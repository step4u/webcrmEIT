package com.coretree.defaultconfig.main.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coretree.defaultconfig.main.mapper.CallbackMapper;
import com.coretree.defaultconfig.main.model.Callback;

/**
 * Test를 위한 컨트롤러 클래스
 * 
 * @author hsw
 *
 */
@RestController
public class CallbackController {

	@Autowired
	CallbackMapper callbackMapper;

    @RequestMapping(path = "/main/callbackList", method = RequestMethod.POST)
    public  List<Callback> customerList(@RequestBody Callback paramCallback, HttpServletRequest request) throws Exception {

		List<Callback> callback = callbackMapper.callbackList(paramCallback);
    	
    	return callback;
    }

	@RequestMapping(path = "/main/callbackSave", method = RequestMethod.POST)
	public long updatePwd(@RequestBody Callback paramCallback, HttpSession session) {
		long result = 0;
		result = callbackMapper.updateCallback(paramCallback);
		return result;
	}
	
	@RequestMapping(path = "/main/reservationList", method = RequestMethod.POST)
	public  List<Callback> reservationList(@RequestBody Callback paramCallback, HttpServletRequest request) throws Exception {
		
		List<Callback> callback = callbackMapper.reservationList(paramCallback);
		
		return callback;
	}

	@RequestMapping(path = "/main/insertReservation", method = RequestMethod.POST)
	public long insertReservation(@RequestBody Callback paramCallback, HttpSession session) {
		long result = 0;
		System.out.println("insertReservation====>"+paramCallback.toString());
		result = callbackMapper.insertReservation(paramCallback);
		
		return result;
	}
	@RequestMapping(path = "/main/reservationSave", method = RequestMethod.POST)
	public long reservationSave(@RequestBody Callback paramCallback, HttpSession session) {
		long result = 0;
		result = callbackMapper.updateReservation(paramCallback);
		return result;
	}
}

















