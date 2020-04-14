# 视频播放器

> ckplayer.js
~~~
  //以下为调用播放器的标准代码
  //var flashvars=new Object();
  //var newurl="rtmp://livecdn.pull.cdbs.com.cn/live/fmvideo";

  function playload(newurl,w,h){
      document.getElementById('player').innerHTML='<div id="a1"></div>';//重置一下容器video
      var	flashvars={
          f:newurl,//视频地址
          c:0,
          p:1//视频默认0是暂停，1是播放
          //loaded:'loadedHandler'
          //my_summary:'支持播放flv，f4v，mp4，rtmp',//视频介绍，请保持在一行文字，不要换行
          //my_pic:'http://www.ckplayer.com/temp/11.jpg'//分享的图片地址
          //调用自定义播放器参数结束
      };
      //var params={bgcolor:'#000000',allowFullScreen:true,allowScriptAccess:'always'};//这里定义播放器的其它参数如背景色（跟flashvars中的b不同），是否支持全屏，是否支持交互
      var attributes={id:'ckplayer_a1',name:'ckplayer_a1'};

      //CKobject.embedSWF('/statics/js/ckplayer/ckplayer.swf','a1','ckplayer_a1','600','450',flashvars);
      CKobject.embedSWF('/statics/js/ckplayer/ckplayer.swf','a1','ckplayer_a1',w,h,flashvars);
      //调用播放器结束
  }
  function loadedHandler(){
      if(CKobject.getObjectById('ckplayer_a1').getType()){
          // alert('播放器已加载，调用的是HTML5播放模块');
          CKobject.getObjectById('ckplayer_a1').addListener('play',playHandler);
      }
      else{
          // alert('播放器已加载，调用的是Flash播放模块');
          CKobject.getObjectById('ckplayer_a1').addListener('play','playHandler');
      }
  }
~~~
