<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="docHeaderOnPigeonhole.jsp"%>
<html style="background-color:#EDEDED;height: 100%">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='doc.jsp.createf.title' /></title>
<script type="text/javascript">
		var prtW = window.dialogArguments;
	    function OK() {
	    	if (typeof(transParams) != 'undefined') {
	    		prtW = transParams.parentWin;
	    	}
	    	if(!checkForm(mainForm))
	    		return ;
	        var dhManager = new docHierarchyManager();
	        var obj = new Object();
	        var titleVal = $("#title").val();
	        obj.parentId = '${parentId}';
	        obj.title = titleVal;
	        dhManager.updateFolderPigeonhole(obj, {
	            success: function(data){
	            	
	            	
	            	//如果后台异常，则提示信息，同时中断程序  return;
	            	if(data.eMessage!=null){
		            	if(data.eMessage == 'doc_upload_dupli_name_failure_alert'){
		            		alert(v3x.getMessage('DocLang.'+data.eMessage,obj.title));
		            	}else{
			            	if(data.eParam!=null){
			            		alert(v3x.getMessage('DocLang.'+data.eMessage,data.eParam));
			            	}else{
			            		alert(v3x.getMessage('DocLang.'+data.eMessage,obj.title));
			            	}
		            	}
		            	return ;
	            	}
	            	//否则，继续进行- - >
					// 首先获取到父页面的元素的treeMoveObj对象  
					var treeMoveObj = prtW.treeMoveObj;
					// 拿到当前点击的文档夹的节点作为父节点
					var selectObj = prtW.selectObj;
					// 拿到tree  
					var tree;
					if(parent.dialogArguments == null){
						if(parent.parent.parent.treeMoveFrame){
							tree = parent.parent.parent.treeMoveFrame.webFXTreeHandler;
						}else if(parent.parent.treeMoveFrame){
							tree = parent.parent.treeMoveFrame.webFXTreeHandler;
						}else if(parent.treeMoveFrame){
							tree = parent.treeMoveFrame.webFXTreeHandler;
						}else{
							tree = treeMoveFrame.webFXTreeHandler;
						}
					} else {
						//取不到的情况
						if (parent.dialogArguments.parent) {
							tree = parent.dialogArguments.parent.treeMoveFrame.webFXTreeHandler;
						} else if(parent.parent.parent.treeMoveFrame){
                            tree = parent.parent.parent.treeMoveFrame.webFXTreeHandler;
                        }else if(parent.parent.treeMoveFrame){
                            tree = parent.parent.treeMoveFrame.webFXTreeHandler;
                        }else if(parent.treeMoveFrame){
                            tree = parent.treeMoveFrame.webFXTreeHandler;
                        }else{
                            tree = treeMoveFrame.webFXTreeHandler;
                        }
					}
					var node = tree.all[tree.getIdByBusinessId(obj.parentId)];
					
					if(typeof eval(node) != 'undefined') {
						try {
							node.reload();
							node.expand();
						} catch(e){}
					}
					//焦点标志位改为true;
					prtW.focusFlag = true;
					if (typeof(transParams) != 'undefined') {
						setTimeout("prtW.collBaclFun();",100); 
					} else {
						setTimeout("window.close();",100); 
					}
	            }
	        });
	    }
	    
	    function calcle(){
	    	if (typeof(transParams) != 'undefined') {
                transParams.parentWin.collBaclFun();
            } else {
               window.close();
            }
	    }

	function onEnterPress(){
		if(v3x.getEvent().keyCode == 13){
			OK();
		}
	}
	window.onload = function() {
		document.getElementById('title').focus();
	};
</script>
</head>
<body scroll="no" onkeydown="listenerKeyESC()" style="overflow: hidden; height: 100%;">
<form name="mainForm" id="mainForm" action="" method="post" onsubmit="return false" target="folderIframe" onkeydown="onEnterPress()">
<input type='hidden' name='parentVersionEnabled' id='parentVersionEnabled' value='${param.parentVersionEnabled}' />
<input type='hidden' name='parentCommentEnabled' id='parentCommentEnabled' value='${param.parentCommentEnabled}' />
<input type='hidden' name='parentRecommendEnable' id='parentRecommendEnable' value='${param.parentRecommendEnable}' />    
<table class="popupTitleRight" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="20" class="PopupTitle" colspan="2">${ctp:i18n('doc.jsp.createf.title')}</td>
	</tr>
	<tr>
		<td align="right" nowrap="nowrap">${ctp:i18n('doc.jsp.createf.name')}&nbsp;</td>
        <td align="left">
		<input type="text" name="title" id="title" value=""  style="width: 260px;;" validate="notNull,isWord,notSpecChar" maxSize="80" inputName="${ctp:i18n('doc.jsp.createf.name')}" /></td>
	</tr>
    <tr><td colspan="2">&nbsp;</td></tr>
	<tr style="margin-top: 10px;margin-bottom: 10px">
      <td align="right" height="30" colspan="2">
        <input type="button" id="btnok" onclick="OK();" class="button-default_emphasize" value="${ctp:i18n('common.button.ok.label')}"/>&nbsp;&nbsp;&nbsp;
        <a id="btncancel" onclick="calcle();" class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>&nbsp;&nbsp;&nbsp;&nbsp;</td>
	</tr>
</table>
</form>
</body>
</html>
