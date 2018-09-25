var columnWidth=new Object();
columnWidth.userName="30%";
columnWidth.dptName="15%";
columnWidth.createDate="15%";
columnWidth.lbsAddr="25%";
columnWidth.lbsComment="20%";

$(function(){
	$(".mycal").each(function(){$(this).compThis();}).addClass("w100b");
	$("#dptName").bind("click",selectDepartment);
	$("#memberName").bind("click",selectMember);
	$("#querySave").bind("click",querySave);
})
/**
*选择部门
*/
function selectDepartment(){
	var txt=$("#dptName").val();
	var values=$("#dptId").val();
	$.selectPeople({
            type : 'selectPeople',
            panels: 'Department',
            selectType:'Department',
            isCanSelectGroupAccount:false,
            onlyLoginAccount:true,
            unallowedSelectEmptyGroup:true,
            hiddenPostOfDepartment:true,
            hiddenOtherMemberOfTeam:true,
            showRecent:true,
            isAllowContainsChildDept:true,
            params : {
		    	text : txt,
		        value : values
		    },
            callback : function(ret) {
                $("#dptName").val(ret.text);
                $("#dptId").val(ret.value.split(",").join("、").split("Department|").join(""));  
            }
        });
}
/**
*选择人员
*/
function selectMember(){
	var txt=$("#memberName").val();
	var values=$("#memberId").val();
	$.selectPeople({
            type : 'selectPeople',
            panels: 'Department,Post',
            selectType:'Member',
            isCanSelectGroupAccount:false,
            onlyLoginAccount:true,
            unallowedSelectEmptyGroup:true,
            hiddenPostOfDepartment:true,
            hiddenOtherMemberOfTeam:true,
            showRecent:true,
            isAllowContainsChildDept:true,
            params : {
		    	text : txt,
		        value : values
		    },
            callback : function(ret) {
            	$("#memberName").val(ret.text);
            	$("#memberId").val(ret.value.split(",").join("、").split("Member|").join(""));
            }
        });
}
/**
*执行查询
*/
function querySave(){
	var ele=$("#lbsTab input");
	var eleList=new Array();
	for(var i=0;i<ele.length;i++){
		var item=$(ele[i]);
		if(item.attr("id")=="onlyOne"&&$("#onlyOne").attr("checked")!="checked"){
			continue;
		}
		eleList.push(item.attr("id")+"="+item.val());
	};
	eleList.push("columnsCount="+$("#columnsCount").val());
	eleList.push("from=0");
	var mlbs = new mLbsRecordManager;
	var result=mlbs.getAttendanceInfoByIds(eleList.join(","));
	buildTable(result);
	initColumnWidth();	
}
/**
*构建表格数据
*/
function buildTable(result){
	var str="<table class='w100b'><tbody>";
	var columns=$("#columns").val().split(",");
	for(var i=0;i<result.length;i++){
		if(i%2==0){
			str+="<tr class='even' style='line-height:25px'>";
		}else{
			str+="<tr style='line-height:25px'>";
		}
		for(var obj in columns){
			var val=result[i][columns[obj]];
			if(val){
				str+="<td noWrap='noWrap' class='padding_l_10' name='"+columns[obj]+"' style='width:"+columnWidth[columns[obj]]+";font-size:12px;text-align:left' title='"+val+"'>"+val+"</td>";
			}
		}
		str+="</tr>";
	}
	str+="</tbody></table>";
	$("#lbsList").html(str);
}
/**
*计算列宽度
*/
function initColumnWidth(){
	var columns=$("#columns").val().split(",");
	var othWidth=0;
	for(var obj in columns){
		if(columns[obj]!='userName'&&typeof ( columns[obj])!="function"){
			othWidth+=$("[name='"+columns[obj]+"']").eq(0).width();
		}
	}
	var htWidth=$("#ht").width();
	$("[name='userName']").width(htWidth-othWidth);
}
function OK(){
	var arr=new Array();
	var eleList=new Array();
	var ele=$("#lbsTab input");
	for(var i=0;i<ele.length;i++){
		var item=$(ele[i]);
		if(item.attr("id")=="onlyOne"&&$("#onlyOne").attr("checked")!="checked"){
			continue;
		}
		eleList.push(item.attr("id")+"="+item.val());
	};
	arr.push(eleList);
	return arr;
}

/*
function fillElement(){
	var pv = getA8Top().paramValue;
	var pt=pv.split(",");
	for(var i=0;i<pt.length;i++){
		var ret=pt[i].split("=");
		$("#"+ret[0]).val(ret[1]);
	}
}*/