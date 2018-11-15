<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<script type="text/javascript">
var master = "";
var slave = "";
var count = 0;
var name = "";
var flag = false;
var parentDoc = window.dialogArguments.window.document;
var orderMap = new Properties();// 定义排序Map,key:排序字段，value：排序方式

function getValueByKey(key) {
	if (fieldNamesMap.containsKey(key)) {
		key = fieldNamesMap.get(key);
	}
	return key;
}

function getKeyByValue(value) {
	var key;
	var list = fieldNamesMap.keys();
	for (var k = 0; k < list.size(); k++) {
		key = list.get(k);
		if (value == fieldNamesMap.get(key))
			return key;
	}
	return value;
}

//通过value获取展示值
function getDisplayNameByValue(value){
	var name = "";
	if (displayNameMap.containsKey(value)) {
		name = displayNameMap.get(value);
	}
	return name;
}

function getTableNameByValue(value){
	var dataareaObj=document.getElementById("formdataarea");
	for(var i=0;i<dataareaObj.length;i++){
		if(value==dataareaObj.options[i].value){
			return $(dataareaObj.options[i]).attr("table");
		}
	}
}
function show(){
	var textObj = parentDoc.getElementById("uniquedatafield");
	var titlevalue = "";// 标题
	var dataareavalue = "";
	var value = textObj.value;
	if (value != "") {
	    var temp = value.split(";");
	    for (var j = 0; j < temp.length; j++) {
	      if(!temp[j]){
	        continue;
	      }
	      var testvalues = temp[j].split(",");
	      var target = $("#uniquedataarea"+(j+1));
	      for (var i = 0; i <= testvalues.length - 1; i++) {
	        if (fieldCanShow(testvalues[i])){
	          
		        //var titleStr = getKeyByValue(testvalues[i]);
				var titleStr = getDisplayNameByValue(testvalues[i]);
		        var tableName=getTableNameByValue(testvalues[i]);
		        target.append("<option value='"+testvalues[i]+"' tableName='"+tableName+"'>"+titleStr+"</option>");
	        }
	      }
	    }
}
}
//判断是否可以显示该字段，如果所有数据域列表中没有改字段时，返回false
function fieldCanShow(fieldName){
  return $("#formdataarea").find("[value="+fieldName+"]").length == 1;
}
function selecttoright() {
	if (!currentDiv){
	  return;
	}
	var uniqueDataArea = currentDiv.find("[id^=uniquedataarea]");
	var selectObj =$("#formdataarea");
	if (selectObj[0].selectedIndex > -1) {
			var selectoptions = $("option",selectObj);//selectObj.options;
			for (var i = 0; i < selectoptions.length; i++) {
				if (selectoptions[i].selected == true) {
					var op = $("option",uniqueDataArea);
					for (var j = 0; j < op.length; j++) {
						var uniquedatavalue = op[j].value;
						if (uniquedatavalue.indexOf("(") > -1)
							uniquedatavalue = op[j].value.substring(0,op[j].value.indexOf("("));
						if (selectoptions[i].value == uniquedatavalue) {
							//alert(selectoptions[i].text +v3x.getMessage("formLang.formcreate_fieldisexits"));
							$.alert('['+selectoptions[i].text+']'+"${ctp:i18n('form.unique.marked.fieldisexits')}");
							return;
						}
					}
				}
			}
			for (var i = 0; i < selectoptions.length; i++) {
				if (selectoptions[i].selected == true) {
					uniqueDataArea.append("<option value='"+selectoptions[i].value+"' tableName='"+$(selectoptions[i]).attr("table")+"'>"+selectoptions[i].text+"</option>");
				}
			}
	}
}

function removeOption(selobj) {
	if (selobj[0].selectedIndex > -1) {
		selobj[0].remove(selobj[0].selectedIndex);
		removeOption(selobj);
	}
}

function delOption() {
	  if (!currentDiv){
	    return;
	  }
	var selectObj = currentDiv.find("[id^=uniquedataarea]");
	removeOption(selectObj);
}

