本项目包含3个分支，其中：

1. `master`分支用于开发；
2. `staging`分支用于测试；
3. `release`分支用于部署；



`staging`和`release`分支中均包含较大的二进制文件（nexe打包文件）；`staging`分支每次更新都会采用force push方式清空原有内容；`release`分支可能定期清理。



工作流是在`master`分支开发，然后使用`stage.sh`脚本创建nexe打包可执行文件，推入`staging`分支测试；如果测试OK，可以checkout release分支，从staging分支checkout所需文件，然后push回github服务器。



这三个分支不存在merge逻辑。



目前使用nexe统一使用node.js的8.9.1 LTS版本。



## Staging

应该在`master`分支开发完成后推回github；然后在一个**新的**目录或服务器上，先clone master分支下来，然后执行stage.sh脚本，该脚本会最后推回github服务器。



**该操作会毁坏执行staging操作的git池**。

