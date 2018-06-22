package com.seeyon.apps.datakit.vo;

import com.seeyon.ctp.organization.bo.V3xOrgMember;

public class RikazeMemberVo {


    private String departmentId;
    private String memberId;
    private String memberName;
    private String avtar;
    private V3xOrgMember v3xOrgMember;


    public String getAvtar() {
        return avtar;
    }

    public void setAvtar(String avtar) {
        this.avtar = avtar;
    }


    public String getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(String departmentId) {
        this.departmentId = departmentId;
    }

    public String getMemberId() {
        return memberId;
    }

    public void setMemberId(String memberId) {
        this.memberId = memberId;
    }

    public String getMemberName() {
        return memberName;
    }

    public void setMemberName(String memberName) {
        this.memberName = memberName;
    }

    public V3xOrgMember getV3xOrgMember() {
        return v3xOrgMember;
    }

    public void setV3xOrgMember(V3xOrgMember v3xOrgMember) {
        this.v3xOrgMember = v3xOrgMember;
    }
}
