<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.ctp.common.constants.ApplicationCategoryEnum" %>
<%@page import="com.seeyon.ctp.common.constants.Constants" %>
<html>
<head>
<%@ include file="../common/INC/noCache.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>--</title>
<style type="text/css">
  html,body{
     width: 100%;
     height:100%;
     border:0;
     padding:0;
     overflow:hidden;
  }
</style>
<script type="text/javascript">

var contentOfficeId;
var newEdocBodyId;
var edocType = parent.edocType;
//var editType = "${canUpdateContent?'1,0':'0,0'}" ;
var officecanSaveLocal= ${canUpdateContent};
var contentUpdate = true;
var currentPage = "newEdoc";
var isNewOfficeFilePage = true;
var summaryId = ${bean.id}; 
isNewOfficeFilePage = false;
var registerType = "${bean.registerType }";
var isFromTemplate = false;//G6登记默认是false不能调用模板

</script>
<%@ include file="edocHeader.jsp" %>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/edoc/js/register.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/barCode/js/barCode.js" />"></script>
<c:set var="hasBarCode" value="${v3x:hasPlugin('barCode')}"/>
<%-- 
<c:set var="hasBarCode" value="true"/>
--%>
<script type="text/javascript">

//设置收文登记页面支持PDF正文。
var supportPdfMenu = true;

canUpdateContent = ${canUpdateContent};


if(!window.dialogArguments) {
  if(getA8Top()!=null && typeof(getA8Top().showLocation)!="undefined") {
	//getA8Top().showLocation(202, "<fmt:message key='edoc.new.type.rec'/> - <fmt:message key='edoc.workitem.state.register'/>");
	  //getA8Top().showLocation(202, "<fmt:message key='edoc.new.type.rec'/>");
  }
}

//能否手动输入文号
var personInput='${personInput}';

var selPerElements = new Properties();

var sendlt = '<<fmt:message key="click.alt" /><fmt:message key="edoc.element.sendtounit" />>';
var copylt = '<<fmt:message key="click.alt" /><fmt:message key="edoc.element.copytounit" />>';


function resizeLayout(){
    $("#attachmentTR img,#attachment2TR img").unbind("click");
    $("#attachmentTR img,#attachment2TR img").bind("click", function(){
        resizeLayout()
    });
    
    $("#registFormTD").height(document.body.clientHeight - $("#attatchDiv").height() - 33);
}

window.onload = function() {
    
    //检验浏览器，如果是非IE
    /*if(!$.browser.msie){
        alert(v3x.getMessage("edocLang.isNotIe"));
        document.body.onbeforeunload = null;//取消离开提示
        backToRegList();//转移到待登记列表
        return;
    }*/
    
	previewFrame('Down');
	
	//用户手工输入开关
	if(personInput=='true') {
		$("#imgSerialNo").css("display", "block");	
	}

	var tempSendTo = "${ctp:escapeJavascript(bean.sendTo)}";
	if(tempSendTo=="") {
		$("[@name='sendTo']").val(sendlt);
		$("[@name='sendTo']").css("color", "gray");	
	}
	var tempCopyTo = "${ctp:escapeJavascript(bean.copyTo)}";
	if(tempCopyTo=="") {
		$("[@name='copyTo']").val(copylt);
		$("[@name='copyTo']").css("color", "gray");	
	}

	<c:if test="${hasBarCode}">
	
	if(registerType == "3"){
		if(openBarCodePort()){
			alert("<fmt:message key='edoc.scanningGun.success'/>");
		}else{
			alert("<fmt:message key='edoc.scanningGun.fail'/>");
		}
	}
	</c:if>
	loadRelationButton();
	initBodyType();
	
	resizeLayout();
}
//点击发送按钮的次数，防止多次点击
var sendCount=0;
function saveRegister(state) {
	var keywordsObj = document.getElementsByName("keywords")[0];
	var subjectObj = document.getElementById("subject");
	if(keywordsObj && keywordsObj.value.length > 85){
		alert("<fmt:message key='edoc.keyword.lessThan'/>");
		return ;
	}else if(subjectObj && subjectObj.value.length > 250){
		alert("<fmt:message key='edoc.subject.lessThan'/>");
		return ;
	}
    var theForm = document.getElementsByName("sendForm")[0];
    theForm.action = genericURL + "?method=saveRegister";
    if (checkForm(theForm)) {
    	//标题不能为空并且不含有特殊字符	
    	if(!checkRegisterSubject(theForm)){return;}
    	//检查主送单位、主送单位2的是否设置有值
		if(!checkRegisterSendTo(theForm)){return;}
		/**
		 	检查登记表里内部文号是否被占用 Start
			叶方确认，同一个文号，如果是A先用（发送，暂存待办），那么B再用这个号，就需要提示
		**/
		 if(!checkSerialNo()){return;}
		//检查公文表里内部文号是否被占用 End
		//检查分发人员是否有分发权限
		if(!isEdocDistribute(theForm)) {return;}
		//保存正文
		
		/*checkOpenState();
		var ocxObj = officeEditorFrame.document.getElementById("WebOffice");
		ocxObj.EditType = "1,0"; //登记单保存时，需要保存正文，只读方式handWrite.js不保存正文。
		officeEditorFrame.isLoadOfficeFile = true; //保证handWrite.js中的checkNeedSave()能验证通过
		*/
      	// 校验打印份数
      	if($("#registerCopies").val()!= ""){
      		if(!/^(0|([1-9][0-9]*))$/.test($("#registerCopies").val())){
          		alert("<fmt:message key='edoc.shares.positiveInteger'/>"); // 打印份数只能为0或正整数！
          		return false;
          	}else if(($("#registerCopies").val().length>8)){              
              	alert("<fmt:message key='edoc.registerCopieswords.limit'/>"); //  打印份数 整数个数长度不能超过9
              	return false;
            }  
         }
      	var bodyType = document.getElementById("bodyType").value;
      	if(bodyType!="HTML") {
      		fileId = newEdocBodyId;
			theForm.content.value = fileId;
        }
      	isNewOfficeFilePage = true;
      	//待分发,分发电子公文不判断
      	if (!saveOcx()) {return;}
	    //保存附件
        saveAttachment();
        //屏蔽按钮
        disableRegisterButtons();
        theForm.state.value = state;
        if(window.event){
        	window.event.returnValue = "false";
        }
        document.body.onbeforeunload = null;
        sendCount++;
    	if(sendCount>1){
    		alert("请不要重复点击！");
    		sendCount = 0;
    		return;
    	}
        theForm.submit();	
        //getA8Top().startProc('');
        
    }
}

