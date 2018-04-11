<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title> <fmt:message key='metadata.manager.querylable'/></title>
<script type="text/javascript">

function selectMetadataItem(){
	  if(!window.detailIframe && !window.detailIframe.root){
		    return ;
		  }
		  var selected = window.detailIframe.root.getSelected() ;
		  var selectId = "";
		  var slectName = "" ;
		  if(selected){
				selectId = selected.businessId;
				slectName = selected.text ;
			}else{	
				window.detailIframe.root.select();
			}
			if(selected == window.detailIframe.root){
		    	alert(v3x.getMessage("sysMgrLang.system_metadataitem_query_root")) ;
		    	return ;
		    }
		  var dv = window.dialogArguments.metadataItemObj;
		  dv.value = selectId;
		  dv.label = slectName ;
		  window.returnvalue = dv ;
		  window.close() ;	
}

</script>
</head>
<body scroll="no" class="">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="popupTitleRight">	
	<tr>
	  <td class="PopupTitle" >
	   <fmt:message key='metadata.manager.querylable'/>
	  </td>
	</tr> 
	  
	<tr>
		<td height="10px;"></td>
	</tr>

<tr>
	<td colspan="2" class="padding5">
	
	<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="">
	<tr>
		<td class="tab-body-bg" colspan="2" style="margin: 0px;padding:0px;">
			<iframe noresize="noresize" frameborder="no" src="${metadataMgrURL}?method=showQueryTree&metadataId=${metadataId}&level=${param.level}" id="detailIframe" name="detailIframe" style="width:100%;height: 100%;" border="0px"></iframe>			
		</td>
	</tr>
	
	</table>
	
	</td>
</tr>  
	
<tr>
  <td height="42" align="right" class="bg-advance-bottom">
   <input type="button" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" name="b1" class="button-default-2" onclick ="selectMetadataItem()">&nbsp;&nbsp;&nbsp;&nbsp;
   <input type="button" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" name="b2" class="button-default-2" onclick="window.close();">
  </td>
</tr>
	
</table>
</body>		
</html>