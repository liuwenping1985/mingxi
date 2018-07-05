package com.seeyon.apps.jixiao.po;

import java.util.Date;

public class Formmain0651 {
    /**
     * `ID` bigint(20) NOT NULL,
     *   `state` int(11) DEFAULT NULL,
     *   `start_member_id` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
     *   `start_date` datetime DEFAULT NULL,
     *   `approve_member_id` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
     *   `approve_date` datetime DEFAULT NULL,
     *   `finishedflag` int(11) DEFAULT NULL,
     *   `ratifyflag` int(11) DEFAULT NULL,
     *   `ratify_member_id` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
     *   `ratify_date` datetime DEFAULT NULL,
     *   `sort` int(11) DEFAULT NULL,
     *   `modify_member_id` varchar(25) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
     *   `modify_date` datetime DEFAULT NULL,
     *   `field0001` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
     *   `field0002` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
     *   `field0003` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
     *   `field0004` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
     *   `field0005` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
     *   `field0006` decimal(20, 4) DEFAULT NULL,
     *   `field0007` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
     *   `field0008` date DEFAULT NULL,
     *   `field0017` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
     *   `field0018` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
     *   `field0019` decimal(20, 4) DEFAULT NULL,
     *   `field0022` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
     *   `field0023` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
     *   `field0024` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
     *   `field0026` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
     *   `field0027` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
     */
    private static String TABLENAME="formmain_0651";
    private Long id;
    private Integer state;
    private String startMemberId;
    private Date startDate;
    private String approveMemberId;
    private Date approveDate;
    private Integer finishedFlag;
    private Integer ratifyFlag;
    private String ratifyMemberId;
    private Date ratifyDate;
    private Integer sort;
    private String modifyMemberId;
    private Date modifyDate;
    //考核周期
    private String field0001;
    //备考评人
    private String field0002;
    private String field0003;
    private String field0004;
    private String field0005;
    //考评成绩
    private Float field0006;
    //考评等级
    private String field0007;
    private Date field0008;
    //等级
    private String field0017;
    private String field0018;
    private Float field0019;
    private String field0022;
    private String field0023;
    private String field0024;
    private String field0026;
    private String field0027;



    public static String getTABLENAME() {
        return TABLENAME;
    }

    public static void setTABLENAME(String TABLENAME) {
        Formmain0651.TABLENAME = TABLENAME;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Integer getState() {
        return state;
    }

    public void setState(Integer state) {
        this.state = state;
    }

    public String getStartMemberId() {
        return startMemberId;
    }

    public void setStartMemberId(String startMemberId) {
        this.startMemberId = startMemberId;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public String getApproveMemberId() {
        return approveMemberId;
    }

    public void setApproveMemberId(String approveMemberId) {
        this.approveMemberId = approveMemberId;
    }

    public Date getApproveDate() {
        return approveDate;
    }

    public void setApproveDate(Date approveDate) {
        this.approveDate = approveDate;
    }

    public Integer getFinishedFlag() {
        return finishedFlag;
    }

    public void setFinishedFlag(Integer finishedFlag) {
        this.finishedFlag = finishedFlag;
    }

    public Integer getRatifyFlag() {
        return ratifyFlag;
    }

    public void setRatifyFlag(Integer ratifyFlag) {
        this.ratifyFlag = ratifyFlag;
    }

    public String getRatifyMemberId() {
        return ratifyMemberId;
    }

    public void setRatifyMemberId(String ratifyMemberId) {
        this.ratifyMemberId = ratifyMemberId;
    }

    public Date getRatifyDate() {
        return ratifyDate;
    }

    public void setRatifyDate(Date ratifyDate) {
        this.ratifyDate = ratifyDate;
    }

    public Integer getSort() {
        return sort;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }

    public String getModifyMemberId() {
        return modifyMemberId;
    }

    public void setModifyMemberId(String modifyMemberId) {
        this.modifyMemberId = modifyMemberId;
    }

    public Date getModifyDate() {
        return modifyDate;
    }

    public void setModifyDate(Date modifyDate) {
        this.modifyDate = modifyDate;
    }

    public String getField0001() {
        return field0001;
    }

    public void setField0001(String field0001) {
        this.field0001 = field0001;
    }

    public String getField0002() {
        return field0002;
    }

    public void setField0002(String field0002) {
        this.field0002 = field0002;
    }

    public String getField0003() {
        return field0003;
    }

    public void setField0003(String field0003) {
        this.field0003 = field0003;
    }

    public String getField0004() {
        return field0004;
    }

    public void setField0004(String field0004) {
        this.field0004 = field0004;
    }

    public String getField0005() {
        return field0005;
    }

    public void setField0005(String field0005) {
        this.field0005 = field0005;
    }

    public Float getField0006() {
        return field0006;
    }

    public void setField0006(Float field0006) {
        this.field0006 = field0006;
    }

    public String getField0007() {
        return field0007;
    }

    public void setField0007(String field0007) {
        this.field0007 = field0007;
    }

    public Date getField0008() {
        return field0008;
    }

    public void setField0008(Date field0008) {
        this.field0008 = field0008;
    }

    public String getField0017() {
        return field0017;
    }

    public void setField0017(String field0017) {
        this.field0017 = field0017;
    }

    public String getField0018() {
        return field0018;
    }

    public void setField0018(String field0018) {
        this.field0018 = field0018;
    }

    public Float getField0019() {
        return field0019;
    }

    public void setField0019(Float field0019) {
        this.field0019 = field0019;
    }

    public String getField0022() {
        return field0022;
    }

    public void setField0022(String field0022) {
        this.field0022 = field0022;
    }

    public String getField0023() {
        return field0023;
    }

    public void setField0023(String field0023) {
        this.field0023 = field0023;
    }

    public String getField0024() {
        return field0024;
    }

    public void setField0024(String field0024) {
        this.field0024 = field0024;
    }

    public String getField0026() {
        return field0026;
    }

    public void setField0026(String field0026) {
        this.field0026 = field0026;
    }

    public String getField0027() {
        return field0027;
    }

    public void setField0027(String field0027) {
        this.field0027 = field0027;
    }
}
