package com.coretree.defaultconfig.azure;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.password.StandardPasswordEncoder;
import org.springframework.security.web.access.ExceptionTranslationFilter;

import com.coretree.defaultconfig.main.model.RoleUrl;

//테스트용입니다. 사용하지마세요
@Configuration
@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

	@Autowired
	private LoginHandler loginSuccessHandler;
	
	@Autowired
	private AuthFailureHandler authFailureHandler;
	
	@Autowired
	private CustomerAuthenticationProvider customAuthenticationProvider;
	
	@Autowired
	private DataSource dataSrc;
	
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
/*
		
				
		auth.inMemoryAuthentication().withUser("1000001").password("1").roles("USER");		
		auth.inMemoryAuthentication().withUser("1000002").password("1").roles("USER");		
		auth.inMemoryAuthentication().withUser("1000003").password("1").roles("USER");		
		auth.inMemoryAuthentication().withUser("1000004").password("1").roles("USER");		*/
		/*
		System.out.println("::::::::::::::::::::::::::::::");
		String getUser = "select username, password, enabled from users where username=?";
		String getAuth = "select username, password, role from users where username=?";

		auth
        .jdbcAuthentication()
        	.dataSource(dataSrc)
            .usersByUsernameQuery(getUser)
            .authoritiesByUsernameQuery(getAuth);
		*/
		
		/*String getUser = "select EMP_NO, PASSWORD, ENABLE from TORGANIZATION where EMP_NO=?";
		String getAuth = "select EMP_NO, ROLE from TORGANIZATION where EMP_NO=?";

		auth
        .jdbcAuthentication()
        	.dataSource(dataSrc)
            .usersByUsernameQuery(getUser)
            .authoritiesByUsernameQuery(getAuth)
        	.passwordEncoder(passwordEncoder());*/
		//.userDetailsService();

		// System.err.println("Progress authenticate");
	}

	@Override
	protected void configure(HttpSecurity http) throws Exception {
		//List<String> urls = jdbcTemplate.queryForList("select rloeurl from TROLE_URL", String.class);
		/*List<Actor> actors = this.jdbcTemplate.query(
				  "select first_name, last_name from t_actor",
				  new RowMapper<Actor>() {
				    public Actor mapRow(ResultSet rs, int rowNum) throws SQLException {
				      Actor actor = new Actor();
				      actor.setFirstName(rs.getString("first_name"));
				      actor.setLastName(rs.getString("last_name"));
				      return actor;
				    }
				  });
			HttpSecurity httpSecurity;
		
			httpSecurity.csrf().disable(); //간단처리
			httpSecurity.authorizeRequests();
	
	*/
		
		List<RoleUrl> roles = jdbcTemplate.query( "select url, role from TROLE_URL",
				  new RowMapper<RoleUrl>() {
				    public RoleUrl mapRow(ResultSet rs, int rowNum) throws SQLException {
				    	RoleUrl roleUrl = new RoleUrl();
				    	roleUrl.setUrl(rs.getString("url"));
				    	roleUrl.setRole(rs.getString("role"));
				      return roleUrl;
				    }
				  });
	
		

		http.csrf().disable(); //간단처리
		http.authorizeRequests().antMatchers("/resources/**").permitAll(); //권장사항
		http.authorizeRequests().antMatchers("/").permitAll(); //테스트
		http.authorizeRequests().antMatchers("/login/**").permitAll(); //테스트
		for(RoleUrl role :roles){
			http.authorizeRequests().antMatchers(role.getUrl()).hasAnyAuthority(role.getRole()); 
		}

		http.authorizeRequests().anyRequest().authenticated()
		.and()
		.authenticationProvider(customAuthenticationProvider)
		.formLogin()
		.loginPage("/")
        .loginProcessingUrl("/j_spring_security_check")
		.defaultSuccessUrl("/index")
		.usernameParameter("j_username")
		.passwordParameter("j_password")
		.failureHandler(authFailureHandler)
		.successHandler(loginSuccessHandler)
		.permitAll()
		.and()
		.logout()
		.invalidateHttpSession(true)
        .logoutUrl("/logout")
		.logoutSuccessUrl("/")
		.permitAll();
		http
        .sessionManagement()
        .sessionFixation()
        .migrateSession()
        .sessionCreationPolicy(SessionCreationPolicy.NEVER)
        .maximumSessions(1)
        .maxSessionsPreventsLogin(false)
        .expiredUrl("/logout")
        ;
        //.maxSessionsPreventsLogin(true)
       // .invalidSessionUrl("/logout");

		http
//		.addFilterBefore(duplicationLoginCheckFilter(), RememberMeAuthenticationFilter.class)
		.addFilterAfter(ajaxSessionCheckFilter(), ExceptionTranslationFilter.class);
		
	}
	
	  @Bean
	    public StandardPasswordEncoder passwordEncoder() {
	        return  new StandardPasswordEncoder();
	    }
	  
	  @Bean
	    public AjaxSessionCheckFilter ajaxSessionCheckFilter() {
		  AjaxSessionCheckFilter ajaxSessionCheckFilter = new AjaxSessionCheckFilter();
		  ajaxSessionCheckFilter.setAjaxHeader("AJAX");
	        return ajaxSessionCheckFilter;
	    }
} 