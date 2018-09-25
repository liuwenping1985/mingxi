   var excludeElements_manage;
   var excludeElements_member;
   var excludeElements_assistant;
   var excludeElements_charge;
   var excludeElements_interfix;
   var isContinuous = false;
   
   function isSelectManager(){
		excludeElements_manage = joinArrays("manage",excludeElements_assistantArray,excludeElements_memberArray,excludeElements_chargeArray,excludeElements_interfixArray);
        selectPeopleFun_manage();
   }
    function isSelectAssistant(){
		excludeElements_assistant = joinArrays("assistant",excludeElements_manageArray,excludeElements_memberArray,excludeElements_chargeArray,excludeElements_interfixArray);
        selectPeopleFun_assistant();
   }
   function isSelectMember(){
		excludeElements_member = joinArrays("member",excludeElements_manageArray,excludeElements_assistantArray,excludeElements_chargeArray,excludeElements_interfixArray);
        selectPeopleFun_member();
   }
   function isSelectCharge(){
		excludeElements_charge = joinArrays("charge",excludeElements_manageArray,excludeElements_assistantArray,excludeElements_memberArray,excludeElements_interfixArray);
        selectPeopleFun_charge();
   }
   function isSelectInterfix(){
		excludeElements_interfix = joinArrays("interfix",excludeElements_manageArray,excludeElements_assistantArray,excludeElements_memberArray,excludeElements_chargeArray);
        selectPeopleFun_interfix();
   }
   
    /**
     * 进展填写
     */
    function initProjectPhases(){
    	saveAttachment();//上传文件
    	document.project.submit();
    }
    
    
   /**
     * 讨论
     */
    function openWin(urls){ 
    var d=new Date();
    var url = urls +"&t="+d.getTime();
    var windowWidth =  screen.width-155;
    var windowHeight =  screen.height-210;
    v3x.openWindow({
        url : url,
        width : windowWidth,
        height : windowHeight,
        top : 130,
        left : 140,
        resizable: "yes",
        dialogType:'open'
    });
}
    
    /**
     *  创建项目
     */
    function submitProject(){
    	projectForm.action =projectUrl+"?method=createProject";
    	getPlist();
    	saveAttachment();//上传文件
    	projectForm.submit();
    }
    /**
     * 更新项目
     */
    function updateProjectSummary(obj){
    	
    	projectForm.action =projectUrl+"?method=updateProject";
    	if(!checkForm(obj)){
    		return false;
    	}
    	var beginDate = document.getElementById('begintime').value;
   		var endDate = document.getElementById('closetime').value;
    	if(compareDate(beginDate,endDate)>0){
			return false;
		}
    	saveAttachment();//上传文件
    }
    
    function sendOrder() {
    	var str="";
    	var sel=formorder.projectsObj;
    	for(i=0;i<sel.options.length;i++) {
    		str+=sel.options[i].value;
    		if(i!=sel.options.length-1){str+=";";}
    	}
    	document.getElementById('projects').value = str;
    	document.getElementById('submitBtn').disabled = true;
    	document.getElementById('cancelBtn').disabled = true;
    }
    function endOrderSave() {
    	//window.dialogArguments.getA8Top().reFlesh();//方法找不到，关闭窗口再刷新框架
    	window.close();
    	
    }
     
    /**
     * 查看项目信息包括进展
     */
    function detailProject(id){
    	if(v3x.getBrowserFlag('pageBreak')){
    		parent.detailFrame.document.location.href =projectUrl+"?method=getProject&projectId="+id;
    	}else{
			v3x.openWindow({
				url : projectUrl+"?method=getProject&projectId="+id,
				dialogType: "open",
				workSpace: 'yes'
			});
    	}
    }
    /**项目排序*/
    function projectOrder(){
    	getA8Top().projectOrderDialog=getA8Top().$.dialog({
    		title:" ",
			url : projectUrl+"?method=orderProject",
			width : "350",
			height : "350",
			resizable : "false",
			transParams:{'parentWin':window}
    	});
    }
    function projectOrderCallBack(){
    	document.location.reload();
    }
    /**
     * 查看项目
     */
    function getProject(id){
        document.location.href =projectUrl+"?method=detailProject&projectId="+id;
    }
    function submitEvolution(){
    	 saveAttachment();//上传文件
    	 project.submit();
    }
    /**
     * 删除项目
     */
    function delProject(id,state){
    	if(window.confirm(v3x.getMessage("ProjectLang.project_delete_warning"))){
		  	document.location.href =projectUrl+"?method=removeProject&projectId="+id+"&state="+state;
		  }
    }
    /**
     * 更新项目
     */
    function updateProject(id){
    	document.location.href =projectUrl+"?method=detailProject&update=update&projectId="+id;
    }
    /**
     * 项目日志列表
     */
   function projectLog(id){
   	    var projectName = document.getElementById("hiddenProjectName").value;
       	document.location.href =projectUrl+"?method=getProjectLog&projectId="+id+"&projectName="+projectName;
   }
     /**
      * 选择项目负责人
      */
    function setPeopleFieldsManage(elements){
         if(!elements){
             return ;
         }
         document.getElementById("managerWeb").value=getNamesString(elements);
         document.getElementById("managers").value=getIdsString(elements,false);
   		 excludeElements_manageArray = elements;
    }
    
    /**
     * 选择项目助理
     */
    function setPeopleFieldsAssistant(elements){
    	if(!elements){
             return ;
         }
         document.getElementById("assistantWeb").value=getNamesString(elements);
         document.getElementById("assistants").value=getIdsString(elements,false);
   		 excludeElements_assistantArray = elements;
    }
    /**
     * 选择项目成员
     */
    function setPeopleFieldsMember(elements){
        if(!elements){
             return ;
         }
         document.getElementById("memberWeb").value=getNamesString(elements);
         document.getElementById("members").value=getIdsString(elements,false);
		 excludeElements_memberArray = elements;
    }
    /**
     * 选择项目相关
     */
   function  setPeopleFieldsInterfix(elements){
        if(!elements){
             return ;
         }
         document.getElementById("interfixWeb").value=getNamesString(elements);
         document.getElementById("interfixs").value=getIdsString(elements,false);
         excludeElements_interfixArray = elements;
   }
   /**
    * 选择项目领导
    */
   function  setPeopleFieldsCharge(elements){
        if(!elements){
             return ;
         }
         document.getElementById("chargeWeb").value=getNamesString(elements);
         document.getElementById("charges").value=getIdsString(elements,false);
         excludeElements_chargeArray = elements;
   }
   /**
    * 部门选择
    */
   function setPeopleFieldsDepartment(elements){
   	    if(!elements){
             return ;
         }
         document.getElementById("departmentWeb").value=getNamesString(elements);
         document.getElementById("department").value=getIdsString(elements,false);
   }
   /**
    * 判断数字是否合法
    */
   function isNumber(object){
		if(isNaN(object.value)){
			alert(v3x.getMessage("ProjectLang.jindu_must_be_number"));
			object.value = 0;
			return false;
		}
		if(object.value>100){
			alert(v3x.getMessage("ProjectLang.jindu_can_not_be_too_large"));
			object.value = 0;
			return false;
		}
		return true;
   }
   /**
    * 判断阶段的计划总数是否超出100%的范围
    */
   function isOver(obj){
         var  count = 0;
   	     for(var s =0;s<aList.size();s++){
   	  	     var pobj = aList.get(s);
   	  	     var thisValue = 100 - count;
   	  	     count += parseFloat(pobj.plan);
   	  	     if(count > 100){
   	  	     	alert(v3x.getMessage("Projectlang.jindu_at_most")+thisValue+"%");
   	  	     	obj.focus();
   	  	     	return false;
   	  	     }
   	  	 }
   	   return true;
   }
   
   
   /**
    * 项目对象
    */
   function  Project(pname,sort,options,id,btime,ctime,plan,desc){
   	    this.pname = pname;
   	    this.sort = sort;
   	    this.btime = btime;
   	    this.ctime = ctime;
        this.plan = plan;
   	    this.desc = desc;
   	    this.options = options;
   	    this.id = id;
   }
   var sort =0;//阶段怕排序 全局唯一
   /**
    * 加入一个项目阶段名称
    */
  function addProjectPhases(pname,sort,options,id){
  	 var project = new Project(pname,sort,options,id);
  	 aList.addAt(sort,project);
  }
  
  function getPlist() {
	  	if(!aList){
	  	  	return;
	  	}
        var proPhase = document.getElementById("proPhases");
        var a =0;
   	    var u =0;
   	    var innerHtml = proPhase.innerHTML;
   	    for(var s=0;s<aList.size();s++){
	   	  	var pobj = aList.get(s);
	   	  	if(pobj.options == "add"){
	   	        innerHtml+="<input type=\"hidden\" id=\"project"+pobj.sort+"Phases\" name=\"projectPhases\" value=\""+pobj.pname+"\">";
	   	        innerHtml+="<input type=\"hidden\" name=\"phase"+a+"Begintime\" value=\""+pobj.btime+"\">";
	   	        innerHtml+="<input type=\"hidden\" name=\"phase"+a+"Closetime\" value=\""+pobj.ctime+"\">";
	   	        innerHtml+="<input type=\"hidden\" name=\"phase"+a+"Percent\" value=\""+pobj.plan+"\">";
	   	        innerHtml+="<input type=\"hidden\" name=\"phase"+a+"Desc\" value=\""+pobj.desc+"\">";
				a++;
	   	    }else if(pobj.options == "update"){
	   	        projectPhase.innerHTML+="<input type='hidden'  name='projectPhase_update_id' value= '"+pobj.id+"'>";
	   	        projectPhase.innerHTML+="<input type='hidden' name='updatephase"+u+"Begintime' value= '"+pobj.btime+"'>";
	   	        projectPhase.innerHTML+="<input type='hidden' name='updatephase"+u+"Closetime' value= '"+pobj.ctime+"'>";
	   	        projectPhase.innerHTML+="<input type='hidden' name='updatephase"+u+"Percent' value= '"+pobj.plan+"'>";
	   	        projectPhase.innerHTML+="<input type='hidden' name='updatephase"+u+"Desc' value= '"+pobj.desc+"'>";
	   	        u++;
	   	     }
   	  }
   	  proPhase.innerHTML=innerHtml;
   }
   /**
    * 添加一个项目阶段
    */
  function setProjectPhasesValue(obj,thisType){
  	    var pSort = document.getElementById("phasesSort").value; 
   	    var pobj = getThisProject(pSort);
   	    if(!pobj){
   	    	if(obj.value)
   	        	alert(v3x.getMessage("ProjectLang.please_add_project_phase"));
   	    	return false;
   	    }
   	    var thisUpdate  = false ;
   	    if(pobj.id !=null && pobj.id !=""){
   	    	thisUpdate= true;
   	    }
   	    if(thisType == "btime"){
   	    	 if(obj.value!="" && obj.value < document.projectForm.begintime.value){
   	    	 	 alert(v3x.getMessage("ProjectLang.phase_startdate_can_not_late_than_project_enddate"));
   	    	 	 obj.value =document.projectForm.begintime.value;
   	    	     return false;
   	    	 }
   	    	 if(obj.value != pobj.btime  && thisUpdate){
   	    	 	pobj.options ='update';
   	    	 }
   	    	 pobj.btime = obj.value;
   	    }
   	    if(thisType == "ctime"){
   	    	if(obj.value !="" && obj.value < pobj.btime){
   	    		  alert(v3x.getMessage("ProjectLang.phase_startdate_can_not_late_than_enddate"));
   	    	 	  pobj.ctime = pobj.btime;
   	    	      return false;
   	    	} 
   	    	if(obj.value != pobj.ctime && thisUpdate){
   	    	 	  pobj.options ='update';
   	    	 }
   	         pobj.ctime = obj.value;  
   	    }
   	    if(thisType == "plan"){   
   	    	if(obj.value != pobj.plan  && thisUpdate){
   	    	 	pobj.options ='update';
   	    	}
   	    	pobj.plan = obj.value;
   	    	if(!isNumber(obj) || !isOver(obj)){
   	    		pobj.plan = (pobj.plan ==null?0:pobj.plan);
   	    	}   
   	    }
   	    if(thisType == "desc"){ 
   	    	if(obj.value != pobj.plan  && thisUpdate){
   	    	 	pobj.options ='update';
   	    	}   
   	        pobj.desc = obj.value;
   	    }
  }
  /**
   * 响应点击一个项目阶段时
   */
  function thisClick(thisValue){
  	   document.getElementById("phasesSort").value =thisValue;
  	   var p = getThisProject(thisValue);
  	   if(!p){
  	     	return ;
  	   }
  	   
  	   var ptableNode = document.getElementById("ptable");
  	   ptableNode.style.display = '';
  	   var initPage = document.getElementById("beforeptable");
  	   initPage.style.display = 'none';
  	   var bdate ="";
  	   var cdate ="";
  	   if(p.btime != null){
  	       bdate = p.btime.substring(0,10);//时间格式截取
  	   }
  	   if(p.btime != null){
  	       cdate = p.ctime.substring(0,10);//时间格式截取
  	   }
  	   projectForm.bdate.value = bdate;
  	   projectForm.cdate.value = cdate;
  	   projectForm.jindudesc.value = (p.desc == null ?"":p.desc);
  	   projectForm.jindu.value =  (p.plan == null?"":p.plan);
  }
  /**
   * 获取当前的阶段
   */
  function getThisProject(optionSort){
  	    var p = null;
  	    for(var s =0;s<aList.size();s++){
   	  	     var pobj = aList.get(s);
   	  	     if(pobj.sort == optionSort){
   	  	          p = pobj;
   	  	          break;
   	  	      }
   	  	 }
   	  	return p;
  }
  /**
   * 删除阶段 pageFlag = update时要记录删除的阶段ID
   */
  function thisDelete(pageFlag){
  	  thisValue = document.getElementById("phasesSort").value ;
  	  var pobj = getThisProject(thisValue);
  	  if(!pobj){
  	  	  return ;
  	  }
  	  if(pageFlag == 'update')
  	  {
  	  	   var projectPhase = document.getElementById("projectPhases");
  	  	   projectPhase.innerHTML += "<input type='hidden'  name='projectPhase_delete' value= '"+pobj.id+"'>";
  	  	   //alert(projectPhase.innerHTML);
  	  }
  	  aList.remove(pobj);
  	  var buttonNode = document.getElementById("Project"+thisValue+"Button");
  	  buttonNode.style.display = 'none';
  	  var ptableNode = document.getElementById("ptable");
  	  ptableNode.style.display = 'none';
  	  var initPage = document.getElementById("beforeptable");
  	  initPage.style.display = '';
}

