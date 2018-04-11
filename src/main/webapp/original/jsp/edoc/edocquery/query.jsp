<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../edocHeader.jsp" %>
<fmt:setBundle basename="com.seeyon.v3x.isearch.resources.i18n.ISearchResources" var="isearchI18N"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='common.combsearch.label'/></title>
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/isearch/css/isearch.css${v3x:resSuffix()}" />">
<c:set value="${pageContext.request.contextPath}" var="path" />
<link rel="stylesheet" href="${path}/common/all-min.css" />
<link rel="stylesheet" href="${path}/skin/default/skin.css" />

<script type="text/javascript">

<!--

function listenerKeyPress(){
	if(event.keyCode == 27){
		window.close();
	}
}

function edocSearch()
{
  if(compareDate(myform.createTimeB.value,myform.createTimeE.value)>0)
  {
    alert(_("edocLang.begin_later_than_end_alert"));
    return;
  }
  if(document.getElementById("receiveTimeB")!=null && compareDate(myform.receiveTimeB.value,myform.receiveTimeE.value)>0)
  {
    alert(_("edocLang.receivetime_begin_later_than_end_alert"));
    return;
  }
  if(document.getElementById("registerDateB")!=null && compareDate(myform.registerDateB.value,myform.registerDateE.value)>0)
  {
    alert(_("edocLang.registetime_begin_later_than_end_alert"));
    return;
  }
  if(document.getElementById("recieveDateB")!=null && compareDate(myform.recieveDateB.value,myform.recieveDateE.value)>0)
  {
    alert(_("edocLang.receivedate_begin_later_than_end_alert"));
    return;
  }
  if(document.getElementById("expectprocesstimeB")!=null && compareDate(myform.expectprocesstimeB.value,myform.expectprocesstimeE.value)>0)
  {
    alert(_("edocLang.log_search_overtime"));
    return;
  }
  if(document.getElementById("workflowDateB")!=null && compareDate(myform.workflowDateB.value,myform.workflowDateE.value)>0)
  {
    alert("流程期限的开始日期不能晚于结束日期");
    return;
  }
  //赋值给父页面的全局变量combQueryObj
  var _parent = transParams.parentWin;

  
  _parent.addCombQueryObj(
		  document.getElementById("subject").value,
		  document.getElementById("docMark").value,
		  document.getElementById("serialNo").value,
		  document.getElementById("createPerson")==null?"":document.getElementById("createPerson").value,
		  document.getElementById("createTimeB").value,
		  document.getElementById("createTimeE").value,
		  document.getElementById("secretLevel").value,
		  document.getElementById("urgentLevel").value,
		  document.getElementById("keywords")==null?"":document.getElementById("keywords").value,
		  document.getElementById("receiveTimeB")==null?"":document.getElementById("receiveTimeB").value,
		  document.getElementById("receiveTimeE")==null?"":document.getElementById("receiveTimeE").value,
		  document.getElementById("sendUnit")==null?"":document.getElementById("sendUnit").value,
		  document.getElementById("registerDateB")==null?"":document.getElementById("registerDateB").value,
		  document.getElementById("registerDateE")==null?"":document.getElementById("registerDateE").value,
		  document.getElementById("recieveDateB")==null?"":document.getElementById("recieveDateB").value,
		  document.getElementById("recieveDateE")==null?"":document.getElementById("recieveDateE").value,
		  document.getElementById("expectprocesstimeB")==null?"":document.getElementById("expectprocesstimeB").value,
		  document.getElementById("expectprocesstimeE")==null?"":document.getElementById("expectprocesstimeE").value,
		  document.getElementById("summaryState")==null?"":document.getElementById("summaryState").value,
		  document.getElementById("workflowDateB")==null?"":document.getElementById("workflowDateB").value,
		  document.getElementById("workflowDateE")==null?"":document.getElementById("workflowDateE").value
				  
);
  _parent.isCombSearchFlag=true;
  //关闭窗口
  transParams.parentWin.combQueryEventCallback();
  commonDialogClose('win123');
  return true;
}


