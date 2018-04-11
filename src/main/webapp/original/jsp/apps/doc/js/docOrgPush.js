$(function(){
    // 定义全局变量,保存搜索的相关参数
    var mySearchObj = new Object();
    mySearchObj.curUserId = $.ctx.CurrentUser.id;
    
    //=====搜索=========
    var searchobj = $('#searchDiv').searchCondition({
        searchHandler: function () {
            var ssss = searchobj.g.getReturnValue();
            mySearchObj.condition = ssss.condition;
            mySearchObj.value = ssss.value;
            $('#myajaxgridbar').ajaxgridbarLoad(mySearchObj);
        },
        conditions: [{
            id: 'docName',
            name: 'docName',
            type: 'input',
            text: "${ctp:i18n('doc.jsp.knowledge.query.name')}",
            value: 'dr_frName_String_like'
        }, {
            id: 'contentType',
            name: 'contentType',
            type: 'select',
            text: "${ctp:i18n('doc.jsp.knowledge.query.contentType')}",
            value: 'dr_frType_Long_equal',
            codecfg : "codeType:'java',codeId:'com.seeyon.apps.doc.manager.DocSearchContentTypeEnumImpl'"
        }, {
            id: 'keyword',
            name: 'keyword',
            type: 'input',
            text: "${ctp:i18n('doc.jsp.knowledge.query.key')}",
            value: 'dr_keyWords_String_like'
            
        }, {
            id : 'alterUser',
            name : 'alterUser',
            type : 'selectPeople',
            text : "${ctp:i18n('doc.metadata.def.lastuser')}",
            value : 'dal_lastUserId_LinkedList_equal',
            comp:"type:'selectPeople',mode:'open',panels:'Department,Team',selectType:'Member',maxSize:'1',showMe:'true'"
        }, {
            id: 'alterDate',
            name: 'alterDate',
            type: 'datemulti',
            text: "${ctp:i18n('doc.metadata.def.lastupdate')}",
            value: 'dal_lastUpdate_Date_between',
            ifFormat:'%Y-%m-%d'
        }]
    });
    
    //=====加载数据=========
    $('#myajaxgridbar').ajaxgridbar({
        managerName : 'knowledgePageManager',
        managerMethod : 'getDocOrgPush',
        callback : function(fpi) {
            //alert($.toJSON(fpi));
            var strHtml = "";
            for (var i = 0; i < fpi.data.length; i++) {
                var o = fpi.data[i];
                var ortherPushered = '';
                var pushedOthers = o.otherOrgPushUserNames;
                for ( var j = 0; j < pushedOthers.length; j++) {
                    ortherPushered += "<span class='left margin_r_10 color_gray'>" + pushedOthers[j] + "</span>";
                }
                ortherPushered = (ortherPushered==='' ? '' : "<span class='left color_gray'>" +
                		"${ctp:i18n('doc.jsp.knowledge.otherPusher.label')}</span>" + ortherPushered);
                strHtml +=
"<li class='padding_10 border_t_gray'>" +
"<img id='img-" + i + "' name='" + o.docCreateUserId + "' class='left margin_l_10 margin_b_10 margin_r_20 hand' " + 
    "src='http://list.image.baidu.com/t/image/w_mengchong.jpg' width='42' height='42' " + 
    "onclick='$.PeopleCard({memberId:\"" + o.docCreateUserId + "\"});' />" + 
"<div class='over_auto_hiddenY'>" +
    "<div class='clearfix'>" +
        "<span class='left'><a href='javascript:void(0);' class='left margin_r_5' onclick='$.PeopleCard({memberId:\"" 
        + o.docCreateUserId + "\"});' >" 
        + o.docCreateUserName + "</a><span class='left margin_r_5'>" + o.operateType + "</span><span class='left ico16 " 
        + o.docMimeTypeName + "_16 margin_r_5'></span><a href='javascript:fnOpenKnowledge(\"" + o.docResourceId + "\""
        + ");' class='left margin_r_5'>${ctp:i18n('doc.jsp.knowledge.doc.leftBook')}" 
        + o.frName + "${ctp:i18n('doc.jsp.knowledge.doc.rightBook')}</a><span class='left " 
        + fnGetStarLevelClass(o.totalScore, o.scoreCount) + "'></span></span>" +
        "<span class='color_gray right'>" + fnEvalTimeInterval(o.pushTime) + "</span>" +
    "</div>" +
    "<div class='margin_t_5'>${ctp:i18n('doc.jsp.knowledge.filepath.label')}" + o.path.replace(/\\/g,"") + "</div>" +
    "<div class='clearfix margin_t_10'>" +
        "<span class='left margin_r_10 color_gray'>${ctp:i18n('doc.jsp.knowledge.pusher.label')}" + o.pushUserName + "</span>" +
         ortherPushered +
        "<span class='right margin_l_10'><a href='javascript:void(0);' onclick='javascript:doc_recommend(\"" + o.docResourceId 
        + "\");'>${ctp:i18n('doc.jsp.knowledge.recommend')}(" 
        + o.recommendCount + ")</a></span>" +
        "<span class='right margin_l_10 color_gray'>${ctp:i18n('doc.jsp.knowledge.evaluation')}(" + o.commentCount + ")</span>" +
        "<span class='right margin_l_10 color_gray'>${ctp:i18n('doc.menu.download.label')}(" + o.downloadCount + ")</span>" +
        "<span class='right margin_l_10 color_gray'><a href='javascript:void(0);' onclick='favorite(\"3\", \"" + o.docResourceId 
        + "\", \"false\", \"3\");'>${ctp:i18n('doc.jsp.knowledge.collection')}(" + o.collectCount + ")</a></span>" +
    "</div>" +
"</div>" +
"</li>";
            }
            $('#ulwithlis').html(strHtml);
            $('#_afpPage').val(fpi.page);
            $('#_afpPages').val(fpi.pages);
            $('#_afpSize').val(fpi.size);
            $('#_afpTotal').val(fpi.total);
            for (var i = 0; i < fpi.data.length; i++) {
               var $imgElement = $('#img-' + i);
               var createUserId = $imgElement.attr('name');
               $imgElement.PeopleCardMini({memberId: createUserId});
            }
        }
    });
    $('#myajaxgridbar').ajaxgridbarLoad(mySearchObj);
});