;
(function (exportObject) {
    var $ = exportObject.$;
    var openDebug = true;

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
                console.log(data);
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
                console.log(data);
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
                console.log(data);
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
                console.log(data);
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
                console.log(data);
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