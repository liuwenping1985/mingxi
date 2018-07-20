<%--
 $Author: weijh $
 $Rev: 9416 $
 $Date:: 2012-12-12 12:46:11#$:

 Copyright (C) 2012 Seeyon, Inc. All rights reserved.
 This software is the proprietary information of Seeyon, Inc.
 Use is subject to license terms.
--%>
<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html class="h100b">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="pragma" contect="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<%@ include file="supervision_header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/form/common/common.js.jsp"%>
<%@ include file="/WEB-INF/jsp/ctp/form/component/formFieldConditionComp.js.jsp"%>
<title>
<c:if test="${supType == 20}">由我分管事项</c:if>
<c:if test="${supType == 30}">我关注的事项</c:if>
<c:if test="${supType == 40}">我督办事项</c:if>
<c:if test="${supType == 50}">超期事项</c:if>
<c:if test="${supType == 80}">承办事项台账</c:if>
<c:if test="${supType == 90}">由我办理事项</c:if>
</title>
</head>
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/supervision/css/dialog.css${v3x:resSuffix()}" />">
	<script type="text/javascript" src="${path}/apps_res/supervision/js/dialog.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" src="${path}/apps_res/supervision/js/supervisionDataList.js${ctp:resSuffix()}"></script>
    <script type="text/javascript" src="${path}/ajax.do?managerName=formManager"></script>
    <script type="text/javascript" src="${path}/ajax.do?managerName=formDataManager"></script>
    <%-- 如果来源于首页栏目时，加载JS --%>
    <c:if test="${isFormSection eq 'true'}">
        <script type="text/javascript" src="${path}/common/form/common/unflowQueryResultSection.js${ctp:resSuffix()}"></script>
    </c:if>

    <script type="text/javascript">
    var supTypeId = "${supTypeId}";//督办事项分类枚举类型
    var supType = "${supType}";//督办列表类型:由我分管事项-20、我关注事项-30、我督办事项-40、已超期事项-50、反馈事项-60、督查事项台账-70、责任事项台账-80、由我办理事项-90、领导全部-100
	var isSupervor = "${isSupervor}";//督办人权限
	var isSupervisionLeader = "${isSupervisionLeader}";
	var isResponsibleUnit = "${isResponsibleUnit}";
	var supMemberIds = "${param.supMemberIds}";
	var rCode = '${param.rCode}';
	var isPersonal = '${param.isPersonal}'

    var warningList = '${warningList}';
	var warningOptions = new Array();
	warningOptions = eval("(" + warningList + ")");
	var isCo_manager = false;//协办单位不显示操作和状态
    var grid;
    //是否有解锁权限,0表示没有,1表示有
    var delnum=0;//用来控制显示
    var unlockAuth=0;
    var chekcSerch=true;
    var numleft=0;
    var numright=0;
    var toFormBean = ${toFormBean};
    var relationInitParam = "${relationInitParam}";
    //判断是否来源于首页无流程栏目
    var isFormSection = "${isFormSection}";
    var _type = "${ctp:escapeJavascript(type)}";
    var _formType = "${formType}";
    var _newFormAuth = "${newFormAuth}";
    var _moduleType = "${moduleType}";
    var _formId = "${formId}";
    var _firstRightId = "${firstRightId}";
    var _formTemplateId = "${formTemplateId}";
    var _templateName = "${templateName}";
    var _sortStr = "${sortStr}";
    var _editAuth = "${editAuth}";
    var _editAuthJson = '${editAuthJson}';
    var breakId="";
    var _commonSearchFields = ${commonSearchFields};
    var urlFieldList = ${urlFieldList};
    var selectBtmType = (relationInitParam===""||relationInitParam==="ss"||relationInitParam==="sm")?'checkbox':"radio";
    var v3x = new V3X();
    var showFields = [];
    //列表加载需要的参数对象；替换页面中每次需要重新加载前构造的对象全部使用该全局对象代替，防止丢失了用户自己设置的过滤条件。by zhangc
    var gridPramsObj = new Object();

    var _fromFormId = "${fromFormId}";
    var _fromDataId = "${fromDataId}";
    var _fromRecordId = "${fromRecordId}";
    var _fromRelationAttr = "${fromRelationAttr}";
    //督办单独加的条件-------start
    setGridDefaultParam(gridPramsObj);
    //督办单独加的条件-------end

    $(document).ready(function() {
        try{
            dispConditon();
            showFormData(toFormBean);
            $("#titleDiv").show();
            if(_type=="baseInfo"){
                $("#titleDiv").find("h2").text(_templateName);
            }else{
                $("#titleDiv").css("display","none");
            }
        }catch(e){
        }
        //只有关联的时候才会如此

        if(_type == "formRelation"){
            checkBindNum();
        }
        $("#searchBtn").click(function(){
            doSearch();
        });
        $("#resethsearch").click(function (){
            $("#userConditionTable").empty();
            $("#userConditionTable").append($("body").data("cloneUserCondition").clone(true));
        });
        //添加责任协办和预警
        addConditions();
      	changeStyle();

    	$("#importAndExport").mouseover(function(){
        	var atop = $(this).position().top;
        	var aleft = $(this).position().left;
        	$("#xl_dropdown").css({"top":(parseInt(atop)+96)+"px","left":(parseInt(aleft)+15)+"px"});
    		$("#xl_dropdown").css("display","block");
    	}).mouseout(function(){
    		$("#xl_dropdown").css("display","none");
    	});
    	$("#xl_dropdown").mouseover(function(){
    		$(this).css("display","block");
    	}).mouseout(function(){
    		$(this).css("display","none");
    	});

    });

    //督查督办加载后修改样式
    function changeStyle(){
    	 //添加顶端部分样式后需要调整表体高度//xl 6-26
        var tHeight = $(".bDiv").css("height");
    	//将查询至于左侧
    	if(supType == 20 || supType == 30 || supType == 40 || supType == 50 || supType == 80 || supType == 90){
        	$("body ul.common_search").css({"left":"20px","top":"63px"});
        	$("#unflowFormDataList").css({"border":"1px solid #ddd","border-radius":"5px","margin":"0 14px"});
        	$(".common_search_condition").css("left","25px");
        	$(".bDiv").css("height",(parseInt(tHeight)-73)+"px");
    	}else{
        	$("body ul.common_search").css({"left":"20px","top":"-1px"});
        	$("#unflowFormDataList").css({"border":"1px solid #ddd","border-radius":"5px"});
        	$(".common_search_condition").css("left","15px");
        	$(".bDiv").css("height",(parseInt(tHeight)-60)+"px");
        }
        //table的top定位下移
        var topL = $("#center").css("top");
        topL = topL.substring(0,topL.length-2);
        //添加查询字样
        $(".search_buttonHand").html($(".search_buttonHand").html()+"查询");

        //查询条件时间空间显示问题-IE10及以上用-11，IE10以下4
       	$(".calendar_icon").css("top","4px");
       	//上下布局
       	$(".vGrip").remove();
       	//查询条件事项类别
       	$("input[name='acToggle']").css({"height":"30px","border-top-right-radius":"3px","border-bottom-right-radius":"3px"});
       	$("#field0022_txt").css({"border-right":"none","border-top-right-radius":"0px","border-bottom-right-radius":"0px"});
		//查询条件：责任单位和选人的为只读
		$("#field0001_txt").attr("readonly","readonly");
       	$(".sundefined input").css("padding-left","5px");
       	//操作表头
		$("th[abbr='field0026'] div").css("padding-left","12px");
		//删除列表头上的隐藏
        $('.nBtn').remove();
      //修改页码go的样式
		$("#grid_go").html("GO");
		//xl 6-28如果责任单位的宽度为20px,添加padding-bottom为8px
		//残留问题：判断输入框是否有内容时的样式
		var height=$("#field0001_txt").css("height");
		$("#field0001_txt").change(function(){
			height=$("#field0001_txt").css("height");
			if(height=="20px"){
				$("#field0001_txt").css("padding","4px 0px");
			}else{
				$("#field0001_txt").css("padding","0px");
			}
		});
		if(height=="20px"){
			$("#field0001_txt").css("padding","4px 0px");
		}
		//xl 7-25修改
		setInterval(function(){
			var width=$("#unflowFormDataList").css("width");
			$(".layout_north").css("width",width);
			$(".layout_center").css("width",width);
			$(".flexigrid").css("width",width);
			$(".bDiv").css("width",width);
		},50);
		
		$(".new_create").css("margin-right","10px");
    }

    function showFormData(formObj){
        new MxtLayout({
            'id' : 'layout',
            'northArea' : {
            'id' : 'north',
            'height' : 35,
            'sprit' : false
        	},
            'centerArea' : {
            'id' : 'center',
            'border' : false
            },
            'southArea':{
            'id' : 'viewSouth'
            },
            'successFn' : function() {
                //构造动态表表头
                var theadarr = [{
                    display : 'id',
                    name : 'id',
                    width : '3%',
                    sortable : false,
                    align : 'center',
                    type : selectBtmType
                },{
                	display : '<span class="ico16 locking_16"></span>',
                    name : 'state',
                    width : '0%',
                    sortable : false,
                    align : 'left'
                }];
                var _width = $("body").width()-25;//宽度-id的宽度
                var num=2;//用来控制表头的显示
                //基础信息无锁定
                //if( _formType ==='3'){
                    theadarr.pop();
                    _width = _width - 25//锁的宽度
                    num=1;
               // }
                showFields = ${showFields};
                var _colWidth = 100;
                if(showFields.length>=10){
                    _colWidth = _width/10;
                }else{
                    _colWidth = _width/showFields.length;
                }
                var width = getTHWidthTable(showFields.length);
				//根据不同的列表显示不同的字段
                showSupervisionListField(showFields,theadarr,width);

                //定义默认的列表参数
                var firstListSize = 36;
                var _resizable = true;
                var _slideToggleBtn = true;
                var _vChange = true;
                if(isFormSection == "true"){
                    _resizable = false;
                    _slideToggleBtn = false;
                    _vChange = false;
                }
                var managerName = "formManager";
                var managerMethed = "getFormMasterDataListByFormId";
				/*if(supType == '0'){//重点工作单独写后台进行查询
					managerName = "supervisionManager";
					managerMethed = "getGovworkDataListByFormId";
				}*/

                grid = $("#mytable").ajaxgrid({
                    parentId : "center",
                    colModel : theadarr,
                    managerName : managerName,
                    managerMethod : managerMethed,
                    click : dblclk,
                    callBackTotle:callBackTotal,
                    minwidth:50,
                    usepager : true,
                    useRp : true,
                    render : rend,
                    customId : "customId_${formTemplateId}",
                    customize:false,
                    resizable : _resizable,
                    vChange :_vChange,
                    rpMaxSize:999,
                    vChangeParam: {
                        overflow: "hidden",
                        autoResize:true
                    },
                    slideToggleBtn: _slideToggleBtn,
                    onSuccess:successFn
                });
               	$("#mytable").ajaxgridLoad(gridPramsObj);
            }
        });
    }


    //使用el表达式(fn:length)取数量有点问题,改用此方法
    function dispConditon(){
        var check=0;
        <c:forEach items="${searchFields}" var="field">
            check++;
        </c:forEach>
        if(check>0){
            setSearchToolbar();
        }
    }
    function successFn(){
        $('.flexigrid :radio').removeClass('noClick');
        if(typeof(breakId)!='undefined' && breakId!='' && $("#breaki"+breakId).length>0){//如果breakId有值，则展开
        	$("#breaki"+breakId).css("width","19px");
        	$("#breaki"+breakId).click();
        }
        breakId="";
    }
    function mobileList(){
        var newFormAuth = _newFormAuth;
        var strs = newFormAuth.split(".");
        var viewId = strs[0];
        var rightId = strs[1];
		var url = _ctxPath+"/form/lightForm.do?method=formDataList&formId="+_formId+"&formTemplateId="+_formTemplateId+"&rightId="+rightId;
		openCtpWindow({"url":url});
    }
    function checkBindNum(){
        var pramsObj = {};
        var fdManager  = new formDataManager();
        pramsObj.formId = toFormBean.id;
        fdManager.checkBindsNum(pramsObj,{
            success: function(msg){  //查核通过
               if(msg){
                   dbAlert(msg);
               }
            }
        });
    }
    </script>
