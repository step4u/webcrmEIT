/*작성자 : 송은미*/
package com.coretree.defaultconfig.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.coretree.defaultconfig.bbs.mapper.BbsMapper;
import com.coretree.defaultconfig.bbs.model.BbsComment;
import com.coretree.defaultconfig.bbs.model.BbsMgt;
import com.coretree.defaultconfig.code.mapper.CodeMapper;
import com.coretree.defaultconfig.setting.mapper.SmsCategoryMapper;
import com.coretree.defaultconfig.setting.mapper.TorganizationMapper;
import com.coretree.defaultconfig.setting.model.SmsCategory;
import com.coretree.defaultconfig.setting.model.Torganization;
import com.coretree.defaultconfig.statis.mapper.IvrCallMapper;
import com.coretree.defaultconfig.statis.mapper.RecordMgtMapper;
import com.coretree.defaultconfig.statis.model.IvrCall;
import com.coretree.defaultconfig.statis.model.RecordMgt;


@RestController
public class PopupController {
	

	@Autowired
	BbsMapper bbsMapper;

	@Autowired
	TorganizationMapper torganizationMapper;
	
	@Autowired
	SmsCategoryMapper smsCategoryMapper;
	
	@Autowired
	RecordMgtMapper recordMgtMapper;
	
	@Autowired
	CodeMapper codeMapper;
	
	@Autowired
	IvrCallMapper ivrCallMapper;
	
	/**
	 * 녹취현황(팝업) - 조회 버튼
	 * @param workbook
	 * @param fileName
	 * @return
	 */
	@RequestMapping(path="/popup/recordList", method = RequestMethod.POST)
	public List<RecordMgt> recordList(@RequestBody RecordMgt searchVO,
    		ModelMap model, HttpServletRequest request) throws Exception {
 
		List<RecordMgt> recordMgt = recordMgtMapper.selectRecordList(searchVO);
		
		return recordMgt;
		
	}

	/**
	 * IVR현황(팝업) - 조회 버튼
	 * @param workbook
	 * @param fileName
	 * @return
	 */
	@RequestMapping(path="/popup/ivrSelect", method = RequestMethod.POST)
	public List<IvrCall> ivrList(@RequestBody IvrCall searchVO,
    		ModelMap model, HttpServletRequest request) throws Exception {
 
		List<IvrCall> ivrCall = ivrCallMapper.selectIvrList(searchVO);
		System.out.println(searchVO.toString());
		
		return ivrCall;
		
	}
	/**
	 * 공지사항 조회(팝업)
	 * @param workbook
	 * @param fileName
	 * @return
	 */
	@RequestMapping(path="/popup/notice", method = RequestMethod.POST)
	public List<BbsMgt> noticeList(@RequestBody BbsMgt searchVO,
    		ModelMap model, HttpServletRequest request) throws Exception {
		List<BbsMgt> bbsmgt = bbsMapper.selectNoticeList(searchVO);
		
		System.out.println(searchVO.toString());
		return bbsmgt;
		
	}

	/**
	 * 공지사항(팝업) - 삭제버튼
	 * @param workbook
	 * @param fileName
	 * @return
	 */
	@RequestMapping(path="/popup/noticeDelete", method = RequestMethod.POST)
	public long noticeDelete(@RequestBody BbsMgt paramBbs, HttpSession session) {
 
		long result = 0;
    	String[] seq = paramBbs.getBbsSeq().split(",");
    	BbsMgt bbs = new BbsMgt();
    	bbs.setBbsSeqs(seq);
    	result = bbsMapper.deleteNotice(bbs);
    	
    	return result;
    	
	}
	/**
	 * 공지사항(팝업) - 등록버튼
	 * @param workbook
	 * @param fileName
	 * @return
	 */
	@RequestMapping(path="/popup/noticeInsert", method = RequestMethod.POST)
	public long noticeInsert(@RequestBody BbsMgt searchVO,
    		ModelMap model, HttpServletRequest request) {
 
		long result;
		try{
			result = bbsMapper.insertNotice(searchVO);
			if(searchVO.getFileName() != ""){
				bbsMapper.insertNoticeFile(searchVO);
			}
		}catch(Exception e){
			result = 0;
		}
		
		return result;
	}
	
	/**
	 * 공지사항(팝업) - 새글 컬럼 업데이트
	 * @param workbook
	 * @param fileName
	 * @return
	 */
	@RequestMapping(path="/popup/noticeNewUpdate", method = RequestMethod.POST)
	public long noticeNewUpdate(@RequestBody BbsMgt searchVO,
    		ModelMap model, HttpServletRequest request) {
 
		long result;
		try{
			result = bbsMapper.updateNotice(searchVO);	
		}catch(Exception e){
			result = 0;
		}
		
		return result;
	}
	
	/**
	 * 공지사항 조회(팝업) - 수정버튼
	 * @param workbook
	 * @param fileName
	 * @return
	 */
	@RequestMapping(path="/popup/noticeModify", method = RequestMethod.POST)
	public long noticeUpdate(@RequestBody BbsMgt searchVO,
    		ModelMap model, HttpSession request) throws Exception {
		long result;
		try{
			result = bbsMapper.selectNoticeModify(searchVO);
		}catch(Exception e){
			result = 0;
		}
		return result;
	}
	
