/**
 * 文件描述：关于list列表框的一些工具方法
 * 使选中的项目上移
 *
 * oSelect: 源列表框
 * isToTop: 是否移至选择项到顶端，其它依次下移，
 *          true为移动到顶端，false反之，默认为false
 */
function moveUp(objStartStr)
{
    var oSelect = document.getElementById(objStartStr+"TargetSelect");
    var selectCount = 0;
    for(var selIndex=0; selIndex<oSelect.options.length; selIndex++){
        if(oSelect.options[selIndex].selected){
        	selectCount++;
        }
    } 
    //如果是多选------------------------------------------------------------------
    if(selectCount > 1)
    {
        for(var selIndex=0; selIndex<oSelect.options.length; selIndex++)
        {
            if(oSelect.options[selIndex].selected)
            {
                if(selIndex > 0)
                {
                    if(!oSelect.options[selIndex - 1].selected){
                    	var textTemp = oSelect.options[selIndex-1].text;
                    	var valueTemp = oSelect.options[selIndex-1].value;
                    	oSelect.options[selIndex-1].text = oSelect.options[selIndex].text;
                    	oSelect.options[selIndex-1].value = oSelect.options[selIndex].value;
                    	oSelect.options[selIndex].text = textTemp;
                    	oSelect.options[selIndex].value = valueTemp;
                    	oSelect.options[selIndex-1].selected = true;
                    	oSelect.options[selIndex].selected = false;
                    	}
                        //oSelect.options[selIndex].swapNode(oSelect.options[selIndex - 1]);
                }
            }
        }
    }
    //如果是单选--------------------------------------------------------------------
    else if(selectCount == 1)
    {
        var selIndex = oSelect.selectedIndex;
        if(selIndex >= 1){
        	var textTemp = oSelect.options[selIndex-1].text;
        	var valueTemp = oSelect.options[selIndex-1].value;
        	oSelect.options[selIndex-1].text = oSelect.options[selIndex].text;
        	oSelect.options[selIndex-1].value = oSelect.options[selIndex].value;
        	oSelect.options[selIndex].text = textTemp;
        	oSelect.options[selIndex].value = valueTemp;
        	oSelect.options[selIndex-1].selected = true;
        	oSelect.options[selIndex].selected = false;
        }
    }
}

/**
 * 使选中的项目下移
 *
 * oSelect: 源列表框
 * isToTop: 是否移至选择项到底端，其它依次上移，
 *          true为移动到底端，false反之，默认为false
 */
function moveDown(objStartStr)
{
	var oSelect = document.getElementById(objStartStr+"TargetSelect");
    var selLength = oSelect.options.length - 1;
    var selectCount = 0;
    for(var selIndex=0; selIndex<oSelect.options.length; selIndex++){
        if(oSelect.options[selIndex].selected){
        	selectCount++;
        }
    } 
    //如果是多选------------------------------------------------------------------
    if(selectCount > 1)
    {
        for(var selIndex=oSelect.options.length - 1; selIndex>= 0; selIndex--)
        {
           if(oSelect.options[selIndex].selected)
                {
                    if(selIndex < selLength)
                    {
                        if(!oSelect.options[selIndex + 1].selected){
	                    	var textTemp = oSelect.options[selIndex+1].text;
	                    	var valueTemp = oSelect.options[selIndex+1].value;
	                    	oSelect.options[selIndex+1].text = oSelect.options[selIndex].text;
	                    	oSelect.options[selIndex+1].value = oSelect.options[selIndex].value;
	                    	oSelect.options[selIndex].text = textTemp;
	                    	oSelect.options[selIndex].value = valueTemp;
	                    	oSelect.options[selIndex+1].selected = true;
	                    	oSelect.options[selIndex].selected = false;
                        }
                            //oSelect.options[selIndex].swapNode(oSelect.options[selIndex + 1]);
                    }
                }
        }
    }
    //如果是单选--------------------------------------------------------------------
    else if(selectCount == 1)
    {
        var selIndex = oSelect.selectedIndex;
        if(selIndex < selLength){
        	var textTemp = oSelect.options[selIndex+1].text;
        	var valueTemp = oSelect.options[selIndex+1].value;
        	oSelect.options[selIndex+1].text = oSelect.options[selIndex].text;
        	oSelect.options[selIndex+1].value = oSelect.options[selIndex].value;
        	oSelect.options[selIndex].text = textTemp;
        	oSelect.options[selIndex].value = valueTemp;
        	oSelect.options[selIndex+1].selected = true;
        	oSelect.options[selIndex].selected = false;
        }
    }
}

/**
 * 移动select的部分内容,必须存在value，此函数以value为标准进行移动
 * oSourceSel: 源列表框对象 
 * oTargetSel: 目的列表框对象
 */
