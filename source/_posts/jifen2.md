---
title: 积分赛2
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img/textbg/69.webp'
date: 2020-07-26 18:44:23
categories: 题目
tags: 集训
mathjax: 
updated: 
keywords: 
description: 
comments: 
highlight_shrink: 
---

> 前两天打了第二场积分赛，难度明显比上次高，感觉更考验思维了，收集了一些我认为有价值的题目，因为太懒了，不想自己写思路题解了，搬来了别人的代码和题解，以后争取养成保存代码的习惯🐷

## A 徐半仙的数学难题

> > 描述
>
> 徐半仙经常修炼。但是每次修炼所能提升的功力确是不确定的（可能是功力还不够深厚
>
> 吧）。
>
> 每次修炼结束之后，徐半仙的脑海中就会浮现出两个数字，*n*和*m*，他的师父跟他说他每
>
> 次修炼增加的功力就是由这两个数决定的。每次增加的功力为(*n*!!!)%*m*，即*n*的阶乘的阶乘的
>
> 阶乘对*m*取模之后的值。
>
> 徐半仙想让你帮他写一个程序，通过*n*和*m*得到他每次修炼之后提升了多少功力。如果这
>
> 次修炼后提升的功力为0，输出*baigei*
>
> > 输入数据
>
> 多组输入，第一行一个正整数*t*(1 *≤* *t* *≤* 105)表示数据组数
>
> 每组数据包含两个整数*n, m*(0 *≤* *n* *≤* 109*,* 1 *≤* *m* *≤* 109)
>
> > 输出数据
>
> 对于每组数据，如果答案为0，输出*baigei*，否则输出答案（每次修炼后提升的功力）
>
> > 样例输入
>
> ```
> 2
> 
> 2 6553
> 
> 2 2
> ```
>
> 
>
> > 样例输出
>
> ```
> 2
> 
> baigei
> ```
>
> > 提示
>
> 在样例中,(2!!!) = 2,对6553取模为2，直接输出，对2取模为0，输出*baigei*

### 分析

我们知道模最大是109，并且很容易知道从4开始，这个数的阶乘的阶乘已经是大于109的，

并且因为我们求的是阶乘，阶乘最后取模和每次取模后相乘的结果相同，因为现在计算的数一

定大于模，所以一定会出现一项为0，因此最后的结果也为0。所以如果*n*小于4，我们直接暴力

计算就可以了，反之直接输出*baigei*即可

### CODE

```c
#include <bits/stdc ++.h>
using namespace std;
typedef long long ll;
#define pb push_back
#define mp make_pair
const int maxn = 1e5 +10;
const int mod = 1e9 +7;
const int INF = 0 x3f3f3f3f ;
int main () {
    int t; cin >>t;
    while(t--){
        ll n,m,ans;
        cin >>n>>m;
        if(n <=1){
        	ans =1%m;
        }else if(n==2){
        	ans =2%m;
        }else if(n==3){
        	ans=1;
        for(ll i=1;i <=720;i++){
            ans *=i;
            ans %=m;
        }
        }else{
        	ans =0;
        }
        if(ans ==0){
            cout <<"baigei\n";
        }else{
        	cout <<ans <<endl;
        }
    }
    return 0;
}
```

## B 徐半仙的八字谜盘

>- 题目描述
>
>有一天徐半仙正在街道上给人算八字，他摆弄一个棋盘，和*K*个棋子，棋盘是*N* *×* *N*的矩阵方
>
>格图，共有*N* *×* *N*个格子。
>
>突然一位神秘ACM大佬来了，对徐半仙说：大仙，是不是您什么难题都算得出来啊？
>
>徐半仙：Of course!
>
>ACM大佬：那你算算这*N* *×* *N*的棋盘，每个方格只能放一个棋子，要把K个棋子都放进去，并且
>
>第一行，最后一行，第一列，最后一列，主对角线，副对角线都至少有一颗棋子的方案数是多
>
>少？
>
>顿时，徐半仙冷汗直流，不知如何应对这位不速之客，只好说：ok....ok.....
>
>为了不显尴尬，徐半仙偷偷用他的迷你手机给你发了一通电报，告诉你N和K，请求你尽快把答
>
>案发送给他。
>
>- 输入数据
>
>第一行为数据的组数*T* (*T* ⩽ 1000)
>
>接下来T行，每行为两个整数*N*和*K* (2 ⩽ *N* ⩽ 100*,* 0 ⩽ *K* ⩽ 100)
>
>- 输出数据
>
>输出T行，第i行为第i组询问的答案。由于答案可能过大，请将答案模1e9+7之后再输出。
>
>- 样例输入
>
>```
>1
>
>3 3
>```
>
>
>
>- 样例输出
>
>```
>10
>```

### 分析

这题主要考察了组合数+容斥原理，其中组合数不是难点，直接套模板就行。

这里如果直接求就必须得考虑很多的情况，所以可以反着来，先求个无规则的任意的摆放数，

