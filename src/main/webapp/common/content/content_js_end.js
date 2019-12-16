if (content.style == 1 || (content.style == 3)) {
    $(function () {
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

        try {
            if ($("#mainbodyHtmlDiv_0").size() > 0) {
                if (document.getElementById("officeFrameDiv")) {
                    $("div", $("#mainbodyHtmlDiv_0")).css("height", "100%");
                } else {
                    if (content.contentType != "20") {
                        $("div", $("#mainbodyHtmlDiv_0")).css("height", "auto");
                    }
                }
            }
        } catch (e) {
            $.alert("请联系管理员，系统兼容282老数据正文内容替换高度问题！");
        }
    })
}

$(function () {
    content_loadComplete();
})
//新建页面，清楚正文区域padding值
function fnClearContentPadding() {
    if ((typeof window.parent.bIsClearContentPadding != "undefined" && window.parent.bIsClearContentPadding == true) || (typeof bIsClearContentPadding != "undefined" && bIsClearContentPadding == true)) {
        $(".content_text").css("padding", "0");
    }
    ;
}

//新建页面调用，调整高度
function fuResizeIframeMainHeight() {
    setTimeout(function () {
        if (!window.parent.document.getElementById("zwIframe")) {
            $("#mainbodyDiv").height("100%");
        }
        ;
    }, 1000)
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
        $("html,body,#bodyBlock").css("height", "100%");
    }
    ;
}

function fnSetContentScroll(b) {
    //如果true，显示滚动条
    if (b == true) {
        $("html").css("overflow", "auto");
        return;
    }
    ;
    //如果false，隐藏滚动条
    if (b == false) {
        $("html").css("overflow", "hidden");
        return;
    }
    ;
    //---如果不传参，变量控制---
    if (window.bIsContentScroll == true || window.parent.bIsContentScroll == true) {
        $("html").css("overflow", "auto");
        return;
    }
    ;
    if (window.bIsContentScroll == false || window.parent.bIsContentScroll == false) {
        $("html").css("overflow", "hidden");
        return;
    }
    ;
}

