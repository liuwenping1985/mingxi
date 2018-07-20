<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../edocHeader.jsp"%>
<html>
<head>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
</head>
<script>
<!--

var oldStatus = '${bean.status}';

	function doIt() {
      if(_checkFormInfo()){
          mainForm.submit();
      }
	}
	
	function _checkFormInfo(){//验证
	    
	    var metadataName = document.getElementById("metadataName");
        //OA-45475 单位管理员将用户公文元素名称修改为特殊字符后，再次查看报错
        var name = document.getElementById("name");
        if(!(/^[^\|"'\/<>]*$/.test(name.value))){
            alert(_("edocLang.element_alter_special_char"));
            return false;
        }
        if(!checkForm(mainForm)){
            return false;
        }
        if(metadataName != null && '<fmt:message key="edoc.element.chooseMetadata" />' == metadataName.value){
            alert(v3x.getMessage("edocLang.edoc_alert_element_chooseMetadata",'<fmt:message key="edoc.element.elementMetadataId"/>'));
            return false;
        }
        
        mainForm.action = "${edocElement}?method=update";
        mainForm.target = "empty";
        
        var c_status;
        var temp = document.getElementsByName("status");
        if(temp!=null && temp.length>0) {
        	for(var i = 0; i < temp.length; i++){
                if(temp[i].checked){
                    c_status = temp[i].value;
                }
            }	
        }
        if(c_status) {
	        if(oldStatus != c_status){//如果原来的状态与要当前的状态不符,判断...0:提示要禁用 1:提示要启用
	            var pompMsg = "";
	            if(c_status == "0"){
	                pompMsg = _("edocLang.edoc_element_disable");
	             }
	            if(c_status == "1"){
	                pompMsg = _("edocLang.edoc_element_enable");
	             }
	            
	            if(pompMsg && pompMsg!="" && !window.confirm(pompMsg)){
	                return false;
	            }
	        }
		}
        return true;
	}
	

function selectbind(){
  
  var metadataId = document.all("metadataId");
  var metadataName= document.all("metadataName");
  var metadatanoname =  document.all("metadatanoname");
  
  //枚举值由bindEnum进行设置
  bindEnum(metadataId,metadataName);
}
function bindEnum(metadataId,metadataName){
	  var obj = new Array();
	  obj[0] = window;
	  var dialog = v3x.openDialog({
	    url:"${path}/enum.do?method=bindEnum&isfinal=0",
	        title : '',
	        width:500,
	    height:520,
	    targetWindow:top,
	    transParams:obj,
	        buttons : [{
	          text : "${ctp:i18n('form.trigger.triggerSet.confirm.label')}",
	          id:"sure",
	          handler : function() {
	              var result = dialog.getReturnValue();
	              if(result){
	                metadataId.value = result.enumId;
	                metadataName.value = result.enumName;
	                dialog.close();
	              }
	          }
	        }, {
	          text : "${ctp:i18n('form.query.cancel.label')}",
	          id:"exit",
	          handler : function() {
	              dialog.close();
	          }
	        }]
	      });
	}
 var extendField= null;
function Enum_value(){
	this.id = null;
	this.name = null;
}


jQuery(function(){
	$("#categorySetBody").height($("#categorySetTd").height()).show();
	$(window).resize(function() {
		$("#categorySetBody").height($("#categorySetTd").height()).show();
	})
});

//-->
</script>
<link rel="stylesheet" href="${path}/common/all-min.css" />
<link rel="stylesheet" href="${path}/skin/default/skin.css" />
<body>

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
	<td class="categorySet-head" height="23">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="categorySet-1" width="4"></td>
				<td class="categorySet-title" width="80" nowrap="nowrap">
					<%-- GOV-5055 单位管理员和公文管理员修改公文元素和外部单位的时候，页签上显示的设置而不是修改 --%>
					<c:choose>
					<c:when test ="${param.flag=='view'}">
						<fmt:message key="edoc.element.detail"/>
					</c:when>
					<c:otherwise>
						<fmt:message key='edoc.modify.element.label'/>
					</c:otherwise>
					</c:choose>
				</td>
				<td class="categorySet-2" width="7"> </td>
				<td class="categorySet-head-space">&nbsp;</td>
			</tr>
		</table>
	</td>
</tr>
  	
<tr>
	<td id="categorySetTd" class="categorySet-head">
		<div id="categorySetBody" class="categorySet-body overflow_auto" style="padding:0;border-bottom:1px solid #a0a0a0;">

<form name="mainForm" method="post" onsubmit="return _checkFormInfo();">
<input type="hidden" name="id" value="${bean.elementId}" />

<table width="70%" height="70%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr>
    <td width="100%" valign="middle">
		<table width="95%" border="0" cellspacing="0" cellpadding="2" align="center">
			<tr>
			  <td colspan="2" height="10px">&nbsp;</td>
			</tr>
			<tr>
				<td class="bg-gray" align="right"><font color="red">*</font><fmt:message key="edoc.element.elementName" />:</td>
				<td class="new-column" nowrap="nowrap">
					<c:if test="${bean.isSystem}">
						<input name="name" type="text" id="name" class="input-50per" style="height:22px;" deaultValue="${bean.name}"
							 validate="isDeaultValue,notNull"
						     value="<fmt:message key="${bean.name}" />" escapeXml="true" readOnly="readonly" disabled="disabled">
					</c:if>
					<c:if test="${!bean.isSystem}">
						<input name="name" type="text" id="name" class="input-50per" style="height:22px;" deaultValue="${bean.name}"
							 maxSize="85"
							 validate="notNull,maxLength"
							 inputName="<fmt:message key="edoc.element.elementName" />"
							 value="<c:out value="${bean.name}" escapeXml="true" default='${bean.name}' />"
							 >
					</c:if>
				</td>
			</tr>
			<tr>
				<td class="bg-gray" align="right"><fmt:message key="edoc.element.elementfieldName" />:</td>
				<td>${bean.fieldName}</td>
			</tr>
			<tr>
				<td class="bg-gray" align="right" width="25%"><fmt:message key="edoc.element.elementType" />:</td>
				<td class="value" align="left">
					<c:choose>
						<c:when test="${bean.type==0}">
							<fmt:message key="edoc.element.string" />
						</c:when>
						<c:when test="${bean.type==1}">
							<fmt:message key="edoc.element.text" />
						</c:when>
						<c:when test="${bean.type==2}">
							<fmt:message key="edoc.element.integer" />
						</c:when>
						<c:when test="${bean.type==3}">
							<fmt:message key="edoc.element.decimal" />
						</c:when>
						<c:when test="${bean.type==4}">
							<fmt:message key="edoc.element.date" />
						</c:when>
						<c:when test="${bean.type==5}">
							<fmt:message key="edoc.element.list" />
						</c:when>
						<c:when test="${bean.type==6}">
							<fmt:message key="edoc.element.comment" />
						</c:when>
						<c:when test="${bean.type==7}">
							<fmt:message key="edoc.element.img" />
						</c:when>
					</c:choose>
				</td>
			</tr>
	
			<%-- <c:if test="${bean.type==5}">
			<tr>
				<td class="bg-gray" align="right" width="25%"><font color="red">*</font><fmt:message key="edoc.element.elementMetadataId" />:</td>
				<td class="value" align="left">
					<input type="text"  id="metadataName"    name="metadataName" class="cursor-hand input-50per" onclick="selectbind()" value = "${metadataName}" readonly = "true" <c:if test='${bean.isSystem}' > disabled </c:if> >
					<input type="hidden"  id="metadataId" name="metadataId" value = "${bean.metadataId}">
					<input type="hidden"  id="metadatanoname" name="metadatanoname" value = "<fmt:message key="edoc.element.chooseMetadata" />">
				</td>
			</tr>
			</c:if> --%>
	
			<tr>
				<td class="bg-gray" align="right" width="25%"><fmt:message key="edoc.element.elementIsSystem" />:</td>
				<td class="value" align="left">
					<c:choose>
						<c:when test="${bean.isSystem}">
							<fmt:message key="edoc.element.systemType" />
						</c:when>
						<c:otherwise>
							<fmt:message key="edoc.element.userType" />
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
			<!-- 屏蔽启用和停用按钮 -->
			<%-- <tr>
				<td class="bg-gray" align="right" width="25%"><fmt:message key="edoc.element.elementStatus" />:</td>
				<td class="value" align="left">
					<c:choose>
						<c:when test="${bean.status==1}">
							<label for="status1">
							 <input type="radio" id="status1" name="status" value="1" checked /><fmt:message key="edoc.element.enabled" /> &nbsp;
							</label>
							<label for="status2">
							 <input type="radio" id="status2" name="status" value="0" /><fmt:message key="edoc.element.disabled" />
							</label>
						</c:when>
						<c:otherwise>
							<label for="status1">
							 <input type="radio" id="status1" name="status" value="1" /><fmt:message key="edoc.element.enabled" /> &nbsp;
							</label>
							<label for="status2">
					 		 <input type="radio" id="status2" name="status" value="0" checked /><fmt:message key="edoc.element.disabled" />
					 		</label>
						</c:otherwise>
					</c:choose>
				</td>
			</tr> --%>
	  	</table>
	</td>
</tr>

</table>
</form>

</div>
</td>
</tr>

<tr id="editButton" style="display:none">
	<td height="42" align="center" class="bg-advance-bottom">
		<input type="button" class="button-default_emphasize" value="<fmt:message key="common.button.ok.label" bundle="${v3xCommonI18N}" />" onclick="doIt();"/>&nbsp;&nbsp;
		<input type="button" class="button-default-2" value="<fmt:message key="common.button.cancel.label" bundle="${v3xCommonI18N}"/>"
		onclick="window.location.href='<c:url value="/common/detail.jsp" />'"/>
	</td>
</tr>

</table>
</div>
</body>
</html>
<iframe name="empty" id="empty" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0">
</iframe>
<script>
<!--
	var flag = "${v3x:escapeJavascript(param.flag)}";
	var status = document.getElementsByName("status");
	var name = document.getElementById("name");
	var metadata = document.getElementById("metadataId");
	var metadataName = document.getElementById("metadataName");

	if (flag == "edit") {
		editButton.style.display = "";
	}
	else {
		if(status[0]){
			status[0].disabled = true;
		}
		if(status[1]){
			status[1].disabled = true;
		}
		name.disabled = true;
		if (metadata != null) {
			metadataName.disabled = true;
		}
	}
//-->
</script>