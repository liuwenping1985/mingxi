<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<script type="text/javascript">
var xmlString = "";
var dialogParam =window.parentDialogObj["formInputChooseRenameDialog"].getTransParams();;
var parentWin=dialogParam[0].document;
var RightData=dialogParam[1];
var type = dialogParam[2];
function showlabelvalue(){
  /*var parent = window.dialogArguments.document;
  var formDataArea = parent.getElementById("formdataarea");
  var labelObj = document.getElementById("rowheader");
  var titleObj = document.getElementById("title");
  if(formDataArea.selectedIndex < 0)
	  return;
  else
     labelObj.innerText = formDataArea.options[formDataArea.selectedIndex].text;
     titleObj.value = formDataArea.options[formDataArea.selectedIndex].text;
     */
  var querytext = "";
  var queryDataArea = parentWin.getElementById("rightdataarea");
  var labelObj = document.getElementById("rowheader");
  var titleObj = document.getElementById("title");
  if(queryDataArea.selectedIndex < 0)
	  return;
  else{
      querytext = queryDataArea.options[queryDataArea.selectedIndex].text;
      if(querytext.indexOf("(") !=-1){
         labelObj.innerText = querytext.substring(0,querytext.indexOf("("));
         titleObj.value =  querytext.substring(querytext.indexOf("(")+1,querytext.indexOf(")"));
      }
      else {
         labelObj.innerText = querytext;
         titleObj.value =  querytext;
      }
  }
}

$(document).ready(function(){
  showlabelvalue();
});

//去掉空格
String.prototype.Trim = function(){
  return   this.replace(/(^\s*)|(\s*$)/g,"");
}

function OK(){
	//$("#myfrm").validate();
   var labelObj = document.getElementById("rowheader");
   var titleObj = document.getElementById("title");
   var queryDataArea = parentWin.getElementById("rightdataarea");
   var slectData=queryDataArea.options[queryDataArea.selectedIndex];
	if(labelObj.innerText == ""){
		return 'false';
	}else{
	    if(titleObj.value.Trim() != ""){
			if(len(titleObj.value.Trim())>255){
				return "${ctp:i18n('form.forminputchoose.lengtherror')}";
			}
			if(labelObj.innerText.Trim() == titleObj.value.Trim()){
				if(isMark(labelObj.innerText) == true){
				  return "${ctp:i18n('form.forminputchoose.inputerror')}";
			    }
				if(isContainsValue(slectData.value,titleObj.value.Trim())){
					if(type == 1){//自定义查询
						return "${ctp:i18n('form.forminputchoose.customersear.error')}";
					}else if(type == 11){//自定义统计
					    return "${ctp:i18n('form.forminputchoose.customersear.reporterror')}";
					}else{
					   return "${ctp:i18n('form.forminputchoose.notallowsamename')}";
					}
				 }else{
					   slectData.text=labelObj.innerText.Trim();
				RightData.put(slectData.value,labelObj.innerText.Trim());
				return 'true';
				   }
			}else{
			   if(isMark(titleObj.value.Trim()) == true){
				  return "${ctp:i18n('form.forminputchoose.inputerror')}";
			   }
			   if(isContainsValue(slectData.value,titleObj.value.Trim())){
				   if (type == 1){
					   return "${ctp:i18n('form.forminputchoose.customersear.error')}";
				   }else if(type == 11){//自定义统计
                       return "${ctp:i18n('form.forminputchoose.customersear.reporterror')}";
                   }else{
                      return "${ctp:i18n('form.forminputchoose.notallowsamename')}";
                   }
			   }else{
				   slectData.text=labelObj.innerText + "(" + titleObj.value.Trim() + ")";
				   RightData.put(slectData.value,titleObj.value.Trim());
				   return 'true';
			   }
			}
		}else{
		  return "${ctp:i18n('form.forminputchoose.titlecantnull')}";
		}
	}
}
function  isMark(str){
		   var myReg = /[\\:,()|<>\/|\'\"?#$%&\^\*]/;
           if(myReg.test(str))
        	   {
        	   return true;
        	   }
           return false;
	   }
	   //取得字符串长度,汉字占3个长度
function len(str) {
    ///<summary>获得字符串实际长度，中文2，英文1</summary>
    ///<param name="str">要获得长度的字符串</param>
    var realLength = 0, len = str.length, charCode = -1;
    for (var i = 0; i < len; i++) {
        charCode = str.charCodeAt(i);
        if (charCode >= 0 && charCode <= 128) realLength += 1;
        else realLength += 3;
    }
    return realLength;
		   }

function isContainsValue(key,value) {
	//先把要排除的移除掉
	var temp=RightData.get(key);
	RightData.remove(key);
	var values = RightData.values();
	for ( var i = 0; i < values.size(); i++) {
		if (values.get(i)==value) {
			RightData.put(key,temp);//值补上
			return true;
		}
	}
	RightData.put(key,temp);//值补上
	return false;
}
	   </script>