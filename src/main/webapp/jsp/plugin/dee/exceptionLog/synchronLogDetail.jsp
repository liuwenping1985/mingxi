<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ include file="/WEB-INF/jsp/plugin/dee/common/common.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<fmt:setBundle
	basename="com.seeyon.apps.dee.resources.i18n.DeeResources" />
<fmt:setBundle
	basename="com.seeyon.v3x.common.resources.i18n.SeeyonCommonResources"
	var="v3xCommonI18N" />

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>异常处理</title>
<script type="text/javascript">
    <c:if test="${!empty retMsg }">

  /*  if (!Array.prototype.indexOf) {
        Array.prototype.indexOf = function(elt, from) {
            var len = this.length >>> 0;
            var from = Number(arguments[1]) || 0;
            from = (from < 0) ? Math.ceil(from) : Math.floor(from);
            if (from < 0)
                from += len;
            for (; from < len; from++) {
                if (from in this && this[from] === elt)
                    return from;
            }
            return -1;
        };
    }
*/

    var value = "${retMsg}";
    var split = value.split(",");
    var tips = split[0];
    var state =split[1];
    if(state.indexOf("failed") != -1){
        $.alert(tips);
    }else {
        $.infor(tips)
    }
    $("#synchronLog", $(parent.document)).ajaxgridLoad();
    </c:if>
    
  
    function refresh(){
        var $synchronLog = $("#synchronLog");
        $synchronLog.ajaxgridLoad();
        
    }
    var gridObj;
        $(document).ready(function () {
            new MxtLayout({
                'id': 'layout',
                'northArea': {
                    'id': 'north',
                    'height': 30,
                    'sprit': false,
                    'border': false
                },
                'centerArea': {
                    'id': 'center',
                    'border': false,
                    'minHeight': 20
                }
            });
            initToolbar();
            initGrid();
        });

        /**
         * 初始化工具栏组件
         */
        function initToolbar() {
           
            $("#toolbars").toolbar({
                toolbar: [
                    {
                        id: "delete",
                        name: "<fmt:message key='dee.dataSource.delete.label'/>",
                        className: "ico16 modify_text_16",
                        click: function () {
                            deleteSycn();
                        }
                    },
                    {
                        id:"edit",
                        name:"<fmt:message key='dee.synchronLog.edit.label'/>",
                        className: "ico16 sort_16",
                        click: function (){
                            openRedo();
                        }
                    },
                    {
                        id:"resend",
                        name:"<fmt:message key='dee.resend.label'/>",
                        className: "ico16 send_sms_16",
                        click: function (){
                            optionType();
                        }
                    }

                ]
            });
        }
        
        
        
        // 获取异常详细信息
        
        function openRedo(){
            var rows = gridObj.grid.getSelectRows();
   		   if(rows.length < 1){
   		    var alertObject =$.alert("<fmt:message key='dee.resend.error.label'/>");
   			   
   			   return;
   		   }
   		   var id = ""; 
 		   for(var i = 0; i<rows.length; i++){
 			   id = rows[i].redo_id;
 		   }	
   		    var dialog = $.dialog({
   		    id: 'url',
   		    url: _ctxPath + "/deeSynchronLogController.do?method=exceptionDetaiOpeanWin&redo_id=" + id,
   		    width: 900,
   		    height: 400,
   		    scrollbars: 'no',
   		    title: '<fmt:message key="dee.synchronLog.edit.label"/>',
   		    targetWindow: parent.parent,
   		    buttons: [{
   		        id:"sure",
   		        text: "<fmt:message key='dee.dataSource.save.label'/>",
   		        handler: function () {
   		         var condi = dialog.getReturnValue();
   		         var msg="ture";
   		         if(condi == msg)
   		          var infor = $.infor("<fmt:message key='dee.synchronLog.saveSuccess.label'/>!");
   		     // alert("<fmt:message key='dee.resend.error.label'/>");
   		         dialog.close();
   		        }
   		    }, {
   		        text: "<fmt:message key='dee.synchronLog.cancel.label'/>",
   		        handler: function () {
   		            dialog.close();
   		        }
   		    }]
   		});
   			

   	 }
        //redo重发
        
        function optionType(){
            var rows = gridObj.grid.getSelectRows();
    		
    		if(rows.length == 0){
    		    var alertObject =$.alert("<fmt:message key='dee.resend.error.label'/>");
    			return;
    		}
    		
    		var listForm = document.getElementById("listForm");
    		var redosId=rows[0].redo_id;
    		var sycnId=rows[0].sync_id;
    	
    		listForm.action = "${urlDeeSynchronLog}?method=deeRedoOrIgnore&redosId="+redosId+"&syncId="+sycnId;
     	   	listForm.submit();
    	}
       // redo信息删除
        
        function deleteSycn(){
           var redoId = ""; 
          
           var rows = gridObj.grid.getSelectRows();
           
          
 		 	if (rows.length < 1) {
 		 	  $.alert("<fmt:message key='dee.resend.error.label'/>");
                return;
            }else{
				var syncId=rows[0].sync_id;
			}
 		  	 for (var i = 0; i < rows.length; i++) {
 		  	  redoId += rows[i].redo_id + ",";
 	           
 	        }
 		  	var map = {};
            map["syncId"] = syncId;
            map["redoId"] = redoId;
 		  var confirm = $
          .confirm({
                  'msg': '${ctp:i18n("metadata.delete.alert.message.label")}',
             	  ok_fn : function() {
                  var r = new deeSynchronLogManager();
                  var retMap = r.delSyncByRedoId(map);
                  if (retMap) {
                      if (retMap.ret_code == "2000") {
                          $.infor("<fmt:message key='dee.synchronLog.delSuccess.label'/>");
                          
                      } else if (retMap.ret_code == "2001") {
                          $.error("<fmt:message key='dee.dataSource.error.label'/>" + retMap.ret_desc);
                      }
                  }
                  var $synchronLog = $("#synchronLog");
                  $synchronLog.ajaxgridLoad();
                  $("#synchronLog", $(parent.document)).ajaxgridLoad();
              },
              cancel_fn : function() {
                  confirm.close();
              }
          });
 		
 	}

       
        /**
         * 初始化列表组件
         */
        function initGrid() {
            var $synchronLog = $("#synchronLog");
            gridObj = $synchronLog.ajaxgrid({
                colModel: [
                    {
                        display: 'id',
                        name: 'sync_id',
                        width: '40',
                        sortable: false,
                        align: 'center',
                        type: 'checkbox',
                        isToggleHideShow:false
                    },
                    {
                        display: "<fmt:message key='dee.content.label'/>",    // 内容
                        name: 'doc_code',
                        width: '28%'
                    },
                    {
                        display: "<fmt:message key='dee.errorMsg.label'/>", // 错误信息
                        name: 'errormsg',
                        width: '20%'
                    },	
                    {
                        display: "<fmt:message key='dee.resend.time.label'/>",  // 重发次数
                        name: 'counter',
                        width: '27%'
                    },
                    {
                        display: "<fmt:message key='dee.status.label'/>",        // 状态
                        name: 'sync_time',
                        width: '27%'
                    }
                  
                ],
                render: rend,
                managerName : "deeSynchronLogManager",
                managerMethod : "findRedoList",
                parentId: $('.layout_center').eq(0).attr('id'),
                height: 200,
                vChange: true,
                vChangeParam: {
                    overflow: "hidden",
                    autoResize: true
                }
            });
            var o = {};
            o.syncId = $("#syncId").val();
            $synchronLog.ajaxgridLoad(o);
        }
		
        function rend(txt, data, r, c) {
            if (c == 4) {
                if(data.state_flag == 0){
                  return "<fmt:message key='dee.status.pendingresend.label'/>";
                }
                 else {
                 return "<fmt:message key='dee.status.skip.label'/>";
                }
            }
           return txt;	
           
        }
        
    </script>
</head>
<body>

	<div id='layout'>
		<div class="layout_north bg_color" id="north">
			<div id="toolbars"></div>
		</div>
		<div class="layout_center over_hidden" id="center">
			<table class="flexme3" id="synchronLog"></table>

		</div>
	</div>
	<input type="hidden" id="syncId" value="${syncId}" />
	<form name="listForm" id="listForm" method="post"
		onsubmit="return false;">
	</form>
</body>
</html>