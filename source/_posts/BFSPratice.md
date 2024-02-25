---
title: BFS练习
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img/textbg/68.webp'
categories: 题目
tags: BFS
abbrlink: 3522c2e0
date: 2020-07-23 18:12:40
mathjax:
updated:
keywords:
description:
comments:
highlight_shrink:
---

## A - Red and Black

>There is a rectangular room, covered with square tiles. Each tile is colored either red or black. A man is standing on a black tile. From a tile, he can move to one of four adjacent tiles. But he can't move on red tiles, he can move only on black tiles.
>
>Write a program to count the number of black tiles which he can reach by repeating the moves described above.
>
>**Input**
>
>The input consists of multiple data sets. A data set starts with a line containing two positive integers W and H; W and H are the numbers of tiles in the x- and y- directions, respectively. W and H are not more than 20.
>
>There are H more lines in the data set, each of which includes W characters. Each character represents the color of a tile as follows.
>
>'.' - a black tile
>'#' - a red tile
>'@' - a man on a black tile(appears exactly once in a data set)
>
>The input consists of multiple data sets. A data set starts with a line containing two positive integers W and H; W and H are the numbers of tiles in the x- and y- directions, respectively. W and H are not more than 20.
>
>There are H more lines in the data set, each of which includes W characters. Each character represents the color of a tile as follows.
>
>'.' - a black tile
>'#' - a red tile
>'@' - a man on a black tile(appears exactly once in a data set)
>
>**Output**
>
>For each data set, your program should output a line which contains the number of tiles he can reach from the initial tile (including itself).
>
>**Sample Input**
>
>```
>6 9
>....#.
>.....#
>......
>......
>......
>......
>......
>#@...#
>.#..#.
>11 9
>.#.........
>.#.#######.
>.#.#.....#.
>.#.#.###.#.
>.#.#..@#.#.
>.#.#####.#.
>.#.......#.
>.#########.
>...........
>11 6
>..#..#..#..
>..#..#..#..
>..#..#..###
>..#..#..#@.
>..#..#..#..
>..#..#..#..
>7 7
>..#.#..
>..#.#..
>###.###
>...@...
>###.###
>..#.#..
>..#.#..
>0 0
>```
>
>**Sample Output**
>
>```
>45
>59
>6
>13
>```

### 分析

