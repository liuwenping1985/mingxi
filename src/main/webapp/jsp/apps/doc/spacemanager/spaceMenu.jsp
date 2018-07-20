<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../docHeader.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
</head>
<script type="text/javascript">
<!-- 

// 	getA8Top().showLocation(1701);
	
showCtpLocation('F04_docSpace');
   
	function modifySpace(){

		var number=0;
		var spaceIds="";
		var theIds=parent.main.document.getElementsByName("id");

		for(var i=0;i<theIds.length;i++){
			if(theIds[i].checked){
		
				number=number+1;

			spaceIds += theIds[i].value + ",";
			}
			
		}


        if(number == 1){
		   var idArray = spaceIds.split(",");
		   spaceIds = idArray[0];
	   
	      }

	

	    if(number == 0){
			alert(v3x.getMessage("DocLang.doc_space_alter_not_select"));
		    return ;
		}
		else if(number > 1){
			alert(v3x.getMessage("DocLang.doc_space_alter_select_one"));
			return;
		}
	
	    parent.bottom.location.href="${spaceURL}?method=getSpaceModify&spaceId="+spaceIds+"&dbClick=true";
            

	}




	function modifySpaces(){

		


		
		var number=0;
		var spaceIds="";
		var theIds=parent.main.document.getElementsByName("id");
		var _theFirstId = "" ;

		for(var i=0;i<theIds.length;i++){
			if(theIds[i].checked){
				if(number == 0){  
				   _theFirstId =  theIds[i].value;
				}	
				number=number+1;
				spaceIds += theIds[i].value + ",";
			}			
		}
	
	    if(number == 0){
			alert(v3x.getMessage("DocLang.doc_spaces_alter_not_select"));
		    return ;
		 }
		else{
	     var deptId = v3x.openWindow({
			url : "${spaceURL}?method=getSpacesModify&spaceId="+_theFirstId+"&dbClick=true",
			width : "600",
			height : "500",
			resizable : "true",
			scrollbars : "true"
		    });
		if(deptId)
	    parent.main.location.href = "${spaceURL}?method=spaceList&deptId=" + deptId;
		//alert(deptId);
		}

	}
		
//-->	
</script>
<body scroll="no">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="border_all" style="border-top-width:0px;border-bottom-width:0px">

	<tr>
		<td height="22"  style="border-top:1px #A4A4A4 solid">

<script type="text/javascript">
	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
	myBar.add(new WebFXMenuButton("modify", "<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />" , "modifySpace();", [1,2], "", null));
	myBar.add(new WebFXMenuButton("modify", "<fmt:message key='doc.batchupdate.label' />" , "modifySpaces();", [1,2], "", null));
	document.write(myBar);

</script>
		</td>
	</tr>
	
</table>
</body>
</html>