//<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
var _dealCustom="custom";
$(function(){
    window.setTimeout(function(){
        var customOption = '<option value="'+_dealCustom+'">${ctp:i18n("workflow.designer.node.customDealterm")}</option>';
	    $(customOption).insertAfter($("#dealTerm option[value=0]"));
    }, 300);
});
function formatDate(date){
    var year, month, day, hour, minute;
    if(date!=null){
        year = date.getFullYear();
        month = date.getMonth()+1;
        if(month<10){
            month = "0"+month;
        }
        day = date.getDate();
        if(day<10){
            day = "0"+day;
        }
        hour = date.getHours();
        if(hour<10){
            hour = "0"+hour;
        }
        minute = date.getMinutes();
        if(minute<10){
            minute = "0"+minute;
        }
        return year+"-"+month+"-"+day+" "+hour+":"+minute;
    }
    return "";
}
var workflowAddNodeMessage = {};
var existNotOnlyMember = true;
var hasSelectedPeople= false;
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
$("#policySelect").change(function(){
	policyChange($(this).val());
});
//new inputChange($("#select_people"),"单击选择人员");
$("#collSelectPeopleInput").click(function (){
	var selectValues = "", selectTexts = "";
	if(workflowAddNodeMessage){
		var tempTypeArray = workflowAddNodeMessage.userType, tempIdArray = workflowAddNodeMessage.userId, tempNameArray = workflowAddNodeMessage.userName;
		if(tempTypeArray!=null && tempIdArray!=null){
			var tempArray = [], tempArray1 = [];
			for(var i=0,len=tempTypeArray.length; i<len; i++){
				tempArray.push(tempTypeArray[i]+"|"+tempIdArray[i]);
				tempArray1.push(tempNameArray[i]);
			}
			selectValues = tempArray.join(","), selectTexts = tempArray1.join(",");
		}
	}
    var wfAjax= new WFAjax();
    var accountExcludeElements= wfAjax.getAcountExcludeElements();
    var excludeElements= parseElements(accountExcludeElements[0]);
	var paramObj = {
        type:'selectPeople'
        ,text:"${ctp:i18n('workflow.insertPeople.urgerAlt')}"
        ,showFlowTypeRadio: false
        ,isConfirmExcludeSubDepartment:true
        ,unallowedSelectEmptyGroup:true
        ,minSize:1
        ,excludeElements:excludeElements
        ,params : {
            text : selectTexts,
            value : selectValues
	    }
        ,targetWindow:getCtpTop()
        ,callback : function(res){
            //showFlowTypeRadio: true，需要显示串行、并行、会签等选项
            //res有三个属性obj(选人结果Array,size=3）、text（选的人名，顿号分隔，String）、value（选的人类型|Id，顿号分隔）
            //obj[0]表示选人结果Array，obj[1]表示flowType1穿行、2并行、3会签，obj[2]表示是否显示单位简称。
            //showFlowTypeRadio: false，需要显示串行、并行、会签等选项
            //res有三个属性obj（选人结果Array）、text（选的人名，顿号分隔，String）、value（选的人类型|Id，顿号分隔）
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
                hasSelectedPeople= true;
                if(flag){
                    existNotOnlyMember = true;
                }else{
                    existNotOnlyMember = false;
                }
                policyChange($("#policySelect").val());
            } else {
                hasSelectedPeople= false
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
function dateFormat(format){
    var current = new Date();
    var o = { 
    "M+" : current.getMonth()+1, //month 
    "d+" : current.getDate(), //day 
    "h+" : current.getHours(), //hour 
    "m+" : current.getMinutes(), //minute 
    "s+" : current.getSeconds(), //second 
    "q+" : Math.floor((current.getMonth()+3)/3), //quarter 
    "S" : current.getMilliseconds() //millisecond 
    } 
    
    if(/(y+)/.test(format)) { 
       format = format.replace(RegExp.$1, (current.getFullYear()+"").substr(4 - RegExp.$1.length)); 
    } 
    
    for(var k in o) { 
       if(new RegExp("("+ k +")").test(format)) { 
           format = format.replace(RegExp.$1, RegExp.$1.length==1 ? o[k] : ("00"+ o[k]).substr((""+ o[k]).length)); 
       } 
    } 
    return format; 
}
$("#dealTerm").change(function(){
	var dealTerm = $(this).val();
    if(dealTerm==_dealCustom){
        $("#customDealTerm").val(dateFormat("yyyy-MM-dd hh:mm"));
        $("#dealTermCustomArea").show();
        if(dialogArguments.dialogObj){
            dialogArguments.dialogObj.dialog.reSize({height:280});
        }
    }else{
        $("#dealTermCustomArea").hide();
       
       
    }
    if(dealTerm!="0"){
		var remindTime = $("#remindTime").val();
	    var remind = Number(remindTime);
	    if(dealTerm==_dealCustom){
	        var nowTime = new Date().getTime();
	        var dealTerm = $("#customDealTerm").attr("value");
	        var temp = /(\d\d\d\d)-(\d\d)-(\d\d) (\d\d):(\d\d)/g.exec(dealTerm);
	        var dealline = new Date();
	        dealline.setFullYear(parseInt(temp[1], 10));
            dealline.setMonth(parseInt(temp[2], 10)-1);
            dealline.setDate(parseInt(temp[3], 10));
            dealline.setHours(parseInt(temp[4], 10));
            dealline.setMinutes(parseInt(temp[5], 10));
	        var shijiancha = dealline.getTime() - nowTime;
	        /*if(shijiancha<0 || shijiancha/1000/60<remind){
	            $.alert("${ctp:i18n('workflow.nodeProperty.remindTimeLessThanDealDeadLine')}");
	            $("#remindTime").get(0).selectedIndex=0;
	            return false;
	        }*/
	    }else{
	        var deal = Number(dealTerm);
	        if(deal <= remind){
	            $.alert("${ctp:i18n('workflow.nodeProperty.remindTimeLessThanDealDeadLine')}");
	            $("#remindTime").get(0).selectedIndex=0;
	            return false;
	        }
	    }
    }else{
        $("#remindTime").get(0).selectedIndex=0;
    }
});
$("#remindTime").change(function(){
	var dealTerm = $("#dealTerm").val();
	var remindTime = $("#remindTime").val();
    var remind = Number(remindTime);
	if(dealTerm==_dealCustom){
	    var nowTime = new Date().getTime();
	    var dealTerm = $("#customDealTerm").attr("value");
        var temp = /(\d\d\d\d)-(\d\d)-(\d\d) (\d\d):(\d\d)/g.exec(dealTerm);
        var dealline = new Date();
        dealline.setFullYear(parseInt(temp[1], 10));
        dealline.setMonth(parseInt(temp[2], 10)-1);
        dealline.setDate(parseInt(temp[3], 10));
        dealline.setHours(parseInt(temp[4], 10));
        dealline.setMinutes(parseInt(temp[5], 10));
        var shijiancha = dealline.getTime() - nowTime;
        if(shijiancha<0 || shijiancha/1000/60<remind){
            $.alert("${ctp:i18n('workflow.nodeProperty.remindTimeLessThanDealDeadLine')}");
            this.selectedIndex=0;
            return false;
        }
    }else{
        var deal = Number(dealTerm);
	    if(deal <= remind){
	        $.alert("${ctp:i18n('workflow.nodeProperty.remindTimeLessThanDealDeadLine')}");
	        this.selectedIndex=0;
	        return false;
	    }
    }
});
function OK(){
	<%--处理期限和提前提醒时间--%>
	var dealTerm = $("#dealTerm").val();
	var remindTime = $("#remindTime").val();
	if(dealTerm==_dealCustom){
        var nowTime = new Date().getTime();
        var dealTerm = $("#customDealTerm").attr("value");
        var temp = /(\d\d\d\d)-(\d\d)-(\d\d) (\d\d):(\d\d)/g.exec(dealTerm);
        var dealline = new Date();
        dealline.setFullYear(parseInt(temp[1], 10));
        dealline.setMonth(parseInt(temp[2], 10)-1);
        dealline.setDate(parseInt(temp[3], 10));
        dealline.setHours(parseInt(temp[4], 10));
        dealline.setMinutes(parseInt(temp[5], 10));
        var shijiancha = dealline.getTime() - nowTime;
        if(shijiancha<0 || shijiancha/1000/60<remind){
            $.alert("${ctp:i18n('workflow.nodeProperty.remindTimeLessThanNow')}");
            $("#remindTime").get(0).selectedIndex=0;
            return false;
        }
    }else{
		var deal = Number(dealTerm);
	    var remind = Number(remindTime);
	    if(deal <= remind && (deal!=0 && remind!=0)){
	        $.alert("${ctp:i18n('workflow.nodeProperty.remindTimeLessThanDealDeadLine')}");
	        $("#remindTime").get(0).selectedIndex=0;
	        return;
	    }
    }
	if(!MxtCheckForm($("body"),{errorAlert:true})){
        return;
    }
    workflowAddNodeMessage.dealTerm = dealTerm;
    workflowAddNodeMessage.remindTime = remindTime;
    workflowAddNodeMessage.policyId = $("#policySelect").attr("value");
    workflowAddNodeMessage.policyName = $("#policySelect").find("option:selected").text();
    workflowAddNodeMessage.flowType = $("input[name=process_mode]:checked").val();
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
    <c:if test="${param.isForm eq true}">
    var formOperationPolicy = '0';
    if($("#formOperationPolicy2").prop("checked")){
    	formOperationPolicy = "1";
    }
    workflowAddNodeMessage.formOperationPolicy = formOperationPolicy;
    </c:if>
    <c:if test="${param.isForm ne true}">workflowAddNodeMessage.formOperationPolicy = '0';</c:if>
    return $.toJSON(workflowAddNodeMessage);
}
function policyChange(poli){
    if(poli == "inform" || poli =="zhihui"){
        $("#processMode_parallel").prop("checked", true);
        $("#nodeProcessMode").addClass("hidden");
        $("#all_mode").prop("checked", true);
        var formPolicy1 = $("#formOperationPolicy1");
        if(formPolicy1.length>0){
            formPolicy1.prop("checked", false);
            formPolicy1.attr("disabled","disabled");
        }
        formPolicy1 = null
        var formPolicy2 = $("#formOperationPolicy2");
        if(formPolicy2.length>0){
        	formPolicy2.prop("checked", true);
        }
        formPolicy2 = null;
    }else{
		var formPolicy1 = $("#formOperationPolicy1");
        if(formPolicy1.length>0){
            formPolicy1.removeAttr("disabled");
        }
        formPolicy1 = null;
        if(existNotOnlyMember){
            if(hasSelectedPeople){
                $("#nodeProcessMode").removeClass("hidden");
            }else{
                $("#nodeProcessMode").addClass("hidden");
            }
            $("#processMode_serial").prop("disabled", false);
            $("#processMode_nextparallel").prop("disabled", false);
            <c:if test="${param.isForm eq true}">
                <c:if test="${isFormReadonly eq true}">
                $("#formOperationPolicy2").prop("checked", true);
                </c:if>
            </c:if>
            /*var formPolicy1 = $("#formOperationPolicy1");
            if(formPolicy1.length>0){
                formPolicy1.removeAttr("disabled");
                formPolicy1.prop("checked", true);
            }
            formPolicy1 = null;
            var formPolicy2 = $("#formOperationPolicy2");
            if(formPolicy2.length>0){
                formPolicy2.prop("checked", false);
                <c:if test="${param.isForm eq true}">
                    <c:if test="${isFormReadonly eq true}">
                    formPolicy2.prop("checked", true);
                    </c:if>
                </c:if>
            }
            formPolicy2 = null;*/
        }else{
            $("#processMode_serial").prop("disabled", false);
            $("#processMode_nextparallel").prop("disabled", false);
            $("#nodeProcessMode").addClass("hidden");
            <c:if test="${param.isForm eq true}">
                <c:if test="${isFormReadonly eq true}">
                $("#formOperationPolicy2").prop("checked", true);
                </c:if>
            </c:if>
            /*var formPolicy1 = $("#formOperationPolicy1");
            if(formPolicy1.length>0){
                formPolicy1.removeAttr("disabled");
                formPolicy1.prop("checked", true);
            }
            formPolicy1 = null;
            var formPolicy2 = $("#formOperationPolicy2");
            if(formPolicy2.length>0){
                formPolicy2.prop("checked", false);
                <c:if test="${param.isForm eq true}">
                    <c:if test="${isFormReadonly eq true}">
                    formPolicy2.prop("checked", true);
                    </c:if>
                </c:if>
            }
            formPolicy2 = null;*/
        }
    }
}
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
        targetWindow: getCtpTop()
    });
}