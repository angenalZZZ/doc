 # npm 配置

~~~
  [nodejs用户变量 Path] += D:\Program\nodejs\node_global
  [nodejs系统变量 NODE_PATH] = D:\Program\nodejs\node_global\node_modules
  npm set init-author-name yangzhou
  npm set init-author-email angenal@hotmail.com
  npm set init-license MIT
  npm config set cache "D:\Program\nodejs\node_cache"      [全局缓存下载目录]
  npm config set prefix "D:\Program\nodejs\node_global"    [全局模块安装目录]
  npm config set proxy http://localhost:23547              [不建议]
  npm config set https-proxy http://localhost:23547        [不建议]
  npm config set registry https://registry.npm.taobao.org  [不建议] [默认值https://registry.npmjs.org/]
  yarn config set registry https://registry.npm.taobao.org [不建议]
~~~

 # npm 升级 & 加速器

~~~
 npm info [package-name]
 npm config ls -l                                         [检查代理等配置]
 npm i npm@latest -g                                      [建议]
 npm i --proxy=http://localhost:23547                     [建议] [不建议 npm config set proxy]
 npm i --registry=https://registry.npm.taobao.org         [建议] [不建议 npm config set registry]
 # install cnpm
 npm i -g cnpm --registry=https://registry.npm.taobao.org [代理taobao]
 npm i -g nrm	                                           [代理切换]
 # install yarn from https://yarn.bootcss.com/docs/install/
 npm i -g yarn > yarn | yarnpkg                           [包管理器]
~~~

 # npm 如何安装 (npm|yarn)

