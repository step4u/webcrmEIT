package com.coretree.defaultconfig.main.controller;

import java.io.IOException;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.RSAPublicKeySpec;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.StandardPasswordEncoder;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.coretree.defaultconfig.EitDateUtil;
import com.coretree.defaultconfig.azure.CustomerSessionInfo;
import com.coretree.defaultconfig.main.mapper.OrganizationMapper;
import com.coretree.defaultconfig.main.model.Organization;

/**
 * Test를 위한 컨트롤러 클래스
 * 
 * @author hsw
 *
 */
@RestController
public class OrganizationController {

	@Autowired
	OrganizationMapper organizationMapper;

	private static int RSA_KEY_SIZE=1024;
	
	private static CustomerSessionInfo sessionInfo = CustomerSessionInfo.getInstance();
	
	public void generateRSA(HttpServletRequest request, ModelMap model) throws Exception {

		KeyPairGenerator generator = null;
		KeyPair keyPair = null;
		KeyFactory keyFactory = null;

		PublicKey publicKey = null;
		PrivateKey privateKey = null;
		RSAPublicKeySpec publicSpec = null;

		String publicKeyModulus = "";
		String publicKeyExponent =  "";

		try {
			generator = KeyPairGenerator.getInstance("RSA");
		} 
		catch (NoSuchAlgorithmException e) {
			System.out.println("generateRSA:KeyPairGenerator: " + e.getMessage());
		//	logger.error("generateRSA:KeyPairGenerator: " + e.getMessage());
			throw new InvalidKeySpecException(e.getMessage());
		}
		generator.initialize(RSA_KEY_SIZE);
		keyPair = generator.genKeyPair();

		try {
			keyFactory = KeyFactory.getInstance("RSA");
		} 
		catch (NoSuchAlgorithmException e) {
			System.out.println("generateRSA:KeyFactory: " + e.getMessage());
			//logger.error("generateRSA:KeyFactory: " + e.getMessage());
			throw new InvalidKeySpecException(e.getMessage());
		}

		publicKey = keyPair.getPublic();
		privateKey = keyPair.getPrivate();

		HttpSession session = request.getSession();

		//session - key
		sessionInfo.setPrivateKey(session.getId(), privateKey);

		try {
			publicSpec = (RSAPublicKeySpec) keyFactory.getKeySpec(publicKey, RSAPublicKeySpec.class);
		} catch (InvalidKeySpecException e) {
			System.out.println("generateRSA:keyFactory.getKeySpec: " + e.getMessage());
			//logger.error("generateRSA:keyFactory.getKeySpec: " + e.getMessage());
			throw new InvalidKeySpecException(e.getMessage());
		}

		publicKeyModulus = publicSpec.getModulus().toString(16);
		publicKeyExponent = publicSpec.getPublicExponent().toString(16);

		//logger.debug("publicKeyModulus : " + publicKeyModulus);

		model.addAttribute("publicKeyModulus",publicKeyModulus);
		model.addAttribute("publicKeyExponent",publicKeyExponent);
	}

