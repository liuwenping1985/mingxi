package com.xad.bullfly.apps.hhsd.controller;

import com.xad.bullfly.apps.hhsd.service.HhsdMainService;
import com.xad.bullfly.apps.hhsd.service.RemoteDepartmentService;
import com.xad.bullfly.apps.hhsd.service.RemoteUserService;
import com.xad.bullfly.web.common.vo.WebJsonResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Created by liuwenping on 2020/9/10.
 */
@RestController
@RequestMapping("/hhsd/api/v0.1")
public class HhsdController {

    @Autowired
    private RemoteUserService remoteUserService;

    @Autowired
    private RemoteDepartmentService remoteDepartmentService;

    @Autowired
    private HhsdMainService hhsdMainService;


    @RequestMapping("/user/{user_id}")
    public WebJsonResponse getRemoteUser(@PathVariable("user_id") String userId) throws Exception {
        //xadXAD@2019
        //-1046765851205939806

        return remoteUserService.getUser(userId);

    }

    @RequestMapping("/dept/{dept_id}")
    public WebJsonResponse getRemoteDept(@PathVariable("dept_id") String deptId) throws Exception {
        //xadXAD@2019
        //-1046765851205939806
        return remoteDepartmentService.getDepartment(deptId);

    }

    @RequestMapping("/duban/task/start/{user_id}")
    public WebJsonResponse startDubanTask(@PathVariable("user_id") String userId) throws Exception {
        //xadXAD@2019
        //-1046765851205939806

        return hhsdMainService.startDubantask(userId);

    }


}
