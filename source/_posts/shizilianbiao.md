---
title: 十字链表存储稀疏矩阵
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img/textbg/89.webp'
date: 2020-12-03 22:00:40
categories: 算法
tags: 数据结构
mathjax: 
updated: 
keywords: 
description: 
comments: 
highlight_shrink: 
---

> 课程设计
>
> **问题描述:**    用十字链表存储稀疏矩阵，实现两个可进行矩阵之间的乘法运算。 
>
> **基本要求:** （1）要对两个矩阵能否进行乘法进行判断。（2）对能够进行乘法运算的稀疏矩阵进行乘法运算并输出正确的结果。

[**参考博客**](https://blog.csdn.net/zhuyi2654715/article/details/6729783)

## 大致思路

一般矩阵中会有很多值为0的元素，十字链表把这些值给忽略掉了，只存有值不为0的元素，每一行都是一个链表，每一列也是一个链表，用一个行指针、一个列指针指向它们，形成矩阵形式

## 数据类型

```c
typedef struct OLNode{  //元素类型
	int row,col;  //行列
	ElemType val;  //数值
	OLNode *right,*down;  //行指针、列指针
}*OLink; 
struct CrossList{  //矩阵结构
	int n,m,num;
	OLink *Rhead,*Chead;  //指向行链表、列链表的指针
};
```

## 初始化指针

每次都要先把矩阵指针置为空

```c
void InitCrossList(CrossList &CL){
	CL.n=CL.m=CL.num=0;
	CL.Rhead=CL.Chead=NULL;
}
```

## 销毁链表

```c
void DestroyCrossList(CrossList CL){
	int n=CL.n,m=CL.m;
	OLink temp;
	for(int i=1;i<=n;i++){
		OLink p=CL.Rhead[i];
		while(p){
			temp=p;
			delete temp;
			p=p->right;
		}
	}
	delete CL.Rhead;
	delete CL.Chead;
	CL.Rhead=NULL;
	CL.Chead=NULL;
	CL.n=CL.m=CL.num=0;
}
```

## 创建链表



```c
void CreateCrossList(CrossList &CL){
	if(CL.Rhead) DestroyCrossList(CL);  //矩阵不为空先销毁
	cout<<"请输入十字链表的行数、列数、非零元个数(空格隔开):\n";
	int n,m,num;
	while(cin>>n>>m>>num){  
		if(n>=1 && m>=1 && num>=1 && num<=n*m) break;  //行数列数不能小于1，非零元个数不能大于矩阵最大容纳量
		cout<<"输入有误，请重新输入:\n";
	}
	CL.n=n; CL.m=m; CL.num=num;  //矩阵行数，列数，非零元个数
	CL.Rhead=new OLink[m+1];  //给每一行分配链表
	if(!CL.Rhead){
		cout<<"内存不足\n";
		exit(-1);
	}
	CL.Chead=new OLink[n+1];  //给每一列分配链表
	if(!CL.Chead) {
		cout<<"内存不足\n";
		exit(-1);
	}
	for(int i=1;i<=n;i++) CL.Rhead[i]=NULL;  //初始化为空
	for(int i=1;i<=m;i++) CL.Chead[i]=NULL;
	for(int i=0;i<num;i++){
		int row,col,val;
		cout<<"请输入第"<<i+1<<"个非零元的横坐标、纵坐标、不为0的值(空格隔开):\n";
		while(cin>>row>>col>>val){
			if(row>=1 && row<=n && col>=1 && col<=m && val) break;  //坐标不能超出矩阵，值不能为0
			cout<<"输入有误，请重新输入:\n";
		} 
		OLink p=new OLNode;
		if(!p){
			cout<<"内存不足\n";
			exit(-1);
		}
		p->row=row; p->col=col; p->val=val;
		if(CL.Rhead[row]==NULL || CL.Rhead[row]->col>col){
			p->right=CL.Rhead[row];
			CL.Rhead[row]=p;
		}
		else{
			OLink j;
			for(j=CL.Rhead[row];j->right && j->right->col<=col;j=j->right);  //找到插入位置
			if(j->col==col){  //当当前坐标有值时覆盖它
				j->val=val;
				continue;
			}
			p->right=j->right;
			j->right=p;
		}
		if(CL.Chead[col]==NULL || CL.Chead[col]->row>row){
			p->down=CL.Chead[col];
			CL.Chead[col]=p;
		}
		else{
			OLink j;
			for(j=CL.Chead[col];j->down && j->down->row<row;j=j->down);  //找到插入位置
			p->down=j->down;
			j->down=p;
		}
	}
}
```

## 打印链表

```c
void PrintCrossList(CrossList CL){
	cout<<"------------------------\n";
	int n=CL.n,m=CL.m;
	for(int i=1;i<=n;i++){
		cout<<"第"<<i<<"行元素:  ";
		OLink p=CL.Rhead[i];
		if(p){
			while(p){
				cout<<p->val<<"("<<p->row<<","<<p->col<<")"<<"  ";
				p=p->right;
			}
		}
		else cout<<"空";
		cout<<'\n';
	}
	cout<<'\n';
	for(int i=1;i<=m;i++){
		cout<<"第"<<i<<"列元素:  ";
		OLink p=CL.Chead[i];
		if(p){
			while(p){
				cout<<p->val<<"("<<p->row<<","<<p->col<<")"<<"  ";
				p=p->down;
			}	
		}
		else cout<<"空";
		cout<<'\n';
	}
	cout<<"------------------------\n";
}
```

## 矩阵相乘

这里用一个二维数组去存了

```c
void multiCrossList(CrossList CL1,CrossList CL2){
    if(CL1.m!=CL2.n){
    	cout<<"矩阵无法相乘\n";
    	return ;
	}
	for(int i=1;i<=CL1.n;i++){
		for(int j=1;j<=CL2.m;j++){
			int num=0;
			OLink p=CL1.Rhead[i];
			while(p){
				OLink q=CL2.Chead[j];
				while(q && q->row<p->col){
					q=q->down;
				}
				if(q && q->row==p->col){
					cout<<p->val<<' '<<q->val<<'\n';
					num+=p->val*q->val;
				}
				p=p->right;
			} 
			mat[i][j]=num;
		}
	}
} 
```

## 主函数

```c
int main()
{
	CrossList CL1,CL2;
	InitCrossList(CL1);
	InitCrossList(CL2);
	cout<<"创建矩阵1:\n";
	CreateCrossList(CL1); 
	cout<<"创建矩阵2:\n";
	CreateCrossList(CL2);
	cout<<"\n创建矩阵1如下:\n";
	PrintCrossList(CL1);
	cout<<"\n创建矩阵2如下:\n";
	PrintCrossList(CL2);
	multiCrossList(CL1,CL2);
	cout<<"\n相乘后矩阵:\n";
	PrintResult();
	return 0;
}
```

## 测试数据

```txt
2 2 2
1 1 1
2 2 2
2 3 5
1 1 1
1 2 2
1 3 1
2 1 3
2 3 -1
```

|  1   |  0   |
| :--: | :--: |
|  0   |  2   |

|  1   |  2   |  1   |
| :--: | :--: | :--: |
|  3   |  0   |  -1  |

结果

|  1   |  2   |  1   |
| :--: | :--: | :--: |
|  6   |  0   |  0   |

