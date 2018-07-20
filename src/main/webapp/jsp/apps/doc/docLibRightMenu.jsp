<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/main" prefix="main"%>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/docManager.js${v3x:resSuffix()}" />"></script>
<link type="text/css" rel="stylesheet" href="<c:url value='/apps_res/doc/css/docMenu.css${v3x:resSuffix()}' />">
<script type="text/javascript" src="<c:url value="/apps_res/doc/js/libCfgMenu.js${v3x:resSuffix()}" />"></script>
<script>
<!--   
	var menu = new RightMenu("${pageContext.request.contextPath}");	
		
	menu.AddItem("column","<fmt:message key='doc.menu.xianshilanmu.label'/>","/seeyon/apps_res/doc/images/column.gif","rbpm","","column");
	menu.AddItem("columnDefault","<fmt:message key='doclib.jsp.editcolumns.default'/>","/seeyon/apps_res/doc/images/column.gif","rbpm","","columnDefault");
	menu.AddItem("searchCondition","<fmt:message key='doclib.jsp.editsearchconfigs'/>","/seeyon/apps_res/doc/images/column.gif","rbpm","","searchCondition");
	menu.AddItem("searchConditionDefault","<fmt:message key='doclib.jsp.editsearchconfig.default'/>","/seeyon/apps_res/doc/images/column.gif","rbpm","","searchConditionDefault");
	
	menu.AddItem("checkin","<fmt:message key='doc.menu.guanliqianchu.label'/>","","rbpm","","checkin");
	menu.AddItem("separator","","","rbpm",null);
	if(v3x.getBrowserFlag("hideMenu") == true){	
		menu.AddItem("acl","<fmt:message key='doc.menu.share.label'/>","/seeyon/apps_res/doc/images/share.gif","rbpm","","acl");
	}
	
	menu.AddItem("log","<fmt:message key='doc.menu.viewlog.label'/>","/seeyon/apps_res/doc/images/log.gif","rbpm","","log");
	menu.AddItem("alert","<fmt:message key='doc.menu.subscribe.label'/>","/seeyon/apps_res/doc/images/alert.gif","rbpm","","alert");
	if(v3x.getBrowserFlag("hideMenu") == true){	
		menu.AddItem("separator","","","rbpm",null);
		menu.AddItem("property","<fmt:message key='doc.menu.properties.label'/>","/seeyon/apps_res/doc/images/property.gif","rbpm","","property");
	}

	document.writeln(menu.GetMenu());
//-->
</script>