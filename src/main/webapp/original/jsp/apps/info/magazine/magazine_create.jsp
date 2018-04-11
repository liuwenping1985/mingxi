<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html class="h100b over_hidden">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=infoMagazineManager"></script>
<script type="text/javascript" src="${path}/ajax.do?managerName=infoManager"></script>
<script type="text/javascript" src="${path}/apps_res/info/js/magazine_create.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
var auditStatus = '${infoMagazineVO.infoMagazine.auditStatus}';
var magazineManager = new infoMagazineManager();
var currentAccount = "${currentAccount}";
var currentTime = "${currentTime}";
var folder = "${folder}";
var systemTemplate = "${sysTemplateUrl}";
var action = "${ctp:escapeJavascript(action)}";
var magazineContentToJson = ${infoMagazineVO.magazineContentToJson};
var useLocalTemplateFile = "${infoMagazineVO.infoMagazine.useLocalFile}" == "1";//设定是否使用本地模版
var infoStateIsDraft = "${infoMagazineVO.infoStateIsDraft}"=="true";
var _isOldMagazine = "${infoMagazineVO.isOld}";

$(document).ready(function () {
	if(magazineContentToJson.length > 0){
		for(var i=0; i<magazineContentToJson.length; i++){
			//封装期刊内容
			if(magazineContentToJson[i].subject && magazineContentToJson[i].subject != ""){
				addMagzineConfForInfo("2",magazineContentToJson[i].subject,"info",
						magazineContentToJson[i].createTime,"0",magazineContentToJson[i].id,
						true,false,magazineContentToJson[i].id,null,"collaboration.gif","Doc1",
						magazineContentToJson[i].id,"32",null,null,"");
			}
		}
	}

	if("${infoMagazineVO.infoMagazine.auditStatus}" == ""){//新建 -默认
		$("#radio_notAudit").attr("checked","checked");
		$("#auditer").hide();
	}else if("${infoMagazineVO.infoMagazine.auditStatus}" == "1"){//编辑-需要审核
		$("#radio_Audit").attr("checked","checked");
		$("#auditer").show();
		if("${infoMagazineVO.infoMagazine.auditMemberIds}" != "")
			$("#audit_label").html("${ctp:i18n('infosend.magazine.label.selectedAuditor')}");
	}else if("${infoMagazineVO.infoMagazine.auditStatus}" == "0"){//编辑-不需要审核
		$("#radio_notAudit").attr("checked","checked");
		$("#auditer").hide();
	}
});
</script>
<body class="h100b page_color" >
<form method="post" id="sendForm"  name="sendForm" class="h100b">
<div id='newInfo_layout' class="comp" comp="type:'layout'">
	<div class="layout_north" layout="height:105,border:false,sprit:false">
		<div id="north_area_h">
			<div class="padding_l_5">
				<div id="toolbar"></div>
			</div>
			<div class="hr_heng"></div>

			<div id="attachment2TRDoc1" style="display: none;">
				<div style="float:left;" class="margin_l_10 margin_r_5"><span style="color: #717171">${ctp:i18n('collaboration.sender.postscript.correlationDocument')}: </span> (<span id="attachment2NumberDivDoc1"></span>)</div>
				<div style="float: right;" id="assDocDomain" isCrid="true" class="comp" comp="type:'assdoc',attachmentTrId:'Doc1',applicationCategory:'1',referenceId:'',modids:1,canDeleteOriginalAtts:false"></div>
			</div>
			<div id="magazineMainData" class="form_area new_page">
				<input type="hidden" value="${folder}" name="infoUrl"/>
				<input type="hidden" value="${currentAccount}" name="publish_account"/>
				<input type="hidden" value="${currentDept}" name="publish_dept"/>
				<input type="hidden" value="${currentTime}" name="publish_time"/><!-- _taohong 用于期刊套红 -->
				
				<!-- 创建者信息 -->
				<input type="hidden" value="${currentAccount}" name="create_account" _taohong="true"/>
                <input type="hidden" value="${currentDept}" name="create_dept" _taohong="true"/>
                <input type="hidden" value="${currentTime}" name="create_time" _taohong="true"/><!-- _taohong 用于期刊套红 -->
				
				<input type="hidden" value="${currentUserName}" name="create_user" _taohong="true"/>
				<input type="hidden" value="${infoMagazineVO.infoMagazine.id}" name="id" id="id"/>
				<input type="hidden" value="${infoMagazineVO.infoMagazine.templateId}" name="templateId" id="templateId"/>
				<input type="hidden" value="${infoMagazineVO.infoMagazine.useLocalFile}" name="useLocalFile" id="useLocalFile">
				<%--配置的期刊内容 --%>
				<input class="hidden" value="${infoMagazineVO.infoIds}" name="magazineConfInfos" id="magazineConfInfos"/>
				<%-- 打开文件 --%>
                <input type="hidden" name="isLoadNewFile" id="isLoadNewFile" value="0">
                <input type="hidden" value="${action}" name="action" id="action" />

				<%-- 輸入區 --%>
		      	<table>
					<tr>
						<td rowspan="2" width="1%" nowrap="nowrap">
							<a id='sendId'  class="margin_lr_10 display_inline-block align_center new_btn">${ctp:i18n('infosend.magazine.create.send')}</a>
						</td>

						<th nowrap="nowrap" width="1%" class='bgcolor align_right'>${ctp:i18n('infosend.magazine.create.journalName')}</th>
						<td width="25%">
							<div class="common_txtbox_wrap margin_l_5">
					             <input class="w100b validate" type="text" id="subject" value="${ctp:toHTML(infoMagazineVO.infoMagazine.subject)}" name="subject" _taohong="true" validate="type:'string',name:'${ctp:i18n('infosend.magazine.create.journalName')}',notNull:true,maxLength:85,character:'-!@#$%^&amp;*()_+',avoidChar:'\\/|$%&amp;&quot;*:?'" alt="${ctp:toHTML(infoMagazineVO.infoMagazine.subject)}"/>
							</div>
						</td>

					   	<th nowrap="nowrap" width="1%" class='bgcolor padding_l_10 align_right'>${ctp:i18n('infosend.magazine.create.configuration')}</th>
						<td nowrap="nowrap" width="25%">
							<div class="common_txtbox_wrap margin_l_5">
					             <input class="w100b validate" id="magazineConf" name="magazineConf" readonly="readonly" type="text" value="${infoMagazineVO.magazineContent}"/>
							</div>
						</td>

						<th nowrap="nowrap" width="1%" class='bgcolor padding_l_10 align_right'>${ctp:i18n('infosend.magazine.create.audit')}</th>
						<td class="padding_r_10">
							<div class="common_checkbox_box clearfix ">
								<label class="margin_r_10 hand" for="radio_notAudit">
					                <input id="radio_notAudit" name="audit" value="0" type="radio" class="radio_com">${ctp:i18n('infosend.magazine.create.notAudited')}
					            </label>
					            <label class="margin_r_10 hand" for="radio_Audit">
					                <input id="radio_Audit" name="audit" value="1" type="radio" class="radio_com">${ctp:i18n('infosend.magazine.create.audit1')}  <%-- 无冒号 --%>
					            </label>
					            <!--<input id="auditer" name="auditer" type="text" onclick="doSelectAuditer()" value=""/>-->
					            <!--
					            <a id="auditer" name="auditer" onclick="doSelectAuditer()" class="common_button common_button_icon comp edit_flow"
					            style="max-width:100px; white-space: normal;width: 100px;">
					            	<span id="audit_label" style=" margin-right: 19px; ">${ctp:i18n('infosend.magazine.create.selectReviewers')}  </span>
					            	<em class="sub_ico" style="margin-right: -8px;"></em>
					            </a> -->
					            <input class="w100b validate common_txtbox_wrap margin_l_5" id="auditer" name="auditer" _taohong="true" readonly="readonly" type="text" onclick="doSelectAuditer()" value="${infoMagazineVO.auditMemberNames}"
					            style="max-width:100px; white-space: normal;width: 100px;"/>

					            <%--已选的审核人 --%>
					            <input id="auditerIds" name="auditerIds" value="${infoMagazineVO.infoMagazine.auditMemberIds}" type="hidden"/>
					            <%--<select id="auditer" name="auditer" style="display: inline-block; width: 130px;">
					            	<c:forEach var="auditMember" items="${auditers}">
					            		<option id="${auditMember.id}">${auditMember.name}</option>
					            	</c:forEach>
					            </select> --%>
							</div>
						</td>
					</tr>

					<tr>
						<th nowrap="nowrap" width="1%" class='bgcolor align_right'>${ctp:i18n('infosend.magazine.create.issue')}</th>
						<td width="25%">
							<div class="common_txtbox_wrap margin_l_5">
								<input class="w100b" name="magazine_no" _taohong="true" validate="maxLength:4,isInteger:true,min:0,name:'${ctp:i18n('infosend.magazine.create.issue')}',notNull:true" maxLength="4" maxSize="4" id="magazine_no" type="text" value="${infoMagazineVO.infoMagazine.magazineNo}"/>
							</div>
						</td>

						<th nowrap="nowrap" width="1%" class='bgcolor align_right'>${ctp:i18n('infosend.magazine.create.publishingLayout')}</th>
						<td>
							<div class="common_selectbox_wrap margin_l_5 ">
					            <select id="templates" onchange="selectTemplate()">
					            	<option id="default_select" ${infoMagazineVO.infoMagazine.templateId == null ? "selected='selected'" : ""}>${ctp:i18n('infosend.magazine.create.selectPublishingLayout')}</option>
					            	<c:forEach var="template" items="${infoMagazineVO.formats}">
					            		<option ${infoMagazineVO.infoMagazine.templateId == template.id ? "selected='selected'" : ""}
					            		 id="${template.id}" fileUrl="${infoMagazineVO.fileUrlMapping[template.id]}">
					            			${ctp:toHTML(template.name)}
					            		</option>
					            	</c:forEach>
					            </select>
					        </div>
						</td>

						<th nowrap="nowrap" width="1%" class='bgcolor padding_l_10 align_right'>${ctp:i18n('infosend.magazine.create.selectPublishRange')}</th>
						<td class="padding_r_10">
							<div id="magazinePublishRange" class="common_txtbox_wrap margin_l_5">
								<%@ include file="../common/magazine_publish_common.jsp" %>
								<input class="w100b validate" type="text" value="${publishVO.publishRangeNames}" id="publishRange"  readonly="readonly" name="publishRange"/>
								<!-- 隐藏显示查看页面人员的Account|id -->
								<input type="hidden" id="viewPeopleId" name="viewPeopleId" value="${infoMagazineVO.viewPeopleId}">
								<!-- 隐藏显示组织\单位查看人员的Account|id -->
								<input type="hidden" id="publicViewPeopleId" name="publicViewPeopleId" value="${infoMagazineVO.publicViewPeopleId}">
								<input type="hidden" id="orgSelectedTree" name="orgSelectedTree" value="${infoMagazineVO.orgSelectedTree}">
								<input type="hidden" id="UnitSelectedTree" name="UnitSelectedTree" value="${infoMagazineVO.unitSelectedTree}">
								<!-- 隐藏显示查看人员的中文 -->
								<input type="hidden" id="viewPeople" name="viewPeople" value="${infoMagazineVO.viewPeople}">
								<!-- 隐藏显示组织\单位查看人员的中文-->
								<input type="hidden" id="publicViewPeople" name="publicViewPeople" value="${infoMagazineVO.publicViewPeople}">
								<!-- 后台传递参数，组件显示范围不受权限控制 0代表后台，1代表台 -->
								<input type="hidden" id="openFromType" name="openFromType" value="1">
							</div>
						</td>
					</tr>
				</table>
				<%-- 輸入區 --%>

		    </div><!-- infoMainData -->
	    </div><!-- north_area_h -->
	</div><!-- layout_north -->

	<div class="layout_center" style="overflow:auto;background:#fff;" layout="border:false,spiretBar:{show:false}">
		<jsp:include page="/WEB-INF/jsp/common/content/content.jsp" />
	</div>
</div>
</form>
</body>
</html>