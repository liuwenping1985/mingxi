<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.ctp.form.modules.engin.formula.FormulaEnums,com.seeyon.ctp.form.util.*"%>
<%@ include file="/WEB-INF/jsp/ctp/form/dee/design/deeDesign.js.jsp" %>
<script type="text/javascript" src="${path}/common/form/design/designBaseInfo.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
//高级设置url
var advanceUrl = _ctxPath + "/form/fieldDesign.do?method=formulaAdvanceSet";
//定义当前窗口全局变量，主要是普通设置和高级设置切换窗口用到
var current_dialog;
//定义一个全局变量保存上一次联动id,用于方法designLinkageField
var designLinkId;
//所有的字段数量
var fieldListSize = ${fieldListSize};
//表单的实际数据库存储表
var tables = ${tables};
//数据库对每个表text类型大小是否有限制
var textLimit = ${textLimit};
//是否产生表单数据
var isHasData = ${isHasData};
var subTableSize = ${subTableSize};
//该变量用于记录实时的字段类型记录。目前最主要的用处在于“垮页面访问字段类型的时候”，如高级设置页面弹出的计算页面要根据基础设置页面设置的字段类型进行表单域显示过滤。
var currentfieldTypeArray;
var currentInputTypeArray;

// seework业务枚举id值（为字符串"noSeeworkBusinessEnum"，表示无此变量；为具体id值时，表示是seework的业务枚举id）
var seeworkBusinessEnumId = "${seeworkBusinessEnumId}";
var isSeework = "${isSeeworkBusinessEnum}";
//定义js方法需要的变量值
var _isNewForm = ${formBean.newForm};
var _isPhoneForm = ${formBean.phoneForm};
var _formType = ${formBean.formType};
//判断是否有高级office
var _advanceOffice = ${advanceOffice};

//表单控件类型集合
var inputTypeObj = {};
//录入类型对应所有关联属性对象
var inputTypeRelObj = {};
//表单控件、字段类型弱关联属性集合
var fieldInputRelationAttrArray;
var fieldTypeAry;
var _imageEnumFormat = '<%=Enums.FormatType.FORMAT4IMAGEENUMOPTION.getText()%>';
var _imageEnumFormat4Formula = '<%=Enums.FormatType.FORMAT4IMAGEENUMFORMULAOPTION.getText()%>';
var style = "${formBean.phoneForm ? "4" : "1"}";
var hasLoaded = false;//基础设置是否加在完全，防止没有加载完就切换页签，导致基础设置里面的信息丢失

$(document).ready(function() {
	/* var result = $("#formTable").html();
	result = result.replace(/td>\s+<td/g, 'td><td');
	$("#formTable").html(result); */
    $("#layout").offset({top:0});
	//循环获取后台的录入类型集合对象，对所有的录入类型，字段类型、相关联属性进行初始化
	<c:forEach items="${inputTypeMap}" var="group">
		<c:forEach items="${group.value}" var="inputType">
			<c:if test="${!(formBean.formType==1 && (inputType.key=='outwrite' || inputType.key=='externalwrite-ahead'))}">
				fieldTypeAry = new Array();
				<c:forEach items="${inputType.fieldType}" var="fieldType">
					fieldTypeAry["${fieldType.key}"] = "${fieldType.text}";
				</c:forEach>
				fieldInputRelationAttrArray = new Array();
				<c:forEach items="${inputType.fieldRelationObjArray}" var="fieldRelObj">
					var fieldInputObj = new fieldInputRelationAttr("${fieldRelObj.fieldLength}",'${fieldRelObj.formatType.text}',"${fieldRelObj.isFormula.key}","${fieldRelObj.isCanInput.key}");
					fieldInputRelationAttrArray["${fieldRelObj.fieldType.key}"] = fieldInputObj;
				</c:forEach>
				inputTypeObj["${inputType.key}"] = fieldTypeAry;
				inputTypeRelObj["${inputType.key}"] = fieldInputRelationAttrArray;
			</c:if>	
		</c:forEach>
	</c:forEach>
    if(fieldListSize > ${initRowsCount}) {
        addProcessBar();
        var fdManager = new formFieldDesignManager();
        fdManager.getBaseInfoHtml({success: function (result) {
            $("#formTbody").append(result);
            initByFieldPage();
            closeProcessBar();
        }});
    }else{
        initByFieldPage();
        closeProcessBar();
    }
	//页面样式初始化
	if(!${formBean.newForm}){
        <c:if test="${canCreate}">
        new ShowBottom({'show':['otherFormSave','doSaveAll','doReturn'],'module':'field'},$("#baseInfoForm"));
        </c:if>
        <c:if test="${!canCreate}">
        new ShowBottom({'show':['doSaveAll','doReturn'],'module':'field'},$("#baseInfoForm"));
        </c:if>
        new ShowTop({'current':'field','canClick':'true','module':'field'},$("#baseInfoForm"));
    }else{
    	new ShowTop({'current':'field','canClick':'false','module':'field'},$("#baseInfoForm"));
   		new ShowBottom({'show':['nextStep'],'source':{'nextStep':'../form/authDesign.do?method=formDesignAuth'},'module':'field'},$("#baseInfoForm"));
    }
	hasLoaded = true;
	viewDesignForm("${formBean.id}");
});

