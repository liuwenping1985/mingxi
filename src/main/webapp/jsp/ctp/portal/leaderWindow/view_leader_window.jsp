<%--
 $Author: xiongfeifei $
 $Rev: 1783 $
 $Date:: 2015-9-13 15:17:19#$:
  
 Copyright (C) 2015 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
  <head>
    <title>${ctp:i18n('edoc.system.menuname.leaderWindow')}</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">	
	<style type="text/css">
		body{ font-family: "微软雅黑"!important; background: none}
		.container{ overflow: hidden; padding:15px 0; margin:0}
		.container .info_left{ float:left; border-right:#d3d3d3 1px dashed; padding-left:20px}
		.container .info_right{ float:right; overflow:hidden; width:60%}
		.info_pic{ float:left; width:130px; box-shadow: 0 0 10px #888888;}
		.info_details{ float:left; padding-left:10px; margin-top:10px; }
		.info_position{ font-size: 18px; color:#892822; font-family: "微软雅黑"!important;}
		.info_work{ margin-top:5px; }
		.left_width{ font-weight: bolder; text-align:left; font-size: 14px; font-family:微软雅黑;}
	</style>
  </head>
  <body class="font_size12">
  	<div class="container w100b">
  		<!-- xl  左边30% -->
  		<div class="info_right" style="width:30%;">
  			<table cellpadding="0" cellspacing="0" width="100%" style="margin-top:0px">
  				<c:forEach items="${leaderWindow.contentList}" var="content">
	 			<tr>
	               	<th class="left_width" width="40%">
	               <%-- 	${content.sunDuty} --%>
	               		${content.sunDuty}
	               	</th>
	               	<td style="color:#555555; font-size:14px; font-family:微软雅黑; padding-left:5px" width="60%"> 
	               		${v3x:toHTMLAlt(content.sunContent)}
	               	</td>
	            </tr> 
               	<tr><td height="30px" colspan="2"></td></tr>
		        </c:forEach>
  			</table>
  		</div>
  		<!-- xl  左边60% -->
  		<div class="info_left" style="width:60%">
  			<div class="info_pic">
  				<c:choose>
	                <c:when test="${leaderWindow.imageName ==null || leaderWindow.imageName =='' }">
	                	<img id="image2" width="130" hight="180" src="${pageContext.request.contextPath}/apps_res/edoc/images/lwdefault.gif" />
	                </c:when>
               <c:otherwise>
                      	<img id="image2" width="130" hight="180" src="${pageContext.request.contextPath}/fileUpload.do?method=showRTE&${leaderWindow.imageName}&type=image" />
              	</c:otherwise>
              </c:choose>
  			</div>
  			<div class="info_details w60b">
  			<c:forEach items="${leaderWindow.contentList}" var="content" varStatus="statu">
  				<c:if test="${statu.first }">
  					<p class="info_position">${v3x:toHTMLAlt(leaderWindow.name)}<c:if test="${leaderWindow.duty != '' }">（${v3x:toHTMLAlt(leaderWindow.duty)}）</c:if></p>
  				</c:if>
  			</c:forEach>
  				<table class="info_work" cellpadding="0" cellspacing="0">
  					<tr>
  						<td width="60px" valign="top" style="line-height:30px;font-family:微软雅黑">工作分工：</td>
  						<td style="line-height:30px; color:#555; font-family:微软雅黑">${v3x:toHTMLAlt(leaderWindow.fenGong)}</td>
  					</tr>
  				</table>
  			</div>
  		</div>
  	</div>
  </body>
</html>