function upordown(nDir) {
	  if (!currentDiv){
	    return;
	  }
	  var selectObj = currentDiv.find("[id^=uniquedataarea]")[0];
	if (selectObj.selectedIndex < 0)
		return;
	if (nDir < 0) {
		if (selectObj.selectedIndex == 0)
			return;
	} else {
		if (selectObj.selectedIndex == selectObj.options.length - 1)
			return;
	}
	var opt = selectObj.options[selectObj.selectedIndex];
	var otheropt = selectObj.options[selectObj.selectedIndex + nDir];

	var text = opt.text;
	var value = opt.value;
	var tableName=opt.tableName;
	opt.text = otheropt.text;
	opt.value = otheropt.value;
	opt.tableName = otheropt.tableName;
	otheropt.text = text;
	otheropt.value = value;
	otheropt.tableName = tableName;
	selectObj.selectedIndex += nDir;

	// 根据顺序重新拼xml字符串
	for (var i = 0; i < selectObj.options.length; i++) {
		if (selectObj.options[i].text.indexOf("(") > -1) {
			dataareavalue = selectObj.options[i].text.substring(0,
					selectObj.options[i].text.indexOf("("));
			if (selectObj.options[i].text.indexOf("&") > -1)
				titlevalue = selectObj.options[i].innerHTML.substring(
						selectObj.options[i].innerHTML.indexOf("(") + 1,
						selectObj.options[i].innerHTML.indexOf(")"));
			else
				titlevalue = selectObj.options[i].text.substring(
						selectObj.options[i].text.indexOf("(") + 1,
						selectObj.options[i].text.indexOf(")"));
			var titleStr = getKeyByValue(dataareavalue);
			var nameStr;
			if (fieldNamesMap.containsKey(titleStr)) {
				nameStr = titleStr;
			} else {
				nameStr = dataareavalue;
			}
		} else {
			var nameStr = selectObj.options[i].text;
			var titleStr = getKeyByValue(selectObj.options[i].text);
			if (fieldNamesMap.containsKey(titleStr)) {
				nameStr = titleStr;
			} else {
				nameStr = selectObj.options[i].text;
			}
		}
	}
}

function OK(jsonParam){
	return enterclick(jsonParam.isAdd);
}

function enterclick() {
  var dataManager = new formDataManager();
  var result = true;
  var resultStr = "";
  $("div[class*=table]").each(function(){
    var dataarea = $(this).find("[id^='uniquedataarea']");
    var fieldStr = "";
    if (dataarea.find("option").length > 0){
      if (!checkNumberOfReapetTable($(this))){
        result = false;
        return false;
      }
      dataarea.find("option").each(function(index){
        var fieldName = $(this).val();
        if(index==0){
          fieldStr += fieldName;
      }else{
          fieldStr += ","+fieldName;
      }
      });
      if(fieldStr){
          resultStr = resultStr + fieldStr + ";";
      }
          if(window.dialogArguments.window.isHasData){
            var success = dataManager.isFieldHasUniqueMarked(fieldStr);
            if(!success){
                return true;
            }else{
                $.alert('${ctp:i18n("form.unique.marked.hasdata")}');
                result = false;
                return false;
            }
        }else{
            //当选中唯一标识只有一个时，将数据唯一勾选。
            return true;
        }
    } else {
      if($("div[class*=table]").length != 1){
          if(resultStr){
              resultStr = resultStr + ";";
          }
      }
    }
  });
  result = result && checkSelectedIsSame(resultStr);
  if (result){
        parentDoc.getElementById("uniquedatafield").value = resultStr;
  }
  return result;
}


function checkSelectedIsSame(resultStr){
  if (resultStr.indexOf(";") == -1){
    return true;
  }
  var list = resultStr.split(";");
  for(var i=0; i < list.length; i++){
    var str1 = list[i];
    for(var j=i+1; j < list.length; j++){
      if (!str1 || !list[j]){
        continue;
      }
      if (str1.length != list[j].length){
        continue;
      }
      var str2 = list[j].split(",");
      str1 = list[i];
      str1 = str1.replace(/,/g,"");
      for(var k=0; k < str2.length; k++){
        if (!str1){
          break;
        }
        str1 = str1.replace(str2[k],"");
      }
      if (!str1){
        $.alert("${ctp:i18n('form.unique.marked.notonly')}");
        return false;
      }
    }
  }
  return true;
}
function checkNumberOfReapetTable(obj){
	var dataareaObj = obj.find("[id^='uniquedataarea']");
	var tableNameMap= new Properties();
	var isContainsMainTable=false;
	dataareaObj.find("option").each(function(){
	    var tableName=$(this).attr("tableName");
		tableNameMap.put(tableName, tableName);
		var tableStart=tableName.substring(0,8);
		if(tableStart=="formmain"){
			isContainsMainTable=true;
		}
		if(!tableNameMap.containsKey(tableName)){
			tableNameMap.put(tableName, tableName);
		}
	  });
	if(isContainsMainTable && tableNameMap.keys().size()<=2){
		return true;
	}else if( !isContainsMainTable && tableNameMap.keys().size()<=1 ){
		return true;
	}else{
		$.alert(obj.find("[type='title']").text()+"${ctp:i18n('form.unique.marked.notone')}");
		return false;
	}
}
</script>