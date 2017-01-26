/*작성자 : 송은미*/
package com.coretree.defaultconfig.controller;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.coretree.defaultconfig.statis.mapper.CallStatMapper;
import com.coretree.defaultconfig.statis.model.CallStat;

@RestController
public class CallStatController {
	@Autowired
	CallStatMapper callStatMapper;

	/**
	 * 전체 통계 현황(팝업) - 조회 버튼(시간별)
	 * @param workbook
	 * @param fileName
	 * @return
	 */
	@RequestMapping(path="/popup/callStatSelect", method = RequestMethod.POST)
	public List<CallStat> callStatList(@RequestBody CallStat searchVO,
    		ModelMap model, HttpServletRequest request) throws Exception {
		
		String start = searchVO.getCallStatstartDate() + " 00:00:00";
		Timestamp t = Timestamp.valueOf(start);
		String end = searchVO.getCallStatendDate() + " 23:59:59";
		Timestamp t2 = Timestamp.valueOf(end);
		
		searchVO.setCallStatstartDate(t.toString());
		searchVO.setCallStatendDate(t2.toString());
		
		List<CallStat> callStat = callStatMapper.selectCallStatList(searchVO);
		return callStat;
	}
	
	/**
	 * 전체 통계 현황(팝업) - 조회 버튼(일별)
	 * @param workbook
	 * @param fileName
	 * @return
	 */
	@RequestMapping(path="/popup/callStatSelectDay", method = RequestMethod.POST)
	public List<CallStat> callStatListDay(@RequestBody CallStat searchVO,
    		ModelMap model, HttpServletRequest request) throws Exception {
		
		String start = searchVO.getCallStatstartDate() + " 00:00:00";
		Timestamp t = Timestamp.valueOf(start);
		String end = searchVO.getCallStatendDate() + " 23:59:59";
		Timestamp t2 = Timestamp.valueOf(end);
		
		searchVO.setCallStatstartDate(t.toString());
		searchVO.setCallStatendDate(t2.toString());
		
		List<CallStat> callStat = callStatMapper.selectCallStatListDay(searchVO);
		return callStat;
	}
	
	/**
	 * 전체 통계 현황(팝업) - 조회 버튼(월별)
	 * @param workbook
	 * @param fileName
	 * @return
	 */
	@RequestMapping(path="/popup/callStatSelectMonth", method = RequestMethod.POST)
	public List<CallStat> callStatListMonth(@RequestBody CallStat searchVO,
    		ModelMap model, HttpServletRequest request) throws Exception {
		
		String start = searchVO.getCallStatstartDate() + "-01 00:00:00";
		Timestamp t = Timestamp.valueOf(start);
		String end = searchVO.getCallStatendDate();
		switch(end.substring(end.length()-2, end.length())){
			case "01" : case "03" : case "05" :
			case "07" : case "08" : case "10" : 
			case "12" : 
				end = end + "-31 23:59:59"; break;
			case "02" : 
				end = end + "-29 23:59:59"; break;
			case "04" : case "06" : 
			case "09" : case "11" : 
				end = end + "-30 23:59:59"; break;
		}
		
		Timestamp t2 = Timestamp.valueOf(end);
		
		searchVO.setCallStatstartDate(t.toString());
		searchVO.setCallStatendDate(t2.toString());
		
		List<CallStat> callStat = callStatMapper.selectCallStatListMonth(searchVO);
		return callStat;
	}
	
	/**
	 * 전체 통계 현황(팝업) - 조회 버튼(연도별)
	 * @param workbook
	 * @param fileName
	 * @return
	 */
	@RequestMapping(path="/popup/callStatSelectYear", method = RequestMethod.POST)
	public List<CallStat> callStatListYear(@RequestBody CallStat searchVO,
    		ModelMap model, HttpServletRequest request) throws Exception {
		
		String start = searchVO.getCallStatstartDate() + "-01-01 00:00:00";
		Timestamp t = Timestamp.valueOf(start);
		String end = searchVO.getCallStatendDate() + "-12-31 23:59:59";
		Timestamp t2 = Timestamp.valueOf(end);
		
		searchVO.setCallStatstartDate(t.toString());
		searchVO.setCallStatendDate(t2.toString());
		
		List<CallStat> callStat = callStatMapper.selectCallStatListYear(searchVO);
		return callStat;
	}
	
