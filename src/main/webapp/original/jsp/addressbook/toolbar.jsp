<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.seeyon.v3x.common.taglibs.functions.Functions" %>
<%@ include file="header.jsp"%>
<html>
<head>
<v3x:selectPeople id="level" panels="Level" selectType="Level" jsFunction="setLevel(elements)"/>
<script type="text/javascript" src="<c:url value='/apps_res/addressbook/js/toolbar.js${v3x:resSuffix()}'/>">
</script>
<script type="text/javascript">
<!--
var changedTypeHref = '<c:url value="/common/detail.jsp" />';
var changedTypeLocation="${urlAddressBook}";
var accountIdDownload = "${param.accountId}";
var hrefDownload = "<c:url value='/addressbook.do'/>?method=download";
var accountIdSearch = "${param.accountId}";
var flag = 0;

var receiveIds = "";
var receiveNames = "";
var currentUserId = "${v3x:currentUser().id}";

//导入vCARD
function openImortWindow(){
  var categoryId;
  try{
  	  //categoryId = parent.treeFrame.root.getSelected().businessId;
  	  categoryId = parent.treeFrame.document.getElementById("tId").value;
  }catch(e)
  {}
  if(!categoryId || categoryId == '' || categoryId == "-1"){
  	alert("请选择需要导入的组");
  	return;
  }
  var memberId;
  var id_checkbox = parent.listFrame.document.getElementsByName("id");
  if (!id_checkbox) {
    return;
  }

  var checkedNum = 0;
  var memberId = null;
  var len = id_checkbox.length;
  for (var i = 0; i < len; i++) {
    if (id_checkbox[i].checked) {
        memberId = id_checkbox[i].value;
        checkedNum ++;
    }
  }
  if(checkedNum > 1){
	alert("每次只能选择一个人员进行VCARD覆盖");
	return;
  }
  vcardSubmitform(categoryId,memberId);
}
var vcardCategoryId,vcardMemberId;	
function vcardSubmitform(categoryId,memberId){
	var form = document.getElementById("uploadFormOrgImp");
	if(memberId && memberId != '' && memberId != null ){
		if(!window.confirm('是否要对选中人员进行VCARD覆盖?')){
			memberId = '';
			return;
		}
	}
	vcardCategoryId = categoryId;
	vcardMemberId = memberId;
	vcardAttach();
}
	
function vcardAttach(){
	insertAttachment(null, null, 'callbackInsertAttachmentsVCard', 'false');
}

function callbackInsertAttachmentsVCard () {
	var rv = true;
	var suffix;
	var fix = "";
	var temp = document.getElementById("templateFile");
	var form = document.getElementById("uploadFormOrgImp");
	if(temp.value==""){//如果为空，attachment中没有附件
		var	at = fileUploadAttachments.values().get(0);//因为之前没有附件,当前附件如果存在只能有1个，也就是第一个
		if(at!=null){
			suffix = at.filename.split(".");
			fix = suffix[suffix.length-1];
			if(fix!="vcf" && fix!="VCF"){
				alert("请选择VCARD文件");
				deleteAttachment(at.fileUrl,false);
				rv = false;
			}else{
				//判断是否符合格式
				document.getElementById("templateFile").value = at.filename;
			}
		}else{
			rv = false;
		}
	}else{//如果不为空，attachment中已经有值
		var att;
		if(!fileUploadAttachments.isEmpty()){
			att = fileUploadAttachments.values().get(1); //如果attachment中之前有值,再次上传后的附件应在第2为...get(1);
			if(att!=null){//判断新上传的附件是否为doc或wps格式
				suffix = att.filename.split(".");
				fix = suffix[suffix.length-1];
				if(fix!="vcf" && fix!="VCF"){
					alert("请选择VCARD文件");
					deleteAttachment(att.fileUrl,false);//如果不是，删除该附件
					rv = false;
				}else{//如果为wps或doc格式，删除原有的附件，并把附件名填上
					var o_at = fileUploadAttachments.values().get(0);
					deleteAttachment(o_at.fileUrl,false);
					document.getElementById("templateFile").value = att.filename;
				}		
			}else{
				rv = false;
			}
		}
	}
	if(rv == false){
		return;
	}
	var form = document.getElementById("uploadFormOrgImp");
	saveAttachment();
	form.target='theLogIframe';
	form.action= "${urlAddressBook}?method=doVcardImoprt&memberId="+vcardMemberId+"&categoryId="+vcardCategoryId;
	form.submit();
}

