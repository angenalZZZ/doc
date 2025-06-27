# [Python](https://www.python.org)

#### [conda](https://anaconda.org) [安装](https://anaconda.org.cn/anaconda/install)、[使用](https://anaconda.org.cn/anaconda/user-guide/getting-started)
Anaconda 是专门为了方便使用 Python 进行数据科学研究而建立的一组软件包，涵盖了数据科学领域常见的 Python 库，并且自带了专门用来解决软件环境依赖问题的 conda 包管理系统。主要是提供了包管理与环境管理的功能，可以很方便地解决多版本python并存、切换以及各种第三方包安装问题。

### `虚拟环境`
~~~bash
:: conda 24.11.3
:: D:\Program\anaconda3\python.exe
:: D:\Program\anaconda3\Scripts\pip.exe

:: 配置conda
conda info -e
conda create -n python3.10 python=3.10
conda remove --name python3.10 --all
::conda create --name new_env_name --clone old_env_name
::conda env export > env_name.yml
::conda activate python3.10
:: conda install --yes --file requirements.txt # 安装依赖包
::conda deactivate
:: conda config --remove-key channels       # 恢复默认官方源defaults
:: conda config --show channels
:: conda config --set show_channel_urls yes # 搜索时显示通道地址|后添加的优先级更高
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch

:: 配置conda 安装Python各版本
:: 安装virtualenv(先安装Python各版本)
pip install virtualenv

:: 创建虚拟环境(先进入项目所在目录)
virtualenv -p /usr/local/bin/python3.10 venv
::virtualenv -p D:\Program\anaconda3\envs\python3.10 venv_appname
:: 激活虚拟环境
source venv/bin/activate
:: venv/bin/activate.bat
:: python --version
:: pip install -r requirements.txt
:: pip install --force-reinstall numpy==1.23.5  # 重新安装指定版本
:: pip install *** -i https://mirrors.aliyun.com/pypi/simple  # 阿里源
:: pip install *** -i https://pypi.tuna.tsinghua.edu.cn/simple # 清华源
:: 退出虚拟环境
deactivate

~~~

---

### [`数据`](https://mp.weixin.qq.com/s/E3BM1GTb13xPF26LXUNv1Q)①`基础操作`
~~~python
# 列表平均值
avg = sum([1, 2, 3, 4, 5]) / len([1, 2, 3, 4, 5])

# 列表转字符串
print(''.join(['hello', 'world']))

# 快速排序
sorted_list = sorted([5, 2, 9, 1, 6])

# 字符串反转
reversed_str = "hello"[::-1] # 切片操作

# 筛选偶数
even_list = [i for i in range(10+1) if x % 2 == 0] # 条件列表推导式

# 字典键值交换
swapped = {v: k for k, v in {100:'💯', 'A':1, 'B':2}.items()} # 字典推导式

# 字符串去重排序
unique_chars = ''.join(sorted(set("hello"))) # >> 'ehlo'

# 素数判断
is_prime = lambda n: n > 1 and all(n % i for i in range(2, int(n**0.5) + 1))  # all() 生成器

# 集合交集
intersection = {1, 2, 3} & {2, 3, 4}  # &运算符妙用

# 字符串转整数列表
int_list = list(map(int, "12345"))  # map函数批量转换

# 文件读取所有行
lines = [line.strip() for line in open('data.txt')]  # 文件对象直接迭代

# 统计字符出现次数
count = "hello world".count('o')  # count()方法

# 生成随机数
import random; print(random.randint(1, 100))  # 分号实现一行多语句

# 秒数转时分秒
print(f"{3661 // 3600}:{(3661 % 3600) // 60}:{3661 % 60}")  # 整除与取模组合

# 闰年判断
is_leap = lambda y: y % 4 == 0 and (y % 100 != 0 or y % 400 == 0)  # 逻辑表达式封装

# 嵌套列表扁平化
flat_list = [item for sublist in [[1, 2], [3, 4]] for item in sublist]  # 双层列表推导式

# 当前时间戳
import time
print(int(time.time()))  # 获取秒级时间戳

# 快速创建HTTP服务
import os
os.system("python -m http.server 8000")  # 单行启动Web服务

# JSON字符串转字典
import json
data = json.loads('{"name": "Alice"}')  # json模块解析

# 列表元素频率统计
from collections import Counter
print(Counter(['a', 'b', 'a']))  # Counter模块快速计数
~~~

### `数据`②`进阶技巧`
~~~python
# 并行处理列表
from concurrent.futures import ThreadPoolExecutor
list(ThreadPoolExecutor().map(lambda x: x**2, [1, 2, 3, 4]))  # 线程池加速计算

# 装饰器日志记录
log = lambda func: lambda *args: print(f"Calling {func.__name__}") or func(*args)  # 嵌套lambda实现装饰器

# 生成器内存优化
squares = (x**2 for x in range(1000000))  # 生成器替代列表节省内存

# 错误处理精简写法
result = 10 / 0 if 2 > 1 else "safe"  # 条件表达式规避异常

