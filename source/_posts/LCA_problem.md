---
title: LCA最小公共祖先
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img/textbg/81.webp'
categories: 算法
tags: 算法
abbrlink: 98bfed5f
date: 2020-09-29 21:44:21
mathjax:
updated:
keywords:
description:
comments:
highlight_shrink:
---

## LCA 公共祖先

什么是最小公共祖先，顾名思义就是俩点最近的公共祖先

![](https://cdn.luogu.com.cn/upload/pic/2282.png)

如图所示：

1. 2和5的最小公共祖先就是4
2. 2和1的最小公共祖先就是4
3. 3和5的最小公共祖先是1

那么怎么求呢？

先介绍两种朴素的做法，~~也就是超时的做法🐷~~

第一种： `向上标记法`

想求两个点的最小公共祖先可以先从其中一个点往上找父亲结点，直到根节点，把路径标记一下，然后从另一个点开始做同样的操作，当遇到已经标记过的点的时候就停下来，这个点一定是最小公共祖先（ 每次查询时间复杂度：O(n) ）

### CODE

```c++
#include <bits/stdc++.h>
using namespace std;
const int MAXN=500100;
vector<int> vt[MAXN];
int fa[MAXN];
bool vis[MAXN];
void dfs(int u){
	int len=vt[u].size();
	for(int i=0;i<len;i++){
		int v=vt[u][i];
		if(v==fa[u]) continue;
		fa[v]=u;
		dfs(v);
	}
}
int lca(int l,int r){
	memset(vis,0,sizeof vis);
	while(l){
		vis[l]=1;
		l=fa[l];
	}
	while(!vis[r]) r=fa[r];
	return r;
}
int main()
{
	ios::sync_with_stdio(0);
	int n,m,s;
	cin>>n>>m>>s;
	for(int i=1;i<=n-1;i++){
		int x,y;
		cin>>x>>y;
		vt[x].push_back(y);
		vt[y].push_back(x);
	}
	dfs(s); //找到每一个点的父亲结点是谁
	while(m--){
		int l,r;
		cin>>l>>r;
		cout<<lca(l,r)<<'\n';
	}
	return 0;
 } 
```

第二种： `利用深度法`

在上面的dfs函数稍微改一下，得到每一个点到根节点的深度（从0开始），当询问两个点的lca时，我们先把深度大的那个点网上搜，直到两个点的深度相同，深度相同后，两个点一起往上搜直到两个点合并到一起，那么这个点就是lca

### CODE

```c
#include <bits/stdc++.h>
using namespace std;
const int MAXN=500100;
vector<int> vt[MAXN];
int fa[MAXN],dep[MAXN];
void dfs(int u,int d){
	dep[u]=d; //处理出每一个点的深度
	int len=vt[u].size();
	for(int i=0;i<len;i++){
		int v=vt[u][i];
		if(v==fa[u]) continue;
		fa[v]=u;
		dfs(v,d+1); //子节点深度加一
	}
}
int lca(int l,int r){
	if(dep[l]<dep[r]) swap(l,r); //保证l是深度大的那个点
	while(dep[l]>dep[r]) l=fa[l]; //从深度大的那个开始往上走
	while(l!=r){ //一起往上
		l=fa[l];
		r=fa[r];
	}
	return r;
}
int main()
{
	ios::sync_with_stdio(0);
	int n,m,s;
	cin>>n>>m>>s;
	for(int i=1;i<=n-1;i++){
		int x,y;
		cin>>x>>y;
		vt[x].push_back(y);
		vt[y].push_back(x);
	}
	dfs(s,0);
	while(m--){
		int l,r;
		cin>>l>>r;
		cout<<lca(l,r)<<'\n';
	}
	return 0;
 } 
```

## 倍增找LCA

 详细讲解：

[视频](https://www.bilibili.com/video/BV155411h7CG?p=2)

[LCA博客讲解](https://www.cnblogs.com/darlingroot/p/10597611.html)

## [P3379 【模板】最近公共祖先（LCA）](https://www.luogu.com.cn/problem/P3379)

```c
#include <bits/stdc++.h>
using namespace std;
const int MAXN=500010;
vector<int> ve[MAXN];
int dep[MAXN],f[MAXN][22];
void dfs(int u, int fa, int d){  //找到每一个节点的父亲节点以及深度大小
	f[u][0]=fa;  //每一个节点往上走2^0步就是父亲节点
	dep[u]=d;  //深度
	int sz=ve[u].size();  //遍历后继节点
	for(int i=0;i<sz;i++){
		int v=ve[u][i];  
		if(v==fa) continue;  //记住不能往回走
		dfs(v, u, d+1);
	}
}
void bz(int n){  //预处理出每一个节点往上2^i步后到达的节点
	for(int i=1;i<22;i++){  //2^22 > 4e7，能处理最大深度不超过4e7的树
		for(int u=1;u<=n;u++){
			f[u][i]=f[f[u][i-1]][i-1];  //当前节点向上走2^i步就等于先向上走2^(i-1)再向上走2^(i-1)步
		}
	}
}
int lca(int x,int y){
	if(dep[x]<dep[y]) swap(x,y);  //保证x的深度大于y
	for(int i=log2(dep[x]-dep[y]);i>=0;i--){
		if((1<<i)<=dep[x]-dep[y]) x=f[x][i]; //注意dep[x]-dep[y]时刻在变化，也正是因为这个所以dep[x]一定最后和dep[y] 
	}
	if(x==y) return x;
	for(int i=log2(dep[x]);i>=0;i--){  //此时两个节点的深度相同，就需要一起往上面走
		if(f[x][i]!=f[y][i]){  //一起走2^i后不能相同，因为相同了可能导致超过（最近）公共祖先！
			x=f[x][i];
			y=f[y][i];
		}
	}
    //走完后一定到达了最近公共祖先的子节点，因为这种方法本质上就是二分
	return f[x][0]; //父节点就是lca
}
int main()
{
	ios::sync_with_stdio(0); cin.tie(0); cout.tie(0);
	int n,m,s;
	cin>>n>>m>>s;
	for(int i=0;i<n-1;i++){
		int a,b;
		cin>>a>>b;
		ve[a].push_back(b);
		ve[b].push_back(a);
	}
	dfs(s,0,0);  //这里很巧妙哦，假设还有一个0节点，而0是s的父亲节点，这样每一个节点往上走2^i就算走过了根节点也会是0
	bz(n);  //预处理
	while(m--){
		int x,y;
		cin>>x>>y;
		cout<<lca(x,y)<<'\n';
	}
	return 0;
}
```

