<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="logHeader.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>    
<title>Insert title here</title>
<script type="text/javascript">
showCtpLocation('F13_loginLog');
var flag=true;
function export2Excel(){
  var formObj = document.getElementById("form1") ;
  if(formObj){
    var ip1 = document.getElementById("ip1").value;
    var ip2 = document.getElementById("ip2").value;
    var ip3 = document.getElementById("ip3").value;
    var ip4 = document.getElementById("ip4").value;
    var or = ip1 != "" || ip2 != "" || ip3 != "" || ip4 != "";
    if(or==true){
        var and = ip1 != "" && ip2 != "" && ip3 != "" && ip4 != "";
        if(and == true)
            document.getElementById("ipAddress").value = ip1 + "." + ip2 + "." + ip3 + "." + ip4;
        else{
            alert(v3x.getMessage("LogLang.logon_alertIP"));
            return;
        }
    }
    formObj.target = "targetFrame";
  	formObj.isExprotExcel.value = "true";
  	
  	formObj.submit();
  }
}

function selectDateTime(whoClick){
    var date = whoClick.value;
    var newDate = new Date();
    var strDate = newDate.getFullYear()+"-"+(newDate.getMonth()+1)+"-"+newDate.getDate();
    
    strDate = formatDate(strDate);
    if(whoClick.name=='startDay'){
      if(document.getElementById('endDay').value!="" && date!="" &&
        date>document.getElementById('endDay').value){
        alert("开始时间不能晚于结束时间");
        whoClick.value="";
      } else if(strDate<date){
          alert("开始时间不能晚于当前时间");
          whoClick.value="";
        }
    }
    if(whoClick.name=='endDay'){
      if(document.getElementById('startDay').value!="" &&  date!="" &&
        date<document.getElementById('startDay').value){
        alert("结束日期不能早于开始日期");
        whoClick.value="";
      }
      else if(strDate<date){
        alert("结束时间不能晚于当前时间");
        whoClick.value="";
      }
    }   
}
function checkIp(ips){
    var values = ips.value;

    if(values==""){
        
        flag=true;
        return ;
    }

    if(cheekNum(values)){
        
        cheekLast(values);
    }
   
}
function cheekNum(values){
    var nums= parseInt(values);
        if(isNaN(values)){
            alert('ip只能输入数字');
         
            flag=false;
        }else if(values.indexOf('.')>0){
                alert('ip只能输入整数');
            
                flag=false;
        
        }else{
            flag=true;
        }
        return flag;
}
function cheekLast(values){
    var nums= parseInt(values);
    if(nums<0||nums>255){
        alert('ip只能在0-255之前');
     
        flag=false;
    }else{
        flag=true;
    }
}
function subs(){
	var endDay = document.getElementById('endDay').value;
	var startDay = document.getElementById('startDay').value;
	if (startDay == '') {
		alert('开始时间不能为空');
		return ;
	}
	if (endDay == '') {
		alert('结束时间不能为空');
		return ;
	}
    checkIp(document.getElementById('ip1'));
    checkIp(document.getElementById('ip2'));
    checkIp(document.getElementById('ip3'));
    checkIp(document.getElementById('ip4'));
    if(flag){
    doDetailSearch();
    }else{
       
    }
}
</script>
</head>
<body scroll="no" class="padding5" topmargin="0" leftmargin="0">
<c:if test="${isShowTab eq 'true'}">
<%@include file="labelPage.jsp"%>
</c:if>
<tr>
	<td height="40" style="border-bottom: solid 1px #ccc; background:#fff;">
		<script>	
			var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />", "gray");
			myBar.add(new WebFXMenuButton("exportExcel", "<fmt:message key='common.toolbar.exportExcel.label' bundle='${v3xCommonI18N}' />", "export2Excel()", [2,6], "", null));
			myBar.add(new WebFXMenuButton("print", "<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' />", "javascript:doPrint()", [1,8], "", null));
			<c:if test="${isShowDelete eq 'true'}">
				myBar.add(new WebFXMenuButton("delete", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "javascript:clearLogs('LogonLog')", [1,3], "", null));
			</c:if>
			document.write(myBar);
			document.close();
		</script>
	</td>
