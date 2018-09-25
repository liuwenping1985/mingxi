/**新建*/
function newAgent(){
	parent.detailFrame.location.href=detailURL+"?method=createOrUpdateAgent&from=new";
}
/**详细信息*/
function showAgentDetail(id){
	if(v3x.getBrowserFlag('pageBreak')){
		parent.detailFrame.location.href=detailURL+"?method=showAgentDetail&id=" + id;
	}else{
	    v3x.openWindow({
		     url: detailURL+"?method=showAgentDetail&id=" + id,
		     dialogType:"open",
		     workSpace: 'yes'
		});
	}
}
/**修改*/
function updateAgentInfo(id,curtUserId,agentId){
	if(id == undefined){
		var id_checkbox = document.getElementsByName("id");
		var curtUserIds = document.getElementsByName("curtUserId");
		var agentIds = document.getElementsByName("agentId");
	    if (!id_checkbox) {
	        return;
	    }
	    var hasMoreElement = false;
	    var len = id_checkbox.length;
	    var countChecked = 0;
	    for (var i = 0; i < len; i++) {
	        if (id_checkbox[i].checked) {
	        	id = id_checkbox[i].value;
	        	curtUserId = curtUserIds[i].value;
	        	agentId = agentIds[i].value;
	            hasMoreElement = true;
	            countChecked++;
	        }
	    }
	    if (!hasMoreElement) {
	        alert(v3x.getMessage("agentLang.agent_alertModifyItem"));
	        return;
	    }
	    if(countChecked > 1){
	    	alert(v3x.getMessage("agentLang.agent_confirmModifyOnlyOne"));
	        return;
	    }
	}
	//双击
	if(curtUserId===agentId){
	    alert('不能修改委托代理设置！');
	    return ;
	}
	parent.detailFrame.location.href=detailURL+"?method=createOrUpdateAgent&from=modify&id=" + id;
}
/**取消*/
function cancelAgent(){
	var theForm = document.getElementsByName("listForm")[0];
	var id_checkbox = document.getElementsByName("id");
    if (!id_checkbox) {
        return;
    }
    var curtUserIds = document.getElementsByName("curtUserId");
    var agentIds = document.getElementsByName("agentId");
    var hasMoreElement = false;
    var len = id_checkbox.length;
    
    var curtUserId=0;
    var agentId=0;
    var countChecked = 0;
    for (var i = 0; i < len; i++) {
        if (id_checkbox[i].checked) {
        	id = id_checkbox[i].value;
        	curtUserId = curtUserIds[i].value;
            agentId = agentIds[i].value;
            if(curtUserId==agentId){
                alert('不能取消委托代理事项！');
                return ;
            }
            hasMoreElement = true;
            countChecked++;
        }
    }
    if (!hasMoreElement) {
        alert(v3x.getMessage("agentLang.agent_alertCancelItem"));
        return;
    }
	theForm.action = detailURL+"?method=cancelAgent";
    theForm.target = "_self";
    theForm.method = "POST";
    theForm.submit();
}

function showTemplate(obj){
	var templateSpan = document.getElementById("templateSpan");
	if(templateSpan){
		if(obj.checked)
			templateSpan.style.display = "inline";
		else
			templateSpan.style.display = "none";
	}
}

function selectTemplate(type){
	var templateSelect = document.getElementById("templateSelect");
	if(templateSelect){
		if(templateSelect.selectedIndex==1){   //选择已办过的模板
			templateChoose(templateChooseCallback,"1,2",true,"","Done");
//			var ret =v3x.openWindow({
//		    	url: detailURL+"?method=showTempletsFrame&type=" + type,
//				width : 700,
//				height : 470,
//				resizable : false, 
//				dialogType : 'modal'
//			});
//			if(typeof(ret)=='undefined'){
//				cancelSelect();
//			}
		}
		document.getElementById("templateIds").value = templateSelect.value;
		lastSelectIndex = templateSelect.selectedIndex;
	}
}

