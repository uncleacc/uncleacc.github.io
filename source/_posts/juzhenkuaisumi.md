---
title: 浅谈矩阵快速幂
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img/textbg/67.webp'
categories: 算法
tags: 矩阵快速幂
abbrlink: a28e20bb
date: 2020-07-21 15:24:31
mathjax:
updated:
keywords:
description:
comments:
highlight_shrink:
---

> 集训开始了对矩阵快速幂的讲解，但是讲解的非常不好，基本没讲，这导致我这个之前就不知道矩阵快速幂的蒟蒻不得不自己乖乖的去网上查资料学习，找到了两个比较不错的视频讲解，具体可以看**清单**里面的**转载**，我来记录一下矩阵快速幂的基本用法🐷

## 矩阵乘法

学习过线性代数或者离散数学的应该都知道矩阵之间的乘法怎么做，知道的可以跳过，矩阵相乘有一个前提条件，就是前一个矩阵的列数必须等于后一个矩阵的行数两个矩阵才能做乘法运算，这是因为矩阵是不满足交换律的，他们相乘得到的矩阵的元素等于这个元素所在的行对应第一个矩阵的行元素依次乘以这个得到的矩阵元素列数对应第二个矩阵的列元素，很绕口，举个例子，假如两个矩阵相乘后得到了新的矩阵，这个矩阵的第一个元素是在第一行第一列对吧，那么这个元素就是第一个矩阵的第一行和第二个矩阵的第二列元素依次相乘再累加的结果，这样你就知道为什么第一个矩阵的列数必须和第二个矩阵行数相同了吧。

那在纸上你肯定会算了，怎么把它转化成代码呢？

### CODE

```c
struct mat{
	ll m[20][20]; //定义了一个20*20的矩阵
};
int n;//n为相乘的矩阵的维数，一般长和宽是相同的
mat operator * (mat a,mat b){ //重载了*运算符，使得两个结构体可以做乘法
	mat ans;
	for(int i=1;i<=n;i++){
		for(int j=1;j<=n;j++){
			ll x=0;
			for(int k=1;k<=n;k++){
				x+=a.m[i][k]*b.m[k][j]%MOD;
			}
			ans.m[i][j]=x;
		}
	}
	return ans; //ans储存结果
}
mat mul(mat a,mat b){ //也可以写一个相乘的函数和重载效果一样
    mat ans;
    for(int i=0; i<n; i++){
		for(int j=0; j<n; j++){
			ll x=0;
			for(int k=0; k<n; k++){
            	x=(x+a.m[i][k]*b.m[k][j]%MOD)%MOD;
			}
			ans.m[i][j]=x;
		}
	}
    return ans;
}
```

## 矩阵快速幂

OK，知道了矩阵乘法，我们就可以开始矩阵快速幂的学习了，加入给你了一个矩阵让你算这个矩阵的N次幂，你怎么算呢？一个一个乘吗？那时间复杂度就是O(n)了，有没有办法降一下呢？学了快速幂的你一定会说可以的，快速幂不仅仅限制于实数上的乘法，它是广义的！来看看广义快速幂：

