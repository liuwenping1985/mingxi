<%--
 $Author:  $
 $Rev:  $
 $Date:: #$:

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html style="height: 100%;">
<head>
<title></title>
<style type="text/css">
</style>
</head>
<body style="height: 100%;overflow_x: hidden" >
    <div class="stadic_layout">
	<div class="stadic_layout_head  padding_tb_10  font_size12 " style="height: 30px;">
            <c:choose>
                <c:when test="${param.type eq 'view' }">
		<label class="margin_r_10 left padding_l_5" for="text">${ctp:i18n('formsection.config.view.label') }</label><div class="link_box clearfix"></div>
                </c:when>
                <c:when test="${param.type eq 'edit' }">
            <span>
            <label class="margin_r_10 left padding_l_5" for="text">${ctp:i18n('formsection.config.modify.label') }</label><div class="link_box clearfix">
            <a class="hand" id = "struction">[${ctp:i18n('formsection.config.operinstruction.label') }]</a></div></span>
                </c:when>
                <c:when test="${param.type eq 'create' }">
            <span>
            <label class="margin_r_10 left padding_l_5" for="text">${ctp:i18n('formsection.config.add.label') }</label><div class="link_box clearfix">
            <a class="hand" id = "struction">[${ctp:i18n('formsection.config.operinstruction.label') }]</a></div></span>
                </c:when>
            </c:choose>
	</div>
    <div id="sectionContent" name ="sectionContent" class="stadic_layout_body" style="top: 30px;${param.type eq 'view' ? 'bottom: 0px;' : 'bottom: 30px;' }">
        <div class="w100b" style="height: 85px;width: 96%;text-align: center;">
	        <form class="form_area" name="myform" id="myform" method="post" action="${path }/form/formSection.do?method=save">
	            <fieldset class="w100b">
	                <legend>${ctp:i18n('formsection.config.message.label') }</legend>
                    <input type="hidden" id="id" name = "id">
                    <input type="hidden" id="column" name = "column"  value="${ffmyform.extraMap['column'] }">
                    <input id="templateId" name="templateId" type="hidden" value="${ffmyform.extraMap['templateId'] }">
                    <input id="menuId" name="menuId" type="hidden" value="${parent ne null ? parent.id : ''}">
                    <div style="width: 100%;text-align: center;">
	                <div style="line-height: 25px;width: 800px;display: inline-block;float: none;">
	                   <div style="width: 200px;text-align: right;" class="left"><font color="red">*&nbsp;</font>${ctp:i18n('formsection.config.name.show') }：</div>
	                   <div style="width: 200px;" class="left">
	                       <div class="common_txtbox clearfix">
	                           <div class="common_txtbox_wrap"><input class="validate" id="sectionName" name="sectionName" value="" type="text" validate="name:'${ctp:i18n('formsection.config.name.show') }',type:'string',notNull:true,maxLength:255,notNullWithoutTrim:true"/></div>
	                       </div>
	                   </div>
	                   <div style="width: 200px;text-align: right;" class="left"><font color="red">*&nbsp;</font>${ctp:i18n('formsection.config.template.label') }：</div>
	                   <div style="width: 150px;" class="left">
	                       <div class="common_txtbox clearfix">
	                           <div class="common_txtbox_wrap">
	                               <input id="templateName" name="templateName" value="${ffmyform.extraMap.templateName }" readonly="readonly" type="text" class="validate" validate="name:'${ctp:i18n('formsection.config.template.label') }',type:'string',notNull:true,maxLength:255"/>
	                           </div>
	                       </div>
	                   </div>
	                   <div style="width: 50px;" class="left">
	                       <c:if test="${param.type eq 'create'}">
	                        <a id="template" class="common_button common_button_gray margin_l_5" >${ctp:i18n('formsection.config.choose.template.set') }</a>
	                       </c:if>
	                       <c:if test="${param.type ne 'create'}">
	                        <a id="template" class="common_button common_button_gray margin_l_5" >${ctp:i18n('formsection.config.choose.template.set') }</a>
	                       </c:if>
	                   </div>
	                </div>
	                <div style="line-height: 25px;width: 800px;display:inline-block;float: none;">
		                <div style="width: 200px;text-align: right;" class="left">${ctp:i18n('formsection.config.choose.selectconfig.label') }：</div>
		                <div style="width: 200px;" class="left">
		                    <div class="common_checkbox_box clearfix " style="text-align: left;">
		                       <label class=" margin_r_10 hand" for="columnType" id="mountSelect">
		                           <c:if test="${ffmyform.sectionType eq 0 or ffmyform.sectionType eq 2 or param.type eq 'create'}">
		                           <input id="columnType" class="radio_com" name="columnType" value="0" type="checkbox" checked="checked">${ctp:i18n('formsection.config.homepage.label') }
		                           </c:if>
		                           <c:if test="${ffmyform.sectionType eq 1 or ffmyform.sectionType eq 3 }">
		                           <input id="columnType" class="radio_com" name="columnType" value="0" type="checkbox">${ctp:i18n('formsection.config.homepage.label') }
		                           </c:if>
		                       </label>
                                <c:if test = "${(!ctp:hasPlugin('formBiz') and !ctp:hasPlugin('formBizModify')) or (!ctp:hasPlugin('formAdvanced') and !ctp:hasPlugin('formBiz')) }">
		                       <label class=" margin_r_10 hand" for="menuType" id="menuMount" style="display: show">
		                       </c:if>
                                   <c:if test = "${ctp:hasPlugin('formBiz') or ctp:hasPlugin('formBizModify') }">
		                       <label class=" margin_r_10 hand" for="menuType" id="menuMount" style="display: none">
		                       </c:if>
		                           <c:if test="${ffmyform.sectionType eq 1 or ffmyform.sectionType eq 2}">
		                           <input id="menuType" class="radio_com" name="menuType" value="1" type="checkbox" checked="checked">${ctp:i18n('formsection.config.menu.label') }
		                           </c:if>
		                           <c:if test="${ffmyform.sectionType eq 0 or ffmyform.sectionType eq 3 or param.type eq 'create'}">
		                           <input id="menuType" class="radio_com" name="menuType" value="1" type="checkbox">${ctp:i18n('formsection.config.menu.label') }
		                           </c:if>
		                       </label>
		                   </div>
		                </div>
		                <div style="width: 200px;text-align: right;" class="left">${ctp:i18n('formsection.config.sharetarget.label') }：</div>
	                    <div style="width: 150px;" class="left margin_t_5">
	                        <div class="common_txtbox clearfix">
	                            <div class="common_txtbox_wrap">
	                                <input type="hidden" id="authValue" name="authValue" value="${ffmyform.extraMap.authValue }">
	                                <input type="text" id="authText" readonly="readonly" name="authText" value="${ffmyform.extraMap.authText }">
	                            </div>
	                        </div>
	                    </div>
	                    <div style="width: 50px;" class="left margin_t_5">
                           <a id="auth_set" class="common_button common_button_gray margin_l_5" >${ctp:i18n('formsection.config.choose.template.set') }</a>
	                    </div>
	                </div>
	                </div>
	            </fieldset>
	        </form>
        </div>
        <div class="margin_t_10 w100b" style="width: 96%;display: inline-block;float: none;text-align: center;">
	        <c:if test="${ffmyform.sectionType eq 0 or ffmyform.sectionType eq 2 or param.type eq 'create'}">
	        <div class="left" id="formColumnDIV" style="text-align: center;display:inline;width: 47%">
	        </c:if>
	        <c:if test="${ffmyform.sectionType eq 1 or ffmyform.sectionType eq 3 }">
	        <div class="left" id="formColumnDIV" style="text-align: center;display:none;width: 47%">
	        </c:if>
	        <fieldset style="text-align: center;width: 100%">
	            <legend>${ctp:i18n('formsection.config.homepage.column') }</legend>
	             <%@ include file="formSectionColumn.jsp" %>
	        </fieldset>
            </div>
	        <c:if test="${ffmyform.sectionType eq 1 or ffmyform.sectionType eq 2}">
	        <div class="right" id="formMenuDIV" style="text-align: center;display:inline;width: 47%">
	        </c:if>
	        <c:if test="${ffmyform.sectionType eq 0 or ffmyform.sectionType eq 3 or param.type eq 'create'}">
	        <div class="right" id="formMenuDIV" style="text-align: center;display:none;width: 47%">
	        </c:if>
	        <fieldset style="text-align: center;width: 100%">
	            <legend>${ctp:i18n('formsection.config.menu') }</legend>
	            <div style="width: 100%;height: 220px;margin-top: 10px;display: inline-block;float: none;max-width: 500px;">
	               <div class="left" style="width: 40%;height: 100%;max-width: 250px;">
				         <div id="allColumns" class="scrollList padding5 border_all" style="height: 200px;">
				             <iframe name="allMenuIFrame" id="allMenuIFrame" src="${path }/form/formSection.do?method=showMenuTree&MountType=menu&canedit=${param.type eq 'view'?'false':'true' }&type=showAll&templateIds=${ffmyform.extraMap['templateId'] }" height="100%" width="100%"  border="0" frameBorder="no"></iframe>
				         </div>
				    </div>
				    <div class="left" style="width: 8%;height: 100%;padding-top: 60px;">
				     <c:if test="${param.type ne 'view' }">
				         <p id="columnRight">
				            <span class="ico16 select_selected" onClick="allMenuIFrame.selectColumn()"></span>
				         </p>
				         <p id="columnLeft" style="margin-top: 20px;">
				            <span class="ico16 select_unselect" onClick="removeMenu()"></span>
				         </p>
				     </c:if>
				    </div>
				    <div class="left" style="width: 40%;height: 100%;max-width: 250px;">
				        <div id="selectedMenus" class="scrollList padding5 border_all" style="height: 200px;overflow: auto;">
				            <div style="text-align: left;">${ctp:i18n("formsection.config.column.category.selected") }</div>
				            <c:forEach items="${menus}" var="item">
				                <c:if test = "${item.parentId ne 0 }">
				                <div id="div${item.ext17 }" class="font_size12">
				                    <div class='clearfix' style='line-height: 20px;margin: 3px;'>
				                        <div class='left margin_r_5'>
				                        <c:if test="${item.ext12==7}">${ctp:i18n("menu.collaboration.new") }</c:if>
				                        <c:if test="${item.ext12==8}">${ctp:i18n("menu.collaboration.listWaitsend") }</c:if>
				                        <c:if test="${item.ext12==9}">${ctp:i18n("menu.collaboration.listsent") }</c:if>
				                        <c:if test="${item.ext12==10}">${ctp:i18n("menu.collaboration.listPending") }</c:if>
				                        <c:if test="${item.ext12==20}">${ctp:i18n("menu.collaboration.listDone") }</c:if>
				                        <c:if test="${item.ext12==30}">${ctp:i18n("menu.collaboration.supervise") }</c:if>
				                        <c:if test="${item.ext12==40}">${ctp:i18n("menu.formquery.label") }</c:if>
				                        <c:if test="${item.ext12==50}">${ctp:i18n("menu.formstat.label") }</c:if>
				                        <c:if test="${item.ext12==60}">${ctp:i18n("formsection.infocenter.infocenter") }</c:if>
				                        </div>
				                        <div class='left' >
				                            <input id='menuColumnType' name='menuColumnType' type='hidden' value='${item.ext12 },${item.ext17 }'>
				                            <input id='subMenuId' name='subMenuId' type='hidden' value='${item.id}'>
				                            <input id='menuColumnName' name='menuColumnName' class='validate' style='width: 120px;'  validate="name:'菜单名称',notNull:true,isWord:true,maxLength:20" type='text' value='${item.name }'>
				                         </div>
				                    </div>
				                </div>
				                </c:if>
				            </c:forEach>
	                         <c:if test="${param.type eq 'create' }">
	                         <div id="div40" class="font_size12">
	                           <div class='clearfix' style='line-height: 20px;margin: 3px;'>
	                               <div class='left margin_r_5'>${ctp:i18n("menu.formquery.label") }</div>
		                        <div class='left' >
		                            <input id='menuColumnType' name='menuColumnType' type='hidden' value='40,40'>
		                            <input id='menuColumnName' name='menuColumnName' class='validate' style='width: 120px;'  validate="name:'菜单名称',notNull:true,isWord:true,maxLength:20" type='text' value='${ctp:i18n('formsection.homepage.query.label')}'>
		                         </div>
		                         </div>
	                         </div>
	                         <div id="div50" class="font_size12">
	                           <div class='clearfix' style='line-height: 20px;margin: 3px;'>
	                               <div class='left margin_r_5'>${ctp:i18n("menu.formstat.label") }</div>
			                        <div class='left' >
			                            <input id='menuColumnType' name='menuColumnType' type='hidden' value='50,50'>
			                            <input id='menuColumnName' name='menuColumnName' class='validate' style='width: 120px;'  validate="name:'菜单名称',notNull:true,isWord:true,maxLength:20" type='text' value='${ctp:i18n('formsection.homepage.statistic.label')}'>
			                         </div>
			                     </div>
	                         </div>
	                         <div id="div60" class="font_size12">
	                           <div class='clearfix' style='line-height: 20px;margin: 3px;'>
	                               <div class='left margin_r_5'>${ctp:i18n("formsection.infocenter.infocenter") }</div>
		                        <div class='left' >
		                            <input id='menuColumnType' name='menuColumnType' type='hidden' value='60,60'>
		                            <input id='menuColumnName' name='menuColumnName' class='validate' style='width: 120px;'  validate="name:'菜单名称',notNull:true,isWord:true,maxLength:20" type='text' value='${ctp:i18n('formsection.homepage.center.label')}'>
		                         </div>
		                         </div>
	                         </div>
	                         </c:if>
				        </div>
				    </div>
				    <div class="left" style="width: 8%;height: 100%;padding-top: 60px;">
				     <c:if test="${param.type ne 'view' }">
				         <p id="columnUp">
				            <span class="ico16 sort_up" onClick="moveMenu('up')"></span>
				         </p>
				         <p id="columnDown" style="margin-top: 20px;">
				            <span class="ico16 sort_down" onClick="moveMenu('down')"></span>
				            </p>                    
				        </c:if>
				    </div>
	            </div>
	        </fieldset>
	        </div>
      </div>
   </div>
     <c:choose>
     <c:when test="${param.type eq 'view' }">
     </c:when>
     <c:otherwise>
     <div class="stadic_layout_footer  page_color bg_color w100b hr_heng" style="height: 30px;text-align: center;margin-top: 5px;padding-top: 5px;">
         <a class="common_button common_button_emphasize margin_r_5" id="saveFormSection">${ctp:i18n('common.button.ok.label')}</a>
         <a class="common_button common_button_gray" id="cancelFormSection">${ctp:i18n('common.button.cancel.label')}</a>
     </div>
    <div id="operInstructionDiv"  style="color:  green;font-size: 12px;display: none;">
        ${ctp:i18n('formsection.config.operinstruction.info')}
    </div>
    </c:otherwise>
    </c:choose>
    </div>
 <%@ include file="formSectionShow.js.jsp" %>
</body>
<script type="text/javascript" src="${path}/ajax.do?managerName=formSectionManager"></script>
</html>