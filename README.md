# noly的世界地图 / Noly's World Map

一个基于 **7676World** 的 Civilization VI TSL 世界地图，主要调整了太平洋/大西洋宽度，并保留了 7676 原版的陆地、浅水、资源和 157 个 TSL。

A Civilization VI TSL world map based on **7676World**, with a wider Pacific and a slightly wider Atlantic.

![preview](preview.png)

## 特点 / Features

- 尺寸 **166 × 82**，偶数宽度，横向圆柱环绕。
- **太平洋显著加宽**：约 23 格（7676 原版约 10 格）。
- **大西洋约 7 格**：7676 原版的 1.2 倍。
- 陆地 **6,124 格**，与 7676 原版一致。
- 浅水 **2,711 格**，深水 **4,777 格**。
- 海洋资源 **2,630** 条，TSL **157** 个，水上出生点只有毛利。
- 保留了 7676 原版的陆地形状、海岸/浅水分布和资源分布；没有全局重算海岸。
- 删除了太平洋中部两条人工残留的条状浅水，相关 4 条海产已移到附近自然浅水。
- 堪察加、库页岛、千岛群岛、北海道、南美、爱尔兰等位置按 7676 修正并保持完整。

> 说明：太平洋是整列加宽，因此白令海（堪察加—阿拉斯加之间）也会比 7676 更宽；堪察加/库页岛/千岛/北海道的相对位置不变。

## 数据 / Map data

| 项目 | 数值 |
|---|---:|
| 尺寸 | 166 × 82 |
| 总格数 | 13,612 |
| 陆地 | 6,124 |
| 浅水 | 2,711 |
| 深水 | 4,777 |
| 海洋资源 | 2,630 |
| TSL | 157 |
| 水上出生点 | 1（毛利） |

## 依赖 / Requirements

- **Civilization VI**
- **Gathering Storm**（modinfo 依赖，必须启用）
- 建议安装与 7676 相同的 DLC/文明包，否则部分 TSL 可能无效或不出生。

## 安装 / Installation

1. 安装 Civ6 和 Gathering Storm。
2. 将本仓库中的 `NolyWorldMap` 文件夹复制到：
   ```
   Documents\My Games\Sid Meier's Civilization VI\Mods\
   ```
   最终结构应为：
   ```
   Mods\NolyWorldMap\NolyWorldMap.modinfo
   Mods\NolyWorldMap\Maps.xml
   Mods\NolyWorldMap\Maps\NolyWorld.Civ6Map
   ```
3. 启动游戏，在 Mod 列表中启用 **noly的世界地图**（如果默认未启用）。
4. **新开一局**，地图类型选择 **「noly的世界地图」**。

> 旧存档保存的是旧地图数据，不会自动更新；每次更新地图后都必须新开一局。

## 文件结构 / Repository layout

```
noly-world-map/
├─ README.md
├─ NOTICE.md
├─ preview.png
├─ .gitignore
└─ NolyWorldMap/
   ├─ NolyWorldMap.modinfo
   ├─ Maps.xml
   └─ Maps/
      └─ NolyWorld.Civ6Map
```

## 版本 / Version

- 2026-11-07：166×82，太平洋 +4 格，删除两条残留浅水条。
- 基于 7676World 的 TSL 世界地图修改。

## 致谢 / Credits

- 原版地图：**7676World**，作者 **7676**（Steam Workshop）。
- 本仓库只包含修改后的 `NolyWorldMap`，**不包含原版 7676World 地图文件**。
- 修改与调整：noly。

## 使用说明 / Notice

- 仅供个人游戏使用。
- 转载/再分发请保留对 **7676** 和 **noly** 的署名，并遵守原版 7676World 的使用条款。
- 商业使用或再分发需获得原作者的许可。
