<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />
	<meta name="renderer" content="webkit">
	<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/template/template.js.jsp"%> <%-- 必须放下面否则会因为没有ctp标签而报错(was环境下) --%>
	<title>
		<c:choose>
			<c:when test="${param.from == 'view' }">
				${ctp:i18n('wfanalysis.auth.user.view')}${ctp:i18n('wfanalysis.auth.type.user') }
			</c:when>
			<c:when test="${param.from == 'edit' }">
				${ctp:i18n('wfanalysis.auth.user.edit')}${ctp:i18n('wfanalysis.auth.type.user') }
			</c:when>
			<c:when test="${param.from == 'add' }">
				${ctp:i18n('wfanalysis.auth.user.add')}${ctp:i18n('wfanalysis.auth.type.user') }
			</c:when>
		</c:choose>
	</title>
	<style>
        .stadic_body_top_bottom {bottom: 30px; top: 30px;}
        .stadic_footer_height{height:30px;}
    </style>
</head>
<body class="h100b" >
	<div class="stadic_layout form_area" id="form">
		<form id="form_userAuth" name="form_userAuth" action="${path}/wfanalysisAuth.do?method=saveUserAuth&from=${param.from}" method="post">
			<div class="stadic_layout_body stadic_body_top_bottom clearfix" overflow="scroll">
				<table width="100%" border="0" cellpadding="2" cellspacing="0" id="userAuthTable">
					<%-- 授权人员 --%>
					<tr height="30px">
						<td width="30%" align="right" nowrap="nowrap"><label class="margin_r_10" for="text"><span 
							class="required">*</span>${ctp:i18n('wfanalysis.auth.user.label.orgentName') }：</label></td>
	         			<td nowrap="nowrap" style="width: 50%">
			            	<div class="common_txtbox_wrap">
			             	 	<input type="hidden" id="authId" value="${wfAnalysisAuthVO.authId }"/>
				                <input readonly="readonly" id="personColumn" style='font-size:12px' name="${ctp:i18n('wfanalysis.auth.user.dialog.personError') }"
				                     class="w100b validate" type="text" 
				                     validate="type:'string',notNull:true,avoidChar:'\&#39;&quot;&lt;&gt;',errorMsg:'${ctp:i18n('wfanalysis.auth.user.dialog.personError') }'" 
				                     value="${wfAnalysisAuthVO.orgentDisplayName}"/>
				                <input type="hidden" id="orgentDisplayId" value="${ctp:parseElementsOfTypeAndId(wfAnalysisAuthVO.orgentDisplayId) }"/>
			             	</div>
	         			</td>
	     			</tr>
	     			<%-- 授权模板 --%>
	     			<tr>
	     				<td><label class="margin_r_10 right title" for="text"><font color="red">*</font>${ctp:i18n('wfanalysis.auth.user.label.templateName') }：</label></td>
	     				<%-- 全部模板 --%>
	     				<td nowrap="nowrap">
	     					<div class="codecfg"><label for='scope' class='margin_r_10 hand'><input 
	     						type='radio' value='0' name='scope' id="scope" class='radio_com' <c:if test="${wfAnalysisAuthVO.scope==0 }"> checked </c:if>/>${ctp:i18n('wfanalysis.auth.user.label.allTemplates') }</label>
	     					</div>
	     				</td>
	     				<td></td>
	     			</tr>
	     			<tr>
	     				<td></td>
	     				<%-- 指定模板 --%>
	     				<td>
	     					<div class="common_txtbox clearfix"><label label 
	     						class="margin_r_10 left title" for="scope"><input id="scope" type="radio" value="1" name="scope" class="radio_com" <c:if test="${wfAnalysisAuthVO.scope==1 }"> checked </c:if>/>
                    	${ctp:i18n('wfanalysis.auth.user.label.designTemplates') }<input type="hidden" id="templateIds" value="${wfAnalysisAuthVO.templateIds}"></label>                                                   
	                    		<div class="common_txtbox_wrap" style="padding-right:0">
	                        		<textarea readonly="readonly" style="border:none;" id="templateNames" name="templateNames" rows="3" class="w100b"><c:if test="${wfAnalysisAuthVO.scope==1 }">${wfAnalysisAuthVO.templateNames}</c:if></textarea>
	                    		</div>
               				 </div>
	     				</td>
	     				<td></td>
	     			</tr>
				</table>
			</div>
			<div align="center" id="buttonDiv" class="stadic_layout_footer stadic_footer_height page_color" >
				<a class="common_button common_button_emphasize margin_r_5" href="javascript:void(0)" id="saveQuery">${ctp:i18n('wfanalysis.auth.user.label.save') }</a>
				<a class="common_button common_button_gray margin_l_5" href="javascript:void(0)" id="reset">${ctp:i18n('wfanalysis.auth.user.label.cancel') }</a>
			</div>		
		</form>
		<input id="validTemplateNames" type="hidden" value="${ctp:toHTMLWithoutSpace(wfAnalysisAuthVO.validTemplateNames)}" />
	</div>
	<script type="text/javascript">
		$(function(){
			<c:choose>
				<c:when test="${param.from == 'view' }">
					//查看
					function initView() {
						$("#personColumn").attr("disabled", "disabled"); //禁用人员选择
						$("input[name='scope']").attr("disabled", "disabled"); //禁用类型单选框
						$("#templateNames").attr("disabled", "disabled"); //禁用
						$("#buttonDiv").hide(); //隐藏[确定/取消]按钮
					}
					initView(); //初始化
				</c:when>
				<c:when test="${param.from == 'add' || param.from == 'edit'}">
					//新增|编辑
					function init(){
						//选人界面初始化
						$("#personColumn").off("click").on("click", function(){
							var $orgentDisplayId = $("#orgentDisplayId");
							var $personColumn = $("#personColumn"); //只用于显示
							$.selectPeople({
						        type: 'selectPeople',
						        panels: 'Department',
						        selectType: 'Member',
						        onlyLoginAccount: true,
						        isNeedCheckLevelScope: false,
						        showConcurrentMember: true,
						        params : {
							    	text: $personColumn.val(),
							        value: $orgentDisplayId.val()
							    },
							    callback: function(ret) {
							    	$orgentDisplayId.val(ret.value);
							    	$personColumn.val(ret.text);
							    }
							});
						});
						//选择模板初始化
						$("#templateNames").off("clic").on("click", function(){
							$("input:radio[name='scope'][value='1']").trigger("click"); //触发指定模板单选
						});
						var $templateNames = $("#templateNames");
						var $templateIds = $("#templateIds");
						$("input:radio[name='scope']").off("click").on("click", function(e){
							var $radio = $(e.target);
							if ($radio.val() == 1) { //指定模板
								templateOrginalData = {};
								templateOrginalData["ids"]  = $templateIds.val();
							    templateOrginalData["names"]= $templateNames.val().split(',');
							    templateChoose(function(keys, arrayName, values){ //回调函数
							    	$templateNames.val(arrayName.join("、"));
									$templateIds.val(keys);
							    }, '1,2,4', true, "${CurrentUser.accountId}", "MaxScope");
							} else { //全部模板
								$templateNames.val("");
								$templateIds.val("");
								templateOrginalData = {};
							}
						});
						//新增按钮
						$("#saveQuery").off("click").on("click", function(){
							//内容校验
							if ($("#form_userAuth").validate()) {
								if ($("input:radio[name='scope']:checked").val() == 1 && $("#templateNames").val() == '') {
									$.alert("${ctp:i18n('wfanalysis.auth.user.dialog.choseTemplate')}");
									return;
								}
								var proce = getCtpTop().$.progressBar({
								      text : "${ctp:i18n('wfanalysis.auth.user.dialog.saving')}"
							    });
								$("#form_userAuth").jsonSubmit({
					            	callback : function(ret) {
					            		if (ret) {
					            			ret = JSON.parse(ret);
				            				if (ret.flag) {
						            	    	 proce.close();
							            	     parent.document.location.reload();	 
						            	     } else {
						            	    	 $.alert(ret.msg);
						            	    	 proce.close(); 
						            	     }
					            		} else {
					            			proce.close();
						            	    parent.document.location.reload();
					            		}
					            	}
					            });
							}
						});
						//取消按钮
						$("#reset").off("click").on("click", function(){
							parent.document.location.reload();
						});
						<%-- 若编辑状态时：如果前期授权的模板被删除或者停用需要弹出提示 --%>
						<c:if test="${param.from == 'edit' && not empty wfAnalysisAuthVO.invalidTemplates}">
							var invalidTemplates = "${ctp:toHTMLWithoutSpaceEscapeQuote(wfAnalysisAuthVO.invalidTemplates)}";
							var win = new MxtMsgBox({
							    'type': 0,
							    imgType:2,
							    'msg': "以下数据已经不再使用，将不再显示：" + invalidTemplates,
							    ok_fn:function(){
							    	win.close();
									$templateIds.val("${wfAnalysisAuthVO.validTemplateIds}");
									$templateNames.val($("#validTemplateNames").val()); //此处用于触发修改指定模板内容为有效的模板名称
							    	$("input:radio[name='scope'][value='1']").trigger("click"); //触发指定模板单选
							    }
							});
						</c:if>
					}
					init(); //初始化
				</c:when>
			</c:choose>
		});
	</script>
</body>
</html>