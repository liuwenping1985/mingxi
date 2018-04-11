<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../common/common.jsp"%>
<title></title>
<script type="text/javascript" src="${path}/ajax.do?managerName=cipSynSchemeManager"></script>
<script type="text/javascript" language="javascript">
$().ready(function() {
	var manager = new cipSynSchemeManager();
	$("#unitTree").tree({
	    idKey: "id",
	    pIdKey: "parentId",
	    nameKey: "name",
	    onClick : clk,
	    managerName: "cipSynSchemeManager",
	    managerMethod: "showERPFilterTree",
	    asyncParam : {
	    	schemeId : $("#schemeId").val(),
	    	thirdOrgid : $("#thirdOrgid").val(),
	    	thirdType : $("#thirdType").val()
	      },
	    nodeHandler: function(n) {
	    	if(n.data.type=='group' || n.data.type=='unit'){
	    		n.open = true;
	    	}else{
	    		n.open = false;
	    	}
	    }
	  });
	$("#unitTree").treeObj().reAsyncChildNodes(null, "refresh");
	manager.showERPFilterTree({"schemeId":$("#schemeId").val(),"thirdOrgid":$("#thirdOrgid").val(),"thirdType":$("#thirdType").val()});
	function clk(e, treeId, node) {
		$("#thirdOrgid").val(node.data.id);
		$("#thirdType").val(node.data.type);
		html();
		if(node.data.type=='unit' && $("#oldThirdType").val()!='group'){
			$("#type_unit").attr("disabled","disabled");
			if($("#type_unit").attr("checked")=="checked"){
				$("#type_dept").attr("checked","checked");
			}
		}
		if(node.data.type=='group'){
			$("#type_unit").removeAttr("disabled");
		}
	}
	if($("#thirdType").val()=='group'){
		$("#type_unit").attr("checked","checked");
	}
	if($("#thirdType").val()=='unit'){
		$("#type_unit").attr("disabled","disabled");
	}
	$("input[name='option']").change(function(){
		html();
	});
	function html(){
		var filterType = $("input[name='option']:checked").val();
		if(filterType==undefined){
			return;
		}
		var json = {"schemeId":$("#schemeId").val(),"thirdOrgid":$("#thirdOrgid").val(),"thirdType":$("#thirdType").val(),"filterType":filterType,"oldThirdType":$("#oldThirdType").val()};
		var list = manager.getERPFilterList(json);
		$("#unSelect").html('');
		if(list!= null && list.length > 0){
			for(var i=0; i<list.length; i++){
				if($("#ListSelect option[value='"+list[i].id+"']").attr("type")==list[i].type){
					continue;
				}
				var typeText = getTypeText(list[i].type,1);
				//var name = $('<div/>').text(list[i].name).html();
				$("#unSelect").append("<option id='o"+i+"' value='"+list[i].id+"' type='"+list[i].type+"'></option>");
				//"+typeText+list[i].code+'&nbsp;&nbsp;&nbsp;&nbsp;'+name+"
				var va = typeText+list[i].code+'  '+list[i].name ;
				$("#o"+i).text(va).html();
			}	
		}	
		//$("#unSelect").html(html);
	}
	$("#unSelect").dblclick(doSelect);
	$("#ListSelect").dblclick(remove);
	var listSelectHtml = "";
	var filterJson = window.parentDialogObj['filterConfig'].getTransParams().filterJson;
	$("#ListSelect").html('');
	if(filterJson!=''){
		var values = $.parseJSON(filterJson).values;
		for(var i=0; i<values.length; i++){
			//listSelectHtml +="<option value='"+values[i].value+"' type='"+values[i].type+"'>"+values[i].text+"</option>";
			$("#ListSelect").append("<option value='"+values[i].value+"' type='"+values[i].type+"'>"+$('<div/>').text(values[i].text).html()+"</option>");
		}
	}else{
		<c:forEach items="${entityList}" var="entity">
			var typeText = getTypeText("${entity.type}",0);
			//listSelectHtml +="<option value='${entity.id}' type='${entity.type}'>"+typeText+"${entity.code}&nbsp;&nbsp;&nbsp;&nbsp;${entity.name}</option>";
			$("#ListSelect").append("<option value='${entity.id}' type='${entity.type}'>"+typeText+"${entity.code}&nbsp;&nbsp;&nbsp;&nbsp;${ctp:toHTML(entity.name)}</option>");
		</c:forEach>
	}
	html();
	//$("#ListSelect").html(listSelectHtml);
});
</script>
<script type="text/javascript">
	function OK() {		
		var o = new Object();
		o.oldThirdOrgid=$("#oldThirdOrgid").val();
		o.thirdType = $("#thirdType").val();
		o.schemeId = $("#schemeId").val();
		o.filterType = $("input[name='option']:checked").val();
		var values = new Array();
		var options = $("#ListSelect option").each(function(i){
			var object = new Object();
			object.type= $(this).attr("type");
			object.text = $(this).text();
			object.value = $(this).val();
			values[i] = object;
		});
		o.values = values;
		return o;
	}
	function doSelectAll(){
		var unSelectHtml = $("#unSelect").html();
		$("#ListSelect").append(unSelectHtml);
		$("#unSelect").html('');
	}
	function doSelect(){
		var unSelect = document.getElementById("unSelect");
		var listSelect = document.getElementById("ListSelect");
		var items = unSelect.options;
		if(items != null && items.length > 0){
		    var selectIndex=-1;
			for(var i = 0; i < items.length; i++){
				var item = items[i];
				if(item.selected){
					selectIndex=item.index;
					listSelect.add(createOption(item.value, item.text,item.getAttribute("type")));
				    break;
				}
			}
			if(selectIndex!=-1)
			{
				unSelect.remove(selectIndex);
				doSelect();
			}
		}
	}
	function removeAll(){
		var selectHtml = $("#ListSelect").html();
		var unSelectHtml = $("#unSelect").html();
		$("#unSelect").append(selectHtml);
		$("#ListSelect").html('');
	}
	function remove(){
	    var unSelect = document.getElementById("unSelect");
		var listSelect = document.getElementById("ListSelect");
		var items = listSelect.options;
		if(items != null && items.length > 0){
			   var selectIndex=-1;
			   var item;
			for(var i = 0; i < items.length; i++){
				item = items[i];
				if(item.selected){
				selectIndex=item.index;
				break;
				}
			}
			if(selectIndex!=-1)
				{
				listSelect.remove(selectIndex);
				unSelect.add(createOption(item.value, item.text,item.getAttribute("type")));
				  remove();
				}
		}
	}
	function createOption(value, text,type){
		var option = document.createElement("option");
		option.value = value;
		option.text = text;
		option.setAttribute("type",type);
		return option;
	}
	function getTypeText(type,a){
		var text  ;
		if(a == 0){
			text = "&nbsp;(";
		}
		else{
			text = " (";
		}
		if(type=='unit'){
			text+="${ctp:i18n('cip.scheme.param.init.unit')}";
		}else if(type=='department'){
			text+="${ctp:i18n('cip.scheme.param.init.dept')}";
		}else if(type=='post'){
			text+="${ctp:i18n('cip.scheme.param.init.post')}";
		}else if(type=='level'){
			text+="${ctp:i18n('cip.scheme.param.init.duty')}";
		}else if(type=='people'){
			text+="${ctp:i18n('cip.scheme.param.init.user')}";
		}
		if(a == 0){
			text+=")&nbsp;&nbsp;";
		}
		else{
			text+=")  ";
		}
		return text;
	}
