<%--
 $Author: weijh $
 $Rev: 9416 $
 $Date:: 2012-12-12 12:46:11#$:
  
 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="common.js.jsp"%>
<html class="h100b">
<head>
<title>表单数据列表</title>
<script type="text/javascript">
var bIsContentScroll = true;
var isNeedScroll = true;
</script>
</head>
<body class="h100b over_hidden">
<div id='layout'>
    <!-- 北边 -->
    <div class="layout_north bg_color" id="north">
        <div class="hr_heng"></div>
        <div id="toolbars" class="margin_l_5 margin_t_5 font_size12">
            <label for="mySent"><input id="mySent" class="radio_com" type="radio" name="colType" value = "1">本人发起</label>
            <label for="delegateToMe"><input id="delegateToMe" class="radio_com" type="radio" name="colType" value = "2">他人发起</label>
        </div>  
    </div>
    <!-- 中间 -->
    <div class="layout_center over_hidden" id="center">
        <table  class="flexme3" id="listSent"></table>
        <div id="grid_detail" class="h100b">
            <iframe id="viewFrame"  width="100%" height="100%" frameborder="0"></iframe>
        </div>
    </div>
</div>
<script type="text/javascript">
var relationInitParam = "${relationInitParam}";
var selectBtmType = (relationInitParam===""||relationInitParam==="ss"||relationInitParam==="sm")?'checkbox':"radio";
var toFormBean = ${toFormBean};
function OK(){
    var selectedBox = new ArrayList();
    $("#listSent").find("input[type='"+selectBtmType+"']").each(function(){
        if(this.checked){
            selectedBox.add(this);
        }
    });
    var selectArray = new Array();
    var viewFrame = $("#viewFrame");
    var moduleId = viewFrame[0].contentWindow.getParameter!=undefined?viewFrame[0].contentWindow.getParameter("moduleId"):"0";
    /**返回数据格式
     *{toFormId:yyyy,
       selectArray:[{masterDataId:xxx,subData:[{tableName:formson_0001,dataIds:[]},{tableName:formson_0002,dataIds:[]}]},
                    {masterDataId:xxx,subData:[{tableName:formson_0001,dataIds:[]},{tableName:formson_0002,dataIds:[]}]}]
      }
     */
    $(selectedBox.toArray()).each(function(masterIndex){
        var jqThis = $(this);
        var tempObj = new Object();
        tempObj.masterDataId = jqThis.val();
        var subData = new Array();
        for(var i=0;i<toFormBean.tableList.length;i++){
            var tempTable = toFormBean.tableList[i];
            if(tempTable.tableType.toLowerCase()==="slave"){
                var tempSubData = new Object();
                tempSubData.tableName = tempTable.tableName;
                if(jqThis.val()==moduleId){
                    var subDom = $("#"+tempTable.tableName,viewFrame);
                    var tempSubArray = new Array();
                    if(subDom){
                        var allCheckedBox = $(":checkbox[checked][tableName='"+tempTable.tableName+"']",$(viewFrame[0].contentWindow.document));
                        if(allCheckedBox.length==0){
                            allCheckedBox = $(":checkbox[tableName='"+tempTable.tableName+"']:eq(0)",$(viewFrame[0].contentWindow.document));
                        }
                        allCheckedBox.each(function(){
                            tempSubArray.push($(this).val()); 
                        });
                    }
                    tempSubData.dataIds = tempSubArray;
                }
                subData.push(tempSubData);
            }
        }
        tempObj.subData = subData;
        selectArray.push(tempObj);
    });
    var obj = new Object();
    obj.selectArray = selectArray;
    obj.toFormId = toFormBean.id;
    return $.toJSON(obj);
}


