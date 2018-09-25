		var selectMembers;
		var publicViewMembers;
		var parentWindow=window.dialogArguments.win;
		var parentViewPeople=parentWindow.$("#viewPeople").val();
		var parentPublicViewPeople=parentWindow.$("#publicViewPeople").val();
		var parentPublishRange=parentWindow.$("#publishRange").val();
		var parentViewPeopleId=parentWindow.$("#viewPeopleId").val();
		var parentpublicViewPeopleId=parentWindow.$("#publicViewPeopleId").val();
		var openFromType = parentWindow.$("#openFromType").val();
		var bindPublishRange=null;
		//后台入口，组件需要验证数据判重
		if(openFromType=="0"){
		 var range=parentWindow.$("#bindPublishRange").val();
		  if(range != undefined){
			 var ranges=range.split(",");
			  for(var i=0;i<ranges.length;i++){
				  if(i==0){
					  bindPublishRange=ranges[i].split("|")[1];
				  }else{
					  bindPublishRange+=","+ranges[i].split("|")[1];
				  }
				  
			  }
		  }
		}
		
		if("" ==parentViewPeople){
			parentViewPeople=$.i18n('infosend.label.stat.clickSelect');//请点击选择;
		}
		if("" == parentPublicViewPeople){
			parentPublicViewPeople=$.i18n('infosend.label.stat.clickSelect');//请点击选择;
		}
		 $(function(){
			//单位树初始化
			    $("#UnitSectionTree").tree({
			      idKey : "id",
			      pIdKey : "parentId",
			      nameKey : "sectionName",
			      pidTypeKey:"parentTypeId",
			      onDblClick : _selectNode,
			      onClick : _clkNode,
			      nodeHandler: function(n) {
			        if(n.data.icon){
			          n.isParent = true;
			        }
			        if(n.data.parentId){
			          n.open = false;
			        }else{
			          n.open = true;
			        }
			      }
			    });
			   //单位已选项
			    $("#UnitSelectedTree").tree({
			      idKey : "id",
			      pIdKey : "parentId",
			      nameKey : "sectionName",
			      title : "title",
			      pidTypeKey:"parentTypeId",
			      onDblClick : _removeNode,
			      showTitle : true,
			      nodeHandler: function(n) {
			        n.open = false;
			      }
			    });
			    //组织树初始化
			    $("#orgSectionTree").tree({
				      idKey : "id",
				      pIdKey : "parentId",
				      title : "title",
				      nameKey : "sectionName",
				      pidTypeKey:"parentTypeId",
				      onDblClick : _selectNode,
				      onClick : _clkNode,
				      nodeHandler: function(n) {
				        if(n.data.icon){
				          n.isParent = true;
				        }
				        if(n.data.parentId){
				          n.open = false;
				        }else{
				          n.open = true;
				        }
				      }
				    });
			    //组织树已选项
			    $("#orgSelectedTree").tree({
			      idKey : "id",
			      pIdKey : "parentId",
			      nameKey : "sectionName",
			      title : "title",
			      pidTypeKey:"parentTypeId",
			      onDblClick : _removeNode,
			      showTitle : true,
			      nodeHandler: function(n) {
			        n.open = false;
			      }
			    });
			    //栏目初始化
			    showOrgTreeData();
			    showUnitTreeData();
			 
		 	new inputChange($("#viewPeople"),parentViewPeople);	
		 	//添加项
		 	$(".add").click(function(){
		 		var newItem=$(".newItem").eq(0).clone(true).removeClass("hidden");
		 		$(".fieldset_edit").eq(0).before(newItem);
		 	});
		 	//删除项
		 	$(".remove").click(function(){
		 		var removeItem=$(".newItem").length;
		 		if(removeItem!=1) $(".newItem").eq(removeItem-1).remove();	  
		 	});
		 	new inputChange($("#publicViewPeople"),parentPublicViewPeople);	
		 	//添加项
		 	$(".add").click(function(){
		 		var newItem=$(".newItem").eq(0).clone(true).removeClass("hidden");
		 		$(".fieldset_edit").eq(0).before(newItem);
		 	});
		 	//删除项
		 	$(".remove").click(function(){
		 		var removeItem=$(".newItem").length;
		 		if(removeItem!=1) $(".newItem").eq(removeItem-1).remove();	  
		 	});
		 	$("#viewPeople").click(function(){
		 	      $.selectPeople({
			          type:'selectPeople'
			          ,panels:'Account,Department'
			          ,selectType:'Account,Department'
			          ,text:$.i18n('common.default.selectPeople.value')
			          ,hiddenPostOfDepartment:true
			          ,hiddenRoleOfDepartment:true
			          ,showFlowTypeRadio:false
			          ,returnValueNeedType: true
			          ,params:{
			             value: selectMembers
			          }
			          ,targetWindow:window.top
			          ,callback : function(res){
			              if(res && res.obj && res.obj.length>0){
			            	  var selPeopleId="" ;
			            	  var selPeopleName="" ;
			            	  var selPeopleType="";
		                      for (var i = 0; i < res.obj.length; i ++){
		                          if (i == res.obj.length -1){
		                              selPeopleId +=res.obj[i].type+"|"+res.obj[i].id+"|0";
		                              selPeopleName+=res.obj[i].name;
		                              var flag=checkVila(res.obj[i].id,selPeopleName);
		                              if(flag){
		                            	  return false;
		                              }
		                              
		                          } else {
		                              selPeopleId+=res.obj[i].type+"|"+res.obj[i].id+"|0" + "," ;
		                              selPeopleName+=res.obj[i].name+",";
		                              checkVila(res.obj[i].id,selPeopleName);
		                              if(flag){
		                            	  return false;
		                              }
		                          }
		                      }
		                      selectMembers = res.value;
		                  
		                      $("#viewPeople" ).val(selPeopleName);
		                      $("#viewPeopleId").val(selPeopleId);
			              } else {
			                     
			              }
			         }
			      });	
		 	});
		 	$("#publicViewPeople").click(function(){
		 		var panelsList;
		 		var showLogin=false;
		 		if($("#checkOrgOrUnit").val()=="1"){
		 			panelsList="Department";
		 			showLogin=true;
		 		}else{
		 			panelsList="Account,Department";
		 		}
		 		 $.selectPeople({
		 			   onlyLoginAccount:showLogin,
			           type:'selectPeople'
			          ,panels:panelsList
			           ,selectType:panelsList
			          ,text:$.i18n('common.default.selectPeople.value')
			          ,hiddenPostOfDepartment:true
			          ,hiddenRoleOfDepartment:true
			          ,showFlowTypeRadio:false
			          ,returnValueNeedType: true
			          ,params:{
			             value: publicViewMembers
			          }
			          ,targetWindow:window.top
			          ,callback : function(res){
			              if(res && res.obj && res.obj.length>0){
			            	  var selPeopleId="" ;
			            	  var selPeopleName="" ;
		                      for (var i = 0; i < res.obj.length; i ++){
		                          if (i == res.obj.length -1){
		                              selPeopleId +=res.obj[i].type+"|"+res.obj[i].id;
		                              selPeopleName+=res.obj[i].name;
		                          } else {
		                              selPeopleId+=res.obj[i].type+"|"+res.obj[i].id + "," ;
		                              selPeopleName+=res.obj[i].name+",";
		                          }
		                      }
		                      publicViewMembers = res.value;
		                      $("#publicViewPeople" ).val(selPeopleName);
		                      $("#publicViewPeopleId").val(selPeopleId);
			              } else {
			                     
			              }
			         }
			      });	
		 	});
		 	$("#viewCheck").click(function(){
		 		var  checkedPeople=$("#viewPeople")[0];
		 		if(checkedPeople.disabled==true){
		 			checkedPeople.disabled="";
		 		}else{
		 			checkedPeople.disabled=true;
		 		}
		 	});
		 	
		 	$("#tabs2_head").find("li a").each(function() {
				$(this).attr("disabled", true);
			});
		 	
			$("#publicInfo").click(function(){
				var  checkedPeople=$("#publicViewPeople")[0];
				var checkSpanDisplay1=$("#Area2Span")[0];
				var  checkSpanDisplay2=$("#Area3Span")[0];
				
		 		if(checkedPeople.disabled==true){
		 			$("#tabs2_head").find("li a").each(function() {
						$(this).attr("disabled", false);
					});
		 			
		 			checkedPeople.disabled="";
		 			checkSpanDisplay1.style.display="block";
		 			checkSpanDisplay2.style.display="block";
		 		}else{
		 			$("#tabs2_head").find("li a").each(function() {
						$(this).attr("disabled", true);
					});
		 			checkedPeople.disabled="";
		 			checkSpanDisplay1.style.display="none";
		 			checkSpanDisplay2.style.display="none";
		 		}
		 	});
			
		 	if(parentPublishRange!="") {
		 		if(parentPublishRange.indexOf("公共信息")>=0) {
		 			var checkedPeople=$("#publicViewPeople")[0];
			 		checkedPeople.disabled = true;
			 		$("#publicInfo").trigger("click");
		 		} else if(parentPublishRange.indexOf("查看页面")>=0) {
		 			var checkedPeople = $("#viewPeople")[0];
			 		checkedPeople.disabled = true;
			 		$("#viewCheck").trigger("click");
		 		}
		 	}
		 	
		 	
		 	if(parentPublishRange.indexOf("查看页面")>=0){//返回值等于0，则包含该字符穿
				$("#viewCheck").attr("checked",'true');
			}
			if(parentPublishRange.indexOf("公共信息")>=0){
				$("#publicInfo").attr("checked","true");
			}
			$("#viewPeopleId").val(parentViewPeopleId);
			$("#publicViewPeopleId").val(parentpublicViewPeopleId);
			var parentorgSelectedTree=parentWindow.$("#orgSelectedTree").val();
			var parentUnitSelectedTree=parentWindow.$("#UnitSelectedTree").val();
			if("" !=parentorgSelectedTree){
			var	parentorgSelectedTreeS=parentorgSelectedTree.split(",");
			var nodes = [];
			for(var i=0;i<parentorgSelectedTreeS.length;i++){
				var selectedTress=parentorgSelectedTreeS[i].split("|");
				var node = new Object();
				node.sectionName=selectedTress[0];
				node.id=selectedTress[1];
				node.parentTypeId=selectedTress[2]
				nodes[nodes.length] = node;
			}
			$("#orgSelectedTree").treeObj().addNodes(null,nodes);
			}
			if("" !=parentUnitSelectedTree){
				var	parentUnitSelectedTreeS=parentUnitSelectedTree.split(",");
				var nodes = [];
				for(var i=0;i<parentUnitSelectedTreeS.length;i++){
					var selectedTress=parentUnitSelectedTreeS[i].split("|");
					var node = new Object();
					node.sectionName=selectedTress[0];
					node.id=selectedTress[1];
					node.parentTypeId=selectedTress[2]
					nodes[nodes.length] = node;
				}
				$("#UnitSelectedTree").treeObj().addNodes(null,nodes);
			}
			
		 })