function onbeforeunload() {
	closeBarCodePort();
	return true;
}

function initDate(reader){
	if(reader){
		//标题
		var subject = document.getElementById("subject");
		if(subject)
			subject.value = reader.GetDocTitle();
		//来问字号
		var docMark = document.getElementById("docMark");
		if(docMark)
			docMark.value = reader.GetDocIssue();
		//主送单位
		var sendTo = document.getElementById("sendTo");
		if(sendTo)
			sendTo.value = reader.GetReceCompany();
		//成文日期
		var edocDate = document.getElementById("edocDate");
		if(edocDate)
			edocDate.value = reader.GetDocTime();
		
		var options;
		//公文密级
		var urgentLevel = document.getElementById("urgentLevel");
		var scanUrgentLevel = reader.GetSecuLevel();
		if(urgentLevel && scanUrgentLevel){
			options = urgentLevel.options;
			if(options){
				for(var i=0;i<options.length;i++){
					if(options[i].text == scanUrgentLevel)
						urgentLevel.selected = true;
				}
			}
		}
		//紧急程度
		var secretLevel = document.getElementById("secretLevel");
		var scanSecretLevel = reader.GetUrgenLevel();
		if(secretLevel && scanSecretLevel){
			options = secretLevel.options;
			for(var i=0;i<options.length;i++){
				if(options[i].text == scanSecretLevel)
					options[i].selected = true;
			}
		}
	}
}

/**
 * 验证内部文号是否重复，除开自己。
 */
function checkSerialNo(){
	//	格式：serialNoValue	"0|String||3"	手写输入
	var serialNo=document.getElementById("serialNo");
	if(!serialNo){
	    return true   
	};
	
	var serialNoValueStr=serialNo.value;
	var serialNoValue = "";
	if(serialNoValueStr.indexOf("|") == -1){
	    serialNoValue = serialNoValueStr;
	}else{
	    serialNoValueStr = serialNoValueStr.substring(serialNoValueStr.indexOf("|") + 1);
	    serialNoValue = serialNoValueStr.substring(0, serialNoValueStr.indexOf("|"));//文号
	}
	var requestCaller = new XMLHttpRequestCaller(this, "edocManager", "checkSerialNoExsit", false);
	requestCaller.addParameter(1,"String", ${bean.id}==null?'':'${bean.id}');
	requestCaller.addParameter(2,"String",serialNoValue);
	var rs = requestCaller.serviceRequest();
	//(0:未使用内部文号 | 1：已使用该内部文号)
	if(rs == "1"){//已经被占用
		alert(_("edocLang.doc_innermark_used"));
		return false;
	}
	return true;
}

function relationSendV(){
  	openRelationSendV('${recEdocId}','${recType}');
}

function loadRelationButton(){
  //关联发文
  var relSends = "${relSends}";
  if(relSends == "haveMany"){
	 document.getElementById("relationSend").style.display="block";
  }
}

