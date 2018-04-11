<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="../../common/common.jsp"%>
<title>${ctp:i18n('ntp.syn.filter.config')}</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=ncOrgManager"></script>
<script type="text/javascript" language="javascript">
$().ready(function() {
	var manager = new ncOrgManager();
	$("#unitTree").tree({
	    idKey: "id",
	    pIdKey: "parentId",
	    nameKey: "name",
	    onClick : clk,
	    managerName: "ncOrgManager",
	    managerMethod: "showERPFilterTree",
	    asyncParam : {
	    	ncOrgCorp : $("#ncOrgCorp").val(),
	      },
	    nodeHandler: function(n) {
	    	if(n.data.type=='unit'){
	    		n.open = true;
	    	}else{
	    		n.open = false;
	    	}
	    }
	  });
	$("#unitTree").treeObj().reAsyncChildNodes(null, "refresh");
	manager.showERPFilterTree({"ncOrgCorp":$("#ncOrgCorp").val()});
	function clk(e, treeId, node) {
		$("#thirdOrgid").val(node.data.id);
		html();
	}
	$("#filterType").change(function(){
		html();
	});
	function html(){
		var filterType = $("#filterType").val();
		if(filterType==undefined){
			return;
		}
		var json = {"ncOrgCorp":$("#ncOrgCorp").val(),"thirdOrgid":$("#thirdOrgid").val(),"filterType":$("#filterType").val()};
		var manager = new ncOrgManager();
		var list = manager.getERPFilterList(json);
		$("#unSelect").html('');
		if(list!= null && list.length > 0){
			for(var i=0; i<list.length; i++){
				if($("#ListSelect option[value='"+list[i].id+"']").attr("type")==list[i].type){
					continue;
				}
				var typeText = getTypeText(list[i].type,1);
				//var name = $('<div/>').text(list[i].name).html();
				$("#unSelect").append("<option id='o"+i+"' value='"+list[i].id+"' type='"+list[i].type+"' code='"+list[i].code+"'></option>");
				//"+typeText+list[i].code+'&nbsp;&nbsp;&nbsp;&nbsp;'+name+"
				var va = typeText+list[i].code+'  '+list[i].name;
				$("#o"+i).text(va).html();
			}	
		}	
		//$("#unSelect").html(html);
	}
	$("#unSelect").dblclick(doSelect);
	$("#ListSelect").dblclick(remove);
	var listSelectHtml = "";
	$("#ListSelect").html('');
	<c:forEach items="${entityList}" var="entity">
		var typeText = getTypeText("${entity.type}",0);
		//listSelectHtml +="<option value='${entity.id}' type='${entity.type}'>"+typeText+"${entity.code}&nbsp;&nbsp;&nbsp;&nbsp;${entity.name}</option>";
		$("#ListSelect").append("<option value='${entity.id}' type='${entity.type}' code='${entity.type}'>"+typeText+"${entity.code}&nbsp;&nbsp;&nbsp;&nbsp;${ctp:toHTML(entity.name)}</option>");
	</c:forEach>
	html();
	//$("#ListSelect").html(listSelectHtml);
	$("#btnok").click(function(){
		var o = new Object();
		o.ncOrgCorp = $("#ncOrgCorp").val();
		var values = new Array();
		var options = $("#ListSelect option").each(function(i){
			var object = new Object();
			object.type= $(this).attr("type");
			object.text = $(this).text();
			object.value = $(this).val();
			values[i] = object;
		});
		o.values = values;
		if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
		var manager = new ncOrgManager();
        manager.saveFilterConfig(o, {
            success: function(rel) {
                try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
                window.close();
            }
        }); 
	});
	$("#btncancel").click(function() {
        window.close();
    });
});
</script>
<script type="text/javascript">
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
	function doSelectLike(){
		var selectLikeCode = $("#selectLike").val();
		if(!/^\*[0-9_a-zA-Z]+$/.test(selectLikeCode) && !/^[0-9_a-zA-Z]+\*$/.test(selectLikeCode)){ 
			$.alert("${ctp:i18n('ntp.syn.filter.message')}");
			return;
		}
		var isStart = false;
		var likeCode;
		if(selectLikeCode.indexOf("*")==0){
			isStart = false;
			likeCode = selectLikeCode.substring(1,selectLikeCode.length);
		}else{
			isStart = true;
			likeCode = selectLikeCode.substring(0,selectLikeCode.length-1);
		}
		var unSelect = document.getElementById("unSelect");
		var listSelect = document.getElementById("ListSelect");
		var items = unSelect.options;
		
		if(items != null && items.length > 0){
			var length = items.length;
			for(var i = length-1; i >= 0; i--){
				var selectIndex=-1;
				var item = items[i];
				var code = item.getAttribute("code");
				if(isStart && code.indexOf(likeCode)==0){
					selectIndex=item.index;
					listSelect.add(createOption(item.value, item.text,item.getAttribute("type")));
				}else if(!isStart && code.lastIndexOf(likeCode) == (code.length-likeCode.length) ){
					selectIndex=item.index;
					listSelect.add(createOption(item.value, item.text,item.getAttribute("type")));
				}
				if(selectIndex!=-1)
				{
					unSelect.remove(selectIndex);
					doSelect();
				}
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
        <div class="layout_west" layout="width:220" style="border: none;width:30%; margin-top: 20px;">
				<div id="unitTree"></div>
                <input type="hidden" id="ncOrgCorp" name="ncOrgCorp" value="${ctp:toHTML(ncOrgCorp)}">
                <input type="hidden" id="thirdOrgid" name="thirdOrgid" value="">
            	<input type="hidden" id="xhtml" name="xhtml">
		</div>
			<%-- 列表 --%>
        <div class="layout_center" id="center" style="overflow:hidden;">
        	<form name="addForm" id="addForm" method="post" target="delIframe">
			<div class="form_area" >
     		<table border="0" width="90%" height="10%" cellspacing="0" cellpadding="0" style="margin-top: 15px;margin-left: 20px;">
				<tr>
					<th nowrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n('application.type.label')}:</font></th>
					<td width="100%">
						<div class="common_selectbox_wrap">
                            <select id="filterType">
                                <option value="department">${ctp:i18n('cip.scheme.param.init.dept')}</option>
                                <option value="post">${ctp:i18n('cip.scheme.param.init.post')}</option>
                                <option value="level">${ctp:i18n('cip.scheme.param.init.duty')}</option>
                                <option value="people">${ctp:i18n('cip.scheme.param.init.user')}</option>
                            </select>
                        </div>
					</td>
				</tr>
			</table>
     
			<table border="0" width="90%" height="90%" cellspacing="0" cellpadding="0" style="margin-top: 15px;margin-left: 20px;">
				<tr>
					<td valign="bottom">&nbsp;${ctp:i18n('ntp.filter.select')}</<td>
					<td></td>
					<td valign="bottom">&nbsp;${ctp:i18n('ntp.filter.object')}</td>
				</tr>
				<tr>
					<td valign="top" align="center" width="250px;">
						<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0">
							<tr>
								<td>
								<select id="unSelect" 
									multiple="multiple" style="width:250px; height: 260px;margin-top: 0px;" size="18">
								</select>
								</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
							<tr><td align="left">${ctp:i18n('ntp.filter.code')}</td></tr>
							<tr><td>
								<div class="common_txtbox_wrap">
									<input type="text" id="selectLike" class="validate word_break_all" name="selectLike"
										validate="notNull:false,name:'编码相似过滤',maxLength:85">
								</div>
							</td></tr>
						</table>
						
					</td>
					<td width="12%" align="center" valign="top">
						<p>
							<a href="javascript:void(0)" style="width: 20px;margin-top: 60px;" class="common_button common_button_emphasize" onClick="doSelectAll()">&gt;&gt;</a>
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
						<p>
							<a href="javascript:void(0)" style="width: 20px; margin-top: 81px;" class="common_button common_button_emphasize" onClick="doSelectLike()">&gt;</a>
						</p>
					</td>
					<td valign="top" align="center">
						<select id="ListSelect" name="ListSelect"  multiple="multiple" style="width: 250px; height: 320px;margin-top: 0px;" size="18">
						</select>
					</td>
				</tr>
			</table>
			</div>
			</form>
			 <div class="stadic_layout_footer stadic_footer_height" style="margin-bottom: 8px;">
                    <div id="button" align="center" class="page_color button_container">
                        <div class="common_checkbox_box clearfix  stadic_footer_height padding_t_5 border_t">                           
                            <a id="btnok" href="javascript:void(0)" class="common_button common_button_emphasize margin_r_10">${ctp:i18n('common.button.ok.label')}</a>
                            <a id="btncancel" href="javascript:void(0)" class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
                        </div>
                    </div>
                </div>
        </div>
        
    </div>    
</body>
</html>