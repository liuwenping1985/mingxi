﻿﻿﻿<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.ctp.form.modules.engin.formula.FormulaEnums,com.seeyon.ctp.form.util.*"%>
<%@ include file="/WEB-INF/jsp/ctp/form/dee/design/deeDesign.js.jsp" %>
<script type="text/javascript" src="${path}/common/form/design/designBaseInfo.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
//高级设置url
var advanceUrl = _ctxPath + "/form/fieldDesign.do?method=formulaAdvanceSet";
var advanceCheckRuleUrl = _ctxPath + "/form/fieldDesign.do?method=advanceCheckRuleSet";
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
var formId='${formBean.id}';
//判断是否有高级office
var _advanceOffice = ${advanceOffice};

//每种控件支持的字段类型: inputType =>> fieldType
var inputTypeObj = {};
//字段类型map
var fieldTypeAry;
//录入类型对应所有关联属性对象
var inputTypeRelObj = {};
//表单控件、字段类型弱关联属性集合 key:fieldType;value:(字段长度、显示格式、计算公式，和是否可以录入长度)
var fieldInputRelationAttrArray;
var _imageEnumFormat = '<%=Enums.FormatType.FORMAT4IMAGEENUMOPTION.getText()%>';
var _imageEnumFormat4Formula = '<%=Enums.FormatType.FORMAT4IMAGEENUMFORMULAOPTION.getText()%>';
var style = "${formBean.phoneForm ? "4" : "1"}";
var subReference = "${subReference}";
var canSaveData = true;
var hasLoaded = false;//基础设置是否加在完全，防止没有加载完就切换页签，导致基础设置里面的信息丢失

