[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$InputZip,
    [string]$OutputZip
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem
$expectedInputHash = '2F4C1DB628DD86C82135F65499FB76D90D4454AA6BF76A8017DFFF4D2C62A4D4'
$inputPath = (Resolve-Path -LiteralPath $InputZip).ProviderPath
if ((Get-FileHash -LiteralPath $inputPath -Algorithm SHA256).Hash -ne $expectedInputHash) {
    throw 'Unsupported input. This patch requires the exact DH-ZH-v0.5.2 ZIP described in README.md. No files were changed.'
}
if ([string]::IsNullOrWhiteSpace($OutputZip)) {
    $OutputZip = Join-Path ([IO.Path]::GetDirectoryName($inputPath)) 'SEUS-Renewed-v1.0.1-DH-ZH-v0.5.4-waterfix.zip'
}
$outputPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputZip)
if ($inputPath -eq $outputPath -or (Test-Path -LiteralPath $outputPath)) {
    throw 'Output already exists or points to the input. Choose a new output path; overwriting is not supported.'
}
if (-not (Test-Path -LiteralPath ([IO.Path]::GetDirectoryName($outputPath)) -PathType Container)) {
    throw 'The output directory must already exist.'
}

$utf8 = [Text.UTF8Encoding]::new($false)
$translations = [IO.File]::ReadAllText((Join-Path $PSScriptRoot 'option-descriptions.json'), $utf8) | ConvertFrom-Json

function Replace-Expected([string]$Text, [string]$Pattern, [string]$Replacement, [int]$Count = 1) {
    $regex = [regex]::new($Pattern)
    if ($regex.Matches($Text).Count -ne $Count) {
        throw ('Unexpected shader structure: ' + $Pattern)
    }
    return $regex.Replace($Text, [Text.RegularExpressions.MatchEvaluator]{ param($match) $Replacement })
}

function Patch-Reflection([string]$Text, [bool]$Overworld) {
    if ($Overworld) {
        $intro = @'
    // Above-water rays must test the opaque scene. Testing depthtex0 lets
    // shallow DH rays hit the same water plane and hide the sky reflection.
    // Keep depthtex0 for underwater total internal reflections.
    bool opaqueWaterReflection = !edgeClamping &&
        GetMaterialMask(6, texture2D(composite, texcoord.st).b * 255.0) > 0.5;
'@
    } else {
        $intro = @'
    // Trace opaque geometry above water to avoid hitting the water itself.
    // Preserve the transparent depth for underwater internal reflections.
    bool opaqueWaterReflection = !edgeClamping &&
        GetMaterialMask(6, texture2D(composite, texcoord.st).b * 255.0) > 0.5;
'@
    }
    $header = [regex]::new('(?m)^vec4\s+ComputeRaytraceReflection\([^\r\n]+\)\n\{\n')
    if ($header.Matches($Text).Count -ne 1) { throw 'Reflection function not found exactly once.' }
    $Text = $header.Replace($Text, [Text.RegularExpressions.MatchEvaluator]{ param($match) $match.Value + $intro + "`n" })
    $sampling = @'
        float reflectionDepth = opaqueWaterReflection
            ? SeusDepth1(depthtex1, samplePos) : SeusDepth0(gdepthtex, samplePos);
        float sampleDepth = SeusViewPosition(samplePos, reflectionDepth).z;
        bool validReflectionSurface = reflectionDepth < 1.0;
'@
    $Text = Replace-Expected $Text '(?m)^[ \t]*float\s+sampleDepth\s*=\s*convertScreenSpaceToWorldSpace\(samplePos\)\.z;' $sampling
    $condition = [regex]::new('(?m)^([ \t]*(?:else )?if\s*\()(diff >= 0)')
    if ($condition.Matches($Text).Count -ne 2) { throw 'Expected two reflection collision checks.' }
    return $condition.Replace($Text, '${1}validReflectionSurface && ${2}')
}

