$(function(){
    var mySearchObj = new Object();
    mySearchObj.curUserId = $.ctx.CurrentUser.id;
    var knowledgeMgr = new knowledgePageManager();
    knowledgeMgr.getDocLatestRead(mySearchObj.curUserId, 16, {
        success:function(list) {
            var strHtml = "";
            for(var i=0; i< list.length; i++) {
                var o = list[i];
                strHtml += o.docResoureId + "<>" + o.mimeTypeId + "<>" + o.frName + "<>" 
                + o.createUserName + "<>" + o.totalScore + "<><br/>";
            }
            $('#ulwithlis01').html(strHtml);
        }
    });
    
    //=====加载数据=========
    $('#myajaxgridbar').ajaxgridbar({
        managerName : 'knowledgePageManager',
        managerMethod : 'getDocCollect',
        callback : function(fpi) {
            var strHtml = "";
            for (var i = 0; i < fpi.data.length; i++) {
                var o = fpi.data[i];
                strHtml += o.docResoureId + "<>" + o.mimeTypeId + "<>" + o.frName + "<>" 
                + o.createUserName + "<>" + fnGetStarLevelClass(o.totalScore, o.scoreCount) + "<><br/>";
            }
            $('#ulwithlis02').html(strHtml);
            $('#_afpPage').val(fpi.page);
            $('#_afpPages').val(fpi.pages);
            $('#_afpSize').val(fpi.size);
            $('#_afpTotal').val(fpi.total);
        }
    });
    $('#myajaxgridbar').ajaxgridbarLoad(mySearchObj);
});