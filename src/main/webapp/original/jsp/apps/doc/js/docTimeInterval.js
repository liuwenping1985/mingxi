/**
 *  计算给定时间到当前时间的时间间隔
 *  @param strDate 日期时间格式字符串 格式如：(2012/09/19 or 2012-09-19)[ (18:25:35 or 18:25)]
 *  @returns 返回距离当前时间间隔,对于无法解析的格式原样返回
 */
function fnEvalTimeInterval(strDate) {
    var strDateFormat = strDate.replace('-', '/');
    var myDate = new Date(strDateFormat);
    if(isNaN(myDate)) {
        return strDate;
    }
    var timeInterval = new Date().getTime() - myDate.getTime();
    var seconds = timeInterval / 1000;
    if (seconds < 0) {
        return strDate;
    }  else {
        var strInterval = '';
        if (seconds < 60) {
            strInterval = Math.floor(seconds) + "${ctp:i18n('doc.createtime.seconds')}";
        }  else {
            var minus = seconds/60;
            if(minus < 60) {
                strInterval = Math.floor(minus) + "${ctp:i18n('doc.createtime.minutes')}";
            } else {
                var hours = minus/60;
                if (hours < 24) {
                    strInterval = Math.floor(hours) + "${ctp:i18n('doc.createtime.hours')}";
                } else {
                    var days = hours/24;
                    if (days < 30) {
                        strInterval = Math.floor(days) + "${ctp:i18n('doc.createtime.days')}";
                    } else {
                        var months = days/30;
                        if (months < 12) {
                            strInterval = Math.floor(months) + "${ctp:i18n('doc.createtime.months')}";
                        } else {
                            var years = months / 12;
                            strInterval = Math.floor(years) + "${ctp:i18n('doc.createtime.years')}";
                        }
                    }
                }
            }
        }
        return strInterval + "${ctp:i18n('doc.createtime.forward')}";
    }
}