	/*엑셀 다운로드*/
	@RequestMapping(path = "/popup/callcenterListExcel")
	public  ModelAndView callcenterListExcel(@RequestParam("callStatstartDate") String startDate,
										@RequestParam("callStatendDate") String endDate,
										@RequestParam("callStatstartDate2") String startDate2,
										@RequestParam("callStatendDate2") String endDate2,
										@RequestParam("empNm") String empNm,
										@RequestParam("radioValue") int radioValue,
			ModelMap model, HttpServletRequest request) throws Exception {
		
	
	
		List<CallStat> result = null;
		
		if(radioValue == 1){
			String start = startDate + " 00:00:00";
			Timestamp t = Timestamp.valueOf(start);
			String end = endDate + " 23:59:59";
			Timestamp t2 = Timestamp.valueOf(end);
			
			CallStat searchVO = new CallStat();
			
			searchVO.setCallStatstartDate(t.toString());
			searchVO.setCallStatendDate(t2.toString());
			searchVO.setCallStatstartDate2(startDate2);
			searchVO.setCallStatendDate2(endDate2);
			
			result = callStatMapper.selectCallStatList(searchVO);
		}else if(radioValue == 2){
			String start = startDate + " 00:00:00";
			Timestamp t = Timestamp.valueOf(start);
			String end = endDate + " 23:59:59";
			Timestamp t2 = Timestamp.valueOf(end);
			
			CallStat searchVO = new CallStat();
			
			searchVO.setCallStatstartDate(t.toString());
			searchVO.setCallStatendDate(t2.toString());
			searchVO.setCallStatstartDate2(startDate2);
			searchVO.setCallStatendDate2(endDate2);
			
			result = callStatMapper.selectCallStatListDay(searchVO);
		}else if(radioValue == 3){
			String start = startDate + "-01 00:00:00";
			Timestamp t = Timestamp.valueOf(start);
			String end = endDate;
			switch(end.substring(end.length()-2, end.length())){
				case "01" : case "03" : case "05" :
				case "07" : case "08" : case "10" : 
				case "12" : 
					end = end + "-31 23:59:59"; break;
				case "02" : 
					end = end + "-29 23:59:59"; break;
				case "04" : case "06" : 
				case "09" : case "11" : 
					end = end + "-30 23:59:59"; break;
			}
			
			Timestamp t2 = Timestamp.valueOf(end);
			
			CallStat searchVO = new CallStat();
			
			searchVO.setCallStatstartDate(t.toString());
			searchVO.setCallStatendDate(t2.toString());
			searchVO.setCallStatstartDate2(startDate2);
			searchVO.setCallStatendDate2(endDate2);
			
			result = callStatMapper.selectCallStatListMonth(searchVO);
		}else if(radioValue == 4){
			String start = startDate + "-01-01 00:00:00";
			Timestamp t = Timestamp.valueOf(start);
			String end = endDate + "-12-31 23:59:59";
			Timestamp t2 = Timestamp.valueOf(end);
			
			CallStat searchVO = new CallStat();
			
			searchVO.setCallStatstartDate(t.toString());
			searchVO.setCallStatendDate(t2.toString());
			searchVO.setCallStatstartDate2(startDate2);
			searchVO.setCallStatendDate2(endDate2);
			
			result = callStatMapper.selectCallStatListYear(searchVO);
		}
		

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("resultList", result);

		model.addAttribute("callcenterList", map.get("resultList"));
		model.addAttribute("empNm", empNm);
		
		return new ModelAndView("CallStatListReportDownload", "callStatListReportMap", model);
	}
	
}
