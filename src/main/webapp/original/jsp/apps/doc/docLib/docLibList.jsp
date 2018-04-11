<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../docHeader.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='doc.jsp.doclib.sort.label'/></title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/docManager.js${v3x:resSuffix()}" />"></script>
</head>
<script>
var libs = "${isEmpty}";



if(libs == "true" ){

	alert(v3x.getMessage('DocLang.doc_alert_no_oderlibs'));
}
	
</script>
<script type="text/javascript">

//getDetailPageBreak(true);
/**select选择的项上移*/
function up(selObj)
{
  var i;
  var optValue,optTxt;
  for(i=0;i<selObj.options.length;i++)
  {
    if(selObj.options[i].selected==true)
	{
	  if(i==0){return;}
	  optValue=selObj.options[i-1].value;
	  optTxt=selObj.options[i-1].text;
	  selObj.options[i-1].value=selObj.options[i].value;
	  selObj.options[i-1].text=selObj.options[i].text;
	  selObj.options[i].value=optValue;
	  selObj.options[i].text=optTxt;
	  selObj.options[i].selected=false;
	  selObj.options[i-1].selected=true;
	}
  }
}
/**select选择的项下移*/
function down(selObj)
{
  var i;
  var optValue,optTxt;  
  for(i=selObj.options.length-1;i>=0;i--)
  {
     
    if(selObj.options[i].selected==true)
	{
	  if(i==(selObj.options.length-1)){return;}
	  optValue=selObj.options[i+1].value;
	  optTxt=selObj.options[i+1].text;
	  selObj.options[i+1].value=selObj.options[i].value;
	  selObj.options[i+1].text=selObj.options[i].text;
	  selObj.options[i].value=optValue;
	  selObj.options[i].text=optTxt;
	  selObj.options[i].selected=false;
	  selObj.options[i+1].selected=true;
	}
  }
}

//保存排序结果
function saveOrder(){
window.close();
}

</script>
<body scroll="no">
<form name="mainForm" id="mainForm" method="post">

<table border="0" cellpadding="0" cellspacing="0" width="100%"
	height="100%" align="center" class="popupTitleRight">
	
	<tr>
		<td class="PopupTitle" height="20"><fmt:message key='common.toolbar.order.label' bundle='${v3xCommonI18N}'/></td>
	</tr>
	<tr>
	<td  class="categorySet-head2">
		<center>
		  <table width="100%" height="100%" border="0">
            <tr>
              <td width="37%">&nbsp;</td>
              <td rowspan="5">
				  <select name="projectsObj" size="12" multiple style="width:250px" id="projectsObj">
					  <c:forEach var="docLibs" items="${docLibs}">
					  	<option value="${docLibs.id}">${docLibs.name}</option>
					  </c:forEach>
	              </select>
              </td>
			  <td width="37%">&nbsp;</td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td>
			  <p><img src="<c:url value="/common/SelectPeople/images/arrow_u.gif"/>"
						alt='<fmt:message key="selectPeople.alt.up" bundle='${v3xMainI18N}'/>'width="24"
						height="24" class="cursor-hand" onClick="up(mainForm.projectsObj)"></p>			  </td>
            </tr>
            <tr>
              <td colspan="1" rowspan="1">&nbsp;</td>
              <td colspan="1" rowspan="1">&nbsp;</td>
            </tr>
            <tr>
              <td colspan="1" rowspan="1">&nbsp;</td>
              <td colspan="1" rowspan="1">
			  <p><img src="<c:url value="/common/SelectPeople/images/arrow_d.gif"/>"
						alt='<fmt:message key="selectPeople.alt.down" bundle='${v3xMainI18N}'/>' width="24"
						height="24" class="cursor-hand" onClick="down(mainForm.projectsObj)"></p>			  </td>
            </tr>
            <tr>
              <td colspan="1" rowspan="1">&nbsp;</td>
              <td colspan="1" rowspan="1">&nbsp;</td>
            </tr>
          </table>		
		</center>
	  </td>				
	</tr>
    <tr>
      <td align="center" class="bg-advance-bottom">
        <input name="Submit" type="button" onClick="saveOrderRep();" class="button-default_emphasize" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />"  />&nbsp;
        <input type="button" name="b2" onclick="window.close();"  value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2" />
      </td>
    </tr>
</table>
</form>

<iframe name="empty" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0">
</iframe>

</body>
</html>