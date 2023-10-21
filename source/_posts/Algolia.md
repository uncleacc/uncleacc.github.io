---
title: Shoka主题配置Algolia搜索
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img/textbg/91.webp'
date: 2020-12-25 21:21:41
tags: hexo
categories: 技术
mathjax: 
updated: 
keywords: 
description: 
comments: 
highlight_shrink: 
---

> 原来使用的Sakura主题已经没人维护了，写作时因为没有集成插件很多标签都没有，因此写出来的文章就比较丑，最重要的原因还是shoka这个主题太好看了，个人实在是喜欢(❤ ω ❤)，忍不住就咕哝了两天，在这里记录一下迁移过程遇到最棘手的问题Algolia的配置吧。

:::success

`主题优点`

先给新主题shoka打个广告，继承了许多优秀插件，尤其是写作标签非常多，[写作标签介绍](https://shoka.lostyu.me/computer-science/note/theme-shoka-doc/special/)，就光这一点就足够吸引我了，其次就是好看，贼好看，这个布局确实是让人看着赏心悦目，而且配置简单，因为很多东西都集成了，就方便了很多操作。

:::

回归主题，由于以前没用过algolia，导致我还得去网上查资料一点一点学，好在最后弄好了。

## Algolia配置

1. 首先第一步就是安装hexo-algolia，右击博客根目录输入`npm i hexo-algolia`

2. 打开网页[algolia](https://www.algolia.com/)，注册账户，新建一个Indice，名字随便起，然后根据提示完成后续工作，大致就是让你选择根据什么来搜索

3. 之后在左侧导航栏中找到`Api Keys`

   ![](https://cdn.jsdelivr.net/gh/uncleacc/Sucai/20201225213848.png "Algolia")

4. 点击All API Keys，然后点击右上角New API Key，新建一个API Key，因为默认给的Only search权限不够只能搜索却不能通过这个API向服务器传输数据，indice选择刚才新建的那个

   ![](https://cdn.jsdelivr.net/gh/uncleacc/Sucai/20201225214129.png "API")

5. 之后在博客根目录`config.yml`中，找到`algolia`的相关配置，然后添加`applicationID`属性，`appID`不要删(主题JS需要)，这两个虽然是一样的，但是因为hexo-algolia会自动去config.yml文件中寻找applicationID字眼而不是appID，因此不加上applicationID会报错，之后填上相应的值，这里注意`apiKey`可以填刚新添加的APIKEY，也可以填这里`Search-Only APIKEY`，刚才创建的用处不在这里

   ![](https://cdn.jsdelivr.net/gh/uncleacc/Sucai/20201225220935.png "algolia")

5. 之后在博客根目录右击`git bash`，输入`export HEXO_ALGOLIA_INDEXING_KEY="你刚才新创建的APIKEY"`，这里一定要是你新创建的不能是Search-Only APIKEY，否则权限不够无法上传索引，之后输入`hexo algolia`，即可成功上传，并在algolia后台中看到上传的索引

   ![](https://cdn.jsdelivr.net/gh/uncleacc/Sucai/20201225222422.png "algolia")![](https://cdn.jsdelivr.net/gh/uncleacc/Sucai/20201225224116.png "索引")

6. 在搜索框中输入即可看到结果了

   ![](https://cdn.jsdelivr.net/gh/uncleacc/Sucai/20201225223941.png "algolia")

[:heavy_check_mark:完美解决]{.label .success}

## 补充

Algolia是一款很强大的搜索服务，打开`Indices`，点击`configuration`，找到`Searchable attributes`，在里面可以定制搜索凭借，例如你添加了`content`，之后输入的内容就会去和文章内容进行匹配之后出来结果，还是很强大的，不过如果你添加了content默认hexo-algolia插件是不上传文章内容的，也就是说你必须修改hexo-algolia插件Js内容来上传content，具体操作是打开目录:`shoka\node_modules\hexo-algolia\lib`，修改`command.js`，输入关键词var INDEXED_PROPERTIES = [查找，然后在[]中添加要上传的内容，不要删除里面的内容，因为可能会报错！

:::warning

[一定认真阅读主题官方文档！一定认真阅读主题官方文档！一定认真阅读主题官方文档！]{.rainbow}

:::
