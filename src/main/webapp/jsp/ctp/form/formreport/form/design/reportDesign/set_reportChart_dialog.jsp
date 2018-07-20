<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/form/formreport/form/common.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>图表</title>
<script>
  //获取父窗口参数
  var parentPara = window.dialogArguments;
  $(function() {
      initData();
	  //初始化选择按钮
	  initChooseButton();
	  
  })
  //初始化选择按钮
  function initChooseButton(){
        setBordFun($("#unselect"), $("#selected"), $("#select_ico"), $("#unselect_ico"));
        setBordFun($("#unselect1"), $("#selected1"), $("#select_ico1"), $("#unselect_ico1"));
  }
  //设置选择面板
  function setBordFun(unselect, selected, selected_ico, unselect_ico) {
    var bord_ = new setBord({
      isKeep : true,
      addObj : unselect,
      removeObj :selected
    });
    bord_.refreash();
    selected_ico.click(function() {
        //交叉报表只能选择一个图列项
       if($(this).attr("id") == "select_ico1"){
           if($("#unselect1").val() != null && parentPara.isAcross && ($("#selected1 option").length == 1 || $("#unselect1").val().length > 1)){
               $.error("${ctp:i18n('report.reportDesign.set.errorAcrossreport')}");
               return;
           }
       }
        bord_.add();
    });
    unselect_ico.click(function() {
        bord_.remove();
    });
    unselect.dblclick(function(){
        selected_ico.trigger("click");
    });
    selected.dblclick(function(){
        unselect_ico.trigger("click");
    });  
  }
  //初始化待选项
   function initData(){
	   //前面已选择的统计分组项
	   var reportHeadSelectedValue = parentPara.reportHeadSelected.value.split(",");
	   var reportHeadSelectedText = parentPara.reportHeadSelected.text.split(",");
	   //前面已选择的统计项
	   var showDataListSelectedValue = parentPara.showDataListSelected.value.split(",");
	   var showDataListSelectedText = parentPara.showDataListSelected.text.split(",");
	   /*
	   for(var i = 0 ; i < showDataListSelectedText.length ; i ++){
	       var index = showDataListSelectedText[i].indexOf(" ");
	       if(index != -1){
	           showDataListSelectedText[i] = showDataListSelectedText[i].substring(0, index);
	       }
	   }*/
	   //已选择的行
	   var headValue = parentPara.chartSelected.headValue.split(",");
	   var headText = parentPara.chartSelected.headText.split(",");
	   //已选择的列
	   var dataValue = parentPara.chartSelected.dataValue.split(",");
       var dataText = parentPara.chartSelected.dataText.split(",");
	   //生成option
	   toOption(reportHeadSelectedValue, reportHeadSelectedText, "#unselect");
	   toOption(showDataListSelectedValue, showDataListSelectedText, "#unselect1");
	   toOption(headValue, headText, "#selected");
	   toOption(dataValue, dataText, "#selected1");
	   $("#chartName").val(parentPara.chartSelected.title);
	   
	   $("#unselect option,#selected option").attr("type", "unselect");
	   $("#unselect1 option,#selected1 option").attr("type", "unselect1");
   }
  
  var unselectMap = new Object();
  //生成option
  function toOption(value, text, obj){
  	  var unselect = ("#unselect" == obj) || ("#unselect1" == obj);
  	  var selected = ("#selected" == obj) || ("#selected1" == obj);
  	  obj = $(obj);
	  if(value.length == text.length){
		  if(value.length > 0 && value[0] != ""){
		      for ( var i = 0; i < value.length; i++) {
		      	if(unselect){
		      		unselectMap[value[i]] = text[i];
		      		obj.append("<option value='" + value[i] + "' title='" + text[i] + "'>" + text[i] + "</option>");
		      	}else{
		      		if(unselectMap[value[i]] != undefined && unselectMap[value[i]] != ""){
		      			obj.append("<option value='" + value[i] + "' title='" + unselectMap[value[i]] + "'>" + unselectMap[value[i]] + "</option>");
		      		}
		      	}
		      }
		  }
	  }else{
		  $.error("${ctp:i18n('report.reportDesign.set.errorToOption')}");
	  }
  }
   //父子界面交互方法，return值能在父页面获得
  function OK(parms){
      var returnValue = new Object();
      var chartHead = "";
      var chartHeadValue = "";
      var chartData = "";
      var chartDataValue = "";

      $("#selected option").each(function() {
          chartHead = union(chartHead, $(this).text());
          chartHeadValue = union(chartHeadValue, $(this).val());
      });
      $("#selected1 option").each(function() {
          chartData = union(chartData, $(this).text());
          chartDataValue = union(chartDataValue, $(this).val());
      });
      returnValue.chartName = $("#chartName").val();
      returnValue.chartHead = chartHead;
      returnValue.chartHeadValue = chartHeadValue;
      returnValue.chartData = chartData;
      returnValue.chartDataValue = chartDataValue;
      if(MxtCheckInput($("#chartName")) && checkChooseAndInput()){
          returnValue.checkValue = true;
      }else{
          returnValue.checkValue = false;
      }
      return returnValue;
  }
   //选择为空判断
   function checkChooseAndInput(){
       //选择空判断 
	   if($.isNull($("#chartName").val()) || $("#chartName").val() === "null"){
           $.error("${ctp:i18n('report.reportDesign.set.errorEmptyChartName')}");//图表名称不能为空!
           return false;
       }
       if($("#selected option").length == 0){
           $.error("${ctp:i18n('report.reportDesign.set.errorCheckChooseAndInput')}");
           return false;
       }
       if($("#selected1 option").length == 0){
           $.error("${ctp:i18n('report.reportDesign.set.errorCheckChooseAndInput1')}");
           return false;
       }
       //交叉报表只能选择一个图列项
       
       return true;
   }
   //返回值拼接，以“,”隔开的字符串
   function union(_self, _new){
       (_self == "") ? (_self = _new) : (_self = _self + "," + _new);
       return _self;
   }
