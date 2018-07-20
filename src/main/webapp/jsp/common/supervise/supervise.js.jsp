<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ page isELIgnored="false" import="com.seeyon.ctp.common.AppContext"%>
<script type="text/javascript">
/**
组件：督办设置窗口
参数1：superviseType   superviseEnum枚举 0是模板 1是协同 2是公文
参数2：isSubmit 是否直接提交 true or false 
参数3：moduleId 主应用ID
参数4：templateId 模板Id 说明：如果是模板设置督办的话MODULEID == NULL,template = 模板ID，如果具体流程的话，MODULEID为应用ID，templateID如果调用了模板就是模板ID
@param startMemberId : 发起人ID
 */
function openSuperviseWindow(superviseType,isSubmit,moduleId,templateId,callBack,startMemberId){

	
	superviseType = $.trim(superviseType);
	isSubmit = $.trim(isSubmit);
	moduleId = $.trim(moduleId);
	templateId = $.trim(templateId);
	startMemberId = $.trim(startMemberId);

    $("#superviseType").val(superviseType);
    $("#moduleId").val(moduleId);
	
    var isTemplate='no';
	if(templateId && !moduleId ){
		isTemplate="yes";
	}
	var superviseId = $("#detailId").val();
	var awakeDate = $("#awakeDate").val();
	var superviseTitle = $("#title").val();
	var supervisors = $("#supervisorNames").val();
	var supervisorsId = $("#supervisorIds").val();
	var role = $("#role").val();
	var unCancelledVisor = $("#unCancelledVisor").val();
	var templateDateTerminal = $("#templateDateTerminal").val();
	var hasLoad = $("#hasLoad").val();
	var dialog = $.dialog({
		 targetWindow:getCtpTop(),
	     id: 'superviseWindow',
	     url: _ctxPath+'/supervise/supervise.do?method=openSuperviseWindow&superviseType='
	          +superviseType+'&isSubmit='+isSubmit+'&moduleId='+moduleId+'&templateId='+$.trim(templateId)
	          +"&superviseId="+superviseId+"&awakeDate="+awakeDate+"&superviseTitle="+encodeURIat(superviseTitle)
	          +"&supervisors="+encodeURIComponent(supervisors)+"&supervisorsId="+supervisorsId+"&role="+role
	          +"&isTemplate="+isTemplate+"&unCancelledVisor="+unCancelledVisor+"&templateDateTerminal="+templateDateTerminal+"&hasLoad="+hasLoad+"&startMemberId="+startMemberId,
	          
	     width: 400,
	     height: 300,
	     title: "${ctp:i18n('collaboration.common.flag.showSuperviseSetting')}",  //督办设置
	     buttons: [{
	         text: "${ctp:i18n('collaboration.pushMessageToMembers.confirm')}", //确定
	         handler: function () {
                var returnValue = dialog.getReturnValue();
            	if( returnValue && returnValue != null){//返回值到父页面
                	var map =  $.parseJSON(returnValue); 
					//防止第二次进入督办时，unCancelledVisor参数丢失
					$("#unCancelledVisor").val(map.unCancelledVisor);
               		$('#supervisorIds').val(map.supervisorIds);
               		$('#templateDateTerminal').val(map.templateDateTerminal);
               		$('#role').val(map.role);
               		$('#title').val(map.title.replace(/<br\s*\/?>/g,"\n"));
           			$('#awakeDate').val(map.awakeDate);
           			$('#supervisorNames').val(unescape(map.supervisorNames));
					if(map.isSubmit == 'true' && map.supervisorIds == ""){
						$('#title').val("");
               			$('#awakeDate').val("");
               			$('#supervisorNames').val("");
					}
					
               		$('#roleNames').val(map.roleNames);
               		$('#appKey').val(map.appKey);
               		$('#moduleId').val(map.entityId);

               		$("#isModifySupervise").val(1);
               		$("#hasLoad").val(1);
               		$('#detailId').val(map.detailId);
               		if(callBack){
                    	callBack(map);
                  	}
               		if(map.isSubmit === 'true'){
               		    $('#superviseDiv').jsonSubmit({
               		        action : _ctxPath+"/supervise/supervise.do?method=saveOrUpdateSupervise",
               		        callback:function(){
               		        }
                        });
               		}
               		dialog.close();
                }
	         }
	     }, {
	         text: "${ctp:i18n('collaboration.pushMessageToMembers.cancel')}", //取消
	         handler: function () {
	             dialog.close();
	         }
	     }]
	 });
}
/**
 * 督办
 */
