/**
 *  根据平均分返回文档的对应的星级class属性值
 *  @param avgScore 文档平均分[Constants.SCORE_MIN=0,Constants.SCORE_MAX=5]
 *  @returns 返回文档的对应的星级class属性值
 */
function fnGetStarLevelClass(avgScore) {
    // 如果传入平均分不是有效数字
    if(avgScore == null || isNaN(avgScore)) {
        return 'stars0';
    }
    // 如果平均分范围无效
    var avg = parseFloat(avgScore);
    if(avg > 5 || avg < 0) {
        return 'stars0';
    }
    var levelClass = 'stars';
    var stars_count = avg;
    var floatPart = stars_count - parseInt(stars_count);
    if(floatPart < 0.25) {
        levelClass += parseInt(stars_count);
    } else if(floatPart > 0.75) {
        levelClass += parseInt(stars_count) + 1;
    } else {
        levelClass += parseInt(stars_count).toString() + '_5';
    }
    return levelClass;
}