<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<%--
	这块代码实现不是很好，后期考了重写
 --%>
<script type="text/javascript">
	var selectId;
	var locationId;
	/**projectProperties属性
 	* id->select对象的id(<select id='"+select_id+"'>)
 	* name->select对象的name属性
 	* disabled->是否置灰
 	* style 样式
 	* class 也是样式
 	* location_id->放置位置的id(<div id='"+location_id+"'>)
 	* relateProjectId->所选中的关联项目id
 	* fn-回调函数
 	*/
	var initProjectSelect=function(selectProperties,location_id,relateProjectId,fn){
		selectId=selectProperties["id"];
		locationId=location_id;
		var user=$.ctx.CurrentUser;
		var projectQueryManager_=new projectQueryManager();
		//ajax请求获取十三个标星项目,标星项目不足13个用一般项目补齐
		var isTemFlag=selectProperties["isTemFlag"];
		var isDisabled=selectProperties["disabled"];
		//var retObj=projectQueryManager_.getMixProjectList(user,(isTemFlag!=undefined&&isDisabled!=undefined)?isTemFlag:"");
		//第一步:隐藏域输入框,用于存储选择的项目id,点击更多的时候回填要用
		var proHtml="<input id='myProject' type='hidden'/><select";
		for(var p in selectProperties){
			//第一步:遍历selectProperties对象,取出对应属性放入select中,拼接html
			if(p!="disabled"){
				proHtml+=" "+p+"='"+selectProperties[p]+"' ";
			}
		}
		//第二步:第一列默认都显示无
		proHtml+="><option id='none' title='${ctp:i18n('common.none')}' value='-1' selected>${ctp:i18n('common.none')}</option>";//无
		var isList=false;
		/* for(var i=0;i<retObj.length;i++){
			if(retObj[i].id==relateProjectId){
				isList=true;
			}
			var projectName=getProjectName(retObj[i].projectName);
			//第三步:拼接option元素
			proHtml+="<option title='"+projectName+"' value='"+retObj[i].id+"'>"+projectName+"</option>";
		} */
		//第三步:最后一列-更多
		//if(retObj.length>=13){
			proHtml+="<option title='${ctp:i18n('project.body.select.label')}' id='allMore' dataType=''>${ctp:i18n('project.body.select.label')}</option>";
		//}
		proHtml+="</select><div><div>";
		//绑定select到指定位置
		$("#"+location_id+"").html(proHtml);
		$("#"+selectId).css("vertical-align","top");
		bindEvent(fn);
		if(relateProjectId!=""&&relateProjectId!=undefined&&relateProjectId!=-1){
			//取项目名称
			var projectName=projectQueryManager_.getProjectName(relateProjectId);
			if(projectName != null){
				relateProjectName=getProjectName(projectName);
				$("#"+locationId+" #myProject").val(relateProjectId);
				//在下拉列表中不存在,在更多下新增一项
				var $hh= $("<option value='"+relateProjectId+"' title='"+relateProjectName+"' id='selProject'></option>").text(projectName);
				fillProject($hh,selectProperties['id'],relateProjectId);
			}
		}
		if(selectProperties["disabled"]!=undefined){
			$("#"+selectProperties["id"]).attr("disabled",selectProperties["disabled"]);
		}
		//OA-70888IE7兼容：关联项目选择框错位
		$("#"+location_id).addClass("common_selectbox_wrap");
	}
	/* 回填项目 */
 	function fillProjectById(select_id,projectId){
 		if(projectId!=""&&projectId!=undefined&&projectId!=-1){
 			var projectQueryManager_=new projectQueryManager();
			//取项目名称
			var projectNameInfo=projectQueryManager_.getProjectNameInfo(projectId);
			if(projectNameInfo.existed){
				var relateProjectName = getProjectName(projectNameInfo.projectName);
				$("#"+locationId+" #myProject").val(projectId);
				//在下拉列表中不存在,在更多下新增一项
				var $hh = $("<option value='"+projectId+"' title='"+relateProjectName+"' id='selProject'></option>").text(projectNameInfo.projectName);
		 		fillProject($hh,select_id,projectId,projectNameInfo.projectName);
				$("#"+select_id+" #selProject").attr("selected",true);
			}
		}
	}
 	
	
	function getProjectName(projectName){
			projectName=projectName+"";
			return projectName.escapeHTML();
	}
	//针对查看置灰情况,单独展现一个select下拉列表(只有一项option)
	function initModify(selectProperties,location_id,relateProjectId){
		var projectQueryManager_=new projectQueryManager();
		//取项目名称
		var relateProjectName=projectQueryManager_.getProjectName(relateProjectId);
		if(relateProjectName != null){
			var $proHtml = $("<select id='"+selectProperties['id']+"' disabled><option value='"+relateProjectId+"'></option></select>");
			$proHtml.find("option").text(relateProjectName);
			$("#"+location_id+"").html($proHtml);
		}else{
			var proHtml="<select id='"+selectProperties['id']+"' disabled><option value='-1'>${ctp:i18n('common.none')}</option></select>";
			$("#"+location_id+"").html(proHtml);
		}
	}
	//回填所选中项目
	function fillProject(hh,select_id,projectId,projectName){
		var selProject=$("#"+select_id+" #selProject").length;
        $("#"+select_id+" #allMore").attr("selected",false);
		if(selProject==0){
			//如果selProject元素不存在,新增一项
			$("#"+select_id+" #allMore").before(hh);
		}else{
			//存在,只需替换掉值
			$("#"+select_id+" #selProject").val(projectId);
            $("#"+select_id+" #selProject").text(projectName);
            $("#"+select_id+" #selProject").attr("title",projectName);
		}
		$("#"+select_id+"").val(projectId);
	}
	
	function showProject(select_id,fn){
		getA8Top().up = window;
		var projectDialog=$.dialog({
    	    id: 'projectDialog',
    	    url: _ctxPath +"/project/project.do?method=showProjectList",
    	    width: 780,
    	    height: 450,
    	    targetWindow:getCtpTop(),
    	    title: "${ctp:i18n('project.body.warning.label')}",
    	    closeParam:{
    	   		show:true,
    	    	handler:function(){
              		closefillProject();
    	    	}
    	    },
    	    buttons : [{
              text : "${ctp:i18n('message.ok.js')}",
              handler : function() {
              	var retObj=projectDialog.getReturnValue();
              	if(retObj==false){
              		$.alert("${ctp:i18n('project.body.warning.label')}");
              		return false;
              	}
              	if(retObj!=null){
              		var projectId=retObj.projectId;
              		var projectName=getProjectName(retObj.projectName);
              		var dataType=retObj.dataType;
              		$("#"+locationId+" #myProject").val(projectId);
              		//从弹出框选中的项目,回填选择更多
              		var len=$("#"+select_id).find("option[value='"+projectId+"']").length;
              		if(len>0){
              			$("#"+select_id).val(projectId);
              		}else{
              			var $hh= $("<option value='"+projectId+"' title='"+projectName+"' id='selProject'></option>").text(retObj.projectName);
              			fillProject($hh,select_id,projectId,retObj.projectName);
              		}
              		if($("#projectPhaseId").length == 1){
	              		var _projectQueryManager_=new projectQueryManager();
	              		var projectSummaryInfo = _projectQueryManager_.getProjectSummaryInfo(projectId);
	              		if(projectSummaryInfo!=null){
	              			$("#projectPhaseId").val(projectSummaryInfo.phaseId);
		              	}
              		}
              	}
              	if(fn){
              		fn();
              	}
              	projectDialog.close();
          	}
        	}, {
              text : "${ctp:i18n('message.cancel.js')}",
              handler : function() {
              		closefillProject();
                	projectDialog.close();
             }
            }]
    	});
	}
	//点击取消和关闭按钮时,回填回原来的项目
	function closefillProject(){
		var proId=$("#"+locationId+" #myProject").val();
		if(proId!=""){
			$("#"+selectId).val(proId);
		}else{
			//初始值选择的是"无",点击取消也需要回填到"无"
        	$("#"+selectId).val("-1");
		}
	}
	//关联项目回调函数
	function getProject(){
		var obj=new Object();
		obj.projectId=$("#"+locationId+" #myProject").val();
		//obj.dataType=$("#"+selectId).attr("dataType");
		return obj;
	}
	
	function bindEvent(fn){
        $("#"+selectId).live("change",function(){
			var item=$("#"+selectId+"").find("option:selected");
			var itemId=item.attr("id");
			var itemValue=item.val();
			if("allMore"!=itemId){
				$("#"+locationId+" #myProject").val(itemValue);
				//当选择"无'，需要查询对应的项目阶段
				if(itemValue!=-1){
					var _projectQueryManager_=new projectQueryManager();
					var projectSummaryInfo = _projectQueryManager_.getProjectSummaryInfo(itemValue);
	          		if(projectSummaryInfo==null){
		      			$("#projectPhaseId").val(1);
	              	}else if(projectSummaryInfo!=null){
	              		$("#projectPhaseId").val(projectSummaryInfo.phaseId);
	                 }
				}else{
		      			$("#projectPhaseId").val(1);
				}
				if(fn){
					fn();
				}
			}else{
				showProject(selectId,fn);
			}
		})
	}
</script>