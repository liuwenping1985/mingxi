<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<html style="overflow: hidden;height: 100%">
<head>
<%@include file="../header.jsp"%>
<fmt:setBundle
    basename="com.seeyon.v3x.plan.resource.i18n.PlanResources"
    var="v3xPlanI18N" />
<fmt:setBundle
    basename="com.seeyon.v3x.info.resources.i18n.InfoResources"
    var="v3xInfo18N" />
<fmt:setBundle
    basename="com.seeyon.v3x.personalaffair.resources.i18n.PersonalAffairResources"
    var="v3xPersonalAffairI18N" />
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8"
    src="<c:url value="/common/jquery/jquery.js${v3x:resSuffix()}" />"></script>
<html:link renderURL='/message.do' var='messageURL' />
<title><fmt:message key='message.setting.title' /></title>
<script type="text/javascript">
    var type = "${type}";
    var messageURL = "${messageURL}";

    try{
    	if("${v3x:escapeJavascript(param.fromModel)}" != "top"){
    	    if("${isAdmin}" == "true"){
    	        showCtpLocation("F13_unitMessageSetting");
    	    }else{
    	        showCtpLocation("F12_perMessageSetting");
    	    }
    	}
    }catch(e){}
    
    function twclose(){
    	//if(parent.parentDialogObj&&parent.parentDialogObj['showMessageSet'])parent.parentDialogObj['showMessageSet'].close();
    	location.reload(window.location.href);
    }
</script>
<style type="text/css">
.border_b {
border-bottom-color:#b6b6b6;
border-bottom-width:1px;
border-bottom-style:solid;
}
.border_r {
border-right-color:#b6b6b6;
border-right-width:1px;
border-right-style:solid;
}
</style>
<script type="text/javascript" charset="UTF-8"
    src="<c:url value="/apps_res/v3xmain/js/message.js${v3x:resSuffix()}" />"></script>
