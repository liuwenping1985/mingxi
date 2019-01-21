<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<html>    
<head>
<title></title>
<script type="text/javascript">
    $(function () {
    });  
	function hideTab(tabIndex){
	    if(tabIndex==1){
	    	$("#myReport").parent().css("display","none");	
	    	$("#groupReport").parent().css("display","inline");	
	    }else if(tabIndex==2){
	    	$("#groupReport").parent().css("display","none");
	    	$("#myReport").parent().css("display","inline");	
	    }else{
	    	$("#groupReport").parent().css("display","none");
	    	$("#myReport").parent().css("display","none");
	    }
	}
	//隐藏表和图页签
	function hideChartGrid(){
		$("#tableResult").parent().css("display","none");
    	$("#chartResult").parent().css("display","none");
	}
  
    //事项统计
    function eventStatistics(){
      	 var hh = "<div class='form_area set_search'>";
    	 if(personGroupTab==2||personGroupTab==1){
    	    hh+="<div class='one_row'>" +
    	    "<table border=0 cellpadding=0 cellspacing=0>" +
    	    "<tbody>" ;
    	    hh+="<tr>"+
    	    getTh("${ctp:i18n('performanceReport.queryMainHtml.selectePerson')}") + managerRange(true)+
    	    "</tr>";
    	    hh+="</tbody>" +
    	    "</table>" +
    	    "</div>" ;
    	 }
    	 if(hiddenChartGridTab!='true'){
    		    hh+="<div class=one_row>" +
    	        "<table border=0 cellpadding=0 cellspacing=0>" +
    	        "<tbody><tr>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.getTime')}")+  "<td width='100%' id='timeAll'>"+getTime() +"</td>"+
    	        "</tr>" +
    	        "</tbody>" +
    	        "</table>" +
    	        "</div>" ;
    	 }else{
    		    hh+="<div class=one_row>" +
    	        "<table border=0 cellpadding=0 cellspacing=0>" +
    	        "<tbody><tr>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.getTime')}")+  "<td id='timeAll'>"+getTime() +"</td>"+
    	        "</tr>" +
    	        "</tbody>" +
    	        "</table>" +
    	        "</div>" ;
    	 }
	    hh += getButton();
	    if(hiddenChartGridTab=='true'){
	    	 $("#sectionTab #queryCondition").html(hh);
	    }else{
	     	$("#tabs #queryCondition").html(hh);
	    }
    	
    }
    //在线时间分析
    function onlineTime(){
    	 var hh = "<div class='form_area set_search'>"+
    	 "<div class='one_row'>" +
    	 "<table border=0 cellpadding=0 cellspacing=0>" +
    	 "<tbody>" ;
    	 if(personGroupTab==2||personGroupTab==1){
    		 hh+="<div class='one_row'>" +
     	    "<table border=0 cellpadding=0 cellspacing=0>" +
     	    "<tbody>" ;
     	    hh+="<tr>"+
     	    getTh("${ctp:i18n('performanceReport.queryMainHtml.selectePerson')}") + managerRange(true)+
     	    "</tr>";
     	    hh+="</tbody>" +
     	    "</table>" +
     	    "</div>" ;
    	 }
    	 if(hiddenChartGridTab!='true'){
     	    hh+="<div class=one_row>" +
	        "<table border=0 cellpadding=0 cellspacing=0>" +
	        "<tbody><tr>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.getTime')}")+ "<td width='100%' id='timeAll'>"+getTime() +"</td>"+
	        "</tr>" +
	        "</tbody>" +
	        "</table>" +
	        "</div>" ;
	 }else{
 	    hh+="<div class=one_row>" +
        "<table border=0 cellpadding=0 cellspacing=0>" +
        "<tbody><tr>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.getTime')}")+ "<td id='timeAll'>"+getTime() +"</td>"+
        "</tr>" +
        "</tbody>" +workTotal()
        "</table>" +
        "</div>" ; 
	 }
	    hh += getButton();
	    if(hiddenChartGridTab=='true'){
	    	 $("#sectionTab #queryCondition").html(hh);
	    }else{
	     	$("#tabs #queryCondition").html(hh);
	    }
    }
    //在线人数趋势
    function onlineStatistics(){
    	 var hh = "<div class='form_area set_search'>" +
    	 "<table border=0 cellpadding=0 cellspacing=0 class='common_center'>" +"<tbody>"+
      		"<tr>"+
				"<td width='50%' vAlign='top' class='padding_lr_10'>"+
    	   			"<table border=0 cellpadding=0 cellspacing=0>" +"<tbody>" ;
			    	    hh+="<tr>"+
			    	    getTh("${ctp:i18n('performanceReport.queryMainHtml.statisticsMode')}") + statisticsMode()+
			    	    "</tr>";
			    	    hh+="</tbody>" +"</table></td>";
			    	    
			    	    hh+="<td width='50%' vAlign='top' class='padding_lr_10'><table border=0 cellpadding=0 cellspacing=0>" +
			    	        "<tbody><tr>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.date')}")+ "<td width='100%' id='timeAll' nowrap='nowrap'><div class='common_txtbox_wrap'><input id='start_time' name='${ctp:i18n('performanceReport.queryMainHtml.date')}' type='text' class='comp mycal validate'  validate='notNull:true'  width='60' comp='type:\"calendar\",ifFormat:\"%Y-%m\"'/></div></td>" +
			    	        //"<td width='60' nowrap='nowrap'><input id='start_time' type='text' class='comp mycal' width='60' comp='type:\"calendar\",ifFormat:\""+dateFormat+"\"'/></td>"
			    	        "</tr>" +
			    	        "</tbody>" +
			    	        "</table>" +
			    	        "</td></tr></table>" ;
			    	    hh += getButton();
    	    if(hiddenChartGridTab=='true'){
    	    	 $("#sectionTab #queryCondition").html(hh);
    	    }else{
    	     	$("#tabs #queryCondition").html(hh);
    	    }	
    }
  	//知识社区活跃度
	function knowledgeActivity(){   
	 var hh = "<div class='form_area set_search one_row'>" +
    "<table border=0 cellpadding=0 cellspacing=0>" +
    "<tbody>" ;
    hh+="<tr id='personManagerRange'>"+
    getTh("${ctp:i18n('performanceReport.queryMainHtml.selectePerson')}") + managerRange(true)+
    "</tr>";
    hh+="<tr>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.getTime')}")+ "<td width='100%' id='timeAll'>"+getTime2() +"</td>"+
        "</tr>" ;
    hh+="</tbody>" +
    "</table>" +
    "</div>" ;
   /* hh+="<div class=one_row>" +
        "<table border=0 cellpadding=0 cellspacing=0>" +
        "<tbody><tr>" +getTh('时间')+ "<td width='100%' id='timeAll'>"+getTime() +"</td>"+
        "</tr>" +
        "</tbody>" +
        "</table>" +
        "</div>" ;*/
    hh += getButton();
    if(hiddenChartGridTab=='true'){
   	 $("#sectionTab #queryCondition").html(hh);
   }else{
    	$("#tabs #queryCondition").html(hh);
   }
	}
  	//知识积分排行榜
	function knowledgeScore(){   
	 var hh = "<div class='form_area set_search one_row'>" ;
	 if(hiddenChartGridTab=='true'){
		 hh+="<table border=0 cellpadding=0 cellspacing=0 width='170px'>" +
		    "<tbody>" ;
	   }else{
		   hh+="<table border=0 cellpadding=0 cellspacing=0 >" +
		    "<tbody>" ;
	   }
    
    hh+="<tr>"+
    getTh("${ctp:i18n('performanceReport.queryMainHtml.selectePerson')}") + managerRange(true)+
    "</tr>";
    hh+="<tr>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.getTime')}")+ "<td width='100%' id='timeAll'>"+getTime() +"</td>"+
        "</tr>" +
        "</tbody>" +
        "</table>" +
        "</div>" ;   
    
    hh += getButton();
    if(hiddenChartGridTab=='true'){
   	 $("#sectionTab #queryCondition").html(hh);
   }else{
    	$("#tabs #queryCondition").html(hh);
   }
	}
  	//知识增长趋势
	function knowledgeIncrease(){
     	 var hh = "<div class='form_area set_search one_row'>" +
         "<span class='margin_r_5'>" +
         "<table border=0 cellpadding=0 cellspacing=0 class='common_center'>" +
         "<tbody>" ;
         hh+="<tr>"+
         getTh("${ctp:i18n('performanceReport.queryMainHtml.getTime')}") + getTimeInterval("%Y-%m",true)+
         "</tr>";
         hh+="</tbody>" +
         "</table>" +
         "</span>" ;
      /* p1:  hh+="<span>" +
         "<table border=0 cellpadding=0 cellspacing=0>" +
         "<tbody><tr>" +getTh('关键字')+ keyWord() +
         "</tr>" +
         "</tbody>" +
         "</table>" +
         "</span>" +  	 */
         hh+="</div>";
     hh += getButton();
     if(hiddenChartGridTab=='true'){
    	 $("#sectionTab #queryCondition").html(hh);
    }else{
     	$("#tabs #queryCondition").html(hh);
    }   	
	}
  	//任务燃尽图
	function taskBurndown(){
     	 var hh = "<div class='form_area set_search one_row'>" +
         "<table border=0 cellpadding=0 cellspacing=0>" +
         "<tbody>" ;
         hh+="<tr>"+
         getTh("${ctp:i18n('performanceReport.queryMainHtml.taskInfo')}") + taskInfo()+
         "</tr>";
         hh+="</tbody>" +
         "</table>" +
         "</div><input type='hidden' id='task_id' />";
     hh += getButton();
     if(hiddenChartGridTab=='true'){
    	 $("#sectionTab #queryCondition").html(hh);
    }else{
     	$("#tabs #queryCondition").html(hh);
    }   	
	}
	//会议参加角色统计
    function meetingJoinRole(){
    	 var hh = "<div class='form_area set_search one_row'>" +
         "<table border=0 cellpadding=0 cellspacing=0 style='align-text:right'>" +
         "<tbody>" ;
    	 if(personGroupTab==2||personGroupTab==1){
         hh+="<tr>"+
         getTh("${ctp:i18n('performanceReport.queryMainHtml.selectePerson')}") + managerRange(true)+
         "</tr>";
         hh+="</tbody>" +
         "</table>" ;
      	   if(hiddenChartGridTab!='true'){
		           hh+="<table border=0 cellpadding=0 cellspacing=0 >" +
		               "<tbody><tr>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.getTime')}")+ "<td width='100%' id='timeAll'>"+getTime() +"</td>"+
		               "</tr>" +
		               "</tbody>" +
		               "</table>";  	 
      	   }else{
  	           hh+="<table border=0 cellpadding=0 cellspacing=0 width='100%'>" +
	               "<tbody><tr>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.getTime')}")+ "<td id='timeAll'>"+getTime() +"</td>"+
	               "</tr>" +
	               "</tbody>" +
	               "</table>" ; 
      	   }
    	 }
         
         "</div>";
     hh += getButton();
     if(hiddenChartGridTab=='true'){
    	 $("#sectionTab #queryCondition").html(hh);
    }else{
     	$("#tabs #queryCondition").html(hh);
    }
    }
    //会议参加情况统计
    function meetingJoin(){
    	 var hh = "<div class='form_area set_search one_row'>" +
         "<table border=0 cellpadding=0 cellspacing=0 >" +
         "<tbody>" ;
    	 if(personGroupTab==2||personGroupTab==1){
         hh+="<tr>"+
         getTh("${ctp:i18n('performanceReport.queryMainHtml.selectePerson')}") + managerRange(true)+
         "</tr>";
         hh+="</tbody>" +
         "</table>" ;
         if(hiddenChartGridTab!='true'){
		         hh+="<table border=0 cellpadding=0 cellspacing=0 >" +
		             "<tbody><tr>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.getTime')}")+ "<td width='100%' id='timeAll'>"+getTime()+"</td>"+
		             "</tr>" +
		             "</tbody>" +
		             "</table>";  	 
        	 }else{
		         hh+="<table border=0 cellpadding=0 cellspacing=0 width='100%'>" +
	             "<tbody><tr>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.getTime')}")+ "<td id='timeAll'>"+getTime()+"</td>"+
	             "</tr>" +
	             "</tbody>" +
	             "</table>"; 
        	 }
    	 }
         "</div>";
     hh += getButton();
     if(hiddenChartGridTab=='true'){
    	 $("#sectionTab #queryCondition").html(hh);
    }else{
     	$("#tabs #queryCondition").html(hh);
    }
    }
    //计划提交回复统计
    function planReturn(){
    	 var hh = "<div class='form_area set_search'>" +
    	 "<table border=0 cellpadding=0 cellspacing=0 class='common_center'>"+"<tbody>"+
         	"<tr>"+
 				"<td width='50%' vAlign='top' class='padding_lr_10'>"+
 					"<table border=0 cellpadding=0 cellspacing=0>" +"<tbody>";
			    	 if(personGroupTab==2||personGroupTab==1){
				         hh+="<tr>"+
				         getTh("${ctp:i18n('performanceReport.queryMainHtml.selectePerson')}") + managerRange(true)+
				         "</tr>";
			    	 }
			    	 hh+="<tr>"+
			         getTh("${ctp:i18n('performanceReport.queryMainHtml.planType')}") + planType()+
			         "</tr>";
         			hh+="</tbody>" +"</table>" +
         		"</td>" +
         		"<td width='50%' vAlign='top' class='padding_lr_10'>"+
         			"<table border=0 cellpadding=0 cellspacing=0>" +"<tbody>" ;
				         if(personGroupTab==2||personGroupTab==1){
				             hh+="<tr><th nowrap='nowrap'><label class='margin_r_10' for='text'>&nbsp;</label></th><td >&nbsp;</td></tr>";
				         }
				         hh+="<tr id='timeAll'>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.getTime')}")+getTimeInterval("%Y-%m",true)+
				         "</tr>" +
         			"</tbody>" +"</table>" +
         		"</td>" +
         	"</tr>" +
         "</tbody>" +"</table>" +
     "</div>";
     hh += getButton();
    if(hiddenChartGridTab=='true'){
    	 $("#sectionTab #queryCondition").html(hh);
    }else{
     	$("#tabs #queryCondition").html(hh);
    }	
    }
    
    
     //日常工作统计条件区
    function workTotal_() {
      	var hh = "<div class='form_area set_search' style='margin-left:50px'>" +
    	 "<table width='60%' id='Worktab' border=0 cellpadding=0 cellspacing=0 class='common_center'>"+"<tbody>"+
         	"<tr>"+
 				"<td width='40%' vAlign='top' id='type_td' class='padding_lr_10'>";
 				if(false){
	            	hh+="<table border=0  cellpadding=0 cellspacing=0>" +"<tbody>";
			    	hh+="<tr>"+
			        	getTh("${ctp:i18n('performanceReport.queryMainHtml.getType')}") + getType_()+
			         	"</tr>";
         				hh+="</tbody>" +"</table>" +
         			"</td>" +
         			"<td width='60%' vAlign='top' id='time_td' class='padding_lr_10'>"+
         			"<table id='st_tab' border=0 cellpadding=0 cellspacing=0>" +"<tbody>" ;
				         hh+="<tr id='rowTime'>" +getTime_()+
				         "</tr>" +
         			"</tbody>" +"</table>" +
         			"</td>" +
         			"</tr>" +
         			"</tbody>" +"</table>" +
         			"</div>";
	            }else{
	    			hh+="<table border=0 cellpadding=0 cellspacing=0>";
		            hh+="<tbody>" +"<tr>";
	            	hh+=getTh("${ctp:i18n('performanceReport.queryMainHtml.selectePerson')}") + managerRange(true);
	            	hh+="</tr>" ;
	            	hh+="<tr id='coltype'>" + getTime_()+
					         "</tr>" ;
				    "</tr>" ;
	            	hh+="</tbody>" +"</table>" +
	            	"</td>" ;
	    			hh+="<td width='60%' vAlign='top' class='padding_lr_10'>"+
	            	"<table border=0 cellpadding=0 cellspacing=0>" +"<tbody>";
	            	hh+="<tr id='rowOcc'>"+
	            	getTh("${ctp:i18n('performanceReport.queryMainHtml.getType')}") + getType_()+
	            	"</tr>";
	            	hh+="</tbody>" +"</table>" +
	            	"</td>" +
	                "</tr>" +"</tbody>" +"</table>" +
	            	"</div>";
	            }
 					
     hh += getButton();
    if(hiddenChartGridTab=='true'){
    	 $("#sectionTab #queryCondition").html(hh);
    }else{
     	$("#tabs #queryCondition").html(hh);
    }
    
    }
    
    //日常工作统计条件区
    function workTotal() {
        var hh = "<div class='form_area set_search'>" +
        "<table border=0 cellpadding=0 cellspacing=0 class='common_center'>"+"<tbody>" +
            	"<tr>"+
    			"<td width='50%' vAlign='top' class='padding_lr_10'>";
    			
	            if(personGroupTab==1){
	            	hh+="<table border=0 cellpadding=0 cellspacing=0 >" ;
	            	hh+=getTh("${ctp:i18n('performanceReport.queryMainHtml.getSort')}")+ getSort()+"<tbody>" +"<tr>";
	            }else{
	            	if(hiddenChartGridTab=='false'){
	    				hh+="<table border=0 cellpadding=0 cellspacing=0 style='width: 250px;'>";
	    			}else{
	    				hh+="<table border=0 cellpadding=0 cellspacing=0 style='width: 120px;'>";
	    			}
		            hh+="<tbody>" +"<tr>";
	            	hh+=getTh("${ctp:i18n('performanceReport.queryMainHtml.selectePerson')}") + managerRange();
	            }
	            hh+="</tr>" ;
	            //处理栏目条件区界面,类型和状态位置颠倒的bug
	            if(hiddenChartGridTab=='false'){
	            	//不是栏目时
	            	hh+="<tr>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.getStatus')}")+ getStatus();
	            }else{
	            	//是栏目时
	            	hh+="<tr>" +getTh("<span class='w1em'></span><span class='w1em'></span>"+"${ctp:i18n('performanceReport.queryMainHtml.getType')}") + getType();
	            }
            	hh+="</tr>" +
            	"</tbody>" +"</table>" +
            	"</td>" +
    			"<td width='50%' vAlign='top' class='padding_lr_10'>"+
            		"<table border=0 cellpadding=0 cellspacing=0>" +"<tbody>";
		            if(hiddenChartGridTab=='false'){
		            	//不是栏目时
		           	 	hh+="<tr>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.getType')}") + getType()+
		           	 "</tr>" +"<tr>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.getTime')}")+"<td width='100%' id='timeAll'>"+getTime()+"</td>"+
		             "</tr>";
		            }else{
		            	//是栏目时
		            	hh+="<tr>" +getTh("<span class='w1em'></span><span class='w1em'></span>"+"${ctp:i18n('performanceReport.queryMainHtml.getStatus')}")+ getStatus()+
		            	"</tr>" +"<tr>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.getTime')}")+"<td id='timeAll'>"+getTime()+"</td>"+
		                "</tr>" ;
		            }
            		hh+="</tbody>" +"</table>" +
            	"</td>" +
                "</tr>" +"</tbody>" +"</table>" +
            "</div>";
        hh += getButton();
        if(hiddenChartGridTab=='true'){
       	 $("#sectionTab #queryCondition").html(hh);
       }else{
        	$("#tabs #queryCondition").html(hh);
       }
    }
    //项目进度统计
    function projectScheduleStatistics(){
        var hh = "<div class='form_area set_search'>" +
        "<table border=0 cellpadding=0 cellspacing=0 class='common_center'>"+"<tbody>"+
     		"<tr>"+
				"<td width='50%' vAlign='top' class='padding_lr_10'>"+
		            "<table border=0 cellpadding=0 cellspacing=0 id='process_tab'>" +
		            "<tbody>" +
		            "<tr>";
		            hh+=getTh("${ctp:i18n('performanceReport.queryMainHtml.projectName')}") + projectName();
		            hh+="</tr>" +
		            "<tr>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.selfRole')}")+ selfRole() +
		            "</tr>" +
		            "</tbody>" +
		            "</table>" +
            	"</td>" +
            	"<td width='50%' vAlign='top' class='padding_lr_10'>" +
		            "<table border=0 cellpadding=0 cellspacing=0>" +
		            "<tbody>" +
		            "<tr>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.projectManager')}") + projectManager() +
		            "</tr>" +
		            "<tr>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.projectStatus')}")+projectStatus()+
		            "</tr>" +
		            "</tbody>" +
		            "</table>" +
            	"</td></tr></tbody></table>" +
            "</div>";
        hh += getButton();
        if(hiddenChartGridTab=='true'){
       	 $("#sectionTab #queryCondition").html(hh);
       }else{
        	$("#tabs #queryCondition").html(hh);
       }
    }
    //存储空间统计
    function storageSpaceStatistics(){
   	 var hh = "<div class='form_area set_search one_row'>" +
     "<table border=0 cellpadding=0 cellspacing=0>" +
     "<tbody>" ;
     hh+="<tr>"+
     getTh("${ctp:i18n('performanceReport.queryMainHtml.selectePerson')}") + managerRange(true)+
     "</tr>";
     hh+="</tbody>" +
     "</table>" +        
     "</div><input type='hidden' id='task_id' />";
     hh += getButton();
     if(hiddenChartGridTab=='true'){
    	 $("#sectionTab #queryCondition").html(hh);
    }else{
     	$("#tabs #queryCondition").html(hh);
    }  
    }
    //流程已办已发统计
    function eventSentAndCompletedStatistics(){
    var hh = "<div class='form_area set_search'>" +
    	"<table border=0 cellpadding=0 cellspacing=0 class='common_center'>" +"<tbody>"+
     		"<tr>"+
				"<td width='50%' vAlign='top' class='padding_lr_10'>"+
			        "<table border=0 cellpadding=0 cellspacing=0>" +
			        "<tbody>" +
			        "<tr>";
			        hh+=getTh("${ctp:i18n('performanceReport.queryMainHtml.flowType.name')}") + flowType_();
			        hh+="</tr>" +
			        "<tr>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.flowStatus')}")+ flowStatus() +
			        "</tr>" +
			        "</tbody>" +
			        "</table>" +
			     "</td>" +
			     "<td width='50%' vAlign='top' class='padding_lr_10'>"+
		        	"<table border=0 cellpadding=0 cellspacing=0>" +
			        "<tbody>" +
			        "<tr id='flowContentReplace'>"  +"<th nowrap='nowrap'><label class='margin_r_10' for='text'>&nbsp;</label></th>" +flowContentType() +
			        "</tr>" +
			        "<tr>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.getTime')}")+"<td><table><tbody><tr>"+getTimeInterval("%Y-%m",true)+
			        "</tr></tbody></table></td></tr>" +
			        "</tbody>" +
			        "</table>" +
			     "</td>" +
			  "</tr>" +
		   "</tbody>" +"</table>" +
        "</div>";
    hh += getButton();
    if(hiddenChartGridTab=='true'){
   	 $("#sectionTab #queryCondition").html(hh);
   }else{
    	$("#tabs #queryCondition").html(hh);
   }
   
