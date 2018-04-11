<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<!DOCTYPE html>
<html class="h100b over_hidden">
<head>
<title>${ctp:i18n("vjoinPortal.label.infoportal")}</title>
<%@ include file="/WEB-INF/jsp/vjoin/common/common_header.jsp"%>
<link rel="stylesheet" href="${path}/apps_res/vjoin/portal/mobileDesigner/common/depend/jqueryUI/css/jquery-ui.min.css${ctp:resSuffix()}">
<link rel="stylesheet" href="${path}/apps_res/vjoin/portal/mobileDesigner/common/depend/bootstrap/css/bootstrap.css${ctp:resSuffix()}">
<link rel="stylesheet" href="${path}/apps_res/vjoin/portal/mobileDesigner/common/depend/colorPicker/css/colorpicker.css${ctp:resSuffix()}">
<link rel="stylesheet" href="${path}/apps_res/vjoin/portal/mobileDesigner/css/mobileDesigner.css${ctp:resSuffix()}">
</head>
<body class="h100b over_hidden">
    <div class="layout-allArea designerWrapper">
    <div class="layout-topArea">
        <div class="layui-tab layui-tab-brief mainLayout">
            <ul class="layui-tab-title custom-tab-title">
                <li class="layui-this">${ctp:i18n("vjoinPortal.label.infoportal")}</li>
            </ul>
        </div>
    </div>
    <div class="layout-centerArea">
        <div class="section">
            <div class="g1">
                <div class="g2">
                    <div class="mobile-designer-centerArea" id="designerCenterArea">
                        <div class="mobileContentArea">
                            <div class="columnList" id="columnList">
                                <ul>
                                    <div class="middle-title"></div>
                                    <div id="colTop" class="columnSection">
                                        <div id="columnRow0" class="connectedSortable"></div>
                                        <li class="li_dropIn" link_div = '0'>${ctp:i18n("vjoinPortal.label.leftdrag")}</li>
                                    </div>
                                </ul>
                            </div>
                        </div>
                        <div class="mobileContentAreaBottom">
                        	<div class="btn-group">
					            <%--<button type="button" class="btn vjoin-btn-default" id="button_preview">预览</button>--%>
                                <button type="button" class="btn vjoin-btn-default" id="button_reset" style="display: none">${ctp:i18n("vjoinPortal.label.reset2def")}</button>
                            </div>
                            <div class="btn-group" style="float:right;">
                                <button type="button" class="btn vjoin-btn-default" id="button_cancel">${ctp:i18n("vjoinPortal.btn.cancel")}</button>
                            </div>
					        <div class="btn-group" style="float:right;">
					            <button type="button" class="btn vjoin-btn-default" id="button_submit">${ctp:i18n("vjoinPortal.btn.ok")}</button>
					        </div>
                        </div>
                    </div>
                </div>
                <div class="designer-leftArea" id="designerLeftArea">
                    <div class="contentArea ">
                        <div class="leftTopArea"><i></i>${ctp:i18n("vjoinPortal.label.optionalcolumn")}</div>
                        <div class="elementList" id="elementList">
                            <ul>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%--<div class="designer-rightArea layui-tab" id="designerRightArea">--%>
            <%--<div class="contentArea layui-tab-title">--%>
                <%--<div class="rightTopArea"><i></i>属性设置</div>--%>
                <%--<div class="rightContent">--%>
                <%--</div>--%>
            <%--</div>--%>
        <%--</div>--%>
        <div class="designer-rightArea" id="designerRightArea">
            <div id='sectionAlert' style='top: 0;left: 0;display: none;position: absolute;width: 100%;z-index: 1;padding-top: 40px'>
                <div class='alert alert-warning' role='alert' style='text-align:center;padding: 10px'>
                </div>
            </div>
            <div class="layui-tab  layui-tab-card" lay-filter="rightTab" style="height: 100%">
                <ul class="layui-tab-title" style="margin-bottom: 0;">
                    <li class="rightTopArea sectionConfig" lay-id="tab1"><i></i>${ctp:i18n("vjoinPortal.label.propertysetting")}</li>
                    <li class="rightTopArea basicConfig layui-this" lay-id="tab2"><i></i>${ctp:i18n("vjoinPortal.label.basicinfo")}</li>
                </ul>
                <div class="layui-tab-content" style="padding: 0">
                    <div class="layui-tab-item rightContent" id="sectionConfigDiv">
                    </div>
                    <div class="layui-tab-item rightContent layui-show" id="basicConfigDiv">
                        <form id="basicConfigForm">
                            <div class="row rightContentRow" id="sectionTitle">
                                <div class="col-md-12 rightContentRowLeft" style="font-size: 16px;font-weight: bold">
                                    <span>${ctp:i18n("vjoinPortal.label.spaceinfo")}</span>
                                    <hr align="center" width="100%" color="#666666" size="2" style="margin:0">
                                </div>
                            </div>
                            <div class="row rightContentRow">
                                <div class="col-md-4 rightContentRowLeft"><span>${ctp:i18n("vjoinPortal.label.spacename")}</span>:</div>
                                <div class="col-md-8 rightContentRowRight" valuetype="2">
                                    <input type="text" id="basic_name" name="basic_name" >
                                </div>
                            </div>
                            <div class="row rightContentRow">
                                <div class="col-md-4 rightContentRowLeft"><span>${ctp:i18n("vjoinPortal.label.spacetype")}</span>:</div>
                                <div class="col-md-8 rightContentRowRight" valuetype="0">
                                    <select id="basic_type" name="basic_type" disabled>
                                        <option value="00" selected></option>
                                        <option value="31">${ctp:i18n("vjoinPortal.label.spacetype31")}</option>
                                        <option value="32">${ctp:i18n("vjoinPortal.label.spacetype32")}</option>
                                        <option value="33">${ctp:i18n("vjoinPortal.label.spacetype33")}</option>
                                        <option value="35">${ctp:i18n("vjoinPortal.label.spacetype35")}</option>
                                        <option value="36">${ctp:i18n("vjoinPortal.label.spacetype36")}</option>
                                        <option value="37">${ctp:i18n("vjoinPortal.label.spacetype37")}</option>
                                    </select>
                                </div>
                            </div>
                            <div class="row rightContentRow" id="accessDiv">
                                <div class="col-md-4 rightContentRowLeft" style="padding-right: 0;"><span>${ctp:i18n("vjoinPortal.label.spaceaccess")}</span>:</div>
                                <div class="col-md-8 rightContentRowRight" valuetype="9" style="">
                                    <input type="text" id="basic_accessStr" name="basic_accessStr" def_val="source"
                                        data-url="/portal/portalController.do?method=bannerImageSet"
                                        base-url="/portal/portalController.do?method=bannerImageSet">
                                    <input type="hidden" id="basic_access" name="basic_access">
                                    <div id="canPushDiv" class="checkbox" style="display: none">
                                        <label for="basic_check_0">
                                            <input type="checkbox" id="basic_check_0" name="basic_check" value="0">${ctp:i18n("vjoinPortal.label.spaceaccesscheck1")}<font style="color: #5584ff">（${ctp:i18n("vjoinPortal.label.spaceaccesscheck1desc")}）</font>
                                        </label>
                                    </div>
                                    <div id="canPersonalDiv" class="checkbox" style="display: none">
                                        <label for="basic_check_1">
                                            <input type="checkbox" id="basic_check_1" name="basic_check" value="1">${ctp:i18n("vjoinPortal.label.spaceaccesscheck2")}
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div class="row rightContentRow">
                                <div class="col-md-4 rightContentRowLeft"><span>${ctp:i18n("vjoinPortal.label.spacestate")}</span>:</div>
                                <div class="col-md-8 rightContentRowRight" valuetype="0">
                                    <div class="col-md-12">
                                        <div class="radio">
                                            <label for="basic_state_0" style="padding-right: 50px">
                                                <input type="radio" id="basic_state_0" name="basic_state" value="0" checked>${ctp:i18n("vjoinPortal.label.spacestart")}
                                            </label>
                                            <label for="basic_state_1">
                                                <input type="radio" id="basic_state_1" name="basic_state" value="1">${ctp:i18n("vjoinPortal.label.spacestop")}
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row rightContentRow">
                                <div class="col-md-4 rightContentRowLeft"><span>${ctp:i18n("vjoinPortal.label.sort")}</span>:</div>
                                <div class="col-md-8 rightContentRowRight" valuetype="2">
                                    <input type="text" id="basic_sortId" name="basic_sortId" checkval="min=0" check="isInteger" value="${sortNum}">
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
<%--栏目的tpl模板--%>
<script id="columnTpl" type="text/html">
    <li sectionType="middle" id="columnSection_{{d.id}}">
        <div class="layout-column">
            <input type="hidden" value="{{d.items[0].sectionId}}_{{d.id}}">
            <div class='mobile-close' style='position: absolute' onclick="javascript:removeMiddleLi('{{d.id}}')">
                X
            </div>
            <div class="middleSection-text" sectionFrom='middle' onclick="javascript:loadRight('{{d.id}}','{{d.items[0].sectionId}}')">{{ d.items[0].name }}</div>
        </div>
    </li>
