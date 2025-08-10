---
title: Cookie技术介绍
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img2/131.webp'
mathjax: true
categories: 记录
abbrlink: 244d313a
keywords: Cookie
description: 记录Cookie的学习
date: 2025-02-03 11:00:12
tags:
updated:
comments:
highlight_shrink:
---
> 摘要：
>
> 这篇文章围绕Cookie技术，从诞生背景、数据流转、属性、数量限制及客户端操作等方面展开介绍，核心要点如下： 
>
> 1. **诞生背景**：HTTP协议无状态，为解决服务端识别客户端身份问题，Cookie应运而生，它存储在客户端，由服务器发送，下次请求时携带至服务器，且不可跨站，每个Cookie绑定特定域名，同域名不同端口可共享。 
> 2. **数据流转**：首次访问网站，浏览器请求无Cookie；服务端响应头加Set - Cookie；浏览器保存；再次访问，请求头携带Cookie。 
> 3. **有效期与作用域**：默认有效期短，随浏览器会话结束消失，与sessionStorage作用域不同。可设max - age延长有效期。作用域由文档源和路径确定，可通过path和domain属性配置。 
> 4. **常见属性**：    
>
>    - **name = value**：键值对，值为Unicode或二进制数据需编码。    
>
>    - **domain**：决定Cookie生效域名，默认当前域名，设为父域名可在子域名生效。    
>
>    - **path**：限制Cookie生效路径，默认“/”。    
>
>    - **expires**：过期时间（GMT格式），客户端与服务器时间不一致时会有偏差。    
>
>    - **Max - age**：存活时间（秒），正数表示生效秒数，负数为临时Cookie，0表示删除，优先级高于expires。    
>
>    - **HttpOnly**：设此属性，js无法读写Cookie，一定程度防CSRF攻击。    
>
>    - **secure**：指定是否仅用安全协议传输，默认为false。    
>
>    - **SameSite**：确定是否允许跨站请求发送Cookie。    
>
>    - **Priority**：Cookie数量超限时，按此属性定义的优先级清除，有Low、Medium、High三种。 
> 5. **个数限制**：Chrome和Safari无硬性限制，Firefox、IE等有不同数量限制，RFC 2965标准规定浏览器最多保存300个Cookie，每个服务器不超20个，单个Cookie不超4KB，部分现代浏览器仍有4KB大小限制。 
> 6. **客户端存取**：    
>    - **读取**：`document.cookie`获取，返回字符串，由键值对组成，不含其他属性。    
>    - **设置**：用`document.cookie`添加，值含特殊字符需`encodeURIComponent()`编码。    
>    - **更新**：同名、路径和域，新值和max - age属性可改变Cookie。    
>    - **删除**：同名、路径和域，设任意值，`max - age`为0。 

# 了解 Cookie

- Cookie 最开始被设计出来是为了弥补HTTP在状态管理上的不足。HTTP 协议是一个无状态协议，客户端向服务器发请求，服务器返回响应，故事就这样结束了，但是下次发请求如何让服务端知道客户端是谁呢？这种背景下，就产生了 Cookie。
- cookie 存储在客户端： cookie 是服务器发送到用户浏览器并保存在本地的一小块数据，它会在浏览器下次向同一服务器再发起请求时被携带并发送到服务器上。因此，服务端脚本就可以读、写存储在客户端的cookie的值。
- cookie 是不可**跨站**的： 每个 cookie 都绑定在特定的域名下（绑定域名下的子域都是有效的），无法在别的域名下获取使用，同域名不同端口也允许共享。（跨域不等于跨站）

# Cookie 的数据流转

1. 在首次访问网站时，浏览器发送请求中并未携带Cookie。
2. 服务端看到请求中未携带Cookie，在HTTP的响应头中加入Set-Cookie。
3. 浏览器收到Set-Cookie后，会将Cookie保存下来
4. 下次再访问该网站时，HTTP请求头就会携带Cookie。

