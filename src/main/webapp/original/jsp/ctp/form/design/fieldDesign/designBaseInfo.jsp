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
    </head>
    <body class="page_color font_size12" onload="closeProgressBar()">
    <input type="button" name="test" value="test" onclick="showIt()" class="hidden">
        <div id='layout' class="comp" comp="type:'layout'">

            <!--向导菜单-->
            <div class="layout_center bg_color_white" id="center" style="overFlow-y: hidden">
            <form class="display_block h100b" id="baseInfoForm" name="baseInfoForm" method="post" action="${path}/form/fieldDesign.do?method=saveBaseInfo" >
                <input type="hidden" name="url" id="url" value="">
                <div class="form_area margin_l_10 margin_b_10 margin_r_10" id="center1" style="min-width: 1040px;">
                    <table border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td nowrap="nowrap">
                                <!-- 表单名称 -->
                                <label for="text">${ctp:i18n("form.base.formname.label")}：</label>
                            </td>
                            <td nowrap="nowrap">
                            <%--<div class="common_txtbox_wrap"> --%>
                                <input type="text" id="formName" name="formName" title="${formBean.formName}" value="${formBean.formName}" onchange="formNameBlur(this)" maxlength="85" class="validate padding_l_5" validate="avoidChar:'\\/|<>:*?;\'&%$#&#34;',notNullWithoutTrim:true,type:'string',name:'${ctp:i18n("form.base.formname.label")}',notNull:true,maxLength:255"/>
                            <%--</div>--%>
                            </td>
                            <td nowrap="nowrap">
                                <!-- 所属应用 -->
                                <label class="margin_l_10" for="text">${ctp:i18n("form.app.affiliatedapply.label")}：</label>
                            </td>
                            <td <c:if test="${formType_processesForm eq formBean.formType}">width="130"</c:if><c:if test="${formType_processesForm ne formBean.formType}">width="200"</c:if> nowrap="nowrap">
                                <select id="categoryId" name="categoryId" class="w100b validate" <c:if test="${formType_processesForm eq formBean.formType}">style="width: 130px;"</c:if><c:if test="${formType_processesForm ne formBean.formType}">style="width: 200px;"</c:if> onmouseover="this.title=this.options[this.selectedIndex].text;" validate="name:'${ctp:i18n("form.app.affiliatedapply.label")}',notNull:true">
                                  ${formTemplateCategorys}
                                </select>
                            </td>
                            <td nowrap="nowrap">
                                <!-- 所属人 -->
                                <label class="margin_l_10 " for="text">${ctp:i18n("form.base.affiliatedsortperson.label")}：</label>
                            </td>
                            <td width="50" nowrap="nowrap">
                                <input type="text" id="ownerName" name="ownerName" class="padding_l_5" readonly="readonly" value="${ctp:showMemberNameOnly(ownerId)}" <c:if test="${formType_processesForm eq formBean.formType}">style="width: 60px;"</c:if> />
                            </td>
                            <td>
                                <!-- 设置 -->
                                <a id="setOwnerBtn" class="common_button common_button_gray margin_l_10" href="javascript:void(0)" title="${ctp:i18n("form.extend.show.set.lable")}">${ctp:i18n("form.extend.show.set.lable")}</a>
                                <input type="hidden" id="ownerId" name="ownerId" readonly="readonly" value="${ownerId}"/>
                                <input type="hidden" id="ownerAccountId" name="ownerAccountId" readonly="readonly" value="${ownerAccountId}"/>
                            </td>
                            <td nowrap="nowrap">
                                <!-- 表单状态 -->
                                <label class="margin_l_10" for="text">${ctp:i18n("form.operhigh.formstate.label")}：</label>
                            </td>
                            <td width="50" nowrap="nowrap">
                                <input type="text" id="state" name="state" readonly="readonly" class="disabled_color padding_l_5" value="${formBean.extraMap.state}" <c:if test="${formType_processesForm eq formBean.formType}">style="width: 60px;"</c:if> />
                            </td>
                            <td nowrap="nowrap">
                                <c:if test="${formType_processesForm eq formBean.formType and isAdvanced eq true and (ctp:hasPlugin('formBiz') or ctp:hasPlugin('formBizModify')) }">
                                    <!-- 回写设置 -->
                                    <a id="setWriteBtn" class="common_button common_button_gray margin_l_10" href="javascript:void(0)" title="${ctp:i18n("form.echoSetting.label")}">${ctp:i18n("form.echoSetting.label")}</a>
                                </c:if>
                                <c:if test="${formType_processesForm ne formBean.formType}">
                                    <!-- 唯一标示 -->
                                    <a id="setUniqueMarkBtn" class="common_button common_button_gray margin_l_10" href="javascript:void(0)" title="${ctp:i18n("form.unique.marked.label")}">${ctp:i18n("form.unique.marked.label")}</a>
                                    <input type="hidden" id="uniquedatafield" name="uniquedatafield" value="${uniquedatafield}"/>
                                </c:if>
                            </td>
                            <c:if test="${isAdvanced eq true}">
                            <td nowrap="nowrap">
                                <input type="hidden" id="checkRule" name="checkRule" <c:if test="${formBean.extraMap.advanceCheckRule == 1}"> value="${ctp:i18n('form.formula.advance.hasset.laebl')}"</c:if> <c:if test="${formBean.extraMap.advanceCheckRule != 1}"> value="${formBean.extraMap.checkRule}"</c:if> />
                                <textarea id="checkRuleData" name="checkRuleData" style="display: none;">${formBean.extraMap.checkRuleData}</textarea>
                                <input type="hidden" id="checkRuleDescription" name="checkRuleDescription" value="${formBean.extraMap.description}" />
                                <!-- 强制校验 -->
                                <input type="hidden" id="forceCheck" name="forceCheck" value="${formBean.extraMap.forceCheck}"/>
                                <!-- 高级校验规则 -->
                                <input type="hidden" id="advanceCheckRule" name="advanceCheckRule" value="${formBean.extraMap.advanceCheckRule}"/>
                                <!-- 校验规则 -->
                                <a id="setCheckRule" class="common_button common_button_gray margin_l_10" href="javascript:void(0)" title="${ctp:i18n("form.baseinfo.checkRule.label")}">${ctp:i18n("form.baseinfo.checkRule.label")}
                                <span id="checkRuleImg" class="ico16 advanced_16" <c:if test="${formBean.extraMap.checkRuleData == '' || formBean.extraMap.checkRuleData == null }">style="display:none"</c:if>></span>
                                </a>
                            </td>
                            </c:if>
                            <!-- infopath表单才显示移动设计器-->
                            <c:if test="${formBean.formType eq 5  and formBean.infoPathForm}">
                                <td nowrap="nowrap">
                                    <a id="setFormStyleBtn" class="common_button common_button_gray margin_l_10" href="javascript:void(0)"><em class='ico16 formPhone_16'></em>移动设计器</a>
                                </td>
                            </c:if>
                            <c:if test="${formType_processesForm eq formBean.formType and isAdvanced eq true}">
                            <td nowrap="nowrap">
                                <!-- 上传正文模板 -->
                                <input type="hidden" id="templateFileId" name="templateFileId" value="${formBean.templateFileId}"/>
                                <input type="hidden" id="templateFileName" name="templateFileName" value="${formBean.templateFileName}"/>
                                <a id="uploadTemplate" title="${ctp:i18n("form.baseinfo.uploadtemplate.label")}" class="common_button common_button_gray margin_l_10" href="javascript:void(0)">${ctp:i18n("form.baseinfo.uploadtemplate.label")}</a>
                            </td>
                            <td nowrap="nowrap" id="templateTd">
                                <div style="margin-left: 10px;">
                                    <div class="comp" attsdata='[${attachmentsJSON}]' comp="type:'fileupload',applicationCategory:'1',displayMode:'visible',canDeleteOriginalAtts:'true',extensions:'doc,docx,wps',quantity:1,isEncrypt:false,firstSave:true,embedInput:'officedoc',attachmentTrId:'${subReference}',takeOver:'false',callMethod:'uploadTemplate',delCallMethod:'delUploadTemplate'">
                                    </div>
                                </div>
                            </td>
                            </c:if>
                        </tr>
                    </table>
                </div>
                   
                <div style="overflow-x:auto;overflow-y:scroll;" id = "centerList">
                <table id="formTable" border="0" cellspacing="0"  cellpadding="0" class="form_area only_table edit_table margin_l_10" style="width:98%;">
                <thead>
                    <tr>
                        <!-- 序号 --><th id="serialnumberTH" style="width: 4%">${ctp:i18n("form.input.serialnumber.label")} </th>
                        <!-- 名称 -->
                        <th id="DataDefineNameTH" style="width: 12%">${ctp:i18n("DataDefine.Name")} </th>
                        <!-- 录入类型 -->
                        <th id="inputtypeTH" style="width: 18%">${ctp:i18n("form.inputtype.label")} </th>
                        <c:if test="${formBean.formType==2 || formBean.formType==3}">
                        <!-- 字段类型 -->
                        <th id="fieldtypeTH"  style="width: 15%">${ctp:i18n("form.base.fieldtype.label")} </th>
                        </c:if>
                        <c:if test="${formBean.formType!=2 && formBean.formType!=3}">
                        <!-- 字段类型 -->
                        <th id="fieldtypeTH"  style="width: 19%">${ctp:i18n("form.base.fieldtype.label")} </th>
                        </c:if>
                        <!-- 关联对象 -->
                        <th id="relationObjectTH" style="width: 10%">${ctp:i18n("form.input.relationObject.label")}</th>
                        <!-- 关联属性 -->
                        <th id="relationTH" style="width: 11%">${ctp:i18n("form.create.input.relation.att.label")}</th>
                        <!-- 显示格式 -->
                        <c:if test="${formBean.formType==2 || formBean.formType==3}">
                            <th id="displayformatTH" style="width: 13%">${ctp:i18n("form.input.displayformat.label")}</th>
                        </c:if>
                        <c:if test="${formBean.formType!=2 && formBean.formType!=3}">
                            <th id="displayformatTH" style="width: 11%">${ctp:i18n("form.input.displayformat.label")}</th>
                        </c:if>
                        <c:if test="${formBean.formType==2 || formBean.formType==3}">
                            <!-- 计算公式 -->
                            <th id="formulaTH" style="width: 12%">${ctp:i18n("form.baseinfo.formula.field.label")}</th>
                            <!-- 数据唯一 -->
                            <th id="uniqueFlagTH" style="width: 5%">${ctp:i18n("form.data.uniqueFlag.lable")}</th>
                        </c:if>
                        <c:if test="${formBean.formType!=2 && formBean.formType!=3}">
                            <!-- 计算公式 -->
                            <th id="formulaTH" style="width: 15%">${ctp:i18n("form.baseinfo.formula.field.label")}</th>
                        </c:if>
                    </tr>
                </thead>
                <tbody id="formTbody">
                    <c:set value="${(formBean.formType == 2 || formBean.formType == 3) ? '55%' : '100%'}" var="_formatTypeWidth" />
                    <c:forEach items="${needInitField}" var="field" varStatus="status">
                        <tr id="${field.name}tr"  index="${status.index}">
                            <!--序号-->
                            <td id="serialnumberTD">${status.count}</td><td id="DataDefineNameTD"><!--名称--><label class="left hand" style="word-break:break-all;" title="${field.display}" onclick="designLinkageField('${field.name}')">[<c:if test="${field.masterField}">${ctp:i18n("form.base.mastertable.label")}</c:if><c:if test="${!field.masterField}">${ctp:i18n("formoper.dupform.label")}${field.ownerTableIndex}</c:if>]&nbsp;${field.display}</label>
                                <span style="display:none;" id="fieldName${status.index}" needCheckData="${field.extraMap.needCheckData}" name="fieldName${status.index}" value="${field.name}" display="${field.display}" isMasterField="${field.masterField}" subTableIndex="${field.ownerTableIndex eq 0?null:field.ownerTableIndex}" tableName="${field.ownerTableName}"></span>
                                <%-- IE9下TABLE中TD错位，这里在td标签和select标签之间不换行了，这是IE9的bug，先这么处理吧！--%>
                            </td><td id="inputtypeTD"><!--录入类型--><select id="inputType${status.index}" tagIndex="${status.index}" oldInputType="${field.inputType}" name="inputType${status.index}" formulaIndex="inputType${field.id}" onchange="confirmChangeInput('${status.index}');" style="width:65%">
                                    <c:forEach items="${inputTypeMap}" var="group">
                                        <optgroup label="${group.key}">
                                            <c:forEach items="${group.value}" var="inputType">
                                                <!-- 1.流程表单没有外部写入和外部预写。2.重表字段没有单选和签章3.重表字段没有流程处理意见控件4.主表字段没有重复表序号控件 -->
                                                <c:if test="${!(formBean.formType==1 && (inputType.key=='outwrite' || inputType.key=='externalwrite-ahead')) && !(!field.masterField && (inputType.key=='radio' || inputType.key=='handwrite' || inputType.key=='flowdealoption')) && !(field.masterField && inputType.key=='linenumber')}">
                                                    <option title="${inputType.text}" extend="${inputType.canExtend}" inputCategory="${inputType.category.key}" value="${inputType.key}" <c:if test="${(field.inputType==inputType.key)}">selected="selected"</c:if>>${inputType.text}</option>
                                                </c:if>
                                            </c:forEach>
                                        </optgroup>
                                    </c:forEach>
                                    <c:if test="${ctp:hasPlugin('vjoin') && (formBean.formType == 1 || formBean.formType == 2 || formBean.formType == 3)}">
                                        <optgroup label="${ctp:i18n('vjoin.form.input.inputtypecatg')}">
                                            <option title="${ctp:i18n('vjoin.form.input.extend.selectJoinMember.label')}" extend="true" inputCategory="org" externalType="1" value="member" <c:if test="${field.inputType == 'member' && field.externalType == '1'}">selected="selected"</c:if>>${ctp:i18n('vjoin.form.input.extend.selectJoinMember.label')}</option>
                                            <option title="${ctp:i18n('vjoin.form.input.extend.selectJoinAccount.label')}" extend="true" inputCategory="org" externalType="2" value="department" <c:if test="${field.inputType == 'department' && field.externalType == '2'}">selected="selected"</c:if>>${ctp:i18n('vjoin.form.input.extend.selectJoinAccount.label')}</option>
                                            <option title="${ctp:i18n('vjoin.form.input.extend.selectJoinOrganization.label')}" extend="true" inputCategory="org" externalType="1" value="department" <c:if test="${field.inputType == 'department' && field.externalType == '1'}">selected="selected"</c:if>>${ctp:i18n('vjoin.form.input.extend.selectJoinOrganization.label')}</option>
                                            <option title="${ctp:i18n('vjoin.form.input.extend.selectJoinPost.label')}" extend="true" inputCategory="org" externalType="1" value="post" <c:if test="${field.inputType == 'post' && field.externalType == '1'}">selected="selected"</c:if>>${ctp:i18n('vjoin.form.input.extend.selectJoinPost.label')}</option>
                                        </optgroup>
                                    </c:if>
                                </select>
                                <input type="hidden" id="externalType${status.index}" name="externalType${status.index}" value='${field.externalType}' />
                                <input type="text" id="selectBindInput${status.index}" fieldStr=""
                                maxLevel="${field.extraMap.maxlevel}" enumType="${field.extraMap.enumType}" hasMoreLevel="${field.extraMap.hasmorelevel}"
                                 name="selectBindInput${status.index}" readonly="readonly" class="validate"
                                <c:if test="${field.inputType=='customcontrol'}">value="${field.formFieldExtend.name}" validate = "" </c:if><c:if test="${field.inputType=='select' || field.inputType=='radio'}">value="${fn:escapeXml(field.extraMap.enumName)}" validate="name:'${ctp:i18n("form.field.bindenum.title.label")}',notNull:true" </c:if><c:if test="${field.inputType == 'relationform'}"> validate="type:'string',name:'${ctp:i18n('form.base.relation.field.label')}',notNull:true"</c:if><c:if test="${field.inputType == 'relationform' || field.inputType == 'exchangetask' || field.inputType == 'querytask'}">value="${field.formRelation.extraMap.toRelationObj}"</c:if>
                                 onclick="selectFieldBind(${status.index},true);"
                                style="cursor:pointer;width:20%;<c:if test="${field.inputType != 'relationform' && field.inputType != 'exchangetask' && field.inputType != 'querytask' && field.inputType != 'customcontrol' && field.inputType != 'select'&& field.inputType != 'radio'}"> display:none</c:if>" />
                                <input type="hidden" id="bindSetAttr${status.index}" name="bindSetAttr${status.index}" relObjId="${field.formRelation.toRelationObj}" value='${field.extraMap.bindSetAttrValue}' selectType="${field.formRelation.viewSelectType}" enumId="${field.enumId}" isFinalChild="${field.isFinalChild}" bindObjId="${field.formRelation.toRelationObj}" bindAttr="${field.formRelation.viewAttr}" relationAttrType="${field.formRelation.toRelationAttrType}" viewCondition="${field.formRelation.extraMap.formulaStr}" viewAttr="${field.formRelation.viewAttr}" tableName="${field.formRelation.extraMap.tableName}" isMaster="${field.formRelation.extraMap.relationFieldType}" formatEnumId="${field.formatEnumId}" formatEnumIsFinalChild="${field.formatEnumIsFinalChild}" formatEnumLevel="${field.formatEnumLevel}" imageEnumFormat="${field.imageEnumFormat}"/>
                            </td><td id="fieldtypeTD"><!--字段类型--><select id="fieldType${status.index}" oldFieldType="${field.fieldType}" formulaIndex="fieldType${field.id}" name="fieldType${status.index}" onchange="confirmChangeField('${status.index}');" style="width:74px">
                                    <c:forEach items = "${field.extraMap.fieldTypeArray}" var = "fieldType">
                                        <option value="${fieldType.key}" <c:if test="${(field.fieldType==fieldType.key)}">selected="selected"</c:if> >
                                        ${fieldType.text}
                                        </option>
                                    </c:forEach>
                                </select>
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
                                <c:if test="${!(field.fieldType == 'DECIMAL' && field.inputType != 'select' && field.inputType != 'radio' && field.inputType != 'checkbox' && !(field.inputType == 'relation' && (field.formRelation.toRelationAttrType == 3 || field.formRelation.toRelationAttrType == 9))) || field.inputType == 'linenumber'}">style="display:none"</c:if>
                                validate="name:'${ctp:i18n("form.serailNumberLength.label")}',isInteger:true,minValue:0,maxValue:10" title="${ctp:i18n('form.field.digitNum.length')}"/>
                            </td><td id="relationObjectTD"><!--关联对象--><c:if test="${field.inputType == 'externalwrite-ahead'}"><select id="refInputName${status.index}" name="refInputName${status.index}" onchange="changeRefInputName('${status.index}');" style="width:100px;"  class="validate" validate="name:'${ctp:i18n("form.input.relationObject.label")}',notNull:true">
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
                            </td><td id="relationTD${status.index}">
                            <!--关联属性-->
                            <!-- refInputAttr+index --></td><td id="displayformatTD">
                            <!--显示格式-->
                                <select id="formatType${status.index}" oldFormatType="${field.formatType}" name="formatType${status.index}"  <c:if test="${field.extraMap.disFormat == '' || field.inputType == 'relationform' || (field.inputType == 'relation')}">style="width:${_formatTypeWidth};display:none"</c:if> <c:if test="${!(field.extraMap.disFormat == '' || field.inputType == 'relationform' || (field.inputType == 'relation'))}">style="width:${_formatTypeWidth};"</c:if> onchange="confirmChangeFormatType('${status.index}');" onclick="setFlowdealoptionFormat('${status.index}');">
                                    ${field.extraMap.disFormat}
                                </select>
                                <c:if test="${formBean.formType==2 || formBean.formType==3}">
                                    <input name="formatEnum${status.index}" type="text" readonly="readonly" class="validate" onclick="bindOutWriterEnum(${status.index})" validate="name:'${ctp:i18n("form.formenum.enumvaluebind")}',notNull:true" id="formatEnum${status.index}"  style="width: 40%; <c:if test="${field.extraMap.showName == false}">display: none; </c:if> cursor: pointer;" value="${fn:escapeXml(field.extraMap.formatEnumName )}"/>
                                </c:if>
                            </td><td id="formulaTD">
                            <!--计算字段-->
                                <div class="common_form_wrap">
                                    <textarea id="formulaData${status.index}" name="formulaData${status.index}" style="display:none;">
                                        ${field.formulaData}
                                    </textarea>
                                    <textarea id="barcodeAttr${status.index}" name="barcodeAttr${status.index}" style="display:none">
                                        ${field.barcodeAttr}
                                    </textarea>
                                    <input type="text" id="formula${status.index}" isAdvance="${field.isAdvance}" name="formula${status.index}" <c:if test="${field.inputType ne 'barcode'}"> <c:if test="${field.isAdvance != 1}"> value="${field.ordinaryFormula}"</c:if> <c:if test="${field.isAdvance == 1}"> value="${ctp:i18n('form.formula.advance.hasset.laebl')}"</c:if></c:if>  readonly="readonly"
                                    onClick="javascript:setFieldFormula('${field.name}','${status.index}');" <c:if test="${!field.extraMap.disFormula}">style="width:80%;cursor:pointer;display:none"</c:if> <c:if test="${field.extraMap.disFormula}">style="width:80%;cursor:pointer;"</c:if>
                                    <c:if test="${field.inputType eq 'barcode'}"><c:if test="${field.barcodeAttr ne ''}">value="${ctp:i18n('form.barcode.hasset.label')}"</c:if></c:if>/>
                                    <a id="advance${status.index}" name="advance${status.index}" onClick="javascript:setFieldFormula('${field.name}','${status.index}');"
                                        <c:if test="${field.inputType ne 'barcode'}">
                                            <c:if test="${field.isAdvance != 1}"> style="display:none;" </c:if>
                                        </c:if>
                                        <c:if test="${field.inputType eq 'barcode'}">
                                            <c:if test="${field.barcodeAttr eq ''}">style="display:none;" </c:if>
                                        </c:if> >
                                        <span class="ico16 advanced_16"></span>
                                    </a>
                                </div>
                            </td><c:if test="${formBean.formType==2 || formBean.formType==3}"><td id="uniqueFlagTD">
                            <!--数据唯一-->
                                    <input id="isUnique${status.index}" name="isUnique${status.index}" onclick="uniqueDataClick('${status.index}')" class="radio_com" value="1" type="checkbox" <c:if test="${field.unique==true}">checked="checked"</c:if> /></td>
                            </c:if>
                        </tr>
                       </c:forEach>
                </tbody>
            </table>
                   <div style="height: 20px">&nbsp;</div>
            </div>
                <input id="relations" type="hidden" value='${formBean.relations}' />
                </form>
            </div>
           
            <div class="layout_south over_hidden" id="south" layout="height:300,maxHeight:500,minHeight:30,sprit:true,border:true,spiretBar:{show:true,handlerB:mixContent,handlerT:maxContent}">
                <div class="">
                    <div id="formContent" class="absolute" style="overflow:hidden;bottom:0px; top:0;width:100%;">
                        <iframe id="viewFrame" src="" frameborder="0" style="width: 100%;height:100%" class=""></iframe>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>