<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="inquiryHeader.jsp"%>
<%@ include file="../common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<link rel="stylesheet" type="text/css"
	href="<c:url value="/apps_res/inquiry/css/inquiry.css${v3x:resSuffix()}" />">
<script type="text/javascript">
	try{
		//协同立方调查穿透,调整iframe的高度
		var iframeDialog=window.top.$("#url_main_iframe_content")[0].contentWindow.$("#collShow")[0].contentWindow.$("#url_main_iframe_content");
		var iframeHeight=iframeDialog.height();
		iframeDialog.height(iframeHeight-1);
	}catch(e){}
<!--
   function closeInquiry(){
      var bid= "${sbcompose.inquirySurveybasic.id}"
      var tid="${sbcompose.inquirySurveybasic.inquirySurveytype.id}"
      mainForm.action="${basicURL}?method=basic_end&bid="+bid+"&surveytypeid="+tid;
      mainForm.target = 'closeIframe';
      if(confirm(v3x.getMessage("InquiryLang.inquiry_stop_alert"))){
         mainForm.submit();
         window.location.reload();
      }
   }
 function merge_inquiry(total,questryId,queryTitle){
      var testMerge  =  document.getElementsByName("items"); 
     
      var len =testMerge.length;
      var count =0;
      var per = "";
      var obj = new ArrayList();
      for(var j=0;j<len;j++){
         if(testMerge[j].checked){
         obj = testMerge[j].value.split(",");
         	if(questryId==obj[0]){
         		count ++;
         	}
            if(per==""){
                per = obj[0];
            }else{
                if(per!= obj[0]){
                   alert(v3x.getMessage("InquiryLang.inquiry_select_the_same_alert"));
                  for(var m=0;m<len;m++){
                     testMerge[m].checked=false;
                  }
                  return false;
                }
            }  
         }
      }
      if(len<2){
            alert(v3x.getMessage("InquiryLang.inquiry_select_two_item_alert"));
          return false;
      }else{
      	if(count<2){
      		alert('请在"'+queryTitle+'"调查问题项中选中至少2个选项!');
      		return false;
      	}
      }
      if(count == total){
      		alert("最多只可以合并"+(total-1)+"项,请重新选择合并项!");
      		return false;
      }
      getA8Top().mergeinquiryWin = v3x.openDialog({
          title:" ",
          transParams:{'parentWin':window},
          url: "${genericController}?ViewPage=inquiry/merge",
          width: 450,
          height: 300,
          isDrag:false
      });
 }
 
 function mergeinquiryCollBack () {
	 getA8Top().mergeinquiryWin.close();
	 if(mainForm.newItem.value!="" && mainForm.newItem.value!="*&*cancelMeger*&*"){
         var bid= "${sbcompose.inquirySurveybasic.id}"
         var tid="${sbcompose.inquirySurveybasic.inquirySurveytype.id}"
         mainForm.action="${basicURL}?method=merge_inquiry&bid="+bid+"&tid="+tid+"&fromPigeonhole="+"${fromPigeonhole}";
         mainForm.submit();
      }
 }
function printResult(){
           var mergeButtons  = document.getElementsByName("mergeButton");
           for(var s= 0;s<mergeButtons.length;s++){
              var mergeButton = mergeButtons[s]; 
              mergeButton.style.display="none";
           }
           
           
           var itemsArr  = document.getElementsByName("items");
           for(var s= 0;s<itemsArr.length;s++){
              var items = itemsArr[s]; 
              items.style.display="none";
           }
           
           
           var retBut;
           var noPrintDiv;
          // var printDiscuss; 
           try{
           //printDiscuss = document.getElementById("printDiscuss");
          // printDiscuss.style.display="";
           retBut=document.getElementById("returnResult");
           retBut.style.display="none";
           noPrintDiv=document.getElementById("noprint");
           noPrintDiv.style.visibility="hidden";
           }catch(e){}
           var p = document.getElementById("printThis");
           var aa= "";
           
           var inquiryName = '<div align="center"><tr><font style="font-size:12px;font-weight:bold;">'+'<c:out value="${sbcompose.inquirySurveybasic.surveyName}" />'+'</font></tr></div>';
		   var mm = inquiryName + p.innerHTML;
		   var list1 = new PrintFragment(aa,mm);
           var tlist = new ArrayList();
		   tlist.add(list1);
           printList(tlist,new ArrayList());
           for(var s= 0;s<mergeButtons.length;s++){
               var mergeButton = mergeButtons[s];
               mergeButton.style.display="";
           }
            for(var s= 0;s<itemsArr.length;s++){
              var items = itemsArr[s]; 
              items.style.display="";
           }
           try{
           retBut.style.display="";
           noPrintDiv.style.visibility="visible";
           //printDiscuss.style.display="none";
           }catch(e){}
            
}

