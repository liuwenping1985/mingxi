<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='edoc.custom.classification'/></title>
<%@ include file="edocHeader.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/collaboration/js/batch.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/customerType.js" />"></script>
<script>
function viewUserCustomerType(){
		//显示用户自定义的 类别列表
		$("#customerType input[@type=checkbox]").each(function(){
			<c:forEach items= "${customerTypeList}" var="type">
				
				if(this.value == '${type.typeId}_${type.typeName}_${type.typeCode}'){
					$(this).attr("checked","true");
				}
				
			</c:forEach>
		});

		if(document.getElementById("doc_data")){
			$("#doc_data input[@type=checkbox]").each(function(){
				this.disabled = true;
			});
			
			$("#doc_data input[@type=checkbox]").each(function(){
				if(this.checked){
					var c = $(this).parent("td").parent("tr").find("input[@type=radio]")[0];
					if(c){
						c.checked = true;
					}
					var d = $(this).parent("td").parent("tr").find("input[@type=checkbox]");
					for(i=0;i<d.length;i++){
						d[i].disabled = false;
					}

					if(c.id.substring(0,1) == 3){
						var a = $(".ct input[@type=checkbox]");
						for(i=0;i<a.length;i++){
							a[i].disabled = false;
						}
					}
				}
			});

			var cc = $(".ct input[@type=checkbox]");
			if(cc){
				if(cc[cc.length-1].checked){
					document.getElementById("r3").checked = true;
					for(i=0;i<cc.length;i++){
						cc[i].disabled = false;
					}
				}
			}
		}
		
	}

function selectone(gtype,obj){
	//当勾选上时，要将它其他的兄弟节点复选框都不勾选
	/*
	var a;
	if(gtype == 'generalType'){
		a = $(obj).parent("td").parent("tr").find("input");
	}else{
		a = $(".ct input");
	}
	if(obj.checked){
		for(i=0;i<a.length;i++){
			if(a[i].value != obj.value){
				a[i].checked = false;
			}
		}
	}

	
	$("#doc_data input[@type=checkbox]").each(function(){
		if(this.id.substring(0,1) != obj.id.substring(0,1)){
			this.checked = false;
		}
	});
	*/
} 


function selectRadio(id){
	$("#doc_data input[@type=checkbox]").each(function(){
		if(this.id.substring(0,1) != id){
			this.checked = false;
			this.disabled = true;
		}else{
			this.checked = true;
			this.disabled = false;
		}
	});
}

</script>


</head>
<body>
<form name="myForm"
	action="${pageContext.request.contextPath}/edocController.do?method=saveCustomerTypes&edocType=${edocType}&isAdminSet=${param.isAdminSet}"
	method="post">
