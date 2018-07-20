<%--
 $Author: maxc $
 $Rev: 2034 $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=templateManager"></script>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- 模版选择 -->
<title>${ctp:i18n('template.templateChooseM.templateSelect')}</title>
<script type="text/javascript">
        var isShowTreeBySearch=false;
        var moduletype="${type}";
        var isMul="${ctp:escapeJavascript(isMul)}";
        var isCanSelectCategory = ${empty isCanSelectCategory ? false : true};
        var selectedNodeMap = {};
        var selectedNodeArray = new Array();
	    /**
	     * 将一个应用类型下面的全部表单模板获取并筛选出未选中的表单模板，设定到数组中去
	     */
	    function getAllTemplatesAndAddToSelected(oSelected,isParent) {
	    	var oChildNodes = oSelected[0].children;
	    	if(oSelected[0].isParent && isMul=='false'){
	    		if(moduletype=='2'){ //请先选择表单模板!
	    		    $.alert("${ctp:i18n('template.templateChooseM.pleaseFormTemplate')}");
	    		}else{ //请选择模板
	    			$.alert("${ctp:i18n('template.templateChooseM.pleaseTemplate')}");
	    		}
	    		return;
	    	}
			//选中应用类型时，将其下的全部表单模板选中	
	    	if(oChildNodes!="undefined" && oChildNodes!=null && !isCanSelectCategory){
				var isHaveSelected="";
				for(var i=0;i<oChildNodes.length;i++) {
					var tempNode = oChildNodes[i];
					isHaveSelected=getAllTemplatesAndAddToSelected($(tempNode),isParent);
				}
				return isHaveSelected;
			}else{
				var returnValue = isSelected(oSelected[0]);
				var categoryChildIsSelected = returnValue["categoryChildIsSelected"];
				if(!returnValue["isSelected"]){//判断该模板或者分类是否已经被选中
					if(isMul=='false'){
						$("#selectedNodes option").remove();
					}
				if(isCanSelectCategory || !oSelected[0].isParent){
					addNodesToSelected(oSelected[0]);//选中普通表单模板
				}
					return false;
				}else{
					if(!isParent || (isCanSelectCategory && typeof(categoryChildIsSelected)=="undefined")){
						if(moduletype=='2' && isMul=='false'){
                            //您已经选择了当前表单模板！
						    $.alert("${ctp:i18n('template.templateChooseM.selectFormTemplateOk')}");
						}else if(typeof(returnValue["templateOrCategoryIsSelected"]) != "undefined" && returnValue["templateOrCategoryIsSelected"]){
                            //您已经选择了当前模板或者分类！
                            if(oSelected[0].data.type=="category"){
								$.alert("${ctp:i18n('template.templateChooseM.selectTemplateCategoryThis')}");
                            }else{
								$.alert("${ctp:i18n('template.templateChooseM.selectTemplateThis')}");
                            }
						}else if(typeof(returnValue["templateOrCategoryParentIsSelected"]) != "undefined"){
							//该分类的模板或分类的父级分类被选择
							var selectNodeParentId = returnValue["templateOrCategoryParentIsSelected"];
							var containNode = selectedNodeMap[selectNodeParentId];
							
							$.alert($.i18n('template.templateChooseM.selectTemplateCategoryContainSelected',containNode.data.name,oSelected[0].name));
						}
					}else if(isCanSelectCategory && categoryChildIsSelected.length>0){
						var selectedNameString = "";
						for(var i=0;i<categoryChildIsSelected.length;i++){
							if(selectedNameString == ""){
								selectedNameString = categoryChildIsSelected[i].value;
							}else{
								if(i<4){
									selectedNameString +="、"+categoryChildIsSelected[i].value;
								}else{
									selectedNameString +=" ...";
									break;
								}
							}
						}
						  $.alert($.i18n('template.templateChooseM.selectTemplateCategoryContainSelected',oSelected[0].data.name,selectedNameString));
		            	  for(var i=0;i<categoryChildIsSelected.length;i++){
		            		  	$(categoryChildIsSelected[i]).remove();
		            		  	var arrayIndex = $.inArray(categoryChildIsSelected[i].id,selectedNodeArray);
		        				if(arrayIndex>-1){
									selectedNodeArray.splice(arrayIndex,1);
		        				}
						  }
		            	  addNodesToSelected(oSelected[0]);
						
					}
				}	
			}
				
		} 
		/**
		 * 增加表单模板节点到右边已选项中，先判断其是否已被选中
		 */
		function addNodesToSelected(oSelected){
			var oOption;
            if(oSelected.data.type !='category'){
    			 oOption=$("<option>").attr("id",oSelected.data.combinId).text(oSelected.data.name);
            }else{
            	var oSelectedNodeId = oSelected.data.combinId;
            	if(oSelectedNodeId.indexOf("C_") == -1){
            		oSelectedNodeId = "C_"+oSelectedNodeId;
            	}
            	selectedNodeArray.push(oSelectedNodeId);
        		selectedNodeMap[oSelectedNodeId] = oSelected;
    			oOption=$("<option>").attr("id",oSelectedNodeId).attr("style","color:#00F").text(oSelected.data.name);
            }
    		$("#selectedNodes").append(oOption);
		}
		
		/**
		 *获取选择分类或者模板的父级分类
		 */
		function getSelectedNodeParentNodeId(selectNode,nodeArr){
			var templeteParentNodes = selectNode.getParentNode();
			if(typeof(templeteParentNodes)!="undefined" && templeteParentNodes!=null){
				if(templeteParentNodes.data.combinId != -1){
					getSelectedNodeParentNodeId(templeteParentNodes,nodeArr);
				}
				var selectNodeId = templeteParentNodes.data.combinId;
				if(selectNodeId.indexOf("C_")==-1){
					selectNodeId = "C_"+selectNodeId;
				}
				nodeArr.push(selectNodeId);
			}
		}
		/**
		 *获取选择分类下的所有模板
		 */
		function getSelectedNodeChildrenNodeId(selectNode,nodeArr){
			var templeteParentNodes = selectNode.children;
			if(typeof(templeteParentNodes) != "undefined"){
				for(var i=0;i<templeteParentNodes.length;i++){
					if(templeteParentNodes[i].isParent){
						getSelectedNodeChildrenNodeId(templeteParentNodes[i],nodeArr);
					}
					if(templeteParentNodes[i].data.type=='category'){
						var oSelectedNodeId = templeteParentNodes[i].data.combinId;
						if(templeteParentNodes[i].data.combinId.indexOf("C_")==-1){
							oSelectedNodeId = "C_"+templeteParentNodes[i].data.combinId;
						}
						nodeArr.push(oSelectedNodeId);
					}else{
						nodeArr.push(templeteParentNodes[i].data.combinId);
					}
				}
			}else{
				nodeArr.push(selectNode.data.combinId);
			}
			
		}
		/**
		 * 判断表单模板的上级分类和分类的下级分类和模板是否没有被选中添加在右侧列表中
		        当前分类或模板被选择返回：selectedArr(当前选择分类下已经选择了的下级分类和模板id),当前分类或者模板被选择：false ,当前分类或者模板的父级被选中：选择的父级分类id
		 */
		function isSelected(templeteNode) {
			var selectedChildNodeArr = new Array();
			var selectedParentNodeArr = new Array();
			var selectedArr = new Array();
			var selectedNameString = "";
			var returnValue = {};
			returnValue['isSelected'] = false;
			if(isCanSelectCategory){
				if(templeteNode.data.type =='category'){ 
					getSelectedNodeChildrenNodeId(templeteNode,selectedChildNodeArr);
				}
				getSelectedNodeParentNodeId(templeteNode, selectedParentNodeArr);
			}
			
			
			var length=$("#selectedNodes option").length;
			for(var i=0; i<length; i++) {
				
				if($("#selectedNodes option")[i].id == templeteNode.id || $("#selectedNodes option")[i].id == "C_"+templeteNode.id || $("#selectedNodes option")[i].id == templeteNode.data.combinId){
				// 判断当前分类或者模板是否被选择
					returnValue["templateOrCategoryIsSelected"] = true;
					returnValue['isSelected'] = true;
					return returnValue;
				
				}else if(isCanSelectCategory && $.inArray($("#selectedNodes option")[i].id, selectedChildNodeArr)>-1 ){
				    //判断选择分类下的分类和模板是否被选择,被选择后需要合并
					selectedArr.push($("#selectedNodes option")[i]);
				} 
			}
			//判断当前分类或者模板的上级分类是否被选择
			if(isCanSelectCategory){
				for(var i=0; i<selectedParentNodeArr.length; i++){
					if($.inArray(selectedParentNodeArr[i],selectedNodeArray)>-1){
						returnValue["templateOrCategoryParentIsSelected"] = selectedParentNodeArr[i];
						returnValue['isSelected'] = true;
						return returnValue;
					}
				}
			}
			if(selectedArr.length>0){
				returnValue['isSelected'] = true;
				returnValue["categoryChildIsSelected"] = selectedArr;
			}
			return returnValue;
		}
		
		function removeSelectedNodeArray(removeNodeId){
			if(typeof(removeNodeId)!="undefined"){
				var arrayIndex = $.inArray(removeNodeId,selectedNodeArray);
				if(arrayIndex>-1){
					selectedNodeArray.splice(arrayIndex,1);	
				}
			}
		}
        var isPortal = "${param.isPortal}";
		function OK(){
          var options=$("#selectedNodes option");
          var ids = "";
          //用于回写模板组件的数据，以数组传递，避免模板中含有特殊字符导致分割错误
          var namesArr = new Array();
          //返回给外层应用用于显示
          var namesDisplay = "";
          var arr = new Array();
          for(var i=0;i<options.length;i++){
               if(ids==""){
                   ids+=$(options[i]).attr("id");
                   namesDisplay+=$(options[i]).text();
                   namesArr.push($(options[i]).text());
               }else{
                   ids+=","+$(options[i]).attr("id");
                   namesDisplay+="、"+$(options[i]).text();
                   namesArr.push($(options[i]).text());
               }
               arr.push($(options[i]).attr("id")); 
          }
          //返回数据的格式
          if(isPortal == '1'){
            return [arr];
          }else{
            var retVal=new Object();
            retVal["ids"]=ids;
            retVal["names"]= namesArr;
            retVal["namesDisplay"]= namesDisplay;
            return retVal;
          }
       }
		function select(){
    		var oSelected =$("#templateTree").treeObj().getSelectedNodes();
			if(oSelected[0]=="undefined"||oSelected[0]==null){
				return;
			}
            if(oSelected[0].isParent && (oSelected[0].children=="undefined" || oSelected[0].children==null)){
              $.alert("${ctp:i18n('template.templateChooseM.notemplateincategory')}");
              return;
            }
			var isHaveSelected=getAllTemplatesAndAddToSelected(oSelected,oSelected[0].isParent);
			if(isHaveSelected && oSelected[0].isParent){
				//$.alert('该分类下包含已经选择的模板，已经帮您过滤！');
			}
    	}
        $(function () {
        	$("#select_selected").click(select);
			if($.inArray($("#moduleType").val(), ["19", "20", "21"]) >= 0) {
				isShowTreeBySearch = true;
			}
        	/**
             * 将已选项删除
             */
        	$("#select_unselect").click(function(){
        		if($("#selectedNodes option:selected")[0]&&$("#selectedNodes option:selected")[0].id){
					removeSelectedNodeArray($("#selectedNodes option:selected")[0].id);
					$("#selectedNodes option:selected").remove();
				}
        	});
        	$("#sort_up").click(function(){
        		var firstSelectedNode=$("#selectedNodes option:selected")[0];  
        		if(firstSelectedNode!="undefined"){
        			var allNodes=$("#selectedNodes option");
        			if(firstSelectedNode!=allNodes[0]){
        				var beforeNode=allNodes[0];
        				for(var i=1;i<allNodes.length;i++){
        					if(allNodes[i]==firstSelectedNode){
        						$(firstSelectedNode).insertBefore("#"+beforeNode.id);
        						break;
        					}else{
        						beforeNode=allNodes[i];
        					}
        				}
        			}
        		}
        	});
        	$("#sort_down").click(function(){
    			var firstSelectedNode=$("#selectedNodes option:selected")[0];  
    			if(firstSelectedNode!="undefined"){
    				var allNodes=$("#selectedNodes option");
    				if(firstSelectedNode!=allNodes[allNodes.length-1]){
    					var afterNode=allNodes[allNodes.length-1];
    					for(var i=allNodes.length-2;i>=0;i--){
    						if(allNodes[i]==firstSelectedNode){
    							$(firstSelectedNode).insertAfter("#"+afterNode.id);
    							break;
    						}else{
    							afterNode=allNodes[i];
    						}
    					}
    				}
    			}
    		});
        	/**
             * 双击已选列表选项将其删除
             */
        	 $("#selectedNodes").dblclick(function(){
        	 	try{
         		 	removeSelectedNodeArray($("#selectedNodes option:selected")[0].id);
        		 	$("#selectedNodes option:selected").remove();
        		 }catch(e){}
        	}); 
            var transParamArr =  {
                searchType: $("#searchType").val(),
                moduleType: $("#moduleType").val(),
                scope: $("#scope").val(),
                reportId:$("#reportId").val(),
                excludeTemplateIds:$("#excludeTemplateIds").val()
            };
            //
            $("#templateName, #searchType, #templateTypes").keydown(function(event){
              if(event.keyCode === 13){
                $("#searchSpan").click();
              }
            });
        	 $("#searchSpan").click(
        			 function(){
                 		var type=$("#searchType").val();
                 		isShowTreeBySearch=true;
                 		if(type==0){
                     		 $("#templateTree").treeObj().setting.treeObj.empty();
                             var params = new Object();
                             params["moduleType"] = $("#moduleType").val();
                             params["scope"] = $("#scope").val();
                             params["reportId"] = $("#reportId").val();
                             params["excludeTemplateIds"] = $("#excludeTemplateIds").val();
                             var _templateManager = new templateManager();
                             var treedata = _templateManager.getTemplateChooseTreeData(params);
                             $("#templateTree").treeObj().addNodes(null,treedata);
                 		}else if(type==1){
                 			$("#templateTree").treeObj().setting.treeObj.empty();
                 		    var params = new Object();
                            params["searchType"] = $("#searchType").val();
                            params["moduleType"] = $("#moduleType").val();
                            params["scope"] = $("#scope").val();
                            params["reportId"] = $("#reportId").val();
                            params["excludeTemplateIds"] = $("#excludeTemplateIds").val();
                            params["textfield"] = encodeURIComponent($("#templateName").val());
                            var _templateManager = new templateManager();
                 			var treedata = _templateManager.getTemplateChooseTreeData(params);
                 			$("#templateTree").treeObj().addNodes(null,treedata);
                 		}else if(type==2){
                     		 $("#templateTree").treeObj().setting.treeObj.empty();
                             var params = new Object();
                             params["searchType"] = $("#searchType").val();
                             params["moduleType"] = $("#templateTypes").val();
                             params["scope"] = $("#scope").val();
                             params["reportId"] = $("#reportId").val();
                             params["excludeTemplateIds"] = $("#excludeTemplateIds").val();
                             params["textfield"] = encodeURIComponent($("#templateName").val());
                             var _templateManager = new templateManager();
                             var treedata = _templateManager.getTemplateChooseTreeData(params);
                             $("#templateTree").treeObj().addNodes(null,treedata);
                     	}
                 	}
        	 ); 
            $("#searchType").change(function () {
                var value = $(this).val();
                var templateName = $("#templateName");
                var templateTypes = $("#templateTypes");
                switch (value) {
                    case "0":
                    	templateName.hide();
                    	templateTypes.hide();
                    	break;
                    case "1":
                    	templateName.show();
                    	templateTypes.hide();
                        break;
                    case "2":
                    	templateName.hide();
                    	templateTypes.show();
                        break;
                }
            });
            $("#templateTree").tree({
        	    idKey : "id",
        	    pIdKey : "pId",
        	    nameKey : "name",
        	    onDblClick :select,
        	    nodeHandler : function(n) {
        	        n.open = isShowTreeBySearch;
        	        if(n.data.id==-1||n.data.id==1||n.data.id=="-1"||n.data.id=="1"){
        	        	n.open=true;
        	        }
        	        if (n.data.type == 'category') {
        	            n.isParent = true;
        	          }
        	    }     
        	});
        	$("#templateName").hide();
        	initData();
        	var templateName = $("#templateName");
            var templateTypes = $("#templateTypes");
            templateName.hide();
            templateTypes.hide();
        });
        
      //加载已经选择的数据
       var objTree1;
       function initData(){
    	      //1、数据来自三部分  portal、组件、老应用    
    		  objTree1=$.fn.zTree.getZTreeObj("templateTree");
    		  
    		  var isComponent = "${ctp:escapeJavascript(param.isComponent)}";
    		  
    		  if(isComponent){
    		        var hasSelectedTemplateIds = window.dialogArguments._tids;
    		        var hasSelectedTemplateNames = window.dialogArguments._tnames;
    		        if(hasSelectedTemplateIds != ''){
    		            var idArr = hasSelectedTemplateIds.split(",");
    		            var name  = hasSelectedTemplateNames;
    		            for(var i = 0 ; i<idArr.length;i++){
    		              var oOption=$("<option>").attr("id",idArr[i]).text(name[i]);
    		              $("#selectedNodes").append(oOption);  
    		            }
    		        }
    		  }else{
    			  var values = "${param._tids}";
    			  if(isPortal == '1')
        		      values = window.dialogArguments;
    		      if(values){
    		    	  var idsArry=values.split(",");
    		          var nodes = objTree1.transformToArray(objTree1.getNodes());
    		          for(var i = 0 ; i<idsArry.length;i++){
    		             for(var j = 0 ; j<nodes.length;j++){
    		                 if(nodes[j].data.id == idsArry[i] || "C_"+nodes[j].data.id == idsArry[i]){
    		                    addNodesToSelected(nodes[j]);
    		                    break;
    		                 }
    		             }
    		          }
    		      }
    		  }
    	}
    </script>