再从这个总数里面减去不符合规则的。

但是我们发现，如果减去了第一行没有棋子的摆放数A，再减去了最后一行没有棋子的摆放数B，

其实就多减去了第一行和最后一行没有棋子的情况，所以这一部分减多的，还要加回来。这里

就可以看到容斥原理了，然后就可以写一个二进制枚举，一共就6条线上的格子，2的6次方种

情况，对应0～31(1代表该条线上没有棋子，0代表可有可无)，如果是奇数个1就减去对应的摆

放数，如果是偶数个1，就加上对应的摆放数。代码稍微多点，但思路上并不难。

### CODE

```c
#include<bits/stdc++.h>
using namespace std;
typedef long long ll;
const ll MAXN=10010;
const ll MOD=1e9+7;
ll c[MAXN][110];
void __initC(ll N = 10005){
	c[1][1]=1;
	for(ll i=0;i<=N;i++) c[i][0] = 1;
	for(ll i=1;i<=N;i++){
		for(ll j =1;j<=105;j++){
			c[i][j]=(ll)(c[i-1][j]+c[i-1][j-1])% MOD;
		}
	}
}
ll N,K;
int main()
{
	__initC();
	ll t;
	scanf("%lld",&t);
	while(t--){
		scanf("%lld%lld",&N,&K);
		ll ans=0;
		for(ll i=0;i<(1<<6);i++){
			ll cnt=0,n=N,m=N,L=0,R=0;
			for(ll j=0;j<6;j++){
				if(i>>j &1){
					cnt++;
					if(j==0||j==1) n--;
					if(j==2||j==3) m--;
					if(j==4){
						L=N;
						if((i>>0&1)||(i>>2&1)) L--;
						if((i>>1&1)||(i>>3&1)) L--;
					}
					if(j==5){
						R=N;
						if((i>>0&1)||(i>>3&1)) R--;
						if((i>>2&1)||(i>>1&1)) R--;
					}
				}
			}
			ll num=n*m;
			if(L && R && N&1) num-=L+R-1;
			else num-=L+R;
			if(cnt&1) ans=(ans-c[num][K]+MOD)%MOD;
			else ans=(ans+c[num][K])%MOD;
	 	}
	 	printf("%lld\n",ans);
	}
	return 0;
}
```

## D 徐半仙的修仙之路

