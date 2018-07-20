<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%
response.setDateHeader("Expires",-1);
response.setHeader("Cache-Control","no-store");
response.setHeader("Pragrma","no-cache");
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>U8账号绑定</title>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<meta HTTP-EQUIV="Cache-Control" CONTENT="no-store"> 
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    </head>
    <script type="text/javascript">
    //getCTPTop().hiddenNavigationFrameset(813);
    function enabledClick()
    {
      var ids=document.getElementsByName("exLoginName");
      var y=0;
        for(var i=0;i<ids.length;i++){
            var idCheckBox=ids[i];
            if(idCheckBox.checked){
              document.getElementById("submit1").disabled = false;
              y++;
              break;
            }
        }
    if(y==0)
    {
     document.getElementById("submit1").disabled = true;
    }
    }
    function submitForm()
    {
    var form1=document.getElementById("postForm1");    
    if(checkForm(form1))
    {
       if(form1.u8UserLoginName.value=="")
           {
           return;
           }
       document.getElementById("buttonSub").disabled=true;
       var userLoginN=document.getElementById("u8UserLoginName").value.trim();
       document.getElementById("u8UserLoginName").value=userLoginN;
       form1.action = "u8BusinessUserMapper.do?method=userBindingMapper";
       form1.submit();
    }
    }
    function doEnter(){
      if(event.keyCode == 13){
          submitForm();
      }
  }
    </script>
    <body  scroll="no" style="overflow: auto">
            <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
                <tr class="page2-header-line">
                    <td width="100%" height="41" valign="top" class="page-list-border-LRD">
                         <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
                            <tr class="page2-header-line">
                                    <td width="45"><div class="notepager"></div></td>
                                    <td id="notepagerTitle1" class="page2-header-bg">&nbsp;${ctp:i18n('u8business.user.mapper')}</td>                               
                                </tr>
                         </table>
                    </td>
                </tr>
                <tr>
                    <td  class="padding5" width="100%" align="center" valign="top">
                        <br>
                        <div style="width: 60%;">
                            <br />
                            <table width="100%" border="0" cellspacing="0" cellpadding="0"
                                align="center">
                            <c:if test="${List!=null}">
                                    <tr>
                                        <td class="bg-gray" width="20%" nowrap="nowrap">
                                            <fieldset>
                                                <legend>
                                                    ${ctp:i18n('u8business.user.mapper')}
                                                </legend>
                                                <table width="100%" border="0" cellspacing="0"
                                                    cellpadding="0" align="center">
                                                    <form id="postForm" method="post" action="u8BusinessUserMapper.do?method=deleteBindingMapper" onsubmit="return confirm('${ctp:i18n('u8business.user.confirm.delete')}')" target="addConfigFrame">
                                                    <tr>
                                                        <td width="20%" nowrap="nowrap" align="center">
                                                            <c:forEach var="mapper" items="${List}"
                                                                varStatus="status">
                                                                <input type="checkbox" name="exLoginName"
                                                                    value="<c:out value='${v3x:toHTML(mapper.exLoginName)}'/>" onclick="enabledClick()" />${v3x:toHTML(mapper.exLoginName)}
                                                                   <c:if test="${status.count%4==0&&status.count!=0}">
                                                                    <br>
                                                                </c:if>
                                                            </c:forEach>
                                                        </td>
                                                        </tr>
                                                    <tr>
                                                        <td width="20%" nowrap="nowrap" align="center">
                                                            <input disabled type="submit"
                                                                value="${ctp:i18n('common.button.delete.label')}"
                                                                class="common_button"  id="submit1">
                                                        </td>
                                                    </tr>
                                                    </form>
                                                </table>
                                        </td>
                                    </tr>
                                </c:if>
                                <tr>
                                    <td>
                                        <br>
                                        <br>
                                        <br>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="new-column" width="100%">
                                        <fieldset>
                                            <legend>
                                                ${ctp:i18n('u8business.user.newmapper')}
                                            </legend>
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0"
                                                align="center">
                                                <form id="postForm1" method="post" action="" onkeypress="doEnter()" target="addConfigFrame">
                                                <tr>
                                                    <td  width="45%" nowrap="nowrap" align="center">
                                                        ${ctp:i18n('u8business.user.account')}:
                                                        <input    value="" type="text" name="u8UserLoginName" id="u8UserLoginName" validate="notNull" inputName="${ctp:i18n('u8business.user.account')}" />
														
                                                    </td>
													<td  width="45%" nowrap="nowrap" >
                                                        ${ctp:i18n('u8business.user.pwd')}:                                                 
														<input   value=""  type="password" name="userPassword"  inputName="${ctp:i18n('u8business.user.pwd')}"/>                                                               
                                                    </td>
													
                                                    <td class="bg-gray" width="10%" nowrap="nowrap">
                                                        <input type="button"
                                                            value="${ctp:i18n('common.button.ok.label')}"
                                                            class="common_button common_button_gray margin_r_10" onclick="submitForm()" id="buttonSub"/>
                                                    </td>
                                                    
                                                </tr>
                                                </form>
                                            </table>
                                        </fieldset>
                                    </td>
                                </tr>
                            </table>
                            <br />
                        </div>

                    </td>
                </tr>
            </table>
            <iframe id="addConfigFrame" name="addConfigFrame" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
    </body>
</html>