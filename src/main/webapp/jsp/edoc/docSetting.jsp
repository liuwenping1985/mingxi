<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="edocHeader.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value='/apps_res/v3xmain/js/shortcut.js${v3x:resSuffix()}' />"></script>
<title><fmt:message key='edoc.custom.classification'/></title>
<script type="text/javascript">
if(getA8Top()!=null && typeof(getA8Top().showLocation)!="undefined") {
  getA8Top().showLocation();
}
document.onkeydown = keyDownSearch;
function keyDownSearch(e) {    
    // 兼容FF和IE和Opera    
    var theEvent = e || window.event;    
    var code = theEvent.keyCode || theEvent.which || theEvent.charCode;    
    if (code == 13) {  
    	doSearch();
    } 
 
}  
function setDisplayCol(){
	var target = document.getElementById("menuTargetSelect");
	var opvalue = "";
	var opname = "";
	for(i=0;i<target.options.length;i++){
		opvalue += target.options[i].value+",";
		opname += target.options[i].text+",";
	}
	if(opvalue.lastIndexOf(",") == opvalue.length-1){
		opvalue = opvalue.substring(0,opvalue.length-1);
		opname = opname.substring(0,opname.length-1);
	}
	var initW = transParams.parentWin; //获得父窗口对象
	//设置收文情况
	initW.document.getElementById('displayCol').value=opvalue;
	initW.document.getElementById('displayColName').value=opname;
	commonDialogClose('win123');
}

//按公文元素关键字查询公文元素
function doSearch(){
	var edocStringValue = '${edocStringValue}';
	var edocStringText = '${edocStringText}';
	var target = document.getElementById("menuTargetSelect");
	var source = document.getElementById("menuSourceSelect");
	var searchKeyWord = document.getElementById("edocSettingSearchKeyWord").value;
	var removeText = "";
	//去除已经选择的公文元素
	for(i=0;i<target.options.length;i++){
		edocStringText = edocStringText.replace(target.options[i].text,"");
		edocStringValue = edocStringValue.replace(target.options[i].value,"");
	}
	var edocStringTextArray = edocStringText.split(",");
	var edocStringValueArray = edocStringValue.split(",");
	source.options.length = 0;
	//去除不符合查询条件的公文元素
	if(searchKeyWord != ""){
		for(var i=0;i<edocStringTextArray.length;i++){
			if(edocStringTextArray[i]!="" && edocStringTextArray[i].indexOf(searchKeyWord)>=0){
				 var objOption = new Option(edocStringTextArray[i],edocStringValueArray[i]); 
				 source.options.add(objOption);
			}
	    }
	}else{
		for(var i=0;i<edocStringTextArray.length;i++){
			if(edocStringTextArray[i]!=""){
				 var objOption = new Option(edocStringTextArray[i],edocStringValueArray[i]); 
				 source.options.add(objOption);
			}
	    }
	}
}
//判断选择内容是否超过20个
function addThisItemCheck(){
	var source = document.getElementById("menuSourceSelect");
	var target = document.getElementById("menuTargetSelect");
	var count= 0;
	//备选框中选择了多少个
	for(i=0;i<source.options.length;i++){  
		  if(source.options[i].selected){
		   	count++;
		  }
 	}
 	//已选框中选择了多少个
 	var selectLength = target.options.length ;
 	//如果已选框和备选框选择共超过20个，在已选框中只显示20个
 	if(count+selectLength>20){
 	 	//还可以选择多少个，插入可以选择的个数
 		alert("<fmt:message key='alert_show_morethan20'/>");
 	}else if(count+selectLength<=20){
 		addThisItem('menu');
 	}
}

