package com.coretree.defaultconfig.main.controller;

import javax.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 권한을 위한 컨트롤러 클래스
 * 
 * @author hsw
 *
 */
@RestController
public class RoleUrlController {

	//SUPERADMIN 페이지
    @RequestMapping(path = "/popup/View*SuperAdmin.do")
	public boolean View_default_SuperAdmin(HttpSession session) {
		return true;
	}
    
	//관리자 페이지
    @RequestMapping(path = "/popup/View*Admin.do")
	public boolean View_default_Admin(HttpSession session) {
		return true;
	}
    
    //사용자 페이지
    @RequestMapping(path = "/popup/View*User.do")
    public boolean View_default_User(HttpSession session) {
    	return true;
    }
    
}


