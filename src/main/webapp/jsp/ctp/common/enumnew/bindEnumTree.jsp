<%--
 $Author: wangwy $
 $Rev: 46833 $
 $Date:: 2015-03-12 11:02:26#$:
  
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
<title>绑定枚举树</title>
</head>
<body scrolling="no">
	<div>
		<ul class="common_search">
			<li>
			<select id="condition" name="condition" style="height: 25px;">
					<option value="">--${ctp:i18n('metadata.select.find')}--</option>
                    <c:choose>
                    <c:when test="${empty rootEnumId}">
                    <option value="enumName">${ctp:i18n('metadata.select.enum.name')}</option>
                    </c:when>
                     <c:otherwise>
                        <option value="itemName"><font size="12">${ctp:i18n('metadata.select.value.name')}</font></option>
                     </c:otherwise>
                    </c:choose>
			</select>
			</li>
			<li id="inputBorder" class="common_search_input">
			<input id="data" class="search_input hidden" type="text"></li>
			<li>
			<a id="searchBtn" class="common_button common_button_gray search_buttonHand" href="javascript:void(0)"><em></em>
			</a>
			</li>
		</ul>
		<br> <br>
		<div style="height:350px;width:486px;overflow:auto;"><ul id="tree"></ul></div>
		<div <c:if test="${isfinal == '0' || tabType == 5}">style="display:none;"</c:if> class="font_size12"><input type="checkbox" name="isFinalChild" id="isFinalChild" class="padding_l_5"><span class="padding_l_5 font_size12">${ctp:i18n('metadata.last.value')}</span></div>
	</div>
    <script type="text/javascript">
		  //树结构参数
		  var treeParams = {
				    onClick:nodeClk,
				    onAsyncSuccess: zTreeOnAsyncSuccess,
			        idKey : "id",
			        pIdKey : "pId",
			        nameKey : "name",
			        managerName : "enumManagerNew",
			        managerMethod : "getBindEnumTree",
			        enableCheck : false,
			        enableEdit : false,
			        enableRename : false,
			        enableRemove : false,
			        nodeHandler : function(n) {
			        	if(n.data.id == -1 || $("#data").val() != ""){
				        	n.open = true;
			        	}
					}
			};
			$().ready(function() {
				initTree();
				if(parent.finalChecked === "true" || parent.finalChecked === true){
					$("#isFinalChild").prop("checked",true);
					parent.finalChecked = true;
				}
				$("#condition").change(function(){
					showNextSpecialCondition(this);
				});
				$("#searchBtn").click(function (){
					search();
				});
				$("#isFinalChild").click(function(){
					if($(this).attr("checked")){
						parent.setFinalChild(true);
					}else{
						parent.setFinalChild(false);
					}
				});
				var bro = $.browser;//只需要对IE7进行处理
				if(bro.msie && bro.version == "7.0"){
					 $("#condition").css("margin-top","2px");
				}
			});
			//树刷新方法
			function refleshTree(o){
				$("#"+o).treeObj().reAsyncChildNodes(null, "refresh");
			}
			//初始化树方法
			function initTree(){
				var params = {tabType:${tabType},isBind:"${ctp:escapeJavascript(isBind)}",rootEnumId:"${rootEnumId}",enumLevel:"${enumLevel}"};
			    treeParams.asyncParam  = params;
			 	$("#tree").empty();
			 	$("#tree").tree(treeParams);
			 	refleshTree("tree");
			}
			//树节点单击事件
			function nodeClk(e, treeId, node) {
				parent.currentTreeId = node.data.id;
				parent.currentNodeName = node.data.name;
				parent.currentNodeType = node.data.type;
				parent.hasMoreLevel = node.data.hasmorelevel;
				parent.maxLevel = node.data.maxlevel;
				parent.levelNum = node.data.levelNum;
                parent.enumType = node.data.enumType;
			    //取消其他页面的选中状态
                parent.cancelOtherIframeSelected();
                var treeObj = $("#tree").treeObj();
                treeObj.selectNode(node);
                treeObj = null;
			}	
			//异步加载树完成以后做回写操作
			function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
				var treeObj = $.fn.zTree.getZTreeObj("tree");
				<c:if test="${not empty rootEnumId}">
				treeObj.expandAll(true);
				</c:if>
				<c:if test="${empty rootEnumId}">
				var nodes = treeObj.getNodes();
				var childrens = treeObj.transformToArray(nodes);
				for(var i = 0;i < childrens.length;i++){
					if("${ctp:escapeJavascript(bindId)}" == childrens[i].id){
						childrens[i].open = true;
						$("#tree").treeObj().selectNode(childrens[i]);
						nodeClk(null,null,childrens[i]);
						break;
					}
				}
				</c:if>
			}
			
			//搜索按钮搜索事件
			function search(){
				var data = $("#data").val();
				<c:choose>
                <c:when test="${empty rootEnumId}">
                var params = {tabType:${tabType},enumName:data,rootEnumId:"${rootEnumId}",enumLevel:"${enumLevel}",isBind:"${ctp:escapeJavascript(isBind)}"};
                </c:when>
                <c:otherwise>
                var params = {tabType:${tabType},itemName:data,rootEnumId:"${rootEnumId}",enumLevel:"${enumLevel}",isBind:"${ctp:escapeJavascript(isBind)}"};
                </c:otherwise>
                </c:choose>
			    treeParams.asyncParam  = params;
			 	$("#tree").empty();
			 	$("#tree").tree(treeParams);
			 	refleshTree("tree");
			}
			
			//change枚举查询框
			function showNextSpecialCondition(obj){
				$("#data").val("");
			    if($(obj).val()==""){
			        $("#data").removeClass("hidden").addClass("hidden");
			    }else{
			    	$("#data").removeClass("hidden");
			    }
			}
			function calcelSelected(){
			    var treeObj = $("#tree").treeObj();
                var nodes = treeObj.getSelectedNodes();
                if(nodes!=null && nodes.length>0){
                    for(var i=0,len=nodes.length; i<len; i++){
                        treeObj.cancelSelectedNode(nodes[i]);
                    }
                }
			}
    </script>
</body>
</html>
