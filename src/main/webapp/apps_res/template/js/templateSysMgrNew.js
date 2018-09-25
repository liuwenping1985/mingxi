$(function() {
    // 普通用户进入协同工作-模板管理页面
    var isAccountAdmin = parent.isAccountAdmin;
    if(isAccountAdmin === "false" && $("#nowLocation a",parent.parent.document).length == 1)
      $("#nowLocation a",parent.parent.document)[0].innerHTML = $.i18n('template.templateSysMana.workTogether'); //协同工作
    
    toolbar =  $("#toolbar").toolbar({
        borderLeft:false,
        borderTop:false,
        borderRight:false,
        isPager:false,
        // 协同新建
        toolbar : [ 
			{id:"newCategory",name : $.i18n('form.base.newsort'),click : newCategory,className : "ico16"},//新建分类
            {id:"editCategory",name : $.i18n('form.base.updatesort'),click : editCategory,className : "ico16 editor_16"}, //修改分类
            {
	          id : "delete",
	          name : $.i18n('common.toolbar.delete.label'),//删除
	          className : "ico16 del_16",
	          click : function() {
	              var sum = 0 ;
	              var ids = new Array();
	              var i = 0;
	              $("#collaborationTemplateTable :checkbox").each(function(){
	                  if ($(this).attr("checked")) {
	                      sum ++ ;
	                      i ++ ;
	                      ids.push($(this).val());
	                  }
	              });
	              if (sum > 0){
	            	  $.alert($.i18n('template.choose.template.no'));
	            	  return;
	                //deleteTemplate(ids);//不能删除模版 只能删除分类
	              }else if(categoryType == infoCategory){
	            	  $.alert($.i18n('template.choose.template'));
	            	  return;
	              }else {
	                // 判断是否是选择的删除模版分类
	                if(deleteCategory()){
	                  $.alert($.i18n('template.category.chooseonedele.info'));
	                }
	              }
	          }
	        },
	        {
	          id : "auth",
	          name : $.i18n('common.toolbar.auth.label'),//授权
	          className : "ico16 authorize_16",
	          click : function() {
	              authTemplete();
	          }
	        },{
			    id : "lianhe",
			    name : $.i18n('govdoc.toolbar.lianhe.label'),//联合发文模板设置
			    className : "ico16 editor_16",
			    click : function() {
			        lianhefawen();
			    }
			  }
        ]
      });   
    if(typeof(govOnly) != "undefined" && govOnly == "true"){
    	$("#lianhe_a").remove();
    }
 // 判断是协同还是公文模版来显示新建的菜单
    if(categoryType === collCategory){
      toolbar.hideBtn("newEdoc");
      toolbar.hideBtn("modifyEdoc");
      toolbar.hideBtn("newInfoTb");
      toolbar.hideBtn("modifyInfoTb");
      $("#templateOperDes").attr("src",_ctxPath+"/collTemplate/collTemplate.do?method=templateOperDes");
    } else if(categoryType === edocCategory 
        || edocsendCategory === categoryType 
        || edocrecCategory === categoryType 
        || sginReportCategory === categoryType){
      toolbar.hideBtn("newColl");
      toolbar.hideBtn("modifyColl");
      toolbar.hideBtn("moveTo");
      toolbar.hideBtn("newInfoTb");
      toolbar.hideBtn("modifyInfoTb");
      //$("#templateOperDes").attr("src",_ctxPath+"/edocTempleteController.do?method=systemDetail");
    } else if(categoryType === infoCategory){
    	toolbar.hideBtn("newEdoc");
        toolbar.hideBtn("modifyEdoc");
        toolbar.hideBtn("newColl");
        toolbar.hideBtn("modifyColl");
        toolbar.hideBtn("moveTo");
        toolbar.hideBtn("replaceNode");
        var layout = $("#layout").layout();
        layout.setWest(0);
    }
    
});

