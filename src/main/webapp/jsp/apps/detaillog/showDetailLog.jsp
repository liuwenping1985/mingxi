<%--
 $Author:  zhaifeng$
 $Rev:  $
 $Date:: 2012-11-07#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <!-- 查看明细日志 -->
    <title>${ctp:i18n('collaboration.sendGrid.findAllLog')}</title>
    <style type="text/css">
        .stadic_head_height { height: 26px; }
        .stadic_body_top_bottom { overflow-y:hidden; bottom: 0px; top: 26px; }
        .public_title { text-indent:1em; height:30px; line-height:30px; font-weight: bold;font-size: 14px;font-family:'Microsoft YaHei',SimHei;}
    </style>
    <script type="text/javascript" src="${path}/ajax.do?managerName=detaillogManager"></script>
    <script type="text/javascript">
        $(document).ready(function () {
        	//ie7兼容处理
    		if ( $.browser.msie ){
    			 if($.browser.version<8){
    				var iframeObj= $("#resource");
    				iframeObj.height(iframeObj.parent().height());
    			 }
    		}
            //初始化 导出excel 标志
            var exportExcelFlag = "1";
            
            var iframeObj= $("#resource");
            iframeObj.height(iframeObj.parent().height());
            
           //处理明细绑定点击事件
           $('#detailLog').click(function(){
               var url = _ctxPath + "/detaillog/detaillog.do?method=showDealingLog&summaryId=${ctp:escapeJavascript(summaryId)}&appName=${ctp:escapeJavascript(param.appName)}&appTypeName=${ctp:escapeJavascript(param.appTypeName)}&isHistoryFlag=${ctp:escapeJavascript(param.isHistoryFlag)}";
               $('#resource').attr("src",url);
               $('#tabID li').click(function(){
                   $('#tabID li').removeClass("current");
                   $(this).addClass("current");
                   return false;
               });
               exportExcelFlag = "1";
           });
           //流程日志 绑定点击事件
           $('#processLog').click(function(){
               var url = _ctxPath + "/detaillog/detaillog.do?method=showProcessLog&processId=${ctp:escapeJavascript(processId)}&summaryId=${ctp:escapeJavascript(summaryId)}&isAdminCheck=${ctp:escapeJavascript(param.isAdminCheck)}";
               $('#resource').attr("src",url);
               $('#tabID li').click(function(){
                   $('#tabID li').removeClass("current");
                   $(this).addClass("current");
                   return false;
               });
               exportExcelFlag = "2";
           });
           //催办日志 绑定点击事件
           $('#superviseLog').click(function(){
               var url = _ctxPath + "/detaillog/detaillog.do?method=showSuperviseLog&summaryId=${ctp:escapeJavascript(summaryId)}";
               $('#resource').attr("src",url);
               $('#tabID li').click(function(){
                   $('#tabID li').removeClass("current");
                   $(this).addClass("current");
                   return false;
               });
               exportExcelFlag = "3";
           });
           
           //初始化时加载显示内容
           if("${ctp:escapeJavascript(showFlag)}"==='2'){
               //显示流程日志
               $('#processLog').click();
           }else{
               //显示处理明细
               $('#detailLog').click();
           }
         
           //导出EXCEL绑定点击事件
           $('#exportExcel').click(function(){
               var url = "";
               if(exportExcelFlag === '1'){
                   url = _ctxPath + "/detaillog/detaillog.do?method=exportExcel&summaryId=${ctp:escapeJavascript(summaryId)}&appName=${ctp:escapeJavascript(param.appName)}&appTypeName=${ctp:escapeJavascript(param.appTypeName)}&isHistoryFlag=${ctp:escapeJavascript(param.isHistoryFlag)}";
               }else if(exportExcelFlag === '2'){
                   url = _ctxPath + "/detaillog/detaillog.do?method=exportProcessExcel&processId=${ctp:escapeJavascript(processId)}&summaryId=${ctp:escapeJavascript(summaryId)}";
               }else if(exportExcelFlag === '3'){
                   url = _ctxPath + "/detaillog/detaillog.do?method=exportRemindersLog&summaryId=${ctp:escapeJavascript(summaryId)}";
               }
               $("#exportExcel").jsonSubmit({
                   action:url,
                   callback : function() {}
               }); 
           });
           //打印 绑定点击事件
           $('#printButton').click(function(){
               var html = $('#resource').contents().find('#print').html();
               popprint(html);
           });
           // 打印 
           function popprint(content) {
               var printContentBody = "";
               var cssList = new ArrayList();
               var pl = new ArrayList();
               var contentBody = content ;
               var contentBodyFrag = "" ;
               cssList.add("${path}/skin/default/skin.css");
               contentBodyFrag = new PrintFragment(printContentBody, contentBody);
               pl.add(contentBodyFrag);
               printList(pl,cssList);
           }
        });
    </script>
</head>
<body class="page_color  h100b over_hidden">
    <div class="stadic_layout">
        <div class="stadic_layout_head stadic_head_height margin_t_5">
           <div class="clearfix">
               <div class="common_tabs clearfix left" id="tabID">
                   <ul class="left">
                       <li class="current"><a href="#" class="no_b_border" id="detailLog">${ctp:i18n("collaboration.dealing.info")}</a></li><%--处理明细 --%>
                       <li><a href="#" class="no_b_border" id="processLog">${ctp:i18n("processLog.list.title.label")}</a></li><%--流程日志 --%>
                       <li><a href="#" class="last_tab no_b_border" id="superviseLog">${ctp:i18n("common.life.log.label")}</a></li><%--催办日志 --%>
                   </ul>
               </div>
               <div class="right margin_r_10 margin_t_5">
                   <span class="hand ico16 xls_16"></span><a href="#" id="exportExcel">${ctp:i18n("application.96.label")}</a>&nbsp;&nbsp;<%--导出Excel --%>
                   <span class="hand ico16 print_16"></span><a href="#" id="printButton">${ctp:i18n("print.label")}</a><%--打印 --%>
               </div>
           </div>
        </div>
        <!-- 处理明细 -->
        <div class="stadic_layout_body stadic_body_top_bottom " id='cscs'>
            <iframe id="resource"  width="100%" height="100%" frameborder="0" name="resource"></iframe>
        </div>
        
    </div>
</body>
</html>

