try {
	getA8Top().endProc();
}
catch (e) {
}


/**
 * 刷新页面
 */
function refreshIt() {
    location.reload();
}

/**
 * 页面回退
 */
function locationBack() {
    history.back(-3);
}

/**
 * 取得列表中选中的id
 */
	function getSelectId(frame){
		var ids=frame.document.getElementsByName('id');
		var id='';
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				id=idCheckBox.value;
				break;
			}
		}
		return id;
	}
	
/**
 * 取得列表中所有选中的id
 */	
	function getSelectIds(frame){
		var ids=frame.document.getElementsByName('id');
		var id='';
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				id=id+idCheckBox.value+',';
			}
		}
		return id;
	}
	
	//单击列表中的某一行,显示该行的详细信息
	function showDetail(id,type,tframe){
		tframe.location.href = partitionURL+"?method=modify"+type+"&id="+id+"&isDetail=readOnly";
	}
	
	// 双击列表中的某一行,显示该行的详细信息
	function dbclick(id,type){
		parent.detailFrame.location.href = partitionURL+"?method=modify"+type+"&id="+id+"&isDetail=readOnly";
	}
	//检查两次输入的密码是否一致
	function checkPassword(){
		var pass = parent.detailFrame.document.getElementById("adminPass").value;
		var pass1 = parent.detailFrame.document.getElementById("adminPass1").value;
		if(pass != pass1){
			alert("两次输入的密码不一致,请重新输入!");
			
			return false;
		}
	}
	


// 实现分区冲突是的方法 的 AJAX 方法
function partition(){
	try {
		var start = document.getElementById("startTime").value;
		var end   = document.getElementById("endTime").value;
		var id = parent.listFrame.document.getElementsByName("id").value;
		var name = parent.listFrame.document.getElementsByName("name").value;
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxPartitionManager", "getPartition", false);
		requestCaller.addParameter(1, "date", start);
		requestCaller.addParameter(2, "date", end);
		requestCaller.addParameter(3, "boolean", false);
		var ds = requestCaller.serviceRequest();
		var v1Ary = start.split('-');
		var v2Ary = end.split('-');
		var d1 = new Date(v1Ary[1]+'/'+v1Ary[2]+'/' + v1Ary[0]);
		var d2 = new Date(v2Ary[1]+'/'+v2Ary[2]+'/' + v2Ary[0]);
		if ( d1 < d2 ){
			if ( !ds ){
				return true ;
			}
			var lengthpartition = ds.length;
			if ( lengthpartition < 1 ) {
				return true ;
			}else if( lengthpartition == 1 ){
				return true ;
			} else{
				var names = [];
				for(var i = 0; i < ds.length; i++){
					names[names.length] = "\"" + ds[i].get("name") + "\"";
				}
				alert(_(sysMgrLang.system_partition_same_time,names.join(",")));
				return false;
			}
			return true ;
		}else{
			alert(v3x.getMessage("sysMgrLang.system_partition_startandendtime"))
			return false; 
		}
		return true;
	}catch (ex1) {
		alert("Exception : " + ex1.message);
		return false;
	}
}
/*
 *  判断分区路径是否正确
 */ 
 function validatepath(){
 	try {
		var requestCaller = new XMLHttpRequestCaller(this,"ajaxPartitionManager","validatePath",false);
		requestCaller.addParameter(1,"String",document.getElementById("validatePath").value);
		var vp = requestCaller.serviceRequest();
		if( vp == 'false' || vp == false){
			alert(v3x.getMessage("sysMgrLang.system_partition_confict"))
			return false;
		}else{
			return true ;
		}		
 	} catch (e) {
 		alert("Exception is : " + e.message)
 		return false; 
 	}
 }
 /*
 *  判断网络共享路径是否正确
 */ 
 function validatesharepath(){
 	try {
		var requestCaller = new XMLHttpRequestCaller(this,"ajaxPartitionManager","validatePath",false);
		requestCaller.addParameter(1,"String",document.getElementById("validateSharePath").value);
		var vp = requestCaller.serviceRequest();
		if( vp == 'false' || vp == false){
			alert(v3x.getMessage("sysMgrLang.system_partition_sharePath"))
			return false;
		}else{
			return true ;
		}		
 	} catch (e) {
 		alert("Exception is : " + e.message)
 		return false; 
 	}
 }
 
/*
 *  拆分分区的 ajax 方法
 */
function split(){
	var theParent=parent.listFrame;
	var theId=theParent.document.getElementsByName("id");
	var newTime = document.getElementById("partition.splittime").value;
	for(var i=0;i<theId.length;i++){
		if(theId[i].checked){
			var v1Ary = theId[i].begin.split('-');
			var v2Ary = theId[i].end.split('-');
			var v3Ary = newTime.split('-');
		
			var d1 = new Date(v1Ary[1]+'/'+v1Ary[2]+'/' + v1Ary[0]);
			var d2 = new Date(v2Ary[1]+'/'+v2Ary[2]+'/' + v2Ary[0]);
			var d3 = new Date(v3Ary[1]+'/'+v3Ary[2]+'/' + v3Ary[0]);
			if (d1<d3 && d2>d3){
				//alert(v3x.getMessage("sysMgrLang.system_partition_split_ok"))
				return true;
			}else{
				//alert(v3x.getMessage("sysMgrLang.syten_partition_split_no_area"));
				return false ;
			}
		}
	}
}
/*
 *  验证管理员密码前后是否想的
 */
function validatepassword(){
	var oldpassword = document.getElementById("oldpassword").value;
	var newpassword = document.getElementById("validatepass").value;
	if (oldpassword == newpassword) {
		return true;
	} else {
		alert("密码和验证码不一致！！！");		
		return false;
	}

}

/**
 * 取得列表中选中的id
 */
	function getSelectIDS(frame){
		var ids=frame.document.getElementsByName('id');
		var id='';
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				id=idCheckBox.value;
				break;
			}
		}
		return id;
	}

	