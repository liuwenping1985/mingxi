package com.seeyon.apps.kdXdtzXc.vo;

import com.seeyon.apps.kdXdtzXc.base.util.ToolkitUtil;
import com.seeyon.apps.kdXdtzXc.util.JSONUtilsExt;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import java.io.IOException;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by tap-pcng43 on 2017-8-14.
 * 会计科目
 */
public class NcCaptionAccountVo implements Serializable {
    private Integer acclev;//科目级次
    private String account;//账套编码
    private String accountname;//账套名称
    private Integer balanorient;//科目方向
    private String code;//科目编码
    private Boolean endflag;//是否末级
    private String name;//科目名称
    private String pk_acctype;//科目类型
    private List<NcCaptionAccountChildrenAlistVo> alist;//辅助核算
//    private Object alist ;


    public String getAccountname() {
        return accountname;
    }

    public void setAccountname(String accountname) {
        this.accountname = accountname;
    }

    public Integer getAcclev() {
        return acclev;
    }

    public void setAcclev(Integer acclev) {
        this.acclev = acclev;
    }

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    public Integer getBalanorient() {
        return balanorient;
    }

    public void setBalanorient(Integer balanorient) {
        this.balanorient = balanorient;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public Boolean getEndflag() {
        return endflag;
    }

    public void setEndflag(Boolean endflag) {
        this.endflag = endflag;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPk_acctype() {
        return pk_acctype;
    }

    public void setPk_acctype(String pk_acctype) {
        this.pk_acctype = pk_acctype;
    }

//    public Object getAlist() {
//        return alist;
//    }

    //    public void setAlist(Object alist) {
//        this.alist = alist;
//    }
    public List<NcCaptionAccountChildrenAlistVo> getAlist() {
        return alist;
    }

    public void setAlist(List<NcCaptionAccountChildrenAlistVo> alist) {
        this.alist = alist;
    }

    public static List<NcCaptionAccountVo> json2List(String json) {
        List<NcCaptionAccountVo> list = new ArrayList<NcCaptionAccountVo>();
        JSONArray jsonArray = JSONArray.fromObject(json);
        Object[] arrays = jsonArray.toArray();
        for (Object o : arrays) {
            JSONObject jsonObject = (JSONObject) o;
            String acclev = jsonObject.get("acclev") + "";
            String account = jsonObject.get("account") + "";
            String accountname = jsonObject.get("accountname") + "";
            String balanorient = jsonObject.get("balanorient") + "";
            String code = jsonObject.get("code") + "";
            String endflag = jsonObject.get("endflag") + "";
            String name = jsonObject.get("name") + "";
            String pk_acctype = jsonObject.get("pk_acctype") + "";
            JSONArray alist = (JSONArray) jsonObject.get("alist");
            NcCaptionAccountVo ncCaptionAccountVo = new NcCaptionAccountVo();
            ncCaptionAccountVo.setAcclev(ToolkitUtil.parseInt(acclev, null));
            ncCaptionAccountVo.setAccount(account);
            ncCaptionAccountVo.setAccountname(accountname);
            ncCaptionAccountVo.setBalanorient(ToolkitUtil.parseInt(balanorient, null));
            ncCaptionAccountVo.setCode(code);
            ncCaptionAccountVo.setEndflag(ToolkitUtil.parseBoolean(endflag, null));
            ncCaptionAccountVo.setName(name);
            ncCaptionAccountVo.setPk_acctype(pk_acctype);
            List<NcCaptionAccountChildrenAlistVo> list1 = new ArrayList<NcCaptionAccountChildrenAlistVo>();
            for (Object oc : alist) {
                JSONObject oc1 = (JSONObject) oc;
                NcCaptionAccountChildrenAlistVo ncCaptionAccountChildrenAlistVo = null;
                try {
                    ncCaptionAccountChildrenAlistVo = JSONUtilsExt.fromJson(oc1.toString(), NcCaptionAccountChildrenAlistVo.class);
                } catch (IOException e) {
                    e.printStackTrace();
                }
                list1.add(ncCaptionAccountChildrenAlistVo);
            }
            ncCaptionAccountVo.setAlist(list1);
            list.add(ncCaptionAccountVo);
        }
        return list;
    }

    @Override
    public String toString() {
        return "NcCaptionAccountVo{" +
                "acclev=" + acclev +
                ", account='" + account + '\'' +
                ", accountname='" + accountname + '\'' +
                ", balanorient=" + balanorient +
                ", code='" + code + '\'' +
                ", endflag=" + endflag +
                ", name='" + name + '\'' +
                ", pk_acctype='" + pk_acctype + '\'' +
                ", alist=" + alist +
                '}';
    }
}
