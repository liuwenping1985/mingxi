<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<%@include file="header.jsp" %>
<%@ page import="java.util.*" %>

<html>
<head>
<title>messageManager</title>
<script type="text/javascript">
showCtpLocation("F13_sysStoreRule");
//getA8Top().hiddenNavigationFrameset();
function checkAutoForm(form){
  if(form.oncount.checked){    
    form.count.validate = 'notNull,isInteger';
  }else{
    form.count.validate = '';
    form.count.value=' ';
  }
  if(form.onday.checked){
    form.day.validate = 'notNull,isInteger';
  }else{
    form.day.validate = '';
    form.day.value=' ';
  }
  if(checkForm(form)){
    alert(v3x.getMessage("MainLang.messagemanager_auto_setup_ok"));
    return true;
  }else{
    return false;
  }
}

function checkHandForm(form){
  if(checkForm(form)){
    if(form.startTime.value>=form.endTime.value){
      alert(v3x.getMessage("MainLang.messagemanager_starttime_lessthan_endTime"));
      return false;
    }else{
      return true;
    }
  }else{
    return false;
  }
}
</script>
</head>
<body scroll="no" style="overflow: no">
<div>
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="border_lr">

    <tr>
        <td height="60%">
        <form name="handForm" action="dbscript.do" method="post"  onsubmit="return (checkForm(this))" >
        <div style="padding:20px">  
            <fieldset style="" ><legend>${ctp:i18n('dataseparator.conf.label')}</legend>
                <table width="100%" border="0">
                                      <tr>
                        <td colspan="2">
                            <div align="center">
                                <span class="description-lable">${ctp:i18n('dataseparator.mesg.warning')}</span>
                            </div>
                        </td>
                      </tr>
                      <tr height="20%">                     
                        <td width="30%" nowrap="nowrap" align="right">${ctp:i18n('dataseparator.date.label')}: &nbsp;&nbsp;
                            <input type="text" readonly="true" class="input-50per" name="endTime" onclick="whenstart('${pageContext.request.contextPath}',this,300,200,'date');" inputName="${ctp:i18n('dataseparator.date.label')}" validate="notNull" value="<fmt:formatDate value="${bean.endDate}" type="both" dateStyle="full" pattern="yyyy-MM-dd"/>" />
                        </td>                       
                        <td>
                            <input name="Submit2" type="submit" class="button-default-2" value="${ctp:i18n('dataseparator.createscbtn.label')}">
                        </td>
                      </tr>

                </table>
            </fieldset>
        </div>
        </form>
        </td>
    </tr>
    <tr>
        <td height="100%">&nbsp;</td>
    </tr>
</table>
</div>
</body>
</html>
