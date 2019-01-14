<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="${path}/ajax.do?managerName=thirdpartyUserMapperCfgManager"></script>
<title>EnumIframe</title>
<script type="text/javascript">
$().ready(function() {
	$("#"+"${autoMapperType}").attr("checked","checked");
	var mappercfg=new thirdpartyUserMapperCfgManager();
	$("input[name=mapper]").click(function(){
		var current = $(this).attr("id");
		if(current!="${autoMapperType}"){
		      $.confirm({
                  'msg': "${ctp:i18n('cip.manager.binding.change.type')}",
                  ok_fn: function() {
                	  mappercfg.changeMapperType(current, {
                          success: function() {
                          },error:function(e){
                         	$.alert(e);
                          }
                      });
                  }
              });
		}
	});


});
</script>
<style>
#toolbar1{
    height: 25px;
    padding-top: 7px;
    padding-left: 7px;
	font-size: 12px;
}
</style>
</head>
<body>
    <div id='layout' class="comp" comp="type:'layout'">
    <div class="comp" comp="type:'breadcrumb',comptype:'location',code:'cip_user'"></div>
    <div class="layout_north" layout="height:30,sprit:false,border:false">  
        <div id="toolbar1"> 
           ${ctp:i18n("cip.manager.binding.automapper")}：
           <label for="account" class="margin_r_20 hand">${ctp:i18n("cip.manager.binding.accountmapper")} <input type="radio" id="account" name="mapper"></label>
           <label for="code" class="margin_r_20 hand">${ctp:i18n("cip.manager.binding.codemapper")} <input type="radio" id="code" name="mapper"></label>
           <label for="email" class="margin_r_20 hand">${ctp:i18n("cip.manager.binding.emailmapper")}<input type="radio" id="email" name="mapper"></label>
           <label for="mobile" class="margin_r_20 hand">${ctp:i18n("cip.manager.binding.mobilemapper")} <input type="radio" id="mobile" name="mapper"></label>
	  </div>
   </div>
       <div id='layoutCenter' class="layout_center over_hidden" layout="border:false">
			<div id="tabs" class="comp" comp="type:'tab'">
				<div class="common_tabs clearfix" id="tabs_head">
            <ul class="left">
              <c:forEach items="${registerList}" var="data" varStatus="index">
              
                 <li <c:if test="${0==index.index}">class="current"</c:if>><a hidefocus="true" href="javascript:void(0)" 
                  tgt="tab${index.index}_iframe" ><span title="${data.appName}">${data.appName}</span></a></li>
              </c:forEach>
            </ul>
			   		
               </div>

	 </div>	
	  
        <div id="tabs_body" class="common_tabs_body" style="height: 100%;">
         <c:forEach items="${registerList}" var="data" varStatus="index">
            <iframe id="tab${index.index}_iframe" width="100%" height="100%"  frameborder="no"
                border="0" src="${path}/cip/userBindingController.do?method=listMapper&registerId=${data.id}"></iframe>
                </c:forEach>
        </div>
       </div>
	 </div>
</body>
</html>