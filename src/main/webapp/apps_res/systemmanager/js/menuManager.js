/**
 * 新建菜单权限
 */
function newMenuPopedom(){
	parent.detailFrame.location.href = menuManagerURL + "?method=newMenuPopedom";
}

/**
 * 取得所选的一个checkbox的值
 */
function getSelectSecurityId(){
	var popedomIds = document.getElementsByName('securityIds');
	for(var i=0; i<popedomIds.length; i++){
		var idCheckBox = popedomIds[i];
		if(idCheckBox.checked){
			return idCheckBox.value;
		}
	}
}

/**
 * 更新菜单权限
 */
function updateMenuPopedom(securityId){
	var disabled = false;
	if(securityId){
		disabled = true;
		/* 放开系统权限的修改
		var popedomIds = document.getElementsByName('securityIds');
		for(var i=0; i<popedomIds.length; i++){
			var idCheckBox = popedomIds[i];
			if(idCheckBox.value == securityId && idCheckBox.extAttributeType == 0){ //过滤是否是系统权限
			}
		}*/
		parent.detailFrame.location.href = menuManagerURL + "?method=editMenuPopedom&view=view&id=" + securityId + "&disabled=" + disabled;
	}
	else{
		var count = validateCheckbox("securityIds");
		switch(count){
			case 0:
					alert(v3x.getMessage("sysMgrLang.choose_item_from_list"));  
					return false;
					break;
			case 1:
					var id = this.getSelectSecurityId();
					/* 放开系统权限的修改
					var popedomIds = document.getElementsByName('securityIds');
					for(var i=0; i<popedomIds.length; i++){
						var idCheckBox = popedomIds[i];
						if(idCheckBox.value == id && idCheckBox.extAttributeType == 0){ //过滤是否是系统权限
							alert(_("sysMgrLang.menuManager_securityCannotChange"));
							return false;
						}
					}
					*/
					
					parent.detailFrame.location.href = menuManagerURL + "?method=editMenuPopedom&id=" + id + "&disabled=" + disabled;
					break;
			default:
					alert(v3x.getMessage("sysMgrLang.choose_one_only"));
					return false;			
		}
	}
	
}

/**
 * 设为默认菜单权限
 */
function setting2Default(){
	var count = validateCheckbox("securityIds");
	switch(count){
		case 0: 
				alert(v3x.getMessage("sysMgrLang.choose_item_from_list"));  
				return false;
		case 1:
				var popedomIds = document.getElementsByName('securityIds');
				for(var i=0; i<popedomIds.length; i++){
					var idCheckBox = popedomIds[i];
					if(idCheckBox.checked){
						if(idCheckBox.extAttributeState == 1){ //过滤是否存在停用的菜单权限
							alert(_("sysMgrLang.menuManager_securityIsInvalidation", idCheckBox.extAttributeName));
							return false;
						}
					}
				}
				break;
		default:
				alert(v3x.getMessage("sysMgrLang.choose_one_only"));
				return false;
	}
	document.all.method.value = "toDefault";
	document.forms["menuMgrForm"].submit();
}

/**
 * 启用菜单权限
 */
function enableMenuPopedom(){
	var count = validateCheckbox("securityIds");
	if(count <= 0){
		alert(_("sysMgrLang.choose_item_from_list")); 
		return false;
	}
	var theForm = document.forms["menuMgrForm"];
	var popedomIds = document.getElementsByName('securityIds');
	for(var i=0; i<popedomIds.length; i++){
		var idCheckBox = popedomIds[i];
		if(idCheckBox.checked){
			var hiddenObj = document.createElement('<INPUT TYPE="hidden" name="securityNames" value="' + idCheckBox.extAttributeName + '" />');
			theForm.appendChild(hiddenObj);
		}
	}
	document.all.method.value = "enableMenuPopedom";
	theForm.submit();
}
/**
 * 判断默认权限的数量 不大于1 时候 返回true
 */
