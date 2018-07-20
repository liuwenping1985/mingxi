<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="edocHeader.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value='/apps_res/v3xmain/js/shortcut.js${v3x:resSuffix()}' />"></script>
<title><fmt:message key='edoc.custom.classification'/></title>
<script type="text/javascript">
if(getA8Top()!=null && typeof(getA8Top().showLocation)!="undefined") {
  getA8Top().showLocation();
}


function setDisplayCol(){
	var target = document.getElementById("menuTargetSelect");
	var opvalue = "";
	var opname = "";
	for(i=0;i<target.options.length;i++){
		opvalue += target.options[i].value+",";
		opname += target.options[i].text+",";
	}
	if(opvalue.lastIndexOf(",") == opvalue.length-1){
		opvalue = opvalue.substring(0,opvalue.length-1);
		opname = opname.substring(0,opname.length-1);
	}
	var initW = transParams.parentWin; ////获得父窗口对象
	//设置收文情况
	initW.document.getElementById('displayCol').value=opvalue;
	initW.document.getElementById('displayColName').value=opname;
	commonDialogClose('win123');
}

</script>
</head>
<body scroll="no">

	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="popupTitleRight">
     <tr>
       <td height="20" class="PopupTitle"><fmt:message key='edoc.custom.classification'/>
		</td>
     </tr>
	  <tr>
	    <td width="100%" class="tab-body-bg" align="center">
        <table width="550" align="center" border="0" cellpadding="0" cellspacing="0">
              <tr>
		        <td width="100%" valign="top">
		     	 <table width="100%" height="100%" align="center" border="0" cellpadding="0" cellspacing="0">
		              <tr>
				        <td width="150" height="20" align="left" >
				        	<b>&nbsp;&nbsp;<fmt:message key="shortcut.all.label" bundle="${v3xMainI18N}"/></b>
				        </td>
				        <td width="15">&nbsp;</td>
				        <td width="150" align="left">
				        	<b>&nbsp;&nbsp;<fmt:message key="selectPeople.selected.label" bundle="${v3xMainI18N}"/></b>
				         </td>
				         <td width="20">&nbsp;</td> 
				     </tr>
		              <tr>
				        <td align="center">
						    <SELECT name="menuSourceSelect" size="17" id="menuSourceSelect" multiple style="width:250px; height: 255px;" ondblclick="addThisItem('menu')">
								<c:forEach items="${leftMap}" var="edoc">
									<option value="${edoc.key}"><fmt:message key="${edoc.value}"/></option> 
								</c:forEach>
						    </SELECT>
				        </td>
				        <td align="center">
			         		<img alt="<fmt:message key='selectPeople.alt.select'/>" src="<c:url value='/common/images/arrow_a.gif'/>" width="15"
									height="12" class="cursor-hand" onClick="addThisItem('menu')"><br/><br/>
							<img alt="<fmt:message key='selectPeople.alt.unselect'/>" src="<c:url value='/common/images/arrow_del.gif'/>" width="15"
									height="12" class="cursor-hand" onClick="removeThisItem('menu')">
						</td>
				        <td align="center">
						    <SELECT name="menuTargetSelect" size="17" id="menuTargetSelect" multiple style="width:250px; height: 255px;" ondblclick="removeThisItem('menu')">
								<c:forEach items="${targetMap }" var="edoc">
									<option value="${edoc.key }"><fmt:message key="${edoc.value }"/></option> 
								</c:forEach>
						    </SELECT>
						    <input type="hidden" name="menuSpareIds" id="menuSpareIds" value="">
						    <input type="hidden" name="oldMenuSpareIds" id="oldMenuSpareIds" value="">
				        </td>
				        <td>
			         		<p><img alt="<fmt:message key='selectPeople.alt.up'/>" src="<c:url value='/common/images/arrow_u.gif'/>" width="12"
									height="15" class="cursor-hand" onClick="moveUp('menu')"></p><br />
							<p><img alt="<fmt:message key='selectPeople.alt.down'/>" src="<c:url value='/common/images/arrow_d.gif'/>" width="12"
									height="15" class="cursor-hand" onClick="moveDown('menu')"></p>
						</td>
				     </tr>
					</table>
		   </td>
		   </tr>
		   </table>
	    </td>
	  </tr>
	  <tr>
			<td height="35" align="right" class="tab-body-bg bg-advance-bottom">
				<input type="button" onClick="setDisplayCol();" id="submitButton" name="submitButton" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default_emphasize">&nbsp;&nbsp;
				<input type="button" onClick="commonDialogClose('win123');" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2">
			</td>
		</tr>
	</table>
</body>
</html>