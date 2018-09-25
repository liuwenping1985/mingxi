//生成表
function drawGrid() {
	var headList = reportParams.headList;
	var dataObjectList = reportParams.dataObjectList;
	var heads = reportParams.heads;
    var reportId = $("#reportId").val();
    //个人团队页签切换，表格数据清空
    if ($.isNull(result)) { $("#queryResult").html(""); } 
    else {
        var hh = "";
        if (reportId == ONLINETIMESTATISTICS) { hh = drawGridOnline(); $("#queryResult").html(hh); } 
        else if (reportId === KNOWLEDGESCORESTATISTICS || reportId === EFFICIENCYANALYSIS
        		|| reportId === NODEANALYSIS ||reportId === OVERTIMEANALYSIS
        		|| reportId === IMPROVEMENTANALYSIS || reportId === COMPREHENSIVEANALYSIS
        		|| reportId===PROCESSPERFORMANCEANALYSIS) {
            pagingGrid();
        } else {
            hh = "<table class='only_table edit_table' border='0' id='reportGrid' cellSpacing='0' cellPadding='0' width='100%' style='overflow:hidden;min-width:480px;'>" +
                "<thead>";
            for (var i = 0; i < headList.length; i++) {
                var sHead = headList[i];
                hh += "<tr>";
                for (var j = 0; j < sHead.length; j++) {
                    var headItem = sHead[j];
                    if(isAdministrator === 'true' && Constants_report_id === PROCESSPERFORMANCEANALYSIS
                    		&& headItem.title === $.i18n('performanceReport.业务类型')){
                    	hh += "<th colspan='" + headItem.colSpan + "' rowspan='" + headItem.rowSpan + "' style='text-align: center;line-height：20px;width:269px' nowrap='nowrap'>" + headItem.title + "</th> ";
                    }else{
                    	hh += "<th colspan='" + headItem.colSpan + "' rowspan='" + headItem.rowSpan + "' style='text-align: center;line-height：20px;' nowrap='nowrap'>" + headItem.title + "</th> ";
                    }
                }
                hh += "</tr>";
            }
            hh += "</thead>" + "<tbody>";
            if(dataObjectList.length > 0) {
	            for (var i = 0; i < dataObjectList.length; i++) {
	                var dataObject = dataObjectList[i];
	                hh += "<tr>";
	                for (var j = 0; j < dataObject.length; j++) {
	                    var dataObjectItem = dataObject[j];
	                    var throughQueryUrl = dataObjectItem.dataPenetrate.urlWithConditionsStr;
	                    var disVal = dataObjectItem.display;
	                    var val=disVal.split(";");
	                    //截取长度小于等于45的字符串
	                    val = val.length <= 45 ? disVal : (val.slice(0,44).join(";")+"...");
	                    val = val.escapeHTML();
	                    disVal = disVal.escapeHTML();
	                    if (throughQueryUrl != '' && throughQueryUrl != undefined && !$.isNull(disVal) && disVal != '0') {
	                    	if((Constants_report_id === EFFICIENCYANALYSIS || Constants_report_id === OVERTIMEANALYSIS || Constants_report_id === PROJECTSCHEDULESTATISTICS) && j === 0) {
	                        	hh += "<td align='center' nowrap='nowrap' style='min-width:58px;text-align:left' title='"+disVal+"'><a href='#' style='color:blue' onclick='throughQueryDialog(\"" + throughQueryUrl + "\")' id='queryList'>&nbsp;" +val + "</a></td>";
	                        }else if(Constants_report_id === TASKBURNDOWNSTATISTICS){
	                        	hh += "<td align='center' nowrap='nowrap' style='min-width:58px;' title='"+disVal+"'><a href='#' style='color:blue' onclick='throughQueryDialog(\"" + throughQueryUrl + "\")' id='queryList'>&nbsp;" +val + "</a></td>";
	                        }else{
	                        	hh += "<td align='center' nowrap='nowrap' style='min-width:58px;' title='"+disVal+"'><a href='#' style='color:blue' onclick='throughQueryDialog(\"" + throughQueryUrl + "\")' id='queryList'>&nbsp;" +val + "</a></td>";
	                        }
	                    } else {
                    		if(Constants_report_id === PROCESSPERFORMANCEANALYSIS && headItem.title === $.i18n('performanceReport.业务类型')){
                        		hh += "<td align='center' nowrap='nowrap' style='width:269px' title='"+disVal+"'>&nbsp" + val+ "</td>";
                        	}else{
                        		hh += "<td align='center' nowrap='nowrap' style='min-width:58px' title='"+disVal+"'>&nbsp" + val+ "</td>";
                        	}
	                    }
	                }
	                hh += "</tr>";
	            }
	            }else{
	            	//if(reportId == PROJECTSCHEDULESTATISTICS||reportId == FLOWSENTANDCOMPLETEDSTATISTICS || reportId == FLOWSENTANDCOMPLETEDSTATISTICSFORM ||reportId == FLOWSENTANDCOMPLETEDSTATISTICSEDOC || reportId == KNOWLEDGEINCREASESTATISTICS){
	            		  hh += "<tr><td align='center' style='font-size:12px' nowrap='nowrap' colspan='"+sHead.length+"'>没有可以显示的数据！</td></tr>";
	            	//}
	            }
            hh += "</tbody>" + "</table>";
            $("#queryResult").html(hh).css("overflow","auto");
            /*if (reportId == FLOWSENTANDCOMPLETEDSTATISTICS || reportId == FLOWSENTANDCOMPLETEDSTATISTICSFORM ||reportId == FLOWSENTANDCOMPLETEDSTATISTICSEDOC || reportId == KNOWLEDGEINCREASESTATISTICS) {
                if (($.isNull(dataObjectList) || dataObjectList.length==0)) {
                    $.alert("${ctp:i18n('performanceReport.queryMain_js.errorNoData')}"); //对不起，你统计的范围内没有数据！
                    return false;
                }
            }*/
        }
    }
  }
 
