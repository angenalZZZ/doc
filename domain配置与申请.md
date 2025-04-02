# [域名](https://wanwang.aliyun.com/domain)


### 域名注册
- [阿里云](https://wanwang.aliyun.com/domain)、[腾讯云](https://cloud.tencent.com/product/domain)、[华为云](https://www.huaweicloud.com/product/domain.html)
- [西部数码](https://faq.myhostadmin.net/services/domain)[首页](https://www.west.cn)、[中万网络](https://www.zw.cn)


### ICP备案
- [阿里云](https://beian.aliyun.com)、[腾讯云](https://cloud.tencent.com/product/ba)、[华为云](https://beian.huaweicloud.com)


### DNS解析
- [阿里云](https://wanwang.aliyun.com/domain/dns)、[腾讯云](https://cloud.tencent.com/product/dns)、[华为云](https://www.huaweicloud.com/product/dns.html)
- [西部数码](https://myhostadmin.net)
~~~
A记录:设定域名或者子域名指向，保证域名指向对应的主机重要设置；
1.做A记录时， 对应值必须是IP地址
2.主机名必须填写，用@可以表示主机名为空
3.泛域名解析，请在主机名处输入*，增加A记录即可
MX记录:设定域名的邮件交换记录，是指定该域名对应的邮箱服务器的重要设置。
CNAME记录:邮箱域名解析将自动生成mail记录和邮件交换记录。
TXT记录: TXT是一种文本记录，仅用于描述域名记录信息，对解析无实质影响。如：v=spf1 ip4:61.139.126.5 ~all
AAAA记录:是用来将域名解析到IPv6地址的DNS记录。用户可以将一个域名解析到IPv6地址上，也可以将子域名解析到IPv6地址上。
SRV记录:它是DNS服务器的数据库中支持的一种资源记录的类型，它记录了哪台计算机提供了哪个服务这么一个简单的信息。
什么是TTL: TTL是指解析生效时间（单位秒），但仅影响解析记录修改的生效时间，添加是实时生效的，最低不允许低于200秒。
~~~

- `cncsedu.com.cn`
~~~
#主机名               解析类型         对应值
  @                     A           122.9.142.200
  www                   A           122.9.142.200
  play                  CNAME       play.cncsedu.com.cn.livecdn.liveplay.myqcloud.com
  push                  CNAME       push.cncsedu.com.cn.livepush.myqcloud.com
  _66ef459eafa72c       CNAME       65ea0017d2b06a.cmcdtcphodyv4i.trust-provider.com
  _dnsauth              TXT         2023041600000006vd4aog79g26xjdzhhvc6fj4kfomimn
  _acme-challenge       TXT         5cmgjNnKoRDFutzOn6lGZIcXaNk8iDMFobfpnYXY51s
~~~
- `codewithsusan.com`
~~~
#主机名               解析类型         对应值
  @                     A           45.79.155.61
  api                   A           165.22.189.218
  www                   CNAME       codewithsusan.com
  email.mail            CNAME       mailgun.org
  mail                  TXT         v=spf1 include:mailgun.org ~all
  @                     TXT         google-site-verification=A8IXwqwZOFxEoQ0AEeK
~~~

---

