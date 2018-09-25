<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../../WEB-INF/jsp/inquiry/inquiryHeader.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='application.10.label' bundle="${v3xCommonI18N}" /><fmt:message key='inquiry.preview.label'/></title>
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/inquiry/css/inquiry.css" />">
<script type="text/javascript">
	
	//获取前一页面传来的对象<改为Open方式 Meng Yang 090618>
	//var inquiryObj = window.dialogArguments;
	var inquiryObj = window.opener;
	//调查名称
	var inquiryName = inquiryObj.document.all.surveyname.value;
	var deptName = inquiryObj.document.all.deptname.value;
	//调查类型下拉列表
	var typeOptions = inquiryObj.document.all.surveytype_id.options;
	
	var inquiryType = "";
	
	for(var i = 0 ; i < typeOptions.length ; i++ ){
		if(typeOptions[i].selected){
			inquiryType = typeOptions[i].text;
		}
	}
	
	//var sendDate = inquiryObj.document.all.send_date.value;
	var endDate = inquiryObj.document.all.close_date.value;
	var scope = inquiryObj.document.all.obj.value;
	var inquiryDesc = inquiryObj.document.all.surveydesc.value;
	
	
	function init(){
		var inquiryObj = window.dialogArguments;
		var questionsMap = inquiryObj.questions;
		alert(questionsMap.size())
		var questionsIndex = inquiryObj.document.all.projectBox.options;
		for(var i = 0 ; i < questionsIndex.length ; i++ ){
			alert(questionsMap.get(questionsIndex[i].index).title)
		}
	}
	//打印--------------------
	function printResult(){
           
           var mergeButtons  = document.getElementsByName("mergeButton");
           for(var s= 0;s<mergeButtons.length;s++){
              var mergeButton = mergeButtons[s]; 
              mergeButton.style.display="none";
           }
           var p = document.getElementById("printThis");
           var aa= "";
		   var mm = p.innerHTML;
		   var list1 = new PrintFragment(aa,mm);
           var tlist = new ArrayList();
		   tlist.add(list1);
           printList(tlist,new ArrayList());
          
           for(var s= 0;s<mergeButtons.length;s++){
               var mergeButton = mergeButtons[s];
               mergeButton.style.display="";
           }
            
}
	
	
</script>
</head>

