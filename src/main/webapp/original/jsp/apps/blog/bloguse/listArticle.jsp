<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<title></title>
<%@ include file="../header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript">
<!--
	function submitSearch(){
		var theForm = document.getElementsByName("searchForm")[0];
		var condition = document.getElementById("condition").value;
	 	var textfield1 = theForm.textfield1.value;
		var textfield2 = theForm.textfield2.value
		
		if (theForm){ 
		   if ( condition == ''||condition == null){
		   alert('<fmt:message key="blog.condition.select" />');
		}else if(textfield1>textfield2 && textfield2 != ''){
		   alert('<fmt:message key="blog.search.alert.time" />');
		}else {
           theForm.submit();
        }
        }
        else if (!theForm){
        	return;
        }
	}

	window.onload = function(){

		var condition = '${condition}';
	//	alert("condition = " + condition);
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
	
	function showFrame(){	
		getA8Top().showFrameWin = getA8Top().$.dialog({
            title:" ",
            transParams:{'parentWin':window},
            url: "${detailURL}?method=getCalendar&userId=${userId}&type=0",
            width: 200,
            height: 150,
            isDrag:false
        });
	}	
	
	function openBlogDetail(_url) {		
		getA8Top().showFrameWin = getA8Top().$.dialog({
            title:" ",
            top:20,
            width:screen.width - 100,
            height:screen.height - 200,
            transParams:{'parentWin':window},
            url: genericURL + _url,
            isDrag:false
        });
	}
	
	function openBlogDetailCallBack (rv){
		getA8Top().showFrameWin.close();
		if(rv && 'false' == rv)
	        window.location.reload(true);
	}
	
	
//-->
</script>
<style>
/***layout*row1+row2***/
.main_div_row2 {
 width: 100%;
 height: 100%;
 _padding-left:0px;
}
.right_div_row2 {
 width: 100%;
 height: 100%;
 _padding:90px 0px 0px 0px;
}
.main_div_row2>.right_div_row2 {
 width:auto;
 position:absolute;
 left:0px;
 right:0px;
}
.center_div_row2 {
 width: 100%;
 height: 100%;
 /*background-color:#00CCFF;*/
 overflow:auto;
}
.right_div_row2>.center_div_row2 {
 height:auto;
 position:absolute;
 top:90px;
 bottom:0px;
}
.top_div_row2 {
 height:90px;
 width:100%;
 position:absolute;
 top:0px;
}
/***layout*row1+row2****end**/
.border_lr{
  border-left: 1px solid #b6b6b6;
  border-right: 1px solid #b6b6b6;
}
</style>

</head>
<body>
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" height="100%" >
		<tr>
			<td width="100%" height="60">
				 <table width="100%" border="0" cellpadding="0" cellspacing="0" class="main-bg">
				        <tr>
							<td width="56">
								<div style=" height: 56px; text-align: center;">
									<div style="width: 50px; height: 50px; margin-top: 2px; text-align: center;">
                                        <img id="image1" src="${v3x:avatarImageUrl(param.userId)}" width="48" height="48"></img>
									</div>
								</div>
							</td>
							<td id="notepagerTitle1" class="page2-header-bg" nowrap="nowrap"><span style="color:#000000;font-size:10pt;" title="${v3x:toHTML(introduce)}">&nbsp;&nbsp;${userName}&nbsp;&nbsp;${v3x:toHTML(v3x:getLimitLengthString(introduce,32,"..."))}</span></td>
							<td class="" align="right">
								<c:if test="${flagAdmin == '2' }">
								<fmt:message key="blog.admin.notstart.alert" />
								</c:if>
								<c:if test="${flagAdmin == 1}">
									<a href="${detailURL}?method=blogNew" class="hyper_link2">[
									<fmt:message key="blog.article.new" />]</a>&nbsp; 				
								</c:if>
								<a href="${detailURL}?method=listShareOtherIndex" class="hyper_link2">[
								<fmt:message key="blog.otherblog" />]</a>&nbsp; 
								<a href="${detailURL}?method=listAllFavoritesArticle" class="hyper_link2">[
								<fmt:message key="blog.family.favorites" />]</a>&nbsp; 
								<a href="${detailURL}?method=getEmployeeModify" class="hyper_link2">[
								<fmt:message key="blog.blogmanager.employee" />]</a>&nbsp; 
							</td>
				      </tr>
				 </table>
			</td>
		</tr>
		<tr>
		<td height="100%">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="page2-list-border">	
			<tr>
				<td valign="top">
					<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
							<td width="65%" align="left" valign="middle" height="26" class="webfx-menu-bar padding5" >
								<a href="javascript:showFrame()">
								[<fmt:message key="blog.search.bydate" />]</a>
							</td>
								<td width="35%" height="26" class="webfx-menu-bar">
									<div class="div-float-right">
		
									<form action="${detailURL}" name="searchForm" id="searchForm" method="get" style="margin: 0px">
										<input type="hidden" value="searchArticle" name="method">
										<input type="hidden" value="${userId}" name="userId">
										<input type="hidden" value="true" name="searchFlag">
                                            <div class="div-float" style="margin-top: 2px;">
												<select id="condition" name="condition"  id="condition" onChange="showNextCondition(this)" class="condition">
													<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
													<option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" /></option>
													<option value="issueTime"><fmt:message key="common.issueDate.label" bundle="${v3xCommonI18N}" /></option>
												</select>
											</div>
											<div id="subjectDiv" class="div-float hidden"><input type="text" id="textfield" name="textfield" class="textfield"></div>
											<div id="issueTimeDiv" class="div-float hidden">
												<input type="text" id="textfield1" name="textfield1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
												-
												<input type="text" id="textfield2" name="textfield2" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
											</div>
											<div onclick="javascript:submitSearch()" class="condition-search-button"></div>
									</form>
									</div>
								</td>
							</tr>
					</table>
				</td>
			</tr>
		</table>
		</td>
		</tr>
		</table>
    </div>
    <div class="center_div_row2" id="scrollListDiv">
		<form name="listForm" method="post" action="" onsubmit="">
			<v3x:table htmlId="pending" data="${articleModellist}" var="col" isChangeTRColor="false" showHeader="true">
				<v3x:column width="5%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
					<input type='checkbox' name='id' value="${col.id}" affairId="${col.id}" />
				</v3x:column>
				<v3x:column width="75%" type="String" label="common.subject.label" hasAttachments="${col.attachmentFlag == 1}" >

					<a
						href="javascript:openBlogDetail('?method=showPostIframe&articleId=${col.id}&familyId=${col.familyId}&resourceMethod=listAllArticle&flag=open&where=other&v=${col.vForList}')"
						class="hyper_link1" title="${col.subject}">
					${col.subject}	
					</a>
				</v3x:column>
				<v3x:column width="10%" type="Number" align="center"
					label="blog.replynumber.label" value="${col.replyNumber}" />
	
				<v3x:column width="10%" type="Date" align="left"
					label="common.issueDate.label">
					<fmt:formatDate value="${col.issueTime}" pattern="${dataPattern}" />
				</v3x:column>
			</v3x:table>
		</form>
    </div>
  </div>
</div>





</body>
</html>
