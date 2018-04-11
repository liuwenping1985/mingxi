<%@ page language="java" contentType="text/html;charset=UTF-8"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${partitionName }分区</title>

<%@include file="../header.jsp"%>
<script type="text/javascript"><!--
	 // 对分区进行取消操作
	 function cancelForm(form){
	    //document.getElementById(form).action= "<c:url value='/common/detail.jsp' />";
		//document.getElementById(form).submit();
		parent.listFrame.location.reload();
	 }
	 // 验证分区是否有时间冲突
	 function partitions(){
	 	var newName = document.getElementById("partition.name").value;
	 	var oldName = document.getElementById("oldname").value;
	 	
	 	var start = document.getElementById("startTime").value;
		var end   = document.getElementById("endTime").value;

		if(start == end){
			alert(v3x.getMessage("sysMgrLang.system_partition_startandendtime"));
			return false;
		}
	 	var v1Ary = start.split('-');
		var v2Ary = end.split('-');
		var d1 = new Date(v1Ary[1]+'/'+v1Ary[2]+'/' + v1Ary[0]);
		var d2 = new Date(v2Ary[1]+'/'+v2Ary[2]+'/' + v2Ary[0]);
		if ( d1 <= d2 ){
		 	if( newName != oldName ){
				try {
					var start = document.getElementById("startTime").value;
					var end   = document.getElementById("endTime").value;
					var id = document.getElementById("id").value;
					var requestCaller = new XMLHttpRequestCaller(this, "ajaxPartitionManager", "getPartition", false);
					requestCaller.addParameter(1, "date", start);
					requestCaller.addParameter(2, "date", end);
					requestCaller.addParameter(3, "boolean", false);
					var ds = requestCaller.serviceRequest();
					if( ds ){
						if(ds.length == 0){
							return true;
						}
						//改的是自己
						if(ds.length == 1 && ds[0].get("id") == id){
							return true;
						}
						
			     		var names = [];
			     		for(var i = 0; i < ds.length; i++){
			     			if(ds[i].get("id") == id){
			     				continue;
			     			}
			     			
							names[names.length] = ds[i].get("name");
						}
						
						alert(_("sysMgrLang.system_partition_same_time", names.join(", ")));
						return false;
					}
					
					return true;
				}
				catch (ex1) {
					return false;
				}
			}else{
				return true;
			}
		}else{
			alert(v3x.getMessage("sysMgrLang.system_partition_startandendtime"))
			return false; 
		}
	}
	// 验证重名
	function validateName(){
		var newName = document.getElementById("partition.name").value;
	 	var oldName = document.getElementById("oldname").value;
	 	if( newName != oldName || oldName == "" ){
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxPartitionManager", "isPartitionNameDuple", false);
			requestCaller.addParameter(1, "String", newName);
			var team = requestCaller.serviceRequest();
			if (team == true || team=="true") {
				alert(v3x.getMessage("sysMgrLang.system_partition_name"));
				return false ;
			} else {
				return true;
			}
		}else{
			return true;
		}
	}
	
	function submitForm(f){
		// 如果含有全文检索插件并且全文检索为分布式模式
		<%-- TODO renw 全文检索
		if('<%=com.seeyon.v3x.indexInterface.IndexInitConfig.isRemoteIndex()%>'=='true'){
			return submitForm_addSharePath(f);
		}
        --%>
		if(checkForm(f) && partitions() && validatepath() && validateName()){
			f.submit1.disabled = true;
			getA8Top().startProc();
			return true;
		}
		else{
			return false;
		}
	}

	function submitForm_addSharePath(f){
		if(checkForm(f) && partitions() && validatepath() && validateName()){
			f.submit1.disabled = true;
			getA8Top().startProc();
			
			return true;
		}
		
		return false;
	}
