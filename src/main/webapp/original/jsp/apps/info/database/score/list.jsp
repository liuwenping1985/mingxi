<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../include/info_header.jsp"%>
<!DOCTYPE html>
<html>
<head> 
<title>信息评分标准设置</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=infoScoreManager"></script>
<script type="text/javascript" src="${path}/apps_res/info/js/list.js${ctp:resSuffix()}"></script>

 <script type="text/javascript">
 $(document).ready(function () {
		loadStyle();
		loadToolbar();
		loadCondition();
		loadData();
		
		setTimeout(function(){$('#summary').attr("src", _ctxPath+"/info/score.do?method=listDesc"+"&size="+grid.p.total);},"300");
		//loadSummaryDesc();
	});
 function loadToolbar() {
		//工具栏
	    var toolbarArray = new Array();
	    toolbarArray.push({id:"create", name:"${ctp:i18n('common.toolbar.new.label')}", className:"ico16", click:addScore});//新建
	    toolbarArray.push({id:"create", name:"${ctp:i18n('common.toolbar.update.label')}", className:"ico16 editor_16", click:modifyRow});//修改
	    toolbarArray.push({id:"create", name:"${ctp:i18n('common.state.normal.label')}", className:"ico16 enabled_16", click:changeEnable});//启动
	    toolbarArray.push({id:"create", name:"${ctp:i18n('common.state.invalidation.label')}", className:"ico16 disabled_16", click:changeDisable});//停用
	    $("#toolbars").toolbar({
	    	isPager:false,
	        toolbar: toolbarArray
	    });
	}
 function loadCondition() {
		//定义搜索条件选项
	    var condition = new Array();
	    //信息评分标准名称
	    condition.push({id:'name', name:'name', type:'input', text:'${ctp:i18n('infosend.score.database.name')}', value:'name', maxLength:85, validate:false});
	    //刊登级别
	     var arrray = new Array();
	    <c:forEach items="${vos}" var="item" >
	  	  var obj = new Object();
	       obj.text = "11";
	       obj.value = "1";
	   	   obj.text = '${item.enumName}';
	   	   obj.value = '${item.enumId}';
	       arrray.push(obj);
		 </c:forEach>
	    condition.push({id:'enumName', name:'enumName', type:'select', text: '${ctp:i18n('infosend.score.publish.level')}', value:'enumName', maxLength:85, validate:false,
	    	  items: arrray
	    });
	    //分数
	    condition.push({id:'score', name:'score', type:'input', text: '${ctp:i18n('infosend.score.number')}', value:'score', maxLength:85, validate:false});
	    //创建人
	    condition.push({id:'createUserName', name:'createUserName', type:'input', text: '${ctp:i18n('infosend.score.create.user')}', value:'createUserName', maxLength:85, validate:false});
	    //创建时间
	    condition.push({id:'createTime', name:'createTime', type:'datemulti',   dateTime: false,text: '${ctp:i18n('infosend.score.create.time')}', value:'createTime', ifFormat:'%Y-%m-%d', maxLength:85, validate:false});
	  	//搜索框
	    var searchobj = $.searchCondition({
	        top:2,
	        right:10,
	        searchHandler: function(){
	            searchFunc();
	        },
	        conditions:condition
	    });
	  	//搜索框执行的动作
	    function searchFunc(){
	        var o = new Object();
	        var choose = $('#'+searchobj.p.id).find("option:selected").val();
	        if(choose === 'name'){
	            o.name = $('#name').val();
	        }else if(choose === 'enumName'){
	            o.enumName = $('#enumName').val();
	        }else if(choose === 'score'){
		        var _score = $('#score').val();
                if (_score != "") {
                    var patrn=/^[\d]+$/;
                    if(!patrn.exec(_score)){
                        $.alert($.i18n('infosend.score.alert.searchScore'));//分数必须为整数！
                        return;
                    }
                    o.score = _score;
                }
	        }else if(choose ==='createUserName'){
	        	 o.createUserName = $('#createUserName').val();
	        }else if(choose === 'createTime'){
        	   var fromDate = $('#from_createTime').val();
                var toDate = $('#to_createTime').val();
                if(fromDate != "" && toDate != "" && fromDate > toDate){
                    $.alert($.i18n('collaboration.rule.date'));//开始时间不能早于结束时间
                    return;
                }
                var date = fromDate+'#'+toDate;
                o.createTime = date;
	        }
	        o.condition = choose;
	        var val = searchobj.g.getReturnValue();
	        if(val !== null){
	            $("#listGrid").ajaxgridLoad(o);
	        }
	    }
	}
 //加载页面数据
 var grid;
 function loadData() {
 	//表格加载
     grid = $('#listGrid').ajaxgrid({
         colModel: [{
             display: 'id',
             name: 'id',
             width: '5%',
             type: 'checkbox',
             isToggleHideShow:false
         }, {
             display: "${ctp:i18n('infosend.score.database.name')}",//信息评分标准名称
             name: 'name',
             sortable : true,
             width: '15%',
            isToggleHideShow:true
         }, {
             display: "${ctp:i18n('infosend.score.number')}",//分数
             name: 'score',
             sortable : true,
             width: '8%',
             sortType:'number' //按数字排序
         }, {
             display: "${ctp:i18n('infosend.score.state.label')}",//状态
             name: 'currentState',
             sortable : true,
             width: '12%'
         }, {
             display: "${ctp:i18n('infosend.score.type')}",//评分类型
             name: 'infoType',
             sortable : true,
             width: '12%'
         }, {
             display: "${ctp:i18n('infosend.score.publish.level')}",//刊登级别
             name: 'enumToString',
             sortable : true,
             width: '12%'
         },{
        	 display: "${ctp:i18n('infosend.score.publisdestination.label')}",//绑定刊物（绑定发布范围）
        	 name: 'infoScores',
             sortable : true,
             width: '12%'
         },{
        	 display: "${ctp:i18n('infosend.score.create.time')}",//创建时间
        	 name: 'createTime',
        	 ifFormat:'%Y-%m-%d',
             sortable : true,
             width: '12%'
         },{
        	 display: "${ctp:i18n('infosend.score.create.user')}",//创建人
        	 name: 'createUserName',
             sortable : true,
             width: '12%'
         }],
         click: clickRow,
         dblclick: clickModifyRow,
         render : rend,
         showTableToggleBtn: true,
         parentId: $('.layout_center').eq(0).attr('id'),
         vChange: true,
 		vChangeParam: {
             overflow: "hidden",
 			autoResize:true
         },
         slideToggleBtn: true,
         managerName : "infoScoreManager",
        managerMethod : "getScoreList"
     });
     var o = new Object();
     $("#listGrid").ajaxgridLoad(o);
 }
 </script>
</head>
<body>
<div id='layout'>
        <div class="layout_north bg_color" id="north">
            <div id="toolbars"></div>
        </div>
        <div class="layout_center over_hidden" id="center">
            <table  class="flexme3" id="listGrid"></table>
            <div id="grid_detail" class="h100b">
                <iframe id="summary" name='summaryF' width="100%" height="100%" frameborder="0"  class="calendar_show_iframe" style="overflow-y:hidden"></iframe>
            </div>
        </div>
    </div> 
</body>
</html>