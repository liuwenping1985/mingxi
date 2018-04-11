<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/form/formreport/form/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/form/formreport/form/queryReport/formreport_chart.js.jsp"%>

<!DOCTYPE html>
<html class="h100b" style="overflow: hidden;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${pageContext.request.contextPath}/common/form/formreport/js/FixTable.js${ctp:resSuffix()}"></script>
<title>${ctp:i18n('report.common.crumbs.queryReport')}</title>
<script type="text/javascript">
var imgnumber=0;//显示第几个图表
//以后切换图形时需要动态获取图形数据
var result = eval(${chartList}); //根据ID获取图表数据 
var chartCfg = eval(${chartCfgList});//图的设置
var echartData = null;//前图表的Base64图片dataURL
<c:if  test="${isError != 'true'}">
var dataHeadList = ${dataHeadList};
var dataObjecList = ${dataObjecList};
</c:if>

function drawing(){
	drawingSeeyonUiChart2();
}
function drawingDefualt(){
	$("#chartDiv input[type='radio']").eq(0).attr('checked',true);
	if(null != chartCfg){
		var columnSize = 0;
		var titles = parent.$("#showDataList").val().split(",");
		var columns = chartCfg[imgnumber].reportColumnList;
		$.each(titles, function(i, value) {
			$.each(columns, function(j, col) {
				if(value == col.title){
					columnSize = columnSize + 1;
				}
			});
		});
		
		if(columnSize >= 2){
	    	$("#chartType7").parent().hide();
	    }else{
	    	$("#chartType7").parent().show();
	    }
		drawingSeeyonUiChart2();
	}
}
function drawingSeeyonUiChart2(){
	//$("#drawingArea").height($("#chartDiv").height() - $("#chartToolBar").height() -20);
	var option = new Object();
	var type = "echarts";
	var dom = "drawingArea";
	if(undefined != result[imgnumber].chartJSON ){
		var echartJson = jQuery.parseJSON( result[imgnumber].chartJSON );
		var chartType = parseInt($("input:radio[name='chartType']:checked").val());
		echartData = drawingChart2(chartType,echartJson.option,dom);
	}else{
		echartData = drawingEmptyChart2(dom);
	}
}

function refreshChart() {
	if ($("#selctChart").val() == "null") {
		$.alert("${ctp:i18n('report.queryReport.index_right.prompt.selectChart')}"); //请选择图表
	} else {
		drawing();
	}
}

