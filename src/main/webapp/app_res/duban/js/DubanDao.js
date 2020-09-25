(function () {
    lx.use(["jquery"], function () {
        var DB_DAO = {};
        var $ = lx.$;

        function fetchData(url, callback, errorBack) {
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

        var debug_mock = true;
        var prefix_uri = "";
        if (debug_mock) {
            prefix_uri = "http://49.4.122.240";
        }
        var mock_urls = {
            duban: "duban.json",
            normal: "leader.json"
        }
        DB_DAO.getUrlByStateAndMode = function (mode, state) {
            var baseUri = "/seeyon/duban.do?method=getRunningDubanTask&mode=";
            if (state == "DONE") {
                baseUri = "/seeyon/duban.do?method=getFinishedDubanTaskList&mode=";
            } else if (state == "ALL") {
                baseUri = "/seeyon/duban.do?method=getAllDubanTaskList&mode=";
            }

            baseUri = prefix_uri + baseUri + mode;
            return baseUri;

        }
        DB_DAO.addLeaderOpinion = function (param, callback) {
            var baseUri = "/seeyon/duban.do?method=addLeaderOpinion";
            baseUri = prefix_uri + baseUri
            $.post(baseUri, param, function (data) {
                if (callback) {
                    callback(data);
                }

            })
        }


        DB_DAO.getLeaderTaskList = function (state, callback) {
            var baseUri = "/seeyon/duban.do?method=getRunningDubanTask&mode=leader";
            if (state == "DONE") {
                baseUri = "/seeyon/duban.do?method=getFinishedDubanTaskList&mode=leader";
            } else if (state == "ALL") {
                baseUri = "/seeyon/duban.do?method=getAllDubanTaskList&mode=leader";
            }
            if (debug_mock) {
                baseUri = mock_urls.normal;
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
            if (debug_mock) {
                baseUri = mock_urls.duban;
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
            if (debug_mock) {
                baseUri = mock_urls.duban;
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
            if (debug_mock) {
                baseUri = mock_urls.duban;
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