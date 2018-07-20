<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../edocHeader.jsp"%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
<!--
	//保存公文备考
	function saveRemark() {
		if(!checkForm(myform))
		return;//验证form
		
		var aId = myform.id.value;
		myform.action = "${edocStat}?method=saveEdocRemark&id=" + aId;
		myform.target = "empty";
		myform.submit();
	}
	function setMainSendUnitFields(elements)
	{
		myform.sendTo.value=getNamesString(elements);
  		myform.sendToId.value=getIdsString(elements);
	}
	
	function setSendUnitFields(elements)
	{
		myform.sendUnit.value=getNamesString(elements);  		
	}
	
	function edocSearch()
	{
	  if(compareDate(myform.createTimeB.value,myform.createTimeE.value)>0)
	  {
	    alert(_("edocLang.begin_later_than_end_alert"));
	    return;
	  }
	  myform.submit();
	}
	
	function resetForm()
	{
	  myform.sendToId.value="";
	  elements_mainSendToUnit="";
	  elements_sendUnit="";
	  
	  myform.reset();	  
	}

//-->
</script>
<style>
.linetop {/*<用友致远发文单>*/
	font-family: Arial, Helvetica, sans-serif;
	font-size: 13px;
	color: #FF0000;
	text-indent: 10pt;
	border-bottom-width: 2px;
	border-bottom-style: solid;
	border-bottom-color: #FF0000;
	align:center;
}
.linel{/*<公文要素名称>*/
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	color: #FF0000;
	text-indent: 10pt;
	border-bottom-width: 1px;
	border-right-width: 1px;
	border-bottom-style: solid;
	border-bottom-color: #FF0000;
	border-right-style: solid;
	border-right-color: #FF0000;
	font-weight: bold;
	height: 20px;
	width: 80px;
}
.linec{/*<用户输入区(公文要素)>*/
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	color: #000000;
	text-indent: 6pt;
	border-bottom-width: 1px;
	border-right-width: 1px;
	border-bottom-style: solid;
	border-bottom-color: #FF0000;
	border-right-style: solid;
	border-right-color: #FF0000;	
	line-height: 20px;
	height: 20px;
}
.liner{/*<用户输入区边框右侧为空>*/
	font-family: Arial, Helvetica, sans-serif;
	font-size: 12px;
	color: #000000;
	text-indent: 6pt;
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-bottom-color: #FF0000;
	height: 20px;
}
input{
width:155px;
}
select{
width:155px;
}
</style>
</head>
<body scroll="no">
<v3x:selectPeople id="mainSendToUnit" panels="Account,Department,ExchangeAccount,OrgTeam" selectType="Account,Department,ExchangeAccount,OrgTeam" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" jsFunction="setMainSendUnitFields(elements)" viewPage="" minSize="0" maxSize="1" showAllAccount="true" />
<v3x:selectPeople id="sendUnit" panels="Account,Department,ExchangeAccount,OrgTeam" selectType="Account,Department,ExchangeAccount,OrgTeam" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" jsFunction="setSendUnitFields(elements)" viewPage="" minSize="0"  maxSize="1" showAllAccount="true" />
<form id="myform" name="myform" method="post" action="${edoc}?method=listEdocSearchReult" target="bottom">

