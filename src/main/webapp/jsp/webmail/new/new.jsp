<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.seeyon.v3x.common.constants.ApplicationCategoryEnum" %>
<%@page import="com.seeyon.v3x.common.constants.Constants" %>
<!DOCTYPE html>
<html style="height: 100%;">
<head>
<%@ include file="../webmailheader.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="label.new.create"/></title>
<script type="text/javascript">
var addFlag = "to";
var excludeElements_to = [];
var excludeElements_cc = [];
var excludeElements_bc = [];
function send()
{
	var form = document.getElementById("sendForm");
	if(checkForm(form))
	{
		saveAttachment();
		form.action = "${webmailURL}?method=send";
		form.comm.value = "";
		isFormSumit=true;
		form.submit();
		try{
		    getA8Top().startProc("<fmt:message key='label.alert.send'/>");
		}catch(e){
		}
	}
}

function setBulPeopleFields(elements,flag){
	if(elements.length <= 0){
		return false;
	}else{
		var ids = "";
		for(var i = 0; i < elements.length; i++){
			var element = elements[i];
			if(ids.length > 0){
				ids += ",";
			}
			ids += element.id;
		}
		if(ids.length > 0){
			var form = document.getElementById("getEmailForm");
			document.getElementById("hidden_ids").value = ids;
			form.submit();
		}
		if(flag=="to"){
			excludeElements_to = elements;
		}else if(flag=="cc"){
			excludeElements_cc = elements;
		}else if(flag=="bc"){
			excludeElements_bc = elements;
		}
	}
}


function saveToDraft()
{
	var form = document.getElementById("sendForm");
	if(checkForm(form))
	{
     	saveAttachment();
		form.action = "${webmailURL}?method=send";
		form.comm.value = "save";
	    isFormSumit=true;
		form.submit();
		try{
		    getA8Top().startProc("<fmt:message key='label.alert.savedraft'/>");
        }catch(e){
        }
	}
}
var selectAddressItems = {};
function selectAddress(flag) {
	selectAddressItems.flag = flag;
 	isFormSumit=true;
 	var elements = null;
 	getA8Top().selectAddressWin = getA8Top().$.dialog({
        title:" ",
        transParams:{'parentWin':window},
        url: "${webmailURL}?method=getAddress",
        width: 608,
        height: 488,
        isDrag:false
    });
}

function selectAddressCollBack(elements) {
	var emailAddress = "";
	getA8Top().selectAddressWin.close();
    var to = document.getElementById(selectAddressItems.flag);
    if(elements != null && elements.length > 0){
        for(var i = 0; i < elements.length; i++){
            if(emailAddress.length > 0){
                emailAddress += ",";
            }
            if(to.value.indexOf(elements[i]) == -1){
                emailAddress += elements[i];
            }
        }
        if(emailAddress.length > 0){
            if(to.value.length > 0){
                to.value += "," + emailAddress;
            }else{
                to.value = emailAddress;
            }
        }
    }
    isFormSumit=false;
}

function validEmail(element){
	var value = element.value;
	if(value.length > 0){
		var emails = value.split(",");
		for(var i = 0; i < emails.length; i++){
			var start = emails[i].indexOf("<");
			var end = emails[i].indexOf(">");
			if(start != -1 && end != -1){
				var email = emails[i].substring(start+1, end);
				if(!isMyEmail(element, email)){
					return false;
				}
			}else{
				if(!isMyEmail(element, emails[i])){
					return false;
				}
			}
		}
		return true;
	}
	return true;
}

function isMyEmail(element, value){
	var inputName = element.getAttribute("inputName");
	if(!testRegExp(value, '^[-!#$%&\'*+\\./0-9=?A-Z^_`a-z{|}~]+@[-!#$%&\'*+\\/0-9=?A-Z^_`a-z{|}~]+\.[-!#$%&\'*+\\./0-9=?A-Z^_`a-z{|}~]+$')){
		writeValidateInfo(element, v3x.getMessage("V3XLang.formValidate_isEmail", inputName));
		return false;
	}
	
	return true;
}
function joinArrays(jionArr,arr1,arr2){

	var arr = new Array();
	excludeElements_wfto = new Array();
	excludeElements_wfbc = new Array();
	excludeElements_wfcc = new Array();
		
	if(arr1&&arr2){
		arr = eval("excludeElements_"+jionArr).concat(arr1,arr2);
	}else if(arr1){
		arr = eval("excludeElements_"+jionArr).concat(arr1);
	}else if(arr2){
		arr = eval("excludeElements_"+jionArr).concat(arr2);
	}
	
	return arr;
}
function mailExcludeElements(flag){
	if("cc"==flag){
		excludeElements_wfcc = joinArrays("wfcc",excludeElements_to,excludeElements_bc);
	}else if("bc"==flag){
		excludeElements_wfbc = joinArrays("wfbc",excludeElements_to,excludeElements_cc);
	}else{
		excludeElements_wfto = joinArrays("wfto",excludeElements_bc,excludeElements_bc);
	}
}

