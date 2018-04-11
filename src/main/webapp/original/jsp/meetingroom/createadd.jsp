<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="header.jsp" %>

<c:set value="${v3x:parseElementsOfTypeAndId(bean.mngdepId)}" var="defaultMngdepId"/>
<c:set value="${v3x:parseElementsOfTypeAndId(bean.adminMembers)}" var="defaultRoomAdmin"/>
<c:set value="${v3x:parseElements(bean.roomAdminList, 'id', 'entityType')}" var="roomAdminList"/>

<v3x:selectPeople id="dep" panels="Account,Department" selectType="Account,Department" jsFunction="setBulDepartFields(elements);" minSize="-1" maxSize="-1" originalElements="${defaultMngdepId}" />
<v3x:selectPeople id="admin" panels="Department" selectType="Member" jsFunction="peopleCallback_admin(elements);" minSize="-1" maxSize="9" originalElements="${defaultRoomAdmin }" showMe="true" showAllAccount="true"/>

<c:set value="${pageContext.request.contextPath}" var="path" />

<fmt:message key="mr.label.admin" var="adminLabel" />
<fmt:message key="mr.label.status" var="statusLabel" />
<fmt:message key="mr.label.room.equipment.description" var="eqdescriptionLabel" />
<fmt:message key="mr.label.roomdescription" var="descriptionLabel" />
<fmt:message key="mr.label.room.photo" var="photoLabel" />
<fmt:message key="mr.label.room.sc" var="scLabel" />
<fmt:message key="mr.label.room.tp" var="tpLabel" />
<fmt:message key="mr.label.needApp" var="needAppLabel" />
<fmt:message key="mr.label.needMsg" var="needMsgLabel" />
<fmt:message key="mr.label.room.zd" var="zdLabel" />
<fmt:message key="mr.label.Croom.system" var="systemLabel" />
<fmt:message key="common.button.ok.label" bundle="${v3xCommonI18N}" var="okLabel" />
<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" var="cancelLabel" />
<fmt:message key="mr.label.applyrange" var="applyrangeLabel" />

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.plugin.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.easyui.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">

$(function() {
	$("#categorySetBody").hide().height($("#categorySetTd").height()).show();
	$(window).resize(function(){
		$("#categorySetBody").hide().height($("#categorySetTd").height()).show();
	});
	init();
	if($("#needApp").attr("checked")==true){
		$("#needMsg")[0].disabled='disabled';
	}
	$("#needApp").click(function(){
		if($(this).attr("checked")==true){
			$("#needMsg")[0].checked=true;
			$("#needMsg")[0].disabled='disabled';
		}else{
			$("#needMsg")[0].checked=false;
			$("#needMsg")[0].disabled='';
		}
	});
	if(""==includeElements_admin && "${param.flag}"=="register"){
		document.getElementById("adminNames").disabled="disabled";
		document.getElementById("adminNames").title=_("officeLang.meetingRoom_admins_length");
	}
});

function init(){
	var picId = document.getElementById("pic");
	var imgObj = "${bean.imageObj}";
	var readOnly = "${param.readOnly}";
	if(readOnly == "true"){
		setReadOnly();
	}
	if(imgObj == null || imgObj == ""){//初始化时imgObj为空 就不显示图片
		picId.style.display = "none";
	}
	downloadURL = "<html:link renderURL='/fileUpload.do?type=0&applicationCategory=6'/>";
}

function addOneSub(n){
    return parseInt(n)+1;
}

function resetSubCount(){
	subCount = 0;
}
		
