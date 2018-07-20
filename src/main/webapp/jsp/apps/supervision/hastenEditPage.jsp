<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="pragma" contect="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/supervision/css/supervisionEditPage.css${v3x:resSuffix()}" />">
<script type="text/javascript" src="${path}/apps_res/supervision/js/supervisionPage.js"></script>
<script type="text/javascript" src="${path}/apps_res/supervision/js/dialog.js"></script>
<title>催办</title>
<style type="text/css">
	.xl-content-table td{
		height:65px;
		vertical-align: top;
	}
	.xl-content-table .xl_h_30 td{
		height:30px;
	}
</style>
</head>

<body>
<form id="subTableForm" class="align_center">
	<input type="hidden" id="masterDataId" name="masterDataId" value="${masterDataId }"/>
	<input type="hidden" id="field0032" name="field0032"/>
	<input type="hidden" id="assistant_unit" name="assistant_unit" value="${assistant_unit }"/>
	<input type="hidden" id="pesponsible_unit" name="pesponsible_unit" value="${pesponsible_unit }"/>
	<div class="xl-container xl-urge-container">

	    <div align="right" class="xl-urge-paper">
	        <b></b>
	        <a onclick="javascript:sendHasten()">
	            拟发催办单
	        </a>
	    </div>
	    <table class="xl-content-table">
        <colgroup>
            <col width="120px"/>
            <col width="80px"/>
            <col width="70px"/>
            <col width="120px"/>
            <col width="90px"/>
        </colgroup>
        <tbody>
        	<tr style="text-align:left;display:none;" id="errorTr">
        		<td></td>
        		<td colspan="4" id="errorMsg">
        			<ul><li><img src="${path}/apps_res/supervision/img/error.png"></li></ul>
        		</td>
        	</tr>
            <tr>
                <td align="right">
                    <div>
                        <label>接收单位：</label>
                    </div>
                </td>
                <td colspan="4">
                    <div style="text-align: left">
                        <textarea type="text" validate="name:'接收单位',type:'string',china3char:true,notNull:true" class="xl-urge-units validate" id="field0036_txt" unselectable="on" name="field0036_txt" >${organize}</textarea>
	            		<input type="hidden" id="field0036" name="field0036" value="${field0036 }">
                    </div>
                </td>
            </tr>
                <td align="right">
                    <div>
                        <label>提醒内容：</label>
                    </div>
                </td>
                <td colspan="4">
                    <div style="text-align: left">
                        <textarea name="field0033" class="xl-urge-word validate" validate="name:'提醒内容',china3char:true,maxLength:4000,notNullWithoutTrim:true" id="field0033" ></textarea>
                    </div>
                </td>
            </tr>
            <tr class="xl_h_30">
                <td colspan="3"></td>
				<td>
					<div>
						<input type="button" value="取消" class="xl_btn_cancel"
							onclick="_closeWin()" />
					</div>
				</td>
				<td align="right">
					<div>
						<input type="button" value="发送" class="xl_btn"
							onclick="send()" />
					</div>
				</td>
            </tr>
        </tbody>
    </table>

	</div>
