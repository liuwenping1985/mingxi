<!DOCTYPE html>
<html>
<head>
	<%@ page contentType="text/html; charset=UTF-8"%>
	<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<script type="text/javascript" src="${path}/ajax.do?managerName=phraseManager"></script>
	<script>
    $(document).ready(function(){
        var objId = "${objId}";
        $("#perphraseId").val(objId);
     });
    //定义回调函数,以json字符串形式返回
    function OK(){/**/
    	if(!valibeforesubmit()){
    		return false;
    	}
    	var callerResponder = new CallerResponder();
        var pManager = new phraseManager();
   		var phraseId = $("#perphraseId").val();
   		 //取得 常用语内容
      	 var phraseContent =$("#phraseDes").val();
      	 var pobj = new Object();
      	 pobj.id = phraseId;
      	 pobj.content = phraseContent;
      	 var returnValue  = pManager.addorupdatePersonPhrase(pobj);
		return returnValue;
    }

  //对输入的常用语做校验
    function valibeforesubmit(){
    	var xx = $("#phraseDes").val();
    	if($.trim(xx) ==""){
    		$.alert("${ctp:i18n('phrase.sys.js.cantbenull')}");
    		return false;
    	}
    	if(xx.length>80){
    		$.alert("${ctp:i18n_1('phrase.sys.js.cyycd','"+xx.length+"')}");
    		return false;
    	}
    	return true;
    }
    
	</script>
</head>
<body scroll="no" style="overflow: hidden">
	<div id="searchId">
    	<input type="hidden" id="perphraseId"></input>
        <table width="90%" height="50%" align="center">
            <tr>
                <td>
                    <div class="common_txtbox clearfix">
                        <textarea id="phraseDes" cols="30" style="height: 105px;width:255px;" wrap="virtual"  class="padding_5 w100b"><c:out value="${objContent}"></c:out></textarea>
                    </div>
                </td>
            </tr>
            <tr>
                <td class="font_size12 padding_t_5" style="color:#888888">${ctp:i18n('phrase.sys.sm')}
    ${ctp:i18n('phrase.sys.cyycd')}
                </td>
            </tr>
        </table>
    </div>
</body>
</html>