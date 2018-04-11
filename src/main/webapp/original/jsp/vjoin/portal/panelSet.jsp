<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/common/INC/noCache.jsp"%>
<html class="h100b over_hidden">
<head>
<title></title>
<script text="text/javascript">
    var parentWindow = parent;
    var paramValue = "";
    $(function() {
        function setPanelValue(options) {
            var id = options.id;
            var spaceType = options.spaceType;
            var entityId = options.entityId;
            var ordinal = options.ordinal;
            var setUrl = options.setUrl;
            var panelValue = options.panelValue;
            paramValue = options.paramValue;
            if (!setUrl) {
                return;
            }
            setUrl = setUrl + "&spaceType=" + spaceType + "&entityId=" + entityId + "&ordinal=" + ordinal + "&panelValue=" + panelValue + "&accountId=${accountId}&from=Vjoin";
            var valueDialog = $.dialog({
                id : id,
                url : setUrl,
                width : 590,
                height : 470,
                title : '',
                isDrag : false,
                panelParam : {
                    'show' : false
                },
                maxParam : {
                    'show' : false
                },
                minParam : {
                    'show' : false
                },
                closeParam : {
                    'show' : false
                },
                transParams : paramValue,
                targetWindow : window,
                isFromModle : true,
                isHead : false,
                buttons : [ {
                    text : $.i18n('common.button.ok.label'),
                    isEmphasize : true,
                    handler : function() {
                        var rv = valueDialog.getReturnValue();
                        var value = "";
                        if (rv && rv != null && rv == "closeDefault") {
                            alert($.i18n("section.hasNoSet"));
                            return;
                        } else if (rv && rv != null) {
                            if (rv.length == 0) {
								alert($.i18n("space.must.chooseone"));
                                return;
							}
                            if (rv.length > 0) {
                                //兼容应用磁贴没有勾选的情况
                                if (rv[0].length < 1||rv[0][0]===null|| (rv[0].length == 1 && rv[0][0] === '|undefined|0')) {
                                    alert($.i18n("space.must.chooseone"));
                                    return;
                                }
                                if (rv[0].length > 100) {
                                    alert($.i18n("portal.prompt.overselect", 100));
                                    return;
                                }
                                if (setUrl.indexOf("/form/business.do?method=editIndexItem&from=bizDashboard&maxValue=-1") != -1) {//表单综合指标栏目-副指标回填
                                    value = JSON.stringify(rv);
                                } else if (setUrl.indexOf("/form/business.do?method=editIndexItem&from=bizDashboard&maxValue=1") != -1) {//表单综合指标栏目-主指标回填
                                    value = JSON.stringify(rv[0]);
                                } else {
                                    if (typeof rv[0] === 'object') {
                                        value = rv[0];
                                    } else if (typeof rv[0] === 'string') {
                                        value = rv[0].join(",");
                                    }
                                }
                            } else {
                                if (setUrl.indexOf("/form/bizDashboard.do?method=setLink") != -1) {//表单综合指标栏目-栏目链接
                                    value = JSON.stringify(rv);
                                    if(value === "{}"){
                                        value = "";
                                    }
                                }
                            }
                        }
                        if(rv !=null){
                            options.callback(value);
                            var index = parentWindow.layer.getFrameIndex(window.name);
                            parentWindow.layer.close(index);
                        }
                    }
                }, {
                    text : $.i18n('common.button.cancel.label'),
                    handler : function() {
                        var index = parentWindow.layer.getFrameIndex(window.name);
                        parentWindow.layer.close(index);
                    }
                } ]
            });
            valueDialog.maxfn();
        }
        setPanelValue(parentWindow.transParams);
    });
</script>
</head>
<body class="h100b over_hidden">
</body>
</html>