function resetForm()
{
	document.getElementById("subject").value="";
	document.getElementById("docMark").value="";
	document.getElementById("serialNo").value="";
	if(document.getElementById("createPerson") != null){
		document.getElementById("createPerson").value="";
	}
	document.getElementById("createTimeB").value="";
	document.getElementById("createTimeE").value="";
	document.getElementById("secretLevel").value="";
	document.getElementById("urgentLevel").value="";
	if(document.getElementById("keywords")!=null)document.getElementById("keywords").value="";
	if(document.getElementById("receiveTimeB")!=null)document.getElementById("receiveTimeB").value="";
	if(document.getElementById("receiveTimeE")!=null)document.getElementById("receiveTimeE").value="";
	if(document.getElementById("sendUnit")!=null)document.getElementById("sendUnit").value="";
	if(document.getElementById("registerDateB")!=null)document.getElementById("registerDateB").value="";
	if(document.getElementById("registerDateE")!=null)document.getElementById("registerDateE").value="";
	if(document.getElementById("recieveDateB")!=null)document.getElementById("recieveDateB").value="";
	if(document.getElementById("recieveDateE")!=null)document.getElementById("recieveDateE").value="";
	if(document.getElementById("expectprocesstimeB")!=null)document.getElementById("expectprocesstimeB").value="";
	if(document.getElementById("expectprocesstimeE")!=null)document.getElementById("expectprocesstimeE").value="";

	if(document.getElementById("workflowDateB") != null){
	 	document.getElementById("workflowDateB").value = "";
	}

	if(document.getElementById("workflowDateE") != null){
	 	document.getElementById("workflowDateE").value = "";
	}
}
function initFormInput()
{
	var _parent = transParams.parentWin;

	if(_parent.document.getElementById("comb_condition")==null || _parent.document.getElementById("comb_condition").value==""){return;}
	
	document.getElementById("subject").value=_parent.document.getElementById("comb_subject").value;
	document.getElementById("docMark").value=_parent.document.getElementById("comb_docMark").value;
	document.getElementById("serialNo").value=_parent.document.getElementById("comb_serialNo").value;
	if(document.getElementById("createPerson") != null){
		document.getElementById("createPerson").value = _parent.document.getElementById("comb_createPerson").value;
	}
	document.getElementById("createTimeB").value=_parent.document.getElementById("comb_createTimeB").value;
	document.getElementById("createTimeE").value=_parent.document.getElementById("comb_createTimeE").value;

	if(_parent.document.getElementById("comb_summaryState") && _parent.document.getElementById("comb_summaryState").value!=""){
		document.getElementById("summaryState").value = _parent.document.getElementById("comb_summaryState").value;
	}

	if(_parent.document.getElementById("comb_workflowDateB") && _parent.document.getElementById("comb_workflowDateB").value!=""){
		document.getElementById("workflowDateB").value = _parent.document.getElementById("comb_workflowDateB").value;
	}

	if(_parent.document.getElementById("comb_workflowDateE") && _parent.document.getElementById("comb_workflowDateE").value!=""){
		document.getElementById("workflowDateE").value = _parent.document.getElementById("comb_workflowDateE").value;
	}
	
	if(_parent.document.getElementById("comb_secretLevel").value!="")document.getElementById("secretLevel").value=_parent.document.getElementById("comb_secretLevel").value;
	if(_parent.document.getElementById("comb_urgentLevel").value!="")document.getElementById("urgentLevel").value=_parent.document.getElementById("comb_urgentLevel").value;
	if(_parent.document.getElementById("comb_keywords").value!="")document.getElementById("keywords").value=_parent.document.getElementById("comb_keywords").value;
	if(_parent.document.getElementById("comb_receiveTimeB").value!="")document.getElementById("receiveTimeB").value=_parent.document.getElementById("comb_receiveTimeB").value;
	if(_parent.document.getElementById("comb_receiveTimeE").value!="")document.getElementById("receiveTimeE").value=_parent.document.getElementById("comb_receiveTimeE").value;
	if(_parent.document.getElementById("comb_sendUnit").value!="")document.getElementById("sendUnit").value=_parent.document.getElementById("comb_sendUnit").value;
	if(_parent.document.getElementById("comb_registerDateB").value!="")document.getElementById("registerDateB").value=_parent.document.getElementById("comb_registerDateB").value;
	if(_parent.document.getElementById("comb_registerDateE").value!="")document.getElementById("registerDateE").value=_parent.document.getElementById("comb_registerDateE").value;
	if(_parent.document.getElementById("comb_recieveDateB").value!="")document.getElementById("recieveDateB").value=_parent.document.getElementById("comb_recieveDateB").value;
	if(_parent.document.getElementById("comb_recieveDateE").value!="")document.getElementById("recieveDateE").value=_parent.document.getElementById("comb_recieveDateE").value;
	if(_parent.document.getElementById("comb_expectprocesstimeB").value!="")document.getElementById("expectprocesstimeB").value=_parent.document.getElementById("comb_expectprocesstimeB").value;
	if(_parent.document.getElementById("comb_expectprocesstimeE").value!="")document.getElementById("expectprocesstimeE").value=_parent.document.getElementById("comb_expectprocesstimeE").value;
} 
//-->
</script>
<style>
.stadic_body_top_bottom{
	bottom: 30px;
	top: 0px;
	position:absolute;
}
.stadic_footer_height{
	height:30px;
	position:absolute;
	bottom:0;
	width:100%;
}
input,select {
	height:22px;
}
TR {
	height:26px;
}
</style>
</head>
<body class="w100b over_hidden" onkeydown="listenerKeyPress()" onLoad="initFormInput()">

