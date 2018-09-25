try {
	getA8Top().endProc();
}
catch (e) {
}

/************************************************************
******************对枚举类别 ，枚举的functions
****************************************************************/
/**
 * 弹出添加窗口
 */
function createnewMdataFolder(actionUrl,isSystem){
	var result = v3x.openWindow({
		url : actionUrl+"?method=createNewMdata&isSystem="+isSystem ,
		width:400,
		height:300
	});
	//alert(result) ;
	try{
		if(result == 'false') {
			parent.treeFrame.location.reload();
		}
	}catch(e){	
	}
}
/**
 * 修改某个类别的检查
 * 根据selectType 判断选择的节点是什么样的数据
 * 0代表的是选择的是类别 1代表选择的是项
 */
function editMetadataFolder(actionUrl){
	if(!window.parent.treeFrame && !window.parent.treeFrame.root ){
		return ;
	}
	var selected = window.parent.treeFrame.root.getSelected() ;
    
    var selectId = "";
	var selectName = "";
	var selectType = "" ;
	if(selected){
		selectId = selected.businessId;
		selectName = selected.text;
		selectType = selected.is_formEnum ;
		sortNum = selected.sort ;
		treeSelectId = selectId ;
	}else{	
		window.parent.treeFrame.root.select();
		//selectName = window.parent.mainIframe.treeFrame.root.getSelected().text;
	}
    if(selected.is_formEnum == '1'){
    	alert(v3x.getMessage("sysMgrLang.system_metadata_chose_in_wrong")) ;
    	//alert("请选择类别");
        return ;
    }
    
    if(selectId == "system"){
        alert(v3x.getMessage("sysMgrLang.system_metadata_update_root"));
        return ;
    }
    
    /* 判断在右边是不是选择了数据 ，
    // 如果没有代表要修改这个分类的信息  
    // 要是选择了一条 
    // 代表修改是要这个分类下的某个元数据
     *  count 是得到选中的条数
     */
   var count = window.parent.listFrame.getSelectBox() ;
   if(count == 0){
   	  if(selectId == 0) {
   	  	alert(v3x.getMessage("sysMgrLang.system_metadata_update_root")) ;
   	  	return ;
   	  }  	
       var result = v3x.openWindow({
			url : actionUrl+"?method=editorNewMdata&from=update&isSystem=true&id="+selectId+"&selectName="+encodeURIComponent(selectName)+"&sortNum="+encodeURIComponent(sortNum) ,
			width:400,
			height:300
	   });
		try{
			parent.treeFrame.location.reload();
		}catch(e){	
			//alert(e) ;
		}
		   	  	
    }else if(count>1){
    	alert(v3x.getMessage("sysMgrLang.system_metadata_delete_in_wrong")) ;
    	//alert("system_metadata_delete_in_wrong");
    }else{
    	var metadataId = window.parent.listFrame.getSelectValue();
    	window.parent.detailFrame.location.href = metadataURL + "?method=editUserDefinedMetadata&metadataId=" + metadataId + "&parentId=" + selectId;
    }
    

}

/**
 * 添加的时候创建判断是不是存在同名的
 */
function checkRepeatCategoryName(form){
	var name = form.elements['typeName'].value;
	var isSystem = form.elements['isSystem'].value ;
	var from = form.elements['from'].value ;
	var id = form.elements['metadataID'].value ;
	try {
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxMetadataManager", "checkName", false);
		requestCaller.addParameter(1, "String", isSystem);
		requestCaller.addParameter(2, "String", name);	
		var idList = requestCaller.serviceRequest();	
		if(!idList ){
			return true;
		}
		var lenth = idList.length ;
		if(lenth == 0 ){
			return true ;
		}
		if(from == 'update' && lenth == 1 && id== idList[0]){
			return true ;
		}
		
		alert(_("sysMgrLang.checkForm_nameMustNotDuple"));
		return false;
		
	}catch(e){
		alert("Exception : " + e.message);
	}
   return true ;
}
/**
 * 添加方法创建公共枚举的时候
 * 判断是不是存在相同名称的枚举
 */
