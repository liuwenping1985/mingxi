package com.xad.bullfly.datasource;

import com.alibaba.druid.pool.DruidDataSource;
import com.alibaba.druid.support.http.StatViewServlet;
import com.alibaba.druid.support.http.WebStatFilter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.boot.web.servlet.ServletRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.annotation.Order;
import org.springframework.jdbc.core.JdbcTemplate;

import javax.sql.DataSource;
import java.util.HashMap;
import java.util.Map;

/**
 * 数据源配置，第一优先装配
 * @Author liuwenping
 */
@Configuration
@PropertySource("classpath:${spring.profiles.active}/datasource.properties")
@ConfigurationProperties(prefix = "datasource")
@Order(0)
public class DataSourceConfig {


    private static final Logger log = LoggerFactory.getLogger(DataSourceConfig.class);

    @Value("${druid.login.user_name}")
    private String userName;

    @Value("${druid.login.password}")
    private String password;

    @Value("${druid.allow.ip}")
    private String allowIp;

    /**
     * 私有bean,现在用durid数据源
     * @return
     */
    @Primary
    @Bean(name="primary_data_source")
    @ConfigurationProperties(prefix="spring.datasource")
    public DataSource primaryDruidDataSource() {
        return new DruidDataSource();
    }
    /**
     * 第二个数据源现在用durid数据源
     * @return
     */
    @Bean(name="huawei_cloud_datasource")
    @ConfigurationProperties(prefix="hw.cloud.spring.datasource")
    public DataSource hwCloudDruidDataSource() {
        return new DruidDataSource();
    }



    @Bean
    public ServletRegistrationBean druidServlet() {
        log.info("init Druid Servlet Configuration ");
        ServletRegistrationBean servletRegistrationBean = new ServletRegistrationBean();
        servletRegistrationBean.setServlet(new StatViewServlet());
        servletRegistrationBean.addUrlMappings("/druid/*");
        Map<String, String> initParameters = new HashMap<String,String>();
        initParameters.put("loginUsername", userName);
        initParameters.put("loginPassword", password);
        // 禁用HTML页面上的“Reset All”功能
        initParameters.put("resetEnable", "false");
        //initParameters.put("allow", allowIp); // IP白名单 (没有配置或者为空，则允许所有访问)
        //initParameters.put("deny", "");// IP黑名单 (存在共同时，deny优先于allow)
        servletRegistrationBean.setInitParameters(initParameters);
        return servletRegistrationBean;
    }

    @Bean
    public FilterRegistrationBean filterRegistrationBean() {
        FilterRegistrationBean filterRegistrationBean = new FilterRegistrationBean();
        filterRegistrationBean.setFilter(new WebStatFilter());
        filterRegistrationBean.addUrlPatterns("/*");
        filterRegistrationBean.addInitParameter("exclusions", "*.js,*.gif,*.jpg,*.png,*.css,*.ico,/druid/*");
        return filterRegistrationBean;

    }

    @Bean(name = "primaryJdbcTemplate")
    public JdbcTemplate primaryJdbcTemplate(
            @Qualifier("primary_data_source") DataSource dataSource) {
        return new JdbcTemplate(dataSource);
    }

    @Bean(name = "secondaryJdbcTemplate")
    public JdbcTemplate secondaryJdbcTemplate(
            @Qualifier("huawei_cloud_datasource") DataSource dataSource) {
        return new JdbcTemplate(dataSource);
    }

}
