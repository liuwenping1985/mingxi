<%@include file="../header.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.hr.resource.i18n.HRResources" var="v3xHRI18N"/>
<c:set var="dis" value="${v3x:outConditionExpression(readOnly, 'disabled', '')}" />
<c:set var="ro" value="${v3x:outConditionExpression(readOnly, 'readOnly', '')}" />
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td width="50%" valign="top">
    <fieldset style="width:95%;border:0px;" align="center">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td rowspan="${v3x:getSysFlagByName('sys_isGovVer')=='true' ? 6:5}" align="center" width="25%">
                	<div style="border: 1px #CCC solid; width:106px; height:126px; text-align: center; background-color: #FFF;">
						<div style="width:100px; height:120px; margin-top: 2px; text-align: center;">
							<c:choose>
								<c:when test="${image == '0'}">
									<img src="/seeyon/fileUpload.do?method=showRTE&fileId=${staff.image_id}
										&createDate=<fmt:formatDate value='${staff.image_datetime}' type='both' dateStyle='full' pattern='yyyy-MM-dd'/>&type=image" width="100" height="120" />
								</c:when>
								<c:otherwise>
									<img src="<c:url value="/apps_res/hr/images/photo.JPG" />" width="100" height="120" />
								</c:otherwise>
							</c:choose>
						</div>
					</div>
                </td>
			  	<td class="bg-gray" width="25%" nowrap="nowrap">
			  		<label for="code"><fmt:message key="addressbook.account_form.code.label"/>:</label>
			  	</td>
				<td class="new-column" width="50%">
					<input class="input-100per" type="text" name="code" id="code" readonly="readonly" ${dis} value="${member.code}" />
				</td>
			</tr>			
		   	<tr>
		     <td class="bg-gray" width="25%" nowrap="nowrap"><label for="gender"><fmt:message key="hr.staffInfo.sex.label" bundle="${v3xHRI18N}"/>:</label></td>
		     <td class="new-column" width="50%">
				<c:choose>
	  	            <c:when test="${tel.gender == '1'}">
	  	            	<input class="input-100per" type="text" name="gender" id="gender" inputName="<fmt:message key='hr.staffInfo.sex.label' bundle='${v3xHRI18N}'/>" value="<fmt:message key='hr.staffInfo.male.label' bundle='${v3xHRI18N}'/>" readonly="readonly" ${dis}/>	                  
			        </c:when>
			        <c:when test="${tel.gender == '2'}">
			        	<input class="input-100per" type="text" name="gender" id="gender" inputName="<fmt:message key='hr.staffInfo.sex.label' bundle='${v3xHRI18N}'/>" value="<fmt:message key='hr.staffInfo.female.label' bundle='${v3xHRI18N}'/>" readonly="readonly" ${dis}/>	    
		            </c:when>
		            <c:otherwise>
		            	<input class="input-100per" type="text" name="gender" id="gender" inputName="<fmt:message key='hr.staffInfo.sex.label' bundle='${v3xHRI18N}'/>" value="" readonly="readonly" ${dis}/>
		            </c:otherwise>
		        </c:choose>
			</td>		     
		   </tr>	
		   
		   <%--GOV-2005 edoc1/123456进入常用工具-通讯录-员工通讯录界面，列表中点击某人姓名查看其名片信息，【政治面貌】应该显示在【性别】下方。 --%>
		   <c:if test ="${(v3x:getSysFlagByName('sys_isGovVer')=='true')}">
			<tr>
				<td class="bg-gray" width="25%" nowrap="nowrap"><label for="political_position"><fmt:message key="org.memberext_form.base_fieldset.political_position" bundle="${orgI18N }"/>:</label></td>
				<td class="new-column" width="50%">
							<select class="input-100per" name="political_position" id="political_position" disabled>
				                <option value="-1"></option>
				                <v3x:metadataItem metadata="${hrMetadata['hr_staffInfo_position']}" showType="option" name="political_position" selected="${staff.political_position}"/>
				  			</select>
				</td>
			</tr>	
			</c:if>
		   	   
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><label for="memeber.familyPhone"><fmt:message key="addressbook.company.telephone.label" />:</label></td>
				<td class="new-column" width="50%" nowrap="nowrap">
				<input class="input-100per" type="text" name="familyPhone"  ${ro} validate="isNumber"  intgerDigits="15" decimalDigits="0" id="familyPhone" inputName="<fmt:message key="addressbook.company.telephone.label" />" value="${officeNum}"  readonly="readonly"/>
			  </td>
			</tr>
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap"><label for="memeber.mobilePhone"><fmt:message key="addressbook.mobilephone.label" />:</label></td>
				<td class="new-column" width="50%" nowrap="nowrap">
				<input type="text" ${ro}  inputName="<fmt:message key="addressbook.mobilephone.label" />" name="mobilePhone" id="mobilePhone" class="input-100per" validate="isNumber"  intgerDigits="20" decimalDigits="0" value="${tel.telNumber }"  readonly="readonly"/>
			  </td>
			</tr>
			<tr>
				<td class="bg-gray" width="25%" nowrap="nowrap"><label for="memeber.email"><fmt:message key="org.member.emailaddress" bundle="${orgI18N }"/>:</label></td>
				<td class="new-column" width="50%">
					<input class="input-100per" type="text" name="email" id="email" ${ro} validate="isEmail" readonly="readonly" inputName="<fmt:message key="org.member.emailaddress" bundle="${orgI18N }"/>" value="${v3x:toHTML(tel.emailAddress)}" />
				</td>
			</tr>	
		</table>
	</fieldset>
	<p></p>    	
    </td>
    <td valign="top">
    	<fieldset style="width:95%;border:0px;" align="center">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap">
			  		<label for="deptName"><fmt:message key="addressbook.company.department.label" />:</label>
			  	</td>
				<td class="new-column" width="75%" nowrap="nowrap">
					<input class="input-100per" type="text" name="deptName" readonly="readonly" ${dis} id="deptName" title="${v3x:showDepartmentFullPath(tel.orgDepartmentId)}" value="${v3x:showDepartmentFullPath(tel.orgDepartmentId)}" />
			    </td>
			</tr>
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap">
			  		<label for="postName"><fmt:message key="addressbook.account_form.primaryPost.label" />:</label>
			  	</td>
				<td class="new-column" width="75%" nowrap="nowrap">
				<input type="text" readonly="readonly" ${dis} name="postName" id="postName" class="input-100per" title="${member.post_name}" value="${member.post_name}"/>
			  </td>
			</tr>
			<c:if test="${tel.isInternal == 'true'}">
			<tr>
				<td class="bg-gray" width="25%" nowrap="nowrap">
					<label for="deptId1"><fmt:message key="addressbook.account_form.secondPost.label" />:</label>
				</td>
				<td class="new-column" width="75%" nowrap="nowrap">					
					<input class="input-100per" type="text" name="secondPosts" readonly="readonly" id="secondPosts" ${dis} value="${member.second_posts}" title="${member.second_posts}"/> 			
				</td>
			</tr>
			</c:if>
			<c:if test="${isEnableLevel=='true'}">
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap">
			  		<label for="levelName"><fmt:message key="addressbook.company.level.label${v3x:suffix()}" />:</label>
			  	</td>
				<td class="new-column" width="75%">
				<input class="input-100per" type="text" name="levelName" readonly="readonly" ${dis} id="levelName" value="<c:out value="${member.level_name}" escapeXml="true"/>" />
			  </td>
			</tr>
			</c:if>
			<%--gov --%>
			<c:if test ="${(v3x:getSysFlagByName('sys_isGovVer')=='true')}">
			<tr>
			  	<td class="bg-gray" width="25%" nowrap="nowrap">
			  		<label for="dutyLevelName"><fmt:message key="addressbook.company.dutylevel.label${v3x:suffix()}" />:</label>
			  	</td>
				<td class="new-column" width="75%">
				<input class="input-100per" type="text" name="dutyLevelName" readonly="readonly" ${dis} id="dutyLevelName" value="${member.dutyLevelName}" />
			  </td>
			</tr>
			</c:if>
			
			<c:if test="${tel.isInternal == 'true'}">
			<tr>
				<td class="bg-gray" width="25%" nowrap="nowrap">
					<label for="deptId2"><fmt:message key="addressbook.account_form.partTimePost.label" />:</label>
				</td>
				<td class="new-column" width="75%" nowrap="nowrap">					
					<input class="input-100per" type="text" name="specialSecondPost" readonly="readonly" id="specialSecondPost" ${dis}  value="${specialSecondPost}" title="${specialSecondPost}"/> 			
				</td>
			</tr>
			</c:if>
		</table>
		</fieldset>
	<p></p>    	
    </td>
  </tr>
  <tr>
    <td valign="top">
	    <fieldset style="width:95%;border:0px;" align="center">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td align="left" width="18%" nowrap="nowrap"><label for="memeber.communication"><fmt:message key="hr.staffInfo.communication.label" bundle="${v3xHRI18N}"/>:</label></td>
					<td class="new-column" width="82%">
						<input class="input-100per" type="text" name="communication" id="communication" ${ro} readonly="readonly" value="${v3x:toHTML(contact.communication) }" />
					</td>
				</tr>
				<tr>
					<td align="left" width="18%" nowrap="nowrap"><label for="memeber.postcode"><fmt:message key="addressbook.account_form.postcode.label" />:</label></td>
					<td class="new-column" width="82%" nowrap="nowrap">
						<input class="input-100per" type="text"inputName="<fmt:message key="addressbook.account_form.postcode.label" />" name="postcode" ${ro} validate="isNumber" intgerDigits="6" decimalDigits="0" id="postcode" readonly="readonly" value="${v3x:toHTML(contact.postalcode)}" />
					</td>
				</tr>
				<tr>
					<td align="left" width="18%" nowrap="nowrap"><label for="website"><fmt:message key="addressbook.account_form.website.labe" />:</label></td>
					<td class="new-column" width="82%" nowrap="nowrap">
						<input type="text" ${ro} name="website" id="website" class="input-100per" readonly="readonly" value="${v3x:toHTML(contact.website)}" />
					</td>
				</tr>
				<tr>
					<td align="left" width="18%" nowrap="nowrap"><label for="blog"><fmt:message key="addressbook.account_form.blog.label" />:</label></td>
					<td class="new-column" width="82%" nowrap="nowrap">
						<input class="input-100per" type="text" name="blog"  ${dis} id="blog" readonly="readonly" value="${v3x:toHTML(contact.blog) }" />
					</td>
				</tr>					
			</table>
		</fieldset>
		<p></p>    	
    </td>
    <td valign="top">
    	<fieldset style="width:95%;border:0px;" align="center">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td class="bg-gray" width="25%" nowrap="nowrap" valign="top"><label for="description"><fmt:message key="addressbook.account_form.memo.label" />:</label></td>
					<td class="new-column" width="75%" nowrap="nowrap">
						<textarea name="description" id="description" rows="" maxlength="200" cols="41" inputName="<fmt:message key='addressbook.account_form.memo.label' />" validate="maxLength" maxSize="200" ${dis } readonly="readonly" style="height: 90px;">${tel.description}</textarea>
					</td>
				</tr>
			</table>
		</fieldset>
		<p></p>    	
    </td>
  </tr> 
</table>