<div class="stadic_layout"  style="background: #F3F3F3;">
	

<div class="stadic_body_top_bottom padding_lr_10" style="background: #F3F3F3;">

<!-- 查询条件设置 -->
<form id="myform" name="myform">

<div id="fieldTwo" align="center" name="fieldTwo" class="w100b" style="margin-top:15px;vertical-align:top;border:0px;background:#F3F3F3;">

<TABLE class="w100b">			
	<TR>
	  	<TD class="margin_r_10 padding_r_5" align="right" nowrap="nowrap"><fmt:message key='edoc.element.subject'/>:</TD>
	  	<TD width="40%"><input type="text" class="w100b" name="subject" id="subject"></TD>
	  	<c:if test="${edocType eq '0' or edocType eq '1' or edocType eq '2'}">
	  		<c:choose>
	  			<c:when test="${edocState eq '2'}">
	  				<TD class="margin_r_10 padding_r_5" align="right" nowrap="nowrap">
	  					<fmt:message key="edoc.workflow.state.label" bundle="${v3xCommonI18N}" />:
	  				</TD>
			        <TD width="40%">
			        	<select name="summaryState" id="summaryState" class="w100b">
			        		<option value="0" selected><fmt:message key="edoc.unend" bundle="${v3xCommonI18N}" /></option>
			        		<option value="3"><fmt:message key="edoc.ended" bundle="${v3xCommonI18N}" /></option>
			        		<option value="1"><fmt:message key="edoc.terminated" bundle="${v3xCommonI18N}" /></option>
			        	</select>
			        </TD>
	  			</c:when>
				<c:otherwise>
					<c:if test="${edocType eq '0' or edocType eq '2'}">
					  	<TD class="margin_r_10 padding_r_5" align="right" nowrap="nowrap"><fmt:message key="common.sender.label" bundle="${v3xCommonI18N}" />:</TD>
				        <TD width="40%"><input type="text" class="w100b" name="createPerson" id="createPerson"></TD>
			        </c:if>
			        <c:if test="${edocType eq '1'}">
			            <TD>&nbsp;</TD>
			            <TD class="padding_r_10">&nbsp;</TD>
			        </c:if>
				</c:otherwise>	  		
	  		</c:choose>
        </c:if>
        <c:if test="${edocType eq '1'}">
            <TD>&nbsp;</TD>
            <TD class="padding_r_10">&nbsp;</TD>
        </c:if>
	</TR>	
	<TR>
	  	<TD class="margin_r_10 padding_r_5" align="right" nowrap="nowrap"><fmt:message key='edoc.element.wordno.label'/>:</TD>
	  	<TD width="40%"><input type="text" class="w100b" name="docMark" id="docMark"></TD>
	  	<TD class="padding_l_20 padding_r_5" align="right" nowrap="nowrap"><fmt:message key='edoc.element.wordinno.label'/>:</TD>				  
	  	<TD width="40%"><input type="text" class="w100b" name="serialNo" id="serialNo"></TD>
	</TR>
	<TR>
	    <c:if test="${edocType eq '1'}">
            <c:if test="${edocState eq '2'}">
	    		<TD class="padding_l_20 padding_r_5" align="right" nowrap="nowrap">
					<fmt:message key="edoc.supervise.deadline.flow" bundle="${v3xCommonI18N}" />:
				</TD>                    
		        <TD width="40%">
		        	<table border="0" cellpadding="0" cellspacing="0" style="width: 100%;TABLE-LAYOUT: fixed;">
		            	<tr>
		                	<td style="width: 48%">
		                		<input type="text" class="w100b" readonly="readonly" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);" name="workflowDateB" id="workflowDateB" />
			                </td>
			                <td style="width: 7px;text-align: center;" valign="middle" align="center">-</td>
			                <td style="widthxuqiu: 48%">
			                	<input type="text" class="w100b" readonly="readonly" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);" name="workflowDateE" id="workflowDateE" />
			                </td>
		               </tr>
	              </table>
		        </TD>
	    	</c:if>
	    	<c:if test="${edocState ne '2'}">
	            <TD class="margin_r_10 padding_r_5" align="right" nowrap="nowrap"><fmt:message key="common.sender.label" bundle="${v3xCommonI18N}" />:</TD>
	            <TD width="40%"><input type="text" class="w100b" name="createPerson" id="createPerson"></TD>
	    	</c:if>
        </c:if>
		<TD class="padding_l_20 padding_r_5" align="right" nowrap="nowrap"><fmt:message key='edoc.supervise.startdate'/>:</TD>					
		<TD width="40%">
		   <table border="0" cellpadding="0" cellspacing="0" style="width: 100%;TABLE-LAYOUT: fixed;">
		      <tr>
		         <td style="width: 48%">
		           <input type="text" class="w100b" name="createTimeB" id="createTimeB" readonly="readonly" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);" />
		         </td>
		         <td style="width: 7px;text-align: center;" valign="middle" align="center">-</td>
		         <td style="width: 48%">
		           <input type="text" class="w100b" name="createTimeE" id="createTimeE" readonly="readonly" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);" />
		         </td>
		      </tr>
		   </table>
		</TD>
		<c:if test="${edocType eq '0' or edocType eq '2'}">
            <c:if test="${edocState eq '2' }">
				<TD class="padding_l_20 padding_r_5" align="right" nowrap="nowrap">
					<fmt:message key="edoc.supervise.deadline.flow" bundle="${v3xCommonI18N}" />:
				</TD>                    
		        <TD width="40%">
		        	<table border="0" cellpadding="0" cellspacing="0" style="width: 100%;TABLE-LAYOUT: fixed;">
		            	<tr>
		                	<td style="width: 48%">
		                		<input type="text" class="w100b" readonly="readonly" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);" name="workflowDateB" id="workflowDateB" />
			                </td>
			                <td style="width: 7px;text-align: center;" valign="middle" align="center">-</td>
			                <td style="width: 48%">
			                	<input type="text" class="w100b" readonly="readonly" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);" name="workflowDateE" id="workflowDateE" />
			                </td>
		               </tr>
	              </table>
		        </TD>
			</c:if>
			<c:if test="${edocState ne '2' }">
	            <TD class="padding_l_20 padding_r_5" align="right" nowrap="nowrap"><fmt:message key='node.receivetime'/>:</TD>                    
		        <TD width="40%">
		           <table border="0" cellpadding="0" cellspacing="0" style="width: 100%;TABLE-LAYOUT: fixed;">
	                <tr>
	                 <td style="width: 48%">
	                   <input type="text" class="w100b" readonly="readonly" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);" name="receiveTimeB" id="receiveTimeB" />
	                 </td>
	                 <td style="width: 7px;text-align: center;" valign="middle" align="center">-</td>
	                 <td style="width: 48%">
	                   <input type="text" class="w100b" readonly="readonly" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);" name="receiveTimeE" id="receiveTimeE" />
	                 </td>
	               </tr>
	              </table>
		        </TD>
			</c:if>
        </c:if>
	</TR>
	<c:if test="${edocType eq '1'}">
	<TR>
		<TD class="margin_r_10 padding_r_5" align="right" nowrap="nowrap"><fmt:message key="edoc.element.register.date"/>:</TD>					
		<TD>
		  <table border="0" cellpadding="0" cellspacing="0" style="width: 100%;TABLE-LAYOUT: fixed;">
                <tr>
                 <td style="width: 48%">
                   <input type="text" class="w100b" readonly="readonly" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);" name="registerDateB" id="registerDateB" />
                 </td>
                 <td style="width: 7px;text-align: center;" valign="middle" align="center">-</td>
                 <td style="width: 48%">
                   <input type="text" class="w100b" readonly="readonly" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);" name="registerDateE" id="registerDateE" />
                 </td>
               </tr>
              </table>
		</TD>
		<TD class="padding_l_20 padding_r_5" align="right" nowrap="nowrap"><fmt:message key="edoc.element.receipt_date"/>:</TD>					
		<TD width="40%">
		  <table border="0" cellpadding="0" cellspacing="0" style="width: 100%;TABLE-LAYOUT: fixed;">
                <tr>
                 <td style="width: 48%">
                   <input type="text" class="w100b" readonly="readonly" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);" name="recieveDateB" id="recieveDateB" />
                 </td>
                 <td style="width: 7px;text-align: center;" valign="middle" align="center">-</td>
                 <td style="width: 48%">
                   <input type="text" class="w100b" readonly="readonly" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);" name="recieveDateE" id="recieveDateE" />
                 </td>
               </tr>
              </table>
		</TD>
	</TR>
	<TR>
		<TD class="margin_r_10 padding_r_5" align="right" nowrap="nowrap"><fmt:message key='edoc.element.sendunit'/>:</TD>					
		<TD colspan="3" class="padding_r_10"><input type="text" class="w100b" name="sendUnit" id="sendUnit"></TD>
	</TR>
	</c:if>
	
	<TR>
		<TD class="margin_r_10 padding_r_5" align="right" nowrap="nowrap"><fmt:message key='edoc.element.urgentlevel'/>:</TD>
		<TD>
			<select name="urgentLevel" id="urgentLevel" class="w100b">
				<option value="" selected><fmt:message key='common.pleaseSelect.label'/></option>
				<v3x:metadataItem metadata="${urgentLevelMetadata}" showType="option" name="urgentLevel" bundle="${colI18N}" switchType="zhangh"/>
			</select>
		</TD>
		<TD class="padding_l_20 padding_r_5" align="right" nowrap="nowrap"><fmt:message key='edoc.element.receive.register.form.secretlevel'/>:</TD>
		<TD width="40%">
			<select name="secretLevel" id="secretLevel" class="w100b">
				<option value="" selected><fmt:message key='common.pleaseSelect.label'/></option>
				<v3x:metadataItem metadata="${secretLevelMetadata}" showType="option" name="secretLevel" bundle="${colI18N}" switchType="zhangh"/>
			</select>
		</TD>
	</TR>
	<c:if test="${(edocType ne '0' and edocType ne '1' and edocType ne '2') or edocState ne '2'}">
		<tr>
	       <TD class="padding_l_20 padding_r_5" align="right" nowrap="nowrap"><fmt:message key="process.expectprocesstime.label"/>:</TD>                    
	       <TD width="40%">
	       <table border="0" cellpadding="0" cellspacing="0" style="width: 100%;TABLE-LAYOUT: fixed;">
                <tr>
                 <td style="width: 48%">
                   <input type="text" class="w100b" readonly="readonly" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);" name="expectprocesstimeB" id="expectprocesstimeB" />
                 </td>
                 <td style="width: 7px;text-align: center;" valign="middle" align="center">-</td>
                 <td style="width: 48%">
                   <input type="text" class="w100b" readonly="readonly" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);" name="expectprocesstimeE" id="expectprocesstimeE" />
                 </td>
               </tr>
           </table>
	       </TD>
	       <TD class="padding_l_20 padding_r_5" align="right" nowrap="nowrap">&nbsp;</TD>                    
           <TD width="40%">&nbsp;</TD>
		</tr>
	</c:if>
</TABLE>
	
</div>	
</form>
</div>

<!-- 查询条件设置结束 -->
<div class=" stadic_layout_footer stadic_footer_height padding_tb_5" align="right" style="position:absolute;bottom:0;line-height:30px;background:#F3F3F3;">
	<input type="button" class="button-default_emphasize" name="btn" onClick="edocSearch();" value="<fmt:message key='common.search.label'/>">
	<input type="button" class="button-default-2 margin_r_10" onClick="commonDialogClose('win123');" name="btn" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />">	
</div><!-- stadic_layout_footer -->
</div>
</body>
</html>