//     	var hh = "<div class='form_area set_search'>" +
//     	"<table border=0 cellpadding=0 cellspacing=0 class='common_center'>" +"<tbody>"+
//      		"<tr>"+
// 				"<td width='50%' vAlign='top' class='padding_lr_10'>"+
// 			        "<table border=0 cellpadding=0 cellspacing=0>" +
// 			        "<tbody>" +
// 			        "<tr>";
// 			        hh+=getTh("${ctp:i18n('performanceReport.queryMainHtml.selectePerson')}") + managerRange(true);
// 			        hh+="</tr>" +
// 			        "<tr>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.flowStatus')}")+ flowStatus() +
// 			        "</tr>" +
// 			        "</tbody>" +
// 			        "</table>" +
// 			     "</td>" +
// 			     "<td width='50%' vAlign='top' class='padding_lr_10'>"+
// 		        	"<table border=0 cellpadding=0 cellspacing=0>" +
// 			        "<tbody>" +
// 			        "<tr >"  +getTh("${ctp:i18n('performanceReport.queryMainHtml.flowType.name')}") + flowType_()+
// 			        "</tr>" +
// 			        "<tr>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.getTime')}")+"<td><table><tbody><tr>"+getTimeInterval("%Y-%m",true)+
// 			        "</tr></tbody></table></td></tr>" +
// 			        "</tbody>" +
// 			        "</table>" +
// 			     "</td>" +
// 			     "<td width='50%' vAlign='top' class='padding_lr_10'>"+
// 		        	"<table border=0 cellpadding=0 cellspacing=0>" +
// 			        "<tbody>" +
// 			        "<tr >"+
// 			        "</tr>" +
// 			        "<tr id='flowContentReplace'>"+"<th nowrap='nowrap'><label class='margin_r_10' for='text'>&nbsp;</label></th>" +flowContentType() +
// 			        "</tr></tbody></table></td></tr>" +
// 			        "</tbody>" +
// 			        "</table>" +
// 			     "</td>" +
// 			  "</tr>" +
// 		   "</tbody>" +"</table>" +
//         "</div>";
//     hh += getButton();
//     if(hiddenChartGridTab=='true'){
//    	 $("#sectionTab #queryCondition").html(hh);
//    }else{
//     	$("#tabs #queryCondition").html(hh);
//    }
    }
    //流程超期统计
    function flowOverTimeStatistics(){
    	var hh = "<div class='form_area set_search'>" +
        "<table border=0 cellpadding=0 cellspacing=0 class='common_center'>" +"<tbody>" +
        	"<tr>"+
        		"<td width='50%' vAlign='top' class='padding_lr_10'>"+
        			"<table border=0 cellpadding=0 cellspacing=0>" +"<tbody>" +
        			"<tr>";
        			hh+=getTh("${ctp:i18n('performanceReport.queryMainHtml.flowType.name')}") + flowType_();
        			hh+="</tr>" +
        			"<tr>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.flowStatus')}")+ flowOverTimeStatus() +
        			"</tr>" +
        			"</tbody>" +"</table>" +
        		"</td>" +
        		"<td vAlign='top' class='padding_lr_10'>"+
        			"<table border=0 cellpadding=0 cellspacing=0>" +"<tbody>" +
        				"<tr id='flowContentReplace'>"+"</tr>" +
        				"<tr id='flowOverTimeDateId'>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.getTime')}")+getTimeInterval("%Y-%m",true)+"</tr>" +
        			"</tbody>" +"</table>" +
        		"</td>" +
        	"</tr>" +
        "</tbody>" +"</table>" +
        "</div>";
    hh += getButton();
    if(hiddenChartGridTab=='true'){
   	 $("#sectionTab #queryCondition").html(hh);
   }else{
    	$("#tabs #queryCondition").html(hh);
   }
    }
  //报表统计按钮设置 
      function getButton() {
          return "<div class='align_center clear padding_lr_5 padding_b_5' id='button_div'>" + 
          "<a href='javascript:void(0)' class='common_button common_button_emphasize margin_r_10' id='querySave' onclick='executeStatistics()'>${ctp:i18n('performanceReport.queryMain.button.start')}</a>" +
          "<a id='queryReset' class='common_button common_button_gray margin_r_10' href='javascript:void(0)' onclick='resetResult()'>${ctp:i18n('performanceReport.queryMain.button.reset')}</a>"+"</div>";
      }
    //构造条件区域组件==========================================begin
    function getTh(name) {
        if(name && name.length < 4){
            return "<th nowrap='nowrap'><label class='margin_r_10 th_name'  for='text'>&nbsp;&nbsp;&nbsp;&nbsp;" + name + ":</label></th>";
        }
        return "<th nowrap='nowrap'><label class='margin_r_10 th_name'  for='text'>" + name + ":</label></th>";
    }
    //计划提交onchange事件
    function timeIntervalChange(){
    	$("#timeAll td").remove();
    	if($("#planType").val()=="2"){
    		$("#timeAll th").after(getTimeInterval("%Y",false));
    		var date = new Date(presentTime.replace(/-/,"/"));
    		var years=date.getFullYear();
    		 $("#start_time").val(years);
    	}else if($("#planType").val()=="1"){
    		var date = new Date(presentTime.replace(/-/,"/"));
        	var fromDate=date.print("%Y-%m");
        	var reportCategory=$("#reportCategory").val();
    		if(reportCategory=='1'){
    			$("#timeAll th").after(getTimeInterval("%Y-%m",true));
    			//var date=new Date();
        		$("#start_time").val(timeMonthCal(6));
        		$("#end_time").val(fromDate);
    		}else{
    			$("#timeAll th").after(getTimeInterval("%Y-%m-%d",true));
            	$("#start_time").val(timeMonthCal(6)+"-01");
         		$("#end_time").val(getFirstAndLastDay()[1]);
    		}
    	}else if($("#planType").val()=="3"){
    		$("#timeAll th").after(getTimeInterval("%Y-%m-%d",true));
    		//var date = new Date();  
    		var date = new Date(presentTime.replace(/-/,"/"));
    		var curYear = date.getFullYear();  
            $("#start_time").val(curYear+"-01-01");
         	$("#end_time").val(curYear+"-12-31");
    	}else{
    		$("#timeAll th").after(getTimeInterval("%Y-%m-%d",true));
            $("#start_time").val(getFirstAndLastDay()[0]);
         	$("#end_time").val(getFirstAndLastDay()[1]);
    	}
    	$(".mycal").each(function(){$(this).compThis();});
    }
