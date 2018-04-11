<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/common/INC/noCache.jsp"%>
<html class="h100b over_hidden">
<head>
<title>${ctp:i18n("selectPeople.page.title")}</title>
<script text="text/javascript">
    var parentWindow = parent;

    $(function() {
        function selectPeople(options) {
            options._window = window;
            var url = _ctxPath + '/selectpeople.do?showAllAccount=true';
            var dialog = $.dialog({
                id: 'SelectPeopleDialog',
                url: url,
                width: 680,
                height: 470,
                title: '${ctp:i18n("selectPeople.page.title")}',
                isDrag: false,
                panelParam: {
                    'show': false
                },
                maxParam: {
                    'show': false
                },
                minParam: {
                    'show': false
                },
                closeParam: {
                    'show': false
                },
                transParams: options,
                targetWindow: window,
                isFromModle: true,
                isHead: false,
                buttons: [{
                    text: '${ctp:i18n("common.button.ok.label")}',
                    isEmphasize: true,
                    handler: function() {
                        var data = dialog.getReturnValue();
                        if (data == -1) {
                            return;
                        }

                        if (data) {
                            var elements = data.obj;
                            var ret = {
                                value: getIdsString(elements),
                                text: getNamesString(elements)
                            }

                            if (options.callback) {
                                options.callback(ret);
                            }
                        }

                        var index = parentWindow.layer.getFrameIndex(window.name);
                        parentWindow.layer.close(index);
                    }
                }, {
                    text: '${ctp:i18n("common.button.cancel.label")}',
                    handler: function() {
                        var index = parentWindow.layer.getFrameIndex(window.name);
                        parentWindow.layer.close(index);
                    }
                }]
            });

            dialog.maxfn();
            setTimeout(function() {
                var thisParent = $("#SelectPeopleDialog_main_iframe_content");
                var newWidth = thisParent.width() + 20;
                var newHeight = thisParent.height() + 20;
                thisParent.css({
                    "width": newWidth,
                    "height": newHeight
                });
            }, 100);
        };

        selectPeople(parentWindow.transParams);
    });
</script>
</head>
<body class="h100b over_hidden">
</body>
</html>