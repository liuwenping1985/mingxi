<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${templateName}</title>
<style>
.overflow{overflow: hidden;}

.orgnazitionTree .treeList{
	background: #fff;
}
.orgnazitionTree .expandTip{
	height:100%;
	width:8px;
	padding-left: 2px;
}
.orgnazitionTree .companyCheck{
	height:23px;
	border:1px solid #dae3ea;
	line-height: 23px;
	background: #fff;
	margin-bottom: 1px;
	padding-left:20px;
	color: #666;
	position: relative;
	font-size: 12px;
}
.orgnazitionTree .companyCheck em{
	position: absolute;
	right: 10px;
	opacity: 0.7;
	top:3px;
}
.treeList_div{overflow:auto;}
.overflow_hidden{overflow:hidden;}
</style>
<script type="text/javascript" src="${path}/common/form/common/showUnflowIndex.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
	var formId = "${formId}";
	var formTemplateId = "${formTemplateId}";
	var templateName = "${templateName}";
	var type = "${type}";
	var accountId = '${loginAccount}';
	var accountName = '${loginAccountName}';
	var isGroupVer = '${isGroupVer}';
	var model = "${modelType}";
	var isFormSection = "${isFormSection}";
	$(document).ready(function() {
		var layoutIndex = new MxtLayout({
            'id': 'layout',
           	<c:if test="${srcFrom == 'bizconfig'}">//判断是菜单进入，需要显示标题部分
	            'northArea': {
	               	'id': 'north',
	               	'height':40,
					'border': false
	           	},
           	</c:if>
	        <c:if test="${not empty searchField.key}">//判断是否设置了树形展现的字段,如果后台没有设置则不加载树
           	'westArea': {
               	'id': 'west',
               	'width':200,
               	'sprit': true,
               	'minWidth':0,
               	'maxWidth':500,
				'border': true,
				spiretBar: {
	                show: true,
	                handlerL: function () {
	                	layoutIndex.setWest(0);
	                },
	                handlerR: function () {
	                	layoutIndex.setWest(260);
	                }
	            }
           	},
           	</c:if>
           	'centerArea': {
               	'id': 'center',
               	'border': true
           	}
       	});
		var formField = $("#key").val();
		//判断是否设置了树形展现的字段,如果后台没有设置则不加载树
		if($.trim(formField) != ""){
			var accNameHeight = 0;
			<c:if test="${searchField.inputType == 'department' or searchField.inputType == 'multidepartment'}">
				accNameHeight = 26;
				$("#currentAccountId").html(accountName);
				$("#accountTree").tree({
			 		idKey: "id",
			 		pIdKey: "parentId",
			 		nameKey: "name",
			 		onClick: accountClk,
			 		enableAsync : true,
			 		managerName : "formDataManager",
			 		managerMethod : "getAccountTree",
			 		nodeHandler: function(n) {
			 			if(n.data.parentId == '-1') {
			 				n.open = true;
			 			} else {
			 				n.open = false;
		 				}
		    		}
		    	});
		        $("#accountTree").css("padding","10px 0 0 10px");
		    	$("#accountTree").treeObj().reAsyncChildNodes(null,"refresh",false);
			</c:if>
			//构建树形结构
			initTree({"accountId":accountId});
			
			$(".treeList_div").height($("#west").height() - accNameHeight - 50);
		}
    	
		var url = _ctxPath + "/form/formData.do?method=showUnflowFormDataList&formId="+formId+"&formTemplateId="+formTemplateId+"&type="+type+"&model="+model + "&unflowFormSectionMore="+isFormSection;
        $("#showUnflowData").attr("src",url);
        
	});
	//重置树
	function resetTree(){
		$("#inputSearch").val("");
		if($.trim($("#key").val()) != ""){
			$("#currentAccountId").html(accountName);
			initTree({"accountId":accountId});
		}
	}
	/**
	 * 取树对应字段的值
	 */
	function getTreeFieldVal(){
		var treeVal = new Object();
		var key = $.trim($("#key").val());
		if(!$.isNull(key)){//设置了树形显示字段
			var val = "";
			var nodes = $("#tree").treeObj().getSelectedNodes();
			for(var i=0;i<nodes.length;i++){
				var node = nodes[i];
				if("value" == node.data.type){
					treeVal[key] = node.data.id;
				}
			}
		}
		return treeVal;
	}
</script>
</head>
<body class="h100b overflow_hidden page_color" id='layout'>
	<%-- 隐藏字段 --%>
	<input type="hidden" id="accountId" value="${loginAccount }">
    <input type="hidden" id="key" value="${searchField.key }">
    <input type="hidden" id="inputType" value="${searchField.inputType }">
    <input type="hidden" id="formId" value="${formId}">
    <input type="hidden" id="formTemplateId" value="${formTemplateId }">
    	<div id='layout' class="comp" comp="type:'layout'">
    		<c:if test="${srcFrom == 'bizconfig'}">
		        <div class="layout_north" id="north">
		            <div style="background: #013675;height:30px;padding-top:10px;"><label style="color: white;margin-left:20px;">${ctp:toHTML(templateName) }</label> </div>
		        </div>
	        </c:if>
	        <div class="layout_center" id="center" style="overflow: hidden;">
                <iframe class="calendar_show_iframe" src="" width="100%" height="100%" frameborder="no" id="showUnflowData"></iframe>
	        </div>
	        <c:if test="${not empty searchField.key }">
		        <div class="overflow_hidden layout_west" id="west" style="background: #fff;">
		            <!-- 查询条件 -->
		        	<div class="margin_tb_10 margin_lr_10 " style="height:26px;width:200px;">
		        		<ul class="common_search">
						    <li  class="common_search_input" style="width:75%;margin-right:1px;"> 
						        <input class="search_input" id="inputSearch" type="text" onkeydown="if(event.keyCode == 13) searchTreeItem()" >
						    </li>
						    <li>
						        <a class="common_button search_buttonHand" href="javascript:void(0)" onclick="searchTreeItem()">
						            <em></em>
						        </a>
						    </li> 
						</ul> 
		        	</div>
		        	<c:if test="${searchField.inputType == 'department' or searchField.inputType == 'multidepartment'}">
		        		<%-- <input type="hidden" id="handOrgIds" value="${searchField.handOrgIds }"> --%>
			        	<div class="orgnazitionTree overflow">
							<div class="companyCheck" onclick="showMenu();">
								<span name="currentAccountId" id="currentAccountId"></span>
								<em id="downCheck" class="ico16 arrow_1_b"></em>
							</div>
	 						<div id="accountContent" class="border_all bg_color_white" style="width:99%;height:85%; position: absolute;display: none;overflow-y: auto;z-index: 1;" >
								<ul id="accountTree" name="accountTree" class="ztree" style="margin-top:0; width:85%;"></ul>
							</div> 
						</div>
					</c:if>
					<div class="treeList_div">
						<div id="tree"></div>
					</div>
		        </div>
	        </c:if>
	    </div>
</body>
</html>