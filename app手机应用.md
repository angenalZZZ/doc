# 手机应用

#### 安卓 Android

> 应用包名: com.company.appname

~~~
keyAlias 'appname'
keyPassword '111111'
storeFile file('../appname.jks')
storePassword '111111'
~~~

> 应用签名: [Windows_sign_tool](http://fs8.ijiami.cn/ijiami/sign/Windows_sign_tool.zip)、[Linux_sign_tool](http://fs8.ijiami.cn/ijiami/sign/Linux_sign_tool.zip)、[Macos_ApkSignTool](http://fs8.ijiami.cn/ijiami/sign/ApkSignTool-v3.5-macos.zip)

~~~bash
"C:\Program Files (x86)\Java\jdk1.8.0_211\bin\jarsigner.exe" -verbose \
 -keystore "C:\keystore-name.jks" \  # 指定签名者证书
 -signedjar "C:\tap_signed.apk" \    # 指定输出签名后的文件
 # -sigalg MD5withRSA -digestalg SHA1 \                            # 选填
 # -tsa http://sha256timestamp.ws.symantec.com/sha256/timestamp \  # 选填
 "C:\tap_unsign.apk" <appname>       # 指定待签名文件和应用名称
~~~

----
