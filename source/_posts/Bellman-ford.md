---
title: Bellman-ford
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img2/123.webp'
tags: 图论
categories: 算法
mathjax: true
abbrlink: 9012ae67
date: 2021-08-06 16:35:24
updated:
keywords:
description:
comments:
highlight_shrink:
---

#  Bellman-ford

>用途：
>
>1. 判负环
>2. 计算含有负权边的最短路径
>
>重边不会影响答案，因为Bellman-ford会遍历所有的边

## 算法流程

先存边，Bellman-ford的存边十分随意，什么储存方式都可以，只有一个要求，就是每次都要遍历到所有的边！

既然如此就用一个结构体去存，一个for循环就可以遍历到所有的边了。

```c
struct node{
	int u,v,w
}e[MAXN];
```

算法十分简单，每次只要让所有的边进行一次更新即可，如果不存在负环，那么一个点最多被n-1个点更新(除了自己)，所以外层循环遍历n-1次，内层循环遍历每一条边

```c
for(int i=1;i<n;i++){
	for(int j=1;j<=m;j++){
        int u=e[j].u,v=e[j].v,w=e[j].w;
		dis[v]=min(dis[v],dis[u]+w);
	}
}
```

如果存在负环，那么经过上面的松弛操作后，一定还有点还可以被松弛，负环可以把环上点能到的所有点的权值都松弛到无限小，遍历所有点，检查是否还有点可以被松弛，如果有，则存在负环，否则不存在。

```c
for(i=1;i<=n;i++){
    if(dis[e[i].v]>dis[e[i].u]+e[i].w){
        return 0;
    }
}
```

### 输出路径

用pre数组保存该节点由谁更新的，初始化时把所有的pre初始化为起点，最后从终点开始往回走，直到走到起点，输出路径。





