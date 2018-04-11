<%--
 $Author:$
 $Rev:$
 $Date:: $:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=businessManager,bizDataManager"></script>
<script type="text/javascript" src="${path}/common/form/bizconfig/batchAuthCommon.js${ctp:resSuffix()}"></script>
<html>
<head>
<title>Insert title here</title>
<script type="text/javascript">
var treeObj;
var currentFormObj;
var bizId = "${param.bizId}";
var bizDataManager = new bizDataManager();
var dialogArg = window.dialogArguments;//所有参数
var lastFormId;//最后一个表单，用于最后一个表单如果不需要重定向的时候，右侧暂时的表单有问题的情况下暂时
$(document).ready(function(){
    $("#formColumnTree").tree({
        idKey : "value",
        pIdKey : "parent",
        nameKey : "name",
        nodeHandler : function(n) {
            n.open = true;
            if(n.data.type != "son"){
                n.isParent = true;
            }
        }
    });
    treeObj = $("#formColumnTree").treeObj();
    //找到第一个需要重定向的表单
    initView(true);
});

function initView(firstShow){
    var nodes = treeObj.getNodes();
    currentFormObj = null;
    var needRedirect = true;
    if(nodes[0].isParent && typeof(nodes[0].children) == "undefined"){
        $.confirm({'msg':'没有需要重定向的表单，业务配置自动激活！',
            ok_fn:function(){
                published(true);
            },
            cancel_fn:function(){
                window.parentDialogObj['redirectBiz'].close();
            },
            close_fn:function(){
                window.parentDialogObj['redirectBiz'].close();
            }
        });
        return;
    }
    for(var i=0; i < nodes.length;i++){
        if (initViewFunction(nodes[i])){
            break;
        } else {
            needRedirect = false;
        }
    }
    if(!needRedirect){
        //最后一个表单，用于最后一个表单如果不需要重定向的时候，右侧暂时的表单有问题的情况下暂时
        $("#viewIframe").prop("src","${path}/content/content.do?isFullPage=true&moduleId="+lastFormId+"&moduleType=35&rightId=-1&isFullPage=true&viewState=4");
    }
    if (!needRedirect && firstShow){
        batchRedirectAuth(bizId,callBack4Ok,callBack4Cancel);
//        $.confirm({'msg':'所有表单已经完成重定向，是否现在发布？',
//            ok_fn:function(){
//                published(true);
//            },
//            cancel_fn:function(){
//                window.parentDialogObj['redirectBiz'].close();
//            },
//            close_fn:function(){
//                window.parentDialogObj['redirectBiz'].close();
//            }
//        });
    }
}

//初始加载的时候如果所有表单都重定向了，弹出授权框的回调函数
function callBack4Ok(){
    var redirectDialog = window.parentDialogObj['redirectBiz'];
    //要先关闭授权的dialog，不然下面的设置按钮不生效
    batchAuthDialog.close();
    redirectDialog.hideBtn("start");
    redirectDialog.showBtn("published");
    redirectDialog.setBtnEmphasize("published");
}
//授权页面取消的回调函数
function callBack4Cancel(){
    var redirectDialog = window.parentDialogObj['redirectBiz'];
    redirectDialog.hideBtn("start");
    redirectDialog.showBtn("auth");
    redirectDialog.setBtnEmphasize("auth");
}
//递归找到需要重定向的表单
function initViewFunction(node){
    if(node.isParent){
        var nodes = node.children;
        for(var i=0; i < nodes.length;i++){
            if (initViewFunction(nodes[i])){
                return true;
            }
        }
    } else {
        if (node.data.state == -2){
            var param = {};
            param.formId = node.data.value;
            param.bizId = bizId;
            //判断该表单是否需要重定向，不需要则跳过
            var result = bizDataManager.needRedirect(param);
            if(result == "0"){
                node.data.state = -1;
                treeObj.updateNode(node);
                var id = node.tId;
                $("#"+id+"_a").css("color","#ccc");
                lastFormId = node.data.value;
            }else{
                currentFormObj = {};
                currentFormObj.id = node.data.value;
                currentFormObj.name = node.data.name;
                $("#viewIframe").prop("src","${path}/content/content.do?isFullPage=true&moduleId="+node.data.value+"&moduleType=35&rightId=-1&isFullPage=true&viewState=4");
                return true;
            }
        } else if (node.data.state == -1){
            var id = node.tId;
            $("#"+id+"_a").css("color","#ccc");
            lastFormId = node.data.value;
        }
    }
}

//完成一个表单重定向之后执行的方法
function completeFormRedirect(){
    var node = treeObj.getNodeByParam("value",currentFormObj.id);
    if (node){
        node.data.state = -1;
        treeObj.updateNode(node);
        initView(false);
    }
}

//完成重定向之后发布业务包
function published(firstView){
    bizDataManager.doUpdateFormBeanState("${param.bizId}","2");
    bizDataManager.doUpdateBizMapState("${param.bizId}","1");
    if (firstView){
        dialogArg.param.closeWindow();
    }
}

function OK(param){
    var result = {};
    result.type = param.type;
    result.redirectComplete = false;
    result.bizId = "${param.bizId}";
    //某个表单导入重定向完成后事件
    if (param.type == 'complete'){
        completeFormRedirect();
        //所有表单重定向完成后，这个对象为null
        if (currentFormObj == null){
            result.redirectComplete = true;
        }else{
            result.formid = currentFormObj.id;
            result.formName = currentFormObj.name;
        }
        return result;
    }
    //下一个，开始导入按钮事件
    if (param.type == 'redirect'){
        result.formid = currentFormObj.id;
        result.formName = currentFormObj.name;
        return result;
    }
    //发布事件
    if (param.type == 'published'){
        published(false);
        return result;
    }
    //保存退出事件
    if (param.type == 'saveandexit'){
        return result;
    }
    return result;
}
</script>
</head>
<body>
    <div class="comp" comp="type:'layout'" id="layout">
        <div id="west" class="layout_west" layout="width:200">
            <div id="formColumnTree"></div>
        </div>
        <div id="center" class="layout_center page_color over_hidden" layout="border:false">
            <iframe id="viewIframe" height="100%" width="100%" style="width: 100%;height: 100%;" frameborder="0" ></iframe>
        </div>
    </div>
</body>
</html>