package com.seeyon.apps.kdXdtzXc.po;

import java.io.Serializable;
import java.util.Date;

/**
 * Created by tap-pcng43 on 2017-8-2.
 * 出差申请审批单-行程
 */
public class TravelExpenseXinChengDetail implements Serializable {
    private Long id;
    private Long formmain_id;

    private Integer ybChucaiDays;
    private Integer ybBuzhuDays;
    private Integer ybFeiBuZhuDays;
    private String ybBeizhu;

    private String chu_cai_dd;//出差地点
    private String di_qu_lx;//地区类型

    private Date insert_date;
    private Date update_date;
    private String idStr;
    private String formmain_idStr;
    private Integer xgChucaiDays;
    private Integer xgBuzhuDays;
    private Integer xgFeiBuZhuDays;
    private String xgBeizhu;
    private Integer xzChucaiDays;
    private Integer xzBuzhuDays;
    private Integer  xzFeiBuZhuDays;
    private String  xzBeizhu;

    public void initStr() {
        if (id != null) {
            idStr = id.toString();
        }
        if (formmain_id != null) {
            formmain_idStr = formmain_id.toString();
        }
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getFormmain_id() {
        return formmain_id;
    }

    public void setFormmain_id(Long formmain_id) {
        this.formmain_id = formmain_id;
    }

    public Integer getYbChucaiDays() {
        return ybChucaiDays;
    }

    public void setYbChucaiDays(Integer ybChucaiDays) {
        this.ybChucaiDays = ybChucaiDays;
    }

    public Integer getYbBuzhuDays() {
        return ybBuzhuDays;
    }

    public void setYbBuzhuDays(Integer ybBuzhuDays) {
        this.ybBuzhuDays = ybBuzhuDays;
    }

    public Integer getYbFeiBuZhuDays() {
        return ybFeiBuZhuDays;
    }

    public void setYbFeiBuZhuDays(Integer ybFeiBuZhuDays) {
        this.ybFeiBuZhuDays = ybFeiBuZhuDays;
    }

    public String getYbBeizhu() {
        return ybBeizhu;
    }

    public void setYbBeizhu(String ybBeizhu) {
        this.ybBeizhu = ybBeizhu;
    }

    public String getChu_cai_dd() {
        return chu_cai_dd;
    }

    public void setChu_cai_dd(String chu_cai_dd) {
        this.chu_cai_dd = chu_cai_dd;
    }

    public String getDi_qu_lx() {
        return di_qu_lx;
    }

    public void setDi_qu_lx(String di_qu_lx) {
        this.di_qu_lx = di_qu_lx;
    }

    public Date getInsert_date() {
        return insert_date;
    }

    public void setInsert_date(Date insert_date) {
        this.insert_date = insert_date;
    }

    public Date getUpdate_date() {
        return update_date;
    }

    public void setUpdate_date(Date update_date) {
        this.update_date = update_date;
    }

    public String getIdStr() {
        return idStr;
    }

    public void setIdStr(String idStr) {
        this.idStr = idStr;
    }

    public String getFormmain_idStr() {
        return formmain_idStr;
    }

    public void setFormmain_idStr(String formmain_idStr) {
        this.formmain_idStr = formmain_idStr;
    }

	public Integer getXgChucaiDays() {
		return xgChucaiDays;
	}

	public void setXgChucaiDays(Integer xgChucaiDays) {
		this.xgChucaiDays = xgChucaiDays;
	}

	public Integer getXgBuzhuDays() {
		return xgBuzhuDays;
	}

	public void setXgBuzhuDays(Integer xgBuzhuDays) {
		this.xgBuzhuDays = xgBuzhuDays;
	}

	public Integer getXgFeiBuZhuDays() {
		return xgFeiBuZhuDays;
	}

	public void setXgFeiBuZhuDays(Integer xgFeiBuZhuDays) {
		this.xgFeiBuZhuDays = xgFeiBuZhuDays;
	}

	public String getXgBeizhu() {
		return xgBeizhu;
	}

	public void setXgBeizhu(String xgBeizhu) {
		this.xgBeizhu = xgBeizhu;
	}

	public Integer getXzChucaiDays() {
		return xzChucaiDays;
	}

	public void setXzChucaiDays(Integer xzChucaiDays) {
		this.xzChucaiDays = xzChucaiDays;
	}

	public Integer getXzBuzhuDays() {
		return xzBuzhuDays;
	}

	public void setXzBuzhuDays(Integer xzBuzhuDays) {
		this.xzBuzhuDays = xzBuzhuDays;
	}

	public Integer getXzFeiBuZhuDays() {
		return xzFeiBuZhuDays;
	}

	public void setXzFeiBuZhuDays(Integer xzFeiBuZhuDays) {
		this.xzFeiBuZhuDays = xzFeiBuZhuDays;
	}

	public String getXzBeizhu() {
		return xzBeizhu;
	}

	public void setXzBeizhu(String xzBeizhu) {
		this.xzBeizhu = xzBeizhu;
	}
    
}
