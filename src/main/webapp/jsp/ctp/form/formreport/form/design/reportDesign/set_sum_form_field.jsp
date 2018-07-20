<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/form/formreport/form/common.jsp" %>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="${url_ajax_reportDesignManager}"></script>
<title>分类行汇总</title>

<script type="text/javascript">
  //获取父窗口参数
  var parent = window.dialogArguments;
  var sortColumnVal=parent.sortColumnVal;
  var from = "${ctp:escapeJavascript(from)}";
  $(function() {
    
	//初始化汇总字段
    initClassifyFields();
	//初始化汇总方式
	if(parent.summaryWay != undefined && parent.summaryWay != ""){
    	$("#summaryWay").val(parent.summaryWay);
	}
    //初始化汇总项
    initSummaryFields();
    //绑定方法
    $("#reset").click(function() {
   		reset();
	});
  });
  
  //分类汇总的汇总字段就是统计分组项
  function initClassifyFields(){
  	if(!$.isNull(parent.selectedShowTitle) && !$.isNull(parent.selectedValue)){
  		var classifyTitles = parent.selectedShowTitle.split(",");//分类字段名称
        var classifyFields = parent.selectedValue.split(",");//分类字段
  		var options = "<option value=''></option>";
        for ( var i = 0; i < classifyFields.length; i++) {
        	//回填选中
        	if(parent.classifyValue == classifyFields[i]){
        		options = options + "<option value="+classifyFields[i]+" selected='selected'>"+classifyTitles[i]+"</option>"
        	}else{
        		options = options + "<option value="+classifyFields[i]+">"+classifyTitles[i]+"</option>"
        	}
        }
  		$("#classifyFields").html(options);
  	}
  }
  //分类汇总的汇总项就是统计项
  function initSummaryFields(){
  	if(!$.isNull(parent.selectedShowTitles) && !$.isNull(parent.selectedValues)){
  		var summaryNewTitles = parent.selectedNewShowTitles.split(",");//可能修改名字
  		var summaryTitles = parent.selectedShowTitles.split(",");//汇总项名称
        var summaryFields = parent.selectedValues.split(",");//汇总项
        var tableHtml = "<table>";
        for ( var i = 0; i < summaryFields.length; i++) {
        	//回填选中
        	if($.inArray(summaryNewTitles[i],parent.summaryItem.split(",")) >= 0){
        		tableHtml = tableHtml + "<tr><td><input name='summaryField' type='checkbox' checked value='"+summaryFields[i]+"' newTitles='"+summaryNewTitles[i]+"' /><label class='font_size12 margin_l_5'>"+summaryTitles[i]+"</label></td></tr>"
        	}else{
        		tableHtml = tableHtml + "<tr><td><input name='summaryField' type='checkbox' value='"+summaryFields[i]+"' newTitles='"+summaryNewTitles[i]+"' /><label class='font_size12 margin_l_5'>"+summaryTitles[i]+"</label></td></tr>"
        	}
        }
        tableHtml = tableHtml+ "</table>";
        $("#summaryField").html(tableHtml);
  	}
  }
	function checkThis(obj){
		if($(obj).find("input").attr("checked")){
			$(obj).find("input").attr("checked",false);
		}else{
			$(obj).find("input").attr("checked",true);
		}
	}
	//重置
	function reset(){
		$("#classifyFields option:first").prop("selected", "selected");
		$("#summaryWay option:first").prop("selected", "selected");
  		$("input[name='summaryField']").each(function(){
  			$(this).attr("checked",false);
  		});  
	}
  
  function OK(parms) {
  	var summaryNewTitles = "";
	var summaryTitles = "";
	var summaryValues = "";
	var summaryTypes = "";
	$("input[name='summaryField']:checked").each(function(){
		summaryNewTitles = summaryNewTitles + $(this).siblings().text()+",";
  		summaryTitles = summaryTitles + $(this).attr("newTitles")+",";
  		summaryValues = summaryValues + $(this).val() + ",";
  		summaryTypes = summaryTypes + $(this).attr("staticsTypes") + ",";
 	});
 	var returnObj = new Object();
 	if($("input[name='summaryField']:checked").length > 0){
 	returnObj.texts = summaryNewTitles.substring(0,summaryNewTitles.length-1);
 	//汇总字段
    returnObj.classifyValue = $("#classifyFields").val();
 	//汇总方式
    returnObj.summaryWay = $("#summaryWay").val();
    returnObj.summaryWayTitle = $("#summaryWay option:selected").text();
 	//汇总项
 	returnObj.summaryTitles = summaryTitles.substring(0,summaryTitles.length-1);
    returnObj.summaryValues = summaryValues.substring(0,summaryValues.length-1);
    returnObj.summaryTypes = summaryTypes.substring(0,summaryTypes.length-1);
 	}
    return returnObj;
  }
  
</script>
</head>
<body class="h100b over_hidden">
    <div class="margin_tb_10" style="margin-right:26px;margin-left:26px;">
    	<table>
    		<tr class="margin_t_5">
    			<td><label class="font_size12 margin_r_10" for="text">${ctp:i18n('report.reportDesign.dialog.classifyField')}</label></td>
    		</tr>
    		<tr class="margin_t_5">
    			<td>
    				<select class="border_all" style="width:255px" id="classifyFields"></select>
				</td>
    		</tr>
    		<tr class="margin_t_5">
    			<td><label class="font_size12 margin_r_10" for="text">${ctp:i18n('report.reportDesign.dialog.summaryWay')}</label></td>
    		</tr>
    		<tr class="margin_t_5">
    			<td>
    				<select class="border_all" style="width:255px" id="summaryWay">
						<option value="sum">${ctp:i18n('report.reportDesign.sum')}</option>
						<option value="count">${ctp:i18n('report.reportDesign.count')}</option>
						<option value="avg">${ctp:i18n('report.reportDesign.avg')}</option>
						<option value="max">${ctp:i18n('report.reportDesign.max')}</option>
						<option value="min">${ctp:i18n('report.reportDesign.min')}</option>
					</select>
    			</td>
    		</tr>
    		<tr class="margin_t_5">
    			<td><label class="font_size12 margin_r_10" for="text">${ctp:i18n('report.reportDesign.dialog.summaryItem')}</label></td>
    		</tr>
    		<tr class="margin_t_5">
    			<td><div class="border_all margin_tb_5" style="width:252px;height:120px;overflow:auto" id="summaryField"></div></td>
    		</tr>
    		<tr class="margin_t_5">
    			<td><a class="common_button common_button_gray" id="reset" style="margin-top:2px" href="javascript:void(0)">${ctp:i18n('report.reportDesign.button.reset')}</a></td>
    		</tr>
    	</table>
    </div>
</body>
</html>
