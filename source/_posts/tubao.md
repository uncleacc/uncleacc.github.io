---
title: 凸包讲解
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img/textbg/95.webp'
tags: 凸包
categories: 算法
date: 2021-02-08 17:22:42
mathjax: 
updated: 
keywords: 
description: 
comments: 
highlight_shrink: 
---

> 凸包（百度百科）:
>
> <img src="https://cdn.jsdelivr.net/gh/uncleacc/Sucai/20210208174637.png" style="zoom: 67%;" />
>
> 

讲解凸包之前先讲解一下极角排序、叉积

## 叉积

就是数学上的叉乘，两个向量叉乘，有正有负，相乘的两个向量前后顺序颠倒符号相反，乘出来的的结果也是一个向量，值等于以这两个向量作为平行四边形的两条边长的面积，方向指向与两个向量垂直的方向，右手定则，拇指指向x轴弯向y轴大拇指指向方向就是叉积的方向

数学上叉积非常重要，利用它可以计算出来不规则图形的面积，只需要知道不规则图形的顶点坐标。

`利用叉积求多边形面积`

>两个向量的叉积值等于以这两个向量作边的平行四边形的面积
>
>求多边形面积，就可以把多边形分解成许多三角形，求各个三角形面积加起来即可，从原点到各个点做向量，逆时针或者顺时针依次作叉积/2求和即可，顺时针和逆时针求出来的叉积方向不同，正负不同逆时针为正，顺时针为负
>
>例题：HDU2036
>
>```c
>#include <bits/stdc++.h>
>#define debug freopen("in.txt","r",stdin); freopen("out.txt","w",stdout)
>#define ios ios::sync_with_stdio(0);cin.tie(0);cout.tie(0)
>using namespace std;
>typedef long long ll;
>typedef unsigned long long ull;
>const int MAXN=1e6+100;
>const int MOD=1e9+7;
>const int INF=0x3f3f3f3f;
>const int SUB=-0x3f3f3f3f;
>const double eps=1e-4;
>const double E=exp(1);
>const double pi=acos(-1);
>int n;
>double ans;
>double x[MAXN],y[MAXN];
>double calc(double x1,double y1,double x2,double y2){
>	return x1*y2-x2*y1;
>}
>int main(){
>	ios;
>	while(cin>>n){
>		if(n==0) break;
>		ans=0;
>		for(int i=1;i<=n;i++) cin>>x[i]>>y[i];
>		for(int i=n-1;i>=1;i--){
>			ans+=calc(x[i+1],y[i+1],x[i],y[i])/2;
>		}
>		ans+=calc(x[1],y[1],x[n],y[n])/2;
>		cout<<fixed<<setprecision(1)<<-ans<<'\n';
>	}
>	return 0;
>}
>```
>
>

## 极角排序

将一系列的点相对于一个基准点顺时针或者逆时针排序

两种方法

1. 利用叉积排序，叉积有正有负，两个向量交换顺序符号就会相反

   ```c
   int cross(point a,point b,point c){
   	int x1=b.x-a.x;
   	int y1=b.y-a.y;
   	int x2=c.x-a.x;
   	int y2=c.y-a.y;
   	return x1*y2-x2*y1;
   }
   int getxx(int x,int y){
   	if(x>0 && y>0) return 1;
   	else if(x>0 && y<0) return 4;
   	else if(x<0 && y>0) return 2;
   	else if(x<0 && y<0) return 3;
   }
   bool cmp1(point a,point b){
   	point c={0,0};
   	int x1=a.x-c.x, y1=a.y-c.y;
   	int x2=b.x-c.x, y2=b.y-c.y;
   	if(getxx(x1,y1)!=getxx(x2,y2)) return getxx(x1,y1)<getxx(x2,y2);
   	else{
   		if(cross(c,a,b)==0) return a.x<b.x;
   		return cross(c,a,b)>0;	
   	}
   }
   
   ```

