<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="<%=request.getContextPath() %>/common/workflow/workflowDesigner_ajax.js${ctp:resSuffix()}"></script>
<html class="h100b">
<head>
    <title>${ctp:i18n("workflow.assignNode.assign")}</title>
    <%@ include file="/WEB-INF/jsp/ctp/workflow/workflow_meta.jsp"%>
</head>
<body class="h100b">
    <div class="form_area padding_5">
        <table border="0" cellSpacing="0" cellPadding="0" width="100%">
          <tbody><tr>
            <th noWrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n("workflow.insertPeople.selectPolicy")}:</label></th>
            <td width="100%"><div class="common_txtbox_wrap">
                <input type="text" name="policy" value="${policy.name }" readonly="readonly" disabled="disabled">
            </div></td>
          <td nowrap="nowrap" rowspan="3" valign="top"><a href="javascript:void(0)" onclick="policyExplain()" class="display_inline-block margin_t_10">&nbsp;[${ctp:i18n("node.policy.explain")}]</a></td>
          </tr>
          <tr>
            <th noWrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n("workflow.insertPeople.selectPeople")}:</label></th>
            <td><div class="common_txtbox_wrap">
                <input id="collSelectPeopleInput" name="collSelectPeopleInput" readonly value="<${ctp:i18n('workflow.insertPeople.urgerAlt')}>" class="validate" validate="type:'string',notNull:true,isDeaultValue:true,deaultValue:'<${ctp:i18n('workflow.insertPeople.urgerAlt')}>'">
            </div></td>
          </tr>
          <tr id="nodeProcessMode" class="hidden">            
                <th noWrap="nowrap"><label class="margin_r_10" for="text">${ctp:i18n("node.process.mode")}:</label></th>
                <td><div class="common_radio_box clearfix">
                    <label for="all_mode">
                        <input type="radio" name="node_process_mode" id="all_mode" value="all" class="radio_com" checked="checked">
                        ${ctp:i18n("node.all.mode")}
                    </label>
                    <label for="competition_mode">  
                        <input type="radio" name="node_process_mode" id="competition_mode" class="radio_com" value="competition">
                        ${ctp:i18n("node.competition.mode")}
                    </label>
                </div></td>
            </tr>
          </tbody>
        </table>
    </div>
<div id="policyExplainHTML" class="hidden">
    <table width="100%" border="0" cellspacing="0" cellpadding="0"> 
        <tr>
            <td colspan="2">
                <div style="height: 28px;">
                    <textarea name="content" rows="9" cols="46" validate="maxLength"
                            inputName="${ctp:i18n('common.opinion.label')}" maxSize="2000" readonly></textarea>
                </div>  
            </td>
        </tr>   
    </table>
