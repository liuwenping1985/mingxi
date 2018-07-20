<%--
 $Author: zhoulj $
 $Rev: 50065 $
 $Date:: 2015-06-17 17:44:56#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>绑定枚举</title>
</head>
<body>
	<div id="tabs" class="comp" comp="type:'tab'">
		<div id="tabs_head" class="common_tabs clearfix">
			<ul class="left">
                    <c:choose>
                        <c:when test="${empty rootEnumId}">
                         <li class="current"><a hideFocus="true" href="javascript:void(0)" tgt="tab1_iframe"><span>${ctp:i18n("metadata.manager.public")}</span></a></li>
                         <li><a hideFocus="true" href="javascript:void(0)" tgt="tab2_iframe"><span>${ctp:i18n("metadata.manager.account")}</span></a></li>
						 <li><a hideFocus="true" href="javascript:void(0)" tgt="tab5_iframe"><span>${ctp:i18n("metadata.manager.system")}</span></a></li>
                         <c:if test="${isNeedImage == 1 && ctp:hasPlugin('formAdvanced')}">
                            <li><a hideFocus="true" href="javascript:void(0)" tgt="tab4_iframe"><span>${ctp:i18n("metadata.unitImageEnum.tab.label")}</span></a></li>
                         </c:if>
                        </c:when>
                        <c:otherwise>
                         <li><a hideFocus="true" href="javascript:void(0)" tgt="tab3_iframe"><span>${ctp:i18n("metadata.manager.select")}</span></a></li>
                        </c:otherwise>
                    </c:choose>
			</ul>
		</div>
		<div id="tabs_body" class="common_tabs_body border_all">
                <c:choose>
                    <c:when test="${empty rootEnumId}">
                     <iframe id="tab1_iframe" border="0" src="${path}/enum.do?method=bindEnumTree&tabType=2&isfinal=${ctp:toHTML(isfinal)}&isFinalChild=${ctp:toHTML(isFinalChild)}&bindId=${ctp:toHTML(bindId)}&isBind=${ctp:toHTML(isBind)}" frameBorder="no" width="100%"></iframe>
                     <iframe id="tab2_iframe" border="0" src="${path}/enum.do?method=bindEnumTree&tabType=3&isfinal=${ctp:toHTML(isfinal)}&isFinalChild=${ctp:toHTML(isFinalChild)}&bindId=${ctp:toHTML(bindId)}&isBind=${ctp:toHTML(isBind)}" frameBorder="no" width="100%"></iframe>
					  <iframe id="tab5_iframe" border="0" src="${path}/enum.do?method=bindEnumTree&tabType=1&isfinal=${ctp:toHTML(isfinal)}&isFinalChild=${ctp:toHTML(isFinalChild)}&bindId=${ctp:toHTML(bindId)}&isBind=${ctp:toHTML(isBind)}" frameBorder="no" width="100%"></iframe>
                     <c:if test="${isNeedImage == 1 && ctp:hasPlugin('formAdvanced')}">
                        <iframe id="tab4_iframe" border="0" src="${path}/enum.do?method=bindEnumTree&tabType=5&isfinal=${ctp:toHTML(isfinal)}&isFinalChild=${ctp:toHTML(isFinalChild)}&bindId=${ctp:toHTML(bindId)}&isBind=${ctp:toHTML(isBind)}" frameBorder="no" width="100%"></iframe>
                     </c:if>
                    </c:when>
                     <c:otherwise>
                     <iframe id="tab3_iframe" border="0" src="${path}/enum.do?method=bindEnumTree&tabType=4&isfinal=${ctp:toHTML(isfinal)}&isFinalChild=${ctp:toHTML(isFinalChild)}&bindId=${ctp:toHTML(bindId)}&isBind=${ctp:toHTML(isBind)}&rootEnumId=${rootEnumId}&enumLevel=${enumLevel}" frameBorder="no" width="100%"></iframe>
                     </c:otherwise>

                 </c:choose>
                
		</div>
	</div>
	<script type="text/javascript">
		var currentTreeId;
		var currentNodeName;
		var currentNodeType;
		var finalChecked = "${isFinalChild}";
		var hasMoreLevel;
		var maxLevel;
		var levelNum;
        var enumType;//枚举类型，系统枚举，单位枚举，图片枚举，公共枚举
		var isReset="${isReset}";
		function OK(){
		    if(isReset && isReset == 'true'){
				if(!currentTreeId){
				    var returnObj = new Array();
	                returnObj.enumId = "";
	                returnObj.enumName = "";
	                return returnObj;
				}
			}else{
				if(currentTreeId == undefined || currentTreeId == -1){
				$.alert("${ctp:i18n('metadata.operate.bind.message.alert')}!");
				return false;
				}
			}
			
			<c:if test="${not empty enumLevel}">
			var enumLevel = "${enumLevel}";
			if(enumLevel != levelNum){
			    $.alert("${ctp:i18n('metadata.operate.bind.message.notlast')}");
                return false;
			}
			</c:if>
			
			if(currentTreeId != undefined && currentNodeType == 1){
				$.alert("${ctp:i18n('metadata.operate.bind.message.alert')}!");
				return false;
			}else{
				//根据传进来的treeid存放对象和final存放对象进行设置值
				var returnObj = new Array();
				returnObj.enumId = currentTreeId;
				returnObj.enumName = currentNodeName;
				returnObj.isFinalChild = finalChecked;
				returnObj.nodeType = currentNodeType;
				returnObj.hasMoreLevel = hasMoreLevel;
				returnObj.maxLevel = maxLevel;
				returnObj.levelNum=levelNum;
				returnObj.enumType=enumType;
				return returnObj;
			}
		}
		//取得当前选中的树的节点id
	    function getSelectTreeNode(){
	    	  var treeObj = $.fn.zTree.getZTreeObj("tree");
	    	  var selected = treeObj.getSelectedNodes();
	    	  return selected[0]==undefined ? undefined : selected[0].data;
	    }
	    function setFinalChild(booleanValue){
	        if(booleanValue==true || booleanValue==false){
	            finalChecked = ""+booleanValue;
	            $("#tabs_body iframe").each(function(){
	                $(this).contents().find("#isFinalChild").prop("checked",booleanValue);
	            });
	        }
	    }
        function cancelOtherIframeSelected(){
            $("#tabs_head li>a").each(function(){
                 var tempThis = $(this), tempWindow = null, tempIframe = null;
                 if(!tempThis.hasClass("current")){
                     tempIframe = document.getElementById(tempThis.attr("tgt"));
                     if(tempIframe!=null && tempIframe.contentWindow && tempIframe.contentWindow.calcelSelected){
                         tempIframe.contentWindow.calcelSelected();
                     }
                 }
                 tempThis = tempWindow = tempIframe = null;
            });
        }
	</script>
</body>
</html>