模板题，没有任何需要注意的地方

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
const int N = 210;
const int MOD = 1e9;
const double eps = 1e-5;
const int INF = 0x3f3f3f;
struct node{
	int x,y,step;
};
int n,m;
char Map[N][N];
bool vis[N][N];
int dir[4][2]={1,0,0,1,-1,0,0,-1};
int bfs(int sx,int sy){
	int cnt=0;
	node s={sx,sy,0};
	queue<node> q;
	q.push(s);
	vis[sx][sy]=1;
	while(!q.empty()){
		node fr=q.front();q.pop();
		cnt++;
		for(int i=0;i<4;i++){
			node next={fr.x+dir[i][0],fr.y+dir[i][1],fr.step+1};
			if(next.x<1||next.x>n||next.y>m||next.y<1) continue;
			if(vis[next.x][next.y]||Map[next.x][next.y]=='#') continue;
			vis[next.x][next.y]=1;
			q.push(next);
		}
	}
	return cnt;
}
int main(){
	ios;
	while(cin>>m>>n){
		if(m==0&n==0) break;
		memset(vis,0,sizeof vis);
		int sx,sy;
		for(int i=1;i<=n;i++){
			for(int j=1;j<=m;j++){
				cin>>Map[i][j];
				if(Map[i][j]=='@'){
					sx=i;
					sy=j;
				}
			}
		}
		int ans=bfs(sx,sy);
		if(ans!=-1) cout<<ans<<'\n';
		else cout<<"oop!"<<'\n';
	}
	return 0;
}
```

## B - Rescue

>Angel was caught by the MOLIGPY! He was put in prison by Moligpy. The prison is described as a N * M (N, M <= 200) matrix. There are WALLs, ROADs, and GUARDs in the prison.
>
>Angel's friends want to save Angel. Their task is: approach Angel. We assume that "approach Angel" is to get to the position where Angel stays. When there's a guard in the grid, we must kill him (or her?) to move into the grid. We assume that we moving up, down, right, left takes us 1 unit time, and killing a guard takes 1 unit time, too. And we are strong enough to kill all the guards.
>
>You have to calculate the minimal time to approach Angel. (We can move only UP, DOWN, LEFT and RIGHT, to the neighbor grid within bound, of course.)
>
>**Input**
>
>First line contains two integers stand for N and M.
>
>Then N lines follows, every line has M characters. "." stands for road, "a" stands for Angel, and "r" stands for each of Angel's friend.
>
>Process to the end of the file.
>
>**Output**
>
>For each test case, your program should output a single integer, standing for the minimal time needed. If such a number does no exist, you should output a line containing "Poor ANGEL has to stay in the prison all his life."
>
>**Sample Input**
>
>```
>7 8
>#.#####.
>#.a#..r.
>#..#x...
>..#..#.#
>#...##..
>.#......
>........
>```
>
>**Sample Output**
>
>```
>13
>```

### 分析

小小的升级，在x处步数加一，问到a处最少步数，用优先队列就行了，把步数靠前的放前面

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
const int N = 210;
const int MOD = 1e9;
const double eps = 1e-5;
const int INF = 0x3f3f3f;
struct node{
	int x,y,time;
	bool operator < (const node &o) const {
		return o.time<time;
	}
};
int n,m;
char Map[N][N];
bool vis[N][N];
int dir[4][2]={1,0,0,1,-1,0,0,-1};
int bfs(int sx,int sy){
	node s={sx,sy,0};
	priority_queue<node> q;
	q.push(s);
	vis[sx][sy]=1;
	while(!q.empty()){
		node fr=q.top();q.pop();
		for(int i=0;i<4;i++){
			node next={fr.x+dir[i][0],fr.y+dir[i][1],fr.time+1};
			if(next.x<1||next.x>n||next.y>m||next.y<1) continue;
			if(vis[next.x][next.y]||Map[next.x][next.y]=='#') continue;
			if(Map[next.x][next.y]=='x') next.time++;
			if(Map[next.x][next.y]=='a'){
				return next.time;
			}
			vis[next.x][next.y]=1;
			q.push(next);
		}
	}
	return INF;
}
int main(){
	ios;
	while(cin>>n>>m){
		memset(vis,0,sizeof vis);
		int sx,sy;
		for(int i=1;i<=n;i++){
			for(int j=1;j<=m;j++){
				cin>>Map[i][j];
				if(Map[i][j]=='r'){
					sx=i;
					sy=j;
				}
			}
		}
		int ans=bfs(sx,sy);
		if(ans!=INF) cout<<ans<<'\n';
		else cout<<"Poor ANGEL has to stay in the prison all his life."<<'\n';
	}
	return 0;
}
```

## C - Battle City

