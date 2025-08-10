---
title: sql语法
cover: 'https://cdn.jsdelivr.net/gh/uncleacc/Img2/133.webp'
mathjax: true
tags: sql语法
categories: 记录
abbrlink: 56483af3
keywords: sql
description: 记录了与sql相关的语法
date: 2025-02-25 23:33:33
updated:
comments:
highlight_shrink:
---

# Sql语句执行顺序

1. from
2. join
3. where
4. group by
5. having
6. select
7. distinct
8. order by
9. limit/offset

# Case和If

`CASE` 表达式有两种形式：简单 `CASE` 表达式和搜索式 `CASE` 表达式。

- **简单 `CASE` 表达式**：

```sql
CASE 表达式
    WHEN 值1 THEN 结果1
    WHEN 值2 THEN 结果2
    ...
    ELSE 结果N
END
```

它将一个表达式与多个值进行比较，根据匹配情况返回相应的结果。

- **搜索式 `CASE` 表达式**：

```sql
CASE
    WHEN 条件1 THEN 结果1
    WHEN 条件2 THEN 结果2
    ...
    ELSE 结果N
END
```

可以使用更复杂的条件进行判断，依次检查每个 `WHEN` 子句中的条件，当某个条件为 `TRUE` 时，返回对应的结果。

`IF` 函数接受三个参数，当条件为 `TRUE` 时返回 `结果1`，当条件为 `FALSE` 时返回 `结果2`。

```sql
IF(条件, 结果1, 结果2)
```

- 

# Group by

- **核心作用**：将数据按指定列分组，每组返回一行结果。
- **关键规则**：`SELECT` 中的非聚合字段必须出现在 `GROUP BY` 中。

---

## 单字段分组
示例表 `Sales`

| order_id | product | category    | amount |
| -------- | ------- | ----------- | ------ |
| 1        | A       | Electronics | 100    |
| 2        | B       | Books       | 50     |
| 3        | A       | Electronics | 200    |
| 4        | C       | Books       | 30     |

按 `category` 统计销售额

```sql
SELECT category, SUM(amount) AS total_sales
FROM Sales
GROUP BY category;
```

结果

| category    | total_sales |
| ----------- | ----------- |
| Electronics | 300         |
| Books       | 80          |

---

## 多字段分组
按 `category` 和 `product` 统计销量

```sql
SELECT category, product, COUNT(*) AS sales_count
FROM Sales
GROUP BY category, product;
```

结果

| category    | product | sales_count |
| ----------- | ------- | ----------- |
| Electronics | A       | 2           |
| Books       | B       | 1           |
| Books       | C       | 1           |

---

## 结合聚合函数
常用聚合函数：

- `SUM()`：求和
- `AVG()`：平均值
- `COUNT()`：计数
- `MAX()/MIN()`：最大/最小值

示例：计算每个产品的平均销售额

```sql
SELECT product, AVG(amount) AS avg_amount
FROM Sales
GROUP BY product;
```

---

## 过滤分组结果（HAVING）
筛选总销售额 > 100 的类别

```sql
SELECT category, SUM(amount) AS total_sales
FROM Sales
GROUP BY category
HAVING SUM(amount) > 100;
```

结果

| category    | total_sales |
| ----------- | ----------- |
| Electronics | 300         |

---

## 常见错误与注意事项
错误1：选择未聚合的字段

```sql
-- 错误写法（product 未在 GROUP BY 中）
SELECT category, product, SUM(amount)
FROM Sales
GROUP BY category;
```
**报错**：`Column 'product' is invalid in the select list...`

错误2：WHERE 与 HAVING 混淆

- **`WHERE`**：在分组前过滤行。
- **`HAVING`**：在分组后过滤组。

其他注意事项：

1. **NULL 值处理**：`GROUP BY` 将 `NULL` 视为同一分组。
2. **性能优化**：大表分组时，确保分组字段有索引。
3. **结果顺序**：分组结果默认无序，需用 `ORDER BY` 明确排序。

---

## 综合示例
统计每个类别下销量超过1次的商品

```sql
SELECT 
    category, 
    product, 
    COUNT(*) AS sales_count,
    SUM(amount) AS total_sales
FROM Sales
WHERE amount > 0  -- 先过滤无效金额
GROUP BY category, product
HAVING COUNT(*) > 1
ORDER BY total_sales DESC;
```

# DISTINCT

对单列数据去重：假设有一个 `Employees` 表，包含 `employee_id`、`employee_name` 和 `department` 列，现在要查询不同的部门名称。

