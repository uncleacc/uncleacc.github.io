---
title: A*算法
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img2/124.webp'
tags: A*算法
categories: 算法
mathjax: true
abbrlink: edfb9eba
date: 2021-09-07 16:39:28
updated:
keywords:
description:
comments:
highlight_shrink:
---

> A\*算法在求一个点到目标点的最短距离时，可以加快速度，如果使用dijstla是nlogn的时复，但是A\*更快，当节点足够多，边足够大时，可能不能求起点到所有点的最短距离，空间不够或者时复顶不住，这个时候A\***或许**能做，A*使用了一个启发式函数f()，其含义是节点到终点的估计距离，这个距离可以是曼哈顿距离，可以是实际到终点的最短距离等等，只要满足**估计距离小于等于实际距离**即可，只要满足了这个，那么用f(u)+dis(u)当作优先队列的排序规则，每次取出最小值，这个点的最短距离就确定了，证明我找不到，`画个图可以想一下是有道理的`

## [ACWing.178.第K短路](https://www.acwing.com/problem/content/description/180/)

![image-20210907170044220](https://cdn.jsdelivr.net/gh/uncleacc/sucai_2/image-20210907170044220.png)

我看到这道题，不会A*之前，我只能想到Knlogn的时复，跑K次dijstla...太菜了，其实更好的是使用BFS，给每一个状态加上一个距离，使用优先队列，每次取出距离最小的点，其实就是dijstla，只不过少了dis数组，这样子做如果不加优化空间和时间都顶不住，所以开一个cnt\[]数组记录每一个点被更新了几次，如果一个点已经被更新K次了，之后这个点就没必要再入队了，加上这个优化后，时复和空间复杂度最坏就是Knlogn，~~但是这道题还是过不去~~，所以使用A\*优化，加上f()函数，表示从终点到节点的最短距离作为近似值，估计值=节点距离起点的距离+距离终点的距离近似值，以估计值作为排序标准，每次取出最小，当终点被第K次取出时返回答案。

需要说明的时这个题目是可能存在重边的，所以必须等一个点把能到的状态都走完，才能判断返回条件。

```c
for(int i=h[u.to];~i;i=e[i].next){
    int v=e[i].to,w=e[i].w;
    if(v==ed){
        K--;
        if(K==0) return u.d+w;
    }
    pq.push({v,u.d+w});
}
```

这个写法是错误的，假如1->2有很多边权，存边的时候是按照来的顺序存的，所以可能是乱的，除非用vector存边而且边权排序，否则答案不对，还有这道题每条最短路中至少要包含一条边，所以如果终点和起点相同，找的是第K+1条边。

```c
#include<bits/stdc++.h>
#define endl '\n'
#define ios ios::sync_with_stdio(0);cin.tie(0);cout.tie(0) 
using namespace std;
const int N=110000;
struct edge{
	int to,next,w;
}e[N];
struct node{
	int to,d;
	bool operator<(const node &o)const{
		return d>o.d;
	}
};
struct nb{
	int to,d,c;
	bool operator<(const nb &o)const{
		if(c==o.c) return d>o.d;
		else return c>o.c;
	}
};
int h[N],rh[N],f[N],cnt[N];
int tot,n,m,st,ed,K;
void add(int *h,int u,int v,int c){
	e[tot]={v,h[u],c};
	h[u]=tot++;
}
void dij(int st){
	priority_queue<node> pq;
	memset(f,0x3f,sizeof f);
	f[st]=0;
	pq.push({st,0});
	while(!pq.empty()){
		auto u=pq.top().to;
		pq.pop();
		for(int i=rh[u];~i;i=e[i].next){
			int v=e[i].to,w=e[i].w;
			if(f[v]>f[u]+w){
				f[v]=f[u]+w;
				pq.push({v,f[v]});
			}
		}
	}
}
int bfs(int st){
	priority_queue<nb> pq;
	pq.push({st,0,f[st]});
	while(!pq.empty()){
		auto u=pq.top();
		pq.pop();
		if(cnt[u.to]>=K) continue;
		cnt[u.to]++;
		if(cnt[u.to]==K && u.to==ed) return u.d;
		for(int i=h[u.to];~i;i=e[i].next){
			int v=e[i].to,w=e[i].w;
			if(cnt[v]>=K) continue;
			pq.push({v,u.d+w,u.d+w+f[v]});
		}
	}
	return -1;
}
int main() {
	ios;
	memset(h,-1,sizeof h);
	memset(rh,-1,sizeof rh);
	cin>>n>>m;
	while(m--){
		int u,v,w;
		cin>>u>>v>>w;
		add(h,u,v,w);
		add(rh,v,u,w);
	}
	cin>>st>>ed>>K;
	if(st==ed) K++;
	dij(ed);
	cout<<bfs(st);
	return 0;
}
```

