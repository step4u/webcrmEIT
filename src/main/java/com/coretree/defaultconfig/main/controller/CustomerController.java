package com.coretree.defaultconfig.main.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coretree.defaultconfig.main.mapper.CustomerMapper;
import com.coretree.defaultconfig.main.model.Customer;

/**
 * Test를 위한 컨트롤러 클래스
 * 
 * @author hsw
 *
 */
@RestController
public class CustomerController{

	@Autowired
	CustomerMapper customerMapper;

	/**
	 * customer counter 정보를 조회한다.
	 * 
	 * @param condition
	 * @return
	 */

    @RequestMapping(path = "/main/customerList", method = RequestMethod.POST)
    public  List<Customer> customerList(@RequestBody Customer searchVO,
    		ModelMap model, HttpServletRequest request) throws Exception {

		List<Customer> customer = customerMapper.selectCustomerList(searchVO);
    	
    	return customer;
    }
    
    @RequestMapping(path = "/main/customerOne", method = RequestMethod.POST)
    public  Customer customerOne(@RequestBody Customer searchVO,
    		ModelMap model, HttpServletRequest request) throws Exception {
    	
    	Customer customer = customerMapper.selectCustomerOne(searchVO);
    	
    	return customer;
    }
    

    @RequestMapping(path = "/main/existCntCustomer", method = RequestMethod.POST)
    public long existCntCustomer(@RequestBody Customer paramCustomer, HttpSession session) {
    	long result = 0;
    	Customer customer = new Customer();
    	if(paramCustomer.getCustCd().equals("1001")){
        	customer = customerMapper.selectExistCnt1001(paramCustomer);
        	result = customer.getExistCnt();
    	}else{
    		customer = customerMapper.selectExistCnt1002(paramCustomer);
        	result = customer.getExistCnt();
    	}
    	return result;
    }
    
    @RequestMapping(path = "/main/insertCustomer", method = RequestMethod.POST)
	public String insertCustomer(@RequestBody Customer paramCustomer, HttpSession session) {
		long result = 0;
		String resultMsg = "0";
		long exitCnt = 0;
		String custNo = "";
		System.out.println("test===>"+paramCustomer.toString());
		Customer customer = new Customer();
		customer = customerMapper.selectExistCnt1001(paramCustomer);
		exitCnt = customer.getExistCnt();
			if(exitCnt == 0){
				result = customerMapper.insertCustomer(paramCustomer);
				if(result == 1){
					custNo = customerMapper.selectCustomerCustNo(paramCustomer);
					resultMsg = custNo;
				}else{
					resultMsg = "0";
				}
			}else{
				customerMapper.updateCustomer(paramCustomer);
				resultMsg = "2";
			}
		return resultMsg;
	}
    
    @RequestMapping(path = "/main/insertCustomer2", method = RequestMethod.POST)
    public long insertCustomer2(@RequestBody Customer paramCustomer, HttpSession session) {
    	long result = 0;
    	long exitCnt = 0;
    	System.out.println("test===>"+paramCustomer.toString());
    	Customer customer = new Customer();
		customer = customerMapper.selectExistCnt1002(paramCustomer);
		exitCnt = customer.getExistCnt();
    		if(exitCnt == 0){
    			result = customerMapper.insertCustomer2(paramCustomer);
    		}else{
    			customerMapper.updateCustomer(paramCustomer);
    			result = 2;
    		}
    	return result;
    }
    
    @RequestMapping(path = "/main/deleteCustomer", method = RequestMethod.POST)
    public long deleteCustomer(@RequestBody Customer paramCustomer, HttpSession session) {
    	long result = 0;
    	String[] test = paramCustomer.getCustNo().split(",");
    	Customer customer = new Customer();
    	customer.setCustNos(test);
    	result = customerMapper.deleteCustomer(customer);
    	return result;
    }
    
	/**
	 * 고객정보선택(팝업)
	 * @param workbook
	 * @param fileName
	 * @return
	 */
    @RequestMapping(path = "/popup/customerList", method = RequestMethod.POST)
    public  List<Customer> customerPopup(@RequestBody Customer searchVO,
    		ModelMap model, HttpServletRequest request) throws Exception {

		List<Customer> customer = customerMapper.selectCustomer(searchVO);
    	
    	return customer;
    }
    
	/**
	 * 엑셀로 고객정보 저장 - 저장 버튼(개인)
	 * @param workbook
	 * @param fileName
	 * @return
	 */
	@RequestMapping(path="/popup/insertCustomer", method = RequestMethod.POST)
	public long saveCustomer(@RequestBody Customer searchVO,
    		ModelMap model, HttpServletRequest request) throws Exception {
		long result = customerMapper.insertCustomer(searchVO);
		return result;
	}
	
	/**
	 * 엑셀로 고객정보 저장 - 저장 버튼(사업가)
	 * @param workbook
	 * @param fileName
	 * @return
	 */
	@RequestMapping(path="/popup/insertCustomer2", method = RequestMethod.POST)
	public long saveCustomer2(@RequestBody Customer searchVO,
    		ModelMap model, HttpServletRequest request) throws Exception {
		long result = customerMapper.insertCustomer2(searchVO);
		return result;
	}
}


















