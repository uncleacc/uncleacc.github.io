---
title: 数位DP
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img2/122.webp'
tags: 数位DP
categories: 算法
mathjax: true
date: 2021-08-01 21:34:42
updated: 
keywords: 
description: 
comments: 
highlight_shrink: 
---

> 数位DP
>
> 解决的是求一段区间中满足一定条件的数的数量，形式固定

## 数位DP模板

```c
int num[100],dp[100][...];
int dfs(int pos,int ...,bool limit) {
	if(pos==0) return ;
	if(!limit && dp[pos][...]!=-1) return dp[pos][...];
	int up=limit?num[pos]:9;
	int sum=0;
	for(int i=0; i<=up; i++) {
		if(...) sum+=dfs(pos-1,...,limit && (i==up));
	}
	if(!limit) dp[pos][...]=sum;
	return sum;
}
//ps 如果有前导0就可以加一个 lead,一开始传1，然后后面就传lead&&(i==0)就可以了
int work(int x) {
	int len=0;
	while(x) {
		num[++len]=x%10;
		x=x/10;
	}
	return dfs(len,...,1); //第一位直接上限位
}
```

以一道例题讲解算法

## [不要62](https://acm.hdu.edu.cn/showproblem.php?pid=2089)

求[L,R]内所有没出现4、62的数字数量，比如662、458这些都不满足条件。

首先转化为算1\~R满足条件数字的问题，然后用fun(R)-fun(L-1)就是答案，数位DP就是对数位进行记忆化搜索，保存可以利用的信息，从而进行剪枝优化时间。核心在于dp[]\[]数组去保存信息，第一维表示当前的位数，第二维表示前一位的状态，记录的是这一维没有限制时符合条件的数量，也就是当前这一位是0\~9时的数量，因为这个状态重复的最多且计算量大

这就是这道题目的代码

```c
//当前的数位，前一位是否为6，前一位是否有限制
int dfs(int pos,bool state,bool limit){
    //到最后一位返回1，表示有一个数满足要求
	if(pos==0) return 1;
    //前一位没有限制表示当前可以取得数字是0~9，看一下是否可以记忆化剪枝
    //注意这里dp为0也可以返回，因为dp记录的是这种状态的答案数量，可能为0
	if(!limit && dp[pos][state]!=-1) return dp[pos][state];
    //当前最高计算到多少位
	int up=limit?num[pos]:9;
    //计算这个状态的答案sum
	int sum=0;
	for(int i=0;i<=up;i++){
		if(state && i==2) continue;	//62跳过
		if(i==4) continue;	//4跳过
		sum+=dfs(pos-1,i==6,limit&&num[pos]==i); //深搜累加答案
	}
	if(!limit) dp[pos][state]=sum; //保存状态
	return sum;	//记得返回答案
}
int work(int x){
	cnt=0;
	while(x){
		num[++cnt]=x%10;	//保存数位
		x/=10;
	}
	return dfs(cnt,0,1);
}
```

## [Round Numbers](http://poj.org/problem?id=3252)

统计区间中二进制0的个数不小于1的个数的所有数字。

这里比不要62多了一个参数，表示是否有前导零。

写法1：

三维dp，第三维表示总位数，这个地方我刚开始写错了，没考虑到这个，只记录了0的数量，其实1的数量也要考虑进去，否则1个0，1个1和1个0，2个1就会被记录成一个状态，导致答案错误，这里我这么写主要为了使用ksm剪枝，更快求出答案。

```c
int dfs(int pos,int js,bool limit,bool lead){
	if(pos==0) return js>=(res-js);
	if(!limit && !lead && js>=(res-js)) dp[pos][js][res]=ksm(2,pos);
	if(!limit && !lead && dp[pos][js][res]!=-1) return dp[pos][js][res];
	int up=limit?num[pos]:1;
	int sum=0;
	for(int i=0;i<=up;i++){
		if(i==0 && lead){
			res--;
			sum+=dfs(pos-1,js,limit&&num[pos]==i,1);
			res++;
		}
		else sum+=dfs(pos-1,i==0?js+1:js,limit&&num[pos]==i,0);
	}
	if(!limit && !lead) dp[pos][js][res]=sum;
	return sum;
}
int work(int x){
	cnt=0;
	while(x){
		num[++cnt]=x%2;
		x/=2;
	}
	res=cnt;
	return dfs(cnt,0,1,1);
}
```

写法2：

当前位是0就加，是1就减，直接包含了所有状态，省空间且写法简单，需要学习，初始值为32因为不能减到负数，因为还要作为数组下标存储状态

```c
int dfs(int pos,int js,bool limit,bool lead){
	if(pos==0) return js>=32;
	if(!limit && !lead && dp[pos][js]!=-1) return dp[pos][js];
	int up=limit?num[pos]:1;
	int sum=0;
	for(int i=0;i<=up;i++){
		if(i==0 && lead) sum+=dfs(pos-1,js,limit&&num[pos]==i,1);
		else sum+=dfs(pos-1,i==0?js+1:js-1,limit&&num[pos]==i,0);
	}
	if(!limit && !lead) dp[pos][js]=sum;
	return sum;
}
int work(int x){
	cnt=0;
	while(x){
		num[++cnt]=x%2;
		x/=2;
	}
	res=cnt;
	return dfs(cnt,32,1,1);
}
```

