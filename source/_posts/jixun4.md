---
title: 贪心与二分
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img/textbg/66.webp'
categories: 题目
tags: 集训
abbrlink: 8fb3f0eb
date: 2020-07-15 20:33:21
mathjax:
updated:
keywords:
description:
comments:
highlight_shrink:
---

> 被虐惨了，各种调试与超时或者看不懂题🐷

## Strange fuction

>Now, here is a fuction:
> F(x) = 6 * x^7+8*x^6+7*x^3+5*x^2-y*x (0 <= x <=100)
>Can you find the minimum value when x is between 0 and 100.
>
>**Input**
>
>The first line of the input contains an integer T(1<=T<=100) which means the number of test cases. Then T lines follow, each line has only one real numbers Y.(0 < Y <1e10)
>
>**Output**
>
>Just the minimum value (accurate up to 4 decimal places),when x is between 0 and 100.
>
>**Sample Input**
>
>```
>2
>100
>200
>```
>
>**Sample Output**
>
>```
>-74.4291
>-178.8534
>```

### 分析

做了这道题我终于相信ACM和高中数学紧密相连，因为是打代码，我就没往导数的方向去想，一搜题解看到导数俩字我瞬间醍醐灌顶，行如流水代码出来🐶

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
using namespace std;
typedef long long ll;
const int MAXN = 1e5;
const int MOD = 1e9;
const double eps = 1e-6;
double y;
double dao(double x){
	return 42*pow(x,6.0)+48*pow(x,5.0)+21*pow(x,2.0)+10*x-y;
}
double f(double x){
	return 6*pow(x,7)+8*pow(x,6)+7*pow(x,3)+5*pow(x,2)-x*y;
}
int main(){
	int t;
	scanf("%d",&t);
	while(t--){
		scanf("%lf",&y);
		double l,r,mid;
		l=0; r=100;
		while(r-l>=eps){
			mid=(l+r)/2;
			if(dao(mid)>0) r=mid;
			else if(dao(mid)<0) l=mid;
			else break;
		}
		printf("%.4f\n",f(mid));
	}
	return 0;
}
```

## Best Cow Line

读不懂题的一道题，其实很简单，但是我就是没读懂意思，它的顺序更换规则只能改变第一个和最后一个，其实是一道比较水的题目，我要吐槽的是刚开始我想锻炼一下数据结构，用双端队列来做了，还用了迭代器，最后交后直接给我来个编译错误，我*，喵的，我**写了这么久你t喵的不能使用迭代器，k！最后还是换成了字符数组来做

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
using namespace std;
typedef long long ll;
const int N = 1e4+100;
const int MOD = 1e9;
const double eps = 1e-5;
const int INF = 0x3f3f3f;
int main(){
	ios;
	int n; cin>>n;
	char ch[n+10];
	string ans;
	for(int i=1;i<=n;i++) cin>>ch[i];
	int p1=1,p2=n;
	while(p2>=p1){
		if(ch[p1]<ch[p2]){
			ans+=ch[p1];
			p1++;
		}
		if(ch[p1]>ch[p2]){
			ans+=ch[p2];
			p2--;
		}
		if(ch[p1]==ch[p2]){
			int it1=p1,it2=p2;
			while(ch[it1]==ch[it2]&&it2>it1){
				it1++; it2--;
			}
			if(ch[it1]>=ch[it2]){
				ans+=ch[p2];
				p2--;
			}
			if(ch[it1]<ch[it2]){
				ans+=ch[p1];
				p1++;
			}
		}
	}
	int cnt=1,len=ans.size();
	for(int i=0;i<len;i++){
		if(cnt%80==0) cout<<ans[i]<<'\n';
		else cout<<ans[i];
		cnt++;
	}
	return 0;
}
```

## The Frog's Games

