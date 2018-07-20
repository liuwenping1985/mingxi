<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="../common/INC/noCache.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${ctp:i18n("project.toolbar.orderset.label")}</title>
</head>
<body scroll='no'>
<script type="text/javascript">
 $(document).ready(function (){
	 init();
/**修复IE7 select框无法显示兼容性问题 **/
	 if($.browser.msie&&($.browser.version == "7.0")){
		document.getElementById("selectDiv").style.border="solid 2px transparent";
	 }
 });
/**select选择的项上移*/
function up(selObj)
{
  var i;
  var optValue,optTxt,optTitle;
  for(i=0;i<selObj.options.length;i++)
  {
    if(selObj.options[i].selected==true)
	{
	  if(i==0){return;}
	  optTitle=selObj.options[i-1].title;
	  optValue=selObj.options[i-1].value;
	  optTxt=selObj.options[i-1].text;
	  selObj.options[i-1].value=selObj.options[i].value;
	  selObj.options[i-1].text=selObj.options[i].text;
	  selObj.options[i-1].title=selObj.options[i].title;
	  selObj.options[i].value=optValue;
	  selObj.options[i].text=optTxt;
	  selObj.options[i].title=optTitle;
	  selObj.options[i].selected=false;
	  selObj.options[i-1].selected=true;
	}
  }
}
/**select选择的项下移*/
function down(selObj)
{
  var i;
  var optValue,optTxt,optTitle;  
  for(i=selObj.options.length-1;i>=0;i--)
  {
     
    if(selObj.options[i].selected==true)
	{
	  if(i==(selObj.options.length-1)){return;}
	  optValue=selObj.options[i+1].value;
	  optTxt=selObj.options[i+1].text;
	  optTitle=selObj.options[i+1].title;
	  selObj.options[i+1].value=selObj.options[i].value;
	  selObj.options[i+1].text=selObj.options[i].text;
	  selObj.options[i+1].title=selObj.options[i].title;
	  selObj.options[i].value=optValue;
	  selObj.options[i].text=optTxt;
	  selObj.options[i].title=optTitle;
	  selObj.options[i].selected=false;
	  selObj.options[i+1].selected=true;
	}
  }
}
function OK(){
	sendOrder();
	var theForm = document.getElementById("formorder");
	theForm.submit();
	setTimeout(function(){
		transParams.parentWin.projectOrderCallBack();
	},500);
}
function sendOrder(){
	var str="";
	var sel=formorder.projectsObj;
	for(i=0;i<sel.options.length;i++) {
		str+=sel.options[i].value;
		if(i!=sel.options.length-1){str+=";";}
	}
	document.getElementById('projects').value = str;
}
function init(){
	var projectsObj=document.getElementById("projectsObj");
	
	/* var projectList=new Array(jQuery.parseJSON(${projectJsonList})); */
	var test=new Array(${projectJsonList});
	var projectList=test[0];
	for(var i=0;i<projectList.length;i++){
		projectsObj.options[i]=new Option(projectList[i].projectName,projectList[i].id);
		projectsObj.options[i].title=projectList[i].projectName;
	}
}
</script>

<form name="formorder" id="formorder" action='${path}/project/project.do?method=saveOrderProject' target='orderIframe' method='post' onsubmit='sendOrder()'>
<input type='hidden' name='oldProjects' id='oldProjects' value='${oldProjects}' />
<input type='hidden' name="projects" id='projects'>
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%" align="center" class="popupTitleRight">
	<tr>
		<td class="PopupTitle" height="7px" style="font-weight:bold"></td>
	</tr>
	<tr height="100%">
	<td>
		<center>
		  <table width="100%" height="100%" border="0">
            <tr height="1px">
              <td width="4%">&nbsp;</td>
              <td rowspan="5">
              	<div id="selectDiv" style="border:none;">
				  	<select name="projectsObj" id="projectsObj" size="12" multiple style="width: 100%; height:330px; overflow:hidden">
	              	</select>
	            </div>
              </td>
			  <td width="4%">&nbsp;</td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td>
              &nbsp;
			  </td>
            </tr>
            <tr>
              <td></td>
			  <td>
			  	<table  border="0">
				  	<tr>
		              <td>&nbsp;</td>
		              <td>
				  		<span class="sort_up" title="${ctp:i18n("selectPeople.alt.up")}" onClick="up(formorder.projectsObj)"></span>
					  </td>
	            	</tr>
				  	<tr>
		              <td>&nbsp;</td>
		              <td>
				  		&nbsp;
					  </td>
	            	</tr>
				  	<tr>
		              <td>&nbsp;</td>
		              <td>
	              		<span class="sort_down" title='${ctp:i18n("selectPeople.alt.down")}' onClick="down(formorder.projectsObj)"></span>
					  </td>
	            	</tr>
              	 </table>		
			  </td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td>
              &nbsp;
			  </td>
            </tr>
            <tr height="1px">
              <td>&nbsp;</td>
              <td>&nbsp;</td>
            </tr>

          </table>		
		</center>
	  </td>				
	</tr>
</table>
</form>
<iframe id="orderIframe" name="orderIframe" height="0" width="0" scrolling="no" frameborder="1" marginheight="0" marginwidth="0"  style="position: relative; bottom: 10px; display:none;"></iframe>
</body>
</html>
