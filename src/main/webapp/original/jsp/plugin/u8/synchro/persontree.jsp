<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<%@include file="header.jsp"%>
		<script type="text/javascript">
		var  pk_co="${param.ncOrgCorp}";
		var EmptyProperties = new Properties();
function personInit(){
	var memberDataBody = document.getElementById("memberDataBody");
	<c:forEach items="${listPerson}" var="person">
	if(!EmptyProperties.containsKey("${person.pk_psndoc}"))
	{
		memberDataBody.add(createOption("${person.pk_psndoc}","${person.psnname}"));
	}
	</c:forEach>
}
function personFilderInit(){
	var memberDataBody = document.getElementById("ListSelect");
	<c:forEach items="${filderlist}" var="person">
		memberDataBody.add(createOption("${person.pk_psndoc}","${person.psnname}"));
		EmptyProperties.put("${person.pk_psndoc}","${person.pk_psndoc}");
	</c:forEach>
}
function doSelect(){
	var memberDataBody = document.getElementById("memberDataBody");
	var listSelect = document.getElementById("ListSelect");
	var items = memberDataBody.options;
	if(items != null && items.length > 0){
	    var selectIndex=-1;
		for(var i = 0; i < items.length; i++){
			var item = items[i];
			if(item.selected){
				selectIndex=item.index;
				listSelect.add(createOption(item.value, item.text));
			    break;
			}
		}
		if(selectIndex!=-1)
		{
		memberDataBody.remove(selectIndex);
		doSelect();
		}
	}
}

function doremove(){
    var memberDataBody = document.getElementById("memberDataBody");
	var listSelect = document.getElementById("ListSelect");
	var items = listSelect.options;
	if(items != null && items.length > 0){
		   var selectIndex=-1;
		   var item;
		for(var i = 0; i < items.length; i++){
			item = items[i];
			if(item.selected){
			selectIndex=item.index;
			break;
			}
		}
		if(selectIndex!=-1)
			{
			deleteFilderPerson(pk_co,item.value);
			listSelect.remove(selectIndex);
			memberDataBody.add(createOption(item.value, item.text));
			doremove();
			}
	}
}

function  doremove1()
{
var listSelect = document.getElementById("ListSelect");
var items = listSelect.options;
if(items != null && items.length > 0)
{
    if(window.confirm(deletConfirm()))
    {
      doremove();
    }
}
}
function  deletConfirm()
{
var  displayName="<fmt:message key='u8.user.filder.person.question'/>";
return displayName;
}
function createOption(value, text){
	var option = document.createElement("option");
	option.value = value;
	option.text = text;
	return option;
}

function  savePerson()
{
	var items = document.getElementById("ListSelect").options;
	
	if(items==null||items.length==0)
	{
	   alert("<fmt:message key='u8.user.filder.title.person'/>");
	   return;
	}
    document.getElementById("submit").disabled=true;
    document.getElementById("cancel").disabled=true;
	var resultString=new StringBuffer();
	if(items != null && items.length > 0)
	{
		for(var i = 0; i < items.length; i++){
			var item = items[i];
			resultString.append(item.value+",");
	}
		document.getElementById("listSelect1").value=resultString;
	}
	document.form1.action="${u8FilderSynchron}?method=saveFilderPerson";
    document.form1.submit();
}
 if("${notFindPerson==null||notFindPerson==''||notFindPerson=='null'}")
	{
window.onload = function(){
	try{
		personFilderInit();
		personInit();
	}
	catch(e){alert(e);}
}
	}
	
		function deleteFilderPerson(ncorgCorp,pk_psndoc)
	{
          try
          {
          	var requestCaller = new XMLHttpRequestCaller(this, "ajaxU8OrgManager", "deleteFilderPerson",false);
		    requestCaller.addParameter(1, "String", ncorgCorp);
		    requestCaller.addParameter(2, "String", pk_psndoc);
		    var ds1=requestCaller.serviceRequest();
		    if(ds1 != null && (typeof ds1 == 'string'))
			{
			//alert("<fmt:message key='u8.user.filder.person.success'/>");
			}
          }catch(ex1)
          {
          alert("Exception : " + ex1);
          }
	}
</script>
	</head>
	<body scroll="no">
     
		<table width="100%" height="100%" border="0"
			cellpadding="0" cellspacing="0" class="popupTitleRight">
			<tr align="center">
				<td height="8" class="popupTitleRight">
					
				</td>
				<td align="left" class="PopupTitle">
					<fmt:message key='u8.user.filder.title.person'>
					</fmt:message>
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<c:choose>
						<c:when
							test="${notFindPerson != null&&notFindPerson!=''&&notFindPerson!='null'}">
							<c:out value="${notFindPerson}" />
						</c:when>
						<c:otherwise>
							<table border="0" width="100%" height="100%" cellspacing="0"
								cellpadding="0">
								<tr>
									<td width="35" align="center">
										&nbsp;
									</td>
									<td valign="top" width="30%" align="right" class="iframe1-">
										<select id="memberDataBody" ondblclick="doSelect()"
											multiple="multiple" style="width: 240px;" size="18">
										</select>
									</td>
									<td width="10%" align="center" valign="top">
										<br />
										<br />
										<br />
										<br />
										<br />
										<br />
										<br />
										<br />
										<p>
											<img
												src="<c:url value="/common/SelectPeople/images/arrow_a.gif"/>"
												alt="<fmt:message key='selectPeople.alt.select' bundle='${v3xMainI18N }'/>"
												width="24" height="24" class="cursor-hand"
												onClick="doSelect()">
										</p>
										<br />
										<p>
											<img
												src="<c:url value="/common/SelectPeople/images/arrow_del.gif"/>"
												alt="<fmt:message key='selectPeople.alt.unselect' bundle='${v3xMainI18N }'/>"
												width="24" height=24 class="cursor-hand"
												onClick="doremove1()">
										</p>
									</td>
									<form name="form1" action="" method="post">
										<input type="hidden" value="${param.ncOrgCorp}"
											name="ncOrgCorp" />
										<input type="hidden" value="${param.ncOrgDeptId}"
											name="ncOrgDeptId" />
									        <input type="hidden" value="" name="listSelect1" id="listSelect1"/>
									<td valign="top" width="30%" class="iframe1-">
										<select id="ListSelect" name="ListSelect"
											ondblclick="doremove1()" multiple="multiple"
											style="width: 240px" size="18">
										</select>
									</td>
									</form>
									<td width="35" align="center">
										&nbsp;
									</td>
								</tr>
							</table>
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			<c:if
				test="${notFindPerson==null||notFindPerson==''||notFindPerson=='null'}">
				<tr>
					<td colspan="2" height="20" class="bg-advance-bottom" align="right">
						<input id="submit" name="submit" type="button"
							onClick="savePerson()" class="button-default-2"
							value='<fmt:message key="common.button.ok.label" bundle="${v3xCommonI18N}" />'>
						<input id="cancel" name="close" type="button"
							onclick="parent.window.close()" class="button-default-2"
							value='<fmt:message key="common.button.cancel.label" bundle="${v3xCommonI18N}" />'>
					</td>
				</tr>
			</c:if>
		</table>

	</body>
</html>