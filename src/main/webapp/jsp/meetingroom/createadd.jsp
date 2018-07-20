<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title></title>
		<%@ include file="header.jsp" %>
		<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.js${v3x:resSuffix()}" />"></script>
		<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.plugin.js${v3x:resSuffix()}" />"></script>
		<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.easyui.js${v3x:resSuffix()}" />"></script>
		<script type="text/javascript">
		function init(){
			var picId = document.getElementById("pic");
			var imgObj = "${imageObj}";
			var readOnly = "${readOnly}";
			if(readOnly == "true"){
				setReadOnly();
			}
			if(imgObj == null || imgObj == ""){//初始化时imgObj为空 就不显示图片
				picId.style.display = "none";
			}
			downloadURL = "<html:link renderURL='/fileUpload.do?type=0&applicationCategory=6'/>";
		}
		function addDoSubmit(){
			//xiangfan 修改 字数限制在50字以内
			var name = document.getElementById("name");
			/* if(name.value.length>50){
				alert(_("officeLang.meetingRoom_name_length"));
				return;
			} */
			//去掉空格
			if(document.getElementById("seatCount")!=null && document.getElementById("seatCount").value!="") {
				document.getElementById("seatCount").value = document.getElementById("seatCount").value.trim();
			}
			saveAttachment();
			if(checkForm(document.myForm)){
			   var place = document.getElementById("place");
			   var description = document.getElementById("description");
			   var eqdescription = document.getElementById("eqdescription");
			   if(!(/^[^\/|"',<>]*$/.test(name.value))){
			      alert(name.getAttribute("inputName")+" 不允许输入（ | / \" ' < > ,） 特殊字符！");
                  return ;
                }else if(!(/^[^\/|"'<>]*$/.test(place.value))){
                  alert(place.getAttribute("inputName")+" 不允许输入（ | / \" ' < >） 特殊字符！");
                  return ;
                }else if(!(/^[^\/|"'<>]*$/.test(description.value))){
                  alert(description.getAttribute("inputName")+" 不允许输入（ | / \" ' < >） 特殊字符！");
                  return ;
                }else if(!(/^[^\/|"'<>]*$/.test(eqdescription.value))){
                  alert(eqdescription.getAttribute("inputName")+" 不允许输入（ | / \" ' < >） 特殊字符！");
                  return ;
                }
				name.value = name.value.trim();
				place.value = place.value.trim();
				description.value = description.value.trim();

				var id = document.getElementById("id");
				var status = document.getElementById("status");
				if(id.value.length > 0 && status.value == "<%=Constants.Status_MeetingRoom_Stop %>"){
					document.getElementById("hiddenIframe").contentWindow.location.href = "${mrUrl}?method=checkStop&id="+id.value;
				}else{
					document.getElementById("myForm").submit();
				}
			}
		}

		// 会议室改造，管理员的管理范围变更为会议室申请范围,这里增加处理 xieFei
		var includeElements_per = "${v3x:parseElementsOfTypeAndId(members)}"; // 过滤查询的人员

        // V3X选择部门的组件的赋值函数 xieFei
		function setBulDepartFields(elements){
			if(elements.length>0){
				var mngdepids="";
				var mngdepid_names="";
				for(var i=0;i<elements.length;i++){
					mngdepids=mngdepids+","+elements[i].id;
					mngdepid_names=mngdepid_names+","+elements[i].name;
				}
				document.getElementById("mngdepid").value = mngdepids.substr(1);
				document.getElementById("mngdepid_name").value = mngdepid_names.substr(1);
			}
		}

        // V3X选择人员的组件的赋值函数 xieFei
		function setBulPeopleFields(elements){
			if(elements.length>0){
				var otheradminids="";
				var otheradminid_names="";
				for(var i=0;i<elements.length;i++){
					otheradminids=otheradminids+","+elements[i].id;
					otheradminid_names=otheradminid_names+","+elements[i].name;
				}
				document.getElementById("otheradminid").value=otheradminids.substr(1);
				document.getElementById("otheradminid_name").value=otheradminid_names.substr(1);
			}else{
				document.getElementById("otheradminid").value="";
				document.getElementById("otheradminid_name").value="";
			}
		}

	/**
   	* 上传图片
   	*/
    var picObjId = "${imageObj.fileUrl}";
    var uploadAttachmentCallback_param = {};
    function uploadAttachment(type){
        if(type==1) {
            var imageId = document.getElementById("imageId");
            if(imageId.value != null && imageId.value != ""){
                alert(v3x.getMessage("NEWSLang.imagenews_imageuploaded"));
                return ;
            }
            var url = downloadURL;
            var quantity = fileUploadQuantity;
            var attachments = fileUploadAttachments;
            var oldSize = fileUploadAttachments.size();
            var picId = document.getElementById("pic");
            downloadURL = "<html:link renderURL='/fileUpload.do?type=5&applicationCategory=6&extensions=jpeg,jpg,png,gif'/>";
            fileUploadQuantity = 1;
            uploadAttachment.oldSize = oldSize;
            uploadAttachmentCallback_param.url = url;
            uploadAttachmentCallback_param.quantity = quantity;
            uploadAttachmentCallback_param.picId = picId;
            insertAttachment(null, null, "uploadAttachment_Callback0", "false");
        } else {
            fileUploadQuantity = 1;
            downloadURL = "<html:link renderURL='/fileUpload.do?type=0&applicationCategory=6'/>";
            insertAttachment(null, null, "uploadAttachment_Callback1", "false");
        }
    }

    /**
     * 上传图片回调1
     */
    function uploadAttachment_Callback0(){
         var newSize = fileUploadAttachments.size();
         var oldSize = uploadAttachment.oldSize;
         var url = uploadAttachmentCallback_param.url;
         var quantity = uploadAttachmentCallback_param.quantity;
         var picId = uploadAttachmentCallback_param.picId;
         if(newSize != oldSize){
             var theList = fileUploadAttachments.keys();
             var attach = fileUploadAttachments.get(theList.get(fileUploadAttachments.size()-1), null);
             var imgAttId = fileUploadAttachments.keys().get(fileUploadAttachments.size()-1);//获得上传图片ID
             if(picObjId && picObjId != "" && picObjId != imgAttId) fileUploadAttachments.keys().remove(picObjId);
             if(imgAttId) picObjId = imgAttId;
             var _createDate = attach.createDate;
             if(_createDate!=null && _createDate!="" && _createDate.indexOf(" ")>0) {
                 _createDate = _createDate.substring(0, 10);
             }
             /*$("#image").val(imgAttId);*/
             document.getElementById("image").setAttribute("value", imgAttId);
             /*$("#imageId").attr("src", "/seeyon/fileUpload.do?method=showRTE&fileId="+imgAttId+"&createDate="+_createDate+"&type=image");*/
             document.getElementById("imageId").setAttribute("src", "<html:link renderURL='/fileUpload.do?method=showRTE&fileId="+imgAttId+"&createDate="+_createDate+"&type=image' />");
         }
         downloadURL = url;
         fileUploadQuantity = quantity;
         if(newSize == 0){
             document.getElementById("pic").style.display = "none";
         }else {
             picId.style.display = "";
         }
    }

    /**
     *上传图片回调2
     */
    function uploadAttachment_Callback1(){
         document.getElementById('filenameContent').value = fileUploadAttachments.keys().get(fileUploadAttachments.size()-1);
         var _attachmentsArrys = CopyToArray(fileUploadAttachments.keys());
         if(picObjId != "" && _attachmentsArrys.indexOf(picObjId) >= 0){
             _attachmentsArrys.remove(picObjId);
         }
         if(_attachmentsArrys.length >= 2){
             deleteAttachment(_attachmentsArrys[0], false);
         }
    }

   	function CopyToArray(v){
   	   var _array = new Array();
   	   for(var i=0; i<v.size(); i++){
   	       _array.push(v.get(i));
   	   }
   	   return _array;
   	}

   	$(function() {
   		$("#categorySetBody").hide().height($("#categorySetTd").height()).show();
   		$(window).resize(function(){
   			$("#categorySetBody").hide().height($("#categorySetTd").height()).show();
   		})
   	})

</script>
<c:set value="${pageContext.request.contextPath}" var="path" />
<link rel="stylesheet" href="${path}/common/all-min.css" />
<link rel="stylesheet" href="${path}/skin/default/skin.css" />
<style>
	input,select {
		height: 22px;
	}
	textarea {
		height: 26px;
	}
	.new-column {
		align: left;
		padding-top: 5px;
		padding-left: 0px;
	}
	.bg-summary {
		background-color:#FFF;
	}
</style>
</head>

<body onload="init()" class="over_hidden w100b h100b">
<!--会议室改造，管理员的管理范围变更为会议室申请范围  v3x实现 xieFei-->
<v3x:selectPeople id="dep" panels="Account,Department" selectType="Account,Department" jsFunction="setBulDepartFields(elements);" minSize="-1" maxSize="-1" originalElements="${v3x:parseElementsOfTypeAndId(mngdepid)}" />
<!--会议室改造，增加其他管理员 v3x实现 xieFei-->
<v3x:selectPeople id="per" panels="Department" selectType="Member" jsFunction="setBulPeopleFields(elements);" minSize="-1" maxSize="-1" originalElements="${v3x:parseElementsOfIds(bean.admin,'Member')}" showMe="false" showAllAccount="true"/>
<form name="myForm" id="myForm" action="${mrUrl }?method=execAdd" method="post" target="hiddenIframe" onsubmit="">
<input type="hidden" name="id" id="id" value="${bean.id }" />
<input type="hidden" id="hasMeetingRoomApp" name="hasMeetingRoomApp" value="false">
<input type="hidden" id="filename2" name="filename2" value="">

<div class="newDiv">

<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="categorySet-bg">

<tr align="center">
	<td height="8" class="detail-top">
		<script type="text/javascript">
			getDetailPageBreak();
		</script>
	</td>
</tr>

<tr>
	<td class="categorySet-4" height="8"></td>
</tr>

<!-- <tr>
	<td class="categorySet-head" height="23">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="categorySet-1" width="4"></td>
				<td class="categorySet-title" width="80" nowrap="nowrap"><fmt:message key="mr.label.roomdetails"/></td>
				<td class="categorySet-2" width="7"></td>
				<td class="categorySet-head-space">&nbsp;</td>
			</tr>
		</table>
	</td>
</tr> -->

<tr>
	<td id="categorySetTd" class="categorySet-head">
		<div id="categorySetBody" class="categorySet-body overflow_auto padding_t_5" style="padding:0;border-bottom:1px solid #a0a0a0;">
			<table width="60%" align="center" border="0" cellspacing="0" cellpadding="0">
				<tr style="padding-top:10px;height:26px;">
					<td width="1%" nowrap="nowrap" class="bg-gray"><font color="red">*</font><fmt:message key="mr.label.meetingroomname"/>:</td>
					<td nowrap="nowrap" align="left">
						<input type="text" style="height:22px;" name="name" id="name" inputName="<fmt:message key="mr.label.meetingroomname"/>" validate="notNull,maxLength" class="w80b" maxSize="50" value="${bean.name }" />
					</td>
				</tr>
				<tr style="padding-top:5px;height:26px;">
					<td width="12%" nowrap="nowrap" class="bg-gray"><font color="red">*</font><fmt:message key="mr.label.seatCount"/>:</td>
					<td nowrap="nowrap" align="left">
						<input type="text" style="height:22px;" inputName="<fmt:message key="mr.label.seatCount"/>" name="seatCount" id="seatCount" validate="notNull,maxLength,isInteger" min="1" class="w80b" maxLength="3" value="${bean.seatCount }"/>
					</td>
				</tr>
				<tr style="padding-top:5px;height:30px;">
					<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key='mr.label.place'/>:</td>
					<td nowrap="nowrap" align="left">
						<textarea name="place" id="place" inputName="<fmt:message key='mr.label.place'/>" validate="maxLength" class="w80b" maxSize="50">${bean.place }</textarea>
					</td>
				</tr>
				<!-- 会议室改造，管理员的管理范围变更为会议室<申请范围> xieFei -->
				<tr style="padding-top:5px;height:26px;">
					<td width="12%" nowrap="nowrap" class="bg-gray"><font color="red">*</font><fmt:message key="mr.label.applyrange"/>:</td>
					<td width="100%">
						<input type="hidden" name="mngdepid" id="mngdepid" value="${bean.mngdepId}"/>
						<input type="text" style="height:22px;" name="mngdepid_name" id="mngdepid_name" onclick="selectPeopleFun_dep()"
						inputName="<fmt:message key="mr.label.applyrange"/>" validate="notNull" class="w80b"  value="${mngdepid_name }"/>
					</td>
				</tr>
				<!-- 会议室改造，会议室增加<其他管理员> xieFei -->
				<tr style="padding-top:5px;height:26px;">
					<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key="mr.label.otheradmin"/>:</td>
					<td nowrap="nowrap" align="left">
						<input type="hidden" name="otheradminid" id="otheradminid"  value="${bean.admin }"/>
						<input type="text" name="otheradminid_name" id="otheradminid_name" style="height:22px;" onclick="selectPeopleFun_per()" 
						class="w80b" value="${otheradminid_name }" inputName="<fmt:message key="mr.label.otheradmin"/>" />
					</td>
				</tr>
				<tr style="padding-top:5px;height:26px;">
					<td width="12%" nowrap="nowrap" class="bg-gray">&nbsp;</td>
					<td nowrap="nowrap" align="left" class="padding_r_5">
						<label for="needApp">
							<input type="checkbox" id="needApp" name="needApp" value="${bean.needApp} " <c:if test="${bean.needApp == MRConstants.Type_MeetingRoom_NeedApp }">checked</c:if> />
							<fmt:message key="mr.label.needApp"/>
						</label>
					</td>
				</tr>
				<tr style="padding-top:5px;height:26px;">
					<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key="mr.label.status"/>:</td>
					<td nowrap="nowrap" align="left">
						<select inputName="<fmt:message key="mr.label.status"/>" name="status" id="status" class="w80b">
							<option value="<%=Constants.Status_MeetingRoom_Normal %>" <c:if test="${bean.status == MRConstants.Status_MeetingRoom_Normal }">selected</c:if> ><fmt:message key='mr.label.status.normal'/></option>
							<option value="<%=Constants.Status_MeetingRoom_Stop %>" <c:if test="${bean.status == MRConstants.Status_MeetingRoom_Stop }">selected</c:if> ><fmt:message key='mr.label.status.stop'/></option>
						</select>
					</td>
				</tr>
				<tr style="padding-top:5px;height:30px;">
					<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key="mr.label.room.equipment.description"/>:</td>
					<td nowrap="nowrap" align="left">
						<textarea name="eqdescription" id="eqdescription" inputName="<fmt:message key="mr.label.room.equipment.description"/>" validate="maxLength" class="w80b" maxSize="50">${bean.eqdescription}</textarea>
					</td>
				</tr>
				<tr style="padding-top:5px;height:30px;">
					<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key="mr.label.roomdescription"/>:</td>
					<td nowrap="nowrap" align="left">
						<textarea name="description" id="description" inputName="<fmt:message key="mr.label.roomdescription"/>" validate="maxLength" class="w80b" maxSize="50">${bean.description }</textarea>
					</td>
				</tr>
				<tr style="padding-top:5x;height:26px;">
					<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key="mr.label.room.photo"/>:</td>
					<td nowrap="nowrap" align="left" class="w80b">
                       <c:if test="${flag=='edit'||flag=='register'}">
                           <a href="#" onclick="javascript:uploadAttachment(1)"><fmt:message key="mr.label.room.sc"/></a>(<fmt:message key="mr.label.room.tp"/>)
                       </c:if>

					</td>
				</tr>
                <tr>
                    <td></td>
                    <td><span style="border: 1px #CCC solid; height: 156px; text-align: center;" id="pic">
                            <div id="thePicture1" style="width: 180px; height: 156px; margin-top: 2px; text-align: center;" >
                                 <fmt:formatDate var="imageDate" pattern="yyyy-MM-dd" value="${imageObj==null?null:imageObj.createdate}" />
                                 <c:if test="${not empty imageObj}">
                                    <html:link renderURL="/fileUpload.do?method=showRTE&fileId=${imageObj.fileUrl}&createDate=${imageDate}&type=image" var="imgURL" />
                                    <%-- <c:set value="/f9_meeting/fileUpload.do?method=showRTE&fileId=${imageObj.fileUrl}&createDate=${imageDate}&type=image" var="_url"/> --%>
                                    <c:set value="${imgURL}" var="_url"/>
                                 </c:if>
                                 <img id="imageId" src="${_url}" width="180px;" height="156px;" />
                            </div>
                        </span>
                        <input type="hidden" id="image" name="image" value="${imageObj==null?null:imageObj.fileUrl }"/>
                        <%--xiangfan 2012-04-20 注释 修复GOV-2001 错误
                        <div id="attachmentTR" style="display:none" class="bg-summary">
                            <v3x:fileUpload attachments="${attatchImage}" canDeleteOriginalAtts="true" /><br>
                        </div>
                        --%>
                     </td>
                </tr>
				<tr style="padding-top:5px;height:26px;">
					<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key="mr.label.Croom.system"/>:</td>
					<td nowrap="nowrap" align="left" class="w80b" >
						<c:if test="${flag=='edit'||flag=='register'}">
							<a href="#" onclick="javascript:uploadAttachment(2)"><fmt:message key="mr.label.room.sc"/></a>(<fmt:message key="mr.label.room.zd"/>)
						</c:if>
					</td>
				</tr>
                <tr>
                    <td></td>
                    <td>
                        <input type="hidden" id="filenameContent" name="filenameContent" value="${attObj==null?'':attObj.fileUrl}"/>
                        <div id="attachmentTR" style="display:none;height:26px;" class="bg-summary">
                            <v3x:fileUpload attachments="${attatchments}" canDeleteOriginalAtts="${flag=='edit'?true:false}" /><br>
                            <v3x:fileUpload attachments="${attatchImage}" canDeleteOriginalAtts="${flag=='edit'?true:false}" /><br>
                        </div>
                    </td>
                </tr>
			</table>
		</div>
	</td>
</tr>

<c:if test="${readOnly ne true}">
<tr>
	<td height="42" align="center" class="bg-advance-bottom">
		<input type="button" onclick="addDoSubmit();" class="button-default-2 button-default_emphasize" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" />&nbsp;
		<input type="button" onclick="document.location='<c:url value="/common/detail.jsp" />';" class="button-default-2" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" />
	</td>
</tr>
</c:if>

</table>

</div>

</form>

<iframe name="hiddenIframe" id="hiddenIframe" style='display:none;height:0%;width:0%;'></iframe>
</body>
</html>