function checkIsNameRep(form){
	var name = form.elements['metadataName'].value;
	var isSystem = form.elements['isSystem'].value ;
	var from = form.elements['from'].value ;
	var id =  form.elements['metadataId'].value ;
	try {
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxMetadataManager", "checEnumName", false);
		requestCaller.addParameter(1, "String", isSystem);
		requestCaller.addParameter(2, "String", name);	
		var idList = requestCaller.serviceRequest();	
		if(!idList ){
			return true;
		}
		var lenth = idList.size() ;
		if(lenth == 0 ){
			return true ;
		}
	
		if(from == 'update' && lenth == 1 && idList.keys().instance[0] == id ){
			return true ;
		}
		if(lenth > 1 ){
			alert(_("sysMgrLang.checkForm_nameMustNotDuple"));
			return false;			
		}
		
		if(idList.values().instance[0] == "") {
			alert(_("sysMgrLang.checkForm_nameMustNotDuple_system"));		
		}else{
			alert(_("sysMgrLang.checkForm_nameMustNotDuple_org"));
		}
		return false ;
	}catch(e){
		alert("Exception : " + e.message);
	}
   return true ;
}

function addMetaDataTypeSubmit(){
	var form = mainForm ;
	if(!checkRepeatCategoryName(form)){
		return ;
	}
	if(!checkForm(form)){
		return ;
	}
    form.target = "mainIframe" ;
    form.action = metadataURL + "?method=createNewMetaDataType" ;
    form.submit();
}
/**
 * 得到树中选择的节点的信息 
 * 新建枚举
 */
function  createnewMdata(actionUrl){
	if(!window.parent.treeFrame && !window.parent.treeFrame.root ){
		return ;
	}
	var selected = window.parent.treeFrame.root.getSelected() ;
    
    var selectId = "";
	var selectName = "";
	var selectType = "" ;
	var metadataType = "" ;
	if(selected){
		selectId = selected.businessId;
		selectName = selected.text;
		selectType = selected.is_formEnum ;
		window.parent.treeFrame.treeSelectId = selectId ;
		treeSelectId = selectId ;
		metadataType = selected.type ;
	}else{	
		window.parent.treeFrame.root.select();
		
	}
	if(selectId == '0' || (selectType == '3' && metadataType == "metadata")){
		window.parent.detailFrame.location.href = actionUrl + "?method=newUserDefinededMetadata&isSystem=true&id="+selectId+"&selectName="+selectName ;
	}else{
		alert(v3x.getMessage("sysMgrLang.system_metadata_chose_in_wrong")) ;    	
    	return ;
	}
    try{ oPopup.hide(); }catch(e){}
}
/**
 * 删除已经存在的分类信息
 */	
