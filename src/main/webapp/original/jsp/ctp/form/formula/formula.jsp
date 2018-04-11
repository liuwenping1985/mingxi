<%--
 $Author: wangfeng $
 $Rev: 261 $
 $Date:: 2013-3-17 14:00:30#$:
--%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ page import="com.seeyon.ctp.form.bean.*"%>
<%@ page import="com.seeyon.ctp.form.modules.engin.formula.FormulaEnums"%>
<%@ page import="com.seeyon.ctp.form.util.Enums.*"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body style="overflow: hidden;"  class="hidden" >
<div style="width: 660px;height: 500px;"class=" margin_5 font_size12">

<%----------------------------------------------------------------------1高级普通设置切换按钮,自定义公式设置组件的头HTML代码(暂不支持事件)start---------------------------------------------------------------------------%>
    <div id="modelSet" style="height: 50px;line-height: 50px;" class="font_size12">
        <label for="normalSet" style="margin-left: 30px;">
            <input type="radio" id="normalSet" name="modelSet" value="1" checked="checked"/><span id="modelSetText">${ctp:i18n('form.field.formula.nomal.set')}</span>
        </label>
        <c:if test="${isAdvanced eq true}">
        <label for="advancedSet" style="margin-left: 30px;">
            <input type="radio" id="advancedSet" name="modelSet" value="2" /><span id="advancedSetText" >${ctp:i18n('form.field.formula.advance.set')}</span>
        </label>
        </c:if>
    </div>
<%----------------------------------------------------------------------1高级普通设置切换按钮,自定义公式设置组件的头HTML代码(暂不支持事件)end---------------------------------------------------------------------------%>

<form id="formulaForm">
<%--------------------------------------------------------------------------------------------------2公式条件录入框start------------------------------------------------------------------------------------------------------------%>
	<div style="width: 660px;height: 90px;" class="">
       <textarea id="formulaStr" name="formulaStr" value=""  style="width:650px;height:90px;"></textarea> 
	</div>
<%--------------------------------------------------------------------------------------------------2公式条件录入框end-------------------------------------------------------------------------------------------------------------%>

<%-----------------------------------------------------------------------------------------------------5 重置/校验按钮---------------------------------------------------------------------------------------------------------------%>
    <div style="width: 660px;height: 30px;" class="margin_t_10">
        <div class="left margin_l_5">${ctp:i18n('form.formula.engin.dblclick.selecteddata.label')}</div>
        <div class="right">
            <label class="margin_r_10 hand" for="forceCheck"id="forceCheckId" style="display: none;" >
                <input name="forceCheck" class="radio_com forceCheck" id="forceCheck" type="checkbox" title="${ctp:i18n("form.formula.engin.checkrule.forcecheck.lable")}">${ctp:i18n("form.formula.engin.checkrule.forcecheck.lable")}</label>
            <a id="btnreset1" class="common_button common_button_gray" href="javascript:void(0)" onclick="$('#formulaStr').val('')">${ctp:i18n('common.button.reset.label')}</a>
			<a id="helpbutton" class="common_button common_button_gray" href="javascript:void(0)" onclick="showHelp()">${ctp:i18n('form.formulahelp.label')}</a>
        </div>
    </div>
    
