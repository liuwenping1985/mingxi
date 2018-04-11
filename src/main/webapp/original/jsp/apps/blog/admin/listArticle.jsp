<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="../header.jsp"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
<!--
	
	function doReturn(){
		document.fm.action="${detailURL}?method=listLatestFiveArticleAndAllBoard";
		document.fm.submit();
	}

	function submitSearch(){	
		var theForm = document.getElementsByName("searchForm")[0];
		if (!theForm) {
        	return;
    	}
		theForm.submit();
	}

	function showFrame(){
		var item = {
				'callBackFun':showFrameCallBackFun
		}
		var t = whenstart("${pageContext.request.contextPath}",null,575,140,'',false,320,320,item);
		if(typeof(t) != 'undefined' && t != null && t != '' && v3x.getBrowserFlag('openWindow')){
			var arry = t.split('-');
			window.location.href ="${detailURL}?method=searchArticle&userId=0&condition=byDate&year="+arry[0]+"&month="+arry[1]+"&day="+arry[2]+"";
	   	}
	}
	
	function showFrameCallBackFun (returnValue) {
		if(typeof(returnValue) != 'undefined' && returnValue != null && returnValue != ''){
            var arry = returnValue.split('-');
            window.location.href ="${detailURL}?method=searchArticle&userId=0&condition=byDate&year="+arry[0]+"&month="+arry[1]+"&day="+arry[2]+"";
        }
	}
	
    function openBlogDetail(_url) {
        getA8Top().openBlogDetailWin = getA8Top().$.dialog({
            title:" ",
            transParams:{'parentWin':window},
            url: genericURL + _url,
            width: window.screen.width,
            height: document.body.clientHeight,
            isDrag:false
        });
    }
    
    function openBlogDetailCallBack (rv){
    	getA8Top().openBlogDetailWin.close();
    	if(rv && 'false' == rv) {
            window.location.reload(true);
    	}
    }
//-->
</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"> 
${v3x:skin()}
<style type="text/css">
.right_div_row2 > .center_div_row2{
top: 30px;
}

</style>
</head>
<body scroll="no">
<div id="nowLocation"></div>
<div class="main_div_row2">
 <div class="right_div_row2">
    <div style="width: 100%">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="bbs-table">
						<tr class="page2-header-line">
							<td class="page2-header-bg">
			                    <span style="font-weight:bold;"><fmt:message key="blog.blogmanager.label" /></span>
								</td>
								<td align="right">
    								<a href="${detailURL}?method=organizationFrame&from=head" 
    										style="color: #000000;margin-right: 5px">
    									[<fmt:message key="blog.blogmanager.enable" />]
    								</a>&nbsp;
    								<a onClick="javascript:showFrame()" style="color: #000000;margin-right: 5px">
    									[<fmt:message key="blog.search.bydate" />]
    								</a>
							</td>						
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>		
	<div class="center_div_row2" id="scrollListDiv">
		<form name="listForm" method="post" action="" onSubmit="">
			<v3x:table
				htmlId="pending" data="${articleModellist}" var="col"
				isChangeTRColor="false" showHeader="true" className="sort ellipsis">
			<v3x:column width="15%" type="String" label="org.member_form.name.label" value="${col.userName}">
				</v3x:column>

				<v3x:column width="50%" type="String" label="common.subject.label">
					
					<a 
						href="javascript:openBlogDetail('?method=showPostIframe&articleId=${col.id}&familyId=${col.familyId}&resourceMethod=listAllArticle&flag=open&where=admin&v=${col.vForList}')"
						class="hyper_link1" title="${col.subject}">
					${col.subject}	
					</a>
					<c:if test="${col.attachmentFlag==1}">
						<span style="height:26px;line-height:26px;"><img src="<c:url value='/apps_res/blog/images/acc.gif'/>" align="absmiddle"></span>
					</c:if>
				</v3x:column>
				<v3x:column width="10%" type="Number" align="center"
					label="blog.clicknumber.label" value="${col.clickNumber}" />
	
				<v3x:column width="10%" type="Number" align="center"
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
</body>
</html>
<script language="javascript">
  showCtpLocation('F04_listAllArticleAdmin');
</script>