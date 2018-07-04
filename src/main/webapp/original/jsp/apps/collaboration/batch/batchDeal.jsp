<%--
 $Author:  张向伟$
 $Rev:  $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <script type="text/javascript">
	    function OK(){
	    	var opinion = "${ctp:escapeJavascript(opinion)}";
	    	var content = document.getElementById("content");
	    	if(content.value.trim() == ""){
	    		if(opinion == '1' || (opinion=="3" && $("#radio03").is(":checked"))){
	    			//您选择的待办事项必须填写处理意见！
		    		$.alert("${ctp:i18n('collaboration.batchDeal.mustComment')}");
		    		var content = document.getElementById("content");
		    		if(content){
		    			content.focus();
		    		}
		    		return false;
	    		}
	    	}
	    	
	    	if(content.value.length > 2000){
                //意见字数不允许超过2000字！
	    	    $.alert("${ctp:i18n_1('collaboration.batchDeal.opinionMore',2000)}");
	    	    return false;
	    	}
	    	var atts = document.getElementsByName("atts");
	    	var attitude = "";
	    	for(var i = 0;i< atts.length;i++){
	    		if(atts[i].checked){
	    			attitude = atts[i].value;
	    			break;
	    		}
	    	}
	    	var trace = document.getElementById("trace").checked;
	
	    	return [attitude,content.value,trace];
	    }

        window.onload=function(){
        	var content = document.getElementById("content");
        	if(content){
        		content.focus();
        	}
        }

        //展示常用语
        function showphrase(str) {
          var callerResponder = new CallerResponder();
          //实例化Spring BS对象
          var pManager = new phraseManager();
          /** 异步调用 */
          var phraseBean = [];
          pManager.getAllPhrases({
            success : function(phraseBean) {
              var phrasecontent = [];
              var phrasepersonal = [];
              for ( var count = 0; count < phraseBean.length; count++) {
                phrasecontent.push(phraseBean[count].content);
                if (phraseBean[count].memberId == str
                    && phraseBean[count].type == "0") {
                  phrasepersonal.push(phraseBean[count]);
                }
              }
              $("#cphrase").comLanguage({
                textboxID : "content",
                data : phrasecontent,
                newBtnHandler : function(phraseper) {
                  $.dialog({
                    url : _ctxPath + '/phrase/phrase.do?method=gotolistpage',
                    transParams : phrasepersonal,
                    width: 600,
                    height: 400,
                    targetWindow:getCtpTop(),
                    title : "${ctp:i18n('phrase.sys.js.cyy')}"
                  });
                }
              });
            },
            error : function(request, settings, e) {
              $.alert(e);
            }
          });
        }
    </script>
    <!-- 批处理 -->
    <title>${ctp:i18n('batch.title')}</title>
    
</head>
<body style="background:#fafafa;">
	<form action="/batch.do?method=doBatch" method="post" name="batchForm">
	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
			<tr height="28px" class="margin_t_10">
				<td>
				<c:set var="attitudes" value="${param.attitude }"/>
				     <div class="font_size12 padding_l_10">
				     <c:if test="${attitude ne null && attitude==1}">
				     	<label class="" for="radio01">
					     	<input type="radio" id='radio01' name="atts" value="1" class="margin_r_5 radio_com" checked="checked"/>
					     	${ctp:i18n('collaboration.dealAttitude.haveRead')}<!-- 已阅 -->
					    </label>
					 </c:if>
					 <c:if test="${attitude ne null && (attitude==1 or attitude==2)}">
						 <label class="" for="radio02">
						     <input type="radio" id='radio02' name="atts" value="2" class="radio_com" <c:if test="${attitude==2}">checked="checked"</c:if>/>
						     ${ctp:i18n('collaboration.dealAttitude.agree')}<!-- 同意 -->
					     </label>
						 <label class="" for="radio03">
					     	<input type="radio" id='radio03' name="atts" value="3" class="radio_com"/>
					     	${ctp:i18n('collaboration.dealAttitude.disagree')}<!-- 不同意 -->
					     </label>
				     </c:if>
				     </div>
				</td>
				<td align="right">
                  <c:if test="${CurrentUser.externalType == 0}">
					<span id="cphrase" style="color: #296fbe;" curUser="${CurrentUser.id}" class="padding_b_10 margin_r_10 font_size12 hand" onClick="javascript:showphrase(${CurrentUser.id})">
					<span class="ico16 common_language_16"></span> 
    					<!-- 常用语 -->
                        ${ctp:i18n('collaboration.common.commonLanguage')}
					</span>
			       		${v3x:showCommonPhrase(pageContext)}
                  </c:if>
				</td>
			</tr>
			<tr>
				<td colspan="2" valign="top" align="center">
				    <textarea  style="height:250px;width:425px;" name="content" id="content"></textarea>
				</td>
			</tr>
			<tr style="display:none">
				<td colspan="2">
					<label for="trace">
						<input type="checkbox" name="trace" id="trace" value="true"><fmt:message key="track.label"/>
					</label>
				</td>
			</tr>
	</table>
	</form>    
</body>
</html>
