---
title: select、poll、epoll（IO多路复用）
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img2/104.webp'
tags: ACM冷知识
categories: 算法
mathjax: true
abbrlink: bc5cfa75
date: 2023-10-01 16:49:38
updated:
keywords:
description:
comments:
highlight_shrink:
---


## 功能

三个模型都是用来判断是否有被监听的socket状态发生改变（读写和异常）

## select

首先介绍一下fd_set这个数组，这其实是一个类图，其中每一位表示一个socketfd，哪一位是1表示这一位对应的socket就是被监听的，有三种需要监听的状态，所以就有三个数组，分别是readset，writeset、exceptset，分别监听读写和异常 select原型：

```java
int select(int maxfd, fd_set* readset, fd_set* writeset, fd_set* exceptset, 
const struct timeval* timeout);>
```

1. maxfd表示监听的最大fd（给定了范围） 
2. 三种状态的数组 
3. timeout表示超时时间，当timeout是NULL表示select只有监听到状态发生变化才会结束否则被阻塞，timeout是0表示select非阻塞，立刻返回，timeout&gt;0（数据结构内部有int）表示过一定时间后若还未检测到状态变化就结束 
4. 返回值为状态变化的fd数量，若返回-1表示错误

### 原理

select采用轮询的方法，遍历fd_set的每一位，检查此socket是否有状态变化，若有变化就把这一位置为1，否则置为0，这样操作之后fd_set表示的意义也从“所有socket的列表”变为了“发生状态变化的socket列表”，接下来只需要遍历这个列表即可处理每一种状态，例如有一个socket有读的需求，则遍历到列表中这个fd时就可以调用read函数，当然由于socketfd意义发生变化，每次select前都需要提前备份一下fd_set，之后每次select后再次select，恢复到备份，这样才能保证每一个监听的fd都被遍历到，还需要注意的时timeout每次也需要重置，当select提前结束，此时timeout会变成剩余的时间，下次select需要重新指定

### 缺点

1. 由于select采用轮询的方式，而每次发生状态变化的fd只有几个，更多是非活跃状态的fd，遍历全部花费了太多时间 
2. fd_set内部有最大限制，32位OS最大1024，62位最大2048

## poll

poll只优化了select的几个点

1. poll采用了新的数据结构代替了fd_set，是一个链表，所以最大限制的说法就不复存在了 
2. poll返回值为活跃状态的fd链表，而没有修改监听链表，这样就不需要每次恢复到备份了 但是poll还是采用轮询的方式，效果依旧很差

## epoll

epoll内部采用了红黑树和链表的方式彻底解决了以上问题

1. 红黑树保存所有带监听的fd，不需要像轮询那样遍历许多非监听的fd 
2. 突破了最大限制 epoll会把发生事件的fd放到链表中，只需遍历链表即可处理每一个事件

