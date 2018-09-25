
function setReadOnly(){
	var nodes = document.getElementsByTagName("input");
	for(var i = 0; i < nodes.length; i++){
		try{
			nodes[i].disabled = true;
		}catch(E){}
	}
	nodes = document.getElementsByTagName("textarea");
	for(var i = 0; i < nodes.length; i++){
		try{
			nodes[i].disabled = true;
		}catch(E){}
	}
	nodes = document.getElementsByTagName("select");
	for(var i = 0; i < nodes.length; i++){
		try{
			nodes[i].disabled = true;
		}catch(E){}
	}
}

function setWriteabled(){
	
}

function checkSelect(formNode){
	var ns = formNode.getElementsByTagName("input");
	for(var i = 0; i < ns.length; i++){
		if(ns[i].type == "checkbox" && ns[i].name == "id" && ns[i].checked){
			return ns[i].value;
		}
	}
	return "";
}

function checkSelectOne(formNode){
	var id = "";
	var ns = formNode.getElementsByTagName("input");
	for(var i = 0; i < ns.length; i++){
		if(ns[i].type == "checkbox" && ns[i].name == "id" && ns[i].checked){
			if(id == ""){
				id = ns[i].value;
			}else{
				return "false";
			}
		}
	}
	return id;
}

//基础数据添加onUnload事件
function UnLoad_detailFrameDown() {
	if(parent.detailFrame!=null){
		parent.detailFrame.location.href = 'common/detail.jsp?direction=Down';
	}
}

