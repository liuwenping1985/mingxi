<%--
 $Author: lilong $
 $Rev: 32817 $
 $Date:: #$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page import="com.seeyon.ctp.privilege.enums.CustomResourceCategoryEnums"%>
<%@ page import="java.util.Map"%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/apps/privilege/menu/menuNew_js.jsp"%>
<html>
    
    <head>
        <title>
        </title>
    </head>
    
    <body>
        <div id='layout' class="comp" comp="type:'layout'">
            <div class="layout_center" id="center" layout="border:false">
                <div class="form_area" id='form_area'>
                    <div class="one_row">
                        <form id="myfrm" name="myfrm" method="post" action="resource.do?method=save">
                            <input type="hidden" id="id" />
                            <!-- 菜单的应用类型 -->
                            <input type="hidden" id="ext4" />
                            <table class="w90b over_hidden" align="center" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <th width="113px">
                                        <label class="margin_r_10" for="text">
                                            ${ctp:i18n('privilege.menu.name.label')}:
                                        </label>
                                    </th>
                                    <td>
                                        <div class="common_txtbox_wrap">
                                            <input type="text" id="name" class="validate w100b" validate="type:'string',name:'${ctp:i18n('privilege.menu.name.label')}',notNull:true,minLength:2,maxLength:20"
                                            />
                                        </div>
                                    </td>
                                </tr>