<%---------------------------------------------------------------------------------------------3中部区域 数据域+运算符、函数-----------------------------------------------------------------------------------------------------%>
    <div style="">
        <div id="dataDiv" class="left" style="height: 300px;width: 440px;">
	    	<div id="tabs" class="comp" comp="type:'tab',width:440,height:260,parentId:'dataDiv'">
	    	    <%------------------------------------------------------3.1数据域选项卡------------------------------------------------------------%>
		        <div id="tabs_head" class="common_tabs clearfix">
		            <ul class="left">
                        <c:if test="${qsType eq '2' or qsType eq '3'}">
                            <li id="currentflowdata_li" ><a href="javascript:void(0)" tgt="flowdata_div"><span title="${ctp:i18n('form.trigger.automatic.currbillvalue.label')}">${ctp:i18n('form.trigger.automatic.currbillvalue.label')}</span></a></li>
                        </c:if>
		                <li id="field_li" class="current"  formulaAttr="'componentType':'componentType_condition,componentType_formula','conditionType':'conditionType_sql,conditionType_hign_auth,conditionType_BizCheck,conditionType_noFunction,conditionType_formula_subconditionType_all','formulaType':'auto_varchar,auto_number,auto_date,auto_datetime,formulaType_number,formulaType_varchar,formulaType_date,formulaType_datetime,formula_archiveset,formulaType_sub_varchar,formulaType_sub_number,formulaType_sub_date,formulaType_sub_datetime,formulaType_sub_summarize_number'" >
                            <a href="javascript:void(0)" tgt="field_div">
                                <c:if test="${otherForm eq null}" >
                                <span title="${ctp:i18n('form.compute.formdata.label')}">
                                    ${ctp:i18n('form.compute.formdata.label')}
                                 </span>
                                 </c:if>
                                 <c:if test="${otherForm ne null}" >
                                 <span title="${ctp:i18n('form.compute.formname.a.label')}${form.formName}">
                                    ${ctp:i18n('form.compute.formname.a.label')}${form.formName}
                                 </span>
                                 </c:if>
                            </a>
                        </li>
                        <c:if test="${otherForm ne null}" >
                        <li id="otherField_li" formulaAttr="'componentType':'componentType_condition,componentType_formula','conditionType':'conditionType_sql,conditionType_BizCheck,conditionType_noFunction,conditionType_all','formulaType':'formulaType_number,formulaType_varchar,formulaType_date,formulaType_datetime'" >
                            <a href="javascript:void(0)" tgt="otherField_div">
                                <span title="${ctp:i18n('form.compute.formname.b.label')}${otherForm.formName}">${ctp:i18n('form.compute.formname.b.label')}${otherForm.formName}</span>
                            </a>
                        </li>
                        </c:if>
		                <li id="org_li" formulaAttr="'componentType':'componentType_condition,componentType_formula','conditionType':',conditionType_noFunction,conditionType_hign_auth,conditionType_sql,conditionType_all','formulaType':'formulaType_varchar'" ><a href="javascript:void(0)" tgt="org_div"><span title="${ctp:i18n('form.formula.engin.orgvar.label')}">${ctp:i18n('form.formula.engin.orgvar.label')}</span></a></li>
		                <li id="date_li" formulaAttr="'componentType':'componentType_condition,componentType_formula','conditionType':',conditionType_noFunction,conditionType_hign_auth,conditionType_sql,conditionType_all','formulaType':'auto_varchar,auto_number,auto_date,auto_datetime,formulaType_varchar'"><a href="javascript:void(0)" tgt="date_div"><span title="${ctp:i18n('form.formula.engin.datevar.label')}">${ctp:i18n('form.formula.engin.datevar.label')}</span></a></li>
		                <li id="system_li" formulaAttr="'componentType':'componentType_condition,componentType_formula','conditionType':',conditionType_noFunction,conditionType_hign_auth,conditionType_sql,conditionType_all','formulaType':'formulaType_varchar'"><a href="javascript:void(0)" tgt="system_div"><span title="${ctp:i18n('form.compute.systemdata.label')}">${ctp:i18n('form.compute.systemdata.label')}</span></a></li>
                        <li id="user_li" ><a href="javascript:void(0)" tgt="user_div"><span title="${ctp:i18n('form.formula.engin.uservar.label')}">${ctp:i18n('form.formula.engin.uservar.label')}</span></a></li>
                        <c:if test="${qsType eq '1'}">
                        <li id="flowdata_li" ><a href="javascript:void(0)" tgt="flowdata_div"><span title="${ctp:i18n('form.formula.engin.flowformvar.label')}">${ctp:i18n('form.formula.engin.flowformvar.label')}</span></a></li>
		                </c:if>
		            </ul>
		    	</div>
		    	 <%-----------------------------------------------------3.2数据域数据--------------------------------------------------------------%>
		        <div id='tabs_body' class="common_tabs_body" style="padding:0 0px;">
		        	<%--表单数据域--%>
		            <div id="field_div">
                        <div id="searchArea1" class="left w100b" style="margin-top: 5px;margin-bottom: 5px">
                            <ul class="common_search">
                                <li id="inputBorder1" class="common_search_input">
                                    <input id="searchValue1" class="search_input" type="text">
                                </li>
                                <li>
                                    <a id="serachbtn1" class="common_button search_buttonHand" href="javascript:void(0)">
                                        <em></em>
                                    </a>
                                </li>
                            </ul>
                        </div>
						<select id="fieldSelect"  name="fieldSelect" multiple="multiple"  style="height: 230px;"  class="w100b"  onclick="clickField(this)" ondblclick="dblClickField(this)">
						  <c:forEach items="${fieldList}" var="obj" varStatus="status">
						  	<option labelType="formField" fieldPre="<%=FormBean.M_PREFIX%>${fn:substringAfter(obj['ownerTableName'],'_')}" displayName="<c:if test="${otherForm ne null}" >{<%=FormBean.M_PREFIX%>${fn:substringAfter(obj['ownerTableName'],'_')}.${obj['display']}}</c:if><c:if test="${otherForm eq null}" >{${obj['display']}}</c:if>"   id="${obj['id']}" tableName="${obj['ownerTableName']}" finalInputType="${obj['finalInputType']}" value="${obj['name']}" extend="${obj.extraMap.canExtend}" formulaStr="{${obj['name']}}" fieldType="${obj['fieldType']}" inputType="${obj['inputType']}" formatType="${obj['formatType']}" <c:if test="${obj['masterField']}">isMasterField=true</c:if> <c:if test="${!obj['masterField']}">isSubField=true</c:if>><c:if test="${obj['masterField']}">[${ctp:i18n('form.base.mastertable.label')}]</c:if> <c:if test="${!obj['masterField']}">[${ctp:i18n('formoper.dupform.label')}${obj['ownerTableIndex'] }]</c:if>${obj['display']}</option>
						  </c:forEach> 
						</select>
					</div>
                    <!-- 不支持的控件，防止直接拷贝的计算式，不放在上面的div里面，会导致这个div有个默认的选项 -->
                    <select id="cannotCalField"style="display: none">
                        <c:forEach items="${cannotCalcFields}" var = "notCalField" varStatus="status">
                            <option>${notCalField['display']}</option>
                        </c:forEach>
                    </select>
					<%--第二表单数据域--%>
		            <div id="otherField_div" class="hidden">
                        <div id="searchArea" class="left w100b" style="margin-top: 5px;margin-bottom: 5px">
                            <ul class="common_search">
                                <li id="inputBorder" class="common_search_input">
                                    <input id="searchValue" class="search_input" type="text">
                                </li>
                                <li>
                                    <a id="serachbtn" class="common_button common_button_gray search_buttonHand" href="javascript:void(0)">
                                        <em></em>
                                    </a>
                                </li>
                            </ul>
                        </div>
						<select id="otherFieldSelect"  name="otherFieldSelect" size="15" style="height: 230px;" class="w100b"  onclick="clickField(this)" ondblclick="dblClickField(this)">
						  <c:forEach items="${otherFormFieldList}" var="obj" varStatus="status">
						  	<option labelType="formField"  fieldPre="<%=FormBean.R_PREFIX%>${fn:substringAfter(obj['ownerTableName'],'_')}" displayName="<c:if test="${otherForm ne null}" >{<%=FormBean.R_PREFIX%>${fn:substringAfter(obj['ownerTableName'],'_')}.${obj['display']}}</c:if><c:if test="${otherForm eq null}" >{${obj['display']}}</c:if>"  id="${obj['id']}" tableName="${obj['ownerTableName']}" finalInputType="${obj['finalInputType']}" value="${obj['name']}" extend="${obj.extraMap.canExtend}" formulaStr="{${obj['name']}}" fieldType="${obj['fieldType']}" inputType="${obj['inputType']}" formatType="${obj['formatType']}" <c:if test="${obj['masterField']}">isMasterField=true</c:if> <c:if test="${!obj['masterField']}">isSubField=true</c:if>><c:if test="${obj['masterField']}">[${ctp:i18n('form.base.mastertable.label')}]</c:if> <c:if test="${!obj['masterField']}">[${ctp:i18n('formoper.dupform.label')}${obj['ownerTableIndex'] }]</c:if>${obj['display']}</option>
						  </c:forEach> 
						</select>
					</div>
					<%--组织机构数据域--%>
		            <div id="org_div" class="hidden">
		            	<select id="orgSelect"  name="orgSelect" size="15" style="height: 260px;" class="w100b" onclick="clickField(this)" ondblclick="dblClickField(this)">
		            	  <c:forEach items="${org}" var="obj" varStatus="status">
						  	<option value="${obj.key}" displayName="[${obj.value}]" inputType="" fieldType="" extend="false">${obj.value}</option>
						  </c:forEach> 
						</select>
					</div>
					<%--日期数据域--%>
		            <div id="date_div" class="hidden">
		            	<select id="dateSelect"  name="dateSelect" size="15" style="height: 260px;" class="w100b" onclick="clickField(this)" ondblclick="dblClickField(this)">
		            	  <c:forEach items="${date}" var="obj" varStatus="status">
						  	<option value="${obj.key}" displayName="[${obj.value}]" inputType="" fieldType="" extend="false">${obj.value}</option>
						  </c:forEach> 
						</select>
					</div>
					<%--系统数据域--%>
		            <div id="system_div" class="hidden">
						<select id="systemSelect"  name="systemSelect" size="15" style="height: 260px;" class="w100b" onclick="clickField(this)" ondblclick="dblClickField(this)">
		            	  <c:forEach items="${sys}" var="obj" varStatus="status">
						  	<option value="${obj.key}" displayName="<c:if test="${otherForm ne null}">{<%=FormBean.R_PREFIX%>${fn:substringAfter(otherForm.masterTableBean.tableName,'_')}.${obj.value}}</c:if><c:if test="${otherForm eq null}">{${obj.value}}</c:if>" inputType="" fieldType="" extend="true">${obj.value}</option>
						  </c:forEach> 
						  <c:forEach items="${numberList}" var="obj" varStatus="status">
						  	<option formulaAttr="'componentType':'componentType_formula','formulaType':'formulaType_varchar'" value="${obj.id}" displayName="serialNumber('${obj.variableName}')" inputType="" fieldType="" extend="">${obj.variableName}</option>
						  </c:forEach> 
						</select>
					</div>
					<%--用户数据域--%>
                          <div id="user_div" class="hidden">
                              <select id="userSelect"  name="userSelect" size="15" style="height: 260px;" class="w100b" onclick="clickField(this)" ondblclick="dblClickField(this)">

                              </select>
                          </div>
                    <%--单据填写值--%>
                    <div id="flowdata_div" class="hidden">
                        <div id="searchArea2" class="left w100b" style="margin-top: 5px;margin-bottom: 5px">
                            <ul class="common_search">
                                <li id="inputBorder2" class="common_search_input">
                                    <input id="searchValue2" class="search_input" type="text">
                                </li>
                                <li>
                                    <a id="serachbtn2" class="common_button common_button_gray search_buttonHand" href="javascript:void(0)">
                                        <em></em>
                                    </a>
                                </li>
                            </ul>
                        </div>
                        <select id="flowData"  name="flowData" size="15" style="height: 230px;" class="w100b" onclick="clickField(this)" ondblclick="dblClickField(this)">
                          <c:forEach items="${fieldList}" var="obj" varStatus="status">
                              <c:if test="${qsType ne '2'}">
                                  <c:if test="${obj['masterField']}">
                                      <option value="${obj['name']}" displayName="[<%=FormBean.FLOW_PREFIX%>${obj['display']}]"><%=FormBean.FLOW_PREFIX%>[${ctp:i18n('form.base.mastertable.label')}]${obj['display']}</option>
                                  </c:if>
                              </c:if>
                              <c:if test="${qsType eq '2'}">
                                  <option  labelType="formField" fieldPre="<%=FormBean.FLOW_PREFIX%>${fn:substringAfter(obj['ownerTableName'],'_')}"  displayName="[<%=FormBean.FLOW_PREFIX%>${obj['display']}]" id="${obj['id']}" tableName="${obj['ownerTableName']}" finalInputType="${obj['finalInputType']}" value="${obj['name']}" extend="${obj.extraMap.canExtend}" formulaStr="{${obj['name']}}" fieldType="${obj['fieldType']}" inputType="${obj['inputType']}" formatType="${obj['formatType']}"  <c:if test="${obj['masterField']}">isMasterField=true</c:if> <c:if test="${!obj['masterField']}">isSubField=true</c:if>><%=FormBean.FLOW_PREFIX%><c:if test="${obj['masterField']}">[${ctp:i18n('form.base.mastertable.label')}]</c:if> <c:if test="${!obj['masterField']}">[${ctp:i18n('formoper.dupform.label')}${obj['ownerTableIndex'] }]</c:if>${obj['display']}</option>
                              </c:if>
                          </c:forEach>
                        </select>
                    </div>
		        </div>
	    	</div>
	    	<%--  描述信息 --%>
			<div id = "descriptiondiv" formulaAttr="'componentType':'componentType_condition','conditionType':'conditionType_BizCheck'">
				<div class="margin_t_10">&nbsp;${ctp:i18n('form.formula.engin.description.label')}： </div>
   				<textarea id="description" name="description" cols="70" style="width:440px;height:60px" ></textarea>
			</div>
        </div>
        <div id="functionarea" class="right" style="height: 315px;width: 210px;margin-top: 10px;overflow: auto;" >