function deleetMetadataFolder(){
	if(!window.parent.treeFrame && !window.parent.treeFrame.root ){
		return ;
	}
	var selected = window.parent.treeFrame.root.getSelected() ;
    
    var selectId = "";
	var selectName = "";
	var selectType = "" ;
	if(selected){
		selectId = selected.businessId;
		selectName = selected.text;
		selectType = selected.is_formEnum ;
		window.parent.treeFrame.treeSelectId = selectId ;
		treeSelectId = selectId ;
	}else{	
		window.parent.treeFrame.root.select();
		//selectName = window.parent.mainIframe.treeFrame.root.getSelected().text;
	}
    if(selected.is_formEnum == '1'){
    	alert(v3x.getMessage("sysMgrLang.system_metadata_chose_in_wrong")) ;
    	//alert("选择类别") ;
    	return ;
    }
    if(selectId == "system"){
        alert(v3x.getMessage("sysMgrLang.system_metadata_delete_in_wrong1"));
        return ;
    }
    /* 判断在右边是不是选择了数据 ，
    // 如果没有代表要修改这个分类的信息  
    // 要是选择了一条 
    // 代表修改是要这个分类下的某个元数据
     *  count 是得到选中的条数
     */
   var count = window.parent.listFrame.getSelectBox() ;
   if(count == 0){
	  	 if(selectId == '0'){
	  	 	alert(v3x.getMessage("sysMgrLang.system_metadata_delete_in_wrong1")) ;
	    	//alert("根目录不能删除") ;
	    	return ;
	    }else{
			    if(window.confirm(_("sysMgrLang.system_metadata_delete"))){
			    	try{
			    		var requestCaller1 =  new XMLHttpRequestCaller(this, "ajaxMetadataManager", "checkMetaFolderIsRef", false);
			    		requestCaller1.addParameter(1 ,"String" ,selectId) ;
			    		var returnValue = requestCaller1.serviceRequest(); 
			    		if(returnValue=="true"){
			    			alert(v3x.getMessage("sysMgrLang.system_metadata_delete_in_wrong_inuse")) ;
							//alert("分类下有枚举已被引用,不能删除!");
							return false;
						}										    		
			    	}catch(e){
			    		alert("Exception : " + e.message) ;
			    		return false ;
			    	}
			    	var form = window.parent.parent.getObjectByid("deleteForm") ;
			    	form.action = metadataURL + "?method=deleetMetadataFolder&metadataId="+selectId;
			    	form.target = "deleteFrame" ;
			    	form.submit() ;
			    	//window.mainIframe.treeFrame.location.href =  metadataURL + "?method=deleetMetadataFolder&metadataId="+selectId;
			    }	    	
	    }
    }else{
    	var selectIds = '';
    	if(window.confirm(_("sysMgrLang.system_metadata_delete"))){
	    	//得到所有的单选框对象
	    	 var metadataIds = window.parent.listFrame.getSelectObj();
	    	 for(var i=0; i<metadataIds.length; i++){
		    	 	var idCheckBox = metadataIds[i];
					if(idCheckBox.checked){
						try{
		    				var requestCaller1 = new XMLHttpRequestCaller(this, "ajaxMetadataManager", "checkMetaIsRef", false);
		    					requestCaller1.addParameter(1, "String", idCheckBox.value);
		    					var ds1 = requestCaller1.serviceRequest();
								if(ds1=="true"){
									alert(v3x.getMessage("sysMgrLang.system_metadata_delete_in_wrong_inuse")) ;
								//	alert("枚举已被引用,不能删除!");
									return false;
								}				
							/**
		    				var requestCaller = new XMLHttpRequestCaller(this, "ajaxMetadataManager", "checkMetacontainChild", false);
		    					requestCaller.addParameter(1, "String", idCheckBox.value);
		    					var ds = requestCaller.serviceRequest();
								if(ds=="true"){
									alert(v3x.getMessage("sysMgrLang.system_metadata_delete_in_wrong_hasChild")) ;
									//alert("枚举包含子枚举项,不能删除!");
									return false;
								}**/
		   					}catch(e){}	
		   					selectIds = selectIds + idCheckBox.value + ",";			
					}
    	    }
 			  var form = window.parent.parent.getObjectByid("deleteForm") ;
			  form.action = metadataURL + "?method=deleteUserDefinedMetadata&metadataId="+selectIds+"&parentId="+selectId;
			  form.target = "deleteFrame" ;
			  form.submit() ;
    	} 
    	 //window.mainIframe.detailFrame.location.href = metadataURL + "?method=editUserDefinedMetadata&metadataId=" + metadataId
    }
        
    
    
    /**
    if(selectId == 'meta_0'){
    	alert("根目录不能删除") ;
    	return ;
    }
    if(window.confirm("确认删除分类吗,该操作不可撤销")){
    	try{
    		var requestCaller1 =  new XMLHttpRequestCaller(this, "ajaxMetadataManager", "checkMetaFolderIsRef", false);
    		requestCaller1.addParameter(1 ,"String" ,selectId) ;
    		var returnValue = requestCaller1.serviceRequest(); 
    		if(returnValue=="true"){
				alert("分类下有枚举已被引用,不能删除!");
				return false;
			}					    		
    	}catch(e){
    		alert("Exception : " + e.message) ;
    		return false ;
    	}
    	var form = document.getElementById("deleteForm") ;
    	form.action = metadataURL + "?method=deleetMetadataFolder&metadataId="+selectId;
    	form.target = "deleteFrame" ;
    	form.submit() ;
    	//window.mainIframe.treeFrame.location.href =  metadataURL + "?method=deleetMetadataFolder&metadataId="+selectId;
    }
   */	
}
 /**
  * 得到选中的选择框的个数
  */
function getSelectBox(){
 	var num = validateCheckbox("metadataIds") ;
 	return num ;
}
/**
 * 得到选择的值
 */
function getSelectValue(){ 
		var metadataIds = document.getElementsByName('metadataIds');
		for(var i=0; i<metadataIds.length; i++){
			var idCheckBox = metadataIds[i];
			if(idCheckBox.checked){
				return idCheckBox.value;
			}
		}
	
}
/**
 * 得到单选框这个对象
 */
function getSelectObj(){ 
   var selectObj = document.getElementsByName('metadataIds');
   return selectObj ;
}
/**
 * 根据ID得到相应的对象
 */
