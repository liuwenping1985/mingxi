<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>选择枚举页面</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=subjectMapperManager"></script>
<script type="text/javascript" language="javascript">
$().ready(function() {
	$("#enumTree").tree({
	    idKey: "id",
	    pIdKey: "parentId",
	    nameKey: "name",
	    onClick : clk,
	    asyncParam : {
	    	enumType:$("#enumType").val(),
	    	searchType:"",
	    	searchData:"",
	    	unitId:$("#unitId").val()
	      },
	    managerName: "subjectMapperManager",
	    managerMethod: "showEnumTree",	    
	    nodeHandler: function(n) {
	    	n.isParent = true;
	    	n.open = true;
	    }
	  });
	$("#enumTree").treeObj().reAsyncChildNodes(null, "refresh");
	function clk(e, treeId, node) {
		//加载列表
	    var o = new Object();
		o.enumId=node.data.id;
		$("#enumId").val(node.data.id);
	    $("#mytable").ajaxgridLoad(o);
	}
	//列表显示
    var mytable = $("#mytable").ajaxgrid({
        colModel: [{
            display: 'id',
            name: 'id',
            width: '9%',
            sortable: false,
            align: 'center',
            type: 'checkbox'
        },
        {
            display: "${ctp:i18n('metadata.enumvalue.showvalue.label')}",
            sortable: true,
            name: 'showvalue',
            width: '50%'
        },
        {
            display: "${ctp:i18n('metadata.enumValue.label')}",
            sortable: true,
            name: 'enumvalue',
            width: '30%'
        }],
        width: "auto",
        managerName: "subjectMapperManager",
        managerMethod: "showEnumItemList",
        parentId:'center'
    });
	//树形结构搜索框
    $("#condition1").change(function(){
    	$("#data").val("");
    	if($("#condition1").val()==""){
	        $("#editTr1").removeClass("hidden").addClass("hidden");
	    }else{
	    	$("#editTr1").removeClass("hidden");
	    }
	});
	//搜索按钮点击事件
	$("#searchBtn").click(function (){
		var o = $("#enumTree").treeObj();
		var otherParam = o.setting.async.otherParam;
		otherParam.searchType = $("#condition1").val();
		otherParam.searchData = $("#data").val();
		otherParam.unitId = $("#unit").val();
		o.reAsyncChildNodes(null, "refresh");		
	});
    //单位下拉框change事件
  	$("#unit").change(function (){
  		if($(this).val()==""){
  			return;
  		}
  		$("#condition1").val("");
  		$("#condition1").trigger("change");
  		var o = $("#enumTree").treeObj();
  		var otherParam = o.setting.async.otherParam;
  		otherParam.searchType="";
  		otherParam.searchData="";
  		otherParam.unitId = $(this).val();
  		o.reAsyncChildNodes(null, "refresh");		
  	});
    var enumType = $("#enumType").val();
    if(enumType!="2"){
    	$("#unitDiv").show();
    }
});
</script>
</head>
<body scrolling="no">
	<div class="comp" comp="type:'layout'" id="layout">		
        <%-- 左侧树组件 --%>
        <div class="layout_west" layout="width:260" style="border-left: none;width:30%;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="3">
							<div class="common_selectbox_wrap hidden" style="width:95%" id="unitDiv">
								<select id="unit" name="unit">
									<option value="">
										<font size="12">--${ctp:i18n('metadata.manager.account.lable')}--</font>
									</option>
									<c:forEach items="${unitList}" var="unit">
										<option value="${unit.id}">
											<font size="12">&nbsp;&nbsp;&nbsp;&nbsp;${unit.name}</font>
										</option>
									</c:forEach>
								</select>
							</div>
						</td>
					</tr>
					<tr bordercolor="red">
						<td width="30%">
							<div class="margin_5">
								<select id="condition1" name="condition1">
									<option value="">
										<font size="12">--${ctp:i18n("metadata.select.find")}--</font>
									</option>
									<option value="enumName">
										<font size="12">${ctp:i18n('metadata.select.enum.name')}</font>
									</option>
									<option value="enumValueName">
										<font size="12">${ctp:i18n('metadata.select.value.name')}</font>
									</option>
								</select>
							</div>
						</td>
						<td width="50%" class="hidden" id="editTr1"><input
							type="text" name="data" id="data" value="" style="width: 95%"
							class="validate"
							validate="type:'string',avoidChar:'&&quot;&lt;&gt;'" /></td>
						<td>
							<div class="left margin_l_5" id="searchBtn">
								<EM class="ico16 search_16"></EM>
							</div>
						</td>
						</div>
					</tr>
				</table>
				<div id="enumTree"></div>
			</div>
			<%-- 列表 --%>
        <div class="layout_center" id="center" style="overflow:hidden;">
        	<table id="mytable" class="flexme3" style="display: none">            
            </table>
        	<input type="hidden" id="enumId" name="enumId" />
        	<input type="hidden" id="enumType" name="enumType" value="${enumType}"/>
        	<input type="hidden" id="unitId" name="unitId" value=""/>
        </div>
    </div>    
</body>
</html>