对多列数据组合去重：若要查询不同的员工姓名和部门的组合。

与聚合函数一起使用：`DISTINCT` 可以与聚合函数（如 `COUNT`、`SUM` 等）一起使用，用于统计不同值的数量或对不同值进行求和。

# UNION

>  注意：使用 `union` 组合查询时，只能使用一条 `order by` 字句，他必须位于最后一条 `select` 语句之后

`UNION` 运算符将两个或更多查询的结果组合起来，并生成一个结果集，其中包含来自 `UNION` 中参与查询的提取行。

`UNION` 基本规则：

- 所有查询的列数和列顺序必须相同。
- 每个查询中涉及表的列的数据类型必须相同或兼容。
- 通常返回的列名取自第一个查询。

默认地，`UNION` 操作符选取不同的值。如果允许重复的值，请使用 `UNION ALL`。



```
SELECT column_name(s) FROM table1
UNION ALL
SELECT column_name(s) FROM table2;
```

`UNION` 结果集中的列名总是等于 `UNION` 中第一个 `SELECT` 语句中的列名。

`JOIN` vs `UNION`：

- `JOIN` 中连接表的列可能不同，但在 `UNION` 中，所有查询的列数和列顺序必须相同。
- `UNION` 将查询之后的行放在一起（垂直放置），但 `JOIN` 将查询之后的列放在一起（水平放置），即它构成一个笛卡尔积。

`UNION` 运算符将两个或更多查询的结果组合起来，并生成一个结果集，其中包含来自 `UNION` 中参与查询的提取行。

`UNION` 基本规则：

- 所有查询的列数和列顺序必须相同。
- 每个查询中涉及表的列的数据类型必须相同或兼容。
- 通常返回的列名取自第一个查询。

默认地，`UNION` 操作符选取不同的值。如果允许重复的值，请使用 `UNION ALL`。

```sql
SELECT column_name(s) FROM table1
UNION ALL
SELECT column_name(s) FROM table2;
```

`UNION` 结果集中的列名总是等于 `UNION` 中第一个 `SELECT` 语句中的列名。

`JOIN` vs `UNION`：

- `JOIN` 中连接表的列可能不同，但在 `UNION` 中，所有查询的列数和列顺序必须相同。
- `UNION` 将查询之后的行放在一起（垂直放置），但 `JOIN` 将查询之后的列放在一起（水平放置），即它构成一个笛卡尔积。

# Replace

1. Replace 函数

`REPLACE` 函数用于在字符串中替换指定的子字符串。它会将字符串中所有出现的指定旧子字符串替换为新的子字符串。

```sql
REPLACE(str, old_substr, new_substr)
```

- `str`：要进行替换操作的原始字符串。
- `old_substr`：需要被替换的旧子字符串。
- `new_substr`：用于替换旧子字符串的新子字符串。

2. Replace into

`REPLACE INTO` 语句用于向表中插入数据，如果插入的数据对应的主键或唯一索引已经存在，则先删除原有的记录，然后再插入新的记录；如果不存在，则直接插入新记录。



3. **示例**

```sql
-- 创建一个示例表
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(50)
);

-- 插入示例数据
INSERT INTO Users (user_id, user_name)
VALUES (1, 'Alice');

-- 使用 REPLACE INTO 语句更新已存在的记录
REPLACE INTO Users (user_id, user_name)
VALUES (1, 'Bob');

-- 查询更新后的记录
SELECT * FROM Users;
```

在上述示例中，由于 `user_id` 为 1 的记录已经存在，`REPLACE INTO` 语句会先删除原有的记录，然后插入新的记录，将 `user_name` 更新为 `'Bob'`。

```sql
UPDATE examination_info
SET tag = REPLACE(tag,'PYTHON','Python')

# REPLACE (目标字段，"查找内容","替换内容")
```

把**examination_info**表中`tag`为`PYTHON`的`tag`字段全部修改为`Python`。

# USING

`USING` 关键字主要用于简化表连接操作，特别是在进行 `JOIN` 操作时，它可以让代码更加简洁。

假设有两个表：`Orders` 表和 `Customers` 表，它们都有一个名为 `customer_id` 的列，用于关联订单和客户信息。

```sql
-- 创建 Customers 表
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    customer_email VARCHAR(100)
);

-- 创建 Orders 表
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE
);

-- 插入示例数据
INSERT INTO Customers (customer_id, customer_name, customer_email)
VALUES (1, 'Alice', 'alice@example.com'),
       (2, 'Bob', 'bob@example.com');

INSERT INTO Orders (order_id, customer_id, order_date)
VALUES (101, 1, '2024-10-01'),
       (102, 2, '2024-10-02');

-- 使用 USING 进行连接查询
SELECT order_id, customer_name, order_date
FROM Orders
JOIN Customers
USING (customer_id);
```

