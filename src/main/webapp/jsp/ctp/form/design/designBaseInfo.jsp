<%--
 $Author: wusb $
 $Rev: 603 $
 $Date:: 2012-08-14
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/form/common/common.js.jsp" %>
<%@ include file="designBaseInfo.js.jsp" %>
<html>
    <head> 
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>基础设置</title>
        <script type="text/javascript" src="${path}/ajax.do?managerName=formFieldDesignManager"></script>
        <script type="text/javascript" src="${path}/ajax.do?managerName=formDataManager"></script>
        <script type="text/javascript" src="${path}/ajax.do?managerName=formRelationManager"></script>
        <style type="text/css">
        	.only_table th, .only_table td{ padding:0 2px}
        </style>
    </head>
    <body class="page_color font_size12" onload="closeProgressBar()">
    <input type="button" name="test" value="test" onclick="showIt()" class="hidden">
        <div id='layout' class="comp" comp="type:'layout'">
            <div class="layout_north" id="north" layout="height:40,sprit:false,border:false">
                <!--向导菜单-->
                <div class="step_menu clearfix margin_tb_5 margin_l_10">
                    <%@ include file="top.jsp" %>
                </div>
                <div class="hr_heng"></div>
            </div>
            <!--向导菜单-->
            <div class="layout_center bg_color_white" id="center" style="overFlow-y: hidden">
            <form class="display_block h100b" id="baseInfoForm" name="baseInfoForm" method="post" action="${path}/form/fieldDesign.do?method=saveBaseInfo" style="min-width: 1265px">
                <input type="hidden" name="url" id="url" value="">
                <div class="form_area margin_l_10 margin_b_10 margin_r_10" id="center1" style="min-width: 1040px;">
                    <table border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td nowrap="nowrap">
                                <!-- 表单名称 -->
                                <label for="text">
                                    <c:if test="${formBean.govDocFormType !=5 &&formBean.govDocFormType !=6 && formBean.govDocFormType !=7 && formBean.govDocFormType!=8}">
                                        ${ctp:i18n("form.base.formname.label")}：
                                    </c:if>
                                    <c:if test="${formBean.govDocFormType ==5 ||formBean.govDocFormType ==6 || formBean.govDocFormType ==7 || formBean.govDocFormType==8}">
                                        ${ctp:i18n("form.base.edocformname.label")}：
                                    </c:if>
                                </label>
                            </td>
                            <td nowrap="nowrap">
                            <%--<div class="common_txtbox_wrap"> --%>
                                <input type="text" id="formName" name="formName" title="${formBean.formName}" value="${formBean.formName}" onchange="formNameBlur(this)" maxlength="85" class="validate padding_l_5" validate="avoidChar:'\\/|<>:*?;\'&%$#&#34;',notNullWithoutTrim:true,type:'string',name:'${ctp:i18n("form.base.formname.label")}',notNull:true,maxLength:255"/>
                            <%--</div>--%>
                            </td>
                            <c:if test="${formBean.govDocFormType !=6 && formBean.govDocFormType !=7 &&  formBean.govDocFormType!=8}">
	                            <td nowrap="nowrap">
	                                <!-- 所属应用 -->
	                                <label class="margin_l_10" for="text">${ctp:i18n("form.app.affiliatedapply.label")}：</label>
	                            </td>
	                            <td width="200" nowrap="nowrap">
	                                <select id="categoryId" name="categoryId" class="w100b validate" style="width: 200px;" validate="name:'${ctp:i18n("form.app.affiliatedapply.label")}',notNull:true">
	                                  ${formTemplateCategorys}
	                                </select>
	                            </td>
                            </c:if>
                             <c:if test="${formBean.govDocFormType ==6}">
	                            <input type="hidden" name="categoryId" value="403"/>
                            </c:if>
                            <c:if test="${formBean.govDocFormType ==7}">
	                            <input type="hidden" name="categoryId" value="402"/>
                            </c:if>
                            <c:if test="${formBean.govDocFormType ==8}">
	                            <input type="hidden" name="categoryId" value="404"/>
                            </c:if>
                            <c:choose> 
                             <c:when test="${formBean.govDocFormType == 0 }">
                            <td nowrap="nowrap" >
							<label class="margin_l_10 " for="text">${ctp:i18n("form.base.affiliatedsortperson.label")}：</label>
                            </td>
                            <td width="50" nowrap="nowrap">
                                <input type="text" id="ownerName" name="ownerName" class="padding_l_5" readonly="readonly" value="${ctp:showMemberNameOnly(formBean.ownerId)}"/>
                            </td>
							 </c:when>
							 <c:otherwise> 
							  <td nowrap="nowrap" style="display:none" >
							<label class="margin_l_10 " for="text">${ctp:i18n("form.base.affiliatedsortperson.label")}：</label>
                            </td>
                            <td width="50" nowrap="nowrap" style="display:none" >
                                <input type="text" id="ownerName" name="ownerName" class="padding_l_5" readonly="readonly" value="${ctp:showMemberNameOnly(formBean.ownerId)}"/>
                            </td>
							 </c:otherwise>
                             </c:choose> 
                                <!-- 所属人 -->
                                
                    
                            <td>
                                <!-- 设置 -->
                                <c:if test="${formBean.govDocFormType == 0 }">
                                <a id="setOwnerBtn" class="common_button common_button_gray margin_l_10" href="javascript:void(0)">${ctp:i18n("form.extend.show.set.lable")}</a>
                                </c:if>
                                <input type="hidden" id="ownerId" name="ownerId" readonly="readonly" value="${formBean.ownerId}" />
                            </td>
                            <td nowrap="nowrap">
                                <!-- 表单状态 -->
                                <label class="margin_l_10" for="text">
                                    <c:if test="${formBean.govDocFormType !=5 &&formBean.govDocFormType !=6 && formBean.govDocFormType !=7 && formBean.govDocFormType !=8}">
                                        ${ctp:i18n("form.operhigh.formstate.label")}：
                                    </c:if>
                                    <c:if test="${formBean.govDocFormType ==5 ||formBean.govDocFormType ==6 || formBean.govDocFormType ==7 || formBean.govDocFormType ==8}">
                                        ${ctp:i18n("form.operhigh.edocformstate.label")}：
                                    </c:if>
                                </label>
                            </td>
                            <td width="50" nowrap="nowrap">
                                <input type="text" id="state" name="state" readonly="readonly" class="disabled_color padding_l_5" value="${formBean.extraMap.state}"/>
                            </td>
                            <td nowrap="nowrap">
                                <c:if test="${formType_processesForm eq formBean.formType and isAdvanced eq true and (ctp:hasPlugin('formBiz') or ctp:hasPlugin('formBizModify')) }">
                                    <!-- 回写设置 -->
                                    <a id="setWriteBtn" class="common_button common_button_gray margin_l_10" href="javascript:void(0)">${ctp:i18n("form.echoSetting.label")}</a>
                                </c:if>
                                <c:if test="${formType_processesForm ne formBean.formType}">
                                    <!-- 唯一标示 -->
                                    <a id="setUniqueMarkBtn" class="common_button common_button_gray margin_l_10" href="javascript:void(0)">${ctp:i18n("form.unique.marked.label")}</a>
                                    <input type="hidden" id="uniquedatafield" name="uniquedatafield" value="${uniquedatafield}"/>
                                </c:if>
                            </td>
                            <c:if test="${isAdvanced eq true}">
                            <td nowrap="nowrap">
                                <input type="hidden" id="checkRule" name="checkRule" value="${formBean.checkRule.conditionFormula}" />
                                <input type="hidden" id="checkRuleDescription" name="checkRuleDescription" value="${formBean.checkRule.description}" />
                                <!-- 校验规则 -->
                                <a id="setCheckRule" class="common_button common_button_gray margin_l_10" href="javascript:void(0)">${ctp:i18n("form.baseinfo.checkRule.label")}
                                <span id="checkRuleImg" class="ico16 advanced_16" <c:if test="${formBean.checkRule.conditionFormula == '' || formBean.checkRule.conditionFormula == null }">style="display:none"</c:if>></span>
                                </a>
                            </td>
                            </c:if>
                            <!-- infopath表单才显示移动设计器-->
                            <c:if test="${formBean.formType eq 5  and formBean.infoPathForm}">
                                <td nowrap="nowrap">
                                    <a id="setFormStyleBtn" class="common_button common_button_gray margin_l_10" href="javascript:void(0)"><em class='ico16 formPhone_16'></em>移动设计器</a>
                                </td>
                            </c:if>
                            <!-- 文单格式设置 -->
							<c:if test="${formBean.govDocFormType ne 0 }">
                            <td nowrap="nowrap">
                                    <a id="opinionSet" class="common_button common_button_gray margin_l_10" href="javascript:void(0)">文单格式设置</a>
                            </td>
							</c:if>
							<!-- 全文签批单设置 -->
							<c:if test="${formBean.govDocFormType eq 5|| formBean.govDocFormType eq 7 || formBean.govDocFormType eq 8}">
                            <td nowrap="nowrap">
                                 <a id="govdocSignSet" class="common_button common_button_gray margin_l_10" href="javascript:void(0)">全文签批单设置</a>
                            </td>
							</c:if>
                        </tr>
                    </table>
                </div>
                   
                   <div style="overflow-x:hidden;overflow-y:scroll;" id = "centerList">
                   <table id="formTable" border="0" cellspacing="0"  cellpadding="0" class="form_area only_table edit_table margin_l_10" style="width:98%">
                        <tr>
                        <thead>
                            <!-- 序号 --><th id="serialnumberTH" width="50">${ctp:i18n("form.input.serialnumber.label")} </th>
                            <!-- 名称 -->
                            <th id="DataDefineNameTH">${ctp:i18n("DataDefine.Name")} </th>
                            <!-- 录入类型 -->
                            <th id="inputtypeTH">${ctp:i18n("form.inputtype.label")} </th>
                            <c:if test="${formBean.formType==2 || formBean.formType==3}">
                            <!-- 字段类型 -->
                            <th id="fieldtypeTH">${ctp:i18n("form.base.fieldtype.label")} </th>
                            </c:if>
                            <c:if test="${formBean.formType!=2 && formBean.formType!=3}">
                            <!-- 字段类型 -->
                            <th id="fieldtypeTH">${ctp:i18n("form.base.fieldtype.label")} </th>
                            </c:if>
                            <!-- 关联对象 -->
                            <th id="relationObjectTH">${ctp:i18n("form.input.relationObject.label")}</th>
                            <!-- 关联属性 -->
                            <th id="relationTH">${ctp:i18n("form.create.input.relation.att.label")}</th>
                            <!-- 显示格式 -->
                            <c:if test="${formBean.formType==2 || formBean.formType==3}">
                                <th id="displayformatTH">${ctp:i18n("form.input.displayformat.label")}</th>
                            </c:if>
                            <c:if test="${formBean.formType!=2 && formBean.formType!=3}">
                                <th id="displayformatTH">${ctp:i18n("form.input.displayformat.label")}</th>
                            </c:if>
                            <c:if test="${formBean.formType==2 || formBean.formType==3}">
                                <!-- 计算公式 -->
                                <th id="formulaTH">${ctp:i18n("form.baseinfo.formula.field.label")}</th>
                                <!-- 数据唯一 -->
                                <th id="uniqueFlagTH">${ctp:i18n("form.data.uniqueFlag.lable")}</th>
                            </c:if>
                            <c:if test="${formBean.formType!=2 && formBean.formType!=3}">
                                <!-- 计算公式 -->
                                <th id="formulaTH">${ctp:i18n("form.baseinfo.formula.field.label")}</th>
                            </c:if>
                             <c:if test="${formBean.govDocFormType==5 || formBean.govDocFormType==6 || formBean.govDocFormType==7 || formBean.govDocFormType==8}">
                                 <th id="">映射字段</th>
                             </c:if>
                             <c:if test="${formBean.govDocFormType==5 || formBean.govDocFormType==6 || formBean.govDocFormType==7 || formBean.govDocFormType==8}">
                                 <th id="">字段ID</th>
                             </c:if>
                        </tr>
                        </thead>
                    <tbody id="formTbody">
                        <c:set value="${(formBean.formType == 2 || formBean.formType == 3) ? '55%' : '100%'}" var="_formatTypeWidth" />
                        <c:forEach items="${needInitField}" var="field" varStatus="status">
                            <tr id="${field.name}tr"  index="${status.index}">
                            	<td id="serialnumberTD">${status.count}</td>
                            	<td id="DataDefineNameTD">
                                    <font class="left hand" style="word-break:break-all;" title="${field.display}" onclick="designLinkageField('${field.name}')">[<c:if test="${field.masterField}">${ctp:i18n("form.base.mastertable.label")}</c:if><c:if test="${!field.masterField}">${ctp:i18n("formoper.dupform.label")}${field.extraMap.subTableIndex}</c:if>]&nbsp;${field.display}</font>
                                    <span style="display:none;" id="fieldName${status.index}" needCheckData="${field.extraMap.needCheckData}" name="fieldName${status.index}" value="${field.name}" display="${field.display}" isMasterField="${field.masterField}" subTableIndex="${field.extraMap.subTableIndex}" tableName="${field.ownerTableName}"></span>
                                </td>
                                <td id="inputtypeTD">
                                	<select <c:if test="${(formBean.govDocFormType==5 || formBean.govDocFormType==6 || formBean.govDocFormType==7 || formBean.govDocFormType==8) && field.mappingField!=null && field.mappingField!=''}">disabled='disabled'</c:if> id="inputType${status.index}" oldInputType="${field.inputType}" name="inputType${status.index}" formulaIndex="inputType${field.id}" onchange="confirmChangeInput('${status.index}');" style="width:75%">
                                        <c:forEach items="${inputTypeMap}" var="group">
                                        	<optgroup label="${group.key}">
                                        		<c:forEach items="${group.value}" var="inputType">
                                                    <!-- 1.流程表单没有外部写入和外部预写。2.重表字段没有单选和签章3.重表字段没有流程处理意见控件4.主表字段没有重复表序号控件 -->
                                                    <c:if test="${!(formBean.formType==1 && (inputType.key=='outwrite' || inputType.key=='externalwrite-ahead')) && !(!field.masterField && (inputType.key =='edocDocMark'||inputType.key=='edocflowdealoption'||inputType.key =='edocSignMark'||inputType.key =='edocInnerMark'||inputType.key=='radio' || inputType.key=='handwrite' || inputType.key=='flowdealoption')) && !(field.masterField && inputType.key=='linenumber')}">
                                                        <option title="${inputType.text}" extend="${inputType.canExtend}" inputCategory="${inputType.category.key}" value="${inputType.key}" <c:if test="${(field.inputType==inputType.key)}">selected="selected"</c:if>>${inputType.text}</option>
                                                    </c:if>
                                                </c:forEach>
                                            </optgroup>
                                        </c:forEach>
                                    </select>
                                    <input type="text" id="selectBindInput${status.index}" fieldStr=""
                                    maxLevel="${field.extraMap.maxlevel}" enumType="${field.extraMap.enumType}" hasMoreLevel="${field.extraMap.hasmorelevel}"
                                     name="selectBindInput${status.index}" readonly="readonly" class="validate"
                                    <c:if test="${field.inputType=='customcontrol'}">value="${field.formFieldExtend.name}" validate = "" </c:if><c:if test="${field.inputType=='select' || field.inputType=='radio'}">value="${field.extraMap.enumName}" validate="name:'${ctp:i18n("form.field.bindenum.title.label")}',notNull:true" </c:if><c:if test="${field.inputType == 'relationform'}"> validate="type:'string',name:'${ctp:i18n('form.base.relation.field.label')}',notNull:true"</c:if><c:if test="${field.inputType == 'relationform' || field.inputType == 'exchangetask' || field.inputType == 'querytask'}">value="${field.formRelation.extraMap.toRelationObj}"</c:if>
                                     onclick="selectFieldBind(${status.index},true);" 
                                    style="cursor:pointer;width:15%;<c:if test="${field.inputType != 'relationform' && field.inputType != 'exchangetask' && field.inputType != 'querytask' && field.inputType != 'customcontrol' && field.inputType != 'select'&& field.inputType != 'radio'}"> display:none</c:if>" />
                                    <input type="hidden" id="bindSetAttr${status.index}" name="bindSetAttr${status.index}" relObjId="${field.formRelation.toRelationObj}" value='${field.extraMap.bindSetAttrValue}' selectType="${field.formRelation.viewSelectType}" enumId="${field.enumId}" isFinalChild="${field.isFinalChild}" bindObjId="${field.formRelation.toRelationObj}" bindAttr="${field.formRelation.viewAttr}" relationAttrType="${field.formRelation.toRelationAttrType}" viewCondition="${field.formRelation.extraMap.formulaStr}" viewAttr="${field.formRelation.viewAttr}" tableName="${field.formRelation.extraMap.tableName}" isMaster="${field.formRelation.extraMap.relationFieldType}" formatEnumId="${field.formatEnumId}" formatEnumIsFinalChild="${field.formatEnumIsFinalChild}" formatEnumLevel="${field.formatEnumLevel}" imageEnumFormat="${field.imageEnumFormat}"/>
                                 </td>
                                 <td id="fieldtypeTD">
                                    <c:choose> 
		                             <c:when test="${field.mappingField == 'copies' }">
		                             	<select id="fieldType${status.index}" oldFieldType="${field.fieldType}" formulaIndex="fieldType${field.id}" name="fieldType${status.index}" onchange="confirmChangeField('${status.index}');" style="width:74px">
                                        <c:forEach items = "${field.extraMap.fieldTypeArray}" var = "fieldType">
                                        	<c:if test="${fieldType.key == 'DECIMAL'}">
                                            	<option value="${fieldType.key}" <c:if test="${(field.fieldType==fieldType.key)}">selected="selected"</c:if> >
                                            	${fieldType.text}
                                            	</option>
                                            </c:if>
                                        </c:forEach>
                                    </select>
									 </c:when>
									 <c:otherwise>
									 	<select id="fieldType${status.index}" oldFieldType="${field.fieldType}" formulaIndex="fieldType${field.id}" name="fieldType${status.index}" onchange="confirmChangeField('${status.index}');" style="width:74px">
                                        <c:forEach items = "${field.extraMap.fieldTypeArray}" var = "fieldType">
                                            <option value="${fieldType.key}" <c:if test="${(field.fieldType==fieldType.key)}">selected="selected"</c:if> >
                                            ${fieldType.text}
                                            </option>
                                        </c:forEach>
                                    </select> 
									 </c:otherwise>
		                             </c:choose> 
                                    <c:if test="${field.fieldType == 'DECIMAL'}">
                                    <input type="text" id="fieldLength${status.index}" oldFieldLength="${field.fieldLength}" name="fieldLength${status.index}"  <c:if test="${field.inputType == 'relation' || field.inputType == 'relationform' }">readonly = "readonly"</c:if> value="${field.fieldLength}" class="width_30 validate comp" validate="name:'${ctp:i18n('form.field.digit.length.label')}',notNull:true,isInteger:true,minValue:1,maxValue:30" comp="type:'onlyNumber',numberType:'int'" <c:if test="${!field.extraMap.disLength}"> style="display:none" </c:if> onblur="confirmChangeFieldLength('${status.index}')" title="${ctp:i18n('form.field.length')}" />
                                    </c:if>
                                    <c:if test="${field.fieldType == 'VARCHAR'}">
                                    <input type="text" id="fieldLength${status.index}" oldFieldLength="${field.fieldLength}" name="fieldLength${status.index}" <c:if test="${field.inputType == 'relation' || field.inputType == 'relationform' }">readonly = "readonly"</c:if> value="${field.fieldLength}" class="width_30 validate comp" validate="name:'${ctp:i18n('form.field.string.length.label')}',notNull:true,isInteger:true,minValue:1,maxValue:4000" comp="type:'onlyNumber',numberType:'int'" <c:if test="${!field.extraMap.disLength}"> style="display:none" </c:if> onblur="confirmChangeFieldLength('${status.index}')" title="${ctp:i18n('form.field.length')}" />
                                    </c:if>
                                    <c:if test="${field.fieldType != 'DECIMAL' && field.fieldType != 'VARCHAR'}">
                                    <input type="text" id="fieldLength${status.index}" oldFieldLength="${field.fieldLength}" name="fieldLength${status.index}" <c:if test="${field.inputType == 'relation' || field.inputType == 'relationform' }">readonly = "readonly"</c:if> value="${field.fieldLength}" class="width_30 validate comp"  comp="type:'onlyNumber',numberType:'int'" <c:if test="${!field.extraMap.disLength}"> style="display:none" </c:if> onblur="confirmChangeFieldLength('${status.index}')" title="${ctp:i18n('form.field.length')}" />
                                    </c:if>
                                    <input type="text" id="digitNum${status.index}" oldDigitNum="${field.digitNum}"   name="digitNum${status.index}" <c:if test="${field.inputType == 'relationform'}"> readonly = "readonly"</c:if> <c:if test="${field.inputType == 'relation'}"> style="display:none" </c:if> value="${field.digitNum}" onblur="confirmChangeFieldDigitNum('${status.index}')" class="width_30 validate comp"  comp="type:'onlyNumber',numberType:'int'"  
                                    <c:if test="${!(field.fieldType == 'DECIMAL' && field.inputType != 'select' && field.inputType != 'radio' && !(field.inputType == 'relation' && (field.formRelation.toRelationAttrType == 3 || field.formRelation.toRelationAttrType == 9))) || field.inputType == 'linenumber'}">style="display:none"</c:if> 
                                    validate="name:'${ctp:i18n("form.serailNumberLength.label")}',isInteger:true,minValue:0,maxValue:10" title="${ctp:i18n('form.field.digitNum.length')}"/>
                                 </td>
                                 <td id="relationObjectTD">
                                    <c:if test="${field.inputType == 'externalwrite-ahead'}">
                                    <select id="refInputName${status.index}" name="refInputName${status.index}" onchange="changeRefInputName('${status.index}');" style="width:100px;"  class="validate" validate="name:'${ctp:i18n("form.input.relationObject.label")}',notNull:true">
                                        <option value=""></option>
                                        <c:forEach items="${outWriteFieldList}" var="outWrite">
                                            <c:if test="${field.ownerTableName == outWrite.ownerTableName}">
                                            <option value="${outWrite.name}" <c:if test="${field.refInputName == outWrite.name}">selected</c:if>>${outWrite.display}</option>
                                            </c:if>
                                        </c:forEach>
                                    </select>
                                    </c:if>
                                    <c:if test="${field.inputType != 'externalwrite-ahead'}">
                                    <select id="refInputName${status.index}" oldRefInputName="${field.formRelation.toRelationAttr}" name="refInputName${status.index}" onchange="changeRefInputName('${status.index}');" <c:if test="${field.inputType == 'externalwrite-ahead' || field.inputType == 'relation'}">style="width:100px;"</c:if> <c:if test="${field.inputType != 'externalwrite-ahead' && field.inputType != 'relation'}">style="width:100px;display:none;"</c:if>  class="validate" validate="name:'${ctp:i18n("form.input.relationObject.label")}',notNull:true">
                                        <c:if test="${fn:length(field.extraMap.refOptions) == 0}">
                                        <option value=""></option>
                                        </c:if>
                                        ${field.extraMap.refOptions}
                                    </select>
                                    </c:if>
                                  </td>
                                  <td id="relationTD">
                                        <!--xuker add && field.formRelation.toRelationAttrType != 11 20160328 field.formRelation.toRelationAttrType != 12 20160405-->
                                        <select id="refInputAttr${status.index}" oldRefInputAttr="${field.formRelation.viewAttr}" name="refInputAttr${status.index}" onchange="changeRefInputAttr('${status.index}');" <c:if test="${field.inputType == 'relation' && (field.formRelation.toRelationAttrType == 1 || field.formRelation.toRelationAttrType == 4 || field.formRelation.toRelationAttrType == 7 || field.formRelation.toRelationAttrType == 8)}">style="width:100px;"</c:if> <c:if test="${field.inputType != 'relation' || (field.formRelation.toRelationAttrType != 1 && field.formRelation.toRelationAttrType != 4 && field.formRelation.toRelationAttrType != 7 && field.formRelation.toRelationAttrType != 8 && field.formRelation.toRelationAttrType != 9&& field.formRelation.toRelationAttrType != 11&& field.formRelation.toRelationAttrType != 12)}">style="width:100px;display:none;"</c:if>   class="validate" validate="name:'${ctp:i18n("form.create.input.relation.att.label")}',notNull:true">
                                        <c:if test="${fn:length(field.extraMap.refAttrOptions) == 0}">
                                        <option value=""></option>
                                        </c:if>
                                        ${field.extraMap.refAttrOptions}
                                        </select>&nbsp;
                                  </td>
                                  <td id="displayformatTD">
                                        <select id="formatType${status.index}" oldFormatType="${field.formatType}" name="formatType${status.index}"  <c:if test="${field.extraMap.disFormat == null || field.extraMap.disFormat == '' || field.inputType == 'relationform' || (field.inputType == 'relation')}">style="width:${_formatTypeWidth};display:none"</c:if> <c:if test="${!(field.extraMap.disFormat == '' || field.inputType == 'relationform' || (field.inputType == 'relation'))}">style="width:${_formatTypeWidth};"</c:if> onchange="confirmChangeFormatType('${status.index}');" >
                                        ${field.extraMap.disFormat}
                                        </select>
                                        <c:if test="${formBean.formType==2 || formBean.formType==3}">
                                        <input name="formatEnum${status.index}" type="text" readonly="readonly" class="validate" onclick="bindOutWriterEnum(${status.index})" validate="name:'${ctp:i18n("form.formenum.enumvaluebind")}',notNull:true" id="formatEnum${status.index}"  style="width: 40%; <c:if test="${field.extraMap.showName == false}">display: none; </c:if> cursor: pointer;" value="${field.extraMap.formatEnumName }"/>
                                        </c:if>
                                   </td>
                                   <td id="formulaTD">
                                        <div class="common_form_wrap">
                                            <textarea id="formulaData${status.index}" name="formulaData${status.index}" style="display:none;">
                                            ${field.formulaData}
                                            </textarea>
                                        <input type="text" id="formula${status.index}" isAdvance="${field.isAdvance}" name="formula${status.index}"  <c:if test="${field.isAdvance != 1}"> value="${field.ordinaryFormula}"</c:if> <c:if test="${field.isAdvance == 1}"> value="${ctp:i18n('form.formula.advance.hasset.laebl')}"</c:if> readonly="readonly" 
                                        onClick="javascript:setFieldFormula('${field.name}','${status.index}');" <c:if test="${!field.extraMap.disFormula}">style="width:80%;cursor:pointer;display:none"</c:if> <c:if test="${field.extraMap.disFormula}">style="width:80%;cursor:pointer;"</c:if>/>
                                        <a id="advance${status.index}" name="advance${status.index}" onClick="javascript:setFieldFormula('${field.name}','${status.index}');" <c:if test="${field.isAdvance != 1}"> style="display:none;" </c:if>><span class="ico16 advanced_16"></span></a>
                                        </div>
                                    </td>
                                    <c:if test="${formBean.formType==2 || formBean.formType==3}">
                                    <td id="uniqueFlagTD">
                                        <input id="isUnique${status.index}" name="isUnique${status.index}" onclick="uniqueDataClick('${status.index}')" class="radio_com" value="1" type="checkbox" <c:if test="${field.unique==true}">checked="checked"</c:if> /></td>
                                    </c:if>
                                    <c:if test="${formBean.govDocFormType==5 || formBean.govDocFormType==6 || formBean.govDocFormType==7 || formBean.govDocFormType==8}">
                                    <td id="">
                                        <input <c:if test="${!field.masterField}">disabled="disabled"</c:if> onClick="javascript:mappingFieldFunc(this,'${status.index}');" selectCode="${field.mappingField }" id="mappingField${status.index}" name="mappingField${status.index}" style="width:80%;cursor:pointer;" type="text" readonly="readonly" value="${field.mappingField }"/></td>
                                    </c:if>
                                    <c:if test="${formBean.govDocFormType==5 || formBean.govDocFormType==6 || formBean.govDocFormType==7 || formBean.govDocFormType==8}">
                                    <td id="">
                                        ${field.name }
                                    </td>
                                    </c:if>
                                </tr>
                           </c:forEach>
                           </tbody>
                </table>
                </div>
                </form>
            </div>
           
            <div class="layout_south over_hidden" id="south" layout="height:300,maxHeight:500,minHeight:30,sprit:true,border:true,spiretBar:{show:true,handlerB:mixContent,handlerT:maxContent}">
                <div class="">
                    <div id="formContent" class="absolute" style="overflow:hidden;bottom:40px; top:0;width:100%;">
                        <iframe id="viewFrame" src="" frameborder="0" style="width: 100%;height:100%" class=""></iframe>
                    </div>
                    <div class="page_color align_right absolute" style="width:100%;height:40px;overflow:hidden;bottom:0;">
                        <%@ include file="bottom.jsp" %>
                    </div>
                </div>
            </div>
        </div>
    </body>
    <script type="text/javascript">
    var thNumber = $("#formTable th").size();
    var thWidth = 1/thNumber;
    $("#formTable th").width(parseInt(thWidth* 100)+"%");
    function mappingFieldFunc(inputObj,indexC){
    	inputObj.focus();
		var dialog = $.dialog({
			url:_ctxPath + "/form/fieldDesign.do?method=designMappingField&fieldName="+$(inputObj).attr("value"),
		    title : "公文元素",//设置表单所属人
		    width:600,
			height:400,
			targetWindow:getCtpTop(),
			transParams:window,
		    buttons : [{
		    	text : $.i18n('collaboration.button.ok.label'),//确定
		    	id:"sure",
		    	handler : function() {
		    		var v = dialog.getReturnValue();
		    		if(v) {
		    			if($("#inputType" + indexC).attr("oldinputtype") == "edocDocMark"
		    					&& v.inputType!="doc_mark") {
			    			alert("公文文号解除元素doc_mark映射，公文文号不能正常使用，请确认!");
			    			return;
			    		}
			    		if($("#inputType" + indexC).attr("oldinputtype") == "edocInnerMark"
			    				&& v.inputType!="serial_no") {
			    			alert("内部文号解除元素serial_no映射，内部文号不能正常使用，请确认!");
			    			return;
			    		}
			    		if($("#inputType" + indexC).attr("oldinputtype") == "edocSignMark"
		    				&& v.inputType!="sign_mark") {
		    				alert("签收编号解除元素sign_mark映射，签收编号不能正常使用，请确认!");
		    				return;
		    			}
			    		
		    			var manager = new formFieldDesignManager();
		    			var ret = manager.getGovDocFieldType(v);
		    			//如果修改的不是同一个枚举，并且已经产生了数据，就提示不能修改。
		    			var oldInputType = $("#inputType"+indexC).val();
		    			var oldFieldType = $("#fieldType"+indexC).val();
		    			if(ret!=null && ret.inputType!=null && (oldInputType!=ret.inputType || oldFieldType!=ret.fieldType ||(oldInputType=="select"&&ret.enumParam != $("#bindSetAttr"+indexC).attr("enumId")))){
			    			var options = getValidateFieldOptions(indexC);
			    			var fdManager = new formFieldDesignManager();
			    			var result = fdManager.validateFormFieldData2(options);
		    				if(result == "1"){
			    				$.alert($.i18n('form.base.dataform.fieldtype.error.label'));
					    		dialog.close();
								return;
		    				}
		    			}
		    			if(ret!=null && ret.inputType!=null){
		    				$("#mappingField"+indexC).attr("selectCode",v);
		    				setMappingAttr(indexC,ret);
		    				$("#inputType"+indexC).val(ret.inputType);
		    				confirmChangeInput(indexC);
		    			}
		    		}
		    		dialog.close();
		    	}
		    }, {
		    	text : $.i18n('govdoc.quxiao.select.label'),
		    	id:"exit",
		    	handler : function() {
		    		if($("#inputType" + indexC).attr("oldinputtype") == "edocDocMark") {
		    			alert("公文文号解除元素doc_mark映射，公文文号功能不能正常使用，请确认!");
		    			return;
		    		}
		    		if($("#inputType" + indexC).attr("oldinputtype") == "edocInnerMark") {
		    			alert("内部文号解除元素serial_no映射，内部文号不能正常使用，请确认!");
		    			return;
		    		}
		    		if($("#inputType" + indexC).attr("oldinputtype") == "edocSignMark") {
	    				alert("签收编号解除元素sign_mark映射，签收编号不能正常使用，请确认!");
	    				return;
	    			}
		    		
		    		dialog.close(); 
		    		$("#mappingField"+indexC).attr("selectCode","");
		    		setMappingAttr(indexC);
		    		$(inputObj).val("");
		    		$("#inputType"+indexC).removeAttr("disabled");
		    		var param = getUpdateFormFieldParam(indexC);
		 			param.mappingField = $(inputObj).val();
		 			var fdManager = new formFieldDesignManager();
		 			fdManager.updateMappingChange(param);
		    	}
		    }, {
		    	text : $.i18n('collaboration.button.close.label'),
		    	id:"cansl",
		    	handler : function() {
		    		dialog.close();
		    	}
		    }]
		});
    }
    function setMappingAttr(index,fieldTypeObj){
    	var o = $("#mappingField"+index);
    	o.attr("enumId","");
    	o.attr("enumName","");
    	if(fieldTypeObj!=null && fieldTypeObj.inputType!=null){
    		o.attr("enumId",fieldTypeObj.enumParam);
        	o.attr("enumName",fieldTypeObj.enumName);
    	}
    }
    $(function(){
        formatTable()
    })
    </script>
</html>