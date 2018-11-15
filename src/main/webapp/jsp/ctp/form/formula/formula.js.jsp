<%--
 $Author: wangfeng $
 $Rev: 261 $
 $Date:: 2013-3-17 14:00:30#$:
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page import="com.seeyon.ctp.form.modules.engin.formula.FormulaEnums"%>
<script type="text/javascript">
/*******************************常量start************************************/
var fMgr = new formManager();
var oldFormulaStr = "";//记录打开时的公式，如果关闭时一样，就不做校验，节约性能
//组件类型
var componentType_formula="<%=FormulaEnums.componentType_formula%>";//公式组件
var componentType_condition="<%=FormulaEnums.componentType_condition%>";//条件组件
//公式组件类型
var formulaType_number = "<%=FormulaEnums.formulaType_number%>";//数字类型公式
var formulaType_varchar = "<%=FormulaEnums.formulaType_varchar%>";//字符串类型公式(动态组合)
var formulaType_date = "<%=FormulaEnums.formulaType_date%>";//日期类型公式
var formulaType_datetime = "<%=FormulaEnums.formulaType_datetime%>";//日期时间类型公式
//公式组件类型(自动更新)
var formulaType_auto_number = "<%=FormulaEnums.formulaType_auto_number%>";//数字类型公式
var formulaType_auto_varchar = "<%=FormulaEnums.formulaType_auto_varchar%>";//字符串类型公式(动态组合)
var formulaType_auto_date = "<%=FormulaEnums.formulaType_auto_date%>";//日期类型公式
var formulaType_auto_datetime = "<%=FormulaEnums.formulaType_auto_datetime%>";//日期时间类型公式

var formulaType_sub_varchar = "<%=FormulaEnums.formulaType_sub_varchar%>";
var formulaType_sub_number = "<%=FormulaEnums.formulaType_sub_number%>";
var formulaType_sub_date = "<%=FormulaEnums.formulaType_sub_date%>";
var formulaType_sub_datetime = "<%=FormulaEnums.formulaType_sub_datetime%>";

var formulaType_sub_summarize_number = "<%=FormulaEnums.formulaType_sub_summarize_number%>";

//条件组件类型
var conditionType_BizCheck = "<%=FormulaEnums.conditionType_BizCheck%>";//业务规则校验
var conditionType_noFunction = "<%=FormulaEnums.conditionType_noFunction%>";//不需要函数
var conditionType_all = "<%=FormulaEnums.conditionType_all%>";//所有界面元素
/*******************************常量end************************************/
//配置参数
var dialogArg = window.dialogArguments;//所有参数
//必选参数
var callBackFunction = dialogArg.callBack;//回调函数
var formId = ""+dialogArg.formId;//表单ID
var componentType = dialogArg.componentType?dialogArg.componentType:componentType_condition;//组件类型公式，条件
var formulaType = dialogArg.formulaType?dialogArg.formulaType:formulaType_number;//需要设置的公式类型(数字，文本，日期类)
var conditionType = dialogArg.conditionType?dialogArg.conditionType:conditionType_noFunction;//需要设置的条件类型(有函数，无函数)
var formulaStr = dialogArg.formulaStr==null?"":$.trim(dialogArg.formulaStr);//公式
//可选参数
var formulaDes = dialogArg.formulaDes==null?"":$.trim(dialogArg.formulaDes);//公式描述
var advanceUrl = dialogArg.advanceUrl;//高级功能的URL
var parentWin = dialogArg.parentWin;//父页面对象
var filterFields = dialogArg.filterFields;//需要过滤掉的字段
var userVar= dialogArg.userVar;//用户变量
var userVarTitle= dialogArg.userVarTitle;//用户变量页签标题
var allowSubFieldAloneUse = dialogArg.allowSubFieldAloneUse==null?false:dialogArg.allowSubFieldAloneUse;//是否需要校验重复项字段是否能单独使用
var checkSubFieldMethod = dialogArg.checkSubFieldMethod==null?false:dialogArg.checkSubFieldMethod;//是否需要验证重复项字段必须出现在重复项方法中
var hasDifferSubField = dialogArg.hasDifferSubField==null?false:true;//是否要校验表达式里是否包含2个不同重表的字段
var fieldTableName = dialogArg.fieldTableName;//源字段的表当hasDifferSubField为true的时用作校验
var noCheck = dialogArg.noCheck==null?false:dialogArg.noCheck;//是否不需要做校验
var subTableName = dialogArg.subTableName;//只留下的重复表表名
var extendSubDep = dialogArg.extendSubDep==null?false:dialogArg.extendSubDep;
var notAllowNull = dialogArg.notAllowNull==null?false:dialogArg.notAllowNull;
var fieldPrex = dialogArg.fieldPrex==null?"":dialogArg.fieldPrex;
var oFormId = dialogArg.otherformId == null ? 0 : dialogArg.otherformId;
var operationType = dialogArg.operationType == null ? "" : dialogArg.operationType;
var tabindex = dialogArg.tabindex == null ? 0 : dialogArg.tabindex;
var allowSubFieldAloneUse4A = dialogArg.allowSubFieldAloneUse4A == null ? allowSubFieldAloneUse : dialogArg.allowSubFieldAloneUse4A;//a表是否需要校验重复项字段是否能单独使用
var allowSubFieldAloneUse4B = dialogArg.allowSubFieldAloneUse4B == null ? allowSubFieldAloneUse : dialogArg.allowSubFieldAloneUse4B;//b表是否需要校验重复项字段是否能单独使用
var queryOrReportId = dialogArg.queryOrReportId?dialogArg.queryOrReportId:"";//查询与统计的用户输入校验用
var allowSubMethod = dialogArg.allowSubMethod==null?true:dialogArg.allowSubMethod;//字段高级权限,重复表字段进来不显示重复表的6个函数。
var forceCheck = dialogArg.forceCheck;//强制校验
var subField = dialogArg.subField;//重复表关键字
var targetbillSet = dialogArg.targetbillSet;//自动更新单据间验证
var isNotOrgli = dialogArg.isNotOrgli;//是否显示组织机构选项卡
var isAutoupdate = dialogArg.isAutoupdate;//自动更新模块
var qsType = dialogArg.qsType;
var isMaster = dialogArg.isMaster;//是否主表字段
var notNeedFunction = dialogArg.notNeedFunction?dialogArg.notNeedFunction:"";//不需要的函数，参数为函数的Id
var fieldType = dialogArg.fieldType;
var actionType = dialogArg.actionType;
var functionType = dialogArg.functionType;
var selectedFieldName = dialogArg.selectedFieldName;
var selectedFieldDisplay = dialogArg.selectedFieldDisplay;
var isAdvanced = dialogArg.isAdvanced;
var isMaster4Advanced = dialogArg.isMaster4Advanced;
$().ready(function() {
	init();
	$("#formulaForm").click(savePosition);
});
function savePosition(e){
	if(e != null && e.target != null){
        var targetId = $(e.target).attr("id");
        if ("description" != targetId && "searchValue1" != targetId && "searchValue" != targetId && "searchValue2" != targetId && "serachbtn1" != targetId && "btnreset1" != targetId) {
            formulaAreaPos = getTextAreaPosition($("#formulaStr")[0]);//记录光标位置
            //IE7中需要在表单获取焦点后手动将光标移动到最后，IE7默认光标在最前面。
            //setPositionAtEndInIE7($("#formulaStr")[0]);
        }
	}
}

