package com.seeyon.apps.kdXdtzXc.vo;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 * Created by tap-pcng43 on 2017-8-8.
 */
public class NCZhuangTao implements Serializable {
    private String account;//账套编码
    private String oatable;//oa table
    private Date prepareddate;//制单日期
    private String pk_voucher;// 凭证主键 修改的时候传输
    private String oanum;//流水号
     private List<NCZhuangTaoDetail> detail;

    public NCZhuangTao(String account, String oatable, Date prepareddate, String pk_voucher, String oanum) {
        this.account = account;
        this.oatable = oatable;
        this.prepareddate = prepareddate;
        this.pk_voucher = pk_voucher;
        this.oanum = oanum;
    }

    public NCZhuangTao() {
    }

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    public Date getPrepareddate() {
        return prepareddate;
    }

    public void setPrepareddate(Date prepareddate) {
        this.prepareddate = prepareddate;
    }

    public String getOatable() {
        return oatable;
    }

    public void setOatable(String oatable) {
        this.oatable = oatable;
    }

    public List<NCZhuangTaoDetail> getDetail() {
        return detail;
    }

    public void setDetail(List<NCZhuangTaoDetail> detail) {
        this.detail = detail;
    }

    public String getPk_voucher() {
        return pk_voucher;
    }

    public void setPk_voucher(String pk_voucher) {
        this.pk_voucher = pk_voucher;
    }

    public String getOanum() {
        return oanum;
    }

    public void setOanum(String oanum) {
        this.oanum = oanum;
    }

    @Override
    public String toString() {
        return "NCZhuangTao{" +
                "account='" + account + '\'' +
                ", oatable='" + oatable + '\'' +
                ", prepareddate=" + prepareddate +
                ", pk_voucher='" + pk_voucher + '\'' +
                ", oanum='" + oanum + '\'' +
                ", detail=" + detail +
                '}';
    }
}