$(document).ready(function() {
    $("#layout").css({top:0,position:"absolute",width:"100%"});
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
    if(fieldListSize > 101) {
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
        parent.ShowBottom({'show':['subRelation','otherFormSave','doSaveAll','doReturn'],'module':'field'},$("#baseInfoForm"));
        </c:if>
        <c:if test="${!canCreate}">
        parent.ShowBottom({'show':['subRelation','doSaveAll','doReturn'],'module':'field'},$("#baseInfoForm"));
        </c:if>
    }else{
        parent.ShowBottom({'show':['subRelation','nextStep'],'source':{'nextStep':'../form/authDesign.do?method=formDesignAuth'},'module':'field'},$("#baseInfoForm"));
    }
	hasLoaded = true;
	viewDesignForm("${formBean.id}");
	hideOnlineEditImg();
    //根据重复表间关系，设置计算公式列是否可编辑
	var relationsObj = $("#relations");
	if(relationsObj.val() != ""){
		resetFormula($.parseJSON(relationsObj.val()));
	}
	$(window).resize(function(){
		layoutDesignPage();//把这个页面布局方法移动到designBaseInfo.js中方便调试
	});
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
    //formatTable();
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

    <%if(!"".equals(com.seeyon.ctp.form.util.Enums.FormType.getEnumByKey(((com.seeyon.ctp.form.bean.FormBean)request.getAttribute("formBean")).getFormType()).getInitJS())){%>
    <jsp:include page='<%=com.seeyon.ctp.form.util.Enums.FormType.getEnumByKey(((com.seeyon.ctp.form.bean.FormBean)request.getAttribute("formBean")).getFormType()).getInitJS()%>'/>
    <%}%>
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
		var formatTypeObj = $("#formatType" + index);
		if("${field.inputType}" == "flowdealoption"){
		    //流程处理意见不是下拉框选择的，是根据弹出框设置的，所以这里特殊处理，拼接为下拉框显示。
			var formatStr = '<option value="${field.formatType}" title="${field.extraMap.flowFormatShow}" selected="selected">${field.extraMap.flowFormatShow}</option>';
			formatTypeObj.empty();
			formatTypeObj.append(formatStr);
		}else{
			formatTypeObj.val("${field.formatType}");
			formatTypeObj.find("option[value='${field.formatType}']").attr("selected",true);
		}
		if("${field.inputType}" == "relation"){
			viewAllRelationDisOrHide(index,"${field.formRelation.toRelationAttrType}");
			//将关联属性改为可搜索的下拉框，放在这里的原因：如果直接放页面，需要全部组件化，然后还的在这里来隐藏不需要的。所以现在是有关联属性的，在这里手动组件化一次。
			<c:if test="${field.inputType == 'relation' && (field.formRelation.toRelationAttrType == 1 || field.formRelation.toRelationAttrType == 4 || field.formRelation.toRelationAttrType == 7 || field.formRelation.toRelationAttrType == 8 || field.formRelation.toRelationAttrType == 9)}">
			addRefInputAttr(index,"${field.formRelation.viewAttr}");
			var refInputAttrObj = $("#refInputAttr"+index);
			refInputAttrObj.append('${field.extraMap.refAttrOptions}');
			refInputAttrObj.comp();
			//将select中的校验规则放在组件化之后的input框上，在提交的时候利用组件去判断关联属性是否为空。
			addValidateToInput(index);
			var valueT = $("#refInputAttr"+index+"_txt").val();
			$("#refInputAttr"+index+"_txt").attr("title", valueT);
			</c:if>
			//$("[id^='relationTD']").comp();
		}
	</c:forEach>
	//该方法需要放到后台--dee
	if("${isHasDeeField}" == true || "${isHasDeeField}" == "true"){
		initDeeTaskRelation();
	}
}
/**
 * 新增关联属性的下拉框,传入行号和原关联属性
 */
function addRefInputAttr(index,oldRefInputAttr){
    var relationTDObj = $("#relationTD"+index);
	relationTDObj.empty();
	if(!oldRefInputAttr){
		oldRefInputAttr = "";
	}
	relationTDObj.append('<select id="refInputAttr'+index+'" style="width:100px;" oldRefInputAttr="' + oldRefInputAttr + '" name="refInputAttr'+index+'" onchange="changeRefInputAttr(\''+index+'\');" class="comp common_drop_down" comp="type:\'autocomplete\',autoSize:true" comptype="autocomplete" validate="name:\'${ctp:i18n("form.create.input.relation.att.label")}\',notNull:true">');
}
//将select中的校验规则放在组件化之后的input框上，在提交的时候利用组件去判断关联属性是否为空。
function addValidateToInput(index){
	var input = $("#refInputAttr"+index+"_txt").addClass("validate");
	var validate = $("#refInputAttr"+index).attr("validate");
	input.attr("validate",validate);
}

/*
 * 检查是否当前对象被引用
 */
function checkInputType2Change(index){
	var result = true;
	var inputTypeObj = $("#inputType"+index);
	var fieldNameObj = $("#fieldName"+index);
	var fieldTypeObj = $("#fieldType"+index);
	var oType = inputTypeObj.attr("oldInputType");
	if(oType == "outwrite"|| oType == "relationform" || oType == "project" || oType == "member" || oType == "department" || oType=="select"
			|| oType == "mapmarked" || oType == "maplocate" || oType == "mapphoto" || oType == "relation" || oType == "exchangetask"){
		<c:forEach items="${formBean.allFieldBeans}" var="field" varStatus="status">
			var i = "${status.index}";
			if(i != index){
				var inputTypeIObj = $("#inputType"+i);
				//遍历所有字段，看每个字段的关联对象时候是当前表单，并且录入类型是数据关联
				if(fieldNameObj.attr("value")==$("#refInputName"+i).val() && (inputTypeIObj.val() == "relation" || inputTypeIObj.val()=="externalwrite-ahead")){
					result = false;
					inputTypeObj.val(oType);
					fieldTypeObj.val(fieldTypeObj.attr("oldFieldType"));
				}
			}
		</c:forEach>
	}
	return result;
}

function changeRelationTips(index, dialog){
	/**
	 * 选择模板点击确定时，如果是相同模板，则提交后保留原样，如果发现是不同的模板，则提示：
	 * 提示信息是:要提示该字段被哪些字段数据关联了,更改模板后该数据关联失效
	 * 确定:
	 * 取消:
	 */
	var fieldNameObj = $("#fieldName"+index);
	var returnFieldName = "";
	<c:forEach items="${formBean.allFieldBeans}" var="field" varStatus="status">
		var i = "${status.index}";
		if(i != index){
			var inputTypeIObj = $("#inputType"+i);
			//遍历所有字段，看每个字段的关联对象时候是当前表单，并且录入类型是数据关联
			if(fieldNameObj.attr("value")==$("#refInputName"+i).val() && (inputTypeIObj.val() == "relation" || inputTypeIObj.val()=="externalwrite-ahead")){
				var fieldNameStr = $("#fieldName" + i).attr("display");
				returnFieldName += "[" + fieldNameStr + "]" + " ";
			}
	}
	</c:forEach>

	if(returnFieldName != ""){
		$.confirm({
			'msg': "切换关联表单,将清空 "+returnFieldName+"字段中的关联属性内容!",
			okText : "继续",
			cancelText : "取消",
			cancel_fn : function () {
				//dialog.close();
			},
			ok_fn : function(){
				dialog.close();
				resetFormRelation(index);
			}

		});
	}else{
		dialog.close();
	}


}

/**
 * 6.1sp1 关联修改.当字段为关联表单,被其他数据关联关联了的话,在没有产生数据和参与计算式的情况下可以修改.
 * 1.判断出哪些字段是数据关联,并且关联的是本字段
 * 2.遍历这些字段.
 */
function resetFormRelation(index){

	//index为关联表单的那个字段的索引.记关联表单字段为A
	<c:forEach items="${formBean.allFieldBeans}" var="field" varStatus="status">
		var i = "${status.index}";

		//i != index 排除掉关联表单自身
		if(i != index){

			//如果字段的inputType是数据关联.并且关联对象的值是A的值.这样就找到了所有数据关联到A的字段
			if(($("#inputType"+i).val() == "relation") && ($("#refInputName"+i).val() == $("#fieldName"+index).attr("value"))){

				//tagIndex是A的索引
				var tagIndex = $("#inputType"+i).attr("tagIndex");
				buildNewRelation(tagIndex);
				var objName = $("#fieldName"+i).attr("value");

				//i为数据关联A的字段的索引
				recursionFindRelation(i, objName);
				viewAllOutWriteAndAllRelation(1);
			}
		}
	</c:forEach>


}
/**
 *以当前的数据关联对象为基准.递归的去寻找下一级关联到当前字段的数据关联字段
 *index:为当前数据关联字段的索引
 *objName:当前数据关联字段关联对象的值
 * */
function recursionFindRelation(index, objName){

	var fdManager = new formFieldDesignManager();

	var fieldNameObj = $("#fieldName"+index);

	//以objName这个字段为基准.继续找下一级的数据关联
	<c:forEach items="${formBean.allFieldBeans}" var="field" varStatus="status">
		var i = "${status.index}";
		if(i != index){
			var inputTypeIObj = $("#inputType"+i);
			//如果字段的输入类型是relation.并且该字段的关联对象的值是objName.就找到了所有关联到objName的字段B
			if((inputTypeIObj.val() == "relation") && ($("#refInputName"+i).val() == objName)){

				//字段B
				var objName = $("#refInputName"+i).val();
				//记录下要被删除的option
				var removeOpt = $("#fieldName"+i).attr("value");


				$("#refInputName"+ i + " option:first").prop("selected", 'selected');
				$("#relationTD"+i).empty();
				var param = getUpdateFormFieldParam(i);
				fdManager.updateFormFieldChange(param);
				//递归的查询
				recursionFindRelation(i, removeOpt);
			}

		}

	</c:forEach>
}

function buildNewRelation(index){
	var refSelect = $("#refInputAttr"+index);
	var refInputNameIndexObj = $("#refInputName"+index);
	var _val = refInputNameIndexObj.val();
	var refIndex = $("#"+_val+"tr").attr("index");
	var bindSetAttrRefIndexObj = $("#bindSetAttr"+refIndex);
	var bindAttrIndexObj = $("#bindSetAttr" + index);
	var relFormId = bindSetAttrRefIndexObj.attr("bindObjId");
	////refInputAttr2的这个属性oldrefinputattr
	refSelect.attr("oldrefinputattr", "");
	//refSelect.val("");
	var refFormulaStr =  bindSetAttrRefIndexObj.attr("viewCondition");
	var refSelectType = bindSetAttrRefIndexObj.attr("selectType");
	var refBindObjId = bindSetAttrRefIndexObj.attr("bindObjId");
	var refrelObjId = bindSetAttrRefIndexObj.attr("relObjId");
	var refisMaster = bindSetAttrRefIndexObj.attr("isMaster");
	var refTable = bindSetAttrRefIndexObj.attr("tableName");
	var refBindAttr = bindSetAttrRefIndexObj.attr("bindAttr");

	bindAttrIndexObj.attr("viewCondition", refFormulaStr);
	bindAttrIndexObj.attr("selectType", refSelectType);
	bindAttrIndexObj.attr("bindObjId", refBindObjId);
	bindAttrIndexObj.attr("relObjId", refrelObjId);
	bindAttrIndexObj.attr("isMaster", refisMaster);
	bindAttrIndexObj.attr("tableName", refTable);
	bindAttrIndexObj.attr("bindAttr", refBindAttr);


	//addRefInputAttr(index);
	//通过ajax获取关联id的表单对应所有字段
	var fdManager = new formFieldDesignManager();
	var returnObj = fdManager.getRelationFormField(relFormId);
	refSelect.empty();
	refSelect.append('<option value="" selected="selected"></option>');
	var objLength = returnObj.length;
	for(var k=0;k<objLength;k++){
		//流程名称过滤
		if(returnObj[k].name == "flowName"){
			continue;
		}
		//进行字段过滤
		if(!filterData4RelationForm(index,refIndex,returnObj[k])){
			continue;
		}

		refSelect.append('<option value="'+returnObj[k].name+'" canInputLength = "'+returnObj[k].isCanInputLength+'" digitNum="'+returnObj[k].digitNum+'" inputType="'+returnObj[k].inputType+'" fieldLength="'+returnObj[k].fieldLength+'" fieldType="'+returnObj[k].fieldType+'" isMasterField="'+returnObj[k].masterField+'" tableName="'+returnObj[k].ownerTableName+'" title="'+returnObj[k].display+'">'+returnObj[k].display+'</option>');

	}
	refSelect.comp();
	//viewAllOutWriteAndAllRelation("1");
	var fdManager = new formFieldDesignManager();
	var param = getUpdateFormFieldParam(index);
	fdManager.updateFormFieldChange(param);
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
			}else if((inFieldType === "TIMESTAMP" || inFieldType === "DATETIME" || inFieldType === "DECIMAL")
					 && (currentFieldType === "DECIMAL" || currentFieldType === "DATETIME" || currentFieldType === "TIMESTAMP")
					 && currentFormula.indexOf(inFieldDisplay) != -1){
				//新增函数getSubValueByMax( {field6} , {事项描述} )出现这种数字类型参与日期计算的场景，在改为文本时需要校验。
				obj.inFormula = true;
				obj.index = i;
			}
		}
	</c:forEach>
	return obj;
}

