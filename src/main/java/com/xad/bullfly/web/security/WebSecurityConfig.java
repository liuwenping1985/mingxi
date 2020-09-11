package com.xad.bullfly.web.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.access.AccessDecisionManager;
import org.springframework.security.access.AccessDecisionVoter;
import org.springframework.security.access.vote.AffirmativeBased;
import org.springframework.security.access.vote.AuthenticatedVoter;
import org.springframework.security.access.vote.RoleVoter;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.provisioning.JdbcUserDetailsManager;
import org.springframework.security.web.access.expression.WebExpressionVoter;

import javax.sql.DataSource;
import java.util.Arrays;
import java.util.List;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true,jsr250Enabled=true,securedEnabled=true)
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    @Value("${xad.default-user}")
    private String du;
    @Value("${xad.default-password}")
    private String dp;

    @Autowired
    @Qualifier("primary_data_source")
    private DataSource dataSource;





    /**
     * 配置核心 所有的东西 都要从这里搞一波
     * 写死的必须弄成动态配置
     * 这里只包含API的权限
     * @param http
     * @throws Exception
     */
    @Override
    protected void configure(HttpSecurity http) throws Exception {
//        http.formLogin(form->form.loginPage("/login").permitAll())
//        .authorizeRequests(
//                 au->au.antMatchers("/","/home").permitAll()
//                .mvcMatchers("**/say").permitAll()
//                .mvcMatchers("/admin/api/**").hasRole("ADMIN")
//                .mvcMatchers("/user/api/**").hasRole("USER")
//                .mvcMatchers("/user/authenticate").permitAll()
//                .mvcMatchers("/rbac/**").hasRole("SUPER_POWER")
//                .mvcMatchers("/app/api/**").access("@webSecurityChopper.access(authentication,request)")
//                .anyRequest().authenticated());

//        http.sessionManagement()
//                .sessionCreationPolicy(SessionCreationPolicy.STATELESS);
//        http.authorizeRequests().
//                accessDecisionManager(accessDecisionManager()).anyRequest().authenticated();
     //   http.logout().permitAll();
        http.authorizeRequests().anyRequest().permitAll();

    }

    public void configure(WebSecurity web) throws Exception {

        web.ignoring().antMatchers("/**/**");
    }




//
//    @Bean
//    @Override
//    public UserDetailsService userDetailsService() {
//        JdbcUserDetailsManager manager = new JdbcUserDetailsManager();
//        manager.setDataSource(dataSource);
//        if(!manager.userExists("user")){
//            manager.createUser(User.withDefaultPasswordEncoder().username("user").password("user").roles("USER").build());
//
//        }
//        if(!manager.userExists("lwp")){
//            manager.createUser(User.withDefaultPasswordEncoder().username("lwp").password("lwp").roles("USER","ADMIN").build());
//
//        }
//        if(!manager.userExists(du)){
//            manager.createUser(User.withDefaultPasswordEncoder().username(du).password(dp).roles("ADMIN").build());
//        }
//        if(!manager.userExists("su-admin")){
//            manager.createUser(User.withDefaultPasswordEncoder().username("su-admin").password("123456").roles("ADMIN","USER","SUPER_POWER").build());
//        }
//        return manager;
//    }
//
//    /**
//     * 授权的判定
//     * @return
//     */
//    @Bean
//    public AccessDecisionManager accessDecisionManager() {
//        List<AccessDecisionVoter<? extends Object>> decisionVoters
//                = Arrays.asList(
//                new WebExpressionVoter(),
//                 new RoleVoter(),
//                new XadWebSecurityVoter(),
//                new AuthenticatedVoter());
//        return new AffirmativeBased(decisionVoters);
//    }
}