</div>
<script type="text/javascript">
    var policyId = "${policy.value}";
    var policyName = "${policy.name}";
    var workflowAddNodeMessage = {};
        /*userId : ["4630579832134913132", "-6493420559815389299", "7131934972243562177",
                   "6028847194429932531", "-1657488837711085297", "-7244364344719094459", "-1297144629726851564",
                   "7061746139192313360", "3186036664616176992"]
        ,userName : ["厂办代副总经理部门(不包含子部门)", "生产部部门", "x1", "x2", "x3", "x4", "x7", "x8", "x9"]
        ,userType : ["Department", "Department", "Member", "Member", "Member", "Member",
                   "Member", "Member", "Member" ]
        ,userExcludeChildDepartment : [ "true", "false", "false", "false", "false", "false",
                   "false", "false", "false" ]
        ,formOperationPolicy : "0"
        ,accountId : ["-8367475328145079113", "-8367475328145079113", "-8367475328145079113",
                   "-8367475328145079113", "-8367475328145079113", "-8367475328145079113", "-8367475328145079113",
                   "-8367475328145079113", "-8367475328145079113"]
        ,accountShortname : ["", "", "", "", "", "", "", "", "" ]
        ,policyId : "collaboration"
        ,policyName : "协同"
        ,isShowShortName : "false"
        ,node_process_mode : "all"
        ,flowType : "5"
        ,advanceRemind : null
        ,deadline : null
    };*/
    //new inputChange($("#select_people"),"单击选择人员");
    $("#collSelectPeopleInput").click(function (){
      var wfAjax= new WFAjax();
      var accountExcludeElements= wfAjax.getAcountExcludeElements();
      var excludeElements= parseElements(accountExcludeElements[0]);
    	var paramObj = {
            type:'selectPeople'
            ,text:"${ctp:i18n('workflow.insertPeople.urgerAlt')}"
            ,showFlowTypeRadio: false
            ,isConfirmExcludeSubDepartment:true
            ,unallowedSelectEmptyGroup:true
            ,excludeElements:excludeElements
            ,params:{
               value: ''
            }
            ,targetWindow:window.top
            ,callback : function(res){
                if(res && res.obj && res.obj.length>0){
                    var idArray = [], nameArray = [], typeArray = [], excludeChildArray = [], accountIdArray = [], accountNameArray = [];
                    var flag = false, peopleArray = res.obj;
                    for(var i=0, len=peopleArray.length; i<len; i++){
                        idArray.push(peopleArray[i].id);
                        nameArray.push(peopleArray[i].name);
                        typeArray.push(peopleArray[i].type);
                        excludeChildArray.push(peopleArray[i].excludeChildDepartment);
                        accountIdArray.push(peopleArray[i].accountId);
                        accountNameArray.push(peopleArray[i].accountShortname);
                        if(peopleArray[i].type!="Member"){
                            flag = true;
                        }
                    }
                    workflowAddNodeMessage.userId = idArray;
                    workflowAddNodeMessage.userName = nameArray;
                    workflowAddNodeMessage.userType = typeArray;
                    workflowAddNodeMessage.userExcludeChildDepartment = excludeChildArray;
                    workflowAddNodeMessage.accountId = accountIdArray;
                    workflowAddNodeMessage.accountShortname = accountNameArray;
                    $("#collSelectPeopleInput").val(res.text);
                    var processModeElement = $("#nodeProcessMode")
                    if(flag){
                        processModeElement.removeClass("hidden");
                    }else{
                        if(!processModeElement.hasClass("hidden")){
                            processModeElement.addClass("hidden");
                        }
                    }
                    processModeElement = null;
                } else {
                    $("#collSelectPeopleInput").val("<${ctp:i18n('workflow.insertPeople.urgerAlt')}>");
                }
            }
        }
        if("${appName}"=="collaboration" || "${appName}"=="form"){
	        paramObj.panels = 'Department,Team,Post,Outworker,RelatePeople'
	        paramObj.selectType = 'Account,Member,Department,Team,Post,Outworker,RelatePeople'
	    }else{
	        paramObj.panels = 'Department,Team,Post,RelatePeople'
	        paramObj.selectType = 'Account,Member,Department,Team,Post,RelatePeople'
	    }
        $.selectPeople(paramObj);
    })
    //权限说明
function policyExplain(){
   	var appName = "${param.appName}";
   	var url = "${path}/workflow/designer.do?method=policyExplain&type=";
   	if(appName == "govdocSend" || appName=="govdocRec" || appName=="govdocExchange"){
   		url=url+"1";
   	}else{
   		url=url+"2";
   	}
    var dialog = $.dialog({
        url : url,
        transParams : window,
        width : 295,
        height : 275,
        title : '${ctp:i18n("node.policy.explain")}',
        buttons : [
            {
                text : '${ctp:i18n("common.button.close.label") }',
                handler : function(){
                    dialog.transParams = null;
                    dialog.close();
            }}
        ],
        targetWindow: top
    });
}
    function OK(){
        if(!MxtCheckForm($("body"),{})){
            return;
        }
        var policyObj = $("#policySelect option:selected");
        workflowAddNodeMessage.policyId = policyId;
        workflowAddNodeMessage.policyName = policyName;
        workflowAddNodeMessage.flowType = '5';
        var modeArray = [], competionObj = $("#competition_mode"), allValue = $("#all_mode").val();
        if(competionObj.prop("checked")){
            var len = workflowAddNodeMessage.userType.length, competitionValue = competionObj.val();
            for(var i=0; i<len; i++){
                if(workflowAddNodeMessage.userType[i]!="Member"){
                    modeArray.push(competitionValue);
                }else{
                    modeArray.push(allValue);
                }
            }
        }else{
            var len = workflowAddNodeMessage.userType.length;
            for(var i=0; i<len; i++){
                modeArray.push(allValue);
            }
        }
        competionObj = null;
        workflowAddNodeMessage.node_process_mode = modeArray;
        <c:if test="${param.isForm eq true}">workflowAddNodeMessage.formOperationPolicy = '1';</c:if>
        <c:if test="${param.isForm ne true}">workflowAddNodeMessage.formOperationPolicy = '0';</c:if>
        policyObj = null;
        return $.toJSON(workflowAddNodeMessage);
    }
</script>
</body>
</html>