# 破解

## 密码破解


#### 1. [压缩包密码](https://www.freedidi.com/2655.html)
> [`hashcat - advanced password recovery`](https://hashcat.net)
> [`John the Ripper password cracker`](https://www.openwall.com)
~~~bash
#1.获取rar压缩包hash值
rar2john *.rar
#1.1开始破解
hashcat -m 13000 -a 3 -w 4 -o password.txt $***$ #输出密码: password.txt

#2.获取zip压缩包hash值
zip2john *.zip
# test.zip/1.txt:$***$:1.txt:test.zip::test.zip #所得hash值: $***$
#2.1开始破解
hashcat -m 17210 -a 0 --force $***$ password.txt #使用密码字典: password.txt
~~~

#### 2. Word密码
~~~bash
#1.获取Word文件的hash值
python office2john.py *.docx
# test.docx:$office$***                         #所得hash值: $office$***
#1.1开始破解
hashcat -m 9600 -a 3 -o password.txt $office$*** ?d?d?d?d #输出密码: password.txt
~~~

#### 3. PDF密码
~~~bash
#1.获取PDF文件的hash值
perl pdf2john.pl *.pdf
# test.pdf:$pdf$***                         #所得hash值: $pdf$***
#1.1开始破解
hashcat -m 10500 -a 3 -o password.txt $pdf$*** ?l?l?l?l?l?l #输出密码: password.txt
~~~


----