function fileToExcel(id){
	saveAsExcelFrame.location.href = "<c:url value='/inquirybasic.do'/>?method=fileToExcel&bid="+id;	
}

function inquiryToCol(){
    try{
    	var url = '${basicURL}?method=surveyToCol&bid=${sbcompose.inquirySurveybasic.id}&tid=${sbcompose.inquirySurveybasic.inquirySurveytype.id}';
    	if("${param.listFlag}"!="true") {//在弹出窗口中
    		var toColWindow = v3x.getParentWindow(window.getA8Top()).getA8Top();
    		if(toColWindow.main) {
    		    toColWindow.gotoDefaultPortal();
    			toColWindow.main.location.href = url;
    			window.getA8Top().close();
    		} else if(v3x.getParentWindow(toColWindow).getA8Top().main) {
    			v3x.getParentWindow(toColWindow).getA8Top().main.location.href = url;
    			window.getA8Top().close();
    		} else {
    			window.getA8Top().document.getElementById('main').src = url;
    		}
    	} else {//在上下列表结构中
    		window.getA8Top().document.getElementById('main').src = url;
    	}
    }catch(e){}
}

function backtovote(){ 
 // window.close();
 if("${param.listFlag}"!="true")
 {	
	window.location.href='${basicURL}?method=survey_detail&bid=${sbcompose.inquirySurveybasic.id}&surveytypeid=${sbcompose.inquirySurveybasic.inquirySurveytype.id}&manager_ID=${param.manager_ID}&listShow=listShow&fromPigeonhole=${fromPigeonhole}&fromReminded=${fromReminded}&userId=${userId}';
  }else
  {
	var ddd = parent.parent.parent.location;
	parent.parent.parent.location.href = ddd;
  	//window.close();
  }
}

//查看评论
function viewDiscuss(url,qname){
	var uri = url+"&qname="+encodeURIComponent(qname);
	if(typeof(getA8Top().opener.getA8Top)!="unknown"){
		getA8Top().opener.getA8Top().openCtpWindow({"url":uri});
	}else{
		getA8Top().openCtpWindow({"url":uri});
	}
}

/**
 * 投票数字的穿透弹出页面方法
 */
function openWindowForVoteData(flag){
	//半匿名的判断
	var semiAnonymous = ${sbcompose.inquirySurveybasic.cryptonym == 1 && sbcompose.inquirySurveybasic.showVoters == true};
	getA8Top().openWindowForVoteDataWin = v3x.openDialog({
        title:" ",
        transParams:{'parentWin':window},
        url: "${basicURL}?method=survey_listVoteDataFrame&bid=${param.bid}&flag="+flag+"&semiAnonymous="+semiAnonymous,
        width: 680,
        height: 380,
        isDrag:false
    });
}

/***
 * 
 
 */
function openWindowForItem(itemId){
	getA8Top().openWindowForItemWin = v3x.openDialog({
        title:" ",
        transParams:{'parentWin':window},
        url: "${basicURL}?method=survey_listItemVoteDataFrame&itemId="+itemId,
        width: 680,
        height: 380,
        isDrag:false
    });
}
//-->
</script>
</head>
<body scroll='no' style="overflow:hidden"  onLoad="reSizeLoad()" onResize="reSizeLoad()">
<script>
<!--
//first
var myBar = new WebFXMenuBar;

