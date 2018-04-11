<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<style>
    .stadic_head_height{
        height:0px;
    }
    .stadic_body_top_bottom{
        bottom: 37px;
        top: 0px;
    }
    .stadic_footer_height{
        height:37px;
    }
</style>
<script type="text/javascript" src="${path}/ajax.do?managerName=portalConfigManager"></script>
<script type="text/javascript">
$().ready(function() {
    var cnt;
    var pcManager = new portalConfigManager();
    var msg = '${ctp:i18n("info.totally")}';
    var isgroup = "";
    $("#thirdPortalform").hide();
    $("#button").hide();
    $(".assist").bind("click",assistfn);
  
    function addform(){
        $("#thirdPortalform").clearform({clearHidden:true});
        $("#thirdPortalform").enable();
        $("#tr1").hide();
    	$("#appText").hide();
      	$("#appTable").hide();
        $("#thirdPortalform").show();
        $("#loginPattern").attr("disabled",true);
        $("#registerId").attr("disabled",false);
        initSelect();
        $("#button").show();
        $("#south").show();
        $("#lconti").show();
        $("#conti").attr("checked",'checked');
        $(".userPwdTr").hide();
        $("input[name=enabled]:eq(0)").attr("checked",'checked'); 
        $("#loginInterface").hide();
        $("#img").addClass("hidden").css("visibility","hidden");
        deleteTR();
    	 $(".assist").bind("click",assistfn);
        mytable.grid.resizeGridUpDown('middle');
    }

    function initSelect(v) {
    	  var riList = pcManager.getCanSelectRegisterInfo();
    	  var registerId = document.getElementById("registerId");
    	  $("#registerId").empty();
    	  $("#registerId").prepend("<option value=''>${ctp:i18n('cip.select.choose')}</option>");
    	  if(null != riList){
    		  for(var i=0;i<riList.length;i++){
        		  var obj = riList[i];
        		  var item = createOption(obj.id, obj.appName);
        		  registerId.add(item);
              }
    	  }
    }
    function clickSelected(v) {
    	  var riList = pcManager.getRegisterInfoById(v);
    	  var registerId = document.getElementById("registerId");
  		  var item = createOption(riList.id, riList.appName);
  		  registerId.add(item);
  		  item.selected=true;
    }
    
    function createOption(value, text) {
		var option = document.createElement("option");
		option.value = value;
		option.text = text;
		
		return option;
	}
    var toolbarPlugin = new Array();
    
    <c:if test="${ctp:hasPlugin('applink')}">
    toolbarPlugin.push({
        id: "add",
        name: "${ctp:i18n('common.toolbar.new.label')}",
        className: "ico16",
        click: function() {
            addform();
        }
    });
    </c:if>
    toolbarPlugin.push({
        id: "modify",
        name: "${ctp:i18n('common.button.modify.label')}",
        className: "ico16 editor_16",
        click: griddbclick
    });
    <c:if test="${ctp:hasPlugin('applink')}">
    toolbarPlugin.push({
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
                $.alert("${ctp:i18n('cip.portal.delete')}");
            } else {
                $.confirm({
                    'msg': "${ctp:i18n('cip.portal.delete.ok')}",
                    ok_fn: function() {
                        pcManager.deletePortal(v, {
                            success: function() {
                                $("#mytable").ajaxgridLoad(o);
                                $("#thirdPortalform").hide();
                                $("#button").hide();
                            }
                        });
                    }
                });
            };
        }
    });
    </c:if>
    $("#toolbar").toolbar({
    	 toolbar:toolbarPlugin
    });

    var mytable = $("#mytable").ajaxgrid({
        click: gridclk,
        isHaveIframe:true,
        dblclick:griddbclick,
        colModel: [{
            display: 'id',
            name: 'id',
            width: '5%',
            sortable: false,
            align: 'center',
            type: 'checkbox'
        },
        {
            display: "${ctp:i18n('cip.register.appcode')}",
            sortable: true,
            name: 'appCode',
            width: '20%'
        },
        {
            display: "${ctp:i18n('cip.register.appname')}",
            sortable: true,
            name: 'registerName',
            width: '25%'
        },
      /*   {
            display: "${ctp:i18n('cip.servcie.url')}",
            sortable: true,
            name: 'registerServiceUrl',
            width: '25%'
        }, */
        {
            display: "${ctp:i18n('cip.service.register.access')}",
            sortable: true,
            name: 'loginPattern',
            width: '25%',
            codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.enums.AccessTypeEnum'"
        },
        {
            display: "${ctp:i18n('cip.service.enabled')}",
            sortable: true,
            name: 'isEnable',
            width: '25%',
            codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.enums.CipEnableEnum'"
        }],
        managerName: "portalConfigManager",
        managerMethod: "showThirdPortalList",
        parentId:'center',
        vChangeParam: {
            overflow: 'hidden',
            position: 'relative'
        },
        slideToggleBtn: true,
        vChange: true
    });
    //加载列表
    var o = new Object();
    $("#mytable").ajaxgridLoad(o);

    function gridclk(data, r, c) {
        $("#thirdPortalform").disable();
        $("#thirdPortalform").show();
        $("#button").hide();
        var thirdPortalDetail = pcManager.viewPortalInfo(data.id);
        if(thirdPortalDetail.accessMethod == 6 || thirdPortalDetail.accessMethod ==3){
          	 var startCommond = thirdPortalDetail.mapCommand;
           	 var trList = $("#mobody").children("tr")
           	 var jsonlength = getJsonLength(startCommond);
           	 var jsonkey = getJsonKey(startCommond);
           	 if(trList.length < jsonlength){
           		 for(var i = 0 ;i < jsonlength-trList.length; i++){
               		 createTrfn(); 
               	 } 
           	 }
           	 var trList = $("#mobody").children("tr")
           	 var values = jsonkey.split(",");
                for (var i=0;i<trList.length;i++) {
                  var commandType = values[i];
                  if(null != commandType && "" != commandType){
                	  var tdArr = trList.eq(i).find("td");
                      tdArr.eq(0).find("select").val(commandType);//移动端类型
                      if("iPhone" == commandType){
                    	  tdArr.eq(1).find("input").val(startCommond.iPhone);//命令
                      }
                      if("iPad" == commandType){
                    	  tdArr.eq(1).find("input").val(startCommond.iPad);//命令
                      }
                      if("androidPhone" == commandType){
                    	  tdArr.eq(1).find("input").val(startCommond.androidPhone);//命令
                      }
                      if("androidPad" == commandType){
                    	  tdArr.eq(1).find("input").val(startCommond.androidPad);//命令
                      }
                      if("WP" == commandType){
                    	  tdArr.eq(1).find("input").val(startCommond.WP);//命令
                      }
                      
                  }
                }
              $("#tr1").hide();
        	  $("#appText").show();
        	  $("#appTable").disable();
        	  $("#appTable").show();
        	  hideURLLocalApp(thirdPortalDetail.accessMethod);
        }else{
        	  $("#tr1").hide();
	       	  $("#appText").hide();
	       	  $("#appTable").hide();
	          if(thirdPortalDetail.accessMethod == 0 ){//pc   	  
	         	  $("#groupLevelId_area").show();   //sso    
	         	  $("#tr_pc_url").show();   //pc登录
	         	  $("#tr_h5_url").hide();   //h5登录
	           }else if(thirdPortalDetail.accessMethod == 1){//移动url
	         	  
	         	  $("#groupLevelId_area").show();   //sso    
	         	  $("#tr_pc_url").hide();   //pc登录
	         	  $("#tr_h5_url").show();   //h5登录
	           }else{
	        	   $("#groupLevelId_area").show();        
	         	   $("#tr_h5_url").show();
	         	   $("#tr_pc_url").show();
	           }
        }
        $(".assist").unbind("click",assistfn)
	    $("#img").addClass("hidden").css("visibility","hidden");
        $("#ssoLoginUrl").val("");
        $("#addForm").fillform(thirdPortalDetail);
    	if(thirdPortalDetail.loginAcl!=null&&thirdPortalDetail.loginAcl!=""){
      		 var o= $.parseJSON(thirdPortalDetail.loginAcl);
             $("#loginAclTxt").val(o.selectPeopleText);
      	}else{
      	     $("#loginAclTxt").val("");
      	     $("#loginAcl").val("");
      	}
        if(thirdPortalDetail.authenticationMode==1){
        	 $("#loginInterface").show();
        }else{
        	 $("#loginInterface").hide();
        }
        if($("#authenticationMode").val()=="2"){
    		$(".userPwdTr").show();
    		var userPwdMap = $.parseJSON(thirdPortalDetail.startCommand);
    		$("#addForm").fillform(userPwdMap);
    		if(userPwdMap.transmethod=='GET'){
    			$("#transmethod1").attr("checked","checked");
    		}else{
    			$("#transmethod2").attr("checked","checked");
    		}
    		$("#encrymethod").trigger("change");
    	}else{
    		$(".userPwdTr").hide();
    	}
        clickSelected(thirdPortalDetail.registerId);
        mytable.grid.resizeGridUpDown('middle');
    }
    
    function hideURLLocalApp(accessMethod){
    	  if(accessMethod == 3){
         	  $("#groupLevelId_area").hide();        
        	  $("#tr_pc_url").hide();
        	  $("#tr_h5_url").hide();
         	  }
    }
    function griddbclick() {
        var v = $("#mytable").formobj({
            gridFilter : function(data, row) {
              return $("input:checkbox", row)[0].checked;
            }
          });
        
        if (v.length < 1) {
            $.alert("${ctp:i18n('cip.chosce.modify')}");
        }else if(v.length > 1){
            $.alert("${ctp:i18n('cip.selected.one.record')}");
        }else{
            mytable.grid.resizeGridUpDown('middle');
            var mpostdetil = pcManager.viewPortalInfo(v[0]["id"]);
            $("#thirdPortalform").clearform({clearHidden:true});
            clickSelected(mpostdetil.registerId);
            if(mpostdetil.accessMethod == 6 || mpostdetil.accessMethod == 3){
           	 var startCommond = mpostdetil.mapCommand;
           	 var trList = $("#mobody").children("tr")
           	 var jsonlength = getJsonLength(startCommond);
           	 var jsonkey = getJsonKey(startCommond);
           	/*  var commonds = startCommond.substring(1,startCommond.length-1);
           	 commonds = commonds.split(","); */
           	 if(trList.length < jsonlength){
           		 for(var i = 0 ;i < jsonlength-trList.length; i++){
               		 createTrfn(); 
               	 } 
           	 }
           	 var trList = $("#mobody").children("tr")
           	 var values = jsonkey.split(",");
                for (var i=0;i<trList.length;i++) {
                  var commandType = values[i];
                  if(null != commandType && "" != commandType){
                	  var tdArr = trList.eq(i).find("td");
                      tdArr.eq(0).find("select").val(commandType);//移动端类型
                      if("iPhone" == commandType){
                    	  tdArr.eq(1).find("input").val(startCommond.iPhone);//命令
                      }
                      if("iPad" == commandType){
                    	  tdArr.eq(1).find("input").val(startCommond.iPad);//命令
                      }
                      if("androidPhone" == commandType){
                    	  tdArr.eq(1).find("input").val(startCommond.androidPhone);//命令
                      }
                      if("androidPad" == commandType){
                    	  tdArr.eq(1).find("input").val(startCommond.androidPad);//命令
                      }
                      if("WP" == commandType){
                    	  tdArr.eq(1).find("input").val(startCommond.WP);//命令
                      }
                      
                  }
                }
                 $("#tr1").hide();
           	  $("#appText").show();
           	  $("#appTable").disable();
           	  $("#appTable").show();
           	hideURLLocalApp(mpostdetil.accessMethod);
           }else{
           	  $("#tr1").hide();
   	       	  $("#appText").hide();
   	       	  $("#appTable").hide();
   	          $("#img").addClass("hidden").css("visibility","hidden");
   	          
   	       if( mpostdetil.accessMethod == 0 ){//pc   	  
         	  $("#groupLevelId_area").show();   //sso    
         	  $("#tr_pc_url").show();   //pc登录
         	  $("#tr_h5_url").hide();   //h5登录
           }else if(mpostdetil.accessMethod == 1){//移动url
         	  
         	  $("#groupLevelId_area").show();   //sso    
         	  $("#tr_pc_url").hide();   //pc登录
         	  $("#tr_h5_url").show();   //h5登录
           }else{
        	   $("#groupLevelId_area").show();        
         	   $("#tr_h5_url").show();
         	   $("#tr_pc_url").show();
           }
           }
            $("#addForm").fillform(mpostdetil);
          	if(mpostdetil.loginAcl!=null&&mpostdetil.loginAcl!=""){
         		 var o= $.parseJSON(mpostdetil.loginAcl);
                 $("#loginAclTxt").val(o.selectPeopleText);
         	}else{
         	   	 $("#loginAclTxt").val("");
         	   	 $("#loginAcl").val("");
         	   	}
            if(mpostdetil.authenticationMode==1){
           	 $("#loginInterface").show();
        	 $("#loginInterface").attr("disabled",true);
           }else{
           	 $("#loginInterface").hide();
           }
            $("#conti").removeAttr("checked");;
            $("#thirdPortalform").enable();
            $("#thirdPortalform").show();
            $("#loginPattern").attr("disabled",true);
            $("#registerId").attr("disabled",true);
            $("#button").show();
            $("#lconti").hide();
            if($("#authenticationMode").val()=="2"){
        		$(".userPwdTr").show();
        		var userPwdMap = $.parseJSON(mpostdetil.startCommand);
        		$("#addForm").fillform(userPwdMap);
        		if(userPwdMap.transmethod=='GET'){
        			$("#transmethod1").attr("checked","checked");
        		}else{
        			$("#transmethod2").attr("checked","checked");
        		}
        		$("#encrymethod").trigger("change");
        	}else{
        		$(".userPwdTr").hide();
        	}
            
            $(".assist").bind("click",assistfn);
        }
    }
    
    $("#authenticationMode").change(function(){
    	if($(this).val()=="2"){
    		$(".userPwdTr").show();
    		$("#transmethod1").attr("checked","checked");
    		$("#encrymethod").trigger("change");
    	}else{
    		$(".userPwdTr").hide();
    	}
    });
    $("#encrymethod").bind('change',function(){
    	if($(this).val()!="customize"){
    		$(".algorithm").hide();
    		$("#algorithm").val('');
    	}else{
    		$(".algorithm").show();
    	}
    });
    $("#registerId").change(function () {  
        var registerId = $("#registerId  option:selected").val();
        if(null != registerId && "" != registerId){
        	  var mpostdetil = pcManager.getRegisterInfoById(registerId);
              $("#loginPattern").val(mpostdetil.accessMethodName)
              var accessMethod = mpostdetil.accessMethod
              $("#accessMethod").val(accessMethod);
              var lastOption = $("#authenticationMode option:last");
              if( accessMethod == 0 ){//pc   	  
            	  $("#groupLevelId_area").show();   //sso    
            	  $("#tr_pc_url").show();   //pc登录
            	  $("#tr_h5_url").hide();   //h5登录
            	  $("#appText").hide();
            	  $("#appTable").hide();
            	  $("tr1").hide();
            	  
            	  $("#img").addClass("hidden").css("visibility","hidden");
              }else if(accessMethod == 1){//移动url
            	  
            	  $("#groupLevelId_area").show();   //sso    
            	  $("#tr_pc_url").hide();   //pc登录
            	  $("#tr_h5_url").show();   //h5登录
            	  $("#appText").hide();
            	  $("#appTable").hide();
            	  $("tr1").hide();
            	  
            	  $("#img").addClass("hidden").css("visibility","hidden");
              }else if( accessMethod == 3){//原生应用
            	  $("#groupLevelId_area").hide();        
            	  $("#tr_pc_url").hide();
            	  $("#tr_h5_url").hide();
            	  $("#appText").show();
            	  $("#appTable").show();
            	  $("tr1").hide();
            	  
            	  var trLenth = $("#assist_id").val();
            	  deleteTR();
              }else if(accessMethod == 6){//pc&原生应用         	
            	  $("#groupLevelId_area").show();  
            	  $("#tr_h5_url").hide();
            	  $("#tr_pc_url").show();
            	  $("#appText").show();
            	  $("#appTable").show();
            	  $("tr1").hide();
            	  
            	  var trLenth = $("#assist_id").val();
            	  deleteTR(trLenth);
              }else{
            	  //2 ,4 ,5 
            	  $("#groupLevelId_area").show();        
            	  $("#tr_h5_url").show();
            	  $("#tr_pc_url").show();
            	  $("#appText").hide();
            	  $("#appTable").hide();
            	  $("tr1").hide();
            	  
            	  $("#img").addClass("hidden").css("visibility","hidden");
              }
              if(accessMethod == 4 || accessMethod == 0 || accessMethod == 1){
            	  if(lastOption.val()!='2'){
            		  $("#authenticationMode").append("<option value='2'>${ctp:i18n('cip.AuthenticationEnum.UserPwdAuthentication')}</option>");   
            	  }
              }else{
            	  if(lastOption.val()=='2'){
            		  lastOption.remove();  
            	  }
              }
              $(".userPwdTr").hide();
        }
    });  
    
    function deleteTR(){
    	var  trLenth =$("#mobody tr").length;
       	if(1!=trLenth){
       		$("#mobody tr:not(:first)").remove();
       	   $("#mobileType1").find("option[value='iPhone']").attr("selected",true);
    	}
    }
    $("#btncancel").click(function() {
        location.reload();
    });
    
	var searchobj = $.searchCondition({
        top:7,
        right:10,
        searchHandler: function(){
            var ssss = searchobj.g.getReturnValue();
            $("#mytable").ajaxgridLoad(ssss);
        },
        conditions: [{
            id: 'search_name',
            name: 'search_name',
            type: 'input',
            text: "${ctp:i18n('cip.register.appname')}",
            value: 'registerName'
        }, 
        {
        	text: "${ctp:i18n('cip.portal.login.pattern')}",
        	id: 'login_Pattern',
            name: 'loginPattern',
            type: 'select',
            value: 'loginPattern',
            codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.enums.AccessTypeEnum'"
        },
        {
            id: 'search_enable',
            name: 'search_enable',
            type: 'select',
            text: "${ctp:i18n('cip.service.enabled')}",
            value: 'isEnable',
            codecfg : "codeType:'java',codeId:'com.seeyon.apps.cip.enums.CipEnableEnum'"
            
        }]
    }); 
    
    $("#btnok").click(function() {
        if(!($("#thirdPortalform").validate())){
          return;
        }
        if(null == $("#registerId").val() || "" == $("#registerId").val()){
        	$.alert("${ctp:i18n('cip.register.appname.choose.alert')}");
    		return;
        }
        if(null == $("#isEnable").val() || "" == $("#isEnable").val()){
        	$.alert("${ctp:i18n('cip.register.enable.choose.alert')}");
    		return;
        }
        if(null == $("#authenticationMode").val() || "" == $("#authenticationMode").val()){
        	$.alert("${ctp:i18n('cip.register.authenticationMode.choose.alert')}");
    		return;
        }
        
        if($("#authenticationMode").val()=='2'){
        	if($("#charset").val()==''){
        		$.alert("${ctp:i18n('cip.portal.choose.charset')}");
        		return;
        	}
        	if($("#encrymethod").val()==''){
        		$.alert("${ctp:i18n('cip.portal.choose.encrytmethod')}");
        		return;
        	}
        	if($("#username").val()=='' || $("#pwd").val()==''){
        		$.alert("${ctp:i18n('cip.portal.fill.parameter')}");
        		return;
        	}
        	if($("#encrymethod").val()=='customize' && $("#algorithm").val()==''){
            	$.alert("${ctp:i18n('cip.portal.fill.algorithm')}");
            	return;
            }
        }
       if($("#accessMethod").val() == 6 || $("#accessMethod").val() == 3){
    	   var trList = $("#mobody").children("tr")
    	   var startCommand = "";
    	   var dupMap = new Properties();
           for (var i=0;i<trList.length;i++) {
             var tdArr = trList.eq(i).find("td");
             var selectValue = tdArr.eq(0).find("select").val();//移动端类型
             var inputValue = tdArr.eq(1).find("input").val();//命令
             if(inputValue.indexOf("\"")>=0){
            	 $.alert("${ctp:i18n('cip.portal.startCommand.error.alert')}");
         		return;
             }
             var selectKey = dupMap.get(selectValue);
             if(selectKey!=null){
            	 $.alert("${ctp:i18n('cip.portal.app.tip')}");
            	 return;
             }
             dupMap.put(selectValue,selectValue);
             if(i== trList.length -1 ){
            	 startCommand += '\"'+selectValue+'\"' +":"+'\"'+inputValue+'\"';
             }else{
            	 startCommand += '\"'+selectValue+'\"' +":"+'\"'+inputValue+'\",';
             }
           }
           $("#startCommand").val("{"+startCommand+"}");
       }
        if(getCtpTop() && getCtpTop().startProc)getCtpTop().startProc();
        pcManager.createOrUpdateThirdPortal($("#addForm").formobj(), {
            success: function(portalBean) {
                try{if(getCtpTop()&&getCtpTop().endProc){getCtpTop().endProc()}}catch(e){};
                $("#mytable").ajaxgridLoad(o);
                if($("#conti").attr("checked")=="checked"){
                    addform();
                }else{   
                    $("#thirdPortalform").hide();
                    $("#button").hide();
                }
            }
        });
    });
    
    $("#addImg").click(function(){
    	createTrfn();
	});
    
	$("#delImg").click(function(){
		var trId = $("#assist_id").val();
		var prevTr = $("#"+trId).prev("tr");
		if(prevTr==null||prevTr.attr("id")==undefined){
			prevTr = $("#"+trId).next("tr");
			if(prevTr==null||prevTr.attr("id")==undefined){
				return;
			}else{
				var img = $("#img");
				var offset = img.offset();
				offset.top = offset.top+$("#"+trId).height()+2;
				img.offset(offset);
			}
		}
		$("#assist_id").val(prevTr.attr("id"));
		$("#"+trId).remove();
    
});
	
    function selectPeople(){
    	var loginJson = $("#loginAcl").val();
    	var loginObject=new Object();
    	loginObject.selectPeopleValue="";
    	if(loginJson!=null&&loginJson!=""){
    		 var o= $.parseJSON(loginJson);
    		 loginObject.selectPeopleValue=o.selectPeopleValue;
    	}
    	  $.selectPeople({
              type: 'selectPeople',
              panels: 'Account,Department,Post,Level,Team,Role,Outworker',
              selectType: 'Account,Department,Member,Team,Post,Level,Role',
              onlyLoginAccount:false,
              hiddenRootAccount:false,
              returnValueNeedType : true,
              minSize:0,
          	  params : {
			       value : loginObject.selectPeopleValue
			     },
              callback: function(ret) {
                  $("#loginAclTxt").val(ret.text);
                  if(ret.value!=""){
                  var textJson = {"selectPeopleValue":ret.value,"selectPeopleText":ret.text};
                  $("#loginAcl").val(JSON.stringify(textJson));
                  }else{
                	  $("#loginAcl").val("");
                  }
              }
        });
      }
    
    $("#loginAclTxt").bind("click",function() {
    	selectPeople();
      });
});

