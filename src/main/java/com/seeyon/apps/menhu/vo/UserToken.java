package com.seeyon.apps.menhu.vo;

import java.util.Date;

/**
 * Created by liuwenping on 2019/1/14.
 */
public class UserToken {

    private Long userId;

    private String userLoginName;

    private String userName;

    private Long validDate;
    //有效时间
    private Long period=10*1000L;

    private String token;

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getUserLoginName() {
        return userLoginName;
    }

    public void setUserLoginName(String userLoginName) {
        this.userLoginName = userLoginName;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public Long getValidDate() {
        return validDate;
    }

    public void setValidDate(Long validDate) {
        this.validDate = validDate;
    }

    public Long getPeriod() {
        return period;
    }

    public void setPeriod(Long period) {
        this.period = period;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public boolean isValidToken(){

        long now = new Date().getTime();
        long valid = this.getValidDate();
        if(now>valid){
            return false;
        }else{
            return true;
        }
    }
}
