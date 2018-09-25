var isOpereaDel = false;
/**
 * 新建
 */
function addProject(url){
	parent.detailFrame.location.href=url;
}
/**
 * 修改
 */
function editProject(){
	var id = getSelectId(v3x.getMessage("ProjectLang.please_choose_one_data"), v3x.getMessage("ProjectLang.please_choose_one_data"));
	if(!id){
		return;
	}else{
		if(managerMap.get(id).contains(sessionScopeParam)){
			if(stateMap.get(id)==2||stateMap.get(id)==3){
				alert(v3x.getMessage("ProjectLang.project_can_not_edit"));
				return;
			}
			parent.detailFrame.location.href = basicURLParam+"?method=detailProject&update=update&showModalWindows=showWindows&listorpop=0&projectId="+id;
		}else{
			alert(v3x.getMessage("ProjectLang.you_are_not_manager_or_builder"));
			return;
		}
	}
}
/**
 * 删除
 */
function delProject(){
  if(isOpereaDel == true || isOpereaDel == "true") {
    return;
  }
	var ids = getSelectIds();
	if(ids == ''){
		alert(v3x.getMessage("ProjectLang.choose_item_from_list"));
		return;
	}
	
	var idsArr = ids.split(",");
	
	for(var i = 0 ; i < idsArr.length - 1 ; i++){
		if(!managerMap.get(idsArr[i]).contains(sessionScopeParam)){
			alert(v3x.getMessage("ProjectLang.you_are_not_manager_or_builder"));
			return;
		}
		if(stateMap.get(idsArr[i])==0||stateMap.get(idsArr[i])==1){
			alert(v3x.getMessage("ProjectLang.project_can_not_delete"));
			return;
		}
	}
	
	if(confirm(v3x.getMessage("ProjectLang.sure_to_delete"))){
		document.location.href =basicURLParam+"?method=removeProject&projectId="+ids;
		getA8Top().initSpaceNavigationNoDisplay();
		isOpereaDel = true;
	}
}

function projectLog(){
	var id = getSelectId();
	if(id == ''){
		alert(v3x.getMessage("ProjectLang.choose_item_from_list"));
		return;
	}else if(validateCheckbox("id")>1){
		alert(v3x.getMessage("ProjectLang.please_choose_one_data"));
		return;
	}
    var projectName = projectNameMap.get(id);
   	parent.detailFrame.location.href =basicURLParam+"?method=getProjectLog&projectId="+id+"&projectName="+encodeURI(projectName);
}
/**
 * 双击列表
 */
function doubleClick(id){
	if(managerMap.get(id).contains(sessionScopeParam)){
		if(stateMap.get(id)==2||stateMap.get(id)==3){
			alert(v3x.getMessage("ProjectLang.project_can_not_edit"));
			return;
		}
		if(v3x.getBrowserFlag('OpenDivWindow')){
			parent.detailFrame.location.href = basicURLParam+"?method=detailProject&update=update&showModalWindows=showWindows&listorpop=0&projectId="+id;
		}else{
			//ipad查看弹出
		    v3x.openWindow({
			     url: basicURLParam+"?method=getProject&projectId="+id,
			     dialogType:"open",
			     workSpace: 'yes'
			});
		}
	}else{
		alert(v3x.getMessage("ProjectLang.you_are_not_manager_or_builder"));
		return;
	}
}
		  