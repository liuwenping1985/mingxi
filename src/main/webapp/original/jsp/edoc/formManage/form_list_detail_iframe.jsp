<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<input type="hidden" name="method_type" id="method_type" value="change" />
<input type="hidden" name="att_fileUrl" id="att_fileUrl" value="${att_fileUrl}">
<input type="hidden" name="att_createDate" id="att_createDate" value="${att_createDate}">
<input type="hidden" name="att_mimeType" id="att_mimeType" value="${att_mimeType}">
<input type="hidden" name="att_filename" id="att_filename" value="${att_filename}">
<input type="hidden" name="att_needClone" id="att_needClone" value="${att_needClone}">
<input type="hidden" name="att_description" id="att_description" value="${att_description}">
<input type="hidden" name="att_type" id="att_type" value="${att_type}">
<input type="hidden" name="att_size" id="att_size" value="${att_size}">
<input type="hidden" name="id" id="id" value="${bean.id}">
<input type="hidden" id="file_name" name="file_name" value="">
<input type="hidden" id="content" name="content" value="" >
<input type="hidden" id="element_id_list" name="element_id_list" value="<c:out value='${element_id_list}' escapeXml='true'/>" >
<input type="hidden" id="mx" name="mx">
<input type="hidden" id="original_xml" name="original_xml" value="${original_xml}" >

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr >
  	<td width="20%" valign="top">
 		<table width="95%" border="0" cellspacing="0" cellpadding="3" align="center">
 			<tr><td class="label" align="left"><fmt:message key="edoc.form.name" /> <fmt:message key="edoc.symbol.colon" /></td></tr>
 			<tr>	
 				<td class="new-column" nowrap="nowrap">
					<input name="name" type="text" id="name" class="input-20per" deaultValue="${bean.name}" maxSize="125" 
					inputName="<fmt:message key="edoc.form.name" />"
					validate="notNull,maxLength" <c:if test="${param.flag == 'readonly'}"> disabled </c:if> 
					    value="<c:out value="${bean.name}" escapeXml="true" default='${bean.name}' />"
					     />
				</td>	
			</tr>
 			<tr><td class="label" align="left"><fmt:message key="edoc.form.sort" /> <fmt:message key="edoc.symbol.colon" /> </td></tr>
 			<tr>	
 				<td class="value" align="left">	
					<c:choose>	 
						 <c:when test='${bean.type=="0"}'>
							<input type="text" value="<fmt:message key="edoc.formstyle.dispatch" />" <c:if test="${param.flag == 'readonly'}"> disabled </c:if>>
						</c:when>			
						<c:when test='${bean.type=="1"}'>
							<input type="text" value="<fmt:message key="edoc.formstyle.receipt" />" <c:if test="${param.flag == 'readonly'}"> disabled </c:if>>
						</c:when>	
						<c:when test='${bean.type=="2"}'>
							<input type="text" value="<fmt:message key="edoc.formstyle.qianbao" />" <c:if test="${param.flag == 'readonly'}"> disabled </c:if>>
						</c:when>				
						<c:otherwise>
							<input type="text" value="" <c:if test="${param.flag == 'readonly'}"> disabled </c:if>>
						</c:otherwise>
					</c:choose>
				</td>	
			</tr>
 			<tr><td class="label" align="left"><fmt:message key="edoc.form.defaultform" /> <fmt:message key="edoc.symbol.colon" /> </td></tr>
 			<tr>	
 				<td class="new-column" nowrap="nowrap">
 				<c:choose>
 				<c:when test='${bean.isDefault==true}'>
 				<label for="isDefault1">
 				<input type="radio" name="isDefault" id="isDefault1" value="1" checked <c:if test="${param.flag == 'readonly'}"> disabled </c:if> /> <fmt:message key="edoc.form.yes" />	
 				</label>
 				<label for="isDefault2">
 				<input type="radio" name="isDefault" id="isDefault2" value="0" <c:if test="${param.flag == 'readonly'}"> disabled </c:if>  /> <fmt:message key="edoc.form.no" />
 				</label>
 				</c:when>
  				<c:when test='${bean.isDefault==false}'>
  				<label for="isDefault1">
 				<input type="radio" name="isDefault" id="isDefault1" value="1" <c:if test="${param.flag == 'readonly'}"> disabled </c:if> /> <fmt:message key="edoc.form.yes" />	
 				</label>
 				<label for="isDefault2">
 				<input type="radio" name="isDefault" id="isDefault2" value="0" checked <c:if test="${param.flag == 'readonly'}"> disabled </c:if> /> <fmt:message key="edoc.form.no" />
 				</label>
 				</c:when>
   				<c:otherwise>
   				<label for="isDefault1">
 				<input type="radio" name="isDefault" id="isDefault1" value="1" <c:if test="${param.flag == 'readonly'}"> disabled </c:if> /> <fmt:message key="edoc.form.yes" />	
 				</label>
 				<label for="isDefault2">
 				<input type="radio" name="isDefault" id="isDefault2" value="0" checked <c:if test="${param.flag == 'readonly'}"> disabled </c:if> /> <fmt:message key="edoc.form.no" />
 				</label>
 				</c:otherwise>
 				</c:choose>
				</td>	
			</tr>
 			<tr><td class="label" align="left"><fmt:message key="edoc.form.currentstatus" /> <fmt:message key="edoc.symbol.colon" /> </td></tr>
 			<tr>		
				<td class="new-column" nowrap="nowrap">
 				<c:choose>
 				<c:when test="${bean.status == 0}">
 				<label for="status1">
 				<input type="radio" id="status1" name="status" value="1" <c:if test="${param.flag == 'readonly'}"> disabled </c:if> /> <fmt:message key="edoc.element.enabled" />	
 				</label>
 				<label for="status2">
 				<input type="radio" id="status2" name="status" value="0" checked <c:if test="${param.flag == 'readonly'}"> disabled </c:if> /> <fmt:message key="edoc.element.disabled" />
 				</label>
				</c:when>
				<c:when test="${bean.status == 1}">
				<label for="status1">
 					<input type="radio" id="status1" name="status" value="1" checked <c:if test="${param.flag == 'readonly'}"> disabled </c:if> /> <fmt:message key="edoc.element.enabled" />	
 				</label>
 				<label for="status2">
 					<input type="radio" id="status2" name="status" value="0" <c:if test="${param.flag == 'readonly'}"> disabled </c:if> /> <fmt:message key="edoc.element.disabled" />
 				</label>
				</c:when>
				<c:otherwise>
				<label for="status1">
				<input type="radio" id="status1" name="status" value="1" <c:if test="${param.flag == 'readonly'}"> disabled </c:if> /> <fmt:message key="edoc.element.enabled" />	
				</label>
				<label for="status2">
 				<input type="radio" id="status2" name="status" value="0" checked <c:if test="${param.flag == 'readonly'}"> disabled </c:if> /> <fmt:message key="edoc.element.disabled" />
 				</label>
				</c:otherwise>
				</c:choose>
				</td>	
			</tr>
 			<tr><td class="label" align="left"><fmt:message key="edoc.form.displaycompanymark" /> <fmt:message key="edoc.symbol.colon" /> </td></tr>
 			<tr>	
 				<td class="new-column" nowrap="nowrap">
 				<c:choose>
 				<c:when test="${bean.showLog==true}">
 				<label for="showLog1">
 					<input type="radio" id="showLog1" name="showLog" value="1" checked <c:if test="${param.flag == 'readonly'}"> disabled </c:if> /> <fmt:message key="edoc.form.yes" />	
 				</label>
 				<label for="showLog2">
 					<input type="radio" id="showLog2" name="showLog" value="0" <c:if test="${param.flag == 'readonly'}"> disabled </c:if> /> <fmt:message key="edoc.form.no" />
 				</label>
 				</c:when>
 				<c:when test="${bean.showLog==false}">
 				<label for="showLog1">
  					<input type="radio" id="showLog1" name="showLog" value="1" <c:if test="${param.flag == 'readonly'}"> disabled </c:if> /> <fmt:message key="edoc.form.yes" />	
  				</label>
  				<label for="showLog2">
 					<input type="radio" id="showLog2" name="showLog" value="0" checked <c:if test="${param.flag == 'readonly'}"> disabled </c:if> /> <fmt:message key="edoc.form.no" />				
 				</label>
 				</c:when>
 				<c:otherwise>
 				<label for="showLog1">
  					<input type="radio" id="showLog1" name="showLog" value="1" <c:if test="${param.flag == 'readonly'}"> disabled </c:if> /> <fmt:message key="edoc.form.yes" />	
  				</label>
  				<label for="showLog2">
 					<input type="radio" id="showLog2" name="showLog" value="0" checked <c:if test="${param.flag == 'readonly'}"> disabled </c:if> /> <fmt:message key="edoc.form.no" />	 					
 				</label>
 				</c:otherwise>
				</c:choose>
				</td>
			</tr>
			<tr><td class="label" align="left"><fmt:message key="edoc.form.description" /> <fmt:message key="edoc.symbol.colon" /> </td></tr>
 			<tr>	
					<td class="new-column" width="75%" nowrap="nowrap"><textarea <c:if test="${param.flag == 'readonly'}"> disabled </c:if>
					class="input-100per" id="description" name="description" rows="6" maxSize="125" validate="maxLength"
					inputName="<fmt:message key="edoc.form.description" />"
					cols="54" value="<c:out value="${bean.description}" escapeXml="true" default='${bean.description}' />">${bean.description}</textarea></td>
			</tr>
 		</table>
  	</td>
	<div class=""><v3x:fileUpload attachments="${attachments}"  canDeleteOriginalAtts="true"  extensions="xsn" /></div>
    <td width="80%" align="left" valign="top">
    	<div id="download" name="download"></div>
    	<c:if test="${param.flag != 'readonly'}">
    	<div><A href="#" id="upload" name="upload" onclick="newcategory();" ><fmt:message key="edoc.form.uploadform" /></A></p></div>
    	</c:if>
    	<fieldset style="width:95%" align="center"><legend><strong><fmt:message key="edoc.form.formpreview" /></strong></legend>
		 <div style="display:none">
			<textarea id="xml" cols="40" rows="10">
				 ${xml}
         	</textarea>
			<textarea id="xsl" cols="40" rows="10">
				 ${xsl}
         	</textarea>   			
		 </div>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr><td>
			<div id="html" name="html" style="height:0px;"></div>
			<div id="img" name="img" style="height:0px;"></div>	 
			<div style="display:none">
			<textarea name="submitstr" id="submitstr" cols="80" rows="20"></textarea> <br/>
			</div>
		</td>
		</tr>
		</table>		
		</fieldset>
	</td>
   </tr>	
</table>

