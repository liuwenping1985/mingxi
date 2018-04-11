<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../common/common.jsp" %>

<html:link renderURL='/meetingroom.do' var='mrUrl' />
<html>
<head>
<%@ include file="../../migrate/INC/noCache.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">

function showMoreReply() {
	if(document.getElementById("more").getAttribute("isAll")=="false") {
		document.getElementById("more").setAttribute("isAll", 'true');
		$("tr[isMore='true']").each(function(i) {
			$(this).show();
		});
	} else {
		document.getElementById("more").setAttribute("isAll", 'false');
		$("tr[isMore='true']").each(function(i) {
			$(this).hide();
		});
	}
}

</script>
</head>
<body scroll=no>

	<%-- 已废
	<table border="1" width="100%">
		<thead>
			<tr>
				<td colspan="2" >会议总人数:${fn:length(allList)},不参加人数:${fn:length(notJoinList)}</td>
			</tr>
		</thead>
		<tbody>
			<tr >
				<td>
					<table border="0">
						<tr>
							<td valign="top">参加:${fn:length(joinList)}</td>
						</tr>
						<c:forEach items="${joinList }" var="affair" varStatus="i">
							<tr isMore="${i.index>4}" style="display:${i.index>4?'none':''}">	<td>${v3x:showMemberName(affair.memberId)}</td></tr>
						</c:forEach>
					</table>
				</td>
				<td>
					<table border="0">
						<tr><td>待回执：${fn:length(waitJoinList)}</td></tr>
						<c:forEach items="${waitJoinList }" var="affair" varStatus="i">
							<tr isMore="${i.index>4}" style="display:${i.index>4?'none':''}"><td>${v3x:showMemberName(affair.memberId)}</td></tr>
						</c:forEach>
					</table>
				</td>
			</tr>
			<tr>
				<td colspan="2" align="right">更多<a id="more" isAll="false" href="javascript:showMoreReply()">>></a></td>
			</tr>
		</tbody>
	</table>
	 --%>

</body>
</html>