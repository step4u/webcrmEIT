package com.coretree.defaultconfig.Listener;

import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.broker.BrokerAvailabilityEvent;
// import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.SessionConnectEvent;
import org.springframework.web.socket.messaging.SessionConnectedEvent;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;
import org.springframework.web.socket.messaging.SessionSubscribeEvent;
import org.springframework.web.socket.messaging.SessionUnsubscribeEvent;

// @Component
public abstract class ApplicationListener {
	  @EventListener
	  public abstract void handleBrokerEvent(BrokerAvailabilityEvent evt);

	  @EventListener
	  public abstract void handleSessionConnectEvent(SessionConnectEvent evt);
	  
	  @EventListener
	  public abstract void handleSessionConnectedEvent(SessionConnectedEvent evt);
	  
	  @EventListener
	  public abstract void handleSessionDisconnectEvent(SessionDisconnectEvent evt);
	  
	  @EventListener
	  public abstract void handleSessionSubscribeEvent(SessionSubscribeEvent evt);
	  
	  @EventListener
	  public abstract void handleSessionUnsubscribeEvent(SessionUnsubscribeEvent evt);
}