<%--第一部分：页面顶端部分--%>
<c:if test="${supType == 20 || supType == 30 || supType == 40 || supType == 50 || supType == 80 || supType == 90}">
	<div class="list-header">
		<!--左边部分-->
		<div class="list-header-left">
			<b></b>
			<span>
			<c:if test="${supType == 20}">由我分管事项</c:if>
			<c:if test="${supType == 30}">我关注的事项</c:if>
			<c:if test="${supType == 40}">我督办事项</c:if>
			<c:if test="${supType == 50}">超期事项</c:if>
			<c:if test="${supType == 80}">责任事项台账</c:if>
			<c:if test="${supType == 90}">由我办理事项</c:if>
			</span>
		</div>
		<!--右边部分-->
		<div class="list-header-right">
			<a href="#"></a>
		</div>
	</div>
</c:if>
<body class="h100b over_hidden" style="position:relative;">
<ul class="xl_dropdown" id='xl_dropdown'><li><a onclick="inportExcel()">导入excel</a></li>
	<li> <a onclick="exporttoExcel()">导出excel</a> </li>
	<li> <a onclick="downTemplate()">模板下载</a> </li>
</ul>
<input type="hidden" value="${param.rCode }" id="rCode" name="rCode">

	<div id="unflowFormDataList" class="comp" comp="type:'layout'">
		<%-- 北边部分包括toolbar和查询条件 --%>
		<div id="north" class="layout_north"
			layout="height:50,maxHeight:50,minHeight:50,spiretBar:{show:false},sprit:false"
			style="border:0;">

		</div>
		<%-- 中间是主表数据列表 --%>
		<div id="center" class="layout_center over_hidden"
			layout="border:false,spiretBar:{show:false}">
			<table class="flexme3 " style="display: none" id="mytable"></table>
		</div>
		<input id="myfile" type="hidden" class="comp"
			comp="type:'fileupload',applicationCategory:'1',extensions:'xls,xlsx',quantity:1,isEncrypt:false,firstSave:true,showReplaceOrAppend:true,hiddenSkipOrCover:'cover'">
	</div>
	<div class="xl_success_hidden" style="display:none">
		    <img src="${path}/apps_res/supervision/img/msg.png">
		    <span>发送成功<span>
		</div>
	<iframe id="exporttoExcel" style="display: none"></iframe>
	<iframe id="downTemplate" style="display: none"></iframe>
</body>
</html>