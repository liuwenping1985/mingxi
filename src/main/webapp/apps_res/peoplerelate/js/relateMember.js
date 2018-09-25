//不需要显示的重复人员
var excludeElements_chooseleader;
var excludeElements_chooseassisitant;
var excludeElements_choosejunior;
var excludeElements_chooseconfrere;

function getMember(elements,currentSelect){
	
	 if(!elements){
		return;
	 }
	 
	//判断当前设置的人员是否已将你设为关联人员 
	var currentSelectName = document.getElementById(currentSelect);
	if(currentSelectName.getAttribute('name')=="leader"){
		for(var i = 0 ; i < elements.length ; i++){
			if(myRelateMap.get(elements[i].id)){
				if(myRelateMap.get(elements[i].id)==1){
					alert(v3x.getMessage("relateLang.has_set_leader",elements[i].name));
					return;
				}
			}
		}
	}else if(currentSelectName.getAttribute('name')=="assistant"){
		for(var i = 0 ; i < elements.length ; i++){
			if(myRelateMap.get(elements[i].id)){
				if(myRelateMap.get(elements[i].id)==2){
					alert(v3x.getMessage("relateLang.has_set_assistant",elements[i].name));
					return;
				}
			}
		}
		
	}else if(currentSelectName.getAttribute('name')=="junior"){
		for(var i = 0 ; i < elements.length ; i++){
			if(myRelateMap.get(elements[i].id)){
				if(myRelateMap.get(elements[i].id)==3){
					alert(v3x.getMessage("relateLang.has_set_junior",elements[i].name));
					return;
				}
			}
		}
		
	}else if(currentSelectName.getAttribute('name')=="confrere"){
		
	}
	//div改造 
	if(v3x.getBrowserFlag('selectDivType')){
		//原来select
		//删除原有人员
	    if(currentSelectName.length > 0){
	    	for(var i = 0; i < currentSelectName.length; i++){
	      			currentSelectName.removeChild(currentSelectName.options[i]);
	     			i--;
	     	}
	    }
      //添加新的人员
	  for(var i = 0; i < elements.length; i++){
	  	var result = false;
	  	for(var k = 0;k<currentSelectName.length;k++){
	  		if(elements[i].id==currentSelectName.options[k].id){
	  			result = true;
	  		}
	  	}
	  	if(!result){
	  		var oOption = document.createElement("OPTION");
	      	oOption.text = elements[i].name;
	      	oOption.value = elements[i].id;
	      	oOption.id = elements[i].id;
	  	  	currentSelectName.options.add(oOption);
	  	}
	  }
	    
	}else{
		//div实现
		//删除原有人员
		currentSelectName.innerHTML = '';
		//添加新的人员
		var currentSelectChildNodes = currentSelectName.childNodes;
		for(var i = 0; i < elements.length; i++){
		  	var result = false;
		  	for(var k = 0;k<currentSelectChildNodes.length;k++){
		  		if(elements[i].id==currentSelectChildNodes[k].id){
		  			result = true;
		  		}
		  	}
		  	if(!result){
		  		var oOption = document.createElement("div");
		  		oOption.setAttribute('class','member-div');
		  		oOption.innerHTML = elements[i].name;
		  		oOption.setAttribute('value',elements[i].id);
		  		oOption.id=elements[i].id; 
		  	  	currentSelectName.appendChild(oOption);
		  	}
		}
	}

	if(currentSelectName.getAttribute('name')=="leader"){
		excludeElements_leader = elements;
	}else if(currentSelectName.getAttribute('name')=="assistant"){
		excludeElements_assistant = elements;
	}else if(currentSelectName.getAttribute('name')=="junior"){
		excludeElements_junior = elements;
	}else if(currentSelectName.getAttribute('name')=="confrere"){
		excludeElements_confrere = elements;
	}
}

