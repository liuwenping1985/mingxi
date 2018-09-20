package com.seeyon.apps.nbd.po;

import javax.persistence.*;
import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Created by liuwenping on 2018/9/18.
 */
@Entity
@Table(name = "addressbook", schema = "v61sp22", catalog = "")
public class AddressbookEntity {
    private long id;
    private Long memberId;
    private Timestamp createDate;
    private Timestamp updateDate;
    private String extAttr1;
    private String extAttr2;
    private String extAttr3;
    private String extAttr4;
    private String extAttr5;
    private String extAttr6;
    private String extAttr7;
    private String extAttr8;
    private String extAttr9;
    private String extAttr10;
    private BigDecimal extAttr11;
    private BigDecimal extAttr12;
    private BigDecimal extAttr13;
    private BigDecimal extAttr14;
    private BigDecimal extAttr15;
    private BigDecimal extAttr16;
    private BigDecimal extAttr17;
    private BigDecimal extAttr18;
    private BigDecimal extAttr19;
    private BigDecimal extAttr20;
    private Timestamp extAttr21;
    private Timestamp extAttr22;
    private Timestamp extAttr23;
    private Timestamp extAttr24;
    private Timestamp extAttr25;
    private Timestamp extAttr26;
    private Timestamp extAttr27;
    private Timestamp extAttr28;
    private Timestamp extAttr29;
    private Timestamp extAttr30;

    @Id
    @Column(name = "ID")
    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    @Basic
    @Column(name = "MEMBER_ID")
    public Long getMemberId() {
        return memberId;
    }

    public void setMemberId(Long memberId) {
        this.memberId = memberId;
    }

