<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<%@include file="projectHeader.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link type="text/css" rel="stylesheet" href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />">
</head>
<body srcoll="no" style="padding: 10px 0px 10px 10px">
	<table align="center" border="0" cellpadding="0" cellspacing="0" width="100%" class="sort border-top border-left border-right border-bottom">
		<thead class="mxt-grid-thead">
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
				<label for="manger">
					<input id="manger" name="designated" type="checkbox" value="1">
				</label>
			</td>
			<td class="sort">
				<fmt:message key="project.body.manger.label"/>
			</td>
		</tr>
		<tr>
			<td align="center" class="sort">
				<label for="responsible">
					<input id="responsible" name="designated" type="checkbox" value="0">
				</label>
			</td>
			<td class="sort">
				<fmt:message key="project.body.responsible.label"/>
			</td>
		</tr>
		<tr>
			<td align="center" class="sort">
				<label for="assistant">
					<input id="assistant" name="designated" type="checkbox" value="5">
				</label>
			</td>
			<td class="sort">
				<fmt:message key="project.body.assistant.label"/>
			</td>
		</tr>
		<tr>
			<td align="center" class="sort">
				<label for="members">
					<input id="members" name="designated" type="checkbox" value="2">
				</label>
			</td>
			<td class="sort">
				<fmt:message key="project.body.members.label"/>
			</td>
		</tr>
		<tr>
			<td align="center" class="sort">
				<label for="related">
					<input id="related" name="designated" type="checkbox" value="3">
				</label>
			</td>
			<td class="sort">
				<fmt:message key="project.body.related.label"/>
			</td>
		</tr>
		</tbody>
	</table>
</div>
</body>
<script type="text/javascript">
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
	var values = parent.paramValue;
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