function getJsonLength(jsonData){
	var jsonLength = 0;
	for(var item in jsonData){
		jsonLength++;
	}
	return jsonLength;
}
function getJsonKey(jsonData){
	var jsonKey ="";
	for(var item in jsonData){
		jsonKey +=item+","
	}
	return jsonKey;
}
function createTrfn(){
	var trId = $("#assist_id").val();
	var html = $("#"+trId).html();
	var tableId = $("#"+trId).parent().parent().attr("id");
	var last = $("#"+tableId+" tr:last").attr("id");
	var assistId = ($("#"+last).find("input").attr("id"));
	var newNum = parseInt(last)+1; 
	html = "<td>"+
        	"<div class='common_selectbox_wrap'>"+
		      "<select id='mobileType"+newNum+"' name='mobileType"+newNum+"' >"+
		        "<option value='iPhone'>iPhone</option>"+
				"<option value='iPad'>iPad</option>"+
				"<option value='androidPhone'>androidPhone</option>"+
				"<option value='androidPad'>androidPad</option>"+
				"<option value='WP'>WP</option>"+
			 " </select>"+
		  " </div>"+
		 " </td>"+
		 "<td>"+
			"<div class='common_txtbox_wrap '>"+
				"<input type='text' id='"+assistId+newNum+"' name='"+assistId+newNum+"' class='validate word_break_all' validate=\"type:'string',notNull:true,name:'${ctp:i18n('cip.start.command.label')}',minLength:10,maxLength:1000\">"+
			"</div>"+
		"</td>";
	$("#appTable").append("<tr class='assist' id='"+newNum+"'>"+html+"</tr>");
	$(".assist").unbind("click",assistfn).bind("click",assistfn);
	$("#assist_id").val($("#"+trId).next("tr").attr("id"));
	$("select").unbind("change",selectChange).bind("change",selectChange);
}