function addProcessBar() {
    getCtpTop().processBar1 =  getCtpTop().$.progressBar({text: $.i18n('form.baseinfo.progressbar.info')});
}

function closeProcessBar() {
    if(getCtpTop().processBar) {
        getCtpTop().processBar.close();
    }
    if(getCtpTop().processBar1) {
        getCtpTop().processBar1.close();
    }
}

function initByFieldPage(){
    window.setTimeout(function(){
        contentObj.origHeight = $("#south").height();
    },500);
    if($.browser.msie && ($.browser.version=="7.0")){
        $("#formContent").css("height","90%");
        $("#viewFrame").css("height","90%");
    }
    //初始化数据唯一，如果唯一标识只选择了一个，而且这个数据唯一没有勾选，就需要勾选上。
    initDataUnique();
    //初始化toolbar中的单击事件
    initBtnClick();
    //初始化应用分类
    if(${formBean.categoryId} == 0 || ${formBean.categoryId} == null || ${formBean.categoryId} == "") {
        $("#categoryId").find("option[index=0]").attr("selected",true);
    }else{
        $("#categoryId").val('${formBean.categoryId}');
    }
    init();
    //在ie9下面，表单制作的时候错行啦。去除td之间的空格
    formatTable();
    //固定表头，位置一定要放到最下面，防止中间过程有重新计算表格的地方,字段必须是300个字段以内，如果是ie8,ie7,ie6就必须是100个以内
    if(${formBean.formType} != 4){
        initFixHead();
        var bro = $.browser;
        //ie6,7,8只能在100以内的表单可以用使用固定表头，ie9,ie10等200以内,非ie400字段以内
        if(bro.msie && ((bro.version == "7.0" || bro.version == "6.0") && fieldListSize < 100)
                || ((bro.version == "8.0" || bro.version == "9.0" || bro.version == "10.0" || bro.version == "11.0") && fieldListSize < 201)
                || (!bro.msie && fieldListSize < 401)){
            //固定表头
            $("#formTable").FixedHead({ tableLayout: "fixed" });
        }
    }
};

/**
 * 回调函数，页面加载完毕以后调用
 */
function init(){
	//初始化dee方法
	initDeeDesign();
	//该dee的方法也需要放到后台-性能优化
	<c:forEach items="${formBean.allFieldBeans}" var="field" varStatus="status">
		var index = "${status.index}";
		$("#formatType"+index).val("${field.formatType}");
		$("#formatType"+index).find("option[value='${field.formatType}']").attr("selected",true);
		if("${field.inputType}" == "relation"){
			viewAllRelationDisOrHide(index,"${field.formRelation.toRelationAttrType}");
		}
	</c:forEach>
	//该方法需要放到后台--dee
	if("${isHasDeeField}" == true || "${isHasDeeField}" == "true"){
		initDeeTaskRelation();
	}
}

