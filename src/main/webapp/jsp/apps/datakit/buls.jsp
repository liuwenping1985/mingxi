<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://v3x.seeyon.com/bridges/spring-portlet-html" prefix="html"%>

<fmt:setBundle basename="com.seeyon.v3x.system.resources.i18n.SysMgrResources" var="v3xSysI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources" var="v3xCommonI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.main.resources.i18n.MainResources"/>
<fmt:setBundle basename="com.seeyon.v3x.edoc.resources.i18n.EdocResource"  var="v3xEdocI18N"/>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/edoc/css/edoc.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<link href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />" type="text/css" rel="stylesheet">

<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery-1.11.3.min.js" />"></script>
<script type="text/javascript">
 var p_f = window.parent;
          if(p_f){
            p_f.$("#main").show();
            /*
           <span class="nowLocation_content" style="color: rgb(60, 60, 60);"><a style="cursor: default; color: rgb(60, 60, 60);">协同工作</a> &gt; <a class="hand" onclick="showMenu('/seeyon/collaboration/collaboration.do?method=listPending')" style="color: rgb(60, 60, 60);">待办事项</a></span></div>
            */
            p_f.$("#nowLocation").html("");	
            //p_f.$("#nowLocation").show();
          }
</script>
</head>
<body srcoll="no" style="overflow: hidden;border:0;" class="tab-body">
    <table>

        <tr>
                <td valign="bottom" height="26" class="tab-tag" style="">

                        <table width="100%" id="main-table" cellpadding="0" cellspacing="0" style='table-layout:fixed'>
                                <tr>
                                        <td width='23' valign="bottom" id="left-td" class="cursor-hand hidden">
                                                <div class='mxt_to_left' id='oMxtToLeft'  onclick="left()">
                                                </div>
                                            </td>
                                            <td style="padding: 0; margin: 0">
                                            <div id='scrollborder' style='overflow:hidden; height: 26px;width:100%;padding: 0; margin: 0'>
                                                <div id="menuTabDiv" class="div-float" style="word-break:keep-all;white-space:nowrap; width: auto">
                                                    
                                                    <div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
       
                                                  
                                                    
                                                        
                                                    <span class="resCode rikazeCode" resCodeParent="">
                                                        <div class="tab-tag-left-sel" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                                                        <div  class="tab-tag-middel-sel" style="word-break:keep-all;white-space:nowrap;clear: right;" onclick="changeTabByRikaZe('publish')">发布</div>
                                                        <div class="tab-tag-right-sel" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                                                        <div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                                                    </span>
                                                    <span class="resCode rikazeCode" resCodeParent="">
                                                            <div class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                                                            <div  class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;" onclick="changeTabByRikaZe('manage')">板块管理</div>
                                                            <div class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                                                            <div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                                                        </span>    
                                                </div>
                                            </div>
                                        </td>
                                </tr>
                               
                        </table>
                </td>
        </tr>
        <tr>
                <td class="" style="margin: 0px;padding:0px;padding-top: 1px;">
                <iframe id="detailIframe" style="min-height:800px" name="detailIframe" width="100%" height="760px" scrolling="no" frameborder="0" marginheight="0" marginwidth="0"></iframe>		
                </td>
            </tr>
    </table>