</script>
</head>
<body onload="initIe10AutoScroll('partitionBody',105);" scroll="auto">
<form id="postForm" method="post" action="${partitionURL}" onsubmit="return submitForm(this)">
	<input type="hidden" id="id" name="id" value="${partition.id}">
	<input type="hidden" id="oldname" value="${partition.name}">
	<input type="hidden" name="method" value="${partitionForm}">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">
	<tr align="center">
		<td height="12" class="detail-top">
			<script type="text/javascript">
			getDetailPageBreak();
			</script>
		</td>
	</tr>
	<tr>
		<td class="categorySet-4" height="8"></td>
	</tr>
	<tr>
		<td class="categorySet-head" height="23">
		<table width="100%" height="100%" border="0" cellspacing="0"
			cellpadding="0">
			<tr>
				<td class="categorySet-1" width="4"></td>
				<c:if test="${partitionName == 0}">
					<td class="categorySet-title" width="120" nowrap="nowrap"><fmt:message key="system.partition.add"/></td>
				</c:if>
				<c:if test="${partitionName == 1}">
					<td class="categorySet-title" width="120" nowrap="nowrap"><fmt:message key="system.partition.modify"/></td>
				</c:if>
				<td class="categorySet-2" width="7"></td>
				<td class="categorySet-head-space">&nbsp;<font color="red">*</font><fmt:message key="system.partition.must"/></td>
				
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td class="categorySet-head">
		<div id="partitionBody" class="categorySet-body" style="margin-bottom:50px;padding-left:0;padding-right:0;">
		<table width="100%" height="100%" cellspacing="0" cellpadding="0" >
		<tr><td height="10%">&nbsp;</td></tr>
			<tr><td valign="top">
		<table width="45%" border="0" cellspacing="0" cellpadding="0"
			align="center">
			<c:set var="ro" value="${v3x:outConditionExpression(readOnly, 'readonly', '')}" />
			<c:set var="dis" value="${v3x:outConditionExpression(readOnly, 'disabled', '')}" />
			<tr>
				<td class="bg-gray" width="20%" nowrap="nowrap">
					<label for="name"><fmt:message key="add.partition.oldlist" /></label></td>
				<td class="new-column" width="80%">
					${oldPath}
				</td>
			</tr>
			<tr>
				<td class="bg-gray" width="20%">
					<label for="post.code"> <font color="red">*</font><fmt:message key="add.partition.partitionname" />:</label>
				</td>
				<td class="new-column" width="80%">
				<input class="input-100per" type="text" name="partition.name" id="partition.name" maxlength="30" maxSize="30" value="${partition.name}" ${dis} inputName="<fmt:message
					key="add.partition.partitionname" />" validate="notNull,maxLength" />
				</td>
			</tr>
			<tr>
				<td class="bg-gray" width="20%" nowrap="nowrap"><label
					for="post.code"> <font color="red">*</font> <fmt:message
					key="add.partition.partitionpath" />:</label></td>
				<td class="new-column" width="80%"><input id="validatePath"
					class="input-100per" type="text" name="partition.path"
					id="partition.path" value="${partition.path}"
					${dis} inputName="<fmt:message
			key="add.partition.partitionpath" />"
					validate="notNull" /></td>
			</tr>
			<tr>
				<td class="bg-gray" width="20%" nowrap="nowrap"><label
					for="typeId"> <font color="red">*</font><fmt:message
					key="add.partition.partitionstate" />:</label></td>
				<td class="new-column" width="80%">
				<select name="partition.state" id="partition.state" ${dis}
					${v3x:outConditionExpression(readOnly, 'disabled', '')}
		 validate="notNull"
					inputName="<fmt:message key="add.partition.partitionstate" />">
					<c:choose>
						<c:when test="${partition.state == '0'}">
							<option value="0" selected="true"><fmt:message
								key="common.state.normal.label" bundle="${v3xCommonI18N}" /></option>
							<option value="1"><fmt:message
								key="common.state.invalidation.label" bundle="${v3xCommonI18N}" /></option>
						</c:when>
						<c:when test="${partition.state == '1'}">
							<option value="0"><fmt:message
								key="common.state.normal.label" bundle="${v3xCommonI18N}" /></option>
							<option value="1" selected="true"><fmt:message
								key="common.state.invalidation.label" bundle="${v3xCommonI18N}" /></option>
						</c:when>
						<c:otherwise>
							<option value="0" selected="true"><fmt:message
								key="common.state.normal.label" bundle="${v3xCommonI18N}" /></option>
							<option value="1"><fmt:message
								key="common.state.invalidation.label" bundle="${v3xCommonI18N}" /></option>
						</c:otherwise>
					</c:choose>
				</select></td>
			</tr>
			<tr>
				<td class="bg-gray" width="20%" nowrap="nowrap"><label
					for="post.sortId"><font color="red">*</font><fmt:message
					key="partition.fieldname.starttime" />:</label></td>
				<td class="new-column" width="80%"><input id="startTime"
					value="<fmt:formatDate value="${partition.startDate}" pattern="yyyy-MM-dd"/>"
					type="text" size="12" name="partition.begintime"
					onclick="whenstart('${pageContext.request.contextPath}', this, event.clientX, event.clientY+100,'date');"
					inputName="<fmt:message key="partition.fieldname.starttime" />"
					validate="notNull" ${ro} ${dis} readonly/></td>
			</tr>
			<tr>
				<td class="bg-gray" width="20%" nowrap="nowrap"><label
					for="post.sortId"><font color="red">*</font><fmt:message
					key="add.partition.endtime" />:</label></td>
				<td class="new-column" width="80%"><input id="endTime"
					value="<fmt:formatDate value="${partition.endDate}" pattern="yyyy-MM-dd"/>"
					size="12" type="text" name="partition.endtime"
					onclick="whenstart('${pageContext.request.contextPath}', this, event.clientX, event.clientY+100,'date');"
					inputName="<fmt:message key="add.partition.endtime" />"
					validate="notNull" ${dis} readonly/></td>
			</tr>
			<c:if test="${isRemoteIndex}">
			<tr>
				<td class="bg-gray" width="20%" nowrap="nowrap">
					<label for="post.sortId"><font color="red">*</font><fmt:message key="add.partition.sharePath" />:</label>
				</td>
				<td class="new-column" width="80%">
					<input id="validateSharePath" class="input-100per" type="text" name="partition.sharePath" id="partition.sharePath" value="${partition.sharePath}" ${dis} inputName="<fmt:message key="add.partition.sharePath" />" validate=""/>
				</td>
			</tr>
			</c:if>
			
			<c:if test="${isRemoteFile}">
			<tr>
				<td class="bg-gray" width="20%" nowrap="nowrap">
					<label for="post.sortId"><font color="red">*</font><fmt:message key="add.partition.fileSharePath" />:</label>
				</td>
				<td class="new-column" width="80%">
					<input id="validateFileServiceSharePath" class="input-100per" type="text" name="partition.fileServiceSharePath" id="partition.fileServiceSharePath" value="${partition.fileServiceSharePath}" ${dis} inputName="<fmt:message key="add.partition.sharePath" />" validate=""/>
				</td>
			</tr>
			</c:if>
			
			<%-- 
			<tr>
				<td class="bg-gray" width="20%" nowrap="nowrap"><label><fmt:message
					key="add.partition.encrypt" />:</label></td>
				<td class="new-column" width="80%" nowrap="nowrap"><c:set
					var="c" value="${post.enable==1 ? 'checked' : '' }" /> <c:set
					var="d" value="${post.enable!=1 ? 'checked' : '' }" /> <c:set
					var="e" value="${post.enable!=1 ? 'checked' : '' }" /> <input
					disabled="disabled" type="radio" name="enable" value="0" $ {c} ${dis}/>
				<fmt:message key="add.partition.notencrypt" /> <input
					disabled="disabled" type="radio" name="enable" value="0" ${d} ${dis}/>
				<fmt:message key="add.partition.lowencrypt" /> <input
					disabled="disabled" type="radio" name="enable" value="0" ${e} ${dis}/>
				<fmt:message key="add.partition.hightencrypt" /></td>
				</td>
			</tr>
			--%>
			<tr>
				<td class="bg-gray" width="20%" nowrap="nowrap" valign="top"><label
					for="decription"><fmt:message
					key="common.description.label" bundle="${v3xCommonI18N}" />:</label></td>
				<td class="new-column" width="80%">
				<textarea name="partition.description"
					id="partition.description" rows="4" cols="80" ${ro} ${dis}>${partition.description}</textarea>
				</td>
			</tr>
		</table>