~~~
# Unix风格: -S -单个字母, GNU风格: --save --英文字符，node-cli参考: commander.js,chalk.js,Lnquirer.js,Yargs.
npm init -f                                               [初始化项目package.json]
npm i -S [--save --no-save]                               [添加项目运行时依赖包到dependencies]
npm i -D [--save-dev]                                     [添加项目开发时依赖包到devDependencies]
npm install --loglevel verbose                            [还原项目依赖,打印详细信息,检查异常!]
~~~

 # npm 全局安装包 npm install -g
  [TypeScript](https://github.com/Microsoft/TypeScriptSamples)、[机器人](https://github.com/Microsoft/BotBuilder-Samples)、[物连网](https://github.com/ms-iot/samples)
  
~~~
npm i -g node-gyp                     # 优先安装[结合VS编译]
cnpm i -g node-sass                   # 优先安装[编译sass>css]
npm i -g typescript    >tsc >tsserver # ts-node | io-ts  非tsconfig编译*.ts时，请在Git-Bash中执行 tsc *.ts && node .
npm i -g webpack webpack-cli webpack-dev-server # 配置例子 https://github.com/teabyii/webpack-examples
npm i -g @angular/cli  >ng            # 跨平台构建工具Angular2，ng set --global warnings.packageDeprecation=false
cnpm i -g vue-cli      >vue           # 构建工具Vue2.x
cnpm i -g @vue/cli     >vue           # 构建工具Vue3.x https://cli.vuejs.org
cnpm i -g weex-toolkit >weex          # 跨平台构建工具 https://github.com/apache/incubator-weex
npm i -g create-rx-app >npx           # 跨平台构建工具RN https://github.com/Microsoft/reactxp
npm i -g react-native-cli             # 跨平台构建工具RN https://reactnative.cn/docs/getting-started.html
npm i -g v8-profiler --profiler_binary_host_mirror=https://npm.taobao.org/mirrors/node-inspector/
~~~

 # npm 工具链 web 开发时 npm i -D [--save-dev]
~~~
npm i -D concurrently                 # 让"阻塞"的命令, 可以并发执行.
    # -D less,less-loader,typescript
npm i -D supervisor                   # 监视代码的改动后自动重启 Node.js 服务: supervisor / nodemon / pm2
npm i -D serve http-server            # 本地开发web服务
npm i -D local-web-server
npm i -g json-server
  > json-server ./mock/data.json <<<{"key": "value", ...}
npm i -g lite-server
  > lite-server -c ./lsconfig.js <<<{"port": 8080,"files":["./src/**/*.*"],"server":{"baseDir":"./src"}}
~~~

 # node 后端开发框架推荐 (npm|yarn) install
  [TypeScript](https://github.com/Microsoft/TypeScript-Node-Starter)、[机器人](https://botpress.io/docs)、[开源库与应用工具](https://github.com/sindresorhus/awesome-nodejs)
  
~~~
# web 框架
npm i -g express         # express项目构建 https://github.com/expressjs/express  http://www.expressjs.com.cn
npm i -g think-cli       # think基于koa2构建 https://github.com/thinkjs/thinkjs  https://thinkjs.org
npm i -S hapi            # hapi基于express构建 https://github.com/hapijs/hapi    https://hapijs.com
    # Bell 第三方登录插件
    # Good 监控日志相关插件
    # Boom 友好的 HTTP 错误返回插件
    # Joi 面向 Object Schema 的验证器插件
    # h2o2 代理转发插件
    # Catbox 缓存策略插件
    # hapi-auth-cookie 基于 Cookie 的用户认证插件
    # Inert 静态文件资源管理插件 https://github.com/hapijs/inert
    # tv 可交互式的 debug 控制台
    # Vision 网页模板渲染插件
    # Sequelize 数据库访问-ORM  https://github.com/danecando/hapi-sequelize
    # Lab & Code 测试插件
    # ...案例教程 https://github.com/yeshengfei/hapi-tutorial
    # ...学习实例 https://github.com/dwyl?utf8=✓&q=hapi&type=&language=javascript
    # ...GraphQL: http://graphql.cn/learn/ https://github.com/wesharehoodies/graphql-nodejs-hapi-api
    # 1. npm init -y           (初始app)
    # 2. yarn add hapi         (框架hapi > package.json > scripts:{"start":"nodemon app.js"} )
    # 3. yarn add knex mssql   (数据mssql)
    # 4. yarn run start        (启动app)

~~~
![](https://github.com/angenalZZZ/nodejs/raw/master/screenshots/1154173649.png)
~~~
    # 1. npm install fundebug-nodejs (监控Hapi)
    # 1.1 配置
    var fundebug = require("fundebug-nodejs");
    fundebug.apikey="fb4cbf60b1550cd9d1ba2cb3deb277010f6c77224a60d3a583faa4bd8a4352e2";
    server.on("request-error", fundebug.HapiErrorHandler);
    server.on("response", fundebug.HapiErrorHandler);
    # 1.2 等待接收错误
    fundebug.notify("Test", "Hello Fundebug!");
    
~~~

----

# node 后端开发包推荐 (npm|yarn) install

~~~
# orm 数据库访问
npm i -S mongoose  # for Mongodb https://mongoosejs.com/docs/index.html
npm i -S knex | npm i -S pg sqlite3 mysql mysql2 oracle mssql  # https://knexjs.org
npm i redis     # 高性能缓存数据库 Redis
npm i level     # 高性能缓存数据库Google LevelDB https://github.com/Level/level
npm i ssdb-node # SSDB 基于 LevelDB https://github.com/reanote/ssdb-node
npm i rxdb      # 实时数据库|实时应用 https://github.com/pubkey/rxdb

# algorithm 算法 https://github.com/jedisct1/siphash-js
npm i siphash # 随机性好、输出均匀、性能突出(可用于字典的高效查找)、偏向性小(防hash攻击)

# thread 多线程
npm i napajs # 多线程运行时 https://github.com/Microsoft/napajs

# chat, bots 聊天,机器人
npm i socket.io  # 聊天服务 https://github.com/socketio/socket.io
npm i botkit     # 聊天机器人 https://github.com/howdyai/botkit

# utility 实用
npm i rxjs       # 响应式编程的库 https://cn.rx.js.org
npm i chalk      # 命令行输出文字颜色  https://github.com/chalk/chalk
npm i commander  # 命令行神器，能帮助我们简化很多操作  http://blog.fens.me/nodejs-commander
npm i pidusage   # 检查进程(PID) / CPU & 内存的使用 https://github.com/soyuka/pidusage
npm i proxyquire # 代理 https://github.com/thlorenz/proxyquire
npm i monaco-editor # 在线代码编辑器 https://microsoft.github.io/monaco-editor/index.html

#---------------------------------------------------------------------------------
npm i -g yo jspm sqlpad @compodoc/compodoc # 标准文档生成工具
yarn global add thelounge                  # Web IRC 客户端(在线聊天服务)

~~~

----

# node 桌面应用推荐
 > [node-webkit](https://github.com/nwjs/nw.js)、[Electron](https://www.cnblogs.com/cczw/archive/2016/10/21/5984012.html)

