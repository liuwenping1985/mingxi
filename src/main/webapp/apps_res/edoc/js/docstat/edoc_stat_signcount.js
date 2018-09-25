var layout;
$(document).ready(function () {
	 layout = $('#layout').layout();
	 //切换统计维度时调用
	 $("input[name='stat']").click(function() {
		 document.frames["content"].document.body.innerText = "";
		 $("#year").click();
	 });
	 $("#queryReset").click(function() {
		 document.frames["content"].document.body.innerText = "";
		 $("#yeartype-startyear option[value='"+curYear+"']").attr("selected", true);
		 $("#yeartype-endyear option[value='"+curYear+"']").attr("selected", true);
		 $("#year").click();
	 });
	 
 });
//导出Excel
function fnDownExcel() {
	$("#resultFrame")[0].contentWindow.statResultToExcel(); 
}
function doStat(type){
	var mManager = new edocStatSetManager();
	//时间判断
	var timeTypes = document.getElementsByName("timeType");
	var k = 0;
	for(i=0;i<timeTypes.length;i++){
		if(timeTypes[i].checked){
			k=i;
			break;
		}
	}
	var flag = 0;
	//年
	if(k==0){
		var sy = document.getElementById("yeartype-startyear").value;
		var ey = document.getElementById("yeartype-endyear").value;
		if(sy>ey){
			flag = 1;
		}
	}
	//季度
	else if(k == 1){
		var sy = document.getElementById("seasontype-startyear").value;
		var ey = document.getElementById("seasontype-endyear").value;
		if(sy>ey){
			flag = 1;
		}else if(sy == ey){
			var ss = document.getElementById("seasontype-startseason").value;
			var es = document.getElementById("seasontype-endseason").value;
			if(eval(ss)>eval(es))flag = 1;
		}
	}
	//月
	else if(k == 2){
		var sy = document.getElementById("monthtype-startyear").value;
		var ey = document.getElementById("monthtype-endyear").value;
		if(sy>ey){
			flag = 1;
		}else if(sy == ey){
			var sm = document.getElementById("monthtype-startmonth").value;
			var em = document.getElementById("monthtype-endmonth").value;
			if(eval(sm)>eval(em))flag = 1; 
		}
	}
	//日
	else if(k == 3){
		var sy = document.getElementById("daytype-startday").value;
		var ey = document.getElementById("daytype-endday").value;
		if(sy=="" || sy==null){
			alert("请选择开始时间");
			return;
		}
		if(ey=="" || ey==null){
			alert("请选择结束时间");
			return;
		}
		var msg = "年份不能小于1990年";
		var startyear = sy.substr(0,4);
		if(parseInt(startyear) < 1990){
			alert(msg);
			return;
		}
		var endyear = ey.substr(0,4);
		if(parseInt(endyear) < 1990){
			alert(msg);
			return;
		}
		
		if(new Date(sy.replace(/-/g,"/")) > new Date(ey.replace(/-/g,"/"))){
			flag = 1;
		}
	}
    if($('input:radio[name="stat"]:checked').length==0){
    	alert("没有可以统计的数据，请前往后台进行配置");
		return;
    }
	if(flag == 1){
		//info.innerHTML="<font color='red'>开始时间不能大于结束时间!</font>";	
		alert("开始时间不能大于结束时间!");
		return;
	}
	var statId = $("input[name='stat']:checked").val();
	var mDetail = mManager.viewOne(statId);
    if(mDetail.state ==1){
    	alert("统计已经停用!");
		return;
    }
	if(type ==1){
		statConditionForm.action =edocStatUrl+"?method=signCountByCondition";
		statConditionForm.target = "content";
	}else{
		statConditionForm.action =edocStatUrl+"?method=exportSignCount";
		statConditionForm.target = "export_iframe";
	}
	statConditionForm.submit();
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
