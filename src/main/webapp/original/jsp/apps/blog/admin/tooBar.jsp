<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%@ include file="../header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.doc.resources.i18n.DocResource" var="v3xDocI18N"/>
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript">
	
	function changeStatus(flag){

		if( !window.parent.leftFrame && !window.parent.leftFrame.root){
		  return ;
		 }
		 var treeObj = window.parent.leftFrame.root ;
		 var selectId = treeObj.getSelected() ;
		 var choseDep = false ;
		 if(selectId) {
		   if(selectId.businessId != '${deptId}'){
		      choseDep = true ;		   
		   }
		 }
		 
		var ids=parent.detailFrame.document.getElementsByName('id');
		var id='';
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				if(idCheckBox.value != 'on')
				id=id+idCheckBox.value+',';
			}
		}
		if(id==''){
			alert(alertPeople);
			return;
		}
		var thpostForm = document.getElementById("thpostForm");
			document.getElementById("id").value = id ; 
		var url = "${detailURL}?method=initListAdmin&deptId=${deptId}" ;
		if(choseDep){		
			  thpostForm.action = "${detailURL}?method=modifyEmployeeBatch&choseDep=true&flag="+flag+"&deptId=${deptId}" ;
		      thpostForm.target =  "_theFrame" ;
		      thpostForm.submit() ;
		     
		}else{
			  thpostForm.action = "${detailURL}?method=modifyEmployeeBatch&choseDep=false&flag="+flag+"&deptId=${deptId}";
		      thpostForm.target = "_theFrame" ;
		      thpostForm.submit() ;
		      url = "${detailURL}?method=listAccountMembersAdmin" ;
		}		
		
	}

	function modifyEmployee() {
		var aUrl = "${detailURL}?method=getEmployeeModifyAdmin&dbClick=true";
		var theForm = parent.detailFrame.memberform;
		var checkid = theForm.id;
		var len = checkid.length;
		var checked = false;
		if (isNaN(len)) {
			alert(v3x.getMessage("BlogLang.blog_employee_alert_not_select"));
			return false;
		}
		else {
			var j = 0;
			for (var i = 0; i < len; i++) {
				if (checkid[i].checked == true) {
					
					if(checkid[i].value!="on"){
						
						aUrl += "&id=" + checkid[i].value + "&deptId=" + checkid[i].getAttribute("deptId");	
						j++;

					}
						
				}
			}
			if (j == 0) {
				alert(v3x.getMessage("BlogLang.blog_employee_alert_not_select"));
				return false;
			}
			else if (j > 1) {
				alert(v3x.getMessage("BlogLang.blog_employee_alert_select_one"));
				return false;
			}
			else {
				parent.bottom.location.href = aUrl;
			}
		}
	}
	function blogBack(){
		parent.location.href = "${detailURL}?method=listAllArticleAdmin";
	}
//-->
</script>
</head>
		<body>
		<form action="" name="thpostForm" id="thpostForm" method="post">
			<input type="hidden" name="id" id="id" value="">      
		</form>
				
							<div>
							<script type="text/javascript">
								var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
								myBar.add(new WebFXMenuButton("", "<fmt:message key='blog.admin.startblog.label'/>", "javascript:changeStatus('start')", [2,3], "", null));
								myBar.add(new WebFXMenuButton("", "<fmt:message key='blog.admin.stopblog.label' />", "javascript:changeStatus('stop')", [2,4], "", null)); 
								myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />", "modifyEmployee();", [1,2], "", null)); 
								myBar.add(new WebFXMenuButton("", "<fmt:message key='blog.admin'/>", "blogBack();", [2,1], "", null)); 
								document.write(myBar);
								document.close();
					    	</script>
							</div>
		</body>
		<iframe name="_theFrame" frameBorder="0"></iframe>
</html>