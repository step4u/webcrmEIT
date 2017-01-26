package com.coretree.defaultconfig.config;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.boot.autoconfigure.jdbc.DataSourceBuilder;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.web.servlet.config.annotation.DefaultServletHandlerConfigurer;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;

import com.coretree.defaultconfig.controller.AgentStatListReportDownload;
import com.coretree.defaultconfig.controller.CallStatListReportDownload;
import com.coretree.defaultconfig.controller.ExcelListReportDownload;
import com.coretree.defaultconfig.controller.IvrCallListReportDownload;
import com.coretree.defaultconfig.controller.RecordListReportDownload;
import com.coretree.defaultconfig.main.controller.CustmoerListReportDownload;


@Configuration
@EnableWebMvc
public class ApplicationConfigureAdapter extends WebMvcConfigurerAdapter {

	@Override
	public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
		// TODO Auto-generated method stub
//		super.configureDefaultServletHandling(configurer);
		configurer.enable();
	}
	
	@Bean
	public InternalResourceViewResolver viewResolver() {
		InternalResourceViewResolver resolver = new InternalResourceViewResolver();
		resolver.setViewClass(JstlView.class);
		resolver.setPrefix("/WEB-INF/jsp/");
        resolver.setSuffix(".jsp");
        return resolver;
	}

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		// TODO Auto-generated method stub
//		super.addResourceHandlers(registry);
		registry.addResourceHandler("/resources/js/**/").addResourceLocations("/static/js/");
		registry.addResourceHandler("/resources/css/**/").addResourceLocations("/static/css/");
		registry.addResourceHandler("/resources/image/**/").addResourceLocations("/static/image/");
		registry.addResourceHandler("/resources/summernote/**/").addResourceLocations("/static/summernote/");
		registry.addResourceHandler("/resources/jui-master/**/").addResourceLocations("/static/jui-master/");
	}

	@Override
	public void addViewControllers(ViewControllerRegistry registry) {

		//테스트 코드------------------------------------------------------------------------------------------
		registry.addViewController("/hello").setViewName("/test/hello"); //에디터 summernote에 연결한다.
		registry.addViewController("/test").setViewName("/test/customer_test"); //테스트에 연결한다.		
		//-----------------------------------------------------------------------------------------------------
		
	//	registry.addViewController("/").setViewName("/login/login");
		registry.addViewController("/index").setViewName("/index");
	}
	
	@Bean
	public CustmoerListReportDownload CustmoerListReportDownload(){
		CustmoerListReportDownload custmoerListReportDownload = new CustmoerListReportDownload();
		return custmoerListReportDownload;
	}
	
	@Bean
	public ExcelListReportDownload ExcelListReportDownload(){
		ExcelListReportDownload excelListReportDownload = new ExcelListReportDownload();
		return excelListReportDownload;
	}
	
	@Bean
	public RecordListReportDownload RecordListReportDownload(){
		RecordListReportDownload recordListReportDownload = new RecordListReportDownload();
		return recordListReportDownload;
	}
	
	@Bean
	public IvrCallListReportDownload IvrCallListReportDownload(){
		IvrCallListReportDownload ivrCallListReportDownload = new IvrCallListReportDownload();
		return ivrCallListReportDownload;
	}
	
	@Bean
	public CallStatListReportDownload CallStatListReportDownload(){
		CallStatListReportDownload callStatListReportDownload = new CallStatListReportDownload();
		return callStatListReportDownload;
	}
	
	@Bean
	public AgentStatListReportDownload AgentStatListReportDownload(){
		AgentStatListReportDownload agentStatListReportDownload = new AgentStatListReportDownload();
		return agentStatListReportDownload;
	}
	
	  @Bean
	  @Primary
	  @ConfigurationProperties(prefix="spring.datasource")
	  public DataSource primaryDataSource() {
	      return DataSourceBuilder.create().build();
	  }
	  
	  /*
	  @Bean
	  @ConfigurationProperties(prefix="spring.datasource2")
	  public DataSource secondaryDataSource() {
	      return DataSourceBuilder.create().build();
	  }
	   */
	  
	  @Bean
	  public SqlSessionFactory sqlSessionFatory(DataSource datasource) throws Exception{
		   SqlSessionFactoryBean sqlSessionFactory = new SqlSessionFactoryBean();
		   sqlSessionFactory.setDataSource(datasource);
		   //Resources 폴더 안에 있는 xml 파일, 연결한 DB에 따라 쿼리 폴더 지정해줄 것  
		   sqlSessionFactory.setMapperLocations(new PathMatchingResourcePatternResolver().getResources("classpath:SQL/firebird/*.xml"));
		   return (SqlSessionFactory) sqlSessionFactory.getObject();
	   }
	   
	   @Bean
	   public SqlSessionTemplate sqlSession(SqlSessionFactory sqlSessionFactory) {
		   return new SqlSessionTemplate(sqlSessionFactory);
	   }
}