/*
 * 检查是否当前对象被引用
 */
function checkInputType2Change(index){
	var result = true;
	var oType = $("#inputType"+index).attr("oldInputType");
	if(oType == "outwrite"|| oType == "relationform" || oType == "project" || oType == "member" || oType == "department" || oType == "account" || oType == "accountAndDepartment"|| oType=="select"
			|| oType == "mapmarked" || oType == "maplocate" || oType == "mapphoto" || oType == "relation" || oType == "exchangetask"){//xuker add || oType == "account" 20160328 || oType == "accountAndDepartment" 20160405
		<c:forEach items="${formBean.allFieldBeans}" var="field" varStatus="status">
			var i = "${status.index}";
			if(i != index){
				if($("#fieldName"+index).attr("value")==$("#refInputName"+i).val() && ($("#inputType"+i).val() == "relation" || $("#inputType"+i).val()=="externalwrite-ahead")){
					result = false;
					$("#inputType"+index).val(oType);
					$("#fieldType"+index).val($("#fieldType"+index).attr("oldFieldType"));
				}
			}
		</c:forEach>
	}
	return result;
}

/*
 * 实时更新当前字段类型数组
 */
function updateCurrentFieldType(){
	currentfieldTypeArray = [];
	<c:forEach items="${formBean.allFieldBeans}" var="field" varStatus="status">
		var i = "${status.index}";
		currentfieldTypeArray[i] = $("#fieldType"+i).val();
	</c:forEach>	
}
/*
 * 更新当前的录入类型
 */
function updateCurrentInputType(){
    currentInputTypeArray = [];
    <c:forEach items="${formBean.allFieldBeans}" var="field" varStatus="status">
		var i = "${status.index}";
        currentInputTypeArray[i] = $("#inputType"+i).val();
    </c:forEach>	
}

/*
 * 根据字段名称获取录入类型
 */
function getInputTypeByFieldName(fieldName){
	<c:forEach items="${formBean.allFieldBeans}" var="field" varStatus="status">
		var index = "${status.index}";
		if($("#fieldName"+index).attr("value")==fieldName){
			return $("#inputType"+index).val();
		}
	</c:forEach>
}

/*
 * 该方法用于判断某个字段是否参与了数字，日期，日期时间字段的计算。
 */
function isInForumula(index){
	var obj = new Array();
	obj.inFormula = false;
	obj.index = -1;
	var inFieldDisplay = "{"+$("#fieldName"+index).attr("display")+"}";
	var inFieldType = $("#fieldType"+index).attr("oldFieldType");
	<c:forEach items="${formBean.allFieldBeans}" var="field" varStatus="status">
		var i = "${status.index}";
		if(i != index){
			var currentFormula = $("#formulaData"+i).val();
			var currentFieldType =  $("#fieldType"+i).val();
			//如果需要判断的是数字类型：1.是否参与了数字类型的计算式2.是否参与了文本类型的动态组合
			//如果需要判断的是日期或者日期时间型：1.是否参与了数字类型的日期函数计算式2.是否参与了日期或者日期时间的计算式
			if((inFieldType === "DECIMAL" || inFieldType === "VARCHAR") &&  (currentFieldType === "DECIMAL" || currentFieldType === "VARCHAR") && currentFormula.indexOf(inFieldDisplay) != -1){
				obj.inFormula = true;
				obj.index = i;
			}else if((inFieldType === "TIMESTAMP" || inFieldType === "DATETIME")
					 && (currentFieldType === "DECIMAL" || currentFieldType === "DATETIME" || currentFieldType === "TIMESTAMP")
					 && currentFormula.indexOf(inFieldDisplay) != -1){
				obj.inFormula = true;
				obj.index = i;
			}
		}
	</c:forEach>
	return obj;
}

/*
 * 改变formatType确认事件
 */