//计划提交回复统计回填
    function planTimeIntervalChange(){
        var startTime=$("#start_time").val();
        var endTime=$("#end_time").val();
    	if(hiddenChartGridTab!="true"){
    		$("#timeAll td").remove();
	    	if($("#planType").val()=="2"){
	    		$("#timeAll th").after(getTimeInterval("%Y",false));
	    		//var years=new Date().getFullYear();
	    		 $("#start_time").val(startTime);
	    	}else if($("#planType").val()=="1"){
	    		$("#timeAll th").after(getTimeInterval("%Y-%m",true));
	        	$("#start_time").val(startTime);
	        	$("#end_time").val(endTime);
	    	}else{
	    		$("#timeAll th").after(getTimeInterval("%Y-%m-%d",true));
	            $("#start_time").val(startTime);
	         	$("#end_time").val(endTime);
	    	}
    	}
    	$(".mycal").each(function(){$(this).compThis();});
    }   
    function workTotalChange(){
		  $("#appType,#status").attr("disabled",true);
		  $(".radio_com").change(function(){
			  if($(this).val()==2){
				  $("#appType,#status").attr("disabled",false);
			  }else{
				  $("#appType,#status").attr("disabled",true);
			  }
		  }
		 );
		  $("#appType").change(changeStatus);
		  $("#time").change(timeChange);
		  if(personGroupTab==2){
			  $("#appType,#status").attr("disabled",false);
		  }
    }
  //获取分类
    function getSort() {
        return "<td width='100%' id='ff_td'> <div class='common_radio_box clearfix'>" +
            "<label for='radiosort1' class='margin_r_10 hand'>" +
            "<input type='radio' value='0' id='radiosort1' name='radiosort' class='radio_com' checked>${ctp:i18n('performanceReport.queryMainHtml.sortsAllDone')}</label> " +
            "<label for='radiosort2' class='margin_r_10 hand'>" +
            "<input type='radio' value='1' id='radiosort2' name='radiosort' class='radio_com'>${ctp:i18n('performanceReport.queryMainHtml.sortsUndo')}</label>" +
            "<label for='radiosort3' class='margin_r_10 hand'>" +
            "<input type='radio' value='2' id='radiosort3' name='radiosort' class='radio_com'>${ctp:i18n('performanceReport.queryMainHtml.sortsOther')}</label>" +
            "</div>" +
            "</td>";
    }