</head>
<body class="page_color">
	<input type="hidden" id="moduleType" value="${moduleType}"/>
	<input type="hidden" id="accountId" value="${v3x:toHTML(accountId)}"/>
	<input type="hidden" id="isMul" value="${isMul}"/>
	<input type="hidden" id="scope" value="${v3x:toHTML(scope)}"/>
    <input type="hidden" id="excludeTemplateIds" value="${v3x:toHTML(param.excludeTemplateIds)}"/>
    <input type="hidden" id="reportId" value="${param.reportId}"/>
    <div id="htmlID" class="">
        <div class="padding_b_10 padding_l_10 padding_t_0 font_size12">
            <div class="clearfix">
                <span class="valign_m">${ctp:i18n('template.templateChoose.inquiry')}:</span><!-- 查询 -->
                <select id="searchType" class="valign_m">
                    <option value="0">${ctp:i18n('template.templateChoose.query')}</option><!-- --查询条件-- -->
                    <option value="1">${ctp:i18n('template.templateChoose.templateName')}</option><!-- 模版名称 -->
                    <option value="2">${ctp:i18n('template.selectSourceTem.transformationOfApplied')}</option><!-- 所属应用 -->
                </select>
                <input id="templateName" type="text" class="valign_m" />
                <select id="templateTypes" class="valign_m">
                ${categoryHTML}
                </select>
                <span id="searchSpan"><a href="javascript:void(0)"><em class="ico16 search_16"></em></a></span>
            </div>
            <div class="hr_heng margin_t_5"></div>
            <table cellpadding="0" cellspacing="0" border="0" height="380" class="w100b margin_t_5" style="*margin-top:2px;">
                <tr height="25">
                    <td>${ctp:i18n('template.templateChooseM.options')}</td><!-- 可选项 -->
                    <td></td>
                    <td>${ctp:i18n('template.templateChooseM.hasOptions')}</td><!-- 已选项 -->
                    <td></td>
                </tr>
                <tr>
                    <td valign="top" width="225" height="360">
                        <div class="border_all" style="width:235px;height:360px;overflow:auto;background-color: white;">
                        	<div id="templateTree">
                        	</div>
                        </div>
                    </td>
                    <td width="20" class="padding_lr_10">
                        <span id="select_selected" class="ico16 select_selected margin_b_10"></span>
                        <br />
                        <span id="select_unselect" class="ico16 select_unselect"></span>
                    </td>
                    <td valign="top" width="225" height="360">
                        <select id="selectedNodes" class="border_all" multiple="multiple" style="height:360px;width:225px;overflow:auto;background-color: white;">
                        
                        </select>
                    </td>
                    <td width="16" class="padding_lr_10">
                    	<c:if test="${isMul}">
                    	<span id="sort_up" class="ico16 sort_up margin_b_10"></span> <br />
                        <span id="sort_down" class="ico16 sort_down"></span>
                        </c:if>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</body>
</html>