<script>
    	function anaParams() {
    var name, value;
    var str = location.href; //取得整个地址栏
    var num = str.indexOf("?")
    str = str.substr(num + 1); //取得所有参数   stringvar.substr(start [, length ]

    var arr = str.split("&"); //各个参数放到数组里
    var params = {};
    for (var i = 0; i < arr.length; i++) {
        num = arr[i].indexOf("=");
        if (num > 0) {
            name = arr[i].substring(0, num);
            value = arr[i].substr(num + 1);
            params[name] = value;
        }
    }
    return params;
}
    var g_links={
        "gzdt":{
            "name":"工作动态",
            "publish":"/seeyon/newsData.do?method=publishList&newsTypeId=1&spaceType=2&spaceId=&custom=",
            "manage":"/seeyon/newsData.do?method=list&condition=&textfield=&type=1&spaceType=2&spaceId=&showAudit=false&custom="
        },
        "xxjb":{
            "name":"信息简报",
            "publish":"/seeyon/newsData.do?method=publishList&newsTypeId=2&spaceType=2&spaceId=&custom=",
            "manage":"/seeyon/newsData.do?method=list&condition=&textfield=&type=2&spaceType=2&spaceId=&showAudit=false&custom="
        },
        "tzgg":{
            "name":"通知公告",
            "publish":"/seeyon/bulData.do?method=publishList&spaceType=2&bulTypeId=1&spaceId=",
            "manage":"/seeyon/bulData.do?method=list&condition=&textfield=&type=1&spaceType=2&custom=&showAudit=false&spaceId="
        },
        "ywzn":{
            "name":"工作指南",
            "publish":"/seeyon/bulData.do?method=publishList&spaceType=2&bulTypeId=-4695372691792968435&spaceId=",
            "manage":"/seeyon/bulData.do?method=list&condition=&textfield=&type=-4695372691792968435&spaceType=2&custom=&showAudit=false&spaceId="
        },
        "xxjl":{
            "name":"学习交流",
            "publish":"/seeyon/bulData.do?method=publishList&spaceType=2&bulTypeId=-4083198690925721448&spaceId=",
            "manage":"/seeyon/bulData.do?method=list&condition=&textfield=&type=-4083198690925721448&spaceType=2&custom=&showAudit=false&spaceId="
        },
        "xzzx":{
            "name":"下载中心",
            "publish":"/seeyon/bulData.do?method=publishList&spaceType=2&bulTypeId=-1365569722735310114&spaceId=",
            "manage":"/seeyon/bulData.do?method=list&condition=&textfield=&type=-1365569722735310114&spaceType=2&custom=&showAudit=false&spaceId="
        }

    }
    function changeTabByRikaZe(resCode){
        var params = anaParams();
        if(resCode == "publish"){
            var link = g_links[params.type]["publish"];
            $("#detailIframe").attr("src",link);
           // console.log(getA8Top());
          
        }
        if(resCode == "manage"){
            var link = g_links[params.type]["manage"];
            $("#detailIframe").attr("src",link);
        }
       

    }
    function showLocation(type){
        p_f.$("#nowLocation").html(' <span class="nowLocation_ico"><img src="/seeyon/main/skin/frame/GOV_red/menuIcon/personal.png"></span><span class="nowLocation_content" style="color: rgb(60, 60, 60);"><a style="cursor: default; color: rgb(60, 60, 60);">'+g_links[type]["name"]+'</a></span>');	
    }
    $(document).ready(function(){
        changeTabByRikaZe("publish");
        var params = anaParams();
        showLocation(params.type);
        $(".rikazeCode").click(function(e){
            //tab-tag-left-sel
            //tab-tag-middel-sel
            //tab-tag-right-sel
            //$(".tab-tag-left")
            var targets = $(e.target).parent().find("div");
            
            var lft = $(".tab-tag-left-sel");
            var mdt = $(".tab-tag-middel-sel");
            var rtt = $(".tab-tag-right-sel");
            lft.removeClass("tab-tag-left-sel");
            lft.addClass("tab-tag-left");
            mdt.removeClass("tab-tag-middel-sel");
            mdt.addClass("tab-tag-middel");
            rtt.removeClass("tab-tag-right-sel");
            rtt.addClass("tab-tag-right");
            $(targets).each(function(index,item){

                if($(item).hasClass("tab-tag-left")){
                    $(item).removeClass("tab-tag-left");
                    $(item).addClass("tab-tag-left-sel");
                }
                if($(item).hasClass("tab-tag-middel")){
                    $(item).removeClass("tab-tag-middel");
                    $(item).addClass("tab-tag-middel-sel");
                }
                if($(item).hasClass("tab-tag-right")){
                    $(item).removeClass("tab-tag-right");
                    $(item).addClass("tab-tag-right-sel");
                }
            });
        });


    });



</script>
</body>
</html>