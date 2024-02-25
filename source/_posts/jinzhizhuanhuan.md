---
title: 进制转换模板
categories: 算法
tags: 算法
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img/textbg/6.webp'
abbrlink: 6bf2ab0f
date: 2020-04-12 11:41:34
mathjax:
updated:
keywords:
description:
comments:
highlight_shrink:
---

## 题目描述

请你编一程序实现两种不同进制之间的数据转换。

输入格式

共三行，第一行是一个正整数，表示需要转换的数的进制n(2≤n≤16)n(2≤n≤16)n(2≤n≤16)，第二行是一个n进制数，若n>10n>10n>10则用大写字母A−FA-FA−F表示数码10−1510-1510−15，并且该nnn进制数对应的十进制的值不超过100000000010000000001000000000，第三行也是一个正整数，表示转换之后的数的进制m(2≤m≤16)m(2≤m≤16)m(2≤m≤16)。

输出格式

一个正整数，表示转换之后的mmm进制数。

输入输出样例

输入 #1

    16
    
    FF
    
    2

输出 #1

    11111111

## 代码：

    #include<iostream>
    #include<stdio.h>
    #include<algorithm>
    #include<string>
    #include<math.h>
    #include<vector>
    using namespace std;
    int change(char ch){
      if(ch=='A') return 10;
      if(ch=='B') return 11;
      if(ch=='C') return 12;
      if(ch=='D') return 13;
      if(ch=='E') return 14;
      if(ch=='F') return 15;
    }
    char judge(int a){
      if(a>=0&&a<=9) return char(a+'0');
      if(a==10) return 'A';
      if(a==11) return 'B';
      if(a==12) return 'C';
      if(a==13) return 'D';
      if(a==14) return 'E';
      if(a==15) return 'F';
    }
    int main()
    {
      int n,m,i=0,cnt=0;
      long long sum=0;
      vector<int> arr;
      string num;
      cin>>m>>num>>n;
      for(int i=num.size()-1;i>=0;i--,cnt++){
        if(num[i]>='A'&&num[i]<='F'){
          int t=change(num[i]);
          sum+=t*pow(m,cnt);
        }
        else sum+=(num[i]-'0')*pow(m,cnt);	
      }
    //	cout<<sum<<endl;
      if(n==10) cout<<sum<<endl;
      else if(n>=2&&n<10||n>10&&n<=16){
        string s="";
        while(sum!=0){
          s=judge(sum%n)+s;
          sum/=n;
        }
        cout<<s<<endl;
      }
    } 
