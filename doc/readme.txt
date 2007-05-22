*) Description
    docbook/ ....... Translation "DocBook 5.0: The Definitive Guide" to simplified chinese.
    subversion/ .... Translation "Version Control with Subversion" to simplified chinese.
    examples/ ...... DocBook 4.5 & 5.0 examples.

*) Check translation
    msgfmt --statistics -c zh_CN.po

*) Formt translation
    msgmerge --no-wrap -o zh_CN-new.po zh_CN.po defguide5.pot
    mv -f zh_CN-new.po zh_CN.po

*) Merge translation
      msgmerge -o zh_CN-new.po  zh_CN-other.po zh_CN.po
      mv -f zh_CN-new.po zh_CN.po
