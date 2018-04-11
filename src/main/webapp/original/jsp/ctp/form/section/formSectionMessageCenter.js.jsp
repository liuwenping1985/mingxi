<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<script type="text/javascript">
var sectionId = "${section.id}";
getCtpTop().showMoreSectionLocation("${ctp:escapeJavascript(section.sectionName) }${ctp:i18n('formsection.homepage.center.label') }");
$(document).ready(function(){
    $("#functionDIV").css("left",$("#tabs2").width()-430);
    <c:choose>
        <c:when test="${param.type eq 'flow'}">
        formFlow();
        </c:when>
        <c:when test="${param.type eq 'query'}">
        formSearch();
        </c:when>
        <c:when test="${param.type eq 'statistic'}">
        formStatistics();
        </c:when>
    </c:choose>
    var layout = $("#layout").layout();
    //getA8Top().hideLocation();
    layout.setEast(0);
    layout.setWest(0);
    layout.setSouth(0);
});

function formFlow(){
    $("#formFlowFrame").prop("src","${path }/form/formSection.do?method=formFlow&column=${param.column }&sectionId=${param.sectionId}");
	<c:if test = "${empty param.column}">
    $("#formFlowFrame").prop("src","${path }/form/formSection.do?method=formFlow&column=Pending&sectionId=${section.id}");
	</c:if>
}
function formSearch(){
    $("#formFlowFrame").prop("src","${path }/form/formSection.do?method=formSearch&sectionId=${section.id}");
}
function formStatistics(){
    $("#formFlowFrame").prop("src","${path }/form/formSection.do?method=formStatistics&sectionId=${section.id}");
}

function showTemplate(){
    var dialog = $.dialog({
      id:'biztemplate',
        'title' : '${ctp:i18n("formsection.infocenter.biztemplate") }',
        'width':600,
        'height':400,
        targetWindow:getCtpTop(),
        transParams:dialog,
        'url':'${path}/form/formSection.do?method=templateList&sectionId='+sectionId,
         buttons:[{
           text : "${ctp:i18n('common.button.close.label')}",
           handler : function() {
             dialog.close();
           }
       }]
      });
}

function changeConfig(){
    var dialog = $.dialog({
        'title' : '${ctp:i18n("formsection.config.homepage.column.edit")}',
        'width':620,
        'height':320,
        targetWindow:getCtpTop(),
        'url':'${path}/form/formSection.do?method=changeConfig&sectionId='+sectionId,
        buttons:[{
          text : "${ctp:i18n('common.button.ok.label')}",
            isEmphasize: true,
            handler : function() {
                var value = dialog.getReturnValue();
                if(value === ""){
                    $.messageBox({
                        'type' : 0,
                        'msg' : '${ctp:i18n("formsection.config.column.must")}',
                        ok_fn : function() {
                        }
                      });
                    return;
                }
                $.ajax({
                   url:"${path}/form/formSection.do?method=saveChangeConfig",
                   data:{
                       'sectionId':sectionId,
                       'value':value
                   }
                });
              dialog.close();
            }
          }, {
            text : "${ctp:i18n('common.button.cancel.label')}",
            handler : function() {
              dialog.close();
            }
        }]
      });
}

function cancelMount(){
	var fsm = new formSectionManager();
	fsm.doCancelPublish(sectionId,true,{success:function(data){
		if(data == "true"){
				$("#cancelMount").hide();
				getCtpTop().refreshMenus();
		}else{
		  $.alert("${ctp:i18n("formsection.infocenter.cancelconfig.error")}");
		}
	}});
}
</script>