/**
 * 合并数组选人界面不出现的人员
 * var  excludeElements_member;
   var  excludeElements_manage;
   var  excludeElements_charge;
   var  excludeElements_interfix;
 */
function joinArrays(jionArr,arr1,arr2,arr3){

		var arr = new Array();
		excludeElements_member = new Array();
   		excludeElements_manage = new Array();
   		excludeElements_charge = new Array();
   		excludeElements_interfix = new Array();
   		
		if(arr1&&arr2&&arr3){
			arr = eval("excludeElements_"+jionArr).concat(arr1,arr2,arr3);
		}else if(arr1&&arr2){
			arr = eval("excludeElements_"+jionArr).concat(arr1,arr2);
		}else if(arr1&&arr3){
			arr = eval("excludeElements_"+jionArr).concat(arr1,arr3);
		}else if(arr2&&arr3){
			arr = eval("excludeElements_"+jionArr).concat(arr2,arr3);
		}else if(arr1){
			arr = eval("excludeElements_"+jionArr).concat(arr1);
		}else if(arr2){
			arr = eval("excludeElements_"+jionArr).concat(arr2);
		}else if(arr3){
			arr = eval("excludeElements_"+jionArr).concat(arr3);
		}
		
		return arr;
}

function delProjectBbs(listForm)
{
	var i;
	var ids="";
	var objs=document.getElementsByName("id");	
	
	for(i=0;i<objs.length;i++)
	{
	  if(objs[i].checked==false){continue;}	  
	  ids+=objs[i].value+",";	  
	}
	if(ids.length>0){ids=ids.substr(0,ids.length-1);}
	if(ids.length<=0)
	{
		alert(_("ProjectLang.choose_item_from_list"));
		return;
	}
	if(window.confirm(_("ProjectLang.sure_to_delete"))==false)
	{
		return;
	}
	listForm.submit();
}


