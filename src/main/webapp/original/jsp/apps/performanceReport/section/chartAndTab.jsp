<%@ page contentType="text/html; charset=utf-8" isELIgnored="false" %>
<%@ include file="/WEB-INF/jsp/apps/performanceReport/query/queryMain_js.jsp"%>
 <!DOCTYPE html>
<html class="h100b over_hidden">            
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                <title>Insert title here</title>
            </head>
            <div id='layout' class="comp" comp="type:'layout'">
            <div class="layout_north " layout="height:150,maxHeight:1200,minHeight:100,spiretBar:{show:true,handlerT:function(){layout.setNorth(0);},handlerB:function(){layout.setNorth(200);}}">
             
               <!--  <div class="layout_north" layout="height:200,maxHeight:1200,minHeight:100,spiretBar:{show:true,handlerT:function(){layout.setNorth(0);},handlerB:function(){layout.setNorth(200);}}">   -->             
                     <div id="tabs">
                        <div id="tabs_head" class="common_tabs clearfix">
                            <ul class="left">
                                <li class="current"><a hidefocus="true" href="javascript:void(0)" tgt="tab1_iframe" id="tableResult">
                                <span>${ctp:i18n('performanceReport.queryMain.result.tableResult')}</span></a>
                                </li>
                                <li><a hidefocus="true" href="javascript:void(0)" tgt="tab2_iframe" id="chartResult">
                                <span>${ctp:i18n('performanceReport.queryMain.result.chartResult')}</span></a>
                                </li>
                            </ul>
                            <ul class="align_center">
                                <li id="reportName">${ctp:i18n('performanceReport.queryMain.reportName')}</li>
                                
                            </ul>
                        </div>
                        <div id="queryResult" class="align_center">
                        </div>
                    </div>
                </div>
                </div>
            </body>        
</html>