<%--                                 <tr>
                                    <th>
                                        <label class="margin_r_10" for="text">
                                            ${ctp:i18n('privilege.menu.picture.label')}:
                                        </label>
                                    </th>
                                    <td>
                                        <div class="common_txtbox_wrap">
                                            <input type="text" class="w100b" id="icon" />
                                            <input id="myfile" type="text" class="comp w100b" comp="type:'fileupload', applicationCategory:'1',  
                                            extensions:'jpg,jpeg,gif,bmp,png', isEncrypt:false,quantity:1, 
                                            canDeleteOriginalAtts:true, originalAttsNeedClone:false, firstSave:true">
                                        </div>
                                        <input id="selectButton" class="common_button common_button_gray" type="button" value="${ctp:i18n('privilege.menu.selectpic.label')}"
                                            onclick="insertAttachment('resCallBack');" />
                                    </td>
                                </tr> --%>
                                <tr>
                                    <th>
                                        <label class="margin_r_10" for="text">
                                            排序号:
                                        </label>
                                    </th>
                                    <td>
                                        <div class="common_txtbox_wrap">
                                            <input type="text" class="w100b" id="sortid" />
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th>
                                        <label class="margin_r_10" for="text">
                                            ${ctp:i18n('privilege.menu.isVirtualNode.label')}:
                                        </label>
                                    </th>
                                    <td>
                                        <div class="common_txtbox  clearfix">
                                            <input type="radio" id="target" name="target" value="1" <c:if test="${target eq 1 }"> checked="checked" </c:if> >${ctp:i18n('privilege.resource.true.label')}&nbsp;
                                            <input type="radio" id="target" name="target" value="0" <c:if test="${target eq 0 }"> checked="checked" </c:if> >${ctp:i18n('privilege.resource.false.label')}
                                        </div>
                                    </td>
                                </tr>
                                <tr class="istarget" style="display: none;">
                                    <th>
                                        <label class="margin_r_10" for="text">
                                            菜单打开方式:
                                        </label>
                                    </th>
                                    <td>
                                        <div class="common_txtbox  clearfix">
                                            <input type="radio" id="opentype" name="opentype" value="mainfrm" <c:if test="${opentype eq mainfrm }"> checked="checked" </c:if> >工作区
                                            <input type="radio" id="opentype" name="opentype" value="newWindow" <c:if test="${opentype eq newWindow }"> checked="checked" </c:if> >弹出窗口
                                        </div>
                                    </td>
                                </tr>
                                <tr class="istarget appResCategoryFornt" style="display: none;">
                                    <th>
                                        <label class="margin_r_10" for="text">
                                            ${ctp:i18n('privilege.menu.pageResName.label')}:
                                        </label>
                                    </th>
                                    <td>
                                        <div class="common_txtbox_wrap">
                                            <input type="hidden" id="enterResourceId" />
                                            <input type="text" class="validate w100b" id="enterResourceName" validate="type:'string',name:'${ctp:i18n('privilege.menu.pageResName.label')}',notNull:true"
                                            readonly="readonly" />
                                        </div>
                                        <input type="button" class="common_button common_button_emphasize" value="${ctp:i18n('privilege.resource.select.label')}"
                                        id="selectPageRes">
                                    </td>
                                </tr>
                                <tr class="istarget appResCategoryFornt" style="display: none;">
                                    <th>
                                        <label class="margin_r_10" for="text">
                                            ${ctp:i18n('privilege.menu.pageResUrl.label')}:
                                        </label>
                                    </th>
                                    <td>
                                        <div class="common_txtbox clearfix">
                                            <textarea rows="5" id="enterResourceUrl" class="w90b validate word_break_all"
                                            validate="type:'string',name:'${ctp:i18n('privilege.menu.pageResUrl.label')}',notNull:true,minLength:4,maxLength:200"
                                            readonly="readonly">
                                            </textarea>
                                        </div>
                                    </td>
                                </tr>
                                <tr class="appResCategoryShortCut" style="display: none;">
                                    <th>
                                        <label class="margin_r_10" for="text">
                                            ${ctp:i18n('privilege.menu.shortcutResName.label')}
                                        </label>
                                    </th>
                                    <td>
                                        <div class="common_txtbox_wrap">
                                            <input type="hidden" id="shortCutResourceId" />
                                            <input type="text" class="validate" id="shortCutResourceName" validate="type:'string',name:'${ctp:i18n('privilege.menu.shortcutResName.label')}',notNull:true,minLength:4,maxLength:20"
                                            readonly="readonly" />
                                        </div>
                                        <input type="button" value="${ctp:i18n('privilege.resource.select.label')}"
                                        id="selectShortCutRes">
                                    </td>
                                </tr>
                                <tr class="appResCategoryShortCut" style="display: none;">
                                    <th>
                                        <label class="margin_r_10" for="text">
                                            ${ctp:i18n('privilege.menu.shortcutResUrl.label')}:
                                        </label>
                                    </th>
                                    <td>
                                        <div class="common_txtbox clearfix">
                                            <textarea rows="5" id="shortCutResourceUrl" class="w100b validate word_break_all"
                                            validate="type:'string',name:'${ctp:i18n('privilege.menu.shortcutResUrl.label')}',notNull:true,minLength:4,maxLength:200"
                                            readonly="readonly">
                                            </textarea>
                                        </div>
                                    </td>
                                </tr>
                                <tr class="appResCategoryShortCut" style="display: none;">
                                    <th>
                                        <label class="margin_r_10" for="text">
                                            是否为默认快捷:
                                        </label>
                                    </th>
                                    <td>
                                        <div class="common_txtbox  clearfix">
                                            <input type="radio" id="shortcutdefult" name="shortcutdefult" value="1"
                                            <c:if test="${shortcutdefult eq 1 }"> checked="checked" </c:if> >${ctp:i18n('privilege.resource.true.label')}
                                            <input type="radio" id="shortcutdefult" name="shortcutdefult" value="0"
                                            <c:if test="${shortcutdefult eq 0 }"> checked="checked" </c:if> >${ctp:i18n('privilege.resource.false.label')}
                                        </div>
                                    </td>
                                </tr>
                                <input type="hidden" id="ext1" value="0" />
                            </table>
                            <iframe id="downLoadIFrame" name="downLoadIFrame" src="" style="display: none;"
                            />
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </body>

</html>