> Many of us had played the game "Battle city" in our childhood, and some people (like me) even often play it on computer now.
>
> What we are discussing is a simple edition of this game. Given a map that consists of empty spaces, rivers, steel walls and brick walls only. Your task is to get a bonus as soon as possible suppose that no enemies will disturb you (See the following picture).
>
> Your tank can't move through rivers or walls, but it can destroy brick walls by shooting. A brick wall will be turned into empty spaces when you hit it, however, if your shot hit a steel wall, there will be no damage to the wall. In each of your turns, you can choose to move to a neighboring (4 directions, not 8) empty space, or shoot in one of the four directions without a move. The shot will go ahead in that direction, until it go out of the map or hit a wall. If the shot hits a brick wall, the wall will disappear (i.e., in this turn). Well, given the description of a map, the positions of your tank and the target, how many turns will you take at least to arrive there?
>
> **Input**
>
> The input consists of several test cases. The first line of each test case contains two integers M and N (2 <= M, N <= 300). Each of the following M lines contains N uppercase letters, each of which is one of 'Y' (you), 'T' (target), 'S' (steel wall), 'B' (brick wall), 'R' (river) and 'E' (empty space). Both 'Y' and 'T' appear only once. A test case of M = N = 0 indicates the end of input, and should not be processed.
>
> **Output**
>
> For each test case, please output the turns you take at least in a separate line. If you can't arrive at the target, output "-1" instead.
>
> **Sample Input**
>
> ```
> 3 4
> YBEB
> EERE
> SSTE
> 0 0
> ```
>
> **Sample Output**
>
> ```
> 8
> ```

### 分析

经典坦克大战，R(河流)S(钢铁)过不去，B(砖块)可以过去但是需要多花一秒，于是这个和上一道就是一道题了，只不过多了一条河不能过而已

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
const int N = 410;
const int MOD = 1e9;
const double eps = 1e-5;
const int INF = 0x3f3f3f;
struct node{
	int x,y,time;
	bool operator < (const node &o) const {
		return o.time<time;
	}
};
int n,m;
char Map[N][N];
bool vis[N][N];
int dir[4][2]={1,0,0,1,-1,0,0,-1};
int bfs(int sx,int sy){
	node s={sx,sy,0};
	priority_queue<node> q;
	q.push(s);
	vis[sx][sy]=1;
	while(!q.empty()){
		node fr=q.top();q.pop();
		for(int i=0;i<4;i++){
			node next={fr.x+dir[i][0],fr.y+dir[i][1],fr.time+1};
			if(next.x<1||next.x>n||next.y>m||next.y<1) continue;
			if(vis[next.x][next.y]||Map[next.x][next.y]=='S'||Map[next.x][next.y]=='R') continue;
			if(Map[next.x][next.y]=='B') next.time++;
			if(Map[next.x][next.y]=='T'){
				return next.time;
			}
			vis[next.x][next.y]=1;
			q.push(next);
		}
	}
	return -1;
}
int main(){
	ios;
	while(cin>>n>>m){
		if(n==0&&m==0) break;
		memset(vis,0,sizeof vis);
		int sx,sy;
		for(int i=1;i<=n;i++){
			for(int j=1;j<=m;j++){
				cin>>Map[i][j];
				if(Map[i][j]=='Y'){
					sx=i;
					sy=j;
				}
			}
		}
		int ans=bfs(sx,sy);
		cout<<ans<<'\n';
	}
	return 0;
}
```

## Dungeon Master

>You are trapped in a 3D dungeon and need to find the quickest way out! The dungeon is composed of unit cubes which may or may not be filled with rock. It takes one minute to move one unit north, south, east, west, up or down. You cannot move diagonally and the maze is surrounded by solid rock on all sides.
>
>Is an escape possible? If yes, how long will it take?
>
>**Input**
>
>The input consists of a number of dungeons. Each dungeon description starts with a line containing three integers L, R and C (all limited to 30 in size).
>L is the number of levels making up the dungeon.
>R and C are the number of rows and columns making up the plan of each level.
>Then there will follow L blocks of R lines each containing C characters. Each character describes one cell of the dungeon. A cell full of rock is indicated by a '#' and empty cells are represented by a '.'. Your starting position is indicated by 'S' and the exit by the letter 'E'. There's a single blank line after each level. Input is terminated by three zeroes for L, R and C.
>
>**Output**
>
>Each maze generates one line of output. If it is possible to reach the exit, print a line of the form
>
>​	Escaped in x minute(s).
>
>
>where x is replaced by the shortest time it takes to escape.
>If it is not possible to escape, print the line
>
>​	Trapped!
>
>**Sample Input**
>
>```
>3 4 5
>S....
>.###.
>.##..
>###.#
>
>#####
>#####
>##.##
>##...
>
>#####
>#####
>#.###
>####E
>
>1 3 3
>S##
>#E#
>###
>
>0 0 0
>```
>
>**Sample Output**
>
>```
>Escaped in 11 minute(s).
>Trapped!
>```

### 分析

这个题有点意思，是一个三维空间的BFS，一维二维都会了，三维自然是手到擒来了，按着模板写，添加一维就行了

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
const int N = 40;
const int MOD = 1e9;
const double eps = 1e-5;
const int INF = 0x3f3f3f;
struct node{
	int x,y,z,time;
};
int l,n,m;
char Map[N][N][N];
bool vis[N][N][N];
int dir[6][3]={{1,0,0},{-1,0,0},{0,1,0},{0,-1,0},{0,0,1},{0,0,-1}};
bool check(node next){
	if(next.x<1||next.x>n||next.y>m||next.y<1||next.z<1||next.z>l) return 0;
	else return 1;
}
int bfs(int sx,int sy,int sz){
	node s={sx,sy,sz,0};
	queue<node> q;
	q.push(s);
	vis[sz][sx][sy]=1;
	while(!q.empty()){
		node fr=q.front();q.pop();
		for(int i=0;i<6;i++){
			node next={fr.x+dir[i][0],fr.y+dir[i][1],fr.z+dir[i][2],fr.time+1};
			if(!check(next)) continue;
			if(vis[next.z][next.x][next.y]||Map[next.z][next.x][next.y]=='#') continue;
			if(Map[next.z][next.x][next.y]=='E'){
				return next.time;
			}
			vis[next.z][next.x][next.y]=1;
			q.push(next);
		}
	}
	return -1;
}
int main(){
//	ios;
	while(cin>>l>>n>>m){
		if(l==0&&n==0&&m==0) break;
		memset(vis,0,sizeof vis);
		int sx,sy,sz;
		for(int k=1;k<=l;k++){
			for(int i=1;i<=n;i++){
				for(int j=1;j<=m;j++){
					cin>>Map[k][i][j];
					if(Map[k][i][j]=='S'){
						sx=i;
						sy=j;
						sz=k;
					}
				}
			}
		}
		int ans=bfs(sx,sy,sz);
		if(ans!=-1) cout<<"Escaped in "<<ans<<" minute(s)."<<'\n';
		else cout<<"Trapped!"<<'\n';
	}
	return 0;
}
```