<%-----------------------------------------------------------------------------------------------3.3运算符，函数------------------------------------------------------------------------------------------%>
            <div style="overflow: visible;">
                <div class="clearfix">
				    <%------------------------------------------------------3.3.1 公式运算符 +-*/()--------------------------------------------------------%>
					 <div class="left" width="25%" id="addButton"  formulaAttr="'componentType':'componentType_condition,componentType_extend,componentType_formula','formulaType':'auto_varchar,auto_number,auto_date,auto_datetime,formulaType_number,formulaType_extend_number,formulaType_extend_varchar,formulaType_varchar,formulaType_date,formulaType_datetime'">
                        <a href="javascript:void(0)" class="form_btn" id="add" onclick="doit('+')" ><span class="plus_16"></span></a>
					 </div>
					 <div class="left margin_l_10"  width="25%" id="minusButton"  formulaAttr="'componentType':'componentType_condition,componentType_extend,componentType_formula','formulaType':'auto_number,auto_date,auto_datetime,formulaType_number,formulaType_extend_number,formulaType_date,formulaType_datetime'">
                        <a href="javascript:void(0)" class="form_btn" id="minus" onclick="doit('-')"><span class="minus_16"></span></a>
					 </div>
					 <div class="left margin_l_10"  width="25%" id="multiplyButton"  formulaAttr="'componentType':'componentType_condition,componentType_extend,componentType_formula','formulaType':'auto_number,formulaType_number,formulaType_extend_number'">
                        <a href="javascript:void(0)" class="form_btn" id="multiply" onclick="doit('*')"><span class="multiply_16"></span></a>
					 </div>
					 <div class="left margin_l_10" width="25%" id="divisionButton"  formulaAttr="'componentType':'componentType_condition,componentType_extend,componentType_formula','formulaType':'auto_number,formulaType_number,formulaType_extend_number'">
                        <a href="javascript:void(0)" class="form_btn" id="division" onclick="doit('/')"><span class="divide_16"></span></a>
					 </div>
                </div>
                <div class="clearfix margin_t_10">
                    <div class="left"  id="bracketLeftButton"  formulaAttr="'componentType':'componentType_condition,componentType_extend,componentType_formula','formulaType':'auto_number,formulaType_number,formulaType_extend_number'">
                        <a href="javascript:void(0)" class="form_btn" id="bracketLeft" onclick="doit('(')"><span class="brackl_16"></span></a>
                     </div>
                     <div class="left margin_l_10"  colspan="3" id="bracketRightButton"  formulaAttr="'componentType':'componentType_condition,componentType_extend,componentType_formula','formulaType':'auto_number,formulaType_number,formulaType_extend_number'">
                        <a href="javascript:void(0)" class="form_btn" id="bracketRight" onclick="doit(')')"><span class="brackr_16"></span> </a>
                     </div>
                </div>
                
                <div class="margin_t_10 align_left" id="splitLine">
                    <hr style="height:1px; color:#CCCCCC; width:170px;text-align: left;">
                </div>
                
                <div formulaAttr="'componentType':'componentType_condition'" >
                <%------------------------------------------------------3.3.2 条件运算> >= < <= = <>--------------------------------------------------------%>
                    <div class="clearfix margin_t_10" scope="conditionButtons" >
                        <div class="left"  id="bigthanButton">
                            <a href="javascript:void(0)" class="form_btn" onclick="doit('>')"><span class="gt_16"> </span> </a>
                        </div>
                        <div class="left margin_l_10"  id="bigAndEqualButton">
                            <a href="javascript:void(0)" class="form_btn" onclick="doit('>=')"><span class="gt_eq_16 w32 "></span> </a>
                        </div>
                        <div class="left margin_l_10"  id="smallthanButton">
                            <a href="javascript:void(0)" class="form_btn" onclick="doit('<')"><span class="lt_16"> </span> </a>
                        </div>
                        <div class="left margin_l_10"  id="smallAndEqualButton">
                            <a href="javascript:void(0)" class="form_btn" onclick="doit('<=')"><span class="lt_eq_16 w32"> </span> </a>
                        </div>
                    </div>
                    <div class="clearfix margin_t_10" scope="conditionButtons" >
	                    <div class="left"  id="equalButton">
	                        <a href="javascript:void(0)" class="form_btn" onclick="doit('=')"><span class="equal_16"> </span> </a>
	                    </div>
	                    <div class="left margin_l_10"  id="notEqualButton" >
	                        <a href="javascript:void(0)" class="form_btn" onclick="doit('<>')"><span class="brack_angle_16 w32"> </span></a>
	                    </div>
                    </div>
                    <div class="clearfix margin_t_10" scope="conditionButtons" >
					    <div class="left"  id="likeButton" >
					        <a href="javascript:void(0)" title= "${ctp:i18n('form.formula.engin.formula.function.title.like') }" class="form_btn w32" onclick="doit(function(){<%=ConditionSymbol.like.getKey()%>({qsType:${qsType}});})">${ctp:i18n('operator.Likeread')}</a>
					    </div>
					    <div class="left margin_l_10"  id="notlikeButton" >
					        <a href="javascript:void(0)" class="form_btn" style="width: 55px;" title= "${ctp:i18n('form.formula.engin.formula.function.title.notlike')}" onclick="doit(function(){<%=ConditionSymbol.not_like.getKey()%>({qsType:${qsType}});})">${ctp:i18n('operator.noLikeread')}</a>
					    </div>
                        <div class="left margin_l_10"  id="extendButton" formulaAttr="'componentType':'componentType_condition','conditionType':'conditionType_formula_sub,conditionType_BizCheck,conditionType_sql,conditionType_hign_auth,conditionType_noFunction'">
                            <a href="javascript:void(0)" class="form_btn" style="width: 55px;" onclick="doit(function(){extend();})">extend</a>
                        </div>
                    </div>
                    <div class="margin_t_10 align_left">
                        <hr style="height:1px; color:#CCCCCC; width:170px;text-align: left;">
                    </div>
                <%------------------------------------------------------3.3.3 逻辑运算符   and or xor not--------------------------------------------------------%>
                    <div class="clearfix">
						<div class="left"  id="andButton" >
						    <a href="javascript:void(0)" class="form_btn" onclick="doit('and')" title="${ctp:i18n('form.formula.engin.formula.function.title.and')}">and</a>
						</div>
						<div class="left margin_l_10"  id="orButton" >
						    <a href="javascript:void(0)" class="form_btn" onclick="doit('or')" title="${ctp:i18n('form.formula.engin.formula.function.title.or') }">or</a>
						</div>
						<%--暂时不这次XOR，无法跨数据库
						<div id="xorButton" >
						    <a href="javascript:void(0)" class="form_btn" onclick="doit('xor')">xor</a>
						</div>
						 --%>
						<div class="left margin_l_10"  id="notButton" >
						    <a href="javascript:void(0)" class="form_btn" onclick="doit('not()')" title="${ctp:i18n('form.formula.engin.formula.function.title.not') }">not</a>
						</div>
						<div class="left margin_l_10"  isAdvanced="true"  id="notButton" formulaAttr="'componentType':'componentType_condition','conditionType':'conditionType_noFunction,conditionType_sql,conditionType_hign_auth,conditionType_BizCheck'">
						    <a href="javascript:void(0)" class="form_btn" title="${ctp:i18n('form.formula.engin.formula.function.title.in') }" onclick="doit(function(){funin();})">in</a>
						</div>
                    </div>
                    <div class="margin_t_10 align_left">
	                    <hr style="height:1px; color:#CCCCCC; width:170px;text-align: left;">
	                </div>
                </div>
                <%------------------------------------------------------3.5 函数--------------------------------------------------------%>
                <div style="width: 190px;">
                    <div class="function clearfix margin_t_10" >
                        <!-- 大写长格式 -->
                        <div class="left" id="toUpperForLongButton"  formulaAttr="'componentType':'componentType_formula','formulaType':'formulaType_varchar,auto_varchar'">
                            <a href="javascript:void(0)" class="form_btn w89" title="${ctp:i18n('form.formula.engin.formula.function.title.toUpperForLong')}" onclick="doit(function(){<%=FunctionSymbol.toUpperForLong.getKey()%>();})"><%=FunctionSymbol.toUpperForLong.getText()%></a>
                        </div>
                        <!-- 大写短格式 -->
                        <div class="left margin_l_5" id="toUpperForShortButton"  formulaAttr="'componentType':'componentType_formula','formulaType':'formulaType_varchar,auto_varchar'">
                            <a href="javascript:void(0)" class="form_btn w89" title="${ctp:i18n('form.formula.engin.formula.function.title.toUpperForShort')}" onclick="doit(function(){<%=FunctionSymbol.toUpperForShort.getKey()%>();})"><%=FunctionSymbol.toUpperForShort.getText()%></a>
                        </div>
                    </div>
                    <div class="function clearfix margin_t_10" >
                        <!-- 中文大写 -->
                        <div class="left" id="toUpperButton"  formulaAttr="'componentType':'componentType_formula','formulaType':'formulaType_varchar,auto_varchar'">
                            <a href="javascript:void(0)" class="form_btn w89" title="${ctp:i18n('form.formula.engin.formula.function.title.toUpper')}" onclick="doit(function(){<%=FunctionSymbol.toUpper.getKey()%>();})"><%=FunctionSymbol.toUpper.getText()%></a>
                        </div>
                    </div>
                    <div class="function clearfix margin_t_10" >
                        <!-- 日期差 -->
                        <div class="left"  id="differDateButton"  formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number,auto_number','conditionType':'conditionType_formula_sub,conditionType_sql,conditionType_hign_auth,conditionType_BizCheck,conditionType_noFunction'">
                            <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.differDate.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.differDate') }"><%=FunctionSymbol.differDate.getText()%></a>
                        </div>
                        <!-- 日期时间差 -->
                        <div class="left margin_l_5" id="differDateTime"  formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number,auto_number','conditionType':'conditionType_formula_sub,conditionType_sql,conditionType_hign_auth,conditionType_BizCheck,conditionType_noFunction'">
                            <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.differDateTime.getKey()%>();})" title="<%=FunctionSymbol.differDateTime.getText()%>"><%=FunctionSymbol.differDateTime.getText()%></a>
                        </div>
                    </div>
                    <div class="function clearfix margin_t_10" >
                        <!-- 重复表最大-->
                        <div class="left"  id="sumButton"  formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number,auto_number','conditionType':'conditionType_all,conditionType_BizCheck,conditionType_hign_auth'">
	                        <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.sum.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.sum') }"><%=FunctionSymbol.sum.getText()%></a>
	                    </div>
                        <!-- 重复表平均-->
	                    <div class="left margin_l_5" id="averButton"  formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number,auto_number','conditionType':'conditionType_all,conditionType_BizCheck,conditionType_hign_auth'">
	                        <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.aver.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.aver') }"><%=FunctionSymbol.aver.getText()%></a>
	                    </div>
                    </div>
                    <div class="function clearfix margin_t_10">
                        <!-- 重复行取值-第一行 -->
                        <div class="left"  id="firstRowButton" formulaAttr="'componentType':'componentType_formula','formulaType':'formulaType_sub_varchar,formulaType_sub_number,formulaType_sub_date,formulaType_sub_datetime'">
                            <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.getSubValueByFirst.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.firstRow') }"><%=FunctionSymbol.getSubValueByFirst.getText()%></a>
                        </div>
                        <!-- 重复行取值-最后一行 -->
                        <div class="left margin_l_5" id="lastRowButton" formulaAttr="'componentType':'componentType_formula','formulaType':'formulaType_sub_varchar,formulaType_sub_number,formulaType_sub_date,formulaType_sub_datetime'">
                            <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.getSubValueByLast.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.lastRow') }"><%=FunctionSymbol.getSubValueByLast.getText()%></a>
                        </div>
                    </div>
                    <div class="function clearfix margin_t_10">
                        <!-- 重复行取值-重复表最大 -->
                        <div class="left"  id="subMaxButton" formulaAttr="'componentType':'componentType_formula','formulaType':'formulaType_sub_varchar,formulaType_sub_number,formulaType_sub_date,formulaType_sub_datetime'">
                            <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.getSubValueByMax.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.subMax') }"><%=FunctionSymbol.getSubValueByMax.getText()%></a>
                        </div>
                        <!-- 重复行取值-重复表最小 -->
                        <div class="left margin_l_5" id="subMinButton" formulaAttr="'componentType':'componentType_formula','formulaType':'formulaType_sub_varchar,formulaType_sub_number,formulaType_sub_date,formulaType_sub_datetime'">
                            <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.getSubValueByMin.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.subMin') }"><%=FunctionSymbol.getSubValueByMin.getText()%></a>
                        </div>
                    </div>
                    <div class="function clearfix margin_t_10">
                        <!-- 重复行取值-重复表最早 -->
                        <div class="left"  id="subEarliestButton" formulaAttr="'componentType':'componentType_formula','formulaType':'formulaType_sub_varchar,formulaType_sub_number,formulaType_sub_date,formulaType_sub_datetime'">
                            <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.getSubValueByEarliest.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.subEarliest') }"><%=FunctionSymbol.getSubValueByEarliest.getText()%></a>
                        </div>
                        <!-- 重复行取值-重复表最晚 -->
                        <div class="left margin_l_5" id="subLatestButton" formulaAttr="'componentType':'componentType_formula','formulaType':'formulaType_sub_varchar,formulaType_sub_number,formulaType_sub_date,formulaType_sub_datetime'">
                            <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.getSubValueByLatest.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.sublatest') }"><%=FunctionSymbol.getSubValueByLatest.getText()%></a>
                        </div>
                    </div>
                    <div class="function clearfix margin_t_10" >
                        <!-- 重复表最大 -->
                        <div class="left"  id="maxButton"  formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number,auto_number','conditionType':'conditionType_all,conditionType_BizCheck,conditionType_hign_auth'">
	                        <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.max.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.max') }"><%=FunctionSymbol.max.getText()%></a>
	                    </div>
                        <!-- 重复表最小 -->
	                    <div class="left margin_l_5"  id="minButton"  formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number,auto_number','conditionType':'conditionType_all,conditionType_BizCheck,conditionType_hign_auth'">
	                        <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.min.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.min') }"><%=FunctionSymbol.min.getText()%></a>
	                    </div>
                    </div>
                    <div class="margin_t_10 align_left function" formulaAttr="'componentType':'componentType_formula','formulaType':'formulaType_varchar'">
                        <hr style="height:1px; color:#CCCCCC; width:170px;text-align: left;">
                    </div>
                    <div class="function clearfix margin_t_10"   formulaAttr="'componentType':'componentType_condition','conditionType':'conditionType_BizCheck,conditionType_all,conditionType_hign_auth'">
                        <!-- exists -->
                        <div class="left"  id="existsButton" >
                            <a href="javascript:void(0)" class="form_btn w89" onclick="doit('exist()')" title="${ctp:i18n('form.formula.engin.formula.function.title.exist')}"><%=FunctionSymbol.exist.getText()%></a>
                        </div>
                        <!-- all -->
                        <div class="left margin_l_5" id="allButton">
                            <a href="javascript:void(0)" class="form_btn w89" onclick="doit('all()')"  title="${ctp:i18n('form.formula.engin.formula.function.title.all')}"><%=FunctionSymbol.all.getText()%></a>
                        </div>
                    </div>
                    <div class="function clearfix margin_t_10"   formulaAttr="'componentType':'componentType_formula','formulaType':'formulaType_date,formulaType_datetime,auto_date,auto_datetime'">
                        <!-- 重复表最早 -->
                        <div class="left"  id="earliestButton" >
                            <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.earliest.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.earliest')}"><%=FunctionSymbol.earliest.getText()%></a>
                        </div>
                        <!-- 重复表最晚 -->
                        <div class="left margin_l_5" id="latestButton">
                            <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.latest.getKey()%>();})"  title="${ctp:i18n('form.formula.engin.formula.function.title.latest')}"><%=FunctionSymbol.latest.getText()%></a>
                        </div>
                    </div>
                    <div class="function clearfix margin_t_10">
                        <!-- 重复表列不重 -->
                        <div class="left" id="uniqueButton" formulaAttr="'componentType':'componentType_condition','conditionType':'conditionType_BizCheck'">
                            <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.unique.getKey()%>();})"  title="${ctp:i18n('form.formula.engin.formula.function.title.unique')}"><%=FunctionSymbol.unique.getText()%></a>
                        </div>
                        <!-- 重复表上一行 -->
                        <div class="left margin_l_5" isAdvanced="true" id="preRowButton"  formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_varchar,formulaType_number,auto_number','conditionType':'conditionType_BizCheck'">
                            <a href="javascript:void(0)" class="form_btn w89" title="${ctp:i18n('form.formula.engin.formula.function.title.preRow')}" onclick="doit(function(){<%=FunctionSymbol.preRow.getKey()%>();})"><%=FunctionSymbol.preRow.getText()%></a>
                        </div>
                    </div>
                    <!-- 重复表分类汇总到重复表用 start -->
                    <div class="function clearfix margin_t_10" >
                        <!-- 重复表分类汇总—重复表分类合计 -->
                        <div class="left"  id="summarizeSumButton" isAdvanced="true" formulaAttr="'componentType':'componentType_formula','formulaType':'formulaType_sub_summarize_number'">
                            <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.summarizeSum.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.summarizeSum') }"><%=FunctionSymbol.summarizeSum.getText()%></a>
                        </div>
                        <!-- 重复表分类汇总—重复表分类平均 -->
                        <div class="left margin_l_5"   id="summarizeAverButton" isAdvanced="true" formulaAttr="'componentType':'componentType_formula','formulaType':'formulaType_sub_summarize_number'">
                            <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.summarizeAver.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.summarizeAver') }"><%=FunctionSymbol.summarizeAver.getText()%></a>
                        </div>
                    </div>
                    <div class="function clearfix margin_t_10" >
                        <!-- 重复表分类汇总—重复表分类最大 -->
                        <div class="left"  id="summarizeMaxButton" isAdvanced="true" formulaAttr="'componentType':'componentType_formula','formulaType':'formulaType_sub_summarize_number'">
                            <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.summarizeMax.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.summarizeMax') }"><%=FunctionSymbol.summarizeMax.getText()%></a>
                        </div>
                        <!-- 重复表分类汇总—重复表分类最小 -->
                        <div class="left margin_l_5"  id="summarizeMinButton" isAdvanced="true" formulaAttr="'componentType':'componentType_formula','formulaType':'formulaType_sub_summarize_number'">
                            <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.summarizeMin.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.summarizeMin') }"><%=FunctionSymbol.summarizeMin.getText()%></a>
                        </div>
                    </div>
                    <!-- 重复表分类汇总到重复表用 end -->
                    <c:if test="${empty param.otherformId}">
                        <div class="function clearfix margin_t_10" >
                            <!-- 重复表分类合计 -->
                            <div class="left"  id="sumifButton" isAdvanced="true" formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number,auto_number','conditionType':'conditionType_all'">
                                <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.sumif.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.sumif') }"><%=FunctionSymbol.sumif.getText()%></a>
                            </div>
                            <!-- 重复表分类平均 -->
                            <div class="left margin_l_5"   id="averifButton" isAdvanced="true" formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number,auto_number','conditionType':'conditionType_all'">
                                <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.averif.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.averif') }"><%=FunctionSymbol.averif.getText()%></a>
                            </div>
                        </div>
                        <div class="function clearfix margin_t_10" >
                            <!-- 重复表分类最大 -->
                            <div class="left"  id="maxifButton" isAdvanced="true" formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number,auto_number','conditionType':'conditionType_all'">
                                <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.maxif.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.maxif') }"><%=FunctionSymbol.maxif.getText()%></a>
                            </div>
                            <!-- 重复表分类最小 -->
                            <div class="left margin_l_5"  id="minifButton" isAdvanced="true" formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number,auto_number','conditionType':'conditionType_all'">
                                <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.minif.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.minif') }"><%=FunctionSymbol.minif.getText()%></a>
                            </div>
                        </div>
                        <div class="function clearfix margin_t_10" >
                            <!-- 重复行取值 -->
                            <div class="left"  id="rowButton" isAdvanced="true" formulaAttr="'componentType':'componentType_formula','formulaType':'formulaType_number,formulaType_date,formulaType_datetime,formulaType_varchar,auto_number,auto_date,auto_datetime'">
                                <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){subRow();})" title="${ctp:i18n('clacType.Duplicateform.row') }"><%=FunctionSymbol.row.getText()%></a>
                            </div>
                            <!-- 函数自定义 -->
                            <div class="left margin_l_5"  id="designButton"  isAdvanced="true" formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_varchar,formulaType_number,auto_varchar,auto_number','conditionType':'conditionType_BizCheck'">
                                <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.design.getKey()%>();})" title="<%=FunctionSymbol.design.getText()%>"><%=FunctionSymbol.design.getText()%></a>
                            </div>
                        </div>
                    </c:if>
                    <div class="function clearfix margin_t_10" >
                        <!-- 取整数 -->
                        <div class="left"  id="sumButton" isAdvanced="true" formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number,auto_number','conditionType':'conditionType_all'">
                            <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.getInt.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.getInt') }"><%=FunctionSymbol.getInt.getText()%></a>
                        </div>
                        <!-- 取余数 -->
                        <div class="left margin_l_5" id="averButton" isAdvanced="true"  formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number,auto_number','conditionType':'conditionType_all'">
                            <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.getMod.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.getMod') }"><%=FunctionSymbol.getMod.getText()%></a>
                        </div>
                    </div>
                    <div class="function clearfix margin_t_10" >
                        <!-- 取年 -->
                        <div class="left"  id="yearButton"  isAdvanced="true" formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number,auto_number','conditionType':'conditionType_all,conditionType_noFunction,conditionType_BizCheck,conditionType_hign_auth,conditionType_sql,conditionType_formula_sub'">
                            <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.year.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.year') }"><%=FunctionSymbol.year.getText()%></a>
                        </div>
                        <!-- 取月 -->
                        <div class="left margin_l_5" id="mouthButton"  isAdvanced="true" formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number,auto_number','conditionType':'conditionType_all,conditionType_noFunction,conditionType_BizCheck,conditionType_hign_auth,conditionType_sql,conditionType_formula_sub'">
                            <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.month.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.month') }"><%=FunctionSymbol.month.getText()%></a>
                        </div>
                      </div>
                    <div class="function clearfix margin_t_10" >
                        <!-- 取日 -->
                        <div class="left"  id="dayButton"  isAdvanced="true" formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number,auto_number','conditionType':'conditionType_all,conditionType_noFunction,conditionType_BizCheck,conditionType_hign_auth,conditionType_sql,conditionType_formula_sub'">
                            <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.day.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.day') }"><%=FunctionSymbol.day.getText()%></a>
                        </div>
                        <!-- 取星期 -->
                        <div class="left margin_l_5"  id="weekdayButton" isAdvanced="true" formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number,auto_number','conditionType':'conditionType_all,conditionType_noFunction,conditionType_BizCheck,conditionType_hign_auth,conditionType_sql,conditionType_formula_sub'">
                            <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.weekday.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.weekday') }"><%=FunctionSymbol.weekday.getText()%></a>
                        </div>
                    </div>

                    <div class="function clearfix margin_t_10" >
                        <!-- 取日期 -->
                        <div class="left" id="dateButton"  isAdvanced="true" formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_varchar,auto_varchar','conditionType':'conditionType_all,conditionType_noFunction,conditionType_hign_auth,conditionType_BizCheck,conditionType_sql'">
                            <a href="javascript:void(0)" class="form_btn w89" title="${ctp:i18n('form.formula.engin.formula.function.title.date')}" onclick="doit(function(){<%=FunctionSymbol.date.getKey()%>();})"><%=FunctionSymbol.date.getText()%></a>
                        </div>
                        <!-- 取时间 -->
                        <div class="left margin_l_5" id="timeButton" isAdvanced="true" formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_varchar,auto_varchar','conditionType':'conditionType_all,conditionType_noFunction,conditionType_hign_auth,conditionType_BizCheck,conditionType_sql'">
                            <a href="javascript:void(0)" class="form_btn w89" title="${ctp:i18n('form.formula.engin.formula.function.title.time')}" onclick="doit(function(){<%=FunctionSymbol.time.getKey()%>();})"><%=FunctionSymbol.time.getText()%></a>
                        </div>
                    </div>
                    <div class="function clearfix margin_t_10" >
                        <!-- 空值 -->
                        <div class="left" id="nullButton" formulaAttr="'componentType':'componentType_condition','conditionType':'conditionType_formula_sub,conditionType_BizCheck,conditionType_sql,conditionType_hign_auth,conditionType_noFunction'">
                            <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){nullValue();})" title="null">${ctp:i18n('form.formula.engin.null.label')}</a>
                        </div>
                        <!-- len -->
                        <div class="left margin_l_5" id="lenButton" formulaAttr="'componentType':'componentType_condition','conditionType':'conditionType_BizCheck'">
                            <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.len.getKey()%>();})"  title="${ctp:i18n('form.formula.engin.formula.function.title.len')}"><%=FunctionSymbol.len.getText()%></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
 </form>
</div>
<div id="bakarea" class="hidden">

</div>
<script type="text/javascript" src="${path}/ajax.do?managerName=formManager"></script>  
<%@ include file="textUtil.js.jsp" %>
<%@ include file="../common/common.js.jsp" %>
<%@ include file="formula.js.jsp" %>
<%@ include file="formulaAction.js.jsp" %>
<script></script>
</body>
</html>