function openType(id) {
	
	try {
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager",
			 "getTheOpenType", false);
		requestCaller.addParameter(1, "Long", id);
				
		var flag = requestCaller.serviceRequest();
		
		return flag;
	}
	catch (ex1) {
		alert("Exception : " + ex1.message);
	}

}

function pigSourceExist(appEnumKey, sourceId){
	try {
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager",
			 "hasPigeonholeSource", false);
		requestCaller.addParameter(1, "Integer", appEnumKey);
		requestCaller.addParameter(2, "Long", sourceId);
				
		var flag = requestCaller.serviceRequest();

		
		return flag;
	}
	catch (ex1) {
		//alert("Exception : " + ex1.message);
		return 'false';
	}
  }
  
  function  projectDocExist(id){
	
	try {

     var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager",
		 "docResourceExist", false);
	  requestCaller.addParameter(1, "Long", id);
			
	  var flag = requestCaller.serviceRequest();
	  return flag;

	}catch (ex1) {
	
		return 'false';
	}
}

//查看项目详情
function showProjectInfo(obj){
	var projectIdvalue = document.getElementById("hiddenProjectId").value;
	if(obj==1){
		var configProDialog = v3x.openDialog({
		url : projectUrl+"?method=detailProject&update=update&projectId="+projectIdvalue,
		width : 600,
		height :600,
		title:v3x.getMessage("ProjectLang.config_project"),
        targetWindow:getA8Top(),
		buttons:[{
	    	id:'ok',
	        text: v3x.getMessage("ProjectLang.project_sure"),
	        emphasize: true,
	        handler: function(){
		    	var rv = configProDialog.getReturnValue();		    	
		    	if(rv){
		    		setTimeout(function(){
		    			configProDialog.close();
		    			setTimeout(function(){
		    			  window.location.reload(true);
		    			},600);
		    		},500);
		    		
		    	}
	        }
	    },{
			id:'cancel',
	        text: v3x.getMessage("ProjectLang.project_calcel"),
	        handler: function(){
	    		configProDialog.close();
	        }
		}]
	   }) ;
	}else{
		var showProDetailDialog = v3x.openDialog({
			url : projectUrl + "?method=getProject&from=1&projectId="+projectIdvalue,
			width : 600,
			height :600,
			title:v3x.getMessage("ProjectLang.project_detail"),
			targetWindow:getA8Top(),
			buttons:[{
		    	id:'ok',
		        text: v3x.getMessage("ProjectLang.project_calcel"),
		        handler: function(){
		          showProDetailDialog.close();
		        }
		    }]
	    }) ;
	}
}
 function hasOpenAcl(all,edit,add,readonly,browse,list){
 	if('true' == all || 'true' == edit || 'true' == readonly || 'true' == browse)
 		return true;
 	else{
 		alert(v3x.getMessage('ProjectLang.project_open_no_acl_alert'));
 		return false;
 	}
 }