## Catch That Cow

>Farmer John has been informed of the location of a fugitive cow and wants to catch her immediately. He starts at a point *N* (0 ≤ *N* ≤ 100,000) on a number line and the cow is at a point *K* (0 ≤ *K* ≤ 100,000) on the same number line. Farmer John has two modes of transportation: walking and teleporting.
>
>\* Walking: FJ can move from any point *X* to the points *X* - 1 or *X* + 1 in a single minute
>\* Teleporting: FJ can move from any point *X* to the point 2 × *X* in a single minute.
>
>If the cow, unaware of its pursuit, does not move at all, how long does it take for Farmer John to retrieve it?
>
>**Input**
>
>Line 1: Two space-separated integers: *N* and *K*
>
>**Output**
>
>Line 1: The least amount of time, in minutes, it takes for Farmer John to catch the fugitive cow.
>
>**Sample Input**
>
>```
>5 17
>```
>
>**Sample Output**
>
>```
>4
>```

### 分析

毒瘤的一道题目，没什么难度，就是感觉评测机器有问题，同样两段代码，放到函数和写在main函数里面不一样的结果。。。不信你可以试试

### CODE

```c
#include<cstdio>
#include<cstring>
#include<queue>
#include<iostream>
using namespace std;
int vis[1000001];
struct node{
	int wei;
	int time;
};
int main()
{
	int n,k;
	cin>>n>>k;
	node start={n,0};
	vis[n]=1;
	queue<node>q;
	q.push(start);
	while(!q.empty()){
		node tmp=q.front(); q.pop(); 
		if(tmp.wei==k){
			cout<<tmp.time<<'\n';
			break;
		}
		for(int i=0;i<3;i++){
			node nx;
			if(i==0) nx={tmp.wei+1,tmp.time+1};
			else if(i==1) nx={tmp.wei-1,tmp.time+1};
			else nx={tmp.wei*2,tmp.time+1};
			if(nx.wei<0||nx.wei>100000||vis[nx.wei]) continue;
			vis[nx.wei]=1;
			q.push(nx);
		}
	}
	return 0;
}
```