//报表统计类型
    function getType() {
		var hh="";
		if(hiddenChartGridTab!="true"){
			hh="<td width='100%' colspan='5'>";
		}else{
			hh="<td colspan='5'>";
		}
         hh +=
            "<div class='common_selectbox_wrap'>" +
            "<select id='appType'>" +
            "<option value='0' selected>${ctp:i18n('colCube.common.list.collaboration')}</option>" ;
            if($.ctx.plugins.contains('edoc')){
            	hh+=  "<option value='1'>${ctp:i18n('colCube.common.list.officeDoc')}</option>" ;
            }                     
           hh+= "<option value='2'>${ctp:i18n('colCube.common.list.plan')}</option>" ;
           if($.ctx.plugins.contains('meeting')){
           	hh+=   "<option value='3'>${ctp:i18n('colCube.common.list.meeting')}</option>" ;
           }
           if(!checkSystemProperty()){
            hh += "<option value='4'>${ctp:i18n('colCube.common.list.ztask')}</option>" ;
           }
          hh+="</select>" +
            "</div>" +
            "</td>";
            return hh;
    }
    
    //报表统计类型
    function getType_() {
		var hh="";
		hh="<td colspan='5' width='100%'>";
         hh +=
            "<div class='common_selectbox_wrap'>" +
            "<select id='appType'>" +
            "<option value='5' selected>${ctp:i18n('performanceReport.queryMainHtml.sortsAllDone')}</option>"+
            "<option value='6' >${ctp:i18n('performanceReport.queryMainHtml.sortsUndo')}</option>"+
            "<option value='7' >${ctp:i18n('performanceReport.queryMain.all.send')}</option>"+
            "<option value='0' >${ctp:i18n('colCube.common.list.collaboration')}</option>" ;
            if($.ctx.plugins.contains('edoc')){
            	hh+=  "<option value='1'>${ctp:i18n('colCube.common.list.officeDoc')}</option>" ;
            }                     
           hh+= "<option value='2'>${ctp:i18n('colCube.common.list.plan')}</option>" ;
           if($.ctx.plugins.contains('meeting')){
           	hh+=   "<option value='3'>${ctp:i18n('colCube.common.list.meeting')}</option>" ;
           }
           if(!checkSystemProperty()){
            hh += "<option value='4'>${ctp:i18n('colCube.common.list.ztask')}</option>" ;
           }
          hh+="</select>" +
            "</div>" +
            "</td>";
            return hh;
    }
    
    
     //判断版本号
function checkSystemProperty(){
	var productId=${ctp:getSystemProperty('system.ProductId')};
	var pflag=false;
	switch(productId){
		case 0:
			pflag=true;
		case 7:
			pflag=true;
		case 12:
            pflag=true;
	}
	return pflag;
}