function checkTemplateIsDelete(templateId){
	  var tm = new templateManager();
	  var result = tm.checkTemplateIsDelete(templateId);
	  if(result.isDel =='1'){
		  return true;
	  }else{
		  return false;
	  }
}
var iframeSrc=_ctxPath+"/form/bindDesign.do?method=editFrame";
$().ready(function() {
	  // 模版类型树
	  $("#templateTree").tree({
	    onClick : showTemplateNew,
	    idKey : "id",
	    pIdKey : "parentId",
	    nameKey : "name",
	    nodeHandler : function(n) {
	      n.isParent = true;
	    }
	  });

	  var treeObj = $.fn.zTree.getZTreeObj("templateTree");
	  var nodes = treeObj.getNodes();
	  if(categoryId && categoryId != ""){
	    var pnode = treeObj.getNodeByParam("id", categoryId, null);
	    expandNode(pnode);
	    showTemplateNew(null, "templateTree", pnode);
	  } else {
	    if (nodes.length>0) {
	        treeObj.expandNode(nodes[0], true, false, false);
	    }
	  }
	  treeObj.selectNode(nodes[0]);
	  $(treeObj.transformToArray(nodes)).each(function(index, elem){
	    if(elem .level == 1 && !elem.children){
	      expandNode(elem);
	    }
	  });

	  function test(e, treeId, node) {
	    window.self.location = _ctxPath + "/template/template.do?method=systemCollaborationTemplateList&categoryId="+node.id+"&categoryType=1";
	  }
	  
	  function showTemplateNew(e, treeId, node) {
	    if(!node)return;
	    var o = new Object();
	    o.categoryType = node.data.type ? node.data.type : categoryType;
	    o.categoryType = o.categoryType === 2 ? 1 : o.categoryType;
	    if(!node.data.type 
	        && (o.categoryType == "4" 
	            || o.categoryType == "401" 
	            || o.categoryType == "402"
	            || o.categoryType == "404")){
	      o.categoryType = node.data.id;
	    }
	    o.categoryId = node.id;
	    o.app = node.id;
	    app = node.id;
	    categoryId = node.id;
	    if(o.categoryId != "1"){
	      currentSelectCategoryId = o.categoryId;
	    }else{
	      currentSelectCategoryId = "";
	    }
	    if(adminflag && node.data.createMember != curUserId 
	        && node.data.id != "4" && (node.data.parentId === 0 || node.data.parentId === "1")){
	      canAdmin = false;
	      $("#modifyColl_a").addClass("common_menu_dis");
	      $("#delete_a").addClass("common_menu_dis");
	    }else{
	      canAdmin = true;
	      canCreateCategory = true;
	      $("#modifyColl_a").removeClass("common_menu_dis");
	      $("#delete_a").removeClass("common_menu_dis");
	    }
	    $("#templateOperDes").attr("src",_ctxPath+"/collTemplate/collTemplate.do?method=templateOperDes&total=0");
	    $("#collaborationTemplateTable").ajaxgridLoad(o);
	  }
	  var subjectWidth = 40;
	  var objectDis = new Object();
	  if(categoryType == infoCategory){
		if(isGroup) {
		  	objectDis ={
		  		display : $.i18n('template.categorylist.createUnit.label'),
				name : 'createUnit',
				width : '10%',
				sortable : true
			}
			subjectWidth = 30;
		}else{
			objectDis.isToggleHideShow = false;
			objectDis.hide = true;
		}
	  }else{
		  objectDis ={
			  		display :$.i18n('template.categorylist.type.label'),
					name : 'type',
					width : '10%',
					codecfg : "codeType:'java',codeId:'com.seeyon.apps.template.enums.TemplateTypeEnums'",
					sortable : true
				}
		subjectWidth = 30;
	  }
	  var grid = $("#collaborationTemplateTable").ajaxgrid({
	      colModel : [ {
	      display : '',
	      name : 'id',
	      width : '5%',
	      type : 'checkbox'
	    }, {
	      display : $.i18n('template.categorylist.name.label'),
	      name : 'subject',
	      width : subjectWidth+'%',
	      sortable : true
	    },objectDis,{
	      display : $.i18n('template.templatelist.partOf.label'),
	      name : "formId",
	      width : '11%',
	      sortable : true
	    },{
	      display : $.i18n('template.categorylist.modifytime.label'),
	      name : 'modifyDate',
	      width : '12%',
	      sortable : true
	    }, {
	      display : $.i18n('template.categorylist.auth.label'),
	      name : 'auth',
	      width : '25%',
	      sortable : true
	    }, {
	      display : $.i18n('template.categorylist.state.label'),
	      name : 'state',
	      width : '5%',
	      sortable : true,
	      codecfg : "codeType:'java',codeId:'com.seeyon.apps.template.enums.TemplateStateEnums'"
	    } ],
	    click: clickRow,
	    //dblclick: dbclickRow,
	    render : rend,
	    isHaveIframe:true,
	    managerName : "collaborationTemplateManager",
	    managerMethod : "selectTempletesNew",
	    parentId: $('.layout_center').eq(0).attr('id'),
	    vChange: true,
		vChangeParam: {
	        overflow: "hidden",
			autoResize:true
	    },
	    callBackTotle: function(obj){
	      //if(categoryType === collCategory){
	        $("#templateOperDes").attr("src",_ctxPath+"/collTemplate/collTemplate.do?method=templateOperDes&total="+obj);
	      //}
	      // 点击被授权的模板分类后，"修改""删除"按钮应该置灰，但不能点击使用
	      // 点击被授权的模板分类子分类时，，"修改""删除"按钮不置灰，能够点击使用 
	      $("#collaborationTemplateTable :checkbox").change(function(){
	        var v = $("#collaborationTemplateTable").formobj({
	          gridFilter : function(data, row) {
	            return $("input:checkbox", row)[0].checked;
	          }
	        });
	        if(v.length > 0){
	          $("#modifyColl_a").removeClass("common_menu_dis");
	          $("#delete_a").removeClass("common_menu_dis");
	        }else if(!canAdmin){
	          $("#modifyColl_a").addClass("common_menu_dis");
	          $("#delete_a").addClass("common_menu_dis");
	        }
	      });
	    },
	    slideToggleBtn: true
	  });
	  //alert($(".grid_checkbox > div > input").size());
	  //alert($(".grid_checkbox > div > input")[0].outerHTML);
	    $(".grid_checkbox > div > input").live("click",function(){
	    	if(this.checked){
	    		$("#modifyColl_a").removeClass("common_menu_dis");
	    		$("#delete_a").removeClass("common_menu_dis");
	    	}
	    });
	  
	  var o = new Object();
	  o.categoryType = categoryType;
	  o.categoryId = categoryId;
	  o.app = 4;
	  grid.grid.resizeGridUpDown('down');
	  $("#collaborationTemplateTable").ajaxgridLoad(o);
	  function clickRow(data, rowIndex, colIndex) {
		    var rows = grid.grid.getSelectRows();
			if(rows.length < 1){
				return;
			}
			var templateId = rows[0].id;
			if(checkTemplateIsDelete(templateId)){
				$.alert($.i18n("template.alert.del"));
				return;
			}
			if(categoryType === collCategory){
				$("#modifyColl_a").removeClass("common_menu_dis");
		        $("#delete_a").removeClass("common_menu_dis");
			  $("#templateOperDes").attr("src",_ctxPath+"/collTemplate/collTemplate.do?method=templateDetail&templateId="+templateId);
		    } else if(categoryType == edocCategory 
		        || edocsendCategory == categoryType 
		        || edocrecCategory == categoryType 
		        || sginReportCategory == categoryType){
		    	//if(app == "4"){
		    		nodeId = data.id;
					nodeModuleType = data.moduleType;
		    		workflowId = data.workflowId;
		    		$("#left_div").show();
		    		govdocShowDocPage();
					document.getElementById("editFrame").contentWindow.location.href = iframeSrc + "&connotEdit=true&fbid="+templateId;
		    		//$("#templateOperDes").attr("src",_ctxPath + "/content/content.do?isFullPage=true&moduleId="+data.extraMap["formId"]+"&moduleType=35&rightId=-2&viewState=4");
		    	//}else{
		    	//	$("#templateOperDes").attr("src",_ctxPath+"/edocTempleteController.do?method=systemDetail&templeteId="+templateId);
		    	//}
		    }else if(categoryType == infoCategory){
		    	$("#templateOperDes").attr("src",_ctxPath+"/govTemplate/govTemplate.do?method=templateInfoDetail&templateId="+templateId);
		    }
		  }

	  function dbclickRow(data,rowIndex, colIndex){
		 var id=data.id;
		 if(checkTemplateIsDelete(id)){
				$.alert($.i18n("template.alert.del"));
				return;
		 }
		 var categoryId = data.categoryId;
		 if(categoryType === collCategory){
		   window.self.location= projectPath + "/collTemplate/collTemplate.do?method=systemNewTemplate&id="+id+"&categoryId="+categoryId;
	     }else if(categoryType == edocCategory 
	             || edocsendCategory == categoryType 
	             || edocrecCategory == categoryType 
	             || sginReportCategory == categoryType){
	           window.self.location= projectPath + "/edocTempleteController.do?method=systemNewTemplete&templeteId="+id+"&from=SYS&categoryType="+categoryId;
	     }else if(categoryType == infoCategory){
	    	 window.self.location= projectPath + "/govTemplate/govTemplate.do?method=systemNewInfoTemplate&id="+id+"&from=SYS&appType="+infoCategory;
	     }
	  }
	  
	  function rend(txt,data, r, c) {

		 if(c===1){
			 txt = "<span class='grid_black'>"+txt;
		    // 附件
	      	if(data.hasAttsFlag === true){
	          txt = txt + "<span class='ico16 affix_16'></span>" ;
	      	}
		    var bodyType = $.trim(data.bodyType);
			 // 公文模板
			 if(data.type === "templete" || data.type === "template"||data.moduleType === 401||data.moduleType === 402||data.moduleType === 403||data.moduleType === 404){

			 }else{
				 if(bodyType != "" && bodyType != '10'){
					 txt = txt + "<span class='ico16 office"+data.bodyType+"_16'/>";
				 }
			 }

		    txt = txt +"</span>";
		 } 
		 if (c === 2){
		      // 公文模板
		      if(data.type === "templete" || data.type === "template"){
		          
		        if(data.moduleType === 19){
		            data.type = 'edoc_send';//直接修改这个值，用于排序
		            return 'edoc_send';
		          //return $.i18n('template.categorytree.senddoctemplate.label');
		        }else if(data.moduleType === 20){
		            data.type = 'edoc_rec';//直接修改这个值，用于排序
		            return 'edoc_rec';
		          //return  $.i18n('template.categorytree.recidoctemplate.label');
		        }else if(data.moduleType === 401){
		            data.type = 'edoc_send';//直接修改这个值，用于排序
		            return 'edoc_send';
		        }else if(data.moduleType === 402){
		            data.type = 'edoc_rec';//直接修改这个值，用于排序
		            return 'edoc_rec';
		        }else if(data.moduleType === 404){
		            data.type = 'sginReport';//直接修改这个值，用于排序
		            return 'sginReport';
		        }else{
		            data.type = 'sginReport';//直接修改这个值，用于显示
		            return 'sginReport';
		          //return $.i18n('template.categorytree.signdoctemplate.label');
		        }
		      }else{
		        return txt;
		      }
		    }
		 if(c == 3){
			 return data.extraMap["formName"];
		 }
	    return txt;
	  }
	  
	  // 搜索框
	  var searchobj = $.searchCondition({
	    top:2,
	    right:10,
	    searchHandler: function(){
	      var result = searchobj.g.getReturnValue();
	      if(result){
	        loadTable(result.condition, result.value);
	      }else{
	        //loadTable();
	      }
	    },
	    conditions: [
	      { id: 'subject',
	        name: 'subject',
	        type: 'input',
	        text: $.i18n('template.categorylist.name.label'),
	        validate: false,
	        value: 'subject'
	      }, 
	      { id: 'modifyDate',
	        name: 'modifyDate',
	        type: 'datemulti',
	        text: $.i18n('template.categorylist.modifytime.label'),
	        ifFormat: "%Y-%m-%d",
	        value: 'modifyDate'
	      }
	    ]
	  });
	  
	  if(categoryType === infoCategory){//信息报送模板
		  var o = new Object();
		  o.categoryType=32;
		  $("#collaborationTemplateTable").ajaxgridLoad(o);
	  }
	  
	});