## Number Transformation

> In this problem, you are given an integer number **s**. You can transform any integer number **A** to another integer number **B** by adding **x** to **A**. This **x** is an integer number which is a prime factor of **A** (please note that 1 and **A** are not being considered as a factor of **A**). Now, your task is to find the minimum number of transformations required to transform **s** to another integer number **t**.
>
> **Input**
>
> Input starts with an integer **T (****≤ 500)**, denoting the number of test cases.
>
> Each case contains two integers: **s (1 ≤ s ≤ 100)** and **t (1 ≤ t ≤ 1000)**.
>
> **Output**
>
> For each case, print the case number and the minimum number of transformations needed. If it's impossible, then print **-1**.
>
> **Sample Input**
>
> ```
> 2
> 
> 6 12
> 
> 6 13
> ```
>
> **Sample Output**
>
> ```
> Case 1: 2
> 
> Case 2: -1
> ```
>
> 

### 分析

有意思的一道题目，给你两个数a和b，让你不断通过加a的质因子直到和b相等，有意思在哪里？这个质因子不是不变的，当a改变后，a的质因子也会发生改变，所以有两种做法，一个是每次增加都进行一次质因子分解，这也是很快的，根本不会超时，1000以内的任何一个数的质因子数量都是不超过10个的，第二种是开一个二维数组，打一个表，因为这里的b是小于1000的，我们可以开这么大的数组，存储某一个数的质因子，这里用了第二种做法，其实题目也不难，就是题目难以理解

### CODE

```c
#include<stdio.h>
#include<math.h>
#include<string.h>
#include<vector>
#include<queue>
#include<iostream>
#include<algorithm>
using namespace std;
int T,t,s;
const int MAX=1e3+10;
const int INF=0x3f3f3f;
int vis[MAX];
vector<int> vt[MAX];

struct node{
	int x,step;
};
bool check(int n){
	if(n==2||n==3) return 1;
	if(n==1||n%6!=1&&n%6!=5) return 0;
	for(int i=5;i*i<=n;i++){
		if(n%i==0||n%(i+2)==0) return 0;
	}
	return 1;
}
void prime(){
	for(int i=2;i<MAX;i++){
		for(int j=2;j<i;j++){
			if(i%j==0&&check(j)) vt[i].push_back(j);
		}
	}
}
int bfs(){
	queue<node> q;
	vis[s]=1;
	node start;
	start.x=s; start.step=0;
	q.push(start);
	while(!q.empty()){
		node tmp=q.front(); q.pop();
		if(tmp.x==t) return tmp.step;
		int len=vt[tmp.x].size();
		for(int i=0;i<len;i++){
			node nx;
			nx.x=tmp.x+vt[tmp.x][i];
			nx.step=tmp.step+1;
			if(nx.x>t||vis[nx.x]) continue;
			vis[nx.x]=1;
			q.push(nx);
		}
	}
	return -1;
}
int main()
{
	prime();
	cin>>T;
	int kase=0;
	while(T--){
		memset(vis,0,sizeof(vis));
		scanf("%d%d",&s,&t);
		int ans=INF;
		ans=bfs();
		printf("Case %d: %d\n",++kase,ans);
	}
	return 0;
}
```

