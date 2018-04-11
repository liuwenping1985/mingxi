<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="logHeader.jsp" %>
<title>Insert title here</title>
<script type="text/javascript">
showCtpLocation("F13_loginLog");
</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<style>
.main_div_row2 {
 width: 100%;
 height: 100%;
 _padding-left:0px;
}
.right_div_row2 {
 width: 100%;
 height: 100%;
 _padding:150px 0px 0px 0px;
}
.main_div_row2>.right_div_row2 {
 width:auto;
 position:absolute;
 left:0px;
 right:0px;
}
.center_div_row2 {
 width: 100%;
 height: 100%;
 /*background-color:#00CCFF;*/
 overflow:auto;
}
.right_div_row2>.center_div_row2 {
 height:auto;
 position:absolute;
 top:150px;
 bottom:0px;
}
.top_div_row2 {
 height:150px;
 width:100%;
 /*background-color:#9933FF;*/
 position:absolute;
 top:0px;
}
</style>
<script type="text/javascript">
function checkIp(ips){
    var values = ips.value;

    if(values==""){
        return true;
    }

    if(cheekNum(values)){
        if (!cheekLast(values)) {
        	return false;
        } else {
        	return true;
        }
    } else {
    	return false;
    }
   
}
function cheekNum(values){
	var flag=true;
    var nums= parseInt(values);
        if(isNaN(values)){
            flag=false;
        }else if(values.indexOf('.')>0){            
            flag=false;
        }else{
            flag=true;
        }
        return flag;
}
function cheekLast(values){
	var le = values.length; 
	if (le > 3) {
		return false;
	}
    var nums= parseInt(values);
    if (le == 3) {
    	if (nums < 100) {
    		return false;
    	}
    }
    if (le == 2) {
    	if (nums < 10) {
    		return false;
    	}
    }

    if(nums<0||nums>255){     
        return false;
    }else{
        return true;
    }
}	
function subForm(){
    if (checkIp(document.getElementById('ip1')) && checkIp(document.getElementById('ip2')) &&  checkIp(document.getElementById('ip3')) && checkIp(document.getElementById('ip4'))) {
    	  doDetailSearch();
   	} else {
   		 alert('ip输入不合法!');
   	}
}

