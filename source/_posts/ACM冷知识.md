---
title: ACM冷知识
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img2/104.webp'
tags: ACM冷知识
categories: 算法
mathjax: true
abbrlink: 5ccd823e
date: 2021-03-15 16:49:38
updated:
keywords:
description:
comments:
highlight_shrink:
---

## __int128

C++支持的最大数据类型就是longlong，再大就会爆掉，所以出现了__int128类型，默认gcc是不支持编译的，但是在各大OJ上是可以运行的，\_\_int128不支持cin、cout，所以需要自己写读入打印函数，也就是传统的快读快写

```c++
#include<bits/stdc++.h>  
using namespace std;  
typedef unsigned long long ll;  

void read(__int128 &x){
	int y=1;x=0;
	char c=getchar();
	while(c<'0' || c>'9'){
		if(c=='-') y=-1;
		c=getchar();
	}
	while(c>='0' && c<='9'){
		x=x*10+c-'0';
		c=getchar();
	}
	x*=y;
}
void print(__int128 x){
	if(x<0){
		cout<<'-';
		x*=-1;
	}
	if(x>=10) print(x/10);
	putchar(x%10+'0');
}
int main()  
{
    __int128 x;
	read(x);
	print(x); 
    return 0;  
}  
```

## atan2

函数原型：`double atan2(double y,double x)`

传进去一个向量，返回这个向量相对于x轴正方向的角度值，当向量朝向是y轴以上返回值为正，当向量朝向为y轴以下，返回值为负，所以值域为(-pi,pi]

## stoi函数 && atoi函数

> 头文件 cstring
>
> 作用：将一个字符串转化为int类型，如果输入小数会省略小数点后面的，负数也可以输入

atoi: 接受const char *，所以string类型需要调用c_str()转化一下，超过上界返回上界，超出下界返回下界

stoi: 接受const string \*，直接传入string即可，超出int范围会报错runerror

```c
#include <bits/stdc++.h>
using namespace std;

int main() {
    string s;
	cin>>s;
	cout<<stoi(s)<<'\n';    
    return 0;
}
/*
>>123
<<123
*/
```

##  isalpha || islower || isupper || isdigit

传入字符判断

isalpha： 判断是否为字母

islower:  判断是否为小写字母

isupper： 判断是否为大写字母

isdigit： 判断是否为数字