function getObjectByid(id){
	 var returnObj = document.getElementById(id) ;
	 return returnObj ;
}
/**
 * 将一个枚举分类下的枚举移动到另一个分类下
 */
function moveToFolder(){
	
	if(!window.parent.treeFrame && !window.parent.treeFrame.root ){
		return ;
	}
	var selected = window.parent.treeFrame.root.getSelected() ;
    
    var selectId = "";
	var selectName = "";
	var selectType = "" ;
	if(selected){
		selectId = selected.businessId;
		selectName = selected.text;
		window.parent.treeFrame.treeSelectId = selectId ;
		selectType = selected.is_formEnum ;
	}else{	
		window.parent.treeFrame.root.select();
		//selectName = window.parent.mainIframe.treeFrame.root.getSelected().text;
	}
    if(selected.is_formEnum == '1'){
    	alert(v3x.getMessage("sysMgrLang.system_metadata_chose_in_wrong"));
    	//alert("选择类别") ;
    	return ;
    }
    var count = window.parent.listFrame.getSelectBox() ; 
    if(count == 0 ){
    	//system_distribute_delete_ok
    	alert(v3x.getMessage("sysMgrLang.system_metadata_move_ok")) ;
    	//alert("前选择最少一条记录！") ;
    	return ;
    }
    var metadataStr = '' ;
    var metadataIds = window.parent.listFrame.getSelectObj();
	 for(var i=0; i<metadataIds.length; i++){
		 var idCheckBox = metadataIds[i];
	     if(idCheckBox.checked){ 
			metadataStr = 	metadataStr +idCheckBox.value + "," ;	
		 }  
	 } 
    var result = v3x.openWindow({
		url : metadataURL+"?method=moveMetada&isSystem=true&metadataTypeId="+selectId+"&metadataIds="+metadataStr ,
		width:500,
		height:500
	});	
	try{
		parent.treeFrame.location.reload();
		parent.listFrame.location.reload() ;
	}catch(e){	
	}
}


/*******************************************************************************
 * 对枚举值的function
 **********************************************************************************/
/**
 *  
 *  新建枚举值
 */
function getSelectBoxCount(objName){
	var num = validateCheckbox(objName) ;
 	return num ;
}

function getHasSelectValue(objName){ 
		var metadataIds = document.getElementsByName(objName);
		for(var i=0; i<metadataIds.length; i++){
			var idCheckBox = metadataIds[i];
			if(idCheckBox.checked){
				return idCheckBox.value;
			}
		}
}

function getCheckBoxObj(objName){ 
   var selectObj = document.getElementsByName(objName);
   return selectObj ;
}

function newdataItem(){
	if(!window.parent.treeFrame && !window.parent.treeFrame.root ){
		return ;
	}
	var selected = window.parent.treeFrame.root.getSelected() ;
    
    var selectId = "";
	var selectName = "";
	var selectType = "" ;
	var type = "" ;
	var isref = "" ;
	var hasChildren="false";
	if(selected){
		selectId = selected.businessId;
		selectName = selected.text;
		selectType = selected.is_formEnum ;
		window.parent.treeFrame.treeSelectId = selectId ;
		type = selected.type ;
		if(selected.isref){
			isref = selected.isref ;
		}
		try{
			var requestCaller = new XMLHttpRequestCaller(this, "ajaxMetadataManager", "checkHasChiledren", false);
			requestCaller.addParameter(1, "String", selectId);
			hasChildren = requestCaller.serviceRequest();
		}catch(e){
			alert(v3x.getMessage("sysMgrLang.system_metadataitem_query_wrong",e)) ;
		  	return ;
		}
	}else{	
		window.parent.treeFrame.root.select();
	}
	 
	 /**
	  * var count = window.parent.mainIframe.listFrame.getSelectBoxCount("metadataItemIds") ;
	  * if(count == 0){
		*	 	window.parent.mainIframe.detailFrame.location.href = metadataURL+"?method=userDefinedednewMetadataItem&metadataId="+selectId;
		*	 }else if(count > 1){
		*	 	alert(v3x.getMessage("sysMgrLang.choose_one_only")) ;
		*	 	//alert("不能选择多条记录") ;
		*	 	return ;
		*	 }else{
		*	 	//得到选中值
		*	 	var value = window.parent.mainIframe.listFrame.getSelectValue() ;
		*	 	window.parent.mainIframe.detailFrame.location.href = metadataURL + "?method=editUserDefinedItem&itemId=" + value + "&metadataId="+selectId;
		*	 }
	  ****/
	 
	  if(isref && isref == "0" && hasChildren=="false" ){
	  	alert(v3x.getMessage("sysMgrLang.system_metadataitem_create_wrong")) ;
	  	return ;
	  }
	  
     window.parent.detailFrame.location.href = metadataURL+"?method=userDefinedednewMetadataItem&parentId="+selectId+"&type="+selectType+"&parentType="+type;
}
/**
 * 修改枚举值
 */
