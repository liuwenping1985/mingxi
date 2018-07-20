<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/edoc/edocHeader.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title></title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.js${v3x:resSuffix()}" />"></script>
<script>

function read_only_choose(){
 	var div = document.getElementById("fieldTwo");
  
  	var inputs = div.getElementsByTagName("input");
  	for(var i=0;i<inputs.length;i++){
      	if(inputs[i].type == "radio" && inputs[i].value == "0"){
          	var s = inputs[i];
          	s.checked = "true";
          	s.value == "0";
      	}
  	}
}

function edit_choose(){

  var div = document.getElementById("fieldTwo");      
  var inputs = div.getElementsByTagName("input");
  
  for(var i=0;i<inputs.length;i++){
      if(inputs[i].type == "radio" && inputs[i].value == "1"){
          var s = inputs[i];
          s.checked = "true";
          s.value = "1";
      }
  }
}

function oprateSubmit(){
  <c:if test="${empty aclList}">
      return ;
  </c:if>
  // id:value,id:value....
  var id_str = "";
  $("input[type='radio']:checked").each(function(){
	  if($(this).attr("name") != "fradio"){
	  	id_str = id_str + $(this).attr("name") + ":" + $(this).attr("value") + ",";
	  }
  });
  var requestCaller = new XMLHttpRequestCaller(this, "elementPermissionManager", "changePolicy", false);
  requestCaller.addParameter(1, "String", "${permissionId}");
  requestCaller.addParameter(2, "String", id_str);
  var ds = requestCaller.serviceRequest();
  if(ds == "success"){
	  window.dialogArguments.pwindow.infoDialog.close();
  }else {
	  alert(ds);
  }
}

function closeDialog(){
	window.dialogArguments.pwindow.infoDialog.close();
}

</script>
<style>
.stadic_body_top_bottom{
	bottom: 35px;
	top: 0px;
	position:absolute;
}
.stadic_footer_height{
	height:35px;
	position:absolute;
	bottom:0;
	width:100%;
}

</style>
</head>
<body style="background:#FFF;overflow:hidden;">

<div class="stadic_layout">