</script>
</head>
<body scrolling="no">
	<div class="comp" comp="type:'layout'" id="layout">		
        <%-- 左侧树组件 --%>
        <div class="layout_west" layout="width:220" style="border-left: none;width:30%;">
				<div id="unitTree" style="margin-top: 15px;"></div>
                <input type="hidden" id="schemeId" name="schemeId" value="${ctp:toHTML(schemeId)}">
            	<input type="hidden" id="thirdOrgid" name="thirdOrgid" value="${ctp:toHTML(thirdOrgid)}">
            	<input type="hidden" id="thirdType" name="thirdType" value="${ctp:toHTML(thirdType)}">
            	<input type="hidden" id="oldThirdOrgid" name="oldThirdOrgid" value="${ctp:toHTML(thirdOrgid)}">
            	<input type="hidden" id="oldThirdType" name="oldThirdType" value="${ctp:toHTML(thirdType)}">
            	<input type="hidden" id="xhtml" name="xhtml">
			</div>
			<%-- 列表 --%>
        <div class="layout_center" id="center" style="overflow:hidden;">
     
			<table border="0" width="90%" height="100%" cellspacing="0" cellpadding="0" style="margin-top: 10px;margin-left: 20px;">
				<tr>
					<td width="100%" colspan="3">
						<div class="common_radio_box clearfix">
							    <label for="type_unit" class="margin_r_10 margin_l_15 hand">
							        <input type="radio" value="unit" id="type_unit"  name="option" class="radio_com">${ctp:i18n('cip.scheme.param.init.unit')}</label>
							    <label for="type_dept" class="margin_r_10 hand">
							        <input type="radio" value="department" id="type_dept"  name="option" class="radio_com" checked="checked">${ctp:i18n('cip.scheme.param.init.dept')}</label>
							    <label for="type_post" class="margin_r_10 hand">
							        <input type="radio" value="post" id="type_post"  name="option" class="radio_com">${ctp:i18n('cip.scheme.param.init.post')}</label>
							    <label for="type_level" class="margin_r_10 hand">
							        <input type="radio" value="level" id="type_level"  name="option" class="radio_com">${ctp:i18n('cip.scheme.param.init.duty')}</label>
							    <label for="type_people" class="margin_r_10 hand">
							        <input type="radio" value="people" id="type_people"  name="option" class="radio_com">${ctp:i18n('cip.scheme.param.init.user')}</label>
						</div>
					</td>
				</tr>
				<tr>
					<td valign="top" align="center">
						<select id="unSelect" 
							multiple="multiple" style="width:250px; height: 320px;margin-top: 10px;" size="18">
						</select>
					</td>
					<td width="10%" align="center" valign="top">
						<p>
							<a href="javascript:void(0)" style="width: 20px;margin-top: 80px;" class="common_button common_button_emphasize" onClick="doSelectAll()">&gt;&gt;</a>
						</p>
						<br />
						<p>
							<a href="javascript:void(0)" style="width: 20px;" class="common_button common_button_emphasize" onClick="doSelect()">&gt;</a>
						</p>
						<br/>
						<p>
							<a href="javascript:void(0)" style="width: 20px;" class="common_button common_button_emphasize" onClick="remove()">&lt;</a>
						</p>
						<br/>
						<p>
							<a href="javascript:void(0)" style="width: 20px;" class="common_button common_button_emphasize" onClick="removeAll()">&lt;&lt;</a>
						</p>
					</td>
					<td valign="top" align="center">
						<select id="ListSelect" name="ListSelect"  multiple="multiple" style="width: 250px; height: 320px;margin-top: 10px;" size="18">
						</select>
					</td>
				</tr>
			</table>
        </div>
    </div>    
</body>
</html>