function addThisItem(objStartStr)
{
	var oSourceSel = document.getElementById(objStartStr+"SourceSelect");
	var oTargetSel = document.getElementById(objStartStr+"TargetSelect");
    //建立存储value和text的缓存数组
    var arrSelValue = new Array();
    var arrSelText = new Array();
    var index = 0;//用来辅助建立缓存数组
    
    //最大可选值
    var maxNum = 20;
    if(objStartStr == "shortcut"){
    	maxNum = 6;
    }
    else if(objStartStr == "tools"){
    	maxNum = 4;
    }
    var iSelectedIndex = 0;
    //存储源列表框中所有的数据到缓存中，并建立value和选中option的对应关系
    for(var i=0; i<oSourceSel.options.length; i++)
    {
        if(oSourceSel.options[i].selected){   
        	iSelectedIndex = oSourceSel.selectedIndex;
			arrSelValue[index] = oSourceSel.options[i].value;
			arrSelText[index] = oSourceSel.options[i].text;
			index ++;
        }
    }
    if((objStartStr != "menu") && ((index + oTargetSel.options.length)>maxNum)){
	    alert(v3x.getMessage("MainLang.shortcut_alert_select_too_more",maxNum));
	    addOption(maxNum-oTargetSel.options.length);
	}else{
		addOption(index);
	}
	if(iSelectedIndex>oSourceSel.options.length-1){
		iSelectedIndex=oSourceSel.options.length-1;
	}
	if(oSourceSel.options.length>iSelectedIndex && iSelectedIndex!=-1){
		setTimeout(function(){oSourceSel.options[iSelectedIndex].selected=true;},1);
	}
	function addOption(maxNum){
	    for(var i=0; i<maxNum; i++){
	      var oOption = document.createElement("option");
	      oOption.text = arrSelText[i];
	      oOption.value = arrSelValue[i];
	      oTargetSel.options.add(oOption);
	      for(var j=0; j<oSourceSel.options.length; j++){
	        var option = oSourceSel.options[j];
	        if(option.text == arrSelText[i] && option.value == arrSelValue[i]){
	 		     oSourceSel.removeChild(oSourceSel.options[j]);
				 j--;
	        }
	      }
	   }
    }
}

function removeThisItem(objStartStr)
{
	var oSourceSel = document.getElementById(objStartStr+"SourceSelect");
	var oTargetSel = document.getElementById(objStartStr+"TargetSelect");
	var iSelectedIndex = 0;
	for(var i=0; i<oTargetSel.options.length; i++)
    {
        if(oTargetSel.options[i].selected)
        {
        	/* 保护 个人事务 不被移除
        	if(objStartStr == "menu" && oTargetSel.options[i].value == "8"){
        		alert(v3x.getMessage("MainLang.menu_cannot_remove", oTargetSel.options[i].text));
        		break;
        	}
        	*/
        	iSelectedIndex = oTargetSel.selectedIndex;
            var oOption = document.createElement("option");
	      	oOption.text = oTargetSel.options[i].text;
	      	oOption.value = oTargetSel.options[i].value;
	      	
            oTargetSel.removeChild(oTargetSel.options[i]);            
            oSourceSel.options.add(oOption);
            
            i--;
        }
    }
	if(iSelectedIndex>oTargetSel.options.length-1){
		iSelectedIndex=oTargetSel.options.length-1;
	}
	if(oTargetSel.options.length>0){
		setTimeout(function(){oTargetSel.options[iSelectedIndex].selected=true;},1);
	}
}

/**
 * 点击确定按钮
 */
function shortcutAndToolsSetOk(){
	document.getElementById("submitButton").disabled = true;
	//快捷设置
	var shortcutSelectObj = document.getElementById("shortcutTargetSelect");
	var str1 = "";
	if(shortcutSelectObj){
		for(var i=0; i<shortcutSelectObj.options.length; i++)
		{
			str1 += shortcutSelectObj.options[i].value;
		 	if(i!=shortcutSelectObj.options.length-1) str1 += ",";
		}
		document.getElementById("shortcutSetStr").value = str1;
	}
	//工具栏设置
	var toolsSelectObj = document.getElementById("toolsTargetSelect");
	var str2 = "";
	if(toolsSelectObj){
		for(var i=0; i<toolsSelectObj.options.length; i++)
		{
			str2 += toolsSelectObj.options[i].value;
		 	if(i!=toolsSelectObj.options.length-1) str2 += ",";
		}
		document.getElementById("toolsSetStr").value = str2;
	}
}

/**
 * 菜单设置点击提交
 */
function settingMenuOk(){
	document.getElementById("submitButton").disabled = true;
	//菜单排序
	var menuSpareSelectObj = document.getElementById("menuTargetSelect");
	var str1 = "";
	if(menuSpareSelectObj){
		if(menuSpareSelectObj.options.length > 0){
			for(var i=0; i<menuSpareSelectObj.options.length; i++){
				str1 += menuSpareSelectObj.options[i].value;
			 	if(i!=menuSpareSelectObj.options.length-1) str1 += ",";
			}
			document.getElementById("menuSpareIds").value = str1;	
			return true;
		}
		else{
			//不允许为空
			alert(_('MainLang.menu_connot_null'));
			document.getElementById("submitButton").disabled = false;
			return false;
		}
	}
	return false;
}
