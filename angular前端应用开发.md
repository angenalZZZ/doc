# [**angular 前端应用开发**](https://github.com/angular/angular)

####   [**快速上手**](https://angular.cn/guide/quickstart)

> 第一步：[安装 Angular CLI 跨平台构建工具](https://angular.cn/guide/quickstart#step-1-install-the-angular-cli)

~~~
  npm install -g @angular/cli
  ng set --global warnings.packageDeprecation=false
~~~

> 第二步：[创建工作空间和初始化应用](https://angular.cn/guide/quickstart#step-2-create-a-workspace-and-initial-application)

~~~
  ng new my-app             # 创建一个简单的 "欢迎" 应用
  ng new my-app --routing   # 创建一个配置好 "路由" 的项目
~~~

> 第三步：[启动开发服务器](https://angular.cn/guide/quickstart#step-3-serve-the-application)

~~~
  cd my-app
  ng serve --open  # --open（或只用 -o）选项会自动打开浏览器，访问 http://localhost:4200
~~~

> 第四步：[使用 VSCode 编辑器 或 通过 Stackblitz 在线编辑](http://www.stackblitz.com/)

~~~
  cd my-app
  code .  # VSCode打开项目
~~~


####   [**数据绑定**](https://angular.cn/guide/displaying-data)

> `Component` 组件 = `Model` 数据流(ajax) + `View` Html模板(.html) + `Controller` 控制器(.ts) <br>
  `Component` 分类 = `Router` 页面设计(page-url) + `Business` 业务功能(interactive-use) + `Library` 基础组件(ui)

~~~
  # 1.单向绑定
   #1）控制器文件ts -> 模板文件html
    #ts:
      imgUrl: string = "1.png";
    #html:
      <img src="1.png">
      <img src="{{imgUrl}}">
      <img [src]="imgUrl">
   #2）模板文件html -> 控制器文件ts
    #html:
      <imput (keyup)="keyPress($event)">
    #ts:
      keyPress(e){ if(e.keyCode==13) console.log('你输入了回车键'); }
---------------------------------------------------------------------------
  # 2.双向绑定
   #  控制器文件ts <-> 模板文件html
    #html:
      <imput [(ngModel)]="inputEmail">
    #ts:
      # 引入FormsModule
      inputEmail: string = "b@h.cn";
    #==等价于==#
    #ts:
      # 引入FormsModule
      inputEmail: string = "b@h.cn";
      onInputEmail(e){ this.inputEmail = e.target.value; }
    #html:
      <imput [value]="inputEmail" (input)="onInputEmail($event)">
---------------------------------------------------------------------------
  # 3.css类绑定
    #html:
      <img class="a b c" src="1.png">
      <img [class.a]="aIsTrue" [class.b]="1" [class.c]="true" src="{{imgUrl}}">
      <img [ngClass]="{ a:1, b:bIsTrue, c:true }" [src]="imgUrl">
---------------------------------------------------------------------------
  # 4.style样式绑定
    #html:
      <img style="border:0;" src="1.png">
      <img [style.border]="0" src="{{imgUrl}}">
      <img [ngStyle]="{ 'border':'0px' }" [src]="imgUrl">
---------------------------------------------------------------------------
  # 5.html属性绑定
    #html:
      <img [attr.width]="imgWidth" src="{{imgUrl}}">
~~~


####   [**组件传值**](https://angular.cn/guide/component-interaction)

> `@Input` 输入 = 父组件给子组件传值 <br>
  `@Output` 输出 = 子组件调用父组件方法&传值

~~~
  # 1. @Input 父组件给子组件传值 
   #1）子组件 ts
    #ts:
      @Input() title: string;
   #2) 父组件 html
    #html:
     <app-child [title]="parentTitle"></app-child>
---------------------------------------------------------------------------
  # 2. @Input 子组件执行父组件定义的方法
   #1）子组件 ts & html
    #ts:
      @Input() exitPage;
      title = 'back home!';
    #html:
      <button (click)="exitPage(title)"></button>
   #2) 父组件 ts & html
    #html:
     <app-child [exitPage]="parentExitPage"></app-child>
    #ts:
     parentExitPage(titleOfChild){ alert(`接收数据：${titleOfChild}`); }
---------------------------------------------------------------------------
  # 3. @Output 子组件执行父组件定义的方法
   #1）子组件 ts & html
    #ts:
      @Output() exitPage = new EventEmitter();
      title = 'back home!';
    #html:
      <button (click)="exitPage.emit(title)"></button>
   #2) 父组件 ts & html
    #html:
     <app-child (exitPage)="parentExitPage($event)"></app-child>
    #ts:
     parentExitPage(e){ alert(`接收事件：${e}`); }
~~~


####   [**调用后端HTTP服务**](https://angular.cn/guide/http)

> `axios` [axios中文文档](https://www.jianshu.com/p/7a9fbcbb1114) <br>
  `rxrest` [Reactive rest library](https://github.com/soyuka/rxrest)

~~~
  # 参考官方文档
~~~


####   [**Rx 响应式编程**](http://reactivex.io/languages.html)

> `Rx` = `Observables` + `LINQ` + `Schedulers`. [ 可观察数据 > Linq操作数据 > 订阅结果数据 ] <br>
  [RxJS 中文文档](https://cn.rx.js.org)、 [RxJS调试](https://cartant.github.io/rxjs-spy)、 [交互式解释图](http://rxmarbles.com) <br>
  `ReactiveX`来自微软，它是一种针对异步数据流的编程。1它将一切数据(包括http请求、事件、数据等)包装成流的形式，2然后用强大丰富的操作符进行处理，使开发者能以同步编程方式处理异步数据，轻松实现复杂的功能。

~~~
 ____           _ ____      
|  _ \ __  __  | / ___|    
| |_) |\ \/ /  | \___ \  
|  _ <  >  < |_| |___) |    
|_| \_\/_/\_\___/|____/ 

开启 RxJS 之旅:

  var subscription = Rx.Observable.interval(500).take(4).subscribe(function (x) { console.log(x) });

引入 rxjs-spy 帮助你调试 RxJS 代码，试试下面这段代码:

  rxSpy.spy();
  var subscription = Rx.Observable.interval(500).tag("interval").subscribe();
  rxSpy.show();
  rxSpy.log("interval");

---------------------------------------------------------------------------
  # 查找Rx功能接口：
  > Object.keys(Rx)
  > ["Scheduler", "Symbol", "Subject", "AnonymousSubject", "Observable", "Subscription", "Subscriber", 
    "AsyncSubject", "ReplaySubject", "BehaviorSubject", "ConnectableObservable", "Notification", "EmptyError", 
    "ArgumentOutOfRangeError", "ObjectUnsubscribedError", "TimeoutError", "UnsubscriptionError", "TimeInterval", 
    "Timestamp", "TestScheduler", "VirtualTimeScheduler", "AjaxResponse", "AjaxError", "AjaxTimeoutError"]
  
  > Object.keys(Rx.Observable)
  > ["create", "bindCallback", "bindNodeCallback", "combineLatest", "concat", "defer", "empty", "forkJoin", 
    "from", "fromEvent", "fromEventPattern", "fromPromise", "generate", "if", "interval", "merge", "race", "never", 
    "of", "onErrorResumeNext", "pairs", "range", "using", "throw", "timer", "zip", "ajax", "webSocket"]
  
  # 创建 CREATION OBSERVABLES
  Observable.from([10,20,30]) # 参数为数组
  Observable.of(1), Observable.of(1,2,3) # 参数为0-多个可选
  Observable.interval(10)  # 每隔10ms产生一次流
  Observable.timer(30, 10) # 初始30ms后timer为10
  
  # 条件 CONDITIONAL OPERATORS
  defaultIfEmpty(true), Rx.Observable.of().defaultIfEmpty(1).subscribe(x => console.log(x)) # x=1 处理断流,没有数据流的情况.
  every(x => x < 10), Rx.Observable.of(2,3,4,5).every(x=>x<5).subscribe(x => console.log(x))# x=false 截流处理,所有流是否满足条件.
  sequenceEqual # 判断两组数据流是否完全相同(不区分时空),都完成后才返回true; 截两组流的处理,合并可截多组流.
  
  # 合并 COMBINATION OPERATORS
  combineLatest((x, y) => "" + x + y), Rx.Observable.combineLatest(Rx.Observable.of(1), 
      Rx.Observable.from(['A','B','C','D'])).map(x => x.join('')).subscribe(x => console.log(x)) # 1A 1B 1C 1D
  concat
  merge
  race
  startWith(1)
  withLatestFrom((x, y) => "" + x + y)
  zip
  
  # 过滤 FILTERING OPERATORS
  debounceTime(10)
  debounce(x => Rx.Observable.timer(10 * x))
  distinct
  distinctUntilChanged
  elementAt(2)
  filter(x => x > 10)
  find(x => x > 10)
  findIndex(x => x > 10)
  first
  ignoreElements
  last
  sample
  skip(2)
  skipUntil
  skipWhile(x => x < 5)
  take(2)
  takeLast(1)
  takeUntil
  takeWhile(x => x < 5)
  throttle(x => Rx.Observable.timer(10 * x))
  throttleTime(25)
  
  # 计算 MATHEMATICAL OPERATORS
  count(x => x > 10)
  max
  min
  reduce((x, y) => x + y)
  
  # 转换 TRANSFORMATION OPERATORS
  buffer
  bufferCount(3, 2)
  bufferTime(30)
  bufferToggle(start$, x => Observable.timer(x))
  bufferWhen
  obs1$.concatMap(() => obs2$, (x, y) => "" + x + y)
  obs1$.concatMapTo(() => obs2$, (x, y) => "" + x + y)
  map(x => 10 * x)
  mapTo("a")
  obs1$.mergeMap(() => obs2$, (x, y) => "" + x + y, 2)
  obs1$.mergeMapTo(() => obs2$, (x, y) => "" + x + y, 2)
  pairwise
  pluck("a")
  repeat(3)
  scan((x, y) => x + y)
  obs1$.switchMap(() => obs2$, (x, y) => "" + x + y)
  obs1$.switchMapTo(() => obs2$, (x, y) => "" + x + y)
  
  # 实用 UTILITY OPERATORS
  delay(20)
  delayWhen(x => Observable.timer(20 * x))
~~~

----

# 推荐功能

> [`实时数据库rxdb/angular2`](https://github.com/pubkey/rxdb/tree/master/examples/angular2)


