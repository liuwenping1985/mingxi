<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title><fmt:message key="link.toolbar.orderset.label"/></title>
<script type="text/javascript" src="${path}/ajax.do?managerName=linkSystemManager"></script>
<script type="text/javascript">
function OK(json) {
    return $("#linkObj").find("option");
}
/**select选择的项上移*/
function up()
{
  var selObj = $("#linkObj").find("option");
  var i;
  var optValue,optTxt;
  for(i=0;i<selObj.size();i++)
  {
    if(selObj[i].selected==true)
    {
      if(i==0){return;}
      optValue=selObj[i-1].value;
      optTxt=selObj[i-1].text;
      selObj[i-1].value=selObj[i].value;
      selObj[i-1].text=selObj[i].text;
      selObj[i].value=optValue;
      selObj[i].text=optTxt;
      selObj[i].selected=false;
      selObj[i-1].selected=true;
    }
  }
}
/**select选择的项下移*/
function down()
{
  var selObj = $("#linkObj").find("option");
  var i;
  var optValue,optTxt;  
  for(i=selObj.size()-1;i>=0;i--)
  {
    if(selObj[i].selected==true)
    {
      if(i==(selObj.size()-1)){return;}
      optValue=selObj[i+1].value;
      optTxt=selObj[i+1].text;
      selObj[i+1].value=selObj[i].value;
      selObj[i+1].text=selObj[i].text;
      selObj[i].value=optValue;
      selObj[i].text=optTxt;
      selObj[i].selected=false;
      selObj[i+1].selected=true;
    }
  }
}
</script>
</head>
<body scroll='no' style="background:#fafafa;">
<input type='hidden' name='oldLinks' id='oldLinks' value='${oldLinks}' />
<input type='hidden' name="linkSystems" id='linkSystems'>
	
	   <table border="0">
	       <tr>
	       <td width="5">&nbsp;</td>
	       <td>
                  <select name="linkObj" id="linkObj" size="12" multiple style="width:210px;height: 190px">
                      <c:forEach var="link" items="${linkSystemList}">            
                      <option title="${link.lname}" value="<c:out value="${link.id}" />"><c:out value="${link.lname}" /></option>
                      </c:forEach>
                  </select>
	       </td>
	       <td width="20">
	          <table  border="0">
		          <tr>
		              <td><p><span class="ico16 sort_up" onClick="up()"></span></p></td>
		          </tr>
		          <tr>
		              <td>&nbsp;</td>
		           </tr>
		           <tr>
		              <td><p><span class="ico16 sort_down" onClick="down()"></span></p></td>
		          </tr>
	          </table> 
	       </td>
	       </tr>
	   </table>
	
	
	
	<!--  
		<center>
		  <table width="100%" height="100%" border="0">
            <tr>
              <td width="5">&nbsp;</td>
              <td rowspan="5">
				  <select name="linkObj" id="linkObj" size="12" multiple style="width:100%">
					  <c:forEach var="link" items="${linkSystemList}">			  
					  <option value="<c:out value="${link.id}" />"><c:out value="${link.lname}" /></option>
					  </c:forEach>
	              </select>
              </td>
			  <td width="15">&nbsp;</td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td><p><span class="ico16 sort_up" onClick="up()"></span></p></td>
            </tr>
            <tr>
              <td></td>
			  <td></td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td><p><span class="ico16 sort_down" onClick="down()"></span></p></td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
            </tr>

          </table>		
		</center>-->

</body>
</html>
