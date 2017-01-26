package com.coretree.defaultconfig.azure;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.authentication.session.SessionAuthenticationException;
import org.springframework.stereotype.Component;

@Component
public class AuthFailureHandler implements AuthenticationFailureHandler {

	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response, AuthenticationException exception)
			throws IOException, ServletException {
		if(exception.getClass().isAssignableFrom(SessionAuthenticationException.class)) {
			System.out.println("이게에러2-->"+exception.toString());
			request.setAttribute("duplicateYN", "Y");
			request.getRequestDispatcher("/").forward(request, response);
//			response.sendRedirect("/");
		} else {
			System.out.println("이게에러--->"+exception.toString());
			request.setAttribute("param",exception.toString());
			response.sendRedirect("/");
		}
	}
}