function confirmChangeFormatType(index){
	//数字类型的字段，如果没有设置日期时间差函数的情况下，是不允许设置天等格式的。
	if($("#fieldType"+index).val() == "DECIMAL" && ($("#formatType"+index).val() == "<%=FormConstant.Day%>"
			|| $("#formatType"+index).val() == "<%=FormConstant.DateTime%>" 
			|| $("#formatType"+index).val() == "<%=FormConstant.WorkDay%>"
			|| $("#formatType"+index).val() == "<%=FormConstant.WorkDateTime%>")){
		var formulaStr = $("#formulaData"+index).val();
		if($.trim(formulaStr) == ""){
			//$.alert("${ctp:i18n_1('form.baseinfo.formatset.date.must.error.label','"+$("#formatType"+index).find("option:selected").text()+"')}");
			$.alert($.i18n('form.baseinfo.formatset.date.must.error.label',$("#formatType"+index).find("option:selected").text()));
			$("#formatType"+index).val("");
			return;
		}else{
	        var _dataObj = $.parseJSON(formulaStr);
	        if(_dataObj.data.length > 0 && $.trim(_dataObj.data[0].result) == ""){
	            $.alert($.i18n('form.baseinfo.formatset.date.must.error.label',$("#formatType"+index).find("option:selected").text()));
	            $("#formatType"+index).val("");
	            return;
	        }
		}
		
	}else if(false && $("#fieldType"+index).val() == "DECIMAL" && ($("#formatType"+index).val() == "<%=FormConstant.ThousandTag%>"
		|| $("#formatType"+index).val() == "<%=FormConstant.HundredTag%>")){
		var formulaStr = $("#formulaData"+index).val();
		if(formulaStr.indexOf("differDate") > -1){
			var display = $("#formatType"+index).val() == "" ? $.i18n('form.baseinfo.hasdate.setformat.value.null') : $("#formatType"+index).find("option:selected").text();
			//$.alert("${ctp:i18n_1('form.baseinfo.hasdate.setformat.error.label','"+display+"')}");
			$.alert($.i18n('form.baseinfo.hasdate.setformat.error.label',display));
			setDecimalFormat(formulaStr,index,$("#digitNum"+index).val());
			return;
		}
	}
	if($("#inputType"+index).val() == "outwrite"){
	    if(isHasData && $("#formatType"+index).attr("oldFormatType") && $("#formatType"+index).val()!=$("#formatType"+index).attr("oldFormatType")){
	        $("#formatType"+index).val($("#formatType"+index).attr("oldFormatType"));
	        $.alert($.i18n('form.base.dataform.outwrite.format.error.label'));
	        return;
	    }
	    //是否参与校验规则判断
	    if(isInCheckRule(index)){
	        $("#formatType"+index).val($("#formatType"+index).attr("oldFormatType"));
	        //该字段参与了校验规则，请先解除校验规则！
	        $.alert($.i18n('form.base.field.isincheckrule.error.label'));
	        return;
	     }
	    //对数字类型，日期日期时间类型参与计算进行判断。
	    var returnObj = isInForumula(index);
	    if(returnObj.inFormula){
	        $("#formatType"+index).val($("#formatType"+index).attr("oldFormatType"));
	        $.alert($.i18n('form.base.field.inputType.informula.error.label',$("#fieldName"+returnObj.index).attr("display")));
	        return;
	    }
	    //判断是否已经设置了唯一标识,同时又属于lable,text,radio,select,textarea
	    if(fieldHasUnique(index)){
	        var inputArray = "lable,text,radio,select,textarea";
	        if(inputArray.indexOf($("#formatType"+index).val()) == -1){
	            $("#formatType"+index).val($("#formatType"+index).attr("oldFormatType"));
	            //该字段在唯一标示中已经设置了，请先修改唯一标示!
	            $.alert($.i18n('form.base.uniqueFlag.check.error.label'));
	            return;
	        }
	    }
	    //检查是否被关联属性关联
	    if(!checkInputType2Change(index)){
	        $("#formatType"+index).val($("#formatType"+index).attr("oldFormatType"));
	        //当前对象已经被引用，请先取消引用后再改变此属性
	        $.alert($.i18n('form.base.relation.objct.isref.label'));
	        return;
	    }
	    var options = new Object();
	    options.fieldName = $("#fieldName"+index).attr("value");
	    options.fieldType = $("#fieldType"+index).val();
	    options.oldFieldType = $("#fieldType"+index).val();
	    options.fieldLength = $("#fieldLength"+index).val();
	    options.digitNum = $("#digitNum"+index).val();
	    options.inputType = $("#formatType"+index).val() == 'flowTitle'?"text":$("#formatType"+index).val();
	    options.oldInputType = $("#formatType"+index).attr("oldFormatType") ?$("#formatType"+index).attr("oldFormatType"):"text";
	  //对基础设置进行校验,通过ajax判断是否已经产生数据等判断
	    var returnStr = vlidateFormFieldChange(options);
	    if(returnStr.value  != "1" && returnStr.value != "-7"){
	        $.alert(returnStr.error);
	        $("#formatType"+index).val($("#formatType"+index).attr("oldFormatType"));
	        return;
	    }else if(returnStr == "-7"){
	        var confirm = $.confirm({
	            'msg': $.i18n('form.baseinfo.operate.advacecondition.error.label'),//该字段参与了操作权限的高级设置条件计算式！该操作可能导致计算式失效！
	            ok_fn: function () {
	                confirm.close();
	            },
	            cancel_fn:function(){
	                $("#formatType"+index).val($("#formatType"+index).attr("oldFormatType"));
	                confirm.close();
	            }
	        });
	    }
	}
	if($("#formatType"+index).val() == "select"){
	    bindOutWriterEnum(index);
	    $("#formatEnum"+index).show();
	}else{
	    $("#formatEnum"+index).hide();
	    $("#formatEnum"+index).val("");
	    $("#formatEnumLevel"+index).hide();
        clearEnumValue(index)
	}
    if($("#formatType"+index).val() == "urlPage"){
        var options = getValidateFieldOptions(index);
        options.fieldName = $("#fieldName"+index).attr("value");
        options.formatType = "urlPage";
        var returnStr = vlidateFormFieldChange(options);
        if(returnStr.value  != "1" && returnStr.value == "-17"){
            $.alert(returnStr.error);
            $("#formatType"+index).val("");
            return ;
        }
        //对计算式相关信息进行置空
        $("#formula"+index).hide();
        $("#advance"+index).hide();
        $("#formulaData"+index).val("");
        $("#formula"+index).attr("isAdvance","0");
        $("#formula"+index).val("");
    }else{
        if($("#inputType"+index).val() == "flowdealoption" 
            || $("#inputType"+index).val() == "outwrite" 
            || $("#inputType"+index).val() == "externalwrite-ahead" 
            || (($("#inputType"+index).val() == "select" || $("#inputType"+index).val() == "radio") && $("#selectBindInput"+index).attr("enumType") == 4 && $("#fieldType"+index).val() == "VARCHAR")){
            $("#formula"+index).hide();
        }else{
            $("#formula"+index).show();
        }
    }
	//更新后台缓存editform
	var param = getUpdateFormFieldParam(index);
	var fdManager = new formFieldDesignManager();
	fdManager.updateFormFieldChange(param);
}