# 用海象运算符赋值
print(n**2 if (n := 5) > 3 else n)  # Python 3.8+ 海象运算符

# 正则匹配提取
import re; print(re.findall(r'\d+', 'a1b23'))  # 快速提取数字

# 环境变量读取
import os; print(os.environ.get('PATH'))  # 获取系统路径$PATH

# 列表元素类型转换
float_list = list(map(float, ['1.2', '3.4']))  # 批量类型转换

# 字典默认值处理
value = {'a': 1}.get('b', 0)  # get()避免KeyError需输入默认值

# 多条件排序
sorted_users = sorted([{'age': 25}, {'age': 20}], key=lambda x: x['age'])  # 自定义排序键

# 快速列表去重
unique = list(dict.fromkeys(['a', 'b', 'a']))  # 利用字典键唯一性

# 进度条显示
from tqdm import tqdm
[time.sleep(0.1) for _ in tqdm(range(10))]  # tqdm库支持一行进度条
~~~

### `数据`③`高效开发`
~~~python
# Pandas读取CSV
import pandas as pd; df = pd.read_csv('data.csv')  # 数据分析必备

# Numpy数组创建
import numpy as np; arr = np.array([1, 2, 3, 4, 5])  # 科学计算基础

# 图像灰度化
from PIL import Image
Image.open('img.jpg').convert('L').save('gray.jpg')  # Pillow库图像处理

# HTTP请求
import requests
print(requests.get('https://api.example.com').json())  # 网络请求一行搞定

# 命令行参数解析
import sys
print(sys.argv)  # 获取脚本参数

# 日期格式化
from datetime import datetime
print(datetime.now().strftime('%Y-%m-%d'))  # 格式化当前时间

# ZIP文件解压
import zipfile
zipfile.ZipFile('data.zip').extractall()  # 无需循环直接解压

# 创建虚拟环境
import venv
venv.create('myenv')  # 内置模块管理环境
~~~

### `数据`④`高级使用`
~~~python
# 函数式编程：高阶函数
  # 使用 map 和 filter 进行函数式编程
numbers = [1, 2, 3, 4, 5]
# 使用 map 对列表中的每个元素求平方
squared = list(map(lambda x: x**2, numbers))
print(squared)  # 输出: [1, 4, 9, 16, 25]
# 使用 filter 筛选偶数
evens = list(filter(lambda x: x % 2 == 0, numbers))
print(evens)  # 输出: [2, 4]

# 上下文管理器（Context Managers）
from contextlib import contextmanager;
@contextmanager
def open_file(filename, mode):
      file = open(filename, mode)
      try:
           yield file
      finally:
          file.close()
  # 使用自定义上下文管理器with
with open_file('example.txt', 'w') as f: # 文件在退出上下文时自动关闭
       f.write('Hello, world!')

# 元类（Metaclasses）
class Meta(type):
      def __new__(cls, name, bases, dct):
             print(f"Creating class {name}")
             return super().__new__(cls, name, bases, dct)
class MyClass(metaclass=Meta):
      pass
obj = MyClass() # 创建实例

# 异步编程（Asyncio）
import asyncio;
async def fetch_data():
       print("Start fetching")
       await asyncio.sleep(2)  # 模拟异步 I/O 操作
       print("Done fetching")
       return {"data": 123}
async def main():
       print("Main starts")
       task = asyncio.create_task(fetch_data())  # 创建任务
       await task   # 等待任务完成
       print("Main ends")
asyncio.run(main()) # 运行异步主函数

# 数据类（Data Classes）
from dataclasses import dataclass;
@dataclass
class Point:
    x: int
    y: int
p = Point(1, 2) # 创建实例
print(p)        # 输出: Point(x=1, y=2)

# 类型注解（Type Hints）
from typing import List, Dict;
def process_data(data: List[int]) -> Dict[str, int]:
      result = {"sum": sum(data), "length": len(data)}
      return result
  # 使用类型注解
data = [1, 2, 3, 4, 5]
result = process_data(data)
print(result)  # 输出: {'sum': 15, 'length': 5}

# 多重继承和 Mixin 扩展
class A:
      def method_a(self):
            print("Method A")
class B:
       def method_b(self):
             print("Method B")
class C(A, B):
       def method_c(self):
             print("Method C")
obj = C()       # 创建实例
obj.method_a()  # 输出: Method A
obj.method_b()  # 输出: Method B
obj.method_c()  # 输出: Method C

# 动态属性和 getattr
  # __getattr__ 方法允许动态访问对象的属性，如果属性不存在，则可以自定义行为。
class DynamicAttributes:
       def __init__(self, **kwargs):
              self.__dict__.update(kwargs) # 动态属性可以通过__dict__进行管理
       def __getattr__(self, name): # 访问不存在的属性时被调用
              return f"Attribute {name} not found"
  # 创建实例
obj = DynamicAttributes(a=1, b=2)
print(obj.a)  # 输出: 1
print(obj.b)  # 输出: 2
print(obj.c)  # 输出: Attribute c not found
~~~


---


