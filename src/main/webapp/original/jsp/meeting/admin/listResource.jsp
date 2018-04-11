<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="header.jsp"%>
<script type="text/javascript" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<link type="text/css" rel="stylesheet" href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<c:set value="<input type='checkbox' onclick='selectAll(this, \"id\")'/>" var="selectAllInput" />
<script type="text/javascript">

//当前位置
showCtpLocation("F03_meetingDataBase");
$(function() {
  	setTimeout(function() {
      if($("#headIDresourcelist") != null) {
          $("#headIDresourcelist").find("th").eq(0).find("div").attr("title", v3x.getMessage("meetingLang.meeting_choose_all"));
      }
  	}, 100);
});

function create(){
  	parent.detailFrame.location.href = "meetingResource.do?method=createAdd";
}

function removeResource(){
	var count = 0;
	var url = 'meetingResource.do?method=execDel';
	var checkedValue = '';
	var objects = document.getElementsByName("id");
	if(objects != null) {	
		for(var i = 0; i < objects.length; i++) {		   		    
			if(objects[i].checked) {		
				  url += '&id=' + objects[i].value;		
				  checkedValue = objects[i].value;
				  count++;		
			}
		}
	}
	
	if(count==1) {
		try{
	  	  	//与会资源与会议室的占用判断
			if(resourceTypeMap.get(checkedValue)=='meetingres'||resourceTypeMap.get(checkedValue)=='office'){
		  	  	var requestCaller1 = new XMLHttpRequestCaller(this, "ajaxResourceManager", "isResourcesUsed", false);
			  	requestCaller1.addParameter(1, "Long", checkedValue);
		  	  	var isUsed = requestCaller1.serviceRequest();
		  	  	if(isUsed=='true'){
		  	  	 	alert(v3x.getMessage("MainLang.resource_used_cannot_del"));
		  	  	 	return;
		  	  	}
		  	}
	        if(confirm(v3x.getMessage("meetingLang.sure_to_delete"))) {
	          	parent.detailFrame.location.href= url;
	        }	
		} catch(ex1) {
			alert("Exception : " + ex1);
		}  
	} else if(count==0) {
		alert(v3x.getMessage("MainLang.resource_selectResToDel"));
	} else if(count>1) {
	  	//批量删除
	   var id = '';
	   for(var i=0;i<objects.length;i++) {
	   		var idCheckBox=objects[i];   		
	   		if(idCheckBox.checked) {
		  		id=id+idCheckBox.value+',';
				
				//与会资源与会议室的占用判断
		  	  	if(resourceTypeMap.get(idCheckBox.value)=='meetingres'||resourceTypeMap.get(idCheckBox.value)=='office'){
			  	  	var requestCaller1 = new XMLHttpRequestCaller(this, "ajaxResourceManager", "isResourcesUsed", false);
				  	requestCaller1.addParameter(1, "Long", idCheckBox.value);
			  	  	var isUsed = requestCaller1.serviceRequest();
			  	  	if(isUsed=='true'){
			  	  	 	alert(v3x.getMessage("MainLang.resource_used_cannot_del"));
			  	  	 	return;
			  	  	}
			  	}		  			
			}
	   	}//for 结束
	   
	   	if(confirm(v3x.getMessage("MainLang.resource_del_confirm"))) {
			parent.detailFrame.location.href="meetingResource.do?method=execDel"+'&id='+id ;	        
	   	}
	}//这个else if 结束
}

// Edit By Lif Start
function modify() {  
	var count = 0;	
	var ids=parent.listFrame.document.getElementsByName('id');
	var id='';
	for(var i=0;i<ids.length;i++) {
		var idCheckBox=ids[i];
		if(idCheckBox.checked){
			id=idCheckBox.value;
			count++;
		}
	}	
	if(count==1) {
		parent.detailFrame.location.href="meetingResource.do?method=modifyAdd&id="+id;
	} else if (count>1) {
		alert(v3x.getMessage("MainLang.resource_once_one"));
		return false;
	} else {
		alert(v3x.getMessage("MainLang.resource_selectResToModify"));
		return false;
	}
}
// Edit End

//双击修改事件
function modifyResource(resourceId) {
	parent.detailFrame.location.href="meetingResource.do?method=modifyAdd&id="+resourceId;
}

function showDetail(id) {
  	parent.detailFrame.location.href="meetingResource.do?method=modifyAdd&oper=detail&id="+id;
}

var resourceTypeMap = new Properties();

</script>
</head>
<body class="page_color">

<div class="main_div_row2">

<div class="right_div_row2">

<div class="top_div_row2">

<table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td  class="webfx-menu-bar">
		<script type="text/javascript">
		  	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","gray");
		  	myBar.add(new WebFXMenuButton("add","<fmt:message key='common.toolbar.new.label' />","create()",[1,1], "",null));
		  	myBar.add(new WebFXMenuButton("mod","<fmt:message key='common.toolbar.update.label' />","modify()",[1,2],"", null));
		  	myBar.add(new WebFXMenuButton("del","<fmt:message key='common.toolbar.delete.label' />","removeResource()",[1,3],"", null));
		  	document.write(myBar);
		  	document.close();
		</script>	
	</td>
</tr>
</table>

</div><!-- top_div_row2 -->

<div class="center_div_row2" id="scrollListDiv">

<form id="Resource" method="post"  style="margin: 0px"> 
		  
<v3x:table htmlId="resourcelist" data="rsList" var="col" showPager="true" showHeader="true" leastSize="0">
     			
	<v3x:column width="5%" align="center" label="${selectAllInput}">
    	<input type='checkbox' name='id' value="<c:out value="${col.id}"/>" affairId="<c:out value="${col.id}" />"/>
        <script>
       		resourceTypeMap.put('${col.id}','${col.type}');
        </script>
  	</v3x:column>
	
	<v3x:column width="40%" type="String" value="${col.name}" label="common.resource.body.name.label" className="cursor-hand sort" onClick="showDetail('${col.id}')" onDblClick="modifyResource('${col.id}')" maxLength="70" symbol="..."></v3x:column>
               
    <v3x:column width="55%" type="String" label="common.resource.body.description.label" className="cursor-hand sort" onClick="showDetail('${col.id}')"
    	value="${col.description}" maxLength="90" symbol="..." alt="${col.description}" />

</v3x:table>

</form>

</div><!-- center_div_row2 -->

</div><!-- right_div_row2 -->

</div><!-- main_div_row2 -->

<script type="text/javascript">
	showDetailPageBaseInfo("detailFrame", "<fmt:message key='mt.meeting.pubResouece.label' />", [3,5], pageQueryMap.get('count'), _("meetingLang.meeting_pubResource_info"));
</script>

</body>
</html>