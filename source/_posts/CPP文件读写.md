---
title: CPP文件读写
tags: 文件读写
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img2/102.webp'
categories: 记录
abbrlink: 96d45fb1
keywords: 文件读写
description: 记录C++文件读写操作
date: 2023-10-22 11:55:49
mathjax:
updated:
comments:
highlight_shrink:
---



# 文件读写

## 头文件

`#include <fstream>`

## 操作

- 声明定义：
  - 读取：ifstream inFile
  - 写出：ofstream outFile

- 打开文件：inFile.open("file name", ios::in)  (ios::in、ios::out、ios::app)
  - 判断是否打开成功：bool inFile.is_open()
- 读出文件一行内容写入string：getline(inFile, str)
- string写出到文件：outFile << str << endl;
- 关闭文件：inFile.close

`示例程序:文件夹下所有文件中csdn图片链接提取出来`



```cpp
#include <bits/stdc++.h>
#include <string>
#include <cstring>
#include <dirent.h>
#include <fstream>
using namespace std;

const char *inFolderPath = "C:\\Users\\60116\\Desktop\\_posts\\";
// const char *outFolderPath = "C:\\Users\\60116\\Desktop\\out\\";

vector<string> res;

void dealwith(string str) {
    if(str.find("csdn") == string::npos) return ;

    int pos = str.find("csdn"), startIndex = -1, endIndex = -1;
    while(pos--) {
        if(str.substr(pos, 5) == "https") {
            startIndex = pos;
            break;
        }
    }

    while(pos < str.size() && pos++) {
        if(str.substr(pos, 4) == ".png" || str.substr(pos, 4) == ".jpg") {
            endIndex = pos + 4;
            break;
        }
    }

    if(startIndex != -1 && endIndex != -1) {
        res.push_back(str.substr(startIndex, endIndex - startIndex));
    }
    return ;
}

void work(char *inPrefix, char *fileName) {
    res.push_back(fileName);

    char inFilePath[500];
    strcpy(inFilePath, inPrefix);
    strcat(inFilePath, fileName);

    // char outFilePath[500];
    // strcpy(outFilePath, outPrefix);
    // strcat(outFilePath, fileName);

    ifstream inFile(inFilePath, ios::in);

    if(!inFile.is_open()) {
        cout << "in error" << endl;
        return ;
    }

    string line;

    //读取文件每一行数据进行处理
    while(getline(inFile, line)) {
        dealwith(line);
    }

    inFile.close();
}

int main() {
    ofstream outFile("C:\\Users\\60116\\Desktop\\out.txt", ios::out);

    if(!outFile.is_open()) {
        cout << "out error" << endl;
        return -1;
    }

    DIR *dir;
    struct dirent *ent;

    if ((dir = opendir(inFolderPath)) != NULL) {
        int cnt = 0;
        while ((ent = readdir(dir)) != NULL) {
            // 忽略 . 和 .. 条目
            if (strcmp(ent->d_name, ".") == 0 || strcmp(ent->d_name, "..") == 0) {
                continue;
            }

            char curInFolderPath[500];
            strcpy(curInFolderPath, inFolderPath);
            
            // char curOutFolderPath[500];
            // strcpy(curOutFolderPath, outFolderPath);

            work(curInFolderPath, ent->d_name);

            ++cnt;
            
            // break;
        }
        cout << "total: " << cnt << endl;
        closedir(dir);
    } else {
        std::cerr << "cannot open this dir" << std::endl;
        return 1;
    }

    for(auto p: res) {
        outFile << p << endl;
    }
    outFile.close();


    return 0;
}

```

## 遍历文件夹下所有文件

```cpp
#include <dirent.h>

DIR *dir;
struct dirent *ent;

if ((dir = opendir(inFolderPath)) != NULL) {
    int cnt = 0;
    while ((ent = readdir(dir)) != NULL) {
        // 忽略 . 和 .. 条目
        if (strcmp(ent->d_name, ".") == 0 || strcmp(ent->d_name, "..") == 0) {
            continue;
        }

        ++cnt;
    }
    cout << "total: " << cnt << endl;
    closedir(dir);
} else {
    std::cerr << "cannot open this dir" << std::endl;
    return 1;
}
```

