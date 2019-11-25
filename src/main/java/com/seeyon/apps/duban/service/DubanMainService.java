package com.seeyon.apps.duban.service;

import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2019/11/25.
 */
public class DubanMainService {

    private static DubanMainService dubanMainService = new DubanMainService();

    public static DubanMainService getInstance(){

        return dubanMainService;

    }

    /**
     * 督办员的列表
     * @param memberId
     * @return
     */
    public List<Map> getDubanTaskMain(Long memberId){
        return null;

    }

    /**
     * 领导的列表
     * @param memberId
     * @return
     */
    public List<Map> getDubanTaskLeader(Long memberId){

        return null;
    }

    /**
     * 主办
     * @param memberId
     * @return
     */
    public List<Map> getMyMainDubanTask(Long memberId){

        return null;
    }

    /**
     * 协办
     * @param memberId
     * @return
     */
    public List<Map> getMyCollDubanTask(Long memberId){

        return null;
    }


}
