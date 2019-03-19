**静态网页托管（个人 Blog）**

- html+jquery+css+文本（.txt）数据存储
- 前台通过 jquery “动态”读取文本文件作为内容输出
- 后台通过 AHK 脚本生成博客（仅为一个主页 index.html，实际为框架）

**文件目录说明**
- index.html——首页，由 AHK 脚本自动生成
- m.html——手机网址导航（个人自用）
- 目录 css
    * main.css——主页样式表文件
- 目录 js
    * main.js——主页 Js 文件
    * jquery-1.12.0.min.js——调用 jquery 库
    * respond.src.js——让 IE9 以下版本浏览器使用响应式布局（非必需）
- 目录 images
    * [所有需要的图片存放目录]
- 目录 web（非必需）
    * [站内其他静态页面]
- 目录 post
    * [文章列表，为 .txt 格式]
    * [文章可由 AHK 脚本辅助编辑]
- 目录 build
    * HTMLBuilder.ahk——AHK 博客生成脚本及文章辅助编辑脚本
    * 目录 template
        + header.html——生成 index.html 所必需的头部内容
        + footer.html——生成 index.html 所必需的底部内容
        + [index.html 主体部分由 HTMLBuilder.ahk 自动生成]

by easysky@foxmail.com
2019/02/14