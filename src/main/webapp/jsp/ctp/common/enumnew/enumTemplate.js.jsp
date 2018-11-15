<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.ctp.common.ctpenumnew.*"%>
<script type="text/javascript">
	//记录当前选中的节点id,以便于刷新用
	var refreshId = null;
	//记录当前选中的节点id及父id串(id1,id2,id3),以便于刷新用
	var refreshIds = "";
	//表格对象
	var gridObj;
	//枚举选项卡类别 1系统枚举 2公共枚举 3单位枚举4选择枚举5单位图片枚举
	var enumType = ${enumType};
	//登录角色类型 1系统管理员2单位管理员（表单管理员）
	var roleType = ${roleType};
	//是否是单位管理员
	var isOrgAdmin = ${isOrgAdmin};
	//OA版本Id
	var productId = ${productId};
	//是否有连续添加
	var isHasContinue = false;
	var totalNum = 0;
	//树结构参数
	var treeParams = {
	        onClick : nodeClk,
	        onAsyncSuccess: zTreeOnAsyncSuccess,
	        idKey : "id",
	        pIdKey : "pId",
	        nameKey : "name",
	        managerName : "enumManagerNew",
	        managerMethod : "getEnumListTree",
	        enableCheck : false,
	        enableEdit : false,
	        enableAsync : true,
	        enableRename : false,
	        enableRemove : false,
	        nodeHandler : function(n) {
	        	n.isParent = true;
	        	if(n.data.id == -1 || $("#data").val() != "" || refreshIds.indexOf(n.data.id) != -1){
		        	n.open = true;
	        	}
	        }
	};
	//页面加载js方法
	$().ready(function() {
		window.setTimeout(function(){
			var centerHeight = $("#center").height(), center_northHeight = $("#center_north").height();
			//ie6下单独处理
			if ($.browser.msie && ($.browser.version == "6.0" || $.browser.version == "7.0"|| $.browser.version == "8.0") && !$.support.style) { 
				$("#content").height(centerHeight-center_northHeight*2-30);
			}else{
				$("#content").height(centerHeight-center_northHeight);
			}
			//初始化树
			initTree();
			//初始化表格
			createTable(1);
			//初始化
			init();
		},500);
	});
	
	function init(){
		//初始化页面元素
		initPageDom();
		//初始化页面事件
		initPageEvent();
	}
	//初始化页面元素
	function initPageDom(){
		initDisOrHide();
	}
	//初始化页面元素显示及隐藏
	function initDisOrHide(){
		if(enumType == <%=Enums.EnumTabType.SYSTEMENUM.getKey()%>){
			if(roleType == <%=Enums.EnumAdminRoleType.SYSTEMADMINENUM.getKey()%> || (isOrgAdmin == true && (productId == 0 || productId == 7))){
				//----系统管理员下的系统枚举----或者是A6企业版本下面的单位管理员
				setLayOut();
				//显示表格值
				activeTable(null,0);
				createSysToolBar(4);
				$("#orgcondition").addClass("hidden");
				$("#condition_box").addClass("hidden");
			}
		}else if(enumType == <%=Enums.EnumTabType.PUBLICENUM.getKey()%>){
			if(roleType == <%=Enums.EnumAdminRoleType.SYSTEMADMINENUM.getKey()%> || (isOrgAdmin == true && (productId == 0 || productId == 7))){
				//----系统管理员下的公共枚举----
				$("#orgcondition").addClass("hidden");
				$("#condition_box").removeClass("hidden");
				createToolBar(1);
			}else if(roleType == <%=Enums.EnumAdminRoleType.ORGADMINENUM.getKey()%> && !(isOrgAdmin == true && (productId == 0 || productId == 7))){
				//----单位管理员下的公共枚举----
				setLayOut();
				$("#orgcondition").addClass("hidden");
				$("#condition_box").removeClass("hidden");
			}
			//显示表格值
			activeTable(null,0);
		}else if(enumType == <%=Enums.EnumTabType.UNITIMAGEENUM.getKey()%>){
            $("#orgcondition").addClass("hidden");
            $("#condition_box").removeClass("hidden");
            createToolBar(1);
            //显示表格值
            activeTable(null,0);
        }else if(enumType == <%=Enums.EnumTabType.ORGENUM.getKey()%>){
			if(roleType == <%=Enums.EnumAdminRoleType.SYSTEMADMINENUM.getKey()%>){
				//系统管理员下的单位枚举
				setLayOut();
				$("#condition_box").addClass("hidden");
				if(productId == 1){
					//A8企业版本不应该有下列单位查询框，默认全部查询出来
					//显示表格值
					activeTable(null,0);
				}else{
					//单位下拉树事件初始化
					orgChange();
					$("#orgcondition").removeClass("hidden");
				}
			}else if(roleType == <%=Enums.EnumAdminRoleType.ORGADMINENUM.getKey()%>){
				//单位管理员下的单位枚举
				$("#orgcondition").addClass("hidden");
				$("#condition_box").removeClass("hidden");
				createToolBar(1);
				//显示表格值
				activeTable(null,0);
			}
		}
	}
	//设置layout公共方法
	function setLayOut(){
		var layout = $("#layout").layout();
		layout.setNorth(0);
		layout.setNorthSp(false);
		if(enumType != <%=Enums.EnumTabType.SYSTEMENUM.getKey()%>){
			$("#content").height($("#content").height() + 30);
		}
		$("#north").removeAttr("style");
	}
	//初始化页面事件
	function initPageEvent(){
		$("#condition").change(function(){
			showNextSpecialCondition(this);
		});
		$("#searchBtn").click(function (){
			search();
		});
		$("#data").keydown(function(e){
			if(e.keyCode == 13) {
				search();
			}
	 	});
		$("#searchSysBtn").click(function (){
			sysSearch();
		});
	}
	//change枚举查询框
	function showNextSpecialCondition(obj){
		$("#data").val("");
		//刷新树
		search();
	    if($(obj).val()==""){
	        $("#editTr").removeClass("hidden").addClass("hidden");
	    }else{
	    	$("#editTr").removeClass("hidden");
	    }
	}
	//搜索按钮搜索事件
	function search(){
		$("#searchBtn").unbind("click");
	    _currentNodeId = null;
		var selectedValue  = $("#condition").val();
		var validateStr = selectedValue == "enumName" ? "name:'${ctp:i18n('metadata.select.enum.name')}',type:'string',avoidChar:'&&quot;&lt;&gt;\\\\'" : "name:'${ctp:i18n('metadata.select.value.name')}',type:'string',avoidChar:'&&quot;&lt;&gt;\\\\'";
		$("#data").attr("validate",validateStr);
		$("#data").validateChange(validateStr);
		var options = new Object();
		options.errorAlert = true;
		options.errorIcon = false;
		if($("#condition_box").validate(options)){
			searchRefreshTree(selectedValue);
		 	//刷一下toolbar,回到点击查询后回到最原始的toolbar.只针对系统管理员下的公共枚举,单位管理员下的单位枚举
		 	if((enumType == <%=Enums.EnumTabType.PUBLICENUM.getKey()%> && roleType == 1) 
		 			|| (enumType == <%=Enums.EnumTabType.ORGENUM.getKey()%> && roleType == 2)
		 			|| (enumType == <%=Enums.EnumTabType.UNITIMAGEENUM.getKey()%> && roleType == 2)){
		 		createToolBar(1);
		 	}
		}
		//搜索完以后，需要对右边表格显示进行刷新
		createTable(1);
		activeTable(null,0);
	}
	
	//搜索完刷新异步树
	function searchRefreshTree(selectedValue){
		var data = $("#data").val();
		var selOrgId = $("#orgselect").val();
		var enumsea = selectedValue == "enumName" ? data : "";
		var itemsea = selectedValue == "enumItemName" ? data : "";
		var params = {enumType:enumType,roleType:roleType,orgId:selOrgId,enumName:enumsea,itemName:itemsea};
	    treeParams.asyncParam  = params;
	 	$("#tree").empty();
	 	$("#tree").tree(treeParams);
	 	refleshTree("tree");
	}
	
	//-------------------------------ToolBar相关方法---------------------start
	//公共的顶层toolbar
	function createToolBar(type,nodeType){
		$("#toolbar_more").remove();//将toolbar的submenu移除，防止由于操作过快，造成相关的误操作
		$("#north").empty();
		$("#north").append("<div id=\"toolbar\"></div>");
		var currentToolbar = $("#toolbar").toolbar(getToolBarParam(type,nodeType));
        if(enumType == <%=Enums.EnumTabType.UNITIMAGEENUM.getKey()%>) {
            if (nodeType == 3) {
                currentToolbar.disabledAll()
            }
        }
	}
	//系统枚举单独的右边toolbar
	function createSysToolBar(type){
		$("#toolbar_center").empty();
		var current_toolbar = $("#toolbar_center").toolbar(getToolBarParam(type));
		if(type == 4){
			current_toolbar.disabled("new4");
			current_toolbar.disabled("delete4");
			//current_toolbar.disabled("excel4");
		}else{
			current_toolbar.enabled("new4");
			current_toolbar.enabled("delete4");
			//current_toolbar.enabled("excel4");
		}
		$("#searchSys").removeClass("hidden");
		$("#content").css("top","");
	}
	function getToolBarParam(type,nodeType){
		//这个方法可以做优化（可以通过json字符串组装拼接,通过按钮级进行配置）这里由于赶时间，先这样了。
		var toolBarParam = null;
		if(type == 1){
			toolBarParam = {isPager:false,
				    toolbar: [{id: "new1",name: "${ctp:i18n('common.toolbar.new.label')}",className: "ico16",subMenu:[{name:"${ctp:i18n('metadata.new.select.enumtype.name')}",click:newEnumType},{name:"${ctp:i18n('metadata.enum.name')}",click:newEnum}]},
				              {id: "editor1",name: "${ctp:i18n('common.toolbar.update.label')}",className: "ico16 editor_16",click:editorEnum},
				              {id: "delete1",name: "${ctp:i18n('common.button.delete.label')}",className: "ico16 del_16",click:delEnum},
				              {id: "move1",name: "${ctp:i18n('metadata.move.label')}",className: "ico16 move_16",click:moveEnum}]
			};
		}else if(type== 2){
			toolBarParam = {isPager:false,
				    toolbar: [{id: "new2",name: "${ctp:i18n('common.toolbar.new.label')}",className: "ico16",click:newEnum},
				              {id: "editor2",name: "${ctp:i18n('common.toolbar.update.label')}",className: "ico16 editor_16",click:editorEnum},
				              {id: "delete2",name: "${ctp:i18n('common.button.delete.label')}",className: "ico16 del_16",click:delEnum},
				              {id: "move2",name: "${ctp:i18n('metadata.move.label')}",className: "ico16 move_16",click:moveEnum}]
			};
		}else if(type == 3){
            if(enumType == <%=Enums.EnumTabType.UNITIMAGEENUM.getKey()%>) {
                if(nodeType == 3){
                    toolBarParam = {isPager: false,
                        toolbar: [
                            {id: "new3", name: "${ctp:i18n('common.toolbar.new.label')}", className: "ico16", disabled:true},
                            {id: "editor3", name: "${ctp:i18n('common.toolbar.update.label')}", className: "ico16 editor_16", disabled:true},
                            {id: "delete3", name: "${ctp:i18n('common.button.delete.label')}", className: "ico16 del_16", disabled:true}
                        ]
                    };
                }else{
                    toolBarParam = {isPager: false,
                        toolbar: [
                            {id: "new3", name: "${ctp:i18n('common.toolbar.new.label')}", className: "ico16", click: newEnumItem},
                            {id: "editor3", name: "${ctp:i18n('common.toolbar.update.label')}", className: "ico16 editor_16", click: editorEnumItem},
                            {id: "delete3", name: "${ctp:i18n('common.button.delete.label')}", className: "ico16 del_16", click: delEnumItem}
                        ]
                    };
                }
            }else{
                toolBarParam = {isPager: false,
                    toolbar: [
                        {id: "new3", name: "${ctp:i18n('common.toolbar.new.label')}", className: "ico16", click: newEnumItem},
                        {id: "editor3", name: "${ctp:i18n('common.toolbar.update.label')}", className: "ico16 editor_16", click: editorEnumItem},
                        {id: "delete3", name: "${ctp:i18n('common.button.delete.label')}", className: "ico16 del_16", click: delEnumItem},
                        {id: "excel3", name: "${ctp:i18n('form.formmasterdatalist.inportexport')}", className: "ico16 import_16", subMenu: [
                            {id: "export3", name: "${ctp:i18n('form.query.transmitexcel.label')}", className: "export_excel_16", click: exportEnumItem},
                            {id: "down3", name: "${ctp:i18n('form.formlist.downinfopath')}", className: "download_16", click: downTemplate},
                            {id: "import3", name: "${ctp:i18n('application.95.label')}", className: "ico16 import_16", click: importEnumItem}
                        ]}
                    ]
                };
            }
		}else if(type == 4){
			toolBarParam = {borderLeft:false,borderRight:false,borderTop:false,isPager:false,
				    toolbar: [{id: "new4",name: "${ctp:i18n('common.toolbar.new.label')}",className: "ico16"},
				              {id: "editor4",name: "${ctp:i18n('common.toolbar.update.label')}",className: "ico16 editor_16",click:editorEnum},
				              {id: "delete4",name: "${ctp:i18n('common.button.delete.label')}",className: "ico16 del_16"}]
			};
		}else if(type == 5){
			toolBarParam = {borderLeft:false,borderRight:false,borderTop:false,isPager:false,
				    toolbar: [{id: "new5",name: "${ctp:i18n('common.toolbar.new.label')}",className: "ico16",click:newEnumItem},
				              {id: "editor5",name: "${ctp:i18n('common.toolbar.update.label')}",className: "ico16 editor_16",click:editorEnumItem},
				              {id: "delete5",name: "${ctp:i18n('common.button.delete.label')}",className: "ico16 del_16",click:delEnumItem}]
			};
		}
		return toolBarParam;
	}
	//-------------------------------ToolBar相关方法---------------------end
	
	//-------------------------------树相关方法---------------------start
	//树刷新方法
	function refleshTree(o){
		$("#"+o).treeObj().reAsyncChildNodes(null, "refresh");
		//树刷新完成后允许再次查询
		$("#searchBtn").bind("click",function(){
			search();
		});
	}
	//初始化树方法
	function initTree(){
		var params = {enumType:enumType,roleType:roleType};
		if(productId == 1 && enumType == 3 && roleType == 1){
			//A8企业版本,系统管理员下的单位枚举应该全部查询出来。
			params = {enumType:enumType,roleType:-1};
		}
	    treeParams.asyncParam  = params;
	 	$("#tree").empty();
	 	$("#tree").tree(treeParams);
	 	refleshTree("tree");
	}
	//树节点单击事件
	var _currentNodeId = null;
	var treeTimeFn = null;
	function nodeClk(e, treeId, node){
		// 取消上次延时未执行的方法
		clearTimeout(treeTimeFn);
		//执行延时
		treeTimeFn = setTimeout(function(){
			nodeClick(e, treeId, node);
		},5);
	}
	function nodeClick(e, treeId, node) {
	    //防止双击
	    if (_currentNodeId != null && _currentNodeId == node.data.id) {
	        return;
	    }
	    _currentNodeId = node.data.id;
        
		//改变toolbar,系统枚举右边表顶
		if(enumType == 1 && node.data.id != -1){
			createSysToolBar(5);
		}else if(enumType == 1 && node.data.id == -1){
			createSysToolBar(4);
		}
		//改变toolbar,公共枚举并且是系统管理员或者单位枚举并且是单位管理员或者A6系统管理员公共枚举
		if(enumType == 2 && roleType == 1 || enumType==5 || enumType == 3 && roleType == 2 || enumType == 2 && isOrgAdmin == true && (productId == 0 || productId == 7)){
			if(node.data.id == -1){
				//点击根节点改变toolbar
				createToolBar(1,node.data.type);
			}else if(node.data.id != -1 && (node.data.type == 2 || node.data.type == 3)){
				//点击枚举或者枚举项改变toolbar
				createToolBar(3,node.data.type);
			}else if(node.data.id != -1 && node.data.type == 1){
				//点击枚举分类改变toolbar
				createToolBar(2,node.data.type);
			}
		}
		
		//加载表格结构,2,3枚举项表格,1枚举表格
    	if(node.data.type == 2 || node.data.type == 3){
    		createTable(2);
    	}else{
    		createTable(1);
    	}
    	//加载表格数据
    	activeTable(node.data.accountId,node.data.id,node.data.type);
    }
	//取得当前选中的树的节点id
    function getSelectTreeNode(){
    	  var treeObj = $.fn.zTree.getZTreeObj("tree");
    	  var selected = treeObj.getSelectedNodes();
    	  return selected[0]==undefined ? undefined : selected[0].data;
    }
	//递归获取某个id的所有父id的值,以id,id,字符串形式返回
	function getParentIds(id){
		if(id === -1) return "-1";
		var treeObj = $.fn.zTree.getZTreeObj("tree");
   	  	var nodes = treeObj.transformToArray(treeObj.getNodes());
		for(var i = 0;i < nodes.length;i++){
			if(nodes[i].id == id){
				return  nodes[i].id + "," + getParentIds(nodes[i].pId);
			}
		}
	}
	//异步加载树完成以后做回写操作
	function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
		var treeObj = $.fn.zTree.getZTreeObj("tree");
		var nodes = treeObj.getNodes();
		var childrens = treeObj.transformToArray(nodes);
		for(var i = 0;i < childrens.length;i++){
			if(refreshId == childrens[i].id){
				childrens[i].open = true;
				$("#tree").treeObj().selectNode(childrens[i],true);
				break;
			}
		}
	}
	//-------------------------------树相关方法---------------------end
	
	//-------------------------------表格相关方法---------------------start
	//动态显示表格数据
	function activeTable(accountId,enumId,nodeType) {
		var orgSelValue =  $("#orgselect").val();
		//系统枚举中的单位id
		if(roleType == 1 && orgSelValue != ""){
			accountId = orgSelValue;
		}
		var o = new Object();
		o.enumType = enumType;
		o.accountId = accountId == undefined ? null : accountId;
		enumId = enumId == -1 ? 0 : enumId;
		o.enumId = enumId == undefined ? null : enumId;
		o.nodeType = nodeType == undefined ? null : nodeType;
		$("#mytable").ajaxgridLoad(o);
	}
	//枚举表格定义延时
	var enumTimeFn = null;
	//枚举项定义延时
	var enumItemTimeFn = null;
	//枚举表格列表，点击事件
	function enumTableClick(data, r, c){
		// 取消上次延时未执行的方法
		clearTimeout(enumTimeFn);
		//执行延时
		enumTimeFn = setTimeout(function(){
			$("#bottomIframe").attr("src","${path }/enum.do?method=enumIndex&pageType=browse&nodeType=2&tabType="+enumType+"&roleType="+roleType+"&enumId="+data.id); 
		},300);
		
	}
	//枚举项表格列表，点击事件
	function enumItemTableClick(data,r,c){
		// 取消上次延时未执行的方法
		clearTimeout(enumItemTimeFn);
		enumItemTimeFn = setTimeout(function(){
			$("#bottomIframe").attr("src","${path }/enum.do?method=enumItemIndex&pageType=browse&tabType="+enumType+"&id="+data.id); 
		},300);
		
	}
	//枚举表格列表，双击事件
	function enumTableDbClick(data, r, c){
		// 取消上次延时未执行的方法
		clearTimeout(enumTimeFn);
		//系统管理员下的单位枚举,单位管理员下的公共枚举,不能修改
		if(!((enumType == 3 && roleType == 1) || (enumType == 2 && roleType == 2))){
			$("#bottomIframe").attr("src","${path }/enum.do?method=enumIndex&pageType=editor&nodeType=2&tabType="+enumType+"&roleType="+roleType+"&parentId="+getParentId()+"&enumId="+data.id);
		}
	}
	//枚举项表格列表，双击事件
	function enumItemTableDbClick(data,r,c){
		// 取消上次延时未执行的方法
		clearTimeout(enumItemTimeFn);
		//系统管理员下的单位枚举,单位管理员下的公共枚举,不能修改
		if(!((enumType == 3 && roleType == 1) || (enumType == 2 && roleType == 2))){
			var currentNode = getSelectTreeNode();
			var parentType = currentNode.type;
			$("#bottomIframe").attr("src","${path }/enum.do?method=enumItemIndex&pageType=editor&tabType="+enumType+"&parentType="+parentType+"&parentId="+getParentId()+"&id="+data.id); 
		}
	}
	//获取表格参数
	function getTableParam(type){
		var tableParam;
		//type为1表示枚举表格，为2表示枚举项表格
		if(type == 1){
			tableParam = {
		            colModel : [ {display : 'id',name : 'id',width : '5%',sortable : false,align : 'center',type : 'checkbox',hide:false,isToggleHideShow:true}, 
		                         {display : '${ctp:i18n("metadata.select.enum.name")}',name : 'enumname',width : '30%',sortable : true,align : 'left',hide:false,isToggleHideShow:true}, 
		                         {display : '${ctp:i18n("metadata.isRef.label")}',name : 'ifuse',width : '10%',sortable : true,align : 'left',hide:false,isToggleHideShow:true}, 
		                         {display : '${ctp:i18n("common.sort.label")}',name : 'sortnumber',width : '10%',sortable : true,align : 'center',hide:false,isToggleHideShow:true}, 
		                         {display : '${ctp:i18n("common.resource.body.description.label")}',name : 'description',width : '35%',sortable : true,hide:false,align : 'left',isToggleHideShow:true}],
		            showTableToggleBtn: false,
		            parentId: "content",
		            usepager:true,
		            customize:false,
		            click :enumTableClick,
		            dblclick:enumTableDbClick,
		            onNoDataSuccess:loadTableFail,
		            callBackTotle:callBackTotal,
		            isHaveIframe:true,
		            vChange: true,
		     	    vChangeParam: {
		     	    	overflow: "hidden",
		     	   		autoResize:true
		     		},
		            slideToggleBtn: true,
		            managerName : "enumManagerNew",
		            managerMethod : "enumTableList"
		     };
		}else{
            if(enumType == <%=Enums.EnumTabType.UNITIMAGEENUM.getKey()%>){
                tableParam = {
                    colModel: [
                        {display: 'id', name: 'id', width: '5%', sortable: false, align: 'center', type: 'checkbox', hide: false, isToggleHideShow: true},
                        {display: '${ctp:i18n("metadata.enumvalue.showvalue.label")}', name: 'showvalue', width: '30%', hide: false, sortable: true, align: 'left', isToggleHideShow: true},
                        {display: '${ctp:i18n("metadata.enumValue.label")}', name: 'enumvalue', width: '10%', sortable: true, align: 'left', hide: false, isToggleHideShow: true},
                        {display: '${ctp:i18n("metadata.isRef.label")}', name: 'ifuse', width: '8%', sortable: true, align: 'left', hide: false, isToggleHideShow: true},
                        {display: '${ctp:i18n("common.sort.label")}', name: 'sortnumber', width: '10%', sortable: true, align: 'center', hide: false, isToggleHideShow: true},
                        {display: '${ctp:i18n("metadata.unitImageEnum.imageBrowse.label")}', name: 'imageid', width: '30%', sortable: true, align: 'center', hide: false, isToggleHideShow: true}
                    ],
                    showTableToggleBtn: false,
                    isHaveIframe: true,
                    parentId: "content",
                    click: enumItemTableClick,
                    customize: false,
                    dblclick: enumItemTableDbClick,
                    onNoDataSuccess: loadTableFail,
                    //onSuccess:successFn,//翟峰的Bug，不再需要onmouseover事件了
                    callBackTotle: callBackTotal,
                    render: rend,
                    vChange: true,
                    vChangeParam: {
                        overflow: "hidden",
                        autoResize: true
                    },
                    slideToggleBtn: true,
                    managerName: "enumManagerNew",
                    managerMethod: "enumItemTableList"
                };
            }else {
                tableParam = {
                    colModel: [
                        {display: 'id', name: 'id', width: '5%', sortable: false, align: 'center', type: 'checkbox', hide: false, isToggleHideShow: true},
                        {display: '${ctp:i18n("metadata.enumvalue.showvalue.label")}', name: 'showvalue', width: '30%', hide: false, sortable: true, align: 'left', isToggleHideShow: true},
                        {display: '${ctp:i18n("metadata.enumValue.label")}', name: 'enumvalue', width: '14%', sortable: true, align: 'left', hide: false, isToggleHideShow: true},
                        {display: '${ctp:i18n("metadata.isRef.label")}', name: 'ifuse', width: '8%', sortable: true, align: 'left', hide: false, isToggleHideShow: true},
                        {display: '${ctp:i18n("common.sort.label")}', name: 'sortnumber', width: '10%', sortable: true, align: 'center', hide: false, isToggleHideShow: true},
                        {display: '${ctp:i18n("metadata.input.state.label")}', name: 'state', width: '15%', sortable: true, align: 'left', hide: false, isToggleHideShow: true},
                        {display: '${ctp:i18n("metadata.output.state.label")}', name: 'outputSwitch', width: '15%', sortable: true, align: 'left', hide: false, isToggleHideShow: true}
                    ],
                    showTableToggleBtn: false,
                    isHaveIframe: true,
                    parentId: "content",
                    click: enumItemTableClick,
                    customize: false,
                    dblclick: enumItemTableDbClick,
                    onNoDataSuccess: loadTableFail,
                    callBackTotle: callBackTotal,
                    render: rend,
                    vChange: true,
                    vChangeParam: {
                        overflow: "hidden",
                        autoResize: true
                    },
                    slideToggleBtn: true,
                    managerName: "enumManagerNew",
                    managerMethod: "enumItemTableList"
                };
            }
		}
		return tableParam;
	}
	//渲染停用启用显示
	function rend(txt,data, r, c,col) {
	      if (enumType != 5 && (col.name == "state" || col.name == "outputSwitch")){
	       	if(txt == 0){
	       		return '${ctp:i18n("common.state.invalidation.label")}';
	       	}else{
	       		return '${ctp:i18n("common.state.normal.label")}';
	       	}
	      }else if(enumType == 5 && col.name == "imageid"){
            var imgSrc = "${path}/fileUpload.do?method=showRTE&fileId="+data.imageId+"&expand=0&type=image";
            return "<img class='showImg' src='"+imgSrc+"' height=25 />";
          }else{
	        return txt;
	      }
	}
	//创建表格结构
	function createTable(type){
		$("#content").empty();
		$("#content").append("<table id=\"mytable\" class=\"flexme3\" style=\"display: none\"></table>"+
				"<div id=\"grid_detail\"><iframe id=\"bottomIframe\" src=\"\"  width=\"100%\" height=\"100%\" frameBorder=\"no\" scrolling=\"no\"></iframe></div>");
		gridObj = $("table.flexme3").ajaxgrid(getTableParam(type));
	}
	//-------------------------------表格相关方法---------------------end
	
	//-------------------------------toolbar按钮事件-----------------start
	//新建枚举分类
	function newEnumType(){
		var obj=new Array();
		obj[0]=window;
		var dialog = $.dialog({
		    url: "${path }/enum.do?method=enumIndex&pageType=new&tabType="+enumType+"&nodeType=1&roleType="+roleType+"&parentId=0",
		    title: '${ctp:i18n("metadata.manager.typename.new")}',
		    width:450,
		    height: 300,
		    targetWindow:top,
		    transParams:obj,
		    buttons: [{
		    	isEmphasize:true,
		        text: '${ctp:i18n("common.button.ok.label")}',
		        handler: function () {
		        	var issuccess = dialog.getReturnValue();
					if(issuccess){
						$.infor({
		    			   'msg': '${ctp:i18n("common.successfully.saved.label")}!',
		    			    ok_fn: function () {
			    			    window.location.reload();
		    			    }
		    			});
						dialog.close();
					}
		        }
		    }, {
		        text: "${ctp:i18n('common.toolbar.cancelmt.label')}",
		        handler: function () {
		            dialog.close();
		        }
		    }]
		});
	}
	//新建枚举
	function newEnum(){
	
		gridObj.grid.resizeGridUpDown('middle');
		$("#bottomIframe").attr("src","${path }/enum.do?method=enumIndex&pageType=new&tabType="+enumType+"&nodeType=2&roleType="+roleType+"&parentId="+getParentId()); 
	}
	//新建枚举项
	function newEnumItem(){
		gridObj.grid.resizeGridUpDown('middle');
		var currentNode = getSelectTreeNode();
		var parentType = currentNode.type;
		$("#bottomIframe").attr("src","${path }/enum.do?method=enumItemIndex&pageType=new&tabType="+enumType+"&parentType="+parentType+"&parentId="+getParentId()); 
		//修复IE8以下高度计算错误，需要的最小高度是208
		// if ($.browser.msie && ($.browser.version == "6.0" || $.browser.version == "7.0"|| $.browser.version == "8.0") && !$.support.style) { 
		// 	$("#grid_detail").css("height","208px");
		// }
	}
	//得到后台保存的父id,这里为什么父id初始值为0而不是-1,因为后台生成树会进行判断
	function getParentId(){
		var parentId;
		var snid = getSelectTreeNode();
		if(snid != undefined && snid.id != "" && snid.id != undefined&& snid.id != -1){
			parentId = snid.id;
		}else{
			parentId = 0;
		}
		return parentId;
	}
	//修改枚举分类或枚举
	function editorEnum(){
		gridObj.grid.resizeGridUpDown('middle');
		var ids = getOperateId(1,1);
		if(ids.length > 1){
			$.alert("${ctp:i18n('metadata.select.unique.record')}");
			return;
		}
		if(ids.length == 1){
			if(isEnumOperate()){
				//枚举操作
				$("#bottomIframe").attr("src","${path }/enum.do?method=enumIndex&pageType=editor&nodeType=2&tabType="+enumType+"&roleType="+roleType+"&parentId="+getParentId()+"&enumId="+ids[0]); 
			}else{
				var obj=new Array();
				obj[0]=window;
				//枚举分类操作
				var dialog = $.dialog({
				    url: "${path }/enum.do?method=enumIndex&pageType=editor&tabType="+enumType+"&nodeType=1&roleType="+roleType+"&parentId=0"+"&enumId="+ids[0],
				    title: '${ctp:i18n("metadata.manager.typename.editor")}',
				    width:350,
				    height: 300,
				    targetWindow:top,
				    transParams:obj,
				    buttons: [{
				    	isEmphasize:true,
				        text: '${ctp:i18n("common.button.ok.label")}',
				        handler: function () {
				        	var issuccess = dialog.getReturnValue();
							if(issuccess){
								$.infor({
					    			   'msg': '${ctp:i18n("common.successfully.saved.label")}!',
					    			    ok_fn: function () {
						    			    window.location.reload();
					    			    }
					    		});
								dialog.close();
							}
				        }
				    }, {
				        text: "${ctp:i18n('common.toolbar.cancelmt.label')}",
				        handler: function () {
				            dialog.close();
				        }
				    }]
				});
			}
		}
	}
	//修改枚举项
	function editorEnumItem(){
		gridObj.grid.resizeGridUpDown('middle');
		var ids = getOperateId(1,2);
		if(ids.length > 1){
			$.alert("${ctp:i18n('metadata.select.unique.record')}");
			return;
		}
		
		var rows = gridObj.grid.getSelectRows(); 
		
		if(ids.length > 0){
			var currentNode = getSelectTreeNode();
			var parentType = currentNode.type;
			$("#bottomIframe").attr("src","${path }/enum.do?method=enumItemIndex&pageType=editor&tabType="+enumType+"&parentType="+parentType+"&parentId="+getParentId()+"&id="+ids[0]); 
		}
	}
	//删除枚举分类及枚举
	function delEnum(){
		var ids = getOperateId(2,1);
		var operateType = 1;
		if(ids.length > 0){
			if(isEnumOperate()){
				//枚举操作
				operateType = 2;
			}else{
				//枚举分类操作
				operateType = 1;
			}
			//进行枚举或分类校验，校验枚举是否被引用
			var em = new enumManagerNew();
			em.validateEnumDel(operateType,ids.join(),{success:
				function(obj){
					if(obj){
						var dialog = $.confirm({
						    'msg': '${ctp:i18n("metadata.delete.alert.message.label")}',
						    ok_fn: function () {
						    	$("#delIframe").prop("src","${path }/enum.do?method=delEnum&nodeType="+operateType+"&ids="+ids.join());
						    	$("#delIframe").load(function (){
						    		if(operateType == 1){
						    			window.location.reload();
						    		}else{
						    			refreshPage(false);
						    		}
						    	});
							},
							cancel_fn:function(){dialog.close();}
						});
					}else{
						$.alert("${ctp:i18n('metadata.delete.isref.error.label')}!");
					}
				}
			});
		}
		
	}
	//删除枚举项
	function delEnumItem(){
		var ids = getOperateId(2,2);
		if(ids.length > 0){
			//1.判断该枚举项是否有下级节点
			//进行枚举或分类校验，校验枚举是否被引用
			var em = new enumManagerNew();
			em.validateEnumItemDel(ids.join(),{success:
				function(obj){
					if(obj == "success"){
						var dialog = $.confirm({
						    'msg': '${ctp:i18n("metadata.delete.alert.message.label")}',
						    ok_fn: function () { 
						    	$("#delIframe").attr("src","${path }/enum.do?method=delEnumItem&ids="+ids.join());
						    	$("#delIframe").load(function (){
						    		refreshPage(false);
						    	});
							},
							cancel_fn:function(){dialog.close();}
						});
					}else if(obj == "isRef"){
						$.alert("${ctp:i18n('metadata.delete.isref.error.label')}!");
					}else if(obj == "hasMore"){
						$.alert("${ctp:i18n('metadata.delete.exischild.error.label')}!");
					}else if(obj == "isSystem"){
						$.alert("${ctp:i18n('metadata.delete.issystem.error.label')}");
					}
				}
			});
		}
	}
	//导出枚举项
	function exportEnumItem(){
		var selNode = getSelectTreeNode();
		$("#delIframe").prop("src","${path }/enum.do?method=exportEnumItemList&parentType="+selNode.type+"&id="+selNode.id);
	}
	//下载模板
	function downTemplate(){
		$("#delIframe").prop("src","${path }/enum.do?method=downEnumItemTemplate");
	}
	//导入枚举项
	function importEnumItem(){
		insertAttachment("importEnumItemCallBk");
	}
	//导入枚举项excel的回调函数
	function importEnumItemCallBk(filemsg,repeat){
		var selNode = getSelectTreeNode();
		var fileId=filemsg.instance[0].fileUrl;
		//进行枚举或分类校验，校验枚举是否被引用
		var em = new enumManagerNew();
		em.saveDataFromImportExcel(selNode.id,selNode.type,fileId,repeat,{success:
			function(obj){
				if(obj == 'success'){
					$.infor({
			    		  'msg':"${ctp:i18n('formsection.import.success')}",
			    		  ok_fn:function (){
			    			  refreshPage(false);
			    		  }
			    	 });
				}else{
					$.alert(obj);
				}
			}
		});
	}
	//判断是枚举操作还是枚举分类操作
	function isEnumOperate(){
		var enumOperate = false;
		var rows = gridObj.grid.getSelectRows(); 
		if(rows.length > 0){
			//修改枚举操作
			enumOperate = true;
		}
		return enumOperate;
	}
	//返回最终进行操作的id集合,同时进行规则判断
	function getOperateId(operateType,objType){
		//operateType操作类型 1表示修改操作，2表示删除操作
		//objType 操作对象类型 1表示枚举或枚举分类,2表示枚举项
		var operateIdArray = new Array();
		//当前选中树节点id
		var currentTreeNode =  getSelectTreeNode();
		var currentTreeId = currentTreeNode == undefined ? "" : currentTreeNode.id;
		var rows = gridObj.grid.getSelectRows(); 
		if(currentTreeId == -1){
			if(rows.length > 0){
				for(var i = 0;i < rows.length; i++){
					operateIdArray[i] = rows[i].id;
				}
			}else{
				if(operateType == 1){
					$.alert("${ctp:i18n('metadata.update.root.error.label')}!");
				}else if(operateType == 2){
					$.alert("${ctp:i18n('metadata.delete.root.error.label')}!");
				}
			}
		}else if(currentTreeId != "" && currentTreeId != undefined && currentTreeId != -1){
			if(rows.length > 0){
				if(operateType == 1 && rows.length > 1){
					$.alert("${ctp:i18n('metadata.select.unique.record')}");
				}else if(operateType == 2 || operateType == 1 && rows.length == 1){
					for(var i = 0;i < rows.length; i++){
						operateIdArray[i] = rows[i].id;
					}
				}
			}else{
				if(objType == 1){
					operateIdArray[0] = currentTreeId;
				}else if(objType == 2){
					if(operateType == 1){
						$.alert("${ctp:i18n('metadata.select.update.record')}");
					}else if(operateType == 2){
						$.alert("${ctp:i18n('metadata.select.delete.record')}");
					}
				}
			}
		}else if(currentTreeId == undefined || currentTreeId == ""){
			if(rows.length > 0){
				if(operateType == 1 && rows.length > 1){
					$.alert("${ctp:i18n('metadata.select.unique.record')}");
				}else if(operateType == 2 || (operateType == 1 && rows.length == 1)){
					for(var i = 0;i < rows.length; i++){
						operateIdArray[i] = rows[i].id;
					}
				}
			}else{
				if(operateType == 1){
					$.alert("${ctp:i18n('metadata.select.update.record')}");
				}else if(operateType == 2){
					$.alert("${ctp:i18n('metadata.select.delete.record')}");
				}
			}
		}
		return operateIdArray;
	}
	//移动按钮操作
	function moveEnum(){
		var rows = gridObj.grid.getSelectRows(); 
		if(rows.length > 0){
			var idArray = new Array();
			for(var i = 0;i < rows.length; i++){
				idArray[i] = rows[i].id;
			}
			var obj = new Array();
			obj[0] = window;
			obj[1] = idArray.join();
			var dialog = $.dialog({
				url:"${path}/enum.do?method=moveEnumIndex&tabType="+enumType,
			    title : '${ctp:i18n("common.toolbar.move.label")}',
			    width:500,
				height:500,
				targetWindow:top,
				transParams:obj,
			    buttons : [{
				  isEmphasize:true,
			      text : "${ctp:i18n('common.button.ok.label')}",
			      id:"sure",
			      handler : function() {
				      var condi = dialog.getReturnValue();
				      if(condi){
				    	  dialog.close();
				    	  $.infor({
				    		  'msg':"${ctp:i18n('metadata.move.success.message')}",
				    		  ok_fn:function (){
				    			  window.location.reload();
				    		  }
				    	 });
				      }
			      }
			    }, {
			      text : "${ctp:i18n('common.button.cancel.label')}",
			      id:"exit",
			      handler : function() {
			        dialog.close();
			      }
			    }]
			  });
		}else{
			$.alert("${ctp:i18n('metadata.select.move.record')}");
		}
	}
	//-------------------------------toolbar按钮事件-----------------end
	//单位下拉树onchange事件 
	function orgChange(){
		$("#orgselect").change(function (){
			var selOrgId = $(this).val();
			if(selOrgId != ""){
				$("#condition_box").removeClass("hidden");
				var params = {enumType:enumType,roleType:roleType,orgId:selOrgId};
			    treeParams.asyncParam  = params;
			 	$("#tree").empty();
			 	$("#tree").tree(treeParams);
			 	refleshTree("tree");
			 	createTable(1);
			 	activeTable(null,0);
			}
		});
	}
	//刷新树页面及对应表格
	function refreshPage(isContinue){
		isHasContinue = isContinue;
		//当前选中节点列表
		var nodes = $("#tree").treeObj().getSelectedNodes();
		var selectedValue  = $("#condition").val();
		if(nodes[0]){
			refreshId = nodes[0]== undefined ? refreshId : nodes[0].id;
			refreshIds = nodes[0]== undefined ? refreshIds : getParentIds(nodes[0].pId) + "," +nodes[0].id;
			//initTree();
			if(selectedValue != undefined && selectedValue != ""){
				searchRefreshTree(selectedValue);
			}else{
				$("#tree").treeObj().reAsyncChildNodes(nodes[0], "refresh");
			}
			//加载表格数据
	    	activeTable(nodes[0].data.accountId,nodes[0].data.id,nodes[0].data.type);
	    	//是否选中连续添加
			if(isContinue){
				$("#bottomIframe").attr("src","${path }/enum.do?method=enumItemIndex&pageType=new&tabType="+enumType+"&parentType="+nodes[0].data.type+"&parentId="+nodes[0].id);
			}
		}else{
			window.location.reload();
		}
	}
	//取消事件
	function cancelPage(){
		$("#bottomIframe").attr("src","${path }/enum.do?method=explainDetail&enumType="+enumType+"&total="+totalNum);
	}
	//系统枚举toolbar查询事件
	function sysSearch(){
	    _currentNodeId = null;
		var o = new Object();
		o.enumType = enumType;
		var node = getSelectTreeNode();
		o.nodeType =  node == undefined ? 1 :node.type;
		o.searchValue = $("#name").val();
		o.enumId = getParentId();
		$("#mytable").ajaxgridLoad(o);
	}
	function loadExplainDetail(){
		if(!isHasContinue){
			$("#bottomIframe").attr("src","${path }/enum.do?method=explainDetail&enumType="+enumType+"&total="+totalNum);
			gridObj.grid.resizeGridUpDown('down');
		}else{
			gridObj.grid.resizeGridUpDown('middle');
		}
		isHasContinue = false;
	}
	function loadTableFail(){
		$("#bottomIframe").attr("src","${path }/enum.do?method=explainDetail&enumType="+enumType+"&total=0");
		gridObj.grid.resizeGridUpDown('down');
	}
	//返回表格总数回调函数
	function callBackTotal(n){
		totalNum = n;
		loadExplainDetail();
	}
    function successFn(){
        $(".showImg").mouseenter(function (){
            $(this).parent().css("height","auto");
            $(this).removeAttr("height");
        }).mouseleave(function (){
            $(this).parent().css("height","28px");
            $(this).attr("height",25);
        });
    }
</script>