![image-20250203110352403](https://cdn.jsdelivr.net/gh/uncleacc/sucai_2/img/image-20250203110352403.png)

![image-20250203110421752](https://cdn.jsdelivr.net/gh/uncleacc/sucai_2/img/image-20250203110421752.png)

Cookie都是name=value的结构，具体格式如下：

`Set-Cookie: "name=value;domain=.domain.com;path=/;expires=Sat, 11 Jun 2016 11:29:42 GMT;HttpOnly;secure"`

# cookie属性：有效期和作用域

cookie默认的有效期很短暂，它只能维持在Web浏览器的会话期间，一旦用户关闭浏览器，cookie保存的数据就丢失了。要注意的是，这与sessionStorage的有效期还是有区别的：cookie的作用域不是局限在浏览器的单个窗口中，它的有效期和整个浏览器进程而不是单个浏览器窗口的有效期一致。如果想要延长cookie的有效期，可以通过设置max-age属性。一旦设置了有效期，浏览器就会将cookie数据存储在一个文件中，并且直到过了指定的有效期才会删除该文件。

cookie的作用域是通过文档源和文档路径来确定的。该作用域通过cookie的path和domain属性可配置。

# Cookie常见属性

|属性|说明|
|--|--|
|name=value|键值对，设置 Cookie 的名称及相对应的值，都必须是字符串类型（name 不区分大小写）<br> - 如果值为 Unicode 字符，需要为字符编码。<br> - 如果值为二进制数据，则需要使用 base64 编码。|
|domain|Cookie 生效的域名，即 Cookie 在哪个网站生效。默认当前访问域名。<br>例如我们在 a.jzplp.com 下设置的 Cookie，就只在这个域名下生效。但是如果我们设置了 domain=jzplp.com，则该 Cookie 可以在 jzplp.com 下的任何域名内生效。比如：jzplp.com，a.jzplp.com, b.jzplp.com。<br>domain 只能设置为当前服务器的域。|
|path|有时候，我们希望 Cookie 仅仅在部分路径下生效，就可以使用 Path 进行限制。这里的路径就是网站的路由。默认的 path=/，即在所有路径下生效。 如果设置了 path=/abc，则只在 /abc 路径下生效。比如：<br> jzplp.com 不生效<br> jzplp.com/abc 生效<br> jzplp.com/abc/def 生效<br> jzplp.com/qaz 不生效<br> jzplp.com/qaz/abc 不生效|
|expires|过期时间（GMT 时间格式），当浏览器端本地的当前时间超过这个时间时，Cookie 便会失效。<br>如果客户端和服务器时间不一致，使用 expires 就会存在偏差。<br>一般浏览器的 cookie 都是默认储存的，当关闭浏览器结束这个会话的时候，cookie 会被删除。<br>Expires 格式：Expires=Wed, 21 Oct 2015 07:28:00 GMT。|
|Max - age|cookie 存活时间，单位秒。如果为正数，则该 cookie 在 maxAge 秒后失效。如果为负数，该 cookie 为临时 cookie ，关闭浏览器即失效，浏览器也不会以任何形式保存该 cookie。如果为 0，表示删除该 cookie 。默认为 -1。<br>优先级高于 expires |
|HttpOnly|如果给某个 cookie 设置了 httpOnly 属性，则无法通过 js 读写该 cookie 的信息，但还是能通过 Application 中手动修改 cookie，所以只是在一定程度上可以防止 CSRF 攻击，不是绝对的安全|
|secure|该 cookie 是否仅被使用安全协议传输。安全协议有 HTTPS，SSL 等，在网络上传输数据之前先将数据加密。默认为 false。<br>当 secure 值为 true 时，cookie 在 HTTP 中是无效的。|
|SameSite|是否允许跨站请求时发送 Cookie|
|Priority|当 Cookie 的数量超过限制时，路蓝旗会清除一部分 Cookie。清除哪些合适呢？Priority 属性用来定义 Cookie 的优先级，低优先级的 Cookie 会优先被清除。<br>Priority 属性有三种： Low, Medium, High。|

cookie集合中的每个cookie都拥有这些属性，而且每个cookie的这些属性都是独立分开的，各自控制各自的cookie。

# 每个域名下cookie个数限制

Chrome和Safari没有做硬性限制
Firefox最多50个cookie
IE7和之后的版本最后可以有50个cookie
IE6或更低版本最多20个cookie
RFC 2965标准不允许浏览器保存超过300个cookie，为每个Web服务器保存的cookie数不能超过20个（是对整个服务器而言，而不仅仅指服务器上的页面和站点），而且，每个cookie保存的数据不能超过4KB。实际上，现代浏览器允许cookie总数超过300个，但是部分浏览器对单个cookie大小仍然有4KB的限制。

# 客户端对Cookie的存取

1. 读取cookie：

可以用 document.cookie 获取当前页面可用的cookie集合，其返回的值是一个字符串，该字符串都是由一系列键/值对组成，不同键/值对之间通过“分号和空格”分开。例如：

```
document.cookie;
// "name1=value1; name2=value2"
```

这些返回的cookie值并不包含键/值以外的其他cookie属性。

2. 设置cookie:

```
document.cookie = `name=${encodeURIComponent(name)}; max-age=1000;`;
```

name这个cookie会被添加到现有的cookie集合中。

由于cookie的键/值中的值是不允许包含分号、逗号和空白符，因此，在存储前一般可以采用 encodeURIComponent() 函数对值进行编码。相应的，读取cookie值的时候要用 decodeURIComponent() 函数解码。

3. 更新cookie

要改变cookie的值，需要使用相同的名字、路径和域，但是新的值重新设置cookie的值。同样地，设置新 max-age 属性就可以改变原来的cookie的有效期。

4. 删除cookie

要删除一个cookie，需要使用相同的名字、路径和域，然后指定一个任意（非空）的值，并且将 max-age 属性指定为0，再次设置cookie。

# 参考文献

[Cookie详解：原理、属性与操作-CSDN博客](https://blog.csdn.net/huangpb123/article/details/109107461)