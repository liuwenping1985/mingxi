<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<%@ include file="../header.jsp"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>

<%@ include file="../../../common/INC/noCache.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<title></title>

<script type="text/javascript">
<!--

	var today = new Date();
	var myYear = today.getFullYear();
	var myMonthTop = today.getMonth()+1;
	var myDayOfMonth = today.getDate();
	
	function submitSearch(){
		var theForm = document.getElementById("searchForm");
		var condition = document.getElementById("condition").value;
		var textfield1 = document.getElementById("textfield1").value;
		var textfield2 = document.getElementById("textfield2").value;
		if (theForm){ 
		   if ( condition == ''||condition == null){
		   alert('<fmt:message key="blog.condition.select" />');
		}else if("issueTime" == condition && textfield1>textfield2 && textfield2 != ''){
		   alert('<fmt:message key="blog.search.alert.time" />');
		}else {
           theForm.submit();
        }
        }
        else if (!theForm){
        	return;
        }
	}

	function doSearchEnter(){
	    if(event.keyCode == 13){
	    	submitSearch();
	    }
	}
	
	function showFrame(){	
   		v3x.openWindow({
			url : "${detailURL}?method=getCalendar&userId=${userId}&type=0",
			width : "300",
			height : "190",
			resizable : "true",
			scrollbars : "true"
			,dialogType:"open"
		});
		window.close();
	}	
	
	function openBlogDetail(_url) {
		getA8Top().openBlogDetailWin = getA8Top().$.dialog({
	        title:"<fmt:message key='blog.post.label'/>",
	        transParams:{'parentWin':window},
	        url: genericURL + _url,
	        width: document.body.scrollWidth,
	        height: document.body.scrollHeight,
	        isDrag:false
	    });
	}
	
	function  openBlogDetailCallBack (rv) {
		if(rv && 'false' == rv) {
            window.location.reload(true);
		}
	}
	
	function doShareClick(URL,flagStart){
		if(flagStart!=1){
			alert("<fmt:message key='blog.admin.notstart.alert2'/>");
			return;
		}else{
			location.href = URL;
		}
	}
	
	function delArticle(){
		var listForm = self.document.getElementById("listForm");
		//listForm.target = "empty";
		var aurl = "${detailURL}?method=deleteArticles";
	
		var chkid = self.document.getElementsByName("id");
		var count = 0;
		var ids = "";
		var familyIds = "";
		for(var i = 0; i < chkid.length; i++){
			if(chkid[i].checked){
				count += 1;
				ids += "," + chkid[i].value;
				familyIds += "," + chkid[i].getAttribute("familyId");
			}
		}
		if(count == 0) {
			alert(v3x.getMessage("BlogLang.blog_delete_select_alert"));
			return;
		}
		if(!window.confirm(v3x.getMessage('DocLang.doc_delete_confirm_tail')))	  
		  return;
		var idsEle = document.getElementById("selectedIds");
		var idsFamilyEle = document.getElementById("selectedFamilyIds");
		
		idsEle.value = ids.substring(1, ids.length);
		idsFamilyEle.value = familyIds.substring(1, familyIds.length);
		
			listForm.action = aurl;	
		listForm.submit();

		
		//location.reload(true);
	
	}
	
	/**
	 * 输出日历
	 * iYear 年
	 * iMonth 月
	 * iDayStyle 输出的样式 分别为 1 2 3 三种
	 */
	function drawCalendar(iYear, iMonth, iDayStyle) {

		var myMonth;
	    var contextPath = v3x.baseURL;
		myMonth = fBuildCal(iYear, iMonth, iDayStyle);
	
		document.write("<table border='0' style='border-bottom: 0 '  cellspacing='0' cellpadding='0' width='100%'><tr>");
		document.write("<td width='30px' align='center'>");
	    document.write("<table title='" +  _('V3XLang.calendar_last_month') + "' border='0' cellPadding='0' cellSpacing='0' onclick='ChangeYearAndMonth(0)'>");
		document.write("<tr><td  align='center' style='CURSOR:Hand'><img border='0' src = '"+contextPath+"/apps_res/blog/images/arrowleft.gif'></td>");
	
	    document.write("</tr></table></td><td id='YearAndMonth'><p align='center' ><table id='tblYearAndMonth' border='0' cellPadding='0' cellSpacing='0'><tr><td width='100%' align='center' ><span id='c_Year'>"+iYear+"</span>" + _('V3XLang.calendar_year') + "<span id='tmpmonth'>");
	
	    var tmp = iMonth;
		document.write(_('V3XLang.calendar_months' + tmp)+"</span><span id='c_Month' class='hidden'>" + (tmp + 1) + "</span></td></tr></table></p></td>");
	
		document.write("<td width='30px'  align='center'>");
		document.write("<table title='" +  _('V3XLang.calendar_next_month') + "' border='0' cellPadding='0' cellSpacing='0' onclick='ChangeYearAndMonth(1)'>");
		document.write("<tr><td width='100%' align='center' style='CURSOR:Hand'><img border='0' src='"+contextPath+"/apps_res/blog/images/arrowright.gif"+"'></td></tr>");
		document.write("</table></td></tr></table>");
	
		document.write("<table height='120' border='0' cellspacing='0' cellpadding='0' bgcolor='#FFFFFF'  width='100%'><tr id='draw'>");
		document.write("<td align='center' nowrap height='22' >");
		document.write(myMonth[0][0]+"</td><td align='center' nowrap >");
		document.write(myMonth[0][1]+"</td><td align='center' nowrap >");
		document.write(myMonth[0][2]+"</td><td align='center' nowrap >");
		document.write(myMonth[0][3]+"</td><td align='center' nowrap >");
		document.write(myMonth[0][4]+"</td><td align='center' nowrap >");
		document.write(myMonth[0][5]+"</td><td align='center' nowrap >");
		document.write(myMonth[0][6]+"</tr>");
	
		for (var w = 1; w < 7; w++) {
			document.write("<tr>");
			for (var d = 0; d < 7; d++) {

				document.write("<td align='middle' >");
				
				document.write("<table border='0' cellpadding='0' width='100%' height='100%'  cellspacing='0'><tr><td onclick=\"eventCal(this);\" align=center>");


				if(myMonth[w][d]){
					document.write("<font id='calDateText' name='calDateText' style='CURSOR:Hand'>" + myMonth[w][d] + "</font></td></tr></table>");
				}else{
					document.write("<font id='calDateText' name='calDateText' style='CURSOR:Hand'>" + "</font></td></tr></table>");
				}
				
				document.write("</td>");
			}
			
			document.write("</tr>");
		}
	}
	
	function eventCal(obj){
		if(obj.firstChild.innerText!=" "){
			location.href=genericURL+"?method=blogHome&searchFlag=true&condition=byDate&year="+eval("c_Year").innerHTML+"&month="+eval("c_Month").innerHTML+"&day="+obj.firstChild.innerHTML;
		}
	}
	
	window.onload = function(){
		var condition = '${v3x:escapeJavascript(condition)}';
	
		if(condition == '' || condition == 'byDate')
			return;
		else {
			var conditionObj = document.getElementById("condition");
			selectUtil(conditionObj, condition);
		    showNextCondition(conditionObj);
			
			if(condition == 'subject')
				document.getElementById("textfield").value = "${v3x:escapeJavascript(field)}";
			else if(condition == 'issueTime'){
				document.getElementById("textfield1").value = "${v3x:escapeJavascript(field)}";
				document.getElementById("textfield2").value = "${v3x:escapeJavascript(field1)}";
			}
		}
	}
	
	function homeNew(){
		location.href = "${detailURL}?method=blogNew";
	}
	function homeDel(){
		delArticle();
	}
	
	function homeUpdate(){
		var blogIds = document.getElementsByName('id');
		var chooseSum = 0;
		var blogId = 0;
		var familyId = 0;
		for(var i = 0; i < blogIds.length; i++){
			if(blogIds[i].checked){
				blogId = blogIds[i].value;
				chooseSum = chooseSum + 1;
				familyId = blogIds[i].getAttribute("familyId");
				v=blogIds[i].getAttribute("v");
			}
		}
		if(chooseSum == 1){	
			getA8Top().openTheWindows = getA8Top().$.dialog({
                title:' ',
                transParams:{'parentWin':window},
                url: genericURL+"?method=showPostIframe&articleId=" + blogId + "&familyId=" + familyId + "&resourceMethod=blogHome&flag=update&v=" + v,
                width: screen.width,
                height: screen.height,
                isDrag:false
           });
		}
		else if(chooseSum > 1){
			alert(v3x.getMessage("BlogLang.blog_choose_more"));
		}
		else if(chooseSum < 1){
			alert(v3x.getMessage("BlogLang.blog_choose_none"));
		}
			
	}
	
	function openBlogDetailCallBack (rv) {
		if(getA8Top().openBlogDetailWin){
			getA8Top().openBlogDetailWin.close();
		}else{
			getA8Top().openTheWindows.close();
		}
		if(rv && rv=='false') {
            window.location.reload();
        }
	}
