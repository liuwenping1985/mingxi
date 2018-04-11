<%--
  Created by IntelliJ IDEA.
  User: wangh
  Date: 2016-3-7 0007
  Time: 17:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
    <title>移动业务首页设计</title>
</head>
<body>
<form method="post" action="" >
    <div class = "font_size12 clearfix" style="height:507px;color:#333333;-webkit-text-size-adjust:none;">
        <input type="hidden" id="mobileBizConfigId" name="mobileBizConfigId"/>
        <!-- 左边 -->
        <div class="left" id="left" style="width:300px;height: 507px;margin-top:7px;margin-top:7px;margin-left:20px;overflow-y: auto;border:1px solid darkgray;">
            <div style="height: 96%;width:100%;width:300px;">
                <!-- 二级菜单 -->
                <div id="domain2" style="overflow-y: auto;overflow-x: auto;height: 89%;width:300px;"></div>
                <!-- 全选 -->
                <div id="selectAllDiv" class="margin_l_20" style="height: 30px;line-height: 30px;margin-top: 5px;">
                    <div class="left">
                        <label class="hand" for="selectAll">
                            <input id="selectAll" name="selectAll" type="checkbox" onclick="selectAllMenu()">
                            ${ctp:i18n('bizconfig.business.mobile.select.all.label')}
                        </label>
                    </div>
                </div>
                <!-- 是否合并 -->
                <div id="domain3" class="margin_l_20" style="height: 30px;">
                    <div class="left" style="width: 100px;line-height: 30px;">
                        <label class="hand" for="bizMerge">
                            <input id="bizMerge" name="bizMerge" type="checkbox" onclick="selectBizMerge()">
                            ${ctp:i18n('bizconfig.flowtemplate.list')}
                        </label>
                    </div>
                    <div class="left common_txtbox_wrap" style="width: 140px;">
                        <input id="bizMergeName" name="bizMergeName" type="text" defaultValue="${ctp:i18n('bizconfig.flowtemplate.list.merge1')}"  readonly="readonly"/>
                    </div>
                </div>
            </div>
        </div>
        <!-- 占位div -->
        <div class="left" style="width:26px;">&nbsp;</div>
        <!-- 右边 -->
        <div class="left" style="width:315px;height: 493px;border-radius:6px;overflow-y: hidden;padding:7px;margin-top:7px;background:#dfdfdf;border: 1px solid #b9babc;">
            <div id="right" style="overflow-y: auto;border: 0px solid darkgray;background:#ffffff;">
                <!-- 广告 -->
                <div id="adArea" style="overflow: hidden;height: 130px;" class="border_b">
                    <div id="bizConfigNameDiv" class="bg_color_blueLight" style="width: 100%;height: 30px;background: #4a90e2;" align="center">
                        <span id="bizConfigName" style="height: 30px;line-height: 30px;font-size: 14px;color: #ffffff;"></span>
                    </div>
                    <div id="viewAdImage" style="height: 100px;position:relative;">
                        <div id="disPlayImage"></div>
                        <div style="z-index: 9999;position: absolute;right: 10px;bottom: 10px;"><span id="editAdImage" title="${ctp:i18n('bizconfig.business.mobile.select.image.label')}" class="ico16 mobile_editor_16"></span></div>
                    </div>
                    <div class="" id="defalutAdImage" value="adImage1.png" isSystem="1" noWrap="" style="width: 350px; height: 100px; float: left;display: none;">
                        <img src="/seeyon/common/form/bizconfig/images/adImage1.png" style="width: 100%; height: 100%;">&nbsp;
                    </div>
                    <div id="recentAdList" class="hidden"></div>
                </div>
                <div>
                    <!-- 指标栏 -->
                    <div id="indexArea" class="left" style="overflow: hidden;height: 40px;position:relative;border-bottom: 1px solid #cccccc;width: 80%;">
                        <div id="indexItem" style="height: 40px;text-align: center;color: #333333;" ></div>
                        <div style="z-index: 9999;position: absolute;right: 0px;bottom: 2px;"><span id="editIndex" title="${ctp:i18n('bizconfig.business.mobile.set.index.title')}" class="ico16 mobile_editor_16"></span></div>
                    </div>
                    <!-- 看板 -->
                    <div id="dashboardArea" class="left" style="overflow: hidden;height: 40px;position:relative;border-bottom: 1px solid #cccccc;width: 20%;">
                        <div id="bizDashboard" style="height: 40px;text-align: center;color: #333333;border-left: 1px solid #cccccc;" ></div>
                        <div style="z-index: 9999;position: absolute;right: 0px;bottom: 2px;"><span id="editDashboard" title="${ctp:i18n('bizconfig.business.mobile.set.dashboard.title')}" class="ico16 mobile_editor_16"></span></div>
                    </div>
                    <div class="clear"></div>
                </div>
                <!-- 二级菜单入口 -->
                <div id="menuArea" style="overflow-y: auto;overflow-x:hidden;height: 320px;"></div>
                <div id="recentIconList" class="hidden"></div>
            </div>
        </div>
    </div>
</form>
<%@ include file="bizConfigSetMobileHome.js.jsp" %>
</body>
</html>
