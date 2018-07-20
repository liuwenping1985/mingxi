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
<script type="text/javascript" src="${path}/ajax.do?managerName=deeDataManager"></script>
<html class="h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>dee数据列表</title>
</head>
<body class="h100b over_hidden">
    <div id="deedatalist" class="comp" comp="type:'layout'">
        <%-- 北边部分查询条件 --%>
        <div id="north" class="layout_north page_color" layout="height:30,maxHeight:30,minHeight:30,spiretBar:{show:false}" style="border-top: none;">
         <div id="toolbar"></div>
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
    
    	var formId = "${formId}";
    	var fieldName = "${fieldName}";
 	    var contentDataId = "${contentDataId}";
 	    var recordId = "${recordId}";
    	var success = "${success}";
    	var gridObj;
    	$(document).ready(function(){
        	if(success == "false"){
//        		$.error("${errorMsg}");
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
    		//initFrameHeight();
    	});
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
               type : "radio"
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
		   
			if(retHasSubDeeData(data) == "1"){
				if(!gridObj.p.vChange)
					gridObj.p.vChange = true;
		   		$("#viewFrame").attr("src","${path}/dee/deeDataDesign.do?method=selectSubDeeDataList&masterId="+data.id+"&formId="+formId+"&fieldName="+fieldName);
		   		gridObj.grid.resizeGridUpDown('middle');
		   	}
			else{
		   		$("#viewFrame").attr("src","${path}/dee/deeDataDesign.do?method=selectSubDeeDataList&masterId="+data.id+"&formId="+formId+"&fieldName="+fieldName);
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
		   var rows = gridObj.grid.getSelectRows();
		   var returnObj = new Object();
		   if(rows.length > 0){
//			   returnObj.deeMasterIds = deeMasterIds;
			   returnObj.selectMasterId = rows[0].id;
			   returnObj.success = true;
		   }else{
			   returnObj.success = false;
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
		   var url = "${path}/dee/deeDataDesign.do?method=hasSubDeeData&masterId="+data.id;
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
    </script>
</body>
</html>