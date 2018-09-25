	// 添加兼职人员信息
	function create(){
		parent.detailFrame.location.href=sPluralityURL+"?method=toAddCntPost&reveal=no";
	}
	// 修改兼职人员信息
	function modify(){
		var id = getSelectIds(parent.listFrame);
		var ids = id.split(",");
		if(ids.size()==2){
			parent.detailFrame.location.href=sPluralityURL+"?method=toUpdateCntPost&id="+ids[0];
		}else if(ids.size()>2){
			alert(v3x.getMessage("sysMgrLang.choose_one_only"));
			return false;				
		}else{
			alert(v3x.getMessage("sysMgrLang.system_choice_one_sign"));
			return false;
		}
	}
	// 删除兼职人员信息
	function remove(){	
	    var isDelete = false;		
	    var objects = document.getElementsByName("id");
	    var id = '';
	    if(objects != null){
	      for(var i = 0; i < objects.length; i++){		  		  	    
		    if(objects[i].checked){			    		      
			  isDelete = true;
			  id = objects[i].value;
		    }
	      }
	    }
	    if(isDelete){
	      if(confirm(v3x.getMessage("sysMgrLang.delete_sure"))){
	        var form = document.getElementById("cntPostform");
	        form.target = "hiddenFrame";
	        form.action = sPluralityURL+"?method=deleteCntPost";
	        form.submit();
		    //parent.window.location= url;
	       }
	    } else {
	      alert(v3x.getMessage("sysMgrLang.system_post_delete"));
	    }						
	}
	
	function showDetail(id){
		parent.detailFrame.location.href=sPluralityURL+"?method=cntPostDetail&id="+id;		  
	}
	function partTime(n){
		if(n==1){
            parent.listFrame.location.href=sPluralityURL+"?method=listPlurality&isIn=1";
			bPlurality=true;
		}else if(n==2){
            parent.listFrame.location.href=sPluralityURL+"?method=listPlurality&isIn=0";
			bPlurality=false;
		}
	}
	function init(){
		var grayTd2Obj = document.getElementById("grayTd2");
		if(parent.parent.WebFXMenuBar_mode=="gray"){
		  document.getElementById("grayTd").className="webfx-menu-bar-gray";
		  if (grayTd2Obj) {
			  grayTd2Obj.className="webfx-menu-bar-gray";
		  }
		  document.getElementById("grayButton").className="div-float condition-search-button-gray";
		}else{
		  document.getElementById("grayTd").className="webfx-menu-bar border-top";
		  if (grayTd2Obj) {
			  grayTd2Obj.className="webfx-menu-bar border-top";
		  }
		}
	}
	function edit(){
		parent.detailFrame.location.href=sPluralityURL+"?method=toUpdateCntPost&id="+id;
	}
	function exportExcel(n,isIn){
		if(n==1){
			hiddenFrame.location.href=sPluralityURL+"?method=exportCnt";
		}else if(n==2){
			hiddenFrame.location.href=sPluralityURL+"?method=exportCnt&isIn=1";
		}else if(n==3){
		    hiddenFrame.location.href=sPluralityURL+"?method=exportCnt&isIn=0";
		}
	}
	function banchAdd(){
		var returnValue = v3x.openWindow({
			url: sPluralityURL+'?method=banchAdd',
			width : 300,
			height : 240,
			resizable: "no"
		});	
		if(returnValue){
			window.location.reload();
		}
	}
	function submitForm(){
		alert('submitForm()');
		window.close();
	}
	function setMemberId(elements){   
		document.getElementById("memberName").value = getNamesString(elements);
		document.getElementById("memberId").value = getIdsString(elements, false); 
	}
	function setAccount(elements){
		document.getElementById("cntAccountName").value = getNamesString(elements);
		document.getElementById("cntAccountId").value = getIdsString(elements, false); 
	}
	function doEndAdd(){
        parent.listFrame.location.reload(true);
    }
    
    function showNextSpecialCondition(conditionObject) {
	var options = conditionObject.options;
	var dname="";
	for (var i = 0; i < options.length; i++) {
		
		if(options[i].value=="name")
			danme="name";
		else if(options[i].value=="")
			danme="";
		else
			danme="account";
	    var d = document.getElementById(danme + "Div");
	    if (d) {
//			if(danme=="account")
//				document.getElementById("accounts").options[0].selected= true;
	        d.style.display = "none";
	 	}
	}
    if(conditionObject.value=="name")
			danme="name";
	else if(conditionObject.value=="")
		{
		danme="";
		document.getElementById('nameDiv').style.display = "none";
		document.getElementById('accountDiv').style.display = "none";
	}
	else
		danme="account";
	if(document.getElementById(danme + "Div") == null) return;
		    document.getElementById(danme + "Div").style.display = "block";
}

// 按钮搜索事件
		function doSearch() {
			var mname="";
			var accountId="";
			var cntaccountid="";
			//var temp = document.getElementsByName('accounts');temp[0].value
			var searchObjValue = document.getElementById('condition').value;
			if(searchObjValue=='name'){
				 mname=document.getElementById('nametextfield').value;
			}else if(searchObjValue=='account'){
				//2012-03-07lilong修改BUG_AEIGHT-1264_listPlurality.jsp页面中查询input的id变换为orgAccountId原来为accounts无法取得该值导致js空指针
				accountId=document.getElementById("orgAccountId").value;
			}else if(searchObjValue=='cntaccount'){
				cntaccountid=document.getElementById("orgAccountId").value;
			}
			var condition=document.getElementById('condition').value;
			document.location.href=sPluralityURL+"?method=listPlurality&sname="+encodeURIComponent(mname)+"&saccount="+accountId+"&scntaccount="+cntaccountid+"&condition="+condition;
		}