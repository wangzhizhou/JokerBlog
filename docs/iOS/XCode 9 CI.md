XCode 9 已经集成了XCode Server, 不用单独安装，这很方便坐持续集成。

[证书和授权文件](http://blog.sina.com.cn/s/blog_a562246f0102vebx.html)

[持续集成环境](https://www.jianshu.com/p/7aed0ef67449)

[持续集成自动上传](https://www.jianshu.com/p/5faf777fdd97?utm_campaign=hugo&utm_medium=reader_share&utm_content=note)


# Pre-integration Scripts

```
#!/bin/sh
export LANG=en_US.UTF-8
cd JokerHub/jokerHub/
/usr/local/bin/pod install
```

# Post-integration Scripts

```
#!/bin/sh
IPA_NAME=$(basename "${XCS_ARCHIVE%.*}".ipa)

IPA_PATH="${XCS_OUTPUT_DIR}/ExportedProduct/Apps/${IPA_NAME}"

echo ${IPA_PATH}

#请根据蒲公英自己的账号，将其中的 uKey 和 _api_key 的值替换为相应的值。

curl -F "file=@${IPA_PATH}" -F "uKey=b48819d10723f97bd0fcb83f852dfa85" -F "_api_key=524a489e84bfa19b9f42eb9acf53779f" http://www.pgyer.com/apiv1/app/upload
```