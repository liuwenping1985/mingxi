<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/workflow/workflowDesigner_js_api.jsp" %>
<!DOCTYPE html>
<html>
   <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>高级查询</title>
    <head>
    <script type="text/javascript">
        var openForm ="${openForm}";
        function OK(json) {
            var o = new Object();
            o.subject = $('#title').val();
//            o.importantLevel = $('#importent').val();
            o.startMemberName = $('#spender').val();
            var from_createDate=$('#from_createDate').val();
            var to_createDate=$('#to_createDate').val();
            var date = from_createDate+'#'+to_createDate;
            if(from_createDate=='' && to_createDate==''){
			    date='';
			  }
            o.createDate=date;
         if(json.type==1){
           if(openForm=="listPending"){ //listPending 

        	   //var from_createDate = $("#from_createDate").val();
               //var to_createDate = $("#to_createDate").val();
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
            }
             //公文文号
             o.docMark = $('#docMark').val();
             //内部文号
             o.serialNo = $('#serialNo').val();
             //密级
             o.secretLevel = $('#secretLevel').find("option:selected").val();
             //紧急程度
             o.urgentLevel = $('#urgentLevel').find("option:selected").val();
             return o;
           }
            if(json.type==2){
            	$("#combinedQueryDIV").clearform();
             }
        }
       
    </script>
    </head>
    <body class="h100b over_hidden">
        <input type="hidden" id="condition1" value="${condition1}" />
        <input type="hidden" id="condition2" value="${condition2}" />
        <input type="hidden" id="frombizconfigIds" value='${param.textfield}' />
        <input type="hidden" id="condition3" value="${condition3}" />
        <input type="hidden" id="bisnissMap" value='${param.textfield}' />
        <input type="hidden" id="condition4" value="${condition4}" />
        <input type="hidden" id="templeteCategorys" value="${param.textfield}" />
        <input type="hidden" id="deduplication" value="${param.deduplication}" />
        <div class="form_area" id="combinedQueryDIV">
            <form style="height: 100%;" name="addQuery" id="addQuery" method="post" class="align_center">
                <table  style="height: 100%;width:98%;" border="0" cellSpacing="10" cellPadding="10">
                    <tr>
                        <td align="right" nowrap="nowrap" width="3%">${ctp:i18n("cannel.display.column.subject.label")}：</td>
                        <td width="2%" align="left"><input id="title"  type="text" name="title"/></td>
                    </tr>
                    <%--公文文号--%>
                    <tr>
                        <td align="right" nowrap="nowrap" width="3%">${ctp:i18n("govdoc.docMark.label")}：</td>
                        <td width="2%" align="left"><input id="docMark"  type="text" name="docMark"/></td>
                    </tr>
                    <%--内部文号--%>
                    <tr>
                        <td align="right" nowrap="nowrap" width="3%">${ctp:i18n("govdoc.serialNo.label")}：</td>
                        <td width="2%" align="left"><input id="serialNo"  type="text" name="serialNo"/></td>
                    </tr>
                    <%--密级--%>
                    <tr>
                        <td align="right" nowrap="nowrap" width="3%">${ctp:i18n("govdoc.secretLevel.label")}：</td>
                        <td width="2%" align="left">
                            <select name="textfield" class="condition" style="width:90px" id="secretLevel">
                                <option value="">${ctp:i18n("common.pleaseSelect.label")}</option>
                                <c:forEach var="secret" items="${edoc_secret_level.items}">
                                    <c:if test="${secret.outputSwitch == 1}">
                                        <option value="${secret.value}">
                                            <c:choose>
                                                <c:when test="${secret.i18n == 1 }">
                                                    ${v3x:_(pageContext, secret.label)}
                                                </c:when>
                                                <c:otherwise>
                                                    ${secret.label}
                                                </c:otherwise>
                                            </c:choose>
                                        </option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <%--紧急程度--%>
                    <tr>
                        <td align="right" nowrap="nowrap" width="3%">${ctp:i18n("govdoc.urgentLevel.label")}：</td>

                        <td width="2%" align="left">
                            <select name="textfield" class="condition" style="width:90px" id="urgentLevel">
                                <option value="">${ctp:i18n("common.pleaseSelect.label")}</option>
                                <c:forEach var="urgent" items="${edoc_urgent_level.items}">
                                    <c:if test="${urgent.outputSwitch == 1}">
                                        <option value="${urgent.value}">
                                            <c:choose>
                                                <c:when test="${urgent.i18n == 1 }">
                                                    ${v3x:_(pageContext, urgent.label)}
                                                </c:when>
                                                <c:otherwise>
                                                    ${urgent.label}
                                                </c:otherwise>
                                            </c:choose>
                                        </option>
                                    </c:if>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>

