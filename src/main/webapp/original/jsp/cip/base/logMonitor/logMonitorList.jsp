<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=logMonitorManager"></script>  
<script type="text/javascript">
 	function openLink(link){
 		window.open(link+"&time="+Math.random());
	}
$().ready(function() {	
	
	var logm = new logMonitorManager(); 
	var s_right = 65;
	if(_locale){
		if(_locale == 'en'){
			s_right = 80;
		}
	}
	    
    var searchobj = $.searchCondition({
        top: 6,
        right: s_right,
        searchHandler: function() {
          var ssss = searchobj.g.getReturnValue();
          $("#mytable").ajaxgridLoad(ssss);
        },
        conditions: [{
          id: 'logApplication',
          name: 'logApplication',
          type: 'select',
          text: "${ctp:i18n('cip.base.form.logMonitor.log_application')}",
          value: 'logApplication',
          codecfg: "codeType:'java',codeId:'com.seeyon.apps.cip.base.enums.LogApplicationEnum'"
        },
        {
            id: 'logAction',
            name: 'logAction',
            type: 'input',
            text: "${ctp:i18n('cip.base.form.logMonitor.log_action')}",
            value: 'logAction'     
          },
        {
            id: 'memberId',
            name: 'memberId',
            type: 'input',
            text: "${ctp:i18n('cip.base.form.logMonitor.member_id')}",
            value: 'memberId'           
          },
         {
             id: 'createDate',
             name: 'createDate',
             type: 'datemulti',
             text: "${ctp:i18n('cip.base.form.logMonitor.create_date')}",
             value: 'createDate',
             dateTime: true
          }
        ]
      });
    
    
    $("#toolbar").toolbar({
        toolbar: [{
          id: "refresh",
          name: "${ctp:i18n('common.toolbar.refresh.label')}",
          className: "ico16 refresh_16",
          click: function() {
        	  var o = new Object();
        	  $("#mytable").ajaxgridLoad(o);
			  mytable.grid.resizeGridUpDown('down');
          }
      },
      {
    	  	id: "delete",
            name: "${ctp:i18n('common.button.delete.label')}",
            className: "ico16 del_16",
          click: function() {
        	  var v = $("#mytable").formobj({
                  gridFilter : function(data, row) {
                    return $("input:checkbox", row)[0].checked;
                  }
                });
              if (v.length < 1) {
                  $.alert("${ctp:i18n('level.delete')}");
              } else {
                  $.confirm({
                      'msg': "${ctp:i18n('common.isdelete.label')}",
                      ok_fn: function() {
                        logm.deleteLogDetail(v, {
                                  success: function() {
                                	  var o = new Object();
                                	  $("#mytable").ajaxgridLoad(o);
                                  }
                              });
                      }
                  });
              };
          }
      },
      {
          id: "view",
          name: "${ctp:i18n('common.toolbar.view.label')}",
          className: "ico16 view_log_16",
          click: function(){
        	  	var v = $("#mytable").formobj({
       	        gridFilter : function(data, row) {
       	          return $("input:checkbox", row)[0].checked;
       	        }
       	      	});
    	      	if (v.length < 1||v.length > 1) {
        	        $.alert("${ctp:i18n('common.choose.one.record.label')}");
        	        return;
        	    }
				viewData(v[0]);
          }
      }  
      ]
    });

    var mytable = $("#mytable").ajaxgrid({
        
        vChange: true,
        vChangeParam: {
            overflow: "hidden",
            autoResize:true
        },
        isHaveIframe:true,
        slideToggleBtn:false,
        colModel: [
       {
    	 display:"id",
         name: 'id',
         width: '5%',
         sortable: true,
         type: 'checkbox'
       }, 
       {
          display: "${ctp:i18n('cip.base.form.logMonitor.log_application')}",
          name: 'logApplication',
          width: '10%',
          codecfg: "codeType:'java',codeId:'com.seeyon.apps.cip.base.enums.LogApplicationEnum'"
         },   
        {
            display: "${ctp:i18n('cip.base.form.logMonitor.log_action')}",
            sortable: true,
            name: 'logAction',
            width: '15%'
        },
        {
            display: "${ctp:i18n('cip.base.form.logMonitor.log_detail')}",
            sortable: true,
            name: 'logDetail',
            width: '30%'
        },
        {
            display: "${ctp:i18n('cip.base.form.logMonitor.member_id')}",
            sortable: true,
            name: 'memberName',
            width: '10%'
        },
        {
            display: "${ctp:i18n('cip.base.form.logMonitor.create_date')}",
            sortable: true,
            type : 'date', 
            name: 'createDate',
            width: '10%'
        },
        {
            display: "${ctp:i18n('cip.base.log.relate.link')}",
            sortable: false,
            name: 'relatedLink',
            width: '10%'
        },
        {
            display: "${ctp:i18n('cip.base.log.sylog.link')}",
            sortable: false,
            name: 'relatedLog',
            width: '10%'
        }
        ],
        width: "auto",
        managerName: "logMonitorManager",
        managerMethod: "listLogs",
        parentId:'center',
        render: rend
    });
      function rend(txt, data, r, c) {
		if (c==6) {
			
			if(data.relatedLink!=""&&data.relatedLink!=null){
				return "<a class=\"common_button common_button_gray\" href=\"javascript:void(0)\" onclick=\"javascript:openLink('"+data.relatedLink+"')\">"+"${ctp:i18n('cip.base.log.relate.link')}"+"</a>";
			}else{
				return "<a class=\"common_button\" disabled>"+"${ctp:i18n('cip.base.log.relate.link')}"+"</a>";
			}
			
		}else{
			if (c==7) {
			
			if(data.relatedLog!=""&&data.relatedLog!=null){
				return "<a class=\"common_button common_button_gray\" href=\"javascript:void(0)\" onclick=\"javascript:openLink('"+data.relatedLog+"')\">"+"${ctp:i18n('cip.base.log.sylog.link')}"+"</a>";
			}else{
				return "<a class=\"common_button\"  disabled=\"disabled\" >"+"${ctp:i18n('cip.base.log.sylog.link')}"+"</a>";
			}
			
		}else{
			return txt;
		}
		}
	
	  }
    
    var o = new Object();
    $("#mytable").ajaxgridLoad(o);
 
});


