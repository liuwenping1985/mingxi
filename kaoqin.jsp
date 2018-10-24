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
            <div id="nowLocation" style="" class="layout_location"><span class="nowLocation_ico"><img src="/seeyon/main/skin/frame/GOV_red/menuIcon/personal.png"></span><span class="nowLocation_content" style="color: rgb(60, 60, 60);"><a style="cursor: default; color: rgb(60, 60, 60);">协同工作</a> &gt; <a class="hand" onclick="showMenu('/seeyon/collaboration/collaboration.do?method=listPending')" style="color: rgb(60, 60, 60);">待办事项</a></span></div>
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
                                                        <div  class="tab-tag-middel-sel" style="word-break:keep-all;white-space:nowrap;clear: right;" onclick="changeTabByRikaZe('pending')">待办</div>
                                                        <div class="tab-tag-right-sel" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                                                        <div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                                                    </span>
                                                    <span class="resCode rikazeCode" resCodeParent="">
                                                            <div class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                                                            <div  class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;" onclick="changeTabByRikaZe('done')">已办</div>
                                                            <div class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                                                            <div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                                                        </span>

                                                        <span class="resCode rikazeCode" resCodeParent="">
                                                                <div class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                                                                <div id="sent" class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;" onclick="changeTabByRikaZe('wait')">待报备</div>
                                                                <div class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                                                                <div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                                                            </span>
                                                            <span class="resCode rikazeCode" resCodeParent="">
                                                                    <div class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                                                                    <div id="sent" class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;" onclick="changeTabByRikaZe('send')">已报备</div>
                                                                    <div class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                                                                    <div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                                                                </span>
                                                    <span class="resCode" resCodeParent="">
                                                        <div class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                                                        <div  class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;" onclick="changeTabByRikaZe('new')" >考勤新建</div>
                                                        <div class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                                                        <div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                                                    </span>	
                                                    <span class="resCode rikazeCode" resCodeParent="">
                                                            <div class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                                                            <div  class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;" onclick="changeTabByRikaZe('time')" >时间视图</div>
                                                            <div class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                                                            <div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                                                        </span>	
                                                        <span class="resCode" resCodeParent="">
                                                                <div class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                                                                <div  class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;" onclick="changeTabByRikaZe('query')" >考勤查询</div>
                                                                <div class="tab-tag-right" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                                                                <div class="tab-separator" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                                                        </span>	
                                                        <span class="resCode" resCodeParent="">
                                                                <div class="tab-tag-left" style="word-break:keep-all;white-space:nowrap;clear: right;"></div>
                                                                <div  class="tab-tag-middel" style="word-break:keep-all;white-space:nowrap;clear: right;" onclick="changeTabByRikaZe('stat')" >考勤统计</div>
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
    
    function changeTabByRikaZe(resCode){
        if(resCode == "wait"){
            $("#detailIframe").attr("src","/seeyon/collaboration/collaboration.do?method=listWaitSend&_resourceCode=F01_listWaitSend&condition=templeteIds&textfield=-4342177955300749683,1564627605772716658,3678542318590706209");
        }
        if(resCode == "pending"){
            $("#detailIframe").attr("src","/seeyon/collaboration/collaboration.do?method=listPending&_resourceCode=F01_listPending&condition=templeteIds&textfield=-4342177955300749683,1564627605772716658,3678542318590706209");
        }
        if(resCode == "done"){
            $("#detailIframe").attr("src","/seeyon/collaboration/collaboration.do?method=listDone&_resourceCode=F01_listDone&condition=templeteIds&textfield=-4342177955300749683,1564627605772716658,3678542318590706209");
         
        }
        if(resCode == "send"){
            $("#detailIframe").attr("src","/seeyon/collaboration/collaboration.do?method=listSent&_resourceCode=F01_listSent&condition=templeteIds&textfield=-4342177955300749683,1564627605772716658,3678542318590706209");
         
        }
        if(resCode == "new"){
            $.get("/seeyon/rikaze.do?method=getUserLevelName",function(data){

                   
var level = data.level;
if(level.name=="正地"||level.name=="副地"){
    window.open("/seeyon/collaboration/collaboration.do?method=newColl&templateId=-4342177955300749683");
}else if(level.name=="正县"||level.name=="副县"){
    window.open("/seeyon/collaboration/collaboration.do?method=newColl&templateId=1564627605772716658");
}else {
    window.open("/seeyon/collaboration/collaboration.do?method=newColl&templateId=3678542318590706209");
}

}); 
        }
        if(resCode == "query"){
            window.open("/seeyon/form/queryResult.do?method=queryExc&hidelocation=false&type=query&queryId=-7609051453161517870");
             
        }
        if(resCode == "stat"){
            //window.open("/seeyon/report/queryReport.do?method=goIndexRight&reportId=-3712757300794145459&type=query");
            window.open("/seeyon/rikaze.do?method=statKaoqin");

        }
        if(resCode == "time"){
            $("#detailIframe").attr("src","/seeyon/calendar/calEvent.do?method=calEventView4Rkz&type=month");
            $("#detailIframe").attr("height","100%");
        }

    }

    $(document).ready(function(){
        changeTabByRikaZe("pending");
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