<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<title>${ctp:i18n("ldap.user.click")}</title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/xtree/xtree.js${v3x:resSuffix()}"/>"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/xtree/xloadtree.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/xmlextras.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" src="/seeyon/ajax.do?managerName=ldapBindingMgr"></script>
<link rel="STYLESHEET" type="text/css" href="<c:url value="/apps_res/form/css/form.css${v3x:resSuffix()}" />">    
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/hr/css/default.css${v3x:resSuffix()}" />">
<link type="text/css" rel="stylesheet" href="<c:url value="/common/js/xtree/xtree.css${v3x:resSuffix()}" />">
${v3x:skin()}
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />">
</head>
<script type="text/javascript">
function actionRdn(name,dnName)
{
	document.getElementById("selectLoginName").value="";	
	if(dnName!=null && dnName!="" && (dnName.indexOf("cn")==0 || dnName.indexOf("CN")==0)){
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

function checkLoginName() {
  var onlyLoginNameE = document.getElementById("onlyLoginName");
  if ('${onlyLoginName}'=='true') {
  	if(onlyLoginNameE){
  		onlyLoginNameE.checked = true;
  	}
  }
}

function searchUser(key){
	document.getElementById("selectLoginName").value="";
	if(key!=null && key!=""){
		$("#userListDiv").children('div').remove();
		$("#userTree").hide();
		$("#searchUserList").show();
		var currentAccountDN = "${currentAccountDN}";
		var rootDN = "${rootDN}";
 		var ldapManager = new ldapBindingMgr();
		var searchUserList = ldapManager.getSearchCn(currentAccountDN,key); 
		var rootHtml = "<div class=\"webfx-tree-item\"><img src=\"/seeyon/common/js/xtree/images/openfoldericon.png\"><a>"+currentAccountDN+"</a></div>"
		var userHtml = "";
		for(i=0;i<searchUserList.length;i++){
			var id = searchUserList[i].id;
			var name = searchUserList[i].name;
			var dnName = searchUserList[i].dnName;
			var showDnName = (dnName.split(","+rootDN))[0];
			
			userHtml = userHtml+ "<div class=\"webfx-tree-container\" id=\"webfx-tree-object-4-cont\" style=\"display: block;\">"
			+"<div class=\"webfx-tree-item\"><img src=\"/seeyon/apps_res/doc/images/docIcon/person.gif\">"
			+"<a onclick=\"javascript:actionRdn('"+name+"','"+showDnName+"')\"" 
			+" href=\"###\">"+showDnName+"</a></div></div>";
		}
	
	    var listHtml=rootHtml+userHtml;
	    $("#userListDiv").html(listHtml);
		$("#searchUserList").show();
	}else{
		$("#userTree").show();
		$("#searchUserList").hide();
	}
}
</script>
<body style="overflow-x:hidden;overflow-y:auto" scroll="yes" onload="checkLoginName()">
<table class="popupTitleRight" style="position:absolute;left:0;top:0;z-index:1" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr height="10">
		<td height="10"  width="20%" class="PopupTitle" style="line-height:20px;height:20px;">${ctp:i18n("ldap.user.click")}</td>
	</tr>
	
	<tr height="10">
		<td height="10"  width="30%" class="PopupTitle" style="line-height:20px;height:20px;">
			<input type="text" id="searchUser" name="searchUser" class="validate"/>
			<a id="btnsearch" class="common_button common_button_gray" href="javascript:searchUser(document.getElementById('searchUser').value);">用户查找</a>
		</td>
	</tr>
		
		
	<!-- 用户树，用于显示全部  -->	
	<tr id="userTree">
	<td style="padding:3px">
	<div class="scrollList">
<script type="text/javascript">
	try{
		var root = new WebFXTree();
		root.text = "${currentAccountDN}";
		<c:forEach items="${userList}" var="root">
			var name = "${v3x:toHTML(root.name)}";
			if(name.indexOf("ou")==0 || name.indexOf("OU")==0){
				 var tree_${root.id} = new WebFXLoadTreeItem("${root.id}", "${v3x:toHTML(root.name)}", null, null, null, null, "<c:url value='/apps_res/doc/images/docIcon/folder_open.gif'/>", "<c:url value='/apps_res/doc/images/docIcon/folder_open.gif'/>");	
				 tree_${root.id}.src = encodeURI("<c:url value='/ldap/ldap.do?method=getSubNode&parentDn=${v3x:toHTML(root.dnName)}&parentId=${root.id}&type=ou'/>");
			}else{
		   		 var tree_${root.id} = new WebFXLoadTreeItem("${root.id}", "${v3x:toHTML(root.name)}", null, null, null, null, "<c:url value='/apps_res/doc/images/docIcon/person.gif'/>", "<c:url value='/apps_res/doc/images/docIcon/person.gif'/>");	
		   		 tree_${root.id}.src = encodeURI("<c:url value='/ldap/ldap.do?method=getSubNode&parentDn=${v3x:toHTML(root.dnName)}&parentId=${root.id}&type=cn'/>");
			}
		   	tree_${root.id}.action = "javascript:actionRdn('${v3x:toHTML(root.name)}','${v3x:toHTML(root.dnName)}')";
			root.add(tree_${root.id});			
		</c:forEach>
		document.write(root);
}catch(e){
	alert(e.name+" "+e.message);
}
</script>
	</div>
	</td>
	</tr>
	
	<!-- 树列表，用于显示查询结果  -->
	<tr id=searchUserList hidden="true">
	<td style="padding:3px" id=searchUserListTd>
	<div class="scrollList" id="userListDiv">
	<!--动态添加搜索结果  -->
	</div>
	</div>
	</td>
	</tr>
		
<tr>
<td class="bg-advance-bottom" style="padding: 0px;" >
<table width="100%" height="100%">
<tr>
<td align="left"><input type="hidden" name="selectLoginName" value="" id="selectLoginName"><label for="onlyLoginName"><input type="checkbox" id="onlyLoginName" name="onlyLoginName" value="0">${ctp:i18n("ldap.lable.checkbox")}</label></td>
</tr>
</table>
</td>
</tr>
</table>
</body>
</html>