//报表状态
    function getStatus() {
		  var hh="";
		  if(hiddenChartGridTab!='true'){
			  hh="<td width='100%'>";
		  }else{
			  hh="<td id='status_td'>";
		  }
          return hh +"<div class='common_selectbox_wrap'>" +
                 "<select id='status'>"+getcolGovType()+ 
                 "</select>" +
                 "</div>" +
                 "</td>";
    }
   //获取协同公文类型
   function getcolGovType(){
	   return "<option value='0' >${ctp:i18n('performanceReport.queryMainHtml.typeDone')}</option>" +
       "<option value='1'>${ctp:i18n('performanceReport.queryMainHtml.typeSent')}</option> " +
       "<option value='2'>${ctp:i18n('performanceReport.queryMainHtml.typeUndo')}</option> " +
       //"<option value='3'>超期</option> " +
       "<option value='3'>${ctp:i18n('performanceReport.queryMainHtml.typeTempUndo')}</option>" +
       "<option value='4'>${ctp:i18n('performanceReport.queryMainHtml.typeArchived')}</option>  " ;	
   }
    //报表统计类型变化时也要触发报表状态改变
    function changeStatus() {
    var apptype=$("#appType").val();
    	var hh="";
        switch(apptype){
        case "3"://会议
        	hh+="<option value='0' >${ctp:i18n('performanceReport.queryMainHtml.typeSent')}</option>" +
            "<option value='1'>${ctp:i18n('performanceReport.queryMainHtml.typeDone')}</option> " +
            "<option value='2'>${ctp:i18n('performanceReport.queryMainHtml.typeUndo')}</option> " +
            "<option value='3'>${ctp:i18n('performanceReport.queryMainHtml.typeArchived')}</option> ";
        	break;
        case "2"://计划
        	hh+="<option value='0' >${ctp:i18n('performanceReport.queryMainHtml.typePublished')}</option>" +
            "<option value='1'>${ctp:i18n('performanceReport.queryMainHtml.typeReceived')}</option> " +
            "<option value='2'>${ctp:i18n('performanceReport.queryMainHtml.typeReplied')}</option> " +
            "<option value='3'>${ctp:i18n('performanceReport.queryMainHtml.typeUnreply')}</option>" ;
        	break;
        case "4"://任务
        	hh+="<option value='0' >${ctp:i18n('performanceReport.queryMainHtml.typeFinish')}</option>" +
            "<option value='1'>${ctp:i18n('performanceReport.queryMainHtml.typeInProgress')}</option> " +
            "<option value='2'>${ctp:i18n('performanceReport.queryMainHtml.typeDelayed')}</option> " +
            "<option value='3'>${ctp:i18n('performanceReport.queryMainHtml.typeUnstart')}</option> " +
            "<option value='4'>${ctp:i18n('performanceReport.queryMainHtml.typeCanceled')}</option>" ;            
        	break;
         default:
        	 hh+=getcolGovType();	 
        }
        $("#status").html(hh);
}
    //统计时间
    function getTime() {
        return "<div class='common_selectbox_wrap' id='timeDiv'>" +
            "<select id='time' onchange='timeChange()'>" +((Constants_report_id==MEETINGJOINROLESTATISTICS||Constants_report_id==EVENTSTATISTICS||Constants_report_id==KNOWLEDGESCORESTATISTICS||Constants_report_id==KNOWLEDGEACTIVITYSTATISTICS)?"":
            "<option value='0'>${ctp:i18n('colCube.common.dateSelect.today')}</option>" )+ 
            "<option value='1' selected>${ctp:i18n('colCube.common.dateSelect.week')}</option>" +
            "<option value='2'>${ctp:i18n('colCube.common.dateSelect.month')}</option>" +((Constants_report_id==MEETINGJOINSTATISTICS||Constants_report_id==MEETINGJOINROLESTATISTICS||Constants_report_id==ONLINETIMESTATISTICS||Constants_report_id==EVENTSTATISTICS)?"":
            (Constants_report_id==KNOWLEDGESCORESTATISTICS?"<option value='3' selected>${ctp:i18n('performanceReport.queryMainHtml.all')}</option>":"<option value='3'>${ctp:i18n('performanceReport.queryMainHtml.all')}</option>") )+((Constants_report_id==MEETINGJOINROLESTATISTICS)?
            "<option value='5'>${ctp:i18n('colCube.common.dateSelect.year')}</option>" :"")+(
            "<option value='4'>${ctp:i18n('colCube.common.dateSelect.anytime')}</option>") +
            "</select>" +
            "</div>";
    }
    function getTime2() {//知识活跃度 默认为本月
        return "<div class='common_selectbox_wrap' id='timeDiv'>" +
            "<select id='time' onchange='timeChange()'>" +((Constants_report_id==MEETINGJOINROLESTATISTICS||Constants_report_id==EVENTSTATISTICS||Constants_report_id==KNOWLEDGESCORESTATISTICS||Constants_report_id==KNOWLEDGEACTIVITYSTATISTICS)?"":
            "<option value='0'>${ctp:i18n('colCube.common.dateSelect.today')}</option>" )+
            "<option value='1'>${ctp:i18n('colCube.common.dateSelect.week')}</option>" +
            "<option value='2' selected>${ctp:i18n('colCube.common.dateSelect.month')}</option>" +((Constants_report_id==MEETINGJOINSTATISTICS||Constants_report_id==MEETINGJOINROLESTATISTICS||Constants_report_id==ONLINETIMESTATISTICS||Constants_report_id==EVENTSTATISTICS)?"":
            "<option value='3'>${ctp:i18n('performanceReport.queryMainHtml.all')}</option>" )+((Constants_report_id==MEETINGJOINROLESTATISTICS)?
            "<option value='5'>${ctp:i18n('colCube.common.dateSelect.year')}</option>" :"")+(
            "<option value='4'>${ctp:i18n('colCube.common.dateSelect.anytime')}</option>") +
            "</select>" +
            "</div>";
    }
    
        //统计时间
    function getTime_() {
        return getTh("${ctp:i18n('performanceReport.queryMainHtml.getTime')}")+"<td width='75%' id='timeAll'><div class='common_selectbox_wrap' id='timeDiv'>" +
            "<select id='time' onchange='timeChange()'>" +((Constants_report_id==MEETINGJOINROLESTATISTICS||Constants_report_id==EVENTSTATISTICS||Constants_report_id==KNOWLEDGESCORESTATISTICS||Constants_report_id==KNOWLEDGEACTIVITYSTATISTICS)?"":
            "<option value='0'>${ctp:i18n('colCube.common.dateSelect.today')}</option>" )+
            "<option value='1' selected>${ctp:i18n('colCube.common.dateSelect.week')}</option>" +
            "<option value='2'>${ctp:i18n('colCube.common.dateSelect.month')}</option>" +((Constants_report_id==MEETINGJOINSTATISTICS||Constants_report_id==MEETINGJOINROLESTATISTICS||Constants_report_id==ONLINETIMESTATISTICS||Constants_report_id==EVENTSTATISTICS)?"":
            "<option value='3'>${ctp:i18n('performanceReport.queryMain.all.Cumulative')}</option>" )+((Constants_report_id==MEETINGJOINROLESTATISTICS)?
            "<option value='5'>${ctp:i18n('colCube.common.dateSelect.year')}</option>" :"")+(
            "<option value='4'>${ctp:i18n('colCube.common.dateSelect.anytime')}</option>") +
            "</select>" +
            "</div></td>";
    }
  //统计时间-年月
    function getTimeYearMonth() {
     //   return getTimeInterval("%Y-%m");
    }
  //时间选择：dateFormat(时间格式)displayIntervalFlag(是否显示时间 间隔)
    function getTimeInterval(dateFormat,displayIntervalFlag) {
	  var hh="";
	
	   	 if(hiddenChartGridTab=='true'){
	   		 hh="<td width='60' nowrap='nowrap'><input id='start_time' name='${ctp:i18n('performanceReport.queryMain.textbox.startTime.name')}' type='text' class='comp mycal validate' validate='notNull:true' readOnly='true' comp='cache:false,type:\"calendar\",ifFormat:\""+dateFormat+"\"'/></td>";
	   	     if(displayIntervalFlag){
	   	    	 hh+="<td id='mid'>-</td>"+"<td width='60' nowrap='nowrap'><input  id='end_time' name='${ctp:i18n('performanceReport.queryMain.textbox.endTime.name')}' type='text'readOnly='true' class='comp mycal validate' validate='notNull:true'  comp='cache:false,type:\"calendar\",ifFormat:\""+dateFormat+"\"'/></td>";
	   	     }
	   	 }else{
	   		 hh="<td width='150' nowrap='nowrap'><div class='common_txtbox_wrap'><input id='start_time' name='${ctp:i18n('performanceReport.queryMain.textbox.startTime.name')}' type='text' class='comp mycal validate' validate='notNull:true' readOnly='true' comp='cache:false,type:\"calendar\",ifFormat:\""+dateFormat+"\"'/></div></td>";
	   	     if(displayIntervalFlag){
	   	    	 hh+="<td id='mid'>-</td>"+"<td width='150' nowrap='nowrap'><div class='common_txtbox_wrap'><input  id='end_time' name='${ctp:i18n('performanceReport.queryMain.textbox.endTime.name')}' type='text'readOnly='true' class='comp mycal validate' validate='notNull:true'  comp='cache:false,type:\"calendar\",ifFormat:\""+dateFormat+"\"'/></div></td>";
	   	     }
	   	 }
	  
     
     return hh;
    }
  //管理范围
    function managerRange(ifRequired){
	    var hh='';
	    //hiddenChartGridTab等于true,为栏目
	    if(hiddenChartGridTab!='true'){
	    	hh="<td width='100%' id='manager_range'>";
	    }else{
	    	hh="<td id='manager_range'>";
	    }
    	return hh+               
    	 "<div class='common_txtbox_wrap'>"+(ifRequired?"<input id='managerRange' name='${ctp:i18n('performanceReport.authorize.list.personsName')}'  type='text' class='validate' validate='notNull:true' />":"<input id='managerRange' name='managerRange'  type='text' />")
    	 +"<input id='managerRangeIds'  type='hidden' />"+
    	 "</div> </td>";

    }
//计划类型  
    function planType() {
        return "<td width='100%'>" +
            "<div class='common_selectbox_wrap' >" +
            "<select id='planType'>" +
            "<option value='0'>${ctp:i18n('performanceReport.queryMainHtml.planType.day')}</option>" +
            "<option value='1' selected>${ctp:i18n('performanceReport.queryMainHtml.planType.week')}</option>" +
            "<option value='2'>${ctp:i18n('performanceReport.queryMainHtml.planType.month')}</option>" +
            "<option value='3'>${ctp:i18n('performanceReport.queryMainHtml.planType.anytime')}</option>" +
            "</select>" +
            "</div>" +
            "</td>";
    }