<form name="form" method="post" style="padding:0;margin:0;">
	<div class="stadic_layout_body stadic_body_top_bottom border_t" style="width:100%;height:95%; overflow:auto;">
		<br />
			&nbsp;&nbsp;<fmt:message key='edoc.current.nodePermissions'/>:${policyName }
		<br />
	 		
	 	<div id="fieldTwo" align="center" name="fieldTwo" style="OVERFLOW:auto;margin-left:15px;vertical-align:top;">
       		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="5" align="left" valign="top">
           		<tr>
                	<td class="new-column" nowrap="nowrap" width="25%" align="left" height="40">
                         <label for="name"><fmt:message key="flowperm.element.name" /></label>
                    </td>
                   	<td width="10%" align="right">
                        <fmt:message key="flowperm.element.readonly" />
                   	</td>
                   	<td width="18%" align="left">
                         <label for="radio1">
	                         <input type="radio" id="radio1" name="fradio"  onclick="read_only_choose();"  <c:if test="${param.flag == 'readonly' or 'zhihui' eq policyLabel}">  disabled </c:if> >
                         </label>
                   	</td>
                   	<td width="10%" align="right">
                      	<fmt:message key="flowperm.element.edit" />
                   	</td>
                   	<td width="18%" align="left">
                         <label for="radio2">
	                         <input type="radio" id="radio2" name="fradio" onclick="edit_choose();"  <c:if test="${param.flag == 'readonly' or 'zhihui' eq policyLabel}">  disabled </c:if> >
                         </label>
                   	</td>
               	</tr>
                
               	<c:forEach items="${aclList}" var="bean">
                	<c:choose>
                    <c:when test="${bean.access == 0 }">
                    	<tr>
                        	<td class="new-column" width="25%" nowrap="nowrap" 
                               <c:if test='${bean.govElement.isSystem}'>
                                       title=${ctp:i18n(bean.govElement.name)}
                               </c:if>
                               <c:if test='${!bean.govElement.isSystem}'>
                                       title="${bean.govElement.name}"
                               </c:if>
                           	>
	                            <label for="name">
		                            <c:if test='${bean.govElement.isSystem}'>
		                                 ${ctp:i18n(bean.govElement.name)}
		                            </c:if>
		                            <c:if test='${!bean.govElement.isSystem}'>
		                                 ${v3x:getLimitLengthString(bean.govElement.name,12,'...')}
		                            </c:if>
	                            </label>
                           </td>
                           <td width="10%" align="right"></td>
                           <td width="18%" align="left">
                            	<label for="a1">
                           			<input type="radio" id="a1" name="${bean.govElement.elementId}" value="0" checked <c:if test="${param.flag == 'readonly' or 'zhihui' eq policyLabel}">  disabled </c:if> >
                            	</label>
                           </td>
                           <td width="10%" align="right"></td>
                           <td width="18%" align="left">
                           		<label for="a2">
									<input type="radio" id="a2" name="${bean.govElement.elementId}" value="1"  <c:if test="${param.flag == 'readonly' or 'zhihui' eq policyLabel}">  disabled </c:if> >
                           		</label>
                           </td>                                                               
                      	</tr>
                    </c:when>
                    <c:when test="${bean.access == 1 }">
                    	<tr>
                           	<td class="new-column" width="25%" nowrap="nowrap"
                               <c:if test='${bean.govElement.isSystem}'>
                                       title=${ctp:i18n(bean.govElement.name)}
                               </c:if>
                               <c:if test='${!bean.govElement.isSystem}'>
                                       title="${bean.govElement.name}"
                               </c:if>
                           	>
	                           	<label for="name">
	                            	<c:if test='${bean.govElement.isSystem}'>
	                                   ${ctp:i18n(bean.govElement.name)}
	                               	</c:if>
	                                <c:if test='${!bean.govElement.isSystem}'>
	                                    ${v3x:getLimitLengthString(bean.govElement.name,12,'...')}
	                                </c:if>
	                           	</label>
                      		</td>
                      		<td width="10%" align="right"></td>
                            <td width="18%" align="left">
                    			<label for="a3">
                    				<input type="radio" id="a3" name="${bean.govElement.elementId}" value="0" <c:if test="${param.flag == 'readonly'}">  disabled </c:if> >
                    			</label>
                            </td>
                            <td width="10%" align="right"></td>
                            <td width="18%" align="left">
                            	<label for="a4">
                            		<input type="radio" id="a4" name="${bean.govElement.elementId}" value="1" checked <c:if test="${param.flag == 'readonly'}">  disabled </c:if> >
                            	</label>
                            </td>                                                              
                        </tr>                                                               
                  	</c:when>
                    <c:otherwise>
                        <tr>
                            <td class="new-column" width="25%" nowrap="nowrap"
                                <c:if test='${bean.govElement.isSystem}'>
                                        title=${ctp:i18n(bean.govElement.name)}
                                </c:if>
                                <c:if test='${!bean.govElement.isSystem}'>
                                        title="${bean.govElement.name}"
                                </c:if>
                            >
                            	<label for="name">
                                   	<c:if test='${bean.govElement.isSystem}'>
                                       ${ctp:i18n(bean.govElement.name)}
                                   	</c:if>
                                   	<c:if test='${!bean.govElement.isSystem}'>
                                       ${v3x:getLimitLengthString(bean.govElement.name,12,'...')}
                                   	</c:if>
                           		</label>
                         	</td>
                         	<td width="10%" align="right"></td>
                            <td width="18%" align="left">
                            	<label for="a5">
                                   	<input type="radio" id="a5" name="${bean.govElement.elementId}" value="0" checked <c:if test="${param.flag == 'readonly'}">  disabled </c:if> >
                                </label>
                           	</td>
                           	<td width="10%" align="right"></td>
                            <td width="18%" align="left">
                              	<label for="a6">
                              		<input type="radio" id="a6" name="${bean.govElement.elementId}" value="1" <c:if test="${param.flag == 'readonly'}">  disabled </c:if> >
                              	</label>
                            </td>                                       
                       	</tr>            
                  	</c:otherwise>
               		</c:choose>
           		</c:forEach>
			</table>
		</div>
	</div><!-- stadic_layout_body -->	
  <div class=" stadic_layout_footer stadic_footer_height" align="right" style="position:absolute;bottom:0;width:100%;line-height:30px;background:#F3F3F3;">
    <input type="button" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2 margin_r_5 margin_t_5" onclick="oprateSubmit();">
    <input type="button" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2 margin_r_10 margin_t_5" onclick="closeDialog();">
  </div><!-- stadic_layout_footer -->
</form>
</div>  
</body>
</html>