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

import com.coretree.defaultconfig.statis.mapper.IvrCallMapper;
import com.coretree.defaultconfig.statis.model.IvrCall;


@RestController
public class IvrCallController {
	
	@Autowired
	IvrCallMapper ivrCallMapper;
	
	/**
	 * IVR현황(팝업) - 조회 버튼
	 * @param workbook
	 * @param fileName
	 * @return
	 */
	@RequestMapping(path="/popup/ivrSelect", method = RequestMethod.POST)
	public List<IvrCall> ivrList(@RequestBody IvrCall searchVO, ModelMap model, HttpServletRequest request) {

		String now = searchVO.getIvrstartDate() +" 00:00:00"; // 형식을 지켜야 함
		Timestamp t = Timestamp.valueOf(now);
		String now2 = searchVO.getIvrendDate() +" 23:59:59"; // 형식을 지켜야 함
		Timestamp t2 = Timestamp.valueOf(now2);
		
		searchVO.setIvrstartDate(t.toString());
		searchVO.setIvrendDate(t2.toString());
		
		List<IvrCall> ivrCall = ivrCallMapper.selectIvrList(searchVO);
		return ivrCall;
	}
	
	/*엑셀 다운로드*/
	@RequestMapping(path = "/popup/ivrListExcel")
	public  ModelAndView ivrcallListExcel(@RequestParam("ivrstartDate") String ivrstartDate,
										@RequestParam("ivrendDate") String ivrendDate,
										@RequestParam("tmptelNo") String tmptelNo,
										@RequestParam("empNm") String empNm,
			ModelMap model, HttpServletRequest request) throws Exception {
		
		String now = ivrstartDate +" 00:00:00"; // 형식을 지켜야 함
		Timestamp t = Timestamp.valueOf(now);
		String now2 = ivrendDate +" 23:59:59"; // 형식을 지켜야 함
		Timestamp t2 = Timestamp.valueOf(now2);
		
		IvrCall searchVO = new IvrCall(); 
		
		searchVO.setIvrstartDate(t.toString());
		searchVO.setIvrendDate(t2.toString());
		
		List<IvrCall> result = ivrCallMapper.selectIvrList(searchVO);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("resultList", result);

		model.addAttribute("ivrCallList", map.get("resultList"));
		model.addAttribute("empNm", empNm);
		
		return new ModelAndView("IvrCallListReportDownload", "ivrListReportMap", model);
	}
	
}
