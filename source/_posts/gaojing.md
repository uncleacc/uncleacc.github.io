---
title: 高精加减乘除
categories: 算法
tags: 高精
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img/textbg/4.webp'
abbrlink: b98ecf14
date: 2020-04-18 22:51:21
mathjax:
updated:
keywords:
description:
comments:
highlight_shrink:
---

## 加法

```c
string add(string a,string b){
    if(a.size() > b.size()) swap(a,b);
    b.insert(b.begin(),'0');
    int t = 0;
    for(int i = b.size()-1,j = a.size()-1;i>=0;i--,j--){
        int cur;
        if(j>=0) cur = (a[j]-'0') + (b[i]-'0') + t;
        else cur = (b[i] - '0') +t;
        b[i] = (cur%10) + '0';
        t = cur/10;
    }
    int idx = b.find_first_not_of('0');
    return idx != -1? b.substr(idx): "0";
}
```
## 减法
```c
string sub(string a,string b){
    //a大b小
    int t = 0;
    for(int i = a.size()-1,j = b.size()-1;i>=0;i--,j--){
        int up = 0,down = 0;
        up = (a[i]-'0') + t; t = 0;
        if(j>=0) down = (b[j]-'0');
        if(up < down) up+=10,t = -1;
        int cur = up-down;
        a[i] = cur+'0';
    }
    int idx = a.find_first_not_of('0');
    return idx != -1? a.substr(idx) : "0";
}
```
## 乘法（高精度乘高精度）

    #include<iostream>
    #include<stdio.h>
    #include<string.h>
    using namespace std;
    int r[50000],r_a[50000],r_b[50000];
    int main()
    {
      string a,b;
      int len,res=0,cnt=0,k; //cnt进位，res保存每位数相乘结果 
      cin>>a>>b;
      for(int i=1;i<=a.size();i++) r_a[i]=a[i-1]-'0';
      for(int i=1;i<=b.size();i++) r_b[i]=b[i-1]-'0';
      len=b.size()+a.size()-1;  //给长度初始化为两个数位数之和 
      for(int i=a.size();i>=1;i--){
        cnt=0; res=0; k=a.size()-i+1;  //k给r数组计数 
        for(int j=b.size();j>=1;j--){
          res=r_a[i]*r_b[j]+cnt+r[k];//每一位数相乘有进位就进位 ,这
                        //里计算每一位数字乘积的时候 ，
                        //一定要加上上一次该位置的数 
          cnt=res/10;  //刷新进位 
          r[k++]=res%10;
          if(j==1&&cnt){
            r[k++]=cnt;//如果每次最后进位了就要在r数组中向后移动一个位置填上该数 
          }
          if(j==1&&i==1&&cnt)	len++;//若最后进位长度要加一  
        }
      }
      while(len>1&&r[len]==0) len--;
      for(int i=len;i>=1;i--){
        cout<<r[i];
      }
      return 0;
    }
## 乘法（高精度乘低精度）
```c
string mul(string a,ll b){
    string c = "";
    ll t = 0;
    for(int i = a.size()-1;i>=0 || t;i--){
        if(i>=0) t += (a[i]-'0')*b;
        c += (t%10) +'0';
        t/=10;
    }
    reverse(c.begin(),c.end());
    return c;
}
```

## 大数乘大数(高精度乘高精度)

```c
int a[10000],b[10000],ans[10000];//注意全局变量 
string x,y;
int len1,len2,pos;
void change(string x,string y){//接受字符串更换成int数组 
	len1=x.size(),len2=y.size();
	for(int i=1;i<=len1;i++) a[i]=x[len1-i]-'0';
	for(int i=1;i<=len2;i++) b[i]=y[len2-i]-'0';
} 
int *hpre(int a[],int b[]){ //接受int数组结果储存于ans数组 
	if((len1==1&&a[1]==0)||(len2==1&&b[1]==0)){
		ans[++pos]=0;
		return ans;
	}
	int jin=0;
	//注意低位在前 
	for(int i=1;i<=len1;i++){
		for(int j=1;j<=len2;j++){
			pos=j+i-1;
			int x=a[i]*b[j]+ans[pos];
			jin=x/10;
			if(jin) ans[pos+1]+=jin;
			ans[pos]=x%10;
		}
	}
	return ans;
}
void print(int ans[]){//输出ans数组 
	if(ans[pos+1]!=0) cout<<ans[pos];
	for(int i=pos;i>=1;i--){
		cout<<ans[i];
	}
}
```



## 除法（高精度除低精度）
```c
string div(string a,ll b){
    string c = "";
    ll cur = 0;
    for(int i = 0;i<a.size();i++){
        cur = cur*10 + (a[i]-'0');
        c += to_string(cur/b);
        cur %= b;
    }
    int idx = c.find_first_not_of('0');
    return idx!=-1 ? c.substr(idx) : "0";
}
```
## 大数取模

```c
int mod(char str[],int c)
{
    int number[100];
    for(int i=0;i<strlen(str);i++)
    	number[i]=str[i]-'0';
    int sum=0;
    for(int i=0;i<strlen(str);i++)//大数取模就是按照每一位取模,不断重复
    {
        sum=((long long)sum*10+number[i])%c;
    }
    return sum;
}
```

## 比较大小

```c
bool cmp(string a,string b){
    int idx1 = a.find_first_not_of('0'),idx2 = b.find_first_not_of('0');
    a = idx1!=-1? a.substr(idx1) : "0";
    b = idx2!=-1? b.substr(idx2) : "0";
    if(a.size() != b.size()) return a.size() >= b.size();
    return a>=b;
}
```
>告诉你个秘密点击下面的赏字就能赞助我了哦（owo）