//导入CSV
function openCSVImport(){
    var categoryId;
    try{
  	  //categoryId = parent.treeFrame.root.getSelected().businessId;
    	categoryId = parent.treeFrame.document.getElementById("tId").value;
    }catch(e){}
    if(!categoryId || categoryId == '' || categoryId == "-1"){
	  	alert("请选择需要导入的组");
	  	return;
    }
	var id_checkbox = parent.listFrame.document.getElementsByName("id");
    if (!id_checkbox) {
        return;
    }
    var checkedNum = 0;
    var memberId = '';
    var len = id_checkbox.length;
    for (var i = 0; i < len; i++) {
        if (id_checkbox[i].checked) {
            memberId = id_checkbox[i].value;
            checkedNum ++;
        }
    }
	if(checkedNum > 1){
		alert("每次只能选择一个人员进行Excel覆盖");
		return;
	}
   	csvSubmitform(categoryId, memberId);		
}

var csvCategoryId,csvMemberId;
function csvSubmitform(categoryId,memberId){
	var form = document.getElementById("uploadFormOrgImp");
	if(memberId && memberId != '' && memberId!= null ){
		if(!window.confirm('是否要对选中人员进行CSV覆盖?')){
			memberId = '';
			return;
		}
	}
	csvCategoryId = categoryId;
	csvMemberId = memberId;
	csvAttach();
}

function csvAttach(){
	insertAttachment(null, null, 'callbackInsertAttachment', 'false');
}

