<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=mLbsAuthorManager"></script>
<script type="text/javascript">

var dialog;
$().ready(function() {
  var ssss;
  var cnt;
  var grid;
  var msg = '${ctp:i18n("info.totally")}';
  var mLbsAuthor = new mLbsAuthorManager();
  var  o = new Object();
  $("#M1LbsAuthor").hide();
  $("#button").hide();
  $("#welcome").show();
  function addform() {
    $("#M1LbsAuthor").clearform({
      clearHidden: true
    });
    $("#oprType").val("1");
    $("#M1LbsAuthor").enable();
    $("#M1LbsAuthor").show();
    $("#button").show();
    $("#welcome").hide();
    $("#lconti").show();
   
    $("input[id=enabled]:eq(0)").attr("checked", 'checked');
    $("input[id=sortIdtype]:eq(0)").attr("checked", 'checked');
    
  }
  var toolbar = $("#toolbar").toolbar({
    toolbar: [{
      id: "create",
      name: "${ctp:i18n('common.toolbar.new.label')}",
      className: "ico16",
      click: function() {
          addform();
          mytable.grid.resizeGridUpDown('middle');
        }

    },
    {
      id: "edit",
      name: "${ctp:i18n('common.button.modify.label')}",
      className: "ico16 editor_16",
      click: griddblclick

    },
    {
        id: "delete",
        name: "${ctp:i18n('common.toolbar.delete.label')}",
        className: "ico16 delete del_16",
        click: deleteInfo

      }] 
  });

   grid = $("#mytable").ajaxgrid({
	   click: gridclk,
	   dblclick: griddblclick,
    
    colModel: [{
      display: 'id',
      name: 'authorUserId',
      width: '5%',
      sortable: false,
      align: 'center',
      type: 'checkbox'
    },
    {
      display: "${ctp:i18n('m1.lbs.authorUser')}",
      sortable: true,
      name: 'authorUserName',
      width: '10%'
    },
    {
      display: "${ctp:i18n('m1.lbs.authorScope')}",
      sortable: true,
      name: 'scopes',
      width: '85%'
    }
    ],
    managerName: "mLbsAuthorManager",
    managerMethod: "getAll",
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
    $("#M1LbsAuthor").disable();
    $("#M1LbsAuthor").show();
    $("#welcome").hide();
    $("#button").hide();
    var detil = mLbsAuthor.viewOneInfo(data.authorUserId);
    $("#M1LbsAuthor").fillform(detil);
  }
 
  $("#btncancel").click(function() {
	  location.reload();
  });
  $("#scopes").click(function(){
	  var tempVal =$("#scopesIds").val();
	  $.selectPeople({
	      type: 'selectPeople',
	      params: {value:tempVal},
	      panels: 'Account,Department,Outworker,Team,Level',
	      selectType: 'Account,Department,Member',
	      minSize:1,
	      maxSize:100,
	      showConcurrentMember:true,
	      onlyLoginAccount: false,
	      returnValueNeedType: true,
	      callback: function(ret) {
	    	  $("#scopes").val(ret.text);
	    	  $("#scopesIds").val(ret.value);
	    	  //OA-126427 选值后没触发change，手动触发一下
	    	  $("#scopes").trigger("change");
	    }
	});
  });
  $("#authorUserName").click(function(){
	  	var memberId = $("#authorUserId").val(),memberName = $("#authorUserName").val();
	  	if(memberId != ""){
	  		memberId = "Member|" + memberId
	  	}
		$.selectPeople({
	      type: 'selectPeople',
	      params : {
		      text:memberName,
		      value:memberId
	      },
	      panels: 'Department,Team,Level',
	      selectType: 'Member',
	      minSize:1,
	      maxSize:1,
	      showConcurrentMember:true,
	      onlyLoginAccount: true,
	      returnValueNeedType: false,
	      callback: function(ret) {
		      $("#editAuthorUser").val("true");
			  $("#authorUserId").val(ret.value);
	    	  $("#authorUserName").val(ret.text);
	    	  //OA-126427 选值后没触发change，手动触发一下
	    	  $("#authorUserName").trigger("change");
	    }
	});
  });
 function sumbit_Ok(){
 	if(!$("#M1LbsAuthor").validate() || !($("#scopesIds").val() !="" && $("#scopesIds").val() !="-1") ) {
     	return;
   	}
	if (getCtpTop() && getCtpTop().startProc){
		getCtpTop().startProc();
	}
	mLbsAuthor = new mLbsAuthorManager();
	var formObj = $("#M1LbsAuthor").formobj({
      	includeDisabled: true
    });
     function refresh(){
    	$("#mytable").ajaxgridLoad(o);
    	if ($("#conti").attr("checked") == "checked") {
        		addform();
    	} else {
        	$("#M1LbsAuthor").hide();
        	grid.grid.resizeGridUpDown('down');
        	$("#button").hide();
        	$("#welcome").show();
    	}
     }
    mLbsAuthor.createAuthorScope(formObj, {
	      success: function(result) {
		        try {
		          if (getCtpTop() && getCtpTop().endProc) {
			            getCtpTop().endProc();
		          }
		    	  if(result.success){
			          $.infor({
			        	  "msg":result.msg,
			        	  "close_fn":refresh,
			        	  "ok_fn":refresh
			          });
		    	  }else{
			          $.alert({
			        	  "msg":result.msg,
			        	  "close_fn":refresh,
			        	  "ok_fn":refresh
			          });
		    	  }
		        } catch(e) {};
	      },
	      error:function(){
	    	  if (getCtpTop() && getCtpTop().endProc) {
		            getCtpTop().endProc();
	          }
	    	  $.error({
	    		  "msg":"保存失败！",
	        	  "close_fn":refresh,
	        	  "ok_fn":refresh
	    	  });
	      }
    });
 }
  
  $("#btnok").bind("click",function(){
	sumbit_Ok();
  });/* 
var searchobj = $.searchCondition({
    top: 2,
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
      id: 'memberName',
      name: 'authorUserName',
      type: 'input',
      text: "授权人",
      value: 'authorUserName'
	}]
  }); */
  function gridagree(){
    $("#welcome").show();
    $("#button").hide();
	$("#M1LbsAuthor").hide();
   var boxs = $("#mytable input:checked");
      if (boxs.length === 0) {
          $.alert("${ctp:i18n('m1.bind.binded.noselect')}");
          return;
      } else {
          var confirm = $.confirm({
            'title': "${ctp:i18n('common.prompt')}",
            'msg': "${ctp:i18n('m1.bind.apply.agree')}",
            ok_fn: function() {
              if (boxs.length === 0) {
                $.alert("${ctp:i18n('m1.bind.binded.noselect')}");
                return;
              } else if (boxs.length >= 1) {
                var members = new Array();
                boxs.each(function() {
                  members.push($(this).val());
                });
				
             if (getCtpTop() && getCtpTop().startProc) getCtpTop().startProc();
              }
            },
            cancel_fn: function() {location.reload();}
          });
      }
  }
   function deleteInfo(){
   $("#welcome").show();
    $("#button").hide();
	$("#M1LbsAuthor").hide();
   var boxs = $("#mytable input:checked");
      if (boxs.length === 0) {
          $.alert("${ctp:i18n('m1.bind.binded.noselect')}");
          return;
      } else {
          var confirm = $.confirm({
        	  'title': "${ctp:i18n('common.prompt')}",
            'msg': "${ctp:i18n('m1.lbs.author.delete.label')}",
            ok_fn: function() {
              var boxs = $("#mytable input:checked");
              if (boxs.length === 0) {
            	  $.alert("${ctp:i18n('org.member_form.choose.personnel.edit')}");
                return;
              } else if (boxs.length >= 1) {
                var members = new Array();
                boxs.each(function() {
                  members.push($(this).val());
                });
				
             if (getCtpTop() && getCtpTop().startProc) getCtpTop().startProc();
             mLbsAuthor = new mLbsAuthorManager();	
             mLbsAuthor.deleteScopes(members, {
				  success: function(result) {
					try {
					  $.infor(result);
					  if (getCtpTop() && getCtpTop().endProc) {
						getCtpTop().endProc();
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
  function griddblclick() {
		$("#M1LbsAuthor").enable();
		  
	//	$("#authorUserName").attr("disabled",true);
		$("#scopse").attr("disabled",true);
	    var v = $("#mytable").formobj({
	      gridFilter: function(data, row) {
	        return $("input:checkbox", row)[0].checked;
	      }
	    });
	    if (v.length < 1) {
	    	 $.alert("${ctp:i18n('m1.lbs.author.choose.personnel.modify')}");
	    	 return
	    } else if (v.length > 1) {
	    	$.alert("${ctp:i18n('m1.lbs.author.choose.personnel.one.modify')}");
	    } else {
	      mytable.grid.resizeGridUpDown('middle');
	      var mdetil = mLbsAuthor.viewOneInfo(v[0]["authorUserId"]);
	     
	      $("#M1LbsAuthor").clearform({
	        clearHidden: true
	      });
	      $("#M1LbsAuthor").fillform(mdetil);
		  
	      $("#conti").removeAttr("checked");
	      $("#M1LbsAuthor").enable();
	      $("#button").show();
	      $("#M1LbsAuthor").show();
	      $("#lconti").hide();
	      $("#welcome").hide();
	      $("input[id=sortIdtype]:eq(0)").attr("checked", 'checked');
	      $("#oprType").val("2");
	    }
	  }
});




</script>
