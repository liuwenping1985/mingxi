/**切换模板类型**/
function changedType(){
	var optValue = document.getElementById("type");
	if(!optValue || !optValue.value || optValue.value == "undefined" || optValue.value == null){
		return;
	}
    parent.location.href =pathMyTemplate+"?method=myTemplate&type="+optValue.value;
}
/**更名**/
var renameItems = {};
function rename(){
    var count = 0;
	var url = pathMyTemplate+'?method=renameTemplate';
	var id = 0;
	var objects = parent.listFrame.document.getElementsByName("ids"); 	
	if(objects != null){
		for(var i = 0; i < objects.length; i++){		  	    
			if(objects[i].checked){			  
			  url += '&id=' + objects[i].value;	
			  id = 	objects[i].value; 
			  count++;   			
			}
		}
	}	
	renameItems.url = url;
	if(count==1){
		getA8Top().myTempReNameWin = getA8Top().$.dialog({
            title:" ",
            transParams:{'parentWin':window},
            url: pathMyTemplate+"?method=initRename&type="+paramType+"&id="+id,
            width: 380,
            height: 200,
            isDrag:false
        });
	}else if(count==0){
	  alert(v3x.getMessage("MainLang.mytemplate_select"));
	}else if(count>1){
	  alert(v3x.getMessage("MainLang.mytemplate_once_one"));
	}
}

function reNameCollBack(returnval) {
	getA8Top().myTempReNameWin.close();
	if(returnval){
		var f = document.renameForm;
	    f.action=renameItems.url;
        f.type.value = paramType;
        f.newName.value = returnval;
        f.submit();
    }
}

/**删除*/
function del(){
    var isDelete = false;
    var count = 0;
	var url = pathMyTemplate+'?method=deleteTemplate';
	var objects = parent.listFrame.document.getElementsByName("ids");
	if(objects != null){
		for(var i = 0; i < objects.length; i++){		  	    
			if(objects[i].checked){
			  isDelete = true;
			  url += '&id=' + objects[i].value;			    			
			}
		}
	}
	if(isDelete){
		if(confirm(v3x.getMessage("MainLang.mytemplate_del_confirm"))){
			parent.location.href= url + '&type=' + paramType;
		}
	}else{
	  alert(v3x.getMessage("MainLang.mytemplate_select"));
	}
}