function callbackInsertAttachment () {
	var rv = true;
	var suffix;
	var fix = "";
	var temp = document.getElementById("templateFile");
	if(temp.value==""){//如果为空，attachment中没有附件
		var	at = fileUploadAttachments.values().get(0);//因为之前没有附件,当前附件如果存在只能有1个，也就是第一个
		if(at!=null){
			suffix = at.filename.split(".");
			fix = suffix[suffix.length-1];
			if(fix!="csv" && fix!="CSV"){
				alert("请选择CSV文件");
				deleteAttachment(at.fileUrl,false);
				rv = false;
			}else{
				//判断是否符合格式
				document.getElementById("templateFile").value = at.filename;
			}		
		}else{
			rv = false;
		}
	} else {
		var att;
		if(!fileUploadAttachments.isEmpty()){
			att = fileUploadAttachments.values().get(1); //如果attachment中之前有值,再次上传后的附件应在第2为...get(1);
			if(att!=null){//判断新上传的附件是否为doc或wps格式
				suffix = att.filename.split(".");
				fix = suffix[suffix.length-1];
				if(fix!="csv" && fix!="CSV"){
					alert("请选择CSV文件");
					deleteAttachment(att.fileUrl,false);//如果不是，删除该附件
					rv = false;
				}else{//如果为wps或doc格式，删除原有的附件，并把附件名填上
					var o_at = fileUploadAttachments.values().get(0);
					deleteAttachment(o_at.fileUrl,false);
					document.getElementById("templateFile").value = att.filename;
				}
			}else{
				rv = false;
			}
		}
	}
	
	if(rv == false){
		return;
	}
	var form = document.getElementById("uploadFormOrgImp");
	saveAttachment();
	form.target='theLogIframe';
	form.action= "${urlAddressBook}?method=doCSVImoprt&memberId="+csvMemberId+"&categoryId=" +csvCategoryId;
	form.submit();
}
//-->
</script>	
</head>
<body style="overflow: hidden;">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td class="webfx-menu-bar-gray" style="height: 40px; padding-left: 10px;">
		<c:choose>
		<c:when test="${param.addressbookType == 1}">
			<script>
			    //ipad隐藏一些操作菜单//if(v3x.getBrowserFlag('hideMenu'))
				var myBar1 = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","gray");
				
				var exportMenu = new WebFXMenu;
				exportMenu.add(new WebFXMenuItem("ExcelExport","EXCEL","download('${param.accountId}','${param.deptId}','${param.addressbookType}')","","",""));
				exportMenu.add(new WebFXMenuItem("VcrdExport","<fmt:message key='addressbook.toolbar.file.vcard'  />","savevCard(1,'${param.accountId}','${param.deptId}','${param.addressbookType}')","","",""));
				exportMenu.add(new WebFXMenuItem("CsvExport","<fmt:message key='addressbook.toolbar.file.csv'  />","saveCsv(1,'${param.accountId}','${param.deptId}','${param.addressbookType}')","","",null));
				if(v3x.getBrowserFlag('hideMenu')){
					<c:if test="${v3x:hasPlugin('uc')}">
						// myBar1.add(new WebFXMenuButton("sendMessage", "<fmt:message key='message.sendDialog.title'  />", "sendMessageForAddress()", [6,2], "", null));
					</c:if>
					<c:if test="${isCanSendSMS}">
						myBar1.add(new WebFXMenuButton("sendSMS", "<fmt:message key='top.alt.sendMobileMsg' bundle='${v3xMainI18N}' />", "sendSMS()", [6,3], "", null));	
					</c:if>
					<c:if test="${showExportPrint}">
					   myBar1.add(new WebFXMenuButton("download","<fmt:message key='org.button.exp.label' bundle='${orgI18N}' />",null,[2,6],"",exportMenu));
					   myBar1.add(new WebFXMenuButton("print", "<fmt:message key='addressbook.toolbar.print.label' />", "print()", [1,8], "", null));
					</c:if>
/* 					if('${param.click}' != 'dept'){
					    myBar1.add("<div class='webfx-menu--button'><input type='checkbox' disabled checked='checked' name='sonDepartmentMembers'/><fmt:message key='addressbook.toolbar.department.lable' /></div>");
					}else{
					    if('${param.isDepartment}'=='0'){
					        myBar1.add("<div class='webfx-menu--button'><input type='checkbox' name='sonDepartmentMembers' onclick=\"javascript:sonDepartmentMembers('searchForm',this.checked);\"/><fmt:message key='addressbook.toolbar.department.lable' /></div>");
						}else{
						    myBar1.add("<div class='webfx-menu--button'><input type='checkbox' checked='checked' name='sonDepartmentMembers' onclick=\"javascript:sonDepartmentMembers('searchForm',this.checked);\"/><fmt:message key='addressbook.toolbar.department.lable' /></div>");
						}
					} */
					if('${param.click}' != 'dept'){
					    myBar1.add("<div class='webfx-menu--button'><input type='checkbox' disabled checked='checked' name='sonDepartmentMembers'/><fmt:message key='addressbook.toolbar.department.lable' /></div>");
					}else{
					    if('${param.isDepartment}'=='0'){
					        myBar1.add("<div class='webfx-menu--button'><input type='checkbox' name='sonDepartmentMembers' onclick=\"javascript:sonDepartmentMembersNew(this.checked);\"/><fmt:message key='addressbook.toolbar.department.lable' /></div>");
						}else{
						    myBar1.add("<div class='webfx-menu--button'><input type='checkbox' checked='checked' name='sonDepartmentMembers' onclick=\"javascript:sonDepartmentMembersNew(this.checked);\"/><fmt:message key='addressbook.toolbar.department.lable' /></div>");
						}
					}
					
				}
				document.write(myBar1);
				document.close();
				
				$(".webfx-menu-bar-gray").css("background","#fff");
			</script>
		</c:when>
		<c:when test="${param.addressbookType == 2}">
			<script>
				var myBar2 = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />", "gray");
				
				var newSelector = new WebFXMenu;	
			  	newSelector.add(new WebFXMenuItem("newMember", "<fmt:message key='addressbook.toolbar.new.member.label'  />", "newMember()"));
			  	newSelector.add(new WebFXMenuItem("newCategory", "<fmt:message key='addressbook.toolbar.team'  />", "newCategory()"));		
				
				var exportMenu = new WebFXMenu;
				exportMenu.add(new WebFXMenuItem("ExcelExport","EXCEL","download('${param.accountId}','${param.deptId}','${param.addressbookType}')","","",null));
				exportMenu.add(new WebFXMenuItem("VcrdExport","<fmt:message key='addressbook.toolbar.file.vcard'  />","savevCard(2,'${param.accountId}','${param.deptId}','${param.addressbookType}')","","",null));
				exportMenu.add(new WebFXMenuItem("CsvExport","<fmt:message key='addressbook.toolbar.file.csv'  />","saveCsv(2,'${param.accountId}','${param.deptId}','${param.addressbookType}')","","",null));
					
				var importMenu = new WebFXMenu;
			    importMenu.add(new WebFXMenuItem("VcrdImport", "<fmt:message key='addressbook.toolbar.file.vcard'  />","openImortWindow()","", "",null));
		        importMenu.add(new WebFXMenuItem("CsvImport", "<fmt:message key='addressbook.toolbar.file.csv'  />","openCSVImport()","","", null));
			        
		        <c:if test="${isCanSendSMS}">
					myBar2.add(new WebFXMenuButton("sendSMS", "<fmt:message key='top.alt.sendMobileMsg' bundle='${v3xMainI18N}' />", "sendSMSByPhoneNum()", [6,3], "", null));	
				</c:if>
				myBar2.add(new WebFXMenuButton("newSelector", "<fmt:message key='addressbook.toolbar.new.select.label'  />", null, [1,1], "", newSelector));
				myBar2.add(new WebFXMenuButton("deleteSelector", "<fmt:message key='addressbook.toolbar.remove.select.label'  />", "removeEntity()",[1,3])); 
				myBar2.add(new WebFXMenuButton("modifyCategory", "<fmt:message key='addressbook.toolbar.update.team'  />", "modifyCategory()", [1,2]));	
				if(v3x.getBrowserFlag('hideMenu')){	
					myBar2.add(new WebFXMenuButton("exp", "<fmt:message key='org.button.exp.label' bundle='${orgI18N}' />", null, [2,6], "", exportMenu));
					myBar2.add(new WebFXMenuButton("imp", "<fmt:message key='org.button.imp.label'  bundle='${orgI18N}' />", null, [9,5], "", importMenu));
					myBar2.add(new WebFXMenuButton("print", "<fmt:message key='addressbook.toolbar.print.label' />", "print()", [1,8], "", null));	
				}
				document.write(myBar2);
				document.close();
				$(".webfx-menu-bar-gray").css("background","#fff");
			</script>
		</c:when>
		<c:when test="${param.addressbookType == 3}">
			<script>
				var myBar3 = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","gray");
				if(v3x.getBrowserFlag('hideMenu')){
					<c:if test="${v3x:hasPlugin('uc')}">
						// myBar3.add(new WebFXMenuButton("sendMessage", "<fmt:message key='message.sendDialog.title'  />", "sendMessageForAddress()", [6,2], "", null));
					</c:if>
					<c:if test="${isCanSendSMS}">
						myBar3.add(new WebFXMenuButton("sendSMS", "<fmt:message key='top.alt.sendMobileMsg' bundle='${v3xMainI18N}' />", "sendSMS()", [6,3], "", null));	
					</c:if>
					<c:if test="${showExportPrint}">
						myBar3.add(new WebFXMenuButton("download", "<fmt:message key='addressbook.toolbar.download.label'  />", "download('${param.accountId}','${param.deptId}','${param.addressbookType}')", [6,4], "", null));
						myBar3.add(new WebFXMenuButton("print", "<fmt:message key='addressbook.toolbar.print.label' />", "print()", [1,8], "", null));
					</c:if>
				}
				document.write(myBar3);
				document.close();
				$(".webfx-menu-bar-gray").css("background","#fff");
			</script>
		</c:when>
		<c:otherwise>
			<script>
				var myBar4 = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","gray");
				if(v3x.getBrowserFlag('hideMenu')){
					<c:if test="${v3x:hasPlugin('uc')}">
						// myBar4.add(new WebFXMenuButton("sendMessage", "<fmt:message key='message.sendDialog.title'  />", "sendMessageForAddress()", [6,2], "", null));
					</c:if>
					<c:if test="${isCanSendSMS}">
						myBar4.add(new WebFXMenuButton("sendSMS", "<fmt:message key='top.alt.sendMobileMsg' bundle='${v3xMainI18N}' />", "sendSMS()", [6,3], "", null));	
					</c:if>
				}
				myBar4.add(new WebFXMenuButton("newOwnTeam", "<fmt:message key='addressbook.toolbar.new.team.label'  />", "newOwnTeam()", [1,1]));
				myBar4.add(new WebFXMenuButton("modifyOwnTeam", "<fmt:message key='addressbook.toolbar.modify.team.label'  />", "modifyOwnTeam()", [1,2]));
				myBar4.add(new WebFXMenuButton("removeOwnTeam", "<fmt:message key='addressbook.toolbar.remove.team.label'  />", "removeOwnTeam()", [1,3], "", null));
				document.write(myBar4);
				document.close();
				$(".webfx-menu-bar-gray").css("background","#fff");
			</script>
		</c:otherwise>
		</c:choose>
	</td>
	<input type="hidden" name="click" id="click" value="${param.click }" />
	<input type="hidden" name="deptId" id="deptId" value="${param.deptId}" />
	<input type="hidden" name="deptIds" id="deptIds" value="${param.deptIds}" />
	<input type="hidden" name="otId" id="otId" value="${param.otId}" />
	<input type="hidden" name="sysId" id="sysId" value="${param.tId}" />
	<input type="hidden" name="mem" id="mem" value="${param.mem}" />
	
	<c:if test="${true || param.addressbookType != 4}">
		<td class="webfx-menu-bar-gray" height="25">
			<div class="div-float-right condition-search-div">
			<c:choose>
			<c:when test="${param.addressbookType == 2}"><!-- 私人通讯录 -->
			<% pageContext.setAttribute("expressionTypes", "name:listSearch.member.name:freeText;abPost:listSearch.member.post:freeText;abLevel:listSearch.member.level"+(Functions.suffix())+":freeText;companyPhone:listSearch.member.telNumber:freeText;mobilePhone:listSearch.member.mobilePhone:freeText"); %>
			</c:when>
			<c:otherwise>
				<c:choose>
					<c:when test="${isRoot}">
						<% pageContext.setAttribute("expressionTypes", "name:listSearch.member.name:freeText;groupPost:listSearch.member.groupPost:groupPostList;groupLevel:listSearch.member.groupLevel:groupLevelList;companyPhone:listSearch.member.telNumber:freeText;mobilePhone:listSearch.member.mobilePhone:freeText"); %>
					</c:when>
					<c:otherwise>
						<% pageContext.setAttribute("expressionTypes", "name:listSearch.member.name:freeText;post:listSearch.member.post:orgPost;level:listSearch.member.level"+(Functions.suffix())+":orgLevelList;companyPhone:listSearch.member.telNumber:freeText;mobilePhone:listSearch.member.mobilePhone:freeText"); %>
					</c:otherwise>
				</c:choose>
			</c:otherwise>
			</c:choose>
			<%-- 这是相对其它include toolbar.jsp 的jsp的位置 --%>
