<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<%@ include file="/WEB-INF/jsp/ctp/form/common/common.js.jsp" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>form</title>
        <script type="text/javascript" src="${path}/ajax.do?managerName=formAuthDesignManager"></script>
    </head>
    <body>
	        <div id="center">
	        <form action="" id="saveForm">
	             <!--左右布局-->
	            	<div id="authField" class="margin_t_5 margin_l_5 margin_r_5" style="height:470px;overflow: auto;">
						<fieldset class="form_area padding_10" id="authFieldMap">
                            <legend>${ctp:i18n('form.oper.operitemflag.label')}</legend>
							<div id="authset">
								<table border="0" cellspacing="0" cellpadding="0" width="100%"   id="authFieldTable">
				                  <tr>
				                  <td align="left" rowspan="7" width="4%">
									<br />
									<br />
									<span class="ico16 repeater_plus_16" href="javascript:void(0)" onclick="add(this);" id="add" parentId="authset" disabled></span>
									<br />
									<br />
									<span class="ico16 repeater_reduce_16" href="javascript:void(0)" onclick="del(this);" id="del" parentId="authset" disabled></span>
									<br />
									<br />
									</td>
				                    <td nowrap="nowrap" align="right" width="6%">
				                        <div style="height:70px;">
					                        <label class="margin_r_10" for="text"  style="margin-bottom: 50px;">
					                           ${ctp:i18n('form.highAuthDesign.if')}:
					                         </label>
				                        </div>
			                         </td>
				                    <td width="410">
				                    <input type="hidden" id="authId" name="authId" value="0"/>
				                    <input type="hidden" id="authValue" name="authValue" value=""/>
				                    <input type="hidden" id="conditionId" name="conditionId" value="0"/>
				                    <textarea readonly="readonly" id="conditionValue" onclick="setConditionVal(this);" name="conditionValue"  style="width:400px;height:70px;" >
				                    </textarea>
				                    </td>
				                     <td width="80" align="left" >
				                        <div>
				                        	<%--则设置为 --%><%--权限设置 --%>
				                            <p>${ctp:i18n('form.highAuthDesign.configas')}:</p><br/>[<A name="highAuthDesign" id="highAuthDesign" parentId="authset" onclick="setHighAuth(this);" class="hand color_blue">${ctp:i18n('form.oper.operitemflag.label')}</A>]
				                        </div>
				                      </td>
				                  </tr>
				                </table>
				           	</div>
						</fieldset>
	                </div>
				</form>
                </div>
            <div id="bottomDiv" class="stadic_layout_footer">
                <table><tr><td><a id="abandon" class="common_button common_button_gray" href="javascript:void(0)">${ctp:i18n('form.trigger.triggerSet.reset.label')}</a></td></tr></table>
            </div>

		<%@ include file="highAuthDesign.js.jsp" %>
        <%@ include file="../common/common.js.jsp" %>
    </body>
</html>
