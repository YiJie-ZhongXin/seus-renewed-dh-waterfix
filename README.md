# SEUS Renewed · DH 中文适配水面修正版 v0.5.4

**本次发布的是可直接放入 `shaderpacks` 使用的最终完整光影 ZIP，已移除修补工具。**

## 作者与 AI 修改声明

> **这个光影不是我制作的，也不是我的原创作品。SEUS / SEUS Renewed 的原作者是 Sonic Ether（Cody Darr），原光影及资源的版权归原作者所有。**
>
> **我只是在已有的 DH/中文适配包基础上提出问题、反馈效果，并使用 AI（OpenAI Codex）排查、修改和验证水面问题。本次仅为 AI 修改的非官方版本，不代表重新制作了整套光影。**
>
> 既有 `DH-ZH-v0.5.2` 的适配和汉化作者尚未核实，其工作不属于本人或本次 AI 修改的原创成果。原作者、适配作者及 OpenAI 均未被声称参与、认可或授权本发布。

**许可说明：包内原始 `LICENSE.txt` 保持不变。原许可要求再分发原版、修改版或部分内容取得 Sonic Ether 的明确书面许可。目前本仓库没有提供该书面授权记录；署名、非商业用途或“AI 修改”声明都不能替代授权。本仓库不把完整光影改为 MIT 开源，也不向下载者授予额外的再分发权。**

完整介绍与归属说明：[SHADER-INTRODUCTION.zh-CN.md](SHADER-INTRODUCTION.zh-CN.md)。

## 下载与安装

[下载最终完整光影包 v0.5.4](https://github.com/YiJie-ZhongXin/seus-renewed-dh-waterfix/releases/download/v0.5.4/SEUS-Renewed-v1.0.1-DH-ZH-v0.5.4-waterfix.zip)

1. 下载 `SEUS-Renewed-v1.0.1-DH-ZH-v0.5.4-waterfix.zip`，无需解压或运行修补脚本。
2. 把 ZIP 放入当前 Minecraft 实例的 `shaderpacks` 文件夹。
3. 在游戏光影列表中选择该 ZIP，将“远景水面反射”设为 **1.0**。旧配置可能保留此前的值，需要手动检查。

使用本次验证的 Minecraft、Iris 和 DH 环境；本包不包含游戏、加载器、Iris 或 DH 模组。请先保留原光影，方便切换。

```text
文件：SEUS-Renewed-v1.0.1-DH-ZH-v0.5.4-waterfix.zip
大小：7,102,594 字节
SHA256：FF08845A2D9B360CC20E86E745C813421316A3D174D112A2570E0A2938711124
```

仓库中的同名 ZIP 与 Release 附件完全一致，是此前本地验证的最终包。

## 光影介绍

SEUS 是 **Sonic Ether’s Unbelievable Shaders** 的缩写，是 Sonic Ether 为 Minecraft Java 版制作的光影项目。**SEUS Renewed 1.0.1** 属于传统光栅化渲染系列，与 SEUS PTGI 是不同系列；本次修改没有加入 PTGI 路径追踪渲染器。

本包既有功能包括太阳光照与阴影、间接光照和环境遮蔽、水波与反射折射、水体吸收和水雾、天空与昼夜变化、大气和雨雾、TAA、泛光、曝光及色调映射，以及法线和视差相关处理。这些来自原光影及已有适配，并非本次 AI 修改原创。具体表现取决于参数、资源包和渲染环境。

**Distant Horizons（遥远的地平线，DH）** 使用较低细节的远景 LOD 扩展可见范围。已有 `DH-ZH-v0.5.2` 负责将远景接入光影并提供中文选项；本次修改集中解决近景与远景水面的衔接问题。

## v0.5.4 修改内容

- **远海暗色带**：水上视角的屏幕空间反射改为追踪不透明深度层，避免命中水面自身，并跳过天空空深度样本。水下全内反射保留原深度路径。
- **近远水面亮度接缝**：统一远景透明层与近景 SEUS 水面使用的光照坐标和编码。
- **远景反射强度**：默认值由 0.5 调整为 1.0，并更新相关中英文选项提示。

`v1.0.1` 是原光影版本；`DH-ZH-v0.5.2` 是已有适配版本；`v0.5.4-waterfix` 是本次非官方水面修改标识，**不是 SEUS 官方新版本号**。

## 测试与限制

测试环境：**Minecraft 1.21.1、Iris NeoForge 1.8.14-beta.1、Distant Horizons 3.3.3**。

已在主世界海面视角进行反射和光照诊断，测试视角中的远海误命中暗带消失，正式包成功编译加载。全部 16 档光照映射已核对。最终包包含 173 个文件，其中 8 个文件相对输入包修改。

下界和末地同步修改了代码，尚未进行相应维度的画面验证；未专门进行水下画面对比，也未验证其他版本组合或建立跨硬件帧率基准。LOD 几何精度限制依然存在，不保证所有场景的岸线、水底与倒影都和完整近景一致。

## 来源与许可

- 原作者及项目：[Sonic Ether / SEUS](https://www.sonicether.com/seus/)。
- 原版下载和许可：[SEUS Renewed 1.0.1](https://sonicether.com/shaders/download/renewed-v1-0-1/)。
- 既有 DH/中文适配作者：待核实，不将其归为本人或 AI 原创。
- 原始许可原文：[LICENSE.txt](LICENSE.txt)，完整光影包内也保留该文件。

仓库的早期历史曾提供独立修补工具；当前分支和当前 Release 已改为完整最终包及说明，不再提供修补工具附件。旧工具曾采用的 MIT 许可不适用于完整光影。