</tr>
<tr>
	<td class="page-list-border-LRD" style="padding-top:6px">
		<!-- TR 条件 -->
		<form method="post" id="form1" action="${logonLog}?method=detailSearch">
		<c:set value="${v3x:parseElementsOfTypeAndId(param.users)}" var="userIds" />
		<v3x:selectPeople id="user" panels="Department,Outworker,Admin" selectType="Member,Admin" minSize="0" originalElements="${userIds}" jsFunction="showUser(elements,'${systemFlag }')" />
		<input type="hidden" name="users" id="users" value="${param.users }" />
		<input type="hidden" name="ipAddress" id="ipAddress">
		<input type="hidden" name="isExprotExcel" id="isExprotExcel" value="">
		<table>
			<tr>
				<td width="100" rowspan="3" align="right"><b><fmt:message key="logon.templete.branch.search.label" />:</b></td>
				<td width="100" align="right"><fmt:message key="logon.search.selectPeople"/>:</td>
				<td width="280"><input type="text" id="userName" name="userName" class="input-100per cursor-hand" value="${v3x:showOrgEntitiesOfTypeAndId(param.users,pageContext)}" onclick="selectPeopleFun_user()" readonly="readonly"></td>
				<td rowspan="3" class="padding-L">
				<input type="button" value="<fmt:message key="common.button.ok.label" bundle="${v3xCommonI18N}"/>" class="button-default-2" onclick="subs()"></td>				
			</tr>
			<tr>
				<td align="right"><fmt:message key="logon.search.ip"/>:</td>
				<td><b><input type="text" size="4" maxlength="3" name="ip1" id="ip1" value="${param.ip1 }" >.<input type="text" size="4" maxlength="3" name="ip2" id="ip2" value="${param.ip2 }" >.<input type="text" size="4" maxlength="3" name="ip3" id="ip3" value="${param.ip3 }" >.<input type="text" size="4" maxlength="3" name="ip4" id="ip4" value="${param.ip4 }"></b>
			</tr>
			<tr>		
				<td align="right"><fmt:message key="logon.search.selectTime"/>:</td>
				<td width="500"><input type="text" class="cursor-hand" name="startDay" id="startDay" value="${startDay}" onpropertychange="selectDateTime(this);"  onclick="whenstart('${pageContext.request.contextPath}',this,400,200, null, false);" readonly="true"> <fmt:message key="logon.search.to"/> 
                <input type="text" class="cursor-hand" name="endDay" id="endDay" value="${endDay}" onpropertychange="selectDateTime(this);" onclick="whenstart('${pageContext.request.contextPath}',this,400,200, null, false);" readonly="true">
				<span class="description-lable"><fmt:message key="logon.member.delete" /></span>
				</td>
			</tr>
		</table>
		</form>
		</td>
		</tr>
		<tr>
			<td class="page-list-border-LRD" height="100%" valign="top">
				<div class="scrollList" id="dataList">
				<form>
				<fmt:message key="message.online.loginType" var="loginTypeTitle" bundle="${v3xMainI18N}" />
		<v3x:table data="${detail}" var="result" htmlId="aaa" isChangeTRColor="true" showHeader="true" showPager="true"  pageSize="20" subHeight="135" formMethod="post">
		  <v3x:column width="10%" label="logon.stat.person" maxLength="40" type="String" >
		  <c:set var="logMember" value="${v3x:getOrgEntity('Member', result.memberId) }"/>
		<c:choose>
			<c:when test="${logMember == null }">
				${v3x:showMemberNameOnly(result.memberId)}
			</c:when>
			<c:when test="${logMember.isDeleted}">
				<font color="gray"><s>${logMember.name}</s></font>
			</c:when>
			<c:otherwise>
				${v3x:showMemberNameOnly(result.memberId)}
			</c:otherwise>
		</c:choose>
		  <c:set var="onlineModel" value="${v3x:getOnlineUser(result.memberId) }"/>
		  <c:set var="onlineTime" value="${result.onlineTime}"/>
		  <fmt:formatDate value='${result.logoutTime}' type='both' dateStyle='full' pattern='yyyy-MM-dd HH:mm' var="logoutTime"/>
		  <c:set var="loginMessage" value="${v3x:_(pageContext,result.logoutType==0?'logon.search.logoutNoError':'logon.search.logoutWithError')}"/>
		  <c:if test="${onlineModel != null }">
		  	<c:if test="${((result.logonTime.time/1000 - onlineModel.lastLoginTime.time/1000)<1 && (result.logonTime.time/1000 - onlineModel.lastLoginTime.time/1000>0)) || ((result.logonTime.time/1000 - onlineModel.lastLoginTime.time/1000>-1) && (result.logonTime.time/1000 - onlineModel.lastLoginTime.time/1000<0))}">
	  			<c:set var="loginMessage" value="${v3x:_(pageContext,'logon.search.online')}"/>
	  			<c:set var="onlineTimeTemp" value="${(now.time - result.logonTime.time)/(1000*60)}"/>
	  			<c:set var="onlineTime" value="${fn:substring(onlineTimeTemp,0,fn:indexOf(onlineTimeTemp,'.'))}"/>
				<c:set var="logoutTime" value="--"/>
		  	</c:if>
		  </c:if>
		  </v3x:column>
		  <c:if test="${v3x:getSysFlagByName('sys_isGroupVer')=='true'}">
		  <c:set value="${v3x:getAccount(result.accountId)}" var="account"/>
		  <v3x:column width="15%" label="log.toolbar.title.account" maxLength="40" type="String" value="${account != null && account.id != v3x:getGroup().id ? account.shortName: '-'}" />
		  </c:if>
		  
		  <v3x:column width="10%" label="logon.org.post" type="String" maxLength="40" value="${v3x:showOrgPostNameByMemberid(result.memberId==null?0:result.memberId) }" /> 
		  
		  <fmt:formatDate value='${result.logonTime}' type='both' dateStyle='full' pattern='yyyy-MM-dd HH:mm' var="logonTime"/>
		  <v3x:column width="14%" label="logon.search.logonTime" type="Date" maxLength="40" value="${logonTime }" />
		  <v3x:column width="14%" label="logon.search.logoutTime" type="Date" maxLength="40" value="${logoutTime }" />
		  <v3x:column width="10%" label="logon.search.onlineTime" type="Srting" maxLength="40" value="${fn:substring((onlineTime / 60),0,fn:indexOf((onlineTime / 60),'.')) }小时${onlineTime % 60 }分" />
		  <v3x:column width="10%" label="logon.search.ip" type="String" maxLength="20" value="${result.ipAddress }" />
		  <v3x:column width="8%" label="${loginTypeTitle}" type="String">
		  	<fmt:message key='online.loginType.${result.loginType}' bundle="${v3xMainI18N}"/>
		  </v3x:column>
		  <v3x:column width="10%" label="logon.search.remark" type="String" maxLength="40" value="${loginMessage}" />
		</v3x:table>
				</form>
				</div>
			</td>
		</tr>
</table>
<iframe id="targetFrame" name="targetFrame" width="0" height="0"></iframe>
</body>
</html>