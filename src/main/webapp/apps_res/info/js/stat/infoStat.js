var selectMembers;
$(document).ready(function(){
      //loadCondition();
     // loadData();
      toFromDate();
      loadInitClick();
});

function loadInitClick(){

	 new inputChange($("#infoMagazineNames"),$.i18n('infosend.label.stat.clickSelect'));
	 new inputChange($("#infoScoreNames"),"请点击选择");
	 new inputChange($("#infoCategoryNames"),"请点击选择");
	 var moreShow_st = 0;//更多状态
	    $("#show_more").click(function () {
	        if (moreShow_st==0) {
	            $(this).html('更多统计条件<span class="ico16 arrow_2_t"></span>');
	            $(".newinfo_more").show();
	            $("#submitOne").hide();
	            $("#submitTwo").show();
	            moreShow_st=1;
	        }else {
	            $(this).html('更多统计条件<span class="ico16 arrow_2_b"></span>');//更多统计条件
	            $(".newinfo_more").hide();
	            $("#submitOne").show();
	            $("#submitTwo").hide();
	            moreShow_st=0;
	        }
	    });

	$("#orgSelect").click(function(){
	      $.selectPeople({
	          type:'selectPeople',
	          panels:'Account,Department',
	          selectType:'Account,Department,Member',
	          text:$.i18n('common.default.selectPeople.value'),
	          hiddenPostOfDepartment:true,
	          hiddenRoleOfDepartment:true,
	          showFlowTypeRadio:false,
	          returnValueNeedType: true,
	          params:{
	             value: selectMembers
	          },
	          targetWindow:window.top,
	          callback : function(res){
	              if(res && res.obj && res.obj.length>0){
	            	  var selPeopleId="" ;
	            	  var selPeopleName="" ;
                    for (var i = 0; i < res.obj.length; i ++){
                        if (i == res.obj.length -1){
                            selPeopleId +=res.obj[i].type+"|"+res.obj[i].id;
                            selPeopleName+=res.obj[i].name;

                        } else {
                            selPeopleId+=res.obj[i].type+"|"+res.obj[i].id+ "," ;
                            selPeopleName+=res.obj[i].name+",";
                        }
                    }
                    selectMembers = res.value;
                    $("#orgSelect" ).val(selPeopleName);
                    $("#viewPeopleId").val(selPeopleId);
	              } else {

	              }
	         }
	      });
	});

	var cateGoryDialog;
	$("#infoCategoryNames").click(function(){
			cateGoryDialog = $.dialog({
		        url: _ctxPath+"/info/infoStat.do?method=listInfoCategoryView",
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
		            	$("#infoCategoryIds").val(infoCategory.auditerId);
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
	            	$("#infoMagazineIds").val(infoMagazines.auditerId);
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
	var infoScore;
	$("#infoScoreNames").click(function(){
		infoScore = $.dialog({
	        url: _ctxPath+"/info/infoStat.do?method=listInfoScoreView",
	        width: "400",
	        height: "300",
	       	title: $.i18n('infosend.label.stat.infoScore'),//信息评分标准
	        id:'cateGoryDialog',
	        transParams:[window],
	        targetWindow:getCtpTop(),
	        closeParam:{
	            show:true,
	            autoClose:false,
	            handler:function(){
	            	infoScore.close();
	            }
	        },
	        buttons: [{
	            id : "okButton",
	            btnType : 1,//按钮样式
	            text: $.i18n("common.button.ok.label"),
	            handler: function () {
	            	var infoScores=infoScore.getReturnValue();
	            	$("#infoScoreNames").val(infoScores.auditerName);
	            	$("#infoScoreIds").val(infoScores.auditerId);
	            	infoScore.close();
	            }
	        }, {
	            id:"cancelButton",
	            text: $.i18n("common.button.cancel.label"),
	            handler: function () {
	            	infoScore.close();
	            }
	        }]
	    });
	});
	$("#btnSave").click(function(){
		submitSearch(0);
	});

	$("#btnSaveMore").click(function(){
		submitSearch(0);
	});
	$("#btnCancelMore").click(function(){
		cancelSearch();
	});
	$("#btnCancel").click(function(){
		cancelSearch();
	});
}
function cancelSearch(){
	
	var fdate=new Date();
	var tdate=new Date();
	fdate.setDate(1);
	var fromDate=fdate.print("%Y-%m-%d");
	var toDate=tdate.print("%Y-%m-%d");
	$("#infoCategoryNames").val("请点击选择");
	$("#infoCategoryIds").val("");
	$("#infoMagazineNames").val("请点击选择");
	$("#infoMagazineIds").val("");
	$("#infoScoreNames").val("请点击选择");
	$("#infoScoreIds").val("");
	$("#orgSelect").val(orgName);
	$("#fromdate").val(fromDate);
	$("#todate").val(toDate);
	$("#viewPeopleId").val("");

}


function submitSearch(searchType){
	var orgName=$("#orgSelect").val();
	var fromdate=$("#fromdate").val();
	var todate=$("#todate").val();
	if(fromdate== "" && todate==""){
		alert("请输入统计时间！");
		return;
	}
	if(fromdate!= "" && todate==""){
		alert("请选择截止时间段!");
		return ;
	}
	if(fromdate== "" && todate!=""){
		alert("请选择起始时间!");
		return ;
	}
	if(orgName==""){
		alert("请选择您要统计的组织范围！");
		return;
	}
	if(fromdate>todate){
		alert("开始时间不能大于结束时间！");
		return;
	}
	$("#autoReloadWindowSearch").val("1");
	var form1=document.getElementById("searchform");
	if(searchType ==1){
		form1=parent.document.getElementById("searchform");
	}
	form1.action =_ctxPath+"/info/infoStat.do?method=listInfoSearchStat";
	form1.target = "content";
	form1.submit();
}
//加载页面数据
var grid;
function loadData() {
   //表格加载
    grid = $('#listStat').ajaxgrid({
        colModel: [{
            display:"组织",
            name: 'scoreManual',
            sortable : true,
            width: '30%'
        }, {
            display:"报送数",
            name: '',
            sortable : true,
            width: '12%'
        },  {
            display: "采用数",
            name: '',
            sortable : true,
            hide:false,
            width: '12%'
        }, {
            display:"采用率",
            name: '',
            sortable : true,
            width: '12%'
        }, {
            display: "系统积分",
            name: 'scoreAutoMatic',
            sortable : true,
            hide:true,
            width: '15%'
        },{
            display:"手动评分",
            name: 'scoreManual',
            sortable : true,
            hide:true,
            width: '12%'
        },{
            display:"总分数",
            name: '',
            sortable : true,
            hide:true,
            width: '15%'
        }],
        showTableToggleBtn: true,
        vChange: true,
        vChangeParam: {
           overflow: "hidden",
           autoResize:true
        },
        resizable : false,
        slideToggleBtn: true,
        managerName : "infoStatManager",
        managerMethod : "listInfoScore"
    });
}

function toFromDate(){
	var fdate=new Date();
	var tdate=new Date();
	fdate.setDate(1);
	var fromDate=fdate.print("%Y-%m-%d");
	var toDate=tdate.print("%Y-%m-%d");
	$("#fromdate").val(fromDate);//开始时间：默认显示当前时间
	$("#todate").val(toDate);
}

function exportToExcel(){
	var form1=document.getElementById("searchform");
	form1.action =_ctxPath+"/info/infoStat.do?method=listInfoExcel";
	form1.target = "content";
	form1.submit();
}

/**弹出发布范围**/
var statRangeDialog
function statzineRange(){
	var data = new Date();
	statRangeDialog = $.dialog({
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
            	statRangeDialog.close();
            }
        },
        buttons: [{
            id : "okButton",
            btnType : 1,//按钮样式
            text: $.i18n("common.button.ok.label"),
            handler: function () {
        		var values = statRangeDialog.getReturnValue();
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
        		statRangeDialog.close();
           }
        }, {
            id:"cancelButton",
            text: $.i18n("common.button.cancel.label"),
            handler: function () {
            	statRangeDialog.close();
            }
        }]
    });
}

function submitFuncPublish(){
	 var statTitle=$("#statTitle").html();
	 var htmls = $("#statTable").html();
	 htmls = $(htmls).find("a").each(function(){
		 $(this).after($(this).text()).remove();
	 }).end()[0].outerHTML;
	 var smanage = new infoStatManager();
	 var tranObj = new Object();
     tranObj.content = htmls;
     tranObj.statTitle = statTitle;
     tranObj.publishRange=$("#publishRange").val();
     tranObj.viewPeopleId=$("#viewPeopleId").val();
     tranObj.publicViewPeopleId=$("#publicViewPeopleId").val();
     tranObj.orgSelectedTree=$("#orgSelectedTree").val();
     tranObj.UnitSelectedTree=$("#UnitSelectedTree").val();
     tranObj.viewPeople=$("#viewPeople").val();
     tranObj.publicViewPeople=$("#publicViewPeople").val();
     tranObj.selectIds=$("#selectIds").val();
     tranObj.viewPeople=$("#viewPeople").val();
     smanage.publishStat(tranObj,{
    	 success : function(){
        	 alert("统计结果发布成功!");
         },
         error : function(request, settings, e){
             $.alert("发布失败！");
         }
      });
}
function loadToolbar() {
    $("#toolbars").toolbar({
    	isPager:false,
        toolbar: [{
            id: "infoPublish",
            name: "结果发布",//结果发布
            className: "ico16 send_16" ,
            click:openMagazinePublishDialog
        },{
            id: "exportExcel",
            name: "导出Excel",//导出Excel
            className: "ico16 export_excel_16",
            click:parent.exportToExcel
        }]
    });
}
var infoStatDialog;
function openInfoStatDialog(url,title) {
  	var width = 900;
  	var height = 460;
  	infoStatDialog = $.dialog({
        url: url,
        width: width,
        height: height,
        title: title,
        id:'infoDialog',
        transParams: window,
        closeParam: {
          'show':true,
          autoClose:false,
          handler:function() {
        	  submitSearch(1);
        	  infoStatDialog.close();
          }
        },
        buttons: [{
            id:"cancelButton",
            text: $.i18n("common.button.cancel.label"),
            handler: function () {
            	submitSearch(1);
            	infoStatDialog.close();
            }
        }],
        targetWindow:getCtpTop()
    });
}