function checkSendMessage(str){
	str = str.trim();
	if(str.length == 0){
		alert(v3x.getMessage("ProjectLang.leaveMessageIsNull"));
		return false;
	}else if(str.length > 1200){
		alert(v3x.getMessage("ProjectLang.leaveMessageNowLength") + str.length + v3x.getMessage("ProjectLang.leaveMessageChange"));
		return false;
	}else{
		return true;
	}
}

/**
 * 人员权限解释
 */
function showDescription(){
    var showDescriptionDialog = v3x.openDialog({
    	id:"showDescriptionId",
    	title:" ",
        url: genericControllerURL + "project/nodeDescription",
        width: "500",
        height: "500",
        width: 600,
        height: 600,
        isDrag:false,
        targetWindow:getA8Top(),
        buttons:[{
			id:'cancel',
	        text: '关闭',
	        handler: function(){
	        	showDescriptionDialog.close();
	        }
		}]
    });
}

/**
 * 项目阶段
 */
function Phase(phaseId, phaseName, phaseBegintime, phaseClosetime, beforeAlarmDate, endAlarmDate, phaseDesc){
	this.phaseId = phaseId;
    this.phaseName = phaseName;
    this.phaseBegintime = phaseBegintime;
    this.phaseClosetime = phaseClosetime;
    this.beforeAlarmDate = beforeAlarmDate;
    this.endAlarmDate = endAlarmDate;
    this.phaseDesc = phaseDesc;
}

