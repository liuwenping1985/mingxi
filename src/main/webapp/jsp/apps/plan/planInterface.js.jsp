<script type="text/javascript">

function openPlan(planId,actionAfterClose,readOnly,isRef,actionWhenCantOpen,isFromRefer){
	 var rv="";
	 var pm = new planManager();
	 pm.checkPotent(planId, {
         success: function(ret){
	         if(ret=="true"){
				 var toSrc = _ctxPath+"/plan/plan.do?method=initPlanDetailFrame&open=dialog&planId="+planId;
				 if(typeof(readOnly)!='undefined'){
					 toSrc = toSrc+"&readOnly="+readOnly;
				 }
				 if(typeof(readOnly)!='undefined'){
				    toSrc = toSrc+"&isRef="+isRef;
				 }
				 if(typeof(readOnly)!='undefined'){
				    toSrc = toSrc+"&isFromRefer="+isFromRefer;
				 }
				 var planViewdialog=$.dialog({
					    url: toSrc,
					    width: $(getA8Top().document).width() - 100,
					    height: $(getA8Top().document).height() - 100,
					    title: $.i18n('plan.dialog.showPlanTitle'),
					    closeParam : {'show':true,handler:function(){ 
					    	rv = planViewdialog.getReturnValue();
				    		planViewdialog.close();
				    		if(actionAfterClose instanceof Function){
				    			actionAfterClose();
					    	}
					    	}},
					    targetWindow:getCtpTop(),
					    buttons: [{
					        text: $.i18n('plan.dialog.close'),
					        handler: function () {
					    		rv = planViewdialog.getReturnValue();
					    		planViewdialog.close();
					    		if(actionAfterClose instanceof Function){
					    			actionAfterClose();
						    	}
					        }
					    }]
					 });
	         }else if(ret=="false"){
				$.alert({
					'msg' : "${ctp:i18n('plan.alert.nopotent')}",
                	ok_fn : function() {
                	    if(typeof(actionWhenCantOpen)!='undefined' && actionWhenCantOpen != null){
                	      actionWhenCantOpen();
                	    }
                	  }
					});
				rv = "nopotent";
		     }else if(ret=="absence"){
		    	$.alert({
					'msg' : "${ctp:i18n('plan.alert.deleted')}",
                	ok_fn : function() {
                        if(typeof(actionWhenCantOpen)!='undefined' && actionWhenCantOpen != null){
                	       actionWhenCantOpen();
                	    }
                	  }
					});
		    	rv = "deleted";
			 }
         }
     });
     return rv;
}
</script>