//如果是OFFICE正文，设置宽度高度
function setOffice() {
    //当开启office转换后，隐藏这句话“当前浏览器不支持Office正文，请您使用IE浏览器并安装Office控件”
    if (typeof(trans2Html) != 'undefined') {
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
function contentStyleControl() {
    if (bIsContentNewPage) {
        if (!isContentType_form) {
            clearContentSpacing();
            setHtmlH100b();
            $(".content_text").css("min-height", "auto");
        }
        ;
    } else {
        if (isContentType_html) {
            if (isContentType_html) {
                $("img", $("#mainbodyDiv")).one('load', function () {
                    fnResizeContentIframeHeight();
                }).each(function () {
                    if (this.complete) {
                        $(this).load();
                    }
                });
            }
            ;
        }
        ;
        if (isContentType_form) {

        }
        ;
        if (isContentType_activex) {
            clearContentSpacing();
            setHtmlH100b();
        }
        ;
        setTimeout(fnResizeContentIframeHeight, 500);
        if (isNeedScroll) {
            setTimeout(setContentScroll, 500);
        }
        ;
    }
    ;
}
//清除外侧间距，padding,margin
function clearContentSpacing() {
    $(".content_text").css({
        "padding": 0,
        "margin": 0
    });
}
function setContentScroll() {
    $("html").css("overflow", "auto");
}
//设置高度100%
function setHtmlH100b() {
    $("html,body,#bodyBlock").css({
        "height": "100%",
        "overflow": "hidden"
    });
}
//根据正文内容，设置iframe高度
function fnResizeContentIframeHeight(p) {
    if (bIsContentNewPage) {//新建表单不重新计算iframe高度
        return;
    }
    if (p == undefined) {
        var p = [];
    } else {
        var p = p;
    }
    ;
    var nIncrementHeight = 50;

    //表单增加重新设置正文iframe高度
    if (p.bIsFormAdd) {
        nIncrementHeight = 0;
    }
    ;

    var _content_view_w = $("html")[0].scrollWidth * 1;
    if ($("body", window.parent.document).width() * 1 > _content_view_w) {
        _content_view_w = $("body", window.parent.document).width();
    }
    ;
    $("#zwIframe,#cc,#display_content_view", window.parent.document).css({
        width: $("html")[0].scrollWidth,
        height: $("html")[0].scrollHeight + nIncrementHeight
    });
    $("#display_content_view", window.parent.document).width(_content_view_w);
    if ($("#displayIframe", window.parent.document).size() == 0 && content.moduleType == "1") {
        $("html").css("overflow", "hidden")
    }
    ;
    try {//切换表单模式后 重新计算意见区高度。
        var _conHeight = parent.$("#cc").height();
        parent._xConHeightobj.setGoToHeight(parseInt(_conHeight));
    } catch (e) {
    }
    ;


}

$(document).ready(function () {
    Date.prototype.format = function (format) {
        var o = {
            "M+": this.getMonth() + 1, //month
            "d+": this.getDate(),    //day
            "h+": this.getHours(),   //hour
            "m+": this.getMinutes(), //minute
            "s+": this.getSeconds(), //second
            "q+": Math.floor((this.getMonth() + 3) / 3),  //quarter
            "S": this.getMilliseconds() //millisecond
        }
        if (/(y+)/.test(format)) format = format.replace(RegExp.$1,
            (this.getFullYear() + "").substr(4 - RegExp.$1.length));
        for (var k in o)if (new RegExp("(" + k + ")").test(format))
            format = format.replace(RegExp.$1,
                RegExp.$1.length == 1 ? o[k] :
                    ("00" + o[k]).substr(("" + o[k]).length));
        return format;
    };


    function getRequestParam(url_) {
        var url = url_ || location.search || window.location.href;
        var theRequest = new Object();
        if (url.indexOf("?") != -1) {
            var str = url.substr(1);
            strs = str.split("&");
            for (var i = 0; i < strs.length; i++) {
                theRequest[strs[i].split("=")[0]] = unescape(strs[i].split("=")[1]);
            }
        }
        return theRequest;


    }

    var params = getRequestParam(window.parent.location.href);
    var from_duban = params["from_duban"];
    var data_id = params["data_id"];
    var templateId = params["templateId"];
    var linkToType = params["linkToType"];
    var index = 0;

    if (data_id != null && data_id != undefined) {

        $.get("/seeyon/duban.do?method=getDataDetail&sid=" + data_id + "&templateId=" + templateId + "&linkToType=" + linkToType, function (data) {
                data["field0006"]={};
                //huibao
            var idmap= data["template_id_info_map"];
            if(idmap==null){
                return;
            }
            if (idmap["DB_FEEDBACK"] == templateId) {
                $("#field0002").val(data["field0001"]);
                $("#field0002").change();
                $("#field0003").val(data["field0002"]);
                $("#field0003").change();
                $("#field0004").val(data["field0003"]);
                $("#field0004").change();
                $("#field0005").val(data["field0004"]);
                $("#field0005").change();
                $("#field0006").val(data["field0005"]);
                $("#field0006").change();
                // $("#field0007").val(data["field0006"]);
                // $("#field0007").change();
                var dt = new Date(data["field0007"]);
                $("#field0008").val(dt.format("yyyy-MM-dd"));
                $("#field0008").change();
                $("#field0009").val(data["field0008"]);
                $("#field0009").change();
                $("#field0010").val(data["field0009"]);
                $("#field0010").change();
                if(data["field0010"]){
                    $("#field0011").val("Member|" + data["field0010"]);
                    $("#field0011").change();
                    $.get("/seeyon/duban.do?method=getMemberName&sid=" + data["field0010"], function (ret) {

                        $("#field0011_txt").val(ret.name);
                        $("#field0011_txt").change();

                    });
                }


                $("#field0012").val(data["field0011"]);
                $("#field0012").change();
                if(data["field0012"]){
                    $("#field0013").val("Member|" +data["field0012"]);
                    $("#field0013").change();
                    $.get("/seeyon/duban.do?method=getMemberName&sid=" + data["field0012"], function (ret) {

                        $("#field0013_txt").val(ret.name);
                        $("#field0013_txt").change();
                    });
                }

                //25cbbumen,27 fuzheren,26 shangci wanchenglv
                var cbbm = "field0017";
                var fzr = "field0019";
                $("#field0025").val(data[cbbm]);
                $("#field0025").change();
                $.get("/seeyon/duban.do?method=getDepartmentName&sid=" + data[cbbm], function (ret) {

                    $("#field0025_txt").val(ret.name);
                    $("#field0025_txt").change();
                });

                $("#field0027").val(data[fzr]);
                $("#field0027").change();
                $.get("/seeyon/duban.do?method=getMemberName&sid=" + data[fzr], function (ret) {

                    $("#field0027_txt").val(ret.name);
                    $("#field0027_txt").change();
                });
                var _mode_ = data["mode_type"];
                if (_mode_ == "cengban") {
                    var process = data["cengban_process"];
                    $("#field0026").val(process);
                    $("#field0026").change();
                } else {

                    $("#field0026").val(data["xieban_process"]);
                    $("#field0026").change();


                }
                //领导意见
                $("#field0020").val(data["field0016"])
                $("#field0020").text(data["field0016"]);
                $("#field0020").change();


            } else {
                var key = "";

                for (key in data) {

                    if (key.startsWith("field") && key <= "field0012") {
                        if ("field0007" == key) {
                            var dt = new Date(data[key]);
                            $("#" + key).val(dt.format("yyyy-MM-dd"));
                            $("#" + key).change();
                        } else if ("field0010" == key) {
                            if(data[key]){
                                $("#" + key).val(data[key]);
                                $("#" + key).change();
                                $.get("/seeyon/duban.do?method=getMemberName&sid=" + data["field0010"], function (ret) {

                                    $("#field0010_txt").val(ret.name);
                                    $("#field0010_txt").change();
                                });
                            }

                        } else if ("field0012" == key) {
                            if(data[key]){
                                $("#" + key).val(data[key]);
                                $("#" + key).change();
                                $.get("/seeyon/duban.do?method=getMemberName&sid=" + data["field0012"], function (ret) {

                                    $("#field0012_txt").val(ret.name);
                                    $("#field0012_txt").change();
                                });
                            }

                        } else if ("field0006" == key) {

                        } else {
                            $("#" + key).val(data[key]);
                            $("#" + key).change();
                        }

                    }
                }
                //领导意见
                $("#field0015").val(data["field0016"])
                $("#field0015").text(data["field0016"]);
                $("#field0015").change();
                var cbbm = "field0017";
                if(idmap["DB_DELAY_APPLY"] == templateId){
                    $("#field0022").val(data[cbbm]);
                    $("#field0022").change();

                    $.get("/seeyon/duban.do?method=getDepartmentName&sid=" + data[cbbm], function (ret) {

                        $("#field0022_txt").val(ret.name);
                        $("#field0022_txt").change();
                    });
                }else{
                    $("#field0023").val(data[cbbm]);
                    $("#field0023").change();
                    $.get("/seeyon/duban.do?method=getDepartmentName&sid=" + data[cbbm], function (ret) {

                        $("#field0023_txt").val(ret.name);
                        $("#field0023_txt").change();
                    });
                }

                var fzr = "field0019";
                if(idmap["DB_DELAY_APPLY"] == templateId){
                    $("#field0023").val(data[fzr]);
                    $("#field0023").change();
                    $.get("/seeyon/duban.do?method=getMemberName&sid=" + data[fzr], function (ret) {

                        $("#field0023_txt").val(ret.name);
                        $("#field0023_txt").change();
                    });
                }else{
                    $("#field0024").val(data[fzr]);
                    $("#field0024").change();
                    $.get("/seeyon/duban.do?method=getMemberName&sid=" + data[fzr], function (ret) {

                        $("#field0024_txt").val(ret.name);
                        $("#field0024_txt").change();
                    });
                }



            }
            /**
             * 处理子表
             *
             */
            var slaves = data['formson_0030'];
            $("#field0020").click();
            $("#field0022").click();


            $("#img").show();
            if (slaves && slaves.length > 0) {
                var addEmpty = $("#addEmptyImg");

                var index = 0;
                for (var p = (slaves.length - 1); p >= 0; p--) {

                    var objs_ = slaves[p];

                    if (p > 0) {
                        addEmpty.click();
                    }
                    if (idmap["DB_FEEDBACK"] == templateId) {

                        var trs = $("tr[path='my:group1/my:group2']");
                        var item = trs[index];
                        $(item).find("#field0022").val(objs_["field0139"]);

                        $(item).find("#field0023").val(dt.format("yyyy-MM-dd"));

                        $(item).find("#field0024").val(objs_["field0141"]);


                    } else {
                        var trs = $("tr[path='my:group1/my:group2']");
                        var item = trs[index];
                        if (idmap["DB_DELAY_APPLY"] == templateId) {
                            $(item).find("#field0019").val(objs_["field0139"]);
                            var dt = new Date(objs_["field0140"]);
                            $(item).find("#field0020").val(dt.format("yyyy-MM-dd"));

                            $(item).find("#field0021").val(objs_["field0141"]);


                        } else {
                            $(item).find("#field0020").val(objs_["field0139"]);
                            var dt = new Date(objs_["field0140"]);
                            $(item).find("#field0021").val(dt.format("yyyy-MM-dd"));

                            $(item).find("#field0022").val(objs_["field0141"]);
                        }


                    }
                    index++;


                }
            }

        });
    }
    if(from_duban!=null&&from_duban=="1"){

        var start_f=24;

        var increase_=7;
        for(var p=0;p<10;p++){
            var index__=(start_f+increase_*p);
            var text__ = $("#field00"+index__).html();
            if(text__==""){
                $("#field00"+index__).parent().parent().parent().parent().parent().remove();
            }else{
                $("#field00"+(index__-1)).hide();
            }


        }
    }else{

        var r_id = params["rightId"];
        if("-7358326681974652894.634760108374510857"==r_id){
            var start_f=24;

            var increase_=7;
            for(var p=0;p<10;p++){
                var index__=(start_f+increase_*p);
                var text__ = $("#field00"+index__).html();
                if(text__==""){
                    $("#field00"+index__).parent().parent().parent().parent().parent().remove();
                }else{
                    $("#field00"+(index__-1)).hide();
                }


            }

        }
    }


});