/**
 * 增加、修改项目阶段
 */
function addPhases(type){
	var id;
	if(type == "update"){
		id = getSelectId(v3x.getMessage("ProjectLang.please_choose_one_data"), v3x.getMessage("ProjectLang.please_choose_one_data"));
		if(!id){
			return;
		}
	}
	
	var projectStartDate = document.getElementById("begintime").value;
	var projectEndDate = document.getElementById("closetime").value;
	
	if(projectStartDate == "" || projectStartDate.length == 0){
		alert(v3x.getMessage("ProjectLang.project_start_end_time_register"));
		return;
	}else if(projectEndDate == "" || projectEndDate.length == 0){
		alert(v3x.getMessage("ProjectLang.project_start_end_time_register"));
		return;
	}

	if(compareDate(projectStartDate, projectEndDate) > 0){
		alert(v3x.getMessage("ProjectLang.begindate_can_not_late_than_enddate"));
		return;
	}
	
	getA8Top().addPhaseDialog = v3x.openDialog({
		id:"addPhaseId",
		title:" ",
		url : addPhaseURL + "&type=" + type + "&id=" + id,
		width : "600",
		height : "300",
		isDrag:false,
		transParams:{'parentWin':window},
        targetWindow:getA8Top()
	});
}

/**
 * add by renjia 2012-7-24
 * 根据阶段ID找到阶段名称
 */
function getPhaseName( phaseId ){
    var updateProjectPhasesArr = document.getElementsByName("updateProjectPhases");
	//var updateProjectPhasesArr = $("input[name='updateProjectPhases']").val;
	if( !updateProjectPhasesArr ){
		return;
	}
	
	for( var i=0 ; i<updateProjectPhasesArr.length ; i++ ){
       var projectInfoArr = updateProjectPhasesArr[i].value.split("-phaseSplit-");
       var pi_projectId = projectInfoArr[ 0 ];
       var pi_projectName = projectInfoArr[ 1 ];
	 //var projectInfoArr = updateProjectPhasesArr[i].value.split("-phaseSplit-");
        
       if( pi_projectId == phaseId ){
    		return pi_projectName;
       }
	}
	return "";
	
}

/**
 * 删除项目阶段
 */
function deletePhases(){
	var hasChecked = getSelectIds().split(",");
	if(hasChecked.length == 1 && hasChecked[0]==""){ //没有实体ID 也会返回length==1的数据，hasChecked[0]=="";
		alert(v3x.getMessage("ProjectLang.please_choose_one_data_at_least"));
		return;
	}else{
		if(confirm(v3x.getMessage("ProjectLang.sure_to_delete"))){
			
			for(var i = 0; i < hasChecked.length-1; i++){//hasChecked最后一个元素为“”，不需循环此数据
				//[begin] add by renjia 20120724
				
				//根据项目节点的ID查询项目阶段下是否存在文档
				var requestCaller = new XMLHttpRequestCaller(this, "ajaxDocHierarchyManager", "hasDocsInProject", false);
				requestCaller.addParameter(1, "long", hasChecked[i]);
				var rv = requestCaller.serviceRequest();

				if( rv == "true" ){
					if( !confirm( getPhaseName(hasChecked[i])+ v3x.getMessage("ProjectLang.project_period_exist_doc") ) ){
						continue;//用户选择取消，不删除
					}
				}
				//[end] add by renjia 20120724
				
				$("#" + hasChecked[i] + "Tr").remove();
				projectArr.remove(hasChecked[i]);
				$("#phasesTable").append("<input type='hidden' id='deleteProjectPhases' name='deleteProjectPhases' value='" + hasChecked[i] + "' />");
				if($("#currentPhaseId").val()==hasChecked[i]){ //如果删除的阶段已被选为当前阶段，则当前阶段设为空
					$("#currentPhaseName").val("");
				}
			}
			
			//如果没有项目阶段,不能设置当前阶段
			if(projectArr.size() == 0){
				$("#currentPhaseId").val("");
				$("#currentPhaseName").val("");
				//$("#currentPhaseTr").hide();
				$("#currentPhaseTr").addClass("hidden");
			}
		}
	}
}