<body>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="page2-header-line">
				<tr>
					<td width="80" height="60"><span class="inquiry_img"></span></td>
					<td class="page2-header-bg" width="380"><fmt:message key='application.10.label' bundle="${v3xCommonI18N}" /></td>
					<td>&nbsp;</td>
					<td class="page2-header-line padding-right" align="right"></td>
				</tr>
			</table>
			<div id="noprint" style="visibility:visible" align="right">    
			   <input type="button" name="mergeButton" onclick="printResult()" class="button-default-2" value="<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' />" />	
	   		</div>	
		</td>
	</tr>
	<tr>
			<td class="bbs-title-bar , bbs-td-center" colspan="2" height="26" align="left">
				<font style="font-size:14px">
					<script type="text/javascript">
						document.write(inquiryName);
					</script>
				</font>			
			</td>
	</tr>
		<tr>
			<td>
			<a name="top" id="top"></a>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td>
					<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="bbs-table2">
						<tr>
							<td width="30%" class="tbCell2 , bbs-bg , bbs-tb-bottom"
								valign="top">
							<table width="100%" border="0">
							   
								<tr>
									<td width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="inquiry.creater.label" />:</td>
							    </tr>
								<tr>
								   <td width="2%">&nbsp;</td>
								   <td width="98%"><c:out value="${sessionScope['com.seeyon.current_user'].name}" /></td>
								</tr>
								<tr>
									<td width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="inquiry.send.department.label" />:</td>
							    </tr>
								<tr>
								   <td width="2%">&nbsp;</td>
								   <td width="98%">
								   		<script type="text/javascript">
											document.write(deptName);
										</script>
								   </td>
								</tr>
								<tr height="2px">
								   <td colspan="3" height="2px"><div class="line"><sub></sub></div></td>
								</tr>
								<tr>
									<td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="inquiry.category.label" />:</td>
							    </tr>
							    <tr>
								   <td  width="2%">&nbsp;</td>
								   <td  width="98%">
								   		<script type="text/javascript">
											document.write(inquiryType);
										</script>
								   </td>
								</tr>
								<tr height="2px">
								   <td colspan="3" height="2px"><div class="line"><sub></sub></div></td>
								</tr>
								<tr>
									<td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="inquiry.date.rane.label" />:</td>
							    </tr>
								<tr>
								  <td  width="2%">&nbsp;</td>
								   <td  colspan="2">
								   		<script type="text/javascript">
								   			var now = new Date().format("yyyy-MM-dd");
											document.write(now);
										</script>
								    &nbsp;&nbsp;<fmt:message key="inquiry.to.label" /></td>   
								</tr>
								<tr>
								   <td  width="2%">&nbsp;</td>
								   <td  colspan="2">
									    <script type="text/javascript">
											document.write(endDate);
										</script>
								   </td>   
								</tr>
								<tr height="2px">
								   <td colspan="3" height="2px"><div class="line"><sub></sub></div></td>
								</tr>
								
								<tr>
								  <tr>
									   <td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="common.issueScope.label" bundle="${v3xCommonI18N}" />:</td>
							       </tr>
									 <tr>
										<td  width="2%">&nbsp;</td>
										<td colspan="2">
											<script type="text/javascript">
												document.write(scope);
											</script>
										</td>
								   </tr>
							</table>
							</td>
	
							<td width="65%" valign='top' class="bbs-tb-bottom">
			<div id="printThis"><!-- 打印开始 -->
							<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td valign="top" style="padding-top: 4px">
										<fmt:message key="inquiry.discription"/>: 
											<script type="text/javascript">
												document.write(inquiryDesc);
											</script>
									</td>
								</tr>
								<tr>
									<td valign="top">
										<script type="text/javascript">
											
											//获取调查问题项
											var questionsMap = inquiryObj.questions;
											//获取问题项用
											var questionsIndex = inquiryObj.document.all.projectBox.options;
											
											if(questionsMap.size()>0){
											
												for(var i = 0 ; i < questionsIndex.length ; i++ ){
													var question = questionsMap.get(questionsIndex[i].index);
													document.write("<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">");
													document.write("<tr><td>"+(i+1)+"."+question.title);
													document.write("<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">");
													if(question.items.size()>0){
														for(var j = 0 ; j < question.items.size() ; j++ ){
															document.write("<tr><td height=\"20\">");
															if(question.singleOrMany=='0'){
																document.write("<input type=\"radio\" disabled=\"disabled\">");
															}else{
																document.write("<input type=\"checkbox\" disabled=\"disabled\">");
															}
															document.write(question.items.get(j));
															document.write("</td></tr>");
														}
													}
													
													if(question.otherItem=='0'){
														document.write("<tr><td height=\"20\">");
														if(question.singleOrMany=='0'){
															document.write("<input type=\"radio\" disabled=\"disabled\">");
														}else{
															document.write("<input type=\"checkbox\" disabled=\"disabled\">");
														}
														document.write("<fmt:message key='inquiry.question.otherItem.label' />");
														document.write("<input type=\"text\" readonly=\"readonly\">");
														document.write("</td></tr>");
													}
													
													if(question.discuss=='0'){
														document.write("<tr><td>");
														document.write("<fmt:message key='inquiry.add.review.label' />");
														document.write("<br><textarea cols=\"120\" rows=\"5\" style=\"border:1px solid #d8d8d8\" readonly=\"readonly\"></textarea></td></tr>");
													}
													
													document.write("</table></td></tr></table>");
													
												}
											}
											
										</script>
									</td>
								</tr>
								
								<!--  预览附件先不做显示   实现起来比较麻烦
									<tr id="attachmentTR" class="bg-summary" style="display:none;">
										<td nowrap="nowrap" height="18" class="bg-gray" valign="top"><fmt:message
											key="common.attachment.label" bundle="${v3xCommonI18N}" />:&nbsp;
										</td>
										<td colspan="8" valign="top">
										<div class="div-float">(<span id="attachmentNumberDiv"></span>)</div>
										<v3x:fileUpload attachments="${attachments}" originalAttsNeedClone="true" /></td>
									</tr>
								-->
								
							</table>
				</div><!-- 打印结束 -->			
							</td>
						</tr>
					</table>
					</td>
				</tr>
	
				<tr>
					<td colspan="2" height="24" align="center">
						<input type="button" name="b2" onclick="window.close()" value="<fmt:message key='common.toolbar.back.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
					</td>
				</tr>
			</table>
			</td>
			</tr>
		</table>
</body>
</html>