function selectall(obj,id){
	$("#"+id+" input[@type=checkbox]").each(function(){
		if(obj.checked){
			$(this).attr("checked","true");
		}else{
			$(this).attr("checked","");
		}
	});
}
 
function setStatContent(){
	var sign = "、";
	var statContentName = "";
	var statContentId = "";
	var sendNodeCode = "";
	var recNodeCode = "";
	var contentTypeId = document.getElementById("contentTypeId").value;
	
	

	//流程节点
	if(contentTypeId==2){
		$("#statContent #selectallsend input[@type=checkbox]").each(function(){
			if(this.checked){
				var statContentStr = $(this).val();
				var stat = statContentStr.split("_");
				statContentId += stat[0]+"=";
				//GOV-4999 公文统计-收发查询，统计维度选择组织，统计列表中点击组织名称报红三角，详见附件！
				sendNodeCode += stat[0]+"=";
				statContentName += $(this).parent().find("label").text()+sign;
			}
		});
		$("#statContent #selectallrec input[@type=checkbox]").each(function(){
			if(this.checked){
				var statContentStr = $(this).val();
				var stat = statContentStr.split("_");
				statContentId += stat[0]+"=";
				//GOV-4999 公文统计-收发查询，统计维度选择组织，统计列表中点击组织名称报红三角，详见附件！
				recNodeCode += stat[0]+"=";
				statContentName += $(this).parent().find("label").text()+sign;
			}
		});
		if(sendNodeCode.lastIndexOf("=") == sendNodeCode.length-1){
			sendNodeCode = sendNodeCode.substring(0,sendNodeCode.length-1);
		}
		if(recNodeCode.lastIndexOf("=") == recNodeCode.length-1){
			recNodeCode = recNodeCode.substring(0,recNodeCode.length-1);
		}
	}
	//收文情况
	else if(contentTypeId==1 ){
		$("#statContent input[@type=checkbox]").each(function(){
			if(this.checked){
				var statContentStr = $(this).val();
				statContentName += statContentStr.substring(statContentStr.indexOf("_")+1)+sign;
				statContentId += statContentStr.substring(0,statContentStr.indexOf("_"))+"=";
			}
		});
	}
	else if(contentTypeId==3){
		$("#statContent input[@type=checkbox]").each(function(){
			if(this.checked){
				var statContentStr = $(this).val();
				statContentName += $(this).parent().find("label").text()+sign;
				//statContentName += statContentStr.substring(statContentStr.indexOf("_")+1)+sign;
				statContentId += statContentStr.substring(0,statContentStr.indexOf("_"))+"=";
			}
		});
	}
	if(statContentName.lastIndexOf(sign) == statContentName.length-1){
		statContentName = statContentName.substring(0,statContentName.length-1);
		statContentId = statContentId.substring(0,statContentId.length-1);
	}
	
	var initW = transParams.parentWin; //获得父窗口对象
	//设置收文情况
	if(contentTypeId==1){
		initW.document.getElementById('sendContent').value=statContentName;
		initW.document.getElementById('sendContentId').value=statContentId;
	}
	//设置流程节点
	else if(contentTypeId==2){
		initW.document.getElementById('workflowNode').value=statContentName;
		initW.document.getElementById('workflowNodeId').value=statContentId;
		initW.document.getElementById('sendNodeCode').value=sendNodeCode;
		initW.document.getElementById('recNodeCode').value=recNodeCode;
	}
	//设置收文情况
	else if(contentTypeId==3){
		initW.document.getElementById('processSituation').value=statContentName;
		initW.document.getElementById('processSituationId').value=statContentId;
	}
	commonDialogClose('win123');
}


//上次勾选的回显
$(document).ready(function() {
	var sc = new Array();
	
	if(document.getElementById("scIdValue")){
		var scIdValue = document.getElementById("scIdValue").value;
		
		if(scIdValue.indexOf("=")>-1){
			sc = scIdValue.split("=");
		}else if(scIdValue != ""){
			sc.push(scIdValue);
		}
		if(sc.length!=0){
			$("#statContent input[@type=checkbox]").each(function(){
				var scid = this.value;
				for(i=0;i<sc.length;i++){
					if(scid == sc[i])$(this).attr("checked","true");
				}
			});
		}
	}
	
});