/**
 * 添加项目阶段,table添加一行
 */
function addPhaseTr(id, type){
	var obj = projectArr.get(id);
	var hiddenId = type == "update" ? "updateProjectPhases" : "addProjectPhases";
	var value = obj.phaseId + "-phaseSplit-" + obj.phaseName + "-phaseSplit-" + obj.phaseBegintime + "-phaseSplit-" + obj.phaseClosetime + 
				"-phaseSplit-" + obj.beforeAlarmDate + "-phaseSplit-" + obj.endAlarmDate + "-phaseSplit-" + obj.phaseDesc;
	var tr = "<tr id='" + obj.phaseId + "Tr'>" + 
			 "<td align='center' class='phaseBox'><input type='checkbox' name='id' value='" + obj.phaseId + "'/><input type='hidden' id='" + hiddenId + "' name='" + hiddenId + "' value='" + value + "' /></td>" + 
			 "<td class='phaseTd'>" + obj.phaseName + "</td>" + "<td class='phaseTd'>" + obj.phaseBegintime + " ~ " + obj.phaseClosetime +  "</td>" + 
			 "</tr>";
	if(type == "update"){
		tr = "<td align='center' class='phaseBox'><input type='checkbox' name='id' value='" + obj.phaseId + "'/><input type='hidden' id='" + hiddenId + "' name='" + hiddenId + "' value='" + value + "' /></td>" + 
             "<td class='phaseTd'>" + obj.phaseName + "</td>" + "<td class='phaseTd'>" + obj.phaseBegintime + " ~ " + obj.phaseClosetime +  "</td>" ;
		$("#" + id + "Tr").html(tr);
		if($("#currentPhaseId").val()==obj.phaseId){
			document.getElementById("currentPhaseName").value=obj.phaseName
		}
	}else{
		$("#phasesTable").append(tr);
	}
	
	//如果有项目阶段,必须设置当前阶段
	if($("#currentPhaseTr").is(":hidden")){
		//$("#currentPhaseTr").show();
		$("#currentPhaseTr").removeClass("hidden");
	}
}

/**
 * 选择模板
 */
function setProjectTemplete(isSpace){
	var selectTemplateIds = $("#templates").val();
	var projectTempleteWin = v3x.openDialog({
		id: "projectTempleteWin",
		title: v3x.getMessage("ProjectLang.select_template"),
		url: "/seeyon/template/template.do?method=templateChooseMul&moduleType=1,2&isMul=true&scope=MemberUse&_tids="+selectTemplateIds,
		width: 600,
        height: 600,
        isIframe:true,
        isDrag:false,
        targetWindow:getA8Top(),
	    buttons:[{
	    	id:'ok',
	        text: v3x.getMessage("ProjectLang.project_sure"),
	        emphasize: true,
	        handler: function(){
	        	try{
		    		var rv = projectTempleteWin.getReturnValue();
		    		var templeteIds = rv.ids.split(",");
		    		var templeteNames = rv.names;
		    		var ids = "";
		    		var names = "";
		    		for(var i = 0; i < templeteIds.length; i++){
		    			if(templeteIds[i] !=null && templeteIds[i]!=""){
		    				ids += templeteIds[i] + ",";
			    			names += templeteNames[i] + "、";
		    			}
		    		}
		    		ids = ids.substring(0, ids.length - 1);
		    		if(isSpace == 'true'){
		    			$.ajax({
							async: false,
							type: "POST",
							url: projectUrl + "?method=setTemplete",
							data: {"projectId": $("#hiddenProjectId").val(), "templates": ids},
							success: function(){
								projectTempleteWin.close();
								window.location.reload(true);
							}
						});
		    		}else{
		    			paramValue = ids;
			    		$("#templates").val(ids);
			    		$("#templatesWeb").val(names.substring(0, names.length - 1));
			    		projectTempleteWin.close();
		    		}
	        	}catch(e){
	        		projectTempleteWin.close();
	        	}
	        }
	    },
	    {
			id:'cancel',
	        text: v3x.getMessage("ProjectLang.project_calcel"),
	        handler: function(){
	    		projectTempleteWin.close();
	        }
		}]
	});
}

/**
 * form验证
 */
function checkThisForm(myForm){
	//验证项目类型
	var projectType = $("#projectType").val();
	if(projectType == ""){
		alert(_("ProjectLang.project_type_not_null"));
		return false;
	}
	
	//验证开始日期、结束日期
	var beginDate = $("#begintime").val();
	var endDate = $("#closetime").val();
	if(beginDate != "" && endDate != ""){
		if(compareDate(beginDate, endDate) > 0){
			alert(_("ProjectLang.begindate_can_not_late_than_enddate"));
			return false;
		}
	}
	
	//验证当前阶段
	if(projectArr.size() > 0){
		var currentPhaseId = $("#currentPhaseId").val();
		var currentPhaseName = $("#currentPhaseName").val();
		if(currentPhaseId == "" || currentPhaseName == ""){
			alert(_("ProjectLang.project_phase_must_be_set"));
			return false;
		}
	}
		//验证项目编号长度
	var projectNum = $("#projectNum").val();
	if(projectNum.length>40){
		alert("项目编号长度不能超过40");
		return false;
	}
	if(!checkForm(myForm)){
		return false;
	}
	
	$("#b1").attr("disabled", true);
	$("#b2").attr("disabled", true);
	
	return true;
}

