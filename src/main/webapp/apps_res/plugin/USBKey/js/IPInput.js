/**
 * IP地址输入控件, 支持输入*或0-255
 * added by Mazc 08-01-23
 */
 
/*
 * 检验输入IP是否合法 
 * str 是否是 *或[0-255整数]类型
 */
function IsByte(str)
{
	if (str.replace(/[0-9\*]/gi, "") != ""){
		return false;
	}
	switch(str.length){
		case 0:
		case 1:
				return true;
				break;
		case 2: 
				var c1 = str.substring(0,1);
				var c2 = str.substring(1,2);
				if(str.indexOf("*") == 0){
					if(c2=="*"){
						return false;
					}
				}
				else{
					 if(c1 == "0"){
						return false;
					 }
				}
				return true;
				break;
		case 3:
				var c12 = str.substring(0,2);
				var c3 = str.substring(2,3);
				if(c12.indexOf("*") != -1){
					if(c3=="*"){
						return false;
					}
					if(c12.indexOf("*")==1){
						if(parseInt(c12.substring(0,1))>2){
							return false;
						}
					}
				}
				else{
					 if(parseInt(c12)>25 || (c12=="25" && parseInt(c3)>5)){
						return false;
					 }
				}
				return true;
				break;
		default: 
				return false;
				break;
	}
}

//IP地址控件类
function CIP(ipCtrlIdStr, objNameStr){
    this.ipCtrlIdStr = ipCtrlIdStr;
    this.ipCtrlId = document.getElementById(this.ipCtrlIdStr);
    this.objNameStr = objNameStr;
    
    this.ipFldArr = new Array("", "", "", "");//实时IP字段值
    
    this.create = CIPCreate;
    this.onPropertyChng = onPropertyChng;
    this.onIPFldKeyDown = onIPFldKeyDown;
    this.prevIPFld = prevIPFld;
    this.nextIPFld = nextIPFld;
    this.setIPValue = setIPValue;
    this.getIPValue = getIPValue;
}

//构造函数
function CIPCreate(){
    var str = "";
    str += "<div class=\"fld\"><input type=\"text\" value=\"\" size=\"2\" id=\"" + this.ipCtrlIdStr + "_ipfld_1\"" +
           " onkeydown=\"javascript:" + this.objNameStr + ".onIPFldKeyDown(1);\"></div>" +
           "<div class=\"fldDot\"><b>.</b></div>" +
           "<div class=\"fld\"><input type=\"text\"  value=\"\"  size=\"3\" id=\"" + this.ipCtrlIdStr + "_ipfld_2\"" +
           " onkeydown=\"javascript:" + this.objNameStr + ".onIPFldKeyDown(2);\"></div>" +
           "<div class=\"fldDot\"><b>.</b></div>" +
           "<div class=\"fld\"><input type=\"text\"  value=\"\"  size=\"3\" id=\"" + this.ipCtrlIdStr + "_ipfld_3\"" +
           " onkeydown=\"javascript:" + this.objNameStr + ".onIPFldKeyDown(3);\"></div>" +
           "<div class=\"fldDot\"><b>.</b></div>" +
           "<div class=\"fld\"><input type=\"text\"  value=\"\"  size=\"3\" id=\"" + this.ipCtrlIdStr + "_ipfld_4\"" +
           " onkeydown=\"javascript:" + this.objNameStr + ".onIPFldKeyDown(4);\"></div>"
    this.ipCtrlId.innerHTML = str;
    setInterval(this.objNameStr + ".onPropertyChng()", 10);
}

//确保不输入无效字符
function onPropertyChng(){
    for (var i=1; i<=4; i++){
        var e = document.getElementById(this.ipCtrlIdStr + "_ipfld_" + i);
        var str = e.value;
        if (!IsByte(str)){
            e.value = this.ipFldArr[i-1];
        }
        else{
            this.ipFldArr[i-1] = e.value;
        }
    }
}

//响应箭头和点号"."按键，以使光标在各字段格间移动
function onIPFldKeyDown(curFldIndex){
    if (event.keyCode == 37){
        //按下向左键
        this.prevIPFld(curFldIndex);
        event.returnValue = false;
    }
    else if (event.keyCode==39 || event.keyCode==110 || event.keyCode==190){
        //按下向右键或句号键
        this.nextIPFld(curFldIndex);
        event.returnValue = false;
    }
}

//下一个字段格
function prevIPFld(curFldIndex){
    if (curFldIndex > 1){
        document.getElementById(this.ipCtrlIdStr + "_ipfld_" + (--curFldIndex)).select();
    }
}

//上一个字段格
function nextIPFld(curFldIndex){
    if (curFldIndex < 4){
        document.getElementById(this.ipCtrlIdStr + "_ipfld_" + (++curFldIndex)).select();
    }
}

/** 
 * 设置 IP 值
 * 成功返回 true
 * 失败返回 false，不改变原设置值
 */
function setIPValue(ipValue){
    var ipFldArr = ipValue.split(".");
    if (ipFldArr.length != 4){
        return false;
    }
    else if (!IsByte(ipFldArr[0]) || !IsByte(ipFldArr[1]) || !IsByte(ipFldArr[2]) || !IsByte(ipFldArr[3])){
        return false;
    }
    
    document.getElementById(this.ipCtrlIdStr + "_ipfld_1").value = ipFldArr[0];
    document.getElementById(this.ipCtrlIdStr + "_ipfld_2").value = ipFldArr[1];
    document.getElementById(this.ipCtrlIdStr + "_ipfld_3").value = ipFldArr[2];
    document.getElementById(this.ipCtrlIdStr + "_ipfld_4").value = ipFldArr[3];
    
    return true;
}

//获取 IP 值，IP 值无效，则返回零长度字符串
function getIPValue(){
    var fld_1 = document.getElementById(this.ipCtrlIdStr + "_ipfld_1").value;
    var fld_2 = document.getElementById(this.ipCtrlIdStr + "_ipfld_2").value;
    var fld_3 = document.getElementById(this.ipCtrlIdStr + "_ipfld_3").value;
    var fld_4 = document.getElementById(this.ipCtrlIdStr + "_ipfld_4").value;
    if(fld_1=="" || fld_2=="" || fld_3=="" || fld_4==""){
    	return "";
    }
    else{
    	document.getElementById(this.ipCtrlIdStr + "_ipfld_1").value="";
   		document.getElementById(this.ipCtrlIdStr + "_ipfld_2").value="";
   		document.getElementById(this.ipCtrlIdStr + "_ipfld_3").value="";
    	document.getElementById(this.ipCtrlIdStr + "_ipfld_4").value="";
    	return fld_1 + "." + fld_2 + "." + fld_3 + "." + fld_4;
    }
}