function clearEnumValue(index){
    $("#formatEnum"+index).val("");
    $("#bindSetAttr"+index).attr("formatEnumId","");
    $("#bindSetAttr"+index).attr("formatEnumIsFinalChild","");
    $("#bindSetAttr"+index).attr("formatEnumLevel","");
    $("#bindSetAttr"+index).attr("imageEnumFormat","");
}

/*
 * 对所有表的字段的总长度进行校验
 */
function validateTableTotalLength(){
	var maxNumber = textLimit - 3;
	var isSuccess = true;
	if(textLimit != -1){
		var tablesArray = new Array();
		var maxNumberArray = new Array();
		var tableLength = tables.length;
		for(var j = 0 ; j < tableLength;j++){
			tablesArray[tables[j]] = 0;
			maxNumberArray[tables[j]] = maxNumber;
		}
		<c:forEach items="${formBean.allFieldBeans}" var="field" varStatus="status">
			var k = "${status.index}";
			var currentNumbers = 0;
			var minuNumber = 0;
			var tableName = $("#fieldName"+k).attr("tableName");
			var fieldType = $("#fieldType"+k).val();
			if(fieldType != "LONGTEXT"){
				if(fieldType === "VARCHAR"){
					minuNumber = 2;
					if(parseInt($("#fieldLength"+k).val()) < 256){
						currentNumbers = currentNumbers + parseInt($("#fieldLength"+k).val()) + 2;
					}
				}else if(fieldType === "TIMESTAMP"){
					minuNumber = 3;
				}else if(fieldType === "DATETIME"){
					minuNumber = 8;
				}else if(fieldType === "DECIMAL"){
					minuNumber = 4;
				}
			}
			tablesArray[tableName] += currentNumbers;
			maxNumberArray[tableName] -= minuNumber;
		</c:forEach>
		var compareMax = 0;
		for(var m = 0 ; m < tableLength;m++){
			//主表和从表都要去掉固定字段的长度
			if(m == 0){
				compareMax = parseInt((maxNumberArray[tables[m]] - 88)/3);
			}else{
				compareMax =  parseInt((maxNumberArray[tables[m]] - 20)/3);
			}
			if(tablesArray[tables[m]] > parseInt(compareMax)){
				if(m==0){
					//主表的字段总长度超出了数据库的限制,超出大小为[{0}]!请调整各个字段的字段长度!
					//$.alert("${ctp:i18n_1('form.baseinfo.totalLength.toobig.error.label','"+parseInt(tablesArray[tables[m]] - compareMax)+"')}");
					$.alert($.i18n('form.baseinfo.totalLength.toobig.error.label',parseInt(tablesArray[tables[m]] - compareMax)));
				}else{
					//第{0}个重复表的字段总长度超出了数据库的限制,超出大小为[{1}]!请调整各个字段的字段长度!
					//$.alert("${ctp:i18n_2('form.baseinfo.totalLength.slavetoobig.error.label','"+parseInt(m+1)+"','"+parseInt(tablesArray[tables[m]] - compareMax)+"')}");
					$.alert($.i18n('form.baseinfo.totalLength.slavetoobig.error.label',parseInt(m+1),parseInt(tablesArray[tables[m]] - compareMax)));
				}
				isSuccess = false;
				return false;
			}
		}
	}
	return isSuccess;
}