//在线时间分析展现方式比较特别，单独列出
function drawGridOnline(){
	  var headList = reportParams.headList;
	  var dataList = reportParams.dataList;
	  var hh="<table class='only_table edit_table' border='0' id='onlineAnalysis' cellSpacing='0' cellPadding='0' width='100%' style='overflow:hidden;min-width:480px;'>"+   
	  "<thead>"; 
	  for(var i=0;i<headList.length;i++){
		  var sHead=headList[i];
		  hh+="<tr>";                                                                                    
		  for(var j=0;j<sHead.length;j++){
			   var headItem=sHead[j];             
			   hh+="<th colspan='"+headItem.colSpan+"' rowspan='"+headItem.rowSpan+"' style='text-align: center;line-height:20px;'>"+headItem.title+"</th> "; 	  
		  }                                                                                                          
		  hh+="</tr>"; 
	   }                                                                                                                     
	   hh+="</thead>" + "<tbody>";
	   if($.isNull(reportParams.gridHtml)){ hh += "<tr><td align='center' nowrap='nowrap' colspan='"+sHead.length+"'>没有可以显示的数据！</td></tr>";}
	   else{ hh+=reportParams.gridHtml;}                                                                                                               
	   hh+="</tbody>" + "</table>";        
       return hh;
}

//增加分页，需要使用表格组建
function pagingGrid(){
	  var headList=reportParams.headList;
	  var heads=reportParams.heads;
	  var dataList=reportParams.dataList;
	  var performanceQueryManager_ = new performanceQueryManager;
	  var obj = $("#execelCondition").formobj();
	  if(!$.isNull(dataList)){
      		var xxxx;
	  	    if(Constants_report_id === KNOWLEDGESCORESTATISTICS){
	  	    	//知识积分排行榜
	  			xxxx=performanceQueryManager_.knowledgeScorePaging(obj,$("#pageSize").val(),$("#pageNo").val());//
	  	    }else{
	  			xxxx=performanceQueryManager_.workflowScorePaging(obj,$("#pageSize").val(),$("#pageNo").val());//
	  	    }
	  	    //没有定义hh将导致hh成为全局变量
		    var hh="<table class='only_table edit_table' border='0' cellSpacing='0' id='knowledgeLeader' cellPadding='0' width='100%' style='overflow:hidden;min-width:480px;'>"+   
		    "<thead>"; 
			for(var i=0;i<headList.length;i++){
				var sHead=headList[i];
				hh+="<tr>";                             
				for(var j=0;j<sHead.length;j++){
					var headItem=sHead[j];
					hh+="<th colspan='"+headItem.colSpan+"' rowspan='"+headItem.rowSpan+"' style='text-align: center;line-height:20px;'>"+headItem.title+"</th> "; 
				 }                                                                                                                 
			    hh+="</tr>"; 
			  }        
		    hh+="</thead>" + "<tbody>";
			if(Constants_report_id === KNOWLEDGESCORESTATISTICS){
	   			for(var i=0;i<xxxx.length;i++){
	   				hh+="<tr>";
	   				for(var j=0;j<xxxx[i].length;j++){
		   				hh+="<td align='center'>"+xxxx[i][j]+"</td>";  
	   				}
	   				hh+="</tr>";
		   		 }
			 } else {
		   		for(var i=0;i<xxxx.length;i++){
	   				hh+="<tr>";
	   				for(var j = 0; j < xxxx[i].length; j++) {
   						var throughQueryUrl=xxxx[i][j].dataPenetrate.urlWithConditionsStr;
   						var disVal=xxxx[i][j].display;
   						var val=disVal.split(";");
	          			//截取长度小于等于45的字符串
	          			val=val.length <= 45 ? disVal : (val.slice(0,44).join(";")+"...");
	          			val=val.escapeHTML();
	          			disVal=disVal.escapeHTML();
	          			if (throughQueryUrl && !$.isNull(disVal) && disVal != '0') {
	          				if((Constants_report_id === EFFICIENCYANALYSIS || Constants_report_id === OVERTIMEANALYSIS || Constants_report_id === PROJECTSCHEDULESTATISTICS)
	          						&&j==0){
	              				hh += "<td align='center' nowrap='nowrap' style='min-width:58px;text-align:left' title='"+disVal+"'><a href='#' style='color:blue' onclick='throughQueryDialog(\"" + throughQueryUrl + "\")' id='queryList'>" +val + "</a></td>";
	              			}else{
	              				hh += "<td align='center' nowrap='nowrap' style='min-width:58px;' title='"+disVal+"'><a href='#' style='color:blue' onclick='throughQueryDialog(\"" + throughQueryUrl + "\")' id='queryList'>" +val + "</a></td>";
	             			}
	          			} else {
	              			hh += "<td align='center' nowrap='nowrap' style='min-width:58px' title='"+disVal+"'>" + val+ "</td>";
	          			}
	   				}
		   				hh+="</tr>";
		   			}
			 }
		   hh+="</tbody>" + "</table>";   
		   $("#queryResult").html(hh);
	  } 
}

