<%@ page contentType="text/html; charset=utf-8" isELIgnored="false" %>
<%@ include file="/WEB-INF/jsp/apps/performanceReport/query/queryMain_js.jsp"%>
<!DOCTYPE html>
<html class="h100b over_hidden">            
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Insert title here</title>
    <script type="text/javascript">
	    function OK(){
			var content=$("#content input");
			var select=$("#content select");
			var array=new Array();
			var arr=new Array();
			var j=0;
			$.each(content,function(i,n){
				var item=$(n);
				if(item.attr("type")=='hidden'){
					array[j]=""+item.attr("id")+"="+item.val();
					j++;
				}
				if(item.attr("type")=='radio'){
					if(item.attr("checked")=='checked'){
						array[j]=""+item.attr("id")+"="+item.val();
						j++;
					}
				}
			})
			$.each(select,function(i,n){
				var item=$(n);
				array[j]=""+item.attr("id")+"="+item.val();
				j++;
			})
			arr[0]=array;
			return arr;
	    }
   		$(function(){
//     		$("#reportType").change(function(){
//     			var reportType=$("#reportType").val();
//     			createHtml();
//     		})
//     		$("#time").live("change",function(){
//     			timeChange();
//     		})
//     		$("#managerRange").live("click",function(){
//     			selectPerson(); 
//     		})
			if(Constants_report_flag=="false"){
				
			}else{
				var hh="<select id='reportCategory'><option value='1'>个人报表</option><option value='2'>团队报表</option></select>"
				$("#Category").html(hh);
			}
			$("#reportCategory").change(function(){
				var reportCategory=$(this).val();
				if(reportCategory=="1"){
		            personGroupTab = 1;
		            selectWorkSpace();
				}else{
			         personGroupTab = 2;
			         selectWorkSpace();
				}
			})
			$("#managerRange").live("click",function(){
				selectPerson();
			})
   		})
    </script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
	<div class="layout_north " layout="height:150,maxHeight:1200,minHeight:100,spiretBar:{show:true,handlerT:function(){layout.setNorth(0);},handlerB:function(){layout.setNorth(200);}}">
   <!--  <div class="layout_north" layout="height:200,maxHeight:1200,minHeight:100,spiretBar:{show:true,handlerT:function(){layout.setNorth(0);},handlerB:function(){layout.setNorth(200);}}">   -->             
        <div id="tabs">
        	<div>
        	       <div id="tabs_head" class="common_tabs clearfix">
						<div id="Category">
						</div>
<!--                        <ul class="left"> -->
<!--                            <li class="current"><a hidefocus="true" href="javascript:void(0)" class="border_b" id="myReport"> -->
<%--                            <span>${ctp:i18n('performanceReport.queryMain.tabs.myReport')}</span></a> --%>
<!--                            </li> -->
<!--                            <li><a hidefocus="true" href="javascript:void(0)" id="groupReport" class="last_tab border_b"> -->
<%--                            <span>${ctp:i18n('performanceReport.queryMain.tabs.groupReport')}</span></a><!-- class="last_tab" --> --%>
<!--                            </li> -->
<!--                        </ul> -->
                   </div>
<!--         		报表类型: -->
<!--         		<select id="reportType"> -->
<!--         			<option value="1" selected="selected">个人报表</option> -->
<!--         			<option value="2" id="groupReport">团队报表</option> -->
<!--         		</select> -->
        	</div>
        	<div id="content">
	        	<input type="hidden" id="reportId" value="${reportId}"/>
	           	<div id="queryCondition" ></div>      
        	</div>
        </div>
    </div>
 </div>
 <script type="text/javascript">
 //createHtml();
 function createHtml(){
	 var reportType=$("#reportType").val();
     var hh = "<div class='form_area_content'>" +
     "<div>" +
     "<table border=0 cellpadding=0 cellspacing=0>" +
     "<tbody>" +
     "<tr>";
     if(reportType==1){
     	//分类
     	hh+=getTh("${ctp:i18n('performanceReport.queryMainHtml.getSort')}")+ getSort();
     }else{
     	//选择人员
     	hh+=getTh("${ctp:i18n('performanceReport.queryMainHtml.selectePerson')}") + managerRange();
     }
     hh+="</tr>" +
     	//状态
     "<tr>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.getStatus')}")+ getStatus() +
     "</tr>" +
     "</tbody>" +
     "</table>" +
     "</div>" +
     "<div>" +
     "<table border=0 cellpadding=0 cellspacing=0>" +
     "<tbody>" +
     //类型
     "<tr>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.getType')}") + getType() +
     "</tr>" +
     //时间
     "<tr>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.getTime')}")+"<td width='100%' id='timeAll'>"+getTime()+"</td>"+
     "</tr>" +
     "</tbody>" +
     "</table>" +
     "</div>" +
     "</div>";
 	$("#queryCondition").html(hh);
 }
 </script>
</body>        
</html>