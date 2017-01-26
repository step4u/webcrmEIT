package com.coretree.defaultconfig.main.controller;



import java.io.File;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coretree.crypto.CryptoAES;
import com.coretree.defaultconfig.EitDateUtil;
import com.coretree.defaultconfig.statis.mapper.RecordMgtMapper;
import com.coretree.defaultconfig.statis.model.RecordMgt;
import com.coretree.exceptions.CryptoException;

/**
 * Test를 위한 컨트롤러 클래스
 * 
 * @author hsw
 *
 */
@RestController
public class RecordMgtController {
	
	@Autowired
	RecordMgtMapper recmgtmapper;

/*	@RequestMapping(path = "/main/selectSms", method = RequestMethod.POST)
	public List<Sms> selectSms(@RequestBody Sms paramSms,HttpSession session) throws Exception {
    	
		List<Sms> sms = smsMapper.selectSms(paramSms);

		return sms;
	}
*/
	
/*
	@RequestMapping(path="/main/{filename}", method=RequestMethod.GET)
	public byte[] getStream2(@PathVariable("filename") String fn) throws CryptoException {

	byte[] out = null;
		try {
			//private final String UPLOADPATH = "D:\\";
			String filename = "/opt/webcrm/media/"+EitDateUtil.formatDate(EitDateUtil.getToday(), "-")+"/" + fn + ".encrypted";
			//			String filename = "D:///test2/" + fn + ".encrypted";
			System.out.println("Test====>"+filename);
			File file = new File(filename);
			String key = "Mary has one cat";
			out = CryptoAES.decrypt(key, file);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return out;
	}
*/
	
	@RequestMapping(path="/main/{seq}", method=RequestMethod.GET)
	public byte[] getStream2(@PathVariable("seq") int seq) throws CryptoException {

	byte[] out = null;
		try {
			// String fn = recmgtmapper.getRecFn(seq).replace(".wav", ".encrypted");
			// String fn = recmgtmapper.getRecFn(seq) + ".encrypted";
			RecordMgt recmgt = recmgtmapper.getRecFn(seq);
			String fn = String.format("/opt/webcrm/media/%s/%s", EitDateUtil.formatDate(recmgt.getRecStartDate(), "-"), recmgt.getFileName() + ".encrypted");
			
			File file = new File(fn);
			String key = "Mary has one cat";
			out = CryptoAES.decrypt(key, file);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return out;
	}
}