</td></tr>


<tr>
	<td height="60" colspan="2" align="center">
		<fieldset style="width:90%;height:50px;background:#f1f7fd;BORDER-TOP:1 Solid #99CCFF;BORDER-LEFT:1 Solid #99CCFF;BORDER-RIGHT:1 Solid #99CCFF;BORDER-BOTTOM:1 Solid #99CCFF; "><table border="0" style="width:90%;height:50px;">
					<tr>
						<td width="20%" align="center">
							<font style="font-weight:bold;"><fmt:message key='partion.variable.description.title' bundle="${v3xCommonI18N}" /></font>&nbsp;:
						</td>
						<td width="80%" align="left">
						$&nbsp;{ctp.base.folder}<fmt:message key='partion.variable.description${v3x:oemSuffix()}' bundle="${v3xCommonI18N}" />
						</td>
					</tr>
                    
					<c:if test="${isRemoteIndex}">
					<tr>
						<td width="20%" align="center">
							<font style="font-weight:bold;">
								<fmt:message key='partion.variable.sharePath.title' bundle="${v3xCommonI18N}"/>
							</font>&nbsp;:
						</td>
						<td width="80%" align="left">
							<fmt:message key='partion.variable.sharePath' bundle="${v3xCommonI18N}" />
						</td>
					</tr>
					</c:if>
					
					<c:if test="${isRemoteFile}">
					<tr>
						<td width="20%" align="center">
							<font style="font-weight:bold;">
								<fmt:message key='partion.variable.fileSharePath.title' bundle="${v3xCommonI18N}"/>
							</font>&nbsp;:
						</td>
						<td width="80%" align="left">
							<fmt:message key='partion.variable.fileSharePath' bundle="${v3xCommonI18N}" />
						</td>
					</tr>
					</c:if>
				</table></fieldset>
	</td>
</tr>

</table>

		</div>
		</td>
	</tr>
	<c:if test="${!readOnly}">
		<tr>
			<td align="center" class="bg-advance-bottom" style="position:fixed;bottom:0;width:100%;padding-top:10px; height:40px;">
			<input name="submit1" type="submit" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />"
				class="button-default_emphasize">&nbsp; 
				<input type="button" onclick="cancelForm('postForm');" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />"
				class="button-default-2"></td>
		</tr>
	</c:if>
</table>
</form>
</body>
</html>