2. atan2，接受一个坐标，返回一个角度值

   ```c
   int getxx(int x,int y){
   	if(x>0 && y>0) return 1;
   	else if(x>0 && y<0) return 4;
   	else if(x<0 && y>0) return 2;
   	else if(x<0 && y<0) return 3;
   }
   bool cmp2(point a,point b){	//atan2排序
   	point c={0,0};
   	int x1=a.x-c.x, y1=a.y-c.y;
   	int x2=b.x-c.x, y2=b.y-c.y;
   	if(getxx(x1,y1)!=getxx(x2,y2)) return getxx(x1,y1)<getxx(x2,y2);
   	else{
   		if(getxx(x1,y1)==3 || getxx(x1,y1)==4){
               if(atan2(-x1,-y1)!=atan2(-x2,-y2)) return atan2(-y1,-x1)>atan2(-y2,-x2);
               else return a.x>b.x; 
           }
           else{
               if(atan2(x1,y1)!=atan2(x2,y2)) return atan2(y1,x1)<atan2(y2,x2);
   	        else return a.x<b.x;
   	    }
   	}
   }
   ```

atan()和atan2是两个不同的函数

> atan(): 接受的是一个正切值（直线的斜率）得到夹角，但是由于正切的规律性本可以有两个角度的但它却只返回一个，因此值域是从-90~90 也就是它只处理一四象限，所以一般不用它。

> atan2(double y,double x) 其中y代表已知点的Y坐标，同理x ,返回值是此点与远点连线与x轴正方向的夹角，这样它就可以处理四个象限的任意情况了，`它的值域相应的也就是-180~180了`

叉积速度慢，但是没有精度问题，atan2速度快，精度可能出现问题

:::warn

这里求凸包，极角排序最好根据y值最小的点为基准点，不要以原点为基准点，因为atan2的值域是[-pi,pi]，当点出现在x轴下面时，返回角度就是负的了，所以最好把所有点的向量都算成x轴上方！而且y值最小的点一定在凸包上的

:::

## 凸包

找出所有点中最靠下且最靠左的坐标点，以这个点作为基准点进行极角排序，之后把前两个点放进去栈中(注意这里的栈不能用stl中的栈实现，因为还要取出倒数第二个元素)，从第三个点开始往后遍历，每次取出栈中前两个点和这个点做叉积，为负数表明内凹，就弹出栈顶元素再做叉积，直到叉积大于0就把这个点入栈，最后栈中元素就是凸包，算出栈中相邻两点的距离就是凸包距离。

例题: POJ1113

## CODE

```c
#include <iostream>
#include <cmath> 
#include <algorithm>
#include <iomanip>
#define ios ios::sync_with_stdio(0); cin.tie(0); cout.tie(0)
using namespace std;
typedef long long ll;
const double pi=acos(-1);
const int SUP=0x800000;
const int MAXN=1e6+100;
const int INF=0x3f3f3f3f;
const double eps=1e-4;
struct node{
	int x,y;
}p[MAXN],d[MAXN];
int n,m,top;
node mi;
bool cmp(node a,node b){
	if(atan2(a.y-mi.y,a.x-mi.x)==atan2(b.y-mi.y,b.x-mi.x)) return a.x<b.x;
	return atan2(a.y-mi.y,a.x-mi.x)<atan2(b.y-mi.y,b.x-mi.x);
}
double getdis(node a,node b){
	return sqrt((a.x-b.x)*(a.x-b.x)+(a.y-b.y)*(a.y-b.y));
}
int cross(node a,node b,node c){
	int x1=b.x-a.x,y1=b.y-a.y;
	int x2=c.x-b.x,y2=c.y-b.y;
	return x1*y2-x2*y1;
}
int main()
{
	ios;
	cin>>n>>m;
	if(n==0){
		cout<<0<<'\n';
		return 0;
	}
	if(n==1){
		cout<<fixed<<setprecision(0)<<2*pi*m<<'\n';
		return 0;
	}
	mi={INF,INF};
	for(int i=1;i<=n;i++){
		cin>>p[i].x>>p[i].y;
		if(p[i].y<mi.y || (p[i].y==mi.y && p[i].x<mi.x)) mi=p[i];
	}
	sort(p+1,p+1+n,cmp);
	d[0]=p[1];
	d[1]=p[2];
	top=1;
	for(int i=3;i<=n;i++){
		while(top>=1 && cross(d[top-1],d[top],p[i])<=0) top--;  //注意这里<=可以减少凸包上的点，比较好的优化
		d[++top]=p[i];
	}
	if(top<=2){
		if(top==2) ans+=getdis(st[1],st[2]);
		cout<<fixed<<setprecision(0)<<ans*2<<'\n';
		return 0;
	}
	double ans=0;
	for(int i=1;i<=top;i++) ans+=getdis(d[i-1],d[i]);
	ans+=getdis(d[0],d[top])+2*pi*m;
	cout<<fixed<<setprecision(0)<<ans<<'\n';
	return 0;
 }

```

