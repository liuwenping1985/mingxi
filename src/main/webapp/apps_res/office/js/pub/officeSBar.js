/**
 * 综合办公，搜索条封装
 * 
 * @param searchBarArgs 使用参考： pTemp.officeSBar =
 *            officeSBar().init({top:2,right:5,"searchItem":["selectPeople","title","importent","createDate"]}); 或者
 *            pTemp.searchBar = officeSBar().top(2).right(5).init(["selectPeople","title","importent","createDate"]);
 *            或者 pTemp.searchBar =
 *            officeSBar().position(2,5).fnId("searchBar").init(["selectPeople","title","importent","createDate"]);//一个页面多个的时候使用
 */
function officeSBar(argFunc) {
    //Bar 支持在java中解析的类型列表,默认为string类型
    var sBarTypes = ["byte","short","int","long","float","double","bool","date","string","selectPeople"];
    var sBar = {
        "argFunc" : null,//获取Bar参数的函数名
        "init" : init,
        "addAll" : addAll,
        "top" : fnTop,
        "right" : fnRight,
        "position" : fnPosition,
        "id" : fnId,
        "show" : fnShow,
        "hide" : fnHide,
        "remove" : fnRemove,
        "reload" : fnReload,
        "sBar" : null,// searchBar对象 调用init方法后初始化
        "sBarG" : null,// searchBar.g对象 调用init方法后初始化
        "$sBar" : null,// searchBar.jquery对象 调用init方法后初始化
        "data" : {
            top : 2,
            right : 5,
            pid : "_officeSBar_" + Math.floor(Math.random() * 10000000),
            "searchItems" : new ArrayList()
        }
    };

    if (argFunc) {
        sBar.argFunc = argFunc;
    }

    function fnId(id) {
        if ($.type(id) === "string" && id.length() > 0) {
            sBar.data.id = id;
            return sBar;
        } else {
            return sBar.data.id;
        }
    }

    function fnTop(top) {
        if ($.isNumeric(top)) {
            sBar.data.top = top;
            return sBar;
        } else {
            return sBar.data.top;
        }
    }

    function fnRight(right) {
        if ($.isNumeric(right)) {
            sBar.data.right = right;
            return sBar;
        } else {
            return sBar.data.right;
        }
    }

    function fnPosition(top, right) {
        fnTop(top);
        fnRight(right);
        return sBar;
    }

    // 显示searchBar
    function fnShow() {
        sBar.$sBar.show();
        return sBar;
    }

    // 隐藏searchBar
    function fnHide() {
        sBar.$sBar.hide();
        return sBar;
    }

    // 删除
    function fnRemove() {
        if (sBar.$sBar) {
            sBar.$sBar.remove();
            sBar.data.searchItems = new ArrayList();
        }
        return sBar;
    }

    function fnReload(sItems) {
        fnRemove();
        addAll(sItems);
        init();
        return sBar;
    }

    function addAll(sItems) {
        sBar.data.searchItems.addAll(sItems);
        return sBar;
    }

    function init(barArgs) {

        if (barArgs === undefined) {
            barArgs = {};
        }

        if ($.isArray(barArgs)) {
            sBar.data.searchItems.addAll(barArgs);
        } else if ($.isPlainObject(barArgs) && barArgs.searchItem) {
            if (barArgs.argFunc) {
                sBar.argFunc = barArgs.argFunc;
            }
            sBar.data.searchItems.addAll(barArgs.searchItem);
        }

        var defaultArg = {
            top : sBar.data.top,
            right : sBar.data.right,
            onchange : function() {
                var sjson = sBar.sBarG.getReturnValue();
                
                if (sjson == null || sjson == '') {
                  return;
                }
                
                var condition = sjson.condition, type = sjson.type;
                
                if (condition == null || condition == '') {
                  return;
                }
                
                if (type == 'input') {//追加输入事件
                  //  return;
                }
                
                parseCutomsType(sjson);
                
                if (typeof (fnSBarChange) !== 'undefined') {
                    fnSBarChange({condition:sjson.condition,_type_:sjson._type_,value:sjson.value});
                }else{
                		//切换前，清空输入框的查询条件
                		sBar.$sBar.find("input").each(function(){
                	    	this.value="";
                	  });
                }
            },
            searchHandler : function() {
                var j = sBar.sBarG.getReturnValue();
                
                if(j==null) return;
                
                var conditions={};
                
                if (j != null) {
                	parseCutomsType(j);
                	conditions.condition = j.condition;
                	conditions._type_ = j._type_;
					        if (j.value != null && j.value.length > 1200) {//内容太多，会导致后台查询错误OA-59233
                		j.value = j.value.substr(0,1200)
                	}
                	conditions.value = j.value;
                }
                if (typeof (fnSBarQuery) !== 'undefined') {
                    //参数处理,修改type的类型为java可以解析的类型,byte,short,integer[int],long,float,double,char,boolean[bool],date,string,list<?>
                   fnSBarQuery(conditions);
                }else{
                    $.alert("未实现fnSBarQuery函数~！");
                }
            },
            
            conditions : argsBuilder(sBar.data.searchItems.toArray()).toArray()
        };
        
        var arg = $.extend(true, {}, defaultArg, barArgs);
        if (arg.id) {// id优先
            var id = arg.id;
            arg.id = sBar.data.pid;
            sBar.sBar = $('#' + id).searchCondition(arg);
        } else {// 默认放在右上角
            arg.id = sBar.data.pid;
            sBar.sBar = $.searchCondition(arg);
        }
        
        if (arg.argFunc) {
          sBar.argFunc = arg.argFunc;
        }

        sBar.$sBar = $("#" + sBar.data.pid + "_ul");
        sBar.sBarG = sBar.sBar.g;

        return sBar;
    }

    /**
     * officeSBar参数构造器
     * 
     * @param barItems
     * @returns {ArrayList}
     */
    function argsBuilder(barItems) {
        var _defaultArgs = getArgsByFuncName();
        var _items = new ArrayList();
        // 解析参数，构造参数对象,自持自定义对象
        for ( var i = 0; i < barItems.length; i++) {
            // 如果是string类型，则表示存放id，如果是object或者数组类型，表示存放的是构造参数
            var item = barItems[i];
            if (typeof (item) === "string") {
                if (_defaultArgs[item]) {
                    _items.add(_defaultArgs[item]);
                } else {
                    $.alert("[id=" + item + "] 未在officeSBar.js中注册！");
                }
            } else {// 自定义对象
                _items.add(item);
            }
        }
        return _items;
    }

    function getArgsByFuncName() {
        if (sBar.argFunc) {
            return eval(sBar.argFunc + "();");
        } else {
            //$.alert('该页面未在officeSearcheBar.js中注册，请参考officeColumn函数');
            return defaultArgs();
        }
    }
    
    function parseCutomsType(sjson) {
	    if (sjson != null) {
	    	var condition = sjson.condition;
        var index = sjson.condition.lastIndexOf("_");
        if (index != -1) {//其它特殊字符与jquery冲突
            sjson.condition = condition.substr(0, index);
            sjson._type_ = condition.substr(index + 1).toLowerCase();
            //检查是否类型正确，如果没找到，提示
            if ($.inArray(sjson._type_, sBarTypes) == -1) {
            	sjson.condition = condition;
            	sjson._type_ = "string";
            }
        } else if(sjson.type == 'datemulti'){//默认为string类型
            sjson._type_ = "date";
        }else if(sjson.type == 'selectPeople'){//选人
        		sjson._type_ = "selectPeople";
        		sjson.value = sjson.value[1];
        }else{
            sjson._type_ = "string";
        }
  		}
    }

    function defaultArgs() {
        return {
        	"categoryName" : {
                id : 'subject',
                name : 'subject',
                type : 'input',
                text : $.i18n('office.auto.category.name.js'),
                value : 'name'
            },
            "selectPeople":{
                id : 'selectPeopleid',
                name : 'selectPeople',
                type : 'selectPeople',
                text : $.i18n('office.assetapply.startmember.js'),
                value : 'selectPeople',
                comp : "type:'selectPeople',mode:'open',value:'Department | -884316703172445_1,Member | 1730833917365171641',text:'开发中心、人员2'"
            },
            "title":{
                id : 'title',
                name : 'title',
                type : 'input',
                text : $.i18n('office.auto.title.js'),
                value : 'subject'
            },
            "importent":{
                id : 'importent',
                name : 'importent',
                type : 'select',
                text : '重要程度',
                value : 'importantLevel',
                items : [ {
                    text : '普通',
                    value : '0'
                }, {
                    text : '重要',
                    value : '1'
                }, {
                    text : '非常重要',
                    value : '2'
                } ]
            },
            "createDate" : {
                id : 'datetime',
                name : 'datetime',
                type : 'datemulti',
                text : $.i18n('office.autoapply.start.date.js'),
                value : 'createDate',
                dateTime : true
            },
            "sendDate" : {
                id : 'datetime1',
                name : 'datetime1',
                type : 'datemulti',
                text : '发起时间11',
                value : 'createDate',
                dateTime : true
            },
            "autoNumber" : {
                id : 'autoNumber',
                name : 'autoNumber',
                type : 'input',
                text : $.i18n('office.auto.num.js'),
                value : 'autoNumber'
            },
            "memberId" : {
                id : 'memberId',
                name : 'memberId',
                type : 'input',
                text : $.i18n('office.auto.handled.js'),
                value : 'memberId'
            },
            "routineMaintenanceFlag" : {
                id : 'routineMaintenanceFlag',
                name : 'routineMaintenanceFlag',
                type : 'select',
                text : $.i18n('office.auto.repairType.js'),
                value : 'routineMaintenanceFlag',
                items : [ {
                    text : $.i18n('office.auto.repairType1.js'),
                    value : '0'
                }, {
                    text : $.i18n('office.auto.repairType2.js'),
                    value : '1'
                } ]
            },
            "repairTime" : {
                id : 'datetime1',
                name : 'repairTime',
                type : 'datemulti',
                text :  $.i18n('office.auto.repairtime.js'),
                ifFormat:'%Y-%m-%d',
                value : 'repairTime',
                dateTime : false
            },
            "driver" : {
                id : 'driver',
                name : 'driver',
                type : 'input',
                text : $.i18n('office.auto.driver.js'),
                value : 'driver'
            },
              "illegalDate" : {
                  id : 'illegalDate',
                  name : 'illegalDate',
                  type : 'datemulti',
                  text : $.i18n('office.auto.illegal.illegalDate.js'),
                  ifFormat:'%Y-%m-%d',
                  value : 'illegalDate',
                  dateTime : false
           },
           "insuredDate" : {
               id : 'insuredDate',
               name : 'insuredDate',
               type : 'datemulti',
               text : $.i18n('office.auto.safety.insuredDate.js'),
               ifFormat:'%Y-%m-%d',
               value : 'insuredDate',
               dateTime : false
           },
           "inspectionDate" : {
               id : 'inspectionDate',
               name : 'inspectionDate',
               type : 'datemulti',
               text : $.i18n('office.auto.inspection.inspectionDate.js'),
               ifFormat:'%Y-%m-%d',
               value : 'inspectionDate',
               dateTime : false
           },
           "expDate" : {
               id : 'expDate',
               name : 'expDate',
               type : 'datemulti',
               text : $.i18n('office.auto.expDate.js'),
               ifFormat:'%Y-%m-%d',
               value : 'expDate',
               dateTime : false
           },
           "policyNum" : {
               id : 'policyNum',
               name : 'policyNum',
               type : 'input',
               text : $.i18n('office.auto.safety.policyNum.js'),
               value : 'policyNum'
           },
           "insureCompany" : {
               id : 'insureCompany',
               name : 'insureCompany',
               type : 'input',
               text : $.i18n('office.auto.safety.insureCompany.js'),
               value : 'insureCompany'
           },
           "illegalFlagStr" : {
               id : 'illegalFlagStr',
               name : 'illegalFlagStr',
               type : 'select',
               text : $.i18n('office.auto.illegal.illegalFlag.js'),
               value : 'illegalFlagStr',
               items : [ {
                   text : $.i18n('office.auto.illegal.illegalFlag1.js'),
                   value : '0'
               }, {
                   text : $.i18n('office.auto.illegal.illegalFlag2.js'),
                   value : '1'
               }]
          },
          "dealStateStr" : {
              id : 'dealStateStr',
              name : 'dealStateStr',
              type : 'select',
              text : $.i18n('office.auto.illegal.dealState.js'),
              value : 'dealStateStr',
              items : [ {
                  text : $.i18n('office.auto.illegal.dealState1.js'),
                  value : '0'
              }, {
                  text : $.i18n('office.auto.illegal.dealState3.js'),
                  value : '2'
              }, {
                  text : $.i18n('office.auto.illegal.dealState2.js'),
                  value : '1'
              }]
         }
        };
    }
    return sBar;
}
