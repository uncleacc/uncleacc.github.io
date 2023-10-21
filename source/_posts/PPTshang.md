---
title: PPT上例题(含倍增)
categories: 题目
date: 2020-05-22 09:29:58
tags: 倍增
cover: https://cdn.jsdelivr.net/gh/uncleacc/Img/textbg/49.webp
mathjax: 
updated: 
keywords: 
description: 
comments: 
highlight_shrink: 
---
>PPT上面的好多题都做不了，ACWING上的题要报名才能做，Codeforces 1000C搜不出来，就做了剩下的，不过二维差分前缀和早就掌握了

## ACWING-797. 差分
超级模板
### Code
```c
#include<bits/stdc++.h>
using namespace std;
const int MAXN=1e5+100;
int val[MAXN],cha[MAXN];
int main()
{
	int n,m;
	cin>>n>>m;
	for(int i=1;i<=n;i++) cin>>val[i];
	while(m--){
		int l,r,c;
		cin>>l>>r>>c;
		cha[l]+=c; cha[r+1]-=c; 
	}
	for(int i=1;i<=n;i++){
		cha[i]+=cha[i-1];
		if(i!=n) cout<<val[i]+cha[i]<<" ";
		else cout<<val[i]+cha[i]<<endl;
	}
	return 0;
 } 
```
## 洛谷-海底高铁
算出每两个城市的往返次数，然后贪心一下，找到最小的，这道题之前做过，当时第一次就AC了，这道题应该不难
### Code
```c
#include<bits/stdc++.h>
#define ios ios::sync_with_stdio(0);cin.tie(0);cout.tie(0)
using namespace std;
typedef long long ll; 
const int MAXN=1e5+100;
long long A[MAXN],B[MAXN],C[MAXN],X[MAXN],cha[MAXN];
int main(){
	ios;
    int n,m; cin>>n>>m;
    for(int i=1;i<=m;i++) cin>>X[i];
    for(int i=1;i<=n-1;i++){
    	cin>>A[i]>>B[i]>>C[i];
    	A[i]+=A[i-1];
    	B[i]+=B[i-1];
	}
	for(int i=1;i<=m-1;i++){
		int l=min(X[i],X[i+1]);
		int r=max(X[i],X[i+1]);
		cha[l]++; cha[r]--;
	}
	ll sum=0;
	for(int i=1;i<=n-1;i++){
		cha[i]+=cha[i-1];
		ll t1=cha[i]*(A[i]-A[i-1]);
		ll t2=cha[i]*(B[i]-B[i-1])+C[i];
		sum+=min(t1,t2);
	}
	cout<<sum<<endl;
    
    return 0;
}
```
## 倍增&&ST表
首先明白倍增是一种思想而不是模板，它与ST并没有必然的联系，不是主要有倍增就必然出现ST，做倍增题一定要明白是对什么倍增的，通常就是对区间长度或者距离倍增，使用倍增通常有(RMQ)即区间最值查询(第二道题)，以及LAC这个还没学，ST表的核心是找到ST的递推关系，从小往大推，直到打完所有表，时间复杂度是O(mlogn)，m为结点数量，n是走的步数(2^0,2^1...)， `2^20` 就已经超过 `1e6` 了，`2^64` 大于 `1e20`，所以logn是非常小的，最多几十次，复杂度记乎可以看成O(N*10)
### AtCoder - abc167_d
一道图上倍增的题目，别看这个1e18很大，它的log级别比64还小，用倍增做时间复杂度变成了O(NlongM)，就是2e6的样子   
这里st表很直接，储存的就是跳了N此后到达位置，特别特别需要注意的是查询千万不能用( 1 << i )，这是特别大的数字，我不明白为啥m是ll，就算把( 1 << i )转化为ll类型再进行与操作还是不行，ll不是64位的吗？范围应该是够的，奇怪，不过以后最好让m右移这样不会爆int，当然也可以用while遍历每一位
#### Code

```c
#include<stdio.h>
#include<iostream>
#include<stdlib.h>
#include<cmath>
using namespace std;
typedef long long ll;
const int maxn=2e5+100;
int st[maxn][70],a[maxn];
int n,pos=1;
ll m;
void bz(){
	int len=log2(m);
	for(int i=1;i<=n;i++) st[i][0]=a[i];
	for(int i=1;i<=len;++i){
		for(int j=1;j<=n;++j){
			st[j][i]=st[st[j][i-1]][i-1];
		}
	}
}
int main()
{
	cin>>n>>m;
	for(int i=1;i<=n;++i) cin>>a[i];
	bz();
	for(int i=0;i<64;i++){
		if(1&(m>>i)){
			pos=st[pos][i];
		}
	}
	cout<<pos<<endl;
}

```
### ACWING-1270. 数列区间最大值
一道模板RMQ题目，这道题ST储存的是每一段区间的最值，倍增的是区间长度，就这道题而言，一段区间的最大值可以由这段区间从中间分开的两端区间的最值的合并，而且每一个数都是可以用2进制表示的，那么就一定用st表中的数相加得到

