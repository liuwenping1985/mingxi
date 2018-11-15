<%@ page contentType="text/html; charset=utf-8" isELIgnored="false"%>
<script type="text/javascript">
var v3x = new V3X();
var toolbar;
$(document).ready(function(){
    toolbar=$("#toolbar").toolbar({
                toolbar : [
                   {
                       name : "${ctp:i18n('menu.collaboration.listPending')}(${pendingNum})",
                       id:'listPending',
                       click : function() {
                         selected('listPending');
                       },
                       className : "ico16 no_through_ico_16"
                    },
                    {
                        name:"${ctp:i18n('menu.collaboration.listDone')}(${doneNum})",
                        id:'listDone',
                        click:function(){
                         selected('listDone');
                        },
                        className:"ico16 gone_through_16"
                    },{
                        name:"${ctp:i18n('menu.collaboration.listsent')}(${sentNum})",
                        id:'listSent',
                        click:function(){
                         selected('listSent');
                        },
                        className:"ico16 lssued_16"
                    },{
                        name:"${ctp:i18n('menu.collaboration.listTrack')}(${trackNum})",
                        id:'listTrack',
                        click:function(){
                         selected('listTrack');
                        },
                        className:"ico16 track_16"
                    },{
                        name:"${ctp:i18n('menu.collaboration.supervise')}(${superviseNum})",
                        id:'listSupervise',
                        click:function(){
                         selected('listSupervise');
                        },
                        className:"ico16 view_unhandled_16"
                    }]
                });
    selected('list${param.column}');
        }
);
function selected(column){
  var allMenuBottons = toolbar.allMenuBottons;
  var item;
  for(var i=0;i<allMenuBottons.length;i++){
    item = allMenuBottons[i];
    toolbar.unselected(item.id);
  }
  toolbar.selected(column);
  $("#colListIframe").prop("src","${path}/form/formSection.do?method="+column+"&templateId=${templateId}");
}
</script>