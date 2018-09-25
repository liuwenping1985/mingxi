 $(document).ready(function () {
	 if(!isGroup) {
 		$("#reportUnitTd").html($.i18n(unitView)+"：");
 		$("#reportUnit").val("Account|"+$.ctx.CurrentUser.loginAccount);
 		$("#reportUnit_txt").val($.ctx.CurrentUser.loginAccountName);
 		$("#reportUnit_txt").unbind("click");
 	}
        loadSearchStyle();
        loadToolbar();
        loadData();
        var cateGoryDialog;
        $("#infoCategoryNames").click(function(){
                cateGoryDialog = $.dialog({
                    url: _ctxPath+"/info/infoStat.do?method=listInfoCategoryView&isGroup=true",
                    width: "400",
                    height: "300",
                    title: $.i18n('infosend.label.stat.infoTypeSelect'),//信息类型选择
                    id:'cateGoryDialog',
                    transParams:[window],
                    targetWindow:getCtpTop(),
                    closeParam:{
                        show:true,
                        autoClose:false,
                        handler:function(){
                            cateGoryDialog.close();
                        }
                    },
                    buttons: [{
                        id : "okButton",
                        btnType : 1,//按钮样式
                        text: $.i18n("common.button.ok.label"),
                        handler: function () {
                            var infoCategory=cateGoryDialog.getReturnValue();
                            $("#infoCategoryNames").val(infoCategory.auditerName);
                            $("#infoCategoryIds").val(infoCategory.ids);
                            cateGoryDialog.close();
                        }
                    }, {
                        id:"cancelButton",
                        text: $.i18n("common.button.cancel.label"),
                        handler: function () {
                            cateGoryDialog.close();
                        }
                    }]
                });
        });
        var  infoMagazine;
        $("#infoMagazineNames").click(function(){
            infoMagazine = $.dialog({
                url: _ctxPath+"/info/infoStat.do?method=listInfoMagazineView",
                width: "400",
                height: "300",
                title: $.i18n('infosend.label.stat.magazineSelect'),//期刊选择
                id:'cateGoryDialog',
                transParams:[window],
                targetWindow:getCtpTop(),
                closeParam:{
                    show:true,
                    autoClose:false,
                    handler:function(){
                        infoMagazine.close();
                    }
                },
                buttons: [{
                    id : "okButton",
                    btnType : 1,//按钮样式
                    text: $.i18n("common.button.ok.label"),
                    handler: function () {
                        var infoMagazines=infoMagazine.getReturnValue();
                        $("#infoMagazineNames").val(infoMagazines.auditerName);
                        $("#infoMagazineIds").val(infoMagazines.ids);
                        infoMagazine.close();
                    }
                }, {
                    id:"cancelButton",
                    text: $.i18n("common.button.cancel.label"),
                    handler: function () {
                        infoMagazine.close();
                    }
                }]
            });
        });
        
        var moreShow_st = 0;//更多状态
        $("#show_more").click(function () {
            if (moreShow_st==0) {
                $(this).html($.i18n('infosend.label.moreCondition') + '<span class="ico16 arrow_2_t"></span>');//更多条件
                $("#moreQuery").show();
                moreShow_st=1;
                $("#magazineidTDName").show();
                $("#magazineidTDValue").show();
                layout.setNorth(210);
                grid.grid.resizeGridAuto();
            }else {
                $(this).html($.i18n('infosend.label.moreCondition') + '<span class="ico16 arrow_2_b"></span>');//更多条件
                $("#moreQuery").hide();
                $("#magazineidTDName").hide();
                $("#magazineidTDValue").hide();
                moreShow_st=0;
                layout.setNorth(178);
                grid.grid.resizeGridAuto();
            }
        });
    });
 var layout;
 function loadSearchStyle() {
     
     //初始化布局
     layout = new MxtLayout({
         'id': 'layout',
         'northArea': {
             'id': 'north',
             'height': 178,
             'sprit': false,
             'border': false
         },
         'centerArea': {
             'id': 'center',
             'border': false,
             'minHeight': 20
         }
     });
 }
 function loadToolbar() {
     $("#toolbars").toolbar({
    	 isPager:false,
         toolbar: [{
             id: "exportExcel",
             name: $.i18n('infosend.draft.exportExcel'),//导出excel
             className: "ico16 export_excel_16", 
             click:doSearchExportExcel
         },{
             id: "print",
             name: $.i18n('infosend.label.print'),//打印
             className: "ico16 print_16",
             click:doPrint
         }]
     });
 }
 
 var searchobj;
 function loadCondition() {//搜索框
     
 }
 //加载页面数据
 var grid;
 function loadData() {
    //表格加载
     grid = $('#infoSearch').ajaxgrid({
         colModel: [{
             display: $.i18n("infosend.search.infoSubject"),//信息标题
             name: 'subject',
             sortable : true,
             width: '31%'
         }, {
             display: $.i18n(unitView),//上报单位
             name: 'reportUnit',
             sortable : true,
             hide:true,
             width: '12%'
         }, {
             display: $.i18n('infosend.listInfo.reportDept'),//上报部门
             name: 'reportDept',
             sortable : true,
             width: '13%'
         }, {
             display: $.i18n('infosend.search.reportDate'),//上报时间
             name: 'reportDate',
             ifFormat:'%Y-%m-%d',
             sortable : true,
             width: '13%'
         }, {
             display: $.i18n('infosend.listInfo.reporter'),//上报人
             name: 'reporter',
             sortable : true,
             hide:true,
             width: '12%'
         },{
             display: $.i18n('infosend.listInfo.infoTypeName'),//信息类型
             name: 'categoryName',
             sortable : true,
             width: '13%'
         },{
             display: $.i18n('infosend.listInfo.score.scoreAutoMatic'),//系统积分
             name: 'scoreAutoMatic',
             sortable : true,
             width: '10%'
         },{
             display: $.i18n('infosend.listInfo.score.scoreManual'),//手动评分
             name: 'scoreManual',
             sortable : true,
             width: '10%'
         },{
             display: $.i18n('infosend.listInfo.score.scoreTotal'),//总分
             name: 'scoreTotal',
             sortable : true,
             width: '10%'
         },{
             display: $.i18n('infosend.label.journal'),//期刊
             name: 'magazineNames',
             sortable : true,
             hide:true,
             width: '20%'
         }],
         click: dbclickRow,
         //dblclick: dbclickRow,
         render : rend,
         showTableToggleBtn: true,
         parentId: "center",
         vChange: true,
         vChangeParam: {
             overflow: "hidden",
            autoResize:true
         },
         resizable : false,
         slideToggleBtn: true,
         managerName : "infoSearchManager",
         managerMethod : "getInfoBySearch"
     });
 }

 function rend(txt, data, r, c) {
     if(c === 0){
         txt="<span class='grid_black'>"+txt;
         //附件
         if(data.attachment === true){
             txt = txt + "<span class='ico16 affix_16'></span>" ;
         }
         //信息类型
         if(data.bodyType!==""&&data.bodyType!==null&&data.bodyType!=="10"&&data.bodyType!=="30"){
             txt = txt+ "<span class='ico16 office"+data.bodyType+"_16'></span>";
         }
         //流程状态
         if(data.state !== null && data.state !=="" && data.state != "0"){
             txt = "<span class='ico16  flow"+data.state+"_16 '></span>"+ txt ;
         }
         txt = txt +"</span>";
     }
     if(c == 6) {//自动评分
         txt = "<a class='scoreA color_blue' onClick='openInfoScoreAutoMaticRecord(\""+data.summaryId+"\")'>" + txt + "</a>" ;
     } else if(c == 7) {//手工评分
         txt = "<a class='scoreA color_blue' onClick='openInfoScoreManualRecord(\""+data.summaryId+"\")'>" + txt + "</a>" ;
     }
     return txt;
 }
 
 function dbclickRow(data, rowIndex, colIndex) {
     if(colIndex == 6 || colIndex == 7) {
         return;
     }
     var _url = _ctxPath+"/info/infoDetail.do?method=summary&openFrom=Done&id="+data.summaryId;
     var title = data.subject;
     doubleClick(_url,escapeStringToHTML(title));
}
 