function defaultMenuEnough(){
	var popedomIds = document.getElementsByName('securityIds');
	var defaultValue = 0;
	var anyChecked = 0;
	for(var i=0; i<popedomIds.length; i++){
		var idCheckBox = popedomIds[i];
		if(idCheckBox.extAttributeDefault == "true" && idCheckBox.extAttributeState == 0){
			defaultValue ++;
			if(idCheckBox.checked){
				anyChecked ++;
			}
		}
	}
	//启用默认权限 为1 单是有选中的
	if(defaultValue <=1 && anyChecked > 0){
		return true;
	}
	//启用默认权限 大于1 但是选中的都是默认权限
	if(defaultValue > 1 && defaultValue == anyChecked){
		return true;
	}
	return false;
}
/**
 * 修改权限时判断该权限是否为启用的默认权限，如果是则不允许停用
 */
function disableEditMenuPopedom(){
	var isEnableDefault = false;
	var popedomIds = parent.listFrame.document.getElementsByName('securityIds');
	for(var i=0; i<popedomIds.length; i++){
		var idCheckBox = popedomIds[i];
		if(idCheckBox.checked && idCheckBox.extAttributeDefault == "true" && idCheckBox.extAttributeState == 0){
			isEnableDefault = true;
		}
	}
	if(isEnableDefault){
		alert(_("sysMgrLang.menuManager_securityCannotDisable"));
		document.getElementById("enabled1").checked = true;
	}
}
/**
 * 停用菜单权限
 */
function disableMenuPopedom(){
	var count = validateCheckbox("securityIds");
	if(count <= 0){
		alert(_("sysMgrLang.choose_item_from_list")); 
		return false;
	}
	//检验是否全部停用
	else if(count >= normalSecurityNum){
		var flagNum = 0;
		var popedomIds = document.getElementsByName('securityIds');
		for(var i=0; i<popedomIds.length; i++){
			var idCheckBox = popedomIds[i];
			if(idCheckBox.checked){
				if(idCheckBox.extAttributeState == 0){
					flagNum++;
				}
			}
		}
		if(flagNum >= normalSecurityNum){
			alert(_("sysMgrLang.menuManager_cannotInvalidationAll"));
			return false;
		}
	}
	
	if(defaultMenuEnough()){//过滤默认权限
		alert(_("sysMgrLang.menuManager_securityCannotDisable"));
		return false;
	}
	var theForm = document.forms["menuMgrForm"];
	var popedomIds = document.getElementsByName('securityIds');
	for(var i=0; i<popedomIds.length; i++){
		var idCheckBox = popedomIds[i];
		if(idCheckBox.checked){
			var hiddenObj = document.createElement('<INPUT TYPE="hidden" name="securityNames" value="' + idCheckBox.extAttributeName + '" />');
			theForm.appendChild(hiddenObj);
		}
	}
	document.all.method.value = "disableMenuPopedom";
	theForm.submit();
}

/**
 * 删除菜单权限
 */
function deleteMenuPopedom(){
	var count = validateCheckbox("securityIds");
	if(count <= 0){
		alert(_("sysMgrLang.choose_item_from_list")); 
		return false;
	}
	else{
		var theForm = document.forms["menuMgrForm"];
		var popedomIds = document.getElementsByName('securityIds');
		for(var i=0; i<popedomIds.length; i++){
			var idCheckBox = popedomIds[i];
			if(idCheckBox.checked){
				if(defaultMenuEnough()){//过滤默认权限
					alert(_("sysMgrLang.menuManager_securityCannotDelete"));
					return false;
				}
				if(idCheckBox.extAttributeType == 0){ //过滤是否是系统权限
					alert(_("sysMgrLang.menuManager_securityCannotChange"));
					return false;
				}
				var hiddenObj = document.createElement('<INPUT TYPE="hidden" name="securityNames" value="' + idCheckBox.extAttributeName + '" />');
				theForm.appendChild(hiddenObj);
			}
		}
		if(confirm(v3x.getMessage("sysMgrLang.delete_sure"))){
			document.all.method.value = "deleteMenuPopedom";
			theForm.submit();
		}
		else{
			return false;
		}
	}
}

	
/**
 * 菜单树的处理
 */
var securityIdsArray = [];

