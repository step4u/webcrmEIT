/*작성자 : 송은미*/
package com.coretree.defaultconfig.controller;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.StandardPasswordEncoder;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coretree.defaultconfig.setting.mapper.TorganizationMapper;
import com.coretree.defaultconfig.setting.model.Torganization;

@RestController
public class TorganizationController {

	@Autowired
	TorganizationMapper torganizationMapper;
	
	/**
	 * 상담원관리(팝업)
	 * @param workbook
	 * @param fileName
	 * @return
	 */
	@RequestMapping(path="/popup/counceller", method = RequestMethod.POST)
	public List<Torganization> councellerList(@RequestBody Torganization searchVO,
    		ModelMap model, HttpServletRequest request) throws Exception {
 
		List<Torganization> torganiztion = torganizationMapper.selectCouncellerList(searchVO);
		
		return torganiztion;
		
	}
	
	/**
	 * 상담원관리(팝업) - 저장버튼
	 * @param workbook
	 * @param fileName
	 * @return
	 */
	@RequestMapping(path="/popup/councellerInsert", method = RequestMethod.POST)
	public long councellerInsert(@RequestBody Torganization searchVO, HttpSession session) {
		long result;
		try{
			Torganization torganization = new Torganization();
			String encodedPassword = new StandardPasswordEncoder().encode(searchVO.getPassword());
			
			torganization.setEmpNo(searchVO.getEmpNo());
			torganization.setEmpNm(searchVO.getEmpNm());
			torganization.setPassword(encodedPassword);
			torganization.setEnterDate(searchVO.getEnterDate());
			torganization.setExtensionNo(searchVO.getExtensionNo());
			torganization.setMobilePhoneNo(searchVO.getMobilePhoneNo());
			torganization.setEmailId(searchVO.getEmailId());
			torganization.setNote(searchVO.getNote());
			torganization.setRole(searchVO.getRole());
			
	    	result = torganizationMapper.insertCounceller(torganization);
	    	
		}catch(Exception e){
			result = 0;
		}
		return result;
	}
	
	
	
	/**
	 * 상담원관리(팝업) - 삭제버튼
	 * @param workbook
	 * @param fileName
	 * @return
	 */
	@RequestMapping(path="/popup/councellerDelete", method = RequestMethod.POST)
	public long councellerDelete(@RequestBody Torganization searchVO, HttpSession session) {
		long result = 0;
    	String[] seq = searchVO.getEmpNo().split(",");
    	Torganization torganization = new Torganization();
    	torganization.setEmpNos(seq);
    	result = torganizationMapper.deleteCounceller(torganization);
    	return result;
	}
	
	/**
	 * 상담원관리(팝업) - 비번초기화 버튼
	 * @param workbook
	 * @param fileName
	 * @return
	 */
	@RequestMapping(path="/popup/councellerUpdate", method = RequestMethod.POST)
	public long councellerUpdate(@RequestBody Torganization searchVO, HttpSession session) {
		long result = 0;
    	String[] seq = searchVO.getEmpNo().split(",");
    	Torganization torganization = new Torganization();
    	
		//영문자, 숫자, 특수문자를 포함한 8자리~20자리 비밀번호 체크(초기화 비밀번호 : pwd12345!)
    	String password = searchVO.getPassword();
	    String passwordPolicy = "((?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*()]).{8,20})";
	     
	    Pattern pattern = Pattern.compile(passwordPolicy);
	    Matcher matcher = pattern.matcher(password);
	     
	    if(matcher.matches() == true){
	    	String encodedPassword = new StandardPasswordEncoder().encode(searchVO.getPassword());
	    	
	    	torganization.setEmpNos(seq);
	    	torganization.setPassword(encodedPassword);
	    	result = torganizationMapper.updateCounceller(torganization);
	    }
    	return result;
	}
	
	/**
	 * 상담원관리(팝업) - 수정
	 * @param workbook
	 * @param fileName
	 * @return
	 */
	@RequestMapping(path="/popup/councellerDataUpdate", method = RequestMethod.POST)
	public long councellerDataUpdate(@RequestBody Torganization searchVO, HttpSession session) {
		long result;
		try{
			result = torganizationMapper.updateDataCounceller(searchVO);			
		}catch(Exception e){
			result = 0;
		}		
		return result;
	}  
	
	/**
	 * 상담원관리(팝업) - 내선번호 중복체크
	 * @param workbook
	 * @param fileName
	 * @return
	 */
	@RequestMapping(path="/popup/councellerExtensionChk", method = RequestMethod.POST)
	public long councellerExtensionChk(@RequestBody Torganization searchVO, HttpSession session) {
		long result;
		try{
			result = torganizationMapper.councellerExtensionChk(searchVO);
		}catch(Exception e){
			result = 0;
		}		
		return result;
	} 
	
	/**
	 * 상담원관리(팝업) - 내선번호 중복체크
	 * @param workbook
	 * @param fileName
	 * @return
	 */
	@RequestMapping(path="/popup/councellerNameChk", method = RequestMethod.POST)
	public long councellerNameChk(@RequestBody Torganization searchVO, HttpSession session) {
		long result;
		try{
			result = torganizationMapper.councellerNameChk(searchVO);
		}catch(Exception e){
			result = 0;
		}		
		return result;
	}
	
	
	
}