    @Basic
    @Column(name = "CREATE_DATE")
    public Timestamp getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Timestamp createDate) {
        this.createDate = createDate;
    }

    @Basic
    @Column(name = "UPDATE_DATE")
    public Timestamp getUpdateDate() {
        return updateDate;
    }

    public void setUpdateDate(Timestamp updateDate) {
        this.updateDate = updateDate;
    }

    @Basic
    @Column(name = "EXT_ATTR_1")
    public String getExtAttr1() {
        return extAttr1;
    }

    public void setExtAttr1(String extAttr1) {
        this.extAttr1 = extAttr1;
    }

    @Basic
    @Column(name = "EXT_ATTR_2")
    public String getExtAttr2() {
        return extAttr2;
    }

    public void setExtAttr2(String extAttr2) {
        this.extAttr2 = extAttr2;
    }

    @Basic
    @Column(name = "EXT_ATTR_3")
    public String getExtAttr3() {
        return extAttr3;
    }

    public void setExtAttr3(String extAttr3) {
        this.extAttr3 = extAttr3;
    }

    @Basic
    @Column(name = "EXT_ATTR_4")
    public String getExtAttr4() {
        return extAttr4;
    }

    public void setExtAttr4(String extAttr4) {
        this.extAttr4 = extAttr4;
    }

    @Basic
    @Column(name = "EXT_ATTR_5")
    public String getExtAttr5() {
        return extAttr5;
    }

    public void setExtAttr5(String extAttr5) {
        this.extAttr5 = extAttr5;
    }

    @Basic
    @Column(name = "EXT_ATTR_6")
    public String getExtAttr6() {
        return extAttr6;
    }

    public void setExtAttr6(String extAttr6) {
        this.extAttr6 = extAttr6;
    }

    @Basic
    @Column(name = "EXT_ATTR_7")
    public String getExtAttr7() {
        return extAttr7;
    }

    public void setExtAttr7(String extAttr7) {
        this.extAttr7 = extAttr7;
    }

    @Basic
    @Column(name = "EXT_ATTR_8")
    public String getExtAttr8() {
        return extAttr8;
    }

    public void setExtAttr8(String extAttr8) {
        this.extAttr8 = extAttr8;
    }

    @Basic
    @Column(name = "EXT_ATTR_9")
    public String getExtAttr9() {
        return extAttr9;
    }

    public void setExtAttr9(String extAttr9) {
        this.extAttr9 = extAttr9;
    }

    @Basic
    @Column(name = "EXT_ATTR_10")
    public String getExtAttr10() {
        return extAttr10;
    }

    public void setExtAttr10(String extAttr10) {
        this.extAttr10 = extAttr10;
    }

    @Basic
    @Column(name = "EXT_ATTR_11")
    public BigDecimal getExtAttr11() {
        return extAttr11;
    }

    public void setExtAttr11(BigDecimal extAttr11) {
        this.extAttr11 = extAttr11;
    }

    @Basic
    @Column(name = "EXT_ATTR_12")
    public BigDecimal getExtAttr12() {
        return extAttr12;
    }

    public void setExtAttr12(BigDecimal extAttr12) {
        this.extAttr12 = extAttr12;
    }

    @Basic
    @Column(name = "EXT_ATTR_13")
    public BigDecimal getExtAttr13() {
        return extAttr13;
    }

    public void setExtAttr13(BigDecimal extAttr13) {
        this.extAttr13 = extAttr13;
    }

    @Basic
    @Column(name = "EXT_ATTR_14")
    public BigDecimal getExtAttr14() {
        return extAttr14;
    }

    public void setExtAttr14(BigDecimal extAttr14) {
        this.extAttr14 = extAttr14;
    }

    @Basic
    @Column(name = "EXT_ATTR_15")
    public BigDecimal getExtAttr15() {
        return extAttr15;
    }

    public void setExtAttr15(BigDecimal extAttr15) {
        this.extAttr15 = extAttr15;
    }

    @Basic
    @Column(name = "EXT_ATTR_16")
    public BigDecimal getExtAttr16() {
        return extAttr16;
    }

    public void setExtAttr16(BigDecimal extAttr16) {
        this.extAttr16 = extAttr16;
    }

    @Basic
    @Column(name = "EXT_ATTR_17")
    public BigDecimal getExtAttr17() {
        return extAttr17;
    }

    public void setExtAttr17(BigDecimal extAttr17) {
        this.extAttr17 = extAttr17;
    }

    @Basic
    @Column(name = "EXT_ATTR_18")
    public BigDecimal getExtAttr18() {
        return extAttr18;
    }

    public void setExtAttr18(BigDecimal extAttr18) {
        this.extAttr18 = extAttr18;
    }

    @Basic
    @Column(name = "EXT_ATTR_19")
    public BigDecimal getExtAttr19() {
        return extAttr19;
    }

    public void setExtAttr19(BigDecimal extAttr19) {
        this.extAttr19 = extAttr19;
    }

    @Basic
    @Column(name = "EXT_ATTR_20")
    public BigDecimal getExtAttr20() {
        return extAttr20;
    }

    public void setExtAttr20(BigDecimal extAttr20) {
        this.extAttr20 = extAttr20;
    }

    @Basic
    @Column(name = "EXT_ATTR_21")
    public Timestamp getExtAttr21() {
        return extAttr21;
    }

    public void setExtAttr21(Timestamp extAttr21) {
        this.extAttr21 = extAttr21;
    }

    @Basic
    @Column(name = "EXT_ATTR_22")
    public Timestamp getExtAttr22() {
        return extAttr22;
    }

    public void setExtAttr22(Timestamp extAttr22) {
        this.extAttr22 = extAttr22;
    }

    @Basic
    @Column(name = "EXT_ATTR_23")
    public Timestamp getExtAttr23() {
        return extAttr23;
    }

    public void setExtAttr23(Timestamp extAttr23) {
        this.extAttr23 = extAttr23;
    }

    @Basic
    @Column(name = "EXT_ATTR_24")
    public Timestamp getExtAttr24() {
        return extAttr24;
    }

    public void setExtAttr24(Timestamp extAttr24) {
        this.extAttr24 = extAttr24;
    }

    @Basic
    @Column(name = "EXT_ATTR_25")
    public Timestamp getExtAttr25() {
        return extAttr25;
    }

    public void setExtAttr25(Timestamp extAttr25) {
        this.extAttr25 = extAttr25;
    }

    @Basic
    @Column(name = "EXT_ATTR_26")
    public Timestamp getExtAttr26() {
        return extAttr26;
    }

    public void setExtAttr26(Timestamp extAttr26) {
        this.extAttr26 = extAttr26;
    }

    @Basic
    @Column(name = "EXT_ATTR_27")
    public Timestamp getExtAttr27() {
        return extAttr27;
    }

    public void setExtAttr27(Timestamp extAttr27) {
        this.extAttr27 = extAttr27;
    }

    @Basic
    @Column(name = "EXT_ATTR_28")
    public Timestamp getExtAttr28() {
        return extAttr28;
    }

    public void setExtAttr28(Timestamp extAttr28) {
        this.extAttr28 = extAttr28;
    }

    @Basic
    @Column(name = "EXT_ATTR_29")
    public Timestamp getExtAttr29() {
        return extAttr29;
    }

    public void setExtAttr29(Timestamp extAttr29) {
        this.extAttr29 = extAttr29;
    }

    @Basic
    @Column(name = "EXT_ATTR_30")
    public Timestamp getExtAttr30() {
        return extAttr30;
    }

    public void setExtAttr30(Timestamp extAttr30) {
        this.extAttr30 = extAttr30;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        AddressbookEntity that = (AddressbookEntity) o;

        if (id != that.id) return false;
        if (memberId != null ? !memberId.equals(that.memberId) : that.memberId != null) return false;
        if (createDate != null ? !createDate.equals(that.createDate) : that.createDate != null) return false;
        if (updateDate != null ? !updateDate.equals(that.updateDate) : that.updateDate != null) return false;
        if (extAttr1 != null ? !extAttr1.equals(that.extAttr1) : that.extAttr1 != null) return false;
        if (extAttr2 != null ? !extAttr2.equals(that.extAttr2) : that.extAttr2 != null) return false;
        if (extAttr3 != null ? !extAttr3.equals(that.extAttr3) : that.extAttr3 != null) return false;
        if (extAttr4 != null ? !extAttr4.equals(that.extAttr4) : that.extAttr4 != null) return false;
        if (extAttr5 != null ? !extAttr5.equals(that.extAttr5) : that.extAttr5 != null) return false;
        if (extAttr6 != null ? !extAttr6.equals(that.extAttr6) : that.extAttr6 != null) return false;
        if (extAttr7 != null ? !extAttr7.equals(that.extAttr7) : that.extAttr7 != null) return false;
        if (extAttr8 != null ? !extAttr8.equals(that.extAttr8) : that.extAttr8 != null) return false;
        if (extAttr9 != null ? !extAttr9.equals(that.extAttr9) : that.extAttr9 != null) return false;
        if (extAttr10 != null ? !extAttr10.equals(that.extAttr10) : that.extAttr10 != null) return false;
        if (extAttr11 != null ? !extAttr11.equals(that.extAttr11) : that.extAttr11 != null) return false;
        if (extAttr12 != null ? !extAttr12.equals(that.extAttr12) : that.extAttr12 != null) return false;
        if (extAttr13 != null ? !extAttr13.equals(that.extAttr13) : that.extAttr13 != null) return false;
        if (extAttr14 != null ? !extAttr14.equals(that.extAttr14) : that.extAttr14 != null) return false;
        if (extAttr15 != null ? !extAttr15.equals(that.extAttr15) : that.extAttr15 != null) return false;
        if (extAttr16 != null ? !extAttr16.equals(that.extAttr16) : that.extAttr16 != null) return false;
        if (extAttr17 != null ? !extAttr17.equals(that.extAttr17) : that.extAttr17 != null) return false;
        if (extAttr18 != null ? !extAttr18.equals(that.extAttr18) : that.extAttr18 != null) return false;
        if (extAttr19 != null ? !extAttr19.equals(that.extAttr19) : that.extAttr19 != null) return false;
        if (extAttr20 != null ? !extAttr20.equals(that.extAttr20) : that.extAttr20 != null) return false;
        if (extAttr21 != null ? !extAttr21.equals(that.extAttr21) : that.extAttr21 != null) return false;
        if (extAttr22 != null ? !extAttr22.equals(that.extAttr22) : that.extAttr22 != null) return false;
        if (extAttr23 != null ? !extAttr23.equals(that.extAttr23) : that.extAttr23 != null) return false;
        if (extAttr24 != null ? !extAttr24.equals(that.extAttr24) : that.extAttr24 != null) return false;
        if (extAttr25 != null ? !extAttr25.equals(that.extAttr25) : that.extAttr25 != null) return false;
        if (extAttr26 != null ? !extAttr26.equals(that.extAttr26) : that.extAttr26 != null) return false;
        if (extAttr27 != null ? !extAttr27.equals(that.extAttr27) : that.extAttr27 != null) return false;
        if (extAttr28 != null ? !extAttr28.equals(that.extAttr28) : that.extAttr28 != null) return false;
        if (extAttr29 != null ? !extAttr29.equals(that.extAttr29) : that.extAttr29 != null) return false;
        if (extAttr30 != null ? !extAttr30.equals(that.extAttr30) : that.extAttr30 != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = (int) (id ^ (id >>> 32));
        result = 31 * result + (memberId != null ? memberId.hashCode() : 0);
        result = 31 * result + (createDate != null ? createDate.hashCode() : 0);
        result = 31 * result + (updateDate != null ? updateDate.hashCode() : 0);
        result = 31 * result + (extAttr1 != null ? extAttr1.hashCode() : 0);
        result = 31 * result + (extAttr2 != null ? extAttr2.hashCode() : 0);
        result = 31 * result + (extAttr3 != null ? extAttr3.hashCode() : 0);
        result = 31 * result + (extAttr4 != null ? extAttr4.hashCode() : 0);
        result = 31 * result + (extAttr5 != null ? extAttr5.hashCode() : 0);
        result = 31 * result + (extAttr6 != null ? extAttr6.hashCode() : 0);
        result = 31 * result + (extAttr7 != null ? extAttr7.hashCode() : 0);
        result = 31 * result + (extAttr8 != null ? extAttr8.hashCode() : 0);
        result = 31 * result + (extAttr9 != null ? extAttr9.hashCode() : 0);
        result = 31 * result + (extAttr10 != null ? extAttr10.hashCode() : 0);
        result = 31 * result + (extAttr11 != null ? extAttr11.hashCode() : 0);
        result = 31 * result + (extAttr12 != null ? extAttr12.hashCode() : 0);
        result = 31 * result + (extAttr13 != null ? extAttr13.hashCode() : 0);
        result = 31 * result + (extAttr14 != null ? extAttr14.hashCode() : 0);
        result = 31 * result + (extAttr15 != null ? extAttr15.hashCode() : 0);
        result = 31 * result + (extAttr16 != null ? extAttr16.hashCode() : 0);
        result = 31 * result + (extAttr17 != null ? extAttr17.hashCode() : 0);
        result = 31 * result + (extAttr18 != null ? extAttr18.hashCode() : 0);
        result = 31 * result + (extAttr19 != null ? extAttr19.hashCode() : 0);
        result = 31 * result + (extAttr20 != null ? extAttr20.hashCode() : 0);
        result = 31 * result + (extAttr21 != null ? extAttr21.hashCode() : 0);
        result = 31 * result + (extAttr22 != null ? extAttr22.hashCode() : 0);
        result = 31 * result + (extAttr23 != null ? extAttr23.hashCode() : 0);
        result = 31 * result + (extAttr24 != null ? extAttr24.hashCode() : 0);
        result = 31 * result + (extAttr25 != null ? extAttr25.hashCode() : 0);
        result = 31 * result + (extAttr26 != null ? extAttr26.hashCode() : 0);
        result = 31 * result + (extAttr27 != null ? extAttr27.hashCode() : 0);
        result = 31 * result + (extAttr28 != null ? extAttr28.hashCode() : 0);
        result = 31 * result + (extAttr29 != null ? extAttr29.hashCode() : 0);
        result = 31 * result + (extAttr30 != null ? extAttr30.hashCode() : 0);
        return result;
    }
}
