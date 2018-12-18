package com.seeyon.apps.nbd.po;

import java.util.Date;

/**
 * `id` bigint(20) NOT NULL,
 `user_name` varchar(255) DEFAULT NULL,
 `user_id` bigint(20) DEFAULT NULL,
 `location` varchar(512) DEFAULT NULL,
 `reason` varchar(512) DEFAULT NULL,
 `start_date` datetime DEFAULT NULL,
 `end_date` datetime DEFAULT NULL,
 `create_time` datetime DEFAULT NULL,
 `update_time` datetime DEFAULT NULL,
 `status` smallint(6) DEFAULT '0'
 * Created by liuwenping on 2018/12/18.
 */
public class ZrzxUserSchedule extends CommonPo{

    private Long userId;
    private String userName;
    private String location;
    private String reason;
    //0 normal 1 leader 2 s-leader
    private Date startDate;
    private Date endDate;
    private String extString1;
    private String extString2;
    private String extString3;

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getExtString1() {
        return extString1;
    }

    public void setExtString1(String extString1) {
        this.extString1 = extString1;
    }

    public String getExtString2() {
        return extString2;
    }

    public void setExtString2(String extString2) {
        this.extString2 = extString2;
    }

    public String getExtString3() {
        return extString3;
    }

    public void setExtString3(String extString3) {
        this.extString3 = extString3;
    }



}