function editdataItem(){
	if(!window.parent.treeFrame && !window.parent.treeFrame.root ){
		return ;
	}
	var selected = window.parent.treeFrame.root.getSelected() ;
    
    var selectId = "";
	var selectName = "";
	var selectType = "" ;
	var type = "" ;
	if(selected){
		selectId = selected.businessId;
		selectName = selected.text;
		selectType = selected.is_formEnum ;
		window.parent.treeFrame.treeSelectId = selectId ;
		type = selected.type ;
	}else{	
		window.parent.treeFrame.root.select();
		//selectName = window.parent.mainIframe.treeFrame.root.getSelected().text;
	}
	  var count = window.parent.listFrame.getSelectBoxCount("metadataItemIds") ;
	 
	  if(count == 0){
	 	alert(v3x.getMessage("sysMgrLang.system_choice_one_sign")) ;
	 	//alert("请选择记录") ;
	 	return ;
	 }else if(count > 1){
	   alert(v3x.getMessage("sysMgrLang.system_metadata_delete_in_wrong")) ;
	 	//alert("不能选择多条记录") ;
	 	return ;
	 }else{
	 	//得到选中值
	 	var value = window.parent.listFrame.getHasSelectValue("metadataItemIds") ;
	 	window.parent.detailFrame.location.href = metadataURL + "?method=editUserDefinedItem&parentId="+selectId+"&selectType="+type+"&itemId=" + value ;
	 }	
}

/**
 * 删除枚举值
 */
function deldatadataItem(){
  if(!window.parent.treeFrame && !window.parent.treeFrame.root ){
		return ;
	}
	var selected = window.parent.treeFrame.root.getSelected() ;
    
    var selectId = "";
	var selectName = "";
	var selectType = "" ;
	var type = "" ;
	if(selected){
		selectId = selected.businessId;
		selectName = selected.text;
		selectType = selected.is_formEnum ;
		window.parent.treeFrame.treeSelectId = selectId ;
		type = selected.type ;
	}else{	
		window.parent.treeFrame.root.select();
		//selectName = window.parent.mainIframe.treeFrame.root.getSelected().text;
	}
	var count = window.parent.listFrame.getSelectBoxCount("metadataItemIds") ;
	  
	if(count == 0){
	  	alert(v3x.getMessage("sysMgrLang.system_post_delete")) ;
	  	//alert("请选择记录") ;
	  	return ;
	 }
	 var selectIds = '';
	 if(window.confirm(_("sysMgrLang.system_metadata_delete"))){
			var checkBoxObj = window.parent.listFrame.getCheckBoxObj("metadataItemIds") ;
			for(var i = 0 ; i < checkBoxObj.length ; i++){
				var checkBox = checkBoxObj[i] ;
				if(checkBox.checked){
					try{
						var requestCaller = new XMLHttpRequestCaller(this, "ajaxMetadataManager", "checkItemIsRef", false);
							requestCaller.addParameter(1, "String", selectId);
						    requestCaller.addParameter(2, "String", checkBox.value);
						var ds = requestCaller.serviceRequest();
						if(ds=="true"){
							alert(v3x.getMessage("sysMgrLang.system_metadata_delete_in_use")) ;
						   //alert("所选项被引用,不能删除!");
							return false;
						}else if(ds == "haschild"){
							alert("该枚举存在下级节点，不能删除！") ;							  
							return false;
						}
						
				   }catch(e){
				   }
				  /**
				   if(checkIstheLastOne(selectId,checkBox.value)){
				   	  //alert("该枚举已经被引用，最后一个没有停用的枚举值不能被删除!") ;
				   	  alert(v3x.getMessage("sysMgrLang.system_metadata_formdelete_theLastOne")) ;
				   	  return false;
				   }**/
				   selectIds = selectIds + checkBox.value + ",";			
				}	
		    }
	/**	***    
	if(checkDelAll(selectId , count)){
		//alert("该枚举已经被引用，不能删除全部的枚举值!") ;
		alert(v3x.getMessage("sysMgrLang.system_metadata_formdelete_all")) ;
		return false ;
	}
	* **/
	var form = window.parent.parent.getObjectByid("deleteForm") ;
	form.action = metadataURL + "?method=deleteUserDefinedItem&metadataItemIds="+selectIds+"&parentType="+type+"&parentId="+selectId;
	form.target = "deleteFrame" ;
	form.submit() ;			    	    	 	
  }
} 	
/***************************************************
 * 表单操作
 *************************************************************/
 
 //绑定枚举
