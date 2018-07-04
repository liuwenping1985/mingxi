<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<script type="text/javascript"
src="${path}/ajax.do?managerName=m3ClientBindService"></script>
<script type="text/javascript">
var dialog;
$().ready(function() {
  var ssss;
  var cnt;
  var grid;
  var msg = '${ctp:i18n("info.totally")}';
  var mbindService = new m3ClientBindService();
  $("#applyform").hide();
  $("#button").hide();
  //$("#welcome").hide();
  $("#welcome").show();

  function addform() {
    $("#applyform").clearform({
      clearHidden: true
    });
    $("#applyform").enable();
    $("#applyform").show();
    $("#button").show();
    $("#welcome").hide();
    $("#lconti").show();
   
    $("input[id=enabled]:eq(0)").attr("checked", 'checked');
    $("input[id=sortIdtype]:eq(0)").attr("checked", 'checked');
    
  }
  var toolbar = $("#toolbar").toolbar({
    toolbar: [{
      id: "agree",
      name: "${ctp:i18n('m3.handleOperationElement.attitudeAgree')}",
      className: "ico16 reference_benchmark_kong_16",
      click: gridagree

    },
    {
      id: "disagree",
      name: "${ctp:i18n('m3.handleOperationElement.attitudeDisAgree')}",
      className: "ico16 binding_benchmark_kong_16",
      click: griddisagree

    },
        {
        id: "selectView",
        text: "${ctp:i18n('m3.bind.apply.list')}",
        type:'select',
        value:2,
        onchange : changeView,
        items:[{
        	text:"${ctp:i18n('m3.bind.binded.list')}",
        	value:1
        }]
        }]
  });

   grid = $("#mytable").ajaxgrid({
    click: gridclk,
    
    colModel: [{
      display: 'id',
      name: 'id',
      width: '5%',
      sortable: false,
      align: 'center',
      type: 'checkbox'
    },
    {
      display: "${ctp:i18n('m3.bind.bind.memberNum')}",
      sortable: true,
      name: 'userName',
      width: '20%'
    },
    {
      display: "${ctp:i18n('m3.bind.clientName')}",
      sortable: true,
      name: 'clientName',
      width: '20%'
    },
    {
      display: "${ctp:i18n('m3.bind.clientType')}",
      sortable: true,
      name: 'clientType',
      width: '20%'
    },
    {
      display: "${ctp:i18n('m3.bind.binded.clientNum')}",
      name: 'clientNum',
      sortable: true,
      width: '20%'
    },
    {
        display: "${ctp:i18n('m3.bind.apply.applyDate')}",

        name: 'applyDate',
        sortable: true,
        width: '15%'
      }
    ],
    managerName: "m3ClientBindService",
    managerMethod: "getAllApplyVo",
    parentId: 'center',
    vChangeParam: {
      overflow: 'hidden',
      position: 'relative'
    },
    slideToggleBtn: true,
    showTableToggleBtn: true,
    vChange: true,
    callBackTotle: getCount
  });
  var o = new Object();
  $("#mytable").ajaxgridLoad(o);
  function gridclk(data, r, c) {
    mytable.grid.resizeGridUpDown('middle');
    $("#applyform").disable();
    $("#applyform").show();
    $("#welcome").hide();
    $("#button").show();
    var detil = mbindService.viewBindApplyOne(data.memberID,data.clientNum);
    $("#addForm").fillform(detil);
  }
 
  $("#btncancel").click(function() {
	  if (! ($("#applyform").validate())) {
	      return;
	    }
	    if (getCtpTop() && getCtpTop().startProc) getCtpTop().startProc();
	    mbindService.disagreeApply($("#addForm").formobj({
	      includeDisabled: true
	    }), {
	      success: function(result) {
			alert(result);
			try {
			
	          if (getCtpTop() && getCtpTop().endProc) {
			  
	            getCtpTop().endProc();
	          }
	        } catch(e) {};
	        $("#mytable").ajaxgridLoad(o);
	        $("#applyform").disable();
	        grid.grid.resizeGridUpDown('down');
	        $("#applyform").hide();
	        $("#welcome").show();
	        $("#button").hide();
	      }
	    });
  });
  $("#btnok").click(function() {
    if (! ($("#applyform").validate())) {
      return;
    }
    if (getCtpTop() && getCtpTop().startProc) getCtpTop().startProc();
    mbindService.agreeApply($("#addForm").formobj({
      includeDisabled: true
    }), {
      success: function(result) {
		
		try {
		if(result == -1){
			
			alert("${ctp:i18n('m3.bind.clientBinded')}");
		} else if (result == -2){

			alert("${ctp:i18n('m3.bind.apply.outnumber')}");
		} else {
			
		alert("${ctp:i18n('m3.bind.apply.disagree.label')}");
		}
          if (getCtpTop() && getCtpTop().endProc) {
		  
            getCtpTop().endProc();
          }
        } catch(e) {};
        $("#mytable").ajaxgridLoad(o);
        $("#applyform").disable();
        grid.grid.resizeGridUpDown('down');
        $("#applyform").hide();
        $("#welcome").show();
        $("#button").hide();
      }
    });
  });

  var searchobj = $.searchCondition({
    top: 7,
    right: 10,
    searchHandler: function() {
      ssss = searchobj.g.getReturnValue();
      ssss.newp=1;
      $("#mytable").ajaxgridLoad(ssss);
      grid.grid.resizeGridUpDown('down');
      $("#applyform").hide();
      $("#welcome").show();
      $("#button").hide();
    },
    conditions: [{
      id: 'search_name',
      name: 'search_name',
      type: 'input',
      text: "${ctp:i18n('m3.bind.apply.memberNum')}",
      value: 'memberName'
    },
    {
      id: 's_code',
      name: 's_code',
      type: 'input',
      text: "${ctp:i18n('m3.bind.binded.clientNum')}",
      value: 'clientNum'
    },
    {
        id: 's_cn',
        name: 's_code',
        type: 'input',
        text: "${ctp:i18n('m3.bind.clientName')}",
        value: 'clientName'
      },
	{
      id: 's_type',
      name: 's_type',
      type: 'select',
      text: "${ctp:i18n('m3.bind.clientType')}",
      value: 'clientType',
	  items:[{
        	text:"android",
        	value:"android"
        },
		{
        	text:"iPhone",
        	value:"iPhone"
        },
		{
        	text:"iPad",
        	value:"iPad"
        }]
    }]
  });
  //切换列表
  function changeView(){
  	window.location = "<c:url value='/m3/mClientBindController.do'/>?method=toBindManage";
  	
  }
  function gridagree(){
    $("#welcome").show();
    $("#button").hide();
	$("#applyform").hide();
   var boxs = $("#mytable input:checked");
      if (boxs.length === 0) {
          $.alert("${ctp:i18n('m3.bind.binded.noselect')}");
          return;
      } else {
          var confirm = $.confirm({
            'title': "${ctp:i18n('common.prompt')}",
            'msg': "${ctp:i18n('m3.bind.apply.agree')}",
            ok_fn: function() {
              if (boxs.length === 0) {
                $.alert("${ctp:i18n('m3.bind.binded.noselect')}");
                return;
              } else if (boxs.length >= 1) {
                var members = new Array();
                boxs.each(function() {
                  members.push($(this).val());
                });
				
             if (getCtpTop() && getCtpTop().startProc) getCtpTop().startProc();
				mbindService.agreeBindApplys(members, {
				  success: function(result) {
					try {
					
					  if (getCtpTop() && getCtpTop().endProc) {
						alert(result);
						getCtpTop().endProc()
					  }
					} catch(e) {};
					$("#mytable").ajaxgridLoad(o);
					grid.grid.resizeGridUpDown('down');
				  }
				});
              }
            },
            cancel_fn: function() {location.reload();}
          });
      }
  }
   function griddisagree(){
   $("#welcome").show();
    $("#button").hide();
	$("#applyform").hide();
   var boxs = $("#mytable input:checked");
      if (boxs.length === 0) {
          $.alert("${ctp:i18n('m3.bind.binded.noselect')}");
          return;
      } else {
          var confirm = $.confirm({
            'title': "${ctp:i18n('common.prompt')}",
            'msg': "${ctp:i18n('m3.bind.apply.disagree')}",
            ok_fn: function() {
              var boxs = $("#mytable input:checked");
              if (boxs.length === 0) {
                $.alert("${ctp:i18n('m3.bind.binded.noselect')}");
                return;
              } else if (boxs.length >= 1) {
                var members = new Array();
                boxs.each(function() {
                  members.push($(this).val());
                });
				
             if (getCtpTop() && getCtpTop().startProc) getCtpTop().startProc();
				mbindService.disagreeBindApplys(members, {
				  success: function(result) {
					try {
					alert(result);
					  if (getCtpTop() && getCtpTop().endProc) {
					  
						getCtpTop().endProc()
					  }
					} catch(e) {};
					$("#mytable").ajaxgridLoad(o);
					grid.grid.resizeGridUpDown('down');
				  }
				});
              }
            },
            cancel_fn: function() {location.reload();}
          });
      }
  }
  function getCount() {
    cnt = mytable.p.total;
    $("#count").get(0).innerHTML = msg.format(cnt);
  }
});
</script>