//-----ready-----

function loadTable(condition, value){
	  var o = new Object();
	  o.categoryId = categoryId;
	  o.app = app;
	  //公文
	  if(categoryType == 4){
		o.categoryType = categoryId;
	  }
	  //协同
	  else{
		o.categoryType = categoryType;
	  }
	  if(o.categoryType !=4 && o.categoryType!=404 && o.categoryType!=401 && o.categoryType!=402){
		  o.categoryType = 401;
	  }
	  if(condition && value){
	    if("modifyDate" === condition){
	      if(value[1] != "" && value[0] > value[1]){
	        $.alert($.i18n('template.wrongdate.info'));
	        return;
	      }
	      eval("o.startdate = '" + value[0] +"';");
	      eval("o.enddate = '" + value[1] +"';");
	    }else{
	      eval("o."+condition+" = '" + escape(value) +"';");
	    }
	  }
	  $("#collaborationTemplateTable").ajaxgridLoad(o);
}

function getSelectTreeNode(){
	  var treeObj = $.fn.zTree.getZTreeObj("templateTree");
	  var selected = treeObj.getSelectedNodes();
	  var selectId = "";
	  if(selected && selected.length != 0){
	    selectId = selected[0].id;
	  }
	  return selectId;
}

function expandNode(pnode){
	  if(pnode){
	    var treeObj = $.fn.zTree.getZTreeObj("templateTree");
	    treeObj.expandNode(pnode, true, false, true);
	    var node = pnode.getParentNode();
	    if(node){
	      expandNode(node);
	    }
	  }
}

