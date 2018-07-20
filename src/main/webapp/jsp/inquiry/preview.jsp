<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="inquiryHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='application.10.label' bundle="${v3xCommonI18N}" /><fmt:message key='inquiry.preview.label'/></title>
<link rel="stylesheet" type="text/css"
	href="<c:url value="/apps_res/inquiry/css/inquiry.css${v3x:resSuffix()}" />">
<style>
<!--
#discussul{
	list-style: none;
	margin:0 0 0 18px;
	font-weight:bold;
}
#discussul li{
	margin:5px 0 5px 20px;
	font-weight:normal;
	color:#000000;
}
// -->
</style>


<script type="text/javascript">
<!--
	//获取前一页面传来的对象
	var inquiryObj = window.opener;
	//调查名称
	var inquiryName = inquiryObj.document.all.surveyname.value;
	var deptName = inquiryObj.document.all.deptname.value;
	//调查类型下拉列表
	var typeOptions = inquiryObj.document.getElementById("surveytype_id").options;
	var inquiryType = "";
	if(typeOptions){
		for(var i = 0 ; i < typeOptions.length ; i++ ){
			if(typeOptions[i].selected){
				inquiryType = escapeStringToHTML(typeOptions[i].text);
			}
		}
	}
	var cryptonym = "";
	var allowAdminViewResult = "";
	var cryptonymItem = inquiryObj.document.getElementsByName('cryptonym');
	if (cryptonymItem) {
	      for(var i = 0 ; i < cryptonymItem.length ; i++ ){
	            if(cryptonymItem[i].checked){
	            	cryptonym = cryptonymItem[i].value;
	            }
	     }
	}
	if (cryptonym == '1') {
		allowAdminViewResult = inquiryObj.document.getElementById('allowAdminViewResult').checked;
	}
	
	//var sendDate = inquiryObj.document.all.send_date.value;
	var endDate = inquiryObj.document.all.close_date.value;
	var scope = inquiryObj.document.all.obj.value;
	var inquiryDesc = inquiryObj.document.all.surveydesc.value;

//附件
  var attNumber = inquiryObj.getFileAttachmentNumber(0);
  var att = "";
  if(attNumber != 0){
      att = "<table><tr><td valign='top'>" + 
          "<div class='div-float' style='font-weight: bolder; font-size: 12px;'>"
           +'<fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" />'+ "：</div></td>" + 
          "<td valign='top' style='color: #335186;'>" + inquiryObj.getFileAttachmentName(0) + "</td></tr></table>";
  }

  //关联文档
  var att2Number = inquiryObj.getFileAttachmentNumber(2);
  var attFile = "";
  if(att2Number != 0){
      attFile = "<table><tr><td valign='top'>" + 
          "<div class='div-float' style='font-weight: bolder; font-size: 12px;'>"
          + '<fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />' + "：</div></td>" + 
          "<td valign='top' style='color: #335186;'>" + inquiryObj.getFileAttachmentName(2) + "</td></tr></table>";
  }
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
//-->
</script>
</head>