//-->
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/blog/js/output_mul_day.js${v3x:resSuffix()}" />"></script>
<style>
	.main_div_cols_l_blog {
	 width: 100%;
	 height: 100%;
	 _padding-right:190px;
	}
	.right_div_cols_l_blog {
	 width: 100%;
	 height: 100%;
	 _padding:30px 0px 0px 0px;
	}
	.main_div_cols_l_blog>.right_div_cols_l_blog {
	 width:auto;
	 position:absolute;
	 left:0px;
	 right:195px;
	}
	.left_div_cols_l_blog {
	 width:190px;
	 height:100%;
	 position:absolute;
	 top:0px;
	 right:0px;
	 overflow: auto;
	}
	.center_div_cols_l_blog {
	 width: 100%;
	 height: 100%;
	 overflow:auto;
	}
	.right_div_cols_l_blog>.center_div_cols_l_blog {
	 height:auto;
	 position:absolute;
	 top:37px;
	 bottom:0px;
	}
	.top_div_cols_l_blog {
	 height:37px;
	 width:100%;
	 position:absolute;
	 top:0px;
	}
    
    .mxtgrid div.bDiv td div {
    height:26px;
    line-height:26px;
    padding-left:10px;
    border-top: 0px solid #fff;
    
    white-space: nowrap;
    overflow: visible;
    text-overflow: ellipsis;
    -moz-binding: url('ellipsis.xml#ellipsis');
}
</style>
</head>
<body scroll="no" class="">
<span id="nowLocation"></span>
<div class="main_div_cols_l_blog">
  <div class="left_div_cols_l_blog border_b">
		<table width="100%" border="0" >
			<tr>
				<td height="170" valign="top">
					<table  width="100%" border="0" cellspacing="0" cellpadding="0" >
						<tr >
							<td class="info-title-back-left" width="7" height="20"></td>
							<td class="info-title-back-middle"><fmt:message key="blog.blogmanager.employee" /></td>
							<td class="info-title-back-middle_text" align="right">
								<a href="${detailURL}?method=getEmployeeModify" class="hyper_link2">[<fmt:message key="blog.set.label" />]</a>													
							</td>
							<td class="info-title-back-right" width="7"></td>
						</tr>
						<tr>
							<td colspan="4" valign="top">
								<table>
									<tr>
										<td width="50">
                                            <img id="image1" class="radius" src="${v3x:avatarImageUrl(CurrentUser.id)}" width="48" height="48"></img>
										</td>
										<td align="left" valign="bottom">
										<%--  
											<a href="${detailURL}?method=getEmployeeModify" class="hyper_link2">
											<b>${userName}</b>
											</a>
											--%>
											<b>${userName}</b>
											<c:if test="${flagAdmin == '2' }">
												(<fmt:message key='blog.admin.notstart.alert'  />)
											</c:if>
										 </td>
									</tr>				
								</table>
							</td>
						</tr>
						<tr>
							<td colspan="4" style="word-break:break-all" title="${v3x:toHTMLAlt(introduce)}" valign="top">
							${v3x:toHTML(v3x:getLimitLengthString(introduce,80,"..."))}
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td height="24" valign="top">
					<table height="100%" width="100%" border="0"  cellspacing="0"  cellpadding="0" >
						<tr >
							<td class="info-title-back-left" width="7">
							</td>
							<td height="24" class="info-title-back-middle" >	
								<table height="24"  border="0"  cellspacing="0"  cellpadding="0" >
									<tr height="100%">
										<td width="30" class="info-title-back-fav" >
											
										</td>
										<td align="left" valign="middle">
											<a style="font-weight: normal; " href="${detailURL}?method=listAllFavoritesArticle" class="hyper_link2">
												<fmt:message key="blog.favorite.lable" />(${atrnum})</a>
										</td>
									</tr>
								</table>
										
																			
							</td>
							<td class="info-title-back-right" width="7"></td>
							
						</tr>
					</table>
				</td>
			</tr>
			<tr height="145">
				<td valign="top">
					<table  width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="info-title-back-middle"><fmt:message key="blog.otherblog" />																											
							</td>
							<td class="info-title-back-middle_text" align="right">
								<a href="${detailURL}?method=listAllShareOther" class="hyper_link2">[<fmt:message key="blog.attention" />]</a>&nbsp; 													
							</td>
						 </tr>
												
												
				         <c:forEach items="${attentionList}" var="conf">
						     <tr><td colspan="4" height="24" title="${conf.userName}">&nbsp;&nbsp;&nbsp;
						     <a href="javascript:doShareClick('${detailURL}?method=listAllArticle&userId=${conf.attentionId}','${conf.flagStart}')"  class="hyper_link2 cursor-hand">${conf.userName}														 														     
						     
						     </a>
							<c:if test="${!conf.startFlag}">
							 <fmt:message key="blog.admin.notstart.lable"></fmt:message>
							</c:if>
						     </td></tr>
							</c:forEach>
							
						 <c:forEach begin="1" end="${attentionListEmpty}">     	
					        <tr height="24">
					     		<td colspan="4" >&nbsp;&nbsp;</td>
					      	</tr>
					     </c:forEach>  
						 <tr >
							<td valign="middle" align="right" colspan="4"><a href="${detailURL}?method=listShareOtherIndex" class="hyper_link2">[<fmt:message key='common.more.label' bundle="${v3xCommonI18N}" />]</a>&nbsp; 
							</td>
						 </tr>
					</table>
				</td>
			</tr>
			<tr>
				<td valign="top">
					<table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td class="info-title-back-left" width="7"></td>
							<td class="info-title-back-middle"><fmt:message key="blog.calendar" /></td>
							<td class="info-title-back-right" width="7"></td>
								
						</tr>
						<tr valign="top">
							<td colspan="3">
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
									<SCRIPT language=javascript id=Change_js type=text/javascript>
										
										if('${byDateFlag}' == 'true'){
										var theMonth = ${v3x:escapeJavascript(param.month)} - 1; 
										drawCalendar('${v3x:escapeJavascript(param.year)}',theMonth,1);
									        fUpdateCal('${v3x:escapeJavascript(param.year)}',theMonth,'${v3x:escapeJavascript(param.day)}');
										}else{	
										drawCalendar(myYear,myMonthTop-1,1);														
									        fUpdateCal(myYear,myMonthTop-1,myDayOfMonth);
										}
								        
								    </SCRIPT>
					        	</table>
							</td>
						</tr>									
					</table>
				</td>
			</tr>
		</table>
  </div>
  <div class="right_div_cols_l_blog border_all">
    <div class="top_div_cols_l_blog">
    
		<table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="webfx-menu-bar" width="30%">
					<script type="text/javascript">
					
						var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
						myBar.add(new WebFXMenuButton("new", "<fmt:message key="blog.article.new" />",  "homeNew();", [5,7], "", ""));		
						myBar.add(new WebFXMenuButton("updateBlog", "<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />", "homeUpdate()", [1,2], "", null));
						
						myBar.add(new WebFXMenuButton("del", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "homeDel();", [1,3], "", ""));
						document.write(myBar);	
						
						if("${flagAdmin}" == "2"){
							var newMenu = document.getElementById("new");
							if(navigator.appName == "Microsoft Internet Explorer" && navigator.appVersion.indexOf('MSIE 10.0') === -1){
								newMenu.disabled = true;
								newMenu.onclick = "";
								newMenu.onmouseover = "";
								newMenu.onmouseout = "";
							} else {
								newMenu.setAttribute("class","disabled webfx-menu--button");
								newMenu.setAttribute("onmouseover","");
								newMenu.setAttribute("onmouseout","");
								newMenu.setAttribute("onclick","");
							}
						}
					
					</script>						
				</td>
				<td class="webfx-menu-bar">
					<div class="div-float-right">
						<form action="${detailURL}" name="searchForm" id="searchForm" method="get" style="margin: 0px">
							<input type="hidden" value="blogHome" name="method">
							<input type="hidden" value="${userId}" name="userId">
							<input type="hidden" value="true" name="searchFlag">
							
								 <div class="div-float">
									<select name="condition" id="condition" onChange="showNextCondition(this)" class="condition" style="height:22px;">
										<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
										<option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" /></option>
										<option value="issueTime"><fmt:message key="common.issueDate.label" bundle="${v3xCommonI18N}" /></option>
									</select>
								</div>
								<div id="subjectDiv" class="div-float hidden"><input type="text" name="textfield" id="textfield" class="textfield" maxlength="80" onkeydown="doSearchEnter()"></div>
								<div id="issueTimeDiv" class="div-float hidden">
									<input type="text" name="textfield1" id="textfield1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly onkeydown="doSearchEnter()">
									-
									<input type="text" name="textfield2" id="textfield2" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly onkeydown="doSearchEnter()">
								</div>
								<div onclick="javascript:submitSearch()" class="condition-search-button div-float"></div>
						</form>
					</div>					
				</td>
			</tr>
		</table>
    </div>
    <div class="center_div_row2 center_div_cols_l_blog page_color" id="scrollListDiv">
		<form id="listForm" name="listForm" method="post" action="" onsubmit="">
		<input type="hidden" name="selectedIds" id="selectedIds" value="" />
		<input type="hidden" name="selectedFamilyIds" id="selectedFamilyIds" value="" />
		<input type="hidden" name="shareState" id="yes" value = "shi" />
		<c:set value="blog.shareState.label" var="lableValue" />
		<v3x:table htmlId="pending" data="${articleModellist}" var="col" isChangeTRColor="true" showHeader="true">
				<v3x:column width="5%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
					<input type='checkbox' id='id' name='id' value="${col.id}" affairId="${col.id}" familyId="${col.familyId}" v="${col.vForEdit}"/>
				</v3x:column>
		
					<v3x:column  width="50%"   type="String" label="common.subject.label" hasAttachments="${col.attachmentFlag == 1}" >
						<a
							href="javascript:openBlogDetail('?method=showPostIframe&articleId=${col.id}&familyId=${col.familyId}&resourceMethod=blogHome&flag=open&where=other&v=${col.vForList}')"
							class="hyper_link1" title="${col.subject}">
						${col.subject}
						</a>
					</v3x:column>
					<script>
					   var cat = "yes";
					</script>

				   <c:if test = "${col.shareState == 0}">
					<v3x:column width="15%" type="String" align="center"
						label="blog.shareState.label"  ><fmt:message key="blog.share.label" /></v3x:column>
				   </c:if>

					<c:if test = "${col.shareState == 1}" >
    					<v3x:column width="15%" type="String" align="center"
    						label="blog.shareState.label" > <fmt:message key="blog.notshare.label" /></v3x:column> 
					</c:if>   

					<v3x:column width="15%" type="Number" align="center"
						label="blog.replynumber.label" value="${col.replyNumber}" />
		
					<v3x:column width="15%" type="Date" align="left"
						label="common.issueDate.label">
						<fmt:formatDate value="${col.issueTime}" pattern="${dataPattern}" />
					</v3x:column>
				</v3x:table>
		</form>
    </div>
  </div>
</div>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<!-- TR 内容  -->
<tr>
	<td height="100%">
		<div class="scrollList">
		<table height="100%" width="100%" border="0" >
		<tr><td>
		<table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
				<!-- TD 列表  -->
				<td>
					<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="page2-list-border">
					<tr height="22">
						<td>


						</td>
					</tr>
					<tr>
						<td>
							<div class="scrollList ">

							</div>
						</td>
					</tr>
		
		
		</table>
		</td></tr>
		</table>	
					
	</td>
				<!-- TD 其他  -->
				<td width="170">

				</td>
			</tr>
		</table>
		</div>
	</td>
</tr>
</table>
<IFRAME height="0%" name="empty" id="empty" width="0%" frameBorder="0"></IFRAME>
</body>
</html>

<script language="javascript">
    showCtpLocation('F04_blogHome');
</script>