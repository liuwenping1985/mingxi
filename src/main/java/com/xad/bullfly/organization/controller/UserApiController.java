package com.xad.bullfly.organization.controller;

import com.alibaba.fastjson.JSON;
import com.xad.bullfly.core.service.OrgService;
import com.xad.bullfly.organization.vo.UserVo;
import com.xad.bullfly.web.common.vo.WebJsonResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

/**
 * Created by liuwenping on 2020/8/12.
 */
@RestController
@RequestMapping("/user/api/v0.1")
public class UserApiController {


    @Autowired
    private OrgService orgService;

    @RequestMapping(value = "/say", method = RequestMethod.POST)
    public String say2(@RequestBody Map data) throws Exception {
        return "Say Hi-Say Hi[POST]" + data;

    }

    @RequestMapping(value = "/say", method = RequestMethod.PUT)
    public String say3(@RequestBody Map data) throws Exception {
        return "Say Hi-Say Hi[PUT]" + data;

    }

    @RequestMapping(value = "/say", method = RequestMethod.DELETE)
    public String say4() throws Exception {
        return "Say Hi-Say Hi[DELETE]";

    }

    @RequestMapping(value = "/say", method = RequestMethod.PATCH)
    public String say5() throws Exception {
        return "Say Hi-Say Hi[PATCH]";

    }

    @RequestMapping("/stream")
    public String index() throws Exception {
        return "guanggun";
    }


    @RequestMapping("/getUsers")
    public WebJsonResponse getUsers() throws Exception {

        List<UserVo> voList = orgService.getUserVoList();

        return WebJsonResponse.successWithItems(voList);

    }


}
