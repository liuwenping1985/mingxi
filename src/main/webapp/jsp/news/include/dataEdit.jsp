<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/taglib.jsp" %>
<script type="text/javascript">
<!--
	var url = null;
	var quantity = null;
	var oldSize = null;
	/**
   	* 上传图片
   	*/
   	function uploadImage4News(){
   		var imageId = document.getElementById("imageId");
   		if(imageId.value != null && imageId.value != "" && imageId.value != 1){
   			alert(v3x.getMessage("NEWSLang.imagenews_imageuploaded"));
   			return ;
   		}
   		url = downloadURL;
   		quantity = fileUploadQuantity;
   		var attachments = fileUploadAttachments;
   		oldSize = fileUploadAttachments.size();
   		downloadURL = "<html:link renderURL='/fileUpload.do?type=5&applicationCategory=0&extensions=jpeg,jpg,png,gif'/>";
   		fileUploadQuantity = 1;
	    insertAttachment(null, null, 'callbackUploadImage4News', 'false');
	    downloadURL = url;
	}
	
	function callbackUploadImage4News(){
		var newSize = fileUploadAttachments.size();
	    if(newSize != oldSize){
			var imgAttId = fileUploadAttachments.keys().get(fileUploadAttachments.size()-1);//获得上传图片ID
			var imageId = document.getElementById("imageId");
			imageId.value = imgAttId;
	    }
	   	downloadURL = url;
	   	fileUploadQuantity = quantity;
	   	resizeFckeditor();
	}
	
	function changeCheckBox(){
		var imageNews = document.getElementById("imageNews");
		//var focusNews = document.getElementById("focusNews");
		var upload = document.getElementById("upload");
		if(imageNews.checked ){
			upload.style.display = "";
		} else {
			upload.style.display = "none";
		}
	}
	function openAdvancedWindow(){
		v3x.openWindow({
			url: "${newsDataURL}?method=openAdvance&spaceType=${param.spaceType}",
			width:"400",
			height:"200",
			scrollbars:"no"
		});
	}