st[i][j]表示从i这一点开始数2^j^个数的最值，即往后数2^(j-1)^个数的最值
#### Code
```c
#include<bits/stdc++.h>
#define ios ios::sync_with_stdio(0);cin.tie(0);cout.tie(0) 
using namespace std;
const int MAXN=1e5+100;
int n,m;
int st[MAXN][22],a[MAXN];
void init()
{
    for(int i=1;i<=n;i++) st[i][0]=a[i];
    for(int j=1;(1<<j)<=n;j++){//区间长度不能超过n
        for(int i=1;i+(1<<j)-1<=n;i++){
            st[i][j]=max(st[i][j-1],st[i+(1<<j-1)][j-1]); //我这里卡了好久，倍增的是区间长度，而st储存的是最值，所以max第二个st第一个括号应该是倍增后的位置
        }
    }
    return;
}
int main()
{
	ios;
    cin>>n>>m;
    for(int i=1;i<=n;i++) cin>>a[i];
    init();
    while(m--)
    {
		int r,l;
        cin>>l>>r;
        int k=log2(r-l+1); //注意，最后查询将两个区间最值合并
        cout<<max(st[l][k],st[r-(1<<k)+1][k])<<endl;
    }
}

```
### 牛客竞赛- 15429 倍增
这道题卡了一天，还是由于我对倍增理解不深，这道题是对往后分2^j^段倍增的，ST表储存的是分成2^j^段对多能到达的距离，讲解全在代码里了
#### Code
```c
#include<bits/stdc++.h>
#define ios ios::sync_with_stdio(0);cin.tie(0);cout.tie(0)
using namespace std;
const int MAXN=1e6+100;
long long n,m,k;
long long st[MAXN][21],book[MAXN],sum[MAXN];
//这里st存的是往右最多走到的距离 
//这里 st表的关系是：一个点往右分成2^j段最多到达的点==先分成2^(j-1)到达的点再往后走2^(j-1) 
void init(){
    for(int i=1;i<=n;i++){
		st[i][0]=upper_bound(sum+1,sum+1+n,sum[i-1]+k)-sum;//很巧妙的sum[i-1]+k，分成一段最多可以到那个数 
	}
    for(int i=1;(1<<i)<=n;i++)//当每一个数都小于k并且每两个相邻的数都大于k时就分成了n份，这也是最多分成n份 
        for(int j=1;j<=n;j++){//记录从每一个点开始分成(2^i)段对多到达哪一个点 
        	st[j][i]=st[st[j][i-1]][i-1];//st的关系 
		}
}
int query(int l,int r){
	int ans=1;
	 //这里必须从大到小，因为要分最小段的数量，
	//所以要尽可能让点往右走，从大到小去试，同理当分成最多段时就要从小到大 
	for(int i=20;st[l][0]<=r;i--){//从当前点分成一段当可以到达的点不能超过r 
		if(st[l][i]<=r&&st[l][i]){//往右最多不能超过r 
			l=st[l][i];//更新当前位置 
			ans+=(1<<i);//加上当前分成的段的数量 
		}
	}
	return ans;
}
int main()
{
	ios;
	cin>>n>>m>>k;
	for(int i=1;i<=n;i++){
		int t; cin>>t;
		sum[i]=t+sum[i-1];//前缀和优化将区间和查询优化为O(1) 
		book[i]=book[i-1]+(t>k);//很巧妙的前缀和，记录前i个数中大于k的数有几个 
	}
	init();
	while(m--){
		int l,r;
		cin>>l>>r;
		if(book[r]-book[l-1]>0) cout<<"Chtholly"<<'\n';//若[l,r]有数大于k则不可能，直接输出 
		else cout<<query(l,r)<<"\n"; 
	}
	return 0;
}
```
<font color="red" size=4>
做了这三道倍增题感觉对倍增有了新的认识，但是我还是处理不好ST和倍增的关系，经常处理不好ST之间的关系，真的感觉自己好菜😢
</font>