function binding(){
   var form = document.getElementById("selectForm") ;
   if(!form){
      return ;
   }
   if(!window.root){
     return ;
   }
   var selected = window.root.getSelected() ;
   
    var selectId = "";
    var selectType = "" ;
	if(selected){
		selectId = selected.businessId;
		selectType = selected.is_formEnum ; 
	}else{	
		window.root.select();
	}
    if(selectType == '0'){
    	alert(v3x.getMessage("sysMgrLang.system_metadata_select_metadata")) ;
    	return ;
    }
	
   form.action = metadataURL + "?method=savaMoveMetadata&toMetadataId="+selectId ;
   form.target = "systemDataTree" ;
   form.submit() ;
}

function doEnd(metadata,flag){	
	//var _cont = window.detailFrame.document.getElementById("checkbox");
	
 	if(flag && flag=='true'){ //连续添加
		window.detailFrame.showOrgDetail = false;
 	}else{
		//Form.disable("postForm");
		window.detailFrame.showOrgDetail = true;
	}
	window.listFrame.location.reload(true);
}
/**
 * 判断当前的枚举值是否是最后一个没有停用的枚举值
 * 如果当前枚举已经被引用同时当前枚举值是最后一个枚举值
 * 返回true 否则返回false
 * Ajax方法进行判断
 */
function checkIstheLastOne( metadataId , metadataItemid){
	try{
    	var requestCaller = new XMLHttpRequestCaller(this, "ajaxMetadataManager", "checkIsTheLastOne", false);
    	requestCaller.addParameter(1, "String", metadataId);
		requestCaller.addParameter(2, "String", metadataItemid);
    	var ds = requestCaller.serviceRequest();
		if(ds == "true" ){			
			return true;
		}
    }catch(e){
    }
    return false ;
}
/**
 * 判断是否删除全部的枚举值
 * 如果该枚举被引用同时删除全部枚举值
 * 返回true
 * Ajax方法进行判断
 */
function checkDelAll(metadataId , count){
	try{
    	var requestCaller = new XMLHttpRequestCaller(this, "ajaxMetadataManager", "checkDelAll", false);
    	requestCaller.addParameter(1, "String", metadataId);
		requestCaller.addParameter(2, "int", count);
    	var ds = requestCaller.serviceRequest();
		if(ds == "true" ){			
			return true;
		}
    }catch(e){
    }
    return false ;
}

function showChildOfMetadataItem(metadataItemId,type,orgAccountId){
	  if(parent.toolbarFram!=null){
		  try{
		  	  var oMetadataToolbar = parent.toolbarFram.document.getElementById('metadataToolbar');
			  var oUnMetadataToolbar = parent.toolbarFram.document.getElementById('unMetadataToolbar');
			  var oMetadataValueToolbar = parent.toolbarFram.document.getElementById('metadataValueToolbar');
			  if(oUnMetadataToolbar!=null && oMetadataToolbar!=null && oMetadataValueToolbar != null){
			  	oUnMetadataToolbar.className = "hidden";
			  	oMetadataToolbar.className = "hidden";
			  	oMetadataValueToolbar.className = "show";
			  }
		  }catch(e){
		      parent.toolbarFram.location.href = metadataURL + "?method=userDefinedtoobar&from="+type+"&isSystem=true&id="+metadataId;
		  }
	  }
	if(orgAccountId && orgAccountId != ""){
		 parent.listFrame.location.href = metadataURL + "?method=userDefinedmetadataItemList&org_account_id="+orgAccountId+"&parentId="+metadataItemId+"&parentType="+type+"&isSystem=true" ;
	}else{
		parent.listFrame.location.href = metadataURL + "?method=userDefinedmetadataItemList&parentId="+metadataItemId+"&parentType="+type+"&isSystem=true" ;
	}  	
}




