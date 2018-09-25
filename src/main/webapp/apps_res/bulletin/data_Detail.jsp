<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../WEB-INF/jsp/bulletin/include/taglib.jsp"%>
<%@ include file="../../WEB-INF/jsp/bulletin/include/header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>
</title>
<link href="<c:url value="/common/RTE/editor/css/fck_editorarea4Show.css"/>" rel="stylesheet" type="text/css">
<script type="text/javascript" >
//获取前一页面传来的对象
	var bulletinObj = window.dialogArguments;
	//公告标题
	var title = bulletinObj.document.all.title.value;
	//发布部门
	var deptName = bulletinObj.document.all.publishDepartmentName.value;
	//部门公告板块和单位的板块区分（能直接取到值的是部门公告板块，不能直接取到值的是单位的板块）
	var typeName = bulletinObj.document.all.typeName.value;

	if(typeName==null || typeName==''){//取不倒值是单位的板块
		//单位公告板块
		var typeOptions = bulletinObj.document.all.typeId.options;	
		var bullType = "";
		for(var i = 0 ; i < typeOptions.length ; i++ ){
			if(typeOptions[i].selected){
				bullType = typeOptions[i].text;
			}
		}
	}else{
		var bullType = typeName;
	}
	//正文内容
 	 var oEditorFCK=bulletinObj.FCKeditorAPI.GetInstance('content');  
 	 var content = oEditorFCK.EditingArea.Document.body.innerHTML;


</script>
</head>
<body scroll='no'  onkeydown="listenerKeyESC()" style="margin: 0px; padding: 0px;">
	<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" class="body-bgcolor" align="center" style="padding: 0px;">
		
		<tr>
			<td class="body-bgcolor-audit" width="100%" height="100%">
			<div class="scrollList">
				<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="body-detail">
				    <tr>
					 <td colspan="6" height="30">
					 <table border="0" cellpadding="0" cellspacing="0" width="100%" style="border-bottom: 1px solid #A4A4A4;">
						 <tr>
						   <td align="center" width="90%" class="titleCss" style="padding: 20px 6px;">
						   		<script type="text/javascript">
									document.write(title);
								</script>
						   </td>
						  </tr>
						</table>
					 </td>
					</tr>
					<tr style='background-color:#f6f6f6'>
						<td class="font-12px" align="right" width="12%" height="28"><fmt:message key="bul.data.publishDepartmentId" /><fmt:message key="label.colon" />&nbsp;&nbsp;</td>
						<td class="font-12px" width="24%">
							<script type="text/javascript">
									document.write(deptName);
							</script>
						</td>
						<td class="font-12px" align="right" width="12%"><fmt:message key="bul.data.type" /><fmt:message key="label.colon" />&nbsp;&nbsp;</td>
						<td class="font-12px" width="24%">
							<script type="text/javascript">
									document.write(bullType);
							</script>
						</td>
						<td class="font-12px" align="right" width="12%"><fmt:message key="bul.data.publishDate" /><fmt:message key="label.colon" />&nbsp;&nbsp;</td>
						<td class="font-12px" width="16%">
							<script type="text/javascript">
									
							</script>
						</td>
					</tr>
		
					<tr>
						<td width="100%" height="500" valign="top" colspan="6">
							<div>								
								<script type="text/javascript">
										document.write(content);
								</script>
							</div>
						</td>
					</tr>
				</table>
				</div>	
				</td>
			</tr>
	</table>
</body>
</html> 