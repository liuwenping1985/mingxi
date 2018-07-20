<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 审核编辑功能代码判断 --%>
<script type="text/javascript">
	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
	myBar.add(new WebFXMenuButton(
				"editBtn", "<fmt:message key='news.amend.log'/>", 
				"editData('${param.id}','${param.spaceId}');", [1,2], 
				"", null));
	
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
		window.onbeforeunload = function(){
		    try {
		        removeCtpWindow(null,2);
		    } catch (e) {
		    }
		}
		
		var topWindow = getA8Top().document.documentElement;
		var winWidth = topWindow.clientWidth - 20,winHeight = topWindow.clientHeight - 20;
		openCtpWindow({'id':'newsAuditEdit','width':winWidth,height:winHeight,'dialogType2':'modal','url':baseUrl+'newsData.do?method=edit&isAuditEdit=true'+'&id='+id+'&custom=list&spaceId='+spaceId});
	}
</script>