<body style="overflow:auto">
<table width="100%" height="100%" cellspacing="0" cellpadding="0" >
	<tr>
		<td width="100%" height="60" valign="top">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="page2-header-line-old" >
				<tr>
					<td width="80" height="60"><span class="inquiry_img"></span></td>
					<td class="page2-header-bg-old" width="380"><fmt:message key='application.10.label' bundle="${v3xCommonI18N}" /></td>
					<td>&nbsp;</td>
					<td class="page2-header-line-old padding-right" align="right"></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
	  <td height="100%" valign="top">
	  <div class="scrollList padding10">
	    <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td colspan="3" height="100%"  valign="top" class="tbCell6 , bbs-bg , left-con"><a name="top" id="top"></a>		

								<table width="100%" border="0" align="left" valign="top">
									<tr>
										<td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="inquiry.subject.label" />:</td>
									 </tr>
									 <tr>
										<td  width="2%">&nbsp;</td>
										<td  width="98%"><script type="text/javascript">document.write(inquiryName.escapeHTML());</script></td>
									</tr>
									<tr height="2px">
											<td colspan="3" height="2px"><div class="lineDetail"><sub></sub></div></td>
									</tr>	
									<tr>
										<td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="inquiry.creater.label" />:</td>
									</tr>
									<tr>
										<td  width="2%">&nbsp;</td>
										<td  width="98%"><c:out value="${sessionScope['com.seeyon.current_user'].name}" /></td>
									</tr>
									<tr height="2px">
									   <td colspan="3" height="2px"><div class="lineDetail"><sub></sub></div></td>
									</tr>							
									<tr>
									   <td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="inquiry.send.department.label" />:</td>
									</tr>									
									<tr>
									  <td  width="2%">&nbsp;</td>
									  <td  width="98%"><script type="text/javascript">document.write(deptName);</script></td>
									</tr>
											<tr height="2px">
											   <td colspan="3" height="2px"><div class="lineDetail"><sub></sub></div></td>
											</tr>
											<tr>
												<td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="inquiry.category.label" />:</td>
										    </tr>
										    <tr>
											   <td  width="2%">&nbsp;</td>
											   <td  width="98%"><script type="text/javascript">document.write(inquiryType);</script></td>
											</tr>									
											<tr height="2px">
											   <td colspan="3" height="2px"><div class="lineDetail"><sub></sub></div></td>
											</tr>
											<tr>
												<td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="inquiry.date.rane.label" />:</td>
										    </tr>
										  	<tr>
											  <td  width="2%">&nbsp;</td>
											   <td  colspan="2"><script type="text/javascript">var now = new Date().format("yyyy-MM-dd");document.write(now);</script>&nbsp;&nbsp;<fmt:message key="inquiry.to.label" /><script type="text/javascript">document.write(endDate);</script></td>   
											</tr>  
											<tr height="2px">
											   <td colspan="3" height="2px"><div class="lineDetail"><sub></sub></div></td>
											</tr>
											<tr>
												   <td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2"><fmt:message key="common.issueScope.label" bundle="${v3xCommonI18N}" />:</td>
										       </tr>
												 <tr>
													<td  width="2%">&nbsp;</td>
													<td colspan="2"><script type="text/javascript">document.write(scope);</script></td>
											   </tr>
                                            <tr height="2px">
                                               <td colspan="3" height="2px"><div class="lineDetail"><sub></sub></div></td>
                                            </tr>
                                            <tr>
                                                 <td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2">投票方式:</td>
                                            </tr>	
                                            
                                            <tr>
                                                <td  width="2%">&nbsp;</td>
                                                <td colspan="2">
                                                    <div style=" width:280px;">
                                                            <script type="text/javascript">
                                                                 var html = "";
                                                                 if (cryptonym == "0") {
                                                                	 html += '<input disabled="disabled" id="cryptonym1" type="radio" name="cryptonym" value="0" checked="checked" />';
                                                                     html += ' <fmt:message key="inquiry.real.name.label" />';
                                                                     html += '<br/>';
                                                                     html += '<input id="allowAdminViewResult" name="allowAdminViewResult" disabled="disabled"  type="checkbox" checked="checked"/>';
                                                                     html += '<fmt:message key="inquiry.allowviewresult.foradmin.2" />';
                                                                 } else {
                                                                	 html += '<input id="cryptonym2" type="radio" name="cryptonym" disabled="disabled" checked="checked"/>';
                                                                     html += '<fmt:message key="inquiry.anonymity.label" />';
                                                                     html += '<br/>';
                                                                	 html += '<input id="allowAdminViewResult" name="allowAdminViewResult" disabled="disabled"  type="checkbox" checked="checked"/>';
                                                                	 if (allowAdminViewResult == true) {
                                                                         html += '<fmt:message key="inquiry.allowviewresult.foradmin" />';
                                                                	 } else {
                                                                	     html += '<fmt:message key="inquiry.allowviewresult.foradmin.1" />';
                                                                	 }
                                                                 }
                                                                 document.write(html);
                                                            </script>
                                                    </div>
                                                </td>
                                            </tr>								    
								</table>
						</td>
						<td width="78%" valign='top' class=" top-padding" style="padding: 10px;">
						  <table width="100%" border="0" cellspacing="0" cellpadding="0" style="word-break:break-all;word-wrap:break-word;">
											<tr>
												<td>
											  &nbsp;<font style="font-size: 16px;">
											            
													</font>
												</td>
											</tr>
											<tr>
												<td class="bbs-tb-padding2" valign="top" style="word-break:break-all;word-wrap:break-word">					
											     	<font style="font-size: 16px;"><script>document.write(inquiryObj.document.all.surveydesc.value.trim().escapeHTML());</script></font>
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
																	document.write("<tr><td><b>"+(i+1)+"."+question.title.escapeHTML()+"</b>");
																	
																	if(question.singleOrMany=='1'){
																		document.write("<b>&nbsp;&nbsp;&nbsp;(<fmt:message key="inquiry.select.max.label" />:");
																		document.write(question.maxSelect+")</b>");
																	}
																	if(question.desc && question.desc!='') {
																		document.write("<br>&nbsp;&nbsp;&nbsp;"+question.desc.escapeHTML());
																	}
																	document.write("<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">");
																	if(question.items.size()>0){
																		//document.write("<tr><td height=\"20\">");
																		//document.write("</td></tr>");
																		for(var j = 0 ; j < question.items.size() ; j++ ){
																			document.write("<tr><td height=\"20\">");
																			if(question.singleOrMany=='0'){
																				document.write("&nbsp;&nbsp;&nbsp;<input type=\"radio\" disabled=\"disabled\">");
																			}else{
																				document.write("&nbsp;&nbsp;&nbsp;<input type=\"checkbox\" disabled=\"disabled\">");
																			}
																			document.write(question.items.get(j).escapeHTML());
																			document.write("</td></tr>");
																		}
																	}
																	
																	if(question.otherItem=='0'){
																		document.write("<tr><td height=\"20\">");
																		if(question.singleOrMany=='0'){
																			document.write("&nbsp;&nbsp;&nbsp;<input type=\"radio\" disabled=\"disabled\">");
																		}else{
																			document.write("&nbsp;&nbsp;&nbsp;<input type=\"checkbox\" disabled=\"disabled\">");
																		}
																		document.write("<fmt:message key='inquiry.question.otherItem.label' />");
																		document.write("<input type=\"text\" readonly=\"readonly\">");
																		document.write("</td></tr>");
																	}
																	
																	if(question.discuss=='0'){
																		if(question.singleOrMany=='2'){
																			document.write("<tr><td>");
																			document.write("&nbsp;&nbsp;&nbsp;<fmt:message key='inquiry.pls.anwer' />");
																			document.write("<br>&nbsp;&nbsp;&nbsp;<textarea cols=\"120\" rows=\"5\" style=\"border:1px solid #d8d8d8\" readonly=\"readonly\"></textarea></td></tr>");
																		}else{
																			document.write("<tr><td>");
																			document.write("&nbsp;&nbsp;&nbsp;<fmt:message key='inquiry.add.review.label' />");
																			document.write("<br>&nbsp;&nbsp;&nbsp;<textarea cols=\"120\" rows=\"5\" style=\"border:1px solid #d8d8d8\" readonly=\"readonly\"></textarea></td></tr>");
																		}
																	}
																	
																	document.write("</table></td></tr></table>");
																	
																}
															}
															
														</script>
													</td>
												</tr>
                                                <tr id="attachTr2">
                                                    <td colspan="2" width="100%" valign="bottom">
                                                        <script type="text/javascript">
                                                            document.write(attFile);
                                                        </script>
                                                    </td>
                                                </tr>		 
												<tr id="attachTr">
													<td colspan="2" width="100%" valign="bottom">
														<script type="text/javascript">
														document.write(att);
														</script>
													</td>
												</tr>
						  </table>
						</td>
					</tr>					      
	    </table>
	    </div>
	  </td>
	</tr>
</table>
</body>
</html>