<%-- 			<jsp:include page="../listAddSearch.jsp">
			<jsp:param name="expressionType" value="${param.condition}"/>
			<jsp:param name="expressionValueBase64" value="<%=com.seeyon.ctp.util.ListSearchHelper.encodeBase64(request.getParameter(\"textfield\"))%>"/>
			<jsp:param name="expressionTypeParamName" value="condition"/>
			<jsp:param name="expressionValueParamName" value="textfield"/>
			<jsp:param name="windowToLoad" value="window"/>
			<jsp:param name="expressionTypes" value="${expressionTypes}"/>
			<jsp:param name="isEnablePost" value="${addressBookSet.memberPost}"/>
            <jsp:param name="isEnableLevel" value="${addressBookSet.memberLevel}"/>
            <jsp:param name="isEnablePhone" value="${addressBookSet.memberPhone}"/>
            <jsp:param name="isEnableMobile" value="${addressBookSet.memberMobile}"/>
            <jsp:param name="accountId" value="${param.accountId}"/>
			</jsp:include> --%>
			</div>
<%--
			<form action="" name="searchForm" id="searchForm" method="get" onsubmit="return false" >
				<input type="hidden" name="from" value="${param.from}"/>
				<div class="div-float-right">
					<div class="div-float">
						<select name="condition" id="condition" onChange="showNextCondition(this)" class="condition">
					    	<option value="subject"><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
						    <option value="name"><fmt:message key="addressbook.username.label"  /></option>
						    <option value="level"><fmt:message key="addressbook.company.level.label" /></option>
						    <option value="tel"><fmt:message key="addressbook.mobilephone.label"  /></option>
					  	</select>
				  	</div>
				  	<div id="nameDiv" class="div-float hidden"><input type="text" name="textfield" id="name" class="textfield-search"/></div>
				  	<div id="telDiv" class="div-float hidden"><input type="text" name="textfield" id="tel" class="textfield-search"/></div>
				  	<c:choose>
				  		<c:when test="${param.addressbookType != 2}">
				  			<div id="levelDiv" class="div-float hidden">
				  				<select name="textfield" id="level_id" class="textfield-search">
				  					<c:forEach var="level" items="${levellist}">
				  						<option value="<c:out value="${level.id}"/>"><c:out value="${level.name}"/></option>
				  					</c:forEach>
				  				</select>
				  			</div>
				  		</c:when>
				  		<c:otherwise>
				  			<div id="levelDiv" class="div-float hidden"><input type="text" name="textfield" id="level_name" class="textfield-search"/></div>
				  		</c:otherwise>
				  	</c:choose>
				  	<div onclick="javascript:search(${param.addressbookType})" class="div-float condition-search-button"></div>
			  	</div>
			</form>