</script>
<%@ include file="/WEB-INF/jsp/vjoin/common/common_footer.jsp"%>
<script type="text/javascript" src="${path}/apps_res/vjoin/portal/mobileDesigner/common/depend/jqueryUI/js/jquery-ui.min.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/vjoin/portal/mobileDesigner/common/depend/bootstrap/js/bootstrap.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/vjoin/portal/mobileDesigner/common/depend/colorPicker/js/colorpicker.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/vjoin/portal/mobileDesigner/js/designerTools.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/vjoin/portal/mobileDesigner/js/mobileDesigner.js${ctp:resSuffix()}"></script>
<script type="text/javascript" src="${path}/apps_res/vjoin/portal/mobileDesigner/js/sectionTools.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
    var spaceType = "${spaceType}";
    var mobileSpacePath = "${mobileSpacePath}";
    var decorationId = "${decorationId}";

    var isNew = "${isNew}";
    var spaceCategory = "${spaceCategory}";
    var spaceId = "${spaceId}";
    var space = '${space}';
    var allowDefined = '${allowDefined}';
    var allowPushed = '${allowPushed}';
    var accessStr = '${accessStr}';
    var accessIds = '${accessIds}';

    $(document).ready(function(){
        /* 右侧选项卡 */
        (function () {
            layui.use('element', function(){});
            initFunction();
            $("#basic_type").val(spaceType);
//            if(spaceCategory === "m3"){
//                $("#canPersonalDiv").show();
//            }
            if(isNew === "modify" && (spaceType === "31" || spaceType === "33" || spaceType === "35" || spaceType === "37")){
                $("#button_reset").show();
            }
            if(spaceType === "33" || spaceType === "37"){
                $("#canPushDiv").show();
            }
            if(spaceType === "31"||spaceType==="35"){
                $("#accessDiv").hide();
                $("#basic_state_0").prop("checked",true);
                $("[name='basic_state']").prop("disabled",true);
            }
        })();

        /* 右侧基本信息设置事件 */
        (function(){
            $("#basic_accessStr").click(function () {
                var selectedVal = $("#basic_access").val();

                $.SeeyonSelectPeople({
                    panels: 'Department,Post,Level,Team,Outworker',
                    selectType: 'Account,Member,Department,Post,Level',
                    minSize: 0,
                    onlyLoginAccount: true,
                    targetWindow: getA8Top(),
                    params: {
                        value: selectedVal
                    },
                    callback: function(ret) {
                        $("#basic_accessStr").val(ret.text);
                        $("#basic_access").val(ret.value);
                    }
                });
            });
        })();
    });
</script>
</html>