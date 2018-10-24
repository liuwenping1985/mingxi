package com.seeyon.apps.menhu.vo;

import java.sql.Timestamp;
import java.util.Date;

/**
 * Created by liuwenping on 2018/10/24.
 */
public class NewsVo extends BulsVo{

    private Date createDate;
    private boolean imgNews;
    private boolean focusNews;
    private String imgUrl;

    public boolean isFocusNews() {
        return focusNews;
    }

    public void setFocusNews(boolean focusNews) {
        this.focusNews = focusNews;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public boolean isImgNews() {
        return imgNews;
    }

    public void setImgNews(boolean imgNews) {
        this.imgNews = imgNews;
    }

    public String getImgUrl() {
        return imgUrl;
    }

    public void setImgUrl(String imgUrl) {
        this.imgUrl = imgUrl;
    }
}
