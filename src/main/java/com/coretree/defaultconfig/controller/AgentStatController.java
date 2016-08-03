/*작성자 : 송은미*/
package com.coretree.defaultconfig.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coretree.defaultconfig.statis.mapper.AgentStatMapper;
import com.coretree.defaultconfig.statis.model.AgentStat;

@RestController
public class AgentStatController {
	@Autowired
	AgentStatMapper agentStatMapper;

	/**
	 * 상담원 통계 현황 - 상담원 selectBox
	 */
	@RequestMapping(path="/code/selectEmpNm", method = RequestMethod.POST)
	public List<AgentStat> agentListSelectBox(@RequestBody AgentStat searchVO,
    		ModelMap model, HttpServletRequest request) throws Exception {
		List<AgentStat> agentStat = agentStatMapper.selectAgentEmpNmList(searchVO);
		return agentStat;
	}
	
	/**
	 * 상담원 통계 현황 - 시간별 조회
	 */
	@RequestMapping(path="/popup/councellerPresentList", method = RequestMethod.POST)
	public List<AgentStat> noticeFileList(@RequestBody AgentStat searchVO,
    		ModelMap model, HttpServletRequest request) throws Exception {
		List<AgentStat> agentStat = agentStatMapper.selectAgentStatList(searchVO);
		return agentStat;
	}
	
	/**
	 * 상담원 통계 현황 - 일별 조회
	 */
	@RequestMapping(path="/popup/councellerPresentListDay", method = RequestMethod.POST)
	public List<AgentStat> noticeFileListDay(@RequestBody AgentStat searchVO,
    		ModelMap model, HttpServletRequest request) throws Exception {
		List<AgentStat> agentStat = agentStatMapper.selectAgentStatListDay(searchVO);
		return agentStat;
	}
	
	/**
	 * 상담원 통계 현황 - 월별 조회
	 */
	@RequestMapping(path="/popup/councellerPresentListMonth", method = RequestMethod.POST)
	public List<AgentStat> noticeFileListMonth(@RequestBody AgentStat searchVO,
    		ModelMap model, HttpServletRequest request) throws Exception {
		List<AgentStat> agentStat = agentStatMapper.selectAgentStatListMonth(searchVO);
		return agentStat;
	}
	
	/**
	 * 상담원 통계 현황 - 연도별 조회
	 */
	@RequestMapping(path="/popup/councellerPresentListYear", method = RequestMethod.POST)
	public List<AgentStat> noticeFileListYear(@RequestBody AgentStat searchVO,
    		ModelMap model, HttpServletRequest request) throws Exception {
		List<AgentStat> agentStat = agentStatMapper.selectAgentStatListYear(searchVO);
		return agentStat;
	}
	
}