function viewData(data) {
	var strUrl = _ctxPath + "/cip/base/logMonitorController.do?method=showLogDetail&id=" + data.id;
	var logDialog = $.dialog(
		{
            url: strUrl,
            width: 500,
            height: 350,
            title:"${ctp:i18n('cip.base.form.logDetail') }",
            id:'logDialog',
            targetWindow:getCtpTop(),
            closeParam:{
                show:true,
                autoClose:false,
                handler:function(){
                	logDialog.close({isFormItem:true});
                }
            },
            buttons: [ {
                id:"cancelButton",
                 text: $.i18n('common.button.cancel.label'),
                handler: function () {
                	logDialog.close({isFormItem:true});
                }
            }]
        }
	);   	
    	 
}
	

var queryDialog;
var o;
function openQueryViews(){
		queryDialog = $.dialog({
        url:   _ctxPath + "/cip/base/logMonitorController.do?method=advancedQuery",
        width: 500,
        height: 320,
        title:"${ctp:i18n('cip.base.form.advancedQuery') }",
        id:'queryDialog',
        transParams:o,
        targetWindow:getCtpTop(),
        closeParam:{
            show:true,
            autoClose:false,
            handler:function(){
                queryDialog.close({isFormItem:true});
            }
        },
        buttons: [{
            id : "okButton",
            text: $.i18n("common.button.ok.label"),
            handler: function () {
               var jsonStr = queryDialog.getReturnValue({type:1});
      		   if (jsonStr== "" || jsonStr == undefined) {
      			   return;
      		   }
  			   o = $.parseJSON(jsonStr);
    		   $("#mytable").ajaxgridLoad(o);
    		   queryDialog.close();
        	  
           }
        }, {
            id:"cancelButton",
             text: $.i18n('collaboration.attachment.clear.js'),
            handler: function () {
        		queryDialog.getReturnValue({type:2});
            }
        }]
    });

}
 
</script>

</head>
<body> 
	<div id='layout' class="comp" comp="type:'layout'">
	    <div class="layout_north" layout="height:40,sprit:false,border:false">  
	      <div id="toolbar"></div>
 
		  <ul class="common_search common_search_condition clearfix"   style="top: 10px; right: 20px; position: absolute; z-index: 900;"><a onclick="openQueryViews();" >${ctp:i18n("common.advance.label") }</a>
		  </ul>
	   </div>
	    <div  class="layout_center over_hidden" id="center">
	      <table id="mytable" class="flexme3" >
	      </table>
	    <!--   <div id="grid_detail" style="overflow-y:hidden;position:relative;">
	          <iframe id="logMonitorDetail" name="logMonitorDetail" width="100%" height="100%" frameborder="0"
	                   class='calendar_show_iframe' style="overflow-y:hidden"></iframe>  
	      </div> -->
	    </div>
	</div>
	<form name="listForm" id="listForm" method="post" onsubmit="return false"></form>
</body>
</html>

 