---
title: bitset
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img/textbg/100.webp'
tags: bitset优化
categories: 算法
date: 2021-02-27 14:49:19
mathjax: 
updated: 
keywords: 
description: 
comments: 
highlight_shrink: 
---

#  bitset

## 用途

这个东西相当于一个bool数组，int是32位表示一个数，而这个32位表示32个数，每一位只能存1或者0，这就使得可以开的空间是int的32倍，时间复杂度为（位数）N/W(计算机常数一般为32)，而访问其中某一位时间复杂度为O(1)，这个的用处多用于数组开不下1e9以上的空间，用unordered_map插入时复O(logn)级别，就可以用bitset优化时间为O(1)

### 定义与初始化

使用bitset类型需`#include<bitset>`

bitset类型在定义时就需要指定所占的空间，例如

```c
bitset<233>bit;
```

bitset类型可以用string和整数初始化（整数转化成对应的二进制）

```c
#include<iostream>
#include<bitset>
#include<cstring>
using namespace std;
int main()
{
    bitset<23>bit (string("11101001"));
    cout<<bit<<endl;
    bit=233;
    cout<<bit<<endl;
    return 0;
}
```

输出结果

```c
00000000000000011101001
00000000000000011101001
```

## 基本运算

bitset支持所有**位运算**

使用这个来进行位运算要比数组模拟位运算快32倍

```c
bitset<23>bita(string("11101001"));
bitset<23>bitb(string("11101000"));
cout<<(bita^bitb)<<endl;
//输出00000000000000000000001 
```

```c
bitset<23>bita(string("11101001"));
bitset<23>bitb(string("11101000"));
cout<<(bita|bitb)<<endl;
//输出00000000000000011101001
```

```c
bitset<23>bita(string("11101001"));
bitset<23>bitb(string("11101000"));
cout<<(bita&bitb)<<endl;
//输出00000000000000011101000
```

```c
bitset<23>bit(string("11101001"));
cout<<(bit<<5)<<endl;
//输出00000000001110100100000
```

```c
bitset<23>bit(string("11101001"));
cout<<(bit>>5)<<endl;
//输出00000000000000000000111
```

## 常用函数

对于一个叫做bit的bitset：

* bit.size()       返回大小（位数）
* bit.count()     返回1的个数
* bit.any()       返回是否有1
* bit.none()      返回是否没有1
* bit.set()       全都变成1
* bit.set(p)      将第p + 1位变成1（bitset是从第0位开始的！） 
* bit.set(p, x)   将第p + 1位变成x
* bit.reset()     全都变成0
* bit.reset(p)    将第p + 1位变成0
* bit.flip()      全都取反
* bit.flip(p)     将第p + 1位取反
* bit.to_ulong()  返回它转换为unsigned long的结果，如果超出范围则报错
* bit.to_ullong() 返回它转换为unsigned long long的结果，如果超出范围则报错
* bit.to_string() 返回它转换为string的结果

## 题目

https://ac.nowcoder.com/acm/contest/11160/D

利用bitset可以卡过去

```c
#include <bits/stdc++.h>
#define debug freopen("in.txt","r",stdin); freopen("out.txt","w",stdout)
#define ios ios::sync_with_stdio(0);cin.tie(0);cout.tie(0)
using namespace std;
typedef long long ll;
typedef unsigned long long ull;
const ll MAXN=1e6+100;
const double pi=acos(-1);
const ll MOD=1e9+7;
const ll INF=0x3f3f3f3f;
const ll SUB=-0x3f3f3f3f;
const ll eps=1e-4;
ll n,m;
ll a[MAXN],b[MAXN]; 
unordered_map<ll,ll> mp;
bitset<1<<30> bt;
int main(){
	ios;
	cin>>n>>m;
	for(ll i=1;i<=n;i++) cin>>a[i];
	for(ll i=1;i<=m;i++){
		cin>>b[i];
		bt.set(b[i]);
		mp[b[i]]++;
	}
	ll ans=0;
	for(ll i=1;i<=n;i++){
		for(ll j=0;j<30;j++){
			for(ll k=j+1;k<30;k++){
				ll now=(1<<j)+(1<<k);
				if(bt[a[i]^now]) ans+=mp[a[i]^now];
			}
		}
	} 
	cout<<ans<<'\n';
	return 0;
}
```