var options1;
var options2;

function searchPre(select, backSelect, options, val){
    if (!options) {
        options = backSelect.find("option");
    }
    search(select,options,val);
}

function search(target,options, value) {
    var leaveOptios = [];
    options.each(function(){
        var text = this.text;
        if (text && text.indexOf(value) != -1){
            leaveOptios[leaveOptios.length] = $(this).clone(true);
        }
    });
    $("option",target).each(function(){
        $(this).remove();
    });
    for (var i=0; i < leaveOptios.length; i++) {
        var o = leaveOptios[i];
        target.append(o);
    }
}

//初始化界面操作
function init(){
	//如果没有传入高级的URL，就隐藏掉高级普通切换设置功能
	if(advanceUrl==""||advanceUrl==undefined||advanceUrl==null){
	  //如果设置了自定义头HTML，则显示自定义的HTML
	  if (dialogArg.headHTML){
	    $("#modelSet").html("");
	    if (parseInt($.browser.version,10)==7){
		  $("#modelSet").append(dialogArg.headHTML.html());
	    } else {
		  $("#modelSet").append(dialogArg.headHTML);
	    }
	  } else {
		  $("#modelSet").remove();
		  $("#functionarea").height(355);
	  }
	}
	<c:if test="${isAdvanced ne true}">
	  $("[isAdvanced]").each(function(){
	    $(this).remove();
	  });
	</c:if>
	//$("#fieldSelect,#otherFieldSelect").find("[inputType='customcontrol']").remove();//复选框不参加公式
	//通过配置解决各种按钮页签在各种场景下的显示隐藏，而不是硬编码
	var objs = $("[formulaAttr]");
	for(var i=0;i<objs.length;i++){
		var obj = $(objs[i]);
		var formulaAttr = $.parseJSON("{"+obj.attr("formulaAttr")+"}");
		if(formulaAttr.componentType!=null&&formulaAttr.componentType.indexOf(componentType)<0){obj.remove();}			
		if(componentType==componentType_formula&&formulaAttr.formulaType!=null&&formulaAttr.formulaType.indexOf(formulaType)<0){obj.remove();}//公式组件	
		if(componentType==componentType_condition&&formulaAttr.conditionType!=null&&formulaAttr.conditionType.indexOf(conditionType)<0){obj.remove();}//条件组件
	}
	if(conditionType == "conditionType_BizCheck"){
		$("#tabs_body").height(212);
		$("#fieldSelect").height(180);
	}
	if(isNotOrgli){
		$("#org_li","#tabs_head").remove();
	}
	if(filterFields){$("#fieldSelect").find("option[value='"+filterFields+"']").remove();}	//过滤掉自身的字段，避免嵌套循环
	$("#fieldSelect,#otherFieldSelect").find("[inputType='outwrite'][formatType='mapmarked']").remove();//外部写入-地图标注字段不参与任何计算和条件
	if(componentType==componentType_condition){
		$("#fieldSelect,#otherFieldSelect").find("[fieldType='LONGTEXT']").remove();//大文本不能参与条件
	    //移除重复项字段
		if (!allowSubFieldAloneUse4A) {
		  $("#fieldSelect").find("[isSubField='true']").remove();
		}
		if (!allowSubFieldAloneUse4B) {
		  $("#otherFieldSelect").find("[isSubField='true']").remove();
		}
		if(userVar!=null){//用户查询条件里,系统变量不能选择流程状态类，只保留系统数据域的前三个		
			$("#systemSelect option:gt(2)").remove();
			//$("#notButton").css("display","none");
		}
		if (operationType == "relationform") {//关联表单
		    if ("${otherForm.formType}" != "1") {//非流程表单
		        $("#systemSelect option:gt(2)").remove();
		    } else {//流程表单，屏蔽【流程状态】，只能关联已结束流程
		        $("#systemSelect option[value='finishedflag']").remove();
		    }
		}
		$("#fieldSelect,#otherFieldSelect").find("[inputType='linenumber']").remove();//重复项序号不参加公式,各类条件设置
		if (subTableName){
	      deleteOtherTable(subTableName);
	      if(subTableName.indexOf("formson") !== -1){
	        $("#existsButton").remove();
	        $("#allButton").remove();
	        $("#descriptiondiv").remove();
	      }
	    } else{
	      if (operationType == "relationform") {
	        if (fieldTableName&&fieldTableName.indexOf("formson") !== -1) {
              $("#fieldSelect").find("[tableName !='" + fieldTableName + "'][tableName^='formson']").remove();
            }
		    if (fieldTableName&&fieldTableName.indexOf("formmain") !== -1) {
			  $("#otherFieldSelect").find("[tableName^='formson']").remove();
		    }
	      } else {
			deleteSlave(fieldTableName);
	      }
	    }
		if(allowSubFieldAloneUse && !allowSubMethod){//子表进入字段高级权限设置时，不出现重复表函数
			$("#sumButton").remove();
			$("#averButton").remove();
			$("#maxButton").remove();
			$("#minButton").remove();
			$("#existsButton").remove();
			$("#allButton").remove();
		}
		//校验规则时，放开强制校验的复选框
		if(conditionType == conditionType_BizCheck){
			//校验规则过滤掉自定义控件
			//$("#fieldSelect,#otherFieldSelect").find("[inputType='customcontrol']").remove();
			//$("#fieldSelect,#otherFieldSelect").find("[inputType='customplan']").remove();
			$("#forceCheckId").show();
			if(forceCheck != "2" ){//2为非强制校验
				$("#forceCheck").prop("checked",true);
			}else{
				$("#forceCheck").prop("checked",false);
			}
		}
	}
	if(componentType==componentType_formula){//公式
		//$("#fieldSelect,#otherFieldSelect").find("[inputType='checkbox']").remove();//复选框不参加公式
		if(allowSubFieldAloneUse){//允许重复项单独使用就不允许使用重复项相关的函数
			$("#sumButton").remove();
			$("#averButton").remove();
			$("#maxButton").remove();
			$("#minButton").remove();
			$("#sumifButton").remove();
			$("#averifButton").remove();
			$("#maxifButton").remove();
			$("#minifButton").remove();
			$("#earliestButton").remove();
			$("#latestButton").remove();
			$("#rowButton").remove();
			//$("option[displayName^='serialNumber(']","#system_div").remove();//如果是重复项，公式不可以设置流水号。移除流水号选项
		}
		//数字类公式，移除非数字的字段
		if(formulaType==formulaType_number || formulaType==formulaType_auto_number || formulaType == formulaType_sub_summarize_number){
			$("#fieldSelect,#otherFieldSelect").find("[fieldType!='DECIMAL']").remove();
			if(formulaType==formulaType_auto_number){
				$("#dateSelect option").each(function (obj) {
					if ($(this).val() == 'date_time_systemTime') $(this).remove();
				});
			}else if(formulaType == formulaType_sub_summarize_number) {
				$("option[ismasterfield='true']","#fieldSelect").each(function (obj) {
					$(this).remove();
				});
			}
			if(!allowSubFieldAloneUse && checkSubFieldMethod) $("#preRowButton").remove();
		}
		//日期类公式，移除非日期的字段
		if(formulaType==formulaType_date || formulaType==formulaType_auto_date){
		    $("#fieldSelect,#otherFieldSelect").find("[inputType!='date'][fieldType!='TIMESTAMP']").remove();
			if(formulaType == formulaType_auto_date) {
				$("#dateSelect option").each(function (obj) {
					if ($(this).val() == 'date_dateTime_systemDateTime' || $(this).val() == 'date_time_systemTime' || $(this).val() == 'date_dec_thisYear' || $(this).val() == 'date_dec_thisMonth' || $(this).val() == 'date_dec_thisDay' || $(this).val() == 'date_dec_thisSeason') $(this).remove();
				});
			}
			$("#preRowButton").remove();
		    //deleteMain(fieldTableName);
		}
		////日期时间类公式，移除非日期时间的字段
		if(formulaType==formulaType_datetime || formulaType==formulaType_auto_datetime){
		    $("#fieldSelect,#otherFieldSelect").find("[inputType!='datetime'][fieldType!='DATETIME']").remove();
			if(formulaType == formulaType_auto_datetime) {
				$("#dateSelect option").each(function (obj) {
					if ($(this).val() != 'date_dateTime_systemDateTime') $(this).remove();
				});
			}
			$("#preRowButton").remove();
		    //deleteMain(fieldTableName);
		}
		if(formulaType==formulaType_varchar || formulaType==formulaType_auto_varchar){//字符串类公式
			$("#fieldSelect,#otherFieldSelect").find("[fieldType='LONGTEXT']").remove();//大文本不能参与字符串类公式
			//if(!allowSubFieldAloneUse){$("#fieldSelect,#otherFieldSelect").find("[isSubField='true']").remove();}//移除重复项字段--又要显示重复表字段了
			$("#orgSelect").find("option[displayName*='ID']").remove();//移除组织结构数据域中的ID变量
			$("#modelSetText").html("${ctp:i18n('form.field.formula.dynamic.normal.set')}");//字符串动态组合国际化
			$("#advancedSetText").html("${ctp:i18n('form.field.formula.dynamic.advance.set')}");//高级设置国际化
			$("#functionLine").remove();//去掉函数区域分割线
			if(dialogArg.flowTitle){//流程标题组合，保持和3.5一样，所以去掉这几个
			  $("#functionarea").html("");
				$("#systemSelect option:gt(2)").remove();//流程标题组合，只保留系统数据域的前三个
				if(!allowSubFieldAloneUse){$("#fieldSelect,#otherFieldSelect").find("[isSubField='true']").remove();}//add by chenxb bug OA-88382 流程标题设置时不能显示重复项 重复行取值功能改出的bug
			}
			if(!allowSubFieldAloneUse && checkSubFieldMethod) $("#preRowButton").remove();
		}
		if(formulaType==formulaType_auto_number || formulaType==formulaType_auto_date || formulaType==formulaType_auto_datetime) {
			$("option[issubfield='true']","#fieldSelect").each(function (obj) {
				var optionText = $(this).text();
				if(typeof subField != "undefined" && typeof optionText != "undefined" && optionText.indexOf("[")>-1 && optionText.indexOf("]")>-1 ) {
					if (optionText.substring(optionText.indexOf("[")+1,optionText.indexOf("]")) != subField) $(this).remove();
				}
			});
			if(qsType && qsType=='2') {
				$("option[issubfield='true']", "#flowData").each(function (obj) {
					var optionText = $(this).text();
					if (typeof subField != "undefined" && typeof optionText != "undefined" && optionText.indexOf("[") > -1 && optionText.indexOf("]") > -1) {
						if (optionText.substring(optionText.indexOf("[") + 1, optionText.indexOf("]")) != subField) $(this).remove();
					}
				});
			}
			if(actionType && actionType=="billOuter"){
				$("#flowData option").each(function (obj) {
					if ($(this).attr("fieldType") != fieldType) $(this).remove();
				});
			}
		}
		if(formulaType=="formula_archiveset"){//字符串类公式 预归档文档关键字设置
			$("#fieldSelect,#otherFieldSelect").find("[fieldType='LONGTEXT']").remove();//大文本不能参与字符串类公式
			if(!allowSubFieldAloneUse){$("#fieldSelect,#otherFieldSelect").find("[isSubField='true']").remove();}//移除重复项字段
			$("#modelSetText").html("${ctp:i18n('form.field.formula.dynamic.normal.set')}");//字符串动态组合国际化
			$("#advancedSetText").html("${ctp:i18n('form.field.formula.dynamic.advance.set')}");//高级设置国际化
			$("#functionLine").remove();//去掉函数区域分割线
			$("#functionarea").html("");
		}
		if(formulaType == formulaType_sub_number || formulaType == formulaType_sub_date || formulaType == formulaType_sub_datetime || formulaType == formulaType_sub_varchar){
			deleteOtherTable(fieldTableName);
			//$("#fieldSelect").find("[fieldType!='"+fieldType+"']").remove();
			$("option[issubfield='true']","#fieldSelect").each(function (obj) {
				if($(this).attr("fieldType") != "DATETIME" && $(this).attr("fieldType") != "TIMESTAMP" && $(this).attr("fieldType") != "DECIMAL") $(this).remove();
			});
		}
		//去除分割线
		if(formulaType == formulaType_sub_number || formulaType == formulaType_sub_date || formulaType == formulaType_sub_datetime || formulaType == formulaType_sub_varchar || formulaType == formulaType_sub_summarize_number){
			$("#splitLine").remove();
		}
		deleteSlave(fieldTableName);
		if(isAdvanced && isMaster4Advanced) $("#preRowButton").remove();
	}

	//清楚特定的不需要的函数
	if(notNeedFunction && notNeedFunction != null && notNeedFunction != ""){
		var functions = notNeedFunction.split(",");
		var len = functions.length;
		for(var i = 0;i<len;i++){
			$("#"+functions[i]).remove();
		}
	}
	
	//判断是否需要显示更多按钮
	if($(".function").length > 3){
	  var index = 0;
	  $(".function").each(function(){
	    if ($(this).children("div").length < 1){
	      $(this).remove();
	      return true;
	    }
	    if (index > 2){
	      $(this).addClass("morefunction");
	      $(this).hide();
	      $("#moreorlesstr").show();
	    }
	    if (index == 2){
	      $(this).after("<div id='moreorlesstr'><div style='text-align: right;width: 100%'><div id='morelable' class='font_size12 hand' style='width: 170px;line-height:30px;'>${ctp:i18n('common_more_label') }<span class='ico16 arrow_2_b'></span></div><div id='lesslable' class='font_size12 hand' style='width: 170px;line-height:30px;'>${ctp:i18n('form.formula.engin.less.label') }<span class='ico16 arrow_2_t'></span></div></div></div>")
	      $("#moreorlesstr").hide();
	    }
	    index++;
	  });
	}

	//查询统计处有用户变量选项卡
	if(userVar){
		for(var i=0;i<userVar.length;i++){
			$("#userSelect").append("<option displayName='["+userVar[i].name+"]'>"+userVar[i].name+"</option>");
		}
		if(userVarTitle){
		  $("#user_li a span").attr("title",userVarTitle);
		  $("#user_li a span").text(userVarTitle);
		}
	}else{$("#user_li").remove();}
	$("#tabs_head li:eq(" + tabindex + ")").attr("class", "current");//定位页签
	$("#tabs").tabCurrent($("#tabs_head li:eq(" + tabindex + ")").find("a").attr("tgt"));//定位页签
	$("#tabs_head li:last").find("a").attr("class","last_tab");//给最后一个页签配置结尾样式
    copySelect2Hidden("fieldSelect","fieldSelect_bak");
    copySelect2Hidden("otherFieldSelect","otherFieldSelect_bak");
	copySelect2Hidden("flowData","flowData_bak");
	$("body").attr("class","");//界面准备好后，一次性显示
	//回显已设置的条件公式
	setTimeout(function(){
		$("#formulaStr").focus();
		$("#formulaStr").text(formulaStr=="${ctp:i18n('form.formula.advance.hasset.laebl')}"?"":formulaStr);
		$("#description").text(formulaDes);
		oldFormulaStr = $("#formulaStr").val();
	},500);
	$("#advancedSet").click(function (){
		changeAdvancedSet();
	});
	$("#morelable").click(function(){
	  showOrHideMoreFunction(true);
	});
	$("#lesslable").click(function(){
	  showOrHideMoreFunction(false)
	}).hide();

	//表单数据域查询
    $("#serachbtn1").click(function(){
        var select = $("#fieldSelect");
        searchPre(select,$("#fieldSelect_bak"), options1,$("#searchValue1").val());
    });
    $("#searchValue1").keyup(function(event) {
        if (event.keyCode == 13) {
            var select = $("#fieldSelect");
            searchPre(select,$("#fieldSelect_bak"), options1,$("#searchValue1").val());
        }
    });
	//其他表单数据域查询
    $("#serachbtn").click(function(){
        var select = $("#otherFieldSelect");
        searchPre(select,$("#otherFieldSelect_bak"), options1,$("#searchValue").val());
    });
    $("#searchValue").keyup(function(event) {
        if (event.keyCode == 13) {
            var select = $("#otherFieldSelect");
            searchPre(select,$("#otherFieldSelect_bak"), options1,$("#searchValue").val());
        }
    });
	//当前单据值 自动更新设置目标单据时用
	$("#serachbtn2").click(function(){
		var select = $("#flowData");
		searchPre(select,$("#flowData_bak"), options1,$("#searchValue2").val());
	});
	$("#searchValue2").keyup(function(event) {
		if (event.keyCode == 13) {
			var select = $("#flowData");
			searchPre(select,$("#flowData_bak"), options1,$("#searchValue2").val());
		}
	});
	//非校验规则进入时，函数自定义显示在左边，要去掉其margin_l_5的class
	if($("#rowButton").html() == undefined){
		$("#designButton").removeClass("margin_l_5");
	}
	if($("#uniqueButton").html() == undefined){
		$("#preRowButton").removeClass("margin_l_5");
	}

	//自动更新时为每个页签添加单击事件，已控制重复行取值、重复表上一行函数的显示隐藏
	$("#tabs_head li").click(function () {
		if (formulaType == formulaType_auto_number || formulaType == formulaType_auto_date || formulaType == formulaType_auto_datetime) {
			if ($(this).attr("id") != "field_li") {
				$("#rowButton").hide();
				$("#designButton").removeClass("margin_l_5");
				$("#preRowButton").hide();
				$("#preRowButton").parent().hide();

				$("#sumifButton").hide();
				$("#averifButton").hide();
				$("#sumifButton").parent().hide();
				$("#maxifButton").hide();
				$("#minifButton").hide();
				$("#maxifButton").parent().hide();
			}else{
				$("#rowButton").show();
				if($("#rowButton").html() != undefined){
					$("#designButton").addClass("margin_l_5");
				}
				$("#preRowButton").show();
				$("#preRowButton").parent().show();

				$("#sumifButton").show();
				$("#averifButton").show();
				$("#sumifButton").parent().show();
				$("#maxifButton").show();
				$("#minifButton").show();
				$("#maxifButton").parent().show();
				showOrHideMoreFunction(false);
			}
		}
	});
	//自动更新时，如果默认显示的不是表单数据域页签，则重复行取值、重复表上一行函数隐藏
	if (formulaType == formulaType_auto_number || formulaType == formulaType_auto_date || formulaType == formulaType_auto_datetime) {
		var area = getSelectedArea();
		if (area.attr("id") != "field_li") {
			$("#rowButton").hide();
			$("#designButton").removeClass("margin_l_5");
			$("#preRowButton").hide();
			$("#preRowButton").parent().hide();

			$("#sumifButton").hide();
			$("#averifButton").hide();
			$("#sumifButton").parent().hide();
			$("#maxifButton").hide();
			$("#minifButton").hide();
			$("#maxifButton").parent().hide();
		}
	}
}

