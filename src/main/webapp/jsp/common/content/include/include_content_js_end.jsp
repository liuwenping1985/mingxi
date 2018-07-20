<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<script>
var content = {};
content.contentType = "${contentList[0].contentType}";
content.moduleType = "${contentList[0].moduleType}";
content.style = "${style}";
if(content.style==1 || (content.style==3)){
  $(function(){
    contentStyleControl();
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
                $("div",$("#mainbodyHtmlDiv_0")).css("height","auto");
            }
        }
    }catch(e){$.alert("请联系管理员，系统兼容282老数据正文内容替换高度问题！");}
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
            setHtmlH100b();
            $(".content_text").css("min-height","auto");
        };
    } else {
        if (isContentType_html) {
        	if (isContentType_html) {
                $("img",$("#mainbodyDiv")).one('load', function() {
                    fnResizeContentIframeHeight();
                }).each(function() {
                    if(this.complete) {
                        $(this).load();
                    }
                });
            };
        };
        if (isContentType_form) {

        };
        if (isContentType_activex) {
            clearContentSpacing();
            setHtmlH100b();
        };
        setTimeout(fnResizeContentIframeHeight, 500);
        if (isNeedScroll) {
            setTimeout(setContentScroll, 500);
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
//根据正文内容，设置iframe高度
function fnResizeContentIframeHeight (p) {
    if (bIsContentNewPage) {//新建表单不重新计算iframe高度
        return;
    }
    if (p == undefined) {
        var p = [];
    } else {
        var p = p;
    };
    var nIncrementHeight = 50;

    //表单增加重新设置正文iframe高度
    if (p.bIsFormAdd) {
        nIncrementHeight = 0;
    };

    var _content_view_w = $("html")[0].scrollWidth * 1;
    if ($("body",window.parent.document).width() * 1 > _content_view_w) {
        _content_view_w = $("body",window.parent.document).width();
    };
    $("#zwIframe,#cc,#display_content_view",window.parent.document).css({
        width:$("html")[0].scrollWidth,
        height:$("html")[0].scrollHeight + nIncrementHeight
    });
    $("#display_content_view",window.parent.document).width(_content_view_w);
    if ($("#displayIframe",window.parent.document).size() == 0 && content.moduleType == "1") {
        $("html").css("overflow","hidden")
    };
    try{//切换表单模式后 重新计算意见区高度。
        var _conHeight = parent.$("#cc").height();
        parent._xConHeightobj.setGoToHeight(parseInt(_conHeight));
    }catch(e){}; 
}
</script>