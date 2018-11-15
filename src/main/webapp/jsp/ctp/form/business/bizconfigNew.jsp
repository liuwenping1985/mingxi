<%--
 $Author: wusb $
 $Rev: 603 $
 $Date:: 2012-09-18

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html style="width: 100%;height: 100%;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>业务配置</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=businessManager"></script>
</head>
<BODY style="width: 100%;height: 100%;">
<c:if test="${empty param.from}">
<div class="comp" comp="type:'breadcrumb',code:'T05_newBusiness'"></div>
</c:if>
<FORM name="bizForm" id="bizForm" method="post" target="main" class="form_area" style="width: 100%;height: 100%;">
<div class="stadic_layout over_hidden">
    <div class="stadic_layout_head" style="height: 65px;">
			<table id="domain1" align="center" border="0" width="100%">
				<tr style="width: 500px;">
					<td style="width: 500px">
					   <div class="clearfix" style="line-height: 20px;margin-top: 5px;width: 500px">
					       <div class="left" style="width: 250px;text-align: right;">
					       		<!-- 业务名称 -->
					           <label class="font_size12"><font color="red">*</font>${ctp:i18n("formsection.config.name.label") }：</label>
					       </div>
					       <div class="left" style="width: 160px;">
								<div class="font_size12 common_txtbox_wrap" style="width: 150px;text-align: left;">
								<input type="text" id="bizConfigName" name="bizConfigName" value="${bizConfig.name}"  class="validate" validate='avoidChar:"\\/|<>:*?\"",type:"string",name:"${ctp:i18n('formsection.config.name.label') }",notNull:true,maxLength:15,notNullWithoutTrim:true'>
								</div>
					       </div>
					       <div class="left">
					       		<!-- 一级菜单 -->
					           ${ctp:i18n('bizconfig.business.name.comment.label') }
					       </div>
					   </div>
					</td>
					<td rowspan="2"  style="width: 300px;">
                        <div class="clearfix"  style="width: 300px;">
                            <div class="left font_size12" style="">${ctp:i18n('bizconfig.business.image.label') }</div>
                            <div class="left"  id="viewImageIframe">
                                <img id="img" alt="" width="32px" height="32px" src="">
                            </div>
                            <div class="left" style="margin-left: 10px;margin-top: 16px;" onclick="imageUpload('bizimage1')">
                                <a id="btnupload" class="common_button common_button_gray" href="javascript:void(0)">${ctp:i18n('bizconfig.business.image.upload') }</a>
                            </div>
                            <div class="left" style="margin-left: 10px;margin-top: 16px;" onclick="setDefalutImage();return false;">
                                <a id="btnclose" class="common_button common_button_gray" href="javascript:void(0)">${ctp:i18n('bizconfig.business.image.default') }</a>
                            </div>
                        </div>
                    </td>
				</tr>
				<tr style="width: 500px;">
				    <td style="width: 500px">
					   <div class="clearfix" style="line-height: 20px;margin-top: 5px;margin-bottom: 5px;width: 500px">
					       <div class="left" style="width: 250px;text-align: right;">
					       		<!-- 使用者授权 -->
					           ${ctp:i18n("bizconfig.use.authorize.label") }：
					       </div>
					       <div class="left common_txtbox_wrap" style="width: 150px;text-align: left;">
					           <input type="hidden" name="bizConfigId" id="bizConfigId" value="${bizConfig.id}">
			                    <input type="hidden" name="from" value="${ctp:toHTML(param.from)}">
			                    <input type="text" name="shareScope" id="shareScope" value="${scopeNames}" style="cursor:pointer;" readonly="readonly">
			                    <input type="hidden" id="shareScopeIds" name="shareScopeIds" value="${scopeIds}" />
			                    <input type="hidden" id="oldShareScopeIds" name="oldShareScopeIds" value="${scopeIds}" />
			                    <input type="hidden" id="bizImageUrl" name="bizImageUrl" value="${bizConfig.bizImageId}">
			                    <div class="" id="defalutImage" noWrap="" style="width: 32px; height: 32px; line-height: 14px; float: left;display: none;">
			                     <img src="/seeyon/main/skin/frame/harmony/menuIcon/common_second_5.png" style="">&nbsp;
			                    </div>
					       </div>
                            <div id="attachmentTR" style="display:none;"></div>
                            <div id="dyncid"></div>
				        </div>
				    </td>
				</tr>
			</table>
    </div>
    <div class="stadic_layout_body border_t clearfix over_hidden" style="top: 65px;bottom: ${empty param.from ? 30 : 0}px;padding-top: 5px;margin-left: 5px;">
        <div class="left" style="width: 60%;height: 95%;position: absolute;left: 0px;">
	            <div id = "parentTable" style="height: 100%;position: absolute;left: 0px; right:40px;">
					<div id="tabs" class="comp" comp="type:'tab',parentId:'parentTable',height:400">
				        <div id="tabs_head" class="common_tabs clearfix">
                            <ul class="left">
                                <c:forEach items="${typelist}" var="sourceType" varStatus="status">
                                <li id="${sourceType.id}_li" <c:if test="${status.first}"> class="current"</c:if> ><a href="javascript:changedTagType('${sourceType.URL}')" tgt="formapp"><span title="${sourceType.name}">${sourceType.name}</span></a></li>
                                </c:forEach>
				            </ul>
				    	</div>
				        <div id='tabs_body' class="common_tabs_body border_all">
							<iframe name="formapp" id="formapp" class="show"  border="0" width="100%" frameBorder="no"  height="370px" scrolling = "no"></iframe>
				        </div>
			    	</div>
		    	</div>
		    	<!-- 左右按钮 -->
		        <div class="right" style="position:absolute; right:3px; padding-top:200px; width:32px; height:32px;">
					<c:if test="${!view}">
						<p id="columnRight">
						    <span class="ico16 select_selected" onClick="selectToCreateMenu()"></span>
						</p>
						<br>
						<p id="columnLeft">
						    <span class="ico16 select_unselect" onClick="removeMenu()"></span>
						</p>
					</c:if>
		        </div>
        </div>
        <div class="right" style="width:40%; height: 95%;position: absolute;right: 0px;">
            <div style="height: 100%;position: absolute; left:0; right: 42px;">
				<div id="domain2" style="overflow: auto;width: 100%;height: 90%;" class="border_all">
					<c:forEach items="${bizConfig.items}" var="item">
						<%String random = "flowMenuType"+com.seeyon.ctp.util.UUIDLong.absLongUUID();%>
						<div id="tr<%=random%>" onclick="selectTrObj(this);" ondblclick="removeTrObj(this);" class="font_size12" name="menuItemTr">
						   <div class='clearfix' style="line-height: 20px;margin: 3px;">
							   <div class="left">
								   [${item.sourceTypeName}]
							   </div>
							   <div class="padding_l_5 left">
							         <div class="left" style="width: 160px;">
									 <div class="font_size12 common_txtbox_wrap" style="width: 150px;text-align: left;"><INPUT id="menuName" name="menuName" value="${item.name}" businessId="${item.sourceId}" class="validate" validate="name:'菜单名称',notNull:true,isWord:true,maxLength:15" type="text" /></div>
							         </div>
									<div class="left" style="display: inline-block;">
									<c:if test="${item.sourceType==1}">
										<label class='margin_l_5' sizset="false" for="<%=random%>1"><input type='radio' id="<%=random%>" disabled="disabled" name='<%=random%>' value='1' <c:if test="${item.flowMenuType==1}"> checked='checked' </c:if> />${ctp:i18n('common.toolbar.new.label')}</label>
										<label class='margin_l_5' sizset="false" for="<%=random%>2"><input type='radio' id="<%=random%>" disabled="disabled" name='<%=random%>' value='2' <c:if test="${item.flowMenuType==2}"> checked='checked' </c:if> />${ctp:i18n("imagenews.list.label") }</label>
									</c:if>
									</div>
									<INPUT id="sourceType" name="sourceType" value="${item.sourceType}" type="hidden" />
									<INPUT id="sourceId" name="sourceId" value="${item.sourceId}" type="hidden" />
									<INPUT id="menuId" name="menuId" value="${item.menuId}" type="hidden" />
									<INPUT id="formAppmainId" name="formAppmainId" value="${item.formAppmainId}" type="hidden" />
									<c:if test="${item.sourceType!=1}">
										<input id="<%=random%>" type='hidden' name="<%=random%>" value='0' />
									</c:if>
									<input type='hidden' sourceType='${item.sourceType}' businessId='${item.sourceId}' id='flowMenuTypeName' name='flowMenuTypeName' value='<%=random%>' />
							   </div>
						   </div>
						</div>
					</c:forEach>
				</div>
                <div id="domain3" style="width: 100%;height: 10%;margin-top: 10px;">
                    <div class="left" style="width: 110px;">
                        <label class="margin_r_5 hand" for="bizMerge">
                            <input id="bizMerge" name="bizMerge" type="checkbox" onclick="selectBizMerge()" ${bizConfig.bizMerge == '1' ? 'checked' : ''}>
                            ${ctp:i18n('bizconfig.flowtemplate.list')}
                        </label>
                    </div>
                    <div class="left common_txtbox_wrap" style="width: 210px;">
                        <input id="bizMergeName" name="bizMergeName" type="text" value="${bizConfig.bizMergeName}" defaultValue="${ctp:i18n('bizconfig.flowtemplate.list.merge1')}" class="validate" validate='avoidChar:"\\/|<>:*?\"",type:"string",name:"${ctp:i18n('bizconfig.flowtemplate.list.merge2')}",notNull:true,notNullWithoutTrim:true,maxLength:15' />
                    </div>
                </div>
            </div>
            <!-- 上下按钮 -->
	        <div class="left" style="position:absolute; right:10px; padding-top:200px; width:32px; height:32px;">
				<c:if test="${!view}">
					<p id="columnUp">
					    <span class="ico16 sort_up margin_l_5" onClick="moveMenu('up')"></span>
					</p>
					<br>
					<p id="columnDown">
					    <span class="ico16 sort_down margin_l_5" onClick="moveMenu('down')"></span>
					</p>
				</c:if>
	        </div>
        </div>
    </div>
    <c:if test="${empty param.from}">
    <div class="stadic_layout_footer page_color align_center" style="height: 30px;">
		<a id="sureBut" class="common_button common_button_gray margin_l_5">${ctp:i18n('common.button.ok.label')}</a>
		<a id="cancelBut" class="common_button common_button_gray margin_l_5" href="javascript:window.location.href='${path}/form/business.do?method=listBusiness';">${ctp:i18n('common.button.cancel.label')}</a>
    </div>
    </c:if>
</div>
</FORM>
<%@ include file="bizconfigNew.js.jsp" %>
</BODY>
</HTML>