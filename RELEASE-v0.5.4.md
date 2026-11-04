# v0.5.4 · 最终完整光影包（非官方 AI 修改）

**此次发布已改为最终完整光影 ZIP，不再提供修补工具。下载后放入 `shaderpacks` 并在游戏中选用，无需执行脚本。**

## 原作者及 AI 修改声明

**这个光影不是我制作的，不是本人原创。原光影 SEUS / SEUS Renewed 的作者为 Sonic Ether（Cody Darr），版权归原作者所有。**

本人仅提出问题、反馈效果，并借助 AI（OpenAI Codex）修改已有 `DH-ZH-v0.5.2` 中的水面兼容问题。已有 DH 适配与汉化作者尚未核实，相关成果不归本人或此次 AI 修改原创。本版本非官方，不声称得到原作者、适配作者或 OpenAI 的认可或授权。

**原包 `LICENSE.txt` 保留不变。原许可要求再分发原版、修改版或部分内容取得 Sonic Ether 的明确书面许可，目前本仓库没有提供该授权记录。署名与 AI 修改声明不替代授权，也不将完整光影改为 MIT 开源。**

## 下载与安装

[下载最终完整光影包](https://github.com/YiJie-ZhongXin/seus-renewed-dh-waterfix/releases/download/v0.5.4/SEUS-Renewed-v1.0.1-DH-ZH-v0.5.4-waterfix.zip)

将 ZIP 原样放入当前游戏实例的 `shaderpacks` 文件夹，在游戏中选择该包，检查“远景水面反射”为 **1.0**。不要解压，无需旧版输入包或修补工具。

```text
文件：SEUS-Renewed-v1.0.1-DH-ZH-v0.5.4-waterfix.zip
大小：7,102,594 字节
SHA256：FF08845A2D9B360CC20E86E745C813421316A3D174D112A2570E0A2938711124
```

## 光影介绍

SEUS 是 Sonic Ether’s Unbelievable Shaders 的缩写，为 Minecraft Java 版光影。Renewed 1.0.1 采用传统光栅化渲染，提供光照、阴影、水面反射折射、天空与天气、TAA、泛光、曝光和色调映射等效果；与 SEUS PTGI 属于不同系列。

已有 DH/中文适配使 Distant Horizons 的低细节远景进入相关渲染流程，并提供中文设置。原光影、既有适配和汉化均不是本次 AI 修改从零制作的功能。

## 本次修正

- 修正水面反射追踪误命中自身造成的远海暗带，跳过天空空深度样本。
- 统一近景与远景水面的光照坐标和编码，改善水雾亮度接缝。
- 远景水面反射默认值设为 1.0，更新相关选项说明。

本次发布 ZIP 与此前本地验证的最终版完全一致；`v0.5.4-waterfix` 是非官方修改标识，不是 SEUS 官方新版本号。

## 验证与限制

已验证 Minecraft 1.21.1、Iris NeoForge 1.8.14-beta.1、DH 3.3.3 的主世界海面，正式包成功加载。下界、末地只同步代码，未验证画面；未专门进行水下测试，未验证其他版本组合或跨硬件性能。远景 LOD 几何精度限制依然存在。

[完整介绍与声明](https://github.com/YiJie-ZhongXin/seus-renewed-dh-waterfix/blob/codex/final-waterfix/SHADER-INTRODUCTION.zh-CN.md) · [原作者主页](https://www.sonicether.com/seus/) · [官方原版与许可](https://sonicether.com/shaders/download/renewed-v1-0-1/)