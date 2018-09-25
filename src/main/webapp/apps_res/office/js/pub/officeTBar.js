/**
 * $Author: muyx $ $Rev: 1 $ $Date:: 2013-06-20 下午2:08:33#$:
 * 
 * Copyright (C) 2012 Seeyon, Inc. All rights reserved. This software is the proprietary information of Seeyon, Inc. Use
 * is subject to license terms.
 */
/**
 * 对toolbar的封装 根据菜单id生成toolbar对象，并对插件的存在性做了统一判定；
 * 
 * @param id toolbar的div的id
 * @param menuItems 数组，对应argsBuilder中的_toolbarDefault对象的id
 * @returns toolbar对象 测试参考： pTemp.tBar = officeTBar().addAll([ "new", "edit", "del","move",
 *          "refresh","sort","disable","upload",
 *          {"newContent":["newHtml","newOffice","newExcel"]},{"advanced":["forwardToColl","forwardToEmail","sortSubItem"]},
 *          {"sendTo":["sendToCommon","sendToDept","sendToOrg","sendToPersonalLearn","sendToDeptLearn","sendToOrgLearn","sendToTarget"]}]).init(
 *          "toolbar");
 */
function officeTBar(tArg) {
    var tBar = {
        "init" : init,
        "addAll" : addAll,
        "argsBuilder" : argsBuilder,
        "menuItems" : new ArrayList(),
        "toolBar" : null,
        "tArg":tArg,
        "id" : null
    };

    function init(id, menuItems) {
        tBar.menuItems.addAll(menuItems);
        var oArgs = argsBuilder(tBar.tArg);
        tBar.id = id;
        tBar.toolBar = $("#" + id).toolbar(oArgs);
        return tBar;
    }

    /**
     * 菜单参数构造器的便捷方法，可以多次增加菜单项数组，用于动态增加菜单项
     * 
     * @param menuItems 菜单项id的数组
     * @returns 菜单对象_toolBar
     */
    function addAll(menuItems) {
        tBar.menuItems.addAll(menuItems);
        return tBar;
    }

    /**
     * toolbar的参数构造器
     * 
     * @param menuItems 菜单项的id数组
     * @returns toolbar的参数数组
     */
    function argsBuilder(toolBarArgs) {
        var _toolbarDefault = fnDefaultArg();
        var _items = new ArrayList();
        var menuItems = tBar.menuItems.toArray();
        // 解析参数，构造参数对象，在构造过程中，对office插件判定判定
        for ( var int1 = 0; int1 < menuItems.length; int1++) {
            // 如果是string类型，则表示存放id，如果是object或者数组类型，表示存放的是构造参数
            var item = menuItems[int1];
            if (typeof (item) === "string") {
                if (_toolbarDefault[item]) {
                    _items.add(_toolbarDefault[item]);
                } else {
                    $.alert("[id=" + item + "] 未在officeToolbar.js中注册！");
                }
            } else if (typeof (item) === "object") {// 处理新建时插件的判定以及其它的规则
                // 第一个属性为父菜单，第二个属性为子菜单值
                for ( var menuName in item) {
                    var childMenu = _toolbarDefault[menuName];
                    if (childMenu) {
                        var aChildMenus = item[menuName];// 子菜单数组
                        if (typeof (aChildMenus) === "object" && (aChildMenus instanceof Array) && aChildMenus.length > 0) {
                            var childMenuArray = new ArrayList();
                            for ( var int2 = 0; int2 < aChildMenus.length; int2++) {
                                var sChildMenuName = aChildMenus[int2];
                                if (_toolbarDefault[sChildMenuName]) {
                                    // 插件判定
                                    if (fnHasPlugin(sChildMenuName)) {
                                        childMenuArray.add(_toolbarDefault[sChildMenuName]);
                                    }
                                } else {
                                    $.alert("[id=" + menuName + "] 未在officeToolbar.js中注册！");
                                }
                            }

                            if (childMenuArray.size() > 0) {
                                childMenu.subMenu = childMenuArray.toArray();
                            }
                        } else {
                            $.alert("子菜单数据格式错误，需要格式为{父菜单id:[子菜单id非空列表]}！");
                        }
                        // 增加subMenu属性
                        _items.add(childMenu);
                    } else {
                        $.alert("[id=" + menuName + "] 未在officeToolbar.js中注册！");
                    }
                }
            } else {// 根据平台规则，自定义参数
                _items.add(item);
            }
        }
        
        var _toolBarArgs = {
            "toolbar" : _items.toArray(),
            "isPager" : false
        };        
        _toolBarArgs = $.extend(true , _toolBarArgs , toolBarArgs);
        return _toolBarArgs;
    }

    function fnDefaultArg() {
        return {
            "new" : {
                id : "new",
                name : $.i18n('office.tbar.new.js'),
                className : "ico16",
                click : function(e) {
                    fnNew(e);
                }
            },
            "reg" : {
              id : "reg",
              name : $.i18n('office.tbar.reg.js'),
              className : "ico16",
              click : function(e) {
                  fnReg(e);
              }
            },
            "edit" : {
                id : "edit",
                name : $.i18n('office.tbar.modify.js'),
                className : "ico16 editor_16",
                click : function(e) {
                    e.id=this.id;
                    fnEdit(e);
                }
            },
            "modify" : {
                id : "modify",
                name : $.i18n('office.tbar.modify.js'),
                className : "ico16 editor_16",
                click : function(e) {
                    e.id=this.id;
                    fnModify(e);
                }
            },
            "del" : {
                id : "del",
                name : $.i18n('office.tbar.delete.js'),
                className : "ico16 del_16",
                click : function(e) {
                    e.id=this.id;
                    fnDel(e);
                }
            },
            "imp2exp" :{
            	id : "imp2exp",
            	name : $.i18n('office.tbar.imp2exp.js'),
            	className : "ico16 import_16",
		            	subMenu :[
		            	          {
		            	        	name: $.i18n('office.tbar.import.js'),
								    click: function() {
								    	fnImp();
								    }
								  },
								  {
								    name: $.i18n('office.tbar.dowloadtemplete.js'),
								    click: function() {
								    	fnDow();
								    }
								  },
								  {
								    name: $.i18n('office.tbar.export.js'),
								    click: function() {
								    	fnExp();
								    }
								  }
            	          ]
            },
            "imp" :{
            	id : "imp",
            	name : $.i18n('office.asset.import.js'),
            	className : "ico16 import_16",
		            	subMenu :[
		            	 {
		            	  name: $.i18n('office.tbar.import.js'),
								    click: function() {
								    	fnImp();
								    }
								  },
								  {
								    name: $.i18n('office.tbar.dowloadtemplete.js'),
								    click: function() {
								    	fnDownLoadTemplate();
								    }
								  }]
            },
            "export" : {
            	id : "export",
            	name : $.i18n('office.tbar.export.js'),
            	className :"ico16 export_excel_16",
            	click : function (){
            		fnExp();
            	}
            },
            "updates" : {
            	id : "updates",
            	name : $.i18n('office.tbar.updates.js'),
            	className :"ico16 batch_edit_16",
            	click : function (){
            		fnUpdates();
            	}
            },
            "revoke" : {
                id : "revoke",
                name : $.i18n('office.tbar.revoke.js'),
                className : "ico16 revoked_process_16",
                click : function(e) {
                    if (typeof (fnRevoke) !== 'undefined') {
                        e.id=this.id;
                        fnRevoke(e);
                    }
                }
            },
            "send" : {
              id : "send",
              name : $.i18n('office.tbar.send.js'),
              className : "ico16 has_been_distributed_16",
              click : function(e) {
                  if (typeof (fnSend) !== 'undefined') {
                      e.id=this.id;
                      fnSend(e);
                  }
              }
            },
	          "dSend" : {
	            id : "dSend",
	            name : $.i18n('office.tbar.dsend.js'),
	            className : "ico16 has_been_distributed_16",
	            click : function(e) {
	                if (typeof (fnDSend) !== 'undefined') {
	                    e.id=this.id;
	                    fnDSend(e);
	                }
	            }
	          },
	          "dLend" : {
	            id : "dLend",
	            name : $.i18n('office.asset.dlend.js'),
	            className : "ico16 has_been_distributed_16",
	            click : function(e) {
	                if (typeof (fnDLend) !== 'undefined') {
	                    e.id=this.id;
	                    fnDLend(e);
	                }
	            }
	          },
	          "out" : {
	            id : "out",
	            name : $.i18n('office.tbar.out.js'),
	            className : "ico16 has_been_distributed_16",
	            click : function(e) {
	                if (typeof (fnOut) !== 'undefined') {
	                    e.id=this.id;
	                    fnOut(e);
	                }
	            }
	          },
	          "recede" : {
	            id : "recede",
	            name : $.i18n('office.tbar.recede.js'),
	            className : "ico16 has_been_distributed_16",
	            click : function(e) {
	                if (typeof (fnRecede) !== 'undefined') {
	                    e.id=this.id;
	                    fnRecede(e);
	                }
	            }
	          },
            "print" : {
                id : "print",
                name : $.i18n('office.tbar.print.js'),
                className : "ico16 print_16",
                click : function(e) {
                    e.id=this.id;
                    fnPrint(e);
                }
            },
            "apply" : {
              id : "apply",
              name : $.i18n('office.tbar.apply.js'),
              className : "ico16",
              click : function(e) {
              	fnApply(e);
              }
          },
          "storage" : {
            id : "storage",
            name : $.i18n('office.tbar.storage.js'),
            className : "ico16",
            click : function(e) {
            	fnStorage(e);
            }
          },
          "recall" : {
            id : "recall",
            name : $.i18n('office.tbar.recall.js'),
            className : "ico16 retrieve_16",
            click : function(e) {
            	fnRecall(e);
            }
          },
          "lend" : {
            id : "lend",
            name : $.i18n('office.tbar.lend.js'),
            className : "ico16",
            click : function(e) {
            	fnLend(e);
            }
          },
          "dolend" : {
              id : "dolend",
              name : $.i18n('office.tbar.dolend.js'),
              className : "ico16 has_been_distributed_16",
              click : function(e) {
              	fnDoLend(e);
              }
            },
          "remind" : {
            id : "remind",
            name : $.i18n('office.tbar.remind.js'),
            className : "ico16 retrieve_16",
            click : function(e) {
            	fnRemind(e);
            }
          },
          "renew":{
              id : "renew",
              name : $.i18n('office.tbar.renew.js'),
              className : "ico16",
              click : function(e) {
              	fnRenew(e);
              }
            },
            "batchApproval":{
              id : "batchApproval",
              name : $.i18n('office.tbar.batchApproval.js'),
              className : "ico16 approval_16",
              click : function() {
                fnBatchApproval();
              }
            },
            "bookBatchReturn":{
              id : "bookBatchReturn",
              name : $.i18n('office.tbar.remind.js'),
              className : "ico16 retrieve_16",
              click : function() {
                fnBookBatchReturn();
              }
            }
        };
    }
    
    return tBar;
}