/**
 * 判断当前字段是否为二维码组成项，如果是的话需要先去掉，才能改变录入类型
 * */
function isInBarcode(index){
	var obj = new Array();
	obj.isInBarcode = false;
	obj.index = -1;
	var inFieldName = $("#fieldName"+index).attr("value");
	<c:forEach items="${formBean.allFieldBeans}" var="field" varStatus="status">
	var i = "${status.index}";
	if(i != index){
		var currentFormula = $("#barcodeAttr"+i).val();
		if(currentFormula.indexOf(inFieldName) > -1){
			obj.isInBarcode = true;
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
    var input = $("#inputType"+index);
    var format = $("#formatType"+index);
    var fieldType = $("#fieldType"+index);
    var fieldNameObj = $("#fieldName"+index);
    var fieldTypeVal = fieldType.val();
    var formatType = format.val();
    var inputType = input.val();
    var formulaStr = $("#formulaData"+index).val();
	//数字类型的字段，如果没有设置日期时间差函数的情况下，是不允许设置天等格式的。
	if(fieldTypeVal == "DECIMAL" && (inputType != "outwrite" && inputType != "externalwrite-ahead") && (formatType == "<%=FormConstant.Day%>"
			|| formatType == "<%=FormConstant.DateTime%>"
			|| formatType == "<%=FormConstant.WorkDay%>"
			|| formatType == "<%=FormConstant.WorkDateTime%>")){
		if($.trim(formulaStr) == ""){
			//$.alert("${ctp:i18n_1('form.baseinfo.formatset.date.must.error.label','"+$("#formatType"+index).find("option:selected").text()+"')}");
			$.alert($.i18n('form.baseinfo.formatset.date.must.error.label',format.find("option:selected").text()));
            format.val("");
			return;
		}else{
	        var _dataObj = $.parseJSON(formulaStr);
	        if(_dataObj.data.length > 0 && $.trim(_dataObj.data[0].result) == ""){
	            $.alert($.i18n('form.baseinfo.formatset.date.must.error.label',format.find("option:selected").text()));
                format.val("");
	            return;
	        }
		}
		
	}else if(false && fieldTypeVal == "DECIMAL" && (formatType == "<%=FormConstant.ThousandTag%>"
		|| formatType == "<%=FormConstant.HundredTag%>")){
		if(formulaStr.indexOf("differDate") > -1){
			var display = formatType == "" ? $.i18n('form.baseinfo.hasdate.setformat.value.null') : formatType.find("option:selected").text();
			//$.alert("${ctp:i18n_1('form.baseinfo.hasdate.setformat.error.label','"+display+"')}");
			$.alert($.i18n('form.baseinfo.hasdate.setformat.error.label',display));
			setDecimalFormat(formulaStr,index,$("#digitNum"+index).val());
			return;
		}
	}
	if(inputType == "outwrite"){
		//OA-98588和孙老师对称，已产生数据，外部写入-数字、日期、日期时间要允许修改显示格式（外部写入-文本要始终不允许），但现状是都不允许
	    if(hasData(fieldNameObj.attr("value")) && fieldTypeVal != "DECIMAL" && fieldTypeVal != "TIMESTAMP" && format.attr("oldFormatType") && format.val()!=format.attr("oldFormatType")){
            format.val(format.attr("oldFormatType"));
	        $.alert($.i18n('form.base.dataform.outwrite.format.error.label'));
	        return;
	    }
	    //是否参与校验规则判断
	    if(isInCheckRule(index)){
            format.val(format.attr("oldFormatType"));
	        //该字段参与了校验规则，请先解除校验规则！
	        $.alert($.i18n('form.base.field.isincheckrule.error.label'));
	        return;
	     }
	    //对数字类型，日期日期时间类型参与计算进行判断。
	    var returnObj = isInForumula(index);
	    if(returnObj.inFormula && fieldTypeVal != "DECIMAL" && fieldTypeVal != "TIMESTAMP"){
            format.val(format.attr("oldFormatType"));
	        $.alert($.i18n('form.base.field.inputType.informula.error.label',$("#fieldName"+returnObj.index).attr("display")));
	        return;
	    }
	    //判断是否已经设置了唯一标识,同时又属于lable,text,radio,select,textarea
	    if(fieldHasUnique(index) && fieldTypeVal != "DECIMAL" && fieldTypeVal != "TIMESTAMP"){
	        if(!checkInput4UniqueMarket(format.val())){
                format.val(format.attr("oldFormatType"));
	            //该字段在唯一标示中已经设置了，请先修改唯一标示!
	            $.alert($.i18n('form.base.uniqueFlag.check.error.label'));
	            return;
	        }
	    }
	    //检查是否被关联属性关联
	    if(!checkInputType2Change(index) && fieldTypeVal != "DECIMAL" && fieldTypeVal != "TIMESTAMP"){
            format.val(format.attr("oldFormatType"));
	        //当前对象已经被引用，请先取消引用后再改变此属性
	        $.alert($.i18n('form.base.relation.objct.isref.label'));
	        return;
	    }
		//OA-98588和孙老师对称，已产生数据，外部写入-数字、日期、日期时间要允许修改显示格式（外部写入-文本要始终不允许），但现状是都不允许
		if(fieldTypeVal != "DECIMAL" && fieldTypeVal != "TIMESTAMP") {
			// OA-114784 无流程触发有流程，设置外部写入-地图标注/复选框，拷贝到实际地图标注/复选框控件时，确定保存提示长度不一致。
			var fieldLength = $("#fieldLength" + index);
			if(formatType == "checkbox"){
				fieldLength.val(inputTypeRelObj["checkbox"]["VARCHAR"].fieldLength);
			}else if(formatType == "mapmarked"){
				fieldLength.val(inputTypeRelObj["mapmarked"]["VARCHAR"].fieldLength);
			}else if(formatType.indexOf("multi") > -1){
				fieldLength.val(inputTypeRelObj["multimember"]["VARCHAR"].fieldLength);
			}else{
				fieldLength.val(inputTypeRelObj["text"]["VARCHAR"].fieldLength);
			}

			var options = {};
			options.fieldName = fieldNameObj.attr("value");
			options.fieldType = fieldTypeVal;
			options.oldFieldType = fieldTypeVal;
			options.fieldLength = fieldLength.val();
			options.digitNum = $("#digitNum" + index).val();
			options.inputType = format.val() == 'flowTitle' ? "text" : format.val() == 'multiattachment' ? "attachment" : format.val();//edit by chenxb 附件回写支持追加 2016-02-24
			options.oldInputType = format.attr("oldFormatType") ? format.attr("oldFormatType") == 'multiattachment' ? "attachment" : format.attr("oldFormatType") : "text";//edit by chenxb 附件回写支持追加 2016-02-24
			//对基础设置进行校验,通过ajax判断是否已经产生数据等判断
			var returnStr = vlidateFormFieldChange(options);
			if (returnStr.value != "1" && returnStr.value != "-7" && returnStr.value != "000") {
				$.alert(returnStr.error);
				format.val(format.attr("oldFormatType"));
				return;
			} else if (returnStr == "-7") {
				var confirm = $.confirm({
					'msg': $.i18n('form.baseinfo.operate.advacecondition.error.label'),//该字段参与了操作权限的高级设置条件计算式！该操作可能导致计算式失效！
					ok_fn: function () {
						confirm.close();
					},
					cancel_fn: function () {
						format.val(format.attr("oldFormatType"));
						confirm.close();
					}
				});
			}
		}
	}
	var formatEnumObj = $("#formatEnum"+index);
	if(formatType == "select"){
        clearEnumValue(index);
	    bindOutWriterEnum(index);
	    formatEnumObj.show();
	}else{
	    formatEnumObj.hide();
	    formatEnumObj.val("");
	    $("#formatEnumLevel"+index).hide();
        clearEnumValue(index);
	}
	var formulaObj = $("#formula"+index);
    if(formatType == "urlPage"){
        var options = getValidateFieldOptions(index);
        options.fieldName = fieldNameObj.attr("value");
        options.formatType = "urlPage";
        var returnStr = vlidateFormFieldChange(options);
        if(returnStr.value  != "1" && returnStr.value == "-17"){
            $.alert(returnStr.error);
            $("#formatType"+index).val("");
            return ;
        }
        //对计算式相关信息进行置空
        formulaObj.hide();
        $("#advance"+index).hide();
        $("#formulaData"+index).val("");
		$("#barcodeAttr"+index).val("");
        formulaObj.attr("isAdvance","0");
        formulaObj.val("");
    }else{
        if(inputType == "flowdealoption"
            || inputType == "outwrite"
			|| inputType == "member"
			|| inputType == "multimember"
			|| inputType == "department"
			|| inputType == "multidepartment"
			|| inputType == "externalwrite-ahead"
            || ((inputType == "select" || inputType == "radio") && $("#selectBindInput"+index).attr("enumType") == 4 && fieldType.val() == "VARCHAR")){
            formulaObj.hide();
        }else{
            formulaObj.show();
        }
    }
	//更新后台缓存editform
	var param = getUpdateFormFieldParam(index);
	var fdManager = new formFieldDesignManager();
	fdManager.updateFormFieldChange(param);
    format.attr("oldFormatType",formatType);
	//外部写入字段类型的显示格式变化后，刷新一下关联对象
	if(inputType == "outwrite") {
		viewAllOutWriteAndAllRelation("1");
	}
}

function clearEnumValue(index){
    $("#formatEnum"+index).val("");
    var bindSetAttrObj = $("#bindSetAttr"+index);
    bindSetAttrObj.attr("formatEnumId","");
    bindSetAttrObj.attr("formatEnumIsFinalChild","");
    bindSetAttrObj.attr("formatEnumLevel","");
    bindSetAttrObj.attr("imageEnumFormat","");
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
					var fieldLengthKObj = $("#fieldLength"+k);
					if(parseInt(fieldLengthKObj.val()) < 256){
						currentNumbers = currentNumbers + parseInt(fieldLengthKObj.val()) + 2;
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

function getFormData(){
    return $("#baseInfoForm").formobj();
}

function saveFormData() {
    getCtpTop().processBar = getCtpTop().$.progressBar({text: "${ctp:i18n('form.base.saveingFormInfo')}"});
    var manager = new formFieldDesignManager();
    manager.saveBaseInfo(getFormData());
    parent.closeProcessBar();
}
</script>