<%--                    <tr>
                        <td align="right" nowrap="nowrap" id="reportUnitTd" width="2%">${ctp:i18n("common.importance.label")}：</td>
                        <td align="left" >
                        	<select id="importent" name="importent" style="width: 50%">
                        	 <option value="">${ctp:i18n("collaboration.newcoll.qxz")}</option>
                        	 <option value="1">${ctp:i18n("common.importance.putong")}</option>
                        	  <option value="2">${ctp:i18n("common.importance.zhongyao")}</option>
                        	   <option value="3">${ctp:i18n("common.importance.feichangzhongyao")}</option>
                        	</select>
                        </td>
                    </tr>--%>
                     <tr>
                        <td align="right" nowrap="nowrap" id="reportUnitTd" width="2%">${ctp:i18n("cannel.display.column.sendUser.label")}：</td>
                        <td align="left"><input id="spender" width="2%" type="text" name="spender"/></td>
                    </tr>
                     <tr>
                        <td align="right" nowrap="nowrap" id="reportUnitTd" width="2%">${ctp:i18n("common.date.sendtime.label")}：</td>
                        <td align="left">
                            <input id="from_createDate" style="width: 40%" class="comp" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[120,10]" readonly>
                            <span class="padding_lr_5">-</span>
                            <input id="to_createDate" class="comp" style="width: 40%" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[120,10]" readonly>
                        </td>
                    </tr>
                    <c:if test="${openForm == 'listPending'}">
	                    <tr>
	                        <td align="right" nowrap="nowrap" id="reportUnitTd" width="2%">${ctp:i18n("cannel.display.column.receiveTime.label")}：</td>
	                        <td align="left">
	                            <input id="from_receiveDate" style="width: 40%" class="comp" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[120,10]" readonly>
	                            <span class="padding_lr_5">-</span>
	                            <input id="to_receiveDate" class="comp" style="width: 40%" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[120,10]" readonly>
	                        </td>
	                    </tr>
	                     <tr>
	                        <td align="right" nowrap="nowrap" id="reportUnitTd" width="2%">${ctp:i18n("pending.deadlineDate.label") }：</td>
	                        <td align="left">
	                            <input id="from_expectprocesstime" style="width: 40%" class="comp" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[120,10]" readonly>
	                            <span class="padding_lr_5">-</span>
	                            <input id="to_expectprocesstime" class="comp" style="width: 40%" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[120,10]" readonly>
	                        </td>
	                    </tr>
	                     <tr>
	                        <td align="right" nowrap="nowrap" id="reportUnitTd" width="2%">${ctp:i18n("collaboration.trans.label") }：</td>
	                        <td align="left" width="10%" >
	                        	<select id="subState" name="subState"  style="width: 50%">
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
		                        <td align="right" nowrap="nowrap" id="reportUnitTd" width="2%">${ctp:i18n("common.date.donedate.label")}：</td>
		                        <td align="left">
		                            <input id="from_dealtime" style="width: 40%" class="comp" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[120,10]" readonly>
		                            <span class="padding_lr_5">-</span>
		                            <input id="to_dealtime" class="comp" style="width: 40%" type="text" comp="type:'calendar',ifFormat:'%Y-%m-%d',showsTime:false,position:[120,10]" readonly>
		                        </td>
		                    </tr>
		                    <tr>
	                        <td align="right" nowrap="nowrap" id="reportUnitTd" width="2%">${ctp:i18n("collaboration.workFlowState.label") }：</td>
	                        <td align="left" width="10%" >
	                        	<select id="workflowState" name="workflowState" style="width: 50%">
	                        	 <option value="">${ctp:i18n("collaboration.newcoll.qxz")}</option>
	                        	  <option value="1">${ctp:i18n("collaboration.ended")}</option>
	                        	   <option value="2">${ctp:i18n("collaboration.terminated")}</option>
	                        	</select>
	                        </td>
	                    </tr>
                    </c:if> 
                     
                </table>
            </form>
        </div>
    </body>
</html>