/***
 * XUANREN
 * @param type
 * @param objTD
 */
function selectOne(type, objTD){
	var flag = false;
	if(type && objTD){
		tempNowSelected.clear();
		if(v3x.getBrowserFlag('selectPeopleShowType')){
			var ops = objTD.options;
			var count = 0;
			for(var i = 0; i < ops.length; i++) {
				var option = ops[i];
				if(option.selected){
					var e = getElementFromOption(option);
					if(e){
						tempNowSelected.add(e);
					}
				}
			}
		}else{
			if(arguments[2]){
				var ops = document.getElementById(arguments[2]).childNodes;
				var count = 0;
				for(var i = 0; i < ops.length; i++) {
					var option = ops[i];
					if(option.getAttribute('seleted')){
						var e = getElementFromOption(option);
						if(e){
							tempNowSelected.add(e);
						}
					}
				}
				selectOneMemberDiv(objTD);
				flag = true;
			}
		}
	}
	if(!v3x.getBrowserFlag('selectPeopleShowType')){
		if(arguments[2]){
			//双击组 选择组
			listenermemberDataBodyDiv(document.getElementById(arguments[2]));
		}else{
			listenermemberDataBodyDiv(document.getElementById(temp_Div));
		}
	}
	
	var _showAccountShortname = false;
	var unallowedSelectEmptyGroup = getParentWindowData("unallowedSelectEmptyGroup") || false;
	
	var alertMessageBeyondLevelScop = new StringBuffer();
	var alertMessageEmptyMemberNO = new StringBuffer();
	var alertMessageBeyondWorkScop = new StringBuffer();
	
	var isCanSelectGroupAccount = getParentWindowData("isCanSelectGroupAccount");
	var isConfirmExcludeSubDepartment = getParentWindowData("isConfirmExcludeSubDepartment");
	for(var i = 0; i < tempNowSelected.size(); i++){
		var element = tempNowSelected.get(i);
		var type = element.type;
		if(type == Constants_Outworker){
			type = Constants_Department;
		}
		
		if(!checkCanSelect(type)){
			continue;
		}
		
		if(type == Constants_Account && excludeElements.contains(type + element.id)){
            continue;
        }
		
		if(!checkExternalMemberWorkScope(type, element.id)){
			continue;
		}
		
		//内部人员: 当前是外部人员面板，检查外部单位能否直接选择，逻辑：只要有一个不可见，就返回；管理员：只判断人员是否为空
		if(isInternal && tempNowPanel.type == Constants_Outworker && unallowedSelectEmptyGroup && type == Constants_Department && checkCanSelectMember()){
		    var _entity = topWindow.getObject(type, element.id);
		    var _ms = _entity.getAllMembers();
		    
		    if(!_ms || _ms.isEmpty()){
            alertMessageEmptyMemberNO.append(element.name);
            continue;
		    }
		    
		    if(!isAdmin){ //普通用户
		        var extMember = topWindow.ExtMemberScopeOfInternal.get(element.id);
		        if(!extMember){
		            alertMessageEmptyMemberNO.append(element.name);
		            continue;
		        }
		        
		        var isSelect = true;
		        for(var i = 0; i < _ms.size(); i++) {
		            if(!extMember.contains(_ms.get(i).id)){
		                isSelect = false;
		                break;
		            }
		        }
		        
		        if(!isSelect){
		            alertMessageBeyondWorkScop.append(element.name);
		            continue;
		        }
		    }
		}
		
		if((isCanSelectGroupAccount == false || isGroupAccessable == false) && type == Constants_Account && element.id == rootAccount.id){
			continue;
		}
		//检测越级访问，只要部门/组里面有任何一个人不能选择，则该部门/组不能选择
		if(type != Constants_Member && type != Constants_Department && !checkAccessLevelScope(type, element.id)){
			alertMessageBeyondLevelScop.append(element.name);
			continue;
		}
		
		//判断是否要子部门 //Constants_Node 工作流用的节点type
		if(( type == Constants_Department || type == Constants_Node ) && isConfirmExcludeSubDepartment){
		    var isShowPageConfirm4Select = false;
		    
		    if(type == Constants_Department){//当前选择的部门
    			var _getChildrenFun = Constants_Panels.get(type).getChildrenFun;
    			
    			var entity = topWindow.getObject(type, element.id);
    			if(entity){
    				datas2Show = eval("entity." + _getChildrenFun + "()");
    			}
    			else{
    				datas2Show = topWindow.findChildInList(topWindow.getDataCenter(type), id);
    			}
    			isShowPageConfirm4Select = datas2Show && !datas2Show.isEmpty();
		    }
		    else if(type == Constants_Node){
		        isShowPageConfirm4Select = element.id.endsWith("DeptMember");
		    }
			if(isShowPageConfirm4Select){
				var _index = element.name.indexOf("(" + $.i18n("selectPeople.excludeChildDepartment") + ")");
				if(_index != -1) {
					element.name = element.name.substring(0, _index);
				}
				//【包含】 true 【不包含】 false【取消】 ''
				var temp = showConfirm4Select(element.name);
				if(temp == '') {
				    continue; //表示不选，跳过
				}
				else if(temp == 'false'){//通过JSP页面来提示是否包含子部门
					element.excludeChildDepartment = true;
					element.name += "(" + $.i18n("selectPeople.excludeChildDepartment") + ")";
				}
				else {
					element.excludeChildDepartment = false;
				}
			}
			if(element.excludeChildDepartment == false) {//包含子部门
				if(!checkAccessLevelScopeWithChildDept(element.id)) {
					alertMessageBeyondLevelScop.append(element.name);
					continue;
				}
			} else {//OA-48542
				if(!checkAccessLevelScope(type, element.id)){//不包含子部门
					alertMessageBeyondLevelScop.append(element.name);
					continue;
				}
			}
		} else {
			if(type == Constants_Department && !checkAccessLevelScope(type, element.id)){
				alertMessageBeyondLevelScop.append(element.name);
				continue;
			}
		}
		
		var key = type + element.id;
		
		if(key == "NodeNodeUser" || key == "NodeSenderSuperDept" || key == "NodeNodeUserSuperDept"){
		    continue;
		}

		if(selectedPeopleElements.containsKey(key)){	//??????????????????
			continue; //Exist
		}
		
		//检测集合里面是否是空的，一般检测部门和组
		if(checkEmptyMember(type, element.id)){
			if(unallowedSelectEmptyGroup){ //不允许选择空组
				alertMessageEmptyMemberNO.append(element.name);
				continue;
			}
			else{
				if(!confirm($.i18n("selectPeople.alertEmptyMember", element.name))){
					continue;
				}
			}
		}
		if(type == Constants_Department && element.excludeChildDepartment == true) {//不包含子部门，父部门下没有人
			if(checkEmptyMemberWithoutChildDept(type, element.id)) {
				if(unallowedSelectEmptyGroup){ //不允许选择空部门
					alertMessageEmptyMemberNO.append(element.name);
					continue;
				}
				else{
					if(!confirm($.i18n("selectPeople.alertEmptyMember", element.name))){
						continue;
					}
				}
			}
		}
		
		var _accountId = element.accountId || currentAccountId;
		var accountShortname = allAccounts.get(_accountId).shortname;
		
		element.type = type;
		element.typeName = Constants_Component.get(type);
		element.accountId = _accountId;
		element.accountShortname = accountShortname;
		
		add2List3(element);
		selectedPeopleElements.put(key, element);		
	}
	
	var sp = $.i18n("common_separator_label");
	var alertMessage = "";
	if(!alertMessageBeyondWorkScop.isBlank()){
	    alertMessage += ($.i18n("selectPeople.alertBeyondWorkScope", alertMessageBeyondWorkScop.toString(sp).getLimitLength(50, "..."))) + "\n\n";
	}
	if(!alertMessageBeyondLevelScop.isBlank()){
		alertMessage += ($.i18n("selectPeople.alertBeyondLevelScope", alertMessageBeyondLevelScop.toString(sp).getLimitLength(50, "..."))) + "\n\n";
	}
	if(!alertMessageEmptyMemberNO.isBlank()){
		alertMessage += ($.i18n("selectPeople.alertEmptyMemberNO", alertMessageEmptyMemberNO.toString(sp).getLimitLength(50, "...")));
	}
	
	if(alertMessage){
		alert(alertMessage);
	}
}
		 
 function _clkNode(event, treeId, treeNode){
		if(treeNode.data.async == false){
			 var params = new Object();
			  new infoMagazineManager().pubBulTypeList({
			    success : function(data){
			        $("#UnitSectionTree").treeObj().removeChildNodes(treeNode);
			        $("#UnitSectionTree").treeObj().addNodes(treeNode, data);
			    }
			  });
		}
	}

 function _beforeExpand(treeId,treeNode){
		if(treeNode.data.async == false){
			var params = new Object();
			  new infoMagazineManager().pubBulTypeList({
			    success : function(data){
			        $("#UnitSectionTree").treeObj().removeChildNodes(treeNode);
			        $("#UnitSectionTree").treeObj().addNodes(treeNode, data);
			    }
			  });
		}
	}
 
 
 function showOrgTreeData(){
	  var params = new Object();
	  params['sectionType']="Org";
	  params['openFromType']=openFromType;
	  new infoMagazineManager().pubBulTypeList(params,{
	    success : function(data){
	        var setting = $("#orgSectionTree").treeObj().setting;
	        setting.callback.beforeExpand = _beforeExpand;
	        $.fn.zTree.init($("#orgSectionTree"), setting, data);
	    }
	  });
	}
 function showUnitTreeData(){
	 var params = new Object();
	 params['sectionType']="Unit";
	 params['openFromType']=openFromType;
	 new infoMagazineManager().pubBulTypeList(params,{
		 success : function(data){
			 var setting = $("#UnitSectionTree").treeObj().setting;
			 setting.callback.beforeExpand = _beforeExpand;
			 $.fn.zTree.init($("#UnitSectionTree"), setting, data);
		 }
	 });
 }
 
 function _selectNode(){
	  var nodes;
	  var selectNodes;
	  if($("#checkOrgOrUnit").val() =="1"){
		  nodes = $("#UnitSectionTree").treeObj().getSelectedNodes();
		  selectNodes = $("#UnitSelectedTree").treeObj().getNodes();
	  }else{
		  nodes = $("#orgSectionTree").treeObj().getSelectedNodes();
		  selectNodes = $("#orgSelectedTree").treeObj().getNodes();
	  }
	  if(nodes){
	    for (var i=0, l=nodes.length; i < l; i++) {
	   	  var nodeData = null;
	        nodeData = nodes[i].data;
	        /**根节点不可以选择**/
	        if(nodeData.parentId==0){
	        	alert($.i18n('infosend.magazine.alert.selectRoot'));//该目录不能选择！
	        	return ;
	        }
	       /**循环遍历已选值*/
	        for (var i=0, l=selectNodes.length; i < l; i++) {
	        	 var node = selectNodes[i];
	        	 if(nodeData.id==node.id){
	        		 alert($.i18n('infosend.magazine.alert.selectRepet'));//不能选择重复项！
	        		 return ;
	        	 }
	        }
	        /**遍历后台其它单位是否已绑定了发布范围**/
	        if(bindPublishRange != null){
	        	var publishRange=bindPublishRange.split(",");
	        	for(var i=0;i<publishRange.length;i++){
	        		if(nodeData.id==publishRange[i]){
	        			alert($.i18n('infosend.magazine.alert.selectOthers'));//其它评分已绑定，不能重复选择！
	        			return ;
	        		}
	        	}
	        }
	      if($("#checkOrgOrUnit").val()  =="1"){
	    	  $("#UnitSelectedTree").treeObj().addNodes(null,nodeData);
	      }else{
	    	  $("#orgSelectedTree").treeObj().addNodes(null,nodeData);
	      }
	    }
	  }
	}
 
 function _removeNode(){
	 var treeObj=null;
	 if($("#checkOrgOrUnit").val() =="1"){
		 treeObj = $("#UnitSelectedTree").treeObj();
	 }else{
		 treeObj = $("#orgSelectedTree").treeObj();
	 }
	  var nodes = treeObj.getSelectedNodes();
	  if(nodes){
	    for (var i=0, l=nodes.length; i < l; i++) {
	      treeObj.removeNode(nodes[i]);
	    }
	  }
	}
 function _removeUnitNode(){
	  var treeObj = $("#UnitSelectedTree").treeObj();
	  var nodes = treeObj.getSelectedNodes();
	  if(nodes){
	    for (var i=0, l=nodes.length; i < l; i++) {
	      treeObj.removeNode(nodes[i]);
	    }
	  }
	}
 function checkPublishType(type){
	 $("#checkOrgOrUnit").val(type);
 }
 
 function OK(){
	 var object= new Object();
	 var  checkPublistType="";//定义选择的发布类型
	 if($("#viewCheck").attr("checked")=='checked'){
		 checkPublistType=$("#viewCheck").val();
	 }
	 if(checkPublistType!="" && checkPublistType.length>0){
		 checkPublistType+=",";
	 }
	 if($("#publicInfo").attr("checked")=='checked'){
		 checkPublistType+=$("#publicInfo").val();
	}
	 //是否选中了查看页面
	 var checkView=$("#viewCheck").attr("checked");
	 var viewPeopleId =$("#viewPeopleId").val();
	 //是否选中了公共信息
	 var checkInfo=$("#publicInfo").attr("checked");
	 
	if(checkView){
		if(viewPeopleId ==""){
			alert($.i18n('infosend.magazine.alert.selectPeople'));//请选择可查看人员
			return;
		}
	}
	if(viewPeopleId != "" ){
		if(checkView==undefined){
			alert($.i18n('infosend.magazine.alert.selectViewCheckBox'));//请勾选查看页面的选择框!
			return;
		}
	}
	 var orgNodes = $("#orgSelectedTree").treeObj().getNodes();
	 var unitNodes = $("#UnitSelectedTree").treeObj().getNodes();
	 var  publicViewPeopleId=$("#publicViewPeopleId").val();
	 if(checkInfo){
		if(orgNodes=="" && unitNodes==""){
			alert($.i18n('infosend.magazine.alert.selectPublishforum'));//请选择发布版块!
			return;
		}
		if(publicViewPeopleId==""){
			alert($.i18n('infosend.magazine.alert.selectGonggaoRange'));//请选择公告发布范围
			return;
		}
		}
	    if(orgNodes!="" || unitNodes!=""){
			 if(checkInfo==undefined){
				 alert($.i18n('infosend.magazine.alert.selectGonggaoCheckbox'));//请勾选公告发布范围选择框
				 return;
			 }
			 if(publicViewPeopleId==""){
				alert($.i18n('infosend.magazine.alert.selectGonggaoRange'));//请选择公告发布范围
				return;
			 } 
		 }
	    if(publicViewPeopleId != ""){
	    	 if(checkInfo==undefined){
				 alert($.i18n('infosend.magazine.alert.selectGonggaoCheckbox'));//请勾选公告发布范围选择框
				 return;
			 }
	    	 if(orgNodes=="" && unitNodes==""){
					alert($.i18n('infosend.magazine.alert.selectPublishforum'));//请选择发布版块!
					return;
			 }
	    }
	 
	 var orgSelectedTree="";//集团选择的公告、新闻
	 var UnitSelectedTree="";//单位选择的公告、新闻
	 /**
	  * 1发布到组织公告
		2发布到组织新闻
		3发布到单位公告
		4发布单位新闻
	  */
	 for(var i=0, l=orgNodes.length; i<l; i++){
		 var node = orgNodes[i];
		 var type;
		 var parentObject =node.data;
		 if(parentObject.parentTypeId==1){
			 type=1;
		 }else{
			 type=2;
		 }
		
	     if (i == orgNodes.length -1){
	    	 orgSelectedTree +=node.sectionName+"|"+node.id+"|"+type;
	     }else{
	    	 orgSelectedTree +=node.sectionName+"|"+node.id+"|"+type+",";
	     }
	 }
	 for(var i=0, l=unitNodes.length; i<l; i++){
		 var node = unitNodes[i];
		 var type;
		 var parentObject =node.data;
		 if(parentObject.parentTypeId==1){
			 type=3;
		 }else{
			 type=4;
		 }
	     if (i == unitNodes.length -1){
	    	 UnitSelectedTree +=node.sectionName+"|"+node.id+"|"+type;
	     }else{
	    	 UnitSelectedTree +=node.sectionName+"|"+node.id+"|"+type+",";
	     }
	 }
	 object.checkPublistTypes=checkPublistType;
	 object.viewPeopleId=$("#viewPeopleId").val();//查看页面返回的人员信息，返回格式Account|1232323;Department|124123412
	 object.publicViewPeopleId=$("#publicViewPeopleId").val();//公共信息选择的查看人员,返回格式Account|1232323;Department|124123412
	 object.orgSelectedTree=orgSelectedTree;
	 object.UnitSelectedTree=UnitSelectedTree;
	 object.viewPeople=$("#viewPeople").val();
	 object.publicViewPeople=$("#publicViewPeople").val();
	 return object;
	}
 
 function checkVila(id,name){	 
	    /**遍历后台其它单位是否已绑定了发布范围**/
       if(bindPublishRange != null){
       	var publishRange=bindPublishRange.split(",");
       	for(var i=0;i<publishRange.length;i++){
       		if(id==publishRange[i]){
       			alert($.i18n('infosend.magazine.alert.selectOthersWhithName', name));//name+已经被其它评分标准选择，不能再次绑定！
       			return true;
       		}
       	}
       }
       return false;
 }
	