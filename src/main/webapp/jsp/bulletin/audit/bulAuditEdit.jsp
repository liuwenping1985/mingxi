<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
 myBar.add(new WebFXMenuButton(
			"editBtn", "<fmt:message key='bul.amend.log'/>", 
			"editData('${param.id}','${param.spaceId}');", 
			[1,2], "", null));
 
if("${bean.type.isAuditorModify}"!="false"){
	document.write(myBar);	
}

function editData(id,spaceId){
	var _state = getStateOfData(id, "ajaxNewsDataManager");
	if(_state){
		if(_state == '20'){
			alert(v3x.getMessage("bulletin.audited_no_edit"));
			return ;
		}else if(_state == '30'){
			alert(v3x.getMessage("bulletin.published_no_edit"));
			return ;
		}
	}
	openCtpWindow({'id':'bulAuditEdit','dialog_type':'open','url':baseUrl+'bulData.do?method=edit&isAuditEdit=true'+'&id='+id+'&custom=list&spaceId='+spaceId});
}
</script>