package com.seeyon.v3x.services.kdXdtzXc;

/**
 * Created by tap-pcng43 on 2017-9-30.
 */
public interface CaiWuSysDataManager {
    String sysDepartments(String xml);

    String sysProjects(String xml);

    String sysOrgInfos(String xml);

    /**
     * ���ܣ��ṩ������Ϣ��OA����
     * @param p_period
     * @return
     */
    String sysnCwTravelAllowance(String p_period);
}
