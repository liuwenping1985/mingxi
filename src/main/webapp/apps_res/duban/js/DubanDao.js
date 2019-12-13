(function () {
    lx.use(["jquery"],function(){
        var DB_DAO = {};
        var $ = lx.$;

        function fetchData(url, callback) {
            $.get(url, function (data) {
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
            }
        }

        window.DB_DAO = DB_DAO;



    });

})();