function selectinner(flag){
	isFormSumit = true;
	addFlag = flag;
	mailExcludeElements(flag);
	eval("selectPeopleFun_wf" + flag + "();");
	isFormSumit = false;
}

// Add By Lif Start
function paddingCss(){
	if (parent.name == "contentFrame"){
		document.body.className="padding5";
		document.getElementById("tableBorder").className="webmail-border"
	}
}

	function showAttention(object){
		/*var divObj = document.getElementById(object);
		var event = v3x.getEvent(); 
		var divLeft = event.x;
		if(divLeft+220>document.body.clientWidth){
			divLeft = event.x - 220;
		}
  		divObj.style.top =  event.y - 10 + "px";
  		divObj.style.left = divLeft + "px";
  		divObj.style.height = 25 + "px";
  		divObj.style.width = 200 + "px";
  		divObj.style.display = "block";*/
  	}
  	
  	function hideAttention(object){
  		var divObj = document.getElementById(object);
  		divObj.style.display = "none";
  	}
// Add End
</script>
</head>
<!-- Edit By Lif Start -->
<body scroll="no" onload="paddingCss();" style="height: 100%;">
<!-- Edit End -->
<form name="sendForm" id="sendForm" method="post" style="height: 100%;">
<v3x:selectPeople id="wfto" panels="Department,Team,Outworker" selectType="Member,Email" jsFunction="setBulPeopleFields(elements,'to')" />
<v3x:selectPeople id="wfcc" panels="Department,Team,Outworker" selectType="Member,Email" jsFunction="setBulPeopleFields(elements,'cc')" />
<v3x:selectPeople id="wfbc" panels="Department,Team,Outworker" selectType="Member,Email" jsFunction="setBulPeopleFields(elements,'bc')" />
<input type="hidden" name="comm" value="${comm}" />
<input type="hidden" name="msgno" value="${bean.mailNumber}" />
<input type="hidden" name="mailLongId" value="${bean.mailLongId}" />
<input type="hidden" name="folderType" value="${folderType }" />
<input type="hidden" name="referenceId" value="${referenceId }" />
<!-- Edit By Lif Start -->
<table width="100%" height="100%"  border="0" cellpadding="0" cellspacing="0" id="tableBorder" style=" background-color: rgb(237,237,237)">
<!-- Edit End -->
  <tr>
    <td height="22" valign="top">
    	<script type="text/javascript">
    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
    	
    	var insert = new WebFXMenu;
    	insert.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.insert.localfile.label' bundle='${v3xCommonI18N}' />", "insertAttachment()"));
    	
    	var bodyTypeSelector = new WebFXMenu;
    	bodyTypeSelector.add(new WebFXMenuItem("", "<fmt:message key='common.body.type.html.label' bundle='${v3xCommonI18N}' />", "chanageBodyType('<%=Constants.EDITOR_TYPE_HTML%>')", "<c:url value='/common/images/toolbar/bodyType_html.gif'/>"));
    	bodyTypeSelector.add(new WebFXMenuItem("", "<fmt:message key='common.body.type.officeword.label' bundle='${v3xCommonI18N}' />", "chanageBodyType('<%=Constants.EDITOR_TYPE_OFFICE_WORD%>')", "<c:url value='/common/images/toolbar/bodyType_word.gif'/>"));
    	bodyTypeSelector.add(new WebFXMenuItem("", "<fmt:message key='common.body.type.officeexcel.label' bundle='${v3xCommonI18N}' />", "chanageBodyType('<%=Constants.EDITOR_TYPE_OFFICE_EXCEL%>')", "<c:url value='/common/images/toolbar/bodyType_excel.gif'/>"));
    	    	
    	myBar.add(new WebFXMenuButton("save", "<fmt:message key='button.saveDraft' />", "saveToDraft()", [3,4], "", null));
    	if(v3x.getBrowserFlag('hideMenu')){
    		myBar.add(new WebFXMenuButton("insert", "<fmt:message key='common.toolbar.insert.label' bundle='${v3xCommonI18N}' />", null, [1,6], "", insert));
    	}
    	<%--
    	//myBar.add(new WebFXMenuButton("select", "内部人员", "selectPeople('wf')", "<c:url value='/apps_res/webmail/images/button_contact.gif'/>", "", null));
		//myBar.add(new WebFXMenuButton("select", "<fmt:message key='label.mail.contact' />", "selectAddress('to')", "<c:url value='/apps_res/webmail/images/button_contact.gif'/>", "", null));
    	//myBar.add(new WebFXMenuButton("insertd", "<fmt:message key='common.insert.label' bundle='${v3xCommonI18N}' />", null, "<c:url value='/common/images/toolbar/insert.gif'/>", "", insert));
    	//myBar.add(new WebFXMenuButton("bodyTypeSelector", "<fmt:message key='common.body.type.label' bundle='${v3xCommonI18N}' />", null, "<c:url value='/common/images/toolbar/bodyTypeSelector.gif'/>", "", bodyTypeSelector));
    	--%>
    	document.write(myBar);
    	document.close();
    	</script>
	</td>
  </tr>
  <tr>