/*
 * 人员控件属性
 */
function getMemberOptions(refVal){
	var memberOptions='<option value=""></option>';
	<c:forEach items="${viewAttrValueList}" var="viewAttrVal">
		if(!("1" == "${productId}" && "account" == "${viewAttrVal.key}")){
			if(refVal && refVal == "${viewAttrVal.key}"){
				memberOptions += '<option fieldType="${viewAttrVal.fieldType}" value="${viewAttrVal.key}" title="${viewAttrVal.text}" selected>${viewAttrVal.text}</option>';
			}else{
				memberOptions += '<option fieldType="${viewAttrVal.fieldType}" value="${viewAttrVal.key}" title="${viewAttrVal.text}">${viewAttrVal.text}</option>';
			}
		}
	</c:forEach>
	return memberOptions;
}
/*
 * 部门控件属性
 */
function getDepartmentOptions(refVal){
	var departmentOptions='<option value=""></option>';
	<c:forEach items="${departmentViewAttrList}" var="viewAttrVal">
		if(refVal && refVal == "${viewAttrVal.key}"){
			departmentOptions += '<option fieldLength="${viewAttrVal.fieldLength}" fieldType="${viewAttrVal.fieldType}" value="${viewAttrVal.key}" title="${viewAttrVal.text}" selected>${viewAttrVal.text}</option>';
		}else{
			departmentOptions += '<option fieldLength="${viewAttrVal.fieldLength}" fieldType="${viewAttrVal.fieldType}" title="${viewAttrVal.text}" value="${viewAttrVal.key}">${viewAttrVal.text}</option>';
		}
	</c:forEach>
	return departmentOptions;
}
/*
 * 单位控件属性 xuker add 20160328
 */
