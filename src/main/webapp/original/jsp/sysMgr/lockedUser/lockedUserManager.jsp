<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@page import="java.util.Properties"%>
<title>锁定用户列表</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<script type="text/javascript">
getA8Top().showCtpLocation("F13_sysLockedUser");
	//定义删除方法
	function removeLuck(){
		var ids= document.getElementsByName('id');
		
		var id='';
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				id=id+idCheckBox.value+',';
			}
		}
	
		if(id==null || id == ""){
			alert(v3x.getMessage("sysMgrLang.system_post_delete"));
			return;
		}
		
		id = id.substring(0,id.length-1);
			
		if(!confirm(_("sysMgrLang.system_locked_user_delete",id))){
			return;
		}
		document.location.href ="${lockedUserManagerURL}?method=destroy&ids="+encodeURIComponent(id)+"";
	}
	
	/**
	 * 搜索按钮事件
	 */
	function doSearch2() {
		document.location.href="${lockedUserManagerURL}?method=listLockedUsers&textfield="+document.getElementById('loginNametextfield').value;
	}
	
	/**
	 * 点击锁定	
	 */
	function selectedValue(obj){
		obj.select();
	}

</script>
</head>
<body scroll="no">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
<table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0" class="">
    <!-- 加载菜单 -->
    <tr>
        <td height="22"  id="toolbar-top-border"  class="webfx-menu-bar border_b" ><script type="text/javascript">    
            var _mode = parent.parent.WebFXMenuBar_mode || 'blue'; 
            var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}'/>",_mode);
            myBar.add(new WebFXMenuButton("del","<fmt:message key="common.toolbar.unlock.label" bundle='${v3xCommonI18N}'/>","removeLuck()",[1,3],"delete", null));
            document.write(myBar);
            document.close();
            </script>
        </td>
          <td id="grayTd" class="webfx-menu-bar border_b" ><form action="" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
            <div class="div-float-right">
                <div class="div-float">
                    <fmt:message key="lockUser.query.loginName.label" bundle="${v3xMainI18N }"/>:
                </div>
                <div id="loginNameDiv" class="div-float">
                    <input type="text" name="textfield" id="loginNametextfield" class="textfield-search" value="${textfield}" onfocus="javascript:selectedValue(this)" onkeydown="javascript:if(event.keyCode==13) doSearch2();">
                </div>                  
                <div id="grayButton" onclick="javascript:doSearch2()" class="condition-search-button"></div>
            </div></form>
        </td>
    </tr>
    </table>
    </div>
    <div class="center_div_row2" id="scrollListDiv">
    <form id="lockedUserform" method="post">
        <v3x:table htmlId="LockedUserlist" data="lockedLoginInfoList" var="lockedLoginInfo" >
            <v3x:column width="5%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
                <input type="checkbox" name="id" value="${lockedLoginInfo.loginName}">
            </v3x:column>
            <v3x:column width="20%" label="sysMgr.lockedUser.LoginName.label" type="String"
                value="${lockedLoginInfo.loginName}" className="cursor-hand sort" 
                maxLength="17"  symbol="..." alt="${lockedLoginInfo.loginName}" onClick="${click}" onDblClick="${dbclick }"/>
            <v3x:column width="30%" label="sysMgr.lockedUser.ip.label" type="String"
                value="${lockedLoginInfo.ip}" className="cursor-hand sort" 
                maxLength="17"  symbol="..." alt="${lockedLoginInfo.ip}" onClick="${click}" onDblClick="${dbclick }"/>
            <v3x:column width="30%"  label="sysMgr.lockedUser.lockedTime.label" type="Date" 
            className="cursor-hand sort"   onClick="${click}" onDblClick="${dbclick }">
            <fmt:formatDate value="${lockedLoginInfo.lockTimestamp}" pattern="${datetimePattern}" />
            </v3x:column>               
            <v3x:column width="15%" label="sysMgr.lockedUser.loginCount.label" type="String"
                value="${lockedLoginInfo.count}" className="cursor-hand sort"
                maxLength="20"  symbol="..." alt="${lockedLoginInfo.count}" onClick="${click}" onDblClick="${dbclick }"/>
        </v3x:table>
        </form>
    </div>
  </div>
</div>
</body>
</html>