//任务选择
    function taskInfo(){
		var hh='';
		if(hiddenChartGridTab!='true'){
			hh="<td width='100%'>";
		}else{
			hh="<td>";
		}
    	return hh+"<div class='common_txtbox_wrap'>"+
    	 "<input id='taskInfo' name='任务' readOnly='readOnly' type='text' class='validate' validate='notNull:true' />"+
    	 "</div> </td>";

    }
//关键字
    function keyWord(){
    	return "<td width='100%'>"+               
    	 "<div class='common_txtbox_wrap'>"+
    	 "<input id='text14'  type='text'>"+
    	 "</div> </td>";

    }

  //统计方式
      function statisticsMode() {
    	  //websphere环境，不明原因的错误（这段ctp:i18n找不到对应资源）。所以才有先生成一个aaa变量，然后再在下面的字符串中拼接。
	  	  var aaa= "${ctp:i18n('performanceReport.queryMainHtml.statisticsMode.byDay')}";
          return "<td width='100%'> <div class='common_radio_box clearfix' id='statisticsMode'>" +
              "<label for='radio1' class='margin_r_10 hand'>" +
              "<input type='radio' value='0' id='radio11' name='option' class='radio_com' checked>"+aaa+"</label> " +
              "<label for='radio2' class='margin_r_10 hand'>" +
              "<input type='radio' value='1' id='radio12' name='option' class='radio_com'>${ctp:i18n('performanceReport.queryMainHtml.statisticsMode.byMonth')}</label>" +             
              "</div>" +
              "</td>";
      }
  //项目名称
  function projectName(){
	  return "<td width='100%' id='project_td'>"+               
 	 "<div class='common_txtbox'>"+
 	 "<input id='projectName' name='projectName'  type='text'  class='validate' validate='maxLength:100' style='width:98%'/>"+
 	 "</div> </td>";
  }
  //项目负责人
  function projectManager(){
	  return "<td width='100%'>"+               
 	 "<div class='common_txtbox'>"+
 	 "<input id='projectManager' name='projectManager'  type='text'  class='validate' validate='maxLength:100' />"+
 	 "</div> </td>";
  }
//本人角色  (和项目数据库里面的定义保持一致)
  function selfRole() {
      return "<td width='100%'>" +
          "<div class='common_selectbox_wrap' >" +
          "<select id='selfRole'>" +
          "<option value='0'>${ctp:i18n('performanceReport.queryMainHtml.projectManager')}</option>" +
          "<option value='1'>${ctp:i18n('performanceReport.queryMainHtml.projectLeader')}</option>" +
          "<option value='2'>${ctp:i18n('performanceReport.queryMainHtml.projectMember')}</option>" +
          "<option value='3'>${ctp:i18n('performanceReport.queryMainHtml.projectReach')}</option>" +
          "<option value='5'>${ctp:i18n('performanceReport.queryMainHtml.projectAssistant')}</option>" +
          "<option value='6' selected>${ctp:i18n('performanceReport.queryMainHtml.all')}</option>" +
          "</select>" +
          "</div>" +
          "</td>";
          }
  //项目状态  (和项目数据库里面的定义保持一致)
  function projectStatus() {
      return "<td width='100%'>" +
          "<div class='common_selectbox_wrap' >" +
          "<select id='projectStatus'>" +
          "<option value='0'>${ctp:i18n('performanceReport.queryMainHtml.started')}</option>" +
          "<option value='2'>${ctp:i18n('performanceReport.queryMainHtml.end')}</option>" +
          "<option value='5' selected>${ctp:i18n('performanceReport.queryMainHtml.all')}</option>" +
          "</select>" +
          "</div>" +
          "</td>";
  }
  //流程类型
  function flowType_() {
      var hh = "<td width='100%'>" +
          "<div class='common_selectbox_wrap' >" +
          "<select id='flowType'>" +
          "<option value='0'>${ctp:i18n('performanceReport.queryMainHtml.flowType.col')}</option>" +
          "<option value='1'>${ctp:i18n('performanceReport.queryMainHtml.flowType.report')}</option>" ;
          if($.ctx.plugins.contains('edoc')){
          	hh +="<option value='2'>${ctp:i18n('colCube.common.list.officeDoc')}</option>" ;
          }
          hh += "</select>" +
          "</div>" +
          "</td>";
      return hh;
  }
