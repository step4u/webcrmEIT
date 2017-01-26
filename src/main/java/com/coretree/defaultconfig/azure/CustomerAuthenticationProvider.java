package com.coretree.defaultconfig.azure;

import java.security.PrivateKey;
import java.util.Collection;

import javax.crypto.Cipher;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;
//import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.StandardPasswordEncoder;
import org.springframework.security.web.authentication.WebAuthenticationDetails;
import org.springframework.stereotype.Component;

//EIT ���ο� �׽�Ʈ �����Դϴ�.
//������ �ϼ���.
@Component
public class CustomerAuthenticationProvider implements AuthenticationProvider {  
 
	private static final Logger logger = LoggerFactory.getLogger(CustomerAuthenticationProvider.class);
	
	private static CustomerSessionInfo sessionInfo = CustomerSessionInfo.getInstance();

    @Autowired
    CustomUserDetailsService customUserDetailsService;
 
    @Autowired
    private StandardPasswordEncoder passwordEncoder;
	
    @Override
    public boolean supports(Class<?> authentication) {
        return authentication.equals(UsernamePasswordAuthenticationToken.class);
    }

	@Override
	public Authentication authenticate(Authentication authentication)
			throws AuthenticationException {
		
        User user = null;
        Collection<? extends GrantedAuthority> authorities = null;
		
		String encodedUsername = (String)authentication.getPrincipal();		
		String encodedPassword = (String)authentication.getCredentials();
		
		String username = "";
		String password = "";

		WebAuthenticationDetails au = (WebAuthenticationDetails)authentication.getDetails();
		String sessionId = au.getSessionId();

		logger.info("--------------------------------------------------------");
		logger.debug("currentSessionID<== {}", sessionId);
		
		PrivateKey privateKey = (PrivateKey)sessionInfo.getPrivateKeyById(sessionId);
		//sessionInfo.removePrivateKey(sessionId);
		if (privateKey == null) {
			logger.error("authenticate", "privateKey null");
			throw new BadCredentialsException("privateKey null");
		}
		
		logger.info("encodedUsername <== {}", encodedUsername);
		logger.info("encodedPassword <== {}", encodedPassword);

		try {
			username = decodetRSA(privateKey, encodedUsername);
			password = decodetRSA(privateKey, encodedPassword);
			
			//logger.info("decodedAuthInfo <== {}", username + " / " + password);
		} 
		catch (Exception e) {
			logger.error("authenticate:" +  e.getMessage());
			throw new BadCredentialsException(e.getMessage());
		}

        try {
            user = (User)customUserDetailsService.loadUserByUsername(username);

			if (!passwordEncoder.matches(password, user.getPassword())) { 
				logger.error("authenticate: password wrong!! " +  password);
				throw new BadCredentialsException("password wrong!! " +  password);
			}
            
            authorities = user.getAuthorities();
        } 
        catch(UsernameNotFoundException e) {
			logger.error("authenticate: UsernameNotFoundException: " + e.getMessage());
            throw new UsernameNotFoundException(e.getMessage());
        } 
        catch(BadCredentialsException e) {
			logger.error("authenticate: BadCredentialsException: " + e.getMessage());
            throw new BadCredentialsException(e.getMessage());
        } 
        catch(Exception e) {
			logger.error("authenticate: etc: " + e.getMessage());
            throw new RuntimeException(e.getMessage());
        }
 
        return new UsernamePasswordAuthenticationToken(username, password, authorities);
	}
	
	private String decodetRSA(PrivateKey privateKey, String securedValue) throws Exception {
		Cipher cipher = Cipher.getInstance("RSA");
		byte[] encryptedBytes = hexToByteArray(securedValue);
		cipher.init(Cipher.DECRYPT_MODE, privateKey);
		byte[] decryptedBytes = cipher.doFinal(encryptedBytes);
		String decryptedValue = new String(decryptedBytes, "utf-8"); 
		return decryptedValue;
	}

	private static byte[] hexToByteArray(String hex) {
		if (hex == null || hex.length() % 2 != 0) {
			return new byte[]{};
		}

		byte[] bytes = new byte[hex.length() / 2];
		for (int i = 0; i < hex.length(); i += 2) {
			byte value = (byte)Integer.parseInt(hex.substring(i, i + 2), 16);
			bytes[(int) Math.floor(i / 2)] = value;
		}
		return bytes;
	}

}


