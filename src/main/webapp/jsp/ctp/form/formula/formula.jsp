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
        <label for="normalSetLabel" style="margin-left: 30px;">
            <input type="radio" id="normalSet" name="modelSet" value="1" checked="checked"/><span id="modelSetText">${ctp:i18n('form.field.formula.nomal.set')}</span>
        </label>
        <c:if test="${isAdvanced eq true}">
        <label for="advancedSetLabel" style="margin-left: 30px;">
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
			<a id="btnreset" class="common_button common_button_gray" href="javascript:void(0)" onclick="$('#formulaStr').val('')">${ctp:i18n('common.button.reset.label')}</a>
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
		                <li id="field_li" class="current"  formulaAttr="'componentType':'componentType_condition,componentType_formula','conditionType':'conditionType_sql,conditionType_hign_auth,conditionType_BizCheck,conditionType_noFunction,conditionType_formula_subconditionType_all','formulaType':'formulaType_number,formulaType_varchar,formulaType_date,formulaType_datetime'" >
                            <a href="javascript:void(0)" tgt="field_div">
                                <c:if test="${otherForm eq null}" >
                                    <c:if test="${form.govDocFormType !=5 &&form.govDocFormType !=6 && form.govDocFormType !=7}">
                                        <span title="${ctp:i18n('form.compute.formdata.label')}">
                                                ${ctp:i18n('form.compute.formdata.label')}
                                        </span>
                                    </c:if>
                                    <c:if test="${form.govDocFormType ==5 ||form.govDocFormType ==6 || form.govDocFormType ==7}">
                                       <span title="${ctp:i18n('form.compute.edocformdata.label')}">
                                               ${ctp:i18n('form.compute.edocformdata.label')}
                                       </span>
                                    </c:if>


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
		                <li id="date_li" formulaAttr="'componentType':'componentType_condition,componentType_formula','conditionType':',conditionType_noFunction,conditionType_hign_auth,conditionType_sql,conditionType_all','formulaType':'formulaType_varchar'"><a href="javascript:void(0)" tgt="date_div"><span title="${ctp:i18n('form.formula.engin.datevar.label')}">${ctp:i18n('form.formula.engin.datevar.label')}</span></a></li>
		                <li id="system_li" formulaAttr="'componentType':'componentType_condition,componentType_formula','conditionType':',conditionType_noFunction,conditionType_hign_auth,conditionType_sql,conditionType_all','formulaType':'formulaType_varchar'"><a href="javascript:void(0)" tgt="system_div"><span title="${ctp:i18n('form.compute.systemdata.label')}">${ctp:i18n('form.compute.systemdata.label')}</span></a></li>
                        <li id="user_li" ><a href="javascript:void(0)" tgt="user_div"><span title="${ctp:i18n('form.formula.engin.uservar.label')}">${ctp:i18n('form.formula.engin.uservar.label')}</span></a></li>
                        <c:if test="${qsType eq '1'}">
                        <li id="flowdata_li" ><a href="javascript:void(0)" tgt="flowdata_div"><span title="${ctp:i18n('form.formula.engin.flowformvar.label')}">${ctp:i18n('form.formula.engin.flowformvar.label')}</span></a></li>
		                </c:if>
		            </ul>
		    	</div>
		    	 <%-----------------------------------------------------3.2数据域数据--------------------------------------------------------------%>
		        <div id='tabs_body' class="common_tabs_body">
		        	<%--表单数据域--%>
		            <div id="field_div">				            	
						<select id="fieldSelect"  name="fieldSelect" multiple="multiple"  style="height: 260px;"  class="w100b"  onclick="clickField(this)" ondblclick="dblClickField(this)">
						  <c:forEach items="${fieldList}" var="obj" varStatus="status">
						  	<option labelType="formField" fieldPre="<%=FormBean.M_PREFIX%>${fn:substringAfter(obj['ownerTableName'],'_')}" displayName="<c:if test="${otherForm ne null}" >{<%=FormBean.M_PREFIX%>${fn:substringAfter(obj['ownerTableName'],'_')}.${obj['display']}}</c:if><c:if test="${otherForm eq null}" >{${obj['display']}}</c:if>"   id="${obj['id']}" tableName="${obj['ownerTableName']}" finalInputType="${obj['finalInputType']}" value="${obj['name']}" extend="${obj.extraMap.canExtend}" formulaStr="{${obj['name']}}" fieldType="${obj['fieldType']}" inputType="${obj['inputType']}" formatType="${obj['formatType']}" <c:if test="${obj['masterField']}">isMasterField=true</c:if> <c:if test="${!obj['masterField']}">isSubField=true</c:if>><c:if test="${obj['masterField']}">[${ctp:i18n('form.base.mastertable.label')}]</c:if> <c:if test="${!obj['masterField']}">[${ctp:i18n('formoper.dupform.label')}${obj.extraMap.subTableIndex }]</c:if>${obj['display']}</option>
						  </c:forEach> 
						</select>								
					</div>
					<%--第二表单数据域--%>
		            <div id="otherField_div" class="hidden">
						<select id="otherFieldSelect"  name="otherFieldSelect" size="15" class="w100b"  onclick="clickField(this)" ondblclick="dblClickField(this)">
						  <c:forEach items="${otherFormFieldList}" var="obj" varStatus="status">
						  	<option labelType="formField"  fieldPre="<%=FormBean.R_PREFIX%>${fn:substringAfter(obj['ownerTableName'],'_')}" displayName="<c:if test="${otherForm ne null}" >{<%=FormBean.R_PREFIX%>${fn:substringAfter(obj['ownerTableName'],'_')}.${obj['display']}}</c:if><c:if test="${otherForm eq null}" >{${obj['display']}}</c:if>"  id="${obj['id']}" tableName="${obj['ownerTableName']}" finalInputType="${obj['finalInputType']}" value="${obj['name']}" extend="${obj.extraMap.canExtend}" formulaStr="{${obj['name']}}" fieldType="${obj['fieldType']}" inputType="${obj['inputType']}" formatType="${obj['formatType']}" <c:if test="${obj['masterField']}">isMasterField=true</c:if> <c:if test="${!obj['masterField']}">isSubField=true</c:if>><c:if test="${obj['masterField']}">[${ctp:i18n('form.base.mastertable.label')}]</c:if> <c:if test="${!obj['masterField']}">[${ctp:i18n('formoper.dupform.label')}${obj.extraMap.subTableIndex }]</c:if>${obj['display']}</option>
						  </c:forEach> 
						</select>
					</div>
					<%--组织机构数据域--%>
		            <div id="org_div" class="hidden">
		            	<select id="orgSelect"  name="orgSelect" size="15" class="w100b" onclick="clickField(this)" ondblclick="dblClickField(this)">
		            	  <c:forEach items="${org}" var="obj" varStatus="status">
						  	<option value="${obj.key}" displayName="[${obj.value}]" inputType="" fieldType="" extend="false">${obj.value}</option>
						  </c:forEach> 
						</select>
					</div>
					<%--日期数据域--%>
		            <div id="date_div" class="hidden">
		            	<select id="dateSelect"  name="dateSelect" size="15" class="w100b" onclick="clickField(this)" ondblclick="dblClickField(this)">
		            	  <c:forEach items="${date}" var="obj" varStatus="status">
						  	<option value="${obj.key}" displayName="[${obj.value}]" inputType="" fieldType="" extend="false">${obj.value}</option>
						  </c:forEach> 
						</select>
					</div>
					<%--系统数据域--%>
		            <div id="system_div" class="hidden">
						<select id="systemSelect"  name="systemSelect" size="15" class="w100b" onclick="clickField(this)" ondblclick="dblClickField(this)">
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
                              <select id="userSelect"  name="userSelect" size="15" class="w100b" onclick="clickField(this)" ondblclick="dblClickField(this)">

                              </select>
                          </div>
                    <%--单据填写值--%>
                    <div id="flowdata_div" class="hidden">
                        <select id="flowData"  name="flowData" size="15" class="w100b" onclick="clickField(this)" ondblclick="dblClickField(this)">
                          <c:forEach items="${fieldList}" var="obj" varStatus="status">
                            <c:if test="${obj['masterField']}">
                              <option displayName="[<%=FormBean.FLOW_PREFIX%>${obj['display']}]"><%=FormBean.FLOW_PREFIX%>[${ctp:i18n('form.base.mastertable.label')}]${obj['display']}</option>
                            </c:if>
                          </c:forEach> 
                        </select>
                    </div>
		        </div>
	    	</div>
	    	<%--  描述信息 --%>
			<div id = "descriptiondiv" formulaAttr="'componentType':'componentType_condition','conditionType':'conditionType_BizCheck'">
				<div class="margin_b_5">&nbsp;${ctp:i18n('form.formula.engin.description.label')}： </div>     
   				<textarea id="description" name="description" cols="70" style="width:440px;height:60px" ></textarea> 
			</div>
        </div>
        <div id="functionarea" class="right" style="height: 315px;width: 210px;margin-top: 10px;overflow: auto;" >