function copySelect2Hidden(oldId,newId) {
    var newObj = $("#"+oldId).clone(true);
    newObj.attr("id",newId);
    newObj.addClass("hidden");
    $("#bakarea").append(newObj);
}

//显示，隐藏更多函数按钮
function showOrHideMoreFunction(isShow){
  if (isShow){
    $(".morefunction").each(function(){
      $(this).show();
    });
    $("#morelable").hide();
    $("#lesslable").show();
    $("#functionarea").scrollTop(450);
  } else {
    $(".morefunction").each(function(){
      $(this).hide();
    });
    $("#morelable").show();
    $("#lesslable").hide();
  }
}

//执行各种动作
function doit(action){
	formulaAreaPos = getTextAreaPosition($("#formulaStr")[0]);//记录光标位置
	//IE7中需要在表单获取焦点后手动将光标移动到最后，IE7默认光标在最前面。
	//setPositionAtEndInIE7($("#formulaStr")[0]);
	if(typeof action=="string"){
		if(formulaType==formulaType_date||formulaType==formulaType_datetime||formulaType==formulaType_auto_date||formulaType==formulaType_auto_datetime){
			dateCal(action=="+"?"%2B":action);
		}else{
			setText(action);
		}
	}else if(typeof action=="function"){
		action();
	}
}