$(document).ready(function () {
    new MxtLayout({
        'id': 'layout',
        'northArea': {
            'id': 'north',
            'height': 35,
            'sprit': false,
            'border': false
        },
        'centerArea': {
            'id': 'center',
            'border': false,
            'minHeight': 20
        }
    });
    //搜索框
    var searchobj = $.searchCondition({
        top:5,
        right:10,
        searchHandler: function(){
            var o = new Object();
            var choose = $('#'+searchobj.p.id).find("option:selected").val();
            if(choose === 'subject'){
                o.subject = $('#title').val();
            }else if(choose === 'importantLevel'){
                o.importantLevel = $('#importent').val();
            }else if(choose === 'createDate'){
                var fromDate = $('#from_datetime').val();
                var toDate = $('#to_datetime').val();
                var date = fromDate+'#'+toDate;
                o.createDate = date;
                if(fromDate != "" && toDate != "" && fromDate > toDate){
                    $.alert("${ctp:i18n('collaboration.rule.date')}");//开始时间不能早于结束时间
                    return;
                }
            }
            var val = searchobj.g.getReturnValue();
            if(val !== null){
                o.colType = $(":input:radio:checked",$("#toolbars")).val();
                o.formId = "${formId}";
                o.fromFormId = "${param.fromFormId}";
                o.fromDataId = "${param.fromDataId}";
                o.fromRecordId = "${param.fromRecordId}";
                o.fromRelationAttr = "${param.fromRelationAttr}";
                $("#listSent").ajaxgridLoad(o);
            }
        },
        conditions: [{
            id: 'title',
            name: 'title',
            type: 'input',
            text: '${ctp:i18n("cannel.display.column.subject.label")}',//标题
            value: 'subject'
        }, {
            id: 'importent',
            name: 'importent',
            type: 'select',
            text: '${ctp:i18n("common.importance.label")}',//重要程度
            value: 'importantLevel',
            items: [{
                text: '${ctp:i18n("common.importance.putong")}',//普通
                value: '1'
            }, {
                text: '${ctp:i18n("common.importance.zhongyao")}',//重要
                value: '2'
            }, {
                text: '${ctp:i18n("common.importance.feichangzhongyao")}',//非常重要
                value: '3'
            }]
        }, {
            id: 'datetime',
            name: 'datetime',
            type: 'datemulti',
            text: '${ctp:i18n("common.date.sendtime.label")}',//发起时间
            value: 'createDate',
            ifFormat:'%Y-%m-%d',
            dateTime: false
        }]
    });
    //表格加载
    var grid = $('#listSent').ajaxgrid({
        colModel: [{
            display: 'id',
            name: 'summaryId',
            width: '5%',
            type : selectBtmType
        },{
            display: '标题',
            name: 'subject',
            sortable : true,
            width: '45%'
        },{
            display: '发起人',
            name: 'startMemberName',
            sortable : true,
            width: '20%'
        }, {
            display: '发起时间',
            name: 'startDate',
            sortable : true,
            width: '30%'
        }],
        click: clickRow,
        render : rend,
        height: 200,
        showTableToggleBtn: true,
        parentId: $('.layout_center').eq(0).attr('id'),
        vChange: true,
        vChangeParam: {
            overflow: "hidden",
            autoResize:true
        },
        isHaveIframe:true,
        slideToggleBtn:true,
        managerName : "colManager",
        managerMethod : "getRelationAffairs",
        onSuccess:function(){
        	$('.flexigrid :radio').removeClass('noClick'); 
        } 
    });
    selectColType();
    
    //绑定他人发起和授权给本人的radio按钮事件
    $("#mySent").unbind("click").bind("click",function(){
        selectColType();
    });
    $("#delegateToMe").unbind("click").bind("click",function(){
        selectColType();
    });
    
    function clickRow(data,rowIndex, colIndex) {
        grid.grid.resizeGrid(200);
        var viewFrame = $("#viewFrame");
        viewFrame.attr("src",getUnflowFormViewUrl("true",data.summary.id,${enu.ModuleType.collaboration},data.operationId,2));
        viewFrame.unbind("load").bind("load",function(){
            if(viewFrame[0].contentWindow.initRelationSubTable){
                setTimeout(function(){viewFrame[0].contentWindow.initRelationSubTable({"type":"relationForm"})},2000);
            }
        });
    }
});

function selectColType(){
    var o = new Object();
    if($(":input:radio:checked",$("#toolbars")).length<=0){
        //默认打开显示本人发起
        $("#mySent")[0].checked = true;
    }else{
    	$("#viewFrame")[0].contentWindow.document.body.innerText = "";
    }
    o.colType = $(":input:radio:checked",$("#toolbars")).val();
    o.formId = "${formId}";
    
    o.fromFormId = "${param.fromFormId}";
    o.fromDataId = "${param.fromDataId}";
    o.fromRecordId = "${param.fromRecordId}";
    o.fromRelationAttr = "${param.fromRelationAttr}";
    
    $("#listSent").ajaxgridLoad(o);
}

//回调函数
function rend(txt, data, r, c) {
    if(c === 1){
        //加图标
        //重要程度
        if(data.importantLevel !==""&& data.importantLevel !== 1){
            txt = "<span class='ico16 important"+data.importantLevel+"_16 '></span>"+ txt ;
        }
        //附件
        if(data.hasAttsFlag === true){
            txt = txt + "<span class='ico16 affix_16'></span>" ;
        }
        //表单授权
        if(data.showAuthorityButton){
            txt = txt + "<span class='ico16 authorize_16'></span>";
        }
        //协同类型
        if(data.bodyType!==""&&data.bodyType!==null&&data.bodyType!=="10"&&data.bodyType!=="30"){
            txt = txt+ "<span class='ico16 office"+data.bodyType+"_16'></span>";
        }
        //流程状态
        if(data.state !== null && data.state !=="" && data.state != "0"){
            txt = "<span class='ico16  flow"+data.state+"_16 '></span>"+ txt ;
        }
        return txt;
    }else{
        return txt;
    }
}     
</script>
</body>
</html>