function getAccountOptions(refVal){
	var accounttOptions='<option value=""></option>';
	<c:forEach items="${accountViewAttrList}" var="viewAttrVal">
	if(refVal && refVal == "${viewAttrVal.key}"){
		accounttOptions += '<option fieldLength="${viewAttrVal.fieldLength}" fieldType="${viewAttrVal.fieldType}" value="${viewAttrVal.key}" title="${viewAttrVal.text}" selected>${viewAttrVal.text}</option>';
	}else{
		accounttOptions += '<option fieldLength="${viewAttrVal.fieldLength}" fieldType="${viewAttrVal.fieldType}" title="${viewAttrVal.text}" value="${viewAttrVal.key}">${viewAttrVal.text}</option>';
	}
	</c:forEach>
	return accounttOptions;
}

/*
 * 多单位多部门控件属性 xuker add 20160405
 */
function getAccountDepartmentOptions(refVal){
	var accounttOptions='<option value=""></option>';
	<c:forEach items="${accountDepartmentViewAttrList}" var="viewAttrVal">
	if(refVal && refVal == "${viewAttrVal.key}"){
		accounttOptions += '<option fieldLength="${viewAttrVal.fieldLength}" fieldType="${viewAttrVal.fieldType}" value="${viewAttrVal.key}" title="${viewAttrVal.text}" selected>${viewAttrVal.text}</option>';
	}else{
		accounttOptions += '<option fieldLength="${viewAttrVal.fieldLength}" fieldType="${viewAttrVal.fieldType}" title="${viewAttrVal.text}" value="${viewAttrVal.key}">${viewAttrVal.text}</option>';
	}
	</c:forEach>
	return accounttOptions;
}
/*
 * 地图控件属性
 */
function getMapOptions(relType,refVal){
	var mapOptions='<option value=""></option>';
	<c:forEach items="${mapViewAttrList}" var="viewAttrVal">
		if((relType == "mapmarked" && "${viewAttrVal.key}".indexOf("gps_date_") == -1) || relType != "mapmarked"){
			if(refVal && refVal == "${viewAttrVal.key}"){
				mapOptions += '<option fieldType="${viewAttrVal.fieldType}" value="${viewAttrVal.key}" title="${viewAttrVal.text}" selected>${viewAttrVal.text}</option>';
			}else{
				mapOptions += '<option fieldType="${viewAttrVal.fieldType}" value="${viewAttrVal.key}" title="${viewAttrVal.text}">${viewAttrVal.text}</option>';
			}
		}
	</c:forEach>
	return mapOptions;
}
/*
 * 关联项目属性
 */
function getProjectOptions(relType,refVal){
	var mapOptions='<option value=""></option>';
	<c:forEach items="${projectViewAttrList}" var="viewAttrVal">
		if(refVal && refVal == "${viewAttrVal.key}"){
			mapOptions += '<option fieldLength="${viewAttrVal.fieldLength}" fieldType="${viewAttrVal.fieldType}" value="${viewAttrVal.key}" title="${viewAttrVal.text}" selected>${viewAttrVal.text}</option>';
		}else{
			mapOptions += '<option fieldLength="${viewAttrVal.fieldLength}" fieldType="${viewAttrVal.fieldType}" value="${viewAttrVal.key}" title="${viewAttrVal.text}">${viewAttrVal.text}</option>';
		}
	</c:forEach>
	return mapOptions;
}

/*
 * 获得图片枚举显示格式
 */
function getImageEnumOptions(isHasFormula){
    if(isHasFormula){
        return '<%=Enums.FormatType.FORMAT4IMAGEENUMFORMULAOPTION.getText()%>';
    }else{
        return '<%=Enums.FormatType.FORMAT4IMAGEENUMOPTION.getText()%>';
    }
}
/*
 * 该字段被其他表单关联，不能修改，请重新设置！
 */
function isFieldToRelation(index){
	if(!_isNewForm){
		var fr = new formRelationManager();
		var isExist = fr.isExistFieldToRelation("${formBean.id}",$("#fieldName"+index).attr("value"));
		return isExist;
	}
	return false;
}
</script>