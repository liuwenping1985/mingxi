 $(document).ready(function () {
	 	//初始化布局
	    new MxtLayout({
	        'id': 'layout',
	        'northArea': {
	            'id': 'north',
	            'height': 30,
	            'sprit': false,
	            'border': false
	        },
	        'centerArea': {
	            'id': 'center',
	            'border': false,
	            'minHeight': 20
	        }
	    });
        //loadToolbar();
        loadCondition();
        loadData();
        
    });
 
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
                     $.alert($.i18n('infosend.listInfo.fromTimeToEndTime'));//开始时间不能大于结束时间!
                     return;
                 }
                 var date = fromDate+'#'+toDate;
                 o.reportDate = date;
             }else if(choose === 'subState'){
                 o.subState = $('#subStateName').val();
             }
             var val = searchobj.g.getReturnValue();
             if(val !== null){
                 o.listType = "listOverAndPending";
                 o.condition = choose;
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
             text: $.i18n('infosend.listInfo.reportTime'),//上报时间
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
        	 id: 'id',
             name: 'id',
             width: '5%',
             isToggleHideShow:false
         }, {
             display: $.i18n("cannel.display.column.subject.label"),//标题
             name: 'subject',
             sortable : true,
             width: '30%'
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
             width: '14%'
         }, {
             display: $.i18n('infosend.listInfo.reportDate'),//上报日期
             name: 'reportDate',
             ifFormat:'%Y-%m-%d',
             sortable : true,
             width: '25%'
         }, {
             display: $.i18n('infosend.listInfo.reporter'),//上报人
             name: 'reporter',
             sortable : true,
             hide:true,
             width: '15%'
         },{
             display: $.i18n('infosend.listInfo.rsEditor'),//责任编辑
             name: 'rsEditor',
             sortable : true,
             width: '14%'
         },{
             display: $.i18n('infosend.listInfo.infoTypeName'),//信息类型
             name: 'infoTypeName',
             sortable : true,
             width: '12%'
         }],
         click: clickRow,
         dblclick: dbclickRow,
         render : rend,
         //showTableToggleBtn: true,
         parentId: $('.layout_center').eq(0).attr('id'),
         //vChange: true,
         //vChangeParam: {
         //    overflow: "hidden",
         //   autoResize:true
         //},
         //slideToggleBtn: true,
         //height:$(document).height()-38,
         height:300,
         managerName : "infoListManager",
         managerMethod : "getInfoOverAndPendingList"
     });
     
     var o = new Object();
     o.listType = "listOverAndPending"; //OA-55103
     $("#listDone").ajaxgridLoad(o);
     //页面底部说明加载
     //$('#summary').attr("src",_ctxPath+"/info/infoList.do?method=infoListDesc&listType="+listType+"&total="+grid.p.total);
 }
 
 function selectInfo(obj) {
	 parent.quoteDocumentSelected(obj, obj.name, 'info', obj.value);
 }
 
 function deselectItem(fileUrl){
	$("#boxId[value='"+fileUrl+"']").attr("checked", false);
}
 
 function rend(txt, data, r, c,col) {
	 if(c===1){
		 txt = "<span class='grid_black'>"+txt;
	        //附件
	        if(data.hasAttsFlag === true){
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
	 if(col.id === "id"){
		 var mapOptions = parent.window.dialogArguments[0].fileUploadAttachments.instanceKeys.instance
		 for(var k = 0; k <mapOptions.length; k++) {
			 if(mapOptions[k] == data.id){
				 txt = "<input type='checkbox' checked='checked' id='boxId' name='"+data.subject+"' onclick='selectInfo(this)' value='"+data.id+"'/>";
				 return txt;
			 }
		 }
		 txt = "<input type='checkbox' id='boxId' name='"+data.subject+"' onclick='selectInfo(this)' value='"+data.id+"'/>";
	 }
	 return txt;
 }
 
 function dbclickRow(data, rowIndex, colIndex){
 }
 function clickRow(data, rowIndex, colIndex){
	 
	 if(colIndex == "0"){
		 return ;
	 }
	 var _url = _ctxPath+"/info/infoDetail.do?method=summary&openFrom=Done&affairId="+data.affairId+"&id="+data.id;
	 var title = data.subject;
	 doubleClick(_url,escapeStringToHTML(title));
	 //grid.grid.resizeGridUpDown('down');
 }
 
function doubleClick(url,title){
	 var parmas = [$('#summary'),$('.slideDownBtn'),$('#listDone')];
	 //getCtpTop().showSummayDialogByURL(url,title,parmas);
	 showSummayDialogByURL(url,title,parmas);
}
function deleteInfo() {
    deleteInfoByPramas(grid,"listDone",listType);
}

 