//-->
</script>
<style>
#officeFrameDiv{height:100%;}
.input-100per{width: 99%;}
.cke_wysiwyg_frame{height:93%!important;}
</style>
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center">
		<tr>
			<td height="10">
				<script type="text/javascript">document.write(myBar);</script>
                <div class="hr_heng"></div>
			</td>
		</tr>
		<tr >
        <td height="10" class="bg-summary padding_t_10 padding_r_5">
		<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center" >
		<tr class="bg-summary" >
		<fmt:message key="oper.send" var="oper_send"/>
		<fmt:message key="news.save" var="news_save"/>
		<fmt:message key="oper.publish" var="oper_publish"/>
		<td rowspan="3" width="1%" nowrap="nowrap" valign="top"><a onclick="javaScript:saveForm('submit');" id='sendId'  class="margin_lr_10 display_inline-block align_center new_btn">${param.isAuditEdit?news_save:(isAduit?oper_send:oper_publish)}</a></td>
			<td width="1%" class=" bg-gray" nowrap><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}"/><fmt:message key="label.colon" />
			</td>
			<td width="25%" align="left">
					<fmt:message key="news.data.title" var="_myLabel"/>
					<fmt:message key="label.please.input" var="_myLabelDefault">
						<fmt:param value="${_myLabel}" />
					</fmt:message>
					<c:set var="_value" value="${v3x:toHTML(bean.title)}" />
					<input type="text" class="input-100per" name="title" id="title"
						value="<c:out value="${bean.title}" default="${_myLabelDefault}" escapeXml="true" />" 
						title="${_value}"
						defaultValue="${_myLabelDefault}"
						onfocus="checkDefSubject(this, true)"
						onblur="checkDefSubject(this, false)"
						inputName="${_myLabel}"
						validate="notNull,isDefaultValue,isWord"
						maxSize="65"
					
						${v3x:outConditionExpression(readOnly, 'disabled', '')}
					/>
			</td>
			<td width="15%" class="label bg-gray" nowrap><fmt:message key="news.data.type" /><fmt:message key="label.colon" /></td>
			<td width="25%">
				<c:choose>
					<c:when test="${custom}">
						<input type="text" class="input-100per" name="types" id="types" value="${theType.typeName}" readonly="true" disabled="true"/>
						<input type="hidden" name="typeId" id="typeId" value="${theType.id}" />
					</c:when>
					<c:otherwise>
						<c:set var="disable" value="disabled='disabled'"/>
						<select name="typeId" id="typeId" class="cursor-hand input-100per"  ${param.isAuditEdit eq 'true'?disable:''} onchange="typeChange();">
			    		<c:forEach items="${newsTypeList}" var="newsType">
							<c:choose>
								<c:when test="${bean.type.id == newsType.id}" >
									<option value="${newsType.id}" selected>${v3x:toHTML(newsType.typeName)}</option>
								</c:when>
								<c:otherwise>
									<option value="${newsType.id}" >${v3x:toHTML(newsType.typeName)}</option>
								</c:otherwise>
							</c:choose>
						</c:forEach>
		    		</select>
					</c:otherwise>
				</c:choose>
					</td>
			<td width="15%" class="label bg-gray"  nowrap><fmt:message key="news.data.publishDepartmentId" /><fmt:message key="label.colon" /></td>
			<td width="25%">
				<c:set value="${v3x:getOrgEntity('Department', bean.publishDepartmentId).name}" var="publishScopeValue"/>
				<c:set value="${v3x:parseElementsOfIds(bean.publishDepartmentId, 'Department')}" var="defauDepar"/>
				<v3x:selectPeople id="dept" originalElements="${defauDepar}" panels="Department" selectType="Department" jsFunction="setNewsPeopleFields(elements,'publishDepartmentId','publishDepartmentName')" maxSize="1" minSize="1" />
				<script type="text/javascript">
								if('${bean.type.spaceType}' != '3')
					onlyLoginAccount_dept = true;
				</script>
				<fmt:message key="news.data.publishDepartmentId" var="_myLabel"/>
				<fmt:message key="label.please.select" var="_myLabelDefault">
					<fmt:param value="${_myLabel}" />
				</fmt:message>
				<input type="hidden" id="publishDepartmentId" name="publishDepartmentId" value="${bean.publishDepartmentId}"/>
				<input type="text" class="cursor-hand input-100per" id="publishDepartmentName" name="publishDepartmentName" readonly="true"  
					value="<c:out value="${publishScopeValue}" default="${_myLabelDefault}" escapeXml="true" />"
					defaultValue="${_myLabelDefault}"
					onfocus="checkDefSubject(this, true)"
					onblur="checkDefSubject(this, false)"
					inputName="${_myLabel}" 
					validate="notNull,isDefaultValue"
					${v3x:outConditionExpression(readOnly, 'disabled', '')}
					onclick="selectPeople('dept','publishDepartmentId','publishDepartmentName');"
					/>
			</td>
	   </tr>
	   <tr class="bg-summary">
	   		<td width="1%" class=" bg-gray" nowrap><fmt:message key="news.data.brief" /><fmt:message key="label.colon" /></td>
			<td width="25%">
				<fmt:message key='news.data.brief' var="_myLabel" /> 
				<fmt:message key="label.please.input" var="_myLabelDefault">
					<fmt:param value="${_myLabel}" />
				</fmt:message> 
				<input type="text" class="input-100per" name="brief" id="brief" value="<c:out value="${bean.brief}" default="" escapeXml="true" />"
					inputName="${_myLabel}" validate="maxLength" maxSize="120" />
			</td>
	   		<td class="label bg-gray" width="15%" nowrap><fmt:message key="news.data.keywords" /><fmt:message key="label.colon" /></td>
			<td width="25%">
				<fmt:message key="news.data.keywords" var="_myLabel" /> 
				<fmt:message key="label.please.input" var="_myLabelDefault">
					<fmt:param value="${_myLabel}" />
				</fmt:message> 
				<input type="text" class="input-100per" name="keywords" id="keywords" value="<c:out value="${bean.keywords}" default="" escapeXml="true" />"
					inputName="${_myLabel}" validate="maxLength" maxSize="60" />
			</td>
			<td class="label bg-gray" width="15%" nowrap><fmt:message key="news.template" /><fmt:message key="label.colon" /></td>
			<td width="25%">
				<select name="templateId" id="templateId" onchange="loadNewsTemplate();">
					<option value="">&lt;<fmt:message key="oper.please.select" /><fmt:message key="news.template" />&gt;</option>
					<c:forEach items="${templateList}" var="template">
						<option value="${template.id}">${v3x:toHTML(template.templateName)}</option>
					</c:forEach>
					<script type="text/javascript">
						var ops = $('templateId').options;
						if('${param.tempIndex}' == null || '${param.tempIndex}' == '')
							ops[0].selected = true;
						else
							ops['${param.tempIndex}'].selected = true;
					</script>
			</td>
	   </tr>
	   <tr class="bg-summary">
	   <td width="1%"></td>
	   <td class="padding_b_5 padding_t_5">
			<div class="div-float">
				<input type="checkbox" name="showPublishUserFlag" id="showPublishUserFlag"  ${v3x:outConditionExpression(bean.showPublishUserFlag, 'checked', '')}/>&nbsp;<label for="showPublishUserFlag"><fmt:message key="news.dataEdit.showPublishUser"/></label>	
	   			<input type="checkbox" name="imageNews" id="imageNews" onclick="changeCheckBox()" ${v3x:outConditionExpression(bean.imageNews, 'checked', '')} />&nbsp;<label for="imageNews"><fmt:message key='news.image_news' /></label>
	   			<input type="hidden" name="imageId" id="imageId" value="${bean.imageId}">&nbsp;&nbsp;
	   			<label for="c" style="${bean.dataFormat == 'OfficeWord' || bean.dataFormat == 'WpsWord' ? '' : 'display: none;'}" id="changePdf">
                   <input type="checkbox" name="changePdf" id="c" ${empty bean.ext5 ? '' : 'checked'}><fmt:message key="common.transmit.pdf" bundle='${v3xCommonI18N}' />
                </label>
	   		</div>
			<span id="upload" style="display:none;">
				<div class="div-float"><input type="button" name="uploadImage" class="button-default-2 button-default-2-long" id="uploadImage" value="<fmt:message key='news.upload.image' />" onclick="javascript:uploadImage4News();"></div>
				<div id="attachment5Area" style="width:100%;height:100%" class="div-float"></div>
			</span>
			<script type="text/javascript">
				var imageId = '${bean.imageId}';
				var imageNews = document.getElementById("imageNews");
				if(imageNews.checked && imageId != null && imageId != "" && imageId != 1){
					document.getElementById("upload").style.display = "";
				}
			</script>
	   </td>
       <td class="label bg-gray" width="15%" nowrap>
           <label style="${bean.dataFormat == 'HTML' ? '' : 'display:none;'}" id="share_weixin_1">
               <fmt:message key="news.share" /><fmt:message key="label.colon" />
           </label>
       </td>
       <td width="25%" >
       <%--<label for="shareDajia">
           <input type="checkbox" name="shareDajia" id="shareDajia" ${v3x:outConditionExpression(bean.shareDajia, 'checked', '')}/>
           <span><fmt:message key="news.share.dajia" /></span>
       </label> --%>
       <label for="shareWeixin" style="${bean.dataFormat == 'HTML' ? '' : 'display:none;'}" id="share_weixin_2">
           <input type="checkbox" name="shareWeixin" id="shareWeixin" ${v3x:outConditionExpression(bean.shareWeixin, 'checked', '')}/>
           <span><fmt:message key="news.share.weixin" /></span>
       </label>   
       </td>
       		<td  width="40%"  colspan="2" id="space"  style="${outerSpace == null ? 'display:none;' : ''}" ><label for="pushToSpace" id="pushToSpace1">
           <script type="text/javascript">
    	   	function cancelOption(){
				if("${spaceFlag}"=="true"){
					if(!document.getElementById("pushToSpace").checked){
						if(!confirm("确认删除在门户栏目的数据？")){
							document.getElementById("pushToSpace").checked = true;
						}
					}
				}
    	      }
    	   </script>
           <input type="checkbox" name="pushToSpace" id="pushToSpace" value="1" onclick="cancelOption();"  ${spaceFlag==true ?'checked':''} />
           <span>推送门户</span>
       </label>   
       <label for="outerSpace" id="outerSpace1">
           <input type="text" class=="input-100per" name="outerSpace" id="outerSpace" readonly="true"  value="${outerSpace.sectionLabel}" }"/>
            <input type="hidden" id="outerSpaceId" name="outerSpaceId" value="${outerSpace.id}"/>
       </label>   </td>
	   </tr>
	   <!-- 在此处添加关联文档 -->
		<tr id="attachment2TR"  style="display:none;">
            <td colspan="2" valign="top"></td>
            <td colspan="3" valign="top">
            <div style="float: left"><fmt:message key="common.mydocument.label" bundle="${v3xCommonI18N}" />:</div>
            <div>
       		<div class="div-float">(<span id="attachment2NumberDiv"></span>)</div>
           <div></div><div id="attachment2Area" style="overflow: auto;"></div></div>
         </tr>
		<tr id="attachmentTR" style="display:none;">
            <td colspan="2" valign="top"></td>
            <td colspan="3" valign="top">
            <div style="float: left"><fmt:message key="label.attachments" /><fmt:message key="label.colon" /></div>
            <div>
                <div class="div-float">(<span id="attachmentNumberDiv"></span>)</div>
                <v3x:fileUpload attachments="${attachments}" canDeleteOriginalAtts="true" />
            </div>
        </tr>
		</table></td></tr>
		<tr>
		  	<td colspan="9" height="6" class="bg-b"></td>
		 </tr>
		<tr>
			<td id="editerDiv_td" valign="top" height="100%" >
			<div id="editerDiv">
				<c:if test="${originalNeedClone==null}">
					<c:set var="originalNeedClone" value="false" scope="request" />
				</c:if>

				<v3x:editor htmlId="content" content="${bean.content}" type="${bean.dataFormat}" createDate="${bean.createDate}" category="6" originalNeedClone="${originalNeedClone}" />
			</div>
			</td>
		</tr>
	</table>