function setData(){
	//div改造 
	document.getElementById("hiddenDataDiv").innerHTML = '';
	if(v3x.getBrowserFlag('selectDivType')){
		//原来select
	   if(document.all.leader.length == 0 && document.all.assistant.length == 0 && document.all.junior.length ==0 && document.all.confrere.length ==0){ 		
	        return confirm(v3x.getMessage("relateLang.isLeave"));
	   }
	   //写入 hidden Input
	   for(var i = 0; i<document.all.leader.length; i++){
	      document.getElementById("hiddenDataDiv").innerHTML += "<input type='hidden' name='leaders' value='" + document.all.leader.options[i].value + "'/>" + "\r";
	   }
	   for(var i = 0; i<document.all.assistant.length; i++){
	      document.getElementById("hiddenDataDiv").innerHTML += "<input type='hidden' name='assistants' value='" + document.all.assistant.options[i].value + "'/>" + "\r";
	   }
	   for(var i = 0; i<document.all.junior.length; i++){
	      document.getElementById("hiddenDataDiv").innerHTML += "<input type='hidden' name='juniors' value='" + document.all.junior.options[i].value + "'/>" + "\r";
	   }
	   for(var i = 0; i<document.all.confrere.length; i++){
	      document.getElementById("hiddenDataDiv").innerHTML += "<input type='hidden' name='confreres' value='" + document.all.confrere.options[i].value + "'/>" + "\r";
	   }
	}else{
		//div实现
		var leader_div = document.getElementById("leader-div");
		var leader_div_child = leader_div.childNodes;
		for(var i = 0; i<leader_div_child.length; i++){
			if(leader_div_child[i].id!=undefined){
				document.getElementById("hiddenDataDiv").innerHTML += "<input type='hidden' name='leaders' value='" + leader_div_child[i].id + "'/>" + "\r";
			}
		}
		
		var junior_div = document.getElementById("junior-div");
		var junior_div_child = junior_div.childNodes;
		for(var i = 0; i<junior_div_child.length; i++){
			if(junior_div_child[i].id!=undefined){
				document.getElementById("hiddenDataDiv").innerHTML += "<input type='hidden' name='juniors' value='" + junior_div_child[i].id + "'/>" + "\r";
			}
		}
		
		var assistant_div = document.getElementById("assistant-div");
		var assistant_div_child = assistant_div.childNodes;
		for(var i = 0; i<assistant_div_child.length; i++){
			if(assistant_div_child[i].id!=undefined){
				document.getElementById("hiddenDataDiv").innerHTML += "<input type='hidden' name='assistants' value='" + assistant_div_child[i].id + "'/>" + "\r";
			}
		}
		
		var confrere_div = document.getElementById("confrere-div");
		var confrere_div_child = confrere_div.childNodes;
		for(var i = 0; i<confrere_div_child.length; i++){
			if(confrere_div_child[i].id!=undefined){
				document.getElementById("hiddenDataDiv").innerHTML += "<input type='hidden' name='confreres' value='" + confrere_div_child[i].id + "'/>" + "\r";
			}
		}
		
		
	}
	//alert(document.getElementById("hiddenDataDiv").innerHTML);
	return true ;
}

//重置
function reSet(){
	
//	清空select中数据
	var sel = document.all.tags("select");
	var leaderloop = sel[0].options.length;
	var assistantloop = sel[1].options.length;
	var juniorloop = sel[2].options.length;
	var confrereloop = sel[3].options.length;
	
	for(var i=0;i<leaderloop;i++){
		sel[0].options.remove(0);
	}
	for(var i=0;i<assistantloop;i++){
		sel[1].options.remove(0);
	}
	for(var i=0;i<juniorloop;i++){
		sel[2].options.remove(0);
	}
	for(var i=0;i<confrereloop;i++){
		sel[3].options.remove(0);
	}
	
//	不回显已选人员
	elements_chooseleader = "";
	elements_chooseassisitant = "";
	elements_choosejunior = "";
	elements_chooseconfrere = "";
	
	excludeElements_leader = null;
	excludeElements_assistant = null;
	excludeElements_junior = null;
	excludeElements_confrere = null;
	
}


