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
<title><%-- 设置界面 --%></title>
</head>
<body scroll="no">
    <form name="formulaDateDiffer" method="post">
        <div class="form_area">
            <div class="form_area_content" style="width:100%;">
                    <div class="one_row">
                        <table class="w100b" border="0" cellspacing="0" cellpadding="0">
                            <tbody>
                                <tr>
                                    <th nowrap="nowrap">
                                        <label class="margin_t_5">${ctp:i18n('workflow.formBranch.formfield')}&nbsp;:&nbsp;</label></th>
                                    <td width="70%" nowrap="nowrap">
                                    <div class="common_selectbox_wrap">
                                    <div class="common_txtbox_wrap"><input type="text" value="${display}" readonly="readonly"/></div>
                                        </div>
                                        <%-- <label class="margin_r_10" for="text" id="field">${formField.display }</label> --%>
                                    </td>
                                </tr>
                                <tr id="operationTr">
                                    <th nowrap="nowrap">
                                        <label class="margin_t_5 hand display_block" for="text">${ctp:i18n('workflow.formBranch.operator') }&nbsp;:&nbsp;</label></th>
                                    <td width="70%">
                                        <div class="common_selectbox_wrap">
                                            <select id="operation" onchange="changeMultiDepartment(this);">
                                                <option value="==">=</option>
                                                <option value="!=">&lt;&gt;</option>
                                                <option value="include">include</option>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr id="handTr">
                                    <th nowrap="nowrap">
                                         <label for="handRadio" id="handRadioLabel" class="margin_t_5 hand display_block">
                                         <input onclick="selectRadio1('handRadio')" type="radio" value="1" id="handRadio"  checked name="option" class="radio_com">${ctp:i18n('workflow.formBranch.fieldValue') }&nbsp;:&nbsp;</label>
                                      </th>
                                    <td width="70%"><c:choose>
                                            <c:when test="${type=='multimember' }">
                                                <div class="common_txtbox_wrap" id="handDiv"><input id="hand" type="text"  class="comp" comp="type:'selectPeople',showBtn:true,extendWidth:true,panels:'Department,Team,Outworker',returnValueNeedType:false,selectType:'Member',maxSize:-1,minSize:0,showMe:true,isNeedCheckLevelScope:false"/></div></c:when>
                                            <c:when test="${type=='multiaccount' }">
                                                <div class="common_txtbox_wrap" id="handDiv"><input id="hand" type="text"  class="comp" comp="type:'selectPeople',showBtn:true,extendWidth:true,panels:'Account',selectType:'Account',maxSize:-1,minSize:0,showMe:true,returnValueNeedType:false,isNeedCheckLevelScope:false"/></div></c:when>
                                            <c:when test="${type=='multidepartment' }">
                                                <div class="common_txtbox_wrap" id="handDiv_MultiDepartment"><input id="hand" type="text"  class="comp" comp="type:'selectPeople',showBtn:true,extendWidth:true,panels:'Department',selectType:'Department',maxSize:-1,minSize:0,showMe:true,returnValueNeedType:false,isConfirmExcludeSubDepartment:false,isNeedCheckLevelScope:false,isAllowContainsChildDept:true"/></div></c:when>
                                            <c:when test="${type=='multipost' }">
                                                <div class="common_txtbox_wrap" id="handDiv"><input id="hand" type="text"  class="comp" comp="type:'selectPeople',showBtn:true,extendWidth:true,panels:'Post',selectType:'Post',maxSize:-1,minSize:0,showMe:true,returnValueNeedType:false,callback:selectPeopleCallback,isNeedCheckLevelScope:false"/></div></c:when>
                                            <c:when test="${type=='multilevel' }">
                                                <div class="common_txtbox_wrap" id="handDiv"><input id="hand" type="text"  class="comp" comp="type:'selectPeople',showBtn:true,extendWidth:true,panels:'Level',selectType:'Level',maxSize:-1,minSize:0,showMe:true,returnValueNeedType:false,callback:selectPeopleCallback,isNeedCheckLevelScope:false"/></div></c:when>
                                    </c:choose><input id="isGroup" type="hidden" value="false"></td>
                                </tr>
                                <tr id="selectTr">
                                    <th nowrap="nowrap">
                                       <label for="selectRadio" id="selectRadioLabel" class="margin_t_5 hand display_block">
                                        <input onclick="selectRadio1('selectRadio')" type="radio" value="2" id="selectRadio" name="option" class="radio_com">${ctp:i18n('workflow.formBranch.formfield') }&nbsp;:&nbsp;</label></th>
                                    <td width="70%">
                                        <div class="common_selectbox_wrap">
                                             <select disabled="disabled" id="select">
                                                    <c:forEach items="${fieldList}" var="field" varStatus="status">
                                                    <option value="${field[1] }">${field[0] }</option>
                                             </c:forEach></select>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                  </div>
              </div>
        <%@include file="formulaextend_multi.js.jsp"%>
    </form>
</body>
</html>