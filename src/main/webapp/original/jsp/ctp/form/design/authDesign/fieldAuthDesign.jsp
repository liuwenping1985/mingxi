<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>form</title>
        <script type="text/javascript" src="${path}/ajax.do?managerName=formAuthDesignManager"></script>
    </head>
    <body>
       <form action="" id="saveForm">
            <!--左右布局-->
           	<div id="authset" style="text-align: left;left: 0px;overflow:hidden;height:480px;">
				<div class="form_area margin_lr_10 margin_t_10 margin_b_5 border_all" id="authFieldMap" style="width: 500px;height: 430px;overflow:auto;">
					<table border="0" cellspacing="0" cellpadding="0" width="100%" id="authFieldTable">
					  <tr id="selectAllAccess">
					  	<th  noWrap style="width: 100px;" align="right"><LABEL for=name>&nbsp;</LABEL></th>
						<td align="left"><div style="width: 45px;">[<A href="javascript:void(0)" name="chobrowse" id="${browse }">${ctp:i18n('form.oper.browse.label')}</A>]</div></TD>
						<td align="left"><div style="width: 45px;">[<A href="javascript:void(0)" name="choedit" id="${edit }">${ctp:i18n('form.authDesign.edit')}</A>]</div></TD>
						<td align="left"><div style="width: 45px;">[<A href="javascript:void(0)" name="chohide" id="${hide }">${ctp:i18n('form.authDesign.hide')}</A>]</div></TD>
						<td	align="left"><div style="width: 45px;">[<A href="javascript:void(0)" name="choappand" id="${add }">${ctp:i18n('form.oper.superaddition.label')}</A>]</div></TD>
						<td	align="left"><div style="width: 45px;">[<A href="javascript:void(0)" name="" id="notNull">${ctp:i18n('form.authDesign.mustinput')}</A>]</div></TD>
					</tr>
					<c:forEach var="field" items="${fb.allFieldBeans }" varStatus="status">
					<tr id="${field.name }_tr">
						<th noWrap align="right"><label class="margin_l_10 margin_r_10">[<c:if test="${field.masterField}">${ctp:i18n("form.base.mastertable.label")}</c:if><c:if test="${!field.masterField}">${ctp:i18n("formoper.dupform.label")}${field.ownerTableIndex }</c:if>]&nbsp${field.display }:</LABEL> </th>
						<td align="left"><div style="width: 45px;text-align: center;"><INPUT tableName="${field.ownerTableName }" fieldName="${field.name }" fieldType="${field.inputType}" <c:if test="${field.inputType eq relationForm}">viewSelectType = ${field.formRelation.viewSelectType }</c:if> type="radio" checked="checked" id="${field.name }_access" name="${field.name }_access" value="${browse }"></div></td>
						<td align="left"><div style="width: 45px;text-align: center;"><INPUT tableName="${field.ownerTableName }" fieldName="${field.name }" fieldType="${field.inputType}" <c:if test="${field.inputType eq relationForm}">viewSelectType = ${field.formRelation.viewSelectType }</c:if> type="radio" id="${field.name }_access" name="${field.name }_access" value="${edit }"></div></td>
						<td align="left"><div style="width: 45px;text-align: center;"><INPUT tableName="${field.ownerTableName }" fieldName="${field.name }" fieldType="${field.inputType}" <c:if test="${field.inputType eq relationForm}">viewSelectType = ${field.formRelation.viewSelectType }</c:if> type="radio" id="${field.name }_access" name="${field.name }_access" value="${hide }"></div></td>
						<td align="left" ><div style="width: 45px;text-align: center;">
						<c:if test="${field.inputType eq 'textarea' or field.inputType eq 'flowdealoption' }">
						<INPUT tableName="${field.ownerTableName }" fieldName="${field.name }"  fieldType="${field.inputType}" <c:if test="${field.inputType eq relationForm}">viewSelectType = ${field.formRelation.viewSelectType }</c:if> type="radio" id="${field.name }_access" name="${field.name }_access" value="${add }" >
						</c:if></div>
						</td>
						<td align="left">
							<div style="width: 45px;text-align: center;">
								<INPUT disabled type="checkbox" fieldType="${field.inputType}" <c:if test="${field.inputType eq relationForm}">viewSelectType = ${field.formRelation.viewSelectType }</c:if> id="${field.name }_notNull"  value="${isNotNull }"/>
							</div> 
						</td>
					</tr>
					</c:forEach>
						<!--正文高级权限暂不设置
					<c:if test="${!empty fb.templateFileId}">
						<tr id="templateFile_tr">
							<th noWrap align="right"><label class="margin_l_10 margin_r_10">[${ctp:i18n("form.system.field.flowcontent.label")}]&nbsp;${ctp:i18n("form.auth.field.content.lable")}:</LABEL> </th>
							<td align="left"><div style="width: 45px;text-align: center;"><INPUT  type="radio" checked="checked" id="templateFile_access" name="templateFile_access" value="${browse }"></div></td>
							<td align="left"><div style="width: 45px;text-align: center;"><INPUT  type="radio" id="templateFile_access" name="templateFile_access" value="${edit }"></div></td>
							<td align="left"><div style="width: 45px;text-align: center;"><INPUT  type="radio" id="templateFile_access" name="templateFile_access" value="${hide }"></div></td>
						</tr>
					</c:if>
					-->
	                </table>
	           	</div>
	           	<a class="common_button common_button_disable common_button_gray margin_l_10 margin_b_5" href="javascript:void(0)" id="groupAuth">${ctp:i18n('form.operhigh.repeatedform.label')}</a>
           		<div id="groupEdit">
					<c:forEach var="table" items="${fb.tableList}" begin="1">
						<!-- 允许添加 -->
						<input tableName="${table.tableName }" title="${ctp:i18n("formoper.dupform.label")}${table.tableIndex}" displayName="${table.display }" type="hidden" name="${table.display }_allowAdd" id="${table.display }_allowAdd" value="" isCollectTable="${table.isCollectTable}"/>
						<!-- 允许删除 -->
						<input tableName="${table.tableName }" title="${ctp:i18n("formoper.dupform.label")}${table.tableIndex}" displayName="${table.display }" type="hidden"  name="${table.display }_allowDelete" id="${table.display }_allowDelete" value="" isCollectTable="${table.isCollectTable}"/>
					</c:forEach>
				</div>
            </div>
		</form>
		<%@ include file="fieldAuthDesign.js.jsp" %>
    </body>
</html>