//防止重复提交
var subCount = 0;
function addDoSubmit(){
	subCount = addOneSub(subCount);
    if(parseInt(subCount)>=2) {
        //不能重复提交，用最原生的alert，$.ALERT不能阻塞，太慢了才弹出
        alert(_("officeLang.meetingRoom_notDuplicateSub"));
        return;
    }
	
	var name = document.getElementById("name");
	//去掉空格
	if(document.getElementById("seatCount")!=null && document.getElementById("seatCount").value!="") {
		document.getElementById("seatCount").value = document.getElementById("seatCount").value.trim();
	}
	saveAttachment();
	
	if(checkForm(document.myForm)){
	   	var place = document.getElementById("place");
	   	var description = document.getElementById("description");
	   	var eqdescription = document.getElementById("eqdescription");
	   	if(!(/^[^\/|"',<>]*$/.test(name.value))) {
	      	alert(name.getAttribute("inputName")+" "+v3x.getMessage("meetingLang.meeting_invalid_charactor"));
	      	subCount = 0;
			return ;
      	} else if(!(/^[^\/|"'<>]*$/.test(place.value))) {
         	alert(place.getAttribute("inputName")+" "+v3x.getMessage("meetingLang.meeting_invalid_charactor"));
            subCount = 0;
            return ;
      	} else if(!(/^[^\/|"'<>]*$/.test(description.value))) {
        	alert(description.getAttribute("inputName")+" "+v3x.getMessage("meetingLang.meeting_invalid_charactor"));
           	subCount = 0;
            return ;
     	} else if(!(/^[^\/|"'<>]*$/.test(eqdescription.value))) {
          	alert(eqdescription.getAttribute("inputName")+" "+v3x.getMessage("meetingLang.meeting_invalid_charactor"));
           	subCount = 0;
            return ;
      	}
	   	
	   	
		name.value = name.value.trim();
		place.value = place.value.trim();
		description.value = description.value.trim();
		
		var needAppObj = document.getElementById("needApp");
		if(needAppObj.checked) {
			needAppObj.value = 1;
		} else {
			needAppObj.value = 0;
		}
		var needMsgObj = document.getElementById("needMsg");
		if(needMsgObj.checked) {
			needMsgObj.value = 2;
		} else {
			needMsgObj.value = 0;
		}
		
		var id = document.getElementById("id");
		var status = document.getElementById("status");
		if(id.value!="" && id.value!="-1" && "${bean.status}"=="0" && status.value == "1") {
			var requestCaller = new XMLHttpRequestCaller(this, "meetingValidationManager", "checkRoomCanStop", false);
			requestCaller.addParameter(1, "Long", id.value);
			var ds = requestCaller.serviceRequest();
			if(ds == 'false') {//会议室有待审批的数据
				if(confirm("<fmt:message key='mr.alert.confirmstop' />")) {
					document.getElementById('hasMeetingRoomApp').value = 'true';
					document.getElementById("myForm").submit();
				}
			} else {
				document.getElementById("myForm").submit();
			}
		} else {
			document.getElementById("myForm").submit();
		}
	} else {
		subCount = 0;
	}
}

//申请范围回调方法
function setBulDepartFields(elements) {
	if(elements.length>0) {
		var mngdepId = "";
		var mngdepName="";
		for(var i=0; i<elements.length; i++){
			if(mngdepId != "") {
				mngdepId += ",";
				mngdepName += ",";
			}
			mngdepId += elements[i].type + "|" + elements[i].id;
			mngdepName += elements[i].name;
		}
		document.getElementById("mngdepId").value = mngdepId;
		document.getElementById("mngdepName").value = mngdepName;
	}
}

var includeElements_admin = "${v3x:toHTML(roomAdminList)}"; // 过滤查询的人员
var elements_adminArr;
var onlyLoginAccount_admin = true;  //只能选择本单位的管理员
var isNeedCheckLevelScope_admin = false;

function selectMtPeople_admin() {
	elements_admimArr = new Array();
	eval('selectPeopleFun_admin()');
}
//会议室管理员回调方法
function peopleCallback_admin(elements){
	if(elements.length > 0) {
		var adminIds = "";
		var adminNames = "";
		for(var i=0; i<elements.length; i++) {
			if(adminIds != "") {
				adminIds += ",";
				adminNames += ",";
			}
			adminIds += elements[i].id;
			adminNames += elements[i].name;
		}
		document.getElementById("adminIds").value = adminIds;
		document.getElementById("adminNames").value = adminNames;
	} else {
		document.getElementById("adminIds").value = "";
		document.getElementById("adminNames").value = "";
	}
	elements_perArr = elements;
}

var picObjId = "${bean.imageObj.fileUrl}";
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
         document.getElementById("image").setAttribute("value", imgAttId);
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

function _submitCallback(msgType, msg) {
 	if(msgType == "success") {
 		alert(v3x.getMessage("meetingLang.meeting_action_success"));
 		//提交后刷新页面（当页面含有子页面）的时候，ff会提示“必须发送此前动作”导致再一次提交数据。解决方法：一个一个页面的刷新，不要一次性刷新全部页面。
 		parent.listFrame.location.reload();
 	} else if(msgType == "notAdmin") {
 		alert(msg);
 		parent.listFrame.location.reload();
 	} else {//同名
 		if(msgType == "failure") {
 			alert(v3x.getMessage("meetingLang.meeting_action_failed"));	
 		} else {
 			alert(msg);	
 		}
 		resetSubCount();
 	}
}

</script>

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

<body class="over_hidden w100b h100b">

<form name="myForm" id="myForm" action="meetingroom.do?method=execAdd" method="post" target="hiddenIframe" onsubmit="">
<input type="hidden" id="id" name="id" value="${bean.id }" />
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

<tr>
	<td id="categorySetTd" class="categorySet-head">
		
		<div id="categorySetBody" class="categorySet-body overflow_auto padding_t_5" style="padding:0;border-bottom:1px solid #a0a0a0;">
			<table width="60%" align="center" border="0" cellspacing="0" cellpadding="0">
				<tr style="padding-top:10px;height:26px;">
					<td width="1%" nowrap="nowrap" class="bg-gray"><font color="red">*</font><fmt:message key="mr.label.meetingroomname"/>:</td>
					<td nowrap="nowrap" align="left">
						<input type="text" style="height:22px;" name="name" id="name" inputName="<fmt:message key="mr.label.meetingroomname"/>" validate="notNull,maxLength" class="w80b" maxSize="50" value="${v3x:toHTML(bean.name) }" />
					</td>
				</tr>
				
				<tr style="padding-top:5px;height:26px;">
					<td width="12%" nowrap="nowrap" class="bg-gray"><font color="red">*</font><fmt:message key="mr.label.seatCount"/>:</td>
					<td nowrap="nowrap" align="left">
						<input type="text" style="height:22px;" inputName="<fmt:message key="mr.label.seatCount"/>" name="seatCount" id="seatCount" validate="notNull,maxLength,isInteger" min="1" class="w80b" maxLength="6" value="${bean.seatCount }"/>
					</td>
				</tr>
				
				<tr style="padding-top:5px;height:30px;">
					<td width="12%" nowrap="nowrap" class="bg-gray"><fmt:message key='mr.label.place'/>:</td>
					<td nowrap="nowrap" align="left">
						<textarea name="place" id="place" inputName="<fmt:message key='mr.label.place'/>" validate="maxLength" class="w80b" maxSize="50">${bean.place }</textarea>
					</td>
				</tr>

				<tr style="padding-top:5px;height:26px;">
					<td width="12%" nowrap="nowrap" class="bg-gray"><font color="red">*</font>${applyrangeLabel }:</td>
					<td width="100%">
						<input type="hidden" name="mngdepId" id="mngdepId" value="${bean.mngdepId}"/>
						<input type="text" name="mngdepName" id="mngdepName" onclick="selectPeopleFun_dep()"
							value="${v3x:toHTML(bean.mngdepName) }" inputName="${applyrangeLabel }" 
							readonly="readonly" class="w80b" style="height:22px;" validate="notNull" />
					</td>
				</tr>

				<tr style="padding-top:5px;height:26px;">
					<td width="12%" nowrap="nowrap" class="bg-gray"><font color="red">*</font>${adminLabel }:</td>
					<td nowrap="nowrap" align="left">
						<input type="hidden" name="adminIds" id="adminIds" value="${bean.adminIds }"/>
						<input type="text" name="adminNames" id="adminNames" 
							value="${v3x:toHTML(bean.adminNames) }" inputName="${adminLabel }"
							onclick="selectMtPeople_admin()" 
							class="w80b" style="height:22px;" readonly="readonly" validate="notNull"/>
					</td>
				</tr>
				
				<tr style="padding-top:5px;height:26px;">
					<td width="12%" nowrap="nowrap" class="bg-gray">&nbsp;</td>
					<td nowrap="nowrap" align="left" class="padding_r_5">
						<!-- 是否需要申请 -->
						<label for="needApp">
							<input type="checkbox" id="needApp" name="needApp" value="${bean.needApp} " ${bean.needApp=="1"?"checked":"" } />
							${needAppLabel }
						</label>
						&nbsp;
						<!-- 是否发送消息 -->
						<label for="needMsg">
							<input type="checkbox" id="needMsg" name="needMsg" value="${bean.needApp} " <c:if test="${bean.needApp == 1 || bean.needApp == 2}">checked</c:if> />
							${needMsgLabel }
						</label>
					</td>
				</tr>
				
				<tr style="padding-top:5px;height:26px;">
					<td width="12%" nowrap="nowrap" class="bg-gray">${statusLabel }:</td>
					<td nowrap="nowrap" align="left">
						<select inputName="${statusLabel }" name="status" id="status" class="w80b">
							<option value="0" <c:if test="${bean.status == 0 }">selected</c:if> ><fmt:message key='mr.label.status.normal'/></option>
							<option value="1" <c:if test="${bean.status == 1 }">selected</c:if> ><fmt:message key='mr.label.status.stop'/></option>
						</select>
					</td>
				</tr>
				
				<tr style="padding-top:5px;height:30px;">
					<td width="12%" nowrap="nowrap" class="bg-gray">${eqdescriptionLabel }:</td>
					<td nowrap="nowrap" align="left">
						<textarea name="eqdescription" id="eqdescription" inputName="${eqdescriptionLabel }" validate="maxLength" class="w80b" maxSize="50">${bean.eqdescription}</textarea>
					</td>
				</tr>
				
				<tr style="padding-top:5px;height:30px;">
					<td width="12%" nowrap="nowrap" class="bg-gray">${descriptionLabel }:</td>
					<td nowrap="nowrap" align="left">
						<textarea name="description" id="description" inputName="${descriptionLabel }" validate="maxLength" class="w80b" maxSize="50">${bean.description }</textarea>
					</td>
				</tr>
				
				<tr style="padding-top:5x;height:26px;">
					<td width="12%" nowrap="nowrap" class="bg-gray">${photoLabel }:</td>
					<td nowrap="nowrap" align="left" class="w80b">
                       <c:if test="${param.flag=='edit' || param.flag=='register'}">
                           <a href="#" onclick="javascript:uploadAttachment(1)">${scLabel }</a>(${tpLabel })
                       </c:if>
					</td>
				</tr>
				
                <tr>
                    <td></td>
                    <td>
                    	<span style="height: 156px; text-align: center;" id="pic">
                            <div id="thePicture1" style="width: 180px; height: 156px; margin-top: 2px; text-align: center;" >
                                 <c:if test="${not empty bean.imageObj}">
                                    <fmt:formatDate var="imageDate" pattern="yyyy-MM-dd" value="${bean.imageObj==null ? null : bean.imageObj.createdate}" />
                                    <html:link renderURL="/fileUpload.do?method=showRTE&fileId=${bean.imageObj.fileUrl}&createDate=${imageDate}&type=image" var="imgURL" />
                                    <c:set value="${imgURL}" var="_url"/>
                                 </c:if>
                                 
                                 <img id="imageId" src="${_url}" width="180px;" height="156px;" />
                            </div>
                        </span>
                        
                        <input type="hidden" id="image" name="image" value="${bean.imageObj==null ? null : bean.imageObj.fileUrl }"/>
                     </td>
                </tr>
                
				<tr style="padding-top:5px;height:26px;">
					<td width="12%" nowrap="nowrap" class="bg-gray">${systemLabel }:</td>
					<td nowrap="nowrap" align="left" class="w80b" >
						<c:if test="${param.flag=='edit' || param.flag=='register'}">
							<a href="#" onclick="javascript:uploadAttachment(2)">${scLabel }</a>(${zdLabel })
						</c:if>
					</td>
				</tr>
				
                <tr>
                    <td></td>
                    <td>
                        <input type="hidden" id="filenameContent" name="filenameContent" value="${bean.attObj==null ? '' : bean.attObj.fileUrl}"/>
                        <div id="attachmentTR" style="display:none;height:26px;" class="bg-summary">
                            <v3x:fileUpload attachments="${bean.attatchments}" canDeleteOriginalAtts="${param.flag=='edit' ? true : false}" /><br>
                            <v3x:fileUpload attachments="${bean.attatchImage}" canDeleteOriginalAtts="${param.flag=='edit' ? true : false}" /><br>
                        </div>
                    </td>
                </tr>
			</table>
		</div>
	</td>
</tr>

<c:if test="${param.readOnly ne true}">
<tr>
	<td height="42" align="center" class="bg-advance-bottom">
		<input type="button" onclick="addDoSubmit();" class="button-default-2 button-default_emphasize" value="${okLabel }" />&nbsp;
		<input type="button" onclick="document.location='<c:url value="/common/detail.jsp" />';" class="button-default-2" value="${cancelLabel }" />
	</td>
</tr>
</c:if>

</table>

</div>

</form>

<iframe name="hiddenIframe" id="hiddenIframe" style='display:none;height:0%;width:0%;'></iframe>
</body>
</html>
