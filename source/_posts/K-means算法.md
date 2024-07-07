---
title: 聚类算法
tags:
  - kmeans
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img2/106.webp'
mathjax: true
abbrlink: 35f08535
keywords:
  - kmeans
  - 聚类算法
description: 讲解一些重要的聚类算法
categories: 记录
date: 2023-11-24 14:21:08
updated:
comments:
highlight_shrink:
---

# 一、K-means介绍

K-means算法，也称为K-平均或者K-均值，是一种无监督的聚类算法。对于给定的样本集，按照样本之间的距离大小，将样本划分为K个簇，让簇内的点尽量紧密的连接在一起，而让簇间的距离尽量的大。K-means是一种使用广泛的最基础的聚类算法，通常作为学习聚类算法时的第一个算法。
其他的聚类算法还有：K-medoids、k-modes、Clara、Clarans等

**聚类**：物理或抽象对象的集合分成由类似的对象组成的多个类的过程被称为聚类。由聚类所生成的簇是一组数据对象的集合，这些对象与同一个簇中的对象彼此相似，与其他簇中的对象相异。

**簇**：本算法中可以理解为，把数据集聚类成k类，即k个簇。

**质心**：指各个类别的中心位置，即簇中心。

**距离公式**：常用的有：欧几里得距离（欧氏距离）、曼哈顿距离、闵可夫斯基距离等。

# 二、算法步骤

## 1.文字说明

①.给定一个待处理的数据集；
		②.记K个簇的中心分别为$c1,c2,...,ck$；每个簇的样本数量为$N1,N2,...,N3$；
		③.通过欧几里得距离公式计算各点到各质心的距离，把每个点划分给与其距离最近的质心，从而初步把数据集分为了K类；
		④.更新质心：通过下面的公式来更新每个质心。就是，新的质心的值等于当前该质心所属簇的所有点的平均值。
$$
c_{j}=\frac{1}{N_{j}}\sum_{i=1}^{N{j}}x_{i},y_{i}
$$
⑤.重复步骤3和步骤4，直到质心基本不再变化或者达到最大迭代次数。

## 2.伪代码

```python
导入或创建训练集，设定K值
随机选取K个点作为初始质心（在数据集的范围内）
repeat
    for i=1,2,...,m(m为样本个数）do
       计算K个质心到所有样本的欧式距离
       把样本中的点划分给距离最近的质心
    end for
    for i=1,2,..,k do
       求每一个簇的数据的平均值
       将求出的平均值赋值给各质心
    end for
until 当前质心基本不变或者达到最大迭代次数
```

# 三、图形展示

