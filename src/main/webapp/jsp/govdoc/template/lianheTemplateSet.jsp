<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
</head>
<body>
<div style="height:320px; overflow-y:auto ">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="only_table">
    <thead>
        <tr>
            <th width="20"></th>
            <th>${ctp:i18n('common.template.label')}</th>
        </tr>
    </thead>
    <tbody>
    <c:forEach var="vo" items="${lists }" varStatus="status">
        <tr <c:if test="${status.index % 2==0 }"> class="erow" </c:if> onclick="$('#codeRadio${status.index }').attr('checked',true);">
            <td><input id="codeRadio${status.index }" type="radio" value="${vo.id }" name="codeRadio" <c:if test="${vo.extraMap['com.seeyon.ctp.form.po.GovdocTemplateDepAuth'] != null }">checked='checked'</c:if>/></td>
            <td>${vo.subject }</td>
        </tr>
        </c:forEach>
    </tbody>
</table>
</div>
  
<p style="position: absolute;bottom: 0; font-size: 14px; padding:10px; color:red">${ctp:i18n('govdoc.lianhe.detail.label')}</p>
</body>
<script type="text/javascript">
function OK(){
	return $("input:checked").val();
}
</script>
</html>