//url中特殊字符转义
function encodeURI4EscChar(str){
	return str.replace(/\#/g,"%23").replace(/\&/g,"%26").replace(/\?/g,"%3F").replace(/\'/g,"=singiequates=").replace(/\+/g,"%2B");
}

//fromPortal:来自首页栏目，需要隐藏条件区
var fromPortal=${fromPortal};
var hasUserCondition = "${hasUserCondition}";
function openshowquery(obj, titleinfo) {
	titleinfo = titleinfo;
	var formType = "";
	mapinfo = $(obj).find("input").val();
	if (!$.isNull(window.parent.document.getElementById("formType"))) {
		formType = window.parent.document.getElementById("formType").value; //表单类型
	}
	
	var url = _ctxPath + "/report/queryReport.do?method=openShowReportQueryPre&formMasterId=${formMasterId}";
	var userCondition = null;
	var userFastCon = null;
	var stateCon = null;
	if (fromPortal == 1) {
		//todo:栏目穿过来参数处理
		if (hasUserCondition == "true") {
			userCondition = $.toJSON(${userCondition});
		} else {
			userFastCon = "[]";
		}
		stateCon = $.toJSON(${stateCon});
	} else {
		if (!$(window.parent.document.getElementById("userConditionDiv")).is(":hidden")) {
			//OA-63139
			//userCondition = $(window.parent.document.getElementById("userConditionTable")).formobj({validate : false});//用户自定义查询
			userCondition = $.toJSON(${userCondition});
		} else if (!$(window.parent.document.getElementById("userFastCondition")).is(":hidden")) {
			//OA-59972
			//userFastCon = $(window.parent.document.getElementById("userFastCondition")).formobj({validate : false});
			userFastCon = $.toJSON(${userFastCondition});
		}
	}

	//流程表单
	if (formType == "1" && fromPortal != 1) {
		stateCon = $(window.parent.document.getElementById("stateTr")).formobj({
			checked: true
		}); //状态选择
		stateCon = $.toJSON(stateCon);
	}
	var dialog = $.dialog({
		title: "${ctp:i18n('report.queryReport.index_right_grid.showDetail')}",
		minParam: 'false',
		maxParam: 'false',
		isDrag: 'false',
		transParams: {
			reportid: "${reportId}",
			reportSaveId: "${reportSaveId}",
			title: titleinfo,
			mapinfo: mapinfo,
			formType: formType,
			userCondition: userCondition,
			userFastCondition: userFastCon,
			stateCon: stateCon
		},
		id: 'frOpenDialog',
		url: url,
		width: $(getCtpTop()).width() - 200,
		height: $(getCtpTop()).height() - 100,
		'targetWindow': getCtpTop()
	});
}
   //在页面抛出调用异常 
   <c:if  test="${error!=null}">
       var confirm = $.confirm({
		   'msg': '${ctp:toHTML(error)}',
       		ok_fn: function () {
       			$("#isContinue",window.parent.document).val("true");
       			parent.search();
       		},
       		cancel_fn:function(){}
       	});
   </c:if>
   <c:if  test="${prompt!=null}">
       var confirm = $.confirm({
       		'msg': '${prompt}',
       		ok_fn: function () {
       			$("#isContinue",window.parent.document).val("true");
       			parent.search();
       		},
       		cancel_fn:function(){}
       	});
   </c:if>
</script>

<script type="text/javascript">
$(document).ready(function() {
	if ($.browser.mozilla) {
		$("#chartDiv").css("height","94%");
	}
    if(parent.item==1){
        var val= parent.$("#selctChart").val();
        if(val!="null")
        {
            var values=val.split("=");//获得表单值 values[0] 表单名称values[1]
            imgnumber =parseInt(values[0]);
        }
        $("#gridDiv").addClass("hidden");
        $("#chartDiv").removeClass("hidden");
        drawingDefualt();
    }
    //图形类型选择事件
    $(".chartClass").click(function(){
        refreshChart();
    });
    
     /* ------------获得统计状态-----*/
     var formType="";
     if(!$.isNull(window.parent.document.getElementById("formType"))){
         formType=window.parent.document.getElementById("formType").value;//表单类型
     }
     if(fromPortal==1 || fromPortal ==2){ 
         $("#portalHidden").hide();
         $("#ftable").attr("style","border-top: none");
     }else if(fromPortal!=2){ // ==2代表从协同点击统计过来
    	 var showMap = propCondition();
    	 if(!$(window.parent.document.getElementById("userFastCondition")).is(":hidden")){
    		 //第一次进入普通模式不显示统计结果
             var isStatisticSvalue=  $(window.parent.document.getElementById("isStatisticSvalue"));
              if(isStatisticSvalue.val()=="1"){
                  $("#StatisticSvalue").show();
              }else{   //首页栏目的统计列表默认显示
                  if(fromPortal!=1){
                      $("#StatisticSvalue").hide();
                  }
                  isStatisticSvalue.val("0");
              }
    	 }
    	 if(formType !="1"){//无流程表单没有状态
             $("#status").hide();
             $("#flowStatus").hide();
             $("#space").show();
         }else{
        	 var stateCon = $(window.parent.document.getElementById("stateTr")).formobj({checked : true}); //状态选择
        	 var flowStatus = ''; //流程状态  0=未结束 1=结束 3=终止  
             if(stateCon.finishedflag0==0 && stateCon.finishedflag1==1 && stateCon.finishedflag3==3){
                 flowStatus = "";
             }else{
             	if(stateCon.finishedflag0==0)  //流程状态  0=未结束 1=结束 3=终止  
               	 	flowStatus+="${ctp:i18n('formquery_finishedno.label')},";//未结束
            	if(stateCon.finishedflag1==1)
             	    flowStatus+="${ctp:i18n('formquery_finished.label')},";//结束
             	if(stateCon.finishedflag3==3)
             	    flowStatus+="${ctp:i18n('formquery_stop.label')},";//终止
             	if (flowStatus.length > 0){
                 	flowStatus = flowStatus.substring(0,flowStatus.length-1);
                 	showMap.put("${ctp:i18n('formquery_sheetfinished.label')}"+':',flowStatus);
             	} 
             }
             
             var state = '';
             if(stateCon.state0==0)     //单据状态
                 state+="${ctp:i18n('form.query.draft.label')},";//草稿
             if(stateCon.state1==1)
                 state+="${ctp:i18n('form.query.nodealwith.label')},";//未审核
             if(stateCon.state2==2)
                 state+="${ctp:i18n('form.query.passing.label')},";//审核通过
             if(stateCon.state3==3)
                 state+="${ctp:i18n('form.query.nopassing.label')},";//审核不通过
             if (state.length > 0){
                 state = state.substring(0,state.length-1);
                 showMap.put("${ctp:i18n('form.formula.engin.audit.status.label')}"+':',state);
             }
             var ratify = '';    
             if(stateCon.ratifyflag0==0)
                 ratify+="${ctp:i18n('form.query.noapproved.label')},";//未核定
             if(stateCon.ratifyflag1==1)
                 ratify+="${ctp:i18n('flowBind.vouch.pass')},";//核定通过
             if(stateCon.ratifyflag2==2)
                 ratify+="${ctp:i18n('form.query.noapprovedpass.label')},";//核定不通过\
              if (ratify.length > 0){
                 ratify = ratify.substring(0,ratify.length-1);
                 showMap.put("${ctp:i18n('form.query.sheetapproved.label')}"+':',ratify);
             }
         }
    	 if(!showMap.isEmpty()){
             show = "${ctp:i18n('report.queryReport.index_right_grid.statisticConditions')}："+'<table width="100%"  border="0" cellpadding="0" cellspacing="0">'
             var len = showMap.size();
             var keys = showMap.keys();
             for(var i = 0;i < len;i++){
                show = show +'<tr height="20">';
                for(var j = 0; j < 3; j++){
                    if(j!==0 && i < len-1){
                        i++;
                    }
                    if(i === len -1){
                        j=3;
                    }
                    show = show +'<td align="left" width="33%" class="font_size12 padding_0">'+keys.get(i)+showMap.get(keys.get(i)).replace(/(<)/gi,"&lt").replace(/(>)/gi,"&gt")+'</td>';
                }
                show = show +'</tr>';
             }
             show = show +'</table>';
    	 	 $("#conditionTD").html(show); 
         }else{
        	 $("#conditionTD").remove();
         }
	}
    setDataTable();
    $("#moreData").click(function(){
        setDataTable();
    });
});
var dataNum = 200;//显示到多少数据
var tbodyHtml = "";
//设置显示数据高宽
function setDataTable(){
	var isError = "${isError}";
    if(isError != "true"){
    	var len = dataObjecList.length;
	    var dataTrTpl = document.getElementById('dataTrTpl').innerHTML; 
	    if(len >= dataNum){
	    	len = dataNum;
	    	$("#moreData").show();
	    }else{
	    	$("#moreData").hide();//隐藏更多
	    }
    	if(len > 0){
		    for(var i=0;i<len;i++){
		    	var dataObjs = dataObjecList[i];
		    	tbodyHtml = tbodyHtml + laytpl(dataTrTpl).render({dataObjs:dataObjs});
		    }
	    	dataObjecList.splice(0,len);
    	}
	    var dataTableTpl = document.getElementById('dataTableTpl').innerHTML; 
	    var tableHtml = laytpl(dataTableTpl).render({dataHeadList:dataHeadList,tbodyHtml:tbodyHtml});
    	$("#context").html(tableHtml);
    }
	
	var realHeight = $("#ftable").height(), realWidth = $("#ftable").width();//表格实际的高和宽
    var canHeight = $("#gridDiv").height(), canWidth = $("#gridDiv").width();//表格能够显示的高和宽
	if(fromPortal != 1){//统计下减去  表单名称显示的高度
		canHeight = canHeight - $("#portalHidden").height();
	}
    var handSize = "${headSize}";
    if(realHeight > canHeight || realWidth > canWidth ){
    	var fixColumnNumber = 0;//需要固定列数
    	if(realWidth > canWidth){
    		fixColumnNumber = parseInt(handSize);
    	}
    	if(realHeight > canHeight){
	   		$("#ftable").width(canWidth - 18);
    	}
		//使用FixTable 固定表头
	    FixTable("ftable", fixColumnNumber, canWidth, canHeight);
    }
}
     
/* ------------获得  统计条件-----*/
function propCondition(){
	var showMap = new Properties();
	if(!$(window.parent.document.getElementById("userFastCondition")).is(":hidden")){
        parent.$("tr","#userFastCondition").each(function(index,item){
            var title = "";
            var value = "";
            parent.$("input",item).each(function(){
                if($(this).attr("id")!="" && $(this).attr("id")!=undefined){
                	if($(this).attr("id").indexOf("_fieldName")>0){
                	    title = $(this).parent().text(); 
                	}
                }
            });
            
            parent.$("textarea",item).each(function(){//多组织控件
            	if($(this).attr("id")!="" && $(this).attr("id")!=undefined){
                	if($(this).attr("id").indexOf("_txt")>0){
                    	value = $(this).val();
                	}
                }
            });
            parent.$("input",item).each(function(){
                if($(this).attr("id")!="" && $(this).attr("id")!=undefined){
                	if($(this).attr("id").indexOf("_txt")>0){
                    	value = $(this).val();
                	}
                	if(($(this).attr("id")+":") == title 
                			&& $(this).attr("onclick") != undefined && $(this).attr("onclick").indexOf("selectEnums") == 0){
                		value = $(this).val();
                		return;
                	}
                }
                if($(this).attr("inputType")=="text"){
                    value = $(this).val();
                }else if($(this).attr("inputType")=="checkbox" || $(this).attr("inputType")=="radio"){
                    tempValues = $(this).val();
                    parent.$("input",$(this).next()).each(function(index,inputItem){
                        $.each(tempValues.split(","),function(valueIndex,tempValue){
                            if(tempValue==$(inputItem).val()){
                                value += $(inputItem).parent().text()+ ",";
                            }
                        });
                    });
                    if (value.length > 0){
                        value = value.substring(0,value.length-1);
                    }
                }else if($(this).attr("inputType")=="select"){
                    value = parent.$("select",$(this).next()).find("option:selected").text()
                }else if($(this).attr("inputType")=="datetime" || $(this).attr("inputType")=="date"){
                    value = $(this).val();
                }
            });
            if(value.trim() != ""){
            	showMap.put(title, value);
            }
        });
    }else{
        //自定义模式
        parent.$("tr","#userConditionDiv").each(function(index,item){
            var title = "";
            var value = "";
            title = parent.$("#fieldName",item).find("option:selected").text();
            parent.$("input",item).each(function(){
            	if($(this).attr("id")!="" && $(this).attr("id")!=undefined){
					if($(this).attr("id")=="fieldValue"){
						if($(this).attr("inputType")=="text"){
							value = $(this).val();
						}else if($(this).attr("inputType")=="checkbox" || $(this).attr("inputType")=="radio"){
							tempValues = $(this).val();
							parent.$("input",$(this).next()).each(function(index,inputItem){
								$.each(tempValues.split(","),function(valueIndex,tempValue){
									if(tempValue==$(inputItem).val()){
										value += $(inputItem).parent().text()+ ",";
									}
								});
							});
							if (value.length > 0){
								value = value.substring(0,value.length-1);
							}
						}else if($(this).attr("inputType")=="select"){
							value = parent.$("select",$(this).next()).find("option:selected").text()
						}else if($(this).attr("inputType")=="datetime" || $(this).attr("inputType")=="date"){
							value = $(this).val();
						}else if($(this).attr("inputType")=="project"){
							
						}else if($(this).attr("inputType")=="outwrite"){
							
						}else if($(this).attr("inputType")=="multimember" || $(this).attr("inputType")=="multiaccount" || $(this).attr("inputType")=="multidepartment" || $(this).attr("inputType")=="multipost" || $(this).attr("inputType")=="multilevel"){
							value = $(this).next().find("textarea").attr("title");
						}else{
							//组织机构人员选择
						}
					}
					if($(this).attr("id").indexOf("_display")>0){
						value = $(this).val();
					}
					if($(this).attr("id").indexOf("_txt")>0){
						value = $(this).val();
					}
					if($(this).attr("type")=="text"){
						value = $(this).val();
					}
                }
            });
            if(value&&value.trim() != ""){
            	if(!$.isNull(showMap.get(title + ":"))){
            		value = showMap.get(title + ":")+","+value;
            		showMap.put(title + ":", value);
            	}else{
            		showMap.put(title + ":", value);
            	}
            }
        });
    }
	return showMap;
}

</script>
<script type="text/html" id="dataTableTpl">
<table class="only_table edit_table" style="border-right: none;" border="0" cellSpacing="0" cellPadding="0" width="100%" id="ftable">
	<thead>
		{{# for(var i = 0, len = d.dataHeadList.length; i < len; i++){ }}
			{{# var heads = d.dataHeadList[i]; }}
			<tr>
			{{# for(var j = 0, hlen = heads.length; j < hlen; j++){ }}
				{{# var head = heads[j]; var title = head.title;  title =  (title == null || title == '') ? "&nbsp;": title ; }}
				<th nowrap="nowrap" colspan="{{head.colSpan}}" rowspan="{{head.rowSpan}}" style="text-align: center;">
				<div style="text-align: center; overflow: visible; margin: auto;">{{=title }}</div></th>
			{{# } }}
			</tr>
		{{# } }}
	</thead>
	<tbody id="StatisticSvalue">{{d.tbodyHtml}}</tbody>
</table>
</script>
<script type="text/html" id="dataTrTpl">
<tr>
  {{# for(var i = 0, len = d.dataObjs.length; i < len; i++){ }}
    {{# var dataObj = d.dataObjs[i];var dis = dataObj.display; dis =  (dis == null || dis == '') ? "&nbsp;": dis ; }}
    {{# if (dataObj.dataPenetrate.title == '') { }}
      <td align="center"><div style="text-align:center;overflow: hidden;">{{=dis }}</div></td>
    {{# } else { }}
      <td align="center" style="cursor:pointer" onclick="openshowquery(this,'{{=dataObj.dataPenetrate.title }}')">
        <a>
          <div style="text-align:center;overflow: hidden;">{{=dis }}</div>
        </a>
        <input class="dongtaiContent hidden" value="{{=dataObj.dataPenetrate.urlWithConditionsStr}}"/>
      </td>
    {{# } }}
  {{# } }}
</tr>
</script>
</head>
<body class="h100b bg_color_white bg_color_none" id="layout">
	<div id="chartDiv" class="hidden h100b">
		<TABLE id="chartToolBar" class="only_table" border="0px" cellSpacing="0px" cellPadding="0px" width="100%">
			<THEAD>
				<TR>
					<TH style="text-align: center"><label class="margin_r_10 hand" for="chartType1">
						<input type="radio" name="chartType" id="chartType1" checked="checked" class="margin_l_10 margin_r_5 chartClass" value="1" />${ctp:i18n('report.queryReport.index_right.toolbar.barChart')}</label>
						<label class="margin_r_10 hand" for="chartType7">
						<input type="radio" name="chartType" id="chartType7" class="margin_l_10 margin_r_5 chartClass" value="7" />${ctp:i18n('report.queryReport.index_right.toolbar.pieChart')}</label>
						<label class="margin_r_10 hand" for="chartType3">
						<input type="radio" name="chartType" id="chartType3" class="margin_l_10 margin_r_5 chartClass" value="3" />${ctp:i18n('report.queryReport.index_right.toolbar.lineChart')}</label>
						<label class="margin_r_10 hand" for="chartType11">
						<input type="radio" name="chartType" id="chartType11" class="margin_l_10 margin_r_5 chartClass" value="11" />${ctp:i18n('report.queryReport.index_right.toolbar.radarChart')}</label>
					</TH>
				</TR>
			</THEAD>
		</TABLE>
		<div style="height: 90%; width: 100%;" class="align_center">
			<div style="height: 100%; width: 100%;" class="align_center" id="drawingArea"></div>
		</div>
	</div>
	<div id="gridDiv" class="h100b w100b">
		<c:choose>
			<c:when test="${reportId == null}">
			</c:when>
			<c:otherwise>
				<table style="border: none; font-size: 12px;" id="portalHidden" border="0" cellSpacing="0" cellPadding="0" width="99%">
					<thead>
						<tr>
							<th align="center" class="padding_t_5" id="reportName" rowspan="2" colspan="3" style="font-size: 12px;">${reportName }</th>
						</tr>
						<tr>
							<th align="center" class="padding_t_5" id="reportName" rowspan="2" colspan="3" style="font-size: 12px;">
							<a id="moreData" class="hide">${ctp:i18n('report.queryReport.index_right_grid.showmore')}</a></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td align="center">
								<table width="98%" id="conditionDetailTable"
									border="0" cellpadding="0" cellspacing="0"
									style="margin-left: 5px;">
									<tr>
										<td colspan="2" width="66%"></td>
										<td width="33%" align="left" id="formName">${formName }</td>
									</tr>
									
									<tr>
										<td colspan="2" width="66%"></td>
										<td width="33%" align="left" id="currentDate">${currentDate }</td>
									</tr>
									<tr>
										<td align="left" colspan="2" id="mycondition" width="60%"></td>
									</tr>
									<tr>
										<td id="conditionTD" colspan="3" align="left" width="100%" class="font_size12 padding_0">&nbsp;</td>
									</tr>
								</table>
							</td>
						</tr>
					</tbody>
				</table>
				<div id="table" style="height: 100%; width: 100%;">
					<div id="context" style="height: 100%;">
						<table class="only_table edit_table" style="border-left: none; border-right: none;" border="0" cellSpacing="0" cellPadding="0" width="100%" id="ftable">
							<%-- <thead>
								<c:forEach var="heads" items="${dataHeadList}">
									<tr>
										<c:forEach var="headValue" items="${heads}" varStatus="status">
											<th nowrap="nowrap" colspan="${headValue.colSpan}" rowspan="${headValue.rowSpan}" style="text-align: center;">
											<div style="text-align: center; overflow: visible; margin: auto;">${ctp:toHTMLWithoutSpace(headValue.title)}</div></th>
										</c:forEach>
									</tr>
								</c:forEach>
							</thead> --%>
							<!--千万别换行！！！解决ie9下表格中空文本节点造成表格飘移的问题-->
<%-- 							<tbody id="StatisticSvalue"><c:forEach var="data" items="${report.dataSet.dataObjectList}" varStatus="row"><tr><c:set var="isAdd" value="true"/><c:forEach var="val" items="${data}" varStatus="status"><c:choose><c:when test="${val.dataPenetrate.title==''}"><td align="center"><div style="text-align:center;overflow: hidden;"><c:choose><c:when test="${empty val.display}">&nbsp;</c:when><c:otherwise>${ctp:toHTMLWithoutSpace(val.display)}</c:otherwise></c:choose></div></td></c:when><c:otherwise><td align="center" style="cursor:pointer" onclick="openshowquery(this,'${val.dataPenetrate.title}')"><a><div style="text-align:center;overflow: hidden;"><c:choose><c:when test="${empty val.display}">&nbsp;</c:when><c:otherwise>${ctp:toHTMLWithoutSpace(val.display)}</c:otherwise></c:choose></div></a><input class="dongtaiContent hidden" value="${val.dataPenetrate.urlWithConditionsStr}"/></td></c:otherwise></c:choose></c:forEach></tr></c:forEach></tbody> --%>
						</table>
					</div>
				</div>
			</c:otherwise>
		</c:choose>
	</div>
<script type="text/javascript" src="${path }/common/js/laytpl.js${ctp:resSuffix()}"></script>
</body>
</html>
