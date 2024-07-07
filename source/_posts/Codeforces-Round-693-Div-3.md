---
title: Codeforces Round
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img/textbg/94.webp'
tags: div3
categories: 题目
abbrlink: 682df6fc
date: 2021-01-21 22:15:01
mathjax:
updated:
keywords:
description:
comments:
highlight_shrink:
---

## A. Cards for Friends

给一个宽度和一个长度的蛋糕，只有为长或宽为偶数时才能切一刀数量乘以2，问给定尺寸的蛋糕能否分够k块。

分别对宽和长除2，只要是偶数就除，看看能除几次，得到两个次数相乘就是能分的最大数量，和k比较一下

```c
#include <bits/stdc++.h>
#define ios ios::sync_with_stdio(0); cin.tie(0); cout.tie(0)
using namespace std;
typedef long long ll;
const int SUP=0x800000;
const int MAXN=1e5;
const int INF=0x3f3f3f3f;
const double eps=1e-4;
int num[MAXN];
int main()
{
	ios;
	int t;
	cin>>t;
	while(t--){
		int w,h,k;
		cin>>w>>h>>k;
		int a=1,b=1;
		while(w){
			if(w&1) break; 
			a*=2;
			w/=2;
		}
		while(h){
			if(h&1) break;
			b*=2;
			h/=2;
		}
		if(k<=a*b)  cout<<"YES\n";
		else cout<<"NO\n";
	}
	return 0;
 }
```

## B. Fair Division

给定n个数，每一个数只能是1或2，问能否把n个数分成相等的两部分

1数量为奇数时不可行，1数量为偶数并且2数量为偶数可行，1数量为偶数2数量为奇数不可行

```c
#include <bits/stdc++.h>
#define ios ios::sync_with_stdio(0); cin.tie(0); cout.tie(0)
using namespace std;
typedef long long ll;
const int SUP=0x800000;
const int MAXN=1e5;
const int INF=0x3f3f3f3f;
const double eps=1e-4;
int num[MAXN];
int main()
{
	ios;
	int t;
	cin>>t;
	while(t--){
		int n;
		cin>>n;
		int cnt1=0,cnt2=2;
		for(int i=1;i<=n;i++){
			int tmp;
			cin>>tmp;
			if(tmp==1) cnt1++;
			if(tmp==2) cnt2++;
		}
		if(cnt1&1) cout<<"NO\n";
		else if(cnt1==0 && cnt2&1) cout<<"NO\n";
		else cout<<"YES\n";
	}
	return 0;
 }
```

## C. Long Jumps

给n个数，初始可以从1-n中任意一个位置作为起始位置，从起始开始，每次往右跳a[i]步，并且得到分数a[i]，当跳过n后结束，问最大分数

排序，从后往前遍历，如果当前位置往右跳后没出界则从这个位置开始的分数就是这个位置的数加上以右跳一步落点为起点的分数，过程中取分数最大值，最后输出

```c
#include <bits/stdc++.h>
#define ios ios::sync_with_stdio(0); cin.tie(0); cout.tie(0)
using namespace std;
typedef long long ll;
const int SUP=0x800000;
const int MAXN=2e5+100;
const int INF=0x3f3f3f3f;
const double eps=1e-4;
int num[MAXN],sc[MAXN];
int main()
{
	ios;
	int t;
	cin>>t;
	while(t--){
		int n,ans=-1;
		cin>>n;
		for(int i=1;i<=n;i++) cin>>num[i];
		for(int i=n;i>=1;i--){
			sc[i]=num[i];
			if(i+num[i]<=n) sc[i]+=sc[i+num[i]];
			ans=max(ans,sc[i]);
		}
		cout<<ans<<'\n';
	}
	return 0;
 }
```

## D. Even-Odd Game

n个数，两个人轮流选数，a选到偶数加分，b选到奇数加分，加分为a[i]，求a开始必胜还是必败

