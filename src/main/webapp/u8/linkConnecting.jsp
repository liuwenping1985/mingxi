<%@ page isELIgnored="false"%>
<%@ page import="com.seeyon.ctp.portal.po.*"%>
<%@ page import="com.seeyon.ctp.common.authenticate.domain.*"%>
<%@ page import="com.seeyon.ctp.util.*"%>
<%@ page import="com.seeyon.ctp.common.*"%>
<%@ page import="com.seeyon.ctp.organization.bo.*"%>
<%@ page import="java.util.*"%>

<%@ page import="com.seeyon.apps.u8login.po.*"%>
<%@ page import="com.seeyon.ctp.organization.manager.*"%>

<%
response.setHeader("Pragma", "No-cache");
response.setHeader("Cache-Control", "no-store");
response.setDateHeader("Expires", -1);
PortalLinkSystem ls = (PortalLinkSystem) request.getAttribute("link");
response.addHeader("X-XSS-Protection","0");
response.setContentType("text/html;charset=" + ls.getTargetCharset());
%>

<%

String u8UserName = "";
String u8Password = "";
Long id = AppContext.getCurrentUser().getId();

OrgManager orgManager = (OrgManager)AppContext.getBean("orgManager");
  V3xOrgMember member=orgManager.getMemberById(id);

if(member!=null){
	u8UserName = member.getCode();
}
if(!"".equals(u8UserName)){
	 List<MemberU8Info> infos = DBAgent.find("from MemberU8Info where userCode='"+u8UserName+"'");
	 if(infos!=null&&infos.size()>0){
			 u8Password = infos.get(0).getPassword();
	 }
}


%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>

<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=<%=ls.getTargetCharset()%>">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache"> 
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache"> 
<META HTTP-EQUIV="Expires" CONTENT="-1">
</head>
<script type="text/javascript">
var contpath = "${pageContext.request.contextPath}";
var _linkURL='${linkURL}';
var v3x = new V3X();
v3x.init("${pageContext.request.contextPath}", "${v3x:getLanguage(pageContext.request)}");
_ = v3x.getMessage;
v3x.loadLanguage("/apps_res/link/i18n");
if('false' == '${dataExist}'){	
   alert(v3x.getMessage("LinkLang.link_has_been_deleted"));
   window.close();
}
</script>

<body>
 <form action="${link.url}" method="${link.method}" id="theForm" name="theForm" accept-charset="${link.targetCharset}" >
	<c:forEach var="vo" items="${optionVos}">
		<input type="hidden" value="<c:out value='${vo.value.value}' escapeXml='true' />" 

id="${vo.option.paramSign}" name="${vo.option.paramSign}" />
	</c:forEach>
</form>
<c:set var="targetUrl" value="${linkSpaceOrSectionVO == null? link.url:linkSpaceOrSectionVO['targetPageUrl']}"></c:set>
<c:if test="${ fn:length(fn:trim(link.agentUrl)) > 0 }">
<%-- 向SSOPROXY发送请求 --%>
<form action="${link.agentUrl}" method="POST" id="targetForm" name="targetForm"  >
	<input type="hidden" value="${targetUrl}" id="targetUrl" name="targetUrl" />
	<input type="hidden" value="${link.url}" id="ssoUrl" name="ssoUrl" />
	<c:forEach var="vo" items="${optionVos}">
        <input type="hidden" value="<c:out value='${vo.value.value}' escapeXml='true' />" id="${vo.option.paramSign}" 

name="${vo.option.paramSign}" />
    </c:forEach>
	<input type="hidden" value="<c:out value='${contentForCheck}' escapeXml='true' />" id="content4Check" 

name="content4Check" />
	<input type="hidden" value="<c:out value='${link.targetCharset}' escapeXml='true' />" id="targetCharset" 

name="targetCharset" />
	<input type="hidden" value="${link.method}" id="ssoLoginMethod" name="ssoLoginMethod" />
	<input type="hidden" value="${wrongConfigPrompt}" id="wrongConfigPrompt" name="wrongConfigPrompt" />
	<input type="hidden" value="${longPrompt}" id="longPrompt" name="longPrompt" />
</form>
</c:if>

<script type="text/javascript">
    var _theForm = document.getElementById("theForm");
	var targetForm = document.getElementById("targetForm");
	var u8UserName = '<%=u8UserName %>';
	var u8Password = '<%=u8Password %>';
	if(_theForm){
	  if($.trim("${contentForCheck}") != ""){
	    //如果需要内容检查
		if(${ fn:length(fn:trim(link.agentUrl)) } > 0){
		  //如果不在同一个域
		  targetForm.submit();
		} else {
		  _theForm.action = "${targetUrl}";
		  if("${target}" == "mainFrame"){
		    theForm.target = parent.main;
		  }
		  if("${link.method}" == "get"){
			  if(${fn:length(optionVos)} > 0){
		          self.location.href = '${targetUrl}?<c:forEach var="vo" items="${optionVos}" varStatus="status">

${vo.option.paramSign}=${vo.value.value}<c:if test="${!status.last}">&</c:if></c:forEach>';
		      } else {
		          self.location.href = '${targetUrl}';
		      }
		  } else {
		    theForm.submit();
		  }
		}
	  } else {
        //直接访问目标页面
	    _theForm.action = "${targetUrl}";
	    if("${target}" == "mainFrame"){
	      theForm.target = parent.main;
	    }
	    if("${link.method}" == "get"){
	    	if(${fn:length(optionVos)} > 0){
	    			self.location.href = '${targetUrl}?<c:forEach var="vo" items="${optionVos}" 

varStatus="status">${vo.option.paramSign}=${vo.value.value}<c:if test="${!status.last}">&</c:if></c:forEach>';
	        } else {
				
							if('${targetUrl}'.indexOf("ygsy")>-1){
					
								self.location.href = 

'http://account.mfcteda.com:2008/Default.ashx?UserID='+u8UserName+'&Password='+u8Password+'&PageKey=ygsy'
							}else if('${targetUrl}'.indexOf("jlsy")>-1){
						
								self.location.href = 

'http://account.mfcteda.com:2008/Default.ashx?UserID='+u8UserName+'&Password='+u8Password+'&PageKey=jlsy'
							}else if('${targetUrl}'.indexOf("kqcx")>-1){
						
								self.location.href = 

'http://account.mfcteda.com:2008/Default.ashx?UserID='+u8UserName+'&Password='+u8Password+'&PageKey=kqcx'
							}else if('${targetUrl}'.indexOf("kqsq")>-1){
						
								self.location.href = 

'http://account.mfcteda.com:2008/Default.ashx?UserID='+u8UserName+'&Password='+u8Password+'&PageKey=kqsq'
							}else if('${targetUrl}'.indexOf("bxsq")>-1){
							
								self.location.href = 

'http://account.mfcteda.com:2008/Default.ashx?UserID='+u8UserName+'&Password='+u8Password+'&PageKey=bxsq'
							}else if('${targetUrl}'.indexOf("bxcx")>-1){
							
								self.location.href = 

'http://account.mfcteda.com:2008/Default.ashx?UserID='+u8UserName+'&Password='+u8Password+'&PageKey=bxcx'
							}else{
								self.location.href = '${targetUrl}';
							}
	           
	        }
	    } else {
	      theForm.submit();
	    }
	  }
	}	
</script>

</body>
</html>