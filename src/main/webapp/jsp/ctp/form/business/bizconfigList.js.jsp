<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<script type="text/javascript">
var currentUserId = "${currentUserId}";
var bizDataManager = new bizDataManager();
var gridObj;
var bizToolBar;
var v3x = new V3X();
  $(document).ready(function() {
	  gridObj=$("table.flexme3").ajaxgrid({
		  colModel:[{
			  display : 'id',
		      name : 'id',
		      width : '20',
		      sortable : false,
		      isToggleHideShow:false,
		      align : 'center',
		      type : 'checkbox'
		      }, {
		      display : '${ctp:i18n("formsection.config.name.show")}',
		      name : 'name',
		      width : '30%',
		      sortable : true,
		      isToggleHideShow:false,
		      align : 'left'
		      },{
	          display : "${ctp:i18n('form.trigger.triggerSet.state.label')}",
	          name : 'state',
	          width : '8%',
	          sortable : true,
	          isToggleHideShow:false,
	          align : 'left'
	          },{
		      display : "${ctp:i18n('form.trigger.triggerSet.state.label')}",
		      name : 'stateValue',
		      hide:true,
		      width : '8%',
		      sortable : true,
		      isToggleHideShow:true,
		      align : 'left'
		      },{
		      display : "${ctp:i18n('common.creater.label') }",
		      name : 'createUserName',
		      width : '20%',
		      sortable : true,
		      isToggleHideShow:false,
		      align : 'left'
		      }, {
		        display : "${ctp:i18n('common.date.createtime.label') }",
		      name : 'createDate',
		      width : '18%',
		      sortable : true,
		      isToggleHideShow:false,
		      align : 'left'
		      }, {
		      display : "${ctp:i18n('bizconfig.use.authorize.label')} ",
		      name : 'authName',
		      width : '24%',
		      sortable : true,
		      isToggleHideShow:false,
		      align : 'left'
		  }],
		  managerName:"businessManager",
		  managerMethod:"listBusiness",
		  click :clk,
          dblclick : dblclk,
          callBackTotle:getCount,
          isToggleHideShow:false,
          usepager : true,
          useRp : true,
          render:rend,
          customize:false,
          resizable : true,
          showToggleBtn: false,
                parentId: $('.layout_center').eq(0).attr('id'),
                vChange: true,
                vChangeParam: {
                    overflow: "hidden",
                    autoResize:true
                },
                slideToggleBtn: true
	  });
	  var o = new Object();
      $("#mytable").ajaxgridLoad(o);
      function rend(txt, data, r, c) {
        if (c==1){
          return "<div class = 'grid_black'>" + txt + "</div>";
       } else {
         return txt;
       }
      }
      function clk(data, r, c) {
          $("#viewFrame").prop("src","${path}/form/business.do?method=formDetail&bizConfigId="+data.id);
      }
      function dblclk(data, r, c){
      }
      var ctpTop = getCtpTop ? getCtpTop() : parent ;
      if(ctpTop)
        ctpTop.$.removeData(ctpTop.document.body, "resourceMenuCache");
      });

  var searchobj = $.searchCondition({
	  top:3,
	  right:10,
	  searchHandler:doSearch,
	  conditions:[{
		  id:'namesearch',
		  name:'namesearch',
		  type:'input',
		  text:'${ctp:i18n("formsection.config.name.show")}',
		  value:'name'
	  },{
		  id: 'createNamesearch',
          name: 'createNamesearch',
          type: 'input',
          text: "${ctp:i18n('common.creater.label') }",//创建人
          value: 'creator'
	  },{
		  id: 'datetime',
          name: 'datetime',
          type: 'datemulti',
          text: "${ctp:i18n('common.date.createtime.label') }",//发起时间
          value: 'createDate',
          dateTime: false,
          ifFormat:'%Y-%m-%d'
	  }]
  });
    $().ready(function() {

    	bizToolBar = $("#toolbar").toolbar({
  	      toolbar : [
              <c:if test="${ctp:hasPlugin('formBiz')}">
              {
                  name : "${ctp:i18n('common.toolbar.new.label')}",
                  click : function() {
                      newBizConfig();
                  },
                  className : "ico16"
              },
              </c:if>
  		      {
  		        name:"${ctp:i18n('common.toolbar.update.label')}",
   		       	 click : function(){
  				          var selectForms = $("input:checked","#mytable");
  				          if(selectForms.length==0){
  				            $.alert('${ctp:i18n("formsection.config.choose.modify.must")}');
  					          return;
  				          }
  				          if(selectForms.length>1){
  				            $.alert('${ctp:i18n("formsection.config.choose.modify.onlyone")}');
  					          return;
  				          }
  				          toEditNewBizConfig(selectForms.val());
  				      },
   		       	 className : "ico16 editor_16"
   		      },
  	      	  {
   		       name:"${ctp:i18n('common.toolbar.delete.label')}",
  			      click : function(){del();},
  			      className : "ico16 del_16"
  			  }
   		      ,{
   		    	  id : "exportEgg",
  				  name : "${ctp:i18n('formsection.export')}",
  				  click : function(){
  					 	  var selectForms = $("input:checked","#mytable");
				          if(selectForms.length==0){
				            $.alert("${ctp:i18n('formsection.export.must')}");
				 	         return;
				          }
				          if(selectForms.length>1){
				            $.alert("${ctp:i18n('formsection.export.onlyone')}");
					          return;
				          }
				          var gridObjArry = gridObj.grid.getSelectRows();
				          if(currentUserId!=gridObjArry[0].createUser){
				            $.alert('不是自己创建的，不能导出！');
				              return;
				          }
				          var bizState = gridObjArry[0].stateValue;
					      if(bizState == -1 || bizState == -2){
					          $.alert("未激活业务配置不能进行导出！");
					          return;
					      }
  					  exportBiz(selectForms.val());
  					  },
  				  className : "ico16 export_16"
  			  },
  			  {
  				  name : "${ctp:i18n('formsection.import')}",
  				  click : function(){ 
  				    //redirect();
  				    insertAttachmentPoi('biz');
  				    },
  				  className : "ico16 import_16 "
  			  }
  			  ,{
  				  name : "${ctp:i18n('bizconfig.activate')}",
  				  click : function(){continueImport()},
  				  className : "ico16 formContinue_16"
  			  }
  			  ]
        });
  	  });
    
    function getCount(n){
        $("#viewFrame").prop("src","${path }/form/business.do?method=desc&size="+n);
      }

    function doSearch() {
    	 var o = {};
         var conditonVal=searchobj.g.getReturnValue();
         if (!conditonVal) {
             return;
         }
         if(conditonVal.condition === "name") {
             o.condition = conditonVal.condition;
             o.nameSearch = $("#namesearch").val();
         } else if(conditonVal.condition === "creator") {
             o.condition = conditonVal.condition;
             o.creatorSearch = $("#createNamesearch").val();
         } else if(conditonVal.condition  === "createDate") {
             o.condition = conditonVal.condition;
             o.createDateSearch1 = $("#from_datetime").val();
             o.createDateSearch2 = $("#to_datetime").val();
         }
         o.page=1;
         $("#mytable").ajaxgridLoad(o);
    }

    //新建
    function newBizConfig(){
    	var dialog = $.dialog({
			url:"${path}/form/business.do?method=newBusiness&from=list",
		    title : '${ctp:i18n("menu.newbiz.label")}',
		    width:1100,
			height:500,
			id:'createBiz',
			targetWindow:getCtpTop(),
		    buttons : [{
		      text : "${ctp:i18n('common.button.ok.label')}",
		      id:"sure",
		      handler : function() {
		    	  var isOK = dialog.getReturnValue({"isAdd":true});
		      }
		    }, {
		      text : "${ctp:i18n('common.button.cancel.label')}",
		      id:"exit",
		      handler : function() {
		        dialog.close();
		      }
		    }]
		  });
	}

    /**
     * 单业务配置主页选中一条表单业务配置进行修改操作
     */
    function toEditNewBizConfig(id) {
    	var gridObjArry = gridObj.grid.getSelectRows();
    	if(currentUserId!=gridObjArry[0].createUser){
    	  $.alert('${ctp:i18n("bizconfig.edit.right")}');
    		return;
    	}
    	var state = gridObjArry[0].stateValue;
	      if(state == -1 || state == -2){
	          $.alert("未激活业务配置不能进行修改！");
	          return;
	      }
    	var dialog = $.dialog({
			url:"${path}/form/business.do?method=editBusiness&from=list&bizConfigId="+id,
		    title : '${ctp:i18n("bizconfig.edit")}',
		    width:1100,
		    height:500,
		    id:'createBiz',
			targetWindow:getCtpTop(),
		    buttons : [{
		      text : "${ctp:i18n('common.button.ok.label')}",
		      id:"sure",
		      handler : function() {
		    	  var isOK = dialog.getReturnValue({"isAdd":false});}
		    }, {
		      text : "${ctp:i18n('common.button.cancel.label')}",
		      id:"exit",
		      handler : function() {
		        dialog.close();
		      }
		    }]
		  });
    }

    /**
     * 选中多条表单业务配置全部删除：包含逻辑删除和真实删除
     */
    function del(){
          var gridObjArry = gridObj.grid.getSelectRows();
          if(gridObjArry.length==0){
            $.alert('${ctp:i18n("formsection.config.choose.delete.must")}');
	          return;
          }
       	 for(var i=0; i<gridObjArry.length;i++) {
         		var idCheckBox = gridObjArry[i];
         		if(currentUserId!=idCheckBox.createUser){
         		  $.alert('${ctp:i18n('bizconfig.delete.right')}');
         			return;
         		}
         	 }
          $.confirm({
            'msg':'${ctp:i18n("bizconfig.delete.sure")}',
            ok_fn:function(){
	        	$("#mytable").jsonSubmit({action:"${path}/form/business.do?method=deleteBusiness",gridFilter : function(data, row) {
	                	return $("input:checkbox", row)[0].checked;
	            	},callback:function(){ getCtpTop().refreshMenus();getCtpTop().showMenu("${path}/form/business.do?method=listBusiness");}
				});

            },
            cancel_fn:function(){

            }
          });
	 }

    function exportBiz(id){
  		  download(id);
    }

    function download(id){
    	processBar =  new MxtProgressBar({text: "正在导出..."});
    	bizDataManager.downloadEgg(id, {
	    	success: function(path){
	    		processBar.close();
                if (path[0] == "false"){
                    $.alert(path[1]);
                } else {
                    $("#exportBiz").attr("src","${path}/"+path[0]+encodeURIComponent(path[1]));
                }
	        },
	      	error:function(e){
	      		processBar.close();
	        	$.alert("${ctp:i18n('form.formlist.exporterror')}");
	      	}
	    });
    }

    function importBiz(filemsg){
    	var fileId=filemsg.instance[0].fileUrl;
        processBar =  new MxtProgressBar({text: "${ctp:i18n('formsection.import.ing')}"});
        var result = bizDataManager.importBiz(fileId,{
        	success: function(result){
        		if (result.result == 'true'){
      	            redirect(result.bizId,false);
      	    	} else {
                    if (result.msg.indexOf("biz:") != -1) {
                        var obj = {};
                        obj.msg = result.msg.substr(4);
                        showMsg4BizValidate(obj);
                    } else {
                        $.alert(result.msg);
                    }
      	    	}
      	   	 	processBar.close();
        	} ,
        	error:function(e){
                $.alert("${ctp:i18n('form.formlist.inporterror')}");
                processBar.close();
            }
        });
        
    }

