<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title></title>
<%@ include file="../../../../common/common.jsp"%>
<script type="text/javascript">

var authObj = window.parentDialogObj["formDesignHighAuthSlave"].getTransParams();
$(document).ready(function(){
	if(authObj!=undefined){
		$("input","#groupEdit").each(function(){
			 var id = $(this).attr("id");
			 if(!authObj[id] || authObj[id]=="false"||authObj[id]==false||authObj[id]=="null"){
					$(this).prop("checked",false);
					$(this).attr("checked",false);
			 }else{
				 	$(this).prop("checked",true);
					$(this).attr("checked",true);
			 }
		});
	}
});
function OK(){
	//直接操作父页面对象
	if(authObj!=undefined){
		$("input","#groupEdit").each(function(){
			 var id = $(this).attr("id");
			 authObj[id] = $(this).prop("checked");
		});
	}
	return authObj;
}
</script>
</head>
<body style="overflow: auto;" class="margin_10">
<form id="operadd" method="post" action="" onSubmit="" name="operadd">
	<table id="groupShow" width="100%" height="0px" border="0" cellpadding="0" cellspacing="0" >
		<tr>
			<td>
				<fieldset style="width: 90%; height: 90%" align="center">
				<!-- 重复表操作 -->
					<legend style="color: blue;">${ctp:i18n('form.operhigh.repeatedform.label')}：</legend>
					<table width="100%" align="center">
						<tr>
							<td>
								<div class="scrollList">
									<table id="groupEdit" style="display: inline" width="95%" border="0"
										cellspacing="0" cellpadding="0" align="center">
										<c:forEach var="table" items="${fb.tableList }" begin="1">
											<tr tableName="${table.tableName }">
												<td class="bg-gray" width="37%" nowrap="nowrap" id="${table.display }" title="${ctp:i18n("formoper.dupform.label")}${table.tableIndex}">[${ctp:i18n("formoper.dupform.label")}${table.tableIndex}]</td>
												<td width="32%" nowrap="nowrap"><label for="${table.display }_allowAdd">
													<!-- 允许添加 -->
													<input tableName="${table.tableName }" type="checkbox" name="${table.display }_allowAdd" id="${table.display }_allowAdd" ${table.isCollectTable ? 'disabled="true"' : ''}/>${ctp:i18n('form.authDesign.allowadd')}</label>
												</td>
												<td width="31%" nowrap="nowrap">
													<label for="${table.display }_allowDelete">
														<!-- 允许删除 -->
														<input tableName="${table.tableName }" type="checkbox"  name="${table.display }_allowDelete" id="${table.display }_allowDelete" ${table.isCollectTable ? 'disabled="true"' : ''}/>${ctp:i18n('form.operhigh.allowdel.label')}
													</label>
												</td>
											</tr>
										</c:forEach>
									</table>
								</div>
							</td>
						</tr>
					</table>
				</fieldset>
			</td>
		</tr>
	</table>
</form>
</body>
</html>