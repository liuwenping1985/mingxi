<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script type="text/javascript"src="${path}/ajax.do?managerName=m3IsignatureManager"></script>
<script type="text/javascript">
var dialog;
$().ready(function() {
  var ssss;
  var cnt;
  var grid;
  var lashpsottype = 1;
  var msg = '${ctp:i18n("info.totally")}';
  var misignature = new m3IsignatureManager();
  $("#signatureKeyForm").hide();
  $("#button").hide();
  $("#welcome").show();
 
  function addform() {
    $("#signatureKeyForm").clearform({
      clearHidden: true
    });
    $("#signatureKeyForm").enable();
    $("#signatureKeyForm").show();
    $("#button").show();
    $("#welcome").hide();
    $("#lconti").show();
    $("#formType").val("add");
    $("#conti").attr("checked", 'checked');
    $("input[id=stateFlag]:eq(0)").attr("checked", 'checked');
    $("input[id=sortIdtype]:eq(0)").attr("checked", 'checked');

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
      name: "${ctp:i18n('common.toolbar.delete.label')}",
      className: "ico16 del_16",
      click: function() {
		$("#signatureKeyForm").hide();
		$("#button").hide();
		$("#welcome").show();
        var v = $("#mytable").formobj({
          gridFilter: function(data, row) {
            return $("input:checkbox", row)[0].checked;
          }
        });
        if (v.length < 1) {
            $.alert("${ctp:i18n('m3.isignature.userkey.selectInfoMore')}");
          } else {
            var ids = new Array();
            for (var  i = 0; i < v.length; i++) {
              ids.push(v[i].userID);
            }
          $.confirm({
			title: "${ctp:i18n('common.prompt')}",
            'msg': "${ctp:i18n('m3.isignature.userkey.deleteConfirm')}",
            ok_fn: function() {
            	misignature.deleteUserkeys(ids, {
                success: function(result) {
					//$.alert(result.message);
					$.messageBox({
                        'type': 0,
                        'imgType': 0,
                        'msg': result.message
                    });
                  $("#mytable").ajaxgridLoad(o);
                  grid.grid.resizeGridUpDown('down');
                }
              });
            }
          });
          };
      }
    }]
  });
//列表
   grid = $("#mytable").ajaxgrid({
    click: gridclk,
    dblclick: griddblclick,
    colModel: [{
        display: 'id',
        name: 'userID',
        width: '5%',
        sortable: false,
        align: 'center',
        type: 'checkbox'
      },
      {
        display: "${ctp:i18n('m3.isignature.userkey.userName')}",
        name: 'userName',
        sortable: true,
        width: '10%'
      },
      {
        display: "${ctp:i18n('m3.isignature.userkey.keysn')}",
        name: 'key',
        sortable: true,
        width: '60%'
      },
      {
        display: "${ctp:i18n('m3.isignature.userkey.createDate')}",
        name: 'createDate',
        sortable: true,
        width: '15%'
      }],
      managerName: "m3IsignatureManager",
      managerMethod: "getPageInfo",
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
    $("#signatureKeyForm").disable();
    $("#signatureKeyForm").show();
    $("#welcome").hide();
    $("#button").hide();
    var detil = misignature.viewOne(data.userID);
    $("#addForm").fillform(detil);
    $("#getkeySn").hide();
  };

  function griddblclick() {
	$("#memberName").attr("disabled",false);
    var v = $("#mytable").formobj({
      gridFilter: function(data, row) {
        return $("input:checkbox", row)[0].checked;
      }
    });
    if (v.length < 1) {
      $.alert("${ctp:i18n('m3.isignature.userkey.selectInfoOne')}");
    } else if (v.length > 1) {
      $.alert("${ctp:i18n('once.selected.one.record')}");
    } else {
      mytable.grid.resizeGridUpDown('middle');
      var mdetil = misignature.viewOne(v[0]["userID"]);
     
      $("#signatureKeyForm").clearform({
        clearHidden: true
      });
      $("#addForm").fillform(mdetil);
	  
      $("#conti").removeAttr("checked");
      $("#signatureKeyForm").enable();
      $("#button").show();
      $("#signatureKeyForm").show();
      $("#lconti").hide();
      $("#welcome").hide();
      $("#getkeySn").show();
      $("#formType").val("modify");
      $("input[id=sortIdtype]:eq(0)").attr("checked", 'checked');
    }
  };
  $("#btncancel").click(function() {
    location.reload();
  });
  $("#userName").click(function(){
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
	    	  checkUser(ret);
	    }
	});
  });
  $("#getkeySn").bind("click",function(){
	  getKeySn();
  });
  $("#btnok").click(function() {
    if (! ($("#signatureKeyForm").validate())) {
      return;
    }
    if (getCtpTop() && getCtpTop().startProc) getCtpTop().startProc();
    misignature.createUserKey($("#addForm").formobj({
      includeDisabled: true
    }), {
      success: function(result) {
        try {
          if (getCtpTop() && getCtpTop().endProc) {
            getCtpTop().endProc();
            var success = result.success;
            if(success == true) {
            	var type =$("#formType").val();
            	if("add" == type) {
            		//$.alert("${ctp:i18n('m3.isignature.userkey.addSuccess')}");
           		 	$.messageBox({
                        'type': 0,
                        'imgType': 0,
                        'msg': "${ctp:i18n('m3.isignature.userkey.addSuccess')}"
                    });

            	}else if ("modify" == type){
            		//$.alert("${ctp:i18n('m3.isignature.userkey.modifySuccess')}");
            		$.messageBox({
                        'type': 0,
                        'imgType': 0,
                        'msg': "${ctp:i18n('m3.isignature.userkey.modifySuccess')}"
                    });
            	}
            }else{
				$.alert(result.message);
            }
          }
        } catch(e) {};
        $("#mytable").ajaxgridLoad(o);
        if ($("#conti").attr("checked") == "checked") {
          lashpsottype = $("#typeId").val();
          addform();
        } else {
          $("#signatureKeyForm").hide();
          grid.grid.resizeGridUpDown('down');
          $("#button").hide();
          $("#welcome").show();
        }
      }
    });
  });

  function getCount() {
    cnt = mytable.p.total;
    $("#count").get(0).innerHTML = msg.format(cnt);
  };
  function getKeySn(){
	  var keySn = DocForm.SignatureControl.WebGetKeySN;
	  $.alert(keySn);
  }
  function checkUser(obj) {
	  var mdetil = misignature.viewOne(obj.value);
	  if(mdetil != null) {
		  //表示有数据 。提示用户是否修改
		   $.confirm({
				title: "${ctp:i18n('common.prompt')}",
	            'msg': "${ctp:i18n('m3.isignature.userkey.exists')}",
	            ok_fn: function() {
	            	$("#signatureKeyForm").clearform({
	                    clearHidden: true
	                  });
	                  $("#addForm").fillform(mdetil);
	            }
	          });
	  } else {
		  $("#userName").val(obj.text);
		  $("#userID").val(obj.value);
	  }
	  
  }
  
});
</script>