排序，从后往前选，能加则加，不能加不加，最后比谁分数大

```c
#include <bits/stdc++.h>
#define ios ios::sync_with_stdio(0); cin.tie(0); cout.tie(0)
using namespace std;
typedef long long ll;
const ll SUP=0x800000;
const ll MAXN=2e5+100;
const ll INF=0x3f3f3f3f;
const double eps=1e-4;
ll num[MAXN];
int main()
{
	ios;
	ll t;
	cin>>t;
	while(t--){
		ll n;
		cin>>n;
		for(ll i=1;i<=n;i++) cin>>num[i];
		sort(num+1,num+1+n);
		ll sc1=0,sc2=0,t=1;
		for(ll i=n;i>=1;i--){
			if(t==1){
				if(!(num[i]&1)) sc1+=num[i];
				t=0;
			}
			else{
				if(num[i]&1) sc2+=num[i];
				t=1;
			}
		}
		if(sc1==sc2) cout<<"Tie\n";
		else if(sc1>sc2) cout<<"Alice\n";
		else cout<<"Bob\n"; 
	}
	return 0;
 }
```

## E. Correct Placement

n组数，每组数都有一个长宽，一组数可以排在另一组数前面，条件是len(pre)<len(now) and wide(pre)<wide(now)或者len(pre)<wide(now) && wide(pre)<wide(now)，对于每一个数输出一个可以排在这个数前面的数位置，多解随便输出一个位置即可

这道题我觉得解法很巧妙，首先每一组数保证h>w，按照h大小排一下序，当h相同时按w从大到小排，然后从前往后遍历，这样保证了前面的h小于等于当前h了，只要找前面小于当前w的一个数即可，由于输出任意一个，可以维护前缀最小值，直接判断前面最小的是否小于当前w，小于就输出那个位置，否则就没有输出-1，还有需要按照初始时序列顺序输出，所以需要记录顺序，这里有一个坑就是前面的数h有可能等于当前数的h，所以前面排序规则中才让w从大到小排，这样一来，h相等时就找不到小于当前值的w了，就会记成-1

```c
#include <bits/stdc++.h>
#define ios ios::sync_with_stdio(0); cin.tie(0); cout.tie(0)
using namespace std;
typedef long long ll;
const ll SUP=0x800000;
const ll MAXN=2e5+100;
const ll INF=0x3f3f3f3f;
const double eps=1e-4;
struct node{
	int h,w,id;
}arr[MAXN],ans[MAXN];
void swap(node &x){
	int tmp=x.h;
	x.h=x.w;
	x.w=tmp;
}
bool cmp(node a,node b){
	if(a.h==b.h) return a.w>b.w;
	return a.h<b.h;
}
bool cmp2(node a,node b){
	return a.id<b.id;
}
int mi[MAXN];
int main()
{
	ios;
	ll t;
	cin>>t;
	while(t--){
		int n;
		cin>>n;
		for(int i=1;i<=n;i++){
			cin>>arr[i].h>>arr[i].w;
			arr[i].id=i;
			if(arr[i].h<arr[i].w) swap(arr[i]);
		}
		sort(arr+1,arr+1+n,cmp);
		memset(mi,0x3f,sizeof mi);
		int p=-1,tail=0;
		for(int i=1;i<=n;i++){
			ans[++tail].id=arr[i].id;
			if(arr[i].w>mi[i-1]) ans[tail].h=p;
			else ans[tail].h=-1;
			if(arr[i].w<mi[i-1]){
				p=arr[i].id;
				mi[i]=arr[i].w;
			}
			else mi[i]=mi[i-1];
		}
		sort(ans+1,ans+1+tail,cmp2);
		for(int i=1;i<=tail;i++){
			if(i!=tail) cout<<ans[i].h<<' ';
			else cout<<ans[i].h<<'\n';
		}
		
	}
	return 0;
 }
```

