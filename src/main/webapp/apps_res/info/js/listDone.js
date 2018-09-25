 $(document).ready(function () {
        loadStyle();
        loadToolbar();
        loadCondition();
        loadData();
        
    });
 function loadToolbar() {
     $("#toolbars").toolbar({
    	 isPager:false,
         toolbar: [{
             id: "filing",
             name: $.i18n("infosend.listInfo.file"),//归档
             className: "ico16 filing_16" ,
             click:checkArchive
         },{
             id: "delteInfo",
             name: $.i18n("infosend.listInfo.deleteInfo"),//删除
             className: "ico16 del_16",
             click:deleteInfo
         },{
             id: "exportExcel",
             name: $.i18n('infosend.draft.exportExcel'),//导出excel
             className: "ico16 export_excel_16", // click:exportExcel
             click:doExportExcel
         }]
     });
 }
 
 var searchobj;
 function loadCondition() {//搜索框
     var topSearchSize = 2;
     if($.browser.msie && $.browser.version=='6.0'){
         topSearchSize = 5;
     }
     searchobj = $.searchCondition({
         top:topSearchSize,
         right:85,
         searchHandler: function(){
             var o = new Object();
             var choose = $('#'+searchobj.p.id).find("option:selected").val();
             if(choose === 'subject'){
                 o.subject = $('#subject').val();
             }else if(choose === 'reportUnit'){
                 o.reportUnit = $('#reportUnit').val();
             }else if(choose === 'reportDept'){
                 o.reportDept = $('#reportDept').val();
             }else if(choose === 'reportDate'){
                 var fromDate = $('#from_reportDate').val();
                 var toDate = $('#to_reportDate').val();
                 if(fromDate != "" && toDate != "" && fromDate > toDate){
                     $.alert($.i18n('infosend.listInfo.fromTimeToEndTime'));//开始时间不能大于结束时间
                     return;
                 }
                 var date = fromDate+'#'+toDate;
                 o.reportDate = date;
             }else if(choose === 'subState'){
                 o.subState = $('#subStateName').val();
             }
             var val = searchobj.g.getReturnValue();
             if(val !== null){
                 o.listType = listType;
                 o.condition = choose;
                 searchConditionObj = o;
                 $("#listDone").ajaxgridLoad(o);
             }
         },
         conditions: [{
             id: 'subject',
             name: 'subject',
             type: 'input',
             text: $.i18n("cannel.display.column.subject.label"),//标题
             value: 'subject',
             maxLength:100
         },{
             id: 'reportDate',
             name: 'reportDate',
             type: 'datemulti',
             text: $.i18n('infosend.listInfo.reportDate'),//上报日期
             value: 'reportDate',
             ifFormat:'%Y-%m-%d',
             dateTime: false
         },{
             id: 'reportUnit',
             name: 'reportUnit',
             type: 'input',
             text: $.i18n(unitView),//上报单位
             value: 'reportUnit',
             maxLength:100
         },{
             id: 'reportDept',
             name: 'reportDept',
             type: 'input',
             text: $.i18n('infosend.listInfo.reportDept'),//上报部门
             value: 'reportDept',
             maxLength:100
         }]
     });
  }
 //加载页面数据
 var grid;
 function loadData() {
    //表格加载
     grid = $('#listDone').ajaxgrid({
         colModel: [{
             display: 'id',
             name: 'id',
             width: '5%',
             type: 'checkbox',
             isToggleHideShow:false
         }, {
             display: $.i18n("cannel.display.column.subject.label"),//标题
             name: 'subject',
             sortable : true,
             width: '38%'
         }, {
             display: $.i18n(unitView),//上报单位
             name: 'reportUnit',
             sortable : true,
             width: '19%'
         }, {
             display: $.i18n('infosend.listInfo.reportDept'),//上报部门
             name: 'reportDept',
             sortable : true,
             hide:true,
             width: '12%'
         }, {
             display: $.i18n('infosend.listInfo.reportDate'),//上报日期
             name: 'reportDate',
             ifFormat:'%Y-%m-%d',
             sortable : true,
             width: '19%'
         }, {
             display: $.i18n('infosend.listInfo.dealTime'),//处理时间
             name: 'dealTime',
             ifFormat:'%Y-%m-%d',
             sortable : true,
             hide:true,
             width: '19%'
         }, {
             display: $.i18n('infosend.listInfo.dealDeadLine'),//处理期限
             name: 'dealDealLine',
             sortable : true,
             hide:true,
             width: '19%'
         }, {
             display: $.i18n('infosend.listInfo.reporter'),//上报人
             name: 'reporter',
             sortable : true,
             hide:true,
             width: '12%'
         },{
             display: $.i18n('infosend.listInfo.rsEditor'),//责任编辑
             name: 'rsEditor',
             sortable : true,
             hide:true,
             width: '12%'
         },{
             display: $.i18n('infosend.listInfo.infoTypeName'),//信息类型
             name: 'infoTypeName',
             sortable : true,
             width: '19%'
         }],
         click: dbclickRow,
         //dblclick: dbclickRow,
         render : rend,
         showTableToggleBtn: true,
         parentId: $('.layout_center').eq(0).attr('id'),
         vChange: true,
         vChangeParam: {
             overflow: "hidden",
            autoResize:true
         },
         resizable : false,
         slideToggleBtn: true,
         managerName : "infoListManager",
         managerMethod : "getInfoDoneList"
     });
     //页面底部说明加载
     //$('#summary').attr("src",_ctxPath+"/info/infoList.do?method=infoListDesc&listType="+listType+"&total="+grid.p.total);
 }
 var TimeFn = null;
 function clickRow(data, rowIndex, colIndex){
	 //取消上次延时未执行的方法
	 clearTimeout(TimeFn);
	 TimeFn = setTimeout(function(){
		 $('#summary').attr("src", _ctxPath+"/info/infoDetail.do?method=summary&openFrom=Done&affairId="+data.affairId);}
	 ,400);
 }
 function dbclickRow(data, rowIndex, colIndex){
	 //取消上次延时未执行的方法
	 clearTimeout(TimeFn);
	 
	 var _url = _ctxPath+"/info/infoDetail.do?method=summary&openFrom=Done&affairId="+data.affairId;
	 //$('#summary').attr("src", _ctxPath+"/info/infoDetail.do?method=summary&openFrom=Send&affairId="+data.affairId);
	 var title = data.subject;
	 doubleClick(_url,escapeStringToHTML(title));
	 grid.grid.resizeGridUpDown('down');
 }
 function rend(txt, data, r, c) {
     if(c === 1){
    	 txt = "<span class='grid_black'>"+txt;
         //附件
         if(data.hasAttsFlag === true){
             txt = txt + "<span class='ico16 affix_16'></span>" ;
         }
         //类型
         if(data.bodyType!==""&&data.bodyType!==null&&data.bodyType!=="10"&&data.bodyType!=="30"){
             txt = txt+ "<span class='ico16 office"+data.bodyType+"_16'></span>";
         }
         //流程状态
         if(data.state !== null && data.state !=="" && data.state != "0"){
             txt = "<span class='ico16  flow"+data.state+"_16 '></span>"+ txt ;
         }
         txt = txt +"</span>";
     }
     if(c === 6 && txt.indexOf("extended|") != -1){
    	txt = txt.replace("extended|", "");
     	//tex = "<font color=\"red\">" + txt + "</font>";
     }
     return txt;
 }
 
function doubleClick(url,title){
	 var parmas = [$('#summary'),$('.slideDownBtn'),$('#listDone')];
	 showSummayDialogByURL(url,title,parmas);
}
function deleteInfo() {
    deleteInfoByPramas(grid,"listDone",listType);
}

 
