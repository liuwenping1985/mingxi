<%--
 $Author: dengcg $
 $Rev: 509 $
 $Date:: 2012-07-21 00:08:40#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.d
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<title>表单列表</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=formFieldDesignManager"></script>
</head>
<body id='layout'>
<div class="layout_north" id="north">
</div>
<div class="layout_center" id="center" style="overflow:hidden;">
    <table class="flexme3" style="display: none" id="mytable"></table>
</div>
<script type="text/javascript">
var gridObj;
var parentDoc = window.dialogArguments.window;
var paramFormType = "${ctp:escapeJavascript(param.formtype)}";
var paramUniquetype = "${ctp:escapeJavascript(param.uniquetype)}";
$().ready(
	      function() {
	        new MxtLayout({
	          'id' : 'layout',
	          'northArea' : {
	            'id' : 'north',
	            'height' : 35,
	            'sprit' : false,
	            'border' : false
	          },
	          'centerArea' : {
	            'id' : 'center',
	            'border' : false
	          },
	          'successFn' : function() {
	             	gridObj = $("table.flexme3").ajaxgrid({
	              colModel : [ {
	                display : 'id',
	                name : 'id',
	                width : '4%',
	                sortable : false,
	                align : 'left',
	                type : 'radio'
	              }, {
	                display : "${ctp:i18n('form.base.formname.label')}",
	                name : 'name',
	                width : '45%',
	                sortable : true,
	                align : 'left'
	              }, {
	                display : "${ctp:i18n('form.base.formtype')}",
	                name : 'bindType',
	                width : '15%',
	                sortable : true,
	                align : 'left'
	              }, {
	                display : "${ctp:i18n('form.base.affiliatedsortperson.label')}",
	                name : 'ownerId',
	                width : '15%',
	                sortable : true,
	                align : 'left'
	              }, {
	                display : "${ctp:i18n('formsection.config.template.category')}",
	                name : 'categoryId',
	                width : '20%',
	                sortable : true,
	                align : 'left'
	              }],
	              managerName : "formFieldDesignManager",
	              parentId:'center',
	              render:rend,
	              resizable:false,
	              managerMethod : "relationFormList"
	            });
	            var o = new Object();
	            if($("#user",$(parentDoc.document)).attr("checked"))
	            	o.selectType = "1";
	            if($("#system",$(parentDoc.document)).attr("checked"))
	            	o.selectType = "2";
	            o.currentFormId = $("#currentFormId",$(parentDoc.document)).val();
	            if (paramFormType != "") {
                    o.formtype = paramFormType;
                }
	            if (paramUniquetype != "") {
                    o.uniquetype = paramUniquetype;
                }
	            $("#mytable").ajaxgridLoad(o);
	            function rend(txt, data, r, c) {
	              if (c==1){
	                return "<div class = 'grid_black'>" + txt + "</div>";
	             } else {
	               return txt;
	             }
	            }
	            function clk(data, r, c) {
	            	
	            }
	            function dblclk(data, r, c){
	            	
	            }
	          }
	        });
	        var categoryArray =new Array();
	        categoryArray[0] = {'value':"9999",'text':"全部应用"};
	        <c:forEach items="${formTemplateCategorys}" var="category" varStatus="status">
	        	categoryArray[categoryArray.length] = {'value':"${category.id }",'text':"${fn:escapeXml(category.name) }"};
	        </c:forEach>
	        var searchobj = $.searchCondition({
	        	top:5,
				right:10,
	            searchHandler: function(){
					var ssss = searchobj.g.getReturnValue();
				  	var o = new Object();
				  	if($("#user",$(parentDoc.document)).prop("checked"))
		            	o.selectType = "1";
		            if($("#system",$(parentDoc.document)).prop("checked"))
		            	o.selectType = "2";
		            o.currentFormId = $("#currentFormId",$(parentDoc.document)).val();
		            if (paramFormType != "") {
		                o.formtype = paramFormType;
		            }
		            if (paramUniquetype != "") {
                        o.uniquetype = paramUniquetype;
                    }
				  	var conditon=ssss.condition;
				  	if(conditon==="name"){
				  		o.name = ssss.value;
				    }else if(conditon==="category"){
				  		var category=ssss.value;
				  		if(category!=="9999"){
				  			o.categoryId=category;
				  		}
				  	}
					o.page = 1;
				  	$("#mytable").ajaxgridLoad(o);  	
	            },
	            conditions: [{
	                id: 'name',
	                name: 'name',
	                type: 'input',
	                text: "${ctp:i18n('form.base.formname.label')}",
	                value: 'name'
			   },{
	                id: 'category',
	                name: 'category',
	                type: 'select',
	                text: "${ctp:i18n('formsection.config.template.category')}",
	                value: 'category',
	                items: categoryArray
	            }]
	        });
	      });
	      

	function OK() {
		var gridObjArry = gridObj.grid.getSelectRows();
		if (gridObjArry.length == 0) {
			$.alert("${ctp:i18n('form.create.input.select.relation')}");
			return false;
		}
		if (gridObjArry[0].id == $("#relFormId",$(parentDoc.document)).val()) {
			return true;
		}
		parentDoc.formType = gridObjArry[0].formType;
		parentDoc.showSelectValue(gridObjArry[0].id, gridObjArry[0].name,
				gridObjArry[0].formType);
		parentDoc.showViewType(gridObjArry[0].id, gridObjArry[0].name,
				gridObjArry[0].formType, true);
		parentDoc.initRelationConditionField(gridObjArry[0].id, gridObjArry[0].name,
				gridObjArry[0].formType);
		parentDoc.showConditionField();
		$("#viewConditionId",$(parentDoc.document)).val("");//系统选择的条件ID要清空
		return true;
	}
</script>
</body>
</html>