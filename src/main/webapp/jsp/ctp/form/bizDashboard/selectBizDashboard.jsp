<%--
  Created by IntelliJ IDEA.
  User: wangh
  Date: 2017/1/3
  Time: 10:51
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
    <title>选择移动看板</title>
</head>
<script type="text/javascript">
    var dialogArgs = window.dialogArguments;
    var dashboard = dialogArgs.dashboard;
    $(document).ready(function(){
        //查询我的看板
        $("#creator").click(function(){
            queryByType(1);
        });
        //查询全单位的看板
        $("#account").click(function(){
            queryByType(2);
        });
        $("#select_selected").click(function(){
            addToRight();
        });
        $("#select_unSelect").click(function(){
            toDelete();
        });
        $("#dashboardItem").dblclick(function(){
            addToRight();
        });
        $("#selectedDashboard").dblclick(function(){
            toDelete();
        });
        $("#creator").trigger("click");
        if(dashboard && dashboard.dashboardId){
            $("#selectedDashboard").html("<option value='"+dashboard.dashboardId+"'>"+dashboard.dashboardName+"</option>");
        }
    });

    //查询看板
    function queryByType(type){
        var itemArea = $("#dashboardItem");
        itemArea.empty();
        var bizDashboard = new bizDashboardManager();
        var result = bizDashboard.getDashboardByType(type);
        if(result.items){
            var items = $.parseJSON(result.items);
            var _html = "";
            for(var i = 0,len = items.length;i<len;i++){
                _html += '<option value="'+items[i].id+'">'+items[i].name+'</option>'
            }
            $(itemArea).html(_html);
        }
    }
    //点击确认的操作
    function OK(){
        var objs = [];
        var selectObj =$("#selectedDashboard");
        $("option",selectObj).each(function(){
            var obj = {};
            obj.dashboardId = $(this).val();
            obj.dashboardName = $(this).text();
            objs.push(obj);
        });
        return objs;
    }
    /**
     * 数据域添加到右边框中
     */
    function addToRight(){
        var selectedObj = $("#selectedDashboard");
        var dashboardItem = $("#dashboardItem");
        var _html = "";
        var leftSelect =  $("option:selected",dashboardItem);
        //(selected && selected.length > 0) ||
        if(leftSelect && leftSelect.length > 1){
            $.alert("${ctp:i18n('biz.dashboard.only.choose.one.label')}");
            return;
        }
        if(!leftSelect || leftSelect.length == 0){
            return;
        }
        //清空已选的，直接替换
        selectedObj.empty();
        if(leftSelect && leftSelect.length > 0){
            for(var i = 0,len = leftSelect.length;i<len;i++){
                _html += '<option value="'+leftSelect[i].value+'">'+leftSelect[i].text+'</option>';
            }
        }
        selectedObj.append(_html);
    }

    /**
     * 从右边移除
     */
    function toDelete(){
        var selectedDashboard = $("#selectedDashboard");
        if(selectedDashboard && selectedDashboard[0].selectedIndex > -1){
            $("option",selectedDashboard).each(function(){
                if($(this)[0].selected){
                    $(this).remove();
                }
            });
        }
    }
</script>
<body class="font_size12">
<div class="margin_t_20 margin_l_20" style="height: 360px;width: 580px;">
    <div class="left" id="selectItem" style="width:270px;height: 100%;">
        <div id="queryType" style="height: 30px;">
            <!-- 我创建的 -->
            <label for="creator" class="font_size12">
                <input type="radio" id="creator" name="templatesRange" checked value="1"/>
                ${ctp:i18n("bizconfig.create.my") }
            </label>
            <!-- 本单位所有 -->
            <label for="account" class="font_size12">
                <input type="radio" id="account" name="templatesRange" value="2"/>
                ${ctp:i18n("bizconfig.create.all") }
            </label>
        </div>
        <div id="dashboardArea" style="height: 330px;overflow: auto">
            <select class="border_all" id="dashboardItem" multiple="multiple" style="width: 100%;height: 100%;"></select>
        </div>
    </div>
    <div class="left" id="toRight" style="width:32px;padding-top: 150px;">
        <span id="select_selected" class="ico16 select_selected"></span>
        <br><br>
        <span id="select_unSelect" class="ico16 select_unselect"></span>
    </div>
    <div class="left" style="width: 250px;height: 360px;">
        <div style="height: 30px;line-height: 30px;">${ctp:i18n('formsection.config.column.category.selected') }</div>
        <div id="selectedArea" style="overflow: auto;height: 330px;" >
            <select class="border_all" id="selectedDashboard" multiple="multiple" style="width: 100%;height: 100%;"></select>
        </div>
    </div>
</div>
</body>
</html>
