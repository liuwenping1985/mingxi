<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>BillTempForm</title>
<script type="text/javascript" src="${path}/ajax.do?managerName=ncVoucherManager"></script>
<script type="text/javascript" language="javascript">

$().ready(function() {
	var pManager = new ncVoucherManager();
	var toolbar = $("#toolbar").toolbar({
	    toolbar: [{
	      id: "add",
	      name: '${ctp:i18n("ncvoucher.plugin.make.label")}',
	      className: "ico16",
	      click: function() {
    	      var v = $("#mytable").formobj({
    	        gridFilter : function(data, row) {
    	          return $("input:checkbox", row)[0].checked;
    	        }
    	      });
    	      if (v.length < 1) {
    	      	  $.alert('${ctp:i18n("ncvoucher.plugin.selectdata.alert")}');
    	        }else if(v.length >1){
    	        	$.alert('${ctp:i18n("ncvoucher.plugin.onedata.alert")}');
    	        }else {
    	           var summaryId=v[0].summaryId;
       	             var dialog = $.dialog({
   					    url:"${pageContext.request.contextPath}/ncVoucherController.do?method=voucherGetGlorgCode",
   					    width: 500,
   					    height: 300,
   					    
   					    title: "${ctp:i18n('ncvoucher.plugin.name.title')}",//选择账簿

   					    buttons: [{
   					        text: "${ctp:i18n('common.button.ok.label')}", //确定
   					        handler: function () {
   					           var rv = dialog.getReturnValue();
   							   var ncAccount = rv[0];
   					           var glorgcode = rv[1];
   					           var billdate = rv[2];
   					           var url = "${pageContext.request.contextPath}/ncVoucherController.do?method=voucherGenerate&summaryId="+summaryId+"&glorgcode="+glorgcode+"&ncAccount="+ncAccount+"&billdate="+billdate;
   			    	      		$.ajax({
   			    	      			async:false,
   			    	      			url:url,
   			    	      			type:"GET",
   			    	      			cache: false,
   			    	      			success:function(data){
   			    	      				var r = new RegExp("\n","g");
   			    	      				data = data.replace(r,"<br>");
   			    	      				var msg = '${ctp:i18n("ncvoucher.plugin.start.processing")}';
   			    	      				var index = data.indexOf(msg);
   			    	      				if(index!=-1){
   			    	      					var str = data.substring(index+msg.length);
   			    	      					var index1 = str.indexOf("nc.bs.gl.pfxx.VoucherPlugin");
   			    	      					if(index1!=-1){
   			    	      						$.alert(str.substring(index1+"nc.bs.gl.pfxx.VoucherPlugin".length+1));
   			    	      					}else{
   			    	      						$.alert(str);
   			    	      					}
   			    	      				}else{
   			    	      					$.alert(data);
   			    	      				} 
   			    	      			},
   			    	      			error:function(data){
   			    	      				$.alert(data);
   			    	      			}
   			    	      		});
   			    	      		$("#mytable").ajaxgridLoad(o1);
   			    	      		
   					           dialog.close();
   					        }
   					    }, {
   					        text: "${ctp:i18n('common.button.cancel.label')}", //取消
   					        handler: function () {
   					            dialog.close();
   					        }
   					    }]
   					  });	
	      	}
	      }
	    },
	    {
		      id: "done",
		      name: '${ctp:i18n("ncvoucher.plugin.doneform.label")}',
		      className: "ico16",
		      click: function() {
		    	  pManager.showDoneCollaborationList({
                      success: function() {
                      	$("#mytable").ajaxgridLoad(o1);
                      }
                  });
		      }
	    }]
	   
	  });
    //列表
    var grid = $("#mytable").ajaxgrid({
    	click: clickRow,
        dblclick: dbclickRow,
        colModel: [{
            display: 'id',
            name: 'id',
            width: '10%',
            align: 'center',
            type: 'checkbox'
        },
        {
            display: '${ctp:i18n("common.subject.label")}',//标题
            name: 'subject',
            sortname : 'summary.subject',
            sortable : true,
            width: '35%'
        }
        ,
        {
            display: '${ctp:i18n("cannel.display.column.sendUser.label")}',//发起人
            name: 'startMemberName',
            sortname : 'affair.senderId',
            sortable : true,
            width: '15%'
        }
        , 
        {
            display: '${ctp:i18n("common.date.sendtime.label")}',//发起时间
            name: 'createDate',
            sortname : 'summary.createDate',
            sortable : true,
            width: '20%'
        },
        {
            display: '${ctp:i18n("common.date.donedate.label")}',//处理时间
            name: 'updateDate',
            sortname : 'affair.updateDate',
            sortable : true,
            width: '20%'
        }
        ],
        width: "auto",
        managerName: "ncVoucherManager",
        managerMethod: "showBindCollaborationList",
        parentId:'center'      
    });
  /* //页面底部说明加载
    $('#summary').attr("src","collaboration.do?method=listDesc&type=listDone&size="+1); */
    //加载表格
    var o1 = new Object();
    $("#mytable").ajaxgridLoad(o1);
    var searchobj = $.searchCondition({
    top: 1,
    right: 10,
    searchHandler: function() {
      ssss = searchobj.g.getReturnValue();
      $("#mytable").ajaxgridLoad(ssss);
    },
    conditions: [{
      id: 'search_code',
      name: 'search_code',
      type: 'input',
      text: '${ctp:i18n("common.subject.label")}',
      value: 'subject'
    } ,{
      id: 'search_name',
      name: 'search_name',
      type: 'input',
      text: '${ctp:i18n("cannel.display.column.sendUser.label")}',
      value: 'startMemberName'
    }]
  });
   function getCount() {
    cnt = mytable.p.total;
    $("#count").get(0).innerHTML = msg.format(cnt);
  }
   
 //定义setTimeout执行方法
   var TimeFn = null;
   function clickRow(data,rowIndex, colIndex) {
       // 取消上次延时未执行的方法
       /* clearTimeout(TimeFn);
       //执行延时
       TimeFn = setTimeout(function(){
           $('#summary').attr("src","collaboration.do?method=summary&openFrom=listDone&affairId="+data.affairId);
       },300); */
   }
   
   //双击事件
   function dbclickRow(data,rowIndex, colIndex){
       // 取消上次延时未执行的方法
       /* clearTimeout(TimeFn);
       var url = _ctxPath + "/collaboration/collaboration.do?method=summary&openFrom=listDone&affairId="+data.affairId;
       var title = data.subject;
       doubleClick(url,title);
       grid.grid.resizeGridUpDown('down'); */
   }
});
</script>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
    	<div class="comp" comp="type:'breadcrumb',code:'F21_10104_voucherGenerateIndex'"></div>
        <div class="layout_north" layout="height:30,sprit:false,border:false">
        	<div id="toolbar"></div>
	        <div id="searchDiv"></div>
    	</div>
        <div class="layout_center" id="center" layout="border:false" style='overflow:hidden;overflow-y:hidden'>
            <table id="mytable" class="flexme3" style="display: none"></table>
            <div id="grid_detail" class="h100b">
                <iframe id="summary"  width="100%" height="100%" frameborder="0"  class='calendar_show_iframe' style="overflow-y:hidden"></iframe>
            </div>
    </div>
</body>
</html>