//删除不同表字段
function deleteOtherTable(fieldTableName){
  if (fieldTableName) {
    $("#fieldSelect,#otherFieldSelect").find("[tableName !='" + fieldTableName + "']").remove();
  }
}

//删除不同重复表字段
function deleteSlave(fieldTableName){
  if (fieldTableName && fieldTableName.indexOf("formson") !== -1) {
    $("#fieldSelect,#otherFieldSelect").find("[tableName !='" + fieldTableName + "'][tableName^='formson']").remove();
  }
}

//删除重复表字段
function deleteMain(fieldTableName){
  if (fieldTableName&&fieldTableName.indexOf("formmain") !== -1) {
    $("#fieldSelect,#otherFieldSelect").find("[tableName !='" + fieldTableName + "']").remove();
  }
}

//单击数据域的事件，暂无功能，预埋
function clickField(selectObj){}
//双击数据域的事件，主要用于向公式条件文本框添加选中的字符
function dblClickField(selectObj){
	var obj = $(selectObj).find("option:selected");
	var objStr = getFieldName(obj.attr("displayName"));
	if(objStr){setText(objStr);}
	formulaAreaPos = getTextAreaPosition($("#formulaStr")[0]);//记录光标位置
}
//返回选中的数据域
function getSelectedField(){
	 var area = $("#tabs_head").find("li.current");
	 var areaId = area.attr("id");
	 var areaStr = areaId.substring(0,areaId.indexOf("_li"));
	 if(areaStr == "currentflowdata"){
		 areaStr = "flowdata";
	 }
	 var fieldAreaId = areaStr+"_div";
	 var fieldArea = $("#"+fieldAreaId);
	 var selectedObj = $(fieldArea).find("option:selected");
	 return selectedObj; 
}
//返回选中的页签
function getSelectedArea(){
	return $("#tabs_head").find("li.current");
}
//返回显示的字段名称
function getFieldName(displayName){
	return displayName;
}
function checkValidate(formulaStr){
	var checkStr = [];
	for(var i=0;i<checkStr.length;i++){
		if(formulaStr.indexOf(checkStr[i])>=0){
			return checkStr[i];
		}
	}
	return "";
}