<%-----------------------------------------------------------------------------------------------3.3运算符，函数------------------------------------------------------------------------------------------%>
            <div style="overflow: visible;">
                <div class="clearfix">
				    <%------------------------------------------------------3.3.1 公式运算符 +-*/()--------------------------------------------------------%>
					 <div class="left" width="25%" id="addButton"  formulaAttr="'componentType':'componentType_condition,componentType_extend,componentType_formula','formulaType':'formulaType_number,formulaType_extend_number,formulaType_extend_varchar,formulaType_varchar,formulaType_date,formulaType_datetime'">
                        <a href="javascript:void(0)" class="form_btn" id="add" onclick="doit('+')" ><span class="plus_16"></span></a>
					 </div>
					 <div class="left margin_l_10"  width="25%" id="minusButton"  formulaAttr="'componentType':'componentType_condition,componentType_extend,componentType_formula','formulaType':'formulaType_number,formulaType_extend_number,formulaType_date,formulaType_datetime'">
                        <a href="javascript:void(0)" class="form_btn" id="minus" onclick="doit('-')"><span class="minus_16"></span></a>
					 </div>
					 <div class="left margin_l_10"  width="25%" id="multiplyButton"  formulaAttr="'componentType':'componentType_condition,componentType_extend,componentType_formula','formulaType':'formulaType_number,formulaType_extend_number'">
                        <a href="javascript:void(0)" class="form_btn" id="multiply" onclick="doit('*')"><span class="multiply_16"></span></a>
					 </div>
					 <div class="left margin_l_10" width="25%" id="divisionButton"  formulaAttr="'componentType':'componentType_condition,componentType_extend,componentType_formula','formulaType':'formulaType_number,formulaType_extend_number'">
                        <a href="javascript:void(0)" class="form_btn" id="division" onclick="doit('/')"><span class="divide_16"></span></a>
					 </div>
                </div>
                <div class="clearfix margin_t_10">
                    <div class="left"  id="bracketLeftButton"  formulaAttr="'componentType':'componentType_condition,componentType_extend,componentType_formula','formulaType':'formulaType_number,formulaType_extend_number'">
                        <a href="javascript:void(0)" class="form_btn" id="bracketLeft" onclick="doit('(')"><span class="brackl_16"></span></a>
                     </div>
                     <div class="left margin_l_10"  colspan="3" id="bracketRightButton"  formulaAttr="'componentType':'componentType_condition,componentType_extend,componentType_formula','formulaType':'formulaType_number,formulaType_extend_number'">
                        <a href="javascript:void(0)" class="form_btn" id="bracketRight" onclick="doit(')')"><span class="brackr_16"></span> </a>
                     </div>
                </div>
                
                <div class="margin_t_10 align_left">
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
					    <a href="javascript:void(0)" class="form_btn w89" title= "${ctp:i18n('form.formula.engin.formula.function.title.notlike')}" onclick="doit(function(){<%=ConditionSymbol.not_like.getKey()%>({qsType:${qsType}});})">${ctp:i18n('operator.noLikeread')}</a>
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
	                    <div class="left"  id="sumButton"  formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number','conditionType':'conditionType_all'"> <%---重复表合计---%>
	                        <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.sum.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.sum') }"><%=FunctionSymbol.sum.getText()%></a>
	                    </div>
	                    <div class="left margin_l_5" id="averButton"  formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number','conditionType':'conditionType_all'">  <%---重复表平均---%>
	                        <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.aver.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.aver') }"><%=FunctionSymbol.aver.getText()%></a>
	                    </div>
	                  </div>
	                  <div class="function clearfix margin_t_10" > 
	                    <div class="left"  id="maxButton"  formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number','conditionType':'conditionType_all'">   <%---重复表最大---%>
	                        <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.max.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.max') }"><%=FunctionSymbol.max.getText()%></a>
	                    </div>
	                    <div class="left margin_l_5"  id="minButton"  formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number','conditionType':'conditionType_all'">  <%---重复表最小---%>
	                        <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.min.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.min') }"><%=FunctionSymbol.min.getText()%></a>
	                    </div>
                    </div>
                  <div class="margin_t_10 align_left function" formulaAttr="'componentType':'componentType_formula','formulaType':'formulaType_varchar'">
                        <hr style="height:1px; color:#CCCCCC; width:170px;text-align: left;">
                    </div>
                    <div class="function clearfix margin_t_10"   formulaAttr="'componentType':'componentType_condition','conditionType':'conditionType_BizCheck,conditionType_all'"> 
                    <div class="left"  id="existsButton" >
                        <a href="javascript:void(0)" class="form_btn w89" onclick="doit('exist()')" title="${ctp:i18n('form.formula.engin.formula.function.title.exist')}"><%=FunctionSymbol.exist.getText()%></a>
                    </div>
                    <div class="left margin_l_5" id="allButton">
                        <a href="javascript:void(0)" class="form_btn w89" onclick="doit('all()')"  title="${ctp:i18n('form.formula.engin.formula.function.title.all')}"><%=FunctionSymbol.all.getText()%></a>
                    </div>
                  </div>
                  <div class="margin_t_10 clearfix function" formulaAttr="'componentType':'componentType_condition','conditionType':'conditionType_formula_sub,conditionType_BizCheck,conditionType_sql,conditionType_hign_auth,conditionType_noFunction,conditionType_all'"> 
                    <div class="left"  id="extendButton" >
                        <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){extend();})">extend</a>
                    </div>
                    <div class="left margin_l_5" id="nullButton" >
                        <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){nullValue();})" title="null">${ctp:i18n('form.formula.engin.null.label')}</a>
                    </div>
                  </div>
                    <div class="function clearfix margin_t_10" > 
	                    <div class="left"  id="differDateButton"  formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number','conditionType':'conditionType_formula_sub,conditionType_sql,conditionType_hign_auth,conditionType_BizCheck,conditionType_noFunction'"> <%---日期差---%>
	                        <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.differDate.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.differDate') }"><%=FunctionSymbol.differDate.getText()%></a>
	                    </div>
	                    <div class="left margin_l_5"  id="differTime"  formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number','conditionType':'conditionType_formula_sub,conditionType_sql,conditionType_hign_auth,conditionType_BizCheck,conditionType_noFunction'"> <%---时间差---%>
	                        <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.differTime.getKey()%>();})" title="<%=FunctionSymbol.differTime.getText()%>"><%=FunctionSymbol.differTime.getText()%></a>
	                    </div>
	                    <div class="left margin_t_10" id="differDateTime"  formulaAttr="'componentType':'componentType_formula','formulaType':'formulaType_number'">  <%---日期时间差---%>
	                        <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.differDateTime.getKey()%>();})" title="<%=FunctionSymbol.differDateTime.getText()%>"><%=FunctionSymbol.differDateTime.getText()%></a>
	                    </div>
	                  </div>

                    <c:if test="${empty param.otherformId}">

                        <div class="function clearfix margin_t_10" >
                            <div class="left"  id="sumifButton" isAdvanced="true" formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number','conditionType':'conditionType_all'">   <%---重复表分类合计---%>
                                <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.sumif.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.sumif') }"><%=FunctionSymbol.sumif.getText()%></a>
                            </div>
                            <div class="left margin_l_5"   id="averifButton" isAdvanced="true" formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number','conditionType':'conditionType_all'">  <%---重复表分类平均---%>
                                <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.averif.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.averif') }"><%=FunctionSymbol.averif.getText()%></a>
                            </div>
                        </div>
                        <div class="function clearfix margin_t_10" >
                            <div class="left"  id="maxifButton" isAdvanced="true" formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number','conditionType':'conditionType_all'">   <%---重复表分类最大---%>
                                <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.maxif.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.maxif') }"><%=FunctionSymbol.maxif.getText()%></a>
                            </div>
                            <div class="left margin_l_5"  id="minifButton" isAdvanced="true" formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number','conditionType':'conditionType_all'">  <%---重复表分类最小---%>
                                <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.minif.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.minif') }"><%=FunctionSymbol.minif.getText()%></a>
                            </div>
                        </div>
                    </c:if>
                    <div class="function clearfix margin_t_10" >
                    <div class="left"  id="sumButton" isAdvanced="true" formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number','conditionType':'conditionType_all'">   <%---取整数---%>
                        <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.getInt.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.getInt') }"><%=FunctionSymbol.getInt.getText()%></a>
                    </div>
                    <div class="left margin_l_5" id="averButton" isAdvanced="true"  formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number','conditionType':'conditionType_all'">  <%---取余数---%>
                        <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.getMod.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.getMod') }"><%=FunctionSymbol.getMod.getText()%></a>
                    </div>
                  </div>
                  <div class="function clearfix margin_t_10" >
                    <div class="left"  id="yearButton"  isAdvanced="true" formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number','conditionType':'conditionType_all,conditionType_noFunction,conditionType_BizCheck,conditionType_hign_auth,conditionType_sql,conditionType_formula_sub'">   <%---取年---%>
                        <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.year.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.year') }"><%=FunctionSymbol.year.getText()%></a>
                    </div>
                    <div class="left margin_l_5" id="mouthButton"  isAdvanced="true" formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number','conditionType':'conditionType_all,conditionType_noFunction,conditionType_BizCheck,conditionType_hign_auth,conditionType_sql,conditionType_formula_sub'">  <%---取月---%>
                        <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.month.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.month') }"><%=FunctionSymbol.month.getText()%></a>
                    </div>
                  </div>
                  <div class="function clearfix margin_t_10" >
                    <div class="left"  id="dayButton"  isAdvanced="true" formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number','conditionType':'conditionType_all,conditionType_noFunction,conditionType_BizCheck,conditionType_hign_auth,conditionType_sql,conditionType_formula_sub'">   <%---取日---%>
                        <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.day.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.day') }"><%=FunctionSymbol.day.getText()%></a>
                    </div>
                    <div class="left margin_l_5"  id="weekdayButton" isAdvanced="true" formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_number','conditionType':'conditionType_all,conditionType_noFunction,conditionType_BizCheck,conditionType_hign_auth,conditionType_sql,conditionType_formula_sub'">  <%---取星期---%>
                        <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.weekday.getKey()%>();})" title="${ctp:i18n('form.formula.engin.formula.function.title.weekday') }"><%=FunctionSymbol.weekday.getText()%></a>
                    </div>
                  </div>
                  
                  <div class="function clearfix margin_t_10" >
                    <div class="left" id="toUpperForLongButton"  formulaAttr="'componentType':'componentType_formula','formulaType':'formulaType_varchar'"> <%---大写长格式---%>   
                        <a href="javascript:void(0)" class="form_btn w89" title="${ctp:i18n('form.formula.engin.formula.function.title.toUpperForLong')}" onclick="doit(function(){<%=FunctionSymbol.toUpperForLong.getKey()%>();})"><%=FunctionSymbol.toUpperForLong.getText()%></a>
                    </div>
                    <div class="left margin_l_5" id="toUpperForShortButton"  formulaAttr="'componentType':'componentType_formula','formulaType':'formulaType_varchar'"> <%---大写短格式---%>
                        <a href="javascript:void(0)" class="form_btn w89" title="${ctp:i18n('form.formula.engin.formula.function.title.toUpperForShort')}" onclick="doit(function(){<%=FunctionSymbol.toUpperForShort.getKey()%>();})"><%=FunctionSymbol.toUpperForShort.getText()%></a>
                    </div>
                  </div>
                  <div class="function clearfix margin_t_10" >
                    <div class="left" id="toUpperButton"  formulaAttr="'componentType':'componentType_formula','formulaType':'formulaType_varchar'"> <%---中文大写---%>   
                        <a href="javascript:void(0)" class="form_btn w89" title="${ctp:i18n('form.formula.engin.formula.function.title.toUpper')}" onclick="doit(function(){<%=FunctionSymbol.toUpper.getKey()%>();})"><%=FunctionSymbol.toUpper.getText()%></a>
                    </div>
                  </div>
                  
                  <div class="function clearfix margin_t_10" >
                    <div class="left" id="dateButton"  isAdvanced="true" formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_varchar','conditionType':'conditionType_all,conditionType_noFunction,conditionType_hign_auth,conditionType_BizCheck,conditionType_sql'"> <%---取日期---%>   
                        <a href="javascript:void(0)" class="form_btn w89" title="${ctp:i18n('form.formula.engin.formula.function.title.date')}" onclick="doit(function(){<%=FunctionSymbol.date.getKey()%>();})"><%=FunctionSymbol.date.getText()%></a>
                    </div>
                    <div class="left margin_l_5" id="timeButton" isAdvanced="true" formulaAttr="'componentType':'componentType_formula,componentType_condition','formulaType':'formulaType_varchar','conditionType':'conditionType_all,conditionType_noFunction,conditionType_hign_auth,conditionType_BizCheck,conditionType_sql'"> <%---取时间---%>
                        <a href="javascript:void(0)" class="form_btn w89" title="${ctp:i18n('form.formula.engin.formula.function.title.time')}" onclick="doit(function(){<%=FunctionSymbol.time.getKey()%>();})"><%=FunctionSymbol.time.getText()%></a>
                    </div>
                  </div>
                  
                  <div class="function clearfix margin_t_10" >
                    <div class="left"  id="designButton"  isAdvanced="true" formulaAttr="'componentType':'componentType_formula','formulaType':'formulaType_varchar,formulaType_number'"> <%---函数自定义---%>   
                        <a href="javascript:void(0)" class="form_btn w89" onclick="doit(function(){<%=FunctionSymbol.design.getKey()%>();})" title="<%=FunctionSymbol.design.getText()%>"><%=FunctionSymbol.design.getText()%></a>
                    </div>
                  </div>
                </div>
                
            </div>
        </div>
    </div>
 </form>
</div>
<script type="text/javascript" src="${path}/ajax.do?managerName=formManager"></script>  
<%@ include file="textUtil.js.jsp" %>
<%@ include file="../common/common.js.jsp" %>
<%@ include file="formula.js.jsp" %>
<%@ include file="formulaAction.js.jsp" %>
<script></script>
</body>
</html>