<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html style="width: 100%;height: 100%;">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>移动看板制作</title>
</head>
<style>
    .section{
        border: 1px dashed #cdcdcd;
        margin: 10px;
        background-color: #ffffff;
    }
    .currentSection{
        border: 1px dashed #42b3e5;
        margin: 10px;
        background-color: #ffffff;
    }
    .duplicateSection{
        border: 1px dashed #cd181f;
        margin: 10px;
    }
    .fontColor{
        color: #42b3e5;
    }
    .highlight{
        background-color: #e2f2fa;
        color:#42b3e5;
    }
</style>
<script type="text/javascript" src="${path}/common/form/bizDashboard/newBizDashboard.js${ctp:resSuffix()}"></script>
<BODY style="width: 100%;height: 100%;">
<FORM name="bizDashboardForm" id="bizDashboardForm" method="post" target="main" class="form_area" style="width: 100%;height: 100%;">
    <div class="stadic_layout over_hidden">
        <div class="stadic_layout_head" style="height: 50px;background-color: #fafafa;border-bottom: 1px solid #dcdbdb;">
            <table id="domain1" align="center" border="0" width="100%">
                <tr style="width: 1000px;">
                    <td style="width: 300px">
                        <div class="clearfix" style="width: 300px">
                            <div class="left" style="line-height: 26px;text-align: right;margin-left: 10px;">
                                <!-- 看板名称 -->
                                <label class="font_size12"><font color="red">*</font>${ctp:i18n("form.biz.mobile.dashboard.editname") }：</label>
                            </div>
                            <div class="left" style="width: 150px;">
                                <div class="font_size12 common_txtbox_wrap" style="width: 150px;text-align: left;">
                                    <input type="text" id="bizDashBoardName" name="bizDashBoardName" title="${bizDashboard.name}" value="${bizDashboard.name}"  class="validate" validate="avoidChar:'\&#39;&quot;&lt;&gt;!\\/|@#$%^&*(){}[]',type:'string',name:'${ctp:i18n('form.biz.mobile.dashboard.editname') }',notNull:true,maxLength:15,notNullWithoutTrim:true">
                                </div>
                            </div>
                        </div>
                    </td>
                    <td style="width: 280px"  nowrap="nowrap">
                        <div class="clearfix" style="width: 280px">
                            <div class="left" style="line-height: 26px;padding-left: 10px;">
                                <!-- 使用者授权 -->
                                ${ctp:i18n("bizconfig.use.authorize.label") }：
                            </div>
                            <div class="left common_txtbox_wrap" style="width: 150px;text-align: left;">
                                <input type="hidden" name="bizDashboardId" id="bizDashboardId" value="${bizDashboard.id}">
                                <!-- new:新增，update：修改 -->
                                <input type="hidden" name="type" id="type" value="${type}"/>
                                <input type="text" name="shareScope" id="shareScope" value="${scopeNames}" style="cursor:pointer;width: 120px;" readonly="readonly">
                                <input type="hidden" id="shareScopeIds" name="shareScopeIds" value="${scopeIds}" />
                                <input type="hidden" id="oldShareScopeIds" name="oldShareScopeIds" value="${scopeIds}" />
                            </div>
                        </div>
                    </td>
                    <td style="width: 400px"  nowrap="nowrap">
                        <div class="clearfix" style="width: 300px">
                            <div class="left" style="line-height: 26px;">
                                <!-- 所属人 -->
                                <label class="margin_l_10 ">${ctp:i18n("form.base.affiliatedsortperson.label")}：</label>
                            </div>
                            <div class="left common_txtbox_wrap" style="width: 150px;text-align: left;">
                                <input type="text" id="ownerName" name="ownerName" class="padding_l_5" readonly="readonly" value="${createUserName}" style="cursor: pointer;width:118px"/>
                                <input type="hidden" id="ownerId" name="ownerId" readonly="readonly" value="${bizDashboard.createUser}"/>
                            </div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <div class="stadic_layout_body clearfix over_hidden" style="top: 50px;bottom: 0px;margin-top: 10px;margin-left: 5px;">
            <div class="left" style="width: 55%;height: 98%;position: absolute;left: 0px;">
                <div id = "parentTable" style="height: 100%;position: absolute;left: 0px; right:40px;">
                    <div id="tabs" class="comp" comp="type:'tab',parentId:'parentTable',height:370">
                        <div id="tabs_head" class="common_tabs clearfix">
                            <ul class="left">
                                <c:forEach items="${allSectionTypeList}" var="sourceType" varStatus="status">
                                    <li id="${sourceType.id}_li" editUrl="${sourceType.editUrl}" <c:if test="${status.first}"> class="current"</c:if> ><a href="javascript:changedTagType('${sourceType.URL}')" tgt="formapp" style="padding: 0 4px;"><span title="${sourceType.name}">${sourceType.name}</span></a></li>
                                </c:forEach>
                            </ul>
                        </div>
                        <div id='tabs_body' class="common_tabs_body border_all">
                            <iframe name="formapp" id="formapp" class="show"  border="0" width="100%" frameBorder="no"  height="100%" scrolling = "no"></iframe>
                        </div>
                    </div>
                </div>
                <!-- 左右按钮 -->
                <div class="right" style="position:absolute; right:4px; padding-top:200px; width:32px; height:32px;">
                        <p id="columnRight">
                            <span class="ico16 select_selected" onClick="selectSection()"></span>
                        </p>
                        <br>
                        <p id="columnLeft">
                            <span class="ico16 select_unselect" onClick="removeSection()"></span>
                        </p>
                </div>
            </div>
            <div class="right" style="width:45%; height: 95%;position: absolute;right: 0px;">
                <div style="height: 100%;position: absolute; left:0; right: 40px;">
                    <div id="domain2" style="overflow: auto;width: 100%;height: 425px;background-color: #fafafa;border: none;">
                        <c:forEach items="${sectionList}" var="item">
                            <div id="tr${item.id}" onclick="markSection(this)" ondblclick="removeTrObj(this);" onmouseenter="triggerEditIcon(this,1)" onmouseleave="triggerEditIcon(this,0)" class="font_size12 section">
                                <div id="content${item.id}" class='clearfix' style="line-height: 20px;margin: 5px;position: relative;">
                                    <div class="left" id="title"><label>${item.sectionName}</label></div>
                                    <div name="editIcon" style="z-index: 9999;position: absolute;right: 2px;bottom: 2px;display: none"><span class="ico16 task_edit_16" onclick="editSectionEven(this)"></span></div>
                                    <div class="padding_l_5 left">
                                        <input id="sourceType" name="sourceType" value="${item.sourceType}" type="hidden" />
                                        <input id="sourceId" name="sourceId" value="${item.sourceId}" type="hidden" />
                                        <input id="sectionId" name="sectionId" value="${item.id}" type="hidden" />
                                        <input id="formId" name="formId" value="${item.formId}" type="hidden" />
                                        <input id="editUrl" name="editUrl" value="${item.editUrl}" type="hidden" />
                                        <input id='sectionContent' name='sectionContent' value='${item.sectionContent}' type='hidden'/>
                                        <input id="valid" name="valid" value="${item.extraMap.valid}" type="hidden"/>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                <!-- 上下按钮 -->
                <div class="left" style="position:absolute; right:11px; padding-top:200px; width:32px; height:32px;">
                        <p id="columnUp">
                            <span class="ico16 sort_up margin_l_5" onClick="moveSection('up')"></span>
                        </p>
                        <br>
                        <p id="columnDown">
                            <span class="ico16 sort_down margin_l_5" onClick="moveSection('down')"></span>
                        </p>
                </div>
            </div>
        </div>
    </div>
</FORM>
</BODY>
</HTML>