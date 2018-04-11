<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>
<%@ include file="../common/INC/noCache.jsp" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="module.sort"/></title>
<style type="text/css">
	.common_button_emphasize{
		color:#fff;
		border:1px solid #42b3e5;
		background:#42b3e5;
	}
	.common_button_emphasize:hover{
		color:#fff;
		border:1px solid #42b3e5;
		background:#62c4ef;
	}
</style>
</head>
<body scroll='no' style="overflow: hidden;">
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
	/**
	var str="";
   	formorder.action="${detailURL}?method=saveOrder";
   	var sel=formorder.projectsObj;
   	for(i=0;i<sel.options.length;i++)
   	{
   		//sel.options[i].selected=true;
   		str+=sel.options[i].value;
   		if(i!=sel.options.length-1){str+=";";}
   	}
   	//alert(str);
   	formorder.projects.value=str;
   	formorder.submit();
   	*/
	 var oSelect = document.getElementById("projectsObj");
	 if(!oSelect) return false;
	 var ids = [];
	 for(var selIndex=0; selIndex<oSelect.options.length; selIndex++)
     {
        ids[selIndex] = oSelect.options[selIndex].value;
     }
	 transParams.parentWin.surveyTypeOrderCollBack(ids);
}

</script>

<form name="formorder" method="post">
<input type=hidden name="projects" value="">

<table border="0" cellpadding="0" cellspacing="0" width="100%"
	height="100%" align="center" class="popupTitleRight">
	
	<tr>
		<td class="PopupTitle" height="20"><fmt:message key='inquiry.type.order.label' /></td>
	</tr>
	<%--
	<tr>
		<td class="categorySet-head" height="23">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td class="categorySet-1" width="4"></td>
					<td class="categorySet-title" width="80" nowrap="nowrap">
					     <fmt:message key='inquiry.type.order.label' />
			         </td>
					<td class="categorySet-2" width="7"></td>
					<td class="categorySet-head-space">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	--%>
	<tr>
	<td  class="categorySet-head2">
		<center>
		  <table width="100%" height="100%" border="0">
            <tr>
              <td width="37%">&nbsp;</td>
              <td rowspan="5">
				  <select id="projectsObj" name="projectsObj" size="12" multiple style="width:250px;height:150px">
					  <c:forEach var="pro" items="${typelist}">
					  	<option value="${pro.id}">${v3x:toHTML(pro.typeName)}</option>
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
						height="24" class="cursor-hand" onClick="up(formorder.projectsObj)"></p>			  </td>
            </tr>
            <tr>
              <td></td>
              <td></td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td>
			  <p><img src="<c:url value="/common/SelectPeople/images/arrow_d.gif"/>"
						alt='<fmt:message key="selectPeople.alt.down" bundle='${v3xMainI18N}'/>' width="24"
						height="24" class="cursor-hand" onClick="down(formorder.projectsObj)"></p>			  </td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
          </table>		
		</center>
	  </td>				
	</tr>
    <tr>
      <td height="42" align="center" class="bg-advance-bottom">
	  <input name="Submit" type="button" onClick="saveOrder();" class="button-default-2 common_button_emphasize" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />"  />&nbsp;
	  <input type="button" name="b2" onclick="getA8Top().surveyTypeOrderWin.close();"	value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2" />
	  </td>
    </tr>
</table>
</form>
</body>
</html>
