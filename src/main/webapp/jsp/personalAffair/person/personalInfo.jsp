<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<%@ include file="../../common/INC/noCache.jsp"%>
<fmt:setBundle basename="com.seeyon.v3x.hr.resource.i18n.HRResources" var="v3xHRI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.localeselector.resources.i18n.LocaleSelectorResources" var="localeI18N"/>
<fmt:setBundle basename="com.seeyon.v3x.organization.resources.i18n.OrganizationResources" var="V3xOrgI18N"/>
<fmt:setBundle basename="com.seeyon.apps.index.resource.i18n.IndexResources" var="indexResources"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/shortcut.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/hr/js/string.extend.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/v3xmain/js/personalInfo.js${v3x:resSuffix()}" />"></script>
<title>Insert title here</title>
<script type="text/javascript">
v3x.loadLanguage("/apps_res/hr/js/i18n");
<%--更新TOP是否播放声音--%>
getA8Top().isEnableMsgSound = ${systemMsgSoundEnable&&(enableMsgSound=='true')};
<%--更新Top消息查看后是否关闭--%>
getA8Top().msgClosedEnable = ${msgClosedEnable!='false'?true:false};
<%--更新TOP人员头像--%>
try {
	if (getA8Top().curUserPhoto) {
		getA8Top().curUserPhoto = "${v3x:avatarImageUrl(CurrentUser.id)}";
	}
	getA8Top().memberImageUrl = "${v3x:avatarImageUrl(CurrentUser.id)}";
	getA8Top().$(".avatar > img").attr("src", getA8Top().memberImageUrl);
} catch(e) {}
function disableSubmitButton() {
	document.getElementById("submitButton").disabled=true;
	return true;
}
function save(){
    document.getElementById("submitButton").click();
}
function cancel(){
    getA8Top().back();
}
//头像设置窗口
function setHead(){
	try{
		var evt = v3x.getEvent();
		var filename = document.getElementById("image1").src;
		getA8Top().setHeadWind = getA8Top().$.dialog({
            title:"<fmt:message key='hr.staffInfo.selfSet.label' bundle='${v3xHRI18N}'/>",
            transParams:{'parentWin':window},
            url: "genericController.do?ViewPage=personalAffair/person/setHead&from=newWindow&filename=" + encodeURIComponent(filename),
            width: 670,
            height: 335,
            isDrag:false
        });
	}catch(e){}
}

/**
 * 设置头像回调函数
 */
function setHeadCollback(returnValue) {
	getA8Top().setHeadWind.close();
	if( returnValue != undefined){
       var returns = returnValue.split(",");
       document.getElementById("filename").value = returns[0];
       document.getElementById("thePicture").innerHTML = "<img class='radius' id='image1' src='" + returns[1] + "' width='104' height='104'>";
    }
}

function smsLoginEnableOnclickHandler(){
  var checked = $("#smsLoginEnable").attr("checked");
  if(checked){
    var telNumber = $("#telNumber").val();
    if(telNumber.replace(/^\s+|\s+$/gm, "") == ""){
      alert(v3x.getMessage("HRLang.systemswitch_telnumberset_prompt"));
      $("#smsLoginEnable").attr("checked", false);
      $("#telNumber").focus();
    } else {
      var requestCaller = new XMLHttpRequestCaller(this, "ajaxPortalManager", "checkTelNumber", false);
      requestCaller.addParameter(1, "String", v3x.getMessage("HRLang.systemswitch_telnumbercheck_prompt"));
      var rs = requestCaller.serviceRequest();
      if(rs == "success"){
        var r = confirm(v3x.getMessage("HRLang.systemswitch_smsloginenable_prompt"));
        if(!r){
          $("#smsLoginEnable").attr("checked", false);
        }
      } else {
        $("#smsLoginEnable").attr("checked", false);
        alert(rs);
      }
    }
  }
}