>The annual Games in frogs' kingdom started again. The most famous game is the Ironfrog Triathlon. One test in the Ironfrog Triathlon is jumping. This project requires the frog athletes to jump over the river. The width of the river is L (1<= L <= 1000000000). There are n (0<= n <= 500000) stones lined up in a straight line from one side to the other side of the river. The frogs can only jump through the river, but they can land on the stones. If they fall into the river, they
>are out. The frogs was asked to jump at most m (1<= m <= n+1) times. Now the frogs want to know if they want to jump across the river, at least what ability should they have. (That is the frog's longest jump distance).
>
>**Input**
>
>The input contains several cases. The first line of each case contains three positive integer L, n, and m.
>Then n lines follow. Each stands for the distance from the starting banks to the nth stone, two stone appear in one place is impossible.
>
>**Output**
>
>For each case, output a integer standing for the frog's ability at least they should have.
>
>**Sample Input**
>
>```
>6 1 2
>2
>25 3 3
>11 
>2
>18
>```
>
>**Sample Output**
>
>```
>4
>11
>```

### 分析

青蛙过河，给你河宽，石头数以及每一个石头离河岸的距离，跳的步数，问青蛙每次最少跳几米才能不掉进河里且安全过岸，典型二分，大致估算复杂度NlogN，不会超时，这里难的其实是怎么判断当前检测的距离是否满足，说白了就是青蛙必须跳到最远能跳到的石头，这样才能保证可能能跳到对面，怎么解决跳到最远能跳到的石头呢？可以用一个pre记录上一次所在的石头位置，然后枚举石头距离，如果当前石头距离上一次位置距离小于等于你的最远弹跳距离的话，就把当前石头位置往后移一个，那么最后出来循环当前石头距离上次驻留位置距离一定是大于最远弹跳距离的，再把石头位置往前移动一个就达到了最远能跳到的距离，`二分检查经常碰到这种情况，一定要知道怎么解决`。

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
using namespace std;
typedef long long ll;
const int N = 5e5+100;
const int MOD = 1e9;
const double eps = 1e-5;
const int INF = 0x3f3f3f;
int d[N];
int L,n,m;
bool check(int mid){
	int pos=0,pre=0;
	for(int i=1;i<=m;i++){
		while(pos<=n+1&&d[pos]-d[pre]<=mid) pos++;
		pos--;
		pre=pos;
	}
	if(pos>=n+1) return 1;
	else return 0;
}
int main(){
	ios;
	while(cin>>L>>n>>m){
		memset(d,0,sizeof d);
		for(int i=1;i<=n;i++) cin>>d[i];
		d[n+1]=L;
		sort(d+1,d+1+n);
		int l=0,r=L,mid,ans;
		while(r>=l){
			mid=(l+r)>>1;
			if(check(mid)){
				ans=mid;
				r=mid-1;
			} 
			else l=mid+1;
		}
		cout<<ans<<'\n';
	}
	return 0;
}
```

## 湫湫系列故事——消灭兔子

>湫湫减肥
>　　越减越肥！
>
>最近，减肥失败的湫湫为发泄心中郁闷，在玩一个消灭免子的游戏。
>　　游戏规则很简单，用箭杀死免子即可。
>　　箭是一种消耗品，已知有M种不同类型的箭可以选择，并且每种箭都会对兔子造成伤害，对应的伤害值分别为Di（1 <= i <= M），每种箭需要一定的QQ币购买。
>　　假设每种箭只能使用一次，每只免子也只能被射一次，请计算要消灭地图上的所有兔子最少需要的QQ币。
>
>**Input**
>
>输入数据有多组，每组数据有四行；
>第一行有两个整数N，M（1 <= N, M <= 100000），分别表示兔子的个数和箭的种类；
>第二行有N个正整数，分别表示兔子的血量Bi（1 <= i <= N）；
>第三行有M个正整数，表示每把箭所能造成的伤害值Di（1 <= i <= M）；
>第四行有M个正整数，表示每把箭需要花费的QQ币Pi（1 <= i <= M）。
>
>特别说明：
>1、当箭的伤害值大于等于兔子的血量时，就能将兔子杀死；
>2、血量Bi，箭的伤害值Di，箭的价格Pi，均小于等于100000。
>
>**Output**
>
>如果不能杀死所有兔子，请输出”No”，否则，请输出最少的QQ币数，每组输出一行。
>
>**Sample Input**
>
>```
>3 3
>1 2 3
>2 3 4
>1 2 3
>3 4
>1 2 3
>1 2 3 4
>1 2 3 1
>```
>
>**Sample Output**
>
>```
>6
>4
>```

### 分析

做这道题就只需要知道一点，杀一只兔子，我们应该选择伤害足够的箭里面消耗最小的，我们把兔子按照血量从大到小排序，箭按伤害从大到小排序，然后枚举兔子血量，去箭里面找到能够杀死这只兔子的所有箭，去里面找到耗费最小的，然后累加耗费就行了，做着做着就发现这用到了优先队列~~不用优先队列还超时~~，优先队列用来装每次枚举兔子时可以杀死这只兔子的所有箭，然后给优先队列进行一次比较运算符重载就行了

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
using namespace std;
typedef long long ll;
const int N = 5e5+100;
const int MOD = 1e9;
const double eps = 1e-5;
const int INF = 0x3f3f3f;
int d[N];
int L,n,m;
bool check(int mid){
	int pos=0,pre=0;
	for(int i=1;i<=m;i++){
		while(pos<=n+1&&d[pos]-d[pre]<=mid) pos++;
		pos--;
		pre=pos;
	}
	if(pos>=n+1) return 1;
	else return 0;
}
int main(){
	ios;
	while(cin>>L>>n>>m){
		memset(d,0,sizeof d);
		for(int i=1;i<=n;i++) cin>>d[i];
		d[n+1]=L;
		sort(d+1,d+1+n);
		int l=0,r=L,mid,ans;
		while(r>=l){
			mid=(l+r)>>1;
			if(check(mid)){
				ans=mid;
				r=mid-1;
			} 
			else l=mid+1;
		}
		cout<<ans<<'\n';
	}
	return 0;
}
```

## Can you find it?

>Give you three sequences of numbers A, B, C, then we give you a number X. Now you need to calculate if you can find the three numbers Ai, Bj, Ck, which satisfy the formula Ai+Bj+Ck = X.
>
>**Input**
>
>There are many cases. Every data case is described as followed: In the first line there are three integers L, N, M, in the second line there are L integers represent the sequence A, in the third line there are N integers represent the sequences B, in the forth line there are M integers represent the sequence C. In the fifth line there is an integer S represents there are S integers X to be calculated. 1<=L, N, M<=500, 1<=S<=1000. all the integers are 32-integers.
>
>**Output**
>
>For each case, firstly you have to print the case number as the form "Case d:", then for the S queries, you calculate if the formula can be satisfied or not. If satisfied, you print "YES", otherwise print "NO".
>
>**Sample Input**
>
>```
>3 3 3
>1 2 3
>1 2 3
>1 2 3
>3
>1
>4
>10
>```
>
>**Sample Output**
>
>```
>Case 1:
>NO
>YES
>NO
>```

## 分析

题意比较好理解，给你三组序列数从这三组序列里随便挑三个数求满足式子所有做法数量，很好想到的是加俩序列，然后在第三组序列里二分找K-a[i]-b[i]，高高兴兴写好代码，交上去超时了。。。后来想了很久感觉没办法再优化了，没想到正解是二分K-c[i]，用一个新数组存ab数组的组合，再在新数组里面二分找K-c[i]，这样好处就是二分的数组变长了，复杂度虽然还是nlogn，但是n却变小了（logn虽然变大了，但是因为是log级别几乎没影响）。真是巧妙

### CODE

```c
#include<iostream>
#include<algorithm> 
#include<string>
#include<cstring>
#include<queue>
using namespace std;
typedef long long ll;
const int MAXN=1e3+100;
int a[MAXN],b[MAXN],c[MAXN],d[MAXN],x[250010];
int main()
{
 	int L,N,M,kase=0;
 	while(cin>>L>>N>>M){
 		int cnt=0;
	 	for(int i=1;i<=L;i++) cin>>a[i];
		for(int i=1;i<=N;i++) cin>>b[i];
		for(int i=1;i<=M;i++) cin>>c[i];
		int S; cin>>S;
		for(int i=1;i<=S;i++) cin>>d[i];
		for(int i=1;i<=L;i++){
			for(int j=1;j<=N;j++){
				x[++cnt]=a[i]+b[j];
			}
		}
		sort(x+1,x+1+cnt);
		cout<<"Case "<<++kase<<":"<<'\n';
		for(int k=1;k<=S;k++){
			int flag=0;
			for(int i=1;i<=M;i++){
				int temp=d[k]-c[i];
//				cout<<temp<<endl;
				int id=lower_bound(x+1,x+1+cnt,temp)-x;
				if(id!=cnt+1&&x[id]==temp){
					flag=1;
					break;
				}
			}
			if(flag) cout<<"YES"<<'\n';
			else cout<<"NO"<<'\n'; 
		}
	}
 	return 0;
} 
```

## Aggressive cows

>Farmer John has built a new long barn, with N (2 <= N <= 100,000) stalls. The stalls are located along a straight line at positions x1,...,xN (0 <= xi <= 1,000,000,000).
>
>His C (2 <= C <= N) cows don't like this barn layout and become aggressive towards each other once put into a stall. To prevent the cows from hurting each other, FJ want to assign the cows to the stalls, such that the minimum distance between any two of them is as large as possible. What is the largest minimum distance?
>
>**Input**
>
>\* Line 1: Two space-separated integers: N and C
>
>\* Lines 2..N+1: Line i+1 contains an integer stall location, xi
>
>**Output**
>
>\* Line 1: One integer: the largest minimum distance
>
>**Sample Input**
>
>```
>5 3
>1
>2
>8
>4
>9
>```
>
>**Sample Output**
>
>```
>3
>```
>
>**Hint**
>
>OUTPUT DETAILS:
>
>FJ can put his 3 cows in the stalls at positions 1, 4 and 8, resulting in a minimum distance of 3.
>
>Huge input data,scanf is recommended.

### 分析

最简单的一道二分题，却放在了最后一题。。。

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
using namespace std;
typedef long long ll;
const int MAXN = 1e5+100;
const int MOD = 1e9;
const double eps = 1e-5;
const int INF = 0x3f3f3f;
int N,C;
int v[MAXN];
int check(int mid){
	int pre=1,cnt=1;
	for(int i=2;i<=N;i++){
		if(v[i]-v[pre]>=mid){
			pre=i;
			cnt++;
		}
		if(cnt==C) return 1;
	}
	return 0;
}
int main(){
	ios;
	cin>>N>>C;
	for(int i=1;i<=N;i++) cin>>v[i];
	sort(v+1,v+1+N);
	int l=0,r=v[N],mid,ans;
	while(r>=l){
		mid=(l+r)>>1;
		if(check(mid)){
			ans=mid;
			l=mid+1;
		}
		else r=mid-1;
	}
	cout<<ans<<'\n';
	return 0;
}
```

## Radar Installation

>Assume the coasting is an infinite straight line. Land is in one side of coasting, sea in the other. Each small island is a point locating in the sea side. And any radar installation, locating on the coasting, can only cover d distance, so an island in the sea can be covered by a radius installation, if the distance between them is at most d.
>
>We use Cartesian coordinate system, defining the coasting is the x-axis. The sea side is above x-axis, and the land side below. Given the position of each island in the sea, and given the distance of the coverage of the radar installation, your task is to write a program to find the minimal number of radar installations to cover all the islands. Note that the position of an island is represented by its x-y coordinates.

![](https://vj.z180.cn/f6ffe515205096387436c13c7449b0ed?v=1594806647)

> **Input**
>
> The input consists of several test cases. The first line of each case contains two integers n (1<=n<=1000) and d, where n is the number of islands in the sea and d is the distance of coverage of the radar installation. This is followed by n lines each containing two integers representing the coordinate of the position of each island. Then a blank line follows to separate the cases.
>
> The input is terminated by a line containing pair of zeros
>
> **Output**
>
> For each test case output one line consisting of the test case number followed by the minimal number of radar installations needed. "-1" installation means no solution for that case.
>
> **Sample Input**
>
> ```
> 3 2
> 1 2
> -3 1
> 2 1
> 
> 1 2
> 0 2
> 
> 0 0
> ```
>
> **Sample Output**
>
> ```c
> Case 1: 2
> Case 2: 1
> ```

膜拜岑大佬

### CODE

```c
#include<iostream>
#include<cmath>
#include<algorithm>
using namespace std;
typedef long long ll;
const int maxn=1010;
int n,d,maxy,cnt,sum;
double lastx,newx;
struct node { 
	int x,y; 
}nod[maxn]; 
bool cmp(node a,node b){ //因为习惯是从左往右看，因此把横坐标小的放到前面（当然你想从右往左 看也可以，但是后面就需要改动一下，把能让点在边界上的左圆心作为推断的圆心就可以）  
	if(a.x!=b.x) return a.x<b.x;
	else return a.y>b.y;//这个让纵坐标小的在前面也可以，不写也可以。不写的话就需要把上 一条的if条件去掉，不然会RE。让不让纵坐标排序都是习惯问题，在此题中不是关键。 
}
int main() { 
	cnt=1; 
	while(cin>>n>>d){ //有n个岛屿，雷达的半径为d 
		if(n==0 && d==0) break; 
		maxy=-1; sum=1;
		for(int i=0;i<n;i++){ 
			cin>>nod[i].x>>nod[i].y; 
			if(nod[i].y>maxy) maxy=nod[i].y;
		}
		sort(nod,nod+n,cmp);
		cout<<"Case "<<cnt<<": ";
		cnt++;
		if(maxy>d) //如果有岛屿到x轴的距离比d大，那么一定不能让所有岛屿都在雷达范围中
			cout<<"-1\n";
		else{
			lastx=nod[0].x+sqrt(d*d-nod[0].y*nod[0].y); //老圆心的横坐标 
			for(int i=1;i<n;i++){
				newx=nod[i].x+sqrt(d*d-nod[i].y*nod[i].y); //新圆心的横坐标 
				if(newx<lastx) //新圆心横坐标在老圆心横坐标左边 
					lastx=newx; //优化上一个圆的圆心坐标 
				else if(sqrt((nod[i].x-lastx)*(nod[i].x- lastx)+nod[i].y*nod[i].y)>d){//如果新圆心在老圆心右边，而且该岛屿到老圆心的距离比d还大，说 明需要增加一个雷达 
					lastx=newx; //更新老圆心的坐标 
					sum++; //雷达个数增加 
				} 
			}
			cout<<sum<<endl; 
		} 
	}
	return 0;
}
```

