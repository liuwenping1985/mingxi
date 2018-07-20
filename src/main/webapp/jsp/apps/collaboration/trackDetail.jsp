<!DOCTYPE html>
<html>
<head>
	<%@ page contentType="text/html; charset=UTF-8"%>
	<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<script type="text/javascript" src="${path}/ajax.do?managerName=colManager"></script>
	<script type="text/javascript" src="${path}/ajax.do?managerName=trackManager"></script>
	<script>
	var zdgzr ="";
	var isCset = true;
    $(document).ready(function(){
    	//0为不跟踪  1是全部人 2是指定人
    	var trackType = '${trackType}';
    	if('1' == trackType || '2' == trackType){
 			$("#gz")[0].selectedIndex = 0;
 			$("#gz_ren").show();
 			if(1 == trackType){
 				$("#radio1").attr("checked","checked");
 			}else if(2 == trackType){
 				$("#radio4").attr("checked","checked");
 				//是指定人的时候，该处去查询已经设置的指定人信息
 				var partText = document.getElementById("zdgzryName");
 	        	partText.style.display="";
 			}
 		}
    	var zdgzr = "${zdgzrStr}";
 		if('' != zdgzr){
    		var	zdgzryId = zdgzr.replace(/Member\|/g,"");  
    		var colTrack = new trackManager();
    		var params = new Object();
        	params["userId"] = zdgzryId;
        	var strName=colTrack.getTrackName(params);
        	$("#zdgzryName").val(strName);
        	$("#zdgzryName").attr("title",strName);
        	var partText = document.getElementById("zdgzryName");
        	partText.style.display="";
        	$("#zdgzry").val(zdgzryId);
 		}
 		if('0' == trackType){
 			$("#gz")[0].selectedIndex =1;
 			 var value = $("#gz").val();
             var _gz_ren = $("#gz_ren");
             switch (value) {
                 case "0":
                     _gz_ren.hide();
                     $("#radio1").attr("checked","checked");
                     break;
                 case "1":
                     _gz_ren.show();
                     break;
             }
 		}
 		var objstate = '${state}';
 		if(objstate && objstate =='3'||objstate =='1'){
 			//流程已经结束的，置灰
 			$("#gz").attr('disabled','disabled');
 			$("#radio1").attr('disabled','disabled');
 			$("#radio4").attr('disabled','disabled');
 			
 			var partText = document.getElementById("zdgzryName");
 			if(partText){
 				partText.style.display="none";
 			}
 	    	
 			isCset= false;
            var dia = window.parentDialogObj['trackDialog'];
            try{dia.disabledBtn("trackSubmit");}catch(e){}
 		}else{
 			$("#gz").removeAttr('disabled');
 			$("#radio1").removeAttr('disabled');
 			$("#radio4").removeAttr('disabled');
 		}

 		$("#radio4").bind('click',function(){
          	 $.selectPeople({
          	        type:'selectPeople'
          	        ,panels:'Department,Team,Post,Outworker,RelatePeople'
          	        ,selectType:'Member'
          	        ,text:"${ctp:i18n('common.default.selectPeople.value')}"
        	        ,hiddenPostOfDepartment:true
           	        ,hiddenRoleOfDepartment:true
           	        ,showFlowTypeRadio:false
           	        ,returnValueNeedType: false
          	        ,params:{
          	           value: zdgzr
          	        }
          	        ,targetWindow:getCtpTop()
          	        ,callback : function(res){
          	        	if(res && res.obj && res.obj.length>0){
          	        	$("#zdgzry").val(res.value);
          	        	trackName(res);
           	        }
          	        }
          	    });
          	var partText = document.getElementById("zdgzryName");
     		partText.style.display="";
          });
 		$("#radio1").bind('click',function(){
 		var partText = document.getElementById("zdgzryName");
 		partText.style.display="none";
 		});
 		$("#gz").change(function () {
            var value = $(this).val();
            var _gz_ren = $("#gz_ren");
            switch (value) {
                case "0":
                    _gz_ren.hide();
                    break;
                case "1":
                    _gz_ren.show();
                    break;
            }
        });
     });
    //定义回调函数,以json字符串形式返回
    function OK(){/**/
        if(isCset){
	    	var valueNew= $("#gz").val();
	        //弄新跟踪类型
	        var newTrackType = "-1";
	        if(0 == $("#gz")[0].selectedIndex && "checked" == $("#radio4").attr("checked")){
	            newTrackType = "2";
	        }else if(0 == $("#gz")[0].selectedIndex && "checked" == $("#radio1").attr("checked")){
	            newTrackType = "1";
	        }else{
	            newTrackType = "0";
	        }
	        //如果选的是否，则需要去删除掉所有的跟踪人员表里面的数据 采用ajax的方式
	        //需要改变的情况均可以到后面去完成 不管是否变化 都从数据库里面先删后加就可以了
	        //实例化Spring BS对象
	        var callerResponder = new CallerResponder();
	        var colMgr = new colManager();
	       //构造传送对象  穿一个数组过去  affairID summaryId isTrack 
	        var tranObj = new Object();
	        tranObj.affairId ='${affairId}';
	        tranObj.objectId ='${objectId}';
	        //组装新的和旧的tracktype
	        tranObj.oldTrackType ='${trackType}';
	        tranObj.newTrackType = newTrackType;
	        tranObj.trackMemberIds = $("#zdgzry").val();
	        tranObj.senderId = '${startMemberId}';
	        colMgr.getTrackInfo(tranObj);
	        return  newTrackType;
        }else{
			return  "cantset";
        }
    }
  //截取跟踪指定人长度
    function trackName(res){
    	var userName="";
    	var nameSprit="";
    	if(res.obj.length>0){
      	for(var co = 0 ; co<res.obj.length ; co ++){
    	   userName+=res.obj[co].name+",";
    	}
      	userName=userName.substring(0,userName.length-1);
      	//只显示前三个名字
      	nameSprit=userName.split(",");
      	if(nameSprit.length>3){
      		nameSprit=userName.split(",", 3);
      		nameSprit+="...";
      	}
      	$("#zdgzryName").attr("title",userName);
    	var partText = document.getElementById("zdgzryName");
    	partText.style.display="";
    	 $("#zdgzryName").val(nameSprit);
     }
    }
	</script>
</head>
<body scroll="no" style="overflow: hidden">
	<input type="hidden" id="zdgzry" name="zdgzry" />
	<input type="hidden" id="secretLevel" name="secretLevel" value="${ secretLevel}"/>
         <div id="htmlID">
        <div class="padding_tb_10 padding_l_10 font_size12">
            <!-- 跟踪 -->
            <span class="valign_m">${ctp:i18n('collaboration.forward.page.label4')}:</span>
            <select id="gz" class="valign_m">
                <option value="1">${ctp:i18n('message.yes.js')}</option>
                <option value="0">${ctp:i18n('message.no.js')}</option>
            </select>
            <div id="gz_ren" class="common_radio_box clearfix margin_t_10">
                <label for="radio1" class="margin_r_10 hand">
                    <!-- 全部 -->
                    <input type="radio" value="0" id="radio1" name="option" class="radio_com">${ctp:i18n('collaboration.listDone.all')}</label>
                    <br>
                <label for="radio4" class="margin_r_10 hand">
                    <!-- 指定人 -->
                    <input type="radio" value="0" id="radio4" name="option" class="radio_com">${ctp:i18n('collaboration.listDone.designee')}</label>
                    <input type="text" id="zdgzryName" name="zdgzryName" size="10" readonly="readonly" style="display: none" onclick="$('#radio4').click()"/>
            </div>
            
        </div>
    </div>
</body>
</html>