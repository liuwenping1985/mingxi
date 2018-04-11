<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
function generate() {
    var v = $("#mytable").formobj({
      gridFilter : function(data, row) {
          return $("input:checkbox", row)[0].checked;
      }
    });
    if (v.length < 1) {
    	  $.alert('${ctp:i18n("voucher.plugin.selectdata.alert")}');
    }else if(v.length == 1){
		var sumArray = new Array();
	    for(var i=0; i<v.length; i++){
		    sumArray[i]=v[i].summaryId;
	    }
		
        var dialog = getA8Top().$.dialog({
		    url:"${path}/voucher/voucherController.do?method=voucherGetGlorgCode",
		    width: 500,
		    height: 300,
		    title: "${ctp:i18n('voucher.plugin.cfg.chose2.account')}",//选择账套
		    buttons: [{
		        text: "${ctp:i18n('common.button.ok.label')}", //确定
		        handler: function () {
		           var rv = dialog.getReturnValue();
		           if(rv!=false){
		           		rv.summaryIdStr = sumArray.join(",");						
		           		dialog.close();
		           		dialog3(rv);
		           }
		        }
		    }, {
		        text: "${ctp:i18n('common.button.cancel.label')}", //取消
		        handler: function () {
		            dialog.close();
		        }
		    }]
		  });
			
	}else{
   	  var sumArray = new Array();
	    for(var i=0; i<v.length; i++){
		    sumArray[i]=v[i].summaryId;
	    }
        var dialog = getA8Top().$.dialog({
		    url:"${path}/voucher/voucherController.do?method=voucherGetGlorgCode",
		    width: 500,
		    height: 300,
		    title: "${ctp:i18n('voucher.plugin.cfg.chose2.account')}",//选择账套
		    buttons: [{
		        text: "${ctp:i18n('common.button.ok.label')}", //确定
		        handler: function () {
		           var rv = dialog.getReturnValue();
		           if(rv!=false){
		           		rv.summaryIdStr = sumArray.join(",");						
		           		dialog.close();
		           		var manager = new voucherManager();
		           		 proce = getA8Top().$.progressBar({
							text: "${ctp:i18n('voucher.plugin.generate.vouchering')}"
						}); 
		           		manager.processErpVouchers(rv,{
		           			success : function(data){								
		           				proce.close();
		           				dialog2(rv);
		           			}
		           		});
		           }
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
    
    function merge(){
        	var v = $("#mytable").formobj({
                gridFilter : function(data, row) {
                  return $("input:checkbox", row)[0].checked;
                }
              });
            if (v.length > 1) {
				 var sumArray = new Array();
				 for(var i=0; i<v.length; i++){					
				 sumArray[i]=v[i].summaryId;
				 }
				var dialog = getA8Top().$.dialog({
				url:"${path}/voucher/voucherController.do?method=voucherGetGlorgCode&flag=merge",
				width: 500,
				height: 300,
				title: "${ctp:i18n('voucher.plugin.cfg.chose2.account')}",//选择账套
				buttons: [{
					text: "${ctp:i18n('common.button.ok.label')}", //确定
					handler: function () {
					   var rv = dialog.getReturnValue();								  
					   if(rv!=false){
							rv.summaryIdStr = sumArray.join(",");										 
							/* var manager = new voucherManager();
							proce = getA8Top().$.progressBar({
								text: "${ctp:i18n('voucher.plugin.generate.vouchering')}"
							});
							manager.processMergeErpVouchers(rv,{
								success : function(){
                					proce.close();
                					dialog2(rv);
								}
							}); */
							dialog.close();
			           		dialog3(rv);
					   }
					}
				}, {
					text: "${ctp:i18n('common.button.cancel.label')}", //取消
					handler: function () {
						dialog.close();
					}
				}]
			  });
     		} else {
    			$.alert("${ctp:i18n("voucher.plugin.selectdata.leasttwo")}");
	 		}
    }
    function dialog2(rv){
    	var url = "${path}/voucher/voucherController.do?method=voucherInfo&idStr="+rv.summaryIdStr+"&accountId="+rv.accountId+"&bookCode="+rv.bookCode+"&mergeflag="+rv.mergeflag;
   			var dialog2 = getA8Top().$.dialog({
   			id : "dialog2",
   			url:url,
		    width: 900,
		    height: 350,
		    title: "${ctp:i18n('voucher.plugin.generate.voucherinfo')}",//
		    //transParams : data,
		    buttons: [{
		        text: "${ctp:i18n('common.button.ok.label')}", //确定
		        handler: function () {
		        	var rv = dialog2.getReturnValue();
	        		dialog2.close();
		        	var o1 = new Object();
		        	o1.isDone = $("#isDone").val();
		        	$("#mytable").ajaxgridLoad(o1);
		        }
		    }, {
		        text: "${ctp:i18n('voucher.plugin.generate.export')}", //导出
		        handler: function () {
		        	var rv = dialog2.getReturnValue();
		        	dialog2.close();
		        	$("#result").val(rv.join(","));
		        	$("#downLoad").submit();
		        	var o1 = new Object();
		        	o1.isDone = $("#isDone").val();
		        	$("#mytable").ajaxgridLoad(o1);
		        }
		    }]
		});
    }

	function dialog3(rv){
    	var url = "${path}/voucher/voucherController.do?method=voucherInfoPre&idStr="+rv.summaryIdStr+"&accountId="+rv.accountId+"&bookCode="+rv.bookCode+"&billdate="+rv.billdate+"&postingdate="+rv.postingdate+"&fiscalYear="+rv.fiscalYear+"&fiscalPeriod="+rv.fiscalPeriod+"&groupCode="+rv.groupCode+"&mergeFlag="+rv.mergeflag;
   		var dialog3 = getA8Top().$.dialog({
   			id : "dialog3",
   			url:url,
		    width: 900,
		    height: 450,
		    title: "${ctp:i18n('voucher.plugin.generate.preinfo')}",//
		    //transParams : data,
		    buttons: [{
		        text: "${ctp:i18n('voucher.plugin.make.label')}", //确定
		        handler: function () {
		        	var rv = dialog3.getReturnValue();
		        	if(rv!=false){
		        		dialog3.close();
			        	var manager = new voucherManager();
			        	proce = getA8Top().$.progressBar({
							text: "${ctp:i18n('voucher.plugin.generate.vouchering')}"
						});
			        	manager.processViewVouchers2ERP(rv,{//根据凭证预览数据生成凭证
			           		success : function(data){
			           			proce.close();
			           			dialog2(rv);
			           		}
			           	});
		        	}
		        }
		    }, {
		        text: "${ctp:i18n('common.button.cancel.label')}", //取消
		      handler: function () {
		    	   dialog3.close();
		        }
		    }]
		});
    }
</script>
</head>
<body>
	
</body>
</html>