function onLoad(){
		var initW = transParams.parentWin; //获得父窗口对象
		//获取选择情况
		var displayCol = initW.document.getElementById('displayCol').value;
		var displayColName = initW.document.getElementById('displayColName').value;
		var displayColArray = displayCol.split(",");
		var displayColNameArray = displayColName.split(",");
		var edocStringValue = '${edocStringValue}';
		var edocStringText = '${edocStringText}';
		var target = document.getElementById("menuTargetSelect");
		var source = document.getElementById("menuSourceSelect");
		var edocStringTextArray = edocStringText.split(",");
		var removeText = "";
		//去除已经选择的公文元素
		for(i=0;i<displayColArray.length;i++){
			for(j=0;j<edocStringTextArray.length;j++){
				if(displayColArray[i]!="" && edocStringTextArray[j]==displayColNameArray[i]){
					 var objOption = new Option(displayColNameArray[i],displayColArray[i]); 
					 target.options.add(objOption);
					edocStringText = edocStringText.replace(displayColNameArray[i],"");
					edocStringValue = edocStringValue.replace(displayColArray[i],"");
					break;
				}
			}
		}
		var edocStringValueArray = edocStringValue.split(",");
		edocStringTextArray = edocStringText.split(",");
		source.options.length = 0;
		//去除不符合查询条件的公文元素
		for(var i=0;i<edocStringTextArray.length;i++){
			if(edocStringTextArray[i]!=""){
				 var objOption = new Option(edocStringTextArray[i],edocStringValueArray[i]); 
				 source.options.add(objOption);
			}
	    }
}
</script>
</head>
<body scroll="no" onload="onLoad()">

	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" class="popupTitleRight">
     <tr>
       <td height="20" class="PopupTitle"><fmt:message key='edoc.custom.classification'/>
		</td>
     </tr>
	  <tr>
	    <td width="100%" class="tab-body-bg" align="center">
        <table width="550" align="center" border="0" cellpadding="0" cellspacing="0">
              <tr>
		        <td width="100%" valign="top">
		     	 <table width="100%" height="100%" align="center" border="0" cellpadding="0" cellspacing="0">
		              <tr>
				        <td width="150" height="20" align="left" >
							<table width="255px">
								<tr  style="width:255px;">
									<td style="width:40px; text-align:right;"><b><fmt:message key="shortcut.all.label" bundle="${v3xMainI18N}"/></b></td>
									<td style="width:185px; text-align:right;">
										<input name="edocSettingSearchKeyWord" class="condition" id="edocSettingSearchKeyWord" style="width: 90px;" type="text" value=""/>
									</td>
									<td style="width:25px; text-align:right;"><span class="condition-search-button" onclick="javascript:doSearch()"/></td>
								</tr>
							</table>
				        </td>
				        <td width="15">&nbsp;</td>
				        <td width="150" align="left">
				        	<b>&nbsp;&nbsp;<fmt:message key="selectPeople.selected.label" bundle="${v3xMainI18N}"/></b>
				         </td>
				         <td width="20">&nbsp;</td> 
				     </tr>
		              <tr>
				        <td align="center">
						    <SELECT name="menuSourceSelect" size="17" id="menuSourceSelect" multiple style="width:250px; height: 255px;" ondblclick="addThisItemCheck('menu')">
								<c:forEach items="${leftMap}" var="edoc">
									<option value="${edoc.key}">${edoc.value}</option> 
								</c:forEach>
						    </SELECT>
				        </td>
				        <td align="center">
			         		<img alt="<fmt:message key='selectPeople.alt.select'/>" src="<c:url value='/common/images/arrow_a.gif'/>" width="15"
									height="12" class="cursor-hand" onClick="addThisItemCheck('menu')"><br/><br/>
							<img alt="<fmt:message key='selectPeople.alt.unselect'/>" src="<c:url value='/common/images/arrow_del.gif'/>" width="15"
									height="12" class="cursor-hand" onClick="removeThisItem('menu')">
						</td>
				        <td align="center">
						    <SELECT name="menuTargetSelect" size="17" id="menuTargetSelect" multiple style="width:250px; height: 255px;" ondblclick="removeThisItem('menu')">
								<c:forEach items="${targetMap }" var="edoc">
									<option value="${edoc.key }">${edoc.value }</option> 
								</c:forEach>
						    </SELECT>
						    <input type="hidden" name="menuSpareIds" id="menuSpareIds" value="">
						    <input type="hidden" name="oldMenuSpareIds" id="oldMenuSpareIds" value="">
				        </td>
				        <td>
			         		<p><img alt="<fmt:message key='selectPeople.alt.up'/>" src="<c:url value='/common/images/arrow_u.gif'/>" width="12"
									height="15" class="cursor-hand" onClick="moveUp('menu')"></p><br />
							<p><img alt="<fmt:message key='selectPeople.alt.down'/>" src="<c:url value='/common/images/arrow_d.gif'/>" width="12"
									height="15" class="cursor-hand" onClick="moveDown('menu')"></p>
						</td>
				     </tr>
					</table>
		   </td>
		   </tr>
		   </table>
	    </td>
	  </tr>
	  <tr>
			<td height="35" align="right" class="tab-body-bg bg-advance-bottom">
				<input type="button" onClick="setDisplayCol();" id="submitButton" name="submitButton" value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />" class="button-default_emphasize">&nbsp;&nbsp;
				<input type="button" onClick="commonDialogClose('win123');" value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" class="button-default-2">
			</td>
		</tr>
	</table>
</body>
</html>