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
             id: "delteInfo",
             name: $.i18n("infosend.listInfo.deleteInfo"),//删除
             className: "ico16 del_16",
             click:deleteInfo
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
             if(choose === 'subject') {
                 o.subject = $('#subject').val();
             } else if(choose === 'subState') {
                 o.subState = $('#subStateName').val();
             } else if(choose === 'auditState') {
                 o.auditState = $('#auditState').val();
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
             text: $.i18n('infosend.magazine.auditDone.journalName'),//标题   期刊名称
             value: 'subject',
             maxLength:100
         }, {
             id: 'auditState',
             name: 'auditState',
             type: 'select',
             text: $.i18n('infosend.magazine.list.condition.state'),//期刊状态
             value: 'auditState',
             items: [{
                 text: $.i18n('infosend.magazine.list.audit.state.3'),
                 value: '3'
             }, {
                 text: $.i18n('infosend.magazine.list.audit.state.4'),
                 value: '4'
             }]
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
             name: 'id',
             width: '5%',
             type: 'checkbox',
             isToggleHideShow:false
         }, {
             display: $.i18n('infosend.magazine.auditDone.journalName'),//标题    期刊名称
             name: 'subject',
             sortable : true,
             width: '38%'
         }, {
             display: $.i18n('infosend.magazine.auditDone.issue'),//期号
             name: 'magazineNo',
             sortable : true,
             hide:false,
             width: '19%'
         },  {
             display: $.i18n('infosend.magazine.auditDone.journalStatus'),//期刊状态
             name: 'auditStateName',
             sortable : true,
             hide:false,
             width: '19%'
         }, {
             display: $.i18n('infosend.magazine.auditDone.auditTime'),//审核日期
             name: 'auditTime',
             ifFormat:'%Y-%m-%d',
             sortable : true,
             width: '19%'
         }, {
             display: $.i18n('infosend.magazine.auditDone.creater'),//创建人
             name: 'creater',
             sortable : true,
             hide:true,
             width: '15%'
         },{
             display:$.i18n('infosend.magazine.auditDone.createTime'),//创建日期
             name: 'createTime',
             sortable : true,
             hide:true,
             width: '12%'
         },{
             display: $.i18n('infosend.magazine.auditDone.reviewer'),//  审核人
             name: 'auditMemberNames',
             sortable : true,
             hide:true,
             width: '15%'
         }],
         click: dbclickRow,
         //dblclick: dbclickRow,
         //render : rend,
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
         managerMethod : "getInfoMagazineDoneList"
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
	 var _url = _ctxPath+"/info/magazine.do?method=summary&openFrom=Done&affairId="+data.affairId;
	 //$('#summary').attr("src", _ctxPath+"/info/infoDetail.do?method=summary&openFrom=Send&affairId="+data.affairId);
	 var title = data.subject;
	 doubleClick(_url,escapeStringToHTML(title));
	 //grid.grid.resizeGridUpDown('down');
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
	var rows = grid.grid.getSelectRows();
    if(rows.length === 0){
    	$.alert($.i18n('infosend.magazine.auditDone.deleteTheJournal')); // 请选择要删除的期刊！
        return;
    }
    var magazineIds = "";
    for(var count = 0 ; count < rows.length; count ++) {
        if(count == rows.length -1){
        	magazineIds += rows[count].id;
        }else{
        	magazineIds += rows[count].id +",";
        }
    }

    if(confirm($.i18n('infosend.magazine.auditDone.canNotBeRestored'))) {  // 确定删除期刊吗？该操作不能恢复
    	var manager = new magazineListManager();
        var flag = manager.deleteMagazineAndAffairManager(magazineIds);
        if(flag == "success") {
        	window.location.reload();
        }
    }
}


