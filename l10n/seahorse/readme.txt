*) 简体中文翻译信息
  http://l10n.gnome.org/languages/zh_CN
  http://l10n.gnome.org/module/seahorse


*) seahorse 开发信息
  http://www.gnome.org/projects/seahorse/development.html

  http://svn.gnome.org/viewcvs/seahorse/trunk/
  http://svn.gnome.org/viewcvs/seahorse/trunk/help/

  svn://svn.gnome.org/svn/seahorse


*) seahorse 翻译信息
  http://svn.gnome.org/viewcvs/seahorse/trunk/po/zh_CN.po
  http://svn.gnome.org/viewcvs/seahorse/branches/gnome-2-18/po/zh_CN.po
  
  svn cat svn://svn.gnome.org/svn/seahorse/trunk/po/zh_CN.po > zh_CN.po
  svn cat svn://svn.gnome.org/svn/seahorse/branches/gnome-2-18/po/zh_CN.po > zh_CN-2.18.po

  wget -O docs.pot      http://l10n.gnome.org/POT/seahorse.HEAD/docs/help.HEAD.pot
  wget -O docs-2.18.pot http://l10n.gnome.org/POT/seahorse.gnome-2-18/docs/help.gnome-2-18.pot

  wget -O seahorse.pot      http://l10n.gnome.org/POT/seahorse.HEAD/seahorse.HEAD.pot
  wget -O seahorse-2.18.pot http://l10n.gnome.org/POT/seahorse.gnome-2-18/seahorse.gnome-2-18.pot


*) seahorse 翻译格式

  统一采用 msgmerge 翻译格式，提交之前先格式化 po 文件。

  gettext 的 Windows 平台二进制包可以从 i18n-zh 下载。

1. 开发版本

    msgfmt --check-accelerators --statistics -c zh_CN.po
    msgmerge --no-wrap -F -o zh_CN.po.new zh_CN.po seahorse.pot
    diff zh_CN.po zh_CN.po.new
    mv -f zh_CN.po.new zh_CN.po

2. 最新稳定版本

    msgfmt --check-accelerators --statistics -c zh_CN-2.18.po
    msgmerge --no-wrap -F -o zh_CN-2.18.po.new zh_CN-2.18.po seahorse-2.18.pot
    diff zh_CN-2.18.po zh_CN-2.18.po.new
    mv -f zh_CN-2.18.po.new zh_CN-2.18.po


*) 从开发版本合并：
      msgmerge -o zh_CN-2.18-new.po zh_CN.po zh_CN-2.18.po
      mv -f zh_CN-2.18-new.po zh_CN-2.18.po
