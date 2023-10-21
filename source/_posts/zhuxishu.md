---
title: 主席树
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img2/113.webp'
tags: 主席树
categories: 算法
mathjax: true
date: 2021-04-10 21:04:00
updated: 
keywords: 
description: 
comments: 
highlight_shrink: 
---

#  主席树(可持续化权值线段树)

> 可持续化系列的一种数据结构，可以保存修改的版本，本质上是一种可持续化权值线段树

## 区间第k小

倘若不是区间，而是每次求所有值的第k小，一个权值线段树就搞定了，将所有数离散化一下，将数值作为插入位置建树，之后查询第k小时，如果左子树插入点数量大于k就在右子树上，否则就在左子树上，这样就能第k小的数在排好序的数组中排第几个了，每次修改花费logn时间，查询也花费logn时间

而如果现在变成了区间第k小，单纯的线段树就维护不了了，因为无法保存过去的信息，如果可以保存过去没有修改过的信息就好了，（~~每次修改都建一颗新树，空间炸不炸呀~~），其实容易想到修改一个点后，变动的点只是这个点的所有祖宗节点（包括父亲节点），只有logn个（n个点的树深度最多是logn），所以可以拉出来一条链来保存修改过的信息

<img src="https://cdn.jsdelivr.net/gh/uncleacc/sucai_2/20210410213132.png" alt="image-20210410213123576" style="zoom:50%;" />

如图，红色的链就是修改过的信息

<img src="https://cdn.jsdelivr.net/gh/uncleacc/sucai_2/20210410213507.png" alt="image-20210410213503619" style="zoom:50%;" />

主席树因为要保存版本信息，无法用2*id表示左孩子那种方式建树，要用朴素的lson和rson数组表示左右孩子

## 个人理解

主席树本质就是前缀权值线段树，权值线段树保存的是每一个区间的值的个数，而主席树就是对每一个前缀都建了一棵树，只不过是优化了空间，并没有真的建出一棵树，在一棵树上拉出了几条链，查询区间第k小时，就用r版本的树减去l-1版本的树，得到的就是这个区间的树

## [洛谷P3834](https://www.luogu.com.cn/problem/P3834)

```c
#include <bits/stdc++.h>
//#pragma G++ optimize(2)
//#pragma G++ optimize(3,"Ofast","inline")
#define debug freopen("in.txt","r",stdin); freopen("out.txt","w",stdout)
#define ios ios::sync_with_stdio(0);cin.tie(0);cout.tie(0)
using namespace std;
typedef long long ll;
typedef unsigned long long ull;
const int MAXN=1e6+100;
const int MOD=1e9+7;
const int INF=0x3f3f3f3f;
const int SUB=-0x3f3f3f3f;
const double eps=1e-4;
const double E=exp(1);
const double pi=acos(-1);
struct node{
	int lson,rson,sum;
}hjt[MAXN*5];
struct name{
	int id,val,fak;
}arr[MAXN];
int bak[MAXN];
int root[MAXN*5];
int n,m,k,cnt,mid;
bool cmp1(name a,name b){
	return a.val<b.val;
}
bool cmp2(name a,name b){
	return a.id<b.id;
} 
int build(int l,int r){
	int rt=++cnt;  //分配空间 
	if(l==r) return rt;  //如果这个节点是叶子节点(不是管理员)就返回这个节点的编号 
	int mid=l+r>>1;
	hjt[rt].lson=build(l,mid);  //建立这个节点的左子树 
	hjt[rt].rson=build(mid+1,r);
	return rt;  //返回根节点 
}
int insert(int pre,int l,int r,int pos){
	int rt=++cnt;  //分配空间
	hjt[rt]=hjt[pre];  //在前一个版本的基础上建树
	hjt[rt].sum++;  //当前版本多了一个值 
	if(l==r)  return rt;  //叶子节点直接返回，表示已经建好当前版本了
	mid=(l+r)>>1;
	if(pos<=mid) hjt[rt].lson=insert(hjt[pre].lson,l,mid,pos);
	else hjt[rt].rson=insert(hjt[pre].rson,mid+1,r,pos); 
	return rt;
}
int query(int u,int v,int l,int r,int k){
	if(l==r) return l;
	int cha=hjt[hjt[v].lson].sum-hjt[hjt[u].lson].sum;
	int mid=l+r>>1;
	if(cha>=k) return query(hjt[u].lson,hjt[v].lson,l,mid,k);
	else return query(hjt[u].rson,hjt[v].rson,mid+1,r,k-cha);
}
int main(){
	ios;
	cin>>n>>m;
	for(int i=1;i<=n;i++){
		cin>>arr[i].val;
		bak[i]=arr[i].val;
		arr[i].id=i;
	}
	sort(bak+1,bak+1+n);
	sort(arr+1,arr+1+n,cmp1);
	for(int i=1;i<=n;i++) arr[i].fak=i;
	sort(arr+1,arr+1+n,cmp2);
	root[0]=build(1,n);
	for(int i=1;i<=n;i++) root[i]=insert(root[i-1],1,n,arr[i].fak);
//	for(int i=0;i<=n;i++) cout<<hjt[root[i]].sum<<' ';
//	cout<<'\n';
	while(m--){
		int l,r;
		cin>>l>>r>>k;
		cout<<bak[query(root[l-1],root[r],1,n,k)]<<'\n';
	}
	return 0;
}


```