function editMenuSecurityOK(formObj){
	if(checkForm(formObj)){
		//新建时校验重复
		//if(document.all.id.value == ""){
			var qxname=document.all.qxname.value.trim();
			var id=document.all.id.value;
			var securityNameObj = document.all.securityName;
			var existSecurityNames = parent.listFrame.existSecurityNamesArray;
			var sname="";
			if(securityNameObj && existSecurityNames){
				sname=securityNameObj.value.replace(/\s/g,'');
				document.all.securityName.value=sname;
				for(var i = 0; i<existSecurityNames.length; i++){
					if(id=="" && sname == existSecurityNames[i].trim()){
						alert(_("sysMgrLang.checkForm_nameMustNotDuple"));
						securityNameObj.focus();
						return false;
					}
					if(id!="" && sname!=qxname && sname == existSecurityNames[i].trim()){
						alert(_("sysMgrLang.checkForm_nameMustNotDuple"));
						securityNameObj.focus();
						return false;
					}
				}
			}
		//}

		var rootTree = menuTreeFrame.tree;
		if(rootTree){
			getChildrenChecked(rootTree)
		}
		/*
		if(securityIdsArray.length<1){
			alert(_("sysMgrLang.menuManager_mustChooseMenu"));
			return false;
		}*/
		
		var theForm = document.getElementsByName("editMenuForm")[0];
		var hidden;
	   	for(var i=0;i<securityIdsArray.length;i++){
			hidden = document.createElement('<INPUT TYPE="hidden" name="menuIds" value="' + securityIdsArray[i] + '" />');
			theForm.appendChild(hidden);
	    }
	    return true;
	}else{
		return false;		
	}
}

//菜单树递归方法
function getChildrenChecked(node){
	if(node && node.childNodes){
		var children = node.childNodes;
		for(var i = 0; i< children.length; i++){
			var c = children[i];
			if(c.folder){
				getChildrenChecked(c);
			}
			else{
				if(c.getChecked()){
					securityIdsArray[securityIdsArray.length] = c.businessId;
				}
			}
		}
	}
}

/**
 * 空间选中菜单
 */
function checkSpaceMenu(formObj){
	if(document.getElementById("systemMenuTreeFrame")){
		var sysRootTree = systemMenuTreeFrame.tree;
		if(sysRootTree){
			getChildrenChecked4SpaceMenu(sysRootTree);
		}
	}
	
	if(document.getElementById("customMenuTreeFrame")){
		var customRootTree = customMenuTreeFrame.tree;
		if(customRootTree){
			getChildrenChecked4SpaceMenu(customRootTree);
		}
	}
	
	//如果启用空间菜单则至少选择一个菜单
	var isSpaceMenuEnabled = document.getElementById("spaceMenuEnabled1");
	if(isSpaceMenuEnabled && isSpaceMenuEnabled.checked && securityIdsArray.length < 1){
		alert(_("sysMgrLang.space_menu_must_choose"));
		return false;		
	}
	
	for(var i = 0;i < securityIdsArray.length; i ++){
		var menuHiddenIds = document.createElement("input");
		menuHiddenIds.id = 'menuIds';
		menuHiddenIds.name = 'menuIds';
		menuHiddenIds.type = 'hidden';
		menuHiddenIds.value = securityIdsArray[i];
		//hidden = document.createElement("<input type='hidden' id='menuIds' name='menuIds' value='" + securityIdsArray[i] + "' />");
		formObj.appendChild(menuHiddenIds);
	}
	return true;
}

/**
 * 菜单树递归方法
 */
function getChildrenChecked4SpaceMenu(node){
	if(node && node.childNodes){
		var children = node.childNodes;
		for(var i = 0; i < children.length; i ++){
			var c = children[i];
			if(c.getChecked()){
				securityIdsArray[securityIdsArray.length] = c.businessId;
			}
			if(c.folder){
				getChildrenChecked4SpaceMenu(c);
			}
		}
	}
}

/**
 * 人员管理 设置菜单权限 弹出窗口确认
 */
function setSecurityOK(){
	var securityIds = '';
	var securityNames = '';
	var popedomIds = document.getElementsByName('securityIds');
	for(var i=0; i<popedomIds.length; i++){
		var idCheckBox = popedomIds[i];
		if(idCheckBox.checked){
			if(securityIds == ''){
				securityIds = idCheckBox.value;
			}else{
				securityIds += "," + idCheckBox.value;
			}
			if(securityNames == ''){
				securityNames = idCheckBox.extAttributeName;
			}else{
				securityNames += "," + idCheckBox.extAttributeName;
			}
		}
	}
	window.returnValue = [securityIds, securityNames];
	window.close();
}