function checkcanCalField(formulaStr){
	var success = true;
	$("#cannotCalField option").each(function () {
		var notField = "{" + $(this).val() + "}";
		if(formulaStr.indexOf(notField) != -1){
			success = false;
		}
	});

	if(!success){
		var msg = {'width':450,'height':150,'title':"${ctp:i18n('form.formula.engin.formula.illegal.error')}",'msg':success};
		$.messageBox({
			'type' : 5,
			'imgType' : 1,
			'title' : "${ctp:i18n('form.formula.engin.systeminfo.label')}",
			'msg' : "${ctp:i18n('form.formula.engin.formula.illegal.cannotcal')}",
			'detail_fn':function(){
				$.alert("${ctp:i18n('form.formula.engin.formulafield.illegal.error')}");
			},
			ok_fn : function() {
			}
		});

		return false;
	}

	return true;
}



//点击OK方法后将公式条件写入父页面
function OK(){
	var checkResult="success";
	var description = $("#description").val();	
	var headHTML = $("#modelSet");
	var formulaStr = $.trim($("#formulaStr").val());//用户录入的公式字符串
	//添加长度校验
	//alert(description.length);
	/*   v5.6 sp1 新增要求描述不限制长度
	if(description != undefined && description.length > 1300){
		$.alert("${ctp:i18n('form.baseinfo.description.validatelength.error.label')}");
		return false;
	}else  
	if(formulaStr != undefined && formulaStr.length > 3000){
		$.alert("${ctp:i18n('form.baseinfo.formula.validatelength.error.label')}");
		return false;
	}*/
		formulaStr = formulaStr.replaceAll("\"","'");
	/*if(conditionType ===conditionType_BizCheck){//校验规则不满足提示已经调整，描述信息不做必填要求
	    if(formulaStr&&!description&&!subTableName){//在填写了公式的情况下再校验描述信息
	        $.alert("${ctp:i18n('form.formula.engin.description.mustwrite')}");
	        return false;
	    }
	}*/
	if (notAllowNull && !formulaStr){
	  if(componentType==componentType_condition){
	    	  $.alert("${ctp:i18n('form.formula.engin.formula.check.conditionnotallownoll')}");
	  } else {
	    	  $.alert("${ctp:i18n('form.formula.engin.formula.check.formulanotallownoll')}");
	  }
	  return false;
	}
	var checkStr = checkValidate(formulaStr);
	//OA-109970重复表中动态组合含特殊脚本，增加1行，特殊脚本丢失；再增加1行，弹出"123"的提示信息。
	//特殊需求，暂时不改动
	<%--if(formulaStr.indexOf("<script>")!=-1){--%>
		<%--$.alert("${ctp:i18n('form.data.formula.calc.error.label4')}");--%>
		<%--$(formulaStr).attr("value","");--%>
		<%--return false;--%>
	<%--}--%>

	if(!checkcanCalField(formulaStr)){
		return false;
	}
	if (dialogArg.procFun){
	  var procV = dialogArg.procFun($.trim(formulaStr),$.trim(description),dataArray,headHTML);
	  if (procV != true){
	    return false;
	  }
	}
	if(noCheck==false&&checkStr){$.alert("${ctp:i18n('form.formula.engin.illegalchar')}:"+checkStr);return;}
		
	var dataArray = "{\"data\":[{\"keyword\":\"if\",\"condition\":\"\",\"result\":\""+formulaStr+"\",\"sort\":0}]}";
	if(conditionType === conditionType_BizCheck){
		forceCheck = $("#forceCheck").attr("checked") == "checked"?"1":"2";
		var preFlag = /preRow\s*\([^()]*\)/;
		if(formulaStr.match(preFlag)) {
			var reg = /^.*all|exist\s*\(\s*[\s*\{\u4E00-\u9FA5\w\W\}\s*\>\<\=\s*]*preRow\s*\(.*$/;
			if(!reg.test(formulaStr)){
				$.alert("${ctp:i18n('form.formula.validate.preRow.error')}");
				return false;
			}
		}
	}
	if(formulaStr==null||formulaStr==""){callBackFunction("",$.trim(description),dataArray,headHTML,forceCheck);return true;}
	if(oldFormulaStr!=formulaStr){//表达式发生改变了后，才去校验，节约性能
		var conditionFormulaStr = /(<|>|=|like|not_like|include|in|isRole|isNotRole|unique|selfFunction)/;//条件组件需要有条件运算符,运算不能有条件运算符
		if(formulaStr&&componentType==componentType_condition&&formulaStr.search(conditionFormulaStr)<0){
			$.alert("${ctp:i18n('form.formula.engin.notcontain.conditionoperator.error')}:"+conditionFormulaStr);
			return false;
		}else if(formulaStr&&componentType==componentType_condition){
			if(!isAloneUse(formulaStr)){
				return false;
			}
		}
		if(formulaStr&&componentType==componentType_formula&&noCheck==false&&formulaStr.search(conditionFormulaStr)>0){
			//$.alert("${ctp:i18n('form.formula.engin.contain')}:"+conditionFormulaStr);
			//return false;
		}
		if(preExc(formulaStr,formId)==false){return false;}	//预执行校验结果不正确
		if(hasDifferSubField){//做是否含有不同重复项表字段的校验
			var formMgr = new formManager();
	        var value =  formMgr.hasDifferSubTable(0,formulaStr); 
	        if(value){
	            $.alert("${ctp:i18n('form.formula.engin.existdiff.slave.error')}");
	            return false;
	        }  	   
		}		
	}
	if(formulaStr && targetbillSet){
		var isCont = false;
		$("#flowData option").each(function (obj) {
			var displayName = $(this).attr("displayName");
			if(formulaStr.indexOf(displayName) > -1){
				isCont = true;
				return false;
			}
		});
		if(!isCont) {
			$.alert("${ctp:i18n('form.trigger.automatic.formula.include.must')}");
			return false;
		}
	}
	var isIncludeSub = false;
	if(isAutoupdate){
		if(isMaster && isMaster=="true") {
			isIncludeSub = isIncludeSubFun(formulaStr,"fieldSelect",isIncludeSub) ? true : isIncludeSubFun(formulaStr,"flowData",isIncludeSub);
		}
		if(formulaStr.indexOf("calcDateTime(") > -1 || formulaStr.indexOf("calcDate(") > -1 || formulaStr.indexOf("calcDate") == 0){
			isIncludeSub = true;
		}
	}
	var returnVal = callBackFunction($.trim(formulaStr),$.trim(description),dataArray,headHTML,forceCheck,isIncludeSub);
	if(returnVal==false){return false;}
    return true;
}
//预执行校验
function preExc(formulaStr,formId){
	var returnValue = "success";
		var fType = componentType==componentType_condition?conditionType:formulaType;//获取当前组件正在设置的为何种类型的公式条件
		if(componentType==componentType_condition && noCheck==false){//条件预执行
			returnValue = fMgr.preExcCondition(formulaStr,fType,formId,oFormId,allowSubFieldAloneUse,checkSubFieldMethod,queryOrReportId);
		}else if(componentType==componentType_formula && noCheck==false){//公式预执行
			//保证客户只输入了一个不存在的变量时不会被忽略掉	
			if(formulaType==formulaType_date||formulaType==formulaType_datetime){
				if(formulaStr.indexOf("{")==-1&&formulaStr.indexOf("[")){
					$.alert('公式设置出错!'+formulaStr);return false;
				}				
			}else if(formulaType==formulaType_number){
				formulaStr = formulaStr;
			}else{
				formulaStr = formulaStr;	
			}
			returnValue = fMgr.preExcFormula(formulaStr,fType,formId,oFormId,allowSubFieldAloneUse,checkSubFieldMethod);
		}
	if(returnValue!="success"){//预执行校验结果不正确
		var msg = {'width':450,'height':150,'title':"${ctp:i18n('form.formula.engin.formula.illegal.error')}",'msg':returnValue};		
	    $.messageBox({
		    'type' : 5,
		    'imgType' : 1,
		    'title' : "${ctp:i18n('form.formula.engin.systeminfo.label')}",
		    'msg' : "${ctp:i18n('form.formula.engin.formulaset.illegal.error')}",
		    'detail_fn':function(){
	    		$.alert(returnValue);
	  		},
		    ok_fn : function() {
		    }
		});
		
		return false;
	}	
	return true;
}
//判断校验规则的函数自定义是否为单独使用
function isAloneUse(formulaStr){
	var reg = /selfFunction\s*\([^()]*\)/;
	if(formulaStr.match(reg)){
		formulaStr = formulaStr.replace(reg,"");
		if(formulaStr.trim().length > 0){
			$.alert("${ctp:i18n('form.formula.engin.customfunction.aloneuse.label')}");
			return false;
		}
	}

	return true;
}

//切换高级设置
function changeAdvancedSet(){
	try{
		var dialogType = 1;
		if(conditionType == "conditionType_BizCheck"){
			dialogType = 2;
		}
		var text = $("#formulaStr").val();
		if(text != ""){
			var dialog = $.confirm({
			    'msg': '${ctp:i18n("form.baseinfo.formula.change.error.label")}',
			    ok_fn: function () { 
					parentWin.window.changeDialog(parentWin.window.current_dialog,advanceUrl,dialogType);
				},
				cancel_fn:function(){$("#normalSet").attr("checked",true);dialog.close();}
			});
		}else{
			parentWin.window.changeDialog(parentWin.window.current_dialog,advanceUrl,dialogType);
		}
	}catch(e){
		
	}
}

function isIncludeSubFun(formulaStr,selId,isIncludeSub){
	$("#"+selId+" option[issubfield=true]").each(function (obj) {
		var displayName = $(this).attr("displayName");
		if (formulaStr.indexOf(displayName) > -1) {
			isIncludeSub = true;
			return false;
		}
	});
	return isIncludeSub;
}
</script>