/**
 * 
 */
function openDetail(link, titleId) {
    var rv = getA8Top().v3x.openWindow({
        url: link,
        workSpace: 'yes'
    });

    if (rv == "true" || rv == true) {
    	try{
        	getA8Top().reFlesh();
    	}
    	catch(e){}
    }
}

function joinArrays(jionArr,arr1,arr2,arr3){
		var arr = new Array();
		excludeElements_chooseleader = new Array();
		excludeElements_chooseassisitant = new Array();
		excludeElements_choosejunior = new Array();
		excludeElements_chooseconfrere = new Array();
		
		if(arr1&&arr2&&arr3){
			arr = eval("excludeElements_"+jionArr).concat(arr1,arr2,arr3);
		}else if(arr1&&arr2){
			arr = eval("excludeElements_"+jionArr).concat(arr1,arr2);
		}else if(arr1&&arr3){
			arr = eval("excludeElements_"+jionArr).concat(arr1,arr3);
		}else if(arr2&&arr3){
			arr = eval("excludeElements_"+jionArr).concat(arr2,arr3);
		}else if(arr1){
			arr = eval("excludeElements_"+jionArr).concat(arr1);
		}else if(arr2){
			arr = eval("excludeElements_"+jionArr).concat(arr2);
		}else if(arr3){
			arr = eval("excludeElements_"+jionArr).concat(arr3);
		}
		
		return arr;
}

function forwardItem(summaryId,affairId){
	
	  var requestCaller = new XMLHttpRequestCaller(this, "ajaxColManager", "checkForwardPermission",false);
	  requestCaller.addParameter(1, "String", summaryId + "_" + affairId);
	  var r = requestCaller.serviceRequest();
		 if(r && (r instanceof Array) && r.length > 0)
		  {
			 alert(v3x.getMessage("relateLang.notAllow_forward"));
			 return;
		  }
	  if (getA8Top().isCtpTop) {
		  getA8Top().toCollWin = getA8Top().$.dialog({
	            title:" ",
	            transParams:{'parentWin':window},
	            url: colURL+"?method=showForward&showType=model&data=" + summaryId + "_" + affairId,
	            width: 360,
	            height: 430,
	            isDrag:false
		  });
	  } else {
		  getA8Top().toCollWin = v3x.openDialog({
	            title:" ",
	            transParams:{'parentWin':window},
	            url: colURL+"?method=showForward&showType=model&data=" + summaryId + "_" + affairId,
	            width: 360,
	            height: 430,
	            isDrag:false
		  });
	  }
}

/**
 * 输出日历
 * iYear 年
 * iMonth 月
 * iDayStyle 输出的样式 分别为 1 2 3 三种
 */
