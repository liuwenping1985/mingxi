
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<html>
<head>
    <title></title>
    <script type="text/javascript">
        var dialogArgs = window.dialogArguments;
        var pWin = dialogArgs.win;//父窗口
        var indexItems = dialogArgs.indexItem;//已有的二级菜单
        var max = ${maxValue} || -1;//如果为空则说明不判断大小
        $(document).ready(function(){
            //加载的时候默认执行一次选择我创建的
            if (${!CurrentUser.admin}) {
                toShowQuerysFromUserOrAdmin("1");
            } else {//执行“本单位所有”
                toShowQuerysFromUserOrAdmin("2");
            }

            $("#queryWithName").click(function(){
                queryWithNameFun();
            });
            $("#queryBeanName").keyup(function(event) {
                if (event.keyCode == 13) {
                    queryWithNameFun();
                }
            });
            $("#select_selected").click(function(){
                addToRight();
            });
            $("#select_unSelect").click(function(){
                toDelete();
            });
            $('#up').click(function() {
                upOrDown("up");
            });
            $('#down').click(function() {
                upOrDown("down");
            });
            initData(indexItems);
        });

        //初始化数据
        function initData(obj){
            var selectedIndicator = $("#selectedIndicator");
            var _html = "";
            if(obj && obj.length > 0){
                for(var i = 0,len = obj.length;i<len;i++){
                    _html += '<option value="'+obj[i].id+'" queryBeanId="'+obj[i].queryBeanId+'" simpleStr="'+obj[i].simpleStr+'">'+obj[i].showTitle+'</option>';
                }
                selectedIndicator.append(_html);
            }else{
                if(obj.id){//父页面在formobj()方法的时候，如果只有一个时，不是数据，所以lenght为0，这里特殊处理一下
                    _html += '<option value="'+obj.id+'" queryBeanId="'+obj.queryBeanId+'" simpleStr="'+obj.simpleStr+'">'+obj.showTitle+'</option>';
                    selectedIndicator.append(_html);
                }
            }
        }

        //点击确认的操作
        function OK(){
            var objs = [];
            var selectObj =$("#selectedIndicator");
            $("option",selectObj).each(function(){
                var obj = {};
                obj.id = $(this).val();
                obj.showTitle = $(this).text();
                obj.queryBeanId = $(this).attr("queryBeanId");
                obj.simpleStr = $(this).attr("simpleStr");
                objs.push(obj);
            });
            return objs;
        }
        function upOrDown(nDir) {
            var selectedObj = $("#selectedIndicator").find("option:selected");
            if(selectedObj.length == 1){
                if(nDir == "up"){
                    if($("#selectedIndicator")[0].selectedIndex > 0){
                        var temp = $(selectedObj).prev();
                        temp.before(selectedObj);
                    }
                }else if(nDir == "down"){
                    if($("#selectedIndicator")[0].selectedIndex < ($("#selectedIndicator")[0].options.length-1)){
                        var temp = $(selectedObj).next();
                        temp.after(selectedObj);
                    }
                }
            }else if(selectedObj.length > 1){
                alert("${ctp:i18n('form.format.flowprocessoption.onlymoveone')}");
            }
        }

        /**
         * 数据域添加到右边框中
         */
        function addToRight(){
            var obj = document.getElementById('queryItemFrame').contentWindow.getSelectObject();
            var selectedIndicator = $("#selectedIndicator");
            var _html = "";
            var selected = $("option",selectedIndicator);
            var count = 0;//最多只能选择3个指标
            var hasTips = false;//只提示一次
            if(selected){
                count = selected.length;
            }
            if(obj && obj.length > 0){
                for(var i = 0,len = obj.length;i<len;i++){
                    if(max != -1 && count >=max){
                        if(!hasTips){
                            alert("${ctp:i18n_1('bizconfig.business.mobile.index.most.select.lable',maxValue)}");
                            hasTips = true;
                        }
                        continue;
                    }
                    var option = $("#selectedIndicator option[value='"+obj[i].id+"']");
                    if(option && option.length > 0){
                        //如果已存在直接忽略
                        continue;
                    }
                    count++;
                    _html += '<option value="'+obj[i].id+'" queryBeanId="'+obj[i].queryBeanId+'" simpleStr="'+obj[i].simpleStr+'">'+obj[i].showTitle+'</option>';
                }
            }
            selectedIndicator.append(_html);
        }

        /**
         * 从右边移除
         */
        function toDelete(){
            var selectedIndicator = $("#selectedIndicator");
            if(selectedIndicator && selectedIndicator[0].selectedIndex > -1){
                $("option",selectedIndicator).each(function(){
                    if($(this)[0].selected){
                        $(this).remove();
                    }
                });
            }
        }

        //点击我创建的和本单位所有的事件
        function toShowQuerysFromUserOrAdmin(type,reserve){
            $("#searchType").val(type);
            if(!reserve){//是否保留查询框的值
                $("#searchName").val("");
                $("#queryBeanName").val("");
            }
            $("#indexForm").jsonSubmit({
                targetWindow:document.getElementById('queryItemFrame').contentWindow
            });
        }
        //根据名字模糊匹配
        function queryWithNameFun(){
            $("#searchName").val($("#queryBeanName").val());
            var isAdmin = ${CurrentUser.admin};
            var type = "2";
            if(!isAdmin && $("#creator") && $("#creator")[0].checked){
                type = "1";
            }
            toShowQuerysFromUserOrAdmin(type,true);
        }
    </script>