	/**
	 * 공지사항 댓글(팝업) - 조회
	 * @param workbook
	 * @param fileName
	 * @return
	 */
	@RequestMapping(path="/popup/selectCommentReplyList", method = RequestMethod.POST)
	public List<BbsComment> noticeCommentList(@RequestBody BbsComment searchVO,
    		ModelMap model, HttpServletRequest request) throws Exception {
		
		List<BbsComment> bbsComment = bbsMapper.selectCommentList(searchVO);
		
		System.out.println(bbsComment.toString());
		return bbsComment;
		
	}
	
	/**
	 * 공지사항 조회(팝업) - 파일이름
	 * @param workbook
	 * @param fileName
	 * @return
	 */
	@RequestMapping(path="/popup/fileName", method = RequestMethod.POST)
	public List<BbsMgt> noticeFileList(@RequestBody BbsMgt searchVO,
    		ModelMap model, HttpServletRequest request) throws Exception {
		
		List<BbsMgt> bbsMgt = bbsMapper.selectFileName(searchVO);
		/*ModelMap bbsMgt = bbsMapper.selectFileName(searchVO);*/
		
		return bbsMgt;
		
	}
	
	/**
	 * 공지사항 조회(팝업) - 댓글 저장
	 * @param workbook
	 * @param fileName
	 * @return
	 */
	@RequestMapping(path="/popup/noticeReplyInsert", method = RequestMethod.POST)
	public long replyInsert(@RequestBody BbsComment searchVO,
    		ModelMap model, HttpServletRequest request){
 
		long result;
		try{
			result = bbsMapper.insertReply(searchVO);		
		}catch(Exception e){
			result = 0;
			e.printStackTrace();
		}
		return result;
	}
	
	
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
	public long councellerInsert(@RequestBody Torganization searchVO,
    		ModelMap model, HttpServletRequest request){
 
		long result;
		try{
			result = torganizationMapper.insertCounceller(searchVO);		
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
	public long councellerDelete(@RequestBody Torganization searchVO,
    		ModelMap model, HttpServletRequest request) {
 
		long result;
		try{
			result = torganizationMapper.deleteCounceller(searchVO);	
		}catch(Exception e){
			result = 0;
		}
		return result;
	}
	
	/**
	 * 상담원관리(팝업) - 비번초기화 버튼
	 * @param workbook
	 * @param fileName
	 * @return
	 */
	@RequestMapping(path="/popup/councellerUpdate", method = RequestMethod.POST)
	public long councellerUpdate(@RequestBody Torganization searchVO,
    		ModelMap model, HttpServletRequest request) {
 
		long result;
		try{
			result = torganizationMapper.updateCounceller(searchVO);	
		}catch(Exception e){
			result = 0;
		}
		return result;
	}
	
	/**
	 * SMS전송유형(팝업)
	 * @param workbook
	 * @param fileName
	 * @return
	 */
	@RequestMapping(path="/popup/smsList", method = RequestMethod.POST)
	public List<SmsCategory> noticeList(ModelMap model, HttpServletRequest request) throws Exception {
		List<SmsCategory> smsCategory = smsCategoryMapper.selectSmsList();
				
		return smsCategory;
		
	}
	
	/**
	 * SMS전송유형(팝업)
	 * @param workbook
	 * @param fileName
	 * @return
	 */
	@RequestMapping(path="/popup/smsOne", method = RequestMethod.POST)
	public SmsCategory smsOne(@RequestBody SmsCategory searchVO,
			ModelMap model, HttpServletRequest request) throws Exception {
		
		SmsCategory smsCategory = smsCategoryMapper.selectSmsOne(searchVO);
		
		return smsCategory;
		
	}
	
	/**
	 * SMS전송유형(팝업) - 저장
	 * @param workbook
	 * @param fileName
	 * @return
	 * @throws IOException 
	 */
	@RequestMapping(path="/popup/saveSms", method = RequestMethod.POST)
	public long saveSms(@RequestBody SmsCategory searchVO,
    		ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		
		long result;
		try{
			result = smsCategoryMapper.insertSms(searchVO);			
		}catch(Exception e){
			result = 0;
		}		
		return result;
		
	}
	
	@RequestMapping(value = "/popup/uploadFile", method = RequestMethod.POST)
	public String insert(MultipartHttpServletRequest request, ModelMap model){
	Map<String, MultipartFile> files = request.getFileMap();
	CommonsMultipartFile cmf = (CommonsMultipartFile) files.get("uploadFile");
	// 경로
	String path ="c:/uploadTest/"+cmf.getOriginalFilename();

	System.out.println("=============================================================" + path);
	File file = new File(path);
	try {
		// 파일 업로드 처리 완료.
		cmf.transferTo(file);
		// insert method
		model.addAttribute("resMessage", "업로드 성공"); 
	} catch (Exception e) {
		model.addAttribute("resMessage", "업로드 실패"); 
	}
		return "/popup/notice";
	}
	
}
