package com.xad.bullfly.core.service;

import com.xad.bullfly.core.common.service.MicroService;
import com.xad.bullfly.organization.vo.UserVo;

import java.util.List;

/**
 * Created by liuwenping on 2019/8/21.
 * @Author liuwenping
 */
public interface OrgService extends MicroService {

    public List<UserVo> getUserVoList();


}