var selectChange = function (){
	 var value = $(this).children('option:selected').val();;
	 var trList = $("#mobody").children("tr")
     for (var i=0;i<trList.length;i++) {
       var tdArr = trList.eq(i).find("td");
       var selectValue = tdArr.eq(0).find("select").val();//移动端类型
       if(selectValue == value ){
    	  // $.alert("${ctp:i18n('cip.register.enable.choose.alert')}");
    	   return;
       }
     }
}

var assistfn = function(){
	addOrDelTr(this);
}
var textfn = function (){
	if("formName"!=$(this).attr("id")){
		if($("#formId").val()==""){
			$.alert("${ctp:i18n('voucher.formmapper.formselect')}");
		}
	}
}
var mousefn = function(){
	var o = $(this);
	o.attr("title",o.val());
}
function addOrDelTr(target){
		//$("#img").removeClass("hidden").css("visibility","visible");
		var imgDiv = $("#img");
	    if(imgDiv.length<=0){
	        return;
	    }
	    imgDiv.removeClass("hidden").css("visibility","visible");
	    //imgDiv.data("currentRow",getRowData(target));
	    $("#assist_id").val($(target).attr("id"));
	    var addImg = $("#addImg");
	    var delImg = $("#delImg");
	    var pos = getElementPos(target);
	    pos.left = pos.left - imgDiv.width();
	    imgDiv.offset(pos);
	    //允许添加
        addImg.css("display", "block");
        addImg[0].title = $.i18n("form.base.addRow.label");
        delImg.css("display", "block");
        delImg[0].title = $.i18n("form.base.delRow.label");
}
/**
 *获取位置,返回位置对象，如：{left:23,top:32}
 */