function templateChooseCallback(ids,names){
    var templateIds = document.getElementById("templateIds");
    if(templateIds){
        templateIds.value = ids;
    }
    var templateSelect = document.getElementById("templateSelect");
    if(templateSelect){
        var option;
        if(templateSelect.options && templateSelect.options.length==3)
            option = templateSelect.options[2];
        else{
            option = document.createElement("OPTION");
            templateSelect.add(option);
        }
        option.text = names;
        option.value = templateIds.value;
        templateSelect.options[2].selected = true;
    }
}

function initSelectedFormTempletes(){
	var templetes = self.dialogArguments.document.getElementsByName("newAffairNode");
	if(templetes && templetes.length>0) {
		var selectNode = document.getElementById("selectNode").options;
		for (var i = 0; i < templetes.length; i++) {
			selectNode.add(new Option(unescape(templetes[i].value), templetes[i].templeteId));
		}
	}
}

//全局数组，载入所选的全部表单模板节点，在每次新操作之前先清空之前的记录
var tempsNodeArray = [];
function selectOne(isMultiSelect){
	var oTargetSel = document.getElementById('selectNode');
	//不支持多选，如果已经选择了一个了，就不能再选择了。
	if(isMultiSelect == false){
		if (oTargetSel.options.length >= 1) {
			alert(v3x.getMessage("V3XLang.common_most_select_one_templete_label"));
			return false;
		}
	}
	var oSelected;
	if(formTemps.tree){
		oSelected = formTemps.tree.getSelected();
	}else{
		if(formTemps.newtree1)
			oSelected = formTemps.newtree1.getSelected();
	}
	if(!oSelected)
		return false;
	//如果用户选中了"表单模板"根节点，给出相应提示，让其选择表单模板或某一应用类型
	if(oSelected.businessId=='0'){
		alert(v3x.getMessage("agentLang.pls_select_category_or_templete"));
		return false;
	}
	//所属应用类型下面如果没有任何表单模板，则跳出提示，不允许移动到右侧
	if(!hasTempletes(oSelected) && !oSelected.isTemplete) {
		alert(v3x.getMessage("agentLang.category_has_no_temps"));
		return false;
	}
	var oSelectNode = document.getElementById('selectNode');
	if(oSelected!=null){
		var sText = oSelected.text;
		var sId = oSelected.businessId;
		var oChildNodes = oSelected.childNodes;		
		//选中应用类型时，将其下的全部表单模板选中	
		if(!oSelected.isTemplete && oChildNodes.length>0){
			getAllFormTempletes(oSelected, tempsNodeArray);
			//不支持多选的情况下不能选择模板数量>1的应用分类。
			if(isMultiSelect == false && tempsNodeArray.length>1){
				alert(v3x.getMessage("V3XLang.common_most_select_one_templete_label"));
				return false;
			}
			if(tempsNodeArray.length>0) {
				for(var i=0;i<tempsNodeArray.length;i++) {
					var tempNode = tempsNodeArray[i];
					addTempNode(tempNode);
				}
			}
		//选中普通表单模板
		}else{
			addTempNode(oSelected);				
		}
	}
	tempsNodeArray.length = 0;	
}
/**
 * 将已选项删除
 */
function removeOne(){
	var oTargetSel = document.getElementById('selectNode');
	var iSelectedIndex = 0;
	for(var k=0; k<oTargetSel.options.length; k++) {
        if(oTargetSel.options[k].selected){
            oTargetSel.removeChild(oTargetSel.options[k]);
            k--;
        }
    }
}
/**
 * 上下移动已选项
 */
function move(direction){
	var list3Object = document.getElementById("selectNode");
	var list3Items = list3Object.options;
	var nowIndex = list3Object.selectedIndex;

	if(direction == "up"){
		if(nowIndex > 0){
			var nowOption = list3Items.item(nowIndex);
			var nextOption = list3Items.item(nowIndex - 1);
			var newOption = new Option(nowOption.text, nowOption.value);
			newOption.selected = true;
			list3Object.add(newOption, nowIndex - 1);
			list3Object.remove(nowIndex + 1);
		}
	}else if(direction == "down"){
		if(nowIndex > -1 && nowIndex < list3Items.length - 1){
			var nowOption = list3Items.item(nowIndex);
			var nextOption = list3Items.item(nowIndex + 1);
			var newOption = new Option(nowOption.text, nowOption.value);
			newOption.selected = true;
			list3Object.add(newOption, nowIndex + 2);
			list3Object.remove(nowIndex);
		}
	}else{
		alert('The direction ' + direction + ' is not defined.');
	}
}

