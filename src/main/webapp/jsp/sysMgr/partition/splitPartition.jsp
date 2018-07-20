<%@ page language="java" contentType="text/html;charset=UTF-8"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>拆分分区</title>
<%@include file="../header.jsp"%>
<script type="text/javascript">
	 function cancelForm(form){
	    //document.getElementById(form).action= "<c:url value='/common/detail.jsp' />";
		//document.getElementById(form).submit();
		parent.listFrame.location.reload();
	 }
	 
	// 验证重名
	function validateName(){
	        var newName = document.getElementById("partition.name").value;
	        if( newName != "" ){
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
		var split = f.splittime;
		var splitDate = f.splittime.value;
		var startDate = f.startDate.value;
		var endDate = f.endDate.value;
		
		if(checkForm(f) && validatepath()&& validateSplitDate(split,splitDate,startDate,endDate) && validateName()){
			f.submit1.disabled = true;
			getA8Top().startProc();
			return true;
		}
		
		return false;
	}
	//验证拆分时间
	function validateSplitDate(split,splitDate,startDate,endDate){
		//拆分时间不能和开始时间和结束时间差一天
		if(!(compareDate(splitDate,new Date().dateAdd(startDate,1))>0 && compareDate(endDate,splitDate)> 0)){
			alert(v3x.getMessage("sysMgrLang.system_partition_split_in_wrong"));
			split.focus();
			return false;
		}
		return true;
	}
</script>
</head>
<body scroll="no" style="overflow: hidden">
<form id="postForm" method="post" action="${partitionURL}?method=executeSplitPartition&id=${param.id}" onsubmit="return submitForm(this)">
<input type="hidden" name="id" value="${v3x:toHTML(partition.id)}">
<input type="hidden" name="startDate" value="${v3x:toHTML(param.startDate)}">
<input type="hidden" name="endDate" value="${v3x:toHTML(param.endDate)}">
<table border="0" cellpadding="0" cellspacing="0" width="100%"
	height="100%" align="center" class="categorySet-bg">
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
				<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key="partition.split.split"/></td>
				<td class="categorySet-2" width="7"></td>
				<td class="categorySet-head-space">&nbsp;<font color="red">*</font><fmt:message key="partition.split.split.must"/></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td class="categorySet-head">
		<div class="categorySet-body">

		<table width="45%" border="0" cellspacing="0" cellpadding="0"
			align="center">
			<c:set var="ro"
				value="${v3x:outConditionExpression(readOnly, 'readonly', '')}" />
			<c:set var="dis"
				value="${v3x:outConditionExpression(readOnly, 'disabled', '')}" />
			<tr>
				<td class="bg-gray" width="20%" nowrap="nowrap"><label
					for="post.code"> <font color="red">*</font><fmt:message
					key="partition.split.newname" />:</label></td>
				<td class="new-column" width="80%"><input class="input-100per"
					type="text" name="partition.name" id="partition.name"
					value="${partition.name}" ${ro} inputName="<fmt:message
			key="partition.split.newname" />" validate="notNull" /></td>
			</tr>
			<tr>
				<td class="bg-gray" width="20%" nowrap="nowrap"><label
					for="post.code"> <font color="red">*</font> <fmt:message
					key="partition.split.newpath" />:</label></td>
				<td class="new-column" width="80%"><input id="validatePath" class="input-100per"
					type="text" name="partition.path" value="${partition.path}" ${ro} inputName="<fmt:message
			key="partition.split.newpath" />" validate="notNull" /></td>
			</tr>
			<tr>
				<td class="bg-gray" width="20%" nowrap="nowrap"><label
					for="post.sortId"> <font color="red">*</font> <fmt:message
					key="partition.split.splittime" />:</label></td>
				<td class="new-column" width="80%"><input id="splittime"
					value="${partition.startDate}" type="text" size="12"
					name="partition.splittime"
					onclick="whenstart('${pageContext.request.contextPath}', this, event.clientX, event.clientY+100,'date');"
					inputName="<fmt:message key="partition.split.splittime.notnull" />"  validate="notNull" ${ro} ${dis}  readonly/>
				</td>
			</tr>
			<tr>
				<td class="bg-gray" width="20%" nowrap="nowrap" valign="top"><label
					for="decription"><fmt:message
					key="common.description.label" bundle="${v3xCommonI18N}" />:</label></td>
				<td class="new-column" width="80%"><textarea
					class="input-100per" name="partition.description"
					id="partition.description" rows="4" cols=""${ro}>${partition.description}</textarea></td>
			</tr>

		</table>
		</div>
		</td>
	</tr>
	<tr>
		<td height="42" align="center" class="bg-advance-bottom"><input
			type="submit" name="submit1"
			value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />"
			class="button-default-2">&nbsp; <input type="button"
			onclick="cancelForm('postForm');"
			value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />"
			class="button-default-2"></td>
	</tr>
</table>
</form>
</body>
</html>
