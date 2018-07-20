<%--
 $Author: duansy $
 $Rev: 261 $
 $Date:: 2012-11-19 15:19:30#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>设置界面</title>
</head>
<body scroll="no">
    <form name="formulaDateDiffer" method="post">
        <div class="form_area">
            <div class="form_area_content" style="width:100%;">
                    <div class="one_row">
                        <table border="0" cellspacing="0" cellpadding="0">
                            <tbody>
                                <tr>
                                    <th nowrap="nowrap">
                                        <label class="margin_r_10" for="text" >&nbsp;&nbsp;${ctp:i18n('workflow.formBranch.formdatafield') }:</label></th>
                                    <td width="90%" nowrap="nowrap">
                                        <label class="margin_r_10" for="text" id="field">${formField.display }</label>
                                    </td>
                                </tr><c:if test="${isShowOperation==true }">
                                <tr id="operationTr">
                                    <th nowrap="nowrap">
                                        <label class="margin_t_5 hand display_block" for="text">${ctp:i18n('workflow.formBranch.operator') }:</label></th>
                                    <td width="70%">
                                        <div class="common_selectbox_wrap">
                                            <select id="operation">
                                                <option value="==">=</option>
                                                <option value="!=">&lt;&gt;</option><c:if test="${isHasOtherNotEqualOperator==true }">
                                                <option value=">">&gt;</option>
                                                <option value=">=">&gt;=</option>
                                                <option value="<">&lt;</option>
                                                <option value="<=">&lt;=</option></c:if><c:if test="${isHasLevelOperator==true }">
                                                <option value="--">--</option>
                                                <option value=">>">&gt;&gt;</option>
                                                <option value="<<">&lt;&lt;</option></c:if>
                                            </select>
                                        </div>
                                    </td>
                                </tr></c:if><c:if test="${isShowDisignerByUser==true }">
                                <tr id="handTr" onclick="selectRadio1('handRadio')">
                                    <th nowrap="nowrap">
                                         <label for="handRadio" id="handRadioLabel" class="margin_t_5 hand display_block"><c:choose><c:when test="${isShowRadio==true }">
                                         <input type="radio" value="1" id="handRadio"  checked name="option" class="radio_com">${ctp:i18n('workflow.formBranch.handOption') }</c:when><c:otherwise>${ctp:i18n('workflow.formBranch.formfieldvalue') }</c:otherwise></c:choose>:</label>
                                      </th>
                                    <td width="70%"><c:choose>
                                            <c:when test="${type=='date' }">
                                                <div class="common_txtbox_wrap" id="handDiv"><input id="hand" readonly="readonly" type="text"  class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d'"/></div></c:when>
                                            <c:when test="${type=='datetime' }">
                                                <div class="common_txtbox_wrap" id="handDiv"><input id="hand" readonly="readonly" type="text"  class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true"/></div></c:when>
                                            <c:when test="${type=='member' }">
                                                <div class="common_txtbox_wrap" id="handDiv"><input id="hand" type="text"  class="comp" comp="type:'selectPeople',panels:'Department,Team,Outworker',returnValueNeedType:false,selectType:'Member',maxSize:1,minSize:0,showMe:true,isNeedCheckLevelScope:false"/></div></c:when>
                                            <c:when test="${type=='account' }">
                                                <div class="common_txtbox_wrap" id="handDiv"><input id="hand" type="text"  class="comp" comp="type:'selectPeople',panels:'Account',selectType:'Account',maxSize:1,minSize:0,showMe:true,returnValueNeedType:false,isNeedCheckLevelScope:false"/></div></c:when>
                                            <c:when test="${type=='department' }">
                                                <div class="common_txtbox_wrap" id="handDiv"><input id="hand" type="text"  class="comp" comp="type:'selectPeople',panels:'Department',selectType:'Department',maxSize:1,minSize:0,showMe:true,returnValueNeedType:false,isConfirmExcludeSubDepartment:false,isNeedCheckLevelScope:false"/></div></c:when>
                                            <c:when test="${type=='post' }">
                                                <div class="common_txtbox_wrap" id="handDiv"><input id="hand" type="text"  class="comp" comp="type:'selectPeople',panels:'Post',selectType:'Post',maxSize:1,minSize:0,showMe:true,returnValueNeedType:false,callback:selectPeopleCallback,isNeedCheckLevelScope:false"/></div></c:when>
                                            <c:when test="${type=='level' }">
                                                <div class="common_txtbox_wrap" id="handDiv"><input id="hand" type="text"  class="comp" comp="type:'selectPeople',panels:'Level',selectType:'Level',maxSize:1,minSize:0,showMe:true,returnValueNeedType:false,callback:selectPeopleCallback,isNeedCheckLevelScope:false"/></div></c:when>
                                            <c:when test="${type=='radio' }"><div class="common_selectbox_wrap" id="handDiv">
                                                <select id="hand"><option value=""></option>
                                                    <c:forEach items="${enumList}" var="tempenum" varStatus="status">
                                                    <option value="${tempenum.id }">${tempenum.showvalue }</option>
                                                </c:forEach></select></div></c:when>
                                            <c:when test="${type=='select' }"><div class="common_selectbox_wrap" id="handDiv">
                                                <select id="hand"><option value=""></option>
                                                    <c:forEach items="${enumList}" var="tempenum" varStatus="status">
                                                        <option value="${tempenum.id }">${tempenum.showvalue }</option>
                                                 </c:forEach></select></div></c:when>
                                            <c:when test="${type=='relation' }"><div class="common_selectbox_wrap" id="handDiv">
                                                <select id="hand"><option value=""></option>
                                                    <c:forEach items="${enumList}" var="tempenum" varStatus="status">
                                                        <option value="${tempenum.id }">${tempenum.showvalue }</option>
                                                 </c:forEach></select></div></c:when>
                                            <c:when test="${type=='checkbox' }"><div class="common_selectbox_wrap" id="handDiv">
                                                <select id="hand"><option value="1">${ctp:i18n('workflow.formBranch.checkboxSelected') }</option><option value="0">${ctp:i18n('workflow.formBranch.checkboxNotSelected') }</option></select></div></c:when>
                                            <c:when test="${type=='project' }">
                                                <div class="common_txtbox_wrap" id="handDiv"><input id="hand" readonly="readonly" type="text"  class="comp" comp="type:'chooseProject'"/></div>
                                            </c:when>
                                    </c:choose><input id="isGroup" type="hidden" value="false"></td>
                                </tr></c:if><c:if test="${isShowSameType==true }">
                                <tr id="selectTr" onclick="selectRadio1('selectRadio')">
                                    <th nowrap="nowrap">
                                       <label for="selectRadio" id="selectRadioLabel" class="margin_t_5 hand display_block"><c:if test="${isShowRadio==true }">
                                        <input type="radio" value="2" id="selectRadio" name="option" class="radio_com"></c:if>${ctp:i18n('workflow.formBranch.formfield') }:</label></th>
                                    <td width="70%">
                                        <div class="common_selectbox_wrap">
                                             <select id="select">
                                                    <option value=""></option><c:forEach items="${fieldList}" var="field" varStatus="status">
                                                    <option value="${field[1] }">${field[0] }</option>
                                             </c:forEach></select>
                                        </div>
                                    </td>
                                </tr></c:if>
                            </tbody>
                        </table>
                    </div>
                  </div>
              </div>
        <%@include file="formulaextend.js.jsp"%>
    </form>
</body>
</html>