---
title: 小Q与异或
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img2/117.webp'
tags: 异或题
categories: 题目
mathjax: true
date: 2021-04-27 20:46:26
updated: 
keywords: 
description: 
comments: 
highlight_shrink: 
---

##   题目

<img src="C:\Users\60116\AppData\Roaming\Typora\typora-user-images\image-20210427204752367.png" alt="image-20210427204752367" style="zoom:67%;" />

### 题意

让你构造一个序列，满足m个位置的前缀异或等于m个值

### 题解

先把p位置的值定成x，把每一个定好的位置标记一下，从前往后跑，没有标记过的点就给他定一个比1e9要大的数，之所以要比1e9要大，是因为要保证定好的位置和它的前一个位置异或不为0，而定好的位置的值x<=1e9，输出时，就输出每一个数和前一个数的异或结果

### CODE

```c
#include <stdio.h>
#include <algorithm>

using namespace std;

int n , m;
int ned[1200000] , is[1200000];
void work () {
	int i , p , x , pre;
	scanf ( "%d%d" , &n , &m );
	for ( i = 1 ; i <= m ; i++ ) {
		scanf ( "%d%d" , &p , &x );
		if ( is[p] && ned[p] != x ) {
			printf ( "-1\n" );
			return ;
		}
		ned[p] = x;
		is[p] = 1;
	}
	for ( i = 1 ; i <= n ; i++ ) {
		if ( is[i] == 0 ) {
			ned[i] = 1000000000 + i;
		}
		if ( ned[i] == ned[i-1] ) {
			printf ( "-1\n" );
			return ;
		}
	}
	for ( i = 1 ; i <= n ; i++ ) {
		printf ( "%d%c" , ned[i-1] ^ ned[i] , i==n?'\n':' ' );
	}
}
int main () {
	work ();
	return 0;
}
```

