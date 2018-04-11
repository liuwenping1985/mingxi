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
<body scroll="no" onload="_init_()">
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
                                </tr><c:if test="${isShowOperation==true }">
                                <tr id="operationTr">
                                    <th nowrap="nowrap">
                                        <label class="margin_t_5 hand display_block" for="text">${ctp:i18n('workflow.formBranch.operator') }&nbsp;:&nbsp;</label></th>
                                    <td width="70%">
                                        <div class="common_selectbox_wrap">
                                            <select id="operation" onchange="changeOperation(this)">
                                                <option value="==">=</option>
                                                <option value="!=">&lt;&gt;</option>
                                                <c:if test="${isHasOtherNotEqualOperator==true }">
                                                <option value=">">&gt;</option>
                                                <option value=">=">&gt;=</option>
                                                <option value="<">&lt;</option>
                                                <option value="<=">&lt;=</option>
                                                </c:if>
                                                <c:if test="${isHasLevelOperator==true }">
                                                <option value="--">--</option>
                                                <option value=">>">&gt;&gt;</option>
                                                <option value="<<">&lt;&lt;</option>
                                                </c:if>
                                                <c:if test="${type=='select' || type=='radio' }">
                                                <option value="in">in</option>
                                                </c:if>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                </c:if>
                               	<c:if test="${isShowDisignerByUser==true }">
                                <tr id="handTr">
                                    <th nowrap="nowrap" valign="top">
                                         <label for="handRadio" id="handRadioLabel" class="margin_t_5 hand display_block"><c:choose><c:when test="${isShowRadio==true }">
                                         <input onclick="selectRadio1('handRadio')" type="radio" value="1" id="handRadio"  checked name="option" class="radio_com">${ctp:i18n('workflow.formBranch.fieldValue') }</c:when><c:otherwise>${ctp:i18n('workflow.formBranch.formfieldvalue') }</c:otherwise></c:choose>&nbsp;:&nbsp;</label>
                                      </th>
                                    <td width="70%">
                                   		<c:choose>
                                            <c:when test="${type=='date' }">
                                                <div class="common_txtbox_wrap" id="handDiv"><input id="hand" readonly="readonly" type="text"  class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d'"/></div></c:when>
                                            <c:when test="${type=='datetime' }">
                                                <div class="common_txtbox_wrap" id="handDiv"><input id="hand" readonly="readonly" type="text"  class="comp" comp="type:'calendar',ifFormat:'%Y-%m-%d %H:%M',showsTime:true"/></div></c:when>
                                            <c:when test="${type=='member' }">
                                            	<c:choose>
                                            		<c:when test="${isVjoinField==true }">
                                            		<div class="common_txtbox_wrap" id="handDiv"><input id="hand" type="text"  class="comp" comp="type:'selectPeople',showBtn:true,extendWidth:true,panels:'JoinOrganization',returnValueNeedType:false,selectType:'Member',maxSize:1,minSize:0,showMe:true,isNeedCheckLevelScope:false"/></div>
                                            		</c:when>
                                            		<c:otherwise>
                                            		<div class="common_txtbox_wrap" id="handDiv"><input id="hand" type="text"  class="comp" comp="type:'selectPeople',showBtn:true,extendWidth:true,panels:'Department,Team,Outworker',returnValueNeedType:false,selectType:'Member',maxSize:1,minSize:0,showMe:true,isNeedCheckLevelScope:false"/></div>
                                            		</c:otherwise>
                                            	</c:choose>
                                            </c:when>
                                            <c:when test="${type=='account' }">
                                                <div class="common_txtbox_wrap" id="handDiv"><input id="hand" type="text"  class="comp" comp="type:'selectPeople',showBtn:true,extendWidth:true,panels:'Account',selectType:'Account',maxSize:1,minSize:0,showMe:true,returnValueNeedType:false,isNeedCheckLevelScope:false"/></div></c:when>
                                            <c:when test="${type=='department' }">
                                            	<c:choose>
                                            		<c:when test="${isVjoinField==true }">
                                            			<c:if test="${externalType==1 }">
                                            			<div class="common_txtbox_wrap" id="handDiv"><input id="hand" type="text"  class="comp" comp="type:'selectPeople',showBtn:true,extendWidth:true,panels:'JoinOrganization',showExternalType:'1',returnValueNeedType:false,selectType:'Department',maxSize:1,minSize:0,showMe:true,isNeedCheckLevelScope:false"/></div>
                                            			</c:if>
                                            			<c:if test="${externalType==2 }">
                                            			<div class="common_txtbox_wrap" id="handDiv"><input id="hand" type="text"  class="comp" comp="type:'selectPeople',showBtn:true,extendWidth:true,panels:'JoinAccount',returnValueNeedType:false,selectType:'Department',maxSize:1,minSize:0,showMe:true,isNeedCheckLevelScope:false"/></div>
                                            			</c:if>
                                            		</c:when>
                                            		<c:otherwise>
                                                	<div class="common_txtbox_wrap" id="handDiv"><input id="hand" type="text"  class="comp" comp="type:'selectPeople',showBtn:true,extendWidth:true,panels:'Department',selectType:'Department',maxSize:1,minSize:0,showMe:true,returnValueNeedType:false,isConfirmExcludeSubDepartment:true,isNeedCheckLevelScope:false"/></div>
                                            		</c:otherwise>
                                            	</c:choose>
                                             </c:when>
                                            <c:when test="${type=='post' }">
                                            	<c:choose>
                                            		<c:when test="${isVjoinField==true }">
                                            		<div class="common_txtbox_wrap" id="handDiv"><input id="hand" type="text"  class="comp" comp="type:'selectPeople',showBtn:true,extendWidth:true,panels:'JoinPost',selectType:'Post',maxSize:1,minSize:0,showMe:true,returnValueNeedType:false,callback:selectPeopleCallback,isNeedCheckLevelScope:false"/></div>
                                            		</c:when>
                                            		<c:otherwise>
                                            		<div class="common_txtbox_wrap" id="handDiv"><input id="hand" type="text"  class="comp" comp="type:'selectPeople',showBtn:true,extendWidth:true,panels:'Post',selectType:'Post',maxSize:1,minSize:0,showMe:true,returnValueNeedType:false,callback:selectPeopleCallback,isNeedCheckLevelScope:false"/></div>
                                            		</c:otherwise>
                                            	</c:choose>
                                            </c:when>
                                            <c:when test="${type=='level' }">
                                                <div class="common_txtbox_wrap" id="handDiv"><input id="hand" type="text"  class="comp" comp="type:'selectPeople',showBtn:true,extendWidth:true,panels:'Level',selectType:'Level',maxSize:1,minSize:0,showMe:true,returnValueNeedType:false,callback:selectPeopleCallback,isNeedCheckLevelScope:false"/></div>
                                            </c:when>
                                            <c:when test="${type=='select' || type=='radio' }">
                                            	<div class="common_selectbox_wrap" id="handDiv">
                                                	<select id="hand">
	                                                    <c:forEach items="${enumList}" var="tempenum" varStatus="status">
	                                                        <option value="${tempenum.id }">${ctp:toHTML(tempenum.showvalue)}</option>
	                                                 	</c:forEach>
                                                 	</select>
                                              	</div>
                                              	<div class="common_selectbox_wrap" id="handSelectInDiv" style="height: 200px;overflow: auto;display: none;">
                                                 	<table>
                                                 		<c:forEach items="${enumList}" var="tempenum" varStatus="status">
	                                                        <tr><td><label class="hand" for="enumin_${tempenum.id }"><input type="checkbox" name="enumin" id="enumin_${tempenum.id }" value="${tempenum.id }">${ctp:toHTML(tempenum.showvalue)}</label></td></tr>
	                                                 	</c:forEach>
                                                 	</table>
                                              	</div>
                                            </c:when>
                                            <c:when test="${type=='relation' }"><div class="common_selectbox_wrap" id="handDiv">
                                                <select id="hand">
                                                    <c:forEach items="${enumList}" var="tempenum" varStatus="status">
                                                        <option value="${tempenum.id }">${ctp:toHTML(tempenum.showvalue)}</option>
                                                 </c:forEach></select></div></c:when>
                                            <c:when test="${type=='checkbox' }"><div class="common_selectbox_wrap" id="handDiv">
                                                <select id="hand"><option value="1">${ctp:i18n('workflow.formBranch.checkboxSelected') }</option><option value="0">${ctp:i18n('workflow.formBranch.checkboxNotSelected') }</option></select></div></c:when>
                                            <c:when test="${type=='project' }">
                                                <div class="common_txtbox_wrap" id="handDiv"><input id="hand" readonly="readonly" type="text"  class="comp" comp="type:'chooseProject'"/></div>
                                            </c:when>
                                    	</c:choose>
                                    	<input id="isGroup" type="hidden" value="false">
                                    </td>
                                </tr>
                                </c:if>
                                <c:if test="${isShowSameType==true }">
                                <tr id="selectTr">
                                    <th nowrap="nowrap">
                                       <label for="selectRadio" id="selectRadioLabel" class="margin_t_5 hand display_block"><c:if test="${isShowRadio==true }">
                                        <input onclick="selectRadio1('selectRadio')" type="radio" value="2" id="selectRadio" name="option" class="radio_com"></c:if>${ctp:i18n('workflow.formBranch.formfield') }&nbsp;:&nbsp;</label></th>
                                    <td width="70%">
                                        <div class="common_selectbox_wrap">
                                             <select  disabled="disabled" id="select">
                                                    <c:forEach items="${fieldList}" var="field" varStatus="status">
                                                    <option value="${field[1] }">${field[0] }</option>
                                             </c:forEach></select>
                                        </div>
                                    </td>
                                </tr></c:if>
                                <%-- 选择人员组件可以匹配角色 --%>
                                <c:if test="${canSelectRole && type=='member' }">
                                    <tr id="roleTr">
                                        <th nowrap="nowrap">
                                             <label class="margin_t_5 hand display_block">
                                             <c:choose>
                                             <c:when test="${isShowRadio==true }">
                                             <input onclick="selectRadio1('roleRadio')" type="radio" value="3" id="roleRadio" name="option" class="radio_com">${ctp:i18n('workflow.branchGroup.5') }
                                             </c:when>
                                             <c:otherwise>${ctp:i18n('workflow.branchGroup.5') }</c:otherwise>
                                             </c:choose>&nbsp;:&nbsp;
                                             </label>
                                          </th>
                                        <td width="70%">
                                        <div class="common_txtbox_wrap" id="roleDiv"><input id="role" type="text"  class="comp" comp="type:'selectPeople',panels:'Role',returnValueNeedType:false,selectType:'Role',maxSize:1,minSize:1,showFlowTypeRadio:false,hiddenMultipleRadio:false,hiddenColAssignRadio:true,showFixedRole:true,isConfirmExcludeSubDepartment:false,onlyLoginAccount:true,isCanSelectGroupAccount:false,callback:selectRoleCallback"/></div>
                                        </td>
                                    </tr>
                                    <c:if test="${isGroup == true }">
                                    <tr>
                                        <td colspan="2">&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" style="text-align: center;">
                                        <span id="loginAccountSpan" style="display: none;">
								            ${ctp:i18n('workflow.branch.byloginaccount.label')} : 
								            <label><input type="radio" name="loginAccount" id="loginAccount1" onclick="showProperty(false);" value="yes">${ctp:i18n('common.true')}</label>
								            <label><input type="radio" name="loginAccount" id="loginAccount2" onclick="showProperty(true);" value="no" checked>${ctp:i18n('common.no')}</label>
								        </span>
                                        </td>
                                    </tr>
                                    </c:if>
                                    <tr>
                                        <td colspan="2">&nbsp;</td>
                                    </tr>
                                    <tr>
									    <td colspan="2" style="text-align: center;">
									    <span id="roleProperty" style="display: none;">
								            <label class="font_size12">
								            <input type="checkbox" id="departments4Role" name="departType4Role" checked="checked"  displayValue="${ctp:i18n('org.member_form.departments.label')}">
								                ${ctp:i18n('org.member_form.departments.label')}</label>
								            <label class="font_size12">
								            <input type="checkbox" id="secondPostDepartment4Role" name="departType4Role" displayValue="${ctp:i18n('workflow.branchGroup.2.6')}">
								            ${ctp:i18n('workflow.branchGroup.2.6')}</label>
								            <c:if test="${isGroup == true }">
								                <label class="font_size12">
								                <input type="checkbox" id="concurrentDepartment4Role" name="departType4Role" displayValue="${ctp:i18n('org.member_form.concurrentDepartment.label')}"> 
								                ${ctp:i18n('org.member_form.concurrentDepartment.label')}</label>
								            </c:if>
								        </span>
									    </td>
									 </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                  </div>
              </div>
        <%@include file="formulaextend.js.jsp"%>
    </form>
</body>
</html>