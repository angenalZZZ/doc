 # npm配置 package.json

   `运行：npm run dev, npm run prod...` [npm模块管理器](http://javascript.ruanyifeng.com/nodejs/npm.html)

~~~
 {
  "name": "hello-webpack",
  "version": "1.0.0",
  "description": "hello webpack app",
  "main": "src/main.js",
  "module": "es2015",
  "scripts": {
    "start": "webpack --mode=production",
    "serve": "webpack-dev-server --open",
    "dev": "SET NODE_ENV=development & webpack-dev-server",
    "prod": "SET NODE_ENV=production & webpack --mode=production -p" // windows环境
    //"prod": "NODE_ENV=production webpack --mode=production -p"  // mac、linux环境
  },
  "author": "",
  "license": "ISC",
  "devDependencies": {
    "babel-core": "^6.26.3",
    "babel-loader": "^7.1.4",
    "babel-preset-env": "^1.7.0",
    "babel-preset-es2015": "^6.24.1",
    "clean-webpack-plugin": "^0.1.19",
    "css-loader": "^0.28.11",
    "extract-text-webpack-plugin": "^3.0.2",
    "file-loader": "^1.1.11",
    "html-loader": "^0.5.5",
    "image-webpack-loader": "^4.3.1",
    "mini-css-extract-plugin": "^0.4.1",
    "sass-loader": "^7.0.3",
    "style-loader": "^0.21.0"
  }
}
~~~
 
 # webpack打包 webpack.config.js
 
~~~javascript
// 打包工具: https://github.com/webpack
// webpack: npm i -g webpack webpack-cli webpack-dev-server
//   > webpack --mode=production --watch -p [打包产品，实时打包，压缩]
var DEBUG = process.env.NODE_ENV.indexOf('production')<0; // 开发测试

// 常用插件: https://github.com/webpack-contrib
var HtmlWebpackPlugin = require('html-webpack-plugin');
var CleanWebpackPlugin = require('clean-webpack-plugin');
var MiniCssExtractPlugin = require("mini-css-extract-plugin");
// var ExtractTextPlugin = require("extract-text-webpack-plugin"); // 不兼容HMR

module.exports = {
  entry: {
    "main": __dirname + "/src/main.js", // 已多次提及的入口文件(可定义多个entry-js)
  },
  output: {
    path: __dirname + "/dist",        // 打包后的输出目录
    filename: "[name].[chunkhash].js" // 文件名{chunkhash:不同js不同hash, hash:不同js相同hash}
  },
  devtool: "eval-source-map", // default: none; 应该开发阶段使用 eval-source-map
  devServer: { // > webpack-dev-server --open
    contentBase: "./dist", // 根文件夹
    port: 3000, // 端口
    inline: true, // 实时刷新 类似于> webpack --watch
    historyApiFallback: true, // 不跳转
    proxy: {      // 代理 解决跨域问题
      "/api": {   // 反向接口地址
        target: "loocalhost:3001/api" // 反向请求地址
      }
    }
  },
  module: {
    rules: [
      // js转换工具: https://github.com/babel
      // npm i -D babel-core babel-loader babel-preset-env babel-preset-es2015
      //   > es6|es7... to es5 (大多数浏览器支持es5)
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader",
          options: { presets: ["env", "es2015"] }
        }
      },
      // css加载工具: https://github.com/webpack-contrib/css-loader
      // css转换工具: https://github.com/webpack-contrib/sass-loader
      // cnpm install node-sass -g
      // npm i -D style-loader css-loader sass-loader mini-css-extract-plugin extract-text-webpack-plugin
      //   > import css from 'file.css'
      {
        test: /\.scss$/,
        use: [
          DEBUG ? 'style-loader' : MiniCssExtractPlugin.loader,
          // 'to-string-loader', // > const css = require('./file.css').toString(); // in Angular
          { loader: 'css-loader', options: { root: '.', minimize: !DEBUG, sourceMap: DEBUG } },
          { loader: 'sass-loader', options: { includePaths: [], minimize: !DEBUG, sourceMap: DEBUG } },
        ]
      },
      // {
      //   test: /\.scss$/,
      //   use: ExtractTextPlugin.extract({ // 不兼容HMR
      //     fallback: 'style-loader',
      //     use: [
      //       // 'to-string-loader', // > const css = require('./file.css').toString(); // in Angular
      //       'css-loader', 'sass-loader'
      //     ]
      //   })
      // },
      // img加载工具: https://github.com/webpack-contrib/file-loader
      // npm i -D file-loader html-loader image-webpack-loader
      //   > import img from './file.png'
      {
        test: /\.(png|jpg|gif|svg)$/,
        use: [
          // 加载图片
          {
            loader: 'file-loader',
            options: {
              name: '[name].[ext]',
              outputPath: 'images/'
            }
          },
          // 压缩图片
          {
            loader: 'image-webpack-loader',
            options: {
              bypassOnDebug: true, // webpack@1.x
              disable: true // webpack@2.x and newer
            }
          }
        ]
      },
      {
        test: /\.(htm|html)$/,
        use: [{ loader: 'html-loader', options: { attrs: false } }]
      },
    ]
  },
  plugins: [
    // https://github.com/jantimon/html-webpack-plugin
    // npm i -D html-webpack-plugin html-minifier
    new HtmlWebpackPlugin({       // 可设置多个html
      title: "Hello Webpack",     // 修改模板html的标题
      template: "src/index.html", // 输入模板html
      filename: "index.html",     // 输出文件html 到输出目录{output.path}
      minify: {                   // 压缩html
        collapseWhitespace: true  // 去掉空白
      },
      chunks: ["main"],           // 输出文件js 对应入口文件{entry.*}
      // excludeChunks: [],       // 输出文件js 除了对应入口文件
      // hash: true, // 参数?{hash} 方便缓存
      // xhtml: true
    }),
    // https://github.com/johnagan/clean-webpack-plugin
    // npm i -D clean-webpack-plugin
    new CleanWebpackPlugin(["dist"]), // 清空输出目录{output.path}
    // https://github.com/webpack-contrib/mini-css-extract-plugin
    //   > @import "~bootstrap/dist/css/bootstrap";
    new MiniCssExtractPlugin({    // 压缩css
      filename: "[name].[chunkhash].css"
    }),
    // https://github.com/webpack-contrib/extract-text-webpack-plugin
    // new ExtractTextPlugin("styles.css"),
  ]
};
~~~