在这个示例中，`USING (customer_id)` 表示根据 `Orders` 表和 `Customers` 表中的 `customer_id` 列进行连接。与使用传统的 `ON` 子句（`ON Orders.customer_id = Customers.customer_id`）相比，`USING` 语法更加简洁。

`USING` 也可以用于多列连接，只需在括号中列出多个列名，用逗号分隔即可。

# AFTER 

在 SQL 中，当使用 `ALTER TABLE` 语句向表中添加新列时，`AFTER` 关键字可以指定新增列在表中的位置，即让新增列位于指定列之后。如果不使用 `AFTER` 关键字，新增列通常会被添加到表的最后一列。

```sql
ALTER TABLE user_info
    ADD school VARCHAR(15) AFTER level,
    CHANGE job profession VARCHAR(10),
    MODIFY achievement INT(11) DEFAULT 0;
```



# EXIST

`EXISTS` 运算符不关注子查询返回的具体数据内容，仅在乎子查询是否能返回至少一行结果。若子查询返回了至少一行，`EXISTS` 就会返回布尔值 `TRUE`，此时主查询会包含满足该条件的记录；若子查询没有返回任何行，`EXISTS` 则返回 `FALSE`，主查询会排除满足该条件的记录。

```sql
SELECT customer_name
FROM Customers
WHERE EXISTS (
    SELECT 1
    FROM Orders
    WHERE Orders.customer_id = Customers.customer_id
);
```

这里，对于 `Customers` 表中的每一行记录，子查询会检查 `Orders` 表中是否存在 `customer_id` 与之匹配的订单记录。若存在，`EXISTS` 返回 `TRUE`，该行客户记录会被包含在主查询结果中；若不存在，`EXISTS` 返回 `FALSE`，该行客户记录会被排除。

# 函数

## [文本处理](https://javaguide.cn/database/sql/sql-syntax-summary.html#文本处理)

| 函数                 | 说明                   |
| -------------------- | ---------------------- |
| `LEFT()`、`RIGHT()`  | 左边或者右边的字符     |
| `LOWER()`、`UPPER()` | 转换为小写或者大写     |
| `LTRIM()`、`RTRIM()` | 去除左边或者右边的空格 |
| `LENGTH()`           | 长度，以字节为单位     |
| `SOUNDEX()`          | 转换为语音值           |

其中， **`SOUNDEX()`** 可以将一个字符串转换为描述其语音表示的字母数字模式。

```sql
SELECT *
FROM mytable
WHERE SOUNDEX(col1) = SOUNDEX('apple')
```

## [日期和时间处理](#日期和时间处理)

- 日期格式：`YYYY-MM-DD`

- 时间格式：`HH:MM:SS`

| 函 数           | 说 明                          |
| --------------- | ------------------------------ |
| `AddDate()`     | 增加一个日期（天、周等）       |
| `AddTime()`     | 增加一个时间（时、分等）       |
| `CurDate()`     | 返回当前日期                   |
| `CurTime()`     | 返回当前时间                   |
| `Date()`        | 返回日期时间的日期部分         |
| `DateDiff()`    | 计算两个日期之差               |
| `Date_Add()`    | 高度灵活的日期运算函数         |
| `Date_Format()` | 返回一个格式化的日期或时间串   |
| `Day()`         | 返回一个日期的天数部分         |
| `DayOfWeek()`   | 对于一个日期，返回对应的星期几 |
| `Hour()`        | 返回一个时间的小时部分         |
| `Minute()`      | 返回一个时间的分钟部分         |
| `Month()`       | 返回一个日期的月份部分         |
| `Now()`         | 返回当前日期和时间             |
| `Second()`      | 返回一个时间的秒部分           |
| `Time()`        | 返回一个日期时间的时间部分     |
| `Year()`        | 返回一个日期的年份部分         |

## [数值处理](#数值处理)

| 函数   | 说明   |
| ------ | ------ |
| SIN()  | 正弦   |
| COS()  | 余弦   |
| TAN()  | 正切   |
| ABS()  | 绝对值 |
| SQRT() | 平方根 |
| MOD()  | 余数   |
| EXP()  | 指数   |
| PI()   | 圆周率 |
| RAND() | 随机数 |

## [汇总](#汇总)

