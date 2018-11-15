<%--
 $Author: dengxj $
 $Rev: 9416 $
 $Date:: 2013-11-15 10:46:11#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:setBundle basename="com.seeyon.apps.dee.resources.i18n.DeeResources"/>
<script type="text/javascript" src="${path}/ajax.do?managerName=deeDataManager"></script>
<html class="h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key='dee.data.list'/></title>
</head>
<body class="h100b over_hidden">
	<input type="hidden" id="listRefField" value="${listRefField}" >
	<input type="hidden" id="listRefFieldValue"  >
    <div id="deedatalist" class="comp" comp="type:'layout'">
    	<%--树机构 --%> 
    	<div id="west" class="layout_west page_color" layout="width:200,maxWidth:200" style="border-top: none;">
         	 <ul id="tree" class="ztree"></ul>
        </div>
    	
        <%-- 北边部分查询条件 --%>
        <div id="north" class="layout_north page_color" layout="height:30,maxHeight:30,minHeight:30,spiretBar:{show:false}" style="border-top: none;">
         <div id="toolbar"> </div>
        </div>
        <%-- 中间是主表数据列表 --%>
        <div id="center" class="layout_center over_hidden" layout="border:false">
            <table class="flexme3 " style="display: none" id="mytable"></table>
            <%-- 重复表数据区域 --%>
            <div id="grid_detail">
                    <iframe id="viewFrame" src=""  height="290px" width="100%"  frameborder="no"></iframe>
            </div>
        </div>
    </div>  
    <script type="text/javascript">
        var loadTree = false;
    	var setting4 = {
            edit: {
                enable: false
            },
            data: {
            	key: {
					name: "${treeName}"
				},
                simpleData: {
                    enable: true,
                    idKey: "${treeId}",
    				pIdKey: "${treePid}"
                }
            },
            callback: {
				onClick:treeClk
            }
        };
		var treeDataStr = '${treeData}';
		
		var zNodes4 = [];
		if(treeDataStr && treeDataStr != ""){
			 zNodes4 = eval('(' + treeDataStr+ ')'); 
		}
		
		var isMasterField = "${isMasterField}";
		
		var zNodes3 =  [{ "${treeId}": -1, "${treePid}": -1, "${treeName}": "<fmt:message key='dee.tree.root.name'/>" }];
    	  

 
    
    	var formId = "${formId}";
    	var fieldName = "${fieldName}";
 	    var contentDataId = "${contentDataId}";
 	    var recordId = "${recordId}";
    	var success = "${success}";
    	var gridObj;
    	$(document).ready(function(){
        	if(success == "false"){
        		var err = $.error({
        		    'msg': '${errorMsg}',
        		    ok_fn: function (){closeMaster();},
        		    close_fn:function (){closeMaster();}
        		});
        		        		
            }
    		//初始化布局
    		initLayOut();
    		//初始化搜索框
    		initSearch();
			//初始化高级查询按钮
			initAdvanceSearchButton();
    		//initFrameHeight();
    		//初始化树
    		initTree();
    	});
		function initAdvanceSearchButton(){
			var buttonStr = '<li class="margin_l_5 search_btn" style="*margin-top:-1px;"><a style="font-size: 12px; border: 1px solid #FFFFFF; color: #318ed9; background: #fff; border-radius: 3px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 95px; padding: 0 12px; line-height: 24px; height: 24px; vertical-align: middle; _vertical-align: baseline; display: inline-block;" href="javascript:void(0)" onClick="advanceSearchView()"><fmt:message key="dee.advanceSearch.name"/></a></li>';
			$("ul li:last").after($(buttonStr)); 
		}
		
    	function closeMaster(){
	    	if(window.parentDialogObj["deeExchangeDialog"]){
	    		window.parentDialogObj["deeExchangeDialog"].close();
		    	return;
		    }
	    	if(parent.window.frames["newFormDataFrame"] != undefined && parent.window.frames["newFormDataFrame"].window.dialog != undefined)
    			parent.window.frames["newFormDataFrame"].window.dialog.close();
        }
    	function initLayOut(){
    		new MxtLayout({
                'id' : 'layout',
                'westArea' : {
                    'id' : 'west',
                    'width' : 200,
                    'sprit' : false
                 },
                'northArea' : {
                  'id' : 'north',
                  'height' : 35,
                  'sprit' : false
                },
                'centerArea' : {
                  'id' : 'center',
                  'border' : false
                },
                'successFn' : function() {
                	initTable();
                }
            });
    	}
    	function initTable(){
    		gridObj = $("#mytable").ajaxgrid({
    	        parentId : "center",
    	        colModel : structColModel(),
    	        click : clk,
    	        managerName : "deeDataManager",
    	        managerMethod : "getDeeMasterDataListByMasterId",
    	        usepager : true,
    	        useRp : true,
    	        showTableToggleBtn : true,
    	        resizable : true,
    	        vChange :false,
    	        isHaveIframe:true,
    	        customize:false,
    	        vChangeParam: {
    	            overflow: "hidden",
    	            autoResize:true
    	        },
    	        slideToggleBtn: true,
    	        onSuccess:function(){
                	$('.flexigrid :radio').removeClass('noClick');
                }


    	   });
    	   var o = new Object();
    	   o.formId = formId;
    	   o.fieldName = fieldName;
    	   o.contentDataId = contentDataId;
    	   o.recordId = recordId;
		   o.treeResultName='${treeResultName}';		   
    	   $("#mytable").ajaxgridLoad(o);
    	}
	    
	   //构造列头
	   function structColModel(){
		  var theadarr = [{
               display : 'id',
               name : 'id',
               width : '30',
               sortable : false,
               align : 'left',
               type : isMasterField == "true"?"radio":"checkbox"
          }];
		  var _width =$("body").width()-50;//宽度-id的宽度
		  var showFields = ${fieldlist};
          var _colWidth = 100;
          if(showFields.length>=10){
         	 _colWidth = _width/10;
          }else{
         	 _colWidth = _width/showFields.length;
          }
          for(var i=0;i<showFields.length;i++){
         	 showFields[i].width = ''+(_colWidth-10);
         	 showFields[i].align ='left';
         	 if(showFields[i].name.toLowerCase() == "id"){
         		 var currentShowField = showFields[i];
         		currentShowField.name = "column_@dee@newId@_id";
         		theadarr.push(currentShowField);
         	 }else{
             	theadarr.push(showFields[i]);
         	 }
          }
          return theadarr;
	   }
	   function clk(data, r, c){
		   if( isMasterField == "false" )
			   return;
		   
			if(retHasSubDeeData(data) == "1"){
				if(!gridObj.p.vChange)
					gridObj.p.vChange = true;
		   		$("#viewFrame").attr("src",encodeURI("${path}/dee/deeDataDesign.do?method=selectSubDeeDataList&masterId="+data.id+"&formId="+formId+"&fieldName="+fieldName));
		   		gridObj.grid.resizeGridUpDown('middle');
		   	}
			else{
		   		$("#viewFrame").attr("src",encodeURI("${path}/dee/deeDataDesign.do?method=selectSubDeeDataList&masterId="+data.id+"&formId="+formId+"&fieldName="+fieldName));
				if(gridObj.p.UMD == "middle"){
					if(!gridObj.p.vChange)
						gridObj.p.vChange = true;
		   			gridObj.grid.resizeGridUpDown('down');
		   		}
			}
			
	   }

	   //
	   function initFrameHeight(){
		   if(navigator.userAgent.indexOf("MSIE 8.0")>0){
			   $("#viewFrame").attr("height","240px");
		   }
		   else{
			   $("#viewFrame").attr("height","290px");
		   }
	   }
	   function OK(){
		   var detailRows = "";
		   //获取iframe的window对象
           var detailWin =  document.getElementById("viewFrame").contentWindow;
		  
		   if(detailWin.getCheckRows){
			   detailRows = detailWin.getCheckRows()
		   } 	
		   var rows = gridObj.grid.getSelectRows();
		   var returnObj = new Object();
		   if(rows.length > 0){
//			   returnObj.deeMasterIds = deeMasterIds;
			   if( isMasterField == "false" ){
				   var masters = "";
				   for(var i=0;i<rows.length;i++){
					   masters += rows[i].id+"|";
				   }
				   returnObj.selectMasterId = encodeURI(masters);
			   }else{
				   returnObj.selectMasterId = rows[0].id;
			   }	
			   returnObj.success = true;
			   returnObj.detailRows = detailRows;
		   }else{
			   //returnObj.success = false;
			   returnObj.selectMasterId = "0";
				returnObj.success = true;
				returnObj.detailRows = detailRows;
		   }
		   return returnObj;
	   }
	   function initSearch(){
		   var searchobj = $.searchCondition({
		        top:2,
		        right:20,
		        searchHandler: function(){
					var result = searchobj.g.getReturnValue();
					var o = new Object();
//			    	o.masterIds = deeMasterIds;
    	   			o.formId = formId;
    	   			o.fieldName = fieldName;
    	   			o.contentDataId = contentDataId;
    	   			o.recordId = recordId;
			    	o.searchName = result.condition;
			    	o.searchValue = result.value;
					o.treeResultName='${treeResultName}';
					var obj = $("#listRefFieldValue").attr("value");
					if(obj){
						if(obj!=null && obj!="" && obj != -1){
							o.listRefField = "${listRefField}";
							o.listRefFieldValue = obj;
						}
					}
					 
			    	$("#mytable").ajaxgridLoad(o);
			    	$("#viewFrame").attr("src","");
			    	gridObj.grid.resizeGridUpDown('down');
		        },
		        conditions: getConditionFields()
		    });
	   }
	   function getConditionFields(){
		   var fieldArray =new Array();
	        <c:forEach items="${searchFieldList}" var="deeField" varStatus="status">
	        	fieldArray[fieldArray.length] = {'id':"${deeField.name }",'value':"${deeField.name }",'text':"${fn:escapeXml(deeField.display)}",'type': "input"};
	        </c:forEach>
	        return fieldArray;
	   }
	   
	   function retHasSubDeeData(data){
		   var url = encodeURI("${path}/dee/deeDataDesign.do?method=hasSubDeeData&masterId="+data.id);
		   var ret = "0";
			$.ajax({
				type:"GET",
				url:url,
				async: false,
				success:function(retData){
					var retJson = eval("(" + retData + ")");
					if(retJson.error!=null && typeof(retJson.error)!="undefined"){
						$.alert("${ctp:i18n('form.create.input.setting.deetask.error.label')}！");
						return ret;
					}
					ret = retJson.hasSub; 
				}
			});
		   return ret;
	   }
	   //alert($("#deedatalist").height());
	   
	   function initTree(){
		   $.fn.zTree.init($("#tree"), setting4, zNodes3);
		   debugger;
		   if(zNodes4){
			   var treeObj = $.fn.zTree.getZTreeObj("tree");
			   var node = treeObj.getNodeByParam("${treeId}", '-1', null);
			   treeObj.addNodes(node, zNodes4,true);
			   loadTree = true;
		   }
	   }
	   
	   function treeClk(event, treeId, treeNode) {
		   if(treeNode["${treeId}"] == '-1'){
			   if(!loadTree){
				   var treeObj = $.fn.zTree.getZTreeObj("tree");
				   treeObj.addNodes(treeNode, zNodes4);
				   loadTree = true;
			   }else{
				   var o = new Object(); 
				   o.formId = formId;
				   o.fieldName = fieldName;
				   o.contentDataId = contentDataId;
				   o.recordId = recordId;
			//	   o.listRefField = "${listRefField}";
			//	   o.listRefFieldValue = treeNode.id;
				   o.treeResultName='${treeResultName}';
				   $("#listRefFieldValue").attr("value",treeNode["${treeId}"]);
				   $("#mytable").ajaxgridLoad(o);
			   }
		   }else{
			   
			   var ids = [];
			   ids.push(treeNode["${treeId}"]);
			   ids = getChild(treeNode,ids);
			   ids = ids.join();
			   
			   var o = new Object(); 
			   o.formId = formId;
			   o.fieldName = fieldName;
			   o.contentDataId = contentDataId;
			   o.recordId = recordId;
			   o.listRefField = "${listRefField}";
			   //o.listRefFieldValue = treeNode.id;
			   o.listRefFieldValue = ids;
			   o.treeResultName='${treeResultName}';
			   $("#listRefFieldValue").attr("value",ids);
			   $("#mytable").ajaxgridLoad(o);
		   }
		  
       }
	   
	   function getChild(treeNode,ids){
		  var cds = treeNode.children;
		  if(cds && cds.length > 0){
			for(var i=0;i<cds.length;i++){
			   ids.push(cds[i]["${treeId}"]);
			   ids = getChild(cds[i],ids);
			} 
			return ids;
		  }else{
			return ids;
	  	  }
	   }
	   
	   
	   //打开高级查询
	   function advanceSearchView(){
			dialog = $.dialog({
				id: 'advanceSearch',
				url:'${path}/dee/deeDataDesign.do?method=advanceSearchView&formId='+formId+'&fieldName='+fieldName+'&listType=tree',
				height:400,
				width:800,
				title: "<fmt:message key='dee.advanceSearch'/>",
				buttons: [{
		                id: 'ok',
		                text: "<fmt:message key='dee.button.ok'/>",
		                handler: function () {
		                	var value = dialog.getReturnValue();
		                	if( value != "error" ){
		                		var o = new Object(); 
								o.formId = formId;
								o.fieldName = fieldName;
								o.contentDataId = contentDataId;
								o.recordId = recordId;
								o.advanceSearch = value;
								o.treeResultName='${treeResultName}';
								var obj = $("#listRefFieldValue").attr("value");
								if(obj){
									if(obj!=null && obj!=""  && obj != -1){
										o.listRefField = "${listRefField}";
										o.listRefFieldValue = obj;
									}
								}
			                	$("#mytable").ajaxgridLoad(o);
								dialog.close();
		                	}  
							
		                }
		            }, 
		            {
		                id: "cancel",
		                text: "<fmt:message key='dee.button.cancel'/>",
		                handler: function () {
		                    dialog.close();
		                }
		            }]				
			});
		}
    </script>
</body>
</html>