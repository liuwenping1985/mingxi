<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="../../common/common.jsp"%>
<script type="text/javascript">
	function createOption(value, text) {
		var option = document.createElement("option");
		option.value = value;
		option.text = text;
		return option;
	}
	$().ready(function() {
		var memberDataBody = document.getElementById("memberDataBody");
		<c:forEach items="${dataMap}" var="data">
		memberDataBody.add(createOption("${data.key}", "${data.key}"));
		</c:forEach>

	});
	function doSelect() {
		var memberDataBody = document.getElementById("memberDataBody");
		var listSelect = document.getElementById("ListSelect");
		var items = memberDataBody.options;
		if (items != null && items.length > 0) {
			var selectIndex = -1;
			for (var i = 0; i < items.length; i++) {
				var item = items[i];
				if (item.selected) {
					selectIndex = item.index;
					listSelect.add(createOption(item.value, item.text));
					break;
				}
			}
			if (selectIndex != -1) {
				memberDataBody.remove(selectIndex);
				doSelect();
			}
		}
	}

	function doremove() {
		var memberDataBody = document.getElementById("memberDataBody");
		var listSelect = document.getElementById("ListSelect");
		var items = listSelect.options;
		if (items != null && items.length > 0) {
			var selectIndex = -1;
			var item;
			for (var i = 0; i < items.length; i++) {
				item = items[i];
				if (item.selected) {
					selectIndex = item.index;
					break;
				}
			}
			if (selectIndex != -1) {
				listSelect.remove(selectIndex);
				memberDataBody.add(createOption(item.value, item.text));
				doremove();
			}
		}
	}

	function doremove1() {
		var listSelect = document.getElementById("ListSelect");
		var items = listSelect.options;
		if (items != null && items.length > 0) {
				doremove();
		}
	}

	function OK() {
		var items = document.getElementById("ListSelect").options;

		if (items == null || items.length == 0) {
			alert("${ctp:i18n('formtalk.alert.tip.one')}");
			return;
		}
		if (items == null || items.length > 1) {
			alert("${ctp:i18n('formtalk.alert.tip.maxone')}");
			return;
		}
	
		if (items != null && items.length > 0) {
			for (var i = 0; i < items.length; i++) {
				var item = items[i];
				return item.value;
			}
		}

	}

</script>
</head>
<body scroll="no">

	<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="popupTitleRight">
		<tr align="center">
			<td height="8" class="popupTitleRight"></td>
			<td align="left" class="PopupTitle"></td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0">
					<tr>
                        <td width="3%" align="center">&nbsp;</td>
						<td valign="top" width="45%" align="left" height="100%">
							<select id="memberDataBody" ondblclick="doSelect()"
							multiple="multiple" style="width: 250px;height:400px" size="1">
						</select>
						</td>
						<td width="3%" align="center" valign="top">
						   <br />
						   <br />
						   <br />
						   <br />
						   <br />
					  <br />
						   <br />
						   <br />
							<p><a href="#">
								<img src="<c:url value='/common/SelectPeople/images/arrow_a.gif'/>" alt="${ctp:i18n('formtalk.jsp.Movetoright')}"
									width="24" height="24"  onClick="doSelect()"></a>
							</p> 
							<p><a href="#">
								<img src="<c:url value='/common/SelectPeople/images/arrow_del.gif'/>" alt="${ctp:i18n('formtalk.jsp.Movetoleft')}"
									width="24" height="24" onClick="doremove1()"></a>
							</p>
							
						</td>
							<td valign="top" align="left"  width="45%" height="100%"><select
								id="ListSelect" name="ListSelect" ondblclick="doremove1()"
								multiple="multiple" style="width: 250px;height:400px" size="1">
							</select></td>
						<td width="2%" align="center">&nbsp;</td>
					</tr>
				</table>
			</td>
		</tr>

	</table>

</body>
</html>