## G - Knight Moves

>A friend of you is doing research on the Traveling Knight Problem (TKP) where you are to find the shortest closed tour of knight moves that visits each square of a given set of n squares on a chessboard exactly once. He thinks that the most difficult part of the problem is determining the smallest number of knight moves between two given squares and that, once you have accomplished this, finding the tour would be easy.
>Of course you know that it is vice versa. So you offer him to write a program that solves the "difficult" part.
>
>Your job is to write a program that takes two squares a and b as input and then determines the number of knight moves on a shortest route from a to b.
>
>**Input**
>
>The input file will contain one or more test cases. Each test case consists of one line containing two squares separated by one space. A square is a string consisting of a letter (a-h) representing the column and a digit (1-8) representing the row on the chessboard.
>
>**Output**
>
>For each test case, print one line saying "To get from xx to yy takes n knight moves.".
>
>**Sample Input**
>
>```
>e2 e4
>a1 b2
>b2 c3
>a1 h8
>a1 h7
>h8 a1
>b1 c3
>f6 f6
>```
>
>**Sample Output**
>
>```
>To get from e2 to e4 takes 2 knight moves.
>To get from a1 to b2 takes 4 knight moves.
>To get from b2 to c3 takes 2 knight moves.
>To get from a1 to h8 takes 6 knight moves.
>To get from a1 to h7 takes 5 knight moves.
>To get from h8 to a1 takes 6 knight moves.
>To get from b1 to c3 takes 1 knight moves.
>To get from f6 to f6 takes 0 knight moves.
>```

### 分析

只是把上下左右换成了马的走法而已

### CODE

```c
#include<string.h>
#include<iostream>
#include<queue>
using namespace std;
char ch1[3],ch2[3];
int vis[9][9],ans;
int dir[8][2]={{2,1},{-2,1},{2,-1},{-2,-1},{1,2},{1,-2},{-1,2},{-1,-2}};
struct node{
    int row,col,step;
};
void bfs(){
    queue<node> q;
    node s;
    s.row=ch1[1]-'1';
    s.col=ch1[0]-'a';
    s.step=0;
    vis[s.row][s.col]=1;
    q.push(s);
    while(!q.empty()){
        node tmp=q.front(); q.pop();
        if(tmp.row==(ch2[1]-'1')&&tmp.col==(ch2[0]-'a')){
            if(tmp.step<ans) ans=tmp.step;
            return;
        }
       	for(int i=0;i<8;i++){
           	node nx;
    		nx.row=tmp.row+dir[i][0];
    		nx.col=tmp.col+dir[i][1];
        	if(!vis[nx.row][nx.col]&&nx.row>=0&&nx.row<8&&nx.col>=0&&nx.col<8){
	            vis[nx.row][nx.col]=1;
	            nx.step=tmp.step+1;
	            q.push(nx);
        	}  
       	}
    }
}
int main()
{
    while(cin>>ch1>>ch2){
        ans=1e9;
	    memset(vis,0,sizeof(vis));
	    bfs();
	    cout<<"To get from "<<ch1<<" to "<<ch2<<" takes "<<ans<<" knight moves."<<'\n';
    }
    return 0;
}
```

## 噩梦