function backToRegList(){
	parent.parent.location.href='edocController.do?method=entryManager&entry=recManager&toFrom=listRegister&edocType=1';
}

</script>
</head>
<body <c:if test="${param.from!='desktop'}">onbeforeunload="${hasBarCode? 'onbeforeunload()':''}"</c:if>>
<form name="sendForm" id="sendForm" method="post" style="height: 100%;">
<input type="hidden" name="app" value="${param.app }" />
<input type="hidden" name="oldDistributerId" value="${oldDistributerId }"/>
<input type="hidden" name="listType" value="${v3x:toHTML(param.listType)}"/>
<input type="hidden" name="recListType" value="${v3x:toHTML(param.recListType)}"/>
<input type="hidden" id="comm" name="comm" value="${v3x:toHTML(param.comm)}"/>
<input type="hidden" name="agentId" value="${agentId }"/>
<input type="hidden" name="agentToId" value="${agentToId }"/>
<input type="hidden" id="currContentNum" name="currContentNum" value="0"/>
<input type="hidden" id="isUniteSend" name="isUniteSend" value="false"/> 
<input type="hidden" name="method" value="saveRegister"/>
<input type="hidden" name="list" value="${param.list}"/>
<input type="hidden" name="id" value="${bean.id }"/>
<input type="hidden" name="identifier" value="${bean.identifier }"/>
<input type="hidden" name="edocType" value="${bean.edocType }"/>
<input type="hidden" id="edocId" name="edocId" value="${bean.edocId }"/>
<input type="hidden" name="recieveId" value="${bean.recieveId }"/>
<input type="hidden" name="registerType" value="${bean.registerType }"/>
<input type="hidden" name="createUserId" value="${bean.createUserId }"/>
<input type="hidden" name="createUserName" value="${bean.createUserName }"/>
<input type="hidden" name="createTime" value="${bean.createTime }"/>
<input type="hidden" name="updateTime" value="${bean.updateTime }"/>
<input type="hidden" name="sendUnit" value="${bean.sendUnit }"/>
<input type="hidden" name="sendUnitId" value="${bean.sendUnitId }"/>
<%-- 
<input type="hidden" name="sendUnitType" value="${bean.sendUnitType }"/>
--%>
<input type="hidden" name="edocUnitId" value="${bean.edocUnitId }"/>
<input type="hidden" name="registerUserId" value="${bean.registerUserId }"/>
<input type="hidden" name="issuerId" value="${bean.issuerId }"/>
<input type="hidden" name="issueDate" value="${bean.issueDate }"/> 
<input type="hidden" name="distributerId" value="${bean.distributerId }"/>
<input type="hidden" name="distributer" value="${bean.distributer }"/>

<input type="hidden" name="sendType" value="${bean.sendType }"/>
<input type="hidden" name="sendToId" value="${bean.sendToId }"/>
<input type="hidden" name="copyToId" value="${bean.copyToId }"/>
<input type="hidden" name="copies" value="${bean.copies }"/>
<input type="hidden" name="state" value="${bean.state }"/>
<input type="hidden" name="recTime" value="${bean.recTime }"/>
<input type="hidden" name="orgAccountId" id="orgAccountId" value="${bean.orgAccountId }"/>
<input type="hidden" name="forwordtosend" value="${forwordtosend}"/>
<input type="hidden" name="copies" id="copies" value="${copies }"/> 


<div name="edocContentDiv" id="edocContentDiv" style="width:0px;height:0px;overflow:hidden; position: absolute;">
	<input type="hidden" name="bodyType" id="bodyType" value="${registerBody.contentType}" >
	<input type="hidden" name="bodyId" value="${registerBody.id}" >
	
	<v3x:editor htmlId="content" editType="${canUpdateContent?'1,0':'0,0'}" content="${registerBody.content}" type="${registerBody.contentType}" createDate="${registerBody.createTime}" originalNeedClone="${registerBody.contentType=='gd' ? false : cloneOriginalAtts}" category="<%=ApplicationCategoryEnum.edoc.getKey()%>" contentName="" />
</div>