## 最小外接圆

[POJ-2215]()

给定n个点坐标，求最小外接圆

求一个凸包，枚举凸包上的3个点，3个点确定一个⚪，当三个点组成钝角三角形，半径就是最长边的一半，否则面积就是a\*b\*c/(4\*S)，S通过叉积求即可

```c
#include <cstdio>
#include <iostream>
#include <algorithm>
#include <cmath>
#include <iomanip>
#define debug freopen("in.txt","r",stdin); freopen("out.txt","w",stdout)
#define ios ios::sync_with_stdio(0);cin.tie(0);cout.tie(0)
using namespace std;
typedef long long ll;
typedef unsigned long long ull;
const int MAXN=1e6+100;
const int MOD=1e9+7;
const int INF=0x3f3f3f3f;
const int SUB=-0x3f3f3f3f;
const double eps=1e-4;
const double E=exp(1);
const double pi=acos(-1);
struct node{
	double x,y;
}p[MAXN],st[MAXN];
node bas;
int n,top; 
bool cmp(node a,node b){
	if(atan2(a.y-bas.y,a.x-bas.x)==atan2(b.y-bas.y,b.x-bas.x)) return a.x<b.x;
	return atan2(a.y-bas.y,a.x-bas.x)<atan2(b.y-bas.y,b.x-bas.x);
}
double cross(node a,node b,node c){
	double x1=b.x-a.x,y1=b.y-a.y;
	double x2=c.x-b.x,y2=c.y-b.y;
	return x1*y2-x2*y1;
}
double getdis(node a,node b){
	return sqrt((a.x-b.x)*(a.x-b.x)+(a.y-b.y)*(a.y-b.y));
}

bool isdun(double a,double b,double c){
	if(a*a+b*b<c*c || a*a+c*c<b*b || b*b+c*c<a*a)
		return 1;//是钝角三角形
	return 0; 
}
int main(){
	ios;
	while(cin>>n && n){
		top=0;
		bas={INF,INF};
		for(int i=1;i<=n;i++){
			cin>>p[i].x>>p[i].y;
			if(p[i].y<bas.y || (p[i].y==bas.y && p[i].x<bas.x)) bas=p[i];
		}
		if(n==1){
			cout<<"0.50"<<'\n';
			continue;
		}
		sort(p+1,p+1+n,cmp);
		st[++top]=p[1];
		st[++top]=p[2];
		for(int i=3;i<=n;i++){
			while(top>1 && cross(st[top-1],st[top],p[i])<=0) --top;
			st[++top]=p[i];
		}
		if(top==2){
			cout<<fixed<<setprecision(2)<<getdis(st[1],st[2])/2+0.5<<'\n';
			continue;
		}
		double ans=0;
		for(int i=1;i<=top;i++){
			for(int j=i+1;j<=top;j++){
				for(int k=j+1;k<=top;k++){
					double dis1=getdis(st[i],st[j]);
					double dis2=getdis(st[j],st[k]);
					double dis3=getdis(st[i],st[k]);
					if(isdun(dis1,dis2,dis3)){
						double len=max(max(dis1,dis2),dis3);
						ans=max(len/2,ans);
					}
					else{
						double S=fabs(cross(st[i],st[j],st[k]))/2;
						ans=max(ans,dis1*dis2*dis3/(4*S));
					}
				}
			}
		}
		cout<<fixed<<setprecision(2)<<ans+0.5<<'\n';
	}
	return 0;
}
```

