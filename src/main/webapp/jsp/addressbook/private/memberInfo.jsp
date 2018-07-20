<%@include file="../header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.addressbook.resource.i18n.AddressBookResources"/>
<c:set var="dis" value="${v3x:outConditionExpression(disabled, 'disabled', '')}" />
<c:set var="ro" value="${v3x:outConditionExpression(readOnly, 'readOnly', '')}" />
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="50%">
    <div class="hr-blue-font"><legend><strong><fmt:message key="addressbook.fieldset.org.label"/></strong></legend></div>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><span class="colorRed">*</span><label for="name"><fmt:message key="addressbook.username.label"/>:</label></td>
				<td class="new-column" width="75%">
				<input type="hidden" id="memberId" name="memberId" value="${memberId}" />
				<input class="input-250px" type="text" name="name" id="name" maxSize="40" maxlength="40"
				inputName="<fmt:message key="addressbook.username.label"/>" validate="isDeaultValue,notNull,maxLength,notSpecChar"
					value="${v3x:toHTML(member.name)}" ${dis }/></td>
			</tr>
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><label for="category"><fmt:message key="addressbook.suoshuzu.label" />:</label></td>
				<td class="new-column" width="75%" nowrap="nowrap">
				<select ${dis } name="categoryId" id="categoryId" class="input-250px" inputName="<fmt:message key="addressbook.account_form.category.label" />">
				<option value="-1"><fmt:message key='addressbook.wu.label' /></option>
					<c:forEach items="${teams}" var="team">
						<c:choose>
							<c:when test="${member.category == team.id || tId == team.id}">
								<option value="${team.id}" selected>${v3x:toHTML(team.name)}</option>
							</c:when>
							<c:otherwise>
								<option value="${team.id}">${v3x:toHTML(team.name)}</option>
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</select>
				<c:if test="${param.edit eq '1' && param.mId != null && param.mId ne ''}">
					<input type='hidden' name='oldName' id='oldName' value='${v3x:toHTML(member.name)}' />
					<input type='hidden' name='oldCategoryId' id='oldCategoryId' value='${member.category}' />
				</c:if>
			  </td>
			</tr>
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><label for="companyName"><fmt:message key="addressbook.account_form.companyName.label" />:</label></td>
				<td class="new-column" width="75%" nowrap="nowrap">
				<input class="input-250px" type="text" name="companyName" id="companyName" validate="maxLength" maxSize="60" inputName="<fmt:message key='addressbook.account_form.companyName.label' />" value="${v3x:toHTML(member.companyName)}" ${dis }/>
			  </td>
			</tr>
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><label for="companyDept"><fmt:message key="addressbook.company.department.label" />:</label></td>
				<td class="new-column" width="75%" nowrap="nowrap">
				<input type="text" ${dis}
					name="companyDept" id="companyDept" class="input-250px"
					 value="${v3x:toHTML(member.companyDept)}" validate="maxLength" maxSize="15" inputName="<fmt:message key="addressbook.company.department.label" />"/>

			  </td>
			</tr>
			<tr>			
				<td class="bg-gray" width="25%" nowrap="nowrap"><label for="companyPost"><fmt:message key="addressbook.company.post.label" />:</label></td>
				<td class="new-column" width="75%" nowrap="nowrap">					
							<input ${dis } class="input-250px" type="text" name="companyPost"
				  			id="companyPost"
				  			value="${v3x:toHTML(member.companyPost)}" validate="maxLength" maxSize="15" inputName="<fmt:message key="addressbook.company.post.label" />"/> 			
				</td>
			</tr>
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><label for="companyLevel"><fmt:message key="addressbook.company.level.label${v3x:suffix()}" />:</label></td>
				<td class="new-column" width="75%">
				<input  class="input-250px" type="text" name="companyLevel" ${dis}
					id="companyLevel"
					value="${v3x:toHTML(member.companyLevel)}" validate="maxLength" maxSize="15" inputName="<fmt:message key="addressbook.company.level.label" />"/>
			  </td>
			</tr>
		</table>
	<p></p>
    </td>
     <td valign="top" width="50%">
    	 <div class="hr-blue-font" ><legend><strong><fmt:message key="addressbook.fieldset.contact.label"/></strong></legend></div>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><label for="memeber.companyPhone"><fmt:message key="addressbook.company.telephone.label"/>:</label></td>
				<td class="new-column" width="75%">
				<input class="input-250px" type="text" name="companyPhone" id="companyPhone" ${dis } ${ro} 
				 inputName="<fmt:message key="addressbook.company.telephone.label"/>"
					value="${member.companyPhone }" validate="maxLength,isPhoneNumber" maxSize="20"/></td>
			</tr>
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><label for="memeber.familyPhone"><fmt:message key="addressbook.account_form.familyphone.label" />:</label></td>
				<td class="new-column" width="75%" nowrap="nowrap">
				<input class="input-250px" type="text" name="familyPhone" ${dis } ${ro}  
					id="familyPhone" validate="maxLength,isPhoneNumber" maxSize="20" inputName="<fmt:message key="addressbook.account_form.familyphone.label" />"
					value="${member.familyPhone }" />
			  </td>
			</tr>
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><label for="memeber.mobilePhone"><fmt:message key="addressbook.mobilephone.label" />:</label></td>
				<td class="new-column" width="75%" nowrap="nowrap">
				<input class="input-250px" type="text" name="mobilePhone" ${dis } ${ro} validate="isInteger" max="19000000000" min="13000000000" 
					 id="mobilePhone"  inputName="<fmt:message key="addressbook.mobilephone.label" />"
					 value="${member.mobilePhone }" validate="maxLength,isInteger" maxSize="11"/>
			  </td>
			</tr>
			<tr>			
				<td class="bg-gray" width="25%" nowrap="nowrap"><label for="memeber.fax"><fmt:message key="addressbook.account_form.fax.labe" />:</label></td>
				<td class="new-column" width="75%" nowrap="nowrap">					
							<input class="input-250px" type="text" name="fax" inputName="<fmt:message key="addressbook.account_form.fax.labe" />"
				  			id="fax" ${dis } ${ro} 
				  			value="${member.fax }" validate="maxLength,isPhoneNumber" maxSize="20"/> 			
				</td>
			</tr>
			
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><label for="memeber.address"><fmt:message key="addressbook.account_form.address.label"/>:</label></td>
				<td class="new-column" width="75%">
				<input class="input-250px" type="text" name="address" id="address" ${dis } ${ro}
					value="${v3x:toHTML(member.address) }" validate="maxLength" maxSize="80" inputName="<fmt:message key="addressbook.account_form.address.label"/>"/></td>
			</tr>
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><label for="memeber.postcode"><fmt:message key="addressbook.account_form.postcode.label" />:</label></td>
				<td class="new-column" width="75%" nowrap="nowrap">
				<input class="input-250px" type="text"inputName="<fmt:message key="addressbook.account_form.postcode.label" />" name="postcode" ${ro} validate="isNumber,maxLength" maxSize="20" intgerDigits="6" decimalDigits="0"
					id="postcode"
					value="${member.postcode }" ${dis }/>
			  </td>
			</tr>
		</table>
		<p></p>
   	</td>
  </tr>
  <tr>
   <td width="50%">
    	 <div class="hr-blue-font"><legend><strong><fmt:message key="addressbook.fieldset.others.label"/></strong></legend></div>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><label for="memeber.email"><fmt:message key="org.member.emailaddress" bundle="${orgI18N }"/>:</label></td>
				<td class="new-column" width="75%">
				<input class="input-250px" type="text" name="email" maxSize="50" id="email" ${dis } ${ro} validate="isEmail,maxLength"
				 inputName="<fmt:message key="org.member.emailaddress" bundle="${orgI18N }"/>"
					value="${v3x:toHTML(member.email)}" /></td>
			</tr>
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><label for="blog"><fmt:message key="addressbook.account_form.blog.label" />:</label></td>
				<td class="new-column" width="75%" nowrap="nowrap">
				<input class="input-250px" type="text" name="blog"  ${dis}
					id="blog"
					value="${v3x:toHTML(member.blog) }" validate="maxLength,isUrl" maxSize="80" inputName="<fmt:message key="addressbook.account_form.blog.label"/>"/>
			  </td>
			</tr>
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><label for="website"><fmt:message key="addressbook.account_form.website.labe" />:</label></td>
				<td class="new-column" width="75%" nowrap="nowrap">
				<input type="text" ${ro} ${dis }
					name="website" id="website" class="input-250px"
					 value="${v3x:toHTML(member.website) }" validate="maxLength,isUrl" maxSize="80" inputName="<fmt:message key="addressbook.account_form.website.labe" />" />
			  </td>
			</tr>
			<tr>			
				<td class="bg-gray" width="25%" nowrap="nowrap"><label for="memeber.msn"><fmt:message key="addressbook.account_form.msn.label" />:</label></td>
				<td class="new-column" width="75%" nowrap="nowrap">					
							<input class="input-250px" type="text" name="msn"  inputName="<fmt:message key="addressbook.account_form.msn.label" />"
				  			id="msn" ${ro} ${dis }
				  			value="${v3x:toHTML(member.msn) }" validate="isEmail"/> 			
				</td>
			</tr>
			<tr>			
				<td class="bg-gray" width="25%" nowrap="nowrap"><label for="memeber.qq"><fmt:message key="addressbook.account_form.qq.label" />:</label></td>
				<td class="new-column" width="75%" nowrap="nowrap">					
							<input class="input-250px" type="text" name="qq"  inputName="<fmt:message key="addressbook.account_form.qq.label" />"
				  			id="qq" ${ro} ${dis } validate="isNumber,maxLength" maxSize="20" intgerDigits="15" decimalDigits="0"
				  			value="${member.qq }"/> 			
				</td>
			</tr>
		</table>
	<p></p>
    </td>
   <td width="50%" valign="top">
        <fmt:message key="addressbook.account_form.memo.label" var="descLable"/>
    	 <div class="hr-blue-font"><legend><strong>${descLable}</strong></legend></div>
		<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td class="new-column" width="90%">
				<textarea class="input-300px" name="memo" id="memo" rows="7" cols="" inputName="${descLable}" validate="maxLength" maxSize="200" ${dis } ${ro}>${member.memo}</textarea>
			</td>
		</tr>
		</table>
	<p></p>
    </td>
  </tr>
</table>