</script>
</head>
<body scroll="no">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="main-bg">
			<tr>
				<td height="20" class="webfx-menu-bar" colspan="2">	
				<script type="text/javascript">
					var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
			    	myBar.add(new WebFXMenuButton("exportExcel", "<fmt:message key='common.toolbar.exportExcel.label' bundle='${v3xCommonI18N}' />", "javascript:exportExcel('LogonLog')", [2,6], "", null));
			    	myBar.add(new WebFXMenuButton("print", "<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' />", "javascript:doPrint()", [1,8], "", null));
			    	myBar.add(new WebFXMenuButton("delete", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "javascript:clearLogs('LogonLog')", [1,3], "", null));
			    	document.write(myBar);
			    	document.close();
			    </script>
				</td>
			</tr>
			<tr>
			  <td class="border-top">
			  <form method="post" id="form1" action="${logonLog}?method=detailSearch&from=audit">
				<c:set value="${v3x:parseElementsOfTypeAndId(param.users)}" var="userIds" />
				<v3x:selectPeople id="user" panels="Department,Outworker,Admin" selectType="Member,Admin" minSize="0" originalElements="${userIds}" jsFunction="showUser(elements,'${systemFlag }')" />
				<input type="hidden" name="users" id="users" value="${param.users }" />
				<input type="hidden" name="ipAddress" id="ipAddress">
				<input type="hidden" name="isExprotExcel" id="isExprotExcel" value="">
				<table>
					<tr>
						<td width="100" align="right"><fmt:message key="logon.search.selectPeople"/>:</td>
						<td width="280"><input type="text" id="userName" name="userName" class="input-100per cursor-hand" value="${v3x:showOrgEntitiesOfTypeAndId(param.users,pageContext)}" onclick="selectPeopleFun_user()" readonly="readonly"></td>
						<td width="100"></td>				
					</tr>
					<tr>
						<td align="right"><fmt:message key="logon.search.ip"/>:</td>
						<td><b><input type="text" size="4" maxlength="3" name="ip1" id="ip1" value="${param.ip1 }">.<input type="text" size="4" maxlength="3" name="ip2" id="ip2" value="${param.ip2 }">.<input type="text" size="4" maxlength="3" name="ip3" id="ip3" value="${param.ip3 }">.<input type="text" size="4" maxlength="3" name="ip4" id="ip4" value="${param.ip4 }"></b>
						<td>&nbsp;</td>
					</tr>
					<tr>		
						<td align="right"><fmt:message key="logon.search.selectTime"/>:</td>
						<td><input type="text" size="15" class="cursor-hand" name="startDay" id="startDay" value="${startDay}" onclick="whenstart('${pageContext.request.contextPath}',this,400,200, null, false);" readonly="true"> <fmt:message key="logon.search.to"/> 
                        <input type="text" size="15" class="cursor-hand" name="endDay" id="endDay" value="${endDay }" onclick="whenstart('${pageContext.request.contextPath}',this,400,200, null, false);" readonly="true">
                        </td>
						<td class="border-padding"><input type="button" value="<fmt:message key="common.button.ok.label" bundle="${v3xCommonI18N}"/>" class="button-default-2" onclick="subForm()"></td>
					</tr>
				</table>
				</form>
			  </td>
			</tr>
			<tr height="20">
				<td class="border-padding border-top" id="searchTitle">
					<fmt:message key="common.system.login.label" bundle="${v3xCommonI18N}" />
				</td>
			</tr>
		</table>
    </div>
    <div class="center_div_row2" id="scrollListDiv">
		<form>
		    <fmt:message key="message.online.loginType" var="loginTypeTitle" bundle="${v3xMainI18N}" />
			<v3x:table data="${detail}" var="result" htmlId="dateList" isChangeTRColor="true" showHeader="true" showPager="true"  pageSize="20" className="sort ellipsis">
			  <v3x:column width="10%" label="logon.stat.person" maxLength="40" type="String" value="${v3x:showMemberNameOnly(result.memberId)}" >
			  <c:set var="logMember" value="${v3x:getOrgEntity('Member', result.memberId) }"/>
			<c:choose>
				<c:when test="${logMember == null }">
				${v3x:showMemberNameOnly(result.memberId)}
				</c:when>
				<c:when test="${logMember.isDeleted}">
					<font color="gray"><s>${logMember.name}</s></font>
				</c:when>
				<c:otherwise>
					${logMember.name}
				</c:otherwise>
			</c:choose>
			  </v3x:column>
			  <c:if test="${v3x:getSysFlagByName('sys_isGroupVer')=='true'}">
			  <c:set value="${v3x:getAccount(result.accountId)}" var="account"/>
			  <v3x:column width="10%" label="log.toolbar.title.account" maxLength="40" type="String" value="${account != null && account.id != v3x:getGroup().id ? account.shortName: '-'}" />
			  </c:if>
			  
			  <v3x:column width="10%" label="logon.org.post"  type="String" maxLength="40" value="${v3x:showOrgPostNameByMemberid(result.memberId) }" /> 
			  
			  <fmt:formatDate value='${result.logonTime}' type='both' dateStyle='full' pattern='yyyy-MM-dd HH:mm' var="logonTime"/>
			  <v3x:column width="13%" label="logon.search.logonTime" type="Date" maxLength="40" value="${logonTime }" />
			  <fmt:formatDate value='${result.logoutTime}' type='both' dateStyle='full' pattern='yyyy-MM-dd HH:mm' var="logoutTime"/>
			  <v3x:column width="15%" label="logon.search.logoutTime" type="Date" maxLength="40" value="${result.logoutType == 1 ? '' : logoutTime}" />
			  <v3x:column width="10%" label="logon.search.onlineTime" type="Srting" maxLength="40" value="${fn:substring((result.onlineTime / 60),0,fn:indexOf((result.onlineTime / 60),'.')) }小时${result.onlineTime % 60 }分" />
			  <v3x:column width="10%" label="logon.search.ip" type="String" maxLength="20" value="${result.ipAddress }" />
			  <v3x:column width="10%" label="${loginTypeTitle}" type="String">
			  	<fmt:message key='online.loginType.${result.loginType}' bundle="${v3xMainI18N}" />
			  </v3x:column>
			  <v3x:column width="10%" label="logon.search.remark" type="String" maxLength="40">
			  	<c:choose>
			  		<c:when test="${result.logoutType == 1}">${v3x:_(pageContext,'logon.search.online')}</c:when>
			  		<c:when test="${result.logoutType == 0}">${v3x:_(pageContext,'logon.search.logoutNoError')}</c:when>
			  		<c:otherwise>${v3x:_(pageContext,'logon.search.logoutWithError')}</c:otherwise>
			  	</c:choose>
			  </v3x:column>
			</v3x:table>
		</form>
		<iframe name="HiddenFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
    </div>
  </div>
</div>
</body>
</html>
<script>
function doPrint(type){
	var printObj = document.getElementById("scrollListDiv");
	var cssList = new ArrayList();
	cssList.add(v3x.baseURL + "/common/css/default.css");
	cssList.add(v3x.baseURL + "/common/skin/default/skin.css");
	var pl = new ArrayList();
	if(printObj){
		var html = printObj.innerHTML;
		html = html.replace(/like-a/gi,"").replace(/openList\S*\)/gi,"");
		var printObjFrag = new PrintFragment("", html);
		pl.add(printObjFrag);
		printList(pl,cssList);
	}
}
</script>