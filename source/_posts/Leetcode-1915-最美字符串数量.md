---
title: Leetcode-1915-最美字符串数量
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img2/101.webp'
tags: 状压+前缀异或和
categories: 题目
mathjax: true
date: 2021-09-05 16:30:11
updated: 
keywords: 
description: 
comments: 
highlight_shrink: 
---

## [最美子字符串的数目](https://leetcode-cn.com/problems/number-of-wonderful-substrings/)

美丽的字符串定义为该字符串**至多一个**字母出现**奇数**次，给定一个字符串求该字符串包含多少个美丽的子串。（该字符串由前十个小写英文字母组成）

由于只会由前10个字母组成，所以可以把所有的字符当作一个二进制位，0表示该字符出现了偶数次，1代表字符出现了奇数次，那么现在好的状态就变成了0和2^i^，我们从前往后遍历字符串，求一个前缀异或状态，两个前缀异或起来即可得到一段区间的状态，那么问题就转化为了所有的位置前面有多少个状态和当前状态异或后是一个好的状态，如此我们就可以开一个数组cnt[i]记录从起始位置到当前位置i状态出现的次数，ans+=cnt[good^state]即是答案，good是一个好的状态，state是当前状态。

```c++
class Solution {
public:
    long long wonderfulSubstrings(string word) {
		long long res=0;
		int cnt[1025];
		memset(cnt,0,sizeof cnt);
		vector<int> good;
		good.push_back(0);
		for(int i=0;i<10;i++) good.push_back(1<<i);
		int len=word.size(),state=0;
		cnt[0]=1;
		for(int i=0;i<len;i++){
			int now=1<<(word[i]-'a');
			state^=now;
			for(auto p:good){
				res+=cnt[p^state];
			}
			cnt[state]++;
		}
		return res;
    }
};
```

