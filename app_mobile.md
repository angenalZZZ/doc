# 手机应用

#### 安卓 Android

> 应用包名: com.company.appname

~~~
keyAlias 'appname'
keyPassword '111111'
storeFile file('../appname.jks')
storePassword '111111'

应用签名: "C:\Program Files (x86)\Java\jdk1.8.0_211\bin\jarsigner.exe" -verbose \
 -keystore "C:\keystore-name.jks" \
 -signedjar "C:\tap_signed.apk" \
 # -sigalg MD5withRSA -digestalg SHA1 \
 # -tsa http://sha256timestamp.ws.symantec.com/sha256/timestamp \
 "C:\tap_unsign.apk" <appname>

~~~


