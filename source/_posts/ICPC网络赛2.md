---
title: ICPC2021网络赛2
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img2/101.webp'
tags: 线段树+欧拉函数
categories: 题目
mathjax: true
date: 2021-09-30 09:19:15
updated: 
keywords: 
description: 
comments: 
highlight_shrink: 
---

## 

## L Euler Function

![image-20210930092043674](https://cdn.jsdelivr.net/gh/uncleacc/sucai_2/image-20210930092043674.png)

题目大意：

给定n个数字，每一个数字不超过100，m次询问

1. 把一个区间的所有数字乘以w(w<=100)
2. 求一个区间所有数的欧拉函数和(mod 998244353)

首先明白一个性质：

$phi(n)=n/(p1*p2*p3...)*(p1-1)*(p2-1)*(p3-1)...$

而n也可以表示为$p1*p2*p3...$

所以$phi(n)=(p1-1)*(p2-1)*(p3-1)...$

那么$phi(w*n)$的值怎么求？

把w质因子分解，可以发现如果n和w有同一个质因子c，那么$phi(c*n)=phi(n)*c$，如果存在一个质因子w有，n没有，那么$phi(c*n)=phi(n)*(c-1)$，发现w的质因子在要乘的区间中都有，那么这道题就变成了简单的区间乘法，区间询问，但是区间中不一定包含w的所有质因子，所以就要去找到那些不包含w的某个质因子的位置，把这些位置单独拿出来乘以(c-1)，如何找到这些位置呢？

可以考虑开一个vis数组，vis[x\]标记一个区间是否都存在质因子x，那么每次做区间乘法时，就可以把w质因子分解，对于每一个质因子c，都去线段树中找，如果一个区间被vis标记了，那么这个区间都存在这个质因子c，就可以直接进行区间修改，否则如果这个区间没有被标记，就向左右子树都找，直到找到这个位置

这里的vis合并时需要遍历25个质因子，进行与的操作，总时复：(O(mlogn*25))，时间快要超时，所以可以把vis数组改成bitset，除以一个32的常数，稳过

`注意区间乘法lazy数组初始化为1！！！`

```c
#include <bits/stdc++.h>
#define int long long
#define endl '\n'
#define ls u<<1
#define rs u<<1|1
#define ios ios::sync_with_stdio(0);cin.tie(0);cout.tie(0)
using namespace std;
typedef long long ll;
const ll mod=998244353;
const int N=2e5+100;
typedef long long ll;
int n,m;
int arr[N];
struct node{
	int l,r;
	ll val;
	bitset<100> bit;
}tr[N<<2];
ll lazy[N<<2];
int getphi(int x){
	int res=x;
	for(int i=2;i<=sqrt(x);i++){
		if(x%i==0){
			res=res*(i-1)/i;
			while(x%i==0) x/=i;
		}
	}
	if(x>1) res=res*(x-1)/x;
	return res;
}
int pr[100],tot;
bitset<100> st[N];
void init(){
	for(int i=2;i<=100;i++){
		int flag=0;
		for(int j=2;j<=sqrt(i);j++){
			if(i%j==0){
				flag=1;
				break;
			}
		}
		if(!flag) pr[++tot]=i;
	}
	for(int i=1;i<=n;i++){
		for(int j=1;j<=tot;j++){
			if(arr[i]%pr[j]==0){
				st[i][pr[j]]=1;
			}
		}
	}
}
void pushup(int u){
	tr[u].bit=tr[ls].bit&tr[rs].bit;	//维护标记
	tr[u].val=(tr[ls].val+tr[rs].val)%mod;	//维护区间欧拉函数和
}
void pushdown(int u){
	if(lazy[u]!=1){
		lazy[ls]=lazy[u]*lazy[ls]%mod;
		lazy[rs]=lazy[u]*lazy[rs]%mod;
		tr[ls].val=tr[ls].val*lazy[u]%mod;
		tr[rs].val=tr[rs].val*lazy[u]%mod;
		lazy[u]=1;
	}
}
void build(int u,int l,int r){
	lazy[u]=1;
	if(l==r){
		tr[u]={l,r,getphi(arr[l]),st[l]};
	}
	else{
		int mid=l+r>>1;
		tr[u]={l,r};
		build(ls,l,mid);
		build(rs,mid+1,r);
		pushup(u);
	}
}
void update(int u,int l,int r,int c){
	if(tr[u].l>=l && tr[u].r<=r && tr[u].bit[c]){
		lazy[u]=lazy[u]*c%mod;
		tr[u].val=tr[u].val*c%mod;
	}
	else if(tr[u].l==tr[u].r){
		tr[u].val=tr[u].val*(c-1)%mod;
		tr[u].bit[c]=1;
	}
	else{
		pushdown(u);
		int mid=tr[u].l+tr[u].r>>1;
		if(l<=mid) update(ls,l,r,c);
		if(r>mid) update(rs,l,r,c);
		pushup(u);
	}
}
ll query(int u, int l, int r) {
	if(l<=tr[u].l && tr[u].r<=r) return tr[u].val;
	pushdown(u);
	int mid=(tr[u].l+tr[u].r)>>1;
	ll res=0;
	if(l<=mid) res=(res+query(ls, l, r))%mod;
	if(r>mid) res=(res+query(rs, l, r))%mod;
	return res;
}
signed main()
{
	ios;
	cin>>n>>m;
	for(int i=1;i<=n;i++) cin>>arr[i];
	init();
	build(1,1,n);
	while(m--){
		int op,l,r,w;
		cin>>op;
		if(op==0){
			cin>>l>>r>>w;
			for(int i=1;i<=25;i++){
				if(w%pr[i]==0){
					while(w%pr[i]==0){
						w/=pr[i];
						update(1,l,r,pr[i]);
					}
				}
				
			}
		}
		else{
			cin>>l>>r;
			cout<<query(1,l,r)<<endl;
		}
	}
	return 0;
}
/*
5 5
5 1 6 2 13
0 5 5 25
0 5 5 18
1 3 5
0 1 3 24
1 3 4
*/
```

第二种写法是用并查集维护一个区间中是否所有数字都可以被质因子c整除，$fa[i][j]$表示第i个质因子第j个位置的数字往右最多可以延申到哪一个位置，假如可以延伸到k，那么[当前位置,k-1]的区间的答案可以直接乘以$pr[i]$，然后把第k个位置单独乘以$c-1$，如此往复，去进行区间修改即可

```c
#include <bits/stdc++.h>
#define int long long
#define endl '\n'
#define ls u<<1
#define rs u<<1|1
#define ios ios::sync_with_stdio(0);cin.tie(0);cout.tie(0)
using namespace std;
typedef long long ll;
const ll mod=998244353;
const int N=2e5+100;
typedef long long ll;
int n,m;
int arr[N],fa[26][N];
struct node {
	int l,r;
	ll val;
} tr[N<<2];
ll lazy[N<<2];
int getphi(int x) {
	int res=x;
	for(int i=2; i<=sqrt(x); i++) {
		if(x%i==0) {
			res=res*(i-1)/i;
			while(x%i==0) x/=i;
		}
	}
	if(x>1) res=res*(x-1)/x;
	return res;
}
void pushup(int u) {
	tr[u].val=(tr[ls].val+tr[rs].val)%mod;
}
void pushdown(int u) {
	if(lazy[u]!=1) {
		lazy[ls]=lazy[u]*lazy[ls]%mod;
		lazy[rs]=lazy[u]*lazy[rs]%mod;
		tr[ls].val=tr[ls].val*lazy[u]%mod;
		tr[rs].val=tr[rs].val*lazy[u]%mod;
		lazy[u]=1;
	}
}
void build(int u,int l,int r) {
	lazy[u]=1;
	if(l==r) tr[u]= {l,r,getphi(arr[l])};
	else {
		int mid=l+r>>1;
		tr[u]= {l,r};
		build(ls,l,mid);
		build(rs,mid+1,r);
		pushup(u);
	}
}
ll query(int u, int l, int r) {
	if(l<=tr[u].l && tr[u].r<=r) return tr[u].val;
	pushdown(u);
	int mid=(tr[u].l+tr[u].r)>>1;
	ll res=0;
	if(l<=mid) res=(res+query(ls, l, r))%mod;
	if(r>mid) res=(res+query(rs, l, r))%mod;
	return res;
}
int pr[100],tot;
void init() {
	for(int i=2; i<=100; i++) {
		int flag=0;
		for(int j=2; j<=sqrt(i); j++) {
			if(i%j==0) flag=1;
		}
		if(!flag) pr[++tot]=i;
	}
	for(int i=1; i<=tot; i++) {	//初始化n个位置的fa数组
		for(int j=1; j<=n; j++) {
			if(arr[j]%pr[i]==0) fa[i][j]=j+1;
		}
	}
}
void mul(int u,int l,int r,int c) {	//线段树区间乘法
	if(tr[u].l>=l && tr[u].r<=r) {
		lazy[u]=lazy[u]*c%mod;
		tr[u].val=tr[u].val*c%mod;
	} else {
		pushdown(u);
		int mid=tr[u].l+tr[u].r>>1;
		if(l<=mid) mul(ls,l,r,c);
		if(r>mid) mul(rs,l,r,c);
		pushup(u);
	}
}
int find(int c,int x) {
	if(x==fa[c][x]) return x;
	return fa[c][x]=find(c,fa[c][x]);
}
void merge(int l,int r,int c) {	//[l,r]区间乘以pr[c]
	int k;
	for(int i=l; ; i=k+1) {
		k=find(c,i);
		if(k>r) {
			mul(1,i,r,pr[c]);	//最后一个区间特判一下
			break;
		} else {
			if(k>i) mul(1,i,k-1,pr[c]);
			fa[c][i]=k+1;	//并查集合并
			mul(1,k,k,pr[c]-1);	//单独相乘
			fa[c][k]=k+1;	//并查集合并
		}
	}
}
void update(int l,int r,int w) {
	for(int i=1; i<=25; i++) {	//第i个质因子有几个乘几次
		while(w%pr[i]==0) {
			merge(l,r,i);
			w/=pr[i];
		}
	}
}
signed main() {
	ios;
	cin>>n>>m;
	for(int i=1; i<=n; i++) {
		cin>>arr[i];
		for(int j=1; j<=25; j++) fa[j][i]=i;
	}
	for(int j=1; j<=25; j++) fa[j][n+1]=n+1;	//因为fa数组指向的位置是(最后一个包含质因子c的下一个位置)，所以n+1也要进行初始化
	init();
	build(1,1,n);
	while(m--) {
		int op,l,r,w;
		cin>>op;
		if(op==0) {
			cin>>l>>r>>w;
			update(l,r,w);
		} else {
			cin>>l>>r;
			cout<<query(1,l,r)<<endl;
		}
	}
	return 0;
}
/*
5 5
5 1 6 2 13
0 5 5 25
0 5 5 18
1 3 5
0 1 3 24
1 3 4
*/
```

## M Addition

![image-20210930102733632](https://cdn.jsdelivr.net/gh/uncleacc/sucai_2/image-20210930102733632.png)

可以借位的模拟题

```c
#include <bits/stdc++.h>
#define endl '\n'
#define ios ios::sync_with_stdio(0);cin.tie(0);cout.tie(0)
using namespace std;
typedef long long ll;
const int N=100;
int s[N];
int a[N],b[N];
int ans[N];
int main() {
	ios;
	int n;
	cin>>n;
	for(int i=1;i<=n;i++) cin>>s[i];
	for(int i=1;i<=n;i++) cin>>a[i];
	for(int i=1;i<=n;i++) cin>>b[i];
	int flag=0,pre;
	for(int i=1;i<=n;i++){
		if(!flag){
			if(a[i] && b[i]){
				ans[i]=0;
				flag=1;
				pre=s[i];
			}
			else if((a[i] && !b[i]) || (!a[i] && b[i])) ans[i]=1;
			else ans[i]=0;
		}
		else{
			if(s[i]==pre){
				if(!a[i] && !b[i]) flag=0;
				if((a[i] && b[i]) || (!a[i] && !b[i])) ans[i]=1;
				else if((a[i] && !b[i]) || (!a[i] && b[i])) ans[i]=0;
			}
			else{
				if(a[i] || b[i]) flag=0;
				if(a[i] && b[i]) ans[i]=1;
				else if((a[i] && !b[i]) || (!a[i] && b[i])) ans[i]=0;
				else ans[i]=1;
			}
		}
	}
	for(int i=1;i<=n;i++) {
		if(i!=n) cout<<ans[i]<<" ";
		else cout<<ans[i]<<endl;
	}
	return 0;
}
/*
*/
```

