package com.seeyon.apps.kdXdtzXc.po;

import com.seeyon.apps.kdXdtzXc.base.ann.XmlField;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 * Created by tap-pcng43 on 2017-8-8.
 * travel allowance
 * 出差补助信息
 */
public class CwTravelAllowance implements Serializable {
    public static String className = CwTravelAllowance.class.getName();
    private Long id;

    @XmlField
    private String SOURCE;//VARCHAR2(150) N 业务来源 ‘OA系统’
    @XmlField
    private String APPL_ORDER_CODE;// VARCHAR2(240) N 申请单编号

    @XmlField
    private String APPL_USER_CODE;// VARCHAR2(100) N 申请人 编码
    @XmlField
    private String EMPLOYEE_CODE;//VARCHAR2(100) N 出差人 编码
    @XmlField
    private String COM_CODE;//VARCHAR2(150) N 机构编码

    @XmlField
    private String DEPT_CODE; //VARCHAR2(150) N 部门编码

    @XmlField
    private String COST_CENTER;// VARCHAR2(150) N 成本中心 即受益部门编码
    @XmlField
    private String PROJECT_CODE;// VARCHAR2(150) N 项目编码

    @XmlField
    private String DATE_FROM;// VARCHAR2(150) N 出差日期自 YYYY-MM-DD
    @XmlField
    private String DATE_TO; //VARCHAR2(150) N 出差日期至 YYYY-MM-DD
    @XmlField
    private String LEAVE_NUM; //VARCHAR2(50) N 出差天数

    @XmlField
    private String ALLOW_NUM; //VARCHAR2(50) N 补贴天数

    @XmlField
    private String NON_ALLOW_NUM; //VARCHAR2(50) N 非补贴天数

    @XmlField
    private String LEAVE_SITE; //VARCHAR2(100) N 出差地点

    @XmlField
    private String LOCATION_TYPE; //VARCHAR2(50) N 出差地区类型 A、B、C 三种类型
    @XmlField
    private String CURRENCY; //VARCHAR2(50) N 币种 CNY；USD;
    @XmlField
    private String DS_FLAG;// VARCHAR2(50) N 董监事标识 Y(yes); N(no)
    @XmlField
    private String OA_KEY; //VARCHAR2(240) N OA主键 申请单编号+出差人员编码+地区类型
    @XmlField
    private String STATUS;// VARCHAR2(20) Y 状态 返回每条记录是否成功  Y(yes);N(no)
    @XmlField
    private String ERR_MSG;// VARCHAR2(240) Y 错误消息 返回每条错误记录的消息

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getSOURCE() {
        return SOURCE;
    }

    public void setSOURCE(String SOURCE) {
        this.SOURCE = SOURCE;
    }

    public String getAPPL_ORDER_CODE() {
        return APPL_ORDER_CODE;
    }

    public void setAPPL_ORDER_CODE(String APPL_ORDER_CODE) {
        this.APPL_ORDER_CODE = APPL_ORDER_CODE;
    }

    public String getAPPL_USER_CODE() {
        return APPL_USER_CODE;
    }

    public void setAPPL_USER_CODE(String APPL_USER_CODE) {
        this.APPL_USER_CODE = APPL_USER_CODE;
    }

    public String getEMPLOYEE_CODE() {
        return EMPLOYEE_CODE;
    }

    public void setEMPLOYEE_CODE(String EMPLOYEE_CODE) {
        this.EMPLOYEE_CODE = EMPLOYEE_CODE;
    }

    public String getCOM_CODE() {
        return COM_CODE;
    }

    public void setCOM_CODE(String COM_CODE) {
        this.COM_CODE = COM_CODE;
    }

    public String getDEPT_CODE() {
        return DEPT_CODE;
    }

    public void setDEPT_CODE(String DEPT_CODE) {
        this.DEPT_CODE = DEPT_CODE;
    }

    public String getCOST_CENTER() {
        return COST_CENTER;
    }

    public void setCOST_CENTER(String COST_CENTER) {
        this.COST_CENTER = COST_CENTER;
    }

    public String getPROJECT_CODE() {
        return PROJECT_CODE;
    }

    public void setPROJECT_CODE(String PROJECT_CODE) {
        this.PROJECT_CODE = PROJECT_CODE;
    }

    public String getDATE_FROM() {
        return DATE_FROM;
    }

    public void setDATE_FROM(String DATE_FROM) {
        this.DATE_FROM = DATE_FROM;
    }

    public String getDATE_TO() {
        return DATE_TO;
    }

    public void setDATE_TO(String DATE_TO) {
        this.DATE_TO = DATE_TO;
    }

    public String getLEAVE_NUM() {
        return LEAVE_NUM;
    }

    public void setLEAVE_NUM(String LEAVE_NUM) {
        this.LEAVE_NUM = LEAVE_NUM;
    }

    public String getALLOW_NUM() {
        return ALLOW_NUM;
    }

    public void setALLOW_NUM(String ALLOW_NUM) {
        this.ALLOW_NUM = ALLOW_NUM;
    }

    public String getNON_ALLOW_NUM() {
        return NON_ALLOW_NUM;
    }

    public void setNON_ALLOW_NUM(String NON_ALLOW_NUM) {
        this.NON_ALLOW_NUM = NON_ALLOW_NUM;
    }

    public String getLEAVE_SITE() {
        return LEAVE_SITE;
    }

    public void setLEAVE_SITE(String LEAVE_SITE) {
        this.LEAVE_SITE = LEAVE_SITE;
    }

    public String getLOCATION_TYPE() {
        return LOCATION_TYPE;
    }

    public void setLOCATION_TYPE(String LOCATION_TYPE) {
        this.LOCATION_TYPE = LOCATION_TYPE;
    }

    public String getCURRENCY() {
        return CURRENCY;
    }

    public void setCURRENCY(String CURRENCY) {
        this.CURRENCY = CURRENCY;
    }

    public String getDS_FLAG() {
        return DS_FLAG;
    }

    public void setDS_FLAG(String DS_FLAG) {
        this.DS_FLAG = DS_FLAG;
    }

    public String getOA_KEY() {
        return OA_KEY;
    }

    public void setOA_KEY(String OA_KEY) {
        this.OA_KEY = OA_KEY;
    }

    public String getSTATUS() {
        return STATUS;
    }

    public void setSTATUS(String STATUS) {
        this.STATUS = STATUS;
    }

    public String getERR_MSG() {
        return ERR_MSG;
    }

    public void setERR_MSG(String ERR_MSG) {
        this.ERR_MSG = ERR_MSG;
    }


}