function addNode(pId, newNode){
	  var treeObj = $.fn.zTree.getZTreeObj("templateTree");
	  var pnode = treeObj.getNodeByParam("id", pId, null);
	  treeObj.addNodes(pnode, newNode);
}

function deleteTreeNode(pId){
	  var treeObj = $.fn.zTree.getZTreeObj("templateTree");
	  var pnode = treeObj.getNodeByParam("id", pId, null);
	  var ppnode = pnode.getParentNode();
	  treeObj.removeNode(pnode);
	  ppnode.isParent = true;
	  expandNode(ppnode);
	  var nodes = treeObj.getNodes();
	  treeObj.selectNode(nodes[0]);
}

function updateNode(pId, newNode){
	  var treeObj = $.fn.zTree.getZTreeObj("templateTree");
	  var node = treeObj.getNodeByParam("id", pId, null);
	  var pnode = treeObj.getNodeByParam("id", newNode.parentId, null);
	  node.name = newNode.name;
	  treeObj.updateNode(node);
	  treeObj.moveNode(pnode, node, "inner");
}

function checkDulipName(pId, name, id){
	  var treeObj = $.fn.zTree.getZTreeObj("templateTree");
	  var pnode = treeObj.getNodeByParam("id", pId, null);
	  var nodes = treeObj.getNodesByParam("name", name, pnode);
	  var result = false;
	  if(nodes && nodes.length > 0){
	    $(nodes).each(function(index, elem){
	      if((pnode.level - elem.level == -1) && elem.id != id){
	        result = true;
	      }
	    });
	  }
	  return result;
}

