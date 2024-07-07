---
title: Qt 类似vscode和matlab的分屏显示效果
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img2/104.webp'
tags: ACM冷知识
categories: 算法
mathjax: true
abbrlink: 4e9af57f
date: 2023-10-01 16:49:38
updated:
keywords:
description:
comments:
highlight_shrink:
---


## 运行截图




向右分屏 ![img](https://cdn.jsdelivr.net/gh/uncleacc/website_materials_img/d12ee987ffbe45ffb733304de299cdbf.png) 多分屏 ![img](https://cdn.jsdelivr.net/gh/uncleacc/website_materials_img/744aa251f91a4112a2e6c5cf80d82adf.png) 全屏显示 ![img](C:\Users\60116\Desktop\img\68b7863013584ed097e8932f31b01566.png)

## 介绍

实现了一个类似vscode和matlab的标签页显示分屏效果，支持鼠标拖拽分屏、全屏显示，可自适应调整大小，程序把要显示的Widget独立出来，可随时替换为其他的用户自定义Widget，例如3d模型、二维画图等

## 存在的问题

1. 加载图片会非常卡，猜测是paintEvent频繁调用而每次绘制图片复杂度高导致 
2. 分屏不能等分分屏，应该不难实现

## 源码

 [gitee源码](https://gitee.com/uncleacc/qt-tab-page)