--%>
		</td>
	</c:if>			
</tr>
</table>
<div style="display:hidden">
<form enctype="multipart/form-data" id="uploadFormOrgImp" name="uploadFormOrgImp" method="post">
<v3x:attachmentDefine attachments="${attachments}" />
<div class="hidden"><v3x:fileUpload attachments="${attachments}" encrypt="false" /></div>	
<script>
	var fileUploadQuantity = 1;
</script>
<div style="display:none;" class="hidden">
  <table width="100%" height="100%" align="center"  border="0">
  	<tr><td height="25">
	<table width="100%" height="100%"  align="center" border="0" cellspacing="0" cellpadding="0">
		<input type="hidden" name="impURL">
		<tr>
			<td id="upload1" class="bg-advance-middel" height="25">
				<div style="width:50%">
				<input name="templateFile" type="text" class="cursor-hand" id="templateFile" style="width:100%" deaultValue="" validate="isDeaultValue,notNull" readonly = "true" value="" escapeXml="true" onClick="attach();"; /></div>
				<div style="width:50%"><fmt:message key='import.choose.file.vcard'  /></div>
			</td>
			<input type="file" name="file1" id="file1" style="width: 100%">
		</tr>
	</table>
	</td>
	</tr>	
  </table>
</div>
</form>
</div>
<iframe style="display:none;" class="hidden" id="theLogIframe" name="theLogIframe" frameborder="0" marginheight="0" marginwidth="0" ></iframe>
<script type="text/javascript">
<!--
var paramCondition = "${v3x:escapeJavascript(param.condition)}";
var paramTextfield = "${v3x:escapeJavascript(param.textfield)}";
var paramAddressbookType = "${v3x:escapeJavascript(param.addressbookType)}";
showCondition('${v3x:toHTML(param.condition)}', "<v3x:out value='${v3x:toHTML(param.textfield)}' escapeJavaScript='true' />", "<v3x:out value='${v3x:toHTML(param.textfield1)}' escapeJavaScript='true' />");
//-->
</script>
</body>
</html>