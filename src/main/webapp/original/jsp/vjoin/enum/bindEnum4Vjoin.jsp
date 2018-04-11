<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/common/INC/noCache.jsp"%>
<html class="h100b over_hidden">
<head>
<title>${ctp:i18n("selectPeople.page.title")}</title>
<script type="text/javascript">
    var parentWindow = parent;
    $(function() {
        function selectEnum(options) {
            options._window = window;
            var isFinalChild = options.isFinalChild;
            var bindId = options.bindId;
            var url = _ctxPath + '/enum.do?method=bindEnum&isfinal=1&isFinalChild=' + isFinalChild + '&bindId=' + bindId + '&isNeedImage=0';
            var dialog = $.dialog({
                id : 'SelectEnumDialog',
                url : url,
                width : 400,
                height : 450,
                title : '选择枚举',
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
                transParams : options,
                targetWindow : window,
                isFromModle : true,
                isHead : false,
                buttons : [ {
                    text : '${ctp:i18n("common.button.ok.label")}',
                    isEmphasize : true,
                    handler : function() {
                        var data = dialog.getReturnValue();
                        if (data) {
                            if (options.callback) {
                                options.callback(data);
                            }
                        }

                        var index = parentWindow.layer.getFrameIndex(window.name);
                        parentWindow.layer.close(index);
                    }
                }, {
                    text : '${ctp:i18n("common.button.cancel.label")}',
                    handler : function() {
                        var index = parentWindow.layer.getFrameIndex(window.name);
                        parentWindow.layer.close(index);
                    }
                } ]
            });

            dialog.maxfn();
            setTimeout(function() {
                var thisParent = $("#SelectPeopleDialog_main_iframe_content");
                var newWidth = thisParent.width() + 20;
                var newHeight = thisParent.height() + 20;
                thisParent.css({
                    "width" : newWidth,
                    "height" : newHeight
                });
            }, 100);
        }

        selectEnum(parentWindow.transParams);
    });
</script>
</head>
<body class="h100b over_hidden">
</body>
</html>