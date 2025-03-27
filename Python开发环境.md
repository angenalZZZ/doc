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