| 函 数     | 说 明            |
| --------- | ---------------- |
| `AVG()`   | 返回某列的平均值 |
| `COUNT()` | 返回某列的行数   |
| `MAX()`   | 返回某列的最大值 |
| `MIN()`   | 返回某列的最小值 |
| `SUM()`   | 返回某列值之和   |

`AVG()` 会忽略 NULL 行。

使用 `DISTINCT` 可以让汇总函数值汇总不同的值。

```sql
SELECT AVG(DISTINCT col1) AS avg_col
FROM mytable
```

## COUNT的用法

1. COUNT(*): 统计表中所有行的数量，包括NULL值。

```sql
SELECT COUNT(*) FROM table_name;
```

2. COUNT(column): 统计指定列中非NULL值的数量。

```sql
SELECT COUNT(column_name) FROM table_name;
```

3. COUNT(DISTINCT column): 统计指定列中不重复的非NULL值的数量。

```sql
SELECT COUNT(DISTINCT column_name) FROM table_name;
```

4. COUNT(CASE WHEN action = 'confirmed' THEN 1 END)：统计列名是confirmed的行数量，count里面的参数是NULL不会+1，不是NULL就+1.

## AVG的用法

功能是计算一组数值的平均值。它在数据统计和分析方面非常实用，能够帮助我们快速获取数据的平均水平。需要注意的是，`AVG` 函数会自动忽略 `NULL` 值，仅对非 `NULL` 的数值进行计算。

```sql
AVG([DISTINCT] 列名)
```

参数解释

- **`DISTINCT`（可选）**：使用该关键字时，`AVG` 函数会先去除重复值，再计算平均值。若省略 `DISTINCT`，则会对所有非 `NULL` 值进行计算。
- **列名**：指定要计算平均值的列，该列的数据类型通常为数值类型，如 `INT`、`DECIMAL` 等。

（一）计算单列的平均值

假设存在一个 `Employees` 表，记录了员工的薪资信息，表结构和示例数据如下：

```sql
-- 创建 Employees 表
CREATE TABLE Employees (
    employee_id INT,
    employee_name VARCHAR(50),
    salary DECIMAL(10, 2)
);

-- 插入示例数据
INSERT INTO Employees (employee_id, employee_name, salary)
VALUES (1, 'Alice', 5000.00),
       (2, 'Bob', 6000.00),
       (3, 'Charlie', 7000.00);
```

要计算所有员工的平均薪资，可以使用以下查询：

```sql
SELECT AVG(salary) AS average_salary
FROM Employees;
```

**结果解释**：此查询会计算 `Employees` 表中 `salary` 列的平均值，并将结果命名为 `average_salary`。

（二）使用 `DISTINCT` 计算不同值的平均值

假设 `Employees` 表中有一些重复的薪资值，现在要计算不同薪资值的平均值。

```sql
SELECT AVG(DISTINCT salary) AS distinct_average_salary
FROM Employees;
```

**结果解释**：`DISTINCT` 关键字会先去除 `salary` 列中的重复值，然后 `AVG` 函数对这些不同的值计算平均值。

（三）结合 `GROUP BY` 子句按分组计算平均值

假设 `Employees` 表中还有一个 `department_id` 列，用于表示员工所属的部门，现在要计算每个部门的平均薪资。

```sql
-- 修改 Employees 表，添加 department_id 列
ALTER TABLE Employees ADD COLUMN department_id INT;

-- 更新示例数据
UPDATE Employees SET department_id = 1 WHERE employee_id IN (1, 2);
UPDATE Employees SET department_id = 2 WHERE employee_id = 3;

-- 按部门计算平均薪资
SELECT department_id, AVG(salary) AS average_salary
FROM Employees
GROUP BY department_id;
```

**结果解释**：`GROUP BY` 子句会将员工按 `department_id` 分组，然后 `AVG` 函数分别计算每个组内 `salary` 列的平均值。

（四）结合 `WHERE` 子句计算满足条件的平均值

若要计算薪资大于 5500 的员工的平均薪资，可以使用 `WHERE` 子句进行筛选。

```sql
SELECT AVG(salary) AS high_salary_average
FROM Employees
WHERE salary > 5500;
```

**结果解释**：`WHERE` 子句会筛选出 `salary` 大于 5500 的员工记录，然后 `AVG` 函数对这些记录的 `salary` 列计算平均值。

注意事项

1. **`NULL` 值处理**：`AVG` 函数会自动忽略 `NULL` 值。若要计算包含 `NULL` 值的列的平均值，需要先对 `NULL` 值进行处理，例如使用 `COALESCE` 函数将 `NULL` 值替换为合适的默认值。

