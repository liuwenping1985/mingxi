if(content.style==1 || (content.style==3)){
  $(function(){
    //contentStyleControl();
	// setOffice();
    //setTimeout(function(){
        // fnResizeContentIframeHeight();
    //},500)
    // fnSetHtmlH100b();
    // fuResizeIframeMainHeight();
    // fnClearContentPadding();

    //setTimeout(function(){
        // fnSetContentScroll();
    //},550);

    try{
        if($("#mainbodyHtmlDiv_0").size() > 0){
            if( document.getElementById("officeFrameDiv")){
                $("div",$("#mainbodyHtmlDiv_0")).css("height","100%");
            }else{
            	if(content.contentType!="20"){
            		$("div",$("#mainbodyHtmlDiv_0")).css("height","auto");
            	}
            }
        }
    }catch(e){$.alert("请联系管理员，系统兼容282老数据正文内容替换高度问题！");}
    contentStyleControl();
  })
}

$(function(){
	content_loadComplete();
})
  //新建页面，清楚正文区域padding值
  function fnClearContentPadding() {
    if ((typeof window.parent.bIsClearContentPadding != "undefined" && window.parent.bIsClearContentPadding == true) || (typeof bIsClearContentPadding != "undefined" && bIsClearContentPadding == true)) {
        $(".content_text").css("padding","0");
    };
  }

  //新建页面调用，调整高度
  function fuResizeIframeMainHeight() {
    setTimeout(function(){
      if (!window.parent.document.getElementById("zwIframe")) {
        $("#mainbodyDiv").height("100%");
      };
    },1000)
  }
  //新建页面，iframe调用正文组件：html和body加高100%，否则comp-debug，$.fn.showE计算错误
  function fnSetHtmlH100b() {
    if (typeof window.parent.bIsContentIframe == "undefined") {
      return;
    }
    if (typeof window.parent.bIsContentNewPage == "undefined") {
      return;
    }
    if (window.parent.bIsContentIframe && window.parent.bIsContentNewPage) {
        $("html,body,#bodyBlock").css("height","100%");
    };
  }

  function fnSetContentScroll(b) {
    //如果true，显示滚动条
    if (b == true) {
      $("html").css("overflow", "auto");
      return;
    };
    //如果false，隐藏滚动条
    if (b == false) {
      $("html").css("overflow", "hidden");
      return;
    };
    //---如果不传参，变量控制---
    if (window.bIsContentScroll == true || window.parent.bIsContentScroll == true) {
      $("html").css("overflow", "auto");
      return;
    };
    if (window.bIsContentScroll == false || window.parent.bIsContentScroll == false) {
      $("html").css("overflow", "hidden");
      return;
    };
  }

  //如果是OFFICE正文，设置宽度高度
  function setOffice(){
    //当开启office转换后，隐藏这句话“当前浏览器不支持Office正文，请您使用IE浏览器并安装Office控件”
    if (typeof(trans2Html) !='undefined') {
      $("center").hide();
    }
    if (window.parent.bIsContentNewPage != true) {
      // office插件，高度设置
      var _obj_office = $("#officeFrameDiv");
      if ((_obj_office.size() * 1) === 1) {
        _obj_office.height(800);
      }
      // office编辑，高度设置
      var _obj_officeTrans = $("#officeEditorFrame");
      if ((_obj_officeTrans.size() * 1) === 1) {
        _obj_officeTrans.height(800);
      }
    }
    // office转换，高度设置
    var _obj_officeTrans = $("#officeTransIframe");
    if ((_obj_officeTrans.size() * 1) === 1) {
      _obj_officeTrans.height(800);
    }
  }
  // ==========================================
  // ${style}
  //    1 是指表单用的infoPath模式
  //    3 是指轻表单模式
  //    4 是移动模式
  // ${contentList[0].contentType}
  //    10 普通协同
  //    20 表单
  //    30 text正文
  //    41 OfficeWord
  //    42 OfficeExcel
  //    43 WpsWord
  //    44 WpsExcel
  //    45 PDF
  // 新建协同、修改正文内容、新建计划、新建会议、新建讨论、新建文档
  // 协同处理、查看计划、查看会议、



// 普通协同？
var isContentType_html = function () {
    if (content.contentType == 10) {
        return true;
    }
    return false;
}();
// 表单？
var isContentType_form = function () {
    if (content.contentType == 20) {
        return true;
    }
    return false;
}();
// activex插件？
var isContentType_activex = function () {
    var num = content.contentType;
    if (num == 41 || num == 42 || num == 43 || num == 44 || num == 45) {
        return true;
    }
    return false;
}();

// 新建页面
var bIsContentNewPage = window.parent.bIsContentNewPage || window.bIsContentNewPage || false;
var isNeedScroll = window.parent.isNeedScroll || window.isNeedScroll || false;

