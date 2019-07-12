
# **[安装redis - Remote Dictionary Service](http://redis.io)**
> [1.查询服务信息](#1查询服务信息)、[2.基础数据结构](#2基础数据结构)、[3.配置Redis](#3配置Redis)、[`教程`](http://www.runoob.com/redis/redis-tutorial.html)

~~~
mac    > brew install redis
ubuntu > apt-get install redis
redhat > yum install redis
windows> https://github.com/MicrosoftArchive/redis/releases
github > git clone --branch 2.8 --depth 1 git@github.com:antirez/redis.git;cd redis;make;cd src;./redis-server --daemonize yes;./redis-cli
docker > docker pull redis;docker run --name redis-server -d -p6379:6379 redis;docker exec -it redis-server redis-cli
~~~

####  1.查询服务信息
> [try redis-cli](http://try.redis.io)

~~~
redis-cli -h 127.0.0.1 -p 6379 -a 123456 -n 0 # redis连接参数 [p端口],[a密码],[n数据库*默认0]
> info [all]                    # 获取所有信息
  # 1. Server 服务器运行的环境参数
  # 2. Clients 客户端相关信息
  # 3. Memory 服务器运行内存统计数据
  # 4. Persistence 持久化信息
  # 5. Stats 通用统计数据
  # 6. Replication 主从复制相关信息
  # 7. CPU CPU 使用情况
  # 8. Cluster 集群信息
  # 9. KeySpace 键值对统计数量信息
  
> info memory                   # 获取内存相关信息,内存分配mem_allocator:libc、tcmalloc(google)、jemalloc(facebook:默认:性能最佳)
> redis-cli info memory | grep used | grep human
  used_memory_human:827.46K     # 内存分配器 (jemalloc...) 从操作系统分配的内存总量
  used_memory_rss_human:3.61M   # 操作系统看到的内存占用 ,top 命令看到的内存
  used_memory_peak_human:29.41K # Redis 内存消耗的峰值
  used_memory_lua_human:37.00K  # lua 脚本引擎占用的内存大小
  # 如果单个 Redis 内存占用过大，并且在业务上没有太多压缩的空间的话，可以考虑集群化了。
  
> info replication              # 获取主从复制相关信息
> info replication | grep backlog
  repl_backlog_active:0
  repl_backlog_size:1048576     # 积压缓冲区大小
  # 复制积压缓冲区大小非常重要，它严重影响到主从复制的效率。当从库因为网络原因临时断开了主库的复制，然后网络恢复了，又重新连上的时候，
  # 这段断开的时间内发生在 master 上的修改操作指令都会放在积压缓冲区中，这样从库可以通过积压缓冲区恢复中断的主从同步过程。
  # 积压缓冲区是环形的，后来的指令会覆盖掉前面的内容。如果从库断开的时间过长，或者缓冲区的大小设置的太小，
  # 都会导致从库无法快速恢复中断的主从同步过程，因为中间的修改指令被覆盖掉了。这时候从库就会进行全量同步模式，非常耗费 CPU 和网络资源。
  
> redis-cli info stats | grep sync
  sync_full:0
  sync_partial_ok:0
  sync_partial_err:0            # 半同步失败次数
  # 通过查看sync_partial_err变量来决定是否需要扩大积压缓冲区，它表示主从半同步复制失败的次数。

> info clients                  # 客户端相关信息, 如:connected_clients(正在连接的客户端数量);
> info client list              # 列出所有的客户端链接地址
> info stats | grep reject
  rejected_connections(超出最大连接数限制而被拒绝的客户端连接次数)数字很大，意味着服务器的最大连接数设置过低，需要调整 maxclients 参数。

# 客户端与Redis建立连接后会自动选择0号数据库，不过可以随时使用SELECT命令更换数据库
> select 1  # 选择1号数据库
> keys *    # 查询所有key(慎用)
> flushdb 0 # 清空数据库0
> flushall  # 清空一个Redis实例中所有数据库中的数据：Redis默认支持16个数据库（可以通过配置文件支持更多，无上限）
# 性能测试
> redis-benchmark -n 10000 -q
> info stats | grep ops         # 每秒操作数:instantaneous_ops_per_sec:***
> monitor                       # 如果 qps 过高，快速观察究竟是哪些 key 访问比较频繁，从而在业务上进行优化，减少 IO 次数(执行后立即ctrl+c中断)
> debug object [key]            # 调试输出 key of object: { Value at: 指针地址, refcount: 引用计数, encoding: 数据类型, serializedlength..}
~~~

####  2.基础数据结构
> [Redis核心原理与应用实践](https://juejin.im/book/5afc2e5f6fb9a07a9b362527)

~~~
--------------------------------------------------------------------
#Redis-Db数据库结构体:             # 内存分配器 (jemalloc...) 从操作系统分配的内存总量
--------------------------------------------------------------------
struct RedisDb {
  dict* dicts;                    # 所有key集合 key=>value(快查hash函数,siphash算法,避免hash攻击...)
  dict* expires;                  # 过期key集合 key=>long (timestamp)
}
--------------------------------------------------------------------
#Redis-Object对象头结构体:         # 存储空间为16字节,公共基类
--------------------------------------------------------------------
struct RedisObject {
  int4 type;                      # 对象的不同类型4bits
  int4 encoding;                  # 存储编码形式4bits
  int24 lru;                      # LRU信息24bits
  int32 refcount;                 # 对象的引用计数(为零时对象就会被销毁)4bytes
  void *ptr;                      # 指针(引用SDS...指向对象内容存储位置)8bytes,64-bit-system
}
--------------------------------------------------------------------
#Redis-dict字典是Redis应用最为频繁的复合型数据结构:所有key集合,过期key集合,hash哈希,zset集合
--------------------------------------------------------------------
struct dict {
  dictht ht[2];                   # ht[0](old-hashtable) <渐进式rehash搬迁> ht[1](new-hashtable)
}
struct dictht {                   # hashtable结构(类似于Java的HashMap)，性能取决于hash函数siphash算法(hash偏向性小,生成key均匀,避免hash攻击)
  ...
  long size;                      # 第一维是数组,数组长度
  long used;                      # table链表中的元素个数
  dictEntry** table;              # 第二维是链表,dictEntry链表的第一个元素的指针
}
struct dictEntry {
  void* key;
  void* val;
  dictEntry* next;                # 链接下一个entry
}
--------------------------------------------------------------------

--------------------------------------------------------------------
1. string # 字符串（SDS带长度信息的字节数组Simple Dynamic String）
--------------------------------------------------------------------
struct SDS<T> {                   # T用作内存优化-结构分配:byte-short-int8-int
  T capacity;                     # 数组容量<=512M(当<1M时扩容加倍;超过1M时扩容+1M)
  T len;                          # 数组长度<=512M
  byte flags;                     # 特殊标识
  byte[] content;                 # 数组内容
}
--------------------------------------------------------------------
 > select 0                       # 查询db: 成功返回 +OK ; 异常返回 -ERR DB index is out of range
 > scan 0 MATCH * COUNT 100       # 查询keys: Array
 > set key value                  # 添加/修改 (value包含空格时添加“”)
 > get key                        # 获取数据: value
 > type key                       # 数据类型: +string ...
 > exists key                     # 是否存在: 成功返回1,失败返回0.
 > renamenx key key2              # 重命名: key to key2
 > del key                        # 删除: 成功返回1,失败返回0.
 > mset name1 value1 name2 value2 # 批量设置
 > mget name1 name2               # 批量获取
 > expire key 60                  # 过期: 60s
 > setex key 60 value             # 添加/过期: 60s
 > ttl key                        # 返回: 过期时间(秒)
 > setnx age 1                    # if age is not exists, set age = 1: 成功返回1,失败返回0.
 > incr age                       # 计数: += 1
 > incrby age 2                   # 计数: += 2
 
--------------------------------------------------------------------
2. list  # 列表 ziplist<T>(压缩列表)、
         # linkedlist(链表-节点间指针关联多会加剧内存碎片化-影响效率)、
         # quicklist(快速列表-改进结构用于代替前两者,是前两者的混合体,将linkedlist按段切分,每一段ziplist紧凑存储并用双向指针串接起来)
         # [内存: 元素少时ziplist压缩列表,元素多时quicklist快速列表,少用linkedlist]: 插入删除快Time=O(1),索引定位慢Time=O(n)
--------------------------------------------------------------------
struct ziplist<T> {               # 压缩列表: 元素个数较少，紧凑的数组结构，存储空间小；删除中间节点会导致级联更新，耗费计算资源。
  int32 zlbytes;                  # 占用字节数
  int32 zltail_offset;            # 最后一个元素距离起始位置的偏移量，用于快速定位
  int16 zllength;                 # 元素个数
  T[] entries;                    # 元素内容列表，紧凑存储结构
  int8 zlend;                     # 标志，压缩列表的结束，值恒定 0xFF
}
struct entry {                    # 压缩列表/元素内容列表/元素内容entry
  int<var> prelen;                # 前一个entry的字节长度
  int<var> encoding;              # 元素类型编码
  optional byte[] content;        # 元素内容
}

struct quicklist {                # 快速列表: 使用多个ziplist紧凑存储，ziplist之间用双向指针连起来；
  ...                             # 单个ziplist长度默认为8k字节,由配置list-max-ziplist-size决定[-1=4kb,-2=8kb..],超出就会新增一个ziplist
  quicklistNode* head;            # 首个元素
  quicklistNode* tail;            # 结尾元素
  long count;                     # 元素个数
  int nodes;                      # ziplist节点个数
  int compressDepth;              # LZF算法压缩深度，默认为0(不压缩),由配置list-compress-depth决定：0,1,2...
  ...                             # 为了支持快速push/pop操作,深度为1时首尾不压缩ziplist,深度为2时首尾第一二个都不压缩ziplist
}
struct quicklistNode {            # 快速列表quicklist的一个节点
  quicklistNode* prev;            # prev+next占16字节(因为64bit系统的指针是8个字节)
  quicklistNode* next;            # prev+next双向指针串接起来
  ziplist*       zl;              # 引用压缩列表ziplist
  int32 size;                     # ziplist占用字节数zlbytes
  int16 count;                    # ziplist元素个数zllength
  int2 encoding;                  # 判断是原生字节数组,还是LZF压缩存储,2bits
}
struct ziplist_compressed {       # 压缩列表,LZF压缩存储
  int32 size;
  byte[] compressed_data;         # 元素内容
}

struct listpack<T> {              # 紧凑列表: Redis 5.0 对ziplist结构改进,存储空间更小;不存在级联更新行为(元素独立),性能好,已用在Stream中
  int32 total_bytes;              # 占用字节数
  int16 size;                     # 元素个数
  T[] entries;                    # 紧凑排列的元素列表
  int8 end;                       # 标志，紧凑列表的结束，值恒定 0xFF
}
struct lpentry {                  # 紧凑列表的元素
  int<var> encoding;              # 编码可选择1|2|3|4|5个字节，同UTF8编码一样，通过字节最高位为1确定编码长度
  optional byte[] content;
  int<var> length;                # 用于计算长度（支持类型多，设计复杂）
}

--------------------------------------------------------------------
 > rpush books python java swift golang # 插入[右进左出/队列,右进右出/栈]: 成功返回4,失败返回0.
 > llen books                     # 列表长度: 成功返回4
 > lpop books                     # 取值快/队列: 成功返回python
 > rpop books                     # 取值快/栈: 成功返回golang
 > lindex books 0                 # 取值慢: 成功返回java, O(n) 慎用
 > lrange books 0 -1              # 取全部: 成功返回java swift, O(n) 慎用
 > ltrim books 1 -1               # 从第二个开始截取全部: 成功返回OK, O(n) 慎用
 > ltrim books 1 0                # 清空列表: llen books = 0 内存自动回收

--------------------------------------------------------------------
3. hash   # 哈希 HashMap 无序字典[内存: 数组+链表二维结构，采用渐进式rehash策略，存储消耗高于单个字符串]
--------------------------------------------------------------------
 > hset books java "think in java" # 添加/修改: 字符串如果有空格要用引用
 > hgetall books
 > hget books java
 > hmset books golang "c in go" python "python cookbook"  # 批量添加/修改
 > hmget bokks java golang python
 > hlen books                      # 集合长度: 成功返回1
 > hset books count 3              # 添加: count 计数
 > hincrby books count 1           # 计数: += 1 , hget books count = 4

--------------------------------------------------------------------
4. set    # 无序集合 intset<T>(整数集合-存储空间小)、HashSet(哈希集合-存储空间大), 集合: 唯一键-值-对
--------------------------------------------------------------------
struct intset<T> {                # 整数集合: 元素个数较少，紧凑的数组结构
  int32 encoding;                 # 决定整数位<T>: 16位、32位、64位
  int32 length;                   # 元素个数
  int<T> contents;                # 整数数组
}

--------------------------------------------------------------------
 > sadd books java                 # 添加: 返回1
 > sadd books java                 # 重复: 返回0
 > sadd books golang python        # 批量: 返回2
 > smembers books                  # 查询: 返回所有/无序
 > sismember books jaja            # 判断: 存在与否
 > scard books                     # 集合长度: 成功返回3
 > spop books                      # 取值/删除: 弹出一个

--------------------------------------------------------------------
5. zset   # 有序集合 (复合结构 = SkipList跳跃列表[SortedSet] + HashMap字典), 集合: 唯一键-值-对
          # [内存: SkipList跳跃列表+HashMap字典，每个value赋予一个score的排序权重]
--------------------------------------------------------------------
struct zset {
  dict* dicts;                    # 所有value集合 value=>score，每个value赋予一个score的排序权重
  zskiplist* zsl;                 # 跳跃列表zskiplist
}
struct zsl {                      # 跳跃列表zskiplist
  zslnode* head;                  # SkipList跳跃列表头指针
  int maxLevel;                   # 跳跃列表当前的最高层；随机层数：调用随机算法分配一个合理的层数；最顶层是2^-63，遍历时从maxLevel层往下遍历。
  map<string, zslnode*> ht;       # HashMap字典-所有的键值对
}
struct zslnode {
  string value;
  double score;
  zslnode*[] forwards;            # 多层连接指针
  zslnode* backward;              # 回溯指针
}

--------------------------------------------------------------------
 > zadd books 9.0 "java"           # 添加: 返回1
 > zadd books 8.8 python           # 添加: 返回1
 > zadd books 8.6 golang           # 添加: 返回1
 > zrange books 0 -1               # 查询: 返回所有 / 按 score 排序
 > zrevrange books 0 -1            # 查询: 返回所有 / 按 score 倒序
 > zrangebyscore books 0 8.9       # 查询: 返回部分 / 区间 score 0 - 8.9
 > zrangebyscore books -inf 8.9 withscores # 查询: 返回部分 / 区间 score -∞(inf无穷大) - 8.9 , withscores(同时返回score)
 > zcard books                     # 集合长度: 成功返回3
 > zscore books "java"             # 查询score: 成功返回9.0
 > zrank books "java"              # 排名: 成功返回0 / 第一名
 > zrem books "java"               # 删除: 成功返回1

--------------------------------------------------------------------
 # 以上的list/hash/set/zset是容器型数据结构,它们有通用规则:
 # 1. create if not exists 容器不存在就创建一个再操作 2. drop if no elements 容器中元素没有了释放内存,列表消失
--------------------------------------------------------------------
6. stream   # 频道[发送/接收/历史]消息
--------------------------------------------------------------------
 > xadd channel1 * create-channel null              # 创建频道channel1,发送空消息create-channel
 > xadd channel1 * message1 "hello world" message2 "my name is stream"  # 创建频道channel1,发送消息message1...
 > xread block 10 streams channel1 1538804450788-0  # 接收消息
 > xrange channel1 1538804450789-0 +                # 历史消息

~~~

~~~
 # 分布式锁
 > set lock:id001 true ex 5 nx   # setnx 和 expire 组合在一起的原子指令，它就是分布式锁的奥义所在。
   OK
   ... do something critical ...
 > del lock:id001
   # 1. 分布式锁不能解决超时问题，如果在加锁和释放锁之间的逻辑执行的太长，以至于超出了锁的超时限制，就会出现问题。
   # 因为这时候第一个线程持有的锁过期了，临界区的逻辑还没有执行完，这个时候第二个线程就提前重新持有了这把锁，
   # 导致临界区代码不能得到严格的串行执行。为了避免这个问题，Redis 分布式锁不要用于较长时间的任务。
   # 如果真的偶尔出现了，数据出现的小波错乱可能需要人工介入解决。
   # 2. 可重入性是指线程在持有锁的情况下再次请求加锁，如果一个锁支持同一个线程的多次加锁，
   # 那么这个锁就是可重入的。比如 Java 语言里有个 ReentrantLock 就是可重入锁。
   # Redis 分布式锁如果要支持可重入，需要对客户端的 set 方法进行包装，使用线程的 Threadlocal 变量存储当前持有锁的计数。
--------------------------------------------------------------------
 # 压力测试工具(dev)
 > redis-benchmark -t set -P 2 -q # 管道提升性能: 成功返回SET:51975.05 requests per second, 慎用 参数-P越大QPS越高,但可能CPU已100%了.

~~~

####  3.配置Redis

~~~
# 配置文件路径: /etc/redis/redis.conf
--------------------------------------------------------------------
# ***限制redis只能本地访问***
  # bind 127.0.0.1
# ***指定访问端口号***
  port 6379
# ***守护线程的方式启动***
  daemonize no
# ***日志跟踪级别***
  loglevel notice
# ***日志跟踪文件***
  logfile ""
# ***设置密码***
  requirepass 123456
# ***数据持久化到本地磁盘***
  appendonly yes
# ***数据持久化路径: /data/appendonly.aof
  appendfilename "appendonly.aof"

~~~

