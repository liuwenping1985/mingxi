;
(function (exportObject) {
    var $ = exportObject.$;


    var _getList = function (data_type, callback_,error_callback_) {
        var url = "/seeyon/nbd.do?method=getDataList&data_type=" + data_type;
        $.get(url, function (data) {
            if (callback_) {
                callback_(data);
            }
        },function(res){
            if (error_callback_){
                error_callback_(res);
            }
            
        });
    }
    var _post_data_add = function (data_type, data_post, callback_, error_callback_) {
        var url = "/seeyon/nbd.do?method=postAdd&data_type=" + data_type;
        $.post(url,data_post,function(ret){
            if (callback_){
                callback_(ret);
            }
        },function(res){
            if (error_callback_){
                error_callback_(res);
            }
        })
    }
     var _post_data_update = function (data_type, data_post, callback_, error_callback_) {
         var url = "/seeyon/nbd.do?method=postUpdate&data_type=" + data_type;
         $.post(url, data_post, function (ret) {
             if (callback_) {
                 callback_(ret);
             }
         }, function (res) {
             if (error_callback_) {
                 error_callback_(res);
             }
         })
     }
     var _post_data_delete = function (data_type, data_post, callback_, error_callback_) {
         var url = "/seeyon/nbd.do?method=postDelete&data_type=" + data_type;
         $.post(url, data_post, function (ret) {
             if (callback_) {
                 callback_(ret);
             }
         }, function (res) {
             if (error_callback_) {
                 error_callback_(res);
             }
         })
     }
    var Dao = {};
    Dao.getList = function(type,callBack,errorCallBack){
        _getList(type, callBack, errorCallBack);
    }
    Dao.add = function (type, data, callBack, errorCallBack) {
        _post_data_add(type, data,callBack, errorCallBack);
    }
    Dao.update = function (type, data, callBack, errorCallBack) {
        _post_data_update(type, callBack);
    }
    Dao.delete = function (type, data, callBack, errorCallBack) {
        _post_data_delete(type, callBack);
    }
    exportObject.Dao = Dao;
})(window);