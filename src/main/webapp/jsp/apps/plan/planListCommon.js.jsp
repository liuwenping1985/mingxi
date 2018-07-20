<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript" src="${path}/ajax.do?managerName=planManager"></script>
<script type="text/javascript">
var showPlan = function(data, r, c) {
      var pm = new planManager();
      pm.checkPotent(data.planId,{
          success:function(ret){
          if(ret=="true"){
              var contentFrame = document.getElementById("planContentFrame");
              var toSrc = "plan.do?method=initPlanDetailFrame&planId="+data.planId;
              contentFrame.src = toSrc;
          }else if(ret=="false"){
              $.alert($.i18n('plan.alert.nopotent'));
          }else if(ret=="absence"){
              var win = new MxtMsgBox({
                    'title':"${ctp:i18n('plan.alert.plansummary.sysmessage')}",
                    'type': 0,
                    'imgType':1,
                    'msg': "${ctp:i18n('plan.alert.deleted')}",
                    ok_fn:function(){
                        win.close();
                        //getCtpTop().reFlesh();
                    }
                });
          }
        }
      });
  };

var rend = function(txt, data, r, c,col) {
    if(col.name=='title'){
        txt = txt+data.viewTitle;
        if(data.hasAttatchment==true){
            txt = txt+"<span class='ico16 affix_16'></span>";
        }
        return txt;
    }
    if(col.name=='finishRatio'){
        return txt.toString()+"%";
    }
    if(col.name=='process'){
            if(txt==1){
                return "${ctp:i18n('plan.desc.replydetail.replyed')}";
            }
            if(txt==0){
                return "${ctp:i18n('plan.desc.replydetail.unreplyed')}";
            }
    }
    if(col.name=='planStatus'){
            if(txt=="1"){return "${ctp:i18n('plan.execution.state.1')}";}
            if(txt=="2"){return "${ctp:i18n('plan.execution.state.2')}";}
            if(txt=="3"){return "${ctp:i18n('plan.execution.state.3')}";}
            if(txt=="4"){return "${ctp:i18n('plan.execution.state.4')}";}
            if(txt=="5"){return "${ctp:i18n('plan.execution.state.5')}";}
            return txt;
    }
    return txt;
 };
</script>