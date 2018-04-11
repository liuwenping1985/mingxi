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
  var lashpsottype = 1;
  var msg = '${ctp:i18n("info.totally")}';
  var mbindservice = new m3ClientBindService();
  $("#bindfromdiv").hide();
  $("#button").hide();
  //$("#welcome").hide();
  $("#welcome").show();
 
  function addform() {
    $("#bindfromdiv").clearform({
      clearHidden: true
    });
    $("#bindfromdiv").enable();
    $("#bindfromdiv").show();
    $("#button").show();
    $("#welcome").hide();
    $("#lconti").show();
    $("#conti").attr("checked", 'checked');
    $("#conti").attr("checked", 'checked');
    $("#androidOption").attr("selected",'selected');
    $("input[id=stateFlag]:eq(0)").attr("checked", 'checked');
    $("input[id=sortIdtype]:eq(0)").attr("checked", 'checked');
    $("#typeId").val(lashpsottype);

  }
  var toolbar = $("#toolbar").toolbar({
    toolbar: [{
      id: "add",
      name: "${ctp:i18n('common.toolbar.new.label')}",
      className: "ico16",
      click: function() {
        addform();
        mytable.grid.resizeGridUpDown('middle');
      }

    },
    {
      id: "modify",
      name: "${ctp:i18n('common.button.modify.label')}",
      className: "ico16 editor_16",
      click: griddblclick

    },
    {
      id: "delete",
      name: "${ctp:i18n('m3.bind.binded.delete')}",
      className: "ico16 del_16",
      click: function() {
		$("#bindfromdiv").hide();
		$("#button").hide();
		$("#welcome").show();
        var v = $("#mytable").formobj({
          gridFilter: function(data, row) {
            return $("input:checkbox", row)[0].checked;
          }
        });
        if (v.length < 1) {
            $.alert("${ctp:i18n('m3.bind.binded.noselect')}");

          } else {
            var name = "";
            for (var  i = 0; i < v.length; i++) {
              if (i != v.length - 1) {
                name = name + v[i].memberName + "、";
              } else {
                name = name + v[i].memberName;
              }
            }
          $.confirm({
			title: "${ctp:i18n('common.prompt')}",
            'msg': "${ctp:i18n('m3.bind.binded.delete.ok')}",
            ok_fn: function() {
            	mbindservice.deleteBindInfo(v, {
                success: function(result) {
					alert(result);
                  $("#mytable").ajaxgridLoad(o);
                  grid.grid.resizeGridUpDown('down');
                }
              });
            }
          });
          };
      }
    },
    {
      id: "starting",
      name: "${ctp:i18n('m3.bind.binded.starting')}",
      className: "ico16 reference_benchmark_kong_16",
      click: function() {
	   $("#bindfromdiv").hide();
    $("#button").hide();
    $("#welcome").show();
    	 var v = $("#mytable").formobj({
          gridFilter: function(data, row) {
            return $("input:checkbox", row)[0].checked;
          }
        });
        if (v.length < 1) {
            $.alert("${ctp:i18n('m3.bind.binded.noselect')}");

          } else {
		 var  clientNums = new Array();
            var name = "";
            for (var i = 0; i < v.length; i++) {
			clientNums[i] = v[i].clientNum;
              if (i != v.length - 1) {
                name = name + v[i].memberName + "、";
              } else {
                name = name + v[i].memberName;
              }
            }
          $.confirm({
			title: "${ctp:i18n('common.prompt')}",
			
           //msg: $.i18n("m1.bind.binded.starting.ok", name),
		   msg: "${ctp:i18n('m3.bind.binded.starting.ok')}",
            ok_fn: function() {
            	mbindservice.startingBindInfo(clientNums, {
                success: function(result) {
				alert(result);
                  $("#mytable").ajaxgridLoad(o);
                  grid.grid.resizeGridUpDown('down');
                }
              });
            }
          });
          };  
      }
    },
    {
      id: "forbidden",
      name: "${ctp:i18n('m3.bind.binded.forbidden')}",
      className: "ico16 binding_benchmark_kong_16",
      click: function() {
		$("#bindfromdiv").hide();
		$("#button").hide();
		$("#welcome").show();
    	   var v = $("#mytable").formobj({
          gridFilter: function(data, row) {
            return $("input:checkbox", row)[0].checked;
          }
        });
        if (v.length < 1) {
            $.alert("${ctp:i18n('m3.bind.binded.noselect')}");

          } else {
            var name = "";
			var clientNums = new Array();
            for (var i = 0; i < v.length; i++) {
			clientNums[i] = v[i].clientNum;
              if (i != v.length - 1) {
                name = name + v[i].memberName + "、";
              } else {
                name = name + v[i].memberName;
              }
            }
          $.confirm({
		  title: "${ctp:i18n('common.prompt')}",
            msg: "${ctp:i18n('m3.bind.binded.forbidden.ok')}",
            ok_fn: function() {
            	mbindservice.forbiddenInfos(clientNums, {
                success: function(result) {
					alert(result);
                  $("#mytable").ajaxgridLoad(o);
                  grid.grid.resizeGridUpDown('down');
                }
              });
            }
          });
          };
      }
    },
    {
        id: "selectView",
        text: "${ctp:i18n('m3.bind.binded.list')}",
        type:'select',
        value:2,
        onchange : changeView,
        items:[{
        	text:"${ctp:i18n('m3.bind.apply.list')}",
        	value:1
        }]
      }]
  });

   grid = $("#mytable").ajaxgrid({
    click: gridclk,
    dblclick: griddblclick,
    colModel: [{
        display: 'id',
        name: 'memberID',
        width: '5%',
        sortable: false,
        align: 'center',
        type: 'checkbox'
      },
      {
        display: "${ctp:i18n('m3.bind.bind.memberNum')}",
        name: 'memberName',
        sortable: true,
        width: '20%'
      },
      {
        display: "${ctp:i18n('m3.bind.clientName')}",
        name: 'clientName',
        sortable: true,
        width: '10%'
      },
      {
        display: "${ctp:i18n('m3.bind.clientType')}",
        name: 'clientType',
        sortable: true,
        width: '20%'
      },
      {
        display: "${ctp:i18n('m3.bind.binded.clientNum')}",
        name: 'clientNum',
        
        sortable: true,
        width: '15%'
      },
      {
        display: "${ctp:i18n('m3.bind.binded.date')}",
        name: 'bindDate',
        sortable: true,
        width: '20%'
      },
      {
          display:"${ctp:i18n('m3.bind.binded.state')}",
          name: 'state',
          sortable: true,
          width: '10%'
        }],
      managerName: "m3ClientBindService",
      managerMethod: "getAllBindedVo",
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
    $("#bindfromdiv").disable();
    $("#bindfromdiv").show();
    $("#welcome").hide();
    $("#button").hide();
    var detil = mbindservice.viewBindedOne(data.memberID,data.clientNum);
    $("#memberForm").fillform(detil);
  }
  
  //切换列表
  function changeView(){
  	window.location = "<c:url value='/m3/mClientBindController.do'/>?method=toBindApply";
  }
  function griddblclick() {
	$("#memberName").attr("disabled",false);
    var v = $("#mytable").formobj({
      gridFilter: function(data, row) {
        return $("input:checkbox", row)[0].checked;
      }
    });
    if (v.length < 1) {
      $.alert("${ctp:i18n('m3.bind.binded.noselect')}");
    } else if (v.length > 1) {
      $.alert("${ctp:i18n('once.selected.one.record')}");
    } else {
      mytable.grid.resizeGridUpDown('middle');
      var mdetil = mbindservice.viewBindedOne(v[0]["memberID"],v[0]["clientNum"]);
     
      $("#bindfromdiv").clearform({
        clearHidden: true
      });
      $("#memberForm").fillform(mdetil);
	  
      $("#conti").removeAttr("checked");
      $("#bindfromdiv").enable();
      $("#button").show();
      $("#bindfromdiv").show();
      $("#lconti").hide();
      $("#welcome").hide();
      $("input[id=sortIdtype]:eq(0)").attr("checked", 'checked');
    }
  }
  $("#btncancel").click(function() {
    location.reload();
  });
  $("#memberName").click(function(){
	  $.selectPeople({
	      type: 'selectPeople',
	      text:'',
	      value:'',
	      panels: 'Department,Outworker',
	      selectType: 'Member',
	      minSize:1,
	      maxSize:1,
	      showConcurrentMember:false,
	      onlyLoginAccount: true,
	      returnValueNeedType: false,
	      callback: function(ret) {
	    	  document.getElementById("memberName").value = ret.text;
	    	  document.getElementById("memberID").value = ret.value;
	    }
	});
  });
  $("#btnok").click(function() {
    if (! ($("#bindfromdiv").validate())) {
      return;
    }
    if (getCtpTop() && getCtpTop().startProc) getCtpTop().startProc();
    mbindservice.createBindInfo($("#memberForm").formobj({
      includeDisabled: true
    }), {
      success: function(result) {
        try {
          if (getCtpTop() && getCtpTop().endProc) {
            getCtpTop().endProc();
			alert(result);
			
          }
        } catch(e) {};
        $("#mytable").ajaxgridLoad(o);
        if ($("#conti").attr("checked") == "checked") {
          lashpsottype = $("#typeId").val();
          addform();
        } else {
          $("#bindfromdiv").hide();
          grid.grid.resizeGridUpDown('down');
          $("#button").hide();
          $("#welcome").show();
        }
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
      text: "${ctp:i18n('m3.bind.bind.memberNum')}",
      value: 'memberName'
    },
    {
      id: 's_code',
      name: 's_code',
      type: 'input',
      text: "${ctp:i18n('m3.bind.binded.clientNum')}",
      value: 'clientNum'
    },{
    	id: 's_clientName',
        name: 's_code',
        type: 'input',
        text: "${ctp:i18n('m3.bind.clientName')}",
        value: 'clientName'
    },
	{
      id: 's_clientType',
      name: 's_clientType',
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
  function getCount() {
    cnt = mytable.p.total;
    $("#count").get(0).innerHTML = msg.format(cnt);
  }
});
</script>