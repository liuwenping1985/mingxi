<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">

	function getSelectIds(frame) {
		var ids = frame.document.getElementsByName('id');
		
		var id = '';
		for ( var i = 0; i < ids.length; i++) {
			var idCheckBox = ids[i];
			if (idCheckBox.checked) {
				id = id + idCheckBox.value + ',';
			}
		}
		return id;
	}
	function add() {
		parent.listAndDetailFrame.detailFrame.location.href = "${urlNCSynchron}?method=addConfig";
	}
	function modify() {
		var id = getSelectIds(parent.listAndDetailFrame.listFrame);
		var ids = id.split(",");
		if (ids.size() == 2) {
			var idStrs = ids[0].split("+");
			if (idStrs[2] == null || idStrs[2] == '') {
				alert("<fmt:message key='u8.orgcorp.isseal'/>");
				return;
			}
			parent.listAndDetailFrame.detailFrame.location.href = "${urlNCSynchron}?method=editConfig&orgId="
					+ idStrs[0]
					+ "&type="
					+ idStrs[1]
					+ "&ncId="
					+ idStrs[2]
					+ "&edit=2";
		} else if (ids.size() > 2) {
			alert("<fmt:message key='u8.common.message.add.moreSelect'/>");
			return false;
		} else {
			alert("<fmt:message key='u8.common.message.add.notSelect'/>");
			return false;
		}
	}

	function remove12(){
	var ids = parent.listAndDetailFrame.listFrame.document.getElementsByName('id');
		var id = '';
		for ( var i = 0; i < ids.length; i++) {
			var idCheckBox = ids[i];
			if (idCheckBox.checked) {
				id = id + idCheckBox.value + ',';
			}
		}
		if(id==''){
			alert("<fmt:message key='u8.common.message.del.one'/>");
			return false;
		}
		if (!confirm("<fmt:message key='u8.common.message.del.confirm'/>")){
			return false;
		}
		document.location.href = "${urlNCSynchron}?method=delConfig&id="+ id;
	}
</script>
</head>
<body>
<span id="nowLocation"></span>
<table height="26" class="border-left border-right" width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="26" class="border-top">
		<script type="text/javascript" id="writeBar">
			var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />", "");
			myBar.add(new WebFXMenuButton("add","<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}'/>","add()","<c:url value='/common/images/toolbar/new.gif'/>", "",null));
			myBar.add(new WebFXMenuButton("mod","<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}'/>","modify()","<c:url value='/common/images/toolbar/update.gif'/>","", null));
			myBar.add(new WebFXMenuButton("del","<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}'/>","remove12()","<c:url value='/common/images/toolbar/delete.gif'/>","", null));
			document.write(myBar);
	    	document.close();
	    	</script>
    	</td>
	</tr>
</table>
</body>
</html>