function drawCalendar(iYear, iMonth, iDayStyle, allDate) {
	var myMonth;
    var contextPath = v3x.baseURL;
	myMonth = fBuildCal(iYear, iMonth, iDayStyle);

	document.write("<table border='0' style='border-bottom: 1px #85B4E1 solid ' class='kalendar' background='"+contextPath+"/apps_res/peoplerelate/images/rlbg.gif' cellspacing='0' cellpadding='0' width='100%'><tr class='calanderTitle'>");
	document.write("<td width='50px' align='center'>");
    document.write("<table title='上一月' border='0' cellPadding='0' cellSpacing='0' onclick='ChangeYearAndMonth(0, allDate)'>");
	document.write("<tr><td width='100%' align='center' class='hand'><img border='0' src = '"+contextPath+"/apps_res/peoplerelate/images/leftMounth.gif'></td>");

    document.write("</tr></table></td><td id='YearAndMonth'><p align='center' style='margin-left: 20; margin-right: 20'><table id='tblYearAndMonth' border='0' cellPadding='0' cellSpacing='0'><tr><td width='100%' align='center' style='font: bold'><span id='c_Year'>"+iYear+"</span> 年 <span id='c_Month'>");

	var tmp = iMonth +1;
	document.write(tmp+"</span> 月</td></tr></table></p></td>");

	document.write("<td width='50px' align='center'>");
	document.write("<table title='下一月' border='0' cellPadding='0' cellSpacing='0' onclick='ChangeYearAndMonth(1, allDate)'>");
	document.write("<tr><td width='100%' align='center' class='hand'><img border='0' src='"+contextPath+"/apps_res/peoplerelate/images/rightMounth.gif"+"'></td></tr>");
	document.write("</table></td></tr></table>");

	document.write("<table height='177' border='0' cellspacing='0' cellpadding='0' bgcolor='#FFFFFF' style='border-right: 1px solid #c6c7c9 ' width='100%'><tr id='draw'>");
	document.write("<td align='center' nowrap height='22' bgcolor='#E1EEFF'  class='kalendar1 STYLE1'>");
	document.write(myMonth[0][0]+"</td><td align='center' nowrap bgcolor='#E1EEFF' class='kalendar1 STYLE1'>");
	document.write(myMonth[0][1]+"</td><td align='center' nowrap bgcolor='#E1EEFF' class='kalendar1 STYLE1'>");
	document.write(myMonth[0][2]+"</td><td align='center' nowrap bgcolor='#E1EEFF' class='kalendar1 STYLE1'>");
	document.write(myMonth[0][3]+"</td><td align='center' nowrap bgcolor='#E1EEFF' class='kalendar1 STYLE1'>");
	document.write(myMonth[0][4]+"</td><td align='center' nowrap bgcolor='#E1EEFF' class='kalendar1 STYLE1'>");
	document.write(myMonth[0][5]+"</td><td align='center' nowrap bgcolor='#E1EEFF' class='kalendar1 STYLE1'>");
	document.write(myMonth[0][6]+"</tr>");

	for (w = 1; w < 7; w++) {
		document.write("<tr>");
		for (d = 0; d < 7; d++) {
			//12-25 取消title国际化问题  价值不大
			//document.write("<td align='middle' onmousemove='showTitle(this);'>");
			document.write("<td align='middle'>");
			
			var clickEvent = "eventCal(this);";
			
			if(typeof(myMonth[w][d]) == "undefined")
				clickEvent = "";
			
			document.write("<table border='0' cellpadding='0' width='100%' height='100%' class='kalendar3' cellspacing='0'><tr><td id='calDate' align=center><a onclick=\"" + clickEvent + "\" class='relatveCalander' href='#'>");
			
			if((d==0)||(d==6)){
				document.write("<font id=calDateText style='CURSOR:Hand;color:#8B0000'>" + myMonth[w][d] + "</font></a></td></tr></table>");
			}else{
				document.write("<font id=calDateText style='CURSOR:Hand;color:black'>" + myMonth[w][d] + "</font></a></td></tr></table>");
			}
			
			
			document.write("</td>");
		}
		
		document.write("</tr>");
	}
}

function showTitle(obj){
	//12-25 取消title国际化问题  价值不大
	if(obj.all(2).innerText!=" "){
		obj.title=eval("c_Year").innerHTML+" 年 "+eval("c_Month").innerHTML+" 月 "+obj.all(2).innerText+" 日";
	}
}

function eventCal(obj){
	if(obj.firstChild.innerText!=" "){
		//因为day小于10时前后加了空格，这个地方要处理掉空格
		var dayStr = obj.firstChild.innerHTML;
		if(dayStr.indexOf("&nbsp;") != -1){
	  	dayStr = dayStr.charAt(6);
	  }
	  location.href=calEventURL+"?method=calEventView4RelateMember&curTab=relateMember&curDate="+eval("c_Year").innerHTML+"-"+eval("c_Month").innerHTML+"-"+dayStr+"&relateMemberID="+relateMemberId;

	}
}