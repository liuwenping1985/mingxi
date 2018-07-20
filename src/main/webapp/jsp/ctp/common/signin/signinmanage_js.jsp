<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=signInManager"></script>
<script type="text/javascript">
var signInManager=new signInManager();
var mytable;
$().ready(function() {
   mytable = $("#mytable").ajaxgrid({
    /* click : clk, */
    colModel: [{
      display: 'id',
      name: 'id',
      width: '5%',
      sortable: false,
      align: 'center',
      type: 'checkbox'
    },{
      display: "${ctp:i18n('signinmanage.application.name')}",
      name: 'lname',
      sortable: true,
      width: '20%'
    },{
        display: "${ctp:i18n('signinmanage.application.parameter')}",
        name: 'loginParam',
        sortable: true,
        width: '15%'
      },{
          display: "${ctp:i18n('signinmanage.application.checkconnection')}",
          name: 'checkUrl',
          sortable: true,
          width: '30%'
        },{
            display: "${ctp:i18n('signinmanage.application.targetconnection')}",
            name: 'targetUrl',
            sortable: true,
            width: '30%'
          }],
      width: 'auto',
      parentId: "roleList_stadic_body_top_bottom",
      managerName: "signInManager",
      managerMethod: "findAll",
      vChangeParam: {
        overflow: "auto"
      },
      slideToggleBtn: true,
      showTableToggleBtn: true,
      vChange: true
  });
   reloadtab();

   
  
  // 工具栏
  var toolbar = $("#toolbar").toolbar({
    toolbar: [{
      id: "creatsso",
      name: "${ctp:i18n('signinmanage.application.new')}",
      className: "ico16",
      click: function() {
        creatsso();
      }
    },
    {
      id: "modifysso",
      name: "${ctp:i18n('signinmanage.application.modify')}",
      className: "ico16 editor_16",
      click: function() {
       modifysso();
      }
    },
    {
        id: "delsso",
        name: "${ctp:i18n('signinmanage.application.delete')}",
        className: "ico16 editor_16",
        click: function() {
         delsso();
        }
      }
    ]
  });
  
  //新建
  function creatsso() {

	  var dialog = $.dialog({
		url: _ctxPath + '/signinmanage.do?method=creatSignin',
	    width: 400,
	    height: 340,
	    isDrag:false,
	    title: "${ctp:i18n('signinmanage.application.new')}",
	    targetWindow: getCtpTop(),
	    buttons: [{
	      id: "btnok",
	      text: "${ctp:i18n('common.button.ok.label')}",
	      handler: function() {
	    	  var ssoInfo = dialog.getReturnValue();
	          if (ssoInfo==undefined||ssoInfo.valid) {
	            return;
	          }

	          var signManager = new signInManager();
	          var ssoNew = new Object();
	          ssoNew.sname = ssoInfo.name_signin;
	          ssoNew.loginParam = ssoInfo.param_signin;
	          ssoNew.checkUrl = ssoInfo.urlcheck_signin;
	          ssoNew.targetUrl = ssoInfo.targetUrl_signin;
	          ssoNew.sort = ssoInfo.sort;
	   
	          signManager.insertSignin(ssoNew, {
	        	  success:function(result){
	        	      if(result != 0){
	            		  // 手动加载表格数据
	                      reloadtab();
	                      dialog.close();
	        	      }
	        	  }
	          });
	        }  	  
	    },
	    {
	      id:"btncancel",
	      text: "${ctp:i18n('systemswitch.cancel.lable')}",
	      handler: function() {
	        dialog.close();
	      }
	    }]
	  });
	  opendialog = dialog; 
  }
  
  //修改
  function modifysso() {
	    var boxs = $(".mytable").formobj({
		      gridFilter : function(data, row) {
		          return $("input:checkbox", row)[0].checked;
		      }
		  });
		    if(boxs.length>1){
		    	$.alert("${ctp:i18n('signinmanage.application.error')}");
		    	return ;
		    }else if(boxs.length==0){
		        $.alert("${ctp:i18n('signinmanage.application.edit')}");
		        return;
		    }
		    if(boxs.length==1){
		    var dialog = $.dialog({
				url: _ctxPath + '/signinmanage.do?method=modifySignin&ssoid='+boxs[0].id,
			    width: 400,
			    height: 340,
			    isDrag:false,
			    title: "${ctp:i18n('signinmanage.application.modify')}",
			    targetWindow: getCtpTop(),
			    buttons: [{
			      id: "btnok",
			      text: "${ctp:i18n('common.button.ok.label')}",
			      handler: function() {
			    	  var ssoInfo = dialog.getReturnValue();
			          if (ssoInfo==undefined||ssoInfo.valid) {
			            return;
			          }

			          var signManager = new signInManager();
			          var ssoNew = new Object();
			          ssoNew.id=ssoInfo.id;
			          ssoNew.sname = ssoInfo.name_signin;
			          ssoNew.loginParam = ssoInfo.param_signin;
			          ssoNew.checkUrl = ssoInfo.urlcheck_signin;
			          ssoNew.targetUrl = ssoInfo.targetUrl_signin;
			          ssoNew.sort = ssoInfo.sort;
			   
			          signManager.modifySso(ssoNew, {
			        	  success:function(result){
			        	      if(result != 0){
			            		  // 手动加载表格数据
			                      reloadtab();
			                      dialog.close();
			        	      }
			        	  }
			          });
			        }  	  
			    },
			    {
			      id:"btncancel",
			      text: "${ctp:i18n('systemswitch.cancel.lable')}",
			      handler: function() {
			        dialog.close();
			      }
			    }]
			  });
  }
			  opendialog = dialog;
	  
  }
  

  //删除
function delsso() {
	    var boxs = $(".mytable").formobj({
	      gridFilter : function(data, row) {
	          return $("input:checkbox", row)[0].checked;
	      }
	  });
	    if(boxs.length>1){
	    	$.alert("${ctp:i18n('signinmanage.application.error')}");
	    	return ;
	    }else if(boxs.length==0){
	        $.alert("${ctp:i18n('signinmanage.application.edit')}");
	        return;
	    }
	    
	    var delManager = new signInManager();
	    delManager.delSsoById(boxs[0].id, {
      	  success:function(result){
    	      if(result != 0){
        		  // 加载表格数据
                  reloadtab();
    	      }
    	  }
      });    
}

//获取选中
function getTableChecked() {
  return $(".mytable").formobj({
    gridFilter: function(data, row) {
      return $("input:checkbox", row)[0].checked;
    }
  });
}

  
  //加载列表
  function reloadtab(){
  var params = new Object();
  params.categoryId = "10";
 $("#mytable").ajaxgridLoad(params);
  }

});

</script>