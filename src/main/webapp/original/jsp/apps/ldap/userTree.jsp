<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="header.jsp"%>
<title><fmt:message key="ldap.user.click"  bundle="${ldaplocale}"/></title>
<base  target=_self>
</head>
<script type="text/javascript">
var dnNameArray = [];
var dnIndex = 0;

function actionRdn( index )
{
	if( dnNameArray && dnNameArray.length!=0 ){
		var cnName = "";

		var tempArray = [];
		if( dnNameArray[index].indexOf( ',OU=' )!=-1 ){
			tempArray = dnNameArray[index].split( ',OU=' );
		}else if ( dnNameArray[index].indexOf( ',ou=' )!=-1 ){
			tempArray = dnNameArray[index].split( ',ou=' );
		}

		if( tempArray && tempArray.length!=0 ){
			cnName = tempArray[ 0 ];
		}
		
		var cnNameLength = cnName.length;
		//暂时不支持的特殊符号包括：= \ ( )
		if( cnName ){
			cnName=cnName.replace( /\,/g , '\\,' );
			cnName=cnName.replace( /\+/g , '\\+' );
			cnName=cnName.replace( /\>/g , '\\>' );
			cnName=cnName.replace( /\</g , '\\<' );
		}

		var dnName = cnName + dnNameArray[index].substring( cnNameLength );
		
		document.getElementById("selectLoginName").value=dnName;
	}
}
function OK() {
  try {
	var rValue=null;
    var id_checkbox = document.getElementsByName("onlyLoginName");
    var len = id_checkbox.length;
    var checkedNum = 0;
    for (var i = 0; i < len; i++) {
      if (id_checkbox[i].checked) {
        checkedNum++;
      }
    }
    if (checkedNum > 0) {
      document.getElementById("selectLoginName").value = document.getElementById("selectLoginName").value + "::" + "check" + "::";
    }
    rValue = document.getElementById("selectLoginName").value;
    if (document.getElementById("selectLoginName").value == null || document.getElementById("selectLoginName").value == '' || document.getElementById("selectLoginName").value == 'undefind') {
    	rValue = "";
    }
    return rValue;
  } catch(e) {
    alert(e.message);
  }
}
function endProc() {
  var divE = document.getElementById("procDIV");
  if (divE) {
    divE.style.display = "none";
  }
}
function checkLoginName() {
  var onlyLoginNameE = document.getElementById("onlyLoginName");
  if ('${onlyLoginName}'=='true') {
  	if(onlyLoginNameE){
  		onlyLoginNameE.checked = true;
  	}
  }
}
</script>
<body style="overflow-x:hidden;overflow-y:auto" scroll="yes" onload="checkLoginName()">
	<script>
	var width = 240;
	var height = 100;
	
	var left = (400 - width) / 2;
	var top = (300 - height) / 2;
	    
	var str = "";
		str += '<div id="procDIV" style="position:absolute;left:'+left+'px;top:'+top+'px;width:'+width+'px;height:'+height+'px;z-index:5;border:solid 2px #DBDBDB;">';
		str += "<table width=\"100%\" height=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" bgcolor='#F6F6F6'>";
		str += "  <tr>";
		str += "    <td align='center' id='procText' height='40' valign='bottom'>"+'<fmt:message key="ldap.prompt.wait"  bundle="${ldaplocale}"/>'+"</td>";
		str += "  </tr>";
		str += "  <tr>";
		str += "    <td align='center'><span class='process'>&nbsp;</span></td>";
		str += "  </tr>";
		str += "</table>";
		str += "</div>";

	document.write(str);
	</script>


<table class="popupTitleRight" style="position:absolute;left:0;top:0;z-index:1" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr height="20">
		<td height="20" class="PopupTitle"><fmt:message key="ldap.user.click"  bundle="${ldaplocale}"/></td>
	</tr>
			
	<tr>
	<td style="padding:3px">
	<div class="scrollList">
<script type="text/javascript">
	try{
	//showProcDiv();
   //startProc('dakaizhong...');
	var root = new WebFXTree("root", "${rootDN}", "");
	root.setBehavior('classic');
	root.icon = "<c:url value='/common/images/templete.gif'/>";
	root.openIcon = "<c:url value='/common/images/templete.gif'/>";	
	
	<c:forEach items="${userList}" var="userList">
		<c:choose>
			<c:when test="${userList.type=='ou'}">
			 var ldap${fn:replace(userList.id, " ", "_")}=new WebFXTreeItem('${userList.id}','${v3x:toHTML(userList.name)}',"","");
			</c:when>
			<c:otherwise>
				dnNameArray[ dnIndex ] = "${userList.dnName}";
		        var ldap${fn:replace(userList.id, " ", "_")}=new WebFXTreeItem('${userList.id}','${v3x:toHTML(userList.name)}',"javascript:actionRdn("+dnIndex+")","","","","","${v3x:toHTML(userList.name)}");
				dnIndex++;
	    	</c:otherwise>
		</c:choose>
	</c:forEach>
	<c:forEach items="${userList}" var="userList">
		<c:choose>
			<c:when test="${userList.parentId==null}">
				root.add(ldap${fn:replace(userList.id, " ", "_")});
			</c:when>
			<c:otherwise>
				ldap${fn:replace(userList.parentId, " ", "_")}.add(ldap${fn:replace(userList.id, " ", "_")});
			</c:otherwise>
		</c:choose>		
	</c:forEach>

	    document.write(root);
	    document.close();
        endProc();
}catch(e){
	alert(e.name+" "+e.message);
	endProc();
}
</script>
	</div>
	</td>
	</tr>
		
<tr>
<td class="bg-advance-bottom" style="padding: 0px;" >
<table width="100%" height="100%">
<tr>
<td align="left"><input type="hidden" name="selectLoginName" value="" id="selectLoginName"><label for="onlyLoginName"><input type="checkbox" id="onlyLoginName" name="onlyLoginName" value="0"><fmt:message key="ldap.lable.checkbox"  bundle="${ldaplocale}"/></label></td>
<%-- <td align="right"><input type="button" name="b1" onclick="submitform()"value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;
<input id="submintCancel" type="button" onclick="window.close()" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2"></td> --%>
</tr>
</table>
</td>
</tr>
</table>
</body>
</html>