</head>
<body scroll="no"  onload="windowLoadCheck('${isAdmin}', '${isAllowCustom}');">
<form name="msgSettingForm" id="msgSettingForm" method="post" action="${messageURL}">
<input type="hidden" name="method" value="updateMessageSetting">
<input type="hidden" name="messageType" value="${type}">
        <table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
            <tr id="msgSettingTr">
                <td width="100%" valign="top" style="padding: 10px 20px;">
                <div id="messageBody">
                <table width="100%" cellspacing="0" cellpadding="0" border="0">
                    <c:choose>
                        <c:when test="${not empty errorMsg}">
                            <tr>
                                <td width="100%" height="400" align="center" style="color: red;">${errorMsg}</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td width="100%" height="100%" valign="top">
                                <table width="100%" cellspacing="0" cellpadding="0" border="0">
                                    <tr align="left" valign="top">
                                        <%--第一层左 --%>
                                        <td>
                                        <table width="100%" cellspacing="10" cellpadding="0" border="0">
                                            <%--协同工作 --%>
                                            <c:if test="${v3x:hasPlugin('collaboration')}">
                                            <tr>
                                                <td>
                                                <label for="App_1">
                                                    <input type="checkbox" id="App_1" name="App" value="1" onclick="selectAndSetAll(1)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 1, null)? 'checked':''} ><b><fmt:message key='personal.message.1.label' bundle="${v3xPersonalAffairI18N}" /></b>
                                                </label>
                                                <span class="ico16 arrow_2_t" onclick="trShowOrHide(this,'1_all');"></span>
                                                <input type="hidden" id="AllInput_1" name="AllInput_1" value="${main:isSelectedOfMessageSetting(messageConfigMap, type, 1, 'ALL') ? 'ALL':''}" >
                                                <table class="tr_1_all" width="100%" >
                                                    <tr>
                                                        <td>
                                                           <table>
                                                               <tr>
                                                                 <td width="20%" align="right">
                                                                    <fmt:message key='application.1.1.label' bundle="${v3xCommonI18N}" />:
                                                                 </td>
                                                                 <td width="20%" align="left">
                                                                 <label for="CollOption1">
                                                                   <input type="checkbox" id="CollOption1" name="Option_1" value="1" onclick="checkParentNode(this,1)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 1,'1')? 'checked':''} ><fmt:message key='common.importance.putong' bundle="${v3xCommonI18N}" />
                                                                 </label>
                                                                 </td>
                                                                 <td width="20%">
                                                                    <label for="CollOption2" class="margin_l_10">
                                                                   <input type="checkbox" id="CollOption2" name="Option_1" value="2" onclick="checkParentNode(this,1)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 1,'2')? 'checked':''} ><fmt:message key='common.importance.zhongyao' bundle="${v3xCommonI18N}" />
                                                                 </label>
                                                                 </td>
                                                                 <td width="20%">
                                                                    <label for="CollOption3" class="margin_l_10">
                                                                   <input type="checkbox" id="CollOption3" name="Option_1" value="3" onclick="checkParentNode(this,1)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 1,'3')? 'checked':''} ><fmt:message key='common.importance.feichangzhongyao' bundle="${v3xCommonI18N}" />
                                                                 </label>
                                                                 </td>
                                                               </tr> 
                                                                <tr>
                                                                 <td width="20%" align="right">
                                                                    <fmt:message key='application.1.2.label' bundle="${v3xCommonI18N}" />:
                                                                 </td>
                                                                 <td>
                                                                 <label for="CollOption4">
                                                                   <input type="checkbox" id="CollOption4" name="Option_1" value="4" onclick="checkParentNode(this,1)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 1,'4')? 'checked':''} ><fmt:message key='common.importance.putong' bundle="${v3xCommonI18N}" />
                                                                 </label>
                                                                 </td>
                                                                 <td width="20%">
                                                                    <label for="CollOption5" class="margin_l_10">
                                                                   <input type="checkbox" id="CollOption5" name="Option_1" value="5" onclick="checkParentNode(this,1)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 1,'5')? 'checked':''} ><fmt:message key='common.importance.zhongyao' bundle="${v3xCommonI18N}" />
                                                                 </label>
                                                                 </td>
                                                                 <td width="20%">
                                                                    <label for="CollOption6" class="margin_l_10">
                                                                   <input type="checkbox" id="CollOption6" name="Option_1" value="6" onclick="checkParentNode(this,1)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 1,'6')? 'checked':''} ><fmt:message key='common.importance.feichangzhongyao' bundle="${v3xCommonI18N}" />
                                                                 </label>
                                                                 </td>
                                                               </tr>     
                                                               <tr>
                                                                 <td colspan="4">    
                                                                 <label for="CollOption7">
                                                                  &nbsp;<input type="checkbox" id="CollOption7" name="Option_1" value="7" onclick="checkParentNode(this,1)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 1,'7')? 'checked':''} ><fmt:message key='personal.message.2.label' bundle="${v3xPersonalAffairI18N}" />
                                                                 </label>
                                                                 </td>
                                                               </tr>
                                                               <tr>
                                                                 <td colspan="4">    
                                                                 <label for="CollOption9">
                                                                  &nbsp;<input type="checkbox" id="CollOption9" name="Option_1" value="9" onclick="checkParentNode(this,1)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 1,'9')? 'checked':''} ><fmt:message key='personal.message.col.9.label' />
                                                                 </label>
                                                                 </td>
                                                               </tr>
                                                              <c:if test ="${(v3x:getSysFlagByName('col_notShowformMessage')!='true')}">
                                                               <tr>
                                                                 <td colspan="4">
                                                                 <label for="CollOption8">
                                                                  &nbsp;<input type="checkbox" id="CollOption8" name="Option_1" value="8" onclick="checkParentNode(this,1)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 1,'8')? 'checked':''} ><fmt:message key='personal.message.col.8.label' bundle="${v3xPersonalAffairI18N}" />
                                                                 </label>
                                                                 </td>
                                                               </tr>  
                                                               </c:if>   
                                                           </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                                </td>
                                            </tr>
                                            </c:if>
                                           <fmt:message key='personal.message.3.label' var="mbgl" bundle="${v3xPersonalAffairI18N}" />
                                           <fmt:message key='personal.message.13.label${v3x:suffix()}' var="zssq" bundle="${v3xPersonalAffairI18N}" />
                                           <fmt:message key='personal.message.3.label' var="jhrc" bundle="${v3xPersonalAffairI18N}" />
                                           <fmt:message key='personal.message.21.label' var="wdgl" bundle="${v3xPersonalAffairI18N}" />
                                           <fmt:message key='personal.message.23.label' var="wdzx" bundle="${v3xPersonalAffairI18N}" />
                                            <c:choose>
                                            <c:when test="${(v3x:getSysFlagByName('knowledge_change') == 'true')}">
                                            <c:set value="${jhrc }" var="TargetLable" />
                                            <c:set value="${wdzx }" var="DocLable" />
                                            </c:when>
                                            <c:when test="${v3x:getSystemProperty('system.onlyA6')}">
                                            <c:set value="${jhrc }" var="TargetLable" />
                                            <c:set value="${wdgl }" var="DocLable" />
                                            </c:when>
                                            <c:otherwise>
                                            <c:set value="${mbgl }" var="TargetLable" />
                                            <c:set value="${zssq }" var="DocLable" />
                                            </c:otherwise>
                                            </c:choose>
                                           <c:if test ="${(v3x:getSysFlagByName('target_showOnlyTimeManager')!='true')}">
                                            	<%--目标管理 --%>
                                            <tr>
                                                <td>
                                                <div style="margin-top: 10px;">
                                                <label for="App_53011">
                                                    <input type="checkbox" id="App_53011"  onclick="selectAndSetAll1('53011')" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 30, null)||main:isSelectedOfMessageSetting(messageConfigMap, type, 5, null)||main:isSelectedOfMessageSetting(messageConfigMap, type, 11, null)? 'checked':''}><b>${TargetLable}</b>
                                                </label>
                                                <span class="ico16 arrow_2_t" onclick="trShowOrHide(this,'53011_all');"></span>
                                                <table class="tr_53011_all" width="100%" cellpadding="0" cellspacing="0" border="0" style="margin-left: 15px;margin-top: 5px;">
                                                <c:if test="${v3x:hasPlugin('taskmanage')}">
                                                    <tr>
                                                        <td>
                                                          <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                              <tr>
                                                                 <td width="100%">
                                                                 <input type="checkbox" id="App_30" name="App" value="30" onclick="selectAndSetAll2(30, '53011')" ${main:isSelectedOfMessageSetting(messageConfigMap, type,30, null)? 'checked':''} ><b><fmt:message key='project.task.menu.name' bundle="${v3xCommonI18N}" /></b>
                                                                 <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'30_all');"></span>
                                                                 <input type="hidden" id="AllInput_30" name="AllInput_30" value="${main:isSelectedOfMessageSetting(messageConfigMap, type, 30, 'ALL') ? 'ALL':''}" >
                                                                 </td>
                                                              </tr>
                                                              <tr style="display: none;" class="tr_30_all">
                                                               <td width="100%">
                                                               <div class="margin_t_5">
                                                               <label for="CollOption13" style="margin-left: 15px;">
                                                                          <input type="checkbox" id="CollOption13" name="Option_30" value="1" onclick="checkParentNode3(this,30,53011)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 30,'1')? 'checked':''} ><fmt:message key='personal.message.10.label' bundle="${v3xPersonalAffairI18N}" />
                                                                       </label>
                                                               <label for="CollOption14" style="margin-left: 15px;"">
                                                                          <input type="checkbox" id="CollOption14" name="Option_30" value="2" onclick="checkParentNode3(this,30,53011)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 30,'2')? 'checked':''} ><fmt:message key='personal.message.11.label' bundle="${v3xPersonalAffairI18N}" />
                                                                       </label>
                                                               <label for="CollOption15" style="margin-left: 15px;">
                                                                          <input type="checkbox" id="CollOption15" name="Option_30" value="3" onclick="checkParentNode3(this,30,53011)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 30,'3')? 'checked':''} ><fmt:message key='personal.message.12.label' bundle="${v3xPersonalAffairI18N}" />
                                                                       </label>
                                                               </div>
                                                               </td>
                                                              </tr>
                                                          </table>
                                                        </td>
                                                    </tr>
                                                </c:if>
                                                <c:if test="${v3x:hasPlugin('plan')}">
                                                    <tr>
                                                        <td>
                                                          <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                              <tr>
                                                                 <td width="100%">
                                                                  <input type="checkbox" id="App_5" name="App" value="5" onclick="selectAndSetAll2(5, '53011')" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 5, null)? 'checked':''} ><b><fmt:message key='personal.message.4.label' bundle="${v3xPersonalAffairI18N}" /></b>
                                                                  <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'5_all');"></span>
                                                                  <input type="hidden" id="AllInput_5" name="AllInput_5" value="${main:isSelectedOfMessageSetting(messageConfigMap, type, 5, 'ALL') ? 'ALL':''}" >
                                                                 </td>
                                                              </tr>
                                                              <tr style="display: none;" class="tr_5_all">
                                                                 <td width="100%">
                                                                 <div class="margin_t_5">
                                                                 <label for="CollOption8" style="margin-left: 15px;">
                                                                          <input type="checkbox" id="CollOption8" name="Option_5" value="1" onclick="checkParentNode3(this,5,53011)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 5,'1')? 'checked':''} ><fmt:message key='personal.message.5.label' bundle="${v3xPersonalAffairI18N}" />
                                                                        </label>
                                                                 <label for="CollOption9" style="margin-left: 15px;">
                                                                          <input type="checkbox" id="CollOption9" name="Option_5" value="2" onclick="checkParentNode3(this,5,53011)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 5,'2')? 'checked':''} ><fmt:message key='personal.message.6.label' bundle="${v3xPersonalAffairI18N}" />
                                                                       </label>
                                                                 <label for="CollOption10" style="margin-left: 15px;">
                                                                          <input type="checkbox" id="CollOption10" name="Option_5" value="3" onclick="checkParentNode3(this,5,53011)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 5,'3')? 'checked':''} ><fmt:message key='personal.message.7.label' bundle="${v3xPersonalAffairI18N}" />
                                                                        </label>
                                                                 <label for="CollOption11" style="margin-left: 15px;">
                                                                          <input type="checkbox" id="CollOption11" name="Option_5" value="4" onclick="checkParentNode3(this,5,53011)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 5,'4')? 'checked':''} ><fmt:message key='personal.message.8.label' bundle="${v3xPersonalAffairI18N}" />
                                                                         </label>
                                                                 <c:choose>
                                                                        <c:when test="${v3x:getSystemProperty('system.onlyA6')}">
                                                                            &nbsp;
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                           <label for="CollOption12" class="margin_l_10">
                                                                              <input type="checkbox" id="CollOption12" name="Option_5" value="5" onclick="checkParentNode3(this,5,53011)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 5,'5')? 'checked':''} ><fmt:message key='personal.message.9.label' bundle="${v3xPersonalAffairI18N}" />
                                                                           </label>
                                                                        </c:otherwise>
                                                                       </c:choose>
                                                                 </div>
                                                                 </td>
                                                              </tr>
                                                          </table>
                                                        </td>
                                                    </tr>
                                                    </c:if>
                                                    <c:if test="${v3x:hasPlugin('calendar')}">
                                                    <tr>
                                                        <td>
                                                          <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                              <tr>
                                                              <td width="100%">
                                                                <input type="checkbox" id="App_11" name="App" value="11" onclick="selectAndSetAll2(11, '53011')" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 11, null)? 'checked':''}  ><b><fmt:message key='application.11.label' bundle="${v3xCommonI18N}" /></b>
                                                                <input type="hidden" id="AllInput_11" name="AllInput_11" value="${main:isSelectedOfMessageSetting(messageConfigMap, type, 11, 'ALL') ? 'ALL':''}" >
                                                              </td>
                                                              </tr>
                                                          </table>
                                                        </td>
                                                    </tr>
                                                    </c:if>
                                                </table>
                                                </div>
                                                </td>
                                            </tr>
                                            </c:if>
                                            <%--知识社区 --%>
                                            <c:if test="${v3x:hasPlugin('doc')}">
                                            <tr>
                                                <td>
                                                    <div style="margin-top: 10px;">
                                                    <label for="App_3">
                                                        <input type="checkbox" id="App_3" name="App" value="3" onclick="selectAndSetAll(3)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 3, null)? 'checked':''}  ><b>${DocLable}</b>
                                                    </label>
                                                    <input type="hidden" id="AllInput_3" name="AllInput_3" value="${main:isSelectedOfMessageSetting(messageConfigMap, type, 3, 'ALL') ? 'ALL':''}" >
                                                    </div>
                                                </td>
                                            </tr>
                                            </c:if>
                                            <%--<c:if test="${type == 'pc' && v3x:hasPlugin('uc')}">
                                            <tr>
					       						<td>
                                                    <div style="margin-top: 10px;">
								       			    <label for="App_25">
								       				    <input type="checkbox" id="App_25" name="App" value="25" onclick="selectAndSetAll(25)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 25, null)? 'checked':''} ${not empty enabledAppEnum&&!v3x:isIntegerInCollection(enabledAppEnum,25)? 'disabled':''}><b><fmt:message key="application.25.label" bundle="${v3xCommonI18N}"/></b>
								       				</label>
                                                    <span class="ico16 arrow_2_t" onclick="trShowOrHide(this,'25_all');"></span>
								       				<input type="hidden" id="AllInput_25" name="AllInput_25" value="${main:isSelectedOfMessageSetting(messageConfigMap, type, 25, 'ALL') ? 'ALL':''}">
                                                    <div class="margin_t_5 tr_25_all">
                                                    <label for="Option_25_1" style="margin-left: 15px;">
                                                        <input type="checkbox" id="Option_25_1" name="Option_25" value="1" onclick="checkParentNode(this,25)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 25, '1') ? 'checked' : ''} ><fmt:message key='personal.message.uc.1.label' bundle="${v3xPersonalAffairI18N}" />
                                                    </label>
                                                    <label for="Option_25_2" style="margin-left: 15px;">
                                                        <input type="checkbox" id="Option_25_2" name="Option_25" value="2" onclick="checkParentNode(this,25)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 25, '2') ? 'checked' : ''} ><fmt:message key='personal.message.uc.2.label' bundle="${v3xPersonalAffairI18N}" />
                                                    </label>
                                                    </div>
                                                    </div>
					       						</td>
					       					</tr>
                                            </c:if> --%>
                                            <%--综合办公--%>
                                            <c:if test="${v3x:hasPlugin('office')}">
                                              <tr>
                                                  <td>
                                                  <div style="margin-top: 10px;">
                                                  <label for="App_26">
                                                  <input type="checkbox" id="App_26" name="App" value="26" onclick="selectAndSetAll1(26)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 26, null)? 'checked':''} ><b><fmt:message key='application.26.label' bundle="${v3xCommonI18N}" /></b>
                                                  </label>
                                                  <span class="ico16 arrow_2_t" onclick="trShowOrHide(this,'26_all');"></span>
                                                  <input type="hidden" id="AllInput_26" name="AllInput_26" value="${main:isSelectedOfMessageSetting(messageConfigMap, type, 26, 'ALL') ? 'ALL':''}" >
                                                  <table class="tr_26_all" width="100%" cellpadding="0" cellspacing="0" border="0" style="margin-left: 15px;margin-top: 5px;">
                                                      <tr>
                                                          <td>
                                                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                                <tr>
                                                                   <td width="100%">
                                                                    <input type="checkbox" id="App_26_0" name="App_26_0" onclick="selectAndSetAll3(26,0)" ><b><fmt:message key='personal.message.office.1.label' bundle="${v3xPersonalAffairI18N}" /></b>
                                                                    <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'26_0');"></span>
                                                                   </td>
                                                                </tr>
                                                                <tr style="display: none;" class="tr_26_0">
                                                                   <td width="100%">
                                                                   <div class="margin_t_5">
                                                                   <label for="Option_26_1" style="margin-left: 15px;">
                                                                            <input type="checkbox" id="Option_26_1" name="Option_26" value="1" onclick="checkParentNode4(this,26,'26_0')" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 26,'1')? 'checked':''} ><fmt:message key='personal.message.office.audit.label' bundle="${v3xPersonalAffairI18N}" />
                                                                          </label>
                                                                   <label for="Option_26_2" style="margin-left: 15px;">
                                                                            <input type="checkbox" id="Option_26_2" name="Option_26" value="2" onclick="checkParentNode4(this,26,'26_0')" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 26,'2')? 'checked':''} ><fmt:message key='personal.message.office.sent.label' bundle="${v3xPersonalAffairI18N}" />
                                                                         </label>
                                                                   <label for="Option_26_3" style="margin-left: 15px;">
                                                                            <input type="checkbox" id="Option_26_3" name="Option_26" value="3" onclick="checkParentNode4(this,26,'26_0')" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 26,'3')? 'checked':''} ><fmt:message key='personal.message.office.out.label' bundle="${v3xPersonalAffairI18N}" />
                                                                          </label>
                                                                   <label for="Option_26_4" style="margin-left: 15px;">
                                                                            <input type="checkbox" id="Option_26_4" name="Option_26" value="4" onclick="checkParentNode4(this,26,'26_0')" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 26,'4')? 'checked':''} ><fmt:message key='personal.message.office.in.label' bundle="${v3xPersonalAffairI18N}" />
                                                                           </label>
                                                                   </div>
                                                                   </td>
                                                                </tr>
                                                            </table>
                                                          </td>
                                                      </tr>
                                                      <tr>
                                                          <td>
                                                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                                <tr>
                                                                   <td width="100%">
                                                                    <input type="checkbox" id="App_26_1" name="App_26_1" onclick="selectAndSetAll3(26,1)" ><b><fmt:message key='personal.message.office.2.label' bundle="${v3xPersonalAffairI18N}" /></b>
                                                                    <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'26_1');"></span>
                                                                   </td>
                                                                </tr>
                                                                <tr style="display: none;" class="tr_26_1">
                                                                   <td width="100%">
                                                                   <div class="margin_t_5">
                                                                   <label for="Option_26_11" style="margin-left: 15px;">
                                                                            <input type="checkbox" id="Option_26_11" name="Option_26" value="11" onclick="checkParentNode4(this,26,'26_1')" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 26,'11')? 'checked':''} ><fmt:message key='personal.message.office.audit.label' bundle="${v3xPersonalAffairI18N}" />
                                                                          </label>
                                                                   <label for="Option_26_12" style="margin-left: 15px;">
                                                                            <input type="checkbox" id="Option_26_12" name="Option_26" value="12" onclick="checkParentNode4(this,26,'26_1')" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 26,'12')? 'checked':''} ><fmt:message key='personal.message.office.grant.label' bundle="${v3xPersonalAffairI18N}" />
                                                                         </label>
                                                                   </div>
                                                                   </td>
                                                                </tr>
                                                            </table>
                                                          </td>
                                                      </tr>
                                                      <tr>
                                                          <td>
                                                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                                <tr>
                                                                   <td width="100%">
                                                                    <input type="checkbox" id="App_26_2" name="App_26_2" onclick="selectAndSetAll3(26,2)" ><b><fmt:message key='personal.message.office.3.label' bundle="${v3xPersonalAffairI18N}" /></b>
                                                                    <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'26_2');"></span>
                                                                   </td>
                                                                </tr>
                                                                <tr style="display: none;" class="tr_26_2">
                                                                   <td width="100%">
                                                                   <div class="margin_t_5">
                                                                   <label for="Option_26_21" style="margin-left: 15px;">
                                                                            <input type="checkbox" id="Option_26_21" name="Option_26" value="21" onclick="checkParentNode4(this,26,'26_2')" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 26,'21')? 'checked':''} ><fmt:message key='personal.message.office.audit.label' bundle="${v3xPersonalAffairI18N}" />
                                                                          </label>
                                                                   <label for="Option_26_22" style="margin-left: 15px;">
                                                                            <input type="checkbox" id="Option_26_22" name="Option_26" value="22" onclick="checkParentNode4(this,26,'26_2')" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 26,'22')? 'checked':''} ><fmt:message key='personal.message.office.lend.label' bundle="${v3xPersonalAffairI18N}" />
                                                                         </label>
                                                                   <label for="Option_26_23" style="margin-left: 15px;">
                                                                            <input type="checkbox" id="Option_26_23" name="Option_26" value="23" onclick="checkParentNode4(this,26,'26_2')" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 26,'23')? 'checked':''} ><fmt:message key='personal.message.office.recede.label' bundle="${v3xPersonalAffairI18N}" />
                                                                          </label>
                                                                   </div>
                                                                   </td>
                                                                </tr>
                                                            </table>
                                                          </td>
                                                      </tr>
                                                      <tr>
                                                          <td>
                                                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                                <tr>
                                                                   <td width="100%">
                                                                    <input type="checkbox" id="App_26_3" name="App_26_3" onclick="selectAndSetAll3(26,3)" ><b><fmt:message key='personal.message.office.4.label' bundle="${v3xPersonalAffairI18N}" /></b>
                                                                    <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'26_3');"></span>
                                                                   </td>
                                                                </tr>
                                                                <tr style="display: none;" class="tr_26_3">
                                                                   <td width="100%">
                                                                   <div class="margin_t_5">
                                                                   <label for="Option_26_31" style="margin-left: 15px;">
                                                                            <input type="checkbox" id="Option_26_31" name="Option_26" value="31" onclick="checkParentNode4(this,26,'26_3')" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 26,'31')? 'checked':''} ><fmt:message key='personal.message.office.audit.label' bundle="${v3xPersonalAffairI18N}" />
                                                                          </label>
                                                                   <label for="Option_26_32" style="margin-left: 15px;">
                                                                            <input type="checkbox" id="Option_26_32" name="Option_26" value="32" onclick="checkParentNode4(this,26,'26_3')" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 26,'32')? 'checked':''} ><fmt:message key='personal.message.office.lend.label' bundle="${v3xPersonalAffairI18N}" />
                                                                         </label>
                                                                   <label for="Option_26_33" style="margin-left: 15px;">
                                                                            <input type="checkbox" id="Option_26_33" name="Option_26" value="33" onclick="checkParentNode4(this,26,'26_3')" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 26,'33')? 'checked':''} ><fmt:message key='personal.message.office.recede.label' bundle="${v3xPersonalAffairI18N}" />
                                                                          </label>
                                                                   </div>
                                                                   </td>
                                                                </tr>
                                                            </table>
                                                          </td>
                                                      </tr>
                                                  </table>
                                                  </div>
                                                  </td>
                                              </tr>
                                              </c:if>
                                            <c:if test="${v3x:hasPlugin('meeting')}">
                                            <%--会议 --%>
                                            <tr>
                                                <td>
                                                <div style="margin-top: 10px;">
                                                <label for="App_6">
                                                    <input type="checkbox" id="App_6" name="App" value="6" onclick="selectAndSetAll(6)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 6, null)? 'checked':''}  ><b><fmt:message key='application.6.label' bundle="${v3xSysMgrI18N}" /></b>
                                                </label>
                                                <span class="ico16 arrow_2_t" onclick="trShowOrHide(this,'6_all');"></span>
                                                <input type="hidden" id="AllInput_6" name="AllInput_6" value="${main:isSelectedOfMessageSetting(messageConfigMap, type, 6, 'ALL') ? 'ALL':''}" >
                                                <div class="margin_t_5 tr_6_all">
                                                <label for="CollOption16" style="margin-left: 15px;">
                                                    <input type="checkbox" id="CollOption16" name="Option_6" value="1" onclick="checkParentNode(this,6)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 6,'1')? 'checked':''} ><fmt:message key='personal.message.14.label' bundle="${v3xPersonalAffairI18N}" />
                                                </label>
                                                <label for="CollOption17" style="margin-left: 15px;">
                                                    <input type="checkbox" id="CollOption17" name="Option_6" value="2" onclick="checkParentNode(this,6)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 6,'2')? 'checked':''} ><fmt:message key='personal.message.15.label' bundle="${v3xPersonalAffairI18N}" />
                                                </label>
                                                <label for="CollOption18" style="margin-left: 15px;">
                                                    <input type="checkbox" id="CollOption18" name="Option_6" value="3" onclick="checkParentNode(this,6)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 6,'3')? 'checked':''} ><fmt:message key='personal.message.16.label' bundle="${v3xPersonalAffairI18N}" />
                                                </label>
                                                <c:if test ="${(v3x:getSysFlagByName('meeting_showNotApproval')!='true')}">
	                                                <label for="Option_6_4" style="margin-left: 15px;">
	                                                    <input type="checkbox" id="Option_6_4" name="Option_6" value="4" onclick="checkParentNode(this,6)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 6,'4')? 'checked':''} ><fmt:message key='personal.message.metting.4.label' bundle="${v3xPersonalAffairI18N}" />
	                                                </label>
                                                </c:if>
                                                </div>
                                                </div>
                                                </td>
                                            </tr>
                                            </c:if>
                                            <%--公文管理 --%>
                                            <c:if test ="${(v3x:getSysFlagByName('edoc_notShow')!='true')}">
                                            <c:if test="${v3x:hasPlugin('edoc')}">
                                            <tr>
                                                <td>
                                                <label for="App_4">
                                                    <input type="checkbox" id="App_4" name="App" value="4" onclick="selectAndSetAll(4)" ${main:isSelectedOfMessageSetting(messageConfigMap, type,4, null)? 'checked':''}  ><b><fmt:message key='personal.message.17.label' bundle="${v3xPersonalAffairI18N}" /></b>
                                                </label>
                                                <span class="ico16 arrow_2_t" onclick="trShowOrHide(this,'4_all');"></span>
                                                <input type="hidden" id="AllInput_4" name="AllInput_4" value="${main:isSelectedOfMessageSetting(messageConfigMap, type, 4, 'ALL') ? 'ALL':''}" >
                                                <table class="tr_4_all" width="100%" >
                                                    <tr>
                                                        <td>
                                                           <table>
                                                               <tr>
                                                                 <td width="5%" align="right">
                                                                    <fmt:message key='application.19.label' bundle="${v3xCommonI18N}" />:
                                                                 </td>
                                                                 <td width="10%" align="left">
                                                                 <label for="EdocOption1">
                                                                   <input type="checkbox" id="EdocOption1" name="Option_4" value="1" onclick="checkParentNode(this,4)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 4,'1')? 'checked':''} ><fmt:message key='personal.message.edoc.1.label' />
                                                                 </label>
                                                                 </td>
                                                                 <td width="10%">
                                                                    <label for="EdocOption2" class="margin_l_10">
                                                                   <input type="checkbox" id="EdocOption2" name="Option_4" value="2" onclick="checkParentNode(this,4)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 4,'2')? 'checked':''} ><fmt:message key='personal.message.edoc.2.label' />
                                                                 </label>
                                                                 </td>
                                                                 <td width="10%">
                                                                    <label for="EdocOption3" class="margin_l_10">
                                                                   <input type="checkbox" id="EdocOption3" name="Option_4" value="3" onclick="checkParentNode(this,4)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 4,'3')? 'checked':''} ><fmt:message key='personal.message.edoc.3.label' />
                                                                 </label>
                                                                 </td>
                                                                 <td width="10%">
                                                                    <label for="EdocOption4" class="margin_l_10">
                                                                   <input type="checkbox" id="EdocOption4" name="Option_4" value="4" onclick="checkParentNode(this,4)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 4,'4')? 'checked':''} ><fmt:message key='personal.message.edoc.4.label' />
                                                                 </label>
                                                                 </td>
                                                                 <td width="10%">
                                                                    <label for="EdocOption5" class="margin_l_10">
                                                                   <input type="checkbox" id="EdocOption5" name="Option_4" value="5" onclick="checkParentNode(this,4)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 4,'5')? 'checked':''} ><fmt:message key='personal.message.edoc.5.label' />
                                                                 </label>
                                                                 </td>
                                                                 <td width="10%">
                                                                    <label for="EdocOption18" class="margin_l_10">
                                                                   <input type="checkbox" id="EdocOption18" name="Option_4" value="18" onclick="checkParentNode(this,4)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 4,'18')? 'checked':''} ><fmt:message key='personal.message.edoc.6.label' />
                                                                 </label>
                                                                 </td>
                                                               </tr> 
                                                               <tr>
                                                                 <td width="5%" align="right">
                                                                    <fmt:message key='application.20.label' bundle="${v3xCommonI18N}" />:
                                                                 </td>
                                                                 <td width="10%" align="left">
                                                                 <label for="EdocOption6">
                                                                   <input type="checkbox" id="EdocOption6" name="Option_4" value="6" onclick="checkParentNode(this,4)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 4,'6')? 'checked':''} ><fmt:message key='personal.message.edoc.1.label' />
                                                                 </label>
                                                                 </td>
                                                                 <td width="10%">
                                                                    <label for="EdocOption7" class="margin_l_10">
                                                                   <input type="checkbox" id="EdocOption7" name="Option_4" value="7" onclick="checkParentNode(this,4)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 4,'7')? 'checked':''} ><fmt:message key='personal.message.edoc.2.label' />
                                                                 </label>
                                                                 </td>
                                                                 <td width="10%">
                                                                    <label for="EdocOption8" class="margin_l_10">
                                                                   <input type="checkbox" id="EdocOption8" name="Option_4" value="8" onclick="checkParentNode(this,4)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 4,'8')? 'checked':''} ><fmt:message key='personal.message.edoc.3.label' />
                                                                 </label>
                                                                 </td>
                                                                 <td width="10%">
                                                                    <label for="EdocOption9" class="margin_l_10">
                                                                   <input type="checkbox" id="EdocOption9" name="Option_4" value="9" onclick="checkParentNode(this,4)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 4,'9')? 'checked':''} ><fmt:message key='personal.message.edoc.4.label' />
                                                                 </label>
                                                                 </td>
                                                                 <td width="10%">
                                                                    <label for="EdocOption10" class="margin_l_10">
                                                                   <input type="checkbox" id="EdocOption10" name="Option_4" value="10" onclick="checkParentNode(this,4)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 4,'10')? 'checked':''} ><fmt:message key='personal.message.edoc.5.label' />
                                                                 </label>
                                                                 </td>
                                                                 <td width="10%">
                                                                    <label for="EdocOption19" class="margin_l_10">
                                                                   <input type="checkbox" id="EdocOption19" name="Option_4" value="19" onclick="checkParentNode(this,4)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 4,'19')? 'checked':''} ><fmt:message key='personal.message.edoc.6.label' />
                                                                 </label>
                                                                 </td>
                                                               </tr>
                                                               <tr >
                                                                 <td width="5%" align="right">
                                                                    <fmt:message key='application.21.label' bundle="${v3xCommonI18N}" />:
                                                                 </td>
                                                                 <td width="10%">
                                                                    <label for="EdocOption11">
                                                                   <input type="checkbox" id="EdocOption11" name="Option_4" value="11" onclick="checkParentNode(this,4)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 4,'11')? 'checked':''} ><fmt:message key='personal.message.edoc.1.label' />
                                                                 </label>
                                                                 </td>
                                                                 <td width="10%">
                                                                    <label for="EdocOption12" class="margin_l_10">
                                                                   <input type="checkbox" id="EdocOption12" name="Option_4" value="12" onclick="checkParentNode(this,4)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 4,'12')? 'checked':''} ><fmt:message key='personal.message.edoc.2.label' />
                                                                 </label>
                                                                 </td>
                                                                 <td width="10%">
                                                                    <label for="EdocOption13" class="margin_l_10">
                                                                   <input type="checkbox" id="EdocOption13" name="Option_4" value="13" onclick="checkParentNode(this,4)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 4,'13')? 'checked':''} ><fmt:message key='personal.message.edoc.3.label' />
                                                                 </label>
                                                                 </td>
                                                                 <td width="10%">
                                                                    <label for="EdocOption14" class="margin_l_10">
                                                                   <input type="checkbox" id="EdocOption14" name="Option_4" value="14" onclick="checkParentNode(this,4)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 4,'14')? 'checked':''} ><fmt:message key='personal.message.edoc.4.label' />
                                                                 </label>
                                                                 </td>
                                                                 <td width="10%">
                                                                    <label for="EdocOption15" class="margin_l_10">
                                                                   <input type="checkbox" id="EdocOption15" name="Option_4" value="15" onclick="checkParentNode(this,4)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 4,'15')? 'checked':''} ><fmt:message key='personal.message.edoc.5.label' />
                                                                 </label>
                                                                 </td>
                                                                 <td width="10%">
                                                                    <label for="EdocOption20" class="margin_l_10">
                                                                   <input type="checkbox" id="EdocOption20" name="Option_4" value="20" onclick="checkParentNode(this,4)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 4,'20')? 'checked':''} ><fmt:message key='personal.message.edoc.6.label' />
                                                                 </label>
                                                                 </td>
                                                               </tr>
                                                               <tr style="display: none">
                                                                 <td colspan="6">    
                                                                 <label for="EdocOption16">
                                                                  &nbsp;<input type="checkbox" id="EdocOption16" name="Option_4" value="16" onclick="checkParentNode(this,4)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 4,'16')? 'checked':''} ><fmt:message key='application.16.label' bundle="${v3xCommonI18N}" />
                                                                 </label>
                                                                 </td>
                                                               </tr>
                                                               <tr>
                                                                 <td colspan="6">    
                                                                 <label for="EdocOption17">
                                                                  &nbsp;<input type="checkbox" id="EdocOption17" name="Option_4" value="17" onclick="checkParentNode(this,4)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 4,'17')? 'checked':''} ><fmt:message key='personal.message.18.label' bundle="${v3xPersonalAffairI18N}" />
                                                                 </label>
                                                                 </td>
                                                               </tr>
                                                           </table>
                                                        </td>
                                                    </tr>
                                                </table>
                                                </td>
                                            </tr>
                                            </c:if>
                                            </c:if>
                                            <%--信息报送 --%>
                                            <c:if test="${v3x:hasPlugin('infosend')}">
                                            <tr>
                                                <td>
                                                <div style="margin-top: 10px;">
                                                    <label for="App_32">
                                                        <input type="checkbox" id="App_32" name="App" value="32" onclick="selectAndSetAll(32)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 32, null)? 'checked':''}><b><fmt:message key="menu.info" bundle="${v3xInfo18N}"/></b>
                                                    </label>
                                                    <input type="hidden" id="AllInput_32" name="AllInput_32" value="${main:isSelectedOfMessageSetting(messageConfigMap, type, 32, 'ALL') ? 'ALL':''}" >
                                                </div>
                                                </td>
                                            </tr>
                                            </c:if>
                                            <c:if test="${!empty otherMsgSystemList}">
                                                <c:forEach items="${otherMsgSystemList}" var="sys">
                                                <tr>
                                                    <td>
                                                    <div style="margin-top: 10px;">
                                                        <label for="App_${sys.applicationCategory}">
                                                            <input type="checkbox" id="App_${sys.applicationCategory}" name="App" value="${sys.applicationCategory}" onclick="selectAndSetAll(${sys.applicationCategory})" ${main:isSelectedOfMessageSetting(messageConfigMap, type, sys.applicationCategory, null)? 'checked':''} ${not empty enabledAppEnum&&!v3x:isIntegerInCollection(enabledAppEnum, sys.applicationCategory)? 'disabled':''}><b>${v3x:messageFromResource(sys.i18NResource, sys.displayName)}</b>
                                                        </label>
                                                        <input type="hidden" id="AllInput_${sys.applicationCategory}" name="AllInput_${sys.applicationCategory}" value="${main:isSelectedOfMessageSetting(messageConfigMap, type, sys.applicationCategory, 'ALL')? 'ALL':''}">
                                                    </div>
                                                    </td>
                                                </tr>
                                                </c:forEach>
                                            </c:if>
                                        </table>
                                        </td>
                                        </tr>
                                        <%--第二层右 --%>
                                        <tr align="left" valign="top">
                                         <c:if test="${v3x:hasPlugin('bbs')||v3x:hasPlugin('news')||v3x:hasPlugin('inquiry')||v3x:hasPlugin('bulletin')}">
                                        <td width="50%" height="100%" valign="top">
                                        <table width="100%" cellspacing="10" cellpadding="0">
                                            <tr align="left" valign="top">
                                            <%--文化建设 --%>
                                                <td>
                                                <label for="App_78910">
                                                    <input type="checkbox" id="App_78910"  onclick="selectAndSetAll1('78910')" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 7, null)||main:isSelectedOfMessageSetting(messageConfigMap, type, 8, null)||main:isSelectedOfMessageSetting(messageConfigMap, type, 9, null)||main:isSelectedOfMessageSetting(messageConfigMap, type, 10, null)? 'checked':''} ><b><fmt:message key='personal.message.19.label' bundle="${v3xPersonalAffairI18N}" /></b>
                                                </label>
                                                <span class="ico16 arrow_2_t" onclick="trShowOrHide(this,'78910_all');"></span>
                                                <div class="tr_78910_all" style="margin-left: 15px;">
                                                 <!-- 公告 --> 
                                                 <c:if test="${v3x:hasPlugin('bulletin')}">
                                                        <label for="App_7">
                                                            <input type="checkbox" id="App_7" name="App" value="7" onclick="selectAndSetAll2(7,'78910')" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 7, null)? 'checked':''}><b><fmt:message key="application.7.label" bundle="${v3xCommonI18N}"/></b>
                                                        </label>
                                                        <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'7_all');"></span>
                                                        <input type="hidden" id="AllInput_7" name="AllInput_7" value="${main:isSelectedOfMessageSetting(messageConfigMap, type, 7, 'ALL')? 'ALL':''}">
                                                <div class="tr_7_all hidden" style="margin-left: 15px;">
                                                <!-- 部门公告 -->
                                                <c:set var="list_index_7" value="1" />
                                                <c:if test="${!empty AllDepartmentBulList}">
                                                <c:forEach items="${AllDepartmentBulList}" var="list_map"  >
                                                 <c:if test="${!empty list_map.list}">
                                                    <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td colspan="2">
                                                           <input type="checkbox" id="App7_${list_index_7}" name="App7_Q" value="${list_index_7}" onclick="selectAndSetAll4(7,${list_index_7},false)" ><b>${v3x:toHTML(list_map.spaceName)}</b>
                                                           <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'7_${list_index_7}');"></span>
                                                        </td>
                                                    </tr>
                                                    <tr style="display: none;" class="tr_7_${list_index_7}">
                                                    <c:forEach items="${list_map.list}" var="dept" varStatus="status">
                                                        <input type="hidden" id="DeptBulletinOptionHidden${status.index}" name="Option_Hidden_7_${list_index_7}" value="${dept.id}" />
                                                        <td width="50%" style="padding-left: 15px;">
                                                            <label for="DeptBulletinOption${status.index}"  title="${dept.typeName}">
                                                              <input type="checkbox" id="DeptBulletinOption${status.index}" name="Option7_${list_index_7}" value="${dept.id}" onclick="checkParentNode2(this, 7,${list_index_7})" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 7, dept.id)? 'checked':''}>${v3x:toHTML(v3x:getLimitLengthString(dept.typeName, 20, '...'))}
                                                            </label>
                                                        </td>   
                                                        <c:if test="${(status.index+1)%2==0&&list_map.size!=2}">
                                                        </tr>
                                                        <tr style="display: none;" class="tr_7_${list_index_7}">
                                                        </c:if> 
                                                    </c:forEach>
                                                    <c:if test="${list_map.size==1}">
                                                         <td width="50%">&nbsp;</td> 
                                                    </c:if>
                                                    </tr>
                                                    </table>
                                                  </c:if>
                                                <c:set var="list_index_7" value="${list_index_7+1}" />
                                                </c:forEach>
                                                </c:if>
                                                <!-- 单位公告 -->
                                                <c:if test="${!empty bulletinTypes}">
                                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                   <td colspan="2">
                                                   <input type="checkbox" id="App7_${list_index_7}" name="App7_Q" value="${list_index_7}" onclick="selectAndSetAll4(7,${list_index_7},false)" ><b>${v3x:getAccount(bulletinTypes_id).name}</b>
                                                   <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'7_${list_index_7}');"></span>
                                                 </td>
                                                 </tr>
                                                 <tr style="display: none;" class="tr_7_${list_index_7}">
                                                <c:forEach items="${bulletinTypes}" var="bulType" varStatus="status">
                                                    <input type="hidden" id="BulletinOptionHidden${status.index}" name="Option_Hidden_7_${list_index_7}" value="${bulType.id}" />
                                                    <td width="50%" style="padding-left: 15px;">
                                                        <label for="BulletinOption${status.index}"  title="${bulType.typeName}">
                                                           <input type="checkbox" id="BulletinOption${status.index}" name="Option7_${list_index_7}" value="${bulType.id}" onclick="checkParentNode2(this, 7,${list_index_7})" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 7, bulType.id)? 'checked':''}>${v3x:toHTML(v3x:getLimitLengthString(bulType.typeName, 20, '...'))}
                                                        </label>
                                                    </td>   
                                                    <c:if test="${(status.index+1)%2==0&&bulletinTypes_size!=2}">
                                                    </tr>
                                                    <tr style="display: none;" class="tr_7_${list_index_7}">
                                                    </c:if>
                                                    </c:forEach>
                                                    <c:if test="${bulletinTypes_size==1}">
                                                         <td width="50%">&nbsp;</td> 
                                                    </c:if>
                                                </tr>
                                                </table>
                                                <c:set var="list_index_7" value="${list_index_7+1}" />
                                                </c:if>
                                                <!-- 集团公告 -->
                                                <c:if test="${!empty groupBulletinTypes}">
                                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                   <td colspan="2">
                                                   <input type="checkbox" id="App7_${list_index_7}" name="App7_Q" value="${list_index_7}" onclick="selectAndSetAll4(7,${list_index_7},false)"><b>${v3x:getAccount(groupBulletinTypes_id).name}</b>
                                                   <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'7_${list_index_7}');"></span>
                                                 </td>
                                                 </tr>
                                                 <tr style="display: none;" class="tr_7_${list_index_7}">
                                                <c:forEach items="${groupBulletinTypes}" var="groupBulType" varStatus="status">
                                                    <input type="hidden" id="GroupBulletinOptionHidden${status.index}" name="Option_Hidden_7_${list_index_7}" value="${groupBulType.id}" />
                                        
                                                    <td width="50%" style="padding-left: 15px;">
                                                    <label for="GroupBulletinOption${status.index}" title="${groupBulType.typeName}">
                                                        <input type="checkbox" id="GroupBulletinOption${status.index}" name="Option7_${list_index_7}" value="${groupBulType.id}" onclick="checkParentNode2(this, 7,${list_index_7})" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 7, groupBulType.id)? 'checked':''} >${v3x:toHTML(v3x:getLimitLengthString(groupBulType.typeName, 20, '...'))}
                                                    </label>
                                                    </td>
                                                    <c:if test="${(status.index+1)%2==0&&groupBulletinTypes_size!=2}">
                                                    </tr>
                                                    <tr style="display: none;" class="tr_7_${list_index_7}">
                                                    </c:if>
                                                
                                                    </c:forEach>
                                                    <c:if test="${groupBulletinTypes_size==1}">
                                                         <td width="50%">&nbsp;</td> 
                                                    </c:if>
                                                </tr>
                                                </table>
                                                <c:set var="list_index_7" value="${list_index_7+1}" />
                                                 </c:if>
                                                 <!-- 自定义团队公告 -->
                                                 <c:if test="${!empty AllCustomBulList}">
                                                <c:forEach items="${AllCustomBulList}" var="list_map" >
                                                 <c:if test="${!empty list_map.list}">
                                                    <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td colspan="2">
                                                           <input type="checkbox" id="App7_${list_index_7}" name="App7_Q" value="${list_index_7}" onclick="selectAndSetAll4(7,${list_index_7},false)" ><b>${v3x:toHTML(list_map.spaceName)}</b>
                                                           <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'7_${list_index_7}');"></span>
                                                        </td>
                                                    </tr>
                                                    <tr style="display: none;" class="tr_7_${list_index_7}">
                                                    <c:forEach items="${list_map.list}" var="dept" varStatus="status">
                                                        <input type="hidden" id="DeptBulletinOptionHidden${status.index}" name="Option_Hidden_7_${list_index_7}" value="${dept.id}" />
                                                        <td width="50%" style="padding-left: 15px;">
                                                            <label for="DeptBulletinOption${status.index}" title="${dept.typeName}">
                                                              <input type="checkbox" id="DeptBulletinOption${status.index}" name="Option7_${list_index_7}" value="${dept.id}" onclick="checkParentNode2(this, 7,${list_index_7})" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 7, dept.id)? 'checked':''}>${v3x:toHTML(v3x:getLimitLengthString(dept.typeName, 20, '...'))}
                                                            </label>
                                                        </td>   
                                                        <c:if test="${(status.index+1)%2==0&&list_map.size!=2}">
                                                        </tr>
                                                        <tr style="display: none;" class="tr_7_${list_index_7}">
                                                        </c:if> 
                                                    </c:forEach>
                                                    <c:if test="${list_map.size==1}">
                                                         <td width="50%">&nbsp;</td> 
                                                    </c:if>
                                                    </tr>
                                                    </table>
                                                  </c:if>
                                                <c:set var="list_index_7" value="${list_index_7+1}" />
                                                </c:forEach>
                                                </c:if>
                                                 <!-- 自定义单位公告 -->
                                                 <c:if test="${!empty AllPublicCustomBulList}">
                                                <c:forEach items="${AllPublicCustomBulList}" var="list_map"  >
                                                 <c:if test="${!empty list_map.list}">
                                                    <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td colspan="2">
                                                           <input type="checkbox" id="App7_${list_index_7}" name="App7_Q" value="${list_index_7}" onclick="selectAndSetAll4(7,${list_index_7},false)" ><b>${v3x:toHTML(list_map.spaceName)}</b>
                                                           <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'7_${list_index_7}');"></span>
                                                        </td>
                                                    </tr>
                                                    <tr style="display: none;" class="tr_7_${list_index_7}">
                                                    <c:forEach items="${list_map.list}" var="dept" varStatus="status">
                                                        <input type="hidden" id="DeptBulletinOptionHidden${status.index}" name="Option_Hidden_7_${list_index_7}" value="${dept.id}" />
                                                        <td width="50%" style="padding-left: 15px;">
                                                            <label for="DeptBulletinOption${status.index}" title="${dept.typeName}">
                                                              <input type="checkbox" id="DeptBulletinOption${status.index}" name="Option7_${list_index_7}" value="${dept.id}" onclick="checkParentNode2(this, 7,${list_index_7})" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 7, dept.id)? 'checked':''}>${v3x:toHTML(v3x:getLimitLengthString(dept.typeName, 20, '...'))}
                                                            </label>
                                                        </td>   
                                                        <c:if test="${(status.index+1)%2==0&&list_map.size!=2}">
                                                        </tr>
                                                        <tr style="display: none;" class="tr_7_${list_index_7}">
                                                        </c:if> 
                                                    </c:forEach>
                                                    <c:if test="${list_map.size==1}">
                                                         <td width="50%">&nbsp;</td> 
                                                    </c:if>
                                                    </tr>
                                                    </table>
                                                  </c:if>
                                                <c:set var="list_index_7" value="${list_index_7+1}" />
                                                </c:forEach>
                                                </c:if>
                                                 <!-- 自定义集团公告 -->
                                                 <c:if test="${!empty AllPublicCustomGroupBulList}">
                                                <c:forEach items="${AllPublicCustomGroupBulList}" var="list_map" >
                                                 <c:if test="${!empty list_map.list}">
                                                    <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td colspan="2">
                                                           <input type="checkbox" id="App7_${list_index_7}" name="App7_Q" value="${list_index_7}" onclick="selectAndSetAll4(7,${list_index_7},false)" ><b>${v3x:toHTML(list_map.spaceName)}</b>
                                                           <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'7_${list_index_7}');"></span>
                                                        </td>
                                                    </tr>
                                                    <tr style="display: none;" class="tr_7_${list_index_7}">
                                                    <c:forEach items="${list_map.list}" var="dept" varStatus="status">
                                                        <input type="hidden" id="DeptBulletinOptionHidden${status.index}" name="Option_Hidden_7_${list_index_7}" value="${dept.id}" />
                                                        <td width="50%" style="padding-left: 15px;">
                                                            <label for="DeptBulletinOption${status.index}" title="${dept.typeName}">
                                                              <input type="checkbox" id="DeptBulletinOption${status.index}" name="Option7_${list_index_7}" value="${dept.id}" onclick="checkParentNode2(this, 7,${list_index_7})" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 7, dept.id)? 'checked':''}>${v3x:toHTML(v3x:getLimitLengthString(dept.typeName, 20, '...'))}
                                                            </label>
                                                        </td>   
                                                        <c:if test="${(status.index+1)%2==0&&list_map.size!=2}">
                                                        </tr>
                                                        <tr style="display: none;" class="tr_7_${list_index_7}">
                                                        </c:if> 
                                                    </c:forEach>
                                                    <c:if test="${list_map.size==1}">
                                                         <td width="50%">&nbsp;</td> 
                                                    </c:if>
                                                    </tr>
                                                    </table>
                                                  </c:if>
                                                <c:set var="list_index_7" value="${list_index_7+1}" />
                                                </c:forEach>
                                                </c:if>
                                                </div>
                                                </c:if>
                                                <br>
                                                <!-- 新闻 --> 
                                                <c:if test="${v3x:hasPlugin('news')}">
                                                        <label for="App_8">
                                                            <input type="checkbox" id="App_8" name="App" value="8" onclick="selectAndSetAll2(8,'78910')" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 8, null)? 'checked':''} ><b><fmt:message key="application.8.label" bundle="${v3xCommonI18N}"/></b>
                                                        </label>
                                                        <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'8_all');"></span>
                                                        <input type="hidden" id="AllInput_8" name="AllInput_8" value="${main:isSelectedOfMessageSetting(messageConfigMap, type, 8, 'ALL')? 'ALL':''}">
                                               <div class="tr_8_all hidden" style="margin-left: 15px;">
                                               <c:set var="list_index_8" value="1" />
                                               <!-- 单位新闻 -->
                                                <c:if test="${!empty newsTypes}">
                                                 <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                   <td colspan="2">
                                                   <input type="checkbox" id="App8_${list_index_8}" name="App8_Q" value="${list_index_8}" onclick="selectAndSetAll4(8,${list_index_8},false)" ><b>${v3x:getAccount(newsTypes_id).name}</b>
                                                   <span class="ico16 arrow_2_b"onclick="trShowOrHide(this,'8_${list_index_8}');"></span>
                                                 </td>
                                                 </tr>
                                                 <tr style="display: none;" class="tr_8_${list_index_8}">
                                                <c:forEach items="${newsTypes}" var="newsType" varStatus="status">
                                                    <input type="hidden" id="NewsOptionHidden${status.index}" name="Option_Hidden_8_${list_index_8}" value="${newsType.id}" />
                                                    <td width="30%" style="padding-left: 15px;">
                                                    <label for="NewsOption${status.index}"  title="${newsType.typeName}">
                                                        <input type="checkbox" id="NewsOption${status.index}" name="Option8_${list_index_8}" value="${newsType.id}" onclick="checkParentNode2(this, 8,${list_index_8})" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 8, newsType.id)? 'checked':''} >${v3x:toHTML(v3x:getLimitLengthString(newsType.typeName, 20, '...'))}
                                                    </label>
                                                    </td>
                                                    <c:if test="${(status.index+1)%2==0&&newsTypes_size!=2}">
                                                    </tr>
                                                        <tr style="display: none;" class="tr_8_${list_index_8}">
                                                    </c:if>
                                                    
                                                  </c:forEach>
                                                    <c:if test="${newsTypes_size==1}">
                                                         <td width="30%">&nbsp;</td> 
                                                    </c:if>
                                                </tr>
                                                </table>
                                                <c:set var="list_index_8" value="${list_index_8+1}" />
                                                 </c:if>
                                                  <!-- 集团新闻 -->
                                                <c:if test="${!empty groupNewsTypes}">
                                                 <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                <tr>
                                                   <td colspan="2">
                                                   <input type="checkbox" id="App8_${list_index_8}" name="App8_Q" value="${list_index_8}" onclick="selectAndSetAll4(8,${list_index_8},false)" ><b>${v3x:getAccount(groupNewsTypes_id).name}</b>
                                                   <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'8_${list_index_8}');"></span>
                                                 </td>
                                                 </tr>
                                                <tr style="display: none;" class="tr_8_${list_index_8}">
                                                <c:forEach items="${groupNewsTypes}" var="groupNewsType" varStatus="status">
                                                    <input type="hidden" id="GroupNewsOptionHidden${status.index}" name="Option_Hidden_8_${list_index_8}" value="${groupNewsType.id}" />
                                                    <td width="30%" style="padding-left: 15px;">
                                                    <label for="GroupNewsOption${status.index}"  title="${groupNewsType.typeName}">
                                                        <input type="checkbox" id="GroupNewsOption${status.index}" name="Option8_${list_index_8}" value="${groupNewsType.id}" onclick="checkParentNode2(this, 8,${list_index_8})" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 8, groupNewsType.id)? 'checked':''} >${v3x:toHTML(v3x:getLimitLengthString(groupNewsType.typeName, 20, '...'))}
                                                    </label>
                                                    </td>
                                                    <c:if test="${(status.index+1)%2==0&&groupNewsTypes_size!=2}">
                                                    </tr>
                                                    <tr style="display: none;" class="tr_8_${list_index_8}">
                                                    </c:if>
                                                
                                                    </c:forEach>
                                                    <c:if test="${groupNewsTypes_size==1}">
                                                         <td width="30%">&nbsp;</td> 
                                                    </c:if>
                                                </tr>
                                                </table>
                                                <c:set var="list_index_8" value="${list_index_8+1}" />
                                                 </c:if>
                                                 <!-- 自定义团队新闻 -->
                                                <c:if test="${!empty AllCustomNewsList}">
                                                <c:forEach items="${AllCustomNewsList}" var="list_map" >
                                                 <c:if test="${!empty list_map.list}">
                                                     <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td colspan="2">
                                                           <input type="checkbox" id="App8_${list_index_8}" name="App8_Q" value="${list_index_8}" onclick="selectAndSetAll4(8,${list_index_8},false)" ><b>${v3x:toHTML(list_map.spaceName)}</b>
                                                           <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'8_${list_index_8}');"></span>
                                                        </td>
                                                    </tr>
                                                    <tr style="display: none;" class="tr_8_${list_index_8}">
                                                    <c:forEach items="${list_map.list}" var="dept" varStatus="status">
                                                        <input type="hidden" id="DeptBulletinOptionHidden${status.index}" name="Option_Hidden_8_${list_index_8}" value="${dept.id}" />
                                                        <td width="30%" style="padding-left: 15px;">
                                                            <label for="DeptBulletinOption${status.index}"  title="${dept.typeName}">
                                                              <input type="checkbox" id="DeptBulletinOption${status.index}" name="Option8_${list_index_8}" value="${dept.id}" onclick="checkParentNode2(this, 8,${list_index_8})" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 8, dept.id)? 'checked':''}>${v3x:toHTML(v3x:getLimitLengthString(dept.typeName, 20, '...'))}
                                                            </label>
                                                        </td>   
                                                        <c:if test="${(status.index+1)%2==0&&list_map.size!=2}">
                                                        </tr>
                                                        <tr style="display: none;" class="tr_8_${list_index_8}">
                                                        </c:if> 
                                                    </c:forEach>
                                                    <c:if test="${list_map.size==1}">
                                                         <td width="30%">&nbsp;</td> 
                                                    </c:if>
                                                    </tr>
                                                    </table>
                                                  </c:if>
                                                <c:set var="list_index_8" value="${list_index_8+1}" />
                                                </c:forEach>
                                                </c:if>
                                                 <!-- 自定义单位新闻 -->
                                                <c:if test="${!empty AllPublicCustomNewsList}">
                                                <c:forEach items="${AllPublicCustomNewsList}" var="list_map" >
                                                 <c:if test="${!empty list_map.list}">
                                                     <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td colspan="2">
                                                           <input type="checkbox" id="App8_${list_index_8}" name="App8_Q" value="${list_index_8}" onclick="selectAndSetAll4(8,${list_index_8},false)" ><b>${v3x:toHTML(list_map.spaceName)}</b>
                                                           <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'8_${list_index_8}');"></span>
                                                        </td>
                                                    </tr>
                                                    <tr style="display: none;" class="tr_8_${list_index_8}">
                                                    <c:forEach items="${list_map.list}" var="dept" varStatus="status">
                                                        <input type="hidden" id="DeptBulletinOptionHidden${status.index}" name="Option_Hidden_8_${list_index_8}" value="${dept.id}" />
                                                        <td width="30%" style="padding-left: 15px;">
                                                            <label for="DeptBulletinOption${status.index}"  title="${dept.typeName}">
                                                              <input type="checkbox" id="DeptBulletinOption${status.index}" name="Option8_${list_index_8}" value="${dept.id}" onclick="checkParentNode2(this, 8,${list_index_8})" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 8, dept.id)? 'checked':''}>${v3x:toHTML(v3x:getLimitLengthString(dept.typeName, 20, '...'))}
                                                            </label>
                                                        </td>   
                                                        <c:if test="${(status.index+1)%2==0&&list_map.size!=2}">
                                                        </tr>
                                                        <tr style="display: none;" class="tr_8_${list_index_8}">
                                                        </c:if> 
                                                    </c:forEach>
                                                    <c:if test="${list_map.size==1}">
                                                         <td width="30%">&nbsp;</td> 
                                                    </c:if>
                                                    </tr>
                                                    </table>
                                                  </c:if>
                                                <c:set var="list_index_8" value="${list_index_8+1}" />
                                                </c:forEach>
                                                </c:if>
                                                 <!-- 自定义集团新闻 -->
                                                <c:if test="${!empty AllPublicCustomGroupNewsList}">
                                                <c:forEach items="${AllPublicCustomGroupNewsList}" var="list_map" >
                                                 <c:if test="${!empty list_map.list}">
                                                     <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                        <td colspan="2">
                                                           <input type="checkbox" id="App8_${list_index_8}" name="App8_Q" value="${list_index_8}" onclick="selectAndSetAll4(8,${list_index_8},false)" ><b>${v3x:toHTML(list_map.spaceName)}</b>
                                                           <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'8_${list_index_8}');"></span>
                                                        </td>
                                                    </tr>
                                                    <tr style="display: none;" class="tr_8_${list_index_8}">
                                                    <c:forEach items="${list_map.list}" var="dept" varStatus="status">
                                                        <input type="hidden" id="DeptBulletinOptionHidden${status.index}" name="Option_Hidden_8_${list_index_8}" value="${dept.id}" />
                                                        <td width="30%" style="padding-left: 15px;">
                                                            <label for="DeptBulletinOption${status.index}" title="${dept.typeName}">
                                                              <input type="checkbox" id="DeptBulletinOption${status.index}" name="Option8_${list_index_8}" value="${dept.id}" onclick="checkParentNode2(this, 8,${list_index_8})" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 8, dept.id)? 'checked':''}>${v3x:toHTML(v3x:getLimitLengthString(dept.typeName, 20, '...'))}
                                                            </label>
                                                        </td>   
                                                        <c:if test="${(status.index+1)%2==0&&list_map.size!=2}">
                                                        </tr>
                                                        <tr style="display: none;" class="tr_8_${list_index_8}">
                                                        </c:if> 
                                                    </c:forEach>
                                                    <c:if test="${list_map.size==1}">
                                                         <td width="30%">&nbsp;</td> 
                                                    </c:if>
                                                    </tr>
                                                    </table>
                                                  </c:if>
                                                <c:set var="list_index_8" value="${list_index_8+1}" />
                                                </c:forEach>
                                                </c:if>
                                                </div>
                                               </c:if>
                                               <br>
                                                <!-- 讨论 --> 
                                                <c:if test="${v3x:hasPlugin('bbs')}">
                                                    <label for="App_9">
                                                        <input type="checkbox" id="App_9" name="App" value="9" onclick="selectAndSetAll2(9,'78910')" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 9, null)? 'checked':''}><b><fmt:message key="application.9.label" bundle="${v3xCommonI18N}"/></b>
                                                    </label>
                                                    <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'9_all');"></span>
                                                    <input type="hidden" id="AllInput_9" name="AllInput_9" value="${main:isSelectedOfMessageSetting(messageConfigMap, type, 9, 'ALL')? 'ALL':''}">
                                                     <div class="tr_9_all hidden" style="margin-left: 15px;">
                                                     <c:set var="list_index_9" value="1" />
                                                    <!-- 部门讨论 -->
                                                       <c:if test="${!empty AllDepartmentBbsList}">
                                                        <c:forEach items="${AllDepartmentBbsList}" var="list_map" >
                                                         <c:if test="${!empty list_map.list}">
                                                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td colspan="2">
                                                                   <input type="checkbox" id="App9_${list_index_9}" name="App9_Q" value="${list_index_9}" onclick="selectAndSetAll4(9,${list_index_9},false)" ><b>${v3x:toHTML(list_map.spaceName)}</b>
                                                                   <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'9_${list_index_9}');"></span>
                                                                </td>
                                                            </tr>
                                                            <tr style="display: none;" class="tr_9_${list_index_9}">
                                                            <c:forEach items="${list_map.list}" var="dept" varStatus="status">
                                                                <input type="hidden" id="DeptBulletinOptionHidden${status.index}" name="Option_Hidden_9_${list_index_9}" value="${dept.id}" />
                                                                <td width="30%" style="padding-left: 15px;">
                                                                    <label for="DeptBulletinOption${status.index}" title="${dept.name}">
                                                                      <input type="checkbox" id="DeptBulletinOption${status.index}" name="Option9_${list_index_9}" value="${dept.id}" onclick="checkParentNode2(this, 9,${list_index_9})" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 9, dept.id)? 'checked':''}>${v3x:toHTML(v3x:getLimitLengthString(dept.name, 20, '...'))}
                                                                    </label>
                                                                </td>   
                                                                <c:if test="${(status.index+1)%2==0&&list_map.size!=2}">
                                                                </tr>
                                                                <tr style="display: none;" class="tr_9_${list_index_9}">
                                                                </c:if> 
                                                            </c:forEach>
                                                            <c:if test="${list_map.size==1}">
                                                                 <td width="30%">&nbsp;</td> 
                                                            </c:if>
                                                            </tr>
                                                            </table>
                                                          </c:if>
                                                        <c:set var="list_index_9" value="${list_index_9+1}" />
                                                        </c:forEach>
                                                        </c:if>
                                                        <!-- 单位讨论 -->
                                                <c:if test="${!empty bbsBoards}">
                                                        <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                        <tr>
                                                          <td colspan="2">
                                                          <input type="checkbox" id="App9_${list_index_9}" name="App9_Q" value="${list_index_9}" onclick="selectAndSetAll4(9,${list_index_9},false)" ><b>${v3x:getAccount(bbsBoards_id).name}</b>
                                                          <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'9_${list_index_9}');"></span>
                                                          </td>
                                                             </tr>
                                                            <tr style="display: none;" class="tr_9_${list_index_9}">
                                                        <c:forEach items="${bbsBoards}" var="board" varStatus="status">
                                                            <input type="hidden" id="BBSOptionHidden${status.index}" name="Option_Hidden_9_${list_index_9}" value="${board.id}" />
                                                          <td width="30%" style="padding-left: 15px;">
                                                            <label for="BBSOption${status.index}"  title="${board.name}">
                                                                <input type="checkbox" id="BBSOption${status.index}" name="Option9_${list_index_9}" value="${board.id}" onclick="checkParentNode2(this, 9,${list_index_9})" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 9, board.id)? 'checked':''}>${v3x:toHTML(v3x:getLimitLengthString(board.name, 20, '...'))}
                                                            </label>
                                                            </td>
                                                           <c:if test="${(status.index+1)%2==0&&bbsBoards_size!=2}">
                                                                </tr>
                                                                <tr style="display: none;" class="tr_9_${list_index_9}">
                                                                </c:if>
                                                       
                                                    </c:forEach>
                                                    <c:if test="${bbsBoards_size==1}">
                                                         <td width="30%">&nbsp;</td> 
                                                    </c:if>
                                                        </tr>
                                                        </table>
                                                        <c:set var="list_index_9" value="${list_index_9+1}" />
                                                        </c:if>
                                                        <!-- 集团讨论 -->
                                                <c:if test="${!empty groupBbsBoards}">
                                                        <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                        <tr>
                                                               <td colspan="2">
                                                               <input type="checkbox" id="App9_${list_index_9}" name="App9_Q" value="${list_index_9}" onclick="selectAndSetAll4(9,${list_index_9},false)"><b>${v3x:getAccount(groupBbsBoards_id).name}</b>
                                                               <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'9_${list_index_9}');" ></span>
                                                             </td>
                                                             </tr>
                                                            <tr style="display: none;" class="tr_9_${list_index_9}">
                                                        <c:forEach items="${groupBbsBoards}" var="groupBoard" varStatus="status">
                                                            <input type="hidden" id="GroupBBSOptionHidden${status.index}" name="Option_Hidden_9_${list_index_9}" value="${groupBoard.id}" />
                                                           <td width="30%" style="padding-left: 15px;">
                                                            <label for="GroupBBSOption${status.index}" title="${groupBoard.name}">
                                                               <input type="checkbox" id="GroupBBSOption${status.index}" name="Option9_${list_index_9}" value="${groupBoard.id}" onclick="checkParentNode2(this, 9,${list_index_9})" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 9, groupBoard.id)? 'checked':''} >${v3x:toHTML(v3x:getLimitLengthString(groupBoard.name, 20, '...'))}
                                                            </label>
                                                            </td>
                                                            <c:if test="${(status.index+1)%2==0&&groupBbsBoards_size!=2}">
                                                                </tr>
                                                                <tr style="display: none;" class="tr_9_${list_index_9}">
                                                            </c:if>  
                                                            
                                                    </c:forEach>
                                                    <c:if test="${groupBbsBoards_size==1}">
                                                         <td width="30%">&nbsp;</td> 
                                                    </c:if>
                                                        </tr>
                                                        </table>
                                                        <c:set var="list_index_9" value="${list_index_9+1}" />
                                                         </c:if>
                                                         <!-- 自定义团队讨论 -->
                                                     <c:if test="${!empty AllCustomBbsList}">
                                                        <c:forEach items="${AllCustomBbsList}" var="list_map" >
                                                         <c:if test="${!empty list_map.list}">
                                                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td colspan="2">
                                                                   <input type="checkbox" id="App9_${list_index_9}" name="App9_Q" value="${list_index_9}" onclick="selectAndSetAll4(9,${list_index_9},false)" ><b>${v3x:toHTML(list_map.spaceName)}</b>
                                                                   <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'9_${list_index_9}');"></span>
                                                                </td>
                                                            </tr>
                                                            <tr style="display: none;" class="tr_9_${list_index_9}">
                                                            <c:forEach items="${list_map.list}" var="dept" varStatus="status">
                                                                <input type="hidden" id="DeptBulletinOptionHidden${status.index}" name="Option_Hidden_9_${list_index_9}" value="${dept.id}" />
                                                                <td width="30%" style="padding-left: 15px;">
                                                                    <label for="DeptBulletinOption${status.index}" title="${dept.name}">
                                                                      <input type="checkbox" id="DeptBulletinOption${status.index}" name="Option9_${list_index_9}" value="${dept.id}" onclick="checkParentNode2(this, 9,${list_index_9})" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 9, dept.id)? 'checked':''}>${v3x:toHTML(v3x:getLimitLengthString(dept.name, 20, '...'))}
                                                                    </label>
                                                                </td>   
                                                                <c:if test="${(status.index+1)%2==0&&list_map.size!=2}">
                                                                </tr>
                                                                <tr style="display: none;" class="tr_9_${list_index_9}">
                                                                </c:if> 
                                                            </c:forEach>
                                                            <c:if test="${list_map.size==1}">
                                                                 <td width="30%">&nbsp;</td> 
                                                            </c:if>
                                                            </tr>
                                                            </table>
                                                          </c:if>
                                                        <c:set var="list_index_9" value="${list_index_9+1}" />
                                                        </c:forEach>
                                                        </c:if>
                                                         <!-- 自定义单位讨论 -->
                                               <c:if test="${!empty AllPublicCustomBbsList}">
                                                        <c:forEach items="${AllPublicCustomBbsList}" var="list_map" >
                                                         <c:if test="${!empty list_map.list}">
                                                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td colspan="2">
                                                                   <input type="checkbox" id="App9_${list_index_9}" name="App9_Q" value="${list_index_9}" onclick="selectAndSetAll4(9,${list_index_9},false)" ><b>${v3x:toHTML(list_map.spaceName)}</b>
                                                                   <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'9_${list_index_9}');"></span>
                                                                </td>
                                                            </tr>
                                                            <tr style="display: none;" class="tr_9_${list_index_9}">
                                                            <c:forEach items="${list_map.list}" var="dept" varStatus="status">
                                                                <input type="hidden" id="DeptBulletinOptionHidden${status.index}" name="Option_Hidden_9_${list_index_9}" value="${dept.id}" />
                                                                <td width="30%" style="padding-left: 15px;">
                                                                    <label for="DeptBulletinOption${status.index}" title="${dept.name}">
                                                                      <input type="checkbox" id="DeptBulletinOption${status.index}" name="Option9_${list_index_9}" value="${dept.id}" onclick="checkParentNode2(this, 9,${list_index_9})" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 9, dept.id)? 'checked':''}>${v3x:toHTML(v3x:getLimitLengthString(dept.name, 20, '...'))}
                                                                    </label>
                                                                </td>   
                                                                <c:if test="${(status.index+1)%2==0&&list_map.size!=2}">
                                                                </tr>
                                                                <tr style="display: none;" class="tr_9_${list_index_9}">
                                                                </c:if> 
                                                            </c:forEach>
                                                            <c:if test="${list_map.size==1}">
                                                                 <td width="30%">&nbsp;</td> 
                                                            </c:if>
                                                            </tr>
                                                            </table>
                                                          </c:if>
                                                        <c:set var="list_index_9" value="${list_index_9+1}" />
                                                        </c:forEach>
                                                        </c:if>
                                                         <!-- 自定义集团讨论 -->
                                                       <c:if test="${!empty AllPublicCustomGroupBbsList}">
                                                        <c:forEach items="${AllPublicCustomGroupBbsList}" var="list_map" >
                                                         <c:if test="${!empty list_map.list}">
                                                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td colspan="2">
                                                                   <input type="checkbox" id="App9_${list_index_9}" name="App9_Q" value="${list_index_9}" onclick="selectAndSetAll4(9,${list_index_9},false)" ><b>${v3x:toHTML(list_map.spaceName)}</b>
                                                                   <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'9_${list_index_9}');"></span>
                                                                </td>
                                                            </tr>
                                                            <tr style="display: none;" class="tr_9_${list_index_9}">
                                                            <c:forEach items="${list_map.list}" var="dept" varStatus="status">
                                                                <input type="hidden" id="DeptBulletinOptionHidden${status.index}" name="Option_Hidden_9_${list_index_9}" value="${dept.id}" />
                                                                <td width="30%" style="padding-left: 15px;">
                                                                    <label for="DeptBulletinOption${status.index}" title="${dept.name}">
                                                                      <input type="checkbox" id="DeptBulletinOption${status.index}" name="Option9_${list_index_9}" value="${dept.id}" onclick="checkParentNode2(this, 9,${list_index_9})" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 9, dept.id)? 'checked':''}>${v3x:toHTML(v3x:getLimitLengthString(dept.name, 20, '...'))}
                                                                    </label>
                                                                </td>   
                                                                <c:if test="${(status.index+1)%2==0&&list_map.size!=2}">
                                                                </tr>
                                                                <tr style="display: none;" class="tr_9_${list_index_9}">
                                                                </c:if> 
                                                            </c:forEach>
                                                            <c:if test="${list_map.size==1}">
                                                                 <td width="30%">&nbsp;</td> 
                                                            </c:if>
                                                            </tr>
                                                            </table>
                                                          </c:if>
                                                        <c:set var="list_index_9" value="${list_index_9+1}" />
                                                        </c:forEach>
                                                        </c:if>
                                                          <!-- 项目讨论 -->
                                                        <c:if test="${projectList_size>0}">
                                                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                               <td colspan="2">
                                                               <input type="checkbox" id="App9_${list_index_9}" name="App9_Q" value="${list_index_9}" onclick="selectAndSetAll4(9,${list_index_9},false)" ><b>项目讨论</b>
                                                               <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'9_${list_index_9}');"></span>
                                                             </td>
                                                             </tr>
                                                            <tr style="display: none;" class="tr_9_${list_index_9}">
                                                            <c:forEach items="${projectList}" var="project" varStatus="status">
                                                                <input type="hidden" id="ProjectBbsOptionHidden${status.index}" name="Option_Hidden_9_${list_index_9}" value="${project.id}" />
                                                                <td width="30%" style="padding-left: 15px;">
                                                                <label for="ProjectBbsOption${status.index}" title="${v3x:toHTML(project.projectName)}">
                                                                    <input type="checkbox" id="ProjectBbsOption${status.index}" name="Option9_${list_index_9}" value="${project.id}" onclick="checkParentNode2(this, 9,${list_index_9})" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 9, project.id)? 'checked':''}>${v3x:toHTML(v3x:getLimitLengthString(project.projectName, 20, '...'))}
                                                                </label>
                                                                </td>
                                                                <c:if test="${(status.index+1)%2==0&&projectList_size!=2}">
                                                                </tr>
                                                                <tr style="display: none;" class="tr_9_${list_index_9}">
                                                                </c:if>
                                                    </c:forEach>
                                                    <c:if test="${projectList_size==1}">
                                                         <td width="30%">&nbsp;</td> 
                                                    </c:if>
                                                            </tr>
                                                            </table>
                                                            <c:set var="list_index_9" value="${list_index_9+1}" />
                                                        </c:if>
                                                        </div>
                                                </c:if>
                                                <br>
                                                <!-- 调查 --> 
                                                <c:if test="${v3x:hasPlugin('inquiry')}">
                                                    <label for="App_10">
                                                        <input type="checkbox" id="App_10" name="App" value="10" onclick="selectAndSetAll2(10,'78910')" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 10, null)? 'checked':''} ><b><fmt:message key="application.10.label" bundle="${v3xCommonI18N}"/></b>
                                                    </label>
                                                    <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'10_all');"></span>
                                                    <input type="hidden" id="AllInput_10" name="AllInput_10" value="${main:isSelectedOfMessageSetting(messageConfigMap, type, 10, 'ALL')? 'ALL':''}">
                                                <div class="tr_10_all hidden" style="margin-left: 15px;">
                                                <!-- 单位调查 -->
                                                <c:set var="list_index_10" value="1" />
                                              <c:if test="${!empty inquiryTypes}">
                                                <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                       <td colspan="2">
                                                        <input type="checkbox" id="App10_${list_index_10}" name="App10_Q" value="${list_index_10}" onclick="selectAndSetAll4(10,${list_index_10},false)"><b>${v3x:getAccount(inquiryTypes_id).name}</b>
                                                        <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'10_${list_index_10}');" ></span>
                                                     </td>
                                                     </tr>
                                                    <tr style="display: none;" class="tr_10_${list_index_10}">
                                                    <c:forEach items="${inquiryTypes}" var="inquiryType" varStatus="status">
                                                        <input type="hidden" id="InquiryOptionHidden${status.index}" name="Option_Hidden_10_${list_index_10}" value="${inquiryType.inquirySurveytype.id}" />
                                                        <td width="30%" style="padding-left: 15px;">
                                                        <label for="InquiryOption${status.index}" title="${inquiryType.inquirySurveytype.typeName}">
                                                           <input type="checkbox" id="InquiryOption${status.index}" name="Option10_${list_index_10}" value="${inquiryType.inquirySurveytype.id}" onclick="checkParentNode2(this, 10,${list_index_10})" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 10, inquiryType.inquirySurveytype.id)? 'checked':''} >${v3x:toHTML(v3x:getLimitLengthString(inquiryType.inquirySurveytype.typeName, 20, '...'))}
                                                        </label>
                                                        </td>
                                                         <c:if test="${(status.index+1)%2==0&&inquiryTypes_size!=2}">
                                                        </tr>
                                                        <tr style="display: none;" class="tr_10_${list_index_10}">
                                                        </c:if>
                                                    
                                                    </c:forEach>
                                                    <c:if test="${inquiryTypes_size==1}">
                                                         <td width="30%">&nbsp;</td> 
                                                    </c:if>
                                                    </tr>
                                                    </table>
                                                    <c:set var="list_index_10" value="${list_index_10+1}" />
                                                     </c:if>
                                                  <!--集团调查 -->
                                                <c:if test="${!empty groupInquiryTypes}">
                                                    <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                    <tr>
                                                       <td colspan="2">
                                                       <input type="checkbox" id="App10_${list_index_10}" name="App10_Q" value="${list_index_10 }" onclick="selectAndSetAll4(10,${list_index_10},false)" ><b>${v3x:getAccount(groupInquiryTypes_id).name}</b>
                                                       <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'10_${list_index_10}');" ></span>
                                                     </td>
                                                     </tr>
                                                    <tr style="display: none;" class="tr_10_${list_index_10}">
                                                    <c:forEach items="${groupInquiryTypes}" var="groupInquiryType" varStatus="status">
                                                        <input type="hidden" id="GroupInquiryOptionHidden${status.index}" name="Option_Hidden_10_${list_index_10}" value="${groupInquiryType.inquirySurveytype.id}" />
                                                        <td width="30%" style="padding-left: 15px;">
                                                        <label for="GroupInquiryOption${status.index}" title="${groupInquiryType.inquirySurveytype.typeName}" >
                                                            <input type="checkbox" id="GroupInquiryOption${status.index}" name="Option10_${list_index_10}" value="${groupInquiryType.inquirySurveytype.id}" onclick="checkParentNode2(this, 10,${list_index_10 })" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 10, groupInquiryType.inquirySurveytype.id)? 'checked':''} >${v3x:toHTML(v3x:getLimitLengthString(groupInquiryType.inquirySurveytype.typeName, 20, '...'))}
                                                        </label>
                                                        </td>
                                                         <c:if test="${(status.index+1)%2==0&&groupInquiryTypes_size!=2}">
                                                        </tr>
                                                        <tr style="display: none;" class="tr_10_${list_index_10}">
                                                        </c:if>
                                                    </c:forEach>
                                                    <c:if test="${groupInquiryTypes_size==0}">
                                                         <td width="30%">&nbsp;</td> 
                                                    </c:if>
                                                    </tr>
                                                    </table>
                                                    <c:set var="list_index_10" value="${list_index_10+1}" />
                                                      </c:if>
                                                      <!--自定义团队调查 -->
                                                   <c:if test="${!empty AllCustomInquiryList}">
                                                        <c:forEach items="${AllCustomInquiryList}" var="list_map" >
                                                         <c:if test="${!empty list_map.list}">
                                                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td colspan="2">
                                                                   <input type="checkbox" id="App10_${list_index_10}" name="App10_Q" value="${list_index_10}" onclick="selectAndSetAll4(10,${list_index_10},false)" ><b>${v3x:toHTML(list_map.spaceName)}</b>
                                                                   <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'10_${list_index_10}');"></span>
                                                                </td>
                                                            </tr>
                                                            <tr style="display: none;" class="tr_10_${list_index_10}">
                                                            <c:forEach items="${list_map.list}" var="dept" varStatus="status">
                                                                <input type="hidden" id="DeptBulletinOptionHidden${status.index}" name="Option_Hidden_10_${list_index_10}" value="${dept.id}" />
                                                                <td width="30%" style="padding-left: 15px;">
                                                                    <label for="DeptBulletinOption${status.index}" title="${dept.typeName}" >
                                                                      <input type="checkbox" id="DeptBulletinOption${status.index}" name="Option10_${list_index_10}" value="${dept.id}" onclick="checkParentNode2(this, 10,${list_index_10})" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 10, dept.id)? 'checked':''}>${v3x:toHTML(v3x:getLimitLengthString(dept.typeName, 20, '...'))}
                                                                    </label>
                                                                </td>   
                                                                <c:if test="${(status.index+1)%2==0&&list_map.size!=2}">
                                                                </tr>
                                                                <tr style="display: none;" class="tr_10_${list_index_10}">
                                                                </c:if> 
                                                            </c:forEach>
                                                            <c:if test="${list_map.size==1}">
                                                                 <td width="30%">&nbsp;</td> 
                                                            </c:if>
                                                            </tr>
                                                            </table>
                                                          </c:if>
                                                        <c:set var="list_index_10" value="${list_index_10+1}" />
                                                        </c:forEach>
                                                        </c:if>
                                                      <!--自定义单位调查 -->
                                               <c:if test="${!empty AllPublicCustomInquiryList}">
                                                        <c:forEach items="${AllPublicCustomInquiryList}" var="list_map" >
                                                         <c:if test="${!empty list_map.list}">
                                                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td colspan="2">
                                                                   <input type="checkbox" id="App10_${list_index_10}" name="App10_Q" value="${list_index_10}" onclick="selectAndSetAll4(10,${list_index_10},false)" ><b>${v3x:toHTML(list_map.spaceName)}</b>
                                                                   <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'10_${list_index_10}');"></span>
                                                                </td>
                                                            </tr>
                                                            <tr style="display: none;" class="tr_10_${list_index_10}">
                                                            <c:forEach items="${list_map.list}" var="dept" varStatus="status">
                                                                <input type="hidden" id="DeptBulletinOptionHidden${status.index}" name="Option_Hidden_10_${list_index_10}" value="${dept.id}" />
                                                                <td width="30%" style="padding-left: 15px;">
                                                                    <label for="DeptBulletinOption${status.index}" title="${dept.typeName}" >
                                                                      <input type="checkbox" id="DeptBulletinOption${status.index}" name="Option10_${list_index_10}" value="${dept.id}" onclick="checkParentNode2(this, 10,${list_index_10})" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 10, dept.id)? 'checked':''}>${v3x:toHTML(v3x:getLimitLengthString(dept.typeName, 20, '...'))}
                                                                    </label>
                                                                </td>   
                                                                <c:if test="${(status.index+1)%2==0&&list_map.size!=2}">
                                                                </tr>
                                                                <tr style="display: none;" class="tr_10_${list_index_10}">
                                                                </c:if> 
                                                            </c:forEach>
                                                            <c:if test="${list_map.size==1}">
                                                                 <td width="30%">&nbsp;</td> 
                                                            </c:if>
                                                            </tr>
                                                            </table>
                                                          </c:if>
                                                        <c:set var="list_index_10" value="${list_index_10+1}" />
                                                        </c:forEach>
                                                        </c:if>
                                                      <!--自定义集团调查 -->
                                                <c:if test="${!empty AllPublicCustomGroupInquiryList}">
                                                        <c:forEach items="${AllPublicCustomGroupInquiryList}" var="list_map" >
                                                         <c:if test="${!empty list_map.list}">
                                                            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                                                            <tr>
                                                                <td colspan="2">
                                                                   <input type="checkbox" id="App10_${list_index_10}" name="App10_Q" value="${list_index_10}" onclick="selectAndSetAll4(10,${list_index_10},false)" ><b>${v3x:toHTML(list_map.spaceName)}</b>
                                                                   <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'10_${list_index_10}');"></span>
                                                                </td>
                                                            </tr>
                                                            <tr style="display: none;" class="tr_10_${list_index_10}">
                                                            <c:forEach items="${list_map.list}" var="dept" varStatus="status">
                                                                <input type="hidden" id="DeptBulletinOptionHidden${status.index}" name="Option_Hidden_10_${list_index_10}" value="${dept.id}" />
                                                                <td width="30%" style="padding-left: 15px;">
                                                                    <label for="DeptBulletinOption${status.index}"  title="${dept.typeName}" >
                                                                      <input type="checkbox" id="DeptBulletinOption${status.index}" name="Option10_${list_index_10}" value="${dept.id}" onclick="checkParentNode2(this, 10,${list_index_10})" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 10, dept.id)? 'checked':''}>${v3x:toHTML(v3x:getLimitLengthString(dept.typeName, 20, '...'))}
                                                                    </label>
                                                                </td>   
                                                                <c:if test="${(status.index+1)%2==0&&list_map.size!=2}">
                                                                </tr>
                                                                <tr style="display: none;" class="tr_10_${list_index_10}">
                                                                </c:if> 
                                                            </c:forEach>
                                                            <c:if test="${list_map.size==1}">
                                                                 <td width="30%">&nbsp;</td> 
                                                            </c:if>
                                                            </tr>
                                                            </table>
                                                          </c:if>
                                                        <c:set var="list_index_10" value="${list_index_10+1}" />
                                                        </c:forEach>
                                                        </c:if>
                                                        </div>
                                                </c:if>
                                                </div>
                                                </td>
                                            </tr>
                                            <c:if test="${type != 'sms' && v3x:hasPlugin('guestbook')}">
                                            <%--留言板 --%>
                                            <tr>
                                                <td>
                                                <div style="margin-top: 10px;">
                                                <label for="App_31">
                                                    <input type="checkbox" id="App_31" name="App" value="31" onclick="selectAndSetAll1('31')" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 31, null)? 'checked':''}><b><fmt:message key="application.31.label" bundle="${v3xCommonI18N}"/></b>
                                                </label>
                                                <span class="ico16 arrow_2_t" onclick="trShowOrHide(this,'31_all');"></span>
                                                <input type="hidden" id="AllInput_31" name="AllInput_31" value="${main:isSelectedOfMessageSetting(messageConfigMap, type, 31, 'ALL')? 'ALL':''}">
                                                <table class="tr_31_all" width="100%" cellpadding="0" cellspacing="0" border="0" style="margin-left:15px;">
                                                <c:if test="${guestbookList_size>0}">
                                                    <tr>
                                                        <td colspan="2">
                                                           <label for="App31_1">
                                                           <input type="checkbox" id="App31_1" name="App31_Q" value="1" onclick="selectAndSetAll4(31,'1')"  ><b><fmt:message key="message.department.label"/></b>
                                                           </label>
                                                           <span class="ico16 arrow_2_t" onclick="trShowOrHide(this,'31_1');"></span>
                                                        </td>
                                                    </tr>
                                                    <tr class='tr_31_1'>
                                                    <c:forEach items="${guestbookList}" var="guestbookType" varStatus="status">
                                                        <input type="hidden" id="guestbookHidden${guestbookType.entityId}" name="Option_Hidden_31_1" value="${guestbookType.entityId}" />
                                                        <td width="50%" style="padding-left: 15px;">
                                                        <label for="guestbook${guestbookType.entityId}" title="${guestbookType.spacename}">
                                                            <input type="checkbox" id="guestbook${guestbookType.entityId}" name="Option31_1" value="${guestbookType.entityId}" onclick="checkParentNode2(this,31,'1')" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 31, guestbookType.entityId)? 'checked':''} >${v3x:toHTML(v3x:getLimitLengthString(guestbookType.spacename, 20, '...'))}
                                                        </label>
                                                        </td>
                                                       <c:if test="${(status.index+1)%2==0&&guestbookList_size!=2}">
                                                           </tr>
                                                           <tr class='tr_31_1'>
                                                        </c:if>
                                                    </c:forEach>
                                                    <c:if test="${guestbookList_size==1}">
                                                         <td width="50%">&nbsp;</td> 
                                                    </c:if>
                                                    </tr>
                                                </c:if>
                                                <c:if test="${projectList_size>0}">
                                                    <tr>
                                                        <td colspan="2">
                                                          <label for="App31_2">
                                                          <input type="checkbox" id="App31_2" name="App31_Q" value="2" onclick="selectAndSetAll4(31,'2')" ><b><fmt:message key="message.project.label"/></b>
                                                          </label>
                                                          <span class="ico16 arrow_2_b" onclick="trShowOrHide(this,'31_2');"></span>
                                                        </td>
                                                    </tr>
                                                    <tr class="tr_31_2 hidden">
                                                    <c:forEach items="${projectList}" var="guestbookType" varStatus="status">
                                                        <input type="hidden" id="guestbookHidden${guestbookType.id}" name="Option_Hidden_31_2" value="${guestbookType.id}" />
                                                        <td width="50%" style="padding-left: 15px;">
                                                        <label for="guestbook${guestbookType.id}" title="${v3x:toHTML(guestbookType.projectName) }">
                                                            <input type="checkbox" id="guestbook${guestbookType.id}" name="Option31_2" value="${guestbookType.id}" onclick="checkParentNode2(this,31,'2')" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 31, guestbookType.id)? 'checked':''}>${v3x:toHTML(v3x:getLimitLengthString(guestbookType.projectName, 20, '...'))}
                                                        </label>
                                                        </td>
                                                        <c:if test="${(status.index+1)%2==0&&projectList_size!=2}">
                                                        </tr>
                                                        <tr class="tr_31_2 hidden">
                                                        </c:if>
                                                    </c:forEach>
                                                    <c:if test="${projectList_size==1}">
                                                         <td width="50%">&nbsp;</td> 
                                                    </c:if>
                                                    </tr>
                                                </c:if>
                                                </table>
                                                </div>
                                                </td>
                                            </tr>
                                           </c:if>
                                           <c:if test="${ctp:hasPlugin('everybodyWork')}">
                                            <tr>
                                                <td>
                                                    <div style="margin-top: 10px;">
                                                    <label for="App_39">
                                                        <input type="checkbox" id="App_39" name="App" value="39" onclick="selectAndSetAll(39)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 39, null)? 'checked':''}  ><b><fmt:message key='everybodyWork.msg.39.label' bundle="${v3xPersonalAffairI18N}" /></b>
                                                    </label>
                                                    <span class="ico16 arrow_2_t" onclick="trShowOrHide(this,'39_all');"></span>
                                                    <input type="hidden" id="AllInput_39" name="AllInput_39" value="${main:isSelectedOfMessageSetting(messageConfigMap, type, 39, 'ALL') ? 'ALL':''}" >
                                                    <div class="margin_t_5 tr_39_all">
                                                        <label for="CollOption39_1" style="margin-left: 15px;">
                                                            <input type="checkbox" id="CollOption39_1" name="Option_39" value="1" onclick="checkParentNode(this,39)" ${main:isSelectedOfMessageSetting(messageConfigMap, type, 39, '1')? 'checked':''} ><fmt:message key='everybodyWork.39.label' bundle="${v3xCommonI18N}" />
                                                        </label>
                                                    </div>
                                                    </div>
                                                </td>
                                             </tr>
                                             </c:if>
                                        </table>
                                        </td>
                                    </c:if>
                                    </tr>
                                </table>
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </table>
                </div>
                </td>
            </tr>
            <c:if test="${isAdmin}">
            <tr>
                <td align="center" class="bg-advance-bottom">
                    <label for="allowCustom">
                        <input type="checkbox" id="allowCustom" name="allowCustom" ${isAllowCustom ? 'checked' : ''}>
                        <fmt:message key="message.setting.custom.enable"  bundle="${v3xSysMgrI18N}"/>
                    </label>
                </td>
            </tr>
            </c:if>
            <c:if test="${empty errorMsg && !(!isAdmin && !isAllowCustom)}">
                <tr>
                    <td height="42" align="center" class="bg-advance-bottom">
                    <input
                        type="submit" name="submitButton" id="submitButton" 
                        value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />"
                        class="button-default_emphasize">&nbsp; 
                    <input type="button"
                        value="<fmt:message key='space.button.toDefault' bundle="${v3xSysMgrI18N}" />" onclick="toDefault()"
                        class="button-default-2">&nbsp;
                    <input type="button" id="cancel"
                        onclick="twclose()"
                        value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />"
                        class="button-default-2">
                    </td>
                </tr>
            </c:if>
        </table>
</form>
<script type="text/javascript">
    function save(){
        document.getElementById("submitButton").click();
    }
    function cancel(){
        document.getElementById("cancel").click();
    }
    
    var height=60;
    if("${isAdmin}"=="true"){
    	height=100;
    }
    bindOnresize('messageBody',20,height);
    var messageBody = document.getElementById("messageBody");
    messageBody.style.overflowX = "hidden";
    messageBody.style.overflowY ="auto";
</script>
</body>
</html>