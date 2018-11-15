<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<script type="text/javascript">
    var dialogArgs = window.dialogArguments;
    var pWin = dialogArgs.win;//父窗口
    var domain2 = dialogArgs.domain2;//已有的二级菜单
    var domain3 = dialogArgs.domain3;//PC端的合并列表信息
    var bizConfigName = dialogArgs.bizConfigName;//业务配置名称
    var mobileConfig = dialogArgs.mobileConfig;//已回填的移动业务配置信息
    var isFirst = mobileConfig?false:true;
    var initToRight = [];//新建时需要写到右边的，先放到一个集合，统一填写，好判断表单分类的情况(表单分类后面没有菜单，则不显示在右边)
    var rightMenu = [];//右边已经选择的菜单，针对已设置移动首页的，如果已经选择二级菜单的话。
    var catgs = [];
    <c:forEach items="${typeList}" var="type" varStatus="status">
        var obj = {};
        obj.key = "${type.key}";
        obj.text = "${type.text}";
        obj.pcKey = "${type.pcKey}";
        var icons = [];
        <c:forEach items="${type.icon}" var="oneIcon" varStatus="image">
            icons.push("${oneIcon}");
        </c:forEach>
        obj.icon = icons;
        catgs.push(obj);
    </c:forEach>
    $(document).ready(function() {
        $("iframe",window.parent.document).attr("scrolling","no");
        if(bizConfigName){
            $("#bizConfigName").html(bizConfigName);
        }

        $("#editAdImage").click(function(){
            editAdImageFun(this);
        });
        $("#editIndex").click(function(){
            editIndexFun(this);
        });
        $("#editDashboard").click(function(){
            editDashboardFun(this);
        });
        //为每个菜单绑定事件
        $(document).on("click","span[id^=icon]",function(){
            editIconFun(this);
        });
        $("#disPlayImage").html($("#defalutAdImage").clone().show());///默认的广告图片

        init();

        //流程列表合并
        new inputChange($("#bizMergeName"), "${ctp:i18n('bizconfig.flowtemplate.list.merge1')}", "color_gray");
        $("#bizMerge").attr("disabled", true);
        $("#bizMergeName").attr("disabled", true);

        //首次进入的时候，全选按钮勾上
        if(isFirst){
            $("#selectAll").prop("checked",true);
            $("#selectAll").attr("checked",true);
        }
    });
    //初始化
    function init(){
        if(domain3.bizMerge == "1"){
            $("#bizMerge").prop("checked","checked");
            $("#bizMerge").attr("checked","checked");
            $("#bizMergeName").val(domain3.bizMergeName);
        }
        //先加载已有的菜单信息，方便初始化左侧列表的勾选情况
        if(mobileConfig){
            var param = $.parseJSON(mobileConfig);
            if(param.id){
                $("#mobileBizConfigId").val(param.id)
            }
            //广告
            var adImageId = param.adImageId;
            if(adImageId){
                var custom = param.custom;
                var img = $("img","#disPlayImage");
                var disDiv = $("#defalutAdImage","#disPlayImage");
                $(disDiv).attr("value",adImageId).attr("isSystem",custom);//回填需要提交的值
                var url = "";
                if(custom == "2" || custom == 2){//自定义上传
                    url = _ctxServer+'/fileUpload.do?method=showRTE&fileId=' + adImageId + '&type=image';
                }else{//系统预置
                    url = "/seeyon/common/form/bizconfig/images/"+adImageId;
                }
                $(img).attr("src",url);
                if(custom == 2){
                    var recentDiv = $("#recentAdList");
                    recentDiv.append($('<input type="hidden" name="customAdList" value="'+adImageId+'"/>'));
                }
            }
            //指标
            var indicatorObj = param.indicatorItems;
            if(indicatorObj){
                initIndexItem(indicatorObj,true);
            }
            //初始化看板
            var dashboardObj = param.dashboard;
            if(dashboardObj){
                initDashboard(dashboardObj);
            }
            //菜单
            var menuObj = param.menuItems;
            if(menuObj){
                for(var i = 0;i<menuObj.length;i++){
                    if(isValidMenu(menuObj[i].menuId)){
                        var title = findMenuTitle(menuObj[i].menuId);
                        if(title){
                            menuObj[i].title = title;
                        }else{
                            menuObj[i].title = menuObj[i].menuName;
                        }
                        var obj = {};
                        obj.menuId = menuObj[i].menuId;
                        obj.menuName = menuObj[i].menuName;
                        obj.sourceType = menuObj[i].sourceType;
                        obj.custom = menuObj[i].custom;
                        obj.iconId = menuObj[i].iconId;//默认的图片
                        obj.title = menuObj[i].title;
                        rightMenu.push(obj);
                        //selectMenuToRight(menuObj[i]);
                        if(menuObj[i].custom == 2){
                            var recentDiv = $("#recentIconList");
                            recentDiv.append($('<input type="hidden" name="customIconList'+menuObj[i].sourceType+'" value="'+menuObj[i].iconId+'"/>'));
                        }
                    }
                }
            }
        }
        var domain2Obj = $("#domain2");
        if(domain2 && domain2.length>0){
            for(var i = 0,len = domain2.length;i<len;i++){
                //业务模块中配置的业务导图菜单不在此出现，调查,讨论也过滤掉
                if(domain2[i].sourceType == "17" || domain2[i].sourceType == "10" || domain2[i].sourceType == "14"
                || domain2[i].sourceType == "9" || domain2[i].sourceType == "13"){
                    continue;
                }
                domain2Obj.append(contactTheDiv(domain2[i]));
            }
        }
        if(isFirst){
            for(var i = 0,len = initToRight.length;i<len;i++){
                selectMenuToRight(initToRight[i]);
            }
        }else{
            $("input[id^='checkbox']",$("#domain2")).each(function(){
                if($(this)[0].checked){
                    dealRelation(this,true);
                }
            });
        }
    }

    //加载已有菜单时，在右侧菜单中查找title
    function findMenuTitle(menuId){
        var title;
        if(domain2){
            for(var i = 0,len = domain2.length;i<len;i++){
                if(menuId == domain2[i].menuId){
                    title = domain2[i].title;
                    break;
                }
            }
        }
        return title;
    }

    //修改的时候判断右侧菜单是否还在左侧可选列表中
    function isValidMenu(menuId){
        var result = false;
        if(domain2){
            for(var i = 0,len = domain2.length;i<len;i++){
                if(menuId == domain2[i].menuId){
                    result = true;
                    break;
                }
            }
        }
        return result;
    }

    //将每一个pc端的二级菜单转换为移动端的
    var leftMenu = 1;//用来确认菜单的位置
    function contactTheDiv(obj){
        var menuName = obj.menuName;
        var sourceType = obj.sourceType;
        var sourceId = obj.sourceId;//应用绑定id
        var menuId = obj.menuId;
        var formAppmainId = obj.formAppmainId;//表单id
        var flowMenuType = obj.flowMenuType;//判断流程是新建还是列表的id
        var title = obj.title;
        var oTr = document.createElement('div');
        var needCheck = false;//默认全部勾选
        if(isFirst){//新增时
            needCheck = true;
        }else{//修改时先判断右侧是否已经有该菜单了
            for(var i = 0;i< rightMenu.length;i++){
                if(rightMenu[i].menuId == menuId){
                    needCheck = true;
                    break;
                }
            }
            //var rightMenu = $("#menu"+menuId,"#menuArea");
            //if(rightMenu && $(rightMenu).attr("id")){
            //    needCheck = true;
            //}
        }
        var idStr = random();
        oTr.id = idStr;
        oTr.className = "font_size12";
        var catg = "";
        var iconId;
        if(sourceType == "1"){
            if(flowMenuType == "2"){
                sourceType = "21";
            }
        }
        for(var i = 0,len = catgs.length;i<len;i++){
            if(sourceType == catgs[i].key){
                catg = catgs[i].text;
                iconId = catgs[i].icon[0];
                break;
            }
        }
        //为了清晰，特意缩进保持div的格式
        var _html = "";
        _html +="<div id='div"+idStr+"' title='" + title + "' index='"+leftMenu+"' class='clearfix padding_l_20' style='line-height: 20px;margin: 3px;white-space:nowrap;'>";
            _html += '<label class="hand" for="checkbox'+idStr+'"><input id="checkbox'+idStr+'" onclick="dealRelation(this)" type="checkbox" value="1"'+(needCheck?"checked":"")+'/>';
            _html += "<span style='padding-left:3px'>["+catg+"]</span>";
            _html += "<span style='padding-left:3px'>"+menuName;+"</span>";
            _html += "<input type='hidden' id='menuName' name='menuName' value='" + menuName + "'/>";
            _html += "<input type='hidden' id='sourceType' name='sourceType' value='" + sourceType + "'/>";
            _html += "<input type='hidden' id='menuId' name='menuId' value='" + menuId + "'/>";
            _html += "<input type='hidden' id='iconId' name='iconId' value='" + iconId + "'/>";
            _html += "</label>"
        _html += "</div>";
        leftMenu++;
        $(oTr).html(_html);
        $(oTr).css("height","20px");//ie8下没有设置高度的时候，每一行撑得很高
        $(oTr).css("margin-bottom","10px");
        if(isFirst){//默认全部勾选，且设置到右边的菜单栏
            var param = {};
            param.menuName = menuName;
            param.sourceType = sourceType;
            param.menuId = menuId;
            param.custom = "1";
            param.iconId = iconId;//默认的图片
            param.title = title;
            initToRight.push(param);
            //selectMenuToRight(param);
        }
        return oTr;
    }
    function random() {
        var random = getUUID();
        return random;
    }
    //checkbox点击事件
    // 左侧菜单个数 leftMenu-1 个
    function dealRelation(obj,hasRight){
        var item = $(obj).parent().parent();
        if($(obj).attr("checked")){//选中
            var param = {};
            param.menuName = $("#menuName",item).val();
            param.sourceType = $("#sourceType",item).val();
            param.menuId = $("#menuId",item).val();
            param.custom = "1";
            param.iconId = $("#iconId",item).val();//默认的图片
            //如果是修改的时候，右侧已经有菜单了，取右侧菜单的图标和是否自定义标识
            if(hasRight && rightMenu){
                for(var i = 0;i< rightMenu.length;i++){
                    if(rightMenu[i].menuId == param.menuId){
                        param.iconId = rightMenu[i].iconId;
                        param.custom = rightMenu[i].custom;
                        break;
                    }
                }
            }
            param.title = $(item).attr("title");
            var nextMenuId = findNextCheckedMenu($(item).attr("index"));
            selectMenuToRight(param,nextMenuId);
        }else{//取消选中
            var idStr = $("#menuId",item).val();
            var oneMenu = $("div[id$='"+idStr+"']","#menuArea");
            if(oneMenu){
                oneMenu.remove();
            }
        }
    }
    //找到下一个选择的menu，以便将本菜单放在这个之前，如果没找到，则在末尾追加。
    function findNextCheckedMenu(index){
        var menuId;
        for(var i = parseInt(index)+1;i<leftMenu;i++){
            var div = $("div[index="+i+"]","#domain2");
            var checkbox = $("input[id^='checkbox']",div);
            if($(checkbox).attr("checked")){
                menuId = $("#menuId",div).val();
                break;
            }
        }
        return menuId;
    }
    //编辑广告图片
    function editAdImageFun(obj){
        var param = {};
        var idStr = $(obj).parent().parent().attr("id");
        var selectedImg = $("#defalutAdImage","#disPlayImage").attr("value");
        param.id = idStr;
        param.win = window;
        param.selectedImg = selectedImg;
        param.fielId = getCustomImage("recentAdList","customAdList");
        var dialog = $.dialog({
            url:_ctxPath + "/form/business.do?method=editImage&type=ad",
            title : $.i18n('bizconfig.business.mobile.select.image.label'),
            width:400,
            height:300,
            targetWindow:getCtpTop(),
            transParams:param,
            buttons : [{
                text : $.i18n('form.trigger.triggerSet.confirm.label'),//确定
                id:"sure",
                isEmphasize: true,
                handler : function() {
                    var result = dialog.getReturnValue();
                    if(result){
                        var imageId = result.imageId;
                        var custom = result.custom;
                        var uploadImgs = result.uploadImgs;
                        if(imageId){
                            var img = $("img","#disPlayImage");
                            var disDiv = $("#defalutAdImage","#disPlayImage");
                            $(disDiv).attr("value",imageId).attr("isSystem",custom);//回填需要提交的值
                            var url = "";
                            if(custom == "2" || custom == 2){//自定义上传
                                url = _ctxServer+'/fileUpload.do?method=showRTE&fileId=' + imageId + '&type=image';
                            }else{//系统预置
                                url = "/seeyon/common/form/bizconfig/images/"+imageId;
                            }
                            $(img).attr("src",url);
                            //处理自定义上传的图片
                            if(uploadImgs){
                                var recentDiv = $("#recentAdList");
                                for(var i = 0,len = uploadImgs.length;i<len;i++){
                                    recentDiv.append($('<input type="hidden" name="customAdList" value="'+uploadImgs[i]+'"/>'));
                                }
                            }
                        }
                        dialog.close();
                    }
                }
            }, {
                text : $.i18n('form.query.cancel.label'),
                id:"exit",
                handler : function() {
                    dialog.close();
                }
            }]
        });
    }

    //获取已上传的广告图片或者菜单图标，仅限本次编辑范围的，没有关闭移动业务配置页面之前的（不入库）
    function getCustomImage(id,name){
        var obj = [];
        $("input[name='"+name+"']","#"+id).each(function(){
            obj.push($(this).val());
        });
        return obj;
    }

    /**
     * 选择移动看板
     */
    function editDashboardFun(){
        var param = {};
        var dashboard = $("#bizDashboard").formobj();
        param.win = window;
        param.dashboard = dashboard;
        var dialog = $.dialog({
            url:_ctxPath + "/form/bizDashboard.do?method=selectBizDashboard",
            title : $.i18n('bizconfig.business.mobile.set.dashboard.title'),
            width:600,
            height:400,
            targetWindow:getCtpTop(),
            transParams:param,
            buttons : [{
                text : $.i18n('form.trigger.triggerSet.confirm.label'),//确定
                id:"sure",
                isEmphasize: true,
                handler : function() {
                    var result = dialog.getReturnValue();
                    if(result[0]){
                        initDashboard(result[0]);
                    }else{
                        $("#bizDashboard").empty();
                    }
                    dialog.close();
                }
            }, {
                text : $.i18n('form.query.cancel.label'),
                id:"exit",
                handler : function() {
                    dialog.close();
                }
            }]
        });
    }

    /**
     * 回填业务看板
     * @param obj
     */
    function initDashboard(obj){
        var bizDashboard = $("#bizDashboard");
        bizDashboard.empty();
        if(obj){
           var _html = '<div class="left border_l" title="'+obj.dashboardName+'" style="text-align: center;white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">' +
                    '<div style="height: 40px;line-height: 40px;padding-left: 2px;"><span>'+obj.dashboardName+'</span></div>' +
                    '<input type="hidden" id="dashboardName" value="'+obj.dashboardName+'" />'+
                    '<input type="hidden" id="dashboardId" value="'+obj.dashboardId+'" />'+
                    '</div>';
            bizDashboard.append(_html);
        }
    }

    //编辑指标
    function editIndexFun(obj){
        var param = {};
        var idStr = $(obj).parent().parent().attr("id");
        var indexItems = $("#indexItem").formobj();
        param.id = idStr;
        param.win = window;
        param.indexItem = indexItems;
        var dialog = $.dialog({
            url:_ctxPath + "/form/business.do?method=editIndexItem&maxValue=3",
            title : $.i18n('bizconfig.business.mobile.set.index.title'),
            width:600,
            height:400,
            targetWindow:getCtpTop(),
            transParams:param,
            buttons : [{
                text : $.i18n('form.trigger.triggerSet.confirm.label'),//确定
                id:"sure",
                isEmphasize: true,
                handler : function() {
                    var result = dialog.getReturnValue();
                    initIndexItem(result,true);
                    dialog.close();
                }
            }, {
                text : $.i18n('form.query.cancel.label'),
                id:"exit",
                handler : function() {
                    dialog.close();
                }
            }]
        });
    }

    //回填指标项
    //如果只设置了1个指标项，则居中显示，设置了2个则对半显示，设置了3个则均分显示
    function initIndexItem(obj,needClear){
        var indexItem = $("#indexItem");
        if(needClear){
            indexItem.html("");
        }
        var _html = "";
        if(obj && obj.length > 0){
            var len = obj.length;
            var width = $("#indexItem").width();
            if(len != 1){
                width = width/len -2;
            }
            for(var i = 0;i<len;i++){
                _html += '<div class="left border_l" title="'+obj[i].showTitle+'" style="text-align: center;width:'+width+'px;height:40px;display:block;white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">' +
                        '<div style="height: 20px;"><span>'+obj[i].simpleStr+'</span></div>' +
                        '<div style="height: 20px;"><span>'+obj[i].showTitle+'</span></div>' +
                        '<input type="hidden" id="showTitle" value="'+obj[i].showTitle+'" />'+
                        '<input type="hidden" id="id" value="'+obj[i].id+'" />'+
                        '<input type="hidden" id="queryBeanId" value="'+obj[i].queryBeanId+'" />'+
                        '<input type="hidden" id="simpleStr" value="'+obj[i].simpleStr+'" />'+
                        '</div>';
            }
            indexItem.append(_html);
        }

    }
    //编辑菜单图标
    function editIconFun(obj){
        var param = {};
        var menuId = $(obj).attr("menuId");
        var menuDiv = $("div[id$='"+menuId+"']","#menuArea");
        var sourceType = $(menuDiv).attr("sourcetype");
        var selectedImg = $(menuDiv).attr("value");
        var idStr = $(obj).attr("id");
        param.id = idStr;
        param.win = window;
        param.selectedImg = selectedImg;
        param.fielId = getCustomImage("recentIconList","customIconList"+sourceType);
        var dialog = $.dialog({
            url:_ctxPath + "/form/business.do?method=editImage&type=icon&width=55&sourceType="+sourceType,
            title : $.i18n('bizconfig.business.mobile.select.icon.label'),
            width:400,
            height:300,
            targetWindow:getCtpTop(),
            transParams:param,
            buttons : [{
                text : $.i18n('form.trigger.triggerSet.confirm.label'),//确定
                id:"sure",
                isEmphasize: true,
                handler : function() {
                    var result = dialog.getReturnValue();
                    if(result){
                        var imageId = result.imageId;
                        var custom = result.custom;
                        var uploadImgs = result.uploadImgs;
                        if(imageId){
                            var img = $("img",menuDiv);
                            var url = "";
                            $(menuDiv).attr("value",imageId).attr("isSystem",custom);//回填需要提交的值
                            if(custom == "2" || custom == 2){//自定义上传
                                url = _ctxServer+'/fileUpload.do?method=showRTE&fileId=' + imageId + '&type=image';
                            }else{//系统预置
                                url = "/seeyon/common/form/bizconfig/images/"+imageId;
                            }
                            $(img).attr("src",url);
                            //处理自定义上传的图片
                            if(uploadImgs){
                                var recentDiv = $("#recentIconList");
                                for(var i = 0,len = uploadImgs.length;i<len;i++){
                                    recentDiv.append($('<input type="hidden" name="customIconList'+sourceType+'" value="'+uploadImgs[i]+'"/>'));
                                }
                            }
                        }
                        dialog.close();
                    }
                }
            }, {
                text : $.i18n('form.query.cancel.label'),
                id:"exit",
                handler : function() {
                    dialog.close();
                }
            }]
        });
    }
    //将左边的菜单添加到右边
    //<div style="z-index: 9999;position: absolute;right: 2px;bottom: 2px;"><span id="editIndex" class="ico16 mobile_editor_16"></span></div>
    function selectMenuToRight(obj,nextMenuId){
        var iconId = obj.iconId;
        var custom = obj.custom;
        var imgUrl;
        if(custom == 2 || custom == "2"){
            imgUrl = _ctxServer+'/fileUpload.do?method=showRTE&fileId=' + iconId + '&type=image';
        }else{
            imgUrl = '/seeyon/common/form/bizconfig/images/'+iconId;
        }
        var menuArea = $("#menuArea");
        var targetDiv;
        if(nextMenuId){
            targetDiv = $("#menu"+nextMenuId,menuArea);
        }
        //div的id和编辑图片的id均以菜单id结尾，编辑的回调处用。
        if(obj.sourceType == "15"){//菜单分类时，单独创建一行
            var category = $('<div title="'+obj.title+'" id="menu'+obj.menuId+'" menuId="'+obj.menuId+'" menuName="'+obj.menuName+'" sourceType="'+obj.sourceType+'" class="left" style="background:#f6f8fa;margin-top:10px;height: 24px;width:100%;line-height: 24px;">&nbsp;&nbsp;'+obj.menuName+'</div>');
            if(targetDiv && targetDiv.length > 0){//插入对应的位置
                $(targetDiv).before(category);
            }else{//没找到对应位置就放最后
                menuArea.append(category);
            }
        }else{
            var oneMenu = $('<div id="menu'+obj.menuId+'" menuId="'+obj.menuId+'" menuName="'+obj.menuName+'" sourceType="'+obj.sourceType+'" value="'+iconId+'" isSystem = "'+custom+'"   style="margin-left: 12px;float:left;margin-top: 12px;width: 58px;" align="center"></div>');
            if(targetDiv && targetDiv.length > 0 ){//插入对应的位置
                $(targetDiv).before(oneMenu);
            }else{//没找到对应位置就放最后
                menuArea.append(oneMenu);
            }
            //图标div
            var imgDiv = $('<div style="width:61px;height: 61px;position: relative"></div>');
            oneMenu.append(imgDiv);
            imgDiv.append($('<img src="'+imgUrl+'" style="width: 51px; height: 51px;"/>'));
            imgDiv.append($('<div style="z-index: 9999;position: absolute;right: 0px;bottom: 2px;"><span id="icon'+obj.menuId+'" menuId="'+obj.menuId+'" title="'+$.i18n('bizconfig.business.mobile.select.icon.label')+'" class="ico16 mobile_editor_16"></span></div>'));
            //菜单名称Div
            var nameDiv = $('<div title="'+obj.title+'" style="width: 61px;height: 15px;line-height: 15px;text-align: center;display:block;white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">'+obj.menuName+'</div>');
            oneMenu.append(nameDiv);
        }
    }
    //点击确认返回的操作
    function OK(){
        var obj = "";
        //移动业务配置Id
        var mobileBizConfigId = $("#mobileBizConfigId").val();
        //广告信息
        var adDiv = $("#defalutAdImage","#disPlayImage");
        var adImgId = $(adDiv).attr("value");
        var adIsSystem = $(adDiv).attr("isSystem");
        //指标信息
        var indexItems = $("#indexItem").formobj();
        var indexObj = "";
        if(indexItems.length){
            for(var i = 0;i<indexItems.length;i++){
                if(i == 0){
                    indexObj = "[";
                }
                indexObj = indexObj + '{"id":"'+indexItems[i].id+'","showTitle":"'+indexItems[i].showTitle+'","queryBeanId":"'+indexItems[i].queryBeanId+'","simpleStr":"'+indexItems[i].simpleStr+'"}';
                if(i == indexItems.length - 1){
                    indexObj = indexObj + "]";
                }else{
                    indexObj += ",";
                }
            }
        }else{//只有一个指标项时
            if(indexItems.id){
                indexObj = '[{"id":"'+indexItems.id+'","showTitle":"'+indexItems.showTitle+'","queryBeanId":"'+indexItems.queryBeanId+'","simpleStr":"'+indexItems.simpleStr+'"}]';
            }
        }
        var menuObj = "[";
        var count = 0;
        //提取菜单信息
        $("div[id^='menu']","#menuArea").each(function(){
            var sourceType = $(this).attr("sourceType");
            var needSave = true;
            if(sourceType == "15"){
                if(!hasMenu(this)){
                    needSave = false;
                }
            }
            if(needSave){
                count ++;
                menuObj += '{"menuId":"'+ $(this).attr("menuId")+'","menuName":"'+$(this).attr("menuName")+'","iconId":"'+$(this).attr("value")+'","custom":"'+$(this).attr("isSystem")+'","sourceType":"'+$(this).attr("sourceType")+'"},';
            }
        });
        if(count != 0){
            menuObj = menuObj.substring(0,menuObj.length-1);
        }else{
            $.alert($.i18n('bizconfig.business.mobile.home.one.label'));
            return false;
        }
        menuObj = menuObj + "]";
        obj = '{"id":"'+mobileBizConfigId+'","adImageId":"'+adImgId+'","custom":"'+adIsSystem+'"';
        if(indexObj != ""){
            obj += ',"indicatorItems":'+indexObj;
        }
        //配置了三个指标，同时配置了移动看板，需要给出一个提示。
        var needTips = false;
        //看板
        var dashboardId = $("#dashboardId").val();
        if(dashboardId && dashboardId != ""){
            if(indexItems.length == 3){
                needTips = true;
            }
            obj += ',"dashboard":{"dashboardId":"'+dashboardId+'","dashboardName":"'+$("#dashboardName").val()+'"}';
        }
        if(menuObj != "[]"){
            obj += ',"menuItems":'+menuObj;
        }
        obj += "}";
        return {success:true,mobileConfig:obj,needTips:needTips};
    }
    //判断右侧菜单分类后面有没有菜单
    function hasMenu(obj){
        var next = $(obj).next();
        if(next){
            var sourceType = $(next).attr("sourceType");
            if(!sourceType || sourceType == "15"){
                return false;
            }
        }
        return true;
    }
    //全选功能
    function selectAllMenu(){
        if($("#selectAll")[0].checked) {
            $("input[id^='checkbox']",$("#domain2")).each(function(){
                if(!$(this)[0].checked){
                    $(this).prop("checked",true);
                    $(this).attr("checked","checked");
                    dealRelation(this);
                }
            });
        }else{
            $("input[id^='checkbox']",$("#domain2")).each(function(){
                if($(this)[0].checked){
                    $(this).prop("checked",false);
                    $(this).attr("checked",false);
                    dealRelation(this);
                }
            });
        }
    }
</script>