/**
 * 合并数组选人界面不出现的人员
 */
function joinArrays(jionArr, arr1, arr2, arr3, arr4){
	var arr = new Array();
	excludeElements_manage = new Array();
	excludeElements_assistant = new Array();
	excludeElements_member = new Array();
	excludeElements_charge = new Array();
	excludeElements_interfix = new Array();
	if (!arr1) arr1 = new Array();
	if (!arr2) arr2 = new Array();
	if (!arr3) arr3 = new Array();
	if (!arr4) arr4 = new Array();
	arr = eval("excludeElements_" + jionArr).concat(arr1, arr2, arr3, arr4);
	return arr;
}

/**
 * 修改项目进度
 */
function setProcess(){
	var projectId = document.getElementById("hiddenProjectId").value;
	var evt = v3x.getEvent();
	getA8Top().setProcessDialog = getA8Top().$.dialog({
		title:" ",
		url: genericControllerURL + "project/setProjectbar&projectId=" + projectId,
	    width: "300",
	    height: "170",
	    transParams:{'parentWin':window}
	});
}

function callBackSetProcess(){
	window.location.reload(true);
}

/**
 * 项目首页－修改项目当前阶段
 */
function setPhase(){
	var projectId = document.getElementById("hiddenProjectId").value;
	var evt = v3x.getEvent();
	getA8Top().setPhaseDialog = v3x.openDialog({
		title:" ",
		url: projectUrl + "?method=setPhase&projectId=" + projectId,
	    width: "300",
	    height: "200",
	    transParams:{'parentWin':window}
	});
}

function callBackSetPhase(){
	window.location.reload(true);
}

/**
 * 新建、修改项目－修改项目当前阶段
 */
function setPhaseForCreate(){
	var evt = v3x.getEvent();
	getA8Top().phaseForCreateDialog = v3x.openDialog({
		title:" ",
		url: genericControllerURL + "project/setPhaseForCreate",
	    width: "300",
	    height: "170",
	    resizable: true,
	    transParams:{'parentWin':window}
	});
}

/**
 * 切换项目
 */
function changeProject(projectSelect){
	window.location = projectUrl + '?method=projectInfo&projectId=' + projectSelect.value;
}

/**
 * 切换项目阶段
 */
function changePhase(phaseSelect){
	var projectId = document.getElementById("hiddenProjectId").value;
	window.location = projectUrl + '?method=projectInfo&projectId=' + projectId + '&phaseId=' + phaseSelect.value;
}

function changeProjectPhase4Tasks(phaseSelect) {
	var projectId = document.getElementById("projectId").value;
	var projectType = document.getElementById("morePro").value;
	var managerFlag = document.getElementById("managerFlag").value;
	var projectState;
	if(document.getElementById("projectState") != null ) {
		projectState = document.getElementById("projectState").value;
	}
	if (projectType == "collaboration") {
		window.location = '/seeyon/project.do?method=moreProjectCol&projectId=' + projectId + '&phaseId=' + phaseSelect.value +'&managerFlag=' +managerFlag;
	} else if (projectType == "calendar") {
		window.location = '/seeyon/project.do?method=moreProjectPlanAndMeeting&projectId=' + projectId + '&phaseId=' + phaseSelect.value +'&managerFlag=' +managerFlag;
	} else if (projectType == "doc") {
		window.location = '/seeyon/project.do?method=moreProjectDoc&projectId=' + projectId + '&phaseId=' + phaseSelect.value +'&managerFlag=' +managerFlag;
	} else if (projectType == "bbs") {
	  var relatCod = document.getElementById("relat").value;
		window.location = '/seeyon/bbs.do?method=moreProjectBbs&projectId=' + projectId + '&phaseId=' + phaseSelect.value +'&managerFlag=' +managerFlag+'&projectState='+projectState+'&relat='+relatCod;
	} else if (projectType == "projectTask") {
		window.location = taskManageUrl + '?method=projectTaskListMore&from=Project&projectId=' + projectId + '&projectPhaseId=' + phaseSelect.value+'&managerFlag=' +managerFlag+'&projectState='+projectState;
	}
}

var isClick = 0;

