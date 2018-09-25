$(function() {
});

/**
 * 选择人员
 */
function fnSelect(type){
	var ids = $("#autoDriver").val();
	if(type === 'manager'){
		ids = $("#autoManager").val();
	}
	fnSelectPeoplePub({type:type,value:ids});
}

/**
 * 设置车辆管理员、驾驶员回调函数
 * @returns
 */
function fnSelectPeople(p) {
	var returnObj = p.okParam;
	if (returnObj) {
		if (p.type === "manager") {
			var managerIds = "";
			var managerNames = "";
			for ( var i = 0, j = returnObj.length; i < j; i++) {
				if (i < j - 1) {
					managerIds = managerIds + returnObj[i].id + ","; 		// 组装管理员ID和名字字符串
					managerNames = managerNames + returnObj[i].name+ ",";
				} else if (i == j - 1) {
					managerIds = managerIds + returnObj[i].id;
					managerNames = managerNames + returnObj[i].name;
				}
			}
			$("#autoManager").val(managerIds);
			$("#autoManagertxt").val(managerNames);
		} else if (p.type === "driver") {
			if(returnObj.length==1){ 										//驾驶员不是必选，要判断为空
				var driverId = returnObj[0].id;	
				var driverName = returnObj[0].memberName;
				$("#autoDriver").val(driverId);
				$("#autoDrivertxt").val(driverName);
			}
		}
		p.dialog.close();
	}
}

function OK(){
	var isAgree = $("#autoInfoUpdates").validate();
	var rval = {};
	rval.isAgree = "no"    //这个字段是用来判断字段校验是否通过
	if(isAgree){
		rval.managerVal = $("#autoManager").val();
		rval.managerTxt = $("#autoManagertxt").val();
		rval.driverVal = $("#autoDriver").val();
		rval.driverTxt = $("#autoDrivertxt").val();
		rval.aveFuelConsump = $("#aveFuelConsump").val();
		rval.aveFuelCost = $("#aveFuelCost").val();
		rval.autoMemo = $("#autoMemo").val();
		rval.isAgree = "yes"  //通过
	}
	return rval;
}