<c:set var="current_user_id" value="${sessionScope['com.seeyon.current_user'].id}"></c:set>
<c:if test="${current_user_id==sbcompose.inquirySurveybasic.createrId && sbcompose.inquirySurveybasic.censor=='8' && sbcompose.inquirySurveybasic.closeDate >nowTime}">
myBar.add(new WebFXMenuButton("<fmt:message key='common.toolbar.disable.label' bundle='${v3xCommonI18N}' />", "<fmt:message key='common.toolbar.disable.label' bundle='${v3xCommonI18N}' />", "closeInquiry()", "<c:url value='/common/images/toolbar/move.gif'/>","<fmt:message key='common.toolbar.disable.label' bundle='${v3xCommonI18N}' />", null));
</c:if>
//-->
</script>

<table width="100%" height="100%" cellspacing="0" cellpadding="0" border="0" class="main-bg">
<tr class="page2-header-line">
	<td width="100%" height="41" valign="top" class="page-list-border-LRD">
		 <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
	     	<tr class="page2-header-line">
	       			<td width="45" class="page2-header-img"><div class="inquiryIndex"></div></td>
					<td id="notepagerTitle1" class="page2-header-bg"><fmt:message key='application.10.label' bundle="${v3xCommonI18N}" /></td>
					<td class="page2-header-line padding-right" align="right">&nbsp;</td>
		        </tr>
		 </table>
	</td>
