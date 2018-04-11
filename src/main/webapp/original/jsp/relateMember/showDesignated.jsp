<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<%@include file="header.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />">
</head>
<body scroll="no" style="padding: 10px 0px 10px 10px">
	<table align="center" border="0" cellpadding="0" cellspacing="0" width="100%" class="sort border-top border-left border-right border-bottom">
		<thead class="mxt-grid-thead">
		<tr>
			<td width="10%" align="center" class="sort">
				<label for="all">
					<input type="checkbox" onclick="selectAll(this, 'designated')">
				</label>
			</td>
			<td class="sort">
				<fmt:message key="common.resource.body.name.label" bundle="${v3xMainI18N}"/>
			</td>
		</tr>
		</thead>
		<tbody class="mxt-grid-tbody">
		<tr>
			<td align="center" class="sort">
				<label for="leader">
					<input id="leader" name="designated" type="checkbox" value="1">
				</label>
			</td>
			<td class="sort">
				<fmt:message key="relate.type.leader"/>
			</td>
		</tr>
		<tr>
			<td align="center" class="sort">
				<label for="junior">
					<input id="junior" name="designated" type="checkbox" value="3">
				</label>
			</td>
			<td class="sort">
				<fmt:message key="relate.type.junior"/>
			</td>
		</tr>
		<tr>
			<td align="center" class="sort">
				<label for="assistant">
					<input id="assistant" name="designated" type="checkbox" value="2">
				</label>
			</td>
			<td class="sort">
				<fmt:message key="relate.type.assistant"/>
			</td>
		</tr>
		<tr>
			<td align="center" class="sort">
				<label for="confrere">
					<input id="confrere" name="designated" type="checkbox" value="4">
				</label>
			</td>
			<td class="sort">
				<fmt:message key="relate.type.confrere"/>
			</td>
		</tr>
		</tbody>
	</table>
</div>
</body>
<script type="text/javascript">

var types=window.dialogArguments;
var chesks=document.getElementsByName("designated");
for(var i=0;i<chesks.length;i++){
	var str=chesks[i].value;
	if(types&&types.indexOf(str)>=0){
		chesks[i].checked='checked';
	}
}
function OK(){
	var ids = [];
	var names = [];
	var designated = document.getElementsByName("designated");
	if(designated){
		for(var i = 0; i < designated.length; i++){
			if(designated[i] && designated[i].checked){
				ids[ids.length] = designated[i].value;
			}
		}
	}
	return [ids, names];
}

window.onload = function (){
	var values = window.dialogArguments;
	var designated = document.getElementsByName("designated");
	if(designated && values){
		for(var i = 0; i < designated.length; i ++){
			var valuestr = values.split(",");
			for(var j = 0; j < valuestr.length; j ++){
				if(valuestr[j] == designated[i].value){
					designated[i].checked = true;
				}
			}
		}
	}
}
</script>
</html>