/**
* 校验选中行是否有编辑，修改权限，即是非是业务配置的所属人
 * true:选中行是当前人员创建，false则不是
 */
function checkRight(data){
    return currentUserId==data.createUser;
}
    
    function continueImport(){
    	var rows = gridObj.grid.getSelectRows();
        if(rows.length==0){
		    $.alert("${ctp:i18n('bizconfig.import.toselect.error.continue')}");
		    return;
        }
        if(rows.length>1){
        	$.alert("${ctp:i18n('bizconfig.import.toselect.error.continue.one')}");
		    return;
        }
        var state = rows[0].stateValue;
        if(state != -1 && state != -2){
        	$.alert("${ctp:i18n('bizconfig.import.toselect.error.title')}");
		    return;
        }
        if(!checkRight(rows[0])){
            $.alert("${ctp:i18n('bizconfig.edit.right.continueimport')}");
            return;
        }
        redirect(rows[0].id,true);
    }
    
    var redirectDialog;
    function redirect(bizId,isContinueRedirect){
      redirectDialog = $.dialog({
        url:"${path}/form/business.do?method=importBiz&bizId=" + bizId,
        title : '${ctp:i18n("bizconfig.import.dialog.label")}',
        width:900,
        height:500,
        id:'redirectBiz',
        transParams:{param:window},
        targetWindow:getCtpTop(),
        closeParam:{'show':true,handler:function(){
            if (isContinueRedirect){
                bizDataManager.doUpdateFormBeanState(bizId,"cancel");
            } else {
                bizDataManager.doUpdateFormBeanState(bizId,"delete");
            }
            closeWindow();
        }},
        buttons : [
        {
          text : "${ctp:i18n('bizconfig.import.dialog.button.start')}",
          id:"start",
          handler : function() {
            var result = redirectDialog.getReturnValue({"type":"redirect"});
            redirectSigleForm(result,bizId);
          }
        }, 
        {
          text : "${ctp:i18n('bizconfig.import.dialog.button.published')}",
          id:"published",
          hide:true,
          handler : function() {
            var result = redirectDialog.getReturnValue({"type":"published"});
              closeWindow();
          }
        }, 
        {
          text : "${ctp:i18n('bizconfig.import.dialog.button.next')}",
          id:"next",
          hide:true,
          handler : function() {
            var result = redirectDialog.getReturnValue({"type":"redirect"});
            redirectSigleForm(result,bizId);
          }
        }, 
        {
          text : "${ctp:i18n('bizconfig.import.dialog.button.saveandexit')}",
          id:"saveandexit",
          handler : function() {
            var result = redirectDialog.getReturnValue({"type":"saveandexit"});
              if (isContinueRedirect){
                  bizDataManager.doUpdateFormBeanState(bizId,"-1");
              } else {
                  bizDataManager.doUpdateFormBeanState(bizId,"-2");
              }
              closeWindow();
          }
        }, 
        {
          text : "${ctp:i18n('common.button.cancel.label')}",
          id:"exit",
          handler : function() {
              if (isContinueRedirect){
                  bizDataManager.doUpdateFormBeanState(bizId,"cancel");
              } else {
                  bizDataManager.doUpdateFormBeanState(bizId,"delete");
              }
              closeWindow();
          }
    }]
    });
    }

