<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="h100b">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="pragma" contect="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<title>分解事项</title>
<c:set var="path" value="${pageContext.request.contextPath}" />
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/supervision/css/supervisionEditPage.css${v3x:resSuffix()}" />">
<script type="text/javascript" src="${path}/apps_res/supervision/js/supervisionPage.js"></script>
</head>
<body>
	
	<form id="subTableForm" class="align_center">
	<input type="hidden" id="completeDate" value="${param.completeDate}"/>
	<div class="xl-container xl-break-container" >
    <!--取消按钮样式-->
    <p  style="text-align:left">
        <span>分解</span>
        <span onclick="_closeWin('${masterDataId}')" class="xl-cancel dialog_close">×</span>
    </p>
    <table class="xl-content-table">
        <colgroup>
            <col width="100px"/>
            <col width="140px"/>
            <col width="20px"/>
            <col width="100px"/>
            <col width="240px"/>
        </colgroup>
        <tbody>
        	<tr style="text-align:left;display:none;" id="errorTr">
        		<td></td>
        		<td colspan="4" id="errorMsg">
        			<ul></ul>
        		</td>
        	</tr>
            <tr>
                <td align="right">
                    <div>
                        <label>事项名称：</label>
                    </div>
                </td>
                <td colspan="4">
                    <div>
                        <textarea validate="name:'事项名称',type:'string',china3char:true,maxLength:4000,notNull:true" type="text" class="xl-th-name validate" name="field0052" id="field0052"></textarea>
                    </div>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <div>
                        <label>完成时限：</label>
                    </div>
                </td>
                <td class="">
                    <div class="">
                    	<input id="field0059" class="xl-finished-date comp validate" validate="name:'完成时限',notNull:true" type="text" style="min-height:28px;" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false" readonly>
                    </div>
                    <span></span>
                </td>
                <td></td>
                <td align="right">
                    <div>
                        <label>责任人：</label>
                    </div>
                </td>
                <td>
                    <div class="inlineDiv">
                        <textarea validate="name:'责任人',type:'string',china3char:true,notNull:false" type="text" name=field0054_txt id="field0054_txt" class="xl-duty-person validate"></textarea>
                		<input name=field0054 id="field0054" style="width:138px;" type="hidden" value="">
                    </div>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <div>
                        <label>紧急程度：</label>
                    </div>
                </td>
                <td>
                    <div>
                        <select class="xl-quick"  id="field0120" name="field0120">
                            <option value=""></option>
                            <c:forEach items="${enumItemList}" var="enumItem">
								<option value="${enumItem.id}" enumvalue="${enumItem.enumvalue}" showText="${enumItem.showvalue}">${enumItem.showvalue}</option>
							</c:forEach>
                        </select>
                    </div>
                </td>
                <td></td>
                <td align="right">
                    <div>
                        <label>责任人电话：</label>
                    </div>
                </td>
                <td>
                    <div class="inlineDiv">
                        <textarea type="text" name="field0119" id="field0119" class="xl-duty-phone"></textarea>
                    </div>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <div>
                        <label>责任单位：</label>
                    </div>
                </td>
                <td colspan="4">
                    <div>
                        <textarea validate="name:'责任单位',type:'string',china3char:true,notNull:true" type="text" id="field0053_txt" name="field0053_txt" class="xl-duty-units validate"></textarea>
                        <input type="hidden" id="field0053" name="field0053">
                    </div>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <div>
                        <label>承办人：</label>
                    </div>
                </td>
                <td colspan="4">
                    <div>
                        <textarea type="text" id="field0148_txt" name="field0148_txt" class="xl-duty-units" readonly="readonly"></textarea>
                        <input type="hidden" id="field0148" name="field0148">
                    </div>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <div>
                        <label>协办单位：</label>
                    </div>
                </td>
                <td colspan="4">
                    <div>
                    <textarea type="text" id="field0055_txt" name="field0055_txt" class="xl-help-units"></textarea>
                        <input id="field0055" name="field0055" type="hidden" class="xl-help-units"></input>
                    </div>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <div>
                        <label>督办要求：</label>
                    </div>
                </td>
                <td colspan="4">
                    <div>
                        <textarea validate="name:'督办要求',type:'string',china3char:true,maxLength:4000,notNull:false" id="field0057" name="field0057" class="xl-demand validate"></textarea>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="4"></td>
                <td align="right">
                    <div>
	                    <input type="button" value="取消" onclick="_closeWin('${masterDataId}')" class="xl_btn_cancel"/>
	                    <input type="button" value="保存" onclick="sendReq4AddOrDel()" class="xl_btn"/>
                    </div>
                </td>
            </tr>
            <input type="hidden" value="${CurrentUser.id}" id="field0123" name="field0123"/>
            <input type="hidden" value="${CurrentUser.loginAccount}" id="field0122" name="field0122"/>
            <input type="hidden" value="${masterDataId}" id="field0147" name="field0147"/>
        </tbody>
    </table>
