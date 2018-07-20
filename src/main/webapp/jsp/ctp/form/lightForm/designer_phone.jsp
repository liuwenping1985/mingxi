<%--
 $Author: daiy $
 $Rev: 509 $
 $Date:: 2015-06-17 00:08:40#$:

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common_header.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=EDGE"/>
    <title>移动表单设计器</title>
    <script type="text/javascript" >
        // jsp上下文 必须在 jsclazz.js引入前执行
        var contextPath= '..';
    </script>
    <script type="text/javascript" src="${path}/common/form/lightFormDesigner/statics/js/3rd/jquery/jquery-1.7.2.js"></script>
    <script type="text/javascript" src="${path}/common/form/lightFormDesigner/statics/js/system/jsclazz.js"></script>
    <script type="text/javascript">
        com.Tool.debug = true;//调试模式配置
        com.Tool.PACKAGE_PREFIX = "com.seeyon.lightform"; //构建包以该值为前缀，多个以英文逗号个隔开
        com.Tool.AJAX_ACTION ="";//配置默认的ajax action处理url
    </script>
    <script type="text/javascript" src="${path}/common/form/lightFormDesigner/statics/js/system/biz-ext.js"></script>
    <script type="text/javascript" src="${path}/common/form/lightFormDesigner/statics/js/system/biz-ext-json.js"></script>
    <script type="text/javascript" src="${path}/common/form/lightFormDesigner/statics/js/system/pache.js"></script>
</head>
<body style="width: 100%;height: 100%;">
<div id='layout' class="comp" comp="type:'layout'">
    <div id="center" class="layout_center page_color over_hidden" layout="border:false">
        <div id="tabs2" class="comp" comp="type:'tab',width:300,height:1,parentId:'center'">
            <div id="tabs2_head" class="common_tabs clearfix">
                <ul class="left">
                    <c:forEach items="${viewList}" var="view" varStatus="status">
                        <c:if test="${status.first}">
                            <c:set var="firstView" value="${view.id}"/>
                        </c:if>
                        <li id="${view.id}_li" <c:if test="${status.first}"> class="current"</c:if>>
                            <a id="btn${status.index}" href="javascript:designPV('${view.id}')" tgt="formFlowFrame"><span>${view.formViewName}</span></a>
                        </li>
                    </c:forEach>
                </ul>
            </div>
            <div id='tabs2_body' class="common_tabs_body border_all">
                <iframe id="formFlowFrame" width="100%" height="100%" border="0" frameBorder="no" src=""></iframe>
            </div>
        </div>
        <div id="frameDiv" style="width: 100%;height: 100%">
            <iframe id="formFlowFrame" width="100%" height="100%" border="0" frameBorder="no" src=""></iframe>
        </div>
    </div>