/**
 * 判断一个应用所属类型下面有无表单模板
 */
function hasTempletes(oSelected) {
	var has = false;
	var oChildNodes = oSelected.childNodes;
	if(oSelected.isTemplete) {
		has = true;
	} else {
		if(oChildNodes.length>0) {
			for(var i=0;i<oChildNodes.length;i++) {
				var child = oChildNodes[i];
				if(child.isTemplete) {
					has = true;
					break;
				} else {
					has = hasTempletes(child);
				}
			}
		}
	}
	return has;
}

/**
 * 将一个应用类型下面的全部模板获取并筛选出未选中的模板，设定到数组中去
 */
function getAllFormTempletes(oSelected) {
	var oSelectNode = document.getElementById('selectNode');
	var oChildNodes = oSelected.childNodes;	
	for(var i=0;i<oChildNodes.length;i++) {
		var child = oChildNodes[i];
		if(child.isTemplete) {
			if(existsNot(child, oSelectNode))
				tempsNodeArray[tempsNodeArray.length] = child;
		} else {
			getAllFormTempletes(child);
		}
	}	
}

/**
 * 判断模板是否已被选中添加在右侧列表中：未选中返回true，已选中返回false
 */
function existsNot(templeteNode) {
	var oSelectNode = document.getElementById('selectNode');
	var bFlag = true;
	if(oSelectNode.options.length>0){
		for(var i=0; i<oSelectNode.options.length; i++) {
			if(oSelectNode.options[i].value==templeteNode.businessId){
				bFlag = false;
				break;
			}
		}
	}
	return bFlag;
}

/**
 * 增加模板节点到右边已选项中，先判断其是否已被选中
 */
function addTempNode(tempNode){
	if(existsNot(tempNode)){
		var oOption = document.createElement('option');
		oOption.text = tempNode.text;
		oOption.value = tempNode.businessId;
		if(tempNode.templeteType){
			oOption.setAttribute("type",tempNode.templeteType);
		}
		var oSelectNode = document.getElementById('selectNode');
		oSelectNode.add(oOption);
	} else if(tempNode.isTemplete) {
		alert(v3x.getMessage("agentLang.templete_selected_already"));
	}
}

/**
 * 响应在模板选择界面中搜索框内按回车键时的操作
 */
function searchTempWithKey(type) {
	if(window.event.keyCode==13)
		searchTemp(type);
}

function searchTemp(type) {
	var theForm = document.getElementById("searchForm");
	var url = detailURL+"?method=showTemplets&expand=true&type="+type;
	theForm.action = url;
	theForm.submit();
}

function setTempsBack() {
	var parentObj = self.dialogArguments;
	var list3Object = document.getElementById("selectNode");
	var list3Items = list3Object.options;
	if(list3Items.length < 1) {
		alert(v3x.getMessage("agentLang.pls_select_at_lease_one_templete"));
		return false;
	}
	var ids = "";
	var names = "";
	for(var i=0;i<list3Items.length;i++) {
		ids += list3Items[i].value;
		names += list3Items[i].text;
		if(i!=list3Items.length-1){
			ids += ',';
			names += '、';
		}
	}
	var templateIds = parentObj.document.getElementById("templateIds");
	if(templateIds){
		templateIds.value = ids;
	}
	var templateSelect = parentObj.document.getElementById("templateSelect");
	if(templateSelect){
		var option;
		if(templateSelect.options && templateSelect.options.length==3)
			option = templateSelect.options[2];
		else{
			option = parentObj.document.createElement("OPTION");
			templateSelect.add(option);
		}
		option.text = names;
		option.value = templateIds.value;
		templateSelect.options[2].selected = true;
	}
	window.returnValue = "OK";
	window.close();
}

function closeWindow(){
	var parentObj = self.dialogArguments;
	parentObj.cancelSelect();
	window.close();
}

function cancelSelect(){
	var templateSelect = document.getElementById("templateSelect");
	if(templateSelect && lastSelectIndex<templateSelect.options.length){
		templateSelect.options[lastSelectIndex].selected = true;
	}
}