</form>
</body>
<script type="text/javascript">
$("#field0036_txt").bind('click',function(){
	var values = $("#field0036").val();
	var txt = $("#field0036_txt").val();
	$.selectPeople({
        type:'selectPeople'
       	,panels:'Account,Department,OrgTeam,ExchangeAccount'
	   	,selectType:'Account,Department,OrgTeam,ExchangeAccount'
        ,text:$.i18n('common.default.selectPeople.value')
        ,hiddenPostOfDepartment:true
        ,hiddenRoleOfDepartment:true
        ,showFlowTypeRadio:false
        ,returnValueNeedType: false
        ,targetWindow:getCtpTop()
        ,returnValueNeedType:true
        ,params : {
	    	text : txt,
	        value : values
	    }
        ,callback : function(res){
	        	if(res && res.obj && res.obj.length>0){
		        	//需要在选择单位后判断是否为责任/协办单位
		        	var assistant_unit = $("#assistant_unit").val();
		        	var pesponsible_unit = $("#pesponsible_unit").val();
		        	var arr = res.value.split(",");
		        	var arrName = res.text.split("、");
		        	var onselectUnit = "";
		        	for(var i = 0 ;i<arr.length;){
						//if(assistant_unit.indexOf(arr[i]) == -1 && pesponsible_unit.indexOf(arr[i]) == -1){
						  if(pesponsible_unit.indexOf(arr[i]) == -1){
							if(onselectUnit.length > 0){
								onselectUnit = onselectUnit+"、";
							}
							onselectUnit = onselectUnit+arrName[i];
							arr.splice(i, 1);
							arrName.splice(i, 1);
							continue;
						}
						i++;
			        }
			        if(onselectUnit.length > 0){
						//dbAlert('"'+onselectUnit+'"既不是责任单位也不是协办单位，请重新选择',parent);
			        	dbAlert('"'+onselectUnit+'"不是责任单位，请重新选择',parent);
			        }
			        var unit=arr.join(",");//查询选择责任单位的承办人
		        	var supManager = new supervisionManager();
		            var takerIdAndNames=supManager.findUndertakerByUnit(unit);
		            if(takerIdAndNames!='' && takerIdAndNames!=null){
		        	    var takerObj=eval(takerIdAndNames);
		        	    if(takerObj!=null && takerObj.valueIds!='undefined'){
		        	    	$("#field0032").val(takerObj.valueIds);
		        	    }
		            }
	                $("#field0036").val(unit);
	                $("#field0036_txt").val(arrName.join("、"));
	            }
	        }
	    });
});
//提交提醒信息
function send(){
	//表单提交
	var formobj = $("#subTableForm");
	if(!formobj.validate({errorBg:true,errorIcon:true})){
		validatamsg(formobj);
		return;
	}
	//提醒记录
	var url = "${path}/supervision/supervisionController.do?method=saveSubTables&masterDataId=${masterDataId}&tableName=remind&tag="
			+ (new Date()).getTime();
	formobj.jsonSubmit({
		action : url,
		debug : false,
		validate : false,
		ajax : true,
		callback : function(objs) {
			var success=eval('('+objs+')').success;
			if(success=='true'){
				sendsuccess("催办成功");
				_closeWin('hasten');
			}else{
				dbAlert("催办失败，请与管理员联系！",parent);
			}
		}
	});
}

function sendHasten(){
	var supManager = new supervisionManager();
	var value = supManager.getTemplateBySupervise("hasten");
	if(typeof(value)=='undefined' || value==""){
		dbAlert("无法获取催办单，请联系表单管理员！",parent);
		return;
	}
	var templateId=value.templateId;
	if(templateId==""){
		dbAlert("无法获取催办单，请联系表单管理员！",parent);
		return;
	}
	var relationField=value.relationField;
	if(typeof(relationField)=='undefined' || relationField==''){
		relationField='';
	}
	var url="${path}/collaboration/collaboration.do?method=newColl&relationField="+relationField+"&templateId="+templateId+"&from=templateNewColl&supType=0&operType=hasten&masterDataId=${masterDataId}";
	var app=value.app;
	var sub_app=value.sub_app;
	if(value.app!="" && value.sub_app!=""){
		url+="&contentDataId=&contentTemplateId=&oldSummaryId=&distributeAffairId=&app="+app+"&sub_app="+sub_app+"&forwardText=&forwardAffairId=&isFenbanFlag=false&curSummaryID=";
	} 
	openCtpWindow({"url":url});
}
$(function(){
	var unit=$("#field0036").val();
	if(unit==''){
		return;
	}
	var supManager = new supervisionManager();
    var takerIdAndNames=supManager.findUndertakerByUnit(unit);
    if(takerIdAndNames!='' && takerIdAndNames!=null){
	    var takerObj=eval(takerIdAndNames);
	    if(takerObj!=null && takerObj.valueIds!='undefined'){
	    	$("#field0032").val(takerObj.valueIds);
	    }
    }
})
</script>
</html>