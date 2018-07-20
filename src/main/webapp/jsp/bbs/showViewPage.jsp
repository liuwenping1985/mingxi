
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, width=device-width">

<title><fmt:message key="bbs.preview.label" /></title>
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/bbs/css/bbs.css${v3x:resSuffix()}" />">
<v3x:attachmentDefine attachments="${attachments}" />
<style>
div.articleCss{
	font-size:12px;
	font-family:Arial, Helvetica, sans-serif;
}

font.titleCss{
	font-size:12px;
	font-weight:900;
	font-family:黑体, Arial, Helvetica;
}
</style>
</head>
<body scroll="no" style="overflow-y:hidden;">
<div class="scrollList" id="scrollListDiv">
<form name="postForm" id="postForm" method="post" style="margin: 0px">
<table id="content" border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
	<tr>
		<td width="100%" height="60" valign="top">
			 <a name="top" id="top"></a>
			 <table width="100%"  border="0" cellpadding="0" cellspacing="0">
		     <tr class="page2-header-line-old" height="60">
		        <td width="80" height="60"><img src="<c:url value="/apps_res/bbs/images/bbsHeader.gif" />" width="80" height="60" /></td>
		        <td class="page2-header-bg-old"><fmt:message key="bbs.label" /></td>	
		         <td class="page2-header-line-old page2-header-link" align="right"></td>
			</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td valign="top" class="padding5" height="70">
			<table width="100%" height="100%" class="page2-list-border">
			    <tr>
				   <td colspan="2" valign="top">
					   <table border="0" cellpadding="0" cellspacing="0" width="100%" class="bbs-view-title-bar" style="border-bottom: 0px">
					   <tr>
					   	<td>
					   		<font class="titleCss">
						   	<script
								type="text/javascript">
						    	if (typeof(title) != "undefined") {
						    	  document.write(title);
						    	}
							</script>
							</font>
					   	</td>
					   </tr>
					   </table>
			       </td>
				</tr>
				<tr>
					<td  class="tbCellTemp bbs-bg" width="150px" nowrap>
						<table>
							<tr>
								<td width="56">
									<div style="border: 1px #CCC solid; width: 56px; height: 56px; text-align: center; background-color: #FFF;">
										<div style="width: 50px; height: 50px; margin-top: 2px; text-align: center;">
											<script>
											if(image == '0'){
												document.write("<img id='image1' src='${pageContext.request.contextPath}/fileUpload.do?method=showRTE&" + issuerImage +"&type=image' width='50' height='50' />");
											}else if(image == '1'){
												document.write("<img id='image1' src='${pageContext.request.contextPath}/apps_res/v3xmain/images/personal/" + issuerImage +"' width='50' height='50' />");
											}else{
												document.write("<img id='image1' src='${pageContext.request.contextPath}/apps_res/v3xmain/images/personal/pic.gif' width='50' height='50' />");
											}
										</script>
										</div>
									</div>
		                		</td>
		                	</tr>
		                	<tr>
		                		<td width="56" align="center">
		                			<div class="bbs-member-name" style="white-space: nowrap; margin-top: 3px;">		
										 ${v3x:currentUser().name}
									</div>
								</td>
							</tr>
						</table>
								<div class="articleCss"><fmt:message key="department.label" />&nbsp;:&nbsp;<script
									type="text/javascript">
						    if (typeof(deptName) != "undefined") {
			                  document.write(deptName);
			                }
							</script></div>
								<div class="articleCss"><fmt:message key="station.label" />&nbsp;:&nbsp;<script
									type="text/javascript">
								if (typeof(postName) != "undefined") {
				                  document.write(postName);
				                }
							</script></div>
						
					
						<div class="articleCss"><fmt:message key="bbs.board.label" />:&nbsp;&nbsp;<script
								   type="text/javascript">
								if (typeof(boardName) != "undefined") {
					              document.write(boardName);
					            }
							</script></div>
						<div class="articleCss">
							<fmt:message key="common.issueScope.label" bundle="${v3xCommonI18N}" />:&nbsp;&nbsp;
							<script
									type="text/javascript">
							if (typeof(issueAreaName) != "undefined") {
								document.write(issueAreaName);
							}
							</script>
						</div>
					</td>
					<td width='100%-150px'>
						<table  border="0" height="100%" width="100%" cellspacing="0" cellpadding="0">
							<tr>
								<td colspan="2"  width="100%" valign="top">
									<table  border="0" height="100%" width="100%" cellspacing="0" cellpadding="0">
										<tr>
											<td valign="top" >
												<div id="con" class="padding30 article">
													<script type="text/javascript">
													try {
													  if (typeof(content) != "undefined") {
	  										    		document.write(content);
													  }
													} catch (e) {
													}
													</script>
												</div>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr id="attach2Tr">
								<td colspan="2" width="100%" valign="bottom">
									<script type="text/javascript">
									 if (typeof(att2) != "undefined") {
										document.write(att2);
									 }
									</script>
								</td>
							</tr>
							<tr id="attachTr">
                                <td colspan="2" width="100%" valign="bottom">
                                    <script type="text/javascript">
                                    if (typeof(att) != "undefined") {
                                      document.write(att);
                                   }
                                    </script>
                                </td>
                            </tr>
					   </table>
					</td>
				</tr>
				<tr>
				   <td colspan="2">
				      <hr>
				   </td>
				</tr>
			</table>
		</td>
	</tr>
</table>	
</form>
</div>
</body>
</html>