function closeWindow(){
    var o = new Object();
    $("#mytable").ajaxgridLoad(o);
    redirectDialog.close();
}
    
    var redirectSigleFormDialog;
    function redirectSigleForm(redirectFormObj,bizId){
      redirectSigleFormDialog = $.dialog({
        url:"${path}/form/business.do?method=redirect&formid="+redirectFormObj.formid,
        title : '${ctp:i18n("bizconfig.import.redirectform.dialog.label")}-'+redirectFormObj.formName,
        width:900,
        height:500,
        id:'redirectSigleForm',
        targetWindow:getCtpTop(),
		  closeParam:{'show':true,handler:function(){
			  $.alert(redirectFormObj.formName + "${ctp:i18n('bizconfig.import.redirectform.complate.no')}");
			  bizDataManager.doUpdateFormBeanState(bizId,"delform");
			  redirectSigleFormDialog.close();
		  }},
        buttons:[
                 {
          text : "${ctp:i18n('form.pagesign.nextpace.label') }",
          id:"next",
          isEmphasize:false,
          handler : function() {
            var obj = redirectSigleFormDialog.getReturnValue({"direction":'next'});
            if (obj && obj.isSuccess){
              $.infor(redirectFormObj.formName + "${ctp:i18n('bizconfig.import.redirectform.complate.yes')}");
              bizDataManager.doUpdateFormBeanState(bizId,"");
              redirectSigleFormDialog.close();
                redirectDialog.setBtnEmphasize("next");
                redirectDialog.hideBtn("start");
                redirectDialog.showBtn("next");
              var result = redirectDialog.getReturnValue({"type":"complate"});
              if (result.redirectComplate){
	              redirectDialog.hideBtn("start");
	              redirectDialog.hideBtn("next");
	              redirectDialog.showBtn("published");
                  redirectDialog.setBtnEmphasize("published");
              }
            }
          }
        },
        {
          text : "${ctp:i18n('common.button.cancel.label')}",
          id:"exit",
          handler : function() {
             $.alert(redirectFormObj.formName + "${ctp:i18n('bizconfig.import.redirectform.complate.no')}");
              bizDataManager.doUpdateFormBeanState(bizId,"delform");
            redirectSigleFormDialog.close();
          }
        }]
      });
    }

    function activeBiz(){

    }

    function changeColType(number,templeteID,menuId){
    	if(!number || number=="" || number=="null"){
    	    number=1;
    	}
    	//window.location.href = "formBizConfig.do?method=listBizColList&flag=formBizConfig&type=menu&templeteId="+templeteID+"&menuId="+menuId+"&number="+number;
    }

</script>