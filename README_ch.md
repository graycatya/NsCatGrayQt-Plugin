[>>> English Version](README.md)

# 介绍
提供一种创建漂亮地、现代化地Windows平台安装界面的方式。
基于Nsis+Qt完成,提供QWidgets,Quick实现案例。

---

**1. NSIS**

从[https://nsis.sourceforge.io/Download](https://nsis.sourceforge.io/Download) 下载NSIS并安装。

**2. Qt**

因为插件默认使用Qt作为界面库，所以需要安装Qt。
Qt安装包会默认将安装目录添加`QTDIR`环境变量，如果没有自动添加，则需要手动添加。

---

# 开始使用

**编译**

编译支持CMake，Qmake，可直接编译NsCatGrayQt-Plugin目录下的cmake与qmake工程。