</div>
</body>
<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
<script type="text/javascript" src="${path}/common/content/formCommon.js${ctp:resSuffix()}"></script>
<script type="text/javascript">
    var currentViewId = "";
    var currentRightId = "";
    var readOnly="${param.readOnly}";
    var ph = new phoneForm();
    var parentWin = window.opener;
    var param = {
        inputStatus:"new",
        formId:0,
        viewId:0,
        rightId:0,
        showTabs:false
    };

    /**
     * 从父窗口获取需要传入的参数
     *
     * 允许的属性：inputStatus=get 给infopath表单配置移动视图
     *                       new 用移动表单设计器新建表单
     *                       update 编辑移动表单设计器创建的表单
     *           formId 表单id
     *           formType 表单类型
     *           viewId 对应的视图id
     *           rightId 对应的权限id
     *           showTabs 是否显示多视图页签
     *           validateFunc 校验窗口是否有效
     **/
    var parentParam = parentWin.${param.function}();
    parentParam = $.extend(param, parentParam);
    $(document).ready(function () {
        var layout = $("#layout").layout();
        layout.setEast(0);
        layout.setWest(0);
        layout.setSouth(0);
        if (!isH5Brose()) {
            if (readOnly) {
                $("body").html("<div style='font-size: 12px'>请在 ie10、ie11、chrome、firefox等支持HTML5的浏览器上预览此视图！</div>");
            } else {
                alert("请在 ie10、ie11、chrome、firefox等支持HTML5的浏览器上使用此功能！");
                window.close();
            }
            return;
        }
        if(parentParam.showTabs) {
            $("#frameDiv").remove();
        } else {
            $("#tabs2").remove();
        }
        $("body").show();

        if(parentParam.viewId) {
            designInfoPathForm(parentParam.viewId, parentParam.rightId);
        } else {
            designP();
        }
        window.onunload = function() {
            if (parentWin.phoneFormCallback) {
                parentWin.phoneFormCallback(parentParam);
            }
        }
    });

    var specialFieldName = "${ctp:i18n('form.fielddesign.fieldcheck')}";

    /**
     * 为infopath创建的表单添加移动视图
     *
     *
     **/
    function designPV(viewId) {
        $.confirm({
            msg:"未保存的视图设置将会丢失，是否确认离开此页？",
            ok_fn:function() {
                designInfoPathForm(viewId, 0);
            },
            cancel_fn:function(){

            }
        });
    }

    function designInfoPathForm(viewId, rightId) {
        currentViewId = viewId;
        currentRightId = rightId;
        var obj = ph.convertFormViewBean2Design(viewId, rightId);
        if (obj && obj.success) {
            obj.paramData = (obj.data);
            com.seeyon.Global.setFormData(obj.data);
            com.seeyon.Global.deleteFunction = cancel4PVForm;
            com.seeyon.Global.saveFunction= function (data) {
                data.viewId = currentViewId;
                data.rightId = currentRightId;
                var result = ph.convertDesign2FormViewBean(data);
                if (result.success) {
                    $.confirm({msg:"视图设置保存成功！是否离开此页面?",
                        ok_fn:function(){
                            if (parentWin.phoneFormCallback) {
                                parentWin.phoneFormCallback(parentParam);
                            }
                            window.close();
                        },
                        cancel_fn:function(){

                        }});
                } else {
                    if (result.msg) {
                        $.alert(result.msg);
                    } else if (result.errorKey) {
                        $.alert($.i18n(result.errorKey));
                    }
                }
            };
            openIframe();
        } else {
            if (obj.msg) {
                $.alert(obj.msg);
            } else if (obj.errorKey) {
                $.alert($.i18n(obj.errorKey));
            }
        }
    }

    /**
     * 用移动表单设计器新建表单
     **/
    function designP() {
        var obj = {};
        obj.formType = "${param.formType}";
        var formId = "${param.formId}";
        if (formId) {
            obj.formId = formId;
        }
        obj.inputStatus = "${param.inputStatus}";
        var result = ph.getParam4PhoneView(obj);
        
        result.data.readOnly=readOnly;
        if(result.data.readOnly){
            result.data.buttons=[];
        }
        com.seeyon.Global.setFormData(result.data);
        com.seeyon.Global.validateFieldName = validateFieldNameOnChange;
        com.seeyon.Global.validateFieldNameAfter = validateFieldNameOnBlur;
        com.seeyon.Global.cancelFunction = cancel4PhoneForm;
        //表单名称修改时，校验方法
        com.seeyon.Global.validateFormName = function(data) {

            return true;
        };
        //表单名称 修改离开时，校验方法
        com.seeyon.Global.validateFormNameAfter = function(data) {

            if(data) {
                var reg = /[\\/|<>:*?;'&%$#"]/;
                if (data.match(reg)){
                    alert("表头名称不能包含这些特殊字符：\\/|<>:*?;'&%$#\"");
                    return false;
                }
            }
            return true;
        };

        com.seeyon.Global.nextFunction = function(data) {
            data.formId = obj.formId;
            data.formType = obj.formType;
            var result = ph.convertDesign2FormBean(data);
            if (result && result.success) {
//                window.opener.showMenu(_ctxPath + "/form/fieldDesign.do?method=baseInfo");
                if (parentWin.phoneFormCallback) {
                    parentWin.phoneFormCallback(parentParam);
                }
                window.close();
            } else {
                $.alert(result.msg);
            }
        };
        openIframe();
    }

    /**
     * 字段名称修改时的事件
     **/
    function validateFieldNameOnChange(obj) {
        return true;
    }

    /**
     * 字段名称修改后，焦点离开时事件
     **/
    function validateFieldNameOnBlur(currentName, obj) {
        if (currentName) {
            if (specialFieldName.indexOf("," + currentName + ",") != -1) {
                alert("字段名称不能是下列名称：" + specialFieldName.substr(1));
                return false;
            }
            var pattern = new RegExp("[`~!@#$^&*()=|{}':;',\\[\\].<>/?~！@#￥……&*（）;—|{}【】‘；：”“'。，、？]");
            if (pattern.test(currentName)) {
                alert("字段名称只能包含字母数字字符、下划线、连字符和句号，不能包含空格或其他特殊字符!");
                return false;
            }

            pattern = /^[a-zA-Z_\u4e00-\u9fa5]/;
            if (!pattern.test(currentName)) {
                alert("字段名称必须以字符或下划线开头!");
                return false;
            }
        }
        return true;
    }
    function fieldTitleRule(con) {

    }

    function openIframe(){
        document.getElementById("formFlowFrame").src = _ctxPath+"/common/form/lightFormDesigner/setFormIphone5s_biz_v_2_0.html";
    }

    /**
     * 取消按钮响应事件
     * infopath表单创建移动视图时
     **/
    function cancel4PVForm() {
        $.confirm({
            msg:"是否删除当前视图的移动视图设置？",
            ok_fn:function(){
                var result = ph.deletePhoneView4PCForm(currentViewId, currentRightId);
                dealResult(result,function(){
                    designInfoPathForm(currentViewId, currentRightId);
                    $.confirm({
                        msg:"移动视图删除成功，是否离开此页面？",
                        ok_fn:function(){
                            if (parentWin.phoneFormCallback) {
                                parentWin.phoneFormCallback(parentParam);
                            }
                            window.close();
                        }
                    });
                });
            },
            cancel_fn:function(){

            }
        });
    }

    function dealResult(result, callback) {
        if (result && result.success) {
            callback();
        } else {
            $.alert(result.msg);
        }
    }

    /**
     * 取消按钮响应事件
     * 移动表单使用
     **/
    function cancel4PhoneForm() {
        $.confirm({
            msg:"确认要离开此页吗？",
            ok_fn:function(){
                window.close();
            },
            cancel_fn:function(){

            }
        });
    }

    /*
     * 是否有重名
     */
    function validateFormName(formName){
        var fdManager = new formFieldDesignManager();
        var returnStr = fdManager.validateFormName(formName);
        if(returnStr=="-4"){
            //表单名称（）已在该单位中存在，请更换表单名
            $.alert($.i18n('form.base.formname.label') + "（"+$("#formName").val() + $.i18n('form.base.dataform.formname.error.label'));
            return false;
        }
        return true;
    }
</script>
</html>
