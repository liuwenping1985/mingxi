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
             id: "publish",
             name: $.i18n('infosend.magazine.publishPending.publish'),//批处理  发布
             className: "ico16 send_16",
             click:publishRange
         }]
     });
 }
 function publishRange(){
	 var id_checkbox = grid.grid.getSelectRows();
	  if (id_checkbox.length === 0) {
	      $.alert($.i18n('infosend.magazine.publishPending.dataReleased'));  // 请选择需要发布的数据!
	      return;
	  }else{
		  var ids='';
	    	for(i=0;i<id_checkbox.length;i++){
	    		ids+=id_checkbox[i].id;
	    		ids+=',';
	    	}
	    	ids = ids.substring(0,ids.length-1);
	    	$("#selectIds").val(ids);
	    	$("#publishMagazineIds").val(ids);
	  }
	  //Office控件检查
	  if(!hasOffice("40", false, $.i18n("infosend.alert.officeNotAvailable"))) {//Office控件不可用，请使用IE浏览器或重新安装Office控件！
          return;
      }
	  openMagazinePublishDialog();
 }
 var queryDialog;
 function classifyViews(){
	 var v = $("#listPending").formobj({
			gridFilter: function(data, row) {
		 	return $("input:checkbox", row)[0].checked;
	 	}
	 });
	if (v.length < 1) {
	    $.alert($.i18n('infosend.listInfo.selectClassInfo'));//请选择要分类的信息！
		return ;
	}
	var ids = "";
	for (i = 0; i < v.length; i++) {
		if (i != v.length - 1) {
			ids = ids + v[i].id + ",";
        } else {
        	ids = ids + v[i].id;
        }
	}
	var _url = _ctxPath + "/info/info.do?method=classifyViews&id_str=" + ids;
	queryDialog = $.dialog({
        url: _url,
        width: 250,
        height: 300,
        title: $.i18n('infosend.draft.classify'), //分类
        id:'showCategory',
        transParams:[window],
        targetWindow:getCtpTop(),
        buttons: [{
        		text:$.i18n("common.button.ok.label"),
        		btnType : 1,//按钮样式
        		handler:function(){
        			var rv = queryDialog.getReturnValue();
		        	if(rv === "error"){
		        	    $.alert($.i18n('infosend.listInfo.selectTypeInfo')); //请选择一条信息类型！
					}else {
	        			queryDialog.close();
	        			var o = new Object();
	        			o.listType = listType;
	        			$("#listPending").ajaxgridLoad(o);
					}
        		}
        	},{
        		text:$.i18n("common.button.cancel.label"),
        		handler:function(){
        			queryDialog.close();
        		}
        	}
        ]
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
             }else if(choose === 'createTime'){
            	  var fromDate = $('#from_createTime').val();
                  var toDate = $('#to_createTime').val();
                  if(fromDate != "" && toDate != "" && fromDate > toDate){
                      $.alert($.i18n('infosend.listInfo.fromTimeToEndTime'));//开始时间不能大于结束时间
                      return;
                  }
                  var date = fromDate+'#'+toDate;
                  o.createTime = date;
             }else if(choose === 'auditTime'){
            	 var fromDate = $('#from_auditTime').val();
                 var toDate = $('#to_auditTime').val();
                 if(fromDate != "" && toDate != "" && fromDate > toDate){
                     $.alert($.i18n('infosend.magazine.publishPending.timeDifference'));//开始时间不能大于结束时间
                     return;
                 }
                 var date = fromDate+'#'+toDate;
                 o.auditTime = date;
             }
             var val = searchobj.g.getReturnValue();
             if(val !== null){
                 o.listType = listType;
                 o.condition = choose;
                 searchConditionObj = o;
                 $("#listPending").ajaxgridLoad(o);
             }
         },
         conditions: [{
             id: 'subject',
             name: 'subject',
             type: 'input',
             text: $.i18n('infosend.magazine.publishPending.journalName'),//标题   期刊名称
             value: 'subject',
             maxLength:100
         },{
             id: 'magazineNo',
             name: 'magazineNo',
             type: 'input',
             text: $.i18n('infosend.magazine.publishPending.issue'),//期号
             value: 'magazineNo',
             maxLength:100
         },{
             id: 'createTime',
             name: 'createTime',
             type: 'datemulti',
             text: $.i18n('infosend.magazine.publishPending.createTime'),//创建时间
             value: 'createTime',
             ifFormat:'%Y-%m-%d',
             dateTime: false
         },{
             id: 'auditTime',
             name: 'auditTime',
             type: 'datemulti',
             text: $.i18n('infosend.magazine.publishPending.auditTime'),//审核时间
             value: 'auditTime',
             ifFormat:'%Y-%m-%d',
             dateTime: false
         }]
     });
  }
 //加载页面数据
 var grid;
 function loadData() {
    //表格加载
     grid = $('#listPending').ajaxgrid({
         colModel: [{
             display: 'id',
             name: 'id',
             affairId: 'affairId',
             width: '5%',
             type: 'checkbox',
             isToggleHideShow:false
         }, {
             display: $.i18n('infosend.magazine.publishPending.journalName'),//期刊名称
             name: 'subject',
             sortable : true,
             width: '35%'
         }, {
             display:$.i18n('infosend.magazine.publishPending.issue'),//期号
             name: 'magazineNo',
             hide:false,
             sortable : true,
             width: '15%'
         }, {
             display: $.i18n('infosend.magazine.publishPending.createTime'),//创建时间
             name: 'createTime',
             ifFormat:'%Y-%m-%d',
             sortable : true,
             width: '15%'
         }, {
             display:$.i18n('infosend.magazine.publishPending.auditTime'),//审核时间
             name: 'auditTime',
             sortable : true,
             width: '15%'
         }, {
             display:$.i18n('infosend.magazine.publishPending.reviewer'),//审核人
             name: 'auditMemberNames',
             sortable : true,
             hide:false,
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
         managerMethod : "getAllPublishPendingList"
     });
     //页面底部说明加载
     //$('#summary').attr("src",_ctxPath+"/info/infoList.do?method=infoListDesc&listType="+listType+"&total="+grid.p.total);
 }
 var TimeFn = null;
 function clickRow(data, rowIndex, colIndex){
	 //取消上次延时未执行的方法
	 clearTimeout(TimeFn);
	 TimeFn = setTimeout(function(){
		 $('#summary').attr("src", _ctxPath+"/info/infoDetail.do?method=summary&openFrom=Pending&affairId="+data.affairId);}
	 ,400);
 }
 function dbclickRow(data, rowIndex, colIndex){
	 //取消上次延时未执行的方法
	 clearTimeout(TimeFn);
	 if(data.isOld) {
		 openMagazineList(data.id, data.subject, 3);
	 } else {
		var _url = _ctxPath+"/info/magazine.do?method=summaryPublish&openFrom=Pending&magazineId="+data.id;
	 	//$('#summary').attr("src", _ctxPath+"/info/infoDetail.do?method=summary&openFrom=Send&affairId="+data.affairId);
	 	var title = data.subject;
	 	doubleClick(_url,escapeStringToHTML(title));
	 	grid.grid.resizeGridUpDown('down');
	}
 }

 function rend(txt, data, r, c) {
     //未读  11  加粗显示
     var subState = data.subState;
     if(subState === 11){
         //TODO txt = "<span class='font_bold'>"+txt+"</span>";
     }
     if(c === 1){
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
     }else if(c === 8){
         var titleTip = subState;
         if (subState === 16 || subState === 17 || subState === 18 ) {
            titleTip  = 16;
         };
         var toolTip = $.i18n('collaboration.toolTip.label' + titleTip);

         if(subState === 12){
             return "<span class='ico16 viewed_16' title='"+ toolTip +"'></span>" ;
         }else{
             return "<span class='ico16 pending" + subState + "_16' title='"+ toolTip +"'></span>" ;
         }
     }
     return txt;
 }

function doubleClick(url,title){
	 var parmas = [$('#summary'),$('.slideDownBtn'),$('#listPending')];
	 showSummayDialogByURL(url,title,parmas);
}


/**弹出发布范围**/
var magazineRangeDialog
function magazineRange(){
	var data = new Date();
	magazineRangeDialog = $.dialog({
        url: _ctxPath+"/info/magazine.do?method=publishRange",
        width: "700",
        height: "500",
       	title: $.i18n('infosend.magazine.publishPending.release'),   // 发布
        id:'magazineRangeDialog',
        transParams:{"win":window},
        targetWindow:getCtpTop(),
        closeParam:{
            show:true,
            autoClose:false,
            handler:function(){
            	magazineRangeDialog.close();
            }
        },
        buttons: [{
            id : "okButton",
            btnType : 1,//按钮样式
            text: $.i18n("common.button.ok.label"),
            handler: function () {
        		var values = magazineRangeDialog.getReturnValue();
        		if(values==undefined){
        			return;
        		}
        		$("#publishRange").val(values.checkPublistTypes);
        		$("#viewPeopleId").val(values.viewPeopleId);
        		$("#publicViewPeopleId").val(values.publicViewPeopleId);
        		$("#orgSelectedTree").val(values.orgSelectedTree);
        		$("#UnitSelectedTree").val(values.UnitSelectedTree);
        		$("#viewPeople").val(values.viewPeople);
        		$("#publicViewPeople").val(values.publicViewPeople);
        		submitFuncPublish();
        		magazineRangeDialog.close();
           }
        }, {
            id:"cancelButton",
            text: $.i18n("common.button.cancel.label"),
            handler: function () {
            	magazineRangeDialog.close();
            }
        }]
    });
}

function submitFuncPublish(){
	   var url =_ctxPath+"/info/magazine.do?method=pendingPublish";
		var domains =[];
	   	domains.push("magazinePublishRange");
	   	domains.push("publishRange");
	   	domains.push("viewPeopleId");
	   	domains.push("publicViewPeopleId");
	   	domains.push("orgSelectedTree");
	   	domains.push("UnitSelectedTree");
	   	domains.push("selectIds");
	   	$("#magazinePublishRange").jsonSubmit({
		    domains : domains,
		    debug : false,
		    action:url,
		    callback: function(data){
		    	$("#listPending").ajaxgridLoad();
	        }
	    });
}