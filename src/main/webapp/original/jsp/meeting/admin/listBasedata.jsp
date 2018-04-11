<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
function changeMenuTab(clickDiv) {
	var menuDiv=document.getElementById("menuTabDiv");
  	var clickDivStyle=clickDiv.className;
  	var divs=menuDiv.getElementsByTagName("div");
  	var i;
  	for(i=0;i<divs.length;i++) {    
    clickDivStyle=divs[i].className;    
    if(clickDivStyle.substr(clickDivStyle.length-4)=="-sel")
    {       
        divs[i].className=clickDivStyle.substr(0,clickDivStyle.length-4);
    }       
  }
  for(i=0;i<divs.length;i++)
  {
        if(clickDiv==divs[i])
        {
          divs[i-1].className=divs[i-1].className+"-sel";
          divs[i].className=divs[i].className+"-sel";
          divs[i+1].className=divs[i+1].className+"-sel";
        }    
  }
  var detailIframe=document.getElementById('detailIframe').contentWindow;
  detailIframe.location.href=clickDiv.getAttribute('url');
}

</script>
</head>
<body scroll="no" class="padding5"  onload="onLoadLeft()" onunload="unLoadLeft()">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td valign="bottom" height="30" class="tab-tag  ">
			<div id="menuTabDiv" class="div-float">			
			
				<c:set value="${(param.from==null||param.from=='') ? 'listMeetingResource' : param.from }" var="from" />
				
				<span class="resCode">
	               	<div class="tab-separator"></div>
	               	<div class="${from=='listMeetingResource'?'tab-tag-left-sel':'tab-tag-left'}"></div>
	               	<div class="${from=='listMeetingResource'?'tab-tag-middel-sel':'tab-tag-middel'}" onclick="javascript:changeMenuTab(this);" url="mtAdminController.do?method=listBasedataMain&from=listMeetingResource"><fmt:message key="mt.mtMeeting.Meeting.Resource.label" /></div>
	               	<div class="${from=='listMeetingResource'?'tab-tag-right-sel':'tab-tag-right'}"></div>
	               	<div class="tab-separator"></div>
	           	</span>
	           	
	           	<span class="resCode">
					<div class="${param.from=='listMeetingType'?'tab-tag-left-sel':'tab-tag-left'}"></div>
					<div class="${param.from=='listMeetingType'?'tab-tag-middel-sel':'tab-tag-middel'}" onclick="javascript:changeMenuTab(this);" url="mtAdminController.do?method=listBasedataMain&from=listMeetingType"><fmt:message key="mt.mtMeeting.classification.label" /></div>
					<div class="${param.from=='listMeetingType'?'tab-tag-right-sel':'tab-tag-right'}"></div>
				</span>
				
				<span class="resCode">
					<div class="${param.from=='listMeetingRoom'?'tab-tag-left-sel':'tab-tag-left'}"></div>
					<div class="${param.from=='listMeetingRoom'?'tab-tag-middel-sel':'tab-tag-middel'}" onclick="javascript:changeMenuTab(this);" url="mtAdminController.do?method=listBasedataMain&from=listMeetingRoom"><fmt:message key="mt.mtMeeting.MeetingRoom.label" /></div>
					<div class="${param.from=='listMeetingRoom'?'tab-tag-right-sel':'tab-tag-right'}"></div>
				</span>
				
			</div>
			
		</td>
	</tr>

	<tr>
		<td>
			<iframe src="mtAdminController.do?method=listBasedataMain&from=${from }" noresize="noresize" frameborder="no" id="detailIframe" name="detailIframe" style="width:100%;height: 100%;" border="0px"></iframe>		
		</td>
	</tr>
</table>

</body>
</html>
