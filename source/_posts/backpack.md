---
title: 浅谈01背包和完全背包
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img/textbg/62.webp'
date: 2020-07-07 19:21:27
categories: 算法
tags: 背包
mathjax: 
updated: 
keywords: 
description: 
comments: 
highlight_shrink: 
---

> 今天做了查并集和01背包结合的一道题，致使我对背包开始了学习

## 前言

背包问题属于动态规划里面的一大块内容，包括九讲，本文主要讲01背包和完全背包

两个背包差别在于01背包每一个物品只能选一次，完全背包则可以选无限次，只要背包容积足够

## 01背包

**结合题目进行讲解**

01背包问题

有 NN 件物品和一个容量是 VV 的背包。每件物品只能使用一次。

第 ii 件物品的体积是 vi，价值是 wi。

求解将哪些物品装入背包，可使这些物品的总体积不超过背包容量，且总价值最大。
输出最大价值。

### 输入格式

第一行两个整数，N，VN，V，用空格隔开，分别表示物品数量和背包容积。

接下来有 NN 行，每行两个整数 vi,wi，用空格隔开，分别表示第 ii 件物品的体积和价值。

### 输出格式

输出一个整数，表示最大价值。

### 数据范围

$$
0<N,V≤1000
0<vi,wi≤1000
$$

### 输入样例

```
4 5
1 2
2 4
3 4
4 5
```



### 输出样例：

```
8
```

### 分析

这是一道01背包模板题

首先从二维开始，我们用dp[i] [j]表示前i个物品当体积为j时最大收益，那么`dp[0][j]`和`dp[i][0]`就都为0，分别对应二维数组的第一行和第一列，接下来就从这两列一步一步往最后推，当碰到第i个物品，我们有两个选择，选或者不选，假若背包装不下，那么不选，`dp[i][j]=dp[i-1][j]`，假若能装下，应该考虑装它是否能使利益最大化，所以应该在装和不装之间取大的，`dp[i][j]=max(dp[i-1][j],dp[i-1][j-w[i]]+v[i])`，注意这里装不一定比不装收益高，因为可能前几件价值大，第i件价值小，选择了第i件就舍弃了前面价值大的。

详细分析[点击我](https://blog.csdn.net/qq_37767455/article/details/99086678)

### 代码

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
#define ios ios::sync_with_stdio(0); cin.tie(0); cout.tie(0)
#define debug freopen("in.txt","r",stdin); freopen("out.txt","w",stdout)
using namespace std;
typedef long long ll;
const int MAXN = 1e3+100;
const int MOD = 1e9;
int dp[MAXN][MAXN],w[MAXN],c[MAXN]; 
int main()
{
    ios;
    int n,v;
    cin>>n>>v;
    for(int i=1;i<=n;i++) cin>>c[i]>>w[i];
    for(int i=1;i<=n;i++){
    	for(int j=1;j<=v;j++){
    		if(j>=c[i]) dp[i][j]=max(dp[i-1][j],dp[i-1][j-c[i]]+w[i]);
    		else dp[i][j]=dp[i-1][j];
            //两种写法都一样
    	    //dp[i][j]=dp[i-1][j];
    		//if(j>=c[i]) dp[i][j]=max(dp[i][j],dp[i-1][j-c[i]]+w[i]);            
		}
	}
	cout<<dp[n][v]<<endl;
	return 0;
} 

```

### 降维

这个时间复杂的是O(NV)的，已经是最优了，但是空间还可以优化，观察上面的递推公式，当前前i个物品的状态只与前i-1个物品的状态有关，也就是在图上只与正上方和左上方有关，而这两个状态是已知的，因此可以用滚动数组从前往后推，也可以用一维数组从后往前推(`必须从后往前推，否则前一次循环保存下来的值将会被修改，从而造成推后面时用的值发生改变`)

### 代码

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
#define ios ios::sync_with_stdio(0); cin.tie(0); cout.tie(0)
#define debug freopen("in.txt","r",stdin); freopen("out.txt","w",stdout)
using namespace std;
typedef long long ll;
const int MAXN = 1e3+100;
const int MOD = 1e9;
int dp[MAXN],w[MAXN],c[MAXN]; 
int main()
{
    ios;
    int n,v;
    cin>>n>>v;
    for(int i=1;i<=n;i++) cin>>c[i]>>w[i];
    for(int i=1;i<=n;i++){
    	for(int j=v;j>=c[i];j--){
    	   dp[j]=max(dp[j],dp[j-c[i]]+w[i]);
		}
	}
	cout<<dp[v]<<endl;
	return 0;
} 

```

## 完全背包

完全背包其实和01背包是超级相似的

其公式的推导可见[闫式DP分析法](https://www.acwing.com/video/945/)，利用数学公式直接推出完全背包公式：`dp[i][j]=max(dp[i-1][j],dp[i][j-w[i]]+v[i])`，这个公式和01背包只有最后max第二部分的i-1换成了i，当降维后，01背包和完全背包就只有一个差别，倒着推和正着推😂

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
#define ios ios::sync_with_stdio(0); cin.tie(0); cout.tie(0)
#define debug freopen("in.txt","r",stdin); freopen("out.txt","w",stdout)
using namespace std;
typedef long long ll;
const int N = 1e3+100;
const int MOD = 1e9;
int dp[N],w[N],c[N]; 
int main()
{
    ios;
    int n,v;
    cin>>n>>v;
    for(int i=1;i<=n;i++) cin>>c[i]>>w[i];
    for(int i=1;i<=n;i++){
        for(int j=c[i];j<=v;j++){
            dp[j]=max(dp[j],dp[j-c[i]]+w[i]);
        }
    }
	cout<<dp[v]<<endl;

	return 0;
} 

```

