---
title: targan缩点
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img2/101.webp'
tags: targan
categories: 算法
mathjax: true
abbrlink: 3905b42d
date: 2021-09-09 21:19:02
updated:
keywords:
description:
comments:
highlight_shrink:
---

 >

> 用途：用来缩点（实际是用来缩强连通分量）
>
> 强连通分量：在有向图G中，如果两个顶点u，ｖ间有一条从ｕ到ｖ的有向路径，同时还有一条从ｖ到ｕ的有向路径，则称两个顶点强连通。如果有向图G的每两个顶点都强连通，称G是一个强连通图。有向非强连通图的极大强连通子图，称为强连通分量。

## 算法流程

首先需要引入几个数组：

dfn\[i]: 表示刚遍历到i号节点的时间戳

low\[i]: 设以i为根的子树为Subtree(i)，low\[i]定义为以下节点的dfn最小值：subtree(i)中的节点、从Subtree中连出一条不指向子树的边

idx[i]: 缩完强连通分量后i号节点后所在的缩点编号

siz[i]: 缩点的子树大小

![image-20210909213353438](https://cdn.jsdelivr.net/gh/uncleacc/sucai_2/image-20210909213353438.png)

![image-20210909213427976](https://cdn.jsdelivr.net/gh/uncleacc/sucai_2/image-20210909213427976.png)

那么代码就可以写了

```c
void targan(int x){
	dfn[x]=low[x]=++tim;
	stk.push(x);
	instk[x]=1;
	for(int i=h[x];~i;i=e[i].next){
		int v=e[i].to;
		if(!dfn[v]){
			targan(v);
			low[x]=min(low[v],low[x]);
		}
		else if(instk[v]) low[x]=min(low[x],dfn[v]);
	}
	if(low[x]==dfn[x]){
		cnt++;
		while(stk.top()!=x){
			siz[cnt]++;
			idx[stk.top()]=cnt;
			instk[stk.top()]=0;
			stk.pop();
		}
		siz[cnt]++;
		idx[stk.top()]=cnt;
		instk[stk.top()]=0;
		stk.pop();
	}
}
```

## [受欢迎的牛](https://www.acwing.com/problem/content/1176/)

本质就是求一个图上有多少个点可以被其他所有点到达

那么就可以先缩点，缩点后变成了一个有向无环图DAG，之后遍历所有边，如果这条边两端的点不属于一个强连通分量，那么这个边就是外部的边，则缩点出度加一，最后看一下如果出度为0的缩点数量>=2，则不存在这样的牛，答案为0；如果只有一个出度为0的缩点，则这个缩点里面的点数就是答案。

```c
#include<bits/stdc++.h>
#define endl '\n'
#define ios ios::sync_with_stdio(0);cin.tie(0);cout.tie(0) 
using namespace std;
const int N=1e4+100,M=5e4+100;
struct edge{
	int to,next;
}e[M];
int h[N],idx[N],dfn[N],out[N],low[N];
int siz[N];
bool instk[N];
int tot,n,m,cnt;
void add(int u,int v){
	e[tot]={v,h[u]};
	h[u]=tot++;
}
int tim;
stack<int> stk;
void targan(int x){
	dfn[x]=low[x]=++tim;
	stk.push(x);
	instk[x]=1;
	for(int i=h[x];~i;i=e[i].next){
		int v=e[i].to;
		if(!dfn[v]){
			targan(v);
			low[x]=min(low[v],low[x]);
		}
		else if(instk[v]) low[x]=min(low[x],dfn[v]);
	}
	if(low[x]==dfn[x]){
		cnt++;
		while(stk.top()!=x){
			siz[cnt]++;
			idx[stk.top()]=cnt;
			instk[stk.top()]=0;
			stk.pop();
		}
		siz[cnt]++;
		idx[stk.top()]=cnt;
		instk[stk.top()]=0;
		stk.pop();
	}
}
int main()
{
	ios;
	memset(h,-1,sizeof h);
	cin>>n>>m;
	while(m--){
		int u,v;
		cin>>u>>v;
		add(u,v);
	}
	for(int i=1;i<=n;i++){
		if(!dfn[i]) targan(i);
	}
	for(int i=1;i<=n;i++){
		for(int j=h[i];~j;j=e[j].next){
			if(idx[i]!=idx[e[j].to]) out[idx[i]]++;
		}
	}
	int ans=0,js=0;
	for(int i=1;i<=cnt;i++){
		if(out[i]==0){
			++js;
			if(js==2){
				ans=0;
				break;
			}
			ans=siz[i];
		}
	}
	cout<<ans<<endl;
	return 0;
}
/*


*/
```





