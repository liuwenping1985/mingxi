var treeImagePath = v3x.baseURL + "/apps_res/taskmanage/images/";
/**
 * 显示或隐藏树形Table的子节点数据
 */
function showHiddenNode(imgObj, trId) {
	var imgSrc = imgObj.src.toLowerCase();
	// 隐藏
	if(imgSrc.indexOf("nolines_minus.gif") != -1) { 
		imgObj.src = treeImagePath + "nolines_plus.gif";
		jQuery("tr[id^=" + trId + ".]").css("display", "none");
	} 
	// 显示
	else { 
		imgObj.src = treeImagePath + "nolines_minus.gif";
		
		// 显示第一层的子节点
		var trs = jQuery("tr[pid=" + trId + "]");
		trs.css("display", "");
		
		// 显示更深层的子节点
		for(var i=0; i < trs.length; i++) {
			showHiddenSub(trs[i].id);
		}
	}
}
/**
 * 递归检查下一级节点是否需要显示
 */
function showHiddenSub(trId) {
	var imgObj = document.getElementById("IMG_" + trId.replace("TR_",""));
	if(imgObj == null) 
		return;
	
	var imgSrc = imgObj.src.toLowerCase();
	// 下级节点是展开的，则需要显示出来
	if(imgSrc.indexOf("nolines_minus.gif") != -1){
		var trs = jQuery("tr[pid=" + trId + "]");
		trs.css("display", "");
		
		for(var i = 0; i < trs.length; i++){
			showHiddenSub(trs[i].id);
		}
	}
}
function select(anchorObj) {
	selectSingle(anchorObj);
	unSelect(anchorObj.id);
}
function unSelect(selectedId) {
	var anchors = jQuery("a");
	for(var i = 0; i < anchors.length; i++) {
		if(anchors[i].id != selectedId) {
			anchors[i].style.background = "";
			anchors[i].style.color = "";
		}
	}
	
	var spans = jQuery("span");
	for(var i = 0; i < spans.length; i++) {
		if(spans[i].id != selectedId) {
			spans[i].style.background = "";
			spans[i].style.color = "";
		}
	}
}
function selectSingle(anchorObj) {
	anchorObj.style.background = "highlight";
	anchorObj.style.color = "highlighttext";
}
function initSelect(taskId) {
	var obj = document.getElementById('anchor-' + taskId);
	selectSingle(obj);
}