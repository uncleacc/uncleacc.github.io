---
title: 集训前缀和与差分
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img/textbg/65.webp'
date: 2020-07-14 17:35:43
categories: 题目
tags: 集训
mathjax: 
updated: 
keywords: 
description: 
comments: 
highlight_shrink: 
---

## 程序设计：蒜头君的数轴

题目来源 ：[点击我](https://nanti.jisuanke.com/t/A1633)

今天蒜头君拿到了一个数轴，上边有 n 个点，但是蒜头君嫌这根数轴不够优美，想要通过加一些点让它变优美，所谓优美是指考虑相邻两个点的距离，最多只有一对点的距离与其它的不同。

蒜头君想知道，他最少需要加多少个点使这个数轴变优美。

>**输入格式**
>
>输入第一行为一个整数 n(1 <=n ,q<= 10^5)(1≤*n*≤105)，表示数轴上的点数。
>
>第二行为 n个不重复的整数
>
>*x*1,*x*2,..., xn (−109≤xi≤109)，表示这些点的坐标，点坐标乱序排列。

> **输出格式**
>
> 输出一行，为一个整数，表示蒜头君最少需要加多少个点使这个数轴变优美。

> **样例输入**
>
> 4
> 1 3 7 15

>**样例输出**
>
>1

### 分析

题目很简单，意思就是在一个数轴给你n个点，让在数轴上添加最少的点使得任意两点之间距离都相等(允许一组点间距和其他不等)。

这道题目用到了gcd，如果不考虑允许一组间距和其他的不相等的情况的话，那么就应该把所有区间都变成长度为gcd(所有点间距)(下面用gcd代替)，现在允许一组不等，那么可以枚举这n-1个区间，删除一个区间看看此时需要添加的最小点数量是多少，取其中最小值，如何求点数量呢？任意一段区间想把它变成gcd就要添加x/gcd-1，x表示这一段区间长度，这是显而易见的，两个连续点是这样的情况，那n个点呢？就应该是这n个点每一组区间的点数加起来，而gcd是一样的，也就是说分母一样，分子是这一段区间长度，而后面减去了多少个一呢？原本有n-1段区间，现在删去了一个，剩下了n-2个，所以计算了n-2次，就是说最后公式就变成了len/gcd-n+2，len表示减去区间后的长度，OK到这里思路就很清晰了，不过还有一点，删去一个区间后你怎么算剩下的区间的gcd呢？每次删去难道都要枚举一下吗？那也太费时了，这里就用到了前缀的思想(注意没有“和”字哦)，开一个gcd1的数组，gcd1[i]表示前i个区间的gcd，再开一个gcd2数组，gcd2[i]表示i之后所有区间的gcd(包括i)，每次删去一个区间，就可以更新gcd为__gcd(gcd1[i-1]gcd2[i+1])，OK分析完毕，接下来就可以~~开心~~的写代码了

### CODE

```c
#include<bits/stdc++.h>
using namespace std;
const int N=1e5+100;
const int INF= 0x3f3f3f3f;
int val[N],gcd1[N],gcd2[N],dis[N];
int main()
{
	int n,sum=0;
	cin>>n;
	for(int i=1;i<=n;i++) cin>>val[i];
	sort(val+1,val+1+n); //因为输入是乱序，所以要排一下序
	for(int i=1;i<n;i++){
		dis[i]=val[i+1]-val[i];
		sum+=dis[i];
	}
	gcd1[0]=0;//注意初始化
	gcd2[n]=0;
	for(int i=1;i<=n-1;i++) gcd1[i]=__gcd(gcd1[i-1],dis[i]);
	for(int i=n-1;i>=1;i--) gcd2[i]=__gcd(gcd2[i+1],dis[i]);
	int ans=INF;
	for(int i=1;i<=n-1;i++){
		int len=sum-dis[i];
		int temp;
		if(i==1) temp=(len/gcd2[i+1])-n+2;
		else if(i==n-1) temp=(len/gcd1[n-2])-n+2;
		else temp=(len/__gcd(gcd1[i-1],gcd2[i+1]))-n+2;
		ans=min(ans,temp);
	}
	cout<<ans<<'\n';
	return 0;
 } 
```

## Monitor

Xiaoteng has a large area of land for growing crops, and the land can be seen as a rectangle of $n \times m$.

But recently Xiaoteng found that his crops were often stolen by a group of people, so he decided to install some monitors to find all the people and then negotiate with them.

However, Xiao Teng bought bad monitors, each monitor can only monitor the crops inside a rectangle. There are $p$ monitors installed by Xiaoteng, and the rectangle monitored by each monitor is known.

Xiao Teng guess that the thieves would also steal $q$ times of crops. he also guessed the range they were going to steal, which was also a rectangle. Xiao Teng wants to know if his monitors can see all the thieves at a time.

> **Input**
>
> There are mutiple test cases.
>
> Each case starts with a line containing two integers $n,m (1 <= n,1 <= m , n \times m <= 10^7)$ which represent the area of the land.
>
> And the secend line contain a integer $p(1 <=p <= 10^6)$ which represent the number of the monitor Xiaoteng has installed. This is followed by p lines each describing a rectangle. Each of these lines contains four intergers $x_1,y_1,x_2~and~y_2(1<=x_1 <=x_2 <= n,1<= y_1 <= y_2 <= m)$ ,meaning the lower left corner and upper right corner of the rectangle.
>
> Next line contain a integer $q(1 <= q<= 10^6)$ which represent the number of times that thieves will steal the crops. This is followed by q lines each describing a rectangle. Each of these lines contains four intergers $x_1,y_1,x_2~and~y_2(1<= x_1 <= x_2 <= n,1<= y_1 <= y_2 <= m)$,meaning the lower left corner and upper right corner of the rectangle.

> **Output**
>
> For each case you should print $q$ lines.
>
> Each line containing **YES** or **NO** mean the all thieves whether can be seen.

> **Sample Input**
>
> ```
> 6 6
> 3
> 2 2 4 4
> 3 3 5 6
> 5 1 6 2
> 2
> 3 2 5 4
> 1 5 6 5
> ```

>
>
>**Sample Output**
>
>```
>YES
>NO
>```

### 分析

题意比较好理解，给你几个矩形区域，这些区域是可以被监控到的，之后再给一些矩形区域，问你这些区域是不是包含在监控区域内部，

很明显我们可以用差分和前缀和把所有监控区域标记为1，然后看偷庄稼的区域面积是不是等于该区域对应值的和，是则包含，否则不包含，这道题难就难在数据量，只说了n*m<=1e7，却没有说n和m的范围，这很为难人啊，你开小一点，万一坐标给你来一个（1，1e7），那不就炸了，你必须开到[ 1e7 ] [1e7]的量才能过，但是会爆内存，这时有一种非常巧妙的方法，把二维映射到一维，具体怎么做呢？比如(2 , 3)，映射规则就是 (x-1)m+y，那这一点就映射到了m+3这一点上，这样可以把这种映射规则写成一个函数，参数就是二维坐标，函数返回映射到一维数组的位置。特别需要注意的一点就是如果你传入参数坐标有0或者大于n或者m了一定要返回0，因为二维前缀和的边界都是0，然后就可以写代码了

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
#define ios ios::sync_with_stdio(0); cin.tie(0); cout.tie(0)
#define debug freopen("in.txt","r",stdin); freopen("out.txt","w",stdout)
const int N=1e7+100;
using namespace std;
int n,m,v[N];
int get(int x,int y){
	if(x==0||y==0||x>n||y>m) return 0;
	return (x-1)*m+y;
}
int main()
{
	while(~scanf("%d%d",&n,&m)){
		memset(v,0,sizeof v);
		int t; scanf("%d",&t);
		while(t--){
			int x1,x2,y1,y2;
			scanf("%d%d%d%d",&x1,&y1,&x2,&y2);
			v[get(x1,y1)]++; 
			v[get(x2+1,y2+1)]++;
			v[get(x1,y2+1)]--;
			v[get(x2+1,y1)]--;
		}
		for(int i=1;i<=n;i++){
			for(int j=1;j<=m;j++){
				v[get(i,j)]+=v[get(i-1,j)]+v[get(i,j-1)]-v[get(i-1,j-1)];
			}
		}
		for(int i=1;i<=n;i++){
			for(int j=1;j<=m;j++){
				if(v[get(i,j)]>0) v[get(i,j)]=1;
				v[get(i,j)]+=v[get(i-1,j)]+v[get(i,j-1)]-v[get(i-1,j-1)];
			}
		}
		int q; scanf("%d",&q);
		while(q--){
			int x1,x2,y1,y2;
			scanf("%d%d%d%d",&x1,&y1,&x2,&y2);
			int ans=v[get(x2,y2)]+v[get(x1-1,y1-1)]-v[get(x2,y1-1)]-v[get(x1-1,y2)];
			if(ans==(x2-x1+1)*(y2-y1+1))printf("YES\n");
			else printf("NO\n");
		}
	}
	return 0;
 } 
```

### 做法二

这道题内存问题还可以用vector来解，因为vector是动态的嘛，定义方式vector<vector< int >> ve(n+10, vector< int >(m+10,0))

```
#include<iostream>
#include<cstdio>
#include<vector>
using namespace std;
int n,m,p,q;
int main(){ 
	while(~scanf("%d%d",&n,&m)){ 
        vector<vector<int> > ve(n+10,vector<int>(m+10,0));
        scanf("%d",&p); 
        int x1,y1,x2,y2;
        while(p--){
            scanf("%d%d%d%d",&x1,&y1,&x2,&y2);
            // cout<<x1<<y1<<x2<<y2<<endl;
            ve[x1][y1]++;
            ve[x2+1][y1]--;
            ve[x1][y2+1]--;
            ve[x2+1][y2+1]++;
        }
        //二维差分求前缀和
		for(int i=1;i<=n;i++)
		for(int j=1;j<=m;j++){
			ve[i][j]+=ve[i-1][j]+ve[i][j-1]-ve[i-1][j-1];
		}
		//把每个格子都置为1
        for(int i=1;i<=n;i++)
            for(int j=1;j<=m;j++){
                ve[i][j]=min(1,ve[i][j]);
            }
        for(int i=1;i<=n;i++)
            for(int j=1;j<=m;j++){
                ve[i][j]+=ve[i-1][j]+ve[i][j-1]-ve[i-1][j-1];
            }
        scanf("%d",&q);
        while(q--){
            scanf("%d%d%d%d",&x1,&y1,&x2,&y2);
            int t=ve[x2][y2]-ve[x2][y1-1]-ve[x1-1][y2]+ve[x1-1][y1-1];
            if(t==(x2-x1+1)*(y2-y1+1)) cout<<"YES"<<endl;
            else cout<<"NO"<<endl;
        }
	}
	return 0;
}
```

