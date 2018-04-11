<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="inquiryHeader.jsp"%>
<html>
<head>
	<title>${ctp:i18n("metadataDef.category.inquiry")}</title>
	<meta charset="UTF-8">
	<title>${ctp:i18n('inquiry.inquiryIndex')}</title><%--i18 调查首页 --%>
	${v3x:skin()}
	<script type="text/javascript">
		var _path = '${path}';
		var ajax_inquiryManager = new inquiryManager();
		function OK(){
			var obj={};
			obj.ids = $("#ids").val();
			obj.typeId = $("input:checked").val();
			return obj;
		}
	</script>

</head>
<body scroll='no' onkeydown="listenerKeyESC()" id="typeBody" style="overflow: hidden;">
<form name="sendForm" action="" method="post" >
	<input type="hidden" value="moveToType" name="method">
	<input type="hidden" id="ids" name="ids" value="${ids}"/>
	<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td class="bg-advance-middel">
				<div style="border: solid 1px #666666;overflow:auto;height:265px ;background-color:rgb(255, 255, 255)" id="listDiv">
					<table class="sort" width="100%"  border="0" cellspacing="0" cellpadding="0" onClick="sortColumn(event, true)">
						<thead>
						<tr class="sort">
							<td type="String" colspan="2">${ctp:i18n("inquiry.categoryName.label")}</td>
						</tr>
						</thead>
						<tbody>
						<c:forEach items="${typeList}" var="typeData">
							<tr class="sort" align="left">
								<td align="center" class="sort" width="5%">
									<input type="radio" name="typeName" value="${typeData.id}" extAttribute1="${typeData.accountId}"/>
								</td>
								<td class="sort" type="String">
										${v3x:toHTML(typeData.typeName)}
								</td>
							</tr>
						</c:forEach>
						</tbody>
					</table>
				</div>
			</td>
		</tr>
	</table>
</form>
<script type="text/javascript" >
	$(document).ready(function() {
//		$('#listDiv').height($('#typeBody').height()-100);
		$('input:radio:first').attr("checked",'checked');
	});
</script>
</body>
</html>