function doubleClick(url,title){
     var parmas = [$('#summary'),$('.slideDownBtn')];
     showSummayDialogByURL(url,title,parmas);
}
 

function doSearchExportExcel(){
   var url = _ctxPath + "/info/infoSearch.do?method=transExportExcelInfo";
   var subject = $("#subject").val();
   if (subject != "") {
       url += "&subject=" + subject;
   }
   //分类ids
   var infoCategoryIds = $("#infoCategoryIds").val();
   if (infoCategoryIds != "") {
       url += "&categoryId="+ infoCategoryIds;
   }
   //期刊IDs
   var infoMagazineIds = $("#infoMagazineIds").val();
   if (infoMagazineIds !="") {
       url += "&magazineId=" + infoMagazineIds;
   }
   //部门IDs
   var reportDept = $("#reportDept").val();
   if (reportDept != "") {
       url += "&reportDeptId=" + reportDept;
   }
   //单位IDs
   var reportUnit = $("#reportUnit").val();
   if (reportUnit != "") {
       url += "&reportUnitId=" + reportUnit;
   }
   //期号
   var magazineNo = $("#magazineNo").val();
   if (magazineNo != "" ) {
       url += "&magazineNo=" + magazineNo;
   }
 //上报时间
   var fromDate = $('#from_reportDate').val();
   var toDate = $('#to_reportDate').val();
   if(fromDate != "" && toDate != "" && fromDate > toDate){
       $.alert($.i18n('infosend.listInfo.fromTimeToEndTime'));//开始时间不能大于结束时间
       return;
   }
   if(fromDate != ""){
       url += "&fromReportDate=" + fromDate;;
   }
   if (toDate != "") {
       url += "&toReportDate=" + toDate;;
   }
   //发布时间
   var frompublishDate = $('#from_publishDate').val();
   var topublishDate = $('#to_publishDate').val();
   if(frompublishDate != "" && topublishDate != "" && frompublishDate > topublishDate){
       $.alert($.i18n('infosend.listInfo.fromTimeToEndTime'));//开始时间不能大于结束时间
       return;
   } 
   if(frompublishDate != "" ){
       url += "&fromPublishDate=" + frompublishDat;
   } 
   if( topublishDate != "") {
       url += "&toPublishDate=" + topublishDate;
   }
   
   //发布范围
   var publishRange = $("#publishRange").val();
   if (publishRange != "") {
       url += "&publishRange=" + publishRange;
   }
   
   var downLoadIframe = document.getElementById("hiddenIframe"); 
   if(downLoadIframe){ 
       downLoadIframe.src = encodeURI(url); 
   }
}