<td> 
  <table width="100%" cellSpacing="0" style="border-top: 1px solid #b6b6b6;">  
  <tr class="bg-summary">
  	<td valign="top" rowspan="5" width="10" class="padding_l_5">
    	<DIV style="height:50px" onclick="send();" onmouseover="javascript:this.className='newbtn-over';" onmouseout="javascript:this.className='newbtn';" id=sendButton class=newbtn><fmt:message key='common.toolbar.send.label' bundle='${v3xCommonI18N}' /></DIV>
    </TD>
    <td width="70" height="20" class="bg-gray"><fmt:message key='label.head.to' />:</td>
    <td nowrap>
        <input name="to" type="text" id="to" class="input-100per" deaultValue="${bean.to}" inputName="<fmt:message key='label.alert.to' />"
               validate="notNull,validEmail"
               escapeXml="true" value="<c:choose><c:when test='${defaultaddr == null }'>${bean.to}</c:when><c:otherwise>${defaultaddr}</c:otherwise></c:choose>" >
        </td>
		<td width="200" align="left" nowrap>
			&nbsp;<a href="###" onclick="selectinner('to')" onMousemove="showAttention('attention');" onMouseleave="hideAttention('attention');" >[<fmt:message key='label.mail.addbymember'/>]</a>&nbsp;<a href="#" onclick="javascript:selectAddress('to')" onMousemove="showAttention('attention');" onMouseleave="hideAttention('attention');" >[<fmt:message key='label.mail.addbycontact'/>]</a>
			
			  <DIV id="attention" style="padding-left:5px;BORDER:#CCCCCC 1px solid;background-color:#97E4FE;display:none;POSITION:absolute;LINE-HEIGHT:20px;filter:alpha(opacity=70);">
				<table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
						<tr>
							<td><fmt:message key="label.new.attention" /></td>
						</tr>
				</table>
			 </DIV>
		</td>
  </tr>
  <tr class="bg-summary">
    <td height="20" class="bg-gray"><fmt:message key='label.head.cc' />:</td>
    <td nowrap>
        <input name="cc" type="text" id="cc" class="input-100per" deaultValue="${bean.cc}" inputName="<fmt:message key='label.alert.cc' />"
               validate="validEmail"
               escapeXml="true" value='${bean.cc}' >
        </td>
		<td width="200" align="left" nowrap>
			&nbsp;<a href="###" onclick="selectinner('cc')" onMousemove="showAttention('attention');" onMouseleave="hideAttention('attention');" >[<fmt:message key='label.mail.addbymember'/>]</a>&nbsp;<a href="###" onclick="javascript:selectAddress('cc')" onMousemove="showAttention('attention');" onMouseleave="hideAttention('attention');" >[<fmt:message key='label.mail.addbycontact'/>]</a>
		</td>
  </tr>
  <tr class="bg-summary">
    <td height="20" class="bg-gray"><fmt:message key='label.head.bc' />:</td>
    <td nowrap>
        <input name="bc" type="text" id="bc" class="input-100per" deaultValue="${bean.bc}" inputName="<fmt:message key='label.alert.bc' />"
               validate="validEmail"
               escapeXml="true" value='${bean.bc}' >
        </td>
		<td width="200" align="left" nowrap>
			&nbsp;<a href="###" onclick="selectinner('bc')" onMousemove="showAttention('attention');" onMouseleave="hideAttention('attention');" >[<fmt:message key='label.mail.addbymember'/>]</a>&nbsp;<a href="###" onclick="javascript:selectAddress('bc')" onMousemove="showAttention('attention');" onMouseleave="hideAttention('attention');" >[<fmt:message key='label.mail.addbycontact'/>]</a>
		</td>
  </tr>
  <tr class="bg-summary">
    <td height="20" class="bg-gray"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" />:</td>
    <td>
        <input name="subject" type="text" id="subject" class="input-100per" deaultValue="${v3x:toHTML(bean.subject)}" inputName="<fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" />"
               validate="notNull" value="${v3x:toHTML(bean.subject)}" maxlength="60"/>     
	</td>
	<td></td> 
  </tr>
  <tr class="bg-summary">
	<td height="20" class="bg-gray">
    	<fmt:message key='label.alert.sendleve'/>:
    </td>
    <td>
    	<select name="priority" id="priority">
          <option value="4" selected="selected"><fmt:message key='label.head.priority.4' /></option>
          <option value="3"><fmt:message key='label.head.priority.3' /></option>
          <option value="1"><fmt:message key='label.head.priority.2' /></option>
        </select>&nbsp;
        <label for="reply">
        <input type="checkbox" id="reply" name="reply" value="true">
		<fmt:message key='label.head.autoreply' />
		</label>&nbsp;
        <fmt:message key='label.alert.chooseOutbox'/>:
		<select name="mailIds" id="mailIds">
			<c:forEach var="mbc" items="${mbcList}">
				<c:choose>
					<c:when test="${mbc.email==defaultSentAddr}">
						<option value="<c:out value="${mbc.email}"/>" selected><c:out value="${mbc.email}"/></option>
					</c:when>
					<c:otherwise>
						<option value="<c:out value="${mbc.email}"/>"><c:out value="${mbc.email}"/></option>
					</c:otherwise>
				</c:choose>
			</c:forEach>
		</select>	
  </td>
    <td></td>
  </tr>
  <script type="text/javascript">
  	var priority = ${bean.priority};
  	if(priority == 0){
  		priority = 4;
  	}
  	document.getElementById("priority").value = priority;
  	var checked = false;
  			<c:choose>
				<c:when test="${bean.reply}">checked = true;</c:when>
				<c:otherwise></c:otherwise>
			</c:choose>
  	if(checked)
  	{
  		document.getElementById("reply").checked = true;
  	}
  </script>
  <tr id="attachmentTR" class="bg-summary" style="display:none;">
  	<td></td>
      <td nowrap="nowrap" height="18" class="bg-gray" valign="top"><fmt:message key="common.attachment.label" bundle="${v3xCommonI18N}" />:</td>
      <td valign="top"><div class="div-float">(<span id="attachmentNumberDiv"></span>个)</div>
    	<v3x:fileUpload attachments="${attachments}" canDeleteOriginalAtts="true" originalAttsNeedClone="${originalAttsNeedClone }"/>
    </td>
    <td></td>
  </tr>
  </table>
 </td>
  <tr valign="top">
	<td><v3x:editor htmlId="content" type="HTML" category="<%=ApplicationCategoryEnum.collaboration.getKey()%>" content="${bean.contentText2}" barType="Mail"/></td>
  </tr>
</table>
</form>
<form id="getEmailForm" name="getEmailForm" action="${webmailURL}?method=getEmailForm" method="post" target="hidden_iframe" style="display:none">
<input type="hidden" name="hidden_ids" id="hidden_ids" value=""/>
</form>
<iframe name="hidden_iframe" style="display:none"></iframe>
<script type="text/javascript">
    showCtpLocation('F12_mailcreate');
    document.getElementById("RTEEditorDiv").style.height = document.documentElement.clientHeight - 191 + "px";
</script>
</body>
</html>