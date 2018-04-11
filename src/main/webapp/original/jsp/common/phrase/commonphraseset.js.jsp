<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext"%>
<script type="text/javascript">
$(document).ready(function(){
	$("#cphrase").bind("click",function(){
			showphrase($(this).attr("curUser"));
	});
});

//展示常用语
function showphrase(str) {
         var callerResponder = new CallerResponder();
        //实例化Spring BS对象
        var pManager = new phraseManager();
				/** 异步调用 */
		var phraseBean =[];
		pManager.findCommonPhraseById({
			success : function(phraseBean){
				var phrasecontent =[];
				var phrasepersonal =[];
				for(var count = 0 ; count<phraseBean.length; count ++){
					phrasecontent.push(phraseBean[count].content);
					if(phraseBean[count].memberId == str && phraseBean[count].type=="0"){
						phrasepersonal.push(phraseBean[count]);
					}
				}
				$("#cphrase").comLanguage({
					//id:'commp',
	                textboxID: "commp",
	                data: phrasecontent,
	                newBtnHandler: function (phraseper) {
	            		$.dialog({
	            			url : _ctxPath+'/phrase/phrase.do?method=gotolistpage',
	            			transParams:phrasepersonal,
	            			title : '${ctp:i18n("phrase.sys.js.cyy")}',
	            			targetWindow:getCtpTop()
	            		});
	                }
	            });
			}, 
			error : function(request, settings, e){
			    $.alert(e);
			}
		});
						
}

</script>