//分页初始化
function pageInit(){
	if($("#pageSize").val()==""){
		$("#pageSize").val(20);
	}
	if($("#pageNo").val()==""){
		$("#pageNo").val(1);
	}
			
	$("#grid_go").click(grid_go);
	$("#prevPage").click(prevPage);	
	$("#nextPage").click(nextPage);	
	$("#firstPage").click(firstPage);	
	$("#lastPage").click(lastPage);			
}
//下一页
function nextPage(){
	configPage('next');
	pagingGrid();
}
//上一页
function prevPage(){
	configPage('prev');
	pagingGrid();
}
//首页
function firstPage(){
	configPage('first');
	pagingGrid();
}
//最后一页
function lastPage(){
	configPage('last');
	pagingGrid();
}
//页面跳转
function grid_go(){
	configPage('');
	pagingGrid();
}

/**
 * 读取输入框中的页数、每页条数，根据type类型设置要下一页列表的页数、每页条数等
 * @param type 如果type为空，表示直接跳转
 **/
function configPage(type){
	//当前页（输入框里面的当前页）
	var pageNo=fetchPageNo();
    //每页显示的条数
	var pageSize=fetchPageSize();
    //默认每页显示的条数
    var defaultPageSize=20;
	//总页数
	var totlePageNum=Math.ceil(pageTotle/pageSize);
	// 新页数
	if(type=='next'){
		pageNo++;
	}else if(type=='prev'){
		pageNo--;
	}else if(type=='first'){
		pageNo = 1;
	}else if(type=='last'){
		pageNo = totlePageNum;
	}
	var newPageNo = pageNo;
	// 根据最大最小值，调整页数
	if(pageNo<1){
		newPageNo = 1;
	}
	if(pageNo>totlePageNum){
		newPageNo = totlePageNum;
	}
	// 设置本次要跳转的页数和每页条数
	$("#pageNo").val(newPageNo);
	$("#pageSize").val(pageSize);
	// 设置总页数
	$("#totlePage").html($.i18n('performanceReport.queryMain_js.pageTotal',Math.ceil(pageTotle/pageSize)));
}
// 读取当前页数
function fetchPageNo(){
	var pNo = $.trim($("#pageNo").val());
	var defaultPageNo = 1;
	var pageNo = defaultPageNo;
	try{
		if(parseInt(pNo)>0){
			pageNo = parseInt(pNo);
		}
	}catch(e){
	}
	return pageNo;
}
// 读取当前每页条数
function fetchPageSize(){
	var pNo = $.trim($("#pageSize").val());
	var defaultPageSize = 20;
	var pageSize = defaultPageSize;
	try{
		if(parseInt(pNo)>0){
			pageSize = parseInt(pNo);
		}
	}catch(e){
	}
	return pageSize;
}

function configPageTotalAndSize(){
	var total = 0;
	var no = 0;
	if(pageTotle!=null){// 增加判断，解决为空的时候可能造成的问题
		total = pageTotle;
		no = Math.ceil(pageTotle/parseInt($("#pageSize").val()));
	}
	$("#totleItem").html($.i18n('performanceReport.queryMain_js.unitTotal',total));	
	$("#totlePage").html($.i18n('performanceReport.queryMain_js.pageTotal',no));
}