</tr>
<tr>
<td height="100%" valign="top">
<table height="99%" width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
  <tr>
     <td colspan="2" align="right" height="2" width="100%">
     <div id="noprint" style="visibility:visible">        
     	<c:if test="${v3x:hasNewCollaboration() && param.openFrom != 'ucpc'}">     	
		   <a href="#" onClick="inquiryToCol()">
		     <span id = "transmitCol">[<fmt:message key='common.toolbar.transmit.col.label' bundle='${v3xCommonI18N}' />]</span>
		   </a>&nbsp;		
		</c:if>
	   <c:if test="${v3x:getBrowserFlagByRequest('HideMenu', pageContext.request)}">
       <a href="#" onClick="fileToExcel('${sbcompose.inquirySurveybasic.id}')">
	     [<fmt:message key='common.toolbar.exportExcel.label' bundle='${v3xCommonI18N}' />]
	   </a>&nbsp;
	   <a href="#" onClick="printResult()">
	     [<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' />]
	   </a>&nbsp;
	   </c:if>
	   </div>
     </td>
	</tr>
	<tr>
		<td colspan="2" valign="top">
		  <form action="" name="mainForm" id="mainForm" method="post">
		    <table width="100%" height="100%" border="0"  cellspacing="0" cellpadding="0" align="center" class="border-top border-left border-right">
			  <tr>
				<td class="webfx-menu-bar" colspan="2" height="26">&nbsp;
				 <font style="font-size:12px;font-weight:bold;">
				 <c:out value="${sbcompose.inquirySurveybasic.surveyName}" />
				 <c:if	test="${sbcompose.inquirySurveybasic.censor=='5'}">
					<fmt:message key='inquiry.state.stop.label' var="stop" />
						 （<c:out value="${stop}" />）
		         </c:if></font>				 
			    </td>				
			</tr>
			<tr>
			  <td class="border-top">
				<div style="overflow:auto;" class="scrollList" id="scrollListDiv">
					<a name="top" id="top">
					</a>
				  <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" height="100%">
					<tr>
						<td>
						  <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="">
							<tr>
								<td width="25%" class="bbs-bg border-bottom" valign="top">
                                  <table width="100%" border="0"  align="left" valign="top">
                                    <tr><td colspan="4">&nbsp;</td></tr>
							        <tr>
										<td width="10%">&nbsp;</td>
										<td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="78%" colspan="2"><fmt:message key="inquiry.subject.label" />:</td>
									</tr>
									<tr>
										 <td width="10%">&nbsp;</td>
										 <td  width="2%">&nbsp;</td>
										<td  width="78%" colspan="2"><c:out value="${sbcompose.inquirySurveybasic.surveyName}" /></td>
									</tr>
									<tr height="2px">
										<td>&nbsp;</td>
										<td colspan="2" height="2px"><div class="lineDetail"><sub></sub></div></td>
									 </tr>	
									<tr>
										<td width="10%">&nbsp;</td>
										<td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="78%" colspan="2"><fmt:message key="inquiry.creater.label" />:</td>
									</tr>
									<tr>
										<td width="10%">&nbsp;</td>
										<td  width="2%">&nbsp;</td>
										<td  width="78%" colspan="2"><c:out value="${v3x:showOrgEntitiesOfIds(sbcompose.inquirySurveybasic.createrId, 'Member', pageContext)}" /></td>
									</tr>
									 <tr height="2px">
										<td>&nbsp;</td>
										 <td colspan="2" height="2px"><div class="lineDetail"><sub></sub></div></td>
									</tr>	
							        
							        <tr>
							           <td width="10%">&nbsp;</td>
								       <td width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> 
									   <td width="78%" colspan="2"><fmt:message key="inquiry.send.department.label" />:</td>
						            </tr>
							        <tr>
							          <td>&nbsp;</td>
							          <td>&nbsp;</td>
							          <td><c:out value="${sbcompose.deparmentName.name}" /> </td>
							        </tr>
							        <tr height="2px">
							          <td>&nbsp;</td>
							          <td colspan="3" height="2px"><div class="lineDetail"><sub></sub></div></td>
							        </tr>
							        <tr>
							          <td>&nbsp;</td>
								      <td><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> 
									  <td colspan="2"><fmt:message key="inquiry.category.label" />:</td>
						            </tr>
						            <tr>
						              <td>&nbsp;</td>
							          <td>&nbsp;</td>
							          <td>
									   <c:out  value="${sbcompose.inquirySurveybasic.inquirySurveytype.typeName}" /></td>
							        </tr>
							        <tr height="2px">
							          <td>&nbsp;</td>
							          <td colspan="3" height="2px"><div class="lineDetail"><sub></sub></div></td>
							        </tr>
							        <tr>
							         <td>&nbsp;</td>
								     <td><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> 
									 <td colspan="2"><fmt:message key="inquiry.date.rane.label" />:</td>
						            </tr>
							        <tr>
							         <td>&nbsp;</td>
							         <td>&nbsp;</td>
							         <td  colspan="2">
									   <fmt:formatDate value="${sbcompose.inquirySurveybasic.sendDate}" pattern="${datetimePattern}" /> &nbsp;&nbsp;<fmt:message key="inquiry.to.label" />
									 </td>   
							       </tr>
							       <tr>
							         <td>&nbsp;</td>
							         <td>&nbsp;</td>
							         <td  colspan="2">
									   <c:choose>
								          <c:when test="${sbcompose.inquirySurveybasic.closeDate eq null}">
								              <fmt:message key="inquiry.no.limit" />
										  </c:when>
									      <c:otherwise>
										     <fmt:formatDate value="${sbcompose.inquirySurveybasic.closeDate}" 	pattern="${datetimePattern}" />
									     </c:otherwise>	
							          </c:choose>
									</td>  
							      </tr>
							      <tr height="2px">
							        <td>&nbsp;</td>
							        <td colspan="3" height="2px"><div class="lineDetail"><sub></sub></div></td>
							      </tr>
							      <c:if test="${sbcompose.inquirySurveybasic.censor != 8 && sbcompose.inquirySurveybasic.censorId != 0}">
								      <tr>
								        <td>&nbsp;</td>
									    <td><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> 
										<td colspan="2"><fmt:message key="inquiry.auditor.label" />:</td>
							          </tr>
								      <tr>
								        <td>&nbsp;</td>
										<td>&nbsp;</td>
										<td colspan="2"><c:out value="${sbcompose.conser.name}" /></td>
								      </tr>
								      <tr height="2px">
								        <td>&nbsp;</td>
								        <td colspan="3" height="2px"><div class="lineDetail"><sub></sub></div></td>
								      </tr>
							      </c:if>							     
							      <tr>
							       <td>&nbsp;</td>
								   <td><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td>
								   <td colspan="2">
								     <fmt:message key="common.issueScope.label" bundle="${v3xCommonI18N}" />:
								   </td>
						          </tr>
								  <tr>
								    <td>&nbsp;</td>
									<td>&nbsp;</td>
									<td colspan="2"><div  style=" width:180px;overflow:hidden; text-overflow:ellipsis;" title="${v3x:showOrgEntities(sbcompose.entity, "id", "entityType", pageContext)}" ><nobr>${v3x:showOrgEntities(sbcompose.entity, "id", "entityType", pageContext)}</nobr></div></td>
							     </tr>
							     				<tr height="2px">
							     				<td>&nbsp;</td>
                                               <td colspan="3" height="2px"><div class="lineDetail"><sub></sub></div></td>
                                              </tr> 
                                               <tr>
                                               <td ></td>
                                                   <td  width="2%"><img  src="<c:url value='/apps_res/inquiry/images/dian.gif'/>" ></td> <td width="98%" colspan="2">投票方式:</td>
                                               </tr>
                                                 <tr>
                                                    <td  width="2%">&nbsp;</td>
                                                    <td colspan="2">
	                                                    <div  style=" width:280px;overflow:hidden; text-overflow:ellipsis;" title="${v3x:showOrgEntities(sbcompose.entity, "id", "entityType", pageContext)}" >
		                                                    <nobr>
				                                				<c:choose>
																	<c:when test="${sbcompose.inquirySurveybasic.cryptonym == 0}">
																		<input disabled="disabled" id="cryptonym1" type="radio" name="cryptonym" value="0" checked="checked" />
				                                						<fmt:message key="inquiry.real.name.label" />
                                                                        <br/>
                                                                        <input id="allowAdminViewResult" name="allowAdminViewResult" disabled="disabled"  type="checkbox" checked="checked"/>
                                                                        <fmt:message key="inquiry.allowviewresult.foradmin.2" />
																	</c:when>
																	<c:when test="${sbcompose.inquirySurveybasic.cryptonym == 1}">
																		<input id="cryptonym2" type="radio" name="cryptonym" disabled="disabled" checked="checked"/>
                                										<fmt:message key="inquiry.anonymity.label" />
                                										<br/>
                                										<input id="allowAdminViewResult" name="allowAdminViewResult" disabled="disabled"  type="checkbox" checked="checked"/>
                                										<c:if test="${sbcompose.inquirySurveybasic.showVoters == true}">
                                											<fmt:message key="inquiry.allowviewresult.foradmin" />
                                										</c:if>
                                                                        <c:if test="${sbcompose.inquirySurveybasic.showVoters == false}">
                                                                            <fmt:message key="inquiry.allowviewresult.foradmin.1" />
                                                                        </c:if>
																	</c:when>
																</c:choose>
			                                				</nobr>
			                                			</div>
		                                			</td>
                                               		
                                               </tr>
						        </table>
								</td>
								<td width="75%" valign='top'>
								<div id="printThis"><!-- 打印开始 -->
								  <table width="100%" height="100%" border="0" cellspacing="0"
									cellpadding="0" style="word-break:break-all;word-wrap:break-word">
									<tr>
										<td class="tbCell4 bbs-tb-padding2 " valign="top">
										<p class="border-padding">
											<!--  <c:out value="${sbcompose.inquirySurveybasic.surveydesc}" />-->
											${v3x:toHTML(sbcompose.inquirySurveybasic.surveydesc)}
										 </p>
                                         <div id="bodyContent">
										<c:forEach	items="${sbcompose.subsurveyAndICompose}" var="tname">
											<table border="0" width="100%" cellpadding="0" cellspacing="0" align="center" class="border-top border-left border-right">
												<tr bgcolor="#ffffff" align="left" class="bbs-title-bar , bbs-td-center">
													<th colspan="3">
													<div style=" width: 350px;overflow:hidden; text-overflow:ellipsis; cursor: hand;height:25px;line-height: 25px;vertical-align: middle;padding-left: 5px;" title="${v3x:toHTML(tname.inquirySubsurvey.title)}">
														<nobr>
															<c:out value="${tname.inquirySubsurvey.sort+1}" />、<c:out value="${tname.inquirySubsurvey.title}"/> 
															<c:if test="${tname.inquirySubsurvey.singleMany==0}">
																（<fmt:message key="inquiry.select.single.label" />）
															</c:if> 
															<c:if test="${tname.inquirySubsurvey.singleMany==1}">
																（<fmt:message key="inquiry.select.many.label" />）
															</c:if>
															<c:if test="${tname.inquirySubsurvey.singleMany==2}">
																（<fmt:message key="inquiry.select.qa.label" />）
															</c:if>
														</nobr>
													</div>
													</th>
													<c:if test="${tname.inquirySubsurvey.singleMany!=2}">
														<th><fmt:message key="inquiry.vote.label" /></th>
														<th><fmt:message key="inquiry.percent.label" /></th>
													</c:if>
													<c:set var="res" value="0" />
													<c:forEach items="${tname.items}" var="tot">

														<c:set var="res" value="${res + tot.voteCount}" />

													</c:forEach>
													</tr>
													<c:set value="0" var="optionNum"></c:set>
													<c:forEach items="${tname.items}" var="sub" varStatus="status">
														<tr bgcolor="#ffffff">
															<td width="5%" height="25"><c:if
																test="${current_user_id==sbcompose.inquirySurveybasic.createrId}">
																<input type="checkbox" name="items"
																	value="${sub.subsurveyId},${sub.id}">
															</c:if></td>
															<td width="45%">
															<div style=" width: 200px;overflow:hidden; text-overflow:ellipsis; cursor: hand" title="${v3x:toHTML(sub.content)}"><nobr><c:out
																value="${sub.content}"/></nobr></div>
															</td>
															<td width="30%">
															<%
									                            com.seeyon.v3x.inquiry.domain.InquirySubsurveyitem item =(com.seeyon.v3x.inquiry.domain.InquirySubsurveyitem)pageContext.getAttribute("sub");
									                            int sort =item.getSort();
									                            String thisSort = String.valueOf(sort%5);
									                            request.setAttribute("thisSort",thisSort);
								                            %>
	                                                   <img id='sss' src="<c:url value='/apps_res/inquiry/images/${thisSort}.gif'/>" width="${sub.voteCount/res*150}px" height="15px">
	                                           
															</td>
															<td width="10%" align="middle">
															<c:choose>
																<c:when test="${sub.voteCount != 0 && isSenderOrAdmin &&(sbcompose.inquirySurveybasic.cryptonym == 0)}">
																	<a onclick="javascript:openWindowForItem('${sub.id}');"><c:out value="${sub.voteCount}" /> </a>
																</c:when>
																<c:otherwise>
																	<c:out value="${sub.voteCount}" />
																</c:otherwise>
															</c:choose>
																
															</td>
															<td width="10%" align="right">
																<c:if test="${res == 0}">
																	<c:set var="res" value="1" />
																</c:if> 
																<fmt:formatNumber value="${sub.voteCount/res*100}" maxFractionDigits="1" /> %
															</td>
														</tr>
														<c:set var="optionNum" value="${status.index+1}"></c:set>
													</c:forEach>
												<tr bgcolor="#ffffff" align="center" id="buttons">
													<td colspan="5" align="right" style="padding: 0">
													<c:set value="${v3x:toHTMLWithoutSpaceEscapeQuote(tname.inquirySubsurvey.title)}" var="surveyTitle" />
													<c:if test="${current_user_id==sbcompose.inquirySurveybasic.createrId && optionNum > 2 && param.openFrom != 'ucpc'}">
														<input type="button" name="mergeButton" class="button-default-2" style="padding-left: 0px; padding-right: 0px;" title="<fmt:message key="inquiry.unite.item.label" />"  value="<fmt:message key="inquiry.unite.item.label" />" onclick="merge_inquiry('${optionNum}','${tname.inquirySubsurvey.id}','${surveyTitle}')">
													</c:if>
													<c:if test="${current_user_id==sbcompose.inquirySurveybasic.createrId || manager eq 'manager'}"><!-- 如果是管理员才显示评论管理的按钮,发起人也应该显示的 -->
														<c:if test="${tname.inquirySubsurvey.discuss=='0' && param.openFrom != 'ucpc'}">
															<c:set value="${tname.inquirySubsurvey.singleMany!='2' ? 'inquiry.manage.review.label' : 'inquiry.manage.answer.label'}" var="buttonKey" />
															<c:if test="${current_user_id==sbcompose.inquirySurveybasic.createrId}">
																<c:set var="isInquiry_createUser" value="true"/>
															</c:if>
															<input type=button name="mergeButton" class="button-default-2" style="padding-left: 0px; padding-right: 0px;" value="<fmt:message key="${buttonKey}" /> " onclick="viewDiscuss('${basicURL}?method=showDisscusFrame&bid=${sbcompose.inquirySurveybasic.id}&qid=${tname.inquirySubsurvey.id}&tid=${sbcompose.inquirySurveybasic.inquirySurveytype.id}&manager_ID=${param.manager_ID}&cryptonym=${sbcompose.inquirySurveybasic.cryptonym}&isInquiry_createUser=${isInquiry_createUser}&singleMany=${tname.inquirySubsurvey.singleMany}','${surveyTitle}')">
														 </c:if> 
													</c:if>
													</td>
												</tr>
												
											<c:if test="${tname.inquirySubsurvey.discuss==0}">
												<c:set value="${tname.inquirySubsurvey.singleMany!='2' ? 'inquiry.review.context.label' : 'inquiry.answer.context.label'}" var="column1Key" />
												<c:set value="${tname.inquirySubsurvey.singleMany!='2' ? 'inquiry.review.people.label' : 'inquiry.answer.people.label'}" var="column2Key" />
												<c:set value="${tname.inquirySubsurvey.singleMany!='2' ? 'inquiry.review.time.label' : 'inquiry.answer.time.label'}" var="column3Key" />
												<tr bgcolor="#ffffff">
													<td colspan="5" width="100%" style="padding: 0" class="border-top">				
													<div id="printDiscuss">
														 <v3x:table data="${tname.inquirySubsurvey.isds}" var="sub" htmlId="aaaa"  showPager="false" dragable="false">
															<v3x:column label="${column1Key}" value="${sub.discussContent}"  alt="${sub.discussContent}" width="229"/>
																
															<c:if test="${sbcompose.inquirySurveybasic.cryptonym=='0'}">
									 							<v3x:column label="${column2Key}" value="${v3x:showMemberName(sub.userId)}"  width="229"></v3x:column>
									    					</c:if>
									    					<v3x:column label="${column3Key}" width="229" type="Date"  align="left" ><fmt:formatDate value="${sub.discussDate}" pattern="${ datetimePattern }"/></v3x:column>
								  						</v3x:table>
													</div>				
													</td>
												</tr>	
											</c:if>
												<tr>
                                                 <td colspan="4">
					                                      <div class="div-float attsContent" style="display: none"
                                                                id="attsDiv${param.bid}">
                                                            <div class="atts-label"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" /> ： &nbsp;&nbsp;</div>
                                                            <v3x:attachmentDefine attachments="${attachments}" />
                                                                <script type="text/javascript">
                                                                    showAttachment('${param.bid}', 0, 'attsDiv${param.bid}');
                                                                </script>
                                                            </div>
					                                </td>
					                            </tr>
					                            <tr>
					                                <td colspan="4">
					                                     <div class="div-float attsContent" style="display: none"
                                                                 id="attsDiv2${param.bid}">
                                                             <div class="atts-label"><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" /> ：</div>
                                                             <v3x:attachmentDefine attachments="${attachments}" /> 
                                                             <script type="text/javascript">
                                                                  showAttachment('${param.bid}',2, 'attsDiv2${param.bid}');
                                                             </script>
                                                            </div>
					                                      
					                                </td>
					                            </tr>
											</table>

											<p align="left">
										</c:forEach>
                                       </div>
										<input type="hidden" name="newItem" value="">
                                        
										
								</table>
								</div>
								</td>
							</tr>
						</table>
						</td>
					</tr>
					
					<a name="buttom" id="buttom"></a>		
				</table>
				</div>
				</td>
			</tr>
		</table>
		</form>
		</td>
		</tr>		
		</table>

</td>
</tr>
<tr>
<td>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
	<td class="bg-advance-bottom" align="left">
		<c:choose>
			<c:when test="${fromReminded!='fromReminded'&&isSenderOrAdmin && !(sbcompose.inquirySurveybasic.cryptonym == 1 && sbcompose.inquirySurveybasic.showVoters == false)}" >
				<td class="bg-advance-bottom">
			                   	<fmt:message key="survey.join.people.link" /> 
			                    <a style="color: blue;" onclick="javascript:openWindowForVoteData('allVote');">${sbcompose.inquirySurveybasic.totals}</a>，
			                    <fmt:message key="survey.now.votes.link1"/> 
			                    <c:choose>
				                    <c:when test="${sbcompose.inquirySurveybasic.voteCount !=0}">
					                    <a style="color: blue;" onclick="javascript:openWindowForVoteData('hadVote');">${sbcompose.inquirySurveybasic.voteCount}</a>
					                    <fmt:message key="survey.now.votes.link2"/>，
				                    </c:when>
				                    <c:otherwise>
					                    <fmt:message key="survey.now.votes">
				                            <fmt:param value="${sbcompose.inquirySurveybasic.voteCount}"></fmt:param>
				                    	</fmt:message>，
				                    </c:otherwise>
			                    </c:choose>
			                     <c:choose>
				                    	<c:when test="${sbcompose.inquirySurveybasic.totals - sbcompose.inquirySurveybasic.voteCount !=0}">
			                    		<a style="color: blue;" onclick="javascript:openWindowForVoteData('noVote');">${sbcompose.inquirySurveybasic.totals - sbcompose.inquirySurveybasic.voteCount}</a> 
			                    		<fmt:message key="survey.now.votes.notvote.link" />
			                    </c:when>
				                    <c:otherwise>
					                    <fmt:message key="survey.now.votes.notvote">
				                            <fmt:param value="${sbcompose.inquirySurveybasic.totals - sbcompose.inquirySurveybasic.voteCount}"></fmt:param>
				                    	</fmt:message>
				                    </c:otherwise>
			                    </c:choose>
		                  	</td> 
			</c:when>
			<c:otherwise>
				<td class="bg-advance-bottom">
                   	<fmt:message key="survey.join.people">
                    	<fmt:param value="${sbcompose.inquirySurveybasic.totals}"></fmt:param>
                    </fmt:message>，
                    <fmt:message key="survey.now.votes">
                            <fmt:param value="${sbcompose.inquirySurveybasic.voteCount}"></fmt:param>
                    </fmt:message>，
                    <fmt:message key="survey.now.votes.notvote">
                            <fmt:param value="${sbcompose.inquirySurveybasic.totals - sbcompose.inquirySurveybasic.voteCount}"></fmt:param>
                    </fmt:message>
                 	</td> 
			</c:otherwise>
		</c:choose>
	</td>
	<td class="bg-advance-bottom" align="right" height="42">						
	  <!-- input type="button" id="returnResult" value="返回投票" class="button-default-2" onclick="backtovote();"/-->
	  <input type="button" id="returnResult" value="<fmt:message key='common.toolbar.back.label' bundle='${v3xCommonI18N}' />" class="button-default-2" onClick="backtovote();"/>
	  </td>
	  </tr>
</table>
</td>
</tr>
</table>
<iframe name="closeIframe" width="0" height="0"></iframe>
<!-- 导出Excel表格所用 -->
<iframe name="saveAsExcelFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
<script type="text/javascript">
//如果从消息窗口单独弹出，而且没有主窗口，不能转发协同
if("${param.listFlag}"!="true") {
    try{
    	var toColWindow = v3x.getParentWindow(window.getA8Top()).getA8Top();
    	var isContentFrame = true;
    	try{
    	    v3x.getParentWindow(toColWindow).getA8Top()
    	}catch(e){
    	    isContentFrame = false;
    	}
    	if(typeof(toColWindow.main)=="undefined"&&!isContentFrame) {
    	    document.getElementById("transmitCol").style.display = "none";
    	}
    }catch(e){
        document.getElementById("transmitCol").style.display = "none";
    }
}

if("${param.fromPigeonhole}" == "true") {
	var transmitCol = document.getElementById("transmitCol");
	if(transmitCol){
		document.getElementById("transmitCol").style.display = "none";
	}
}
var oHeight = parseInt(document.body.clientHeight)-130;
var oWidth = parseInt(document.body.clientWidth);
initFFScroll('scrollListDiv',oHeight,oWidth);
initSafariScroll('scrollListDiv',oHeight,oWidth);
initChromeScroll('scrollListDiv',oHeight,oWidth);
bindOnresize('scrollListDiv',0,120);

function reSizeLoad(){
    var h=document.body.clientHeight;
    document.getElementById("scrollListDiv").style.height=h-115;
    try{
    	  if (window.top.opener.$("#main")[0].contentWindow) {
                window.top.opener.$("#main")[0].contentWindow.sectionHandler.reload("pendingSection",true);
          }
    }catch(e){
    }
}
</script>
</body>
</html>