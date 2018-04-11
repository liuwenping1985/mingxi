<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>
<%@ include file="/WEB-INF/jsp/apps/common/INC/noCache.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="metadata.manager.typename.lable" bundle="${v3xMainI18N}"/></title>
</head>
  <body  scroll="no" onkeydown="listenerKeyESC()">
    <form action="${metadataMgrURL}?method=createNewMetaDataType"   method="post" target="saveNewMetaDataType" onsubmit="return (checkForm(this) && checkRepeatCategoryName(this))">
    <input type="hidden" name=isSystem value="${type}">
    <input type="hidden" name=metadataID value="${matadata.id}">
    <input type="hidden" name=from value="${param.from}">
      <table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0" class="popupTitleRight" >
          <tr>
             <td height="20" valign="bottom" class="PopupTitle"><fmt:message key="metadata.manager.typename.editor" bundle="${v3xMainI18N}"/> </td>
          </tr>
          
          <tr>
             <td height="20"></td>
          </tr>
          
           <tr>
             <td>
	              <table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0" class="">
		               <tr>
		                 <td width= "25%" height="28" class="" align="right"> <font color="red">*</font><fmt:message key="common.name.label" bundle="${v3xCommonI18N}"/>:&nbsp;&nbsp;</td>
		                 <td width=""><fmt:message key="common.default.name.value" var="defSubject" bundle="${v3xCommonI18N}" />
			    		  <input name="typeName" type="text" id="subject" class="input-80per cursor-hand" maxlength="20"
		               	         value="<c:out value="${metadataName}" />"  validate="notNull,maxLength,isWord"   character="\\/|><*?'&%$"  inputName="<fmt:message key="common.name.label" bundle="${v3xCommonI18N}"/>"
		               	   /></td>
		                   </tr>
		                   <tr>
		                        <fmt:message key='common.sort.label' bundle="${v3xCommonI18N}" var='sortLabel' />
			                    <td height="28" align="right"><font color="red">*</font> ${sortLabel}:&nbsp;&nbsp;&nbsp;</td>
			                    <td>
			                    <input id="sort" name="sortNum" type="text" class="input-80per"
			                           value="<c:out value="${matadata.sort}" />"
					                   validate="notNull,isInteger" maxSize="8" maxlength="8" inputName="${sortLabel}" />
			                    </td>
		                   </tr>
				                   
						<tr>
							<td width="25%" height="24" valign="top" nowrap="nowrap" class="" align="right"><label for="memo"><fmt:message key="metadata.enum.description.label"/></label>:&nbsp;&nbsp;&nbsp;</td>
							<td class="new-column" width="75%">
								<textarea id="description" name="textarea" rows="6" cols=""  class="input-80per"  validate="maxLength" maxSize="60" inputName="${descriptionLabel}" >${matadata.description}</textarea>
								</td>
						</tr>		                   
               
	             </table>
             </td>
           </tr>
           
           <tr>
            <td align="center" class="bg-advance-bottom" >
             <input type="submit"  class="button-default-2" 
                    value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />"
                    id="b1" name="b1"
             />&nbsp;&nbsp;&nbsp;&nbsp;
             <input type="button" onclick="JavaScript:window.close();" class="button-default-2"
                    value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />"
                    id="b2" name="b2"
             />
            </td>
           </tr>
           
      </table>
    </form>
    <iframe name="saveNewMetaDataType" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
  </body>
  
</html>