//新建模版类型
function newCategory(){
  var selectId = getSelectTreeNode();
  if(selectId == ""){
    $.alert($.i18n('template.category.choosecategory.info'));
    return;
  }
  var dialog = $.dialog({
    url : projectPath + '/collTemplate/collTemplate.do?method=showSystemCategoryNew&canAdmin='+canAdmin+'&parentId='+selectId+'&categoryType=0',
    width : 550, 
    height : 300,
    targetWindow:getCtpTop(),
    title : $.i18n('template.category.create.title'),
    buttons : [ {
      id:'okb',
      text : $.i18n('template.category.submit.label'),
      handler : function() {
    	dialog.disabledBtn('okb');
        var category = dialog.getReturnValue();
        if(category.valid){
          dialog.enabledBtn('okb');
          return;
        }
    	var rule = /^[^\|\\"'<>]*$/;
    	if(!(rule.test(category.name))) {
    		$.alert(categoryTip);
    		dialog.enabledBtn('okb');
    		return;
    	}
        var callerResponder = new CallerResponder();
        callerResponder.success = function(jsonObj) {
          var newNode = new Object();
          newNode.id = jsonObj.id;
          newNode.name = jsonObj.name;
          newNode.parentId = jsonObj.parentId;
          newNode.createMember = curUserId;
          addNode(jsonObj.parentId, newNode);
          //$.infor("${ctp:i18n('template.category.createsuccess.info')}");
          new MxtMsgBox({
				'title':$.i18n('system.prompt.js'),
			    'type': 0,
			    'imgType':0,
			    'msg': $.i18n('template.category.createsuccess.info'),
				ok_fn:function(){
					window.location.reload();
				}
			});
          dialog.close();
        };
        callerResponder.sendHandler = function(b, d, c) {
            var confirm = "";
            confirm = $.confirm({
                'msg': $.i18n('privilege.resource.confirmSubmit.info'),
                ok_fn: function () {
                    b.send(d, c);
                }
            });
        }
        var cm = new collaborationTemplateManager();
        var categoryNew = new Object();
        categoryNew.name = category.name;
        categoryNew.parentId = category.parentId;
        // 检查是否重名
        if(checkDulipName(category.parentId, category.name)){
          dialog.enabledBtn('okb');
          $.alert($.i18n('template.category.dulipname.info'));
          return;
        }
        categoryNew.sort = category.sort;
        categoryNew.description = category.description;
        categoryNew.type = category.type;
        categoryNew.orgAccountId = category.orgAccountId;
        categoryNew.createMember = category.createMember;
        categoryNew.modifyMember = category.modifyMember;
        categoryNew.auth = category.auth;
        cm.saveCategory(categoryNew, callerResponder);
      }
    }, {
      text : $.i18n('template.category.cancel.label'),
      handler : function() {
        dialog.close();
      }
    }]
  });
}


//修改模版类型
function editCategory(){
  if(!canAdmin){
    return;
  }
  var selectId = getSelectTreeNode();
  if(selectId == "" || selectId === "0"){
    return true;
  }
  if(selectId =='1'){
	  new MxtMsgBox({
			'title':$.i18n('system.prompt.js'),
		    'type': 0,
		    'imgType':2,
		    'msg': $.i18n('template.category.choosecategory.info'),
			ok_fn:function(){
			}
		});
	return false;
  }
  if(selectId =='4' || selectId =='401' || selectId =='402' || selectId == '404'){
	  new MxtMsgBox({
			'title':$.i18n('system.prompt.js'),
		    'type': 0,
		    'imgType':2,
		    'msg': "系统预置分类，不能修改",
			ok_fn:function(){
			}
		});
	return false;
  }
  var dialog = $.dialog({
    url : projectPath + '/collTemplate/collTemplate.do?method=editSystemCategoryNew&categoryId='+selectId+'&categoryType=0',
    width : 600, 
    height : 400,
    targetWindow:getCtpTop(),
    title : $.i18n('template.category.modify.title'),
    buttons : [ {
      text : $.i18n('template.category.submit.label'),
      handler : function() {
        var category = dialog.getReturnValue();
        if(category.valid){
          return;
        }
        var callerResponder = new CallerResponder();
        callerResponder.success = function(jsonObj) {
          var newNode = new Object();
          newNode.id = jsonObj.id;
          newNode.name = jsonObj.name;
          newNode.parentId = jsonObj.parentId;
          updateNode(selectId, newNode);
          //alert("${ctp:i18n('template.category.updatesuccess.info')}");
          new MxtMsgBox({
					'title':$.i18n('system.prompt.js'),
				    'type': 0,
				    'imgType':0,
				    'msg': $.i18n('template.category.updatesuccess.info'),
					ok_fn:function(){
						window.location.reload();
					}
				});
          dialog.close();
        };
        callerResponder.sendHandler = function(b, d, c) {
            var confirm = "";
            confirm = $.confirm({
                'msg': $.i18n('privilege.resource.confirmSubmit.info'),
                ok_fn: function () {
                    b.send(d, c);
                }
            });
        }
        var cm = new collaborationTemplateManager();
        var categoryNew = new Object();
        categoryNew.id = category.id;
        categoryNew.name = category.name;
        categoryNew.parentId = category.parentId;
        // 检查是否重名
        if(checkDulipName(category.parentId, category.name, categoryNew.id)){
          $.alert($.i18n('template.category.dulipname.info'));
          return;
        }
        categoryNew.sort = category.sort;
        categoryNew.description = category.description;
        categoryNew.type = category.type;
        categoryNew.orgAccountId = category.orgAccountId;
        // categoryNew.createMember = category.createMember;
        // categoryNew.modifyMember = category.modifyMember;
        categoryNew.auth = category.auth;
        cm.updateCategory(categoryNew, callerResponder);
      }
    }, {
      text : $.i18n('template.category.cancel.label'),
      handler : function() {
        dialog.close();
      }
    }]
  });
  return false;
}


//删除模版类型
function deleteCategory(){
  if(!canAdmin){
    return;
  }
  // 
  var treeObj = $.fn.zTree.getZTreeObj("templateTree");
  var selected = treeObj.getSelectedNodes();
  var nodes = treeObj.getNodes();
  if(selected[0].level == 0){
    $.alert($.i18n('template.category.chooseonedele.info'));
    return;
  }
  // 删除分类的时候加不能删除最后一个分类
  if(selected[0].level < 2 && nodes[0].children.length < 2){
    $.alert($.i18n('template.category.cantdeletelast.info'));
    return;
  }
  var selectId = getSelectTreeNode();
  if(selectId =='4' || selectId =='401' || selectId =='402' || selectId == '404'){
	  new MxtMsgBox({
			'title':$.i18n('system.prompt.js'),
		    'type': 0,
		    'imgType':2,
		    'msg': "系统预置分类，不能删除",
			ok_fn:function(){
			}
		});
	return false;
  }
  if(selectId == "" || selectId === "0"){
    return true;
  }
  var callerResponder = new CallerResponder();
  callerResponder.success = function(jsonObj) {
      if(jsonObj === $.i18n('template.category.deletesuccess.info')){
          deleteTreeNode(selectId);
          $.infor(jsonObj);
      }else{
          $.alert("当前公文模版类型下包含子类型或者模版，不能删除.");
      }
  };
  callerResponder.sendHandler = function(b, d, c) {
      var confirm = "";
      confirm = $.confirm({
          'msg': $.i18n('privilege.category.confirmSubmit.info'),
          ok_fn: function () {
              b.send(d, c);
          }
      });
  }
  var confirm = "";
  confirm = $.confirm({
      'msg': $.i18n('template.category.confirmdelete.info'),
      ok_fn: function () {
          var cm = new collaborationTemplateManager();
          cm.deleteCategory(selectId, callerResponder);
      }
  });
  return false;
}

//删除模版
function deleteTemplate(ids){
  var callerResponder = new CallerResponder();
  callerResponder.success = function(jsonObj) {
    $.infor($.i18n('template.deletesuccess.info'));
    loadTable();
  };
  callerResponder.sendHandler = function(b, d, c) {
      var confirm = "";
      confirm = $.confirm({
          'msg': $.i18n('privilege.category.confirmSubmit.info'),
          ok_fn: function () {
              b.send(d, c);
          }
      });
  }
  var ctm = new collaborationTemplateManager();
  var reV = ctm.getGovdocTemplateDepAuthFlag(ids);
  if(reV==true){
	  $.alert($.i18n('template.govdoc.msg.delete.lianhe.info'));
	  return false;
  }
  var confirm = "";
  confirm = $.confirm({
      'msg': $.i18n('template.confirmdelete.info'),
      ok_fn: function () {
          var cm = new collaborationTemplateManager();
          cm.deleteTemplete(ids, categoryType, callerResponder);
      }
  });
}


//设置默认模板 dy 2015-08-28
/*function doIsDefaultTemplate(ids){ var callerResponder = new CallerResponder();
  callerResponder.success = function(jsonObj) {
    $.infor(('成功设定为本单位的该类模板'));
    loadTable();
  };
  callerResponder.sendHandler = function(b, d, c) {
      var confirm = "";
      confirm = $.confirm({
          'msg': $.i18n('privilege.category.confirmSubmit.info'),
          ok_fn: function () {
              b.send(d, c);
          }
      });
  }
  var confirm = "";
  confirm = $.confirm({
      'msg': ('确定要设置该项目为默认模板？'),
      ok_fn: function () {
          var cm = new collaborationTemplateManager();
          //cm.deleteTemplete(ids, categoryType, callerResponder);
          cm.doIsDefaultTemplete(ids,callerResponder);
      }
  });
	
	}
*/
//停启用模版
function doInvalidateTemplete(state){
  var sum = 0 ;
  var ids = new Array();
  var i = 0;
  $("#collaborationTemplateTable :checkbox").each(function(){
      if ($(this).attr("checked")) {
          sum ++ ;
          i ++ ;
          ids.push($(this).val());
      }
  });
  if (sum > 0){
    var callerResponder = new CallerResponder();
    callerResponder.success = function(jsonObj) {
      loadTable();
    };
    callerResponder.sendHandler = function(b, d, c) {
        var confirm = "";
        confirm = $.confirm({
            'msg': $.i18n('privilege.category.confirmSubmit.info'),
            ok_fn: function () {
                b.send(d, c);
            }
        });
    }
    var cm = new collaborationTemplateManager();
    cm.updateInvalidateTemplete(ids, state, callerResponder);
  } else {
    // 判断是否是选择的删除模版分类
    $.alert($.i18n('template.needchoose.info'));
  }
}

// 模版授权
function authTemplete() {
  var sum = 0;
  var ids = new Array();
  var i = 0;
  $("#collaborationTemplateTable :checkbox").each(function() {
    if ($(this).attr("checked")) {
      sum++;
      i++;
      ids.push($(this).val());
    }
  });
  if (sum > 0) {
    var v = $("#collaborationTemplateTable").formobj({
      gridFilter : function(data, row) {
        return $("input:checkbox", row)[0].checked;
      }
    });
    var auth = v[0].auth;
    var authValue = v[0].authValue;
    //如果选择多个则不回填
    if(v.length > 1){
  	  auth = "";
  	  authValue = "";
    }
    var onlyLoginAccount = false;
    var selectTypeString = "Department,Team,Post,Level,Outworker,Account,Member";
    var panels = "Department,Team,Post,Level,Outworker,Account";
    if(categoryType == '4' || categoryType == '32'){
        panels = "Department,Team,Post,Level,Account";
    }
    selectPeopleAuth(ids, auth, authValue, panels, onlyLoginAccount, selectTypeString);
  } else {
    // 判断是否是选择的删除模版分类
    $.alert($.i18n('template.needchoose.info'));
  }
}

function selectPeopleAuth(ids, auth, authValue, panels, onlyLoginAccount, selectTypeString){
    $.selectPeople({
      text : auth,
      value : authValue,
      isNeedCheckLevelScope:false,
      type : 'selectPeople',
      panels : panels,
      selectType : selectTypeString,
      onlyLoginAccount : onlyLoginAccount,
      hiddenPostOfDepartment:true,
      minSize: 0,
      params: {
        value: authValue
      },
      callback : function(ret) {
        authSelectResult(ids, ret.value);
      }
    });
  }


function authSelectResult(ids, value) {
    var callerResponder = new CallerResponder();
    callerResponder.success = function(jsonObj) {
      loadTable();
    };
    callerResponder.sendHandler = function(b, d, c) {
        var confirm ="";
        confirm = $.confirm({
            'msg': $.i18n('privilege.category.confirmSubmit.info'),
            ok_fn: function () {
                b.send(d, c);
            }
        });
    }
    var cm = new collaborationTemplateManager();
    cm.updateTempleteAuth(ids, value, categoryType, callerResponder);
  }

// 移动
function moveTemplete() {
  var sum = 0;
  var ids = new Array();
  var i = 0;
  $("#collaborationTemplateTable :checkbox").each(function() {
    if ($(this).attr("checked")) {
      sum++;
      i++;
      ids.push($(this).val());
    }
  });
  if (sum > 0) {
    var template_tree_dialog = $.dialog({
      title : $.i18n('template.category.move.title'),
      url : projectPath + "/collTemplate/collTemplate.do?method=showCategoryTree&categoryType="+categoryType,
      width : 500,
      height : 400,
      targetWindow:getCtpTop(),
      buttons : [ {
        text : $.i18n('template.category.submit.label'),
        handler : function() {
          var pId = template_tree_dialog.getReturnValue();
          if(pId == 1){
        	  $.alert($.i18n('collaboration.template.move'));
        	  return;
          }
          var callerResponder = new CallerResponder();
          callerResponder.success = function(jsonObj) {
            loadTable();
          };
          callerResponder.sendHandler = function(b, d, c) {
              var confirm = "";
              confirm = $.confirm({
                  'msg': $.i18n('privilege.resource.confirmSubmit.info'),
                  ok_fn: function () {
                      b.send(d, c);
                  }
              });
          }
          var cm = new collaborationTemplateManager();
          //检查重名
          var reV = cm.checkTargethasDupName(ids,pId);
          if(reV){
          	$.alert(reV);
          	template_tree_dialog.close();
              return;
         	}
          cm.updateTempletePath(ids, pId, callerResponder);
          template_tree_dialog.close();
        }
      }, {
        text : $.i18n('template.category.cancel.label'),
        handler : function() {
          template_tree_dialog.close();
        }
      } ]
    });
  } else {
    // 判断是否是选择的删除模版分类
    $.alert($.i18n('template.needchoose.info'));
  }
  

}

function lianhefawen(){
	var dialog = $.dialog({
		url:_ctxPath + "/collTemplate/collTemplate.do?method=lianheTemplateSet",
	    title : $.i18n('govdoc.toolbar.lianhe.label'),//设置表单所属人
	    width:350,
		height:400,
		targetWindow:getCtpTop(),
		transParams:window,
	    buttons : [{
	    	text : $.i18n('collaboration.button.ok.label'),//确定
	    	id:"sure",
	    	handler : function() {
	    		var v = dialog.getReturnValue();
	    		if(v) {
	    			var manager = new govdocTemplateDepAuthManager();
	                
	        		manager.saveAll4Lianhe(v, {
	                    success: function(obj){
	                    	window.self.location.href = window.self.location.href;
	                 	}
	             	});
	    		}
	    		dialog.close();
	    	}
	    }, {
	    	text : $.i18n('govdoc.quxiao.select.label'),
	    	id:"exit",
	    	handler : function() {
	    		var manager = new govdocTemplateDepAuthManager();
        		manager.deleteCurrentLianhe({
                    success: function(obj){
                    	window.self.location.href = window.self.location.href;
                 	}
             	});
	    		dialog.close();//取消
	    	}
	    }, {
	    	text : $.i18n('collaboration.button.close.label'),
	    	id:"cansl",
	    	handler : function() {
	    		dialog.close();
	    	}
	    }]
	});
}
function addScrollForIframe(){
	  $("#templateOperDes").css("overflow","scroll");	
}
function govdocShowDocPage() {
	addScrollForIframe();
	if (nodeId=='') {
	  return;
	}
	var url = _ctxPath+"/content/content.do?isFullPage=true&moduleId="+ nodeId + "&govdocForm=1&viewState=3&moduleType="+nodeModuleType;
	$(".left>li").removeClass("current");
	$("#govdocArticleBut").addClass("current");
	$("#templateOperDes").attr('src', url);
}
function showGovdocContent() {
	var editframe = document.getElementById("editFrame").contentWindow;
	editframe.dealPopupContentWin();
}
//流程图
function showWorkFlow() {
	if (workflowId=='') {
		return;
	}

	//根据模板ID去取工作流图
	$(".left>li").removeClass("current");
	$("#workFlowBut").addClass("current");
	var url = _ctxPath+'/workflow/designer.do?method=showDiagram&isTemplate=true&isDebugger=false&scene=2&isModalDialog=false&processId='
    + workflowId+'&currentUserName='+encodeURIComponent($.ctx.CurrentUser.name );
	$("#templateOperDes").attr('src', url).css("overflow","hidden");
}