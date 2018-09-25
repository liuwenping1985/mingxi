/**
 * 当用户在以创建日期为条件进行查询时，如果发现开始日期晚于结束日期，则自动将开始日期置为结束日期前一星期，或将结束日期置为开始日期后一星期
 */
function setDate(id) {
	var startDate = document.getElementById("startdate");
	var endDate = document.getElementById("enddate");
	if(arguments && arguments.length == 3) {
		startDate = document.getElementById(arguments[1]);
		endDate = document.getElementById(arguments[2]);
	}
	if(startDate.value == '' || endDate.value == '')
		return;
		
	var result = compareDate(startDate.value, endDate.value);
	var setDate;
	if (result > 0) {
		if(id=='startdate') {
			setDate = parseDate(startDate.value);
			//endDate.value = formatDate(setDate.dateAdd(startDate.value, 7));
		} else {
			setDate = parseDate(endDate.value);
			//startDate.value = formatDate(setDate.dateAdd(endDate.value, -7));
		}
		//alert(v3x.getMessage("V3XLang.calendar_endTime_startTime"));
	}
}
/**
 * 重复场景处理：列表界面勾选复选框修改时，选且只能选择一条，删除时，必须选择至少一条
 * 类似的js代码处理过程都是相同的，唯一不同的是给出的提示消息，为了复用，将提示消息作为参数传入
 * 如果不满足上述条件，返回false，反之返回有效的id字符串
 */
function getSelectId(msg0) {
	var ids = document.getElementsByName('id');
	var length = 0;
	var id = "";
	for(var i=0; i<ids.length; i++) {
		if(ids[i].checked) {
			if(length == 0)
				id += ids[i].value;
			else
				id += ',' + ids[i].value;
				
			length += 1;
		}
	}
	if(length == 0) {
		alert(msg0);
		return false;
	}
	if(arguments.length > 1 && arguments[1] && length > 1) {
		alert(arguments[1]);
		return false;
	}
	return id;
}
/**
 * 进行中进度条展现
 */
function showProcDiv(){
	var width = 240;
	var height = 100;
	
	var left = (document.body.scrollWidth - width) / 8 * 5;
	var top = (document.body.scrollHeight - height) / 3;
	    
	var str = "";
		str += '<div id="procDIV" style="position:absolute;left:'+left+'px;top:'+top+'px;width:'+width+'px;height:'+height+'px;z-index:50;border:solid 2px #DBDBDB;">';
		str += "<table width=\"100%\" height=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" bgcolor='#F6F6F6'>";
		str += "  <tr>";
		str += "    <td align='center' id='procText' style='font-size:12px' height='40' valign='bottom'>&nbsp;</td>";
		str += "  </tr>";
		str += "  <tr>";
		str += "    <td align='center'><span class='process'>&nbsp;</span></td>";
		str += "  </tr>";
		str += "</table>";
		str += "</div>";
		
	document.getElementById("procDiv1").innerHTML = str;
	document.close();
}
function startProcManual(title){
	startProc(title);
}
function endProcManual(){
	endProc();
}
function startProc(title){
	var procTextE = document.getElementById("procText");
	if(procTextE){
		procTextE.innerText = title;
	}
	
	var divE = document.getElementById("procDiv1");
	if(divE){
		divE.style.display = "";
	}
}
function endProc(){
	var divE = document.getElementById("procDiv1");
	if(divE){
		divE.style.display = "none";
	}
}
/**
 * 显示文档右侧列表的当前路径，也可用于其它类似页面结构的当前位置显示
 */
function showLocationText(text){
	obj.rows = "0,*";
	document.getElementById("nowLocation").innerHTML = text;
}