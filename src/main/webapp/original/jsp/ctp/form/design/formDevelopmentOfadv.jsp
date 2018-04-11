<%@ page language="java" pageEncoding="UTF-8" %>
<script type="text/javascript">
    function beforeSubmit(affairid, attitude, content, object, sucessCallback, failedCallBack) {
        //var r = new collaborationFormBindEventListener();

        //if (!r.achieveTaskType) {
            //sucessCallback();
            //return;
        //}
        
        //var taskType = r.achieveTaskType(affairid, attitude, content);
        var taskType = callBackendMethod("collaborationFormBindEventListener","achieveTaskType",affairid, attitude, content);
        //var taskType = callBackendMethod("formBindExtendClassEventListener","achieveTaskType",affairid, attitude, content);
        if (taskType) {
            var ds1;
            if ("ext" == taskType) {	//开发高级-扩展类
                //ds1 = r.preHandler(affairid, attitude, content);
                //ds1 = callBackendMethod("collaborationFormBindEventListener","preHandler",affairid, attitude, content);
                ds1 = callBackendMethod("formBindExtendClassEventListener","preHandler",affairid, attitude, content);
                
                if (ds1 && typeof (ds1) == "object") {
                    if (ds1[0] == '1') {	//数组下标[0]值为1代表扩展类，数组下标[0]值2代表DEE，有返回代表审核失败，返回null代表正常
                        if (object != null) {
                            object.close();
                        }
                        var extContent=ds1[1].replace(/[\r\n]/g, "");	//扩展类返回值
                        var dialog = $.dialog({
                            url: "${path}/genericController.do?ViewPage=ctp/form/design/eventTip&content="
                                    + encodeURIComponent(extContent),
                            title: "${ctp:i18n('dee.Development.Audit.Results')}",
                            width: 300,
                            height: 300,
                            closeParam: {show: false},
                            buttons: [
                                {
                                    text: "${ctp:i18n('dee.Development.Transfer.audit.opinion')}",
                                    id: "sure1",
                                    handler: function () {
                                        if (content != "") {
                                            content = content + "\r\n" + "-----------------------------" + "\r\n";
                                        }

                                        try{
                                            setContentDealComment(content + extContent);
                                        } catch (e) {
                                            
                                        }
                                        failedCallBack();
                                        dialog.close();
                                    }
                                },
                                {
                                    text: "${ctp:i18n('dee.button.cancel')}",
                                    id: "exit1",
                                    handler: function () {
                                        failedCallBack();
                                        dialog.close();
                                    }
                                }
                            ]
                        });
                    }
                }else{
                  sucessCallback();
                }
            } else if ("dee" == taskType) {
                executeDeeTask(null, affairid, attitude, content, null, "false", sucessCallback, failedCallBack);
            } else {
                sucessCallback();
            }
        } else {
            sucessCallback();
        }
    }

    function executeDeeTask(r, affairid, attitude, content, currentEventId, skipConcurrent, sucessCallback, failedCallBack) {
        //var ds1 = r.preDeeHandler(affairid, attitude, content, currentEventId, skipConcurrent);
        var ds1 = callBackendMethod("collaborationFormBindEventListener","preDeeHandler",affairid, attitude, content, currentEventId, skipConcurrent);
        if (ds1) {
            var blockFormWriteBackJson = ds1["blockFormWriteBackJson"];
            if (blockFormWriteBackJson) {
                var objs = blockFormWriteBackJson;
                // 兼容google浏览器需要下面这一句替换掉google浏览器添加的pre
                objs = objs.replace("<pre style=\"word-wrap: break-word; white-space: pre-wrap;\">", "").replace("</pre>", "").replace("<pre>", "");
                var _objs = $.parseJSON(objs);
                if (_objs.success == "true" || _objs.success == true) {
                    // 如果当前权限因为高级权限改变，则将改变后的权限id记录在页面中
                    if (_objs.viewRight != undefined && $("#rightId").val() != _objs.viewRight) {
                        $("#rightId").val(_objs.viewRight);
                        $("#img").removeClass("hidden").addClass("hidden");
                    }
                    _objs = _objs.results;
                    if(typeof formCalcResultsBackFill!="undefined"){
                        formCalcResultsBackFill(_objs);
                    }else if(document.getElementById("zwIframe")!=null){
                        document.getElementById("zwIframe").contentWindow.formCalcResultsBackFill(_objs);
                    }else{
                    	componentDiv.document.zwIframe.formCalcResultsBackFill(_objs);
                    }
              //      formCalcResultsBackFill(_objs);
                } else {
                    $.alert(_objs.errorMsg);
                }
            }

            var hasNext = ds1["hasNext"];
            var retSkipConcurrent = ds1["skipConcurrent"];
            var retCurrentEventId = ds1["currentEventId"];
            var blockInfoMsgType = ds1["blockInfoMsgType"];
            var blockInfoReason = ds1["blockInfoReason"];
            var exception = ds1["exception"];
            if (exception) {
                var dialog2 = $.dialog({
                    url: "${path}/genericController.do?ViewPage=ctp/form/design/eventTip&content="
                            + encodeURIComponent("DEE任务执行失败！"),
                    title: "${ctp:i18n('dee.Development.fail.info')}",
                    width: 350,
                    height: 100,
                    closeParam: {show: false},
                    buttons: [
                        {
                            text: "${ctp:i18n('dee.Development.button.close')}",
                            id: "exit1",
                            handler: function () {
                                if (failedCallBack && failedCallBack != "undefined") {
                                    failedCallBack();
                                }
                                dialog2.close();
                            }
                        }
                    ]
                });
            } else if (blockInfoMsgType == "error") {
                var dialog1 = $.dialog({
                    url: "${path}/genericController.do?ViewPage=ctp/form/design/eventTip&content="
                            + encodeURIComponent(blockInfoReason),
                    title: "${ctp:i18n('dee.Development.fail.info')}",
                    width: 350,
                    height: 100,
                    closeParam: {show: false},
                    buttons: [
                        {
                            text: "${ctp:i18n('dee.Development.button.close')}",
                            id: "exit1",
                            handler: function () {
                                if (failedCallBack && failedCallBack != "undefined") {
                                    failedCallBack();
                                }
                                dialog1.close();
                            }
                        }
                    ]
                });
            } else if (blockInfoMsgType == "info") {
                var dialog = $.dialog({
                    url: "${path}/genericController.do?ViewPage=ctp/form/design/eventTip&content="
                            + encodeURIComponent(blockInfoReason),
                    title: "${ctp:i18n('dee.Development.info')}",
                    width: 350,
                    height: 100,
                    closeParam: {show: false},
                    buttons: [
                        {
                            text: "${ctp:i18n('dee.button.ok')}",
                            id: "exit1",
                            handler: function () {
                                if (hasNext == "true") {
                                    executeDeeTask(null, affairid, attitude, content, retCurrentEventId, retSkipConcurrent, sucessCallback, failedCallBack);
                                } else {
                                    sucessCallback();
                                }
                                dialog.close(dialog.index);
                            }
                        }
                    ]
                });
            } else {
                if (hasNext == "true") {
                    executeDeeTask(null, affairid, attitude, content, retCurrentEventId, retSkipConcurrent, sucessCallback, failedCallBack);
                } else {
                    sucessCallback();
                }
            }
        }
    }
</script>