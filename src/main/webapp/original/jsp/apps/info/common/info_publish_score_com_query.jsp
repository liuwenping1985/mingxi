<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/info_header.jsp"%>
<!DOCTYPE html>
<html>
    <head> 
    <title>${ctp:i18n("infosend.listInfo.combinedQuery")}</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <script type="text/javascript">
   		listType = '${param.listType}';
   		var categoryNameDialog;
   		
        function OK() {
            var o = new Object();
            o.subject = $('#subject').val();
            o.categoryId = $('#categoryId').val();
            o.reportUnitId = $('#reportUnitId').val();
            o.reportDeptId = $('#reportDeptId').val();
            o.listType = listType;
            o.condition = "condition";
            
            var fromDate = "";
            var toDate = "";

          	//发布时间
            fromDate = $('#from_reportDate').val();
            toDate = $('#to_reportDate').val();
            if(fromDate != "" && toDate != "" && fromDate > toDate) {
                $.alert($.i18n('infosend.magazine.alert.fromTimeToEnd', $.i18n('infosend.listInfo.reportTime')));//上报时间的开始时间不能大于结束时间
                return;
            }
            if(fromDate !="" || toDate!="") {
            	date = fromDate+'#'+toDate;
                o.reportDate = date;
            }
            
          	//发布时间
            fromDate = $('#from_publishTime').val();
            toDate = $('#to_publishTime').val();
            if(fromDate != "" && toDate != "" && fromDate > toDate){
                $.alert($.i18n('infosend.magazine.alert.fromTimeToEnd', $.i18n('infosend.listInfo.score.publishTime')));//发布时间的开始时间不能大于结束时间
                return;
            }
            if(fromDate !="" || toDate!="") {
            	date = fromDate+'#'+toDate;
                o.publishTime = date;
            }
            window.dialogArguments[0].loadFormData(o);
            colseQuery();
        }

        function colseQuery() {
            try{
                var dialogTemp=window.parentDialogObj['queryDialog'];
                dialogTemp.close();
            }catch(e){}
        }
        
        function loadClick() {
        	$("#reportUnit").click(function() {
        		var pIds = $("#reportUnitId").val();
        		$.selectPeople({
    		        type:'selectPeople'
    		        ,panels:'Account'
    		        ,selectType:'Account'
    		        ,text:$.i18n('common.default.selectPeople.value')
    		        ,hiddenPostOfDepartment:true
    		        ,hiddenRoleOfDepartment:true
    		        ,showFlowTypeRadio:false
    		        ,returnValueNeedType: false
    		        ,params:{
    		           value:pIds
    		        }
    		        ,targetWindow:getCtpTop()
    		        ,callback : function(res){
    		        	if(res && res.obj && res.obj.length>0) {
    						if(res.value.length > 0){
    							var zgrArr = res.value.split(",");
    							var zddr ="";
    							if(zgrArr.length > 0){
    								for(var co = 0 ; co<res.obj.length ; co ++){
    									zddr += res.obj[co].type+"|" + res.obj[co].id+",";
    								}
    								if(zddr.length > 0){
    									pIds = zddr.substring(0, zddr.length - 1);
    								}
    							}
    						}
    						$("#reportUnit").val(res.text);
    						$("#reportUnitId").val(pIds);
    		            }    		        	
    		        }
    		    });
        	});
        	
        	$("#reportDept").click(function() {
        		var pIds = $("#reportDeptId").val();
        		$.selectPeople({
    		        type:'selectPeople'
    		        ,panels:'Department'
    		        ,selectType:'Department'
    		        ,text:$.i18n('common.default.selectPeople.value')
    		        ,hiddenPostOfDepartment:true
    		        ,hiddenRoleOfDepartment:true
    		        ,showFlowTypeRadio:false
    		        ,returnValueNeedType: false
    		        ,params:{
    		           value:pIds
    		        }
    		        ,targetWindow:getCtpTop()
    		        ,callback : function(res){
    		        	if(res && res.obj && res.obj.length>0) {
    						if(res.value.length > 0){
    							var zgrArr = res.value.split(",");
    							var zddr ="";
    							if(zgrArr.length > 0){
    								for(var co = 0 ; co<res.obj.length ; co ++){
    									zddr += res.obj[co].type+"|" + res.obj[co].id+",";
    								}
    								if(zddr.length > 0){
    									pIds = zddr.substring(0, zddr.length - 1);
    								}
    							}
    						}
    						$("#reportDept").val(res.text);
    						$("#reportDeptId").val(pIds);
    		            }    		        	
    		        }
    		    });
        		
        	});
        	
        	
        	$("#categoryName").click(function(){
        		categoryNameDialog = $.dialog({
       		        url: _ctxPath+"/info/infoStat.do?method=listInfoCategoryView",
       		        width: "250",
       		        height: "300",
       		       	title: $.i18n('infosend.label.stat.infoTypeSelect'),//信息类型选择
       		        id:'categoryNameDialog',
       		        transParams:[window],
       		        targetWindow:getCtpTop(),
       		        closeParam:{
       		            show:true,
       		            autoClose:false,
       		            handler:function(){
       		            	categoryNameDialog.close();
       		            }
       		        },
       		        buttons: [{
       		            id : "okButton",
       		            btnType : 1,//按钮样式
       		            text: $.i18n("common.button.ok.label"),
       		            handler: function () {
       		            	var infoCategory = categoryNameDialog.getReturnValue();
       		            	$("#categoryName").val(infoCategory.auditerName);
       		            	$("#categoryId").val(infoCategory.auditerId);
       		            	if(categoryNameDialog) {
       		            		categoryNameDialog.close();
       		            	}
       		            }
       		        }, {
       		            id:"cancelButton",
       		            text: $.i18n("common.button.cancel.label"),
       		            handler: function () {
       		            	categoryNameDialog.close();
       		            }
       		        }]
       		    });
        	});
        }
        
        $(document).ready(function () {
        	loadClick();
        	if(!isGroup) {
        		$("#reportUnitTd").html($.i18n(unitView)+"：");
        		$("#reportUnitId").val("Account|"+$.ctx.CurrentUser.loginAccount);
         		$("#reportUnit").val($.ctx.CurrentUser.loginAccountName);
         		$("#reportUnit").unbind("click");
        	}
        });
        
    </script>
    </head>
    <body class="h100b over_hidden">
        <div class="form_area" id="combinedQueryDIV">
            <form style="height: 100%;" name="addQuery" id="addQuery" method="post" class="align_center">
                <table  style="height: 100%;width:98%;" border="0" cellSpacing="10" cellPadding="10">
                    <tr>
                        <td align="right" nowrap="nowrap" width="15%">${ctp:i18n("infosend.listInfo.subject")}：</td>
                        <td width="35%" align="left"><input id="subject" class="w100b" type="text" name="subject"/></td>
                        <td align="right" nowrap="nowrap" width="15%">${ctp:i18n("infosend.listInfo.category")}：</td>
                        <td width="35%"align="left"><input id="categoryName" class="w100b" readonly="readonly" type="text"  name="categoryName"/><input id="categoryId" class="hidden"  type="text"  name="categoryId"/></td>
                    </tr>
                    <tr>
                        <td align="right" nowrap="nowrap" id="reportUnitTd">${ctp:i18n("infosend.listInfo.reportUnit")}：</td>
                        <td align="left"><input id="reportUnit" class="w100b" type="text" readonly="readonly" name="reportUnit"/><input id="reportUnitId" class="hidden" type="text" name="reportUnitId"/></td>
                        <td align="right" nowrap="nowrap">${ctp:i18n("infosend.listInfo.reportDept")}：</td>
                        <td align="left"><input id="reportDept" class="w100b" type="text" readonly="readonly" name="reportDept"/><input id="reportDeptId" class="hidden" type="text" name="reportDeptId"/></td>
                    </tr>
                    
                    <tr>
                        <td align="right" nowrap="nowrap" width="15%"><!-- 上报时间 -->${ctp:i18n('infosend.listInfo.reportTime')}：</td>
                        <td align="left" nowrap="nowrap" colspan="3" width="85%">
                            <input id="from_reportDate" class="comp" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[240,10]" readonly>
                            <span style="width:10%" class="padding_lr_20">-</span>
                            <input id="to_reportDate" class="comp" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[120,10]" readonly>
                        </td>
                    </tr>

                    <tr>
                        <td align="right" nowrap="nowrap" width="15%"><!-- 发布时间 -->${ctp:i18n('infosend.listInfo.score.publishTime')}：</td>
                        <td align="left" nowrap="nowrap" colspan="3" width="85%">
                            <input id="from_publishTime" class="comp" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[240,10]" readonly>
                            <span style="width:10%" class="padding_lr_20">-</span>
                            <input id="to_publishTime" class="comp" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[120,10]" readonly>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
    </body> 
</html>