<TABLE width="100%" height="100%" bgcolor="#FFFFFF" cellspacing="0" cellpadding="0">
	<TR>						
		<TD align="left" VALIGN="top">
			<div class="scrollList">
			<TABLE cellspacing="0" border="0">				
				<TR>
				  <TD style="height=5px">&nbsp;</TD>
				  <TD></TD>
				  <TD colspan="4">&nbsp;</TD>
			  </TR>
				<TR>
				  <TD width="120px" align="center"><b><fmt:message key='edoc.search.design.label'/>:</b></TD>
				  <TD><fmt:message key='edoc.sorttype.label'/>:</TD>
				  <TD colspan="4" >
				  <select name="edocType">
				  <option value="0"><fmt:message key='edoc.docmark.inner.send'/></option>
				  <option value="1" selected="selected"><fmt:message key='edoc.docmark.inner.receive'/></option>				  
				  <option value="2"><fmt:message key='edoc.docmark.inner.signandreport'/></option>
				  </select></TD>
			  </TR>
				
				<TR>
				  <TD>&nbsp;</TD>
				  <TD><fmt:message key='edoc.element.subject'/>:</TD>
				  <TD width="180px"><input type="text" name="subject"></TD>
				  <TD><fmt:message key='edoc.element.keyword'/>:</TD>				  
				  <TD  width="180px"><input type="text" name="keywords">				</TD>
				  <TD >&nbsp;</TD>
			  </TR>
				<TR>
				  <TD>&nbsp;</TD>
				  <TD><fmt:message key='edoc.element.wordno.label'/>:</TD>
				  <TD><input type="text" name="docMark"></TD>
				  <TD><fmt:message key='edoc.element.wordinno.label'/>:</TD>				  
				  <TD ><input type="text" name="serialNo"></TD>
				  <TD >&nbsp;</TD>
			  </TR>
				<TR>
				  <TD>&nbsp;</TD>
					<TD><fmt:message key='edoc.element.doctype'/>:</TD>
					<TD>
					<select name="docType">
					<option value="" selected><fmt:message key='common.pleaseSelect.label'/></option>
					<v3x:metadataItem metadata="${edocTypeMetadata}" showType="option" name="docType" bundle="${colI18N}" switchType="zhangh"/>
					</select>					</TD>
					<TD><fmt:message key='edoc.element.sendtype'/>:</TD>
					<TD >
					<select name="sendType">
					<option value="" selected><fmt:message key='common.pleaseSelect.label'/></option>
					<v3x:metadataItem metadata="${sendTypeMetadata}" showType="option" name="sendType" bundle="${colI18N}" switchType="zhangh"/>
					</select></TD>
					<TD >&nbsp;</TD>
				</TR>
				<TR>
				  <TD>&nbsp;</TD>
					<TD><fmt:message key='edoc.element.author'/>:</TD>
					<TD><input type="text" name="createPerson"></TD>
					<TD><fmt:message key='edoc.element.createdate'/>:</TD>					
					<TD >
					<input type="text" name="createTimeB" readonly="readonly" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);" style="width:75px;">-<input  style="width:75px;" type="text" name="createTimeE" readonly="readonly" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);">					</TD>
					<TD >&nbsp;</TD>
				</TR>
				<TR>
				  <TD>&nbsp;</TD>
					<TD><fmt:message key='edoc.element.sendtounit'/>:</TD>
					<TD><input type="text" name="sendTo" readonly="readonly" onClick="selectPeopleFun_mainSendToUnit();"><input type="hidden" name="sendToId"></TD>
					<TD><fmt:message key='edoc.element.sendunit'/>:</TD>					
					<TD ><input type="text" name="sendUnit" onDblClick="selectPeopleFun_sendUnit();"></TD>
					<TD >&nbsp;</TD>
				</TR>				
				<TR>
				  <TD>&nbsp;</TD>
					<TD><fmt:message key='edoc.element.issuer'/>:</TD>
					<TD><input type="text" name="issuer"></TD>
					<TD><fmt:message key='edoc.element.sendingdate'/>:</TD>					
					<TD ><input type="text" readonly="readonly" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);" name="signingDate"></TD>
					<TD >
					<input type="button" style="width:50px" name="btn" onClick="edocSearch();" value="<fmt:message key='common.search.label'/>">&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" onclick="resetForm()" style="width:50px" name="btn" value="<fmt:message key='common.reset.label'/>">					</TD>
				</TR>				
			</TABLE>
			</div>
		</TD>				
	</TR>			
</TABLE>		

</form>
<script>
//showDetailPageBaseInfo("bottom", "<fmt:message key='edoc.stat.query.label' />", "/common/images/detailBannner/207.gif", null, _("edocLang.detail_info_207"));
</script>
</body>