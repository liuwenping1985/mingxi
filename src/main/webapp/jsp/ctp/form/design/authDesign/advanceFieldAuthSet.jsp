<%--
 $Author: dengxj $
 $Rev: 603 $
 $Date:: 2014-10-16
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/form/common/common.js.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>权限条件控制</title>
</head>
<body>
<div id="headerDiv">
	<table align="center" width="100%" height="90%" style="table-layout:fixed;">
		<tr  id="digitAdvacedSet">
			<table id="setArea" class="margin_5">
				<tr scope="advancedTextField" name="cloneTR">
					<td valign="top" width="12%" height="100%" align="right" class=" padding_t_5 padding_r_5">
					<span id="add" onClick="addRow(this);"  class="ico16 repeater_plus_16"></span><br><br>
					<span id="del" onClick="delRow(this);"  class="ico16 repeater_reduce_16"></span>
					</td>
					<td valign="top" width="8%" height="100%" align="right" class="padding_t_5"><span class="font_size12 padding_r_5">&nbsp;${ctp:i18n("form.highAuthDesign.if")}</span> </td>
					<td valign="middle" width="27%" height="100%" align="left" class="padding_t_5">
					<textarea id='ifFormField' name="ifFormField" readonly="true" cols="25" rows="5" class="input-100" onClick="setCondition(this,'${field.name}',${field.masterField},'${field.ownerTableName}')">${ctp:i18n('form.authdesign.hightauth.label')}</textarea>
					</td>
					<td valign="top" width="10%" height="100%" align="right" class="padding_t_5"><span class="font_size12 padding_r_5">&nbsp;${ctp:i18n("form.field.formula.elseif.set")} </span> </td>
					<td width="43%" valign="middle" align="left" class=" padding_t_5">
                        <table>
                        <tr>
                            <td colspan="5" class="font_size12">
                                [<c:if test="${field.masterField}">${ctp:i18n("form.base.mastertable.label")}</c:if><c:if test="${!field.masterField}">${ctp:i18n("formoper.dupform.label")}${field.ownerTableIndex }</c:if>]&nbsp${field.display}:
                            </td>
                        </tr>
                        <tr id="selectAllAccess" class="font_size12">
                            <td align="center">${ctp:i18n('form.oper.browse.label')}</TD>
                            <td align="center">${ctp:i18n('form.authDesign.edit')}</TD>
                            <td align="center">${ctp:i18n('form.authDesign.hide')}</TD>
                            <td align="center">${ctp:i18n('form.oper.superaddition.label')}</TD>
                            <td align="center">${ctp:i18n('form.authDesign.mustinput')}</TD>
                        </tr>
                        <tr id="radioTr">
                            <td align="center" class="font_size12"><INPUT tableName="${field.ownerTableName }" fieldName="${field.name }" fieldType="${field.inputType}" <c:if test="${field.inputType eq relationForm}">viewSelectType = ${field.formRelation.viewSelectType }</c:if> type="radio" checked="checked" id="field_access" name="field_access" value="${browse }"></td>
                            <td align="center" class="font_size12"><INPUT tableName="${field.ownerTableName }" fieldName="${field.name }" fieldType="${field.inputType}" <c:if test="${field.inputType eq relationForm}">viewSelectType = ${field.formRelation.viewSelectType }</c:if> type="radio" id="field_access" name="field_access" value="${edit }"></td>
                            <td align="center" class="font_size12"><INPUT tableName="${field.ownerTableName }" fieldName="${field.name }" fieldType="${field.inputType}" <c:if test="${field.inputType eq relationForm}">viewSelectType = ${field.formRelation.viewSelectType }</c:if> type="radio" id="field_access" name="field_access" value="${hide }"></td>
                            <td align="center" class="font_size12">
                                <c:if test="${field.inputType eq 'textarea' or field.inputType eq 'flowdealoption' }">
                                    <INPUT tableName="${field.ownerTableName }" fieldName="${field.name }"  fieldType="${field.inputType}" <c:if test="${field.inputType eq relationForm}">viewSelectType = ${field.formRelation.viewSelectType }</c:if> type="radio" id="field_access" name="field_access" value="${add }" >
                                </c:if>
                            </td>
                            <td align="center" class="font_size12">
                                <INPUT type="checkbox" fieldType="${field.inputType}" <c:if test="${field.inputType eq relationForm}">viewSelectType = ${field.formRelation.viewSelectType }</c:if> id="field_notNull" onClick="clickIsNotNull(this);"  value="0"/>
                            </td>
                        </tr>
                        </table>
					</td>
				</tr>
			</table>
		</tr>
	</table>
	</div>
	<div id="bottomDiv" class="stadic_layout_footer">
	<table><tr><td><a id="abandon" class="common_button common_button_gray" href="javascript:void(0)">${ctp:i18n('form.trigger.triggerSet.reset.label')}</a></td></tr></table>
	</div>
    <script type="text/javascript">
        var parWin = window.dialogArguments;
        var currentFieldName = "${field.name}";
        var authTypeValue = $("#authTypeValue",parWin.document).val();
        $().ready(
                function(){
                    init();
                }
        );
        /**
         * 初始化
         */
        function init() {
            //重置事件
            $("#abandon").click(function (index) {
                if("${viewType}" == 'view') {
                    return;
                }
                $("#setArea tr[name='cloneTR']").each(function (index) {
                    if (index === 0) {
                        $($(this).find("textarea")[0]).val("");
                        $($(this).find("textarea")[0]).val("${ctp:i18n('form.authdesign.hightauth.label')}");
                        $($(this).find("input[type='checkbox']")[0]).removeAttr("checked");
                        $($(this).find("input[type='checkbox']")[0]).attr("value",0);
                        initAuthRadio($(this));
                        resetAuthRdio($(this));
                        return true;
                    } else {
                        $(this).remove();
                    }
                });
                adapterFooter();
            });
            $("input:radio","#setArea").click(function(){
                setIsNotNullAbled($(this));
            });
            //初始化权限值的状态
            initAuthRadio($("#setArea"));
            initData();
            resetAuthRdio("relation",$("#setArea"));
            if("${viewType}" == "view"){
                $("#abandon").prop("disabled",true);
            }
        }

        function initAuthRadio(currentObj){
            $("input:radio",currentObj).each(function(){
                if($(this).val() == "${edit}" && authTypeValue == "add"){
                    $(this).prop("checked",true);
                }else if($(this).val() == "${browse}" && authTypeValue != "add"){
                    $(this).prop("checked",true);
                }
            });
            if (authTypeValue == "readonly") {
                $("input[value=${edit}]",currentObj).prop("disabled",true);
                $("input[value=${add}]",currentObj).prop("disabled",true);
                $("input[value=${browse}]",currentObj).prop("checked",true);
            }
            if("${isCollectTable}" == "true") {
                $("input[value=${browse}]",currentObj).prop("checked",true);
                $("input[value=${edit}]",currentObj).prop("disabled",true);
                $("input[value=${add}]",currentObj).prop("disabled",true);
            }
        }

        //设置单选多选的状态
        //必填选项
        //外部写入 和外部预写不能编辑和隐藏
        //如果当前字段是系统关联表单字段，那么必填置灰，权限缺省为浏览状态。
        function resetAuthRdio(relationForm,currentObj){
            $("input:radio[value='" + parWin._browse + "'][fieldType='" + parWin._externalwrite + "']",currentObj).prop("checked",true);
            $("input:radio[value!='" + parWin._browse + "'][fieldType='" + parWin._externalwrite + "']",currentObj).prop("disabled",true);
            $("input:radio[value='" + parWin._browse + "'][fieldType='" + parWin._outwrite + "']",currentObj).prop("checked",true);
            $("input:radio[value!='" + parWin._browse + "'][fieldType='" + parWin._outwrite + "']",currentObj).prop("disabled",true);
            $("input:radio[value='" + parWin._browse + "'][fieldType='" + parWin._linenumber + "']",currentObj).prop("checked",true);
            $("input:radio[value!='" + parWin._browse + "'][fieldType='" + parWin._linenumber + "']",currentObj).prop("disabled",true);
            //如果当前字段是系统关联表单字段，那么必填置灰，权限缺省为浏览状态。
            if (relationForm != "relation"){
                $("input:radio[value=" + parWin._browse + "][fieldType='" + parWin._relationForm + "'][viewSelectType=2]",currentObj).prop("checked",true);
            }
            $("input:radio[value=" + parWin._isNotNull + "][fieldType='" + parWin._relationForm + "'][viewSelectType=2]",currentObj).prop("checked",false);
            $("input:radio[value=" + parWin._isNotNull + "][fieldType='" + parWin._relationForm + "'][viewSelectType=2]",currentObj).prop("disabled",true);
            if(currentObj != undefined && currentObj.attr("id") === "setArea") {
                setIsNotNullAbled();
            }else{
                setIsNotNullAbled(currentObj);
            }
        }

        function setIsNotNullAbled(obj){
            if(obj){
                var checkedObj = obj;
                var nullAbleObj = $(obj.parents("tr").find("input:checkbox")[0]);
                if(checkedObj.val() == parWin._browse || parWin._hide == checkedObj.val()){
                    nullAbleObj.prop("checked",false);
                    nullAbleObj.prop("disabled",true);
                    nullAbleObj.attr("value",0);
                    if(checkedObj.attr("fieldType") == "linenumber"){
                        //nullAbleObj.prop("checked", true);
                    }
                }else{
                    nullAbleObj.prop("disabled",false);
                }
                if(checkedObj.attr("fieldType") == "flowdealoption" || checkedObj.attr("fieldType") == "checkbox"){
                    nullAbleObj.prop("checked", false);
                    nullAbleObj.prop("disabled",true);
                }
                if(checkedObj.attr("fieldType") == parWin._relationForm && checkedObj.attr("viewSelectType") == "2"){
                    nullAbleObj.prop("checked", false);
                    nullAbleObj.prop("disabled",true);
                }
            }else {
                $("input:radio:checked", "#setArea").each(function () {
                    var checkedObj = $(this);
                    var nullAbleObj = $($(this).parents("tr").find("input[type='checkbox']")[0]);
                    if (checkedObj.val() == parWin._browse || parWin._hide == checkedObj.val()) {
                        nullAbleObj.prop("checked", false);
                        nullAbleObj.prop("disabled", true);
                        if (checkedObj.attr("fieldType") == "linenumber") {
                            //nullAbleObj.prop("checked", true);
                        }
                    } else {
                        nullAbleObj.prop("disabled", false);
                    }
                    var fieldtype = $(this).attr("fieldtype");
                    if (fieldtype == "flowdealoption" || fieldtype == "checkbox" || fieldtype == "lable") {
                        nullAbleObj.prop("checked", false);
                        nullAbleObj.prop("disabled", true);
                    }
                    if (fieldtype == parWin._relationForm && checkedObj.attr("viewSelectType") == "2") {
                        nullAbleObj.prop("checked", false);
                        nullAbleObj.prop("disabled", true);
                    }
                    if("${viewType}"=="view"){
                        nullAbleObj.prop("disabled", true);
                    }
                });
            }
        }

        /*
        * 增加行
        */
        function addRow(obj){
            if("${viewType}" == 'view') {
                return;
            }
            if($(obj).parent().parent().parent().find("tr[name='cloneTR']").length > 40){
                $.alert("${ctp:i18n('form.field.formula.max.message')}");
                return;
            }
            var randomNum = getRandom(999);
            var ifName="ifFormField" + randomNum;
            var resName = "field_access" + randomNum;
            var resNotNullName = "field_isNotNull" + randomNum;
            //这里不知道为什么源行的radio会被清空，这里做一个预防保存操作
            var oldRadioValue = $($(obj).parents("tr").find("input[type='radio']:checked")[0]).attr("value");
            //var currentRow = $(obj).parents("tr").clone(true);
            var currentRow = formClone4AuthSet($(obj).parents("tr"));
            if($.browser.msie && ($.browser.version=="6.0" || $.browser.version=="7.0")) {
                currentRow = getNewTR(currentRow, randomNum);
            }
            currentRow.insertAfter($(obj).parents("tr"));
            $($(obj).parents("tr").next().find("textarea")[0]).attr("id",ifName);
            $($(obj).parents("tr").next().find("textarea")[0]).val("${ctp:i18n('form.authdesign.hightauth.label')}");
            if(!($.browser.msie && ($.browser.version=="6.0" || $.browser.version=="7.0"))) {
                $($(obj).parents("tr").next().find("input[type='radio']")).each(
                        function (index) {
                            $(this).attr("id", resName);
                            $(this).prop("id", resName);
                            $(this).attr("name", resName);
                            $(this).prop("name", resName);
                        }
                );
            }
            $($(obj).parents("tr").next().find("input[type='checkbox']")[0]).attr("id",resNotNullName);
            $($(obj).parents("tr").next().find("input[type='checkbox']")[0]).removeAttr("checked");
            $($(obj).parents("tr").next().find("input[type='checkbox']")[0]).attr("value",0);
            initAuthRadio($(obj).parents("tr").next());
            resetAuthRdio($(obj).parents("tr").next());
            //将源行的值设置回去
            $($(obj).parents("tr").find("input[type='radio'][value='"+oldRadioValue+"']")[0]).prop("checked","checked");
            $("input:radio",currentRow).click(function(){
                setIsNotNullAbled($(this));
            });
            adapterFooter();
        }

        /*
        * 删除行
         */
        function delRow(obj){
            if("${viewType}" == 'view') {
                return;
            }
            var trNum = $("#setArea tr[name='cloneTR']").length;
            if(trNum == 1){
                $($(obj).parents("tr").find("textarea")[0]).val("${ctp:i18n('form.authdesign.hightauth.label')}");
                $($(obj).parents("tr").find("input[type='checkbox']")[0]).removeAttr("checked");
                $($(obj).parents("tr").find("input[type='checkbox']")[0]).attr("value",0);
                initAuthRadio($(obj).parents("tr"));
                resetAuthRdio($(obj).parents("tr"));
            }else{
                $(obj).parents("tr").remove();
            }
            adapterFooter();
        }
        /**
         * 初始化数据
         */
        function initData(){
            var data = $("#"+currentFieldName+"_fieldHighAuths",parWin.document).val();
            if(data && data != ""){
                data = $.parseJSON(data);
                if(data.length != undefined){
                    var value ="";
                    for(var i=0;i < data.length;i++){
                        value = data[i];
                        if(i==0){//第一行直接复制
                            $($("#setArea tr[name='cloneTR']").eq(0).find("textarea")[0]).val(value.formulaValue);
                            $($("#setArea tr[name='cloneTR']").eq(0).find("input[type='radio'][value='"+value.access+"']")[0]).attr("checked","checked");
                            $($("#setArea tr[name='cloneTR']").eq(0).find("input[type='checkbox']")[0]).attr("value",value.isNotNull);
                            if(value.isNotNull == 1){
                                $($("#setArea tr[name='cloneTR']").eq(0).find("input[type='checkbox']")[0]).attr("checked","checked");
                            }
                            //禁用每一行
                            if ("${viewType}" === 'view') {
                                disabledTR($("#setArea tr[name='cloneTR']").eq(0));
                            }
                        }else{//非第一行，先增加行，后插入值。
                            var randomNum = getRandom(999);
                            var ifName="ifFormField" + randomNum;
                            var resAccessName = "field_access" + randomNum;
                            var resNotNullName = "field_isNotNull" + randomNum;
                            var k = i-1;
                            var oldRadioValue = $($("#setArea tr[name='cloneTR']").eq(k).find("input[type='radio']:checked")[0]).val();
                            var currentRow =$("#setArea tr[name='cloneTR']").eq(k).clone(true);
                            if($.browser.msie && ($.browser.version=="6.0" || $.browser.version=="7.0")) {
                                currentRow = getNewTR(currentRow, randomNum);
                            }
                            currentRow.insertAfter($("#setArea tr[name='cloneTR']").eq(k));
                            $($("#setArea tr[name='cloneTR']").eq(k).next().find("textarea")[0]).attr("id",ifName);
                            $($("#setArea tr[name='cloneTR']").eq(k).next().find("textarea")[0]).val(value.formulaValue);
                            if(!($.browser.msie && ($.browser.version=="6.0" || $.browser.version=="7.0"))) {
                                $($("#setArea tr[name='cloneTR']").eq(k).next().find("input[type='radio']")).each(
                                        function (index) {
                                            $(this).attr("id", resAccessName);
                                            $(this).attr("name", resAccessName);
                                        }
                                );
                            }
                            $($("#setArea tr[name='cloneTR']").eq(k).next().find("input[type='checkbox']")[0]).attr("id",resNotNullName);
                            $($("#setArea tr[name='cloneTR']").eq(k).next().find("input[type='radio'][value='"+value.access+"']")[0]).attr("checked","checked");
                            $($("#setArea tr[name='cloneTR']").eq(k).next().find("input[type='checkbox']")[0]).removeAttr("checked");
                            $($("#setArea tr[name='cloneTR']").eq(k).next().find("input[type='checkbox']")[0]).attr("value",value.isNotNull);
                            if(value.isNotNull == 1){
                                $($("#setArea tr[name='cloneTR']").eq(k).next().find("input[type='checkbox']")[0]).attr("checked","checked");
                            }
                            $($("#setArea tr[name='cloneTR']").eq(k).find("input[type='radio'][value='"+oldRadioValue+"']")[0]).attr("checked","checked");
                            //禁用每一行
                            if ("${viewType}" === 'view') {
                                disabledTR($("#setArea tr[name='cloneTR']").eq(k));
                            }
                        }
                    }
                    adapterFooter();
                }
            }else{
            	//禁用每一行
                if ("${viewType}" === 'view') {
                    disabledTR($("#setArea tr[name='cloneTR']").eq(0));
                }
            }
        }
        /**
         * 调整重置按钮区域的高度
        */
        function adapterFooter(){
            if($("#headerDiv").height() > 500){
                $("#bottomDiv").removeClass("stadic_layout_footer");
            }else{
                if(!$("#bottomDiv").hasClass("stadic_layout_footer")){
                    $("#bottomDiv").addClass("stadic_layout_footer");
                }
            }
        }
        /**
        * 设置字段权限条件
        * @param obj 当前字段所在textarea
        * @param filterField 过滤当前字段
        * @param isMasterField 是否是主表
        * @param fieldTableName 所在表名
         */
        function setCondition(obj,filterField,isMasterField,fieldTableName){
            if ($(obj).val() == "${ctp:i18n('form.authdesign.hightauth.label')}") {
                $(obj).val("");
            }
            setHighFieldAuth(obj,filterField,isMasterField,fieldTableName);
        }

        /**
         * 是否必填，点击事件
         */
        function clickIsNotNull(obj){
            if($(obj).attr("checked")){
                $(obj).attr("value",1);
            }else{
                $(obj).attr("value",0);
            }
        }
        /**
        * OK 方法，点击确定事件
         */
        function OK() {
            var conditionValue = "";
            var isConditionNull = false;
            var returnValue = new Array();
            var dataObj =null;
            $("#setArea").find("tr[name='cloneTR']").each(function (index) {
                conditionValue = $($(this).find("textarea")[0]).val();
                if(conditionValue == null || conditionValue == "" || conditionValue == "${ctp:i18n('form.authdesign.hightauth.label')}"){
                    isConditionNull = true;
                    return false;
                }
                dataObj = new Object();
                dataObj.formulaValue = conditionValue;
                dataObj.access = $(this).find("input[type='radio']:checked").val();
                dataObj.isNotNull = $($(this).find("input[type='checkbox']")[0]).attr("value");
                returnValue[index] = dataObj;
            });
            if(isConditionNull && $("#setArea").find("tr[name='cloneTR']").length > 1){
                $.alert("${ctp:i18n('form.authdesign.highfieldauth.notnull.label')}");
                return 'false';
            }
            if(isConditionNull && $("#setArea").find("tr[name='cloneTR']").length == 1){
                return "";
            }
            return returnValue.length == 0 ? "" : $.toJSON(returnValue);;
        }
        //获得随机数
        function getRandom(n){
            return Math.floor(Math.random()*n+1);
        }

        function getNewTR(obj,ramNumber){
            obj.comp();
            var ramHtml = getIe7Html(ramNumber);
            $("#radioTr",obj).html(ramHtml);
            $("input:radio",obj).bind("click",function(){
                setIsNotNullAbled($(this));
            });
            return obj;
        }

        function getIe7Html(ramNumber){
            var viewSelectTypeValue = "";
            if("${field.inputType}" === "${relationForm}"){
                viewSelectTypeValue =  " viewSelectType = '" + "${field.formRelation.viewSelectType}" + "'";
            }
            var addradio = "";
            if("${field.inputType}" === "textarea" || "${field.inputType}" === "flowdealoption"){
                addradio = "<INPUT tableName=${field.ownerTableName } fieldName=${field.name }  fieldType=${field.inputType} "+viewSelectTypeValue+" type=\"radio\" id=\"field_access"+ramNumber+"\" name=\"field_access"+ramNumber+"\" value=${add } >";
            }
            var editChkHtml = "";
            var browseChkHtml = "";
            var disabledHtml = "";
            if(authTypeValue == "add"){
                editChkHtml = "checked=\"checked\"";
            }else{
                browseChkHtml = "checked=\"checked\"";
                disabledHtml = "disabled";
            }
            return "<td align=\"center\" class=\"font_size12\"><INPUT tableName='${field.ownerTableName }' fieldName='${field.name }' fieldType='${field.inputType}' "+viewSelectTypeValue+" type=\"radio\" "+browseChkHtml+"  id=\"field_access"+ramNumber+"\" name=\"field_access"+ramNumber+"\" value='${browse}'></td>"
                +"<td align=\"center\" class=\"font_size12\"><INPUT tableName=${field.ownerTableName } fieldName=${field.name } fieldType=${field.inputType} "+viewSelectTypeValue+" type=\"radio\" "+editChkHtml+" id=\"field_access"+ramNumber+"\" name=\"field_access"+ramNumber+"\" value='${edit }'></td>"
                +"<td align=\"center\" class=\"font_size12\"><INPUT tableName=${field.ownerTableName } fieldName=${field.name } fieldType=${field.inputType} "+viewSelectTypeValue+" type=\"radio\" id=\"field_access"+ramNumber+"\" name=\"field_access"+ramNumber+"\" value='${hide }'></td>"
                +"<td align=\"center\" class=\"font_size12\">"+addradio+"</td>"
                +"<td align=\"center\" class=\"font_size12\"><INPUT type=\"checkbox\" fieldType=${field.inputType} "+viewSelectTypeValue+" "+disabledHtml+" id=\"field_notNull\" onClick=\"clickIsNotNull(this);\"  value=\"0\"/></td>";
        }
        function disabledTR(jqObj){
            $(jqObj.find("#add")[0]).prop("disabled",true);
            $(jqObj.find("#del")[0]).prop("disabled",true);
            $(jqObj.find("textarea")[0]).prop("disabled",true);
            $(jqObj.find("input[type='checkbox']")[0]).prop("disabled",true);
            $(jqObj.find("input[type='radio']")).each(function (){
                $(this).prop("disabled",true);
            });
        }
        
        /**
         *自己的clone方法
         */
        function formClone4AuthSet(jqObj){
            var cloneObj;
            if(jqObj[0].outerHTML){
                //****ie7下jquery的clone方法复制出来的对象有问题，因为如果对复制出来的对象设置attr自定义属性的时候会将老对象的attr给修改了
                cloneObj = $(jqObj[0].outerHTML.replace(/jQuery\d+="\d+"/g,""));
            }else{
                cloneObj = jqObj.clone();
            }
            if(cloneObj[0].tagName.toLowerCase()=="input"){
                cloneObj.val(jqObj.val());
            }else{
                var temp = jqObj.find("input");
                cloneObj.find("input").each(function(i){
                    $(this).val(temp.eq(i).val());
                });
                temp = null;
            }
            return cloneObj;
        }
    </script>
</body>
</HTML>