```sql
SELECT AVG(COALESCE(salary, 0)) AS average_salary
FROM Employees;
```

1. **数据类型**：`AVG` 函数只能用于数值类型的列。若对非数值类型的列使用 `AVG` 函数，会导致错误。
2. **性能考虑**：在处理大量数据时，频繁使用 `AVG` 函数可能会影响性能。可以考虑在合适的列上创建索引，以提高查询效率。

问题: `avg(case when rating < 3 then 1 else 0 end)` 和 `avg(case when rating < 3 then 1  end)` 有什么区别?

`AVG(case when rating < 3 then 1 else 0 end)`

- 这里的 `CASE` 表达式是一个完整的条件判断，对于每一行记录，当 `rating` 小于 3 时，表达式返回 1；当 `rating` 大于等于 3 时，表达式返回 0。
- `AVG` 函数会对这些 1 和 0 进行求平均值的操作。实际上，这个平均值代表的是 `rating` 小于 3 的记录在所有记录中所占的比例。

`AVG(case when rating < 3 then 1 end)`

- 此 `CASE` 表达式没有 `ELSE` 部分，当 `rating` 小于 3 时，表达式返回 1；当 `rating` 大于等于 3 时，表达式返回 `NULL`。

- ## `AVG` 函数会忽略 `NULL` 值，只对返回 1 的记录进行计数，然后计算平均值。最终结果是 `rating` 小于 3 的记录数量除以 `rating` 小于 3 的记录数量，结果始终为 1。

## Date_format

基本语法：

```sql
DATE_FORMAT(date, format)
```

- **`date`**：这是需要进行格式化的日期或日期时间表达式，可以是日期类型的列名，也可以是具体的日期值，例如 `'2024-10-01'` 。
- **`format`**：用于指定输出格式的字符串，其中包含各种格式说明符，这些说明符决定了日期和时间的显示方式。

常用格式说明符

| 说明符 | 描述                         | 示例 |
| ------ | ---------------------------- | ---- |
| `%Y`   | 四位数的年份                 | 2024 |
| `%y`   | 两位数的年份                 | 24   |
| `%m`   | 两位数的月份（01 - 12）      | 03   |
| `%c`   | 月份（1 - 12）               | 3    |
| `%d`   | 两位数的日（01 - 31）        | 05   |
| `%e`   | 日（1 - 31）                 | 5    |
| `%H`   | 24 小时制的小时数（00 - 23） | 15   |
| `%h`   | 12 小时制的小时数（01 - 12） | 03   |
| `%i`   | 分钟数（00 - 59）            | 30   |
| `%s`   | 秒数（00 - 59）              | 45   |
| `%p`   | AM 或 PM                     | PM   |

# 

# 约束

约束可以在创建表时规定（通过 CREATE TABLE 语句），或者在表创建之后规定（通过 ALTER TABLE 语句）。

约束类型：

- `NOT NULL` - 指示某列不能存储 NULL 值。
- `UNIQUE` - 保证某列的每行必须有唯一的值。
- `PRIMARY KEY` - NOT NULL 和 UNIQUE 的结合。确保某列（或两个列多个列的结合）有唯一标识，有助于更容易更快速地找到表中的一个特定的记录。
- `FOREIGN KEY` - 保证一个表中的数据匹配另一个表中的值的参照完整性。
- `CHECK` - 保证列中的值符合指定的条件。
- `DEFAULT` - 规定没有给列赋值时的默认值。

# [事务处理](#事务处理)

不能回退 `SELECT` 语句，回退 `SELECT` 语句也没意义；也不能回退 `CREATE` 和 `DROP` 语句。

**MySQL 默认是隐式提交**，每执行一条语句就把这条语句当成一个事务然后进行提交。当出现 `START TRANSACTION` 语句时，会关闭隐式提交；当 `COMMIT` 或 `ROLLBACK` 语句执行后，事务会自动关闭，重新恢复隐式提交。

通过 `set autocommit=0` 可以取消自动提交，直到 `set autocommit=1` 才会提交；`autocommit` 标记是针对每个连接而不是针对服务器的。

指令：

- `START TRANSACTION` - 指令用于标记事务的起始点。

- `SAVEPOINT` - 指令用于创建保留点。

- `ROLLBACK TO` - 指令用于回滚到指定的保留点；如果没有设置保留点，则回退到 `START TRANSACTION` 语句处。

- `COMMIT` - 提交事务。

  