<div style="height: 26px;line-height: 26px;width: 100%;overflow: hidden;">
    <script type="text/javascript">     
            var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
            var sendButton="";//纸质是保存，其他都是发送
            if(${param.listType eq 'registerByManual'}){
                sendButton="<fmt:message key='common.toolbar.save.label' bundle='${v3xCommonI18N}'/>";
            }else{
                sendButton="<fmt:message key='common.toolbar.send.label' bundle='${v3xCommonI18N}'/>";
            }
            myBar.add(new WebFXMenuButton("send",sendButton,"saveRegister(2)", [1,4], "", null));   

                            
            //保存到草稿箱
            <c:if test="${'modifyRegister' ne comm}">
                myBar.add(new WebFXMenuButton("saveAs", "<fmt:message key='edoc.receive.register.saveToDraftBox'/>","saveRegister(0);", [1,5], "", null));
            </c:if>
            <%--
            if(${bean.distributeState!=2} && ${bean.state!=2} && ${bean.state!=3} && ${bean.registerType}!=0 && ${bean.registerType}!=1) {
                myBar.add(new WebFXMenuButton("saveAs", "<fmt:message key='edoc.receive.register.saveToDraftBox'/>","saveRegister(0);", [1,5], "", null));
            } else if(${bean.distributeState!=2} && ${bean.state==3}) {//保存(用于退件箱)
                myBar.add(new WebFXMenuButton("saveAs", "<fmt:message key='modifyBody.save.label'/>","saveRegister(3);", [1,5], "", null));
            }
            --%>
                
            var insert = new WebFXMenu;
            insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.localfile.label' bundle='${v3xCommonI18N}' />", "insertAttachmentFn()"));
            insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.mydocument.label' bundle='${v3xCommonI18N}' />", "quoteDocumentEdocFn()"));

            myBar.add(new WebFXMenuButton("insert", "<fmt:message key='common.toolbar.insert.label' bundle='${v3xCommonI18N}'/>", null, [1,6], "", insert));
            //myBar.add(new WebFXMenuButton("insert", "<fmt:message key='common.toolbar.insert.label' bundle='${v3xCommonI18N}'/>", "insertAttachment()", [1,6], "", null));

            if(${bean.registerType!=0} && ${bean.registerType!=1} && ${bean.distributeState!=2} && "${param.comm}"!="modify") {
                myBar.add(${v3x:bodyTypeSelector("v3x")});
            }
            
            myBar.add(new WebFXMenuButton("content1", "<fmt:message key='common.toolbar.content.label' bundle='${v3xCommonI18N}' />","dealPopupContentWinWhenDraft('0');", [8,10], "", null));
            
            //if(registerType==1 && !window.dialogArguments) {//电子登记
            //  myBar.add(new WebFXMenuButton("back", "<fmt:message key='menu.edocNew.back' />","backToRegList();", [4,1], "", null));
            //}
            <c:if test="${param.from!='desktop'}">
            document.write(myBar.toString());
            document.close();
            </c:if>
        </script>
</div>
<div id="attatchDiv" style="width: 100%;">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
     <tr id="attachment2TR" class="bg-summary" style="display:none;">
         <td nowrap="nowrap" style="width:60px;" class="bg-gray" valign="top"><fmt:message key="common.toolbar.insert.mydocument.label" bundle="${v3xCommonI18N}" />:</td>
         <td valign="top"><div class="div-float">(<span id="attachment2NumberDiv"></span>)</div>
             <div id="attachment2Area" style="overflow: auto;"></div>
         </td>
     </tr>
     <tr id="attachmentTR" class="bg-summary" style="display:none;">
          <td nowrap="nowrap" style="width:60px;" class="bg-gray" valign="top" align="right"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" />:</td>
           <td valign="top"><div class="div-float">(<span id="attachmentNumberDiv"></span>)</div>
             <v3x:fileUpload attachments="${attachments}" canDeleteOriginalAtts="${canDeleteOriginalAtts}" originalAttsNeedClone="${cloneOriginalAtts}" />      
           </td>
     </tr>
 </table>
</div>

<div style="height: 6px;overflow: hidden;" class="bg-b"></div>
<div id="registFormTD" style="overflow: hidden;">
  <div id="formAreaDiv" class="scrollList" style="overflow: auto;">
            <div id="relationSend" align="right" style="display:none;"> 
                <a href="#" onclick="relationSendV()" ><font color=red><fmt:message key='edoc.associated.posting'/></font></a>
            </div>
        
            <div id="html" name="html" style="border:1px solid;border-color:#FFFFFF;">
                <%@ include file="formManage/edoc_register_form.jsp" %>
            </div>
        </div>
</div>


<script type="text/javascript">

	newEdocBodyId = fileId;
	contentOfficeId = new Properties(0);
	contentOfficeId.put("${registerBody.contentNo}", fileId);
	
	function insertAttachmentFn(){
        insertAttachment(null, null, "resizeLayout", "false");
	}
	
    function quoteDocumentEdocFn(){
        quoteDocumentEdoc('${appType}');
        window.quoteDocument_affterFn = resizeLayout;//该方法会在关联文档关闭后回调，在edoc.js里面
    }
</script>
<c:if test="${hasBarCode}">
<v3x:webBarCode readerId="PDF417Reader" readerCallBack="initDate"/>
</c:if>
</form>
</body>
</html>