//流程状态
  function flowStatus() {
      return "<td width='100%'>" +
          "<div class='common_selectbox_wrap' >" +
          "<select id='flowStatus'>" +
          "<option value='0'>${ctp:i18n('performanceReport.queryMainHtml.flowStatus.sent&done')}</option>" +
          "<option value='1'>${ctp:i18n('performanceReport.queryMainHtml.typeSent')}</option>" +
          "<option value='2'>${ctp:i18n('performanceReport.queryMainHtml.typeDone')}</option>" +
          "</select>" +
          "</div>" +
          "</td>";
  }
  //流程状态
  function flowOverTimeStatus() {
      return "<td width='100%'>" +
          "<div class='common_selectbox_wrap' >" +
          "<select id='flowOverTimeStatus'>" +
          "<option value='0'>${ctp:i18n('performanceReport.queryMainHtml.typeSent&Done')}</option>" +
          "<option value='2'>${ctp:i18n('performanceReport.queryMainHtml.typeDone')}</option>" +
          "<option value='1'>${ctp:i18n('performanceReport.queryMainHtml.typeCurrentUndo')}</option>" +
          "</select>" +
          "</div>" +
          "</td>";
  }
  //流程模板数量
  function flowTemplateNum() {
	  var hh;
	 //当hiddenChartGridTab不为空时,表示请求方为栏目,修改单元格的宽度
	  if(hiddenChartGridTab==false){
		  hh="<td width='100%' nowrap='nowrap'>";
	  }else{
		  hh="<td nowrap='nowrap' width='150'>";
	  }
      return hh+="<div class='common_selectbox_wrap' >" +
      "<select id='flowTemplateNum'>" +
      "<option value='6'>6</option>" +
      "<option value='5'>5</option>" +
      "<option value='4'>4</option>" +
      "<option value='3' selected>3</option>" +
      "<option value='2'>2</option>" +
      "<option value='1'>1</option>" +
      "</select>" +
      "</div>"+
      "</td>";
} 
  //流程正文类型:自由协同、模板协同
  function flowContentType(){
	  var  hh="<td height='24px;' nowrap='nowrap' ><div class='common_checkbox_box clearfix '>";
	 /* if(hiddenChartGridTab!='true'){
		  hh="<td height='24px;' nowrap='nowrap' ><div class='common_checkbox_box clearfix '>";
	  }else{
		  hh="<td height='24px;' nowrap='nowrap' ><div class='common_checkbox_box clearfix '>";
	  }*/
	 return hh+"<label for='Checkbox1' class='margin_r_10 hand'>"+
     "<input value='0' id='Checkbox1' name='flowContentType' class='radio_com' type='checkbox'>${ctp:i18n('performanceReport.queryMainHtml.freeCol')}</label>"+
     "<label for='Checkbox2' class='margin_r_10 hand'>"+
     "<input value='0' id='Checkbox2' name='flowContentType' class='radio_com' type='checkbox'>${ctp:i18n('performanceReport.queryMainHtml.templeCol')}</label>"+
     "</div></td>";
  }
  //公文流程正文类型:自由协同、模板协同
  function edocFlowContentType(){
	  var  hh="<td height='24px;' nowrap='nowrap' ><div class='common_checkbox_box clearfix '>";
	 return hh+"<label for='Checkbox1' class='margin_r_10 hand'>"+
     "<input value='0' id='Checkbox1' name='flowContentType' class='radio_com' type='checkbox'>${ctp:i18n('performanceReport.queryMain.reports.self.build')}</label>"+
     "<label for='Checkbox2' class='margin_r_10 hand'>"+
     "<input value='0' id='Checkbox2' name='flowContentType' class='radio_com' type='checkbox'>${ctp:i18n('performanceReport.queryMain.getTemplate')}</label>"+
     "</div></td>";
  }
  //选择年月日
  function getDate(){
	  	var hh="";
		  hh+="<td width='150' nowrap='nowrap' id='start_time_td'><div class='common_txtbox_wrap'><input id='start_time' name='${ctp:i18n('performanceReport.queryMain.textbox.startTime.name')}' type='text' class='comp mycal validate' validate='notNull:true' readOnly='true' comp='cache:false,type:\"calendar\",ifFormat:\"%Y-%m-%d\"'/></div></td>";
	  	  hh+="<td id='mid'>-</td>"+"<td width='150' nowrap='nowrap'  id='end_time_td'><div class='common_txtbox_wrap'><input  id='end_time' name='${ctp:i18n('performanceReport.queryMain.textbox.endTime.name')}' type='text'readOnly='true' class='comp mycal validate' validate='notNull:true'  comp='cache:false,type:\"calendar\",ifFormat:\"%Y-%m-%d\"'/></div></td>";
  	  	return hh;
  }
  function getTemplate(){
	    var hh=Constants_report_id==IMPROVEMENTANALYSIS||Constants_report_id==EFFICIENCYANALYSIS||Constants_report_id==NODEANALYSIS?"<td width='100%'>":"<td>";
    	return hh+               
    	 "<div class='common_txtbox_wrap'>"+"<input class='validate' id='templeteName' name=\"${ctp:i18n('performanceReport.queryMain.getTemplate')}\"  type='text' validate='notNull:true' />"
    	 +"<input id='templeteId'  type='hidden' />"+
    	 "</div> </td>";
  }
  function effeiciencyAnalysis(){
  		var hh = "<div class='form_area set_search'>" +
    	 "<table width='90%' border=0 cellpadding=0 cellspacing=0 class='common_center'>"+"<tbody>"+
         	"<tr>"+
 				"<td width='50%' vAlign='top' id='type_td' class='padding_lr_10'>";
	            	hh+="<table border=0 style='padding-left:70px;' cellpadding=0 cellspacing=0>" +"<tbody>";
			    	hh+="<tr>"+
			        	getTh("${ctp:i18n('performanceReport.query.getTemplate')}")+getTemplate()+
			         	"</tr>";
         				hh+="</tbody>" +"</table>" +
         			"</td>" +
         			"<td width='50%' vAlign='top' class='padding_lr_10'>"+
         			"<table border=0 cellpadding=0 cellspacing=0>" +"<tbody>" ;
				         hh+="<tr id='timeAll'>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.getTime')}") + getDate()+
				         "<td><input type='hidden' name='flowstate' id='flowstate'  value='${finish}' /></td></tr>" +
         			"</tbody>" +"</table>" +
         			"</td>" +
         			"</tr>" +
         			"</tbody>" +"</table>" +
         			"</div>";
     		hh += getButton();
    		if(hiddenChartGridTab=='true'){
    	 		$("#sectionTab #queryCondition").html(hh);
    		}else{
     			$("#tabs #queryCondition").html(hh);
    		}
  }
  
  function nodeAnalysis(){
  var hh = "<div class='form_area set_search'>" +
    	 "<table width='90%' border=0 cellpadding=0 cellspacing=0 class='common_center'>"+"<tbody>"+
         	"<tr>"+
 				"<td width='50%' vAlign='top' id='type_td' class='padding_lr_10'>";
	            	hh+="<table border=0 style='padding-left:70px;' cellpadding=0 cellspacing=0>" +"<tbody>";
			    	hh+="<tr>"+
			        	getTh("${ctp:i18n('performanceReport.query.getTemplate')}")+getTemplate()+
			         	"</tr>";
         				hh+="</tbody>" +"</table>" +
         			"</td>" +
         			"<td width='50%' vAlign='top' class='padding_lr_10'>"+
         			"<table border=0 cellpadding=0 cellspacing=0>" +"<tbody>" ;
				         hh+="<tr id='timeAll'>" +getTh("${ctp:i18n('performanceReport.queryMainHtml.getTime')}") + getDate()+
				         "</tr>" +
         			"</tbody>" +"</table>" +
         			"</td>" +
         			"</tr>" +
         			"</tbody>" +"</table>" +
         			"</div>";
     		hh += getButton();
    		if(hiddenChartGridTab=='true'){
    	 		$("#sectionTab #queryCondition").html(hh);
    		}else{
     			$("#tabs #queryCondition").html(hh);
    		}
	  }
  
  function getProcessStatus(){
	  var hh="";
	  hh+="<td width='' noWrap='noWrap'><input name='flowstate' id='flowstate0' type='checkbox' checked='checked' value='${finish}'/>${ctp:i18n('formquery_finished.label')}</td>"+
	  "<td noWrap='noWrap'><input name='flowstate' class='padding_l_10' id='flowstate1' type='checkbox' checked='checked' value='${run}'/>${ctp:i18n('formquery_finishedno.label')}</td>"+
	  "<td noWrap='noWrap'><input name='flowstate' class='padding_l_10' id='flowstate3' type='checkbox' checked='checked' value='${terminate}'/>${ctp:i18n('col.state.10.stepstop')}</td>";
	  return hh;
  }
  function overTimeAnalysis(){
  				var hh = "<div class='form_area set_search'>" +
    	 		"<table width='65%' border=0 cellpadding=0 cellspacing=0 class='common_center'>"+"<tbody>"+
         		"<tr>"+
 				"<td width='50%' vAlign='top' id='type_td' class='padding_lr_10'>";
	            	hh+="<table border=0  cellpadding=0 cellspacing=0>" +"<tbody>";
			    	hh+="<tr>"+
			        	getTh("${ctp:i18n('performanceReport.query.getTemplate')}")+getTemplate()+
			         	"</tr>";
			         	hh+="<tr id='timeAll'>"+
			         	 getTh("${ctp:i18n('performanceReport.queryMainHtml.getTime')}") + getDate()+
				         "</tr>" ;
         				hh+="</tbody>" +"</table>" +
         			"</td>" +
         			"<td width='50%' vAlign='top' class='padding_lr_10'>"+
         			"<table id='st_tab' border=0 cellpadding=0 cellspacing=0>" +"<tbody>" ;
				         hh+="<tr>" +getTh("${ctp:i18n('common.flow.state.label')}") + getProcessStatus()+
				         "</tr>" +
         			"</tbody>" +"</table>" +
         			"</td>" +
         			"</tr>" +
         			"</tbody>" +"</table>" +
         			"</div>";
		 		hh += getButton();
		 		if(hiddenChartGridTab=='true'){
			 		$("#sectionTab #queryCondition").html(hh);
				}else{
		 			$("#tabs #queryCondition").html(hh);
				} 
  }
  
  function getDate1(){
	  var hh='';
	  hh+="<td width='150' nowrap='nowrap' id='start_time_td'><div class='common_txtbox_wrap'><input id='start_time1' name='${ctp:i18n('performanceReport.queryMain.textbox.startTime.name')}' type='text' class='comp mycal validate' validate='notNull:true' readOnly='true' comp='cache:false,type:\"calendar\",ifFormat:\"%Y-%m-%d\"'/></div></td>";
  	  hh+="<td id='mid'>-</td>"+"<td width='150' nowrap='nowrap'  id='end_time_td'><div class='common_txtbox_wrap'><input  id='end_time1' name='${ctp:i18n('performanceReport.queryMain.textbox.endTime.name')}' type='text'readOnly='true' class='comp mycal validate' validate='notNull:true'  comp='cache:false,type:\"calendar\",ifFormat:\"%Y-%m-%d\"'/><div></td>";
  	  return hh;
  }
  
  function getDate2(){
	  var hh='';
	  hh+="<td width='150' nowrap='nowrap' id='start_time_td'><div class='common_txtbox_wrap'><input id='start_time2' name='${ctp:i18n('performanceReport.queryMain.textbox.startTime.name')}' type='text' class='comp mycal validate' validate='notNull:true' readOnly='true' comp='cache:false,type:\"calendar\",ifFormat:\"%Y-%m-%d\"'/></div></td>";
  	  hh+="<td id='mid'>-</td>"+"<td width='150' nowrap='nowrap'  id='end_time_td'><div class='common_txtbox_wrap'><input  id='end_time2' name='${ctp:i18n('performanceReport.queryMain.textbox.endTime.name')}' type='text'readOnly='true' class='comp mycal validate' validate='notNull:true'  comp='cache:false,type:\"calendar\",ifFormat:\"%Y-%m-%d\"'/></div></td>";
  	  return hh;
  }
  function improvementAnalysis(){
  		 var hh = "<div class='form_area set_search'>" +
    	 		"<table width='90%' border=0 cellpadding=0 cellspacing=0 class='common_center'>"+"<tbody>"+
         		"<tr>"+
 				"<td width='50%' vAlign='top' id='type_td' class='padding_lr_10'>";
	            	hh+="<table border=0 style='padding-left:70px;' cellpadding=0 cellspacing=0>" +"<tbody>";
			    	hh+="<tr>"+
			        	getTh("${ctp:i18n('performanceReport.query.getTemplate')}")+getTemplate() +
			         	"</tr>";
         				hh+="</tbody>" +"</table>" +
         			"</td>" +
         			"<td width='50%' vAlign='top' class='padding_lr_10'>"+
         			"<table id='st_tab' border=0 cellpadding=0 cellspacing=0>" +"<tbody>" ;
				         hh+="<tr>" +getTh("${ctp:i18n('performanceReport.queryMain.reports.compare.1')}") + getDate1()+
				         "</tr>";
				         hh+="<tr>" +getTh("${ctp:i18n('performanceReport.queryMain.reports.compare.2')}")+getDate2()+
				         "</tr>";
         			hh+="</tbody>" +"</table>" +
         			"</td>" +
         			"</tr>" +
         			"</tbody>" +"</table>" +
         			"</div>";
		 		hh += getButton();
		 		if(hiddenChartGridTab=='true'){
			 		$("#sectionTab #queryCondition").html(hh);
				}else{
		 			$("#tabs #queryCondition").html(hh);
				} 
  		
  }
  
  function templateRadio(){
		var hh="";
	    if(Constants_report_id==6991064496354839525){
	    		hh+="<td nowrap='nowrap' colspan='2'><input type='radio' name='operationType' id='allTemplete' value='self' onclick='changeOperationType()' checked/>"
	    		hh+="${ctp:i18n('performanceReport.authorize.person.allTemplate')}";
	    		hh+="&nbsp;&nbsp<input type='radio' name='operationType' id='chooseTemplete' value='template' onclick='changeOperationType()' />"
	    		hh+="${ctp:i18n('performanceReport.queryMain.reports.sepcified')}</td>";
				hh+="<td><input type='text' name='templeteName' id='templeteName' style='width:100px' value='${ctp:i18n('performanceReport.queryMain.reports.click')}' title='' readonly ${flowType eq 'self' ? 'disabled' : ''} /></td>"
	    }else{
			hh+="<td nowrap='nowrap'><label for='allTemplete'>"+
			"<input name='templete' id='allTemplete' onclick='hiddenTemplete();' type='radio' checked='checked' value='1'/>${ctp:i18n('performanceReport.authorize.person.allTemplate')}</td>";
			hh+="<td nowrap='nowrap'><label for='chooseTemplete'>"+
			"<input name='templete' class='padding_l_10' id='chooseTemplete' onclick='selectTemplate()' type='radio' value='2'/>${ctp:i18n('performanceReport.queryMain.reports.sepcified')}</td>";
			hh+="<td nowrap='nowrap'><div id='specTempleteDiv' class='common_txtbox_wrap' style='height: 25px; float: left;display:none'>"+
			"<input name='templeteName'  id='templeteName' style='display: none;' onclick='' type='text' readonly='readonly' value=''/>"+
			"<input name='templeteId' id='templeteId' type='hidden' value=''/></div></td>";
	    }
		return hh;
  }
  function appType(){
	   var hh='';
		   //流程统计
		   if(Constants_report_id==6991064496354839525){
				   hh+="<td>"+
		               "<div class='common_selectbox_wrap' ><select id='condition' onchange='changeAppType()' style='width:88%'>"
		               <c:forEach items='${appEnumKeyList}' var='appEnumKey' >
		               	hh+="<c:set value='${ctp:getApplicationCategoryName(appEnumKey, pageContext)}' var='objName' />"
		               	hh+="<option value='${appEnumKey}' ${appEnumKey==1 ? 'selected' : '' }>${ctp:i18n(objName)}</option>"
		               </c:forEach>
		            hh+="</select>"+
					"<input type='hidden' id='appType' name='appType' value='1'/>"+
					"<input type='hidden' name='statScope' id='statScope' value='account'>"+
					"<input type='hidden' name='templeteId' id='templeteId' value='${!isGroupAdmin and !isAdministrator ? '1' : '-1'}' /></div></td>";
		   }else{
			   hh+="<td width='100%'>" +
		       "<div class='common_selectbox_wrap' >" +
		       "<select id='flowType'>" +
		       "<option value='1'>${ctp:i18n('performanceReport.queryMainHtml.flowType.col')}</option>" +
		       "<option value='2'>${ctp:i18n('performanceReport.queryMainHtml.flowType.report')}</option>" +
		       "<option value='4'>${ctp:i18n('colCube.common.list.officeDoc')}</option>" +
		       "</select>" +
		       "</div>" +
		       "</td>";
		   }
	   return hh;
  }
  function comprehensiveAnalysis(){
  				var hh = "<div class='form_area set_search'>" +
    	 		"<table width='60%' border=0 cellpadding=0 cellspacing=0 class='common_center'>"+"<tbody>"+
         		"<tr>"+
 				"<td width='50%' vAlign='top' id='type_td' class='padding_lr_10'>";
	            	hh+="<table border=0 style='' cellpadding=0 cellspacing=0>" +"<tbody>";
			    	hh+="<tr>"+
			        	getTh("${ctp:i18n('performanceReport.queryMainHtml.flowType.name')}")+appType()+
			         	"</tr>";
			        	hh+="<tr>"+
			        	getTh("${ctp:i18n('performanceReport.queryMainHtml.getTime')}") + getTimeInterval("%Y-%m",true)+
			         	"</tr>";
         				hh+="</tbody>" +"</table>" +
         			"</td>" +
         			"<td width='50%' vAlign='top' class='padding_lr_10'>"+
         			"<table id='st_tab' border=0 cellpadding=0 cellspacing=0>" +"<tbody>" ;
				         hh+="<tr id='timeAll'>" +getTh("${ctp:i18n('performanceReport.queryMain.getTemplate')}") + templateRadio()+
				         "</tr>" +
         			"</tbody>" +"</table>" +
         			"</td>" +
         			"</tr>" +
         			"</tbody>" +"</table>" +
         			"</div>";
		 		hh += getButton();
		 		if(hiddenChartGridTab=='true'){
			 		$("#sectionTab #queryCondition").html(hh);
				}else{
		 			$("#tabs #queryCondition").html(hh);
				} 
  }
  
  function getAccount(){
	  var hh='';
	  if(isGroupAdmin=='true'){
		  hh+="<td nowrap='nowrap'><label for='toAccount'><input type='radio' name='statWhat' id='toAccount' value='Account'  checked='true' onclick='switchIt(this)'>"+getName("${ctp:i18n('performanceReport.queryMain.reports.account')}")+"</label></td>"
	  }
	  hh+="<td nowrap='nowrap'><label for='toDep'><input type='radio' name='statWhat' id='toDep' value='${accountId==null ? 'Department' : 'Account' }' ${isGroupAdmin ? '' : 'checked' } onclick='switchIt(this)'>"+getName("${ctp:i18n('performanceReport.queryMain.reports.department')}")+"</label>"+
		"<label for='toPer'><input type='radio' name='statWhat' id='toPer' value='Member' onclick='switchIt(this)'>"+getName("${ctp:i18n('performanceReport.authorize.list.personsName')}")+"</label>"+
		"<input type='hidden' id='statWhat' name='statWhat' value=''>"+
		"<input type='hidden' name='statType' id='statType' value='${accountId==null ? '' : 'Account' }'></td>"
		if(isGroupAdmin=="false"){
			hh+="<td nowrap='nowrap' id='acldem'>&nbsp;&nbsp;"+getName("${ctp:i18n('performanceReport.queryMain.reports.account')}"+"${ctp:i18n('performanceReport.queryMain.reports.department')}")+"</td>";
		}
		hh+="<td width='' align='right' id='perLabel' style='display:none' nowrap='nowrap'>&nbsp;&nbsp;"+getName("${ctp:i18n('performanceReport.queryMain.reports.designated.personnel')}")+"</td>"
	  
	    hh+="<td width='60px' id='depContent' nowrap='nowrap'><div class='common_txtbox_wrap'>"+
		"<c:set var='accountName' value='${ctp:getAccount(accountId).name}'/>"+
		"<input type='text' name='department' id='department' style='width:80px;' value='${empty accountName ? '点击选择' : accountName}' onclick='selectPeopleDA()'   readonly class='cursor-hand'/>"+
		"<input type='hidden' name='epartmentIds' id='departmentIds' value='${accountId }' />"+
		"</div></td>"+
		"<td width='60px' id='perContent' style='display:none' nowrap='nowrap'><div class='common_txtbox_wrap'>"+
		"<input type='text' name='person' id='person' style='width:80px' value='点击选择' readonly class='cursor-hand' />"+
		"<input type='hidden' name='personIds' id='personIds' value='' />"+
		"</div></td>"
	  return hh;
  }
		
	function getName(name){
		return name;
	}
  	function processAnalysis(){
  	var hh = "<div class='form_area set_search'>" +
    	 		"<table width='70%' border=0 cellpadding=0 cellspacing=0 class='common_center'>"+"<tbody>"+
         		"<tr>"+
 				"<td width='50%' vAlign='top' id='type_td' class='padding_lr_10'>";
	            	hh+="<table border=0  cellpadding=0 cellspacing=0>" +"<tbody>";
			    	hh+="<tr>"+
			        	getTh("${ctp:i18n('performanceReport.queryMainHtml.flowType.name')}")+appType()+
			         	"</tr>";
			         	hh+="<tr id='timeAll'>";
	    	 			hh+=getTh("${ctp:i18n('performanceReport.queryMain.textbox.startTime.name')}");
	    				hh+=getDate()+
				         "</tr>" ;
         				hh+="</tbody>" +"</table>" +
         			"</td>" +
         			"<td width='50%' vAlign='top' class='padding_lr_10'>"+
         			"<table border=0 cellpadding=0 cellspacing=0>" +"<tbody>" ;
				         hh+="<tr>";
				         if(isGroupAdmin=='false'){
	    	 				if(isAdministrator=='true'){
		     					hh+=getTh("${ctp:i18n('performanceReport.workFlowAnalysis.workFlowStat.businessType')}")
	    					 }else{
		    	 				hh+=getTh("${ctp:i18n('performanceReport.queryMain.getTemplate')}")
	    	 				}
	    				 }
	     				hh+=templateRadio()+
				         "</tr>";
				         hh+="<tr>"+getTh("${ctp:i18n('performanceReport.queryMain.textbox.Statistics')}")+getAccount()+
	     				"</tr>";
         			hh+="</tbody>" +"</table>" +
         			"</td>" +
         			"</tr>" +
         			"</tbody>" +"</table>" +
         			"</div>";
		 		hh += getButton();
		 		if(hiddenChartGridTab=='true'){
			 		$("#sectionTab #queryCondition").html(hh);
				}else{
		 			$("#tabs #queryCondition").html(hh);
				} 
  }
  //构造条件区域组件==========================================end 
</script>
    </head>
</html>        