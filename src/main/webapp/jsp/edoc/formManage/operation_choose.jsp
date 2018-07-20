<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head>
<%@include file="../edocHeader.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css"
	href="<c:url value="/common/css/default.css${v3x:resSuffix()}" />" />
<link rel="stylesheet" type="text/css"
	href="<c:url value="/common/SelectPeople/css/css.css${v3x:resSuffix()}" />" />
	<script type="text/javascript">
	
	window.transParams = window.transParams||parent.transParams;//新建和修改打开层次不一样
	
	function showNode(boundName,permItem){
		var opts = null;
		var option =null;
		var opt = null;
		var temp_b = null;

		var selected = document.getElementById("selected"); //选择区
		var reserve = document.getElementById("reserve"); //备选区
	
		var arg = transParams.parentWin;
		
		opt = arg.document.getElementById(permItem);
		
		opts = arg.document.getElementById("choosedOperation_"+permItem);   //得到对应处理意见的名称

		if(opts!=null && opts!=""){
				for(var j = 0; j < opts.length; j++) {
					if(opts[j].text=="") {
						continue;
					}
					var temp = opts[j].text.split(",");
					if(opts[j].getAttribute("itemList")){
					    temp_b = opts[j].getAttribute("itemList").split(",");
					}
					if(temp.length > 1) {
						for(var i=0;i<temp.length;i++){
	  	  				option=document.createElement("OPTION");
		     			selected.options.add(option);
		     			if(opts[j].getAttribute("itemList")){
			 				option.value=temp_b[i];
			 			}else{
			 				option.value= opts[j].value;
			 			}
			  			option.text= temp[i];						
						}
					}else if(temp.length == 1 && opts[j].value !="" && opts[j].text != ""){				
	  	  				option=document.createElement("OPTION");
		     			selected.options.add(option);
			 			//option.value=opts[j].value;
			 			if(opts[j].getAttribute("itemList")){
			 				option.value=temp_b[0];
			 			}else{
			 				option.value= opts[j].value;
			 			}
			  			option.text=opts[j].text;
			  		}
				}
			}

		
/* 				for(var j = 0; j < reserve.length; j++) {							
					for(var i=0;i<selected.length;i++){
						if(reserve.options[i]!=null && selected.options[j]!=null && reserve.options[i].value==selected.options[j].value){
							reserve.options.remove(i);
							}
						}
				} */
			
		
				
		
			var operation_opt = arg.document.getElementById("operation");
			var operation_str = arg.document.getElementById("operation_str");  
			if(reserve.options.length!=0){
				reserve.options.length = 0;
				for(var j = 0; j < operation_opt.length; j++){
				  	var re = '('+operation_opt.options[j].value+')';
				  	var r =   operation_str.value.indexOf(re);
				  	if(r == -1){ 							
	  	  				option=document.createElement("OPTION");
		     			reserve.options.add(option);
			 			option.value=operation_opt[j].value;
			  			option.text=operation_opt[j].text;
			  		}  
				}
			}
	}

	
	function moveLtoR(fObj,tObj)
{

  var i;
  var opt;
  for(i=0;i<fObj.options.length;i++)
  {
    if(fObj.options[i].selected==true)
    {
      	  for(var j=0;j<tObj.length;j++){
      	  	if(fObj.options[i].value == tObj.options[j].value){
				break;
      	  		}
		  	}
		  	if(j==tObj.length){
		  	     opt=document.createElement("OPTION");
	     		 tObj.options.add(opt);
		 		 opt.value=fObj.options[i].value;
		  		 opt.text=fObj.options[i].text;  
		  		 
		  		 fObj.remove(i);
		  		 	  i--;
		   }
   	 }
   	 
  }
}
function moveRtoL(fObj,tObj)
{

  var i;
  var opt;
  for(i=0;i<fObj.options.length;i++)
  {
    if(fObj.options[i].selected==true)
    {
    
    	  		  	  opt=document.createElement("OPTION");
	     		 tObj.options.add(opt);
		 		 opt.value=fObj.options[i].value;
		  		 opt.text=fObj.options[i].text;  
    
	  fObj.remove(i);
	  i--;
	  

    }
  }
}

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

	function transformValue(){
		var obj =  document.getElementById("selected");
		var array = new Array();
		for(var i=0;i<obj.options.length;i++){	
			array[i] = new Array();
			array[i][0]= obj.options[i].value;
			array[i][1] = obj.options[i].text;
		}
		
		transParams.parentWin.chooseFlowPermCallback(array);
	    transParams.parentWin.chooseFlowPermWin.close();
	}
	</script>
