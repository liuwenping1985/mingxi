package com.xad.bullfly.demo.controller;

import com.xad.bullfly.annotaion.AdminPermission;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Created by liuwenping on 2020/8/12.
 */
@RestController
@RequestMapping("/admin/api/v0.1")
public class AdminApiController {


    @RequestMapping("/say")
    @AdminPermission
    public String sayHello() {

        return "hi young blood! I am admin";

    }

    @RequestMapping("/test/stream")
    public String index() throws Exception {
        return "guanggun";

    }


}