function showSuperviseWindow(summaryId,app,finished, templeteId){
    var button = new Array();
    var dialogs = "";
    if(!finished){
        button.push({
            text: "${ctp:i18n('collaboration.updateCopntent.saveAndExit')}", //保存并退出
            handler: function () {
                var returnValue = dialogs.getReturnValue();
                if(returnValue != false){
                    var map =  $.parseJSON(returnValue); 
                    $('#awakeDate').val(map.awakeDate);
                    $('#detailId').val(map.superviseId);
                    //传递之前进行了转码，防止特殊字符 使JSON串出错，这里进行解码
                    var desc = decodeURIComponent(map.description);
                    $('#description').val(desc);
                    $('#superviseDiv').jsonSubmit({
                        action : _ctxPath+"/supervise/supervise.do?method=updateContentAndDate",
                        callback : function() { 
                        	//不需要刷新，如果添加刷新会导致首页栏目报错
                            if(parent && parent.$("#superviseList")[0]){
                            	parent.$("#superviseList").ajaxgridLoad();
                            }
                        }
                    });
                    dialogs.close();
                }
            }
        });
        button.push({
            text: "${ctp:i18n('collaboration.pushMessageToMembers.cancel')}", //取消
            handler: function () {
                dialogs.close();
            }
        });
    }else{
        button.push({
            text: "${ctp:i18n('common.button.close.label')}", //关闭
            handler: function () {
                dialogs.close();
            }
        });
    }
    
    dialogs = $.dialog({
        targetWindow:getCtpTop(),
        title: "${ctp:i18n('collaboration.common.flag.showSupervise')}",  //督办
        url: _ctxPath+'/supervise/supervise.do?method=superviseDialog&summaryId='+summaryId+"&appKey="+app+"&finished="+finished,
        width: 500,
        height: 350,
        buttons: button
    });
}
</script>
<div id="superviseDiv">
		<!--放置督办的信息区域开始  detailId 提醒日期  督办主题  督办人员IDs 督办人员names 督办角色  督办角色names-->
		<%--督办设置需要保持的5个属性 --%>
		<input type="hidden" name="detailId" id="detailId" value="${empty _SSVO ? '' : _SSVO.detailId}" />
		<input type="hidden" name="supervisorIds" id="supervisorIds" value="${empty _SSVO ? '' : _SSVO.supervisorIds}" />
		<input type="hidden" name="supervisorNames" id="supervisorNames" value="${empty _SSVO ? '' : _SSVO.supervisorNames}" />
		<input type="hidden" name="awakeDate" id="awakeDate" value="${empty _SSVO ? '' : _SSVO.awakeDate}" />
		<input type="hidden" name="title" id="title" value="${empty _SSVO ? '' : ctp:toHTMLAlt(_SSVO.title)}" />
		
		<input type="hidden" name="unCancelledVisor" id="unCancelledVisor" value="${empty _SSVO ? '' : _SSVO.unCancelledVisor}">
		
		<input type="hidden" name="role" id="role" value="${empty _SSVO ? '' : _SSVO.role}">
		<input type="hidden" name="templateDateTerminal" id="templateDateTerminal" value="${empty _SSVO ? '' : _SSVO.templateDateTerminal}" />
		
		
		
		<%--立即提交需要的两个属性 --%>
		<input type="hidden" name="superviseType" id="superviseType" value="" />		<!-- 应用类型 -->
		<input type="hidden" name="moduleId" id="moduleId" value="" />	<!-- 应用id -->
		
		
		
		<!-- 督办摘要 -->
        <input type="hidden" name="description" id="description" value="" />
        
        
        
        <input type="hidden" name="isModifySupervise"  id="isModifySupervise" value="0">
        <input type="hidden" name="hasLoad" id="hasLoad" value="${empty _SSVO ? 0 : 1}">
		<!-- 放置督办的信息区域结束 -->
</div>