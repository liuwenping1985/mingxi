function addCategory(){
	parent.detailFrame.location.href = edocCategoryUrl + "?method=detail&actionType=addCategory";
}

function showCategory(id){
	parent.detailFrame.location.href = edocCategoryUrl + "?method=detail&actionType=showCategory&id=" + id;
}

/**
 * 对标题默认值的切换
 * @param isShowBlack 去掉为默认值，显示空白，用在onFocus
 */
function checkDefSubject(obj, isShowBlack) {
	var dv = obj.defaultContent;
    if (isShowBlack && obj.value == dv) {
            obj.value = "";
    }
    else if (!obj.value) {
            obj.value = dv;
    }
}

function modifyCategory(){

	var items = document.getElementsByName("id");
	if(!items){
		alert(v3x.getMessage("edocLang.please_select_category"));
		return;
	}
	var selectCount = 0;
	var selectId;
	for(var i=0;i<items.length;i++){
		if(items[i].checked){
			selectId = items[i].value;
			selectCount++;
		}
	}
	if(selectCount == 0){
		alert(v3x.getMessage("edocLang.please_select_category"));
		return ;
	}else if(selectCount > 1){
		alert(v3x.getMessage("edocLang.edoc_category_selectOnlyOne"));
		return;
	}
	parent.detailFrame.location.href = edocCategoryUrl + "?method=detail&actionType=editCategory&id=" + selectId;

}
//lijl添加
function modifyCategory1(){
	var items = document.getElementsByName("id");
	if(!items){
		alert(v3x.getMessage("edocLang.please_select_category"));
		return;
	}
	var select = false;
	var modifiedId = "";
	var category;
	var modifyCategory = document.getElementById("modifyCategory");
	for(var i=0;i<items.length;i++){
		if(items[i].checked){
			select = true;
			modifiedId += items[i].value + ",";
			category = document.getElementById("category"+items[i].value);
			if(category){
				category.disabled = false;
			}
		}
	}
	if(!select){
		alert(v3x.getMessage("edocLang.please_select_category"));
	}else{
		modifyCategory.value += modifiedId;
	}
}

function deleteCategory(){
	var items = document.getElementsByName("id");
	if(!items){
		alert(v3x.getMessage("edocLang.please_select_category"));
		return;
	}
	var selectCount = 0;
	var systemCount = 0;
	var msg = "";
	var removedId = new Array();
	for(var i=0;i<items.length;i++){
		if(items[i].checked){
			removedId[selectCount] = items[i].value;
			if(items[i].getAttribute("isSystem") == "true"){
				systemCount++;
			}
			selectCount++;
		}
	}
		
	if(systemCount > 0){
		alert(_("edocLang.edoc_category_system_enable_delete")+"\r\n");
		return;
	}
	if(selectCount == 0){
		alert(v3x.getMessage("edocLang.please_select_category"));
		return;
	}

	if(removedId.length > 0){
		msg = "";
		var urlstr = edocCategoryUrl+"?method=checkUsed&ids="+removedId+"&date="+new Date;
		$.ajax({
			url:urlstr ,
			async:false,
			success: function(data){
				var usedList = {};
				eval("usedList = "+data);
				var arr = removedId;
				for(var index=0;index<arr.length;index++){
					if(usedList[arr[index]]){
						var nameObj = document.getElementById("name" + arr[index]);
						if(nameObj)
							msg += nameObj.innerText + "\r\n";
						var chkList = document.getElementsByName("id");
						for(var i=0;i<chkList.length;i++){
							if(chkList[i].value == arr[index]){
								chkList[i].checked = false;
							}
						}
					}
				}
			},
			error:function(){
				alert("error:"+e.message);
			}
		});
		if(msg.length > 0){
			alert(_("edocLang.edoc_category_used_enable_delete")+"\r\n"+msg);
			return;
		}
	}
	
	if (!window.confirm(_("edocLang.edoc_category_confirmDelete"))){
		return;
	}
	mainForm.action = edocCategoryUrl + "?method=deleteCategory";
	mainForm.submit();
}

function reloadEdocCategory(newOptions){
	var _parent = window.parent.dialogArguments.window;
	var _document = _parent.document;
	var sel = _parent.document.getElementById("edocCategory");
	sel.options.length = 0;
	for(var i=0;i<newOptions.length;i++){
		var opt = _document.createElement("option");
		opt.value = newOptions[i].value;
		opt.text = newOptions[i].text;
		sel.options[i] = opt;
	}
}

function checkChar(value){
	return /^[^\|"']*$/.test(value);
}

function checkPost(){
	var categoryName = document.getElementById("categoryName");
	if(categoryName){
		if(!checkChar(categoryName.value)){
			alert(_("edocLang.edoc_category_name_enable_specchar"));
			return false;
		}
	}
	return true;
}

function saveCategory(){
	//GOV-3854 公文管理-基础数据-文单定义-新建文单-发文种类维护-新建或修改发文种类，名称中有单引号或双引号时，保存报脚本错且部分特殊字串也会被转义
	//不能输入特殊字符
	var submitButton =  document.getElementById("submitButton");
	submitButton.disabled = true;
	if(!checkForm(categoryForm)){
		submitButton.disabled = false;
		return;
	}
	if(checkRepeat()=='true'){
		submitButton.disabled = false;
		return;
	}
	if(checkPost()){
		categoryForm.method= "POST";
		categoryForm.action = edocCategoryUrl+"?method=save";
		categoryForm.submit();
	}else{
		submitButton.disabled = false;
	}
}

function checkRepeat(){
	var hasName = false;
	var requestCaller = new XMLHttpRequestCaller(this, "edocCategoryManager", "hasExistName", false);
	var categoryName = document.getElementById("categoryName").value;
	var categoryId = document.getElementById("id");
	if(categoryId){
		categoryId = categoryId.value;
	}else{
		categoryId = "";
	}
    requestCaller.addParameter(1, "String", categoryName);
    requestCaller.addParameter(2,"Long",categoryId);
    requestCaller.addParameter(3,"Long",currentUserDomain);
    hasName = requestCaller.serviceRequest();
    if(hasName == 'true'){
    	alert(_("edocLang.edoc_category_name_enable_repeat")+"\r\n"+categoryName);
    }
	return hasName;
}