</div>
	</form>
</body>
<script type="text/javascript">
	var unitIds="";
	var personIds="";
	var helpUnitIds="";
	$("#field0054_txt").bind('click',function(){
		var values = $("#field0054").val();
		var memStr="";
		if(values!=''){
			var memberIds=values.split(",");
			for(var i  = 0 ; i < memberIds.length ; i ++){
	            memStr += "Member|"+memberIds[i]+","
	        }
	        if(memStr.length > 0){
	          	memStr = memStr.substring(0,memStr.length-1);
	        }
		}
		
   	 	$.selectPeople({
   	        type:'selectPeople'
   	        ,panels:'Department,Team,Post,Outworker,RelatePeople'
   	        ,selectType:'Member'
   	        ,text:$.i18n('common.default.selectPeople.value')
   	        ,hiddenPostOfDepartment:true
   	        ,hiddenRoleOfDepartment:true
   	        ,showFlowTypeRadio:false
   	        ,returnValueNeedType: false
   	        ,targetWindow:getCtpTop()
   	        ,params : {
			        value : memStr
			    }
   	 		,minSize:0
   	        ,callback : function(res){
   	        	if(res && res.obj && res.obj.length>0){
   	                $("#field0054").val(res.value);
   	                $("#field0054_txt").val(res.text);
   	                //TODO 增加已选人员参数
   	                $("#field0054_txt").css("background-color","#fff");
   	             	$("#field0054_txt").parent().removeClass("error-form");
   	            }else{
   	             	$("#field0054").val('');
	                $("#field0054_txt").val('');
   	            }
   	        }
   	    });
   });
	$("#field0053_txt").bind('click',function(){
		var values = $("#field0053").val();
		var txt = $("#field0053_txt").val();
	   	 $.selectPeople({
	   	        type:'selectPeople'
	   	        ,panels:'Account,Department,OrgTeam,ExchangeAccount'
	   	        ,selectType:'Account,Department,OrgTeam,ExchangeAccount'
	   	        ,text:$.i18n('common.default.selectPeople.value')
	   	        ,hiddenPostOfDepartment:true
	   	        ,hiddenRoleOfDepartment:true
	   	        ,showFlowTypeRadio:false
	   	        ,targetWindow:getCtpTop()
	   	        ,returnValueNeedType:true
	   	     	,params : {
			    	text : txt,
			        value : values
			    }
	   			,minSize:0
	   	        ,callback : function(res){
	   	        	if(res && res.obj && res.obj.length>0){
	   	        		$(this).css("background-color","#fff");
    	                $("#field0053").val(res.value);
    	                $("#field0053_txt").val(res.text);
    	            	var supManager = new supervisionManager();
    	                var takerIdAndNames=supManager.findUndertakerByUnit(res.value);
    	            	var takerObj=eval(takerIdAndNames);
    	                if(takerObj.valueIds!='undefined' && takerObj.valueIds!=''){
    	                	$("#field0148").val(takerObj.valueIds);
    	                }
    	                if(takerObj.valueNames!='undefined' && takerObj.valueNames!=''){
    	                	$("#field0148_txt").val(takerObj.valueNames);
    	                }
    	                if(takerObj.noMsg!='undefined' && takerObj.noMsg!=''){
    	                	alert($.i18n('supervision.newinfo.nosupervisemember',takerObj.noMsg));
    	                }
    	                $("#field0053_txt").parent().removeClass("error-form");
    	            }else{
    	            	$("#field0053").val('');
    	                $("#field0053_txt").val('');
    	                $("#field0148").val('');
	            		$("#field0148_txt").val('');
    	            }
	   	        }
	   	    });
	   });
	   $("#field0055_txt").bind('click',function(){
		     var values = $("#field0055").val();
			var txt = $("#field0055_txt").val();
		   	 $.selectPeople({
		   	        type:'selectPeople'
		   	        ,panels:'Account,Department,OrgTeam,ExchangeAccount'
		   	        ,selectType:'Account,Department,OrgTeam,ExchangeAccount'
		   	        ,text:$.i18n('common.default.selectPeople.value')
		   	        ,hiddenPostOfDepartment:true
		   	        ,hiddenRoleOfDepartment:true
		   	        ,showFlowTypeRadio:false
		   	        ,targetWindow:getCtpTop()
		   	        ,returnValueNeedType:true
		   	     	,params : {
				    	text : txt,
				        value : values
				    }
		   			,minSize:0
		   	        ,callback : function(res){
		   	        	if(res && res.obj && res.obj.length>0){
		   	        		$(this).css("background-color","#fff");
	    	                $("#field0055").val(res.value);
	    	                $("#field0055_txt").val(res.text);
	    	                //把error-form的class remove掉
	    	                $("#field0055_txt").parent().removeClass("error-form");
	    	            } else {
	    	            	$("#field0055").val('');
	    	                $("#field0055_txt").val('');
	    	            }
		   	        }
		   	    });
		   });
	//复制自form.js
	function sendReq4AddOrDel() {
		//表单提交
		var formobj = $("#subTableForm");
		var date = $("#field0059").val();
		var preDate = $("#completeDate").val();
		
		var currentDate=new Date().format("yyyy-MM-dd");
	    if(date!='' && date<currentDate){
			$.alert("事项的完成时限必须大于或等于当前时间！");
			return;
		}
		
		if(preDate!='' && date>preDate){
			 $.alert("完成时限不能晚于上级事项的完成时限！");
			 return;
		}
		
		//
		//模拟提醒记录
		var url = "${path}/supervision/supervisionController.do?method=saveSubTables&masterDataId=${masterDataId}&tableName=${tableName}&tag="
				+ (new Date()).getTime();
		if(!formobj.validate({errorBg:true,errorIcon:true})){
			validatamsg(formobj);
			return;
		}
		formobj.jsonSubmit({
			action : url,
			//domains : contentData,
			validate : false,
			ajax : true,
			callback : function(objs) {
				//alert("0000：" + objs);
				var returnObj = $.parseJSON(objs);
				var success=returnObj.success;
				if(success=='true'){
					alert("分解成功");
					_closeWin("${masterDataId}");
				}else{
					$("#errorTr").hide();
					var errorMessage = $.parseJSON(returnObj.errorMsg);
					if (errorMessage.ruleError) {
						$.alert({"msg":errorMessage.ruleError,"width":500,"height":150});
					}
				}
				//TODO 跳转页面到列表页面
			}
		});
	}
	$(function(){
		 //默认选中普通的紧急程度
		 $("#field0120").find("option[enumvalue='2']").attr("selected","selected");
	})
	
</script>
</html>