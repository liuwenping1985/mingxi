<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='metadata.manager.binding'/></title>
<script type="text/javascript">
</script>
<script type="text/javascript">

function getObjectById(divObj){
   var returnObj = document.getElementById(divObj) ;
   return returnObj;
}

function selectMetadata(){
  if(!window.detailIframe && !window.detailIframe.root){
    return ;
  }
  var selected = window.detailIframe.root.getSelected() ;
  var selectId = "";
  var selectType = "" ;
  var slectName = "" ;
  if(selected){
		selectId = selected.businessId;
		selectType = selected.is_formEnum ; 
		slectName = selected.text ;
	}else{	
		window.detailIframe.root.select();
	}
	if(selectType != '1'){
    	alert(v3x.getMessage("sysMgrLang.system_metadata_select_metadata")) ;
    	return ;
    }
  var dv = window.dialogArguments.extendField;
  dv.id = selectId;
  dv.name = slectName ;
  var isFinalChild = document.all("isFinalChild");
  if(isFinalChild != null){
  	  dv.isFinalChild = isFinalChild.checked;
  } else {
	  dv.isFinalChild = false;
  }
  dv.level = 1;
  var level = getLevel(selectId) ;
  if(level){
	  if(level == 0){
		    alert("该枚举已经被删除!") ;
	    	return ;
		}
	  dv.level = level
   }
  window.returnvalue = dv ;
  window.close() ;
}
function getLevel(metadataId){
	if(!metadataId){
		return  ;
	}
	try{
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxMetadataManager", "getLevel", false);
		requestCaller.addParameter(1, "Long", metadataId);
		var rs = requestCaller.serviceRequest();
		if(rs){
			return rs;
		}
	}
	catch (ex1) {
		alert("Exception : " + ex1);
		return;
	}
}


</script>

</head>
<body scroll="no" onload="setDefaultTab(0);">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="popupTitleRight">
	<tr>
	  <td class="PopupTitle" colspan="2">
	    <fmt:message key='metadata.manager.binding'/>
	  </td>
	</tr>   
	
	<tr>
	  <td height="10px;" colspan="2"></td>
	</tr>
	
	<tr>
	<td colspan="2" class="padding5">
	
	<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="">
<tr>
  <td valign="bottom" height="26" class="tab-tag" colspan="2">
	<div class="tab-separator"></div>
	<div id="menuTabDiv" class="div-float">
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel" onclick="javascript:changeMenuTab(this);" url="${metadataMgrURL}?method=selectTreeFrame"><fmt:message key='metadata.manager.public' bundle="${v3xMainI18N}"/></div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>
		<div class="tab-tag-left"></div>
		<div class="tab-tag-middel" onclick="javascript:changeMenuTab(this);" url="${metadataMgrURL}?method=selectOrgTreeFrame"><fmt:message key='metadata.manager.account' bundle="${v3xMainI18N}"/></div>
		<div class="tab-tag-right"></div>
		<div class="tab-separator"></div>
	</div>
   </td>
  </tr>

	<tr>
		<td class="tab-body-bg" colspan="2" style="margin: 0px;padding:0px;">
		<iframe noresize="noresize" frameborder="no" id="detailIframe" name="detailIframe" style="width:100%;height: 100%;" border="0px"></iframe>			
		</td>
	</tr>
	
	</table>
	
	</td>
	</tr>   


	
<tr>
  <td height="42" align="left" class="bg-advance-bottom">
  	<c:if test="${param.inputtype eq 'select'}">
      <input type="checkbox" name="isFinalChild" id="isFinalChild"> 
      <label for="isFinalChild">
      <fmt:message key='metadata.manager.finalchild.label'/>
      </label>
    </c:if>
  	  &nbsp;
  </td>
  <td height="42" align="right" class="bg-advance-bottom">
   <input type="button" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" name="b1" class="button-default-2" onclick ="selectMetadata()">&nbsp;&nbsp;&nbsp;&nbsp;
   <input type="button" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" name="b2" class="button-default-2" onclick="window.close();">
  </td>
</tr>
	
</table>

</body>		
</html>