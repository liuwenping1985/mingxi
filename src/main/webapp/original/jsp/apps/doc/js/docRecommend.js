$(function(){
	
	var currentUserId = $.ctx.CurrentUser.id;
    /**
     * 人员卡片，onMoueseOver
     */
    function initPeopleCardMini(){
        $("img[id^=personCard]").each(function(index) {
            $(this).PeopleCardMini({
                memberId : $(this).attr("userId")
            });
        });
    }
    
    // 定义全局变量,保存搜索的相关参数
    var mySearchObj = new Object();
    mySearchObj.userId = currentUserId;
    mySearchObj.dynamicType = "2";
    
    //=====搜索=========
    var searchobj = $('#searchDiv').searchCondition({
        searchHandler: function () {
            var ssss = searchobj.g.getReturnValue();
            mySearchObj.condition = ssss.condition;
            mySearchObj.value = ssss.value;
            $('#ajaxgridbar').ajaxgridbarLoad(mySearchObj);
        },
        conditions: [{
            id: 'docName',
            name: 'docName',
            type: 'input',
            text: "${ctp:i18n('doc.jsp.knowledge.query.name')}",
            value: 'd_frName_String_like'
        }, {
            id: 'contentType',
            name: 'contentType',
            type: 'select',
            text: "${ctp:i18n('doc.jsp.knowledge.query.contentType')}",
            value: 'd_frType_Long_equal',
            codecfg : "codeType:'java',codeId:'com.seeyon.apps.doc.manager.DocSearchContentTypeEnumImpl'"
        }, {
            id: 'keyword',
            name: 'keyword',
            type: 'input',
            text: "${ctp:i18n('doc.jsp.knowledge.query.key')}",
            value: 'd_keyWords_String_like'
        }, {
            id : 'alterUser',
            name : 'alterUser',
            type : 'selectPeople',
            text : "${ctp:i18n('doc.jsp.home.learn.recommender')}",
            value : 't_actionUserId_LinkedList_equal',
            comp:"type:'selectPeople',mode:'open',panels:'Department,Team,Post,Outworker',selectType:'Member',maxSize:'1',showMe:'true'"
        }, {
            id: 'alterDate',
            name: 'alterDate',
            type: 'datemulti',
            text: "${ctp:i18n('doc.jsp.home.learn.time')}",
            value: 't_actionTime_Date_between',
            ifFormat:'%Y-%m-%d'
        }]
    });

    
    //=====加载数据=========
    $('#ajaxgridbar').ajaxgridbar({
        managerName : 'docActionUseManager',
        managerMethod : 'findLatestDynamicDocByType',
        callback : function(fpi) {
            var ul = $('#ulwithlis_recommend');
            ul.html("");
            var isDocCreateUser = false;
            var strHtml = new StringBuffer();
            for ( var i = 0, len = fpi.data.length; i < len; i++) {
                var o = fpi.data[i];
                isDocCreateUser = (currentUserId === o.createUserId);
                strHtml.append("<li class='padding_10 border_b_gray'><img id='personCard-");
                strHtml.append(i);
                strHtml.append("' userId='");
                strHtml.append(o.actionUserId);
                strHtml.append("' class='left margin_l_10 margin_b_10 margin_r_20 hand' src='${v3x:avatarImageUrl(o.actionUserId)}' width='42' height='42' onclick='$.PeopleCard({memberId:\"");
                strHtml.append(o.actionUserId);
                strHtml.append("\"});' /><div class='over_hidden'><div class='clearfix'><span class='left'><a href='javascript:void(0);' onclick='$.PeopleCard({memberId:\"");
                strHtml.append(o.actionUserId);
                strHtml.append("\"});' class='left margin_r_5'>");
                strHtml.append(o.actionUserName);
                strHtml.append("</a><span class='left margin_r_5'>${ctp:i18n('doc.jsp.knowledge.others.recommend.label')}</span><a href='javascript:void(0);' onclick='$.PeopleCard({memberId:\"");
                strHtml.append(o.createUserId);
                strHtml.append("\"});' class='left margin_r_5'>");
                strHtml.append(o.createUserName);
                strHtml.append("</a><span class='left margin_r_5'>${ctp:i18n('doc.jsp.knowledge.others.doc.label')}</span><span class='ico16 fileType2_");
                strHtml.append(o.mimeTypeId);
                strHtml.append(" margin_r_5 left'></span><a href='");
                if (isDocCreateUser) {
                    strHtml.append("javascript:fnDocOpenDialogOnlyId(\"");
                    strHtml.append(o.docResoureId);
                    strHtml.append("\", 1);");
                } else {
                    strHtml.append("javascript:openFileWithPermission(\"");
                    strHtml.append(o.docResoureId);
                    strHtml.append("\",\"");
                    strHtml.append(o.createUserId);
                    strHtml.append("\");");
                }
                strHtml.append("' title=\"");
                strHtml.append(o.frName);
                strHtml.append("\" class='left margin_r_5'>${ctp:i18n('doc.jsp.knowledge.doc.leftBook')}");
                strHtml.append(o.frName.getLimitLength(30,'...'));
                strHtml.append("${ctp:i18n('doc.jsp.knowledge.doc.rightBook')}</a><span class='left ");
                strHtml.append(o.avgScoreClass.toString());
                strHtml.append("'></span></span><span class='color_gray right margin_r_5'>");
                strHtml.append(fnEvalTimeInterval(o.actionTime));
                strHtml.append("</span></div><div class='margin_t_5 word_break_all'>");
                strHtml.append(o.description);
                strHtml.append("</div><div class='clearfix margin_t_20'><span class='right margin_l_10'><a href='javascript:void(0);' onclick='javascript:doc_recommend(\"");
                strHtml.append(o.docResoureId);
                strHtml.append("\",\"");
                strHtml.append(o.recommendEnable);
                strHtml.append("\");'>${ctp:i18n('doc.jsp.knowledge.recommend')}(");
                strHtml.append(o.recommendCount.toString());
                strHtml.append(")</a></span><span class='right margin_l_10 color_gray'>${ctp:i18n('doc.jsp.knowledge.evaluation')}(");
                strHtml.append(o.commentCount.toString());
                strHtml.append(")</span><span class='right margin_l_10 color_gray'>${ctp:i18n('doc.menu.download.label')}(");
                strHtml.append(o.downloadCount.toString());
                strHtml.append(")</span>");
                if (isDocCreateUser) {
                    strHtml.append("<span class='right margin_l_10 color_gray'>${ctp:i18n('doc.jsp.knowledge.collection')}(");
                    strHtml.append(o.collectCount.toString());
                    strHtml.append(")</span>");
                } else {
                    strHtml.append("<span class='right margin_l_10 color_gray'><a href='javascript:void(0);' onclick='favorite(\"3\", \"");
                    strHtml.append(o.docResoureId);
                    strHtml.append("\", \"false\", \"3\");'>${ctp:i18n('doc.jsp.knowledge.collection')}(");
                    strHtml.append(o.collectCount.toString());
                    strHtml.append(")</a></span>");
                }
                strHtml.append("</div></div></li>");
            }
            ul.html(strHtml.toString());
            $('#_afpPage').val(fpi.page);
            $('#_afpPages').val(fpi.pages);
            $('#_afpSize').val(fpi.size);
            $('#_afpTotal').val(fpi.total);
            initPeopleCardMini();
        }
    });
    $('#ajaxgridbar').ajaxgridbarLoad(mySearchObj);
});