$changedNames = @(
    'shaders/lib/dh_compat.glsl',
    'shaders/lib/dh_water_fragment.glsl',
    'shaders/composite3.fsh',
    'shaders/world-1/composite3.fsh',
    'shaders/world1/composite3.fsh',
    'shaders/lang/en_US.lang',
    'shaders/lang/zh_CN.lang',
    'shaders/lang/zh_TW.lang'
)
$updates = @{}
$archive = [IO.Compression.ZipFile]::OpenRead($inputPath)
try {
    foreach ($name in $changedNames) {
        $entry = $archive.GetEntry($name)
        if ($null -eq $entry) { throw ('Missing required entry: ' + $name) }
        $reader = [IO.StreamReader]::new($entry.Open(), $utf8)
        try { $text = $reader.ReadToEnd() } finally { $reader.Dispose() }
        $usesCrLf = $text.Contains("`r`n")
        $text = $text.Replace("`r`n", "`n")
        switch -Wildcard ($name) {
            '*/dh_compat.glsl' {
                $text = Replace-Expected $text '(?m)^#define\s+DH_WATER_REFLECTION\s+0\.5[^\r\n]*' '#define DH_WATER_REFLECTION 1.0 // 1.0 matches near-water reflection strength; lower values can cause a color seam. [0.0 0.25 0.5 0.75 1.0]'
            }
            '*/dh_water_fragment.glsl' {
                $lightmap = @'
    // DH vertices normalize light nibbles to [0,1]. Vanilla SEUS water first
    // samples at (nibble + 0.5)/16, then uses this legacy lightmap remapping.
    // In particular full skylight is ~0.9677, not 1; after the sky-light curve
    // that difference otherwise doubles the distant water-fog brightness.
    vec2 waterLightmap = clamp(((dhLightmap * 15.0 + 0.5) / 16.0)
        * (33.05 / 32.0) - vec2(1.05 / 32.0), 0.0, 1.0);
'@
                $marker = [regex]::new('(?m)^(    gl_FragData\[0\])')
                if ($marker.Matches($text).Count -ne 1) { throw 'Water output marker is not unique.' }
                $text = $marker.Replace($text, [Text.RegularExpressions.MatchEvaluator]{ param($match) $lightmap + "`n" + $match.Value })
                $text = Replace-Expected $text 'DhEncodeBlockLight\(dhLightmap\.x\), dhLightmap\.y' 'DhEncodeBlockLight(waterLightmap.x), waterLightmap.y'
            }
            '*/composite3.fsh' { $text = Patch-Reflection $text ($name -eq 'shaders/composite3.fsh') }
            '*/lang/*.lang' {
                $locale = [IO.Path]::GetFileNameWithoutExtension($name)
                $description = $translations.$locale
                if ([string]::IsNullOrWhiteSpace($description)) { throw 'Missing option translation.' }
                $text = Replace-Expected $text '(?m)^option\.DH_WATER_REFLECTION\.comment=[^\r\n]*' ('option.DH_WATER_REFLECTION.comment=' + $description)
            }
            default { throw ('Unexpected patch target: ' + $name) }
        }
        if ($usesCrLf) { $text = $text.Replace("`n", "`r`n") }
        $updates[$name] = $text
    }
} finally { $archive.Dispose() }

# All input checks and text edits finish before an output file is created.
$createdOutput = $false
try {
    Copy-Item -LiteralPath $inputPath -Destination $outputPath
    $createdOutput = $true
    $archive = [IO.Compression.ZipFile]::Open($outputPath, [IO.Compression.ZipArchiveMode]::Update)
    try {
        foreach ($name in $changedNames) {
            $archive.GetEntry($name).Delete()
            $entry = $archive.CreateEntry($name, [IO.Compression.CompressionLevel]::Optimal)
            $writer = [IO.StreamWriter]::new($entry.Open(), $utf8)
            try { $writer.Write($updates[$name]) } finally { $writer.Dispose() }
        }
    } finally { $archive.Dispose() }
    if ((Get-FileHash -LiteralPath $inputPath -Algorithm SHA256).Hash -ne $expectedInputHash) {
        throw 'The input changed during patching.'
    }
    Write-Output ('Created local-use shader ZIP: ' + $outputPath)
    Write-Output 'Original shader: Sonic Ether / Cody Darr. Unofficial AI-assisted repair; not an original shaderpack.'
    Write-Output 'Do not redistribute the generated shader ZIP without the required permissions.'
} catch {
    if ($createdOutput -and (Test-Path -LiteralPath $outputPath)) { Remove-Item -LiteralPath $outputPath }
    throw
}