</head>
<body class="font_size12">
<form id="indexForm" name="indexForm" method="post" action="${path}/form/business.do?method=editIndexItem" target="queryItemFrame" class="font_size12">
    <input type="hidden" id="searchType"/>
    <input type="hidden" id="searchName"/>
</form>
<div class="margin_t_20 margin_l_10" style="height: 360px;width: 580px;">
    <div class="left" id="selectItem" style="width:260px;height: 100%;">
        <div id="queryType" style="height: 30px;">
            <c:if test="${!CurrentUser.admin}">
            <!-- 我创建的 -->
            <label for="creator" class="font_size12">
                <input type="radio" id="creator" name="templatesRange" checked value="1" onClick="toShowQuerysFromUserOrAdmin('1')" />
                ${ctp:i18n("bizconfig.create.my") }
            </label>
            <!-- 本单位所有 -->
            <label for="account" class="font_size12">
                <input type="radio" id="account" name="templatesRange" value="2" onClick="toShowQuerysFromUserOrAdmin('2')" />
                ${ctp:i18n("bizconfig.create.all") }
            </label>
            </c:if>
        </div>
        <!-- 表单查询 -->
        <div style="line-height: 25px;height: 25px;margin-bottom: 5px;width: 260px;">
            ${ctp:i18n('bizconfig.business.mobile.query.template.label')}:
            <input type="text" id="queryBeanName"><span id="queryWithName" class="ico16 search_16"></span>
        </div>
        <div id="queryItem" style="height: 300px;overflow: hidden">
            <iframe id="queryItemFrame" name = "queryItemFrame" height="100%" width="100%" style="border: 0px;"></iframe>
        </div>
    </div>
    <div class="left" id="toRight" style="width:32px;padding-top: 150px;">
        <span id="select_selected" class="ico16 select_selected"></span>
        <br><br>
        <span id="select_unSelect" class="ico16 select_unselect"></span>
    </div>
    <div class="left" style="width: 240px;height: 360px;">
        <div style="height: 20px;line-height: 20px;">${ctp:i18n('formsection.config.column.category.selected') }</div>
        <div id="selectedArea" style="overflow: auto;height: 340px;" >
            <select class="border_all" id="selectedIndicator" ondblclick="toDelete()" multiple="multiple" style="width: 100%;height: 100%;"></select>
        </div>
    </div>
    <div class="left" style="width:32px;padding-top: 150px;">
        <span id="up"  class="ico16 sort_up"></span>
        <br><br>
        <span id="down"  class="ico16 sort_down"></span>
    </div>
</div>
</body>
</html>
