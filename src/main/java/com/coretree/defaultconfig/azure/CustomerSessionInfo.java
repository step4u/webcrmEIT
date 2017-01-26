package com.coretree.defaultconfig.azure;

import java.security.PrivateKey;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;

//EIT ���ο� �׽�Ʈ �����Դϴ�.
//������ �ϼ���.

public class CustomerSessionInfo {

	//private static final Logger logger = LoggerFactory.getLogger(CustomSessionInfo.class);

	private static CustomerSessionInfo thisInfo = null;
	
	private static final Map<String, PrivateKey> privateKeys = new ConcurrentHashMap<String, PrivateKey>();
	
	private CustomerSessionInfo() {}
	
	public static synchronized CustomerSessionInfo getInstance() {
		if (thisInfo == null)
			thisInfo = new CustomerSessionInfo();
		return thisInfo;
	}
	
    public PrivateKey getPrivateKeyById(String sessionId) {
    	PrivateKey key = privateKeys.get(sessionId);
    	removePrivateKey(sessionId);
		return key;
	}
    
	public void setPrivateKey(String sessionId, PrivateKey privateKey) {
		privateKeys.put(sessionId, privateKey);
	}
	
	public void removePrivateKey(String id) {
		privateKeys.remove(id);
	}

}
