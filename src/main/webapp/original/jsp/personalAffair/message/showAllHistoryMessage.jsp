<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="header.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/xtree/xtree.js${v3x:resSuffix()}"/>"></script>
<link type="text/css" rel="stylesheet" href="<c:url value="/common/js/xtree/xtree.css${v3x:resSuffix()}" />"/>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/> 
<style>
.main_div_row3 {
 width: 100%;
 height: 100%;
 _padding-left:0px;
}
.right_div_row3 {
 width: 100%;
 height: 100%;
 _padding:30px 0px 30px 0px;
}
.main_div_row3>.right_div_row3 {
 width:auto;
 position:absolute;
 left:0px;
 right:0px;
}
.center_div_row3 {
 width: 100%;
 height: 100%;
 /*background-color:#00CCFF;*/
 overflow:auto;
 overflow-x:hidden; 
}
.right_div_row3>.center_div_row3 {
 height:auto;
 position:absolute;
 top:30px;
 bottom:30px;
}
.top_div_row3 {
 height:30px;
 width:100%;
 background-color:#dfdede;
 position:absolute;
 top:0px;
}
.bottom_div_row3 {
 height:30px;
 width:100%;
 /*background-color:#FF9900;*/
 position:absolute;
 bottom:0px;
 _bottom:-1px; /*-- for IE6.0 --*/
}
.mxtgrid div.bDiv{position:absolute;}
.mxtgrid div.bDiv td.sort{padding-left:12px;border-width:1px 0;}
.meeting{background: #ffffff}
</style>
</head>
<body style="overflow: hidden;">
<div class="main_div_row3">
  <div class="right_div_row3">
    <div class="top_div_row3">
		<table cellpadding="0" cellspacing="0" width="100%" height="100%">
			<tr>
				<td colspan="2" valign="middle" style="padding-left:12px;">
					<input type='checkbox' name='id' onclick="selectAllCheck(this)" value='0' style="vertical-align:middle;"/><span class="date_date"><fmt:message key="online.selectall.label" bundle="${v3xSysI18N}"/></span>
				</td>
			</tr>
		</table>
    </div>
    <div class="center_div_row3" id="center_div_row3">
		<table cellpadding="0" cellspacing="0" width="100%" className="sort ellipsis">
			<c:forEach items="${map}" var="mymap" varStatus="index">
				<c:set var="_key" value="${mymap.key}"/>
				<c:set var="_array" value="${mymap.value}"/>
				<tr>
					<td height="30" valign="middle" colspan="2" style="border-bottom:1px solid #fff;">
						<span class="date_date"><fmt:message key="online.date.label" bundle="${v3xSysI18N}"/>:${_key}</span>
					</td>
				</tr>
				<tr>
					<td colspan="2" height="1" valign="top" class="splitLine"  style="border:none;">
						<hr class="date_line"/>					
					</td>
				</tr>
				<c:forEach items="${_array}" var="msg" >
					<tr class="${msg.isRead?'date_read':'date_no_read'}">
						<td align="center" width="30" valign="top" class="splitLine sort">
							<input type='checkbox' name='id' class="date_chaek" value="${msg.id}" />
						</td>
						<td class="splitLine sort">
							<div class="date_header">
								<span class="date_sender">
									${msg.senderName}
									<c:if test="${param.sort == 'true'}">
										<font style="color: #CCC;">
											<c:if test="${msg.messageType == 2}">
												(${v3x:getDepartment(msg.referenceId).name})
											</c:if>
											<c:if test="${msg.messageType == 3 || msg.messageType == 4 || msg.messageType == 5}">
												(${v3x:toHTML(v3x:getTeam(msg.referenceId).name)})
											</c:if>
										</font>
									</c:if>
								</span>
								<span class="date_time">
									<fmt:formatDate value="${msg.creationDate}" pattern="yyyy-MM-dd HH:mm:ss" />
								</span>
								<c:if test="${msg.receiverId == v3x:currentUser().id}">
									<c:set value="sendMessage('${msg.senderId}')" var="onClick" />
								</c:if>
								<c:if test="${msg.senderId == v3x:currentUser().id}">
									<c:set value="sendMessage('${msg.receiverId}')" var="onClick" />
								</c:if>
								<span id="reply${msg.id}" onclick="${onClick}" style="padding-left: 50px;" class="like-a"><fmt:message key="message.person.reply.label"/></span>
							</div>
							<div class="date_content">
								${msg.messageContent}
							</div>
						</td>
					</tr>							
				</c:forEach>
			</c:forEach>
		</table>
    </div>
    <div class="bottom_div_row3" id="bottom_div_row3">
    <form id="form1" name="form1" action="" method="post">
		<table cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td class="table_footer" nowrap="nowrap" align="right">
					<script type="text/javascript">
					<!--
						var pageFormMethod = "get"
						var pageQueryMap = new Properties();
						pageQueryMap.put('method', "showAllHistoryMessage");
						pageQueryMap.put('_spage', '');
						pageQueryMap.put('page', '${page}');
						pageQueryMap.put('count', "${size}");
						pageQueryMap.put('pageSize', "${pageSize}");
						pageQueryMap.put('type', "${param.type}");
						pageQueryMap.put('id', "${param.id}");
						pageQueryMap.put('area', "${param.area}");
						pageQueryMap.put('time', "${param.time}");
						pageQueryMap.put('content', "${param.content}");
						pageQueryMap.put('search', "${param.search}");
						pageQueryMap.put('sort', "${param.sort}");
					//-->
					</script>
					<fmt:message key='taglib.list.table.page.html' bundle="${v3xCommonI18N}">
						<fmt:param ><input type="text" maxlength="3" class="pager-input-25-undrag" value="${pageSize}" name="pageSize" onChange="pagesizeChange(this)" onkeypress="enterSubmit(this, 'pageSize')"></fmt:param>
						<fmt:param>${pages}</fmt:param>
						<fmt:param>${size}</fmt:param>
						<fmt:param>
							<c:choose>
								<c:when test="${page == 1 && size > pageSize}">
									<!a href="javascript:first(this)"><fmt:message key='taglib.list.table.page.first.label' bundle="${v3xCommonI18N}" /></!a>
									<!a href="javascript:prev(this)"><fmt:message key='taglib.list.table.page.prev.label' bundle="${v3xCommonI18N}" /></!a>
									<a href="javascript:next(this)"><fmt:message key='taglib.list.table.page.next.label' bundle="${v3xCommonI18N}" /></a>
									<a href="javascript:last(this, '${pages }')"><fmt:message key='taglib.list.table.page.last.label' bundle="${v3xCommonI18N}" /></a>
								</c:when>
								<c:when test="${page == pages && size > pageSize}">
									<a href="javascript:first(this)"><fmt:message key='taglib.list.table.page.first.label' bundle="${v3xCommonI18N}" /></a>
									<a href="javascript:prev(this)"><fmt:message key='taglib.list.table.page.prev.label' bundle="${v3xCommonI18N}" /></a>
									<!a href="javascript:next(this)"><fmt:message key='taglib.list.table.page.next.label' bundle="${v3xCommonI18N}" /></!a>
									<!a href="javascript:last(this, '${pages }')"><fmt:message key='taglib.list.table.page.last.label' bundle="${v3xCommonI18N}" /></!a>
								</c:when>
								<c:when test="${page != pages && page != 1 && size > pageSize}">
									<a href="javascript:first(this)"><fmt:message key='taglib.list.table.page.first.label' bundle="${v3xCommonI18N}" /></a>
									<a href="javascript:prev(this)"><fmt:message key='taglib.list.table.page.prev.label' bundle="${v3xCommonI18N}" /></a>
									<a href="javascript:next(this)"><fmt:message key='taglib.list.table.page.next.label' bundle="${v3xCommonI18N}" /></a>
									<a href="javascript:last(this, '${pages }')"><fmt:message key='taglib.list.table.page.last.label' bundle="${v3xCommonI18N}" /></a>
								</c:when>
								<c:otherwise>
									<!a href="javascript:first(this)"><fmt:message key='taglib.list.table.page.first.label' bundle="${v3xCommonI18N}" /></!a>
									<!a href="javascript:prev(this)"><fmt:message key='taglib.list.table.page.prev.label' bundle="${v3xCommonI18N}" /></!a>
									<!a href="javascript:next(this)"><fmt:message key='taglib.list.table.page.next.label' bundle="${v3xCommonI18N}" /></!a>
									<!a href="javascript:last(this, '${pages }')"><fmt:message key='taglib.list.table.page.last.label' bundle="${v3xCommonI18N}" /></!a>
								</c:otherwise>
							</c:choose>
						</fmt:param>
						<fmt:param>
							<input type="text" maxlength="10" class="pager-input-25-undrag" value="${page}" onChange="pageChange(this)" pageCount="${size}" onkeypress="enterSubmit(this, 'intpage')">
						</fmt:param>
					</fmt:message>
					<input type="button" value="go" class="go_undrag" onclick="pageGo(this)">
				</td>
			</tr>
		</table>
	</form>
    </div>
  </div>
</div>
</body>
</html>
<script type="text/javascript">
function focusArea(id){
	 var o = document.getElementById(id);
	 if(o){
		 o.focus();
	 }
}

function keyDownSubmit(ev,id){
	 var o = document.getElementById(id);
	 if(o){
		 ev  =  ev  ||  window.event;
		 if(ev.keyCode==13 && ev.ctrlKey){
			o.click();
		}	
	 }
}

function selectAllCheck(obj){
	var checks = document.getElementsByName('id');
	if(checks==null || checks.length==0){return;}
	var _v = obj.value;
	if(_v == '0'){
		for(var i= 0;i<checks.length;i++){
			checks[i].checked = true;
		}
		obj.value = '1';
	}else{
		for(var i= 0;i<checks.length;i++){
			checks[i].checked = false;
		}
		obj.value = '0';
	}
}
var oHeight = parseInt(document.body.clientHeight);
document.getElementById('center_div_row3').style.height = (oHeight-92)+"px";
document.getElementById('bottom_div_row3').style.bottom = "30px";
</script>