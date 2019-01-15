;
(function (exportObject) {
    var $ = exportObject.$;
    var openDebug = false;
    
    var cachedData_={
        "data_link":{
            items:[]
        },
        "TemplateNumber":{
            items:[]
        }
    }
    if(window.cachedData){
        cachedData_ = window.cachedData;
    }else if(window.parent&&window.parent.cachedData){
        
         cachedData_ = window.parent.cachedData;
        
    }
    window.cachedData=cachedData_;
     

    var _getList = function (data_type, callback_, error_callback_) {
        var url = "/seeyon/nbd.do?method=getDataList&data_type=" + data_type;
        var mock_url = "http://127.0.0.1:8080/seeyon/nbd/getDataList?data_type=" + data_type;
        if (openDebug) {
            url = mock_url;
        }

        $.ajax({
            url: url,
            async: true, //同步方式发送请求，true为异步发送
            type: "GET",
            dataType: "json",
            success: function (data) {
                if(data_type=="data_link"){
                    console.log("data_link");
                    cachedData["data_link"].items=data.items;
                }
                if (callback_) {
                    callback_(data);
                }
            },
            error: function (res) {
                if (error_callback_) {
                    error_callback_(res);
                }
            }
        })
    }
    var _getById = function (data_type, data_, callback_, error_callback_) {
        var url = "/seeyon/nbd.do?method=getDataById&data_type=" + data_type;
        var mock_url = "http://127.0.0.1:8080/seeyon/nbd/getDataById?data_type=" + data_type;
        if (openDebug) {
            url = mock_url;
        }

        $.ajax({
            url: url,
            async: true, //同步方式发送请求，true为异步发送
            type: "GET",
            data: data_,
            dataType: "json",
            success: function (data) {

                if (callback_) {
                    callback_(data);
                }
            },
            error: function (res) {
                if (error_callback_) {
                    error_callback_(res);
                }
            }
        })
    }
    var _post_data_add = function (data_type, data_post, callback_, error_callback_) {
        var url = "/seeyon/nbd.do?method=postAdd&data_type=" + data_type;
        var mock_url = "http://127.0.0.1:8080/seeyon/nbd/postAdd?data_type=" + data_type;
        if (openDebug) {
            url = mock_url;
        }
        $.ajax({
            url: url,
            async: true, //同步方式发送请求，true为异步发送
            data: data_post,
            type: "POST",
            dataType: "json",
            success: function (data) {

                if (callback_) {
                    callback_(data);
                }
            },
            error: function (res) {
                if (error_callback_) {
                    error_callback_(res);
                }
            }
        })

    }
    var _post_data_update = function (data_type, data_post, callback_, error_callback_) {
        var url = "/seeyon/nbd.do?method=postUpdate&data_type=" + data_type;
        var mock_url = "http://127.0.0.1:8080/seeyon/nbd/postUpdate?data_type=" + data_type;
        if (openDebug) {
            url = mock_url;
        }
        $.ajax({
            url: url,
            async: true, //同步方式发送请求，true为异步发送
            data: data_post,
            type: "POST",
            dataType: "json",
            success: function (data) {
                //console.log(data);
                if (callback_) {
                    callback_(data);
                }
            },
            error: function (res) {
                if (error_callback_) {
                    error_callback_(res);
                }
            }
        })
    }
    var _post_data_delete = function (data_type, data_post, callback_, error_callback_) {
        var url = "/seeyon/nbd.do?method=postDelete&data_type=" + data_type;
        var mock_url = "http://127.0.0.1:8080/seeyon/nbd/postDelete?data_type=" + data_type;
        if (openDebug) {
            url = mock_url;
        }
        $.ajax({
            url: url,
            async: true, //同步方式发送请求，true为异步发送
            data: data_post,
            type: "POST",
            dataType: "json",
            success: function (data) {
                //console.log(data);
                if (callback_) {
                    callback_(data);
                }
            },
            error: function (res) {
                if (error_callback_) {
                    error_callback_(res);
                }
            }
        });
    }
    var Dao = {};
     Dao.transExportType=function(exportType) {
        if ("mid_table" == exportType) {
            return "中间表";
        }
        if ("http" == exportType) {
            return "接口发送";
        }
        if ("custom" == exportType) {
            return "自定义";
        }
        return exportType;
    }

    Dao.transTriggerType=function(exportType) {
        if ("process_start" == exportType) {
            return "流程开始";
        }
        if ("process_end" == exportType) {
            return "流程结束";
        }
        return exportType;
    }
    Dao.transDbType=function(val){

        if (val == 0) {
            return "Mysql";
        }
        if (val == 1) {
            return "Oracle";
        }
        if (val == 2) {
            return "SQLServer";
        }
        return "Unknown"

    }
    Dao.getCacheByKey=function(key){

        return cachedData[key];
    }
    Dao.getLinkName=function(val){
        if(val == null){
            return val;
        }
       var dataLinks =  Dao.getCacheByKey("data_link");
       if(dataLinks.items){
           var label=null;
            for(var p=0;p<dataLinks.items.length;p++){
                var item = dataLinks.items[p];
                if(item.sid==val){
                    label = item.name;
                    break;
                } 
            }
            if(label){
                return label;
            }
            return val;

       }else{
           return val;
       }
    };
    Dao.getList = function (type, callBack, errorCallBack) {
        _getList(type, callBack, errorCallBack);
    }
    Dao.getDataById = function (type, data, callBack, errorCallBack) {
        _getById(type, data, callBack, errorCallBack);
    }
    Dao.add = function (type, data, callBack, errorCallBack) {
        _post_data_add(type, data, callBack, errorCallBack);
    }
    Dao.update = function (type, data, callBack, errorCallBack) {
        _post_data_update(type, data, callBack, errorCallBack);
    }
    Dao.delete = function (type, data, callBack, errorCallBack) {
        _post_data_delete(type, data, callBack, errorCallBack);
    }
    Dao.testConnection = function (data_post, callBack, error_callback_) {
        var url = "/seeyon/nbd.do?method=testConnection";
        var mock_url = "http://127.0.0.1:8080/seeyon/nbd/testConnection";
        if (openDebug) {
            url = mock_url;
        }
        $.ajax({
            url: url,
            async: true, //同步方式发送请求，true为异步发送
            data: data_post,
            type: "POST",
            dataType: "json",
            success: function (data) {

                if (callBack) {
                    callBack(data);
                }
            },
            error: function (res) {
                if (error_callback_) {
                    error_callback_(res);
                }
            }
        });

    }
    Dao.getTemplateNumber = function (data_post, callBack, error_callback_) {
        var url = "/seeyon/nbd.do?method=getTemplateNumber";
        var mock_url = "http://127.0.0.1:8080/seeyon/nbd/getTemplateNumber";
        if (openDebug) {
            url = mock_url;
        }
        $.ajax({
            url: url,
            async: true, //同步方式发送请求，true为异步发送
            data: data_post,
            type: "POST",
            dataType: "json",
            success: function (data) {
                cachedData["TemplateNumber"].items=data.items;
                if (callBack) {
                    callBack(data);
                }
            },
            error: function (res) {
                if (error_callback_) {
                    error_callback_(res);
                }
            }
        });

    }
    Dao.getFormByTemplateNumber = function (data_post, callBack, error_callback_) {
        var url = "/seeyon/nbd.do?method=getFormByTemplateNumber";
        var mock_url = "http://127.0.0.1:8080/seeyon/nbd/getFormByTemplateNumber";
        if (openDebug) {
            url = mock_url;
        }
        $.ajax({
            url: url,
            async: true, //同步方式发送请求，true为异步发送
            data: data_post,
            type: "POST",
            dataType: "json",
            success: function (data) {

                if (callBack) {
                    callBack(data);
                }
            },
            error: function (res) {
                if (error_callback_) {
                    error_callback_(res);
                }
            }
        });
    }
    Dao.dbConsole = function (data_post, callBack, error_callback_) {
        var url = "/seeyon/nbd.do?method=dbConsole";
        var mock_url = "http://127.0.0.1:8080/seeyon/nbd/dbConsole";
        if (openDebug) {
            url = mock_url;
        }
        $.ajax({
            url: url,
            async: true, //同步方式发送请求，true为异步发送
            data: data_post,
            type: "POST",
            dataType: "json",
            success: function (data) {
                console.log(data);
                if (callBack) {
                    callBack(data);
                }
            },
            error: function (res) {
                if (error_callback_) {
                    error_callback_(res);
                }
            }
        });
    }
    exportObject.Dao = Dao;
})(window);