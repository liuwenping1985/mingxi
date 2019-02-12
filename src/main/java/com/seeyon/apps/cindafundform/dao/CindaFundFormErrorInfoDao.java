package com.seeyon.apps.cindafundform.dao;

import java.util.List;

import com.seeyon.apps.cindafundform.po.CindaFundFormErrorInfo;

public interface CindaFundFormErrorInfoDao {
	  /**
	   * 保存
	   * @param record
	   */
	  public void save(CindaFundFormErrorInfo record);

	  /**
	   * 更新
	   * @param record
	   */
	  public void update(CindaFundFormErrorInfo record);

	  /**
	   * 删除
	   * @param id
	   */
	  public void delete(CindaFundFormErrorInfo record);

	  /**
	   * 分页条件查询
	   * @return
	   */
	  public List<CindaFundFormErrorInfo> select();

	  /**
	   * 根据主键查询
	   * @param id
	   * @return
	   */
	  public CindaFundFormErrorInfo findById(long id);
}