function addProjectTask(projectId, projectPhaseId, projectBeginTime, projectEndTime,optype) {
	var url = taskManageUrl + '?method=newTaskInfo&from=Project&projectId=' + projectId + '&projectPhaseId=' + projectPhaseId + 
			  '&beginDate=' + projectBeginTime + '&endDate=' + projectEndTime + '&optype='+ optype;
	var taskDialog = v3x.openDialog({
		id : 'taskDialog',
		title : v3x.getMessage("ProjectLang.new_project_task"),
		url : url,
		width	: 600,
		height	: 550,
		targetWindow : getA8Top(),
		resizable	: "false",
		buttons:[{
              id:'OK',
              text: v3x.getMessage("ProjectLang.project_sure"),
              emphasize: true,
              handler:function(){
              	if(isClick == 0){
              		var ret = taskDialog.getReturnValue();
    			    if(ret == true || ret == 'true') {
    			    	isClick = 1;    			    	
    			    	setTimeout(function(){taskDialog.close();refresh();},500);			        			        
    			    }
              	}
                
              }
            },{
              id:"OkAndContinue",
              text: v3x.getMessage("ProjectLang.ok_and_continue"),
              handler:function(){
            	var ret = taskDialog.getReturnValue();
            	if(ret){
            		var isFirefox = window.navigator.userAgent.indexOf("Firefox") !== -1;
            		if(isFirefox) {
            		  setTimeout(function(){taskDialog.reloadUrl(url);},500);
            		} else {
            		  taskDialog.reloadUrl(url);
            		}
                    isContinuous = true;
                }
              }
            },{
              id:'Cancel',
              text: v3x.getMessage("ProjectLang.project_calcel"),
              //text:'Cancel',
              handler: function(){
              	if(isContinuous == true || isContinuous == "true") {
              		setTimeout(function(){refresh();},500);
              	}
                taskDialog.close();
              }
            }]
	});

}

function refresh(){
    window.location.reload();
}

function moreProjectTasks(projectId, projectPhaseId, managerFlag,projectState,isNewTask) {
	window.location.href = taskManageUrl + '?method=projectTaskListMore&from=Project&projectId=' + projectId + '&projectPhaseId=' + projectPhaseId + '&managerFlag=' + managerFlag+'&projectState='+projectState+'&isNewTask='+isNewTask;
}
	
/**
 * 按项目负责人查询，选人界面返回值
 */
function setSearchPeopleFields(elements){
	$("#projectManagerId").val(getIdsString(elements, false));
	$("#projectManagerName").val(getNamesString(elements));
}

/**
 * 设置项目的开始日期或结束日期,如果已有项目阶段判断日期是否符合场景
 */
function selectProjectDate(type, contextPath, obj){
	var result = whenstart(contextPath, null, 300, 200, 'date');
	if(result){
	    var phasesKeys = projectArr.keys();
	    for(var i = 0; i < phasesKeys.size(); i ++){
	        var phaseObj = projectArr.get(phasesKeys.get(i));
	        var phaseObjBegintime = phaseObj.phaseBegintime;
	        var phaseObjClosetime = phaseObj.phaseClosetime;
	        
	        if(type == "start"){
	        	if((compareDate(result, phaseObjBegintime) > 0)){
		    		alert(v3x.getMessage("ProjectLang.project_startdate_can_not_more_than_phase_startdate"));
		        	return;
		        }
	        }else if(type == "end"){
	        	if((compareDate(result, phaseObjClosetime) < 0)){
		    		alert(v3x.getMessage("ProjectLang.project_enddate_can_not_late_than_phase_enddate"));
		        	return;
		        }
	        }
	    }
	    obj.value = result;
	}
	if(result==""){
		obj.value = result;
	}
}
var projectTypeProps = new Properties();
function syncProjectTypeName(selectObj) {
//	var projectTypeName = projectTypeProps.get(selectObj.value);
//	if(projectTypeName && projectTypeName.trim() != '') {
//		document.getElementById('projectType').value = projectTypeName;
//	}
	document.getElementById('projectType').value = document.getElementById('projectType_'+selectObj.value).value;
}

function setDate(id) {
	var startDate = document.getElementById("startdate");
	var endDate = document.getElementById("enddate");
	if(arguments && arguments.length == 3) {
		startDate = document.getElementById(arguments[1]);
		endDate = document.getElementById(arguments[2]);
	}
	if(startDate.value == '' || endDate.value == '')
		return;
		
	var result = compareDate(startDate.value, endDate.value);
	var setDate;
	if(result>0){
		if(id=='startdate') {
			setDate = parseDate(startDate.value);
			endDate.value = formatDate(setDate.dateAdd(startDate.value, 7));
		} else {
			setDate = parseDate(endDate.value);
			startDate.value = formatDate(setDate.dateAdd(endDate.value, -7));
		}
	}
}

function getSelectId(msg0) {
    var ids = document.getElementsByName('id');
    var length = 0;
    var id = "";
    for(var i=0; i<ids.length; i++) {
        if(ids[i].checked) {
            if(length == 0)
                id += ids[i].value;
            else
                id += ',' + ids[i].value;
                
            length += 1;
        }
    }
    if(length == 0) {
        alert(msg0);
        return false;
    }
    if(arguments.length > 1 && arguments[1] && length > 1) {
        alert(arguments[1]);
        return false;
    }
    return id;
}


function getSelectIds(){
    var ids=document.getElementsByName('id');
    var id='';
    for(var i=0;i<ids.length;i++){
        var idCheckBox=ids[i];
        if(idCheckBox.checked){
            id=id+idCheckBox.value+',';
        }
    }
    return id;
}