<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="header.jsp" %>
<script>
function changedType(type){
    parent.location.href = "${urlMyTemplate}?method=myTemplate&type="+type;
}

function rename(){
    var count = 0;
	var url = '${urlMyTemplate}?method=renameTemplate';
	var id = 0;
	var objects = parent.listFrame.document.getElementsByName("id"); 	
	if(objects != null){
		for(var i = 0; i < objects.length; i++){		  	    
			if(objects[i].checked){			  
			  url += '&id=' + objects[i].value;	
			  id = 	objects[i].value; 
			  count++;   			
			}
		}
	}	
	if(count==1){
		  var returnval = v3x.openWindow({
			url : "${urlMyTemplate}?method=initRename&type=${param.type}&id="+id,
			width : "380",
			height : "200",
			resizable : "true",
			scrollbars : "true"	
		  });
		  if(returnval){
			  parent.location.href = url + "&type=${param.type}&newName="+returnval;
          }
	}else if(count==0){
	  alert(v3x.getMessage("MainLang.mytemplate_select"));
	}else if(count>1){
	  alert(v3x.getMessage("MainLang.mytemplate_once_one"));
	}
}

function del(){
    var isDelete = false;
    var count = 0;
	var url = '${urlMyTemplate}?method=deleteTemplate';
	var objects = parent.listFrame.document.getElementsByName("id");
	if(objects != null){
		for(var i = 0; i < objects.length; i++){		  	    
			if(objects[i].checked){
			  isDelete = true;
			  url += '&id=' + objects[i].value;			    			
			}
		}
	}
	if(isDelete){
		if(confirm(v3x.getMessage("MainLang.mytemplate_del_confirm"))){
			parent.location.href= url + '&type=' +'${param.type}';
		}
	}else{
	  alert(v3x.getMessage("MainLang.mytemplate_select"));
	}
}

getA8Top().showLocation(806,"<fmt:message key='mytemplate.type.${param.type}'/>");

</script>
<body style="padding:0px 5px 0px 5px ;">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
		<td valign="top" height="26" class="tab-tag">
			<div class="div-float">
			<c:if test="${param.type=='col'}">
				<div class="tab-tag-left-sel"></div>
				<div class="tab-tag-middel-sel" onclick="changedType('col')" ><fmt:message key='mytemplate.type.col'/></div>
				<div class="tab-tag-right-sel"></div>
				<div class="tab-separator"></div>							
				<div class="tab-tag-left"></div>
				<div class="tab-tag-middel" onclick="changedType('meeting')"><fmt:message key='mytemplate.type.meeting'/></div>
				<div class="tab-tag-right"></div>
				<div class="tab-separator"></div>
				<div class="tab-tag-left"></div>
				<div class="tab-tag-middel" onclick="changedType('inquiry')"><fmt:message key='mytemplate.type.inquiry'/></div>
				<div class="tab-tag-right"></div>
			</c:if>
			<c:if test="${param.type=='meeting'}">
				<div class="tab-tag-left"></div>
				<div class="tab-tag-middel" onclick="changedType('col')"><fmt:message key='mytemplate.type.col'/></div>
				<div class="tab-tag-right"></div>
				<div class="tab-separator"></div>								
				<div class="tab-tag-left-sel"></div>
				<div class="tab-tag-middel-sel" onclick="changedType('meeting')"><fmt:message key='mytemplate.type.meeting'/></div>
				<div class="tab-tag-right-sel"></div>
				<div class="tab-separator"></div>			
				<div class="tab-tag-left"></div>
				<div class="tab-tag-middel" onclick="changedType('inquiry')"><fmt:message key='mytemplate.type.inquiry'/></div>
				<div class="tab-tag-right"></div>
			</c:if>		
			<c:if test="${param.type=='inquiry'}">
				<div class="tab-tag-left"></div>
				<div class="tab-tag-middel" onclick="changedType('col')" ><fmt:message key='mytemplate.type.col'/></div>
				<div class="tab-tag-right"></div>
				<div class="tab-separator"></div>								
				<div class="tab-tag-left"></div>
				<div class="tab-tag-middel" onclick="changedType('meeting')"><fmt:message key='mytemplate.type.meeting'/></div>
				<div class="tab-tag-right"></div>
				<div class="tab-separator"></div>			
				<div class="tab-tag-left-sel"></div>
				<div class="tab-tag-middel-sel" onclick="changedType('inquiry')"><fmt:message key='mytemplate.type.inquiry'/></div>
				<div class="tab-tag-right-sel"></div>
			</c:if>		
			</div>
		</td>
  <td valign="bottom" width="3" rowspan="2"><div class="tab-tag-1">&nbsp;</div></td>
  </tr>
<tr><td>
<script>
var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />" , "gray" );
myBar.add(new WebFXMenuButton("rename", "<fmt:message key='mytemplate.toolbar.rename.label' />", "rename()", "<c:url value='/common/images/toolbar/new.gif'/>"));
myBar.add(new WebFXMenuButton("del", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "del()", "<c:url value='/common/images/toolbar/delete.gif'/>", "", null));
document.write(myBar);
document.close();
</script>
</td>
</tr>
</table>
</body>