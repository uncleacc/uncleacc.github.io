---
title: 集训第一天
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img/textbg/63.webp'
date: 2020-07-10 17:29:58
categories: 题目
tags: 集训
mathjax: 
updated: 
keywords: 
description: 
comments: 
highlight_shrink: 
---

> 紧张刺激而又枯燥的集训开始了🐷

## problem1

[题目链接](https://vjudge.net/contest/382262#problem/D)

一道思维题，很容易想到从大往小减，这是一个误区，可以这样思考，任意两个数如果差为偶数一定是满足题目要求的，当这两个数高度相同时就可以看成一棵树了，再让这个数去和其他的数比较，当差又是偶数时便又满足题目要求，便可以得出规律，只要给定序列任意两个数相差为偶数便满足题意

### CODE

```c
#include <stdio.h>
#include <iostream>
#include <string>
#include <string.h>
#include <map>
#include <queue>
#include <stack>
#include <algorithm>
#include <vector>
#include <set>
#define PI acos(-1)
#define ios ios::sync_with_stdio(0);
#define debug freopen("in.txt","r",stdin); freopen("out.txt","w",stdout)
using namespace std;
typedef long long ll;
const int MAXN = 1e5+100;
const int MOD = 1e9;
int h[MAXN];
int main()
{
	ios;
    int t;
    cin>>t;
    while(t--){
    	int n;
    	cin>>n;
    	for(int i=1;i<=n;i++) cin>>h[i];
		int flag=0;
		for(int i=2;i<=n;i++){
			if((h[i]-h[i-1])%2){
				flag=1;
				break;
			}
		}
		if(flag) cout<<"no"<<'\n';
		else cout<<"yes"<<'\n';
	}
	return 0;
} 
```

## Problem2

[题目链接](https://vjudge.net/contest/382262#problem/G)

英文不好真的读不懂题。。。这道题意思是机器人从原点出发，经过一系列走法之后到达一点，问能不能删除这一系列走法中的字串，使得终点不变而删除的字串长度最小

不难看出当走到以前经过的一点时，这中间的序列一定是可以删除的，那么我们可以每一点上一次走到这里花费的步数(注意不是最小步数因为我们要求的是删除的字串长度最小)，当再次走到该点时用此时的步数减去上一次走到该点的步数得到的就是可以删除的字串长度，若该长度最小那么更新答案便可以了，这里如何记录一个点是否走过呢？假设用数组来存就需要二维数组，里面大多数点都是没用的，就很浪费空间，这道题开不了这么大的空间，可以用map来存，map<pair<int,int>,int>

### CODE

```c
#include<bits/stdc++.h>
#define ll long long
using namespace std;
map<pair<int,int>,int> mp;
string s;
int main()
{
	int t;
	cin>>t;
	while(t--){
		mp.clear();
		int n,maxn=1e9;
		cin>>n>>s;
		s=' '+s;
		int l,r,x=0,y=0;
		int len=s.size();
		mp[make_pair(x,y)]=-1;
		for(int i=1;i<len;i++){
			if(s[i]=='L') x--;
			if(s[i]=='R') x++;
			if(s[i]=='D') y--;
			if(s[i]=='U') y++;
			int m=mp[make_pair(x,y)];
			if(m!=0){
				if(m==-1) m=0;
				if(i-m<maxn){
					maxn=i-m;
					l=m+1; r=i;
				}
			}
			mp[make_pair(x,y)]=i;
		}
		if(maxn==1e9) cout<<-1<<'\n';
		else cout<<l<<' '<<r<<'\n';
	}
	return 0;
}
```

## problem3

[题目链接](https://vjudge.net/contest/382262#problem/K)

这道题我想错方向了，我在想把两个字符串连接后转化成新数，然后这个问题就转换成了从1到a，从1到b挑出两个数满足题意，这样我最多就能想出二分优化成NlogN，但是数据量1e9，指定过不了，就在这可了很久很久，原来这道题两个数连接不是让用字符串连接的，是让你用a10^(b的位数)+b来连接的，这样一来原来的a+b+ab==a10^(b的位数)+b，两边消去b，然后等式都除以a，就把a消去了，然后就能算出来b的公式，b=10^(b的位数)-1，啊！这道题其实不难，就是方向错了，难受😫

### CODE

```c
#include <stdio.h>
#include <algorithm>
#include <iostream> 
using namespace std;
typedef long long ll;
int check(ll t){
    while(t>0){
        int x=t%10;
        t/=10;
        if(x!=9) return 0;
    }
    return 1;
}
int main(void){
    int t;
    cin>>t;
    while(t--){
        ll a,b;
        cin>>a>>b;
        ll cnt=0;
        ll temp=b;
        while(temp>0){
            temp/=10;
            cnt++;
        }
        if(check(b)) cout<<a*cnt<<'\n';
        else cout<<a*(cnt-1)<<'\n';
    }
    return 0;
}
```

## Problem4

[题目链接](https://vjudge.net/contest/382262#problem/J)

这道题也算是一道思维题吧，要想让数最大，一定是数的位数优先，两位数肯定比一位数大对吧，想通了这再举几个例子就能看出来这是一个递归的过程，递归出口就是2和3

```c
#include <stdio.h>
#include <iostream>
#include <string>
#include <string.h>
#include <map>
#include <queue>
#include <stack>
#include <algorithm>
#include <vector>
#include <set>
#define PI acos(-1)
#define ios ios::sync_with_stdio(0);
#define debug freopen("in.txt","r",stdin); freopen("out.txt","w",stdout)
using namespace std;
typedef long long ll;
const int MAXN = 1e5+100;
const int MOD = 1e9;
int h[MAXN];
int main()
{
	ios;
    int t;
    cin>>t;
    while(t--){
    	int n;
    	cin>>n;
    	for(int i=1;i<=n;i++) cin>>h[i];
		int flag=0;
		for(int i=2;i<=n;i++){
			if((h[i]-h[i-1])%2){
				flag=1;
				break;
			}
		}
		if(flag) cout<<"no"<<'\n';
		else cout<<"yes"<<'\n';
	}
	return 0;
} 
```

