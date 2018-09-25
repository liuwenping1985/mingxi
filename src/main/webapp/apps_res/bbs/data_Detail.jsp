<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<%@ include file="../../WEB-INF/jsp/bbs/header.jsp"%>
<title></title>
<script type="text/javascript">

//获取前一页面传来的对象
	var bbsObj = window.dialogArguments;
	//讨论标题
	var title = bbsObj.document.all.articleName.value;
	//讨论发布者
	var issueUser = bbsObj.document.all.issueUser.value;
	//发布范围
	var issueAreaName = bbsObj.document.all.issueAreaName.value;
	//人员部门
	var deptName = bbsObj.document.all.deptName.value;
	//人员岗位
	var postName = bbsObj.document.all.postName.value;
	//讨论板块
	var bbstype_Name = bbsObj.document.all.bbstype_Name.value;// 单位集团  为空 ，部门项目的为  1
	var bbsTypeName = bbsObj.document.all.bbsTypeName.value;//部门或者项目的板块
	var bbsType = "";
	if(bbstype_Name==null || bbstype_Name==''){//取不倒值是单位或者集团的板块--值为空
		var typeOptions = bbsObj.document.all.boardId.options;
		for(var i = 0 ; i < typeOptions.length ; i++ ){
			if(typeOptions[i].selected){
					bbsType = typeOptions[i].text;
			}
		}
	}else{//取到值是部门的板块---值为1
		bbsType = bbsTypeName;
	}
	
	//正文内容
 	 var oEditorFCK=bbsObj.FCKeditorAPI.GetInstance('content');  
 	 var content = oEditorFCK.EditingArea.Document.body.innerHTML;	

</script>

</head>

<body scroll="no">

<form name="postForm" id="postForm" method="post" style="margin: 0px">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
	<tr>
		<td width="100%" height="60" valign="top">
			 <table width="100%"  border="0" cellpadding="0" cellspacing="0">
		     <tr class="page2-header-line" height="60">
		        <td width="80" height="60"><img src="<c:url value="/apps_res/bbs/images/bbsHeader.gif" />" width="80" height="60" /></td>
		        <td class="page2-header-bg"><fmt:message key="bbs.label" /></td>
		        <td class="page2-header-line page2-header-link" align="right">
					<span class="hyper_link2">
						[<fmt:message key="bbs.reply.post.label" />]</span> &nbsp;
					<span class="hyper_link2"> [<fmt:message key="common.toolbar.refresh.label" bundle="${v3xCommonI18N}" />]</span>&nbsp; 
					<a class="hyper_link2" href="###" onclick="javascript:window.close();">
						[<fmt:message key="common.toolbar.back.label" bundle="${v3xCommonI18N}" />]
					</a>
		        </td>
			</tr>
			</table>
		</td>
	</tr>