function telNumberOnBlurHandler(element){
  var oldValue = $("#telNumber").attr("defValue");
  var telNumber = $("#telNumber").val();
  var checked = $("#smsLoginEnable").attr("checked");
  if(checked && $.trim(telNumber) == ""){
    alert(v3x.getMessage("HRLang.systemswitch_telnumbercheck_prompt") + "," + v3x.getMessage("HRLang.systemswitch_telnumberset_prompt"));
    $("#smsLoginEnable").attr("checked", false);
    $("#telNumber").focus();
    return;
  }
  if(isPhoneNumber(element) && maxLength(element)){
    if(checked && oldValue != telNumber){
      var requestCaller = new XMLHttpRequestCaller(this, "ajaxPortalManager", "checkTelNumber", false);
      requestCaller.addParameter(1, "String", v3x.getMessage("HRLang.systemswitch_telnumberModify_prompt"));
      var rs = requestCaller.serviceRequest();
      if(rs == "success"){
        var r = confirm(v3x.getMessage("HRLang.systemswitch_smsloginenable_prompt"));
        if(!r){
          $("#smsLoginEnable").attr("checked", false);
        }
      } else {
        $("#smsLoginEnable").attr("checked", false);
        alert(rs);
      }
    }
    $("#telNumber").attr("defValue", telNumber);
  } else {
    $("#telNumber").focus();
  }
}
</script>
<style type="text/css">
input[type="text"]{height:20px;}
</style>
</head>
<body style="overflow: auto;">
<form method="get" action="${personalAffairURL}" onsubmit="return (checkForm(this) && disableSubmitButton());">
	<input type="hidden" name="method" value="updatePersonalInfo">
	<input type="hidden" name="memberId" id="memberId" value="${member.id}">
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td width="100%" align="center">
        <div id="scrollListDiv">
                   	<table align="center" width="10%" border="0" cellspacing="0" cellpadding="0">
                   	  <tr><td colspan="2" height="30"><br></td></tr>
                   	  <tr>
						<td class="bg-gray" width="25%" nowrap="nowrap" valign="top"><fmt:message key="hr.staffInfo.self.label"
							bundle="${v3xHRI18N}" />:</td>
						<td class="new-column" width="75%" nowrap="nowrap" align="left">
							<table cellpadding="0" cellspacing="0">
								<tr>
									<td>
										<div class="radius" style="border: 1px #CCC solid; width: 104px; height: 104px; text-align: center; background-color: #FFF;">
											<div id="thePicture" style="width: 104px; height: 104px; text-align: center;">
												<img class="radius" id="image1" src="${fileName}" width="104" height="104" />
												<c:set value="${selfImage}" var="selfImage" />
											</div>
										</div>
									</td>
									<td valign="bottom">
										<input type="hidden" id="filename" name="filename" value="${selfImage}">
										&nbsp;&nbsp;
										<!-- 判断是否允许修改--不允许置灰 -->
										<c:if test="${isAllowUpdateAvatarEnable}">
											<input type="button" size="100" value="<fmt:message key="hr.staffInfo.changeself.label" bundle="${v3xHRI18N}" />" onclick="setHead()">
										</c:if>
										<c:if test="${!isAllowUpdateAvatarEnable}">
											<input disabled type="button" size="100" value="<fmt:message key="hr.staffInfo.changeself.label" bundle="${v3xHRI18N}" />">
										</c:if>
									</td>
								</tr>
							</table>
						</td>
					  </tr>
					  <tr><td colspan="2"><br></td></tr>
			          <tr>
						<td class="bg-gray" width="25%" nowrap="nowrap">
							<fmt:message key="hr.staffInfo.name.label" bundle="${v3xHRI18N}"/>:
						</td>
						<td class="new-column" width="75%" nowrap="nowrap">
							<input type="text" id="n" name="n" disabled size="70" value="${member.name}"/>
						</td>
					  </tr>
			          <tr>
						<td class="bg-gray" width="25%" nowrap="nowrap">
							<fmt:message key="hr.staffInfo.memberno.label"  bundle="${v3xHRI18N}"/>:
						</td>
						<td class="new-column" width="75%" nowrap="nowrap">
							<input type="text" id="no" name="no" disabled size="70" value="${member.code}"/>
						</td>
					</tr> 
					
					  <c:choose>
						<c:when test="${v3x:getSysFlagByName('i18n_onlyCN') == true}">
						<input name="primaryLanguange" type="hidden" value="zh_CN">
						</c:when>
						<c:otherwise>
						<tr>
						<td class="bg-gray" width="25%" nowrap="nowrap">
							<fmt:message key="org.member_form.primaryLanguange.label"  bundle="${V3xOrgI18N}"/>:
						</td>
						<td class="new-column" width="75%" nowrap="nowrap">
							<select name="primaryLanguange" class="input-100per">
							    <c:forEach items="${v3x:getAllLocales()}" var="language">
                                    <c:if test="${v3x:getSysFlagByName('sys_isGovVer') != 'true' || language != 'en'}">
							            <option value="${language}" ${orgLocale==language ? "selected" : ""}><fmt:message key="localeselector.locale.${language}" bundle="${localeI18N}"/></option>
                                    </c:if>
							    </c:forEach>
							</select>
						</td>
					  	</tr>	
						</c:otherwise>
					  </c:choose>    	
			          
			          <tr>
                       <td class="bg-gray" nowrap="nowrap">
                           <fmt:message key="hr.staffInfo.workTelephone.label"  bundle="${v3xHRI18N}"/>:
                       </td>
			           <td class="new-column" nowrap="nowrap">
                            <input type="text" id="telephone" name="telephone" maxlength="66" inputName="<fmt:message key="hr.staffInfo.workTelephone.label"  bundle="${v3xHRI18N}"/>" validate="maxLength" size="70" value="${v3x:toHTML(member.officeNum)}" /> 
                       </td> 
                      </tr>
			          <tr>                    
			           <td class="bg-gray" nowrap="nowrap">
			               <fmt:message key="hr.staffInfo.mobileTelephone.label"  bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" nowrap="nowrap">
			               <input type="text" id="telNumber" name="telNumber" onblur="if(v3x.isMSIE){telNumberOnBlurHandler(this);}"  defValue="<c:out value="${v3x:toHTML(member.telNumber)}" escapeXml="true"/>" maxLength="70" size="70" inputName="<fmt:message key="hr.staffInfo.mobileTelephone.label"  bundle="${v3xHRI18N}"/>" validate="isPhoneNumber,maxLength" value="<c:out value="${member.telNumber}" escapeXml="true"/>"/>
                       </td>
                      </tr>

			          <tr>
			           <td class="bg-gray" width="25%" nowrap="nowrap" align="right">
			               <fmt:message key="hr.staffInfo.address.label"  bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" width="75%" nowrap="nowrap">    
			               <input type="text" id="address" name="address" maxlength="70" size="70" value="${v3x:toHTML(contactInfo.address)}"/>
                       </td>
                      </tr>
			          <tr>
			           
			           <td class="bg-gray" nowrap="nowrap">
			               <fmt:message key="hr.staffInfo.postalcode.label"  bundle="${v3xHRI18N}"/>:
			           </td>
			           <td class="new-column" nowrap="nowrap">
			               <input type="text" id="postalcode" name="postalcode" maxlength="70" size="70" value="${v3x:toHTML(contactInfo.postalcode)}" />
                       </td>
                      </tr>
			          <tr>
                       <td class="bg-gray" nowrap="nowrap">
                           <fmt:message key="hr.staffInfo.emailDetail.label"  bundle="${v3xHRI18N}"/>:
                       </td>
			           <td class="new-column" nowrap="nowrap"> 
			                 <input type="text" id="email" name="email" maxlength="70" size="70" value="${v3x:toHTML(member.emailAddress)}" inputName="<fmt:message key='hr.staffInfo.emailDetail.label'  bundle='${v3xHRI18N}'/>" maxSize="40" maxLength="40" validate="validEmail,maxLength"/>  
                       </td>                     
                      </tr>
                      <tr>
                       <td class="bg-gray" nowrap="nowrap">
                           <fmt:message key="hr.staffInfo.communication.label"  bundle="${v3xHRI18N}"/>:
                       </td>
			           <td class="new-column" nowrap="nowrap"> 
			               <input type="text" id="communication" name="communication" maxlength="70" size="70" value="${v3x:toHTML(contactInfo.communication)}" />
                       </td>                     
                      </tr>
                      <tr>
                       <td class="bg-gray" nowrap="nowrap">
                         <fmt:message key="hr.staffInfo.wb.label"  bundle="${v3xHRI18N}"/>:
                       </td>
                       <td class="new-column" nowrap="nowrap"> 
                           <input type="text" id="wb" name="wb" maxlength="70" size="70" value="${v3x:toHTML(member.weibo)}" />
                       </td>                     
                      </tr>
                      <tr>
                       <td class="bg-gray" nowrap="nowrap">
                         <fmt:message key="hr.staffInfo.wx.label"  bundle="${v3xHRI18N}"/>:
                       </td>
                       <td class="new-column" nowrap="nowrap"> 
                           <input type="text" id="wx" name="wx" maxlength="70" size="70" value="${v3x:toHTML(member.weixin)}" />
                       </td>                     
                      </tr>
                      <tr>
                       <td class="bg-gray" nowrap="nowrap">
                           <fmt:message key="hr.staffInfo.website.label"  bundle="${v3xHRI18N}"/>:
                       </td>
			           <td class="new-column" nowrap="nowrap"> 
			               <input type="text" id="website" name="website" maxlength="70" size="70" value="${v3x:toHTML(contactInfo.website)}" inputName="<fmt:message key="hr.staffInfo.website.label"  bundle="${v3xHRI18N}"/>" validate="maxLength" />
                       </td>                     
                      </tr>
                      <tr>
                       <td class="bg-gray" nowrap="nowrap">
                           <fmt:message key="hr.staffInfo.blog.label"  bundle="${v3xHRI18N}"/>:
                       </td>
			           <td class="new-column" nowrap="nowrap"> 
			               <input type="text" id="blog" name="blog" maxlength="70" size="70" inputName="<fmt:message key="hr.staffInfo.blog.label"  bundle="${v3xHRI18N}"/>" validate="maxLength" value="${v3x:toHTML(contactInfo.blog)}" />
                       </td>                     
                      </tr>
                        
                      <tr>
	                       <td class="bg-gray" nowrap="nowrap" valign="top">
	                           <fmt:message key="hr.record.remark.label"  bundle="${v3xHRI18N}"/>:
	                       </td>
				           <td class="new-column" nowrap="nowrap"> 
				              <textarea  maxlength="2000"  rows="5" cols="68" name="comment" id="comment"  inputName="<fmt:message key="hr.record.remark.label"  bundle="${v3xHRI18N}"/>">${v3x:toHTML(member.description)}</textarea>
	                       </td>    	                  
                       </tr>
                      
					   <c:if test="${isCanUseSMS}">       
                       <tr>
                           <td class="bg-gray" nowrap="nowrap"></td>
                           <td class="new-column" nowrap="nowrap">
                               <label for="smsLoginEnable"><input id="smsLoginEnable" name="smsLoginEnable" type="checkbox" value="true" onclick="smsLoginEnableOnclickHandler(this);" ${smsLoginEnable != 'true'? '':'checked'} >
                                    <fmt:message key="systemswitch.smsLoginEnable.lable" bundle="${v3xHRI18N}" />
                               </label>
                           </td>  
                       </tr>
                       </c:if>
                       <tr>
			           <td class="bg-gray" nowrap="nowrap">
			               
			           </td>
			           <td class="new-column" nowrap="nowrap">
			               <label for="msgSoundEnable">
			    				<input id="msgSoundEnable" name="enableMsgSound" type="checkbox" value="true" ${systemMsgSoundEnable&&(enableMsgSound=='true')? 'checked':''} ${systemMsgSoundEnable? '':'disabled'}>
					       		<fmt:message key="systemswitch.MsgHint.lable"/>
					       </label>
                       </td>
                       </tr>
                       <tr>
			           <td class="bg-gray" nowrap="nowrap">
			               
                       <td class="new-column" nowrap="nowrap">
			               <label for="msgClosedEnable">
			    				<input id="msgClosedEnable" name="msgClosedEnable" type="checkbox" value="true" ${msgClosedEnable!='false'? 'checked':''} >
					       		<fmt:message key="systemswitch.MsgAfterLook.lable"/>
					       </label>
                       </td>
                        </tr>
                  <c:if test="${v3x:hasPlugin('index')}">		
		                <tr>
	                       <td class="bg-gray" nowrap="nowrap">
			               </td>
	                       <td class="new-column" nowrap="nowrap"> 
	                       <c:if test="${not empty isShowIndexSummary&&isShowIndexSummary=='false'}">
	                          <c:set value="true" var="setIndexSummary"/>
	                       </c:if>  
				               <label for="isShowIndexSummary">
				    				<input id="isShowIndexSummary" name="isShowIndexSummary" type="checkbox" value="true" ${isShowIndexSummary=='false'? 'checked':''} >
						       		<fmt:message key="index.com.seeyon.v3x.index.showSummary.notshow" bundle="${indexResources }"/>
						      </label>  
	                       	</td>	
                    	  </tr>
                    </c:if>
                    <tr>
			           <td class="bg-gray" nowrap="nowrap">
			               
                       <td class="new-column" nowrap="nowrap">   
			               <label for="extendConfig">
			    				<input id="extendConfig" name="extendConfig" type="checkbox" value="true" ${extendConfig!='false'? 'checked':''} >
					       		<fmt:message key="personalInfo.extend"/>
					       </label>
                       </td>
                        </tr>
                        
                        <tr>
			           <td class="bg-gray" nowrap="nowrap">
			               
                       <td class="new-column" nowrap="nowrap">   
			               <label for="tracksend">
			    				<input id="tracksend" name="tracksend" type="checkbox" value="true" ${tracksend!='false'? 'checked':''} >
					       		<fmt:message key="personalInfo.track.send"/>
					       </label>
                       </td>
                        </tr>
                        
                        <tr>
			           <td class="bg-gray" nowrap="nowrap">
			               
                       <td class="new-column" nowrap="nowrap">   
			               <label for="trackprocess">
			    				<input id="trackprocess" name="trackprocess" type="checkbox" value="true" ${trackprocess=='true'? 'checked':''} >
					       		<fmt:message key="personalInfo.track.process"/>
					       </label>
                       </td>
                        </tr>
		            </table>
	</div>
	</td>
	</tr>
	  <tr style="display:none">
			<td height="42" align="center" class="tab-body-bg bg-advance-bottom">
				<input type="submit" id="submitButton" name="submitButton" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" class="button-default-2">&nbsp;
				<input type="button" onclick="getA8Top().back();" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" class="button-default-2">
			</td>
		</tr>
	</table>
</form>
</body>
</html>
<script>
bindOnresize('scrollListDiv',0,0);
showCtpLocation("F12_perSetting");
</script>