<%--
  Created by IntelliJ IDEA.
  User: daiy
  Date: 2014-11-10
  Time: 11:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html class="h100b">
<head>
    <title>${ctp:i18n('form.trigger.fix.data.title')}</title>
    <style>
        .static_right{
            float: right;
            width: 49%;
            height: 97%;
            text-align: right;
        }
        .static_left{
            width: 50%;
            float: left;
            height: 97%;
        }
        .static_top{
            height: 30px;
        }
    </style>
    <script type="text/javascript" src="${path}/ajax.do?managerName=formListManager,formTriggerManager"></script>
    <script type="text/javascript">
        $(document).ready(function(){
            setToolbar();

            $("#flowFrame").prop("src",getUrl("1"));
            $("#unFlowFrame").prop("src",getUrl("2,3"));
        });

        function getUrl(formtype){
            return "${path}/form/triggerDesign.do?method=fillBackDataFixFormList&formtype="+formtype;
        }

        function setToolbar(){
            $("#toolbar").toolbar({toolbar : [{
                id:"fixSelected",name:"${ctp:i18n('form.tirgger.fix.data.selected')}",click:fixSelected,className:"ico16 batch_16"
            },{
                id:"fixAll",name:"${ctp:i18n('form.trigger.fix.data.all')}",click:fixAll,className:"ico16 batch_16"
            },{
                id:"dataList",name:"数据列表",click:showData,className:"ico16 batch_16"
            }]});
        }

        function showData() {
            var flowId = getSelectedIds($("#flowFrame"));
            var formId;
            if (flowId) {
                if (flowId.indexOf(',') > 0) {
                    $.alert("一次只能选择一个表单，请重新选择！");
                    return;
                }
                formId = flowId;
            }
//            if (!formId && unFlowId) {
//                if (unFlowId.indexOf(',') > 0) {
//                    $.alert("一次只能选择一个表单，请重新选择！");
//                    return;
//                }
//                formId = unFlowId;
//            }
            if (formId) {
                var dialog = $.dialog({
                    url:"${path}/form/triggerDesign.do?method=showDataList&formId="+formId,
                    title : "表单数据列表",
                    transParams:window,
                    targetWindow:getCtpTop(),
                    width:1000,
                    height:500,
                    buttons:[{
                        text : "${ctp:i18n('form.trigger.triggerSet.confirm.label')}",
                        id:"sure",
                        handler : function() {
                            dialog.close();
                        }
                    }]
                });
            } else {
                $.alert("请选择需要展现列表的流程表单！");
            }
        }

        function fixSelected(){
            var flowId = getSelectedIds($("#flowFrame"));
            var unFlowId = getSelectedIds($("#unFlowFrame"));
            if(!flowId && !unFlowId){
                $.alert("${ctp:i18n('form.trigger.fix.data.selected.must')}");//请选择需要修改的表单！
                return;
            }
            fixData(flowId,unFlowId,unFlowId.length==0);
        }

        function getSelectedIds(table){
            return table[0].contentWindow.getSelectedIds();
        }

        function fixAll(){
            fixData("","",true);
        }

        function fixData(flowId,unFlowId,isAll){
            var manager = new formTriggerManager();
            $.confirm({
                'msg': "${ctp:i18n('form.trigger.fix.data.do')}",
                ok_fn:function(){
                    var progress = new MxtProgressBar({text: "${ctp:i18n('form.trigger.fix.data.doing')}"});
                    manager.doFillBackDataFix(flowId,unFlowId,isAll,{
                        success:function(msg){
                            progress.close();
                            if (!msg){
                                $.infor("${ctp:i18n('form.trigger.fix.data.done')}");
                            } else {
                                $.alert(msg);
                            }
                        }
                    });
                }
            });
        }
    </script>
</head>
<body class="h100b over_hidden">
    <div class="stadic_layout h100b">
        <div class="stadic_layout_head static_top">
            <div id="toolbar" class="f0f0f0"></div>
        </div>
        <div class="static_left border_r">
            <iframe id="flowFrame" frameborder="0" style="width:100%;height:100%;"></iframe>
        </div>
        <div class="static_right border_l">
            <iframe id="unFlowFrame" frameborder="0" style="width:100%;height:100%;"></iframe>
        </div>
    </div>
</body>
</html>
