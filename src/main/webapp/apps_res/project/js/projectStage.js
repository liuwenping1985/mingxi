	var paratWindow;
	var parentWindowData;
	var projectAjax = new projectConfigManager();
	var isAdd = true;//true:新建		false:修改
	var changeNum=0;
	
	function init(){
		paratWindow = window.parentDialogObj['projectStageWin'];
		parentWindowData = window.dialogArguments;
		if(parentWindowData.index!=0){
			initData(parentWindowData.index);
		}
	}
	/**
	 * 初始化数据
	 */
	function initData(index){
		$("#phaseId").val(parentWindowData.stageList[index-1].phaseId);
		$("#phaseName").val(parentWindowData.stageList[index-1].phaseName);
		$("#phaseBegintime").val(parentWindowData.stageList[index-1].phaseBegintime.substring(0,10));
		$("#phaseClosetime").val(parentWindowData.stageList[index-1].phaseClosetime.substring(0,10));
		$("#beforeAlarmDate option[value='"+parentWindowData.stageList[index-1].beforeAlarmDate+"']").attr("selected",true);
		$("#endAlarmDate option[value='"+parentWindowData.stageList[index-1].endAlarmDate+"']").attr("selected",true);
		$("#phaseDesc").val(parentWindowData.stageList[index-1].phaseDesc);
		if(undefined == parentWindowData.stageList[index-1].isAdd){
			isAdd = false;
			$("#phaseId").val(parentWindowData.stageList[index-1].id);
			$("#projectId").val(parentWindowData.stageList[index-1].projectId);
		}
	}
	/**
	 * 增加项目阶段
	 */
	function addPhase(){
		var phaseId=$("#phaseId").val();
		var phaseName=$("#phaseName").val();
		var phaseBegintime=$("#phaseBegintime").val();
		var phaseClosetime=$("#phaseClosetime").val();
		var beforeAlarmDate=$("#beforeAlarmDate").val();
		var endAlarmDate=$("#endAlarmDate").val();
		var phaseDesc=$("#phaseDesc").val();
		var projectId=$("#projectId").val();
		var phase = new Phase(phaseId,phaseName,phaseBegintime,phaseClosetime,beforeAlarmDate,endAlarmDate,phaseDesc,projectId);
		return phase;
    }
   	/**
	 * 判断是否有变动
	 */
	function isChange(){
   		changeNum++;   	
	}

	/**
	 * 取消
	 */
	function CLOSE(){
		if(changeNum != 0){
			var confirm =$.confirm({
				'msg': $.i18n("project.phase.ischange"),
        		ok_fn: function () {
        			var phase = OK();
        			if(null!=phase){
        				parentWindowData.affterAddPhase(phase ,parentWindowData.index ,paratWindow);
        			}
				 },
        		cancel_fn:function(){
        			paratWindow.close();
				}
			});
	   	}else{
	   		paratWindow.close();
	   	}
	}
	
	function OK(){
		var parentBegintime = parentWindowData.beginTime;
		var parentClosetime = parentWindowData.endTime;
		var phaseBegintime = $("#phaseBegintime").val();
		var phaseClosetime = $("#phaseClosetime").val();
		
		if(compareDate(phaseBegintime, phaseClosetime) > 0){
			$.alert($.i18n("project.phase.startdate.cannot.late.enddate"));
			return;
		}
		if(compareDate(phaseBegintime, parentBegintime) < 0){
			$.alert($.i18n("project.phase.startdate.than.project.startdate"));
			return;
		}else if(compareDate(phaseBegintime, parentClosetime) > 0){
			$.alert($.i18n("project.phase.startdate.than.project.enddate"));
			return;
		}
		if(compareDate(phaseClosetime, parentBegintime) < 0){
			$.alert($.i18n("project.phase.enddate.than.project.startdate"));
			return;
		}else if(compareDate(phaseClosetime, parentClosetime) > 0){
			$.alert($.i18n("project.phase.enddate.than.project.enddate"));
			return;
		}
		
		$("#phaseName").val($.trim($("#phaseName").val()));
		var myForm = $("#tabs2");
		if(myForm.validate()){
			var isExist=false;
			for(var i=0;i<parentWindowData.stageList.length;i++){
				if(i == parentWindowData.index-1){
					continue;
				}
				var phase = parentWindowData.stageList[i];
				if(phase.phaseName == $("#phaseName").val()){
					isExist=true;
					break;
				}
			}
			if(isExist){
				$.alert($.i18n("project.phase.name.repeat"));
				paratWindow.enabledBtn('ok');
				return;
			}else{
				paratWindow.disabledBtn('ok');
				return addPhase();
			}
		}else{
			paratWindow.enabledBtn('ok');
		}
	}
	
	
/**
 * 项目阶段
 */
function Phase(phaseId, phaseName, phaseBegintime, phaseClosetime, beforeAlarmDate, endAlarmDate, phaseDesc,projectId){
	if("" == phaseId){
		this.phaseId = projectAjax.getUUID().uuid; 
	}else{
		this.phaseId = phaseId;
	}
    this.phaseName = phaseName;
    this.phaseBegintime = phaseBegintime;
    this.phaseClosetime = phaseClosetime;
    this.beforeAlarmDate = beforeAlarmDate;
    this.endAlarmDate = endAlarmDate;
    this.phaseDesc = phaseDesc;
    this.isAdd = isAdd;
    this.projectId = projectId;
}
function closeWindow(){
	this.close();
}