</script>
</head>
<body class="bg_color_white">
        <div class="shortcut_set align_center font_size12">
                <table width="100%" height="100%" class="margin_b_5">
                     <tr>
                            <th nowrap="nowrap"><label class="margin_r_5" for="text"><span class="required">*</span>${ctp:i18n('report.reportDesign.dialog.chartItem.title')}：</label></th>
                            <td width="100%" class="form_area">
                                <div class="common_txtbox_wrap">
                                    <input id="chartName" value="" class="validate font_size12" type="text" validate="type:'string',name:'${ctp:i18n('report.reportDesign.dialog.chartItem.title')}',notNull:true,maxLength:255,avoidChar:'!,@#$%^:&*()\\\/\'&quot;?<>'">
                                </div>
                            </td>
                     </tr>
                </table>
                    <table align="center" width="100%" height="100%" style="table-layout: fixed;">
                        <tr>
                            <td valign="top" width="50%" height="100%">
                                <p align="center" class="margin_b_5 font_size12 align_left">${ctp:i18n('report.reportDesign.dialog.groupingitem.title')}：</p> 
                                <select style="height: 150px;" class="w100b font_size12" multiple id="unselect"></select>
                            </td>
                            <td width="30px" valign="middle">
                            	<span class="select_selected" id="select_ico"></span><br> <br> 
                            	<span class="select_unselect" id="unselect_ico"> </span>
                            </td>
                            <td valign="top" width="50%" height="100%">
                                <p align="center" class="margin_b_5 w100b font_size12 align_left"><span class="required">*</span>${ctp:i18n('report.reportDesign.dialog.chartItem.row')}： </p> 
                                <select class="w100b selected_area font_size12" style="width: 225px; height: 150px;" multiple size="20" id="selected"></select>
                            </td>
                        </tr>
                    </table>
                </div>

                <div class="shortcut_set align_center">
                    <table align="center" width="100%" height="100%" style="table-layout: fixed;">
                        <tr>
                            <td valign="top" width="50%" height="100%">
                                <p align="center" class="margin_b_5 font_size12 align_left">${ctp:i18n('report.reportDesign.dialog.staticsitem.title')}：</p> 
                                <select style="height: 150px;" class="w100b font_size12" multiple id="unselect1"></select>
                            </td>
                            <td width="30px" valign="middle">
                            	<span class="select_selected" id="select_ico1"></span><br> <br> 
                            	<span class="select_unselect" id="unselect_ico1"> </span>
                            </td>
                            <td valign="top" width="50%" height="100%">
                                <p align="center" class="margin_b_5 w100b font_size12 align_left"><span class="required">*</span>${ctp:i18n('report.reportDesign.dialog.chartItem.column')}：</p> 
                                <select class="w100b selected_area font_size12" style="width: 225px; height: 150px;" multiple size="20" id="selected1"></select>
                            </td>
                        </tr>
                    </table>
                </div>


</body>
</html>