![](https://cdn.jsdelivr.net/gh/uncleacc/Sucai/9.png)

很明显矩阵的乘法也是满足广义快速幂的要求的，而矩阵快速幂的幺元其实就是单位矩阵也就是左对角线为1其他全为0的矩阵，这样的单位矩阵乘以任何矩阵都不会改变这个矩阵结果，其意义就相当于实数运算中的“1”。明白了这个就可以直接上代码了

```c
mat mul(mat a,mat b){ //自定义矩阵相乘函数
    mat ans;
    for(int i=0; i<n; i++){
		for(int j=0; j<n; j++){
			ll x=0;
			for(int k=0; k<n; k++){
            	x=(x+a.m[i][k]*b.m[k][j]%MOD)%MOD;
			}
			ans.m[i][j]=x;
		}
	}
    return ans;
}
mat ksm(mat a,ll b){ //矩阵快速幂
    mat ans;
    memset(ans.m,0,sizeof ans.m); //定义矩阵快速幂的幺元
    for(int i=0; i<n; i++) ans.m[i][i]=1; //左对角线都为1
    while(b){
    	if(n&1) ans=mul(a,ans);
    	a=mul(a,a);
    	b>>=1;
	}
    return ans; //ans即为这个a矩阵的n次幂
}
```

以上操作其实不难理解，仔细想一想很简单的，接下来重点来了！！！

<font color="red" size=4>我学了这个有什么用呢？</font>

难道只是为了解一下矩阵的乘法？当然不是的！！！它可以大大加快递推的速度

## 加快递推

什么叫递推？比如十分经典的斐波那契数列，我现在要求你算出第n项是多少，那你肯定要从前往后一步一步算，不可能跳步的，因为后面的结果必须由前面的元素决定！如果你不知道矩阵快速幂，那时间复杂度是O(N)的，假如我就很难为你，把数据量开到1e9，绝对不能单纯的递推了对吧，这时我们的矩阵快速幂就派上用场了，我们可以定义这样的一个矩阵：

|   f(n)  |

|  f(n-1)|                     为什么要这样定义呢？因为这一个矩阵包含了推出f(n+1)的所有元素，也就是包含了推出下一个矩阵的所有元素！而这个矩阵也等于：

| f(n-1)+f(n-2) |

|       f(n-1)      |                就是把上面的式子的第一项变成了f(n-1)+f(n-2)结果不变的对吧，而这个式子就等于

| 1 1 |             | f(n-1) |

| 1 0 |  乘上    | f(n-2) |  ，由此我们发现了矩阵前后的关系

|   f(n)  |          | 1 1 |          | f(n-1) |

|  f(n-1)|   =    | 1 0 |    *    | f(n-2) |  ，这像不像一个等比数列，an=x * an-1，那么我们就可以直接转换成

|   f(n)  |          | 1 1 |(n-2)   |  f(2)    |

|  f(n-1)| =      | 1  0|   *      |  f(1)    | ，式子的第二个矩阵就是需要套用快速幂的矩阵，其n-2次方乘以式子第三个矩阵就是式子第一个矩阵，OK，到这里我们就成功把递推式子转换成为了快速幂的式子，套一下快速幂的模板就解出来了

可以是试着做这道题目： [题目链接](https://vjudge.net/contest/383066#problem/A) 密码：hpucam

### AC-CODE

```c
#include<stdio.h>
#include<iostream>
#include<string.h>
using namespace std;
typedef long long ll;
const int MAXN=100;
const int MOD=10000;
struct mat{
	ll m[3][3];
};
int n;
mat operator * (mat a,mat b){
	mat ans;
	for(int i=1;i<=2;i++){
		for(int j=1;j<=2;j++){
			ll x=0;
			for(int k=1;k<=2;k++){
				x+=a.m[i][k]*b.m[k][j]%MOD;
			}
			ans.m[i][j]=x;
		}
	}
	return ans;
}
mat ksm(mat a,int b){
	mat ans;
	memset(ans.m,0,sizeof ans.m);
	for(int i=1;i<=2;i++) ans.m[i][i]=1;
	while(b){
		if(b&1) ans=ans*a;
		a=a*a;
		b>>=1;
	}
	return ans;
}
int main()
{
	int n;
	while(scanf("%d",&n),n!=-1){
		mat a,ans;
		a.m[1][1]=a.m[1][2]=a.m[2][1]=1;
		a.m[2][2]=0;
		ans=ksm(a,n);
		cout<<ans.m[2][1]%MOD<<'\n';
	}
	return 0;
}
```

<font color="red" size=5>终于完了，帮助到您的话留下一句鼓励的话吧👍</font>

<font color="green" size=5>Ending</font>