function changeDimension(obj){
	var timeType = "";
	var types = document.getElementsByName("timeType");
	for(i=0;i<types.length;i++){  
		if(types[i].checked){
			timeType = types[i].value;
		}
	}
	var orgtitle = document.getElementById("orgtitle").value;
	//还要清空组织
	document.getElementById("selectPeople0_text").value = "";
	document.getElementById("selectPeople2_text").value = "";
	
	document.getElementById("organizationId").value="";
	//改变为时间维度
	if(obj.value==1){
		
		//document.getElementById("organizationName").onclick=selectPeopleFun_grantedDepartId;
		//var obj1 = document.getElementById("organizationName");
		//obj1.setAttribute("onclick", "selectPeopleFun_grantedDepartId()");
		document.getElementById("selectPeople0").style.display = "";
		document.getElementById("selectPeople2").style.display = "none";
		//年
		if(timeType == 1){
			document.getElementById("yearselect").style.display = "";
			document.getElementById("yearselect-right").style.display = "";
		}
		//季度
		else if(timeType == 2){
			document.getElementById("seasonselect").style.display = "";
			document.getElementById("seasonselect-right").style.display = "";
		}
		//月
		else if(timeType == 3){
			document.getElementById("monthselect").style.display = "";
			document.getElementById("monthselect-right").style.display = "";
		}
		//日
		else if(timeType == 4){
			document.getElementById("dayselect").style.display = "";
			document.getElementById("dayselect-right").style.display = "";
		}
	}
	//改变为组织维度
	else if(obj.value==2){
		//var obj1 = document.getElementById("organizationName");
		document.getElementById("selectPeople0").style.display = "none";
		document.getElementById("selectPeople2").style.display = "";
		//obj1.setAttribute("onclick", "selectPeopleFun_grantedDepartId2()");
		//年
		if(timeType == 1){
			document.getElementById("yearselect").style.display = "";
			//document.getElementById("yearselect-right").style.display = "none";
		}
		//季度
		else if(timeType == 2){
			document.getElementById("seasonselect").style.display = "";
			//document.getElementById("seasonselect-right").style.display = "none";
		}
		//月
		else if(timeType == 3){
			document.getElementById("monthselect").style.display = "";
			//document.getElementById("monthselect-right").style.display = "none";
		}
		//日
		else if(timeType == 4){
			document.getElementById("dayselect").style.display = "";
			//document.getElementById("dayselect-right").style.display = "none";
		}
	}
}


function timeTypeChange(obj){
	var dimensionType = "";
	var types = document.getElementsByName("statisticsDimension");
	for(i=0;i<types.length;i++){  
		if(types[i].checked){
			dimensionType = types[i].value;
			break;
		}
	}
	if(obj.id == 'quarter'){
		document.getElementById("seasonselect").style.display="block";
		document.getElementById("yearselect").style.display="none";
		document.getElementById("monthselect").style.display="none";
		document.getElementById("dayselect").style.display="none";
		if(dimensionType == 2){
			//document.getElementById("seasonselect-right").style.display="none";
		}
	}
	if(obj.id == 'year'){
		document.getElementById("yearselect").style.display="block";
		document.getElementById("seasonselect").style.display="none";
		document.getElementById("monthselect").style.display="none";
		document.getElementById("dayselect").style.display="none";
		if(dimensionType == 2){
			//document.getElementById("yearselect-right").style.display="none";
		}
	}
	if(obj.id == 'month'){
		document.getElementById("monthselect").style.display="block";
		document.getElementById("yearselect").style.display="none";
		document.getElementById("seasonselect").style.display="none";
		document.getElementById("dayselect").style.display="none";
		if(dimensionType == 2){
			//document.getElementById("monthselect-right").style.display="none";
		}
	}
	if(obj.id == 'day'){
		document.getElementById("dayselect").style.display="block";
		document.getElementById("monthselect").style.display="none";
		document.getElementById("yearselect").style.display="none";
		document.getElementById("seasonselect").style.display="none";
		if(dimensionType == 2){
			//document.getElementById("dayselect-right").style.display="none";
		}
	}
}

function openContentWindow(contentTypeId){
	var winWidth = 300;
	var winHeight = contentTypeId == 2 ? 520 : 300;
	var feacture = "dialogWidth:" + winWidth + "px; dialogHeight:" + winHeight + "px;";
	feacture = feacture + "directories:no; localtion:no; menubar:no; status:no;";
	feacture = feacture + "toolbar:no; scroll:no; resizeable:no; help:no";

	var statContentId = "";
	var titleV = "";
	if(contentTypeId == 1){
		var statContentId = document.getElementById("sendContentId").value;
		titleV = "公文种类";
	}else if(contentTypeId == 2){
		var statContentId = document.getElementById("workflowNodeId").value;
		titleV = "选择流程节点";
	}else if(contentTypeId == 3){
		var statContentId = document.getElementById("processSituationId").value;
		titleV = "选择办理情况";
	}
	var url = "edocStat.do?method=openStatContent&contentTypeId="+contentTypeId+"&statContentId="+statContentId
					+"&ndate="+new Date();
	getA8Top().win123 = getA8Top().$.dialog({
		title:titleV,
		transParams:{'parentWin':window},
	    url   : url,
	    width : winWidth,
	    height  : winHeight,
	    resizable : "no"
	  });
}

//定义选人界面回调函数 
function doAuth4Category(elements){ 
  if(elements){ 
    document.getElementById("auth").value = getIdsString(elements); 
    document.getElementById("authStr").value = getNamesString(elements); 
  } 
}


function setPeopleFields(elements){
	if(elements){
		var obj1 = getNamesString(elements);
		var obj2 = getIdsString(elements,false);

		var selectPeople0 = document.getElementById("selectPeople0");
		var selectPeople2 = document.getElementById("selectPeople2");

		if(selectPeople0.style.display == "none"){
			var selectPeople2_text = document.getElementById("selectPeople2_text");
			selectPeople2_text.value = obj1;
		}else{
			var selectPeople0_text = document.getElementById("selectPeople0_text");
			selectPeople0_text.value = obj1;
			
		}
		document.getElementById("organizationId").value = getIdsString(elements,true);
	}
}