[题目链接](https://www.acwing.com/problem/content/description/179/)

>给定一张N*M的地图，地图中有1个男孩，1个女孩和2个鬼。
>
>字符“.”表示道路，字符“X”表示墙，字符“M”表示男孩的位置，字符“G”表示女孩的位置，字符“Z”表示鬼的位置。
>
>男孩每秒可以移动3个单位距离，女孩每秒可以移动1个单位距离，男孩和女孩只能朝上下左右四个方向移动。
>
>每个鬼占据的区域每秒可以向四周扩张2个单位距离，并且无视墙的阻挡，也就是在第k秒后所有与鬼的曼哈顿距离不超过2k的位置都会被鬼占领。
>
>**注意：** 每一秒鬼会先扩展，扩展完毕后男孩和女孩才可以移动。
>
>求在不进入鬼的占领区的前提下，男孩和女孩能否会合，若能会合，求出最短会合时间。
>
>#### 输入格式
>
>第一行包含整数T，表示共有T组测试用例。
>
>每组测试用例第一行包含两个整数N和M，表示地图的尺寸。
>
>接下来N行每行M个字符，用来描绘整张地图的状况。（注意：地图中一定有且仅有1个男孩，1个女孩和2个鬼）
>
>#### 输出格式
>
>每个测试用例输出一个整数S，表示最短会合时间。
>
>如果无法会合则输出-1。
>
>每个结果占一行。
>
>#### 数据范围
>
>1<n,m<8001<n,m<800
>
>#### 输入样例：
>
>```
>3
>5 6
>XXXXXX
>XZ..ZX
>XXXXXX
>M.G...
>......
>5 6
>XXXXXX
>XZZ..X
>XXXXXX
>M.....
>..G...
>10 10
>..........
>..X.......
>..M.X...X.
>X.........
>.X..X.X.X.
>.........X
>..XX....X.
>X....G...X
>...ZX.X...
>...Z..X..X
>```
>
>#### 输出样例：
>
>```
>1
>1
>-1
>```

### 分析

双向BFS，男孩和女孩轮流BFS，直到两者轨迹有交叉

### CODE

```c
#include<bits/stdc++.h>
using namespace std;
const int N=810;
typedef pair<int,int> pii;
int n,m;
pii boy,girl,ghost[2];
int vis[N][N],dx[4]={1,0,-1,0},dy[4]={0,1,0,-1};
char g[N][N];
bool check(int x,int y,int k){
    if(x<1||x>n||y<1||y>m||g[x][y]=='X') return false; 
    for(int i=0;i<2;i++){   
        if(abs(x-ghost[i].first)+abs(y-ghost[i].second)<=2*k) return false;
    }
    return true;
}
int bfs(){
    queue<pii> qb,qg;
    qb.push(boy); qg.push(girl);
    int step=0;
    while(!qb.empty()||!qg.empty()){
    	step++;
    	for(int k=0;k<3;k++){
    		for(int j=0,len=qb.size();j<len;j++){
    			int x=qb.front().first;
    			int y=qb.front().second;
    			qb.pop();
    			if(!check(x,y,step)) continue;
    			for(int i=0;i<4;i++){
    				int nx=x+dx[i];
    				int ny=y+dy[i];
    				if(!check(nx,ny,step)) continue;
					if(vis[nx][ny]==2) return step;
    				if(!vis[nx][ny]){
    					vis[nx][ny]=1;
    					qb.push({nx,ny});
					}
				}
			}
		}
		for(int k=0;k<1;k++){
			for(int j=0,len=qg.size();j<len;j++){
				int x=qg.front().first;
				int y=qg.front().second;
				qg.pop();
				if(!check(x,y,step)) continue;
				for(int i=0;i<4;i++){
					int nx=x+dx[i];
					int ny=y+dy[i];
					if(!check(nx,ny,step)) continue;
					if(vis[nx][ny]==1) return step;
					if(!vis[nx][ny]){
						vis[nx][ny]=2;
						qg.push({nx,ny});
					}
					
				}
			}	
		}
	}
    return -1;
}
int main()
{
	int t;
	cin>>t;
	while(t--){
		memset(vis,0,sizeof vis);
		cin>>n>>m;
		int cnt=0;
		for(int i=1;i<=n;i++){
			for(int j=1;j<=m;j++){
				cin>>g[i][j];
				if(g[i][j]=='M') boy={i,j};
				if(g[i][j]=='G') girl={i,j};
				if(g[i][j]=='Z') ghost[cnt++]={i,j};
			}
		}
		cout<<bfs()<<'\n';
	}	
	return 0;
 } 
```

