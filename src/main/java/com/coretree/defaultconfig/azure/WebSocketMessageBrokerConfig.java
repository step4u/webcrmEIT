package com.coretree.defaultconfig.azure;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;
import org.springframework.web.socket.config.annotation.AbstractWebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;

@Configuration
@EnableScheduling
@ComponentScan({"com.coretree.defaultconfig.config.azure"})
@EnableWebSocketMessageBroker
public class WebSocketMessageBrokerConfig extends AbstractWebSocketMessageBrokerConfigurer {

	@Override
	public void registerStompEndpoints(StompEndpointRegistry registry) {
		registry.addEndpoint("/webCTI").withSockJS();
	}

	@Override
	public void configureMessageBroker(MessageBrokerRegistry config) {
		config.setApplicationDestinationPrefixes("/app");
		
		ThreadPoolTaskScheduler pingScheduler = new ThreadPoolTaskScheduler();
        pingScheduler.initialize();
        
		config.enableSimpleBroker("/queue", "/topic").setHeartbeatValue(new long[]{25000, 25000}).setTaskScheduler(pingScheduler);
        // config.enableSimpleBroker("/queue", "/topic").setTaskScheduler(pingScheduler);
	}
}