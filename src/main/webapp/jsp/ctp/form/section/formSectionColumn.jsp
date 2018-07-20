<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<div style="width: 100%;height: 220px;margin-top: 10px;display: inline-block;float: none;max-width: 500px;">
    <div class="left" style="width: 40%;height: 100%;max-width: 250px;">
	     <div id="allColumns" class="scrollList padding5 border_all" style="height: 200px;">
	         <iframe name="allColumnsIFrame" id="allColumnsIFrame" src="${path }/form/formSection.do?method=showColumnTree&MountType=column&canedit=${param.type eq 'view' ? 'false' : 'true' }&type=showAll&templateIds=${ffmyform.extraMap['templateId'] }" height="100%" width="100%"  border="0" frameBorder="no"></iframe>
	     </div>
    </div>
    <div class="left" style="width: 8%;height: 100%;padding-top: 60px;">
     <c:if test="${param.type ne 'view' }">
         <p id="columnRight">
            <span class="ico16 select_selected" onClick="allColumnsIFrame.selectColumn()"></span>
         </p>
         <p id="columnLeft" style="margin-top: 20px;">
            <span class="ico16 select_unselect" onClick="selectColumnsIFrame.removeColumn()"></span>
         </p>
     </c:if>
    </div>
    <div class="left" style="width: 40%;height: 100%;max-width: 250px;">
        <div id="selectedColumns" class="scrollList padding5 border_all" style="height: 200px;">
            <iframe name="selectColumnsIFrame" id="selectColumnsIFrame" src="${path }/form/formSection.do?method=showColumnTree&MountType=column&canedit=${param.type eq 'view' ? 'false' : 'true' }&type=showSelect&sectionId=${ffmyform.id}" height="100%" width="100%"  border="0" frameBorder="no"></iframe>
        </div>
    </div>
    <div class="left" style="width: 8%;height: 100%;padding-top: 60px;">
     <c:if test="${param.type ne 'view' }">
         <p id="columnUp">
            <span class="ico16 sort_up" onClick="selectColumnsIFrame.moveColumn('prev')"></span>
         </p>
         <p id="columnDown" style="margin-top: 20px;">
            <span class="ico16 sort_down" onClick="selectColumnsIFrame.moveColumn('next')"></span>
            </p>                    
        </c:if>
    </div>
</div>
