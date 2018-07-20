<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/edoc/edocHeader.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="systemswitch.title.lable"/></title>
<html:link renderURL='/govdocOpenController.do' var="govdocOpenController" />

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

</head>
<script type="text/javascript">
showCtpLocation("F07_edocSystem1");
function confirmthisform(){
	if(document.getElementById("allowEditInForm1")!=null && document.getElementById("allowEditInForm1").checked){
		var uNames = document.getElementById("userNames").value;
		if(uNames==""||uNames=="请选择人员"){
			alert("请选择允许修改意见人员");
			return;
		}
	}
    var form = document.all("submitform");
    form.action = "${govdocOpenController}?method=saveEdocOpenSet";
    form.submit();
   
}
function defaultform(){
	document.getElementById("allowUpdateAttachment2").checked="checked";
	document.getElementById("duanxintixing2").checked="checked";
	document.getElementById("handInputEdoc1").checked="checked";
	document.getElementById("selfFlow1").checked="checked";
	document.getElementById("taohongriqi1").checked="checked";
	document.getElementById("allowEditInForm2").checked="checked";
	document.getElementById("edocDocMark2").checked="checked";
	document.getElementById("edocInnerMark2").checked="checked";
	document.getElementById("govdocview1").checked="checked";
	document.getElementById("edocInnerMarkJB2").checked="checked";
	document.getElementById("allowCommentInForm1").checked="checked";
    var form = document.all("submitform");
    form.action = "${govdocOpenController}?method=defaultEdocOpenSet";
    form.submit();
}
var mainURL = "<html:link renderURL='/main.do'/>";
function cancelthisform(){
 document.location.reload();
}
<c:if test="${operateResult}">
alert(v3x.getMessage('edocLang.operateOk'));
</c:if>

function displayCustomType(type){
    //当点击的是 统一设置自定义分类 时，需要显示 <点击设置自定义分类>
    if(type == 'sendCustomType' || type == 'recCustomType'){
        var t = document.getElementById("type_"+type);
        t.style.display = "";//如果设为block,会换行显示
        
    }
}

function cancelCustomType(type){
    if(type == 'sendCustomType' || type == 'recCustomType'){
        var t = document.getElementById("type_"+type);
        t.style.display = "none";
        
    }
}

function openCustomType(type){
    var t;
    if(type == 'sendCustomType'){
        t = 0;
    }else{
        t = 1;
    }

    var winWidth = 450;
    var winHeight = 350;
    var feacture = "dialogWidth:" + winWidth + "px; dialogHeight:" + winHeight + "px;";
    feacture = feacture + "directories:no; localtion:no; menubar:no; status:no;";
    feacture = feacture + "toolbar:no; scroll:no; resizeable:no; help:no";
    
    var url = "${pageContext.request.contextPath}/govdocOpenController.do?method=customerTypes&isAdminSet=true&edocType="+t+"&ndate="+new Date();
    var retObj = window.showModalDialog(url,window ,feacture);
    
}
function callbackt(){
	alert("${ctp:i18n('govdoc.govdocSwitch.alert.success')}");
}

function taohongriqiShow(type){
    var taohongshow=document.getElementById("taohongshow");
    if(type==1){
        taohongshow.innerHTML="示例：二〇一四年一月一日";
    }else{
        taohongshow.innerHTML="示例：2014年1月1日";
    }
}
function setHeight(){
      var mainObj=getA8Top().document.getElementById("main");
      var oHeight = parseInt(mainObj.offsetHeight-120);
      if (oHeight < 0) {
          return;
      }
      var oHtml = document.getElementById('1212');
      if (oHtml) {
          oHtml.style.overflow = 'auto'
          oHtml.style.height = oHeight + "px";
      }
}
function setPeopleFields(elements){
	if(elements){
		var obj1 = getNamesString(elements);
		var obj2 = getIdsString(elements,false);
		document.getElementById("userNames").value = getNamesString(elements);
		document.getElementById("merberIds").value = getIdsString(elements,true);
	}
}
function onRadioClick(enable_e, disable_e1, disable_e2) {
	if(enable_e != ''){
		document.getElementById(enable_e).disabled= false;
	}
	//如果点击了"否",清空选人的值
	if(disable_e1 != ''){
		document.getElementById(disable_e1).value = "请选择人员";	
		document.getElementById("merberIds").value = "";		
		document.getElementById(disable_e1).disabled= true;	
	}
}
var onlyLoginAccount_grantedDepartId = false;
function selectPeopleFun_grantedDepartId1() {
	onlyLoginAccount_grantedDepartId = true;
	selectPeopleFun_grantedDepartId();
}
</script>
<body onload="setHeight()">

