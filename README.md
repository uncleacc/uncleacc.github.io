## 脚本列表

- `newpost.sh`: 创建一篇新的 Hexo 文章；从 `pic_num.txt` 读取上次封面 URL，解析数字自增生成新封面并写入生成的 Markdown 的 `cover:` 字段。内置“事务式”处理：任一步骤失败将终止并回滚，避免产生半成品文件。要求 `pic_num.txt` 事先存在且内容为有效 URL。
- `deploy.sh`: 执行 `hexo clean && hexo g && hexo d`，生成并部署博客到远端（master 分支）。
- `backup.sh`: 在 `backup` 分支提交与推送源文件变更（需要当前分支为 `backup`）。
- `quick.sh`: 一键执行部署与备份，依次调用 `deploy.sh` 与 `backup.sh`。


