<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="edocHeader.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="systemswitch.title.lable"/></title>
<html:link renderURL='/edocOpenController.do' var="edocOpenController" />

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

</head>
<script type="text/javascript">
showCtpLocation("F07_edocSystem1");
function confirmthisform(){
    //当收文登记开关由开启状态 变为关闭状态时，需要通过ajax方式查询该单位下是否有待登记数据
    if("${isG6Ver}" == "true"){
        var notOpen = document.getElementById("openRegister2");
        if("${register_switch_init_value}" == "yes" && notOpen.checked ){
            var requestCaller = new XMLHttpRequestCaller(this, "edocExchangeManager", "isHaveWaitRegisters", false);
            var rs = requestCaller.serviceRequest();
            if(rs == "true"){
                alert(edocLang.not_close_register);
                document.getElementById("openRegister1").checked = "checked";
                return;
            }
        }
    }
    
    var form = document.all("submitform");
    form.action = "${edocOpenController}?method=saveEdocOpenSet";
    form.submit();
}
function defaultform(){
    var form = document.all("submitform");
    form.action = "${edocOpenController}?method=defaultEdocOpenSet";
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
    
    var url = "${pageContext.request.contextPath}/edocController.do?method=customerTypes&isAdminSet=true&edocType="+t+"&ndate="+new Date();
    var retObj = window.showModalDialog(url,window ,feacture);
    
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

</script>
<body onload="setHeight()">
  <form name="submitform" method="post">
    <table width="100%" height="100%" align="center" border="0" cellpadding="0" cellspacing="0" class="categorySet">
      <tr>
        <td width="15%"></td>
        <td width="70%" align="center">
          <div>
            <div id="1212" style="padding:20px">  
              <fieldset width="50%">
                <legend><fmt:message key="menu.edoc.edocSwitchSet.label"/></legend>
                <table width="" cellpadding="4" cellspacing="6" >
                  <c:forEach items="${configItems}" var="configItem">
                    <c:if test="${v3x:hasPlugin('edoc')==true}">  
                      
                      <c:choose>
                        <c:when test="${configItem.configItem=='defualtExchangeDeptType'}">
                          <%-- 部门交换默认选择 --%>
	                      <tr id="defualtExchangeDeptTypeTR">
	                        <td   nowrap>
	                          <div align="right"><fmt:message key="edoc.label.switch.defualtExchangeDeptType"/>:</div>
	                        </td>
	                        <td >
	                          <label for="defualtExchangeDeptType1" style="width: 160px;display: inline-block;">
	                            <input name="${configItem.configItem}" id="defualtExchangeDeptType1" type="radio" 
	                              value="Creater" ${configItem.configValue=='Creater' ? 'checked' : ''}/>
	                            <fmt:message key="edoc.label.switch.defualtExchangeDeptType.creater" bundle="${v3xMainI18N}"/>
	                          </label>
	                          <label for="defualtExchangeDeptType2"  style="width: 160px;display: inline-block;">
	                            <input name="${configItem.configItem}" id="defualtExchangeDeptType2" type="radio" 
	                              value="Dispatcher" ${configItem.configValue=='Dispatcher' ? 'checked' : ''}/>
	                            <fmt:message key="edoc.label.switch.defualtExchangeDeptType.dispatcher" bundle="${v3xMainI18N}"/>
	                          </label>
	                        </td>
	                      </tr>
                        </c:when>
                        <c:otherwise>
	                      <tr>
	                        <td   nowrap>
	                           <c:choose>
	                             <c:when test="${configItem.configItem == 'allowUpdate' && isG6}">
	                                 <div align="right"><fmt:message key="systemswitch.archives.allowUpdate.GOV"/>:</div>
	                             </c:when>
	                             <c:otherwise>
	                                 <div align="right"><fmt:message key="systemswitch.archives.${configItem.configItem}"/>:</div>
	                             </c:otherwise>
	                           </c:choose>
	                        </td>
	                        <td >
	                        <c:choose>  
	                          <%-- 封发时默认交换类型 --%>   
	                          <c:when test="${configItem.configItem=='defaultExchangeType'}">
	                            <label for="radio1" style="width: 60px;display: inline-block;">
	                              <input name="${configItem.configItem}" id="radio1" type="radio" value="depart" ${configItem.configValue=='depart' ? 'checked' : ''}/>
	                              <fmt:message key="org.department.label" bundle="${v3xMainI18N}"/>
	                            </label>
	                            <label for="radio2"  style="width: 60px;display: inline-block;">
	                              <input name="${configItem.configItem}" id="radio2" type="radio" value="company" ${configItem.configValue=='company' ? 'checked' : ''}/>
	                              <fmt:message key="org.account.label" bundle="${v3xMainI18N}"/>
	                            </label>
	                          </c:when>
	                          
	                          <%-- 正文套红签发日期显示 --%>
	                          <c:when test="${configItem.configItem=='taohongriqi'}">
	                            <label for="${configItem.configItem}1"  style="width: 60px;display: inline-block;">
	                              <input name="${configItem.configItem}" id="${configItem.configItem}1" onclick="taohongriqiShow(1);" type="radio" value="yes" ${configItem.configValue=='yes' ? 'checked' : ''}/>
	                              <fmt:message key="systemswitch.archives.taohongriqi.daxie"/>
	                            </label>
	                            <label for="${configItem.configItem}2"  style="width: 60px;display: inline-block;">
	                              <input name="${configItem.configItem}" id="${configItem.configItem}2"  onclick="taohongriqiShow(0);" type="radio" value="no" ${configItem.configValue=='no' ? 'checked' : ''}/>
	                              <fmt:message key="systemswitch.archives.taohongriqi.xiaoxie"/>      
	                            </label>
	                            <span id="taohongshow" style="white-space:nowrap;border: 0px;"></span>
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
	                            <label for="radio3"  style="width: 60px;display: inline-block;">
	                              <input name="${configItem.configItem}" id="radio3" type="radio" value="no" ${configItem.configValue=='no' ? 'checked' : ''}/>
	                              <fmt:message key="timesort.desc.label" bundle="${v3xMainI18N}"/>
	                            </label>
	                            <label for="radio4"  style="width: 60px;display: inline-block;">
	                              <input name="${configItem.configItem}" id="radio4" type="radio" value="yes" ${configItem.configValue=='yes' ? 'checked' : ''}/>
	                              <fmt:message key="timesort.asc.label" bundle="${v3xMainI18N}"/>      
	                            </label>
	                          </c:when>
	      
	                          <c:otherwise>
	                            <label for="${configItem.configItem}1"  style="width: 60px;display: inline-block;">
	                              <input name="${configItem.configItem}" id="${configItem.configItem}1" type="radio"
	                                value="yes" ${configItem.configValue=='yes' ? 'checked' : ''} onclick="displayCustomType('${configItem.configItem}');"/>
	                              <fmt:message key="systemswitch.yes.lable" bundle="${v3xMainI18N}"/>
	                            </label>
	                            <label for="${configItem.configItem}2"  style="width: 60px;display: inline-block;">
	                              <input name="${configItem.configItem}" id="${configItem.configItem}2" type="radio" 
	                                value="no" ${configItem.configValue=='no' ? 'checked' : ''} onclick="cancelCustomType('${configItem.configItem}');"/>
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
                    </c:if>
                  </c:forEach>
                </table>
              </fieldset>  
            </div>
          </div>
        </td>
        <td width="15%"></td>
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
</body>
</html>
