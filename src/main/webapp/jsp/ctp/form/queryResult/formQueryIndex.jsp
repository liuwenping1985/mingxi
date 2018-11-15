<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>表单查询</title>
<style>
	.stadic_head_height{
		height:21px;
	}
	.stadic_body_top_bottom{
		bottom: 0px;
 		top:21px;
	}
</style>
<script>
    var isQuery = false;
	var treeParams = {
		onClick : queryClick,
		beforeDrag : function() {},
		beforeDrop : function() {},
		managerName : "formQueryResultManager",
		managerMethod : "getQueryList4Tree",
		idKey : "id",
		pIdKey : "parentId",
		nameKey : "name",
		<c:if test="${formType eq ''}">
		asyncParam : {formType:"1,2,3", templateCategoryId:"${param.templateCategoryId}"},
		</c:if>
		<c:if test="${formType != ''}">
		asyncParam : {formType:"${formType}", templateCategoryId:"${param.templateCategoryId}"},
		</c:if>
		enableCheck : false,
		enableEdit : false,
		enableRename : false,
		enableRemove : false,
		nodeHandler : function(n) {
		    if (n.data.id == '2' || isQuery) {
		        n.open = true;
		    }
		}
	};
	function nodeOpen(n){
		n.open = true;
	}
    $(document).ready(function(){
    	new inputChange($("#set_display"),"${ctp:i18n('form.query.clickToShow')}");//点击设置显示
    	new inputChange($("#sort_display"),"${ctp:i18n('form.query.clickToOrderBy')}");//点击设置排序
        new MxtLayout({
             'id': 'layout',
             'northArea': {
                'id': 'north',
                        'height':0,
                        'sprit':false,
						'border':false,
						'spritBar': false
            },
            'westArea': {
                'id': 'west',
                'width':220,
                'sprit': true,
                'minWidth':0,
                'maxWidth':500,
				'border': true
            },
            'centerArea': {
                'id': 'center',
                'border': true,
				'minHeight':20,
				'border': false
            }
        });
		$("#tree1").tree(getQueryParam());
		refleshTree("tree1");
		$("#tree2").tree(getMyQueryParam());
		refleshTree("tree2");

           $("#searchBtn").click(function() {
           	searchParam();
           });
           $("#data").keyup(function(e){
               if(e.keyCode ==13){
               	searchParam();
               }
           });
    });
    function searchParam(){
        if(!$("#condition_box").validate()){
            return;
        }
        isQuery = true;
        var dataVal = $("#data").val();
        dataVal = encodeURIComponent(dataVal);
    	if(treeParams.asyncParam==null){
    		treeParams.asyncParam = new Object();
    	}
        treeParams.asyncParam.condition = $("#condition").val();
        treeParams.asyncParam.data = dataVal;
     	$("#tree1").empty();
     	$("#tree1").tree(getQueryParam(dataVal));
     	refleshTree("tree1");
     	$("#tree2").empty();
     	$("#tree2").tree(getMyQueryParam(dataVal));
     	refleshTree("tree2");
    }

    function showNextSpecialCondition(obj){
    	$("#data").val("");
        if($(obj).val()==""){
            $("#editTr").removeClass("hidden").addClass("hidden");
        }else{
        	$("#editTr").removeClass("hidden");
        }
    }
    function refleshTree(o){
        if("tree1"==o){
        	count = 0;
        }
    	$("#"+o).treeObj().reAsyncChildNodes(null, "refresh");
    }

    function myqueryClick(e, treeId, treeNode) {
    	$("#tree1").treeObj().cancelSelectedNode();
    	if(treeNode.data.type == "query"){
        	$("iframe").prop("src","${path }/form/queryResult.do?method=queryExc&hidelocation=false&type=myQuery&queryId="+treeNode.data.id);
        }
    }

    function queryClick(e, treeId, treeNode) {
    	$("#tree2").treeObj().cancelSelectedNode();
    	if(treeNode.data.type == "query"){
        	$("iframe").prop("src","${path }/form/queryResult.do?method=queryExc&hidelocation=false&type=query&queryId="+treeNode.data.value);
        }
    }

    function getQueryParam(o){
    	var count = 0;
    	treeParams.managerMethod = "getQueryList4Tree";
    	treeParams.onClick = queryClick;
    	treeParams.nodeHandler = function(n){
    		if (n.data.id == '2'|| isQuery) {
    		      n.open = true;
    		    }
		    if(n.data.type=="query"){
			    count++;
		    }
        };
        treeParams.onAsyncSuccess=function(){
			$("iframe").prop("src","${path }/form/queryResult.do?method=queryMain&formType=${formType}&size="+count);
        };
                
    	return treeParams;
    }
    function getMyQueryParam(o){
    	treeParams.managerMethod = "getMyQueryList4Tree";
    	treeParams.onClick = myqueryClick;
    	treeParams.nodeHandler = function(n){
    		if (n.data.id == '2'||(o!=null&&o!="")) {
    		      n.open = true;
    		    }
        };
        treeParams.onAsyncSuccess=null;
    	return treeParams;
    }
</script> 
</head>
<body class="h100b overflow_hidden page_color" id='layout'>
	<div >
	<c:if test="${formType!='4'}">
		  <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'T05_formQuery'"></div>
        </c:if>
		<div class="layout_west" id="west" style="overflow:auto;">
			<div class="condition_box form_area margin_l_5 margin_r_5 margin_b_5 padding_t_10" id="condition_box" style="float:none;">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr >
					<td width="30%">
						<div class=" common_selectbox_wrap">
							<select id="condition" name="condition" onChange="showNextSpecialCondition(this)" class="margin_l_5 font_size12" style="width: 85px;height:22px">
								<option value="">--${ctp:i18n('form.query.chooseCondition')}--</option><!-- 选择条件 -->
								<option value="queryName">${ctp:i18n('form.flow.templete.name')}</option><!-- 模板名称 -->
                                <c:if test="${empty param.templateCategoryId}">
								    <option value="categoryName">${ctp:i18n('form.app.affiliatedapply.label')}</option><!-- 所属应用 -->
                                </c:if>
							</select>
						</div>
					</td>
					<td class="hidden" id="editTr" style="width: 55px">
                        <div class="common_txtbox_wrap" style="width: 55px">
                            <input type="text" name="${ctp:i18n('form.query.label.condition')}" id="data" value="" class="validate" validate="type:'string',avoidChar:'&&quot;&lt;&gt;'"/>
                        </div>
					</td>
					<td>
						<div class="left margin_l_5"  id="searchBtn"><EM class="ico16 search_16"></EM></div>
					</td>
				</tr>
			</table>
			<ul id="tree1" class="treeDemo_0 ztree" > </ul>
	        <ul id="tree2" class="treeDemo_0 ztree"> </ul>
        </div>
		</div>
	    <!--查询设置&结果-->
	    <div class="layout_center " id="center" style="overflow:hidden;">
			<iframe frameborder="0" width="100%" height="100%" src="${path }/form/queryResult.do?method=queryMain&formType=${formType}&templateCategoryId=${param.templateCategoryId}"> </iframe>
    	</div> 	
	</div>
</body>
</html>
