/**
 * 对Tab的构造参数的封装,一个页面只能创建一个Grid
 */
function officeTab() {
    var _officeTab = {
        "init" : init,
        "addAll" : addAll,
        "addRow" : addRow,// 增加一行到指定位置
        "selectRows" : selectRows,// 选中的行
        "selectRowIds" : selectRowIds,// 选中的行的id
        "reLoad" : reLoad,// 手动加载数据
        "load" : load,// 根据参数到[后台]加载数据
        "reSize" : reSize,// resizeGridUpDown 参数为u，m，d或者up，middle，down
        "showCol" : showCol,// 显示、隐藏某列
        "hideCol" : hideCol,// 显示、隐藏某列
        "toggleCol" : toggleCol,// 显示、隐藏某列
        "disableRow" : disableRow,// 禁用某行
        "enableRow" : enableRow,// 开启某行
        "removeRow" : removeRow,// 删除指定行,参数为制定行id
        "indexOf" : indexOf,// 查找某个属性对应的值的数据在所在索引
        "moveRow" : moveRow,// 移动某行
        "moveFirst" : moveFirst,// 移动到第一行
        "moveEnd" : moveEnd,// 移动末尾行
        "datas" : fnDatas,// Tab数据
        "getData" : fnGetData,// 根据行号获取数据
        "items" : new ArrayList(),
        "tab" : null,// 平台gird对象
        "$tab" : null,// jquery table 对象
        "id" : null// 初始化时的Tab的id
    };

    /**
     * 根据菜单id生成Grid对象，并对插件的存在性做了统一判定；
     * @param id toolbar的div的id
     */
    function init(id, options) {
        _officeTab.items.addAll(options.items);
        var oArgs = argsBuilder(options);
        _officeTab.id = id;
        _officeTab.$grid = $("#" + id);
        _officeTab.grid = _officeTab.$grid.ajaxgrid(oArgs);
        // 注册右键菜单
        return _officeTab;
    }

    function addAll(options) {
        _officeTab.items.addAll(options);
        return _officeTab;
    }

    /**
     * 根据参数到后台查询数据
     * 
     * @param param
     */
    function load(param) {
        _officeTab.$grid.ajaxgridLoad(param);
        return _officeTab;
    }

    /**
     * o 手工加载数据，objs结构为{ rows : [], page : 0, total : 0 }
     */
    function reLoad(args) {
        _officeTab.$grid.ajaxgridData(args);
        return _officeTab;
    }

    /**
     * 0返回一个数组
     */
    function selectRows() {
        return _officeTab.grid.grid.getSelectRows();
    }

    /**
     * 0获取选中行的id列表
     */
    function selectRowIds() {
        var rows = selectRows();
        var ids = [];
        for ( var i = 0; i < rows.length; i++) {
            ids.push(rows[i]['id']);
        }
        return ids;
    }

    /**
     * o设置高度，宽度
     * 
     * @param position 例如：'up','middle','down' 或者u,m,d
     */
    function reSize(position) {
        var _position = [ 'up', 'middle', 'down' ];
        var _p = [ 'u', 'm', 'd' ];
        if(position){
        	switch (position.toLowerCase()) {
            case _position[0]:
            case _p[0]:
                _officeTab.grid.grid.resizeGridUpDown(_position[0]);
                return _officeTab;
            case _position[1]:
            case _p[1]:
                _officeTab.grid.grid.resizeGridUpDown(_position[1]);
                return _officeTab;
            case _position[2]:
            case _p[2]:
                _officeTab.grid.grid.resizeGridUpDown(_position[2]);
                return _officeTab;
        }
      }
      // 默认重置table所占区域大小
      _officeTab.grid.grid.resizeGridAuto();
      return _officeTab;
    }

    /**
     * o 设置显示列
     * 
     * @param 数组或数字
     */
    function showCol(cols) {
        return toggleCol(cols, true);
    }

    function hideCol(cols) {
        return toggleCol(cols, false);
    }

    function toggleCol(cols, isShow) {
        if (cols!=null) {
            if ($.isArray(cols)) {
                for ( var i = 0; i < cols.length; i++) {
                    _officeTab.grid.grid.toggleCol(cols[i], isShow);
                }
            } else if ($.isNumeric(cols)) {
                _officeTab.grid.grid.toggleCol(cols, isShow);
            }
            return _officeTab;
        }else{
        	 $.alert("officeTab.showCol(cols)参数无效！");
        }
    }

    /**
     * o 禁用选中
     */
    function disableRow(rowId) {
        var tr = _officeTab.$grid.find("tr[id=row" + rowId + "]");
        tr.find(":checkbox").attr("disabled", "disabled");
        tr.find(":radio").attr("disabled", "disabled");
        return _officeTab;
    }

    /**
     * o 开启选中
     */
    function enableRow(rowId) {
        var tr = _officeTab.$grid.find("tr[id=row" + rowId + "]");
        tr.find(":checkbox").removeAttr("disabled");
        return _officeTab;
    }

    /**
     * 0获取行数据
     * 
     * @param row 行,不传获取全部数据
     * @param col 列，可以是数字，第几列，也可以是列名称
     */
    function fnGetData(row) {
        var rows = fnDatas().rows;
        if (row && row >= 0 && row < rows.length) {
            return rows[row];
        } else {
            return rows;
        }
    }

    /**
     * 0获取行索引
     * 
     * @param attr 属性名,默认为id,或者为选中的行的数据row
     * @param value 在结果中查找值
     * @returns 行号,找不到为-1;
     */
    function indexOf(attr, value) {
        var data = fnGetData();
        for ( var i = 0; i < data.length; i++) {
            var s = data[i];
            if (s === attr) {
                return i;
            } else if (attr != null && s != null && value != null && s[attr] == value) {
                return i;
            } else if (s != null && attr != null && s['id'] == attr) {
                return i;
            }
        }
        return -1;
    }

    /**
     * o 获取表格中的数据所有数据
     * 
     * @returns
     */
    function fnDatas() {
        return _officeTab.grid.p.datas;
    }

    /**
     * 0向grid追加一行数据
     * 
     * @param row 数据
     * @param index 位置
     * @param isAppend 是否是追加，false为替换，默认为追加
     */
    function addRow(row, index, isAppend) {
        var data = fnDatas();
        var list = new ArrayList();
        list.addAll(data.rows);
        if (!$.isNumeric(index)) {
            index = 0;
        }

        if (index >= list.size()) {
            index = list.size() - 1;
        }

        if (isAppend) {
            if (index === 0) {
                var list2 = new ArrayList();
                list2.add(row);
                list2.addList(list);
                list = list2;
            } else if ((index + 1) === list.size()) {
                list.add(row);
            } else {
                var list2 = new ArrayList();
                list2.addList(list.subList(0, index));
                list2.add(row);
                list2.addList(list.subList(index, list.size()));
                list = list2;
            }
            // 没更新条数
            // data.dataCount += 1;
        } else {
            list.set(index, row);
        }

        data.rows = list.toArray();
        _officeTab.reLoad(data);
        return _officeTab;
    }

    /**
     * 0删除指定行
     */
    function removeRow(rowId) {
        var index = indexOf(rowId);
		    var rows = _officeTab.grid.p.datas.rows, _rows = [],rowsIndex = 0;
		    
        for ( var i = 0; i < rows.length; i++) {
					if(i == index){
						continue;
					}
					_rows[rowsIndex++] = rows[i];
				}
        var data = _officeTab.grid.p.datas;
        
        if(data.dataCount){
        	
			   	data.dataCount -= 1;
        }
        
        data.rows = _rows;
        
        _officeTab.reLoad(data);
        return _officeTab;
    }

    /**
     * 0 移动到第一行
     * @param rowId 当前行的id
     * @param rowId2 目标rowId
     */
    function moveFirst(rowId) {
        var $grid = _officeTab.$grid;
        var curRow = $grid.find("tr[id=row" + rowId + "]");
        var targetRow = $grid.find("tr[id^=row]:first");
        // 当自己是最后一行时，不移动
        if (targetRow.attr("id") !== ("row" + rowId)) {
            curRow.insertBefore(targetRow);
        }
    }

    /**
     * 0 移动到末尾
     * 
     * @param rowId 当前行的id
     * @param rowId2 目标rowId
     */
    function moveEnd(rowId) {
        var $grid = _officeTab.$grid;
        var curRow = $grid.find("tr[id=row" + rowId + "]");
        var targetRow = $grid.find("tr[id^=row]:last");
        // 当自己是最后一行时，不移动
        if (targetRow.attr("id") !== ("row" + rowId)) {
            curRow.insertAfter(targetRow);
        }
    }

    /**
     * 0移动到指定行之前
     * 
     * @param curRowId 当前行的id
     * @param targetRowId 目标rowId
     */
    function moveRow(curRowId, targetRowId) {
        var $grid = _officeTab.$grid;
        var curRow = $grid.find("tr[id=row" + curRowId + "]");
        var targetRow = $grid.find("tr[id=row" + targetRowId + "]");
        curRow.insertAfter(targetRow);
    }

    /**
     * 私有函数，仅内部使用 grid列名参数构造器
     * 
     * @param options 菜单项的id数组,包括自定义列{argFunc:"officeCenter",items:[],managerName:null,managerMethod:null}
     *            以及平台规定的参数，需要覆盖的参数列表
     * @returns toolbar的参数数组
     */
    // 提供简单的参数封装
    function argsBuilder(options) {
        var gridHearderArgs = {};
        if(options.argFunc){
            gridHearderArgs = eval(options.argFunc+"()");
        }else{
            $.alert('该页面未注册，请officeTab.js中注册！');
            return;
        }
        
        var items = new ArrayList();
        var colItems = _officeTab.items.toArray();
        // 解析参数，构造参数对象，在构造过程中，对office插件判定判定
        for ( var i = 0; i < colItems.length; i++) {// 显示列列表
            // 如果是string类型，则表示存放id，如果是object或者数组类型，表示存放的是构造参数
            var item = colItems[i];
            if ($.type(item) === "string") {
                if (gridHearderArgs[item]) {
                    items.add(gridHearderArgs[item]);
                } else {
                    $.alert("[id=" + item + "] 未在officeTab.js中注册！");
                }
            } else if ($.isPlainObject(item)) {// 根据平台规则，自定义参数，直接追加
                items.add(item);
            }
        }

        var defaultSet = {
            "vresize" : false,
            "isHaveIframe" : true,
            "usepager" : true,// 是有翻页条
            "showTableToggleBtn" : false,
            "vChange" : true,
            "slideToggleBtn" : false,// 上下伸缩按钮是否显示
            "parentId" : "staticBodyDiv",// grid占据div空间的id
            "resizable" : false,// 明细页面的分隔条
            "click" : _fnTabClk,
            "dblclick" : _fnTabDBClk,
            "managerName" : null,
            "managerMethod" : null,
            "customize":false,//表格无故消失的问题
            "render" : _fnTabRender,
            "vChangeParam" : {
                overflow : "hidden",
                autoResize : true
            }
        };

        var settings = $.extend(true, defaultSet, options);
        settings.colModel = items.toArray();
        return settings;
    }

    return _officeTab;
}

/**
 * 处理双击变三次单击的问题
 */
_officeTabIsDBClk = false;

function _fnTabClk(rowData, rowIndex, colIndex, id) {
    _officeTabIsDBClk = false;
    window.setTimeout(cc, 200);
    function cc() {
        if (_officeTabIsDBClk) {
            return;
        }
        if (typeof (fnTabClk) !== 'undefined') {
            fnTabClk(rowData, rowIndex, colIndex, id);
        }
    }
}

/**
 * 处理双击变三次单击的问题
 */
function _fnTabDBClk(rowData, rowIndex, colIndex, id) {
    _officeTabIsDBClk = true;
    if (typeof (fnTabDBClk) !== 'undefined') {
        fnTabDBClk(rowData, rowIndex, colIndex, id);
    }
}

/**
 * 列Render
 */
function _fnTabRender(text, row, rowIndex, colIndex, col) {
    var _text = (text == null) ? "" : text;
    if(col.name == 'recordDate'){
        _text = (text == null) ? "" : text.substr(0, 10);
    }
    return "<span class='grid_black'>"+_text+"</span>";
}