// 正文组件样式控制器
function contentStyleControl () {
    if (bIsContentNewPage) {
        if (!isContentType_form) {
            clearContentSpacing();
            if(typeof(_isFowardForm) == "undefined"){//转发的表单不能overflow:hidden;  OA-101187
              setHtmlH100b();
            }else if(typeof(_isFowardForm) != "undefined" && viewState == "1"){//可以编辑的转发的表单  OA-104062
              setHtmlH100b();
            }
            $(".content_text").css("min-height","auto");
        };
    } else {
        if (isContentType_html) {
            //Safari浏览器  长图计算高度有问题
            if(navigator.userAgent.indexOf("Safari") != -1){
                $("img",$("#mainbodyDiv")).load(function() {
                    if(this.complete) {
                      fnResizeContentIframeHeight();
                    }
                });
            }else{
                $("img",$("#mainbodyDiv")).one('load', function() {
                    fnResizeContentIframeHeight();
                }).each(function() {
                    if(this.complete) {
                        $(this).load();
                    }
                });
            }

        };

        if (isContentType_activex) {
            clearContentSpacing();
            setHtmlH100b();
        };

        if(isContentType_form || typeof(_isFowardForm) != "undefined"){
          //只有表单和转发的表单才延迟计算，延迟原因: include_mainbody.jsp里面的initFormContent方法有延迟
          setTimeout(fnResizeContentIframeHeight, 500);
        }else{
          //普通正文直接算高度，不延迟
          fnResizeContentIframeHeight();
        }
        if (isNeedScroll) {
            setContentScroll();
        };
    };
}
//清除外侧间距，padding,margin
function clearContentSpacing () {
    $(".content_text").css({
        "padding": 0,
        "margin": 0
    });
}
function setContentScroll () {
    $("html").css("overflow", "auto");
}
//设置高度100%
function setHtmlH100b () {
    $("html,body,#bodyBlock").css({
        "height": "100%",
        "overflow": "hidden"
    });
}
var oldHeight = 0;
//根据正文内容，设置iframe高度
function fnResizeContentIframeHeight (p) {
    if (bIsContentNewPage) {//新建表单不重新计算iframe高度
        return;
    }

    var $html = $("html");
    var $html0 =$html[0];
    var parentDocument = window.parent.document;
    var _content_view_w = 0;

    var $body = $("body",parentDocument);
    var $zwIframe = $("#zwIframe",parentDocument);
    var $cc = $("#cc",parentDocument);
    var $displayContentView = $("#display_content_view",parentDocument);

    //在#zwIframe加载完成之后再计算
    /*$("#zwIframe",parentDocument).load(function(){
      _content_view_w = $html0.scrollWidth * 1;
    })*/

    if ($body.width() * 1 > _content_view_w) {
        _content_view_w = $body.width();
    };
    var newScrollWidth = $html0.scrollWidth;
    if($html0.scrollWidth<_content_view_w && $html0.scrollWidth!=786 &&(_content_view_w-newScrollWidth)<30){//如果只是差异一个滚动条的宽度且不是标准正文，以_content_view_w为准
      newScrollWidth = _content_view_w;//  OA-93850    OA-94589
    }
    if(newScrollWidth != 0){//当正文没加载出来的时候不做宽度、高度处理
        $zwIframe.css("width", newScrollWidth);
        $cc.css("width", newScrollWidth);
    }

    $displayContentView.width(_content_view_w);

    if ($("#displayIframe",parentDocument).size() == 0 && content.moduleType == "1" && $zwIframe.size() == 1) {
        $html.css("overflow","hidden")
    }


    //ie8下面布局还没算出来，延迟异步高度计算，不然算出来也不对....
    if(($.browser.msie&&parseInt($.browser.version,10) == 8) && $body.height() ==0){
      setTimeout(function(){
        fnResizeContentIframeHeight();
      },50);
      return;
    }

    //start
    //6.0新需求，当内容高度很少时，正文自适应高度
    var _client_height = parent.document.documentElement.clientHeight;
    var replyHeight= $("#replyContent_sender",parentDocument).outerHeight(true);//附言区域
    var commentHeight= $("#currentComment",parentDocument).outerHeight(true);//意见区
    var commentForwardDivHeight = $("#commentForwardDivOut",parentDocument).outerHeight(true);//转发的协同 原来处理意见

    var $mainBodyDiv = $("#mainbodyDiv");
    var zwIframeRightHeight= $mainBodyDiv.height()<300?300:$mainBodyDiv.height();//新需求，最小高度300
    var _fix_height = _client_height - zwIframeRightHeight - replyHeight - commentHeight - commentForwardDivHeight;

    if(zwIframeRightHeight != 0){//当正文没加载出来的时候不做高度处理
      //当内容不足一屏  30是当只有一行的时候。增加高度30px
        var tempHeight = 0;
      if(_fix_height>10){
        var zwIframeRightHeight = _client_height - replyHeight - commentHeight - commentForwardDivHeight;
        tempHeight = zwIframeRightHeight;
      }else{//当内容超过一屏
          tempHeight = zwIframeRightHeight+30;
      }

      $zwIframe.css("height", tempHeight + "px");
      $cc.css("height", tempHeight + "px");
      $displayContentView.css("height", tempHeight + "px");
      oldHeight = tempHeight;
    }
    //end

    try{//切换表单模式后 重新计算意见区高度。
        var _conHeight = $cc.height();
        parent._xConHeightobj.setGoToHeight(parseInt(_conHeight));
    }catch(e){};
}
