<%--
 $Author:$
 $Rev:$
 $Date:: $:

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript"
	src="${path}/ajax.do?managerName=formTriggerDesignManager"></script>
<script type="text/javascript">
var obj;
var grid;
var paramFormcategory = "${ctp:escapeJavascript(param.formcategory)}";
	$(document).ready(function() {
		var category = new Array();
		<c:forEach items="${category}" var="category" varStatus="status">
		category[category.length] = {
			'value' : "${category.id }",
			'text' : "${fn:escapeXml(category.name) }"
		};
		</c:forEach>
		var searchobj = $.searchCondition({
			top : 10,
			right : 10,
			searchHandler : function() {
				//alert('执行查询')
				var ssss = searchobj.g.getReturnValue();
				if (ssss == null) {
					return;
				}
				var o = new Object();
				o.formId = "${formId}";
				o.ownerId = "${ownerId}";
				o.notTemplateId = "${notTemplateId}";
				o.forcheck = 'true';//后台过滤用,无实际意义
				if (paramFormcategory != "") {
				  o["formcategory"] = paramFormcategory;
                }
				o[ssss.condition] = ssss.value;
				grid.p.newp = 1;
				$("#mytable").ajaxgridLoad(o);
			},
			conditions : [ {
				id : 'templateName',
				name : 'templateName',
				type : 'input',
				text : "${ctp:i18n('form.seeyontemplatename.label')}",
				value : 'templateName'
			}, {
				id : 'formname',
				name : 'formname',
				type : 'input',
				text : "${ctp:i18n('form.base.formname.label')}",
				value : 'formname'
			}, {
				id : 'category',
				name : 'category',
				type : 'select',
				text : "${ctp:i18n('formsection.config.template.category')}",
				value : 'category',
				items : category
			}, {
				id : 'formcategory',
				name : 'formcategory',
				type : 'select',
				text : "${ctp:i18n('form.base.formtype')}",
				value : 'formcategory',
				items:[{
					value:"2",
					text:'${ctp:i18n("menu.appform.label") }'
				},{
					value:"3",
					text:'${ctp:i18n("menu.basedata.label") }'
				}]
			} ]
		});
		if (paramFormcategory != "") {
		    searchobj.g.hideItem("formcategory");
        }
		grid = $("table.flexme3").ajaxgrid({
			colModel : [{
				display : 'id',
	              name : 'id',
	              width : '8%',
	              sortable : false,
	              align : 'center',
	              type : 'radio'
			},{
				display : "${ctp:i18n('form.seeyontemplatename.label')}",
                name : 'name',
                width : '30%',
                sortable : true,
                align : 'left'
			},{
				display : "${ctp:i18n('form.base.formname.label')}",
                name : 'formname',
                width : '20%',
                sortable : true,
                align : 'left'
			},{
				display : "${ctp:i18n('formsection.config.template.category')}",
                name : 'category',
                width : '20%',
                sortable : true,
                align : 'left'
			},{
				display : "${ctp:i18n('form.base.formtype')}",
                name : 'formtype',
                width : '20%',
                sortable : false,
                align : 'left'
			}],
            managerName : "formTriggerDesignManager",
            managerMethod : "getFormTemplateList",
            click :clk,
            dblclick : dblclk,
            usepager : true,
            useRp : true,
            render: render,
            rp : 10,
            resizable : true,
            onSuccess : success,
            showTableToggleBtn: false,
                  parentId:"center",
                  vChange: true,
					vChangeParam: {
		                overflow: "hidden",
						autoResize:true
		            },
                  slideToggleBtn: true
		});
		var o = new Object();
		if (paramFormcategory != "") {
            o["formcategory"] = paramFormcategory;
        }
        $("#mytable").ajaxgridLoad(o);
	});
	
	function success(){
        $('.flexigrid :radio').removeClass('noClick');
        $('.flexigrid :radio').parent().removeClass('noClick');
    }
	function clk(data, r, c) {
		if (data.length){
			data = data[0];
		}
		obj = {};
		obj.formId = data.formId;
		obj.value= data.id;
		obj.name = data.name;
		grid.grid.resizeGridUpDown('middle');
		$("#viewFrame").prop("src","${path }/content/content.do?isFullPage=true&moduleId="+data.formId+"&moduleType=35&rightId=-2&viewState=4");
    }
    function dblclk(data, r, c){
		clk(data, r, c);
    }
    /**
     * 处理列表中所显示的数据
     * @param text 列表显示信息
     * @param row 列对象
     * @param rowIndex 列索引
     * @param colIndex 行索引
     * @param col 行对象
     */
    function render(text, row, rowIndex, colIndex,col){
    	if (rowIndex == 1){
    		
    	}
        return text;
    }
    function OK(){
    	if (!obj){
    		return "must";
    	}
    	return obj;
    }
</script>
</head>
<body>
	<div id='layout' class="comp" comp="type:'layout'">
		<div class="layout_north" id="north"  layout="height:40,sprit:false,border:false">
		&nbsp;
	    </div>
		<div class="layout_center" style="overflow: hidden;" id="center"
			layout="border:false">
			<table class="flexme3 " style="display: none" id="mytable"></table>
			<div id="grid_detail">
				<iframe id="viewFrame" src="" width="100%" height="100%"
					frameborder="no"></iframe>
			</div>
		</div>
	</div>
</body>
</html>