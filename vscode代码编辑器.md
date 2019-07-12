
# **安装 [Visual Studio Code](https://github.com/microsoft/vscode)**

~~~
mac    > https://code.visualstudio.com/docs/setup/mac
linux  > https://code.visualstudio.com/docs/setup/linux
windows> https://code.visualstudio.com/docs/setup/windows
network> https://code.visualstudio.com/docs/setup/network
~~~

##  安装.NET [Install .NET Core SDK](https://www.microsoft.com/net/learn/dotnet/hello-world-tutorial)

####  1.插件扩展 [Extensions for the Visual Studio family of products](https://marketplace.visualstudio.com/vscode)

~~~
> 环境Env
    1. DotNet: C#扩展、Roslyn & OmniSharp、vscode-solution-explorer、.NET Core Test Explorer

> 快捷键Key
    1. 命令: Ctrl + Shift + P
    2. 格式化代码: Shift + Alt + F
    3. 编码时查找方法接口: Ctrl + T

> 同步配置Code
  1. 安装扩展Settings Sync
     > Shift + Alt + U 上传配置
       1) 获取你的GitHub帐户访问令牌 : New personal access token > code-settings-sync (填写Token描述后选gist)
       2) 按快捷键，它将询问您的GitHub帐户访问令牌 | github.com/settings/tokens (可重新生成Token)
       3) 自动上传您的设置，扩展程序会在系统消息中为您提供私有的GistID (注意保存,用于下载配置和共享给其它电脑使用)
       4) 验证GistID | https://gist.github.com/{YourName}/{GistID}
     > Shift + Alt + D 下载配置
       1) 按快捷键，它将询问您的GistID (个人私有的Gist)
       2) 公共的 Gist | 52ABP框架/开发环境/设置同步扩展工具 | 52abp.com
          首先按 F1 进入命令行，然后输入sync ；选择重置设置(保证本地的配置为清空状态)
          选择高级选项；Sync:从公开的 Gist 下载设置；再选择下载设置(F1>sync>“下载设置”)
          输入公共的gist：
            437fd3b1068fb13810418c1ddd84ca57
            149022554137a8df48d795eb8b8298ec
---------------------------------------------------------------------------------
Restarting Visual Studio Code may be required to apply color and file icon theme.
--------------------
Files Uploaded:
  extensions.json > extensions.json
  keybindings.json > keybindings.json
  locale.json > locale.json
  settings.json > settings.json
  csharp.json > snippets|csharp.json

Extensions Ignored:
  No extensions ignored.

Extensions Removed:
  Feature Disabled.

Extensions Added:
  Angular-BeastCode v8.0.7
  Angular2 v0.4.1
  aspnet-helper v0.6.4
  auto-close-tag v0.5.6
  auto-rename-tag v0.1.0
  autoimport v1.5.3
  beautify v1.5.0
  Bookmarks v10.4.4
  bootstrap-v4-snippets v1.1.1
  code-settings-sync v3.2.9
  csharp v1.20.0
  debugger-for-chrome v4.11.4
  EditorConfig v0.13.0
  githistory v0.4.6
  guides v0.9.3
  html-css-class-completion v1.19.0
  html-snippets v0.2.1
  iis-express v1.1.2
  markdown-all-in-one v2.4.0
  markdown-pdf v1.2.0
  ng-alain-vscode v7.0.0
  ng-template v0.800.0
  ng-zorro-vscode v7.3.4
  npm-intellisense v1.3.0
  prettier-vscode v1.9.0
  quokka-vscode v1.0.227
  translator v0.0.3
  tsimporter v2.0.1
  tslint v1.0.43
  typelens v1.6.6
  typescript-javascript-grammar v0.0.50
  vscode-angular2-files v1.6.2
  vscode-eslint v1.9.0
  vscode-icons v8.7.0
  vscode-language-pack-zh-hans v1.35.1
  vscode-markdownlint v0.28.0
  vscode-todo-highlight v1.0.4
  vscodeintellicode v1.1.7

 ~~~

####  2.帮助文档
  [52ABP框架/开发文档](https://gitee.com/aiabpedu/dashboard/wikis/aiabpedu%2F52abp_framework_programming?doc_id=183193&sort_id=833878)