	@RequestMapping(value="/")
	public void loginEncode(HttpServletRequest request, HttpServletResponse response) throws Exception {

		ModelMap model = new ModelMap();
		generateRSA(request, model);
		
		String publicKeyModulus = (String)model.get("publicKeyModulus");
		String publicKeyExponent = (String)model.get("publicKeyExponent");

		request.setAttribute("publicKeyModulus", publicKeyModulus);
		request.setAttribute("publicKeyExponent", publicKeyExponent);

		request.getRequestDispatcher("/WEB-INF/jsp/login/login.jsp").forward(request, response);
	}
	@RequestMapping(path = "/login/actionLogin", method = RequestMethod.POST)
	public void checkLogin(HttpSession session, HttpServletRequest request,HttpServletResponse response) throws IOException {
		Organization paramUsers = new Organization();
		paramUsers.setEmpNo(request.getAttribute("empNo").toString());
		Organization users = organizationMapper.checkLogin(paramUsers);
		if(users != null){
			session.setAttribute("empNo", users.getEmpNo());
			session.setAttribute("empNm", users.getEmpNm());
			session.setAttribute("extensionNo", users.getExtensionNo());
			session.setAttribute("role", users.getRole());
			session.setAttribute("lastLoginDate", users.getLastLoginDate());

			//비밀번호 재설정X
			if(users.getModifyDate().equals("") || users.getModifyDate() == ""){
				session.setAttribute("pwdModifyDate", "N");
			}else{
				session.setAttribute("pwdModifyDate", "Y");
				//3개월 이상
				if(EitDateUtil.datetoInt(EitDateUtil.getToday()) > EitDateUtil.datetoInt(EitDateUtil.addMonth(users.getModifyDate(), 3))){
					session.setAttribute("3M_pwdUpdate", "Y");
				}else{
					session.setAttribute("3M_pwdUpdate", "N");
				}
			}

			organizationMapper.updateLoginDate(paramUsers);
		}
		
		response.sendRedirect("/index");
		/*ModelAndView view = new ModelAndView();
		view.setViewName("/index");
		return view;*/
	}
/*	
	@RequestMapping(path = "/login/actionLogin", method = RequestMethod.POST)
	public ModelAndView checkLogin(HttpSession session, HttpServletRequest request) {
		long result = 0;
		Organization paramUsers = new Organization();
		paramUsers.setEmpNo(request.getAttribute("empNo").toString());
		Organization users = organizationMapper.checkLogin(paramUsers);
		String encodedPassword = new BCryptPasswordEncoder().encode(paramUsers.getPassword());
		System.out.println("==========>test222>>>>"+ users.toString());
		if(users != null){
			System.out.println("==========>test222>>>>"+ users.toString());
			long nCount = users.getExistCount();
			String realPassword = users.getPassword();
			if(nCount == 0){
				result = 0;
			}else if(nCount == 1){
				System.out.println("==========>test>>>>"+ users.toString());
				session.setAttribute("empNo", users.getEmpNo());
				session.setAttribute("empNm", users.getEmpNm());
				session.setAttribute("extensionNo", users.getExtensionNo());
				session.setAttribute("role", users.getRole());
				session.setAttribute("lastLoginDate", users.getLastLoginDate());
				result = 1;
			}else if(nCount == 1 && !realPassword.equals(encodedPassword)){
				result = 2;
			}
		}
		ModelAndView view = new ModelAndView();
		view.setViewName("/index");
		return view;
	}
*/

	@RequestMapping(path = "/login/updatePwd", method = RequestMethod.POST)
	public long updatePwd(@RequestBody Organization paramUsers, HttpSession session) {
		long result = 0;

		//영문자, 숫자, 특수문자를 포함한 8자리~20자리 비밀번호 체크
		String password = paramUsers.getNewPwd();
	    String passwordPolicy = "((?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*()]).{8,20})";
	     
	    Pattern pattern = Pattern.compile(passwordPolicy);
	    Matcher matcher = pattern.matcher(password);
	     
	    if(matcher.matches() == true){ 
			Organization users = organizationMapper.checkLogin(paramUsers);
			if(users != null){
				 Boolean encodedPwdChk = new StandardPasswordEncoder().matches(paramUsers.getPassword(), users.getPassword());
				if(encodedPwdChk){
					 String encodedPassword = new StandardPasswordEncoder().encode(paramUsers.getNewPwd());
					 paramUsers.setNewPwd(encodedPassword);
					 organizationMapper.updatePwd(paramUsers);
					result = 1;
				}else{
					result = 0;
				}
			}
	    }else{
	    	result = 2;
	    }
		return result;
	}
	
	
	@RequestMapping(path = "/empList", method = RequestMethod.POST)
	public List<Organization> empList() throws Exception {
		
		List<Organization> emp = organizationMapper.empList();

		return emp;
	}
	
	@RequestMapping(path = "/main/usersState", method = RequestMethod.POST)
	public List<Organization> usersState() throws Exception {
		
		List<Organization> emp = organizationMapper.usersState();
		
		return emp;
	}	
	
	//비밀번호 변경 3개월 경과 - 나중에 변경
	@RequestMapping(path = "/login/updatePwd_late", method = RequestMethod.POST)
	public long updatePwd_late(@RequestBody Organization paramUsers, HttpSession session) throws Exception {
		long result = 0;
		try{
			result = organizationMapper.updatePwd_late(paramUsers);
		}catch(Exception e){
			result = 0;
		}
		return result;
	}
}

