假设K=2，即有两个簇，绿色为最初的样本数据集（图a），红色标记和蓝色标记分别为两个质心（图b）。通过计算样本到红色质心和蓝色质心的距离，实现对样本的分类，然后再不断地更新质心的位置，最终得到了一个比较理想的聚类结果（图f）。
![](https://img-blog.csdnimg.cn/img_convert/4ffa7521d16a213ad998090a6903dfdb.png)
顺序为：a→b→c→d→e→f
可以看到，整个算法是一个不断更新质心和簇的过程。

# 四、代码实现

```python
import matplotlib.pyplot as plt
from random import uniform
from math import sqrt
import numpy as np


data = [[], []]
n = 50
for i in range(n):
    if i < 20:
        data[0].append(uniform(0, 4))
        data[1].append(uniform(0, 12))
    elif i >= 20 and i < 30:
        data[0].append(uniform(0, 10))
        data[1].append(uniform(0, 10))
    else:
        data[0].append(uniform(9, 12))
        data[1].append(uniform(0, 12))
plt.scatter(data[0], data[1], marker='+')
plt.show()
plt.xlim(0, 12)
plt.ylim(0, 12)
cent = np.empty((3, 2)) # 创建中心
for i in range(3):  # 随机初始化中心
    cent[i][0] = uniform(0, 12)
    cent[i][1] = uniform(0, 12)
dist = np.empty((3, n)) # 距离中心的距离

def distEuclid(x1, y1, x2, y2): # 计算欧几里得距离
    return sqrt(pow(x1-x2, 2) + pow(y1-y2, 2))

def k_means():  # k-means算法
    for step in range(50):
        for i in range(n):
            for j in range(3):  # 计算距离
                dist[j][i]=distEuclid(data[0][i], data[1][i], cent[j][0], cent[j][1])
        sumX = [0, 0, 0]    # 记录距离每一个中心最近的点X和
        sumY = [0, 0, 0]    # 记录距离每一个中心最近的点Y和
        num = [0, 0, 0]     # 记录距离每一个中心最近的点数量
        for i in range(n):
            mi = min(dist[0][i], dist[1][i], dist[2][i])
            for j in range(3):
                if(dist[j][i] == mi):
                    sumX[j] += data[0][i]   # update
                    sumY[j] += data[1][i]
                    num[j] += 1
                    if(step == 49): # 最后一次分配画图
                        c = ''
                        if (j == 0):
                            c = 'g'
                        elif (j == 1):
                            c = 'b'
                        else:
                            c = 'r'
                        plt.scatter(data[0][i], data[1][i], marker='+', color=c)
    for i in range(3):  # 画中心
        plt.scatter(cent[i][0], cent[i][1], marker='*', c='k')
    plt.show()


if __name__ == '__main__':
    k_means()
```

![请添加图片描述](https://img-blog.csdnimg.cn/8d163f326b134233af8e6820311de9ae.png)


# 五、K-means 算法存在的问题

由于K-means算法简单且易于实现，因此K-means算法得到了很多的应用，但是从K-means算法的过程中可以发现两个问题：
1.簇中心的个数K是需要事先给定的，对事先比较了解的数据集可以很好地进行分类，但在处理未知数据时无法确定K的值为多少时更合适，就无从下手或者只能盲目尝试。
2.K-means算法在聚类之前，需要随机初始化K个质心，如果质心选择不好，如上面的图形所示，最后的聚类结果会非常差。

# 六、在线K-means

现实情况中，数据并不是一下子就能全部获得的，通常是以数据流的形式请求，所以在线聚类是很有必要的。

下面是在线聚类的流程：

对于新到来的一个或者一串数据，求出距离数据最近的簇，每个簇都有一个中心点，这个点不一定是样本点，比如一个簇只有两个样本点，则中心点就在两个样本点的中间，是一个虚拟点。

然后把新的数据加入到对应的簇中，更新簇的中心，更新方法有许多，有精度高（时复也高）的，也有精度低（时复也低）的。

## 代码

代码59行利用了“学习率”来更新簇中心，其思想是：当簇中样本点足够多的情况下，新来的点影响就会变小，学习率也就会变小，新点在更新簇中心的公式中，权重变低。

```python
import matplotlib.pyplot as plt
from random import uniform
from math import sqrt
import numpy as np


class OnlineKMeans:
    """ Online K Means Algorithm """

    def __init__(self,
                 num_features: int,
                 num_clusters: int,
                 lr: tuple = None):
        """
        :param num_features: The dimension of the data
        :param num_clusters: The number of clusters to form as well as the number of centroids to generate.
        :param lr: The learning rate of the online k-means (c', t0). If None, then we will use the simplest update
        rule (c'=1, t0=0) as described in the lecture.
        """
        if num_features < 1:
            raise ValueError(f"num_features must be greater or equal to 1!\nGet {num_features}")
        if num_clusters < 1:
            raise ValueError(f"num_clusters must be greater or equal to 1!\nGet {num_clusters}")

        self.num_features = num_features
        self.num_clusters = num_clusters

        self.num_centroids = 0
        self.centroid = np.zeros((num_clusters, num_features))
        self.cluster_counter = np.zeros(num_clusters)  # Count how many points have been assigned into this cluster

        self.num_samples = 0
        self.lr = lr

    def fit(self, X):
        """
        Receive a sample (or mini batch of samples) online, and update the centroids of the clusters
        :param X: (num_features,) or (num_samples, num_features)
        :return:
        """

        if len(X.shape) == 1:
            X = X[np.newaxis, :]
        num_samples, num_features = X.shape

        for i in range(num_samples):
            self.num_samples += 1
            # Did not find enough samples, directly set it to mean
            if self.num_centroids < self.num_clusters:
                self.centroid[self.num_centroids] = X[i]
                self.cluster_counter[self.num_centroids] += 1
                self.num_centroids += 1
            else:
                # Determine the closest centroid for this sample
                sample = X[i]
                dist = np.linalg.norm(self.centroid - sample, axis=1)
                centroid_idx = np.argmin(dist)

                if self.lr is None:
                    self.centroid[centroid_idx] = (self.cluster_counter[centroid_idx] * self.centroid[centroid_idx] +
                                                   sample) / (self.cluster_counter[centroid_idx] + 1)
                    self.cluster_counter[centroid_idx] += 1
                else:
                    c_prime, t0 = self.lr
                    rate = c_prime / (t0 + self.num_samples)
                    # rate = self.lr
                    self.centroid[centroid_idx] = (1 - rate) * self.centroid[centroid_idx] + rate * sample
                    self.cluster_counter[centroid_idx] += 1

    def predict(self, X):
        """
        Predict the cluster labels for each sample in X
        :param X: (num_features,) or (num_samples, num_features)
        :return: Returned index starts from zero
        """
        if len(X.shape) == 1:
            X = X[np.newaxis, :]
        num_samples, num_features = X.shape

        clusters = np.zeros(num_samples)
        for i in range(num_samples):
            sample = X[i]
            dist = np.linalg.norm(self.centroid - sample, axis=1)
            clusters[i] = np.argmin(dist)
        return clusters

    def fit_predict(self, X):
        """
        Compute cluster centers and predict cluster index for each sample.
        :param X: (num_features,) or (num_samples, num_features)
        :return:
        """
        # Because the centroid may change in the online setting, we cannot determine the cluster of each label until
        # we finish fitting.
        self.fit(X)
        return self.predict(X)

    def calculate_cost(self, X):
        """
        Calculate the KMean cost on the dataset X
        The cost is defined in the L2 distance.

        :param X: (num_features,) or (num_samples, num_features) the dataset
        :return: The cost of this KMean
        """

        if len(X.shape) == 1:
            X = X[np.newaxis, :]
        num_samples, num_features = X.shape

        cost = 0
        for i in range(num_samples):
            # Determine the closest centroid for this sample
            sample = X[i]
            dist = np.linalg.norm(self.centroid - sample, axis=1)
            cost += np.square(np.min(dist))

        return cost

# 生成一组随机数据
X = np.concatenate([np.random.normal(loc=0, scale=1, size=(100, 2)),
                    np.random.normal(loc=5, scale=1, size=(100, 2))])

# 创建 OnlineKMeans 对象
num_clusters = 3
online_kmeans = OnlineKMeans(num_features=2, num_clusters=num_clusters, lr=(1, 0))

# 遍历数据，逐步进行在线聚类
for i in range(len(X)):
    online_kmeans.fit(X[i])

# 预测聚类结果
predictions = online_kmeans.predict(X)

# 绘制数据点和聚类中心
plt.scatter(X[:, 0], X[:, 1], c=predictions, cmap='viridis', alpha=0.5)
plt.scatter(online_kmeans.centroid[:, 0], online_kmeans.centroid[:, 1], marker='X', s=200, c='red')
plt.title("Online K-Means Clustering")
plt.xlabel('Feature 1')
plt.ylabel('Feature 2')
plt.show()
```

