<v3x:selectPeople id="grantedDepartId" panels="Department" selectType="Member" jsFunction="setPeopleFields(elements)"  originalElements="${v3x:parseElementsOfTypeAndId(identifyAuth)}"/>

<form name="submitform" method="post" target="post_frame">

<table width="100%" height="100%" align="center" border="0" cellpadding="0" cellspacing="0" class="categorySet">
<tr>
<!-- <td width="15%"></td> -->
<td colspan="3" width="100%" align="center">

<div id="1212" style="padding:20px">  
	<fieldset width="50%">
		<legend><fmt:message key="menu.edoc.edocSwitchSet.label"/></legend>
        
        <c:if test="${v3x:hasPlugin('edoc')==true}">
		<table width="" cellpadding="4" cellspacing="6" >
			
			<c:forEach items="${configItems}" var="configItem">
            	
           	<c:choose>
            <%-- 部门交换默认选择 --%>
            <c:when test="${configItem.configItem=='defualtExchangeDeptType'}">
			<tr id="defualtExchangeDeptTypeTR">
               	<td nowrap>
                   	<div align="right"><fmt:message key="edoc.label.switch.defualtExchangeDeptType"/>:</div>
				</td>
                   <td>
                   	<label for="defualtExchangeDeptType1" style="width: 170px;display: inline-block;">
                        <input name="${configItem.configItem}" id="defualtExchangeDeptType1" type="radio" value="Creater" ${configItem.configValue=='Creater' ? 'checked' : ''}/>
                        <fmt:message key="edoc.label.switch.defualtExchangeDeptType.creater" bundle="${v3xMainI18N}"/>
					</label>
                    <label for="defualtExchangeDeptType2"  style="width: 170px;display: inline-block;">
						<input name="${configItem.configItem}" id="defualtExchangeDeptType2" type="radio" value="Dispatcher" ${configItem.configValue=='Dispatcher' ? 'checked' : ''}/>
                        <fmt:message key="edoc.label.switch.defualtExchangeDeptType.dispatcher" bundle="${v3xMainI18N}"/>
					</label>
				</td>
			</tr>
            </c:when>
                  	
            <c:otherwise>
			<tr>
               	<td nowrap>
                 	<c:choose>
                     	<c:when test="${configItem.configItem == 'allowUpdate' && isG6}">
                         	<div align="right"><fmt:message key="systemswitch.archives.allowUpdate.GOV"/>:</div>
                         </c:when>
						<c:otherwise>
                         	<div align="right"><fmt:message key="systemswitch.archives.${configItem.configItem}"/>:</div>
                         </c:otherwise>
					</c:choose>
				</td>
                <td>
					<c:choose>
                         <%-- 封发时默认交换类型 --%>   
                         <c:when test="${configItem.configItem=='defaultExchangeType'}">
                         <label for="radio1" style="width: 70px;display: inline-block;">
                         	<input name="${configItem.configItem}" id="radio1" type="radio" value="depart" ${configItem.configValue=='depart' ? 'checked' : ''}/>
                            <fmt:message key="org.department.label" bundle="${v3xMainI18N}"/>
						</label>
                        <label for="radio2"  style="width: 70px;display: inline-block;">
                             <input name="${configItem.configItem}" id="radio2" type="radio" value="company" ${configItem.configValue=='company' ? 'checked' : ''}/>
                             <fmt:message key="org.account.label" bundle="${v3xMainI18N}"/>
                        </label>
                     	</c:when>
	                          
						<%-- 2015年8月27日 公文交换环节简化  xiex start   --%>
                    	<%-- 收文操作环节设置   --%>
                        <c:when test="${configItem.configItem=='openRegister'}">
                           	<label for="${configItem.configItem}1"  style="width: 100%;display: inline-block;">
                            	<input name="${configItem.configItem}" id="${configItem.configItem}1" type="radio" value="1" ${configItem.configValue=='1' ? 'checked' : ''}/>
                            	<fmt:message key="systemswitch.archives.openRegister.one"/>
                           	</label>
                           	<br/>
                            <label for="${configItem.configItem}2"  style="width: 100%;display: inline-block;padding-top: 10px;">
                            	<input name="${configItem.configItem}" id="${configItem.configItem}2" type="radio" value="2" ${configItem.configValue=='2' ? 'checked' : ''}/>
                            	<fmt:message key="systemswitch.archives.openRegister.two"/>
                            </label>
                            <br/>
                            <label for="${configItem.configItem}3"  style="width: 100%;display: inline-block;padding-top: 10px;">
                            	<input name="${configItem.configItem}" id="${configItem.configItem}3" type="radio" value="3" ${configItem.configValue=='3' ? 'checked' : ''}/>
                            	<fmt:message key="systemswitch.archives.openRegister.three"/>
                            </label>
                      	</c:when>
	                          	
                       	<%-- 2015年8月27日 公文交换环节简化  xiex end  --%>
                        <%-- 正文套红签发日期显示 --%>
						<c:when test="${configItem.configItem=='taohongriqi'}">
                          	<label for="${configItem.configItem}1"  style="width: 70px;display: inline-block;">
                           		<input name="${configItem.configItem}" id="${configItem.configItem}1" onclick="taohongriqiShow(1);" type="radio" value="yes" ${configItem.configValue=='yes' ? 'checked' : ''}/>
                           		<fmt:message key="systemswitch.archives.taohongriqi.daxie"/>
                          	</label>
                           	<label for="${configItem.configItem}2"  style="width: 70px;display: inline-block;">
                           		<input name="${configItem.configItem}" id="${configItem.configItem}2"  onclick="taohongriqiShow(0);" type="radio" value="no" ${configItem.configValue=='no' ? 'checked' : ''}/>
                           		<fmt:message key="systemswitch.archives.taohongriqi.xiaoxie"/>      
                           	</label>
                           	<span id="taohongshow" style="white-space:nowrap;border: 0px;display:inline-block;width:145px"></span>
                           	<script>
	                           	if(document.getElementById("taohongriqi2").checked){
	                               	taohongriqiShow(0);
	                           	}else{
	                               	taohongriqiShow(1);
	                           	}
                           	</script>
                        </c:when>
	      						
                        <%-- 这个被废弃了 --%>
                        <c:when test="${configItem. configItem == 'timesort'}">
                          	<label for="radio3"  style="width: 70px;display: inline-block;">
                          		<input name="${configItem.configItem}" id="radio3" type="radio" value="no" ${configItem.configValue=='no' ? 'checked' : ''}/>
                              	<fmt:message key="timesort.desc.label" bundle="${v3xMainI18N}"/>
                            </label>
                            <label for="radio4"  style="width: 70px;display: inline-block;">
	                            <input name="${configItem.configItem}" id="radio4" type="radio" value="yes" ${configItem.configValue=='yes' ? 'checked' : ''}/>
	                            <fmt:message key="timesort.asc.label" bundle="${v3xMainI18N}"/>      
                            </label>
                      	</c:when>
	                          
                       	<c:when test="${configItem. configItem == 'showExchangeMenu'}">
                        	<label for="${configItem.configItem}1"  style="width: 70px;display: inline-block;">
                            	<input name="${configItem.configItem}" id="${configItem.configItem}1" type="radio" value="no" ${configItem.configValue=='no' ? 'checked' : ''} onclick="displayCustomType('${configItem.configItem}');"/>
                              	<fmt:message key="systemswitch.yes.lable" bundle="${v3xMainI18N}"/>
                            </label>
                            <label for="${configItem.configItem}2"  style="width: 70px;display: inline-block;">
                            	<input name="${configItem.configItem}" id="${configItem.configItem}2" type="radio" value="yes" ${configItem.configValue=='yes' ? 'checked' : ''} onclick="cancelCustomType('${configItem.configItem}');"/>
                            	<fmt:message key="systemswitch.no.lable" bundle="${v3xMainI18N}"/>
                            </label>
                      	</c:when>
						
						<%-- 新建、处理页面布局  --%>
                      	<c:when test="${configItem. configItem == 'govdocview'}">
                           	<label for="${configItem.configItem}1"  style="width: 70px;display: inline-block;">
                            	<input name="${configItem.configItem}" id="${configItem.configItem}1" type="radio" value="no" ${configItem.configValue=='no' ? 'checked' : ''} onclick="displayCustomType('${configItem.configItem}');"/>
                             	原布局
                           	</label>
                           	<label for="${configItem.configItem}2"  style="width: 70px;display: inline-block;">
                            	<input name="${configItem.configItem}" id="${configItem.configItem}2" type="radio" value="yes" ${configItem.configValue=='yes' ? 'checked' : ''} onclick="cancelCustomType('${configItem.configItem}');"/>
                             	新布局
                           	</label>
                        </c:when>
                        
                        <%-- 允许修改意见  --%>
                      	<c:when test="${configItem.configItem == 'allowEditInForm'}">
                      		<label for="allowEditInForm2"  style="width: 70px;display: inline-block;" >
                           		<input name="allowEditInForm" id="allowEditInForm2" type="radio" value="no" ${configItem.configValue=='no' ? 'checked' : ''} onclick="onRadioClick('','userNames','')"/>
                           		<fmt:message key="systemswitch.no.lable" bundle="${v3xMainI18N}"/>
	                   		</label>
	                   		<label for="allowEditInForm1"  style="display: inline-block;">
                           		<input name="allowEditInForm" id="allowEditInForm1" type="radio" value="yes" ${configItem.configValue=='yes' ? 'checked' : ''} onclick="onRadioClick('userNames','','')"/>
                           		<fmt:message key="systemswitch.yes.lable" bundle="${v3xMainI18N}"/>
                           		<c:choose>
				    				<c:when test="${!empty identifyAuth}"><c:set var="b" value="${v3x:showOrgEntitiesOfTypeAndId(identifyAuth, pageContext)}" /></c:when>
				    				<c:otherwise><c:set var="b" value="请选择人员" /></c:otherwise>
    		               		</c:choose>
                           		<input id="userNames" name="userNames" readonly = "true" ${configItem.configValue=='no' ? 'disabled="disabled"' : ''}   value="${b}" onfocus="if(value =='请选择人员'){value =''}" onblur="if (value ==''){value='请选择人员'}"  onclick ="selectPeopleFun_grantedDepartId1();" />
                           		<input type="hidden" id="merberIds" name="merberIds" value="${identifyAuth}" />	
                        	</label>
                      	</c:when>
	                     <%-- 允许在文单中修改意见  --%>
                      	<c:when test="${configItem.configItem == 'allowCommentInForm'}">
                   			<label for="${configItem.configItem}1"  style="width: 70px;display: inline-block;">
                           	<input name="${configItem.configItem}" id="${configItem.configItem}1" type="radio" value="no" ${configItem.configValue=='no' ? 'checked' : ''} onclick="displayCustomType('${configItem.configItem}');"/>
                             	右侧
                           	</label>
                           	<label for="${configItem.configItem}2"  style="width: 70px;display: inline-block;">
                            	<input name="${configItem.configItem}" id="${configItem.configItem}2" type="radio" value="yes" ${configItem.configValue=='yes' ? 'checked' : ''} onclick="cancelCustomType('${configItem.configItem}');"/>
                             	文单
                           	</label>
                      	</c:when>
	                    
	                    <c:otherwise>
                           	<label for="${configItem.configItem}1"  style="width: 70px;display: inline-block;">
                             	<input name="${configItem.configItem}" id="${configItem.configItem}1" type="radio" value="yes" ${configItem.configValue=='yes' ? 'checked' : ''} onclick="displayCustomType('${configItem.configItem}');"/>
                             	<fmt:message key="systemswitch.yes.lable" bundle="${v3xMainI18N}"/>
                           	</label>
                           	<label for="${configItem.configItem}2"  style="width: 70px;display: inline-block;">
                             	<input name="${configItem.configItem}" id="${configItem.configItem}2" type="radio" value="no" ${configItem.configValue=='no' ? 'checked' : ''} onclick="cancelCustomType('${configItem.configItem}');"/>
                             	<fmt:message key="systemswitch.no.lable" bundle="${v3xMainI18N}"/>
                           	</label>
                            	
                           	<!-- 统一设置自定义分类启用了，那就应该显示右边的 -->
                           	<c:choose>     
                             	<c:when test="${configItem.configValue=='yes' && (configItem.configItem == 'recCustomType' || configItem.configItem == 'sendCustomType' )}">
                               		<c:set var="display" value=""/>
                             	</c:when>
                             	<c:otherwise>
                               		<c:set var="display" value="none"/>
                             	</c:otherwise>  
                           	</c:choose>
                            
                            <span id="type_${configItem.configItem}" onclick="openCustomType('${configItem.configItem}');" style="white-space:nowrap;display:${display};border: 1px solid #CCC;cursor:pointer;">
                            	&lt;<fmt:message key="edoc.custom.type.msg" />&gt;
                            </span>
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
            </c:otherwise>
            </c:choose>
			</c:forEach>
            
            <%--
            <tr>
                     <td>
                        <div align="right"><fmt:message key="systemswitch.archives.allowUpdate.Opinion"/>:</div>                 
                     </td>
	                 <td >                    
                        <label for="opinionchoices2"  style="width: 70px;display: inline-block;" >
                           <input name="opinionchoices" id="opinionchoices2" type="radio" 
                             value="no"  ${authState=='false' ? 'checked' : ''} onclick="onRadioClick('','userNames','')"/>
                           <fmt:message key="systemswitch.no.lable" bundle="${v3xMainI18N}"/>
	                   </label>
	                   <label for="opinionchoices1"  style="display: inline-block;">
                           <input name="opinionchoices" id="opinionchoices1" type="radio"
                             value="yes"  ${authState=='true' ? 'checked' : ''} onclick="onRadioClick('userNames','','')"/>
                           <fmt:message key="systemswitch.yes.lable" bundle="${v3xMainI18N}"/>
                           	<c:choose>
				    			<c:when test="${!empty identifyAuth}"><c:set var="b" value="${v3x:showOrgEntitiesOfTypeAndId(identifyAuth, pageContext)}" /></c:when>
				    			<c:otherwise><c:set var="b" value="请选择人员" /></c:otherwise>
    		               </c:choose>
                           <input id="userNames" name="userNames" readonly = "true" ${authState=='false' ? 'disabled="disabled"' : ''}   value="${b}" onfocus="if(value =='请选择人员'){value =''}" onblur="if (value ==''){value='请选择人员'}"  onclick="selectPeopleFun_grantedDepartId();" />
                           <input type="hidden" id="merberIds" name="merberIds" value="${identifyAuth}" />	
                        </label>
	                 </td>
	               </tr> --%>
          	</table>
          	</c:if>
		</fieldset>  
</div>
</td>
<!-- <td width="15%"></td> -->
</tr>

<tr>
	<td height="42" align="center" class="bg-advance-bottom" colspan="3"> 
    	<input name="Input3" type="button" class="button-default_emphasize" value="<fmt:message key="common.button.ok.label" bundle='${v3xCommonI18N}' />" onclick="confirmthisform()"/>
        <span style="width:10px">&nbsp;</span>
        <input name="Input" type="button" class="button-default-2" title="<fmt:message key="systemswitch.resume.defaultDeploy" bundle="${v3xMainI18N}"/>" value="<fmt:message key="systemswitch.resume.defaultDeploy" bundle="${v3xMainI18N}"/>" onclick="defaultform()"/>
        <span style="width:10px">&nbsp;</span>
        <input name="Input2" type="button"  class="button-default-2" value="<fmt:message key="systemswitch.cancel.lable" bundle="${v3xMainI18N}"/>" onclick="cancelthisform()"/>
	</td>
</tr>
</table>

</form>

<iframe name='post_frame' id="post_frame" style="display:none;"></iframe>

</body>
</html>
