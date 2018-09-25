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
             id: "cancel",
             name: $.i18n('infosend.magazine.publishDone.unpublish'),//取消发布
             className: "ico16 revoked_process_16",
             click:cancelPublishMagazine
         },{
             id: "filing",
             name: $.i18n('infosend.magazine.publishDone.file'),//归档
             className: "ico16 filing_16",
             click:checkArchive
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
         right:10,
         searchHandler: function(){
             var o = new Object();
             var choose = $('#'+searchobj.p.id).find("option:selected").val();
             if(choose === 'subject'){
                 o.subject = $('#subject').val();
             }else if(choose === 'magazineNo'){
                 o.magazineNo = $('#magazineNo').val();
             }else if(choose === 'publishLastTime'){
            	  var fromDate = $('#from_publishLastTime').val();
                  var toDate = $('#to_publishLastTime').val();
                  if(fromDate != "" && toDate != "" && fromDate > toDate){
                      $.alert($.i18n('infosend.magazine.publishDone.timeDifference'));//开始时间不能大于结束时间
                      return;
                  }
                  var date = fromDate+'#'+toDate;
                  o.publishLastTime = date;
             }else if(choose === 'publishRange'){
                 o.publishRange = $('#publishRange').val();
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
             text: $.i18n('infosend.magazine.publishDone.journalName'),//标题  期刊名称
             value: 'subject',
             maxLength:100
         },{
             id: 'magazineNo',
             name: 'magazineNo',
             type: 'input',
             text: $.i18n('infosend.magazine.publishDone.issue'),//期号
             value: 'magazineNo',
             maxLength:100
         },{
             id: 'publishLastTime',
             name: 'publishLastTime',
             type: 'datemulti',
             text: $.i18n('infosend.magazine.publishDone.publishTime'),//发布时间
             value: 'publishLastTime',
             ifFormat:'%Y-%m-%d',
             dateTime: false
         },{
             id: 'publishRange',
             name: 'publishRange',
             type: 'input',
             text: $.i18n('infosend.magazine.publishDone.publishedRange'),//发布范围
             value: 'publishRange',
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
             affairId: 'affairId',
             id: 'id',
             value: 'id',
             name: 'id',
             width: '5%',
             type: 'checkbox',
             isToggleHideShow:false
         }, {
             display: $.i18n('infosend.magazine.publishDone.journalName'),//期刊名称
             name: 'subject',
             sortable : true,
             width: '35%'
         }, {
             display:$.i18n('infosend.magazine.publishDone.issue'),//期号
             name: 'magazineNo',
             sortable : true,
             hide:false,
             width: '20%'
         }, {
             display: $.i18n('infosend.magazine.publishDone.publishTime'),//发布时间
             name: 'publishLastTime',
             ifFormat:'%Y-%m-%d',
             sortable : true,
             width: '20%'
         }, {
             display: $.i18n('infosend.magazine.publishDone.publishedRange'),//发布范围
             name: 'publishRange',
             sortable : true,
             width: '20%'
         }],
         click: dbclickRow,
         //dblclick: dbclickRow,
        // render : rend,
         showTableToggleBtn: true,
         parentId: $('.layout_center').eq(0).attr('id'),
         vChange: true,
         vChangeParam: {
             overflow: "hidden",
            autoResize:true
         },
         resizable : false,
         slideToggleBtn: true,
         managerName : "magazineListManager",
         managerMethod : "getAllPublishDoneList"
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
	 if(data.isOld) {
		 openMagazineList(data.id, data.subject, 4);
	 } else {
		var _url = _ctxPath+"/info/magazine.do?method=summaryPublish&openFrom=Done&magazineId="+data.id;
		 //$('#summary').attr("src", _ctxPath+"/info/infoDetail.do?method=summary&openFrom=Send&affairId="+data.affairId);
		 var title = data.subject;
		 doubleClick(_url,escapeStringToHTML(title));
		 grid.grid.resizeGridUpDown('down');
	 }
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
     return txt;
 }

function doubleClick(url,title){
	 var parmas = [$('#summary'),$('.slideDownBtn'),$('#listDone')];
	 showSummayDialogByURL(url,title,parmas);
}

function deleteInfo() {
    deleteInfoByPramas(grid,"listDone",listType);
}

var cancelDialog;
function cancelPublishMagazine() {
	var id_checkbox = grid.grid.getSelectRows();
	if (id_checkbox.length === 0) {
		//请选择需要撤销的协同！
		$.alert($.i18n('infosend.listInfo.selectCancelOnePublishMagazine'))
		return;
	}
	if(id_checkbox.length > 1){
		//只能选择一条记录!
		$.alert($.i18n('infosend.listInfo.selectCancelOnePublishMagazine'));
	    return;
	}
	cancelDialog = $.dialog({
        url:  _ctxPath + "/info/magazinelist.do?method=openMagazinePublishCancelDialog",
        width: 500,
        height: 240,

        title: $.i18n('infosend.magazine.publishDone.unpublish'), //取消发布

        id:'cancelDialog',
        transParams:[window],
        targetWindow:getCtpTop(),
        closeParam:{
            show:true,
            autoClose:false,
            handler:function(){
            	cancelDialog.close();
            }
        },
        buttons: [{
            id : "okButton",
            text: $.i18n("common.button.ok.label"),
            btnType : 1,//按钮样式
            handler: function () {
                var comment = cancelDialog.getReturnValue();
                if (!comment) {
                	$.alert($.i18n('infosend.magazine.publish.alert.notNullPostscript'));//撤销附言不能为空！
					return;
				}
                //长度验证
                if(comment.length > 100){
                	$.alert($.i18n('infosend.magazine.publish.alert.maxLenPostscript') + comment.length);//撤销附言不能超过100字，当前字数为
					return;
                }
                cancelDialog.close();
                var magazineIds = id_checkbox[0].id;
            	var manager = new magazineListManager();
                var flag = manager.deletePublishMagazine(magazineIds, comment);
                if(flag == "success") {
                	window.location.reload();
            	}
           }
        }, {
            id:"cancelButton",
            text: $.i18n("common.button.cancel.label"),
            handler: function () {
            	cancelDialog.close();
            }
        }]
    });
	  
}