function showValuesList(metadataId,orgAccountId){
	 if(parent.toolbarFram!=null){
		  try{
			  var oMetadataToolbar = parent.toolbarFram.document.getElementById('metadataToolbar');
			  var oUnMetadataToolbar = parent.toolbarFram.document.getElementById('unMetadataToolbar');
			  var oMetadataValueToolbar = parent.toolbarFram.document.getElementById('metadataValueToolbar');
			  if(oMetadataToolbar!=null && oUnMetadataToolbar!=null && oMetadataValueToolbar != null){
			  	oMetadataToolbar.className = "hidden";
			  	oUnMetadataToolbar.className = "hidden";
			  	oMetadataValueToolbar.className = "show";
			  }
		  }catch(e){
		      parent.toolbarFram.location.href = metadataURL + "?method=userDefinedtoobar&from=metadata&isSystem=true&id="+metadataId;
		  }
	  }
	 if(orgAccountId && orgAccountId != ""){
		 parent.listFrame.location.href = metadataURL+"?method=userDefinedmetadataItemList&isSystem=true&parentType=metadata&parentId="+metadataId+"&org_account_id="+orgAccountId;
	 }else{
		 parent.listFrame.location.href = metadataURL+"?method=userDefinedmetadataItemList&isSystem=true&parentType=metadata&parentId="+metadataId;
	 }
	 
     
}
function showTypeList(acconutId){
	  if(parent.toolbarFram!=null){
		  try{
			  var oMetadataToolbar = parent.toolbarFram.document.getElementById('metadataToolbar');
			  var oUnMetadataToolbar = parent.toolbarFram.document.getElementById('unMetadataToolbar');
			  var oMetadataValueToolbar = parent.toolbarFram.document.getElementById('metadataValueToolbar');
			  if(oMetadataToolbar!=null && oUnMetadataToolbar!=null && oMetadataValueToolbar!= null){
			  	oMetadataToolbar.className = "hidden";
			  	oMetadataValueToolbar.className = "hidden";
			  	oUnMetadataToolbar.className = "show";
			  }
		  }catch(e){
		      parent.toolbarFram.location.href = metadataURL + "?method=userDefinedtoobar&from=metadataType&isSystem=true&id=0";
		  }
	  }
	  if(acconutId){
		  parent.listFrame.location.href = metadataURL+"?method=userDefinedmetadataList&org_account_id="+acconutId;	  
	  }else{
		  parent.listFrame.location.href = metadataURL+"?method=userDefinedmetadataList";
	  }
	
}
function showItemList(metadataId ,metadataType){
	  if(parent.toolbarFram!=null){
		  try{
		  	  var oMetadataToolbar = parent.toolbarFram.document.getElementById('metadataToolbar');
			  var oUnMetadataToolbar = parent.toolbarFram.document.getElementById('unMetadataToolbar');
			  var oMetadataValueToolbar = parent.toolbarFram.document.getElementById('metadataValueToolbar');
			  if(oUnMetadataToolbar!=null && oMetadataToolbar!=null && oMetadataValueToolbar != null){
			  	oUnMetadataToolbar.className = "hidden";
			  	oMetadataValueToolbar.className = "hidden";
			  	oMetadataToolbar.className = "show";
			  }
		  }catch(e){
		      parent.toolbarFram.location.href = metadataURL + "?method=userDefinedtoobar&from=metadataType&isSystem=true&id="+metadataId;
		  }
	  }
   parent.listFrame.location.href = metadataURL + "?method=userDefinedmetadataList&parentId="+metadataId+"&metadataType="+metadataType+"&isSystem=true" ;
}

function refreshTree(idStr){
	if(idStr == '0'){
		document.location.reload();
	} else {
		var tree;
		if(parent.parent.treeFrame){
			tree = parent.parent.treeFrame.webFXTreeHandler;
		}else if(parent.treeFrame){
			tree = parent.treeFrame.webFXTreeHandler;
		}else{
			tree = treeFrame.webFXTreeHandler;
		}
		var node = tree.all[tree.getIdByBusinessId(idStr)];
		if(typeof eval(node) != 'undefined') {
			try {
				node.reload();
			} catch(e){}
		}
	}
}
