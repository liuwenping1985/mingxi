(function () {
    lx.use(["jquery"], function () {
        var DB_DAO = {};
        var $ = lx.$;



        var debug_mock = lx.eutil.isMock();
        var prefix_uri = "";
        if (debug_mock) {
            prefix_uri = "http://49.4.122.240";
        }
        function fetchData(url, callback, errorBack) {
            if (debug_mock) {
                url = prefix_uri+url;
            }
            $.get(url, function (data) {
                if (callback) {
                    callback(data);
                }
            }, function (error) {
                if (!errorBack) {
                    errorBack(error);
                }
            });
        }
        DB_DAO.getUrlPrefix=function(){
            return prefix_uri;
        }
        DB_DAO.getUrlByStateAndMode = function (mode, state) {
            var baseUri = "/seeyon/duban.do?method=getRunningDubanTask&mode=";
            if(mode=="watcher"){
                baseUri = "/seeyon/duban.do?method=getWatcherData&state="+state+"&mode=";
            }else{
                if (state == "DONE") {
                    baseUri = "/seeyon/duban.do?method=getFinishedDubanTaskList&mode=";
                } else if (state == "ALL") {
                    baseUri = "/seeyon/duban.do?method=getAllDubanTaskList&mode=";
                }else if(state=="APPROVING"){
                    baseUri = "/seeyon/duban.do?method=getApprovingTaskList&mode=";
                }
            }


            baseUri = prefix_uri + baseUri + mode;
            return baseUri;

        }
        DB_DAO.addLeaderOpinion = function (param, callback,errorCallback) {
            var baseUri = "/seeyon/duban.do?method=addLeaderOpinion";
            baseUri = prefix_uri + baseUri
            $.post(baseUri, param, function (data) {
                if (callback) {
                    callback(data);
                }

            });
        }


        DB_DAO.getLeaderTaskList = function (state, callback) {
            var baseUri = "/seeyon/duban.do?method=getRunningDubanTask&mode=leader";
            if (state == "DONE") {
                baseUri = "/seeyon/duban.do?method=getFinishedDubanTaskList&mode=leader";
            } else if (state == "ALL") {
                baseUri = "/seeyon/duban.do?method=getAllDubanTaskList&mode=leader";
            }
            fetchData(baseUri, callback);
        };
        DB_DAO.getWatcherTaskList = function (state, callback) {
            var baseUri = "/seeyon/duban.do?method=getWatcherData&state="+state;
            fetchData(baseUri, callback);
        };
        DB_DAO.getDubanTaskList = function (state, callback) {
            var baseUri = "/seeyon/duban.do?method=getRunningDubanTask&mode=duban";
            if (state == "DONE") {
                baseUri = "/seeyon/duban.do?method=getFinishedDubanTaskList&mode=duban";
            } else if (state == "ALL") {
                baseUri = "/seeyon/duban.do?method=getAllDubanTaskList&mode=duban";
            }
            fetchData(baseUri, callback);
        };
        DB_DAO.getCengbanbanTaskList = function (state, callback) {
            var baseUri = "/seeyon/duban.do?method=getRunningDubanTask&mode=cengban";
            if (state == "DONE") {
                baseUri = "/seeyon/duban.do?method=getFinishedDubanTaskList&mode=cengban";
            } else if (state == "ALL") {
                baseUri = "/seeyon/duban.do?method=getAllDubanTaskList&mode=cengban";
            }
            fetchData(baseUri, callback);
        };
        DB_DAO.getXiebanTaskList = function (state, callback) {
            var baseUri = "/seeyon/duban.do?method=getRunningDubanTask&mode=xieban";
            if (state == "DONE") {
                baseUri = "/seeyon/duban.do?method=getFinishedDubanTaskList&mode=xieban";
            } else if (state == "ALL") {
                baseUri = "/seeyon/duban.do?method=getAllDubanTaskList&mode=xieban";
            }
            fetchData(baseUri, callback);
        };

        DB_DAO.getDataByModeAndState = function (mode, state, callback) {
            if (mode == "duban") {
                DB_DAO.getDubanTaskList(state, callback);
            } else if (mode == "leader") {
                DB_DAO.getLeaderTaskList(state, callback);
            } else if (mode == "cengban") {
                DB_DAO.getCengbanbanTaskList(state, callback);
            } else if (mode == "xieban") {
                DB_DAO.getXiebanTaskList(state, callback);
            }else if (mode == "watcher") {
                DB_DAO.getWatcherTaskList(state, callback);
            }
        }

        window.DB_DAO = DB_DAO;


    });

})();