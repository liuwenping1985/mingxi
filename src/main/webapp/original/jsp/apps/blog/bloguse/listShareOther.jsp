<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="../header.jsp"%>
</head>
 <v3x:selectPeople id="per" panels="Department" selectType="Department,Member"
	departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" jsFunction="setPeopleFields(elements)" />
<body scroll="yes">
<c:set var="loopl" value="1"/>
<script type="text/javascript">
<!--
	function doClick(URL,flagStart){
		if(flagStart!=1){
			alert("<fmt:message key='blog.admin.notstart.alert2'/>");
			return;
		}else{
			location.href = URL;
		}
	}	
	  function   showDiv(){   
  var   obj   =   document.getElementById("hideDiv");   
  obj.style.left=event.clientX;   
  obj.style.top=event.clientY;   
  obj.style.display="";   
  }
//-->
</script>
<table width="100%" height="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr class="page2-header-line">
		<td width="100%" height="41" valign="top" class="page-list-border-LRD">
			 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="border_b">
		     	<tr class="page2-header-line">
		        <td width="45" class="page2-header-img"><div class="bulltenIndex"></div></td>
				<td class="page2-header-bg"><fmt:message key="blog.otherblog"/></td>
				<td class="page2-header-line padding-right" align="right">
					<div class="blog-div-float-right">
						<!-- 配置他人博客 -->
						<a
							href="${detailURL}?method=listAllShareOther&from=${from}" class="hyper_link2"
							title="<fmt:message key='blog.otherblog.setup'/>"> 
							[<fmt:message key="blog.otherblog.setup" />]
						</a>&nbsp;
						<!-- 返回 -->
					<c:if test="${from!='doc'}">
				
						<a href="${detailURL}?method=blogHome" class="hyper_link2">
								[<fmt:message key="common.toolbar.back.label" bundle="${v3xCommonI18N}" />]
						</a>&nbsp;&nbsp;
					</c:if>
					</div>
				
				</td>
			    </tr>
			 </table>
		</td>
	</tr>
	<tr height="40"><td></td></tr>
	<tr>
		<td valign="top">
		<!--  <div class="scrollList">  -->
			<table width="90%" border="0"   cellspacing="0" cellpadding="0" align="center" valign="top" >
			
			
			<c:forEach items="${AttentionModelList}" var="vo">
				<tr height="56">
					<td id="thePicture" align="center" width="100">
						<a onclick="javascript:doClick('${detailURL}?method=listAllArticle&userId=${vo.attentionId}','${vo.flagStart}')" 
									class="hyper_link2" border="0" title="${v3x:toHTML(vo.introduce)}" target="_self"
									style="cursor:hand"   onmouseout="document.getElementById('hideDiv').style.display='none';">
							<div style="border: 1px #CCC solid; width: 50px; height: 50px; text-align: center; background-color: #FFF;">
								<div style="width: 50px; height: 50px; text-align: center;">
                                        <img id="image1" src="${v3x:avatarImageUrl(vo.attentionId)}" width="48" height="48"></img>
								</div>
							</div>										
						</a>
					</td>
					<td align="left" class="dotted_line">
						<table height="100%" width="100%" border="0"  cellspacing="0"  cellpadding="0" >
							<tr height="25" >
								<td>
															<a onclick="javascript:doClick('${detailURL}?method=listAllArticle&userId=${vo.attentionId}','${vo.flagStart}')" 
									class="hyper_link1" border="0"  target="_self"
								style="cursor:hand"	   onmouseout="document.getElementById('hideDiv').style.display='none';">
										<b><c:out value="${vo.userName }"/></b>
										<c:if test="${vo.flagStart != 1}">
											(<fmt:message key="blog.admin.notstart.alert3"/>)
										</c:if>
										&nbsp;&nbsp;&nbsp;&nbsp;										
										<c:out value="${vo.departmentName }"/>	
										<c:out value="${vo.postName }"/>&nbsp;&nbsp;&nbsp;&nbsp;
										<fmt:message key="blog.setshare.label"/><fmt:message key="blog.subject.number.label"/> <c:out value="${vo.articleNumber }"/>

									</a>
								</td>
								<td width="30"></td>
							</tr>
							<tr height="25" >
								<td>
															<a onclick="javascript:doClick('${detailURL}?method=listAllArticle&userId=${vo.attentionId}','${vo.flagStart}')" 
									class="hyper_link1" border="0" title="${v3x:toHTML(vo.introduce)}" target="_self"
								style="cursor:hand"	   onmouseout="document.getElementById('hideDiv').style.display='none';">

										${v3x:toHTML(v3x:getLimitLengthString(vo.introduce,100,"..."))}
									</a>
								</td>
								<td width="30">
								<a href="${detailURL}?method=delAttention&id=${vo.id}" title="<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />">
								<img src="${pageContext.request.contextPath}/apps_res/blog/images/del.gif" width="16" height="16" border="0"/></a></td>
							</tr>
							<tr height="10"><td colspan="2"></td></tr>
						
						</table>
					</td>

					<td width="30"></td>
				</tr>
			</c:forEach>
			</table>
		</td>
	</tr>
	 <div   id="hideDiv"   style="border:1px   solid   #888;display:none;position:absolute">   
  </div>
  		<c:if test="${fn:length(AttentionModelList)==0 }">
			<tr valign="top">
				<td height="100%"  align="center">
					<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                        <tr>
                            <td align="right" valign="middle" width="50%"><img class="valign_m margin_r_10"
                                src="<c:url value="/skin/default/images/zszx_empty.png"/>" />
                            </td>
                            <td class="color_gray font_size12" width="50%"><fmt:message key="blog.other.no.alert"/></td>
                        </tr>
                    </table>
                </td>
			</tr>
		</c:if>
</table>
</body>
</html>