<%--
 $Author: wangfeng $
 $Rev: 261 $
 $Date:: 2013-3-17 14:00:30#$:
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page import="com.seeyon.ctp.form.modules.engin.formula.FormulaEnums"%>
<script type="text/javascript">
var formulaAreaPos = {'startPos':-1,'endPos':-1};//公式录入框记录光标位置对象


//在光标处插入文本
function setText(str){//alert(formulaAreaPos.startPos+"|"+formulaAreaPos.endPos);
	if(formulaAreaPos.startPos==-1||formulaAreaPos.endPos==-1){
		formulaAreaPos.startPos =$("#formulaStr").val().length ;
		formulaAreaPos.endPos =$("#formulaStr").val().length ;
	}
	if (fieldPrex){
		str = str.replace("{","{"+fieldPrex+".");
	}
	selectTextAreaValue($("#formulaStr")[0],formulaAreaPos.startPos,formulaAreaPos.endPos);
	var text = str;
	
	if (!dialogArg.flowTitle && !(str.length == 1 && "+_*/()".indexOf(str) > -1)){
	  text = ""+str+" ";
	  if (needPrexSpace()){
	    text = " "+str+" ";
	  }
	}

   	addToTextArea($("#formulaStr")[0],text);
	if(str == "not()" || str == "all()" || str == "exist()"){
	  setTextAreaPosition($("#formulaStr")[0],getTextAreaPosition($("#formulaStr")[0]).endPos-2);
	}
}

function needPrexSpace(){
  if (formulaAreaPos.startPos == 0 ||formulaAreaPos.startPos == -1){
    return false;
  }
  var value = $("#formulaStr").val();
  var currentPrex = value.charAt(formulaAreaPos.startPos-1);
  if (currentPrex != ' '){
    return true;
  }
  return false;
}
		
/**
 * 修改textArea中的value
 */
function addToTextArea(textAreaObj, addedValue){
    if(textAreaObj==null || addedValue==null){return;}
    var startPos = 0, endPos = 0;
    //设置分支条件
    if (document.selection){//IE浏览器
        //这个focus不能去掉，否则文本添加的位置会出错。
        textAreaObj.focus();
        var sel = textAreaObj.ownerDocument.selection.createRange();
        sel.text = addedValue;
        sel.select();
        sel = null;
    }else if(textAreaObj.selectionStart || textAreaObj.selectionStart == '0'){//火狐/网景 浏览器
        //得到光标前的位置
        startPos = textAreaObj.selectionStart;
        //得到光标后的位置
        endPos = textAreaObj.selectionEnd;
        // 在加入数据之前获得滚动条的高度 
        var restoreTop = textAreaObj.scrollTop, createCodeValue = textAreaObj.value; 
        textAreaObj.value = createCodeValue.substring(0, startPos) + addedValue + createCodeValue.substring(endPos, textAreaObj.value.length);
        //如果滚动条高度大于0
        if (restoreTop > 0) {
            textAreaObj.scrollTop = restoreTop;
        }
        textAreaObj.selectionStart = startPos + addedValue.length;
        textAreaObj.selectionEnd = endPos + addedValue.length;
    }else{
        textAreaObj.value = createCodeValue + addValue;
    }
    textAreaObj = null;
    
}
/**
 * 获取textArea中光标的位置
 */
function getTextAreaPosition(t){
    var startPos = 0, endPos = 0;
    if(t!=null){
    	try{
	       if (t.ownerDocument.selection) {
	            t.focus();
	            var ds = t.ownerDocument.selection;
	            var range = ds.createRange();
	            var stored_range = range.duplicate();
	            stored_range.moveToElementText(t);
	            stored_range.setEndPoint("EndToEnd", range);
	            startPos = t.selectionStart = stored_range.text.length - range.text.length;
	            endPos = t.selectionEnd = t.selectionStart + range.text.length;
	            ds = range = null;
	        } else if(t.selectionStart) {
	            startPos = t.selectionStart;
	            endPos = t.selectionEnd;
	        } else {
	            startPos = endPos = 0;
	        }
    	}catch(e){}
    }
    //OA-125265    表单设置条件保存，然后中间修改某个字段条件，此时会有问题
    var lastOpIsDel = false;
    var delStartPos = 0;
    var dom = document.getElementById('formulaStr');
    //ie8及更早版本，不支持这个属性，判断一下，如果需要，ie8可以用dom.attachEvent("onclick", myFunction);
    if(dom.addEventListener){
        dom.addEventListener('keyup', function(e){
            if (e.keyCode === 8 || e.keyCode === 46) {
                lastOpIsDel = true;
                delStartPos = this.selectionStart;
            } else {
                lastOpIsDel = false;
            }
        });

        dom.addEventListener('focusout', function(e){
            if (lastOpIsDel) {
                this.setSelectionRange(delStartPos, delStartPos);
            }
        });

        dom.addEventListener('click', function(e){
            lastOpIsDel = false;
        });
    }

    return {"startPos":startPos, "endPos":endPos};
}

/**
 * 设置textArea光标的位置
 */
function setTextAreaPosition(t,number){
    if(t==null || number==null){return;}
    selectTextAreaValue(t,number,number);
}

/**
 * 选中textArea中的文字
 */
function selectTextAreaValue(t, s, z){
    if(t==null || s==null || z==null){return;}
    if(t.ownerDocument && t.ownerDocument.selection){
        var range = t.createTextRange();
        range.moveEnd('character', -t.value.length);
        range.moveEnd('character', z);
        range.moveStart('character', s);
        range.select();
    }else if(t.setSelectionRange){
        t.setSelectionRange(s,z);
        t.focus();
    }
    t = null;
}

//IE7中需要在表单获取焦点后手动将光标移动到最后，IE7默认光标在最前面。
function setPositionAtEndInIE7(textareaObj){
	if($.browser.msie&&parseInt($.browser.version,10)==7){
		if(formulaAreaPos.startPos==0&&formulaAreaPos.endPos==0){
			textareaObj.focus();
			if($(textareaObj).val()!=""){
				setTextAreaPosition($(textareaObj)[0],$(textareaObj).val().length+1);
				formulaAreaPos = getTextAreaPosition(textareaObj);//重新记录光标位置
			}
		}
	}
}
</script>