<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<!DOCTYPE html>
<html>
   <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>${ctp:i18n("collaboration.button.advancedQuery.js")}</title><!-- 高级查询 -->
    <head>
    <script type="text/javascript">
        var openForm ="${openForm}";
        $(document).ready(function () {
        	var obj = window.parentDialogObj["queryDialog"].transParams;
        	if (!$.isEmptyObject(obj)) {
        		if (obj.subject != "") {
        			$('#title').val(obj.subject);
        		}
        		if (obj.importantLevel != "") {
        			$('#importent').find("option[value='"+obj.importantLevel+"']").attr("selected",true);
        		}
        		if (obj.startMemberName != "") {
        			$('#spender').val(obj.startMemberName);
        		}
        		if (obj.isOverdue != "") {
        			 $("#isOverdue").find("option[value='"+obj.isOverdue+"']").attr("selected",true);
        		}
				if (obj.createDate !="" && "undefined" != typeof(obj.createDate)) {
        			var createDate = obj.createDate.split("#");
        			$('#from_createDate').val(createDate[0]);
        			$('#to_createDate').val(createDate[1]);
        		}
        		if(openForm=="listPending") {
        			if(obj.subState != undefined && obj.subState !=""){
            			$('#subState').find("option[value='"+obj.subState+"']").attr("selected",true);
            		}
        			if(obj.receiveDate != undefined && obj.receiveDate!="") {
        				var receiveDate = obj.receiveDate.split("#");
            			$('#from_receiveDate').val(receiveDate[0]);
            			$('#to_receiveDate').val(receiveDate[1]);
        			}
        			if(obj.expectprocesstime != undefined && obj.expectprocesstime != ""){
        				var expectprocesstime = obj.expectprocesstime.split("#");
            			$('#from_expectprocesstime').val(expectprocesstime[0]);
            			$('#to_expectprocesstime').val(expectprocesstime[1]);
        			}
        		} else if(openForm == "listDone") {
        			if(obj.dealDate != undefined && obj.dealDate !="") {
        				var dealDate = obj.dealDate.split("#");
            			$('#from_dealtime').val(dealDate[0]);
            			$('#to_dealtime').val(dealDate[1]);
        			}
        			if(obj.workflowState != undefined && obj.workflowState !=""){
            			$('#workflowState').find("option[value='"+obj.workflowState+"']").attr("selected",true);
        			}
        			if(obj.nodeskip != "undefined" && obj.nodeskip !=""){
            			$('#nodeskip').find("option[value='"+obj.nodeskip+"']").attr("selected",true);
        			}
        		}
        	}
        });
        
        function OK(json) {
            var o = new Object();
            o.subject = $('#title').val();
            o.importantLevel = $('#importent').val();
            o.startMemberName = $('#spender').val();
            var from_createDate=$('#from_createDate').val();
            var to_createDate=$('#to_createDate').val();
            var date = from_createDate+'#'+to_createDate;
            if(from_createDate=='' && to_createDate==''){
			    date='';
			  }
            o.createDate=date;
            o.isOverdue = $('#isOverdue').val();
         if(json.type==1){
           if(openForm=="listPending"){ //listPending 

               if(from_createDate != "" && to_createDate != "" && from_createDate > to_createDate){
                   $.alert($.i18n('collaboration.rule.date'));//开始时间不能早于结束时间
                   return;
               }
               
	        	var from_receiveDate=$('#from_receiveDate').val();
	        	var to_receiveDate=$('#to_receiveDate').val();

	        	if(from_receiveDate != "" && to_receiveDate != "" && from_receiveDate > to_receiveDate){
	                   $.alert($.i18n('collaboration.rule.date'));//开始时间不能早于结束时间
	                   return;
	               }
	        	
	        	var date = from_receiveDate+'#'+to_receiveDate;
			    if(from_receiveDate=='' && to_receiveDate==''){
				    date='';
				  }
	        	o.receiveDate=date;
	            var from_expectprocesstime=$('#from_expectprocesstime').val();
	            var to_expectprocesstime=$('#to_expectprocesstime').val();

	            if(from_expectprocesstime != "" && to_expectprocesstime != "" && from_expectprocesstime > to_expectprocesstime){
                    $.alert($.i18n('collaboration.rule.date'));//开始时间不能早于结束时间
                    return;
                }
	            
	            var date = from_expectprocesstime+'#'+to_expectprocesstime;
	            if(from_expectprocesstime=='' && to_expectprocesstime==''){
				    date='';
				  }
	            o.expectprocesstime = date;
	            o.subState=$('#subState').val();
	            o.condition = "comQuery";
	            if($("#condition1").val() == 1){
	            	o.templeteAll = "all";
			    }
	            if($("#condition2").val() == 1){
                    o.templeteIds = $("#frombizconfigIds").val()+"";
                }
                if($("#condition3").val() == 1){
                	o.templeteIds = $("#bisnissMap").val()+"";
                }
                if($("#condition4").val() == 1){
                	o.templeteCategorys = $("#templeteCategorys").val()+"";
                }
                
                return o;
	            
            }else if(openForm=="listDone"){
                  var from_createDate = $("#from_createDate").val();
                  var to_createDate = $("#to_createDate").val();
                  if(from_createDate != "" && to_createDate != "" && from_createDate > to_createDate){
                      $.alert($.i18n('collaboration.rule.date'));//开始时间不能早于结束时间
                      return;
                  }
            	  var fromDate = $('#from_dealtime').val();
                  var toDate = $('#to_dealtime').val();
                  if(fromDate != "" && toDate != "" && fromDate > toDate){
                      $.alert($.i18n('collaboration.rule.date'));//开始时间不能早于结束时间
                      return;
                  }
                  var date = fromDate+'#'+toDate;
                  if(fromDate=='' && toDate==''){
  				    date='';
  				   }
                  o.dealDate = date;
                  //当按照处理时间查询时候，查询所有的信息
                  o.deduplication = "false";
            	  o.workflowState = $('#workflowState').val();
            	  if($("#condition1").val() == 1){
                      o.templeteAll = "all";
                  }
            	  if($("#condition2").val() == 1){
                      o.templeteIds = $("#frombizconfigIds").val()+"";
                  }
            	  if($("#condition3").val() == 1){
                      o.templeteIds = $("#bisnissMap").val()+"";
                  }
            	  if($("#condition4").val() == 1){
                      o.templeteCategorys = $("#templeteCategorys").val()+"";
                  }
                  if($("#deduplication").val() == "true"){
                	  o.deduplication ="true";
                  }
                  if($("#nodeskip").val() != "undefined" && $("#nodeskip").val() != ""){
                  	  o.nodeskip = $("#nodeskip").val();
                  }
                  return o;
            	   
            }
        	 
           }
            if(json.type==2){
            	$("#combinedQueryDIV").clearform();
             }
        }
       
    </script>
    </head>
    <body class="h100b over_hidden" style="background:#fafafa;">
        <input type="hidden" id="condition1" value="${condition1}" />
        <input type="hidden" id="condition2" value="${condition2}" />
        <input type="hidden" id="frombizconfigIds" value='${param.textfield}' />
        <input type="hidden" id="condition3" value="${condition3}" />
        <input type="hidden" id="bisnissMap" value='${param.textfield}' />
        <input type="hidden" id="condition4" value="${condition4}" />
        <input type="hidden" id="templeteCategorys" value="${param.textfield}" />
        <input type="hidden" id="deduplication" value="${param.deduplication}" />
        <div class="form_area" id="combinedQueryDIV" style="margin: 0px 20px;">
            <form style="height: 100%;" name="addQuery" id="addQuery" method="post" class="align_center">
                <table  style="height: 100%;width:100%;" border="0">
                    <tr>
                        <td align="right" nowrap="nowrap" style="width:61px;color:#333;">${ctp:i18n("cannel.display.column.subject.label")}${ctp:i18n("collaboration.common.maohao")}</td>
                        <td align="left"><input style="width:251px;color:#333;" id="title"  type="text" name="title"/></td>
                    </tr>
                    <tr>
                        <td style="width:61px;color:#333;" align="right" nowrap="nowrap" id="reportUnitTd" >${ctp:i18n("common.importance.label")}${ctp:i18n("collaboration.common.maohao")}</td>
                        <td align="left" >
                        	<select id="importent" name="importent" style="width:251px;color:#333;margin-top:6px;">
                        	 <option value="">${ctp:i18n("collaboration.newcoll.qxz")}</option>
                        	 <option value="1">${ctp:i18n("common.importance.putong")}</option>
                        	  <option value="2">${ctp:i18n("common.importance.zhongyao")}</option>
                        	   <option value="3">${ctp:i18n("common.importance.feichangzhongyao")}</option>
                        	</select>
                        </td>
                    </tr>
                    <c:if test="${dataType ne '1'}">
                     <tr>
                        <td style="width:61px;color:#333;" align="right" nowrap="nowrap" id="reportUnitTd" >${ctp:i18n("cannel.display.column.sendUser.label")}${ctp:i18n("collaboration.common.maohao")}</td>
                        <td align="left"><input style="width:251px;color:#333;margin-top:6px;" id="spender" type="text" name="spender"/></td>
                    </tr>
                    </c:if>
                     <tr>
                        <td style="width:61px;color:#333;" align="right" nowrap="nowrap" id="reportUnitTd" >${ctp:i18n("common.date.sendtime.label")}${ctp:i18n("collaboration.common.maohao")}</td>
                        <td align="left">
                            <input id="from_createDate" style="width: 113px; margin-top: 6px; color: #333;" class="comp" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[120,10]" readonly>
                            <span class="padding_lr_5">-</span>
                            <input id="to_createDate" class="comp" style="width: 113px; margin-top: 6px; color: #333;" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[120,10]" readonly>
                        </td>
                    </tr>
                    <c:if test="${openForm == 'listPending'}">
	                    <tr>
	                        <td  style="width:61px;color:#333;" align="right" nowrap="nowrap" id="reportUnitTd">${ctp:i18n("cannel.display.column.receiveTime.label")}${ctp:i18n("collaboration.common.maohao")}</td>
	                        <td align="left">
	                            <input id="from_receiveDate" style="width: 113px; margin-top: 6px; color: #333;" class="comp" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[120,10]" readonly>
	                            <span class="padding_lr_5">-</span>
	                            <input id="to_receiveDate" class="comp" style="width: 113px; margin-top: 6px; color: #333;" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[120,10]" readonly>
	                        </td>
	                    </tr>
	                     <tr>
	                        <td style="width:61px;color:#333;" align="right" nowrap="nowrap" id="reportUnitTd">${ctp:i18n("pending.deadlineDate.label") }${ctp:i18n("collaboration.common.maohao")}</td>
	                        <td align="left">
	                            <input id="from_expectprocesstime" style="width: 113px; margin-top: 6px; color: #333;" class="comp" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[120,10]" readonly>
	                            <span class="padding_lr_5">-</span>
	                            <input id="to_expectprocesstime" class="comp" style="width: 113px; margin-top: 6px; color: #333;" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[120,10]" readonly>
	                        </td>
	                    </tr>
	                     <tr>
	                        <td style="width:61px;color:#333;" align="right" nowrap="nowrap" id="reportUnitTd" >${ctp:i18n("collaboration.trans.label") }${ctp:i18n("collaboration.common.maohao")}</td>
	                        <td align="left" >
	                        	<select id="subState" name="subState"  style="width:251px;color:#333;margin-top:6px;">
	                        	 <option value="">${ctp:i18n("collaboration.newcoll.qxz")}</option>
	                        	 <option value="11">${ctp:i18n("collaboration.toolTip.label11") }</option>
	                        	  <option value="12">${ctp:i18n("collaboration.toolTip.label12") }</option>
	                        	   <option value="13">${ctp:i18n("collaboration.dealAttitude.temporaryAbeyance") }</option>
	                        	    <option value="2">${ctp:i18n("collaboration.toolTip.label16") }</option>  
	                        	     <option value="15">${ctp:i18n("collaboration.substate.16.label") }</option>
	                        	</select>
	                        </td>
	                    </tr>
                    </c:if>
                     <c:if test="${openForm == 'listDone'}">
	                     <tr>
		                        <td style="width:61px;color:#333;" align="right" nowrap="nowrap" id="reportUnitTd">${ctp:i18n("common.date.donedate.label")}${ctp:i18n("collaboration.common.maohao")}</td>
		                        <td align="left">
		                            <input id="from_dealtime" style="width: 113px; margin-top: 6px; color: #333;" class="comp" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[120,10]" readonly>
		                            <span class="padding_lr_5">-</span>
		                            <input id="to_dealtime" class="comp" style="width: 113px; margin-top: 6px; color: #333;" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[120,10]" readonly>
		                        </td>
		                    </tr>
		                    <tr>
	                        <td style="width:61px;color:#333;" align="right" nowrap="nowrap" id="reportUnitTd">${ctp:i18n("collaboration.workFlowState.label") }${ctp:i18n("collaboration.common.maohao")}</td>
	                        <td align="left" >
	                        	<select id="workflowState" name="workflowState" style="width:251px;color:#333;margin-top:6px;">
	                        	 <option value="">${ctp:i18n("collaboration.newcoll.qxz")}</option>
	                        	 <option value="0">${ctp:i18n("collaboration.unend")}</option>
	                        	  <option value="1">${ctp:i18n("collaboration.ended")}</option>
	                        	   <option value="2">${ctp:i18n("collaboration.terminated")}</option>
	                        	</select>
	                        </td>
	                    </tr>
                    </c:if> 
                     <tr>
                     	<!-- 节点超期 -->
                     	<td style="width:61px;color:#333;" align="right" nowrap="nowrap" id="isOverdueTd">${ctp:i18n('collaboration.condition.affairOverdue')}${ctp:i18n("collaboration.common.maohao")}</td>
                     	<td align="left" >
                        	<select id="isOverdue" name="isOverdue" style="width:251px;color:#333;margin-top:6px;">
                        		<option value="">${ctp:i18n("collaboration.newcoll.qxz")}</option>
                        	  	<option value="1">${ctp:i18n("message.yes.js")}</option>
                        	    <option value="0">${ctp:i18n("message.no.js")}</option>
                        	</select>
                        </td>
                     </tr>
                     <c:if test="${openForm == 'listDone'}">
                     <tr>
                     	<!-- 节点跳过 -->
                     	<td style="width:61px;color:#333;" align="right" nowrap="nowrap" id="isOverdueTd">${ctp:i18n("collaboration.listDone.nodeskip")}：</td>
                     	<td align="left" >
                        	<select id="nodeskip" name="nodeskip" style="width:251px;color:#333;margin-top:6px;">
                        		<option value="">${ctp:i18n("collaboration.newcoll.qxz")}</option>
                        		<option value="all">${ctp:i18n("collaboration.listDone.allskip")}</option>
                        	  	<option value="overdue">${ctp:i18n("collaboration.listDone.overdueskip")}</option>
                        	    <option value="repeat">${ctp:i18n("collaboration.listDone.repeatskip")}</option>
                        	</select>
                        </td>
                     </tr>
                     </c:if>
                </table>
            </form>
        </div>
    </body>
</html>