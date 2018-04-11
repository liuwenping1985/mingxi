<%--
  Created by IntelliJ IDEA.
  User: daiye
  Date: 2016-8-15
  Time: 20:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/jsp/common/common.jsp" %>
<html>
<head>
    <title>表单数据列表</title>
    <style>
        .static_top{
            height: 30px;
        }
    </style>
</head>
<body id='layout' class="comp" comp="type:'layout'">
<div class="layout_north" id="north" layout="height:30,sprit:false,border:false">
    <div id="toolbar" class="f0f0f0"></div>
</div>
<div class="layout_center" id="center1" style="overflow:hidden;">
    <table class="flexme3" style="display: none" id="mytable1"></table>
    <div id='grid_detail1'>
        <iframe id="viewFrame1" frameborder="0" src=""  style="width: 100%;height:100%;"></iframe>
    </div>
</div>
</body>
<script type="text/javascript">
    var flowTable;
    $(document).ready(function(){
        var tableObj = {};
        tableObj.colModel=getTableColModel();
        tableObj.isToggleHideShow=false;
        tableObj.managerName="formTriggerManager";
        tableObj.managerMethod="fixDataList";
        tableObj.usepager=true;
        tableObj.useRp=true;
        tableObj.customize=true;
        tableObj.resizable=true;
        tableObj.render=rend;
        tableObj.showToggleBtn=false;
        tableObj.vChange=true;
        tableObj.vChangeParam={overflow: "hidden",
            autoResize:true};
        tableObj.slideToggleBtn=true;

        tableObj.parentId='center1';
        flowTable = $("#mytable1").ajaxgrid(tableObj);

        var o = {};
        o.formId = "${param.formId}";
        $("#mytable1").ajaxgridLoad(o);
        setToolbar();
    });

    function getTableColModel(){
        var o = [ {
            display : 'id',
            name : 'id',
            width : '25',
            sortable : false,
            align : 'center',
            isToggleHideShow:false,
            type : 'checkbox'
        }, {
            display : "协同标题",
            name : 'title',
            width : '30%',
            sortable : true,
            align : 'left',
            isToggleHideShow:false
        }, {
            display : "流程状态",
            name : 'state',
            width : '15%',
            sortable : true,
            isToggleHideShow:false,
            align : 'left'
        }, {
            display : "核定状态",
            name : 'vouchState',
            width : '15%',
            sortable : true,
            isToggleHideShow:false,
            align : 'center'
        },{
            display : "发起时间",
            name : 'startDate',
            width : '15%',
            sortable : true,
            isToggleHideShow:false,
            align : 'center'
        },{
            display : "结束时间",
            name : 'endDate',
            width : '15%',
            sortable : true,
            isToggleHideShow:false,
            align : 'center'
        },{
            display : "发起人",
            name : 'startMember',
            width : '15%',
            sortable : true,
            isToggleHideShow:false,
            align : 'center'
        } ];
        return o;
    }

    function rend(txt, data, r, c) {
        return txt;
    }
    
    function setToolbar() {
        $("#toolbar").toolbar({toolbar : [{
            id:"fixSelected",name:"修复选中",click:fixSelected,className:"ico16 batch_16"
//        },{
//            id:"fixAll",name:"修复所有",click:fixAll,className:"ico16 batch_16"
        }]});
    }

    function fixSelected() {
        var ids = getSelectedIds(flowTable);
        if (ids) {
            $.confirm({
                'msg':"确认再次执行选中数据的回写或者触发设置？",
                ok_fn:function () {
                    var fm = new formTriggerManager();
                    var result = fm.addFixData2List("${param.formId}", ids);
                    if (result) {
                        $.infor("成功将数据加入回写触发执行队列，请等待执行！");
                    }
                }
            });
        }
    }
    function fixAll() {

    }

    function getSelectedIds(table){
        var gridObjArray = table.grid.getSelectRows();
        var id = "";
        if (gridObjArray && gridObjArray.length > 0){
            for(var i = 0; i < gridObjArray.length; i++){
                id = id + gridObjArray[i].id + ",";
            }
            if (id){
                id = id.substr(0,id.length-1);
            }
        }
        return id;
    }
</script>
</html>