>- 描述
>
>徐半仙每天闲来无事就在家中打坐，他相信这样能够悟道，得道升仙的方法；
>
>有一天他接到了一个电话，电话中告诉他，蜀山的掌门给了他一次让他去蜀山学习的机会，约
>
>他去城郊见面。于是他特别开心的答应了下来，但是他到了以后发现对方竟然是传销团伙，徐
>
>半仙这时十分的后悔，他想偷偷的逃走但是这里守卫森严他一点办法都没有，这时他十分无助
>
>的哭泣着并且十分后悔自己迷恋修仙。忽然旁边的憨憨龙告诉他，只要你能够计算出这个房子
>
>有几间房间，并且最大的一间房间有多大就可以帮助他逃走了。
>
>这个房子是只有一层，被分成了*n*行*m*列，每一间房间的面积都是1，但是因为传销团伙
>
>为了节约空间，这些房间的四面墙有些被堵着了。并且如果两个房间连在一起就是一个面积
>
>为2的房间。
>
>这时徐半仙突然看到了机会，于是经过徐半仙的一波神奇的操作后他和憨憨龙一起逃出了
>
>这个传销团伙，并且还配合警方抓捕了这个传销团伙。从这以后徐半仙再也不想着修仙了，他
>
>一心专注于程序设计，并成为了一名优秀的acmer。
>
>聪明的你一定想知道徐半仙如何计算的吗？那么你也来尝试一下吧，看看你和徐半仙谁更
>
>厉害一点！
>
>- 输入数据
>
>每个测试有*T*组数据每组第一行输入两个数 *n, m* (1 ⩽ *n, m* ⩽ 50。接下来*n*行数据，每
>
>行*m*个整数这个整数*p*表示表示这个房间所拥有的墙的编号和 (1表示左墙，2表示上墙，4表示
>
>右墙，8表示下墙)
>
>- 输出数据
>
>输出两个整数分别代表房间的数量，和最大的房间面积。
>
>- 样例输入
>
>```
>1
>
>4 7
>
>11 6 11 6 3 10 6
>
>7 9 6 13 5 15 5
>
>1 10 12 7 13 7 5
>
>13 11 10 8 10 12 13
>```
>
>- 样例输出
>
>```
>5 9
>```

### 分析

这题主要考察你的dfs和你的建模能力。其实如果就是我们的一个模板题Oil Deposits

只是在这道题上加了一个走下一步的限制条件。

如果 *p*&8 == 0 我们可以向下走

如果 *p*&4 == 0 我们可以向右走

如果 *p*&2 == 0 我们可以向上走

如果 *p*&1 == 0 我们可以向左走

这样的话就和上面的模板题一样了

### CODE

```c
#include<bits/stdc++.h>
using namespace std;
int maze[60][60],M,N;
int book[60][60];
int roomnum =0, maxroom =0, room;// 记录 房 间数 、 最大房间 、 目 前 房 间 大 小 
void dfs(int x,int y){ 
	if(book[x][y]) return;
	room++;
	book[x][y]=1;
	if(( maze[x][y] & 1)==0) dfs(x,y-1);
	if(( maze[x][y] & 2)==0) dfs(x-1,y);
	if(( maze[x][y] & 4)==0) dfs(x,y+1);
	if(( maze[x][y] & 8)==0) dfs(x+1,y);
}
int main ()
{
	int t;cin>>t;
	while(t--){
		cin>>M>>N;
		memset(book ,0,sizeof(book ));
		for(int i=0;i<M;i++){
			for(int j=0;j<N;j++){
				cin>>maze[i][j];
			}
		}
		for(int i=0;i<M;i++){
			for(int j=0;j<N;j++){
				if(!book[i][j]){
					room=0;
					roomnum++;
					dfs(i,j);
					maxroom=max(maxroom,room );
				}
			}
		}
		cout<<roomnum<<" "<<maxroom<<"\n";
	}
	return 0;
}
```

## G 徐半仙的数学问题

>- 描述
>
>已知有a,b,c,d四个正整数求满足下列两个等式的x的个数。
>
>*gcd* (*x, a*) = *b*
>
>*lcm* (*x, c*) = *d*
>
>- 输入数据
>
>第一行输入一个整数T，表示测试的组数
>
>第2行到T+1行，每行4个整数,分别表示a,b,c,d.数据保证a能够被b整除，d能够被c整除
>
>1 *<*= *T <*= 2000
>
>1 *<*= *a, b, c, d <*= 2*e*9
>
>- 输出数据
>
>共T行，每行一个整数，如果不存在这样的x,输出0,否则,输出满足条件的x的个数
>
>- 样例输入
>
>```
>4
>
>41 1 96 288
>
>95 1 37 1776
>
>8481 1 999976991 1999953982
>
>32560 2 999992632 1999985264
>```
>
>- 样例输出
>
>```
>6
>
>2
>
>4
>
>0
>```

### 分析

考察了唯一分解定理求lcm和gcd，打一个素数表，枚举素数，打出质因子表。详细看[bilibili](https://www.bilibili.com/video/BV1Uc411h7Yq)

### CODE

```
#include <iostream>
#include <algorithm>
#include <string>
#include <cstring>
#include <map>
#include <set>
#include <deque>
#include <queue>
#include <vector>
#include <cstring>
#include <cstdio>
#include <cstdlib>
#include <cmath>
#define ios ios_base::sync_with_stdio(0),cin.tie(0),cout.tie(0)
#define debug  freopen("in.txt","r",stdin),freopen("out.txt","w",stdout);
#define PI acos(-1)
#define fs first
#define sc second
using namespace std;
typedef long long ll;
typedef pair<int,int> pii;
const ll maxn = 1e6+10;
double eps = 1e-8;
 
int T;
int a0,a1,b0,b1;
bool vis[maxn];
int P[maxn],tail;
struct node{
    int a,b,c,d;
};
map<int,node> mp;
void initP(int N){
    for(int i = 2;i<=N;i++){
        if(!vis[i]) P[tail++] = i;
        for(int j = 0;P[j]<=N/i;j++){
            vis[P[j]*i] = true;
            if(i%P[j] == 0) break;
        }
    }
}
void divP(){
    int idx = 0;
    for(int t:{a0,a1,b0,b1}){
        ++idx;
        for(int j = 0;j<tail && P[j]*P[j] <=t;j++){
            if(t%P[j] == 0){
                int cnt = 0;
                while(t%P[j] == 0){
                    cnt++;
                    t/=P[j];
                }
                if(idx == 1) mp[P[j]].a = cnt;
                if(idx == 2) mp[P[j]].b = cnt;
                if(idx == 3) mp[P[j]].c = cnt;
                if(idx == 4) mp[P[j]].d = cnt;
            }
        }
        if(t>1){
            if(idx == 1) mp[t].a = 1;
            if(idx == 2) mp[t].b = 1;
            if(idx == 3) mp[t].c = 1;
            if(idx == 4) mp[t].d = 1;
        }
    }
}
ll fun(){
    ll res = 1;
    for(auto p:mp){
        node cur = p.second;
        int a = cur.a,b = cur.b,c = cur.c,d = cur.d;
        int cnt = 0;
        for(int i = 0;i<=31;i++){
            if(min(i,a) == b && max(i,c) == d) cnt++;
        }
        res *= cnt;
    }
    return res;
}
int main(){
    ios;
    initP(1<<16);
    cin>>T;
    while(T--){
        cin>>a0>>a1>>b0>>b1;
        mp.clear();
        divP();
        cout<<fun()<<endl;
    }
    return 0;
}
```

