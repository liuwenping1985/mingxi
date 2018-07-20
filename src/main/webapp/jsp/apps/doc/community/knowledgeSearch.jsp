
<script type="text/javascript">
        $(function () {
            
            //**********搜索************
            var searchobj = $('#searchDiv').searchCondition({
                searchHandler: function () {
                    var jsonParam = searchobj.g.getReturnValue();
                    var paramValue = jsonParam.value;
                    var condition = jsonParam.condition;
                    if(condition == 'createUser' || condition == 'createTime' || condition == 'sponsor' || condition == 'startDate') {
                        if(paramValue[0] == '' || paramValue[1] == '') {
                            $.alert('${ctp:i18n("doc.jsp.knowledge.query.error")}');
                            return;
                        }
                        if(condition == 'createTime' || condition == 'startDate') {
                            var result = compareDate(paramValue[0], paramValue[1]);
                            if(result > 0) {
                                $.alert('${ctp:i18n("doc.jsp.knowledge.query.error")}');
                            }
                        }
                    } else {
                        if(paramValue == null || paramValue.trim() == '') {
                            $.alert('${ctp:i18n("doc.jsp.knowledge.query.error")}');
                            return;
                        }
                    }
                    
                    //TODO 点击查询按钮执行的操作
                    //后台manager及method
                    //managerName :'knowledgeManager',
                    //managerMethod :'findAllDocsByAjax',
                    //如有不同请自行再实现具体搜索逻辑
                },
                conditions: [{
                    id: 'frName',
                    name: 'frName',
                    type: 'input',
                    text: $.i18n('doc.jsp.knowledge.query.name'),
                    value: 'frName'
                }, {
                    id: 'contentType',
                    name: 'contentType',
                    type: 'select',
                    text: $.i18n('doc.jsp.knowledge.query.contentType'),
                    value: 'contentType',
                    codecfg: "codeType:'java',codeId:'com.seeyon.apps.doc.enums.ContentTypeEnums'"
                }, {
                    id: 'keyWords',
                    name: 'keyWords',
                    type: 'input',
                    text: $.i18n('doc.jsp.knowledge.query.key'),
                    value: 'keyWords'
                }, {
                    id: 'createTime',
                    name: 'createTime',
                    type: 'datemulti',
                    text: $.i18n('doc.jsp.knowledge.query.createTime'),
                    value: 'createTime',
                    ifFormat:'%Y-%m-%d'
                }, {
                    id: 'createUser',
                    name: 'createUser',
                    type: 'selectPeople',
                    text: $.i18n('doc.jsp.knowledge.query.createUser'),
                    value: 'createUser',
                    comp:"type:'selectPeople',mode:'open',panels:'Department,Team',selectType:'Member',maxSize:'1',showMe:'true'"
                }, {
                    id: 'sponsor',
                    name: 'sponsor',
                    type: 'selectPeople',
                    text: $.i18n('doc.jsp.knowledge.query.launched'),
                    value: 'sponsor',
                    comp:"type:'selectPeople',mode:'open',panels:'Department,Team',selectType:'Member',maxSize:'1',showMe:'true'"
                }, {
                    id: 'startDate',
                    name: 'startDate',
                    type: 'datemulti',
                    text: $.i18n('doc.jsp.knowledge.query.launchedTime'),
                    value: 'startDate',
                    ifFormat:'%Y-%m-%d'
                }]
            });
        });
</script>
    <div id="searchDiv" class="right"></div>