<input type="hidden" name="from" value="${param.from }"/>
<table align="center" class="popupTitleRight" width="100%" height="100%">
    <tr>
		<td height="20" class="PopupTitle"><fmt:message key='edoc.custom.classification'/>
		</td>
	</tr>
    <tr><td class="">
    <table align="center"  width="100%" height="100%">
	<tr>
		<td style="padding:0 12px; height:22px;">
		<div id="topRadio" align="left"><fmt:message key='edoc.custom.sort'/>:
		<c:if test="${edocType == 0}">
		<input type="radio" id="r_send_sort" name="bigTypeId" value="3" checked/> <label for="r_send_sort"><fmt:message key='edoc.category.send'/></label>&nbsp; 
		<input type="radio" id="r_doc_data" name="bigTypeId" value="4"  /><label for="r_doc_data"><fmt:message key='edoc.element'/></label>&nbsp;
		<input type="radio" id="r_time" name="bigTypeId" value="2" /><label for="r_time"><fmt:message key='edoc.custom.time'/></label>&nbsp;
		<input type="radio" id="r_node" name="bigTypeId" value="${edocType}" /><label for="r_node"><fmt:message key='edoc.stat.workflownode'/></label><br>
		</c:if> 
		
		<c:if test="${edocType == 1}">
		<input type="radio" id="r_time" name="bigTypeId" value="2" checked /><label for="r_time"><fmt:message key='edoc.custom.time'/></label>&nbsp;
		<input type="radio" id="r_node" name="bigTypeId" value="${edocType}" /><label for="r_node"><fmt:message key='edoc.stat.workflownode'/></label><br>
		</c:if> 
		</div>
		</td>
	</tr>

	<tr>
		<td>
		<div id="customerType" style="border: 1px solid #CCC;width:370px;height:234px;overflow:auto; margin:0 12px;">

		<c:if test="${edocType == 0}">
		<div id="send_sort" >
			<table>

			<c:forEach items="${sendList}" var="node">
				<tr>
					<td><c:if test="${!empty node.statContentName && node.statContentId !='-1' }">

						<input id="send_sort${node.statContentId}" type="checkbox" value="${node.statContentId}_${node.statContentName}_cusSendType_${node.statContentId}" name="typeId" />
						<label for="send_sort${node.statContentId}">${node.statContentName}</label>
					</c:if></td>
				</tr>
			</c:forEach>
		</table>
		
		</div>
		
		
		
		<div id="doc_data" style="display: none;">
		<table width="155%">
			<div id="generalType">
			<tr>
				<td width="15%"><input id="r1" type="radio" name="docRadio" onclick="selectRadio('1')"/><label for="r1"><fmt:message key="${edoc_urgent_level.label}" /></label>:</td>
				<c:forEach items="${edoc_urgent_level.items}" var="data">
					
						<c:if test="${!empty data.label && data.state == 1 && data.isSystem == 1 }">
						<td width="10%">
						<input id="1-${data.id}"  type="checkbox" value="${data.id}_${data.label}_urgentLevel_${data.value}" name="typeId" />
						<label for="1-${data.id}"><fmt:message key="${data.label }" /></label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						</td>
						</c:if>
						<c:if test="${!empty data.label && data.state == 1 && data.isSystem == 0}">
						<td width="10%">
						<input id="1-${data.id}"  type="checkbox" value="${data.id}_${data.label}_urgentLevel_${data.value}" name="typeId" />
						<label for="1-${data.id}">${data.label}</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						</td>
						</c:if>
					
				</c:forEach> 
			</tr>

			<tr>
				<td><input id="r2" type="radio" name="docRadio" onclick="selectRadio('2')"/><label for="r2"><fmt:message key="${edoc_secret_level.label}" /></label>:</td>
				<c:forEach items="${edoc_secret_level.items}" var="data">
					
					<c:if test="${!empty data.label && data.state == 1 && data.isSystem == 1 }">
					<td width="10%">
						<input id="2-${data.id}" type="checkbox" value="${data.id}_${data.label}_secretLevel_${data.value}" name="typeId" />
						<label for="2-${data.id}"><fmt:message key="${data.label }" /></label>
					</td>	
					</c:if>
					<c:if test="${!empty data.label && data.state == 1 && data.isSystem == 0}">
					<td width="10%">
						<input id="2-${data.id}" type="checkbox" value="${data.id}_${data.label}_secretLevel_${data.value}" name="typeId" />
						<label for="2-${data.id}">${data.label }</label>
					</td>	
					</c:if>
					
				</c:forEach>
			</tr>
			</div>

			
			<tr class="ct">
				<td><input id="r3" type="radio" name="docRadio" onclick="selectRadio('3')"/><label for="r3"><fmt:message key="${edoc_send_type.label}" /></label>:</td>
				<c:forEach items="${edoc_send_type.items}" var="data"
					varStatus="status">
					
						<c:if test="${!empty data.label }">
							<td width="10%">
							<input id="3-${data.id}"  type="checkbox" value="${data.id}_${data.label}_sendType_${data.value}" name="typeId" />
							<c:if test="${data.isSystem == 1}">
							<label for="3-${data.id}"><fmt:message key="${data.label }" /></label>
							</c:if>
							<c:if test="${data.isSystem == 0}">
							<label for="3-${data.id}">${data.label }</label>
							</c:if>
							</td>
						</c:if>	
							
				</c:forEach>	
			</tr>
			
		</table>
		</div>
		</c:if> 

		
		<div id="node" style="display: none" >
		<table>

			<c:forEach items="${nodeList}" var="node">
				<tr>
					<td>
					<c:if test="${!empty node.label }">
						<input id="${node.flowPermId}" type="checkbox" value="${node.flowPermId}_${node.label}_nodePolicy_${node.name}" name="typeId" />
						<label for="${node.flowPermId}"><fmt:message key="${node.label}" /></label>
					</c:if>
					<c:if test="${empty node.label }">
						<input id="${node.flowPermId}" type="checkbox" value="${node.flowPermId}_${node.label}_nodePolicy_${node.name}" name="typeId" />
						<label for="${node.flowPermId}">${node.name}</label>
					</c:if>
					</td>
				</tr>
			</c:forEach>
		</table>
		</div>

		<div id="time" <c:if test="${edocType == 0}"> style="display: none" </c:if>>
		<table>
			<c:forEach items="${timeList}" var="time">
				<tr>
					<td><c:if test="${!empty time.id }">
						<input id="${time.id }" type="checkbox" value="${time.id}_${time.name}_cusReceiveTime_${time.id}" name="typeId" /><label for="${time.id}"><fmt:message key="${time.name}" /></label>
						</c:if>
					</td>
				</tr>

			</c:forEach>
		</table>
		
		</div>
		</div>
		</td>
	</tr>
	</table>
	</td></tr>
	<tr>
		<td align="right" height="42" class="bg-advance-bottom"  valign="middle" style="padding-top:0;">
		<input type="button"  value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}"/>" class="button-default_emphasize" onclick="save();" /> &nbsp; 
		<input type="button" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}"/>" class="button-default-2" onclick="javascript:window.close();" /></td>
	</tr>
</table>
</form>
<iframe name="operFrame" style="display:none;" width="0" height="0"></iframe>
</body>
</html>