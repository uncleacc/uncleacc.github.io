---
title: STL集训典型题目
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img/textbg/64.webp'
date: 2020-07-13 15:32:05
categories: 题目
tags: STL
mathjax: 
updated: 
keywords: 
description: 
comments: 
highlight_shrink: 
---

> 自己找题，做课件，还得学习新的东西，不得不说确实挺费时间的，光找找题目就花了2个小时左右，还是因为自己的题量少的原因，只能去搜一些题目自己再做做，不过粘贴题目AC的感觉真的美妙🐷

## Running Medians

For this problem, you will write a program that reads in a sequence of 32-bit signed integers. After each *odd-indexed* value is read, output the median (middle value) of the elements received so far.

> **Input**
>
> The first line of input contains a single integer P, (1 ≤ P ≤ 1000), which is the number of data sets that follow. The first line of each data set contains the data set number, followed by a space, followed by an odd decimal integer M, (1 ≤ M ≤ 9999), giving the total number of signed integers to be processed.
> The remaining line(s) in the dataset consists of the values, 10 per line, separated by a single space.
> The last line in the dataset may contain less than 10 values.

> **Output**
>
> For each data set the first line of output contains the data set number, a single space and the number of medians output (which should be one-half the number of input values plus one). The output medians will be on the following lines, 10 per line separated by a single space. The last line may have less than 10 elements, but at least 1 element. There should be no blank lines in the output.

> **Sample Input**
>
> ```c
> 3
> 1 9
> 1 2 3 4 5 6 7 8 9
> 2 9
> 9 8 7 6 5 4 3 2 1
> 3 23
> 23 41 13 22 -3 24 -31 -11 -8 -7
> 3 5 103 211 -311 -45 -67 -73 -81 -99
> -33 24 56
> ```

>Sample Output
>
>```c
>1 5
>1 2 3 4 5
>2 5
>9 8 7 6 5
>3 12
>23 23 22 22 13 3 5 5 3 -3
>-7 -3
>```

### 分析

一道对顶堆的典型例题，对顶堆是优先队列的一种典型使用方式，主要就是开辟两个优先队列，一个大根一个小根，动态维护它们的元素数量以及两个队列的队头大小关系，永远保证大根堆头比小根堆头小，从而使整个序列元素有序，因此每次进来一个新元素只要判断其是该放到哪一个堆就行了

### CODE

```c
#include<bits/stdc++.h>
using namespace std;
int T,n,m,a[50005];

priority_queue<int,vector<int>, greater<int> > q;

priority_queue<int> p;

int main()
{
    cin>>T;
    while(T--){
        while(!q.empty())q.pop();
        while(!p.empty())p.pop();
        scanf("%d%d",&m,&n);
        printf("%d %d\n",m,(n+1)/2);
        for(int i=1;i<=n;i++) scanf("%d",&a[i]);
        q.push(a[1]);
        printf("%d",a[1]);
        int cnt=1;
        for(int i=2;i<=n;i++){
            if(a[i]>q.top()) q.push(a[i]);
            else p.push(a[i]);
            if(i%2!=0){
                while(p.size()>(i/2)){
                    q.push(p.top());
                    p.pop();
                }
                while(q.size()>(i-(i/2))){
                    p.push(q.top());
                    q.pop();
                }
                cnt++;
                if(cnt%10==1) printf("\n%d",q.top());
                else printf(" %d",q.top());
            }    
        }
        puts("");
    }
}
```

## Constructing the Array

[题目链接](https://vjudge.net/contest/382426#problem/I)

### 分析

这道题拿到手应该第一反应就是找规律，找规律是能做出来的，情况也就是那么多种，但是这道题更官方的做法是用优先队列来做，什么你问我怎么做？我们只要每一段连续0的字符串当作一个优先队列，定义一个结构体，装这对序列的最左面元素的下标和这段序列的长度，优先按长度从大到小排列，然后再按下标从小到大排列，每次将指定元素放到到指定位置时，以这个元素作为分割线从中间分开，之后就会出现两个队列，依次入队，每次重复这样的操作，直到放完所有的元素

### CODE

```c
#include<bits/stdc++.h>
using namespace std;
const int N=2e5+100;
struct node{
	int len,l,r;
	bool operator < (const node &a) const{
		if(a.len==len) return l>a.l;
		else return len<a.len;
	}
};
priority_queue<node> pq;
int ans[N];
int main()
{
	int t;
	cin>>t;
	while(t--){
		int n;
		cin>>n;
		memset(ans,0,sizeof ans);
		while(!pq.empty()) pq.pop();
		pq.push((node){n,1,n});
		int cnt=0,mid;
		while(1){
			node now=pq.top(); pq.pop();
			if((now.r-now.l+1)&1){
				ans[(now.l+now.r)>>1]=++cnt;
				mid=(now.l+now.r)>>1;
			}
			else{
				ans[(now.l+now.r-1)>>1]=++cnt;
				mid=(now.l+now.r-1)>>1;
			}
			if(cnt==n) break;
			if(mid-1>=now.l) pq.push((node){mid-now.l,now.l,mid-1});
			if(now.r>=mid+1) pq.push((node){now.r-mid,mid+1,now.r});
		}
		for(int i=1;i<=n;i++) cout<<ans[i]<<' ';
		cout<<'\n';
	}
	return 0;
}
```

