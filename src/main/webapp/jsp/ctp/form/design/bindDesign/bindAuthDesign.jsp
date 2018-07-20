<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>form</title>
        <script type="text/javascript" src="${path}/common/form/design/bindDesign/bindAuthDesign.js"></script>
    </head>
    <%@ include file="../../common/common.js.jsp" %>
    <script type="text/javascript">
        $(document).ready(function(){
       var param = window.dialogArguments;
       var tt = $("#authSetTable",param.document).formobj();
       $("#authSetTable").fillform(tt);
       $("#authTo","#authSetTable").val(tt.authTo);
       $("#authTo_txt","#authSetTable").val(tt.authTo_txt);
       if (tt.update){
           var value = $.parseJSON(tt.update);
           var haveSet = false;
           if (value.length){
               for(var i=0; i <value.length;i++){
                   if (value[i].update || value[i].value){
                       addModifySet(null,value[i]);
                       haveSet = true;
                   }
               }
           } else {
               if (value.update || value.value){
                   addModifySet(null,value);
                   haveSet = true;
               }
           }
           if (!haveSet){
               addModifySet();
           }
       } else {
           addModifySet();
       }

       $("#buttonarea").click(function(){
           setUnFlowSetAuth();
       });

       $("#add").change(function(){
           var optionSelected = $(":selected:eq(0)",$(this));
           if (!optionSelected.val()){
               $("#addAlias").val("");
               $("#addAlias").prop("readonly",true);
           } else {
               if (!$("#addAlias").val()){
                   $("#addAlias").val("${ctp:i18n('common.toolbar.new.label')}");
               }
               $("#addAlias").prop("readonly",false);
           }
       });
       $("#add").trigger("change");

       $("#selectPP").click(function(){
           var par = new Object();
           par.value = $("#authTo").val();
           par.text = $("#authTo_txt").val();
           $.selectPeople({
               panels: 'Account,Department,Team,Post,Level,Outworker',
               type:'selectPeople',
               selectType: 'Account,Department,Team,Post,Level,Member',
               hiddenPostOfDepartment:true,
               isNeedCheckLevelScope:false,
               showAllOuterDepartment:true,
               minSize:0,
               params : par,
               callback : function(ret) {
                 $("#authTo").val(ret.value);
                 $("#authTo_txt").val(ret.text);
               }
           });
       });

         $("#setbathupdate").click(function(){
             var obj = {};
             obj.title = "${ctp:i18n('form.bind.bath.update.label')}${ctp:i18n('form.input.inputtype.oper.label')}";
             obj.valueTitle = "${ctp:i18n('form.bind.bath.update.set.label')}";
             obj.showSysArea = false;
             var relationValue = {};
             relationValue.value = "bathupdate";
             obj.relationValue = relationValue;
             obj.result = {
                     value:"bathupdate",
                     display:'bathupdate_txt'
             };
             selectFormField("batchUpdate",obj);
         });
   });

     function OK(){
         if($("#authName").val().trim()==""){
        	 //操作授权名称不能为空
             $.alert("${ctp:i18n('form.bind.operauthname.label')}${ctp:i18n('form.base.notnull.label')}!");
         }else if($(":checkbox:checked","#browseTable").length < 1){
        	 //显示名称至少选择一项!
             $.alert("${ctp:i18n('common.display.show.label')}${ctp:i18n('form.query.chooseOneAtLeast')}");
         }else{
             if (!existSameDisplayName()){
                 var obj = $(".nomore",$("#authSetTable")).formobj({validate:false});
                 var update = $("#updateSet").formobj({validate:false});
                 update = $.toJSON(update);
                 obj.update = update;
                 return obj;
             }
         }
     }
    
    </script>
    <body style="margin-top: 20px;" class="font_size12">
    	<table id="authSetTable" width="600" border="0" cellpadding="0" cellspacing="0" height="100%" class="ellipsis form_area">
		<tr height="35px" class="nomore">
		  <%-- 操作授权名称 --%>
		  <td align="right" nowrap="nowrap" class="padding_l_10">
		  <label><font color="red">*</font></label>${ctp:i18n('form.bind.operauthname.label')}：
		  </td>
		  <td width="300px">
		  <DIV class=common_txtbox_wrap>
		   <input name="authName" type="text" id="authName" >
		   <input name="authId" type="hidden" id="authId" >
		   </DIV>   
		  </td>
		  <td width="100">&nbsp;</td>
		  <td width="170">&nbsp;</td>
		</tr>
		 
		<tr height="35px" class="nomore">
            <td colspan="4">
                <div class="clearfix" style="line-height: 25px;">
                    <%--  新建 --%>
                    <div class="left" style="width: 100px;text-align: right">${ctp:i18n('common.toolbar.new.label')}：</div>
                    <div class="left" style="width: 247px;">
                        <div class=" common_selectbox_wrap" >
                            <select id="add" name="add" class="input-100 font_size12">
                                <%-- 无 --%>
                                <option value="">${ctp:i18n('form.timeData.none.lable')}</option>
                                <c:forEach var="view" items="${formBean.formViewList }">
                                    <c:forEach var="auth" items="${view.operations }">
                                        <c:if test="${auth.type == add }">
                                            <option value='${view.id }.${auth.id }'>${view.formViewName }.${auth.name }</option>
                                        </c:if>
                                    </c:forEach>
                                </c:forEach>
                            </select>
                        </div>
                    </div>
                    <%-- 显示名称 --%>
                    <div class="left" style="width: 90px;text-align: right;margin-right: 10px;">${ctp:i18n("form.bind.showname.label") }：</div>
                    <div class="common_txtbox_wrap left" style="width: 130px;">
                        <input id="addAlias" name="addAlias" style="width:110px;" type="text" value="" class="validate" validate="name:'${ctp:i18n("form.bind.showname.label")}',type:'string',notNull:true,maxLength:10,avoidChar:'<>!@#$%^&*()'" />
                    </div>
                </div>
            </td>
		</tr>
		
        <tr height="35px">
          <td colspan="4">
              <div id="updateSet">

              </div>
          </td>
		</tr>

        <tr height="35px" class="nomore">
            <td align="right">
                ${ctp:i18n('form.bind.bath.update.label')}：
            </td>
            <td >
                <div class="common_txtbox_wrap">
                    <input type="hidden" id="bathupdate" name="bathupdate">
                    <label for="bathupdate_txt"></label><input type="text" datafiledId="bathupdate" id="bathupdate_txt" name="bathupdate_txt" readonly>
                </div>
            </td>
            <td>
                <a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="setbathupdate">${ctp:i18n('form.input.inputtype.oper.label')}</a>
            </td>
        </tr>
		
        <tr height="35px" class="nomore">
        <%-- 显示 --%>
		  <td align="right"><label><font color="red">*</font></label>${ctp:i18n('common.display.show.label')}：</td>
		  <td>
		  <fieldset>
		    <table id="browseTable" width="100%" border="0" cellpadding="0" cellspacing="0" height="100%" class="ellipsis">
				<c:forEach var="view" items="${formBean.formViewList }" varStatus="status">
					<tr>
					  <td align="left" width="35%">
					    <input id="browseCheck${status.index}" type="checkbox" name="browseCheck${status.index}" value="${view.id }" />
					  	<label for="browseCheck${status.index}"><span title="${view.formViewName }">${view.formViewName }</span></label>
					  </td>
					  <td>			
					    <select id="browseSelect${status.index}" name="browseSelect${status.index}" class="input-100 font_size12">
							<c:forEach var="auth" items="${view.operations }">
								<c:if test="${auth.type == browse }">
									<option value='${view.id }.${auth.id }'>${auth.name }</option>
								</c:if>
							</c:forEach>
						</select>
					  </td>
					</tr>  
				</c:forEach>
			</table>
			</fieldset>
		  </td>	 
		  <td>&nbsp;</td>
		  <td>&nbsp;</td>
		</tr> 
		
		<tr height="35px" class="nomore">
		<%-- 其他 --%>
		  <td align="right">${ctp:i18n('common.other.label')}：</td>
		  <td colspan="3">
			<fieldset>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
				  <tr>
				    <td nowrap="nowrap">
                    <label for="bathFresh">
                    <%-- 批量刷新 --%>
                    <input id="bathFresh" type="checkbox" name="bathFresh"  value="true">
                    ${ctp:i18n('form.bind.bath.refresh.label')}
                    </label>       
                    </td>
					<td nowrap="nowrap">
					<label for="allowlock">
					<%-- 加锁/解锁 --%>
				 	<input id="allowlock" type="checkbox" name="allowlock"  value="true">
				    ${ctp:i18n('form.bind.lockedAndUnLock.label')}
					</label>       
					</td>
					<td nowrap="nowrap">
					<label for="allowdelete">
					<%-- 删除 --%>
				 	<input id="allowdelete" type="checkbox" name="allowdelete" value="true">${ctp:i18n('common.toolbar.delete.label')}
					</label>        
					</td>
					<td nowrap="nowrap">
					<label for="allowexport">
					<%-- 导出 --%>
					<input id="allowexport" type="checkbox" name="allowexport" value="true">
				    ${ctp:i18n('form.condition.guideout.label')}
					</label>           
					</td>
					<td nowrap="nowrap">
					<%-- 查询 --%>
					<label for="allowquery">
					<input id="allowquery" type="checkbox" name="allowquery" value="true">
				    ${ctp:i18n('form.query.querybutton')}
					</label>           
					</td>
					<td nowrap="nowrap" height="20">
					<label for="allowreport">
					<%-- 统计 --%>
					<input id="allowreport" type="checkbox" name="allowreport" value="true">
				    ${ctp:i18n('form.report.statbutton')}
					</label>           
					</td>
					<td nowrap="nowrap">
					<%-- 打印 --%>
					<label for="allowprint">
					<input id="allowprint" type="checkbox" name="allowprint" value="true">
				    ${ctp:i18n('form.print.printbutton')}
					</label>           
					</td>
					<td nowrap="nowrap">
					<%-- 日志 --%>
					<label for="allowlog">
						<input id="allowlog" type="checkbox" name="allowlog" value="true">
					    ${ctp:i18n('form.log.label')}
					</label>           
					</td>
				  </tr>
				</table>
			</fieldset>
		  </td>
		</tr>
		<tr height="35px" class="nomore">
		<%-- 操作范围 --%>
		  <td align="right">${ctp:i18n('form.query.operrange.label')}：</td>
		  <td>
		   <div class="common_txtbox">
		    <span id="spanqueryarea">
            <textarea name="formula" id="formula" readonly="readonly" style="width: 100%"></textarea></span>
            </div>
		  </td>
		  <%-- 操作范围 --%>
		   <td> <a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="buttonarea">${ctp:i18n('form.input.inputtype.oper.label')}</a></td>
		</tr>
		
		<tr height="35px" class="nomore">
		<%-- 使用者授权 --%>
		  <td align="right">${ctp:i18n('form.query.useroperauth.label')}：</td>
		  <td>
		  <DIV class=common_txtbox_wrap>
		  <input type="hidden" id="authTo" name="authTo">
		  <input type="text" id="authTo_txt" name="authTo_txt" readonly="readonly">
		  </DIV>
		  </td>
		  <%-- 设置 --%>
		  <td> <a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="selectPP">${ctp:i18n('form.input.inputtype.oper.label')}</a></td>
		</tr>	
	   </table>
        <div class="modifySet hidden margin_t_5">
            <div class="clearfix" style="line-height: 25px;">
                <div class="left" style="width: 45px;text-align: right;padding-right: 15px">
                    <span class="ico16 repeater_reduce_16" id="reduce_btn"></span>
                    <span class="ico16 repeater_plus_16" id="plus_btn"></span>
                </div>
                <%-- 修改 --%>
                <div class="left" style="width: 40px;text-align: right">${ctp:i18n('common.button.modify.label')}：</div>
                <div class="left" style="width: 247px;">
                    <div class=" common_selectbox_wrap" >
                        <select id="update" name="update" class="font_size12">
                            <%-- 无 --%>
                            <option value="" needShow="false">${ctp:i18n('form.timeData.none.lable')}</option>
                            <c:forEach var="view" items="${formBean.formViewList }">
                                <c:forEach var="auth" items="${view.operations }">
                                    <c:if test="${auth.type == update }">
                                        <option needShow="${auth.containInitNull}" value='${view.id }.${auth.id }'>${view.formViewName }.${auth.name }</option>
                                    </c:if>
                                </c:forEach>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <%-- 显示名称 --%>
                <div class="left" style="width: 90px;text-align: right;margin-right: 10px;">${ctp:i18n("form.bind.showname.label") }：</div>
                <div class="common_txtbox_wrap left" style="width: 130px;">
                    <input type="text" id="display" readonly style="width: 110px;" name="display" value="" class="validate" validate="name:'${ctp:i18n("form.bind.showname.label") }',type:'string',notNull:true,maxLength:10,avoidChar:'<>!@#$%^&*()\''" />
                </div>
            </div>
            <div class="clearfix hidden" style="margin-top: 5px;" id="modifyShowDealDiv">
                <div class="left" style="width: 100px">&nbsp;</div>
                <div class="left common_checkbox_box clearfix ">
                    <input name="modifyShowDeal" id="modifyShowDeal" type="hidden" value="false">
                    <label class="margin_r_10 hand input_div" for="modifyShowDeal" onclick="setModifyShowDealValue(this)">
                        <input name="option" class="radio_com input_radio" id="modifyShowDeal" type="checkbox" value="true">修改时不弹出单据</label>
                </div>
            </div>
        </div>
	</body>
</html>
