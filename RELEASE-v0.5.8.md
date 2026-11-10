# v0.5.8 · 机械动力材质与反射调整（测试版）

本版汇总 v0.5.5～v0.5.8 的画面清晰度、Colorwheel 接入、光色、LabPBR 与金属反射修改，保留 v0.5.4 的 DH 水面修正。下载完整 ZIP 放入 shaderpacks 即可使用，旧版可以并存。

**已知问题：掉落物下方的黑色矩形仍可在实际游戏中复现。** 本版虽然加入独立实体标记、投影与接触阴影排除，但尚未覆盖实际触发路径，因此以测试版发布，不标为已修复。临时诊断光影不包含在本次附件中。

## 主要变化

- **清晰度与 TAA**：调整历史重投影、历史颜色限制与越界拒绝，移除不受设置控制的指数锐化；默认关闭运动模糊及细微泛光，最终输出改用可调的零均值灰色抖动。
- **机械动力 / Colorwheel**：增加三维度主体、半透明、效果和阴影程序，新增原生方块实体通道；运动结构保留原始 UV，避免把重复链条纹理当作普通方块图集执行 POM。
- **噪声与光色**：光照缓冲提高至 RGBA16，去除重复亮度噪声；GI 默认采样由 9 增至 25，噪声周期扩大。默认普通方块光色温改为 3500K，色调映射改为 Khronos PBR Neutral，保留旧映射选项。这不能证明噪声只发生在高版本，也不表示旧映射完全无法压缩高亮。
- **LabPBR 材质**：法线 Z 从 RG 重建，修正金属度、alpha 发光及孔隙度通道，处理法线编码极点；粗糙金属反射权重使用光滑度平方限制，并按粗糙度采样场景 mip。没有实现全部 LabPBR 功能。
- **金属倒影**：根据实际位置与 UV 导数建立切线空间；新增“金属反射法线强度”，默认 0.25。调整屏幕反射的短起步、双向交点细化、厚度、自相交与屏幕边界检查，减轻近处误命中和边缘拉伸。
- **掉落物兼容尝试**：为已识别的掉落物与虚拟阴影贴片增加排除，保护半透明实体的材质数据；加入 GI/AO 除零和非有限数值防护。黑矩形仍存在，不能将这些改动记为问题已经解决。

## 验证范围

验证环境：Minecraft **1.21.1**、Iris NeoForge **1.8.14-beta.1**、Create **6.0.10**、Colorwheel **1.3.0**、Distant Horizons **3.3.3**，GPU 为 RTX 3060 Laptop。测试使用 Create-LabPBR-v12 等资源包，不能直接推及其他组合。

- **程序检查**：188 组光影侧程序 GPU 编译/链接通过；真实 Colorwheel AST 转换器处理 66 阶段成功，转换结果组合测试后端后，33 组程序编译/链接通过。部分实例后端与材质回调仍含夹具，不能替代完整游戏验证。
- **合成场景**：直接调用实际函数，检查近处反射命中、出屏幕/自相交拒绝、金属反射法线，以及 9 组旋转、镜像、退化 UV 切线空间；实际火药纹理通过已识别阴影通道的排除测试。
- **游戏加载**：v0.5.8 在实际主世界成功加载，Iris 与 Colorwheel 管线创建完成，加载段未发现编译错误。
- **仍未解决**：实景仍复现掉落物地面黑矩形。独立 ID 生效，临时诊断的原始颜色层没有显示同样的黑矩形，但尚未定位完整触发路径。不能声称本版已修好，或掉落物不再产生任何地面阴影。
- **未验证部分**：原金属截图同位置、同光照的完整对照，下界/末地画面，跨硬件与 FPS 变化，以及所有机械动力附属材质、多层透明效果。屏幕反射和 DH 的几何及可见范围限制依然存在。

## 下载与校验

[下载完整光影 ZIP](https://github.com/YiJie-ZhongXin/seus-renewed-dh-waterfix/releases/download/v0.5.8/SEUS-Renewed-v1.0.1-DH-ZH-v0.5.8-reflectionfix.zip)

```text
文件：SEUS-Renewed-v1.0.1-DH-ZH-v0.5.8-reflectionfix.zip
大小：7,171,457 字节
SHA256：02D7E17C788EC545054331DC48E8B4B6F1EB39D99A9F6347234F3B282E4E4EEA
```

附件与仓库同名 ZIP 一致；发布前仅更新包内说明，光影程序保持此前受检版本。金属反射法线强度默认 0.25，性能不足可将 GI_QUALITY 调回 0.5。保留 [v0.5.4](https://github.com/YiJie-ZhongXin/seus-renewed-dh-waterfix/releases/tag/v0.5.4) 供回退。

[累计更新记录](https://github.com/YiJie-ZhongXin/seus-renewed-dh-waterfix/blob/codex/final-waterfix/CHANGELOG.md) · [安装与设置](https://github.com/YiJie-ZhongXin/seus-renewed-dh-waterfix/blob/codex/final-waterfix/README.md)

## 归属与许可

**这个光影不是本人制作的，也不是本人原创。SEUS / SEUS Renewed 的原作者是 Sonic Ether（Cody Darr），原程序和资源的版权归原作者所有。** 本人提出问题并反馈效果，使用 AI（OpenAI Codex）辅助排查、修改及部分验证。已有 DH 适配与汉化作者尚待核实，相关成果不归本人或 AI 原创。

v0.5.8 的局部兼容实现参考了 iterationT 测试包中的 UV 导数法线、中性值处理和反射检查思路；参考包不随本仓库发布，也不声称相关作者参与或认可本版本。PBR Neutral 函数保留 Khronos 作者标注与 Apache-2.0 许可。版本号为非官方修改标识，不是 SEUS 官方版本。

原始 [LICENSE.txt](https://github.com/YiJie-ZhongXin/seus-renewed-dh-waterfix/blob/codex/final-waterfix/LICENSE.txt) 及包内许可证保留。原许可要求再分发原版、修改版或部分内容取得 Sonic Ether 的明确书面许可，仓库目前未提供该授权记录；署名、非商业或 AI 修改声明不能替代授权。本仓库不将完整光影改为 MIT 开源，也不授予额外再分发权。

[完整介绍](https://github.com/YiJie-ZhongXin/seus-renewed-dh-waterfix/blob/codex/final-waterfix/SHADER-INTRODUCTION.zh-CN.md) · [原作者主页](https://www.sonicether.com/seus/)