function getElementPos(el) {
    var ua = navigator.userAgent.toLowerCase();
    if (el.parentNode === null || el.style.display == 'none') {
        return false;
    }
    var parent = null;
    var pos = [];
    var box;
    if (el.getBoundingClientRect) {//IE，google
        box = el.getBoundingClientRect();
        var scrollTop = document.documentElement.scrollTop;
        var scrollLeft = document.documentElement.scrollLeft;
        if(navigator.appName.toLowerCase()=="netscape"){//google
        	scrollTop = Math.max(scrollTop, document.body.scrollTop);
        	scrollLeft = Math.max(scrollLeft, document.body.scrollLeft);
        }
        return { left : box.left + scrollLeft, top : box.top + scrollTop };
    } else if (document.getBoxObjectFor) {// gecko
        box = document.getBoxObjectFor(el);
        var borderLeft = (el.style.borderLeftWidth) ? parseInt(el.style.borderLeftWidth) : 0;
        var borderTop = (el.style.borderTopWidth) ? parseInt(el.style.borderTopWidth) : 0;
        pos = [ box.x - borderLeft, box.y - borderTop ];
    } else {// safari & opera
        pos = [ el.offsetLeft, el.offsetTop ];
        parent = el.offsetParent;
        if (parent != el) {
            while (parent) {
                pos[0] += parent.offsetLeft;
                pos[1] += parent.offsetTop;
                parent = parent.offsetParent;
            }
        }
        if (ua.indexOf('opera') != -1 || (ua.indexOf('safari') != -1 && el.style.position == 'absolute')) {
            pos[0] -= document.body.offsetLeft;
            pos[1] -= document.body.offsetTop;
        }
    }
    if (el.parentNode) {
        parent = el.parentNode;
    } else {
        parent = null;
    }
    while (parent && parent.tagName != 'BODY' && parent.tagName != 'HTML') { // account for any scrolled ancestors
        pos[0] -= parent.scrollLeft;
        pos[1] -= parent.scrollTop;
        if (parent.parentNode) {
            parent = parent.parentNode;
        } else {
            parent = null;
        }
    }
    return {
        left : pos[0],
        top : pos[1]
    };
}
</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',code:'cip_portal'"></div>
    <div class="layout_north" layout="height:40,sprit:false,border:false">
     	<div id="searchDiv"></div>
        <div id="toolbar"></div>
    </div>
    <div class="layout_center over_hidden" layout="border:false" id="center">
        <table id="mytable" class="flexme3" border="0" cellspacing="0" cellpadding="0" ></table>
        <div id="grid_detail" class="relative">
            <div class="stadic_layout">
                <div class="stadic_layout_head stadic_head_height"></div>
                <div class="stadic_layout_body stadic_body_top_bottom">
                    <div id="thirdPortalform" class="form_area">
                        <%@include file="cipPortalForm.jsp"%>
                    </div>
                </div>
                <div class="stadic_layout_footer stadic_footer_height">
                    <div id="button" align="center" class="page_color button_container">
                        <div class="common_checkbox_box clearfix  stadic_footer_height padding_t_5 border_t">
                            <label for="conti" class="margin_r_10 hand" id="lconti">
                                <input type="checkbox" id="conti" class="radio_com" checked="checked">${ctp:i18n('continuous.add')}</label>
                            <a id="btnok" href="javascript:void(0)" class="common_button common_button_emphasize margin_r_10">${ctp:i18n('common.button.ok.label')}</a>
                            <a id="btncancel" href="javascript:void(0)" class="common_button common_button_gray">${ctp:i18n('common.button.cancel.label')}</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>