//打印信息查询列表
function doPrint(){
    var printSubject ="";
    var printsub = $.i18n('infosend.state.label.infoQueryList');//信息查询列表
    printsub = "<center><span style='font-size:24px;line-height:24px;margin-top:10px'>"+printsub+"</span><hr style='height:1px' class='Noprint'></hr></center>";
    
    var printColBody= $.i18n('infosend.label.subject');//标题
    var colBody ="<div>"+ $('#center').html() + "</div>";

    var printSubFrag = new PrintFragment(printColBody,printsub);  
    var colBodyFrag= new PrintFragment(printSubject,colBody);  
    var cssList = new ArrayList();
    
    var pl = new ArrayList();
    pl.add(printSubFrag);
    pl.add(colBodyFrag);
    printList(pl,cssList);
}
function gridChangeTable() {
  //拖动列表打印样式替换
    var mxtgrid = jQuery(".flexigrid");
    if(mxtgrid.length > 0 ){
        jQuery(".hDivBox thead th div").each(function(){
            var _html = $(this).html();
            $(this).parent().html(_html);
        });
        var tableHeader = jQuery(".hDivBox thead");
        
        jQuery(".bDiv tbody td div").each(function(){
            var _html = $(this).html();
            $(this).parent().html(_html);
        });
        
        var tableBody = jQuery(".bDiv tbody");
        var str = "";
        var headerHtml =tableHeader.html();
        var bodyHtml = tableBody.html();
        if(headerHtml == null || headerHtml == 'null')
            headerHtml ="";
        if(bodyHtml == null || bodyHtml=='null'){
            bodyHtml="";
        }
        if(mxtgrid.hasClass('dataTable')){
          str+="<table class='table-header-print table-header-print-dataTable' border='0' cellspacing='0' cellpadding='0'>"
        }else{
          str+="<table class='table-header-print' border='0' cellspacing='0' cellpadding='0'>"
        }
        str+="<thead>";
        str+=headerHtml;
        str+="</thead>";
        str+="<tbody>";
        str+=bodyHtml;
        str+="</tbody>";
        str+="</table>";
        var parentObj = mxtgrid.parent();
        mxtgrid.remove();
        parentObj.html(str);
        jQuery(".flexigrid a").removeAttr('onclick');
    }
}
function searchInfo() {
    var o = new Object();
    var subject = $("#subject").val();
    if (subject != "") {
        o.subject = subject;
    }
    //分类ids
    var infoCategoryIds = $("#infoCategoryIds").val();
    if (infoCategoryIds != "") {
        o.categoryId = infoCategoryIds;
    }
    //期刊IDs
    var infoMagazineIds = $("#infoMagazineIds").val();
    if (infoMagazineIds !="") {
        o.magazineId = infoMagazineIds;
    }
    //部门IDs
    var reportDept = $("#reportDept").val();
    if (reportDept != "") {
        o.reportDeptId = reportDept;
    }
    //单位IDs
    var reportUnit = $("#reportUnit").val();
    if (reportUnit != "") {
        o.reportUnitId = reportUnit;
    }

    //期号
    var magazineNo = $("#magazineNo").val();
    var patrn=/^[\d]+$/;
    if(magazineNo != "" && ( !patrn.exec(magazineNo) || magazineNo.length > 4)){
        $.alert($.i18n('infosend.magazine.create.fourOfTheNumbers'));
        return false;
    }else if(magazineNo != "") {
        o.magazineNo = magazineNo;
    }
    
    //上报时间
    var fromDate = $('#from_reportDate').val();
    var toDate = $('#to_reportDate').val();
    if(fromDate != "" && toDate != "" && fromDate > toDate){
        $.alert($.i18n('infosend.listInfo.fromTimeToEndTime'));//开始时间不能大于结束时间
        return;
    } else if(fromDate != "" || toDate != ""){
        var date = fromDate+'#'+toDate;
        o.reportDate = date;
    }
    //发布时间
    var frompublishDate = $('#from_publishDate').val();
    var topublishDate = $('#to_publishDate').val();
    if(frompublishDate != "" && topublishDate != "" && frompublishDate > topublishDate){
        $.alert($.i18n('infosend.listInfo.fromTimeToEndTime'));//开始时间不能大于结束时间
        return;
    } else if(frompublishDate != "" || topublishDate != ""){
        var publishDate = frompublishDate+'#'+topublishDate;
        o.publishLastTime = publishDate;
    }
    //发布范围
    var publishRange = $("#publishRange").val();
    if (publishRange != "") {
        o.publishRange = publishRange;
    }
    o.condition = "query";
    $("#infoSearch").ajaxgridLoad(o);
}

function resetQuery() {
    $("#subject").val("");
    //分类ids
    $("#infoCategoryNames").val("");
    $("#infoCategoryIds").val("");
    //期刊IDs
    $("#infoMagazineNames").val("");
    $("#infoMagazineIds").val("");
    //部门IDs
    $("#reportDept").val("");
    $("#reportDept_txt").val("");
    //单位IDs
    $("#reportUnit").val("");
    $("#reportUnit_txt").val("");
    //期号
    $("#infoMagazineNames").val("");
    $("#magazineNo").val("");
    
    //上报时间
    $('#from_reportDate').val("");
    $('#to_reportDate').val("");
    //发布时间
    $('#from_publishDate').val("");
    $('#to_publishDate').val("");
    //发布范围
    $("#publishRange").val("");
}




 