<tr>
<td valign="top" class="padding5" height="100%">
	<table align="center" width="100%" height="100%" cellpadding="0" cellspacing="0" class="page2-list-border">	
	    <tr>
		   <td height="25" class="webfx-menu-bar page2-list-header">
	       <b>
	         <script type="text/javascript" >
				document.write(title);	
  			 </script>
	       		<c:choose>
					<c:when test="${article.resourceFlag==1}">
						<font color="black">[<fmt:message key="bbs.yuan.label" />]</font>
					</c:when>
					<c:when test="${article.resourceFlag==2}">
						<font color="black">[<fmt:message key="bbs.zhuan.label" />]</font>
					</c:when>
				</c:choose>
				
		      	 <c:if test="${article.anonymousFlag}">
		       			<font color="red">[<fmt:message key="anonymous.label"/>]</font>
	       		 </c:if>
	       </b>
	       </td>
		</tr>
		<tr>
		  <td>
		  <div class="scrollList">
		  <a name="top" id="top"></a>
				<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td>
							<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="20%" class="tbCell2 bbs-bg bbs-tb-bottom" style="word-break: break-all">
										
												<div class="bbs-member-name">
													  <script type="text/javascript" >
															document.write(issueUser);	
  													  </script>
												</div>
												<div><img src="<c:url value='/apps_res/bbs/images/pic.gif'/>" ></div>
												<div><fmt:message key="department.label" />&nbsp;:&nbsp;${v3x:getOrgEntity('Department',article.department).name}
													<script type="text/javascript" >
														document.write(deptName);	
  									     			</script>
												</div>
												<div><fmt:message key="station.label" />&nbsp;:&nbsp;
													<script type="text/javascript" >
														document.write(postName);	
  									     			</script>
												</div>
										
										<fmt:message key="bbs.board.label" />:&nbsp;&nbsp;
										 <script type="text/javascript" >
												document.write(bbsType);	
  									     </script>
										<div>
											<fmt:message key="common.issueScope.label" bundle="${v3xCommonI18N}" />:&nbsp;&nbsp;											
											<script type="text/javascript" >
												document.write(issueAreaName);	
  									    	 </script>
										</div>
									</td>
							
									<td width="80%" valign='top' class="bbs-tb-bottom">
										<table  width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" 
												style="table-layout:fixed;">
											<tr>
												<td class="tbCell4 , bbs-tb-padding"  width="87%" height="24" >
													<fmt:message key="bbs.issue.at.label" />：
												</td>
												<td class="tbCell4" width="13%" height="24">
													<div class="bbs-div-padding-right"><fmt:message key="bbs.first.floor.label" /></div>
												</td>
											</tr>
											<tr>
												<td class="tbCell4-dotted bbs-tb-padding2" colspan="2" valign="top">
													<div style="width:100%;overflow-x:auto;overflow-y:hidden;">
													 <script type="text/javascript">
															document.write(content);
 													 </script>&nbsp;<br>													
													</div>
												</td>
											</tr>
											<tr align="right">
												<td colspan="2" height="24">
													<!-- 删除 -->
														<a href="#" class="hyper_link2">
														<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' /></a>&nbsp;&nbsp;&nbsp;&nbsp;
													
													
													<!-- 引用 -->
														<a href="#" class="hyper_link2">
														<fmt:message key="bbs.reference.label"/></a>&nbsp;&nbsp;&nbsp;&nbsp;
													
													
													<a href="#" id="toTop"><img border="0" src="<c:url value='/apps_res/bbs/images/top.GIF'/>" alt="<fmt:message key='return.top.label'/>" ></a>&nbsp;&nbsp;&nbsp;&nbsp;
													<a href="#"><img border="0" src="<c:url value='/apps_res/bbs/images/bottom.GIF'/>" alt="<fmt:message key='return.buttom.label'/>"></a>&nbsp;&nbsp;&nbsp;&nbsp;
												</td>
											</tr>
										</table>
									</td>		
								</tr>	
							</table>
						</td>
					</tr>
					<tr><td height="10">&nbsp;</td></tr>
					
					<tr>
					<td valign="top"  height="160">
					<table align="center" width="100%" height="100%" cellpadding="0" cellspacing="0" class="page2-list-border sort manage-stat-1">	
						<thead>
						    <tr>
							   <td height="25">
						       <b><fmt:message key="quick.reply.label" /></b>
						       </td>
							</tr>
						</thead>	
							<tr>
							  <td>
							 <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
														<tr>
															<td width="20%" height="24" align="right" class="tbCell4 , bbs-bg">
																<fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" />:&nbsp;&nbsp;
															</td>
															<td width="80%" height="24" class="tbCell4 bbs-tb-padding">
																<span title="${article.articleName}">RE：
																	 <script type="text/javascript" >
																		document.write(title);	
  																	 </script>
																</span>
																<span onclick="" class="like-a"><fmt:message key='common.toolbar.insertAttachment.label' bundle="${v3xCommonI18N}" /></span>
															</td>
														</tr>
													
														 <tr id="attachmentTR" style="display:none;">
														      <td nowrap="nowrap" height="26"  class="tbCell4 , bbs-bg"  valign="middle" align="right">
														      		<fmt:message key="common.attachment.label"   bundle="${v3xCommonI18N}"/>:&nbsp;&nbsp;
														      </td>
														      <td valign="top" height="26"  class="tbCell4 , bbs-tb-padding">
														      		<div class="div-float">(0)</div>
														    		
														      </td>
														  </tr>  
													
														<tr>
															<td align="right" class="tbCell4 , bbs-bg">
																<fmt:message key="bbs.content.label"/>:&nbsp;&nbsp;
															</td>
															<td class="tbCell4 , bbs-tb-padding">
																<textarea rows="5" name="content" disabled="disabled" style="width:98%" inputName="<fmt:message key="bbs.content.label"/>" validate="notNull,maxLength" maxSize="500"></textarea>
															</td>
														</tr>
														
														<tr>
															<td class="bbs-bg">
																&nbsp;
															</td>
															<td class="bbs-tb-padding">
																<input type="button" name="reply"
																	value="<fmt:message key='common.button.submit.label' bundle='${v3xCommonI18N}'/>"
																	onclick="" class="button-default-2"> 
															</td>
														</tr>
													</table>
							  </td>
							</tr>
							
						</table>
					</td> 
					</tr>
					
					 <tr>
				          <TD align="right"> 
				               	<fmt:message key="bbs.reply.page.label">
				               		<fmt:param value="0"></fmt:param>
				               		<fmt:param value="1"></fmt:param>
				               	</fmt:message>
				               	  | <fmt:message key="taglib.list.table.page.first.label" bundle="${v3xCommonI18N}"/>&nbsp;&nbsp;<fmt:message key="taglib.list.table.page.prev.label" bundle="${v3xCommonI18N}"/>&nbsp;&nbsp;<fmt:message key="taglib.list.table.page.next.label" bundle="${v3xCommonI18N}"/>&nbsp;&nbsp;<fmt:message key="taglib.list.table.page.last.label" bundle="${v3xCommonI18N}"/>
				               	  | <fmt:message key="bbs.reply.page.at.label">
					               		<fmt:param value="1"></fmt:param>
					               	</fmt:message>
				               	  <input type="button" value="go" onclick="">
				          </TD>
				     </tr>
				</table>
				<a name="buttom" id="buttom"></a>
		  </div>
		  </td>
		</tr>
	</table>
 </td>
</tr>

</table>	
</form>
<iframe name="hiddenFrame" width="0" height="0" frameborder="0"></iframe>
<iframe name="newHiddenFrame" width="0" height="0" frameborder="0"></iframe>
</body>
</html>