<title><fmt:message key="edoc.form.flowperm.bound.name" /></title>
</head>
<body onload="showNode('${boundName}','${permItem}');" scroll="no">
<form name="form1">
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle"><font size="3"><strong><fmt:message key="edoc.form.flowperm.bound.name" />
		</td>
	</tr>
	<tr>
		<td style="padding:0 10px;" valign="top">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="40%"><fmt:message key="edoc.form.operation.choose.reserve"/></td>
					<td width="10%">&nbsp;</td>
					<td width="40%"><fmt:message key="edoc.form.operation.choose.selected"/></td>
					<td width="10%">&nbsp;</td>
				</tr>
				<tr valign="top">
					<td id="Area1" class="iframe" width="40%" valign="top">
						<select id="reserve" name="reserve"	ondblclick="moveLtoR(form1.reserve,form1.selected);"	multiple="multiple"  size="22"  style="width:130px;">
						<c:forEach var="flowPerm" items="${flowPermList}">
						<option value="${flowPerm.label}">
						<c:if test="${flowPerm.type == 0}">${flowPerm.name}</c:if>
						<c:if test="${flowPerm.type == 1}">${flowPerm.name}</c:if>
						</option>
						</c:forEach>
						</select>
					</td>
						<td width="10%" valign="middle"  align="center">
							<p><img src="<c:url value="/common/SelectPeople/images/arrow_a.gif"/>"
							alt='<fmt:message key="selectPeople.alt.select" bundle='${v3xMainI18N}'/>' width="24"
							height="24" class="cursor-hand" onClick="moveLtoR(form1.reserve,form1.selected);"></p>
							<p><img src="<c:url value="/common/SelectPeople/images/arrow_del.gif"/>"
							alt='<fmt:message key="selectPeople.alt.unselect" bundle='${v3xMainI18N}'/>' width="24"
							height="24" class="cursor-hand" onClick="moveRtoL(form1.selected,form1.reserve);"></p>
					</td>
					<td id="Area1" class="iframe"  width="40%" valign="top">
						<select id="selected" name="selected" ondblclick="moveRtoL(form1.selected,form1.reserve);"
							multiple="multiple"  size="22"  style="width:130px;" >
						</select>
					</td>
						<td width="10%" valign="middle"  align="center">
						<p><img src="<c:url value="/common/SelectPeople/images/arrow_u.gif"/>"
						alt='<fmt:message key="selectPeople.alt.up" bundle='${v3xMainI18N}'/>'width="24"
						height="24" class="cursor-hand" onClick="up(form1.selected)"></p>
						<p><img src="<c:url value="/common/SelectPeople/images/arrow_d.gif"/>"
						alt='<fmt:message key="selectPeople.alt.down" bundle='${v3xMainI18N}'/>' width="24"
						height="24" class="cursor-hand" onClick="down(form1.selected)"></p>
					</td>
				</tr>
				</table>
	</td>
</tr>
<tr>
	<td height="42px" align="right" class="bg-advance-bottom">
		<input name="Submit" type="button" onClick="transformValue();" class="button-default_emphasize"
			value="<fmt:message key='common.button.ok.label' bundle='${v3xCommonI18N}' />"  />
		<input name="close" type="button" onclick="transParams.parentWin.chooseFlowPermWin.close()" class="button-default-2"
			value="<fmt:message key='common.button.cancel.label' bundle='${v3xCommonI18N}' />" />
	</td>
	</tr>
</table>
</form>
</body>
</html>