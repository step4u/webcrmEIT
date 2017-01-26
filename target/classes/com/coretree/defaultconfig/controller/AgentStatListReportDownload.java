package com.coretree.defaultconfig.controller;

import java.net.URLEncoder;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFPalette;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.hssf.util.Region;
import org.springframework.web.servlet.view.document.AbstractExcelView;

import com.coretree.defaultconfig.EitDateUtil;
import com.coretree.defaultconfig.EitReportStyleUtil;

public class AgentStatListReportDownload extends AbstractExcelView {

	@Override
	protected void buildExcelDocument(Map<String, Object> model,
			HSSFWorkbook wb, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// TODO Auto-generated method stub

		try {
			/**
			 * 현재 컨드롤 되어지는 행번호
			 */
			int rownum = 0;
			/**
			 * 지금까지 총 컨트롤한 행수
			 */
			int rowcnt = 0;
			/**
			 * 합계가 들어갈 행번호
			 */
			int sum_rownum = 0;
			/**
			 * 셀병합시(세로병합)에서 시작되는 행번호
			 */
			int mer_st_rownum = 0;

			EitReportStyleUtil style = new EitReportStyleUtil();
			JSONArray agentStatList = JSONArray.fromObject(model.get("agentStatList"));
			String empNm2 = model.get("empNm2").toString();
	
			// GREY_25_PERCENT의 인텍스 값에 대한 REG속성 값을 변경
			HSSFPalette palette = wb.getCustomPalette();
			palette.setColorAtIndex(HSSFColor.GREY_25_PERCENT.index,
					(byte) 242, (byte) 242, (byte) 242);
	
			HSSFSheet sheet = wb.createSheet("상담원 통계현황 리스트");

			sheet.setColumnWidth((short) 0, (short) 8 * 300);
			sheet.setColumnWidth((short) 1, (short) 15 * 300);
			sheet.setColumnWidth((short) 2, (short) 15 * 300);
			for (int i=3; i<=13; i++){
				sheet.setColumnWidth((short) i, (short) 10 * 300);
			}
			
			/**
			* 헤더 폰트
			* 폰트 높이는 24, 폰트 종류는 Courier New, 이탈릭체로 설정한다
			*/
	
			HSSFDataFormat df = wb.createDataFormat();
			
			HSSFFont hFont = style.getFont(wb, "맑은 고딕", (short) 20, HSSFFont.BOLDWEIGHT_BOLD);
			
			/**
			* 본문 타이틀 폰트
			*/
			HSSFFont tiFont = style.getFont(wb, "맑은 고딕", (short) 10, HSSFFont.BOLDWEIGHT_BOLD);
	
			/**
			* 본문 내용 폰트
			*/
			HSSFFont cFont = style.getFont(wb, "맑은 고딕", (short) 10, HSSFFont.BOLDWEIGHT_NORMAL);
	
			/**
			 * 본문 상세 스타일
			 */
			HSSFFont taFont = style.getFont(wb, "맑은 고딕", (short) 8, HSSFFont.BOLDWEIGHT_NORMAL);
			
			/**
			* 헤더 셀스타일
			*/
			HSSFCellStyle hStyle = style.getHeaderStyle(wb, hFont, HSSFCellStyle.ALIGN_CENTER, HSSFCellStyle.VERTICAL_CENTER, 
					HSSFCellStyle.BORDER_MEDIUM, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_MEDIUM, HSSFCellStyle.BORDER_MEDIUM, 
					df.getFormat(DEFAULT_CONTENT_TYPE));
			
			/**
			* 타이틀 _텍스트_가운데정렬_테두리위아래
			*/
			HSSFCellStyle Ti_T_C_Ttb_style = style.getTitleStyle(wb, tiFont, HSSFCellStyle.ALIGN_CENTER, HSSFCellStyle.VERTICAL_CENTER, 
					HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_NONE, HSSFCellStyle.BORDER_NONE, 
					df.getFormat(DEFAULT_CONTENT_TYPE) );
			
			/**
			* 타이틀 _텍스트_가운데정렬_테두리위아래, 왼쪽테두리 굵은선
			*/
			HSSFCellStyle Ti_T_C_Ml_style = style.getTitleStyle(wb, tiFont, HSSFCellStyle.ALIGN_CENTER, HSSFCellStyle.VERTICAL_CENTER, 
					HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_MEDIUM, HSSFCellStyle.BORDER_NONE, 
					df.getFormat(DEFAULT_CONTENT_TYPE) );
	
			/**
			* 타이틀 _텍스트_수직정렬위_테두리위아래, 왼쪽테두리 굵은선
			*/
			HSSFCellStyle Ti_T_T_Ml_style = style.getTitleStyle(wb, tiFont, HSSFCellStyle.ALIGN_CENTER, HSSFCellStyle.VERTICAL_TOP, 
					HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_MEDIUM, HSSFCellStyle.BORDER_NONE, 
					df.getFormat(DEFAULT_CONTENT_TYPE) );
			
			/**
			* 타이틀 _텍스트_가운데정렬_테두리위아래, 오른쪽테두리 굵은선
			*/
			HSSFCellStyle Ti_T_C_Mr_style = style.getTitleStyle(wb, tiFont, HSSFCellStyle.ALIGN_CENTER, HSSFCellStyle.VERTICAL_CENTER, 
					HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_NONE, HSSFCellStyle.BORDER_MEDIUM, 
					df.getFormat(DEFAULT_CONTENT_TYPE) );
			
			/**
			* 타이틀 _텍스트_가운데정렬_테두리전체, 굵은선
			*/
			HSSFCellStyle Ti_T_C_M_style = style.getTitleStyle(wb, tiFont, HSSFCellStyle.ALIGN_CENTER, HSSFCellStyle.VERTICAL_CENTER, 
					HSSFCellStyle.BORDER_MEDIUM, HSSFCellStyle.BORDER_MEDIUM, HSSFCellStyle.BORDER_MEDIUM, HSSFCellStyle.BORDER_MEDIUM, 
					df.getFormat(DEFAULT_CONTENT_TYPE) );
			
			/**
			* 타이틀 _텍스트_왼쪽정렬_테두리 위아래
			*/
			HSSFCellStyle Ti_T_L_Ttbl_style = style.getTitleStyle(wb, tiFont, HSSFCellStyle.ALIGN_LEFT, HSSFCellStyle.VERTICAL_CENTER, 
					HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_NONE, 
					df.getFormat(DEFAULT_CONTENT_TYPE) );
	
			/**
			* 타이틀 _텍스트_가운데정렬_테두리 전체
			*/
			HSSFCellStyle Ti_T_C_T_style = style.getTitleStyle(wb, tiFont, HSSFCellStyle.ALIGN_CENTER, HSSFCellStyle.VERTICAL_CENTER, 
					HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, 
					df.getFormat(DEFAULT_CONTENT_TYPE) ); 
	
			/**
			* 타이틀(본문폰트) _텍스트_오른쪽정렬_테두리 위아래.
			*/
			HSSFCellStyle Ti_T_R_Ttb_style = style.getTitleStyle(wb, cFont, HSSFCellStyle.ALIGN_RIGHT, HSSFCellStyle.VERTICAL_CENTER, 
					HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_NONE, HSSFCellStyle.BORDER_NONE, 
					df.getFormat(DEFAULT_CONTENT_TYPE) );
	
			/**
			* 타이틀_숫자_오른쪽정렬_테두리전체
			*/
			HSSFCellStyle Ti_N_R_Mr_style = style.getTitleStyle(wb, tiFont, HSSFCellStyle.ALIGN_CENTER, HSSFCellStyle.VERTICAL_CENTER, 
					HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_MEDIUM, 
					df.getFormat("####.##%") );
	
			/**
			* 타이틀_회(원)_오른쪽정렬_테두리전체
			*/
			HSSFCellStyle Ti_AK_R_T_style = style.getTitleStyle(wb, tiFont, HSSFCellStyle.ALIGN_RIGHT, HSSFCellStyle.VERTICAL_CENTER, 
					HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, 
					df.getFormat("###,###,##0") );
	
			/**
			* 본문_텍스트_가운데정렬_테두리전체
			*/
			HSSFCellStyle C_T_C_T_style = style.getContentsStyle(wb, cFont, HSSFCellStyle.ALIGN_CENTER, HSSFCellStyle.VERTICAL_CENTER, 
					HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, 
					df.getFormat(DEFAULT_CONTENT_TYPE) );
			
			/**
			 * 본문_텍스트_가운데정렬_테두리전체
			 */
			HSSFCellStyle C_T_L_T_style = style.getContentsStyle(wb, cFont, HSSFCellStyle.ALIGN_LEFT, HSSFCellStyle.VERTICAL_CENTER, 
					HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, 
					df.getFormat(DEFAULT_CONTENT_TYPE) );
	
			/**
			* 본문_텍스트_가운데정렬_테두리전체, 오른쪽 굵은선
			*/
			HSSFCellStyle C_T_C_Mr_style = style.getContentsStyle(wb, cFont, HSSFCellStyle.ALIGN_CENTER, HSSFCellStyle.VERTICAL_CENTER, 
					HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_MEDIUM, 
					df.getFormat(DEFAULT_CONTENT_TYPE) );
	
			/**
			* 본문_텍스트_가운데정렬_테두리전체, 왼쪽 굵은선
			*/
			HSSFCellStyle C_T_C_Ml_style = style.getContentsStyle(wb, cFont, HSSFCellStyle.ALIGN_CENTER, HSSFCellStyle.VERTICAL_CENTER, 
					HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_MEDIUM, HSSFCellStyle.BORDER_THIN, 
					df.getFormat(DEFAULT_CONTENT_TYPE) );
	
			/**
			* 본문_텍스트_가운데정렬_테두리전체, 위아래가는선, 오른쪽왼쪽 굵은선
			*/
			HSSFCellStyle C_T_C_Mlr_style = style.getContentsStyle(wb, cFont, HSSFCellStyle.ALIGN_CENTER, HSSFCellStyle.VERTICAL_CENTER, 
					HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_MEDIUM, HSSFCellStyle.BORDER_MEDIUM, 
					df.getFormat(DEFAULT_CONTENT_TYPE) );
	
			/**
			* 본문_텍스트_가운데정렬_테두리전체, 위,오른쪽가는선, 왼쪽,아래 굵은선
			*/
			HSSFCellStyle C_T_C_Mblr_style = style.getContentsStyle(wb, cFont, HSSFCellStyle.ALIGN_CENTER, HSSFCellStyle.VERTICAL_CENTER, 
					HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_MEDIUM, HSSFCellStyle.BORDER_MEDIUM, HSSFCellStyle.BORDER_MEDIUM, 
					df.getFormat(DEFAULT_CONTENT_TYPE) );
	
			/**
			 * 본문_텍스트_왼쪽정렬_테두리전체, 오른쪽굵은선
			 */
			HSSFCellStyle C_T_L_Mr_style = style.getContentsStyle(wb, cFont, HSSFCellStyle.ALIGN_LEFT, HSSFCellStyle.VERTICAL_CENTER, 
					HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_MEDIUM, 
					df.getFormat(DEFAULT_CONTENT_TYPE) );
	
			/**
			 * 본문_텍스트_왼쪽정렬_테두리전체, 아래, 왼쪽 굵은선
			 */
			HSSFCellStyle C_T_C_Mbl_style = style.getContentsStyle(wb, cFont, HSSFCellStyle.ALIGN_LEFT, HSSFCellStyle.VERTICAL_CENTER, 
					HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_MEDIUM, HSSFCellStyle.BORDER_MEDIUM, HSSFCellStyle.BORDER_THIN, 
					df.getFormat(DEFAULT_CONTENT_TYPE) );
	
			/**
			 * 본문_텍스트_왼쪽정렬_테두리전체, 아래, 오른쪽 굵은선
			 */
			HSSFCellStyle C_T_C_Mbr_style = style.getContentsStyle(wb, cFont, HSSFCellStyle.ALIGN_LEFT, HSSFCellStyle.VERTICAL_CENTER, 
					HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_MEDIUM, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_MEDIUM, 
					df.getFormat(DEFAULT_CONTENT_TYPE) );
	
			/**
			 * 본문_텍스트_왼쪽정렬_테두리전체, 아래 굵은선
			 */
			HSSFCellStyle C_T_C_Mb_style = style.getContentsStyle(wb, cFont, HSSFCellStyle.ALIGN_LEFT, HSSFCellStyle.VERTICAL_CENTER, 
					HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_MEDIUM, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, 
					df.getFormat(DEFAULT_CONTENT_TYPE) );
	
	
			/**
			 * 본문_숫자_오른쪽정렬_테두리전체
			 */
			HSSFCellStyle C_N_R_T_style = style.getContentsStyle(wb, cFont, HSSFCellStyle.ALIGN_RIGHT, HSSFCellStyle.VERTICAL_CENTER, 
					HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, 
					df.getFormat(DEFAULT_CONTENT_TYPE));
	
			/**s
			 * 본문_회계(원)_오른쪽정렬_테두리전체
			 */
			HSSFCellStyle C_AK_R_T_style = style.getContentsStyle(wb, cFont, HSSFCellStyle.ALIGN_RIGHT, HSSFCellStyle.VERTICAL_CENTER, 
					HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, 
					df.getFormat("###,###,##0") ); 
	
			/**
			 * 본문_회계(달러)_오른쪽정렬_테두리전체
			 */
			HSSFCellStyle C_AU_R_T_style = style.getContentsStyle(wb, cFont, HSSFCellStyle.ALIGN_CENTER, HSSFCellStyle.VERTICAL_CENTER, 
					HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, 
					df.getFormat("$#,##0.##") );
	
			/**
			 * 본문_날짜_가운데정렬_테두리전체
			 */
			HSSFCellStyle C_D_C_T_style = style.getContentsStyle(wb, cFont, HSSFCellStyle.ALIGN_CENTER, HSSFCellStyle.VERTICAL_CENTER, 
					HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, 
					df.getFormat("yyyy-mm-dd") );
	
			/**
			 * 꼬리말(본문비고)_텍스트_가운데정렬_테두리전체
			 */
			HSSFCellStyle Ta_T_R_T_style = style.getTailStyle(wb, taFont, HSSFCellStyle.ALIGN_RIGHT, HSSFCellStyle.VERTICAL_CENTER, 
					HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, HSSFCellStyle.BORDER_THIN, 
					df.getFormat(DEFAULT_CONTENT_TYPE) );
	
			HSSFRow row = null;
			HSSFCell cell = null;
			rownum = 0;
			
			/*************** 헤더 ***************/
			// 설정한 폰트를 스타일에 적용한다
			row = sheet.createRow(rownum);
			
			row.setHeight((short) (7 * 25));

			rownum = rownum + 1;
			
			row = sheet.createRow(rownum);
			cell = row.createCell(0);
			
			row.setHeight((short) (32.35 * 25));

			for (int c = 0; c <= 16; c++) {
				cell = row.createCell(c);
				cell.setCellValue("상담원 통계현황 리스트");
				cell.setCellStyle(hStyle);
			}
			sheet.addMergedRegion(new Region((short) rownum, (short) 0, (short) rownum, (short) 16));

			rownum = rownum + 1;
			
			row = sheet.createRow(rownum);

			for (int c = 0; c <= 1; c++) {
				cell = row.createCell(c);
				cell.setCellValue("출력일");
				cell.setCellStyle(C_D_C_T_style);
			}
			sheet.addMergedRegion(new Region((short) rownum, (short) 0, (short) rownum, (short) 1));

			for (int c = 2; c <= 4; c++) {
				cell = row.createCell(c);
				cell.setCellStyle(C_D_C_T_style);
				cell.setCellValue(EitDateUtil.formatDate(EitDateUtil.getToday(),"-") +" "+EitDateUtil.formatTime2(EitDateUtil.getTotime(),":"));
			}
			sheet.addMergedRegion(new Region((short) rownum, (short) 2, (short) rownum, (short) 4));

			rownum = rownum + 1;
			
			row = sheet.createRow(rownum);
			
			for (int c = 0; c <= 1; c++) {
				cell = row.createCell(c);
				cell.setCellValue("출력자");
				cell.setCellStyle(C_D_C_T_style);
			}
			sheet.addMergedRegion(new Region((short) rownum, (short) 0, (short) rownum, (short) 1));

			for (int c = 2; c <= 4; c++) {
				cell = row.createCell(c);
				cell.setCellStyle(C_D_C_T_style);
				cell.setCellValue(empNm2);
			}
			sheet.addMergedRegion(new Region((short) rownum, (short) 2, (short) rownum, (short) 4));

			rownum = rownum + 2;
			row = sheet.createRow(rownum);
			
			cell = row.createCell(0);
			cell.setCellValue("SEQ");
			cell.setCellStyle(Ti_T_C_T_style);
			sheet.addMergedRegion(new Region((short) rownum, (short) 0, (short) rownum+1, (short) 0));
			
			cell = row.createCell(1);
			cell.setCellValue("일자");
			cell.setCellStyle(Ti_T_C_T_style);
			sheet.addMergedRegion(new Region((short) rownum, (short) 1, (short) rownum+1, (short) 1));
			
			cell = row.createCell(2);
			cell.setCellValue("상담원");
			cell.setCellStyle(Ti_T_C_T_style);
			sheet.addMergedRegion(new Region((short) rownum, (short) 2, (short) rownum+1, (short) 2));
			
			
			for (int c = 3; c <= 4; c++) {
				cell = row.createCell(c);
				cell.setCellStyle(Ti_T_C_T_style);
				cell.setCellValue("인바운드");
			}
			sheet.addMergedRegion(new Region((short) rownum, (short) 3, (short) rownum, (short) 4));
			
			for (int c = 5; c <= 6; c++) {
				cell = row.createCell(c);
				cell.setCellStyle(Ti_T_C_T_style);
				cell.setCellValue("아웃바운드");
			}
			sheet.addMergedRegion(new Region((short) rownum, (short) 5, (short) rownum, (short) 6));
			
			for (int c = 7; c <= 8; c++) {
				cell = row.createCell(c);
				cell.setCellStyle(Ti_T_C_T_style);
				cell.setCellValue("내선통화");
			}
			sheet.addMergedRegion(new Region((short) rownum, (short) 7, (short) rownum, (short) 8));
			
			for (int c = 9; c <= 13; c++) {
				cell = row.createCell(c);
				cell.setCellStyle(Ti_T_C_T_style);
				cell.setCellValue("상담원상태");
			}
			sheet.addMergedRegion(new Region((short) rownum, (short) 9, (short) rownum, (short) 13));
			
			cell = row.createCell(14);
			cell.setCellValue("콜백");
			cell.setCellStyle(Ti_T_C_T_style);
			sheet.addMergedRegion(new Region((short) rownum, (short) 14, (short) rownum+1, (short) 14));
			
			cell = row.createCell(15);
			cell.setCellValue("예약");
			cell.setCellStyle(Ti_T_C_T_style);
			sheet.addMergedRegion(new Region((short) rownum, (short) 15, (short) rownum+1, (short) 15));
			
			cell = row.createCell(16);
			cell.setCellValue("SMS");
			cell.setCellStyle(Ti_T_C_T_style);
			sheet.addMergedRegion(new Region((short) rownum, (short) 16, (short) rownum+1, (short) 16));
			
			row = sheet.createRow(6); 
			
			cell = row.createCell(0);
			cell.setCellStyle(Ti_T_C_T_style);
			
			cell = row.createCell(1);
			cell.setCellStyle(Ti_T_C_T_style);
			
			cell = row.createCell(2);
			cell.setCellStyle(Ti_T_C_T_style);
			
			cell = row.createCell(3);
			cell.setCellValue("건수");
			cell.setCellStyle(Ti_T_C_T_style);

			cell = row.createCell(4);
			cell.setCellValue("시간");
			cell.setCellStyle(Ti_T_C_T_style);
			
			cell = row.createCell(5);
			cell.setCellValue("건수");
			cell.setCellStyle(Ti_T_C_T_style);
			
			cell = row.createCell(6);
			cell.setCellValue("시간");
			cell.setCellStyle(Ti_T_C_T_style);
			
			cell = row.createCell(7);
			cell.setCellValue("건수");
			cell.setCellStyle(Ti_T_C_T_style);
			
			cell = row.createCell(8);
			cell.setCellValue("시간");
			cell.setCellStyle(Ti_T_C_T_style);
			
			cell = row.createCell(9);
			cell.setCellValue("대기");
			cell.setCellStyle(Ti_T_C_T_style);
			
			cell = row.createCell(10);
			cell.setCellValue("후처리");
			cell.setCellStyle(Ti_T_C_T_style);
			
			cell = row.createCell(11);
			cell.setCellValue("이석");
			cell.setCellStyle(Ti_T_C_T_style);
			
			cell = row.createCell(12);
			cell.setCellValue("휴식");
			cell.setCellStyle(Ti_T_C_T_style);
			
			cell = row.createCell(13);
			cell.setCellValue("교육");
			cell.setCellStyle(Ti_T_C_T_style);
			
			cell = row.createCell(14);
			cell.setCellStyle(Ti_T_C_T_style);
			
			cell = row.createCell(15);
			cell.setCellStyle(Ti_T_C_T_style);
			
			cell = row.createCell(16);
			cell.setCellStyle(Ti_T_C_T_style);
			
			rownum = 7;

			int j = 1;
			//총계 계산을 위한 변수
			int nInbound = 0;
			int tInbound = 0;
			int nOutbound = 0;
			int tOutbound = 0;
			int nExtension = 0;
			int tExtension = 0;
			int nCallback = 0;
			int nReservation = 0;
			int nSms = 0;
			int tAgentStat1011 = 0;
			int tAgentStat1012 = 0;
			int tAgentStat1013 = 0;
			int tAgentStat1014 = 0;
			int tAgentStat1015 = 0;
			
			
			for (int i = 0; i < agentStatList.size(); i++) {
			row = sheet.createRow(rownum);
			
			tInbound = agentStatList.getJSONObject(i).getInt("tInbound") + tInbound;
			tOutbound = agentStatList.getJSONObject(i).getInt("tOutbound") + tOutbound;
			tExtension = agentStatList.getJSONObject(i).getInt("tExtension") + tExtension;
			tAgentStat1011 = agentStatList.getJSONObject(i).getInt("tAgentStat1011") + tAgentStat1011;
			tAgentStat1012 = agentStatList.getJSONObject(i).getInt("tAgentStat1012") + tAgentStat1012;
			tAgentStat1013 = agentStatList.getJSONObject(i).getInt("tAgentStat1013") + tAgentStat1013;
			tAgentStat1014 = agentStatList.getJSONObject(i).getInt("tAgentStat1014") + tAgentStat1014;
			tAgentStat1015 = agentStatList.getJSONObject(i).getInt("tAgentStat1015") + tAgentStat1015;
			
			cell = row.createCell(0);
			cell.setCellValue(j);
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(1);
			cell.setCellValue(agentStatList.getJSONObject(i).getString("regDate"));
			cell.setCellStyle(C_D_C_T_style);
			
			cell = row.createCell(2);
			cell.setCellValue(agentStatList.getJSONObject(i).getString("empNm"));
			cell.setCellStyle(C_D_C_T_style);
			
			cell = row.createCell(3);
			cell.setCellValue(agentStatList.getJSONObject(i).getInt("nInbound"));
			cell.setCellStyle(C_N_R_T_style);
			nInbound = agentStatList.getJSONObject(i).getInt("nInbound") + nInbound;
			
			cell = row.createCell(4);
			cell.setCellValue(agentStatList.getJSONObject(i).getString("tInboundFmt"));
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(5);
			cell.setCellValue(agentStatList.getJSONObject(i).getInt("nOutbound"));
			cell.setCellStyle(C_N_R_T_style);
			nOutbound = agentStatList.getJSONObject(i).getInt("nOutbound") + nOutbound;
			
			cell = row.createCell(6);
			cell.setCellValue(agentStatList.getJSONObject(i).getString("tOutboundFmt"));
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(7);
			cell.setCellValue(agentStatList.getJSONObject(i).getInt("nExtension"));
			cell.setCellStyle(C_N_R_T_style);
			nExtension = agentStatList.getJSONObject(i).getInt("nExtension") + nExtension;
			
			cell = row.createCell(8);
			cell.setCellValue(agentStatList.getJSONObject(i).getString("tExtensionFmt"));
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(9);
			cell.setCellValue(agentStatList.getJSONObject(i).getString("tAgentStat1011Fmt"));
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(10);
			cell.setCellValue(agentStatList.getJSONObject(i).getString("tAgentStat1012Fmt"));
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(11);
			cell.setCellValue(agentStatList.getJSONObject(i).getString("tAgentStat1013Fmt"));
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(12);
			cell.setCellValue(agentStatList.getJSONObject(i).getString("tAgentStat1014Fmt"));
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(13);
			cell.setCellValue(agentStatList.getJSONObject(i).getString("tAgentStat1015Fmt"));
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(14);
			cell.setCellValue(agentStatList.getJSONObject(i).getInt("nCallback"));
			cell.setCellStyle(C_N_R_T_style);
			nCallback = agentStatList.getJSONObject(i).getInt("nCallback") + nCallback;
			
			cell = row.createCell(15);
			cell.setCellValue(agentStatList.getJSONObject(i).getInt("nReservation"));
			cell.setCellStyle(C_N_R_T_style);
			nReservation = agentStatList.getJSONObject(i).getInt("nReservation") + nReservation;
			
			cell = row.createCell(16);
			cell.setCellValue(agentStatList.getJSONObject(i).getInt("nSms"));
			cell.setCellStyle(C_N_R_T_style);
			nSms = agentStatList.getJSONObject(i).getInt("nSms") + nSms;
			
			rownum = rownum + 1;
			j = j + 1;
			}
			
			row = sheet.createRow(rownum);
			j = j + 1;
			
			String tInboundFmt = time(tInbound);
			String tOutboundFmt = time(tOutbound);
			String tExtensionFmt = time(tExtension);
			String tAgentStat1011Fmt = time(tAgentStat1011);
			String tAgentStat1012Fmt = time(tAgentStat1012);
			String tAgentStat1013Fmt = time(tAgentStat1013);
			String tAgentStat1014Fmt = time(tAgentStat1014);
			String tAgentStat1015Fmt = time(tAgentStat1015);
			
			for (int c = 0; c <= 2; c++) {
				cell = row.createCell(c);
				cell.setCellStyle(Ti_T_C_T_style);
				cell.setCellValue("총계");
			}
			sheet.addMergedRegion(new Region((short) rownum, (short) 0, (short) rownum, (short) 2));
			
			cell = row.createCell(3);
			cell.setCellValue(nInbound);
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(4);
			cell.setCellValue(tInboundFmt);
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(5);
			cell.setCellValue(nOutbound);
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(6);
			cell.setCellValue(tOutboundFmt);
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(7);
			cell.setCellValue(nExtension);
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(8);
			cell.setCellValue(tExtensionFmt);
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(9);
			cell.setCellValue(tAgentStat1011Fmt);
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(10);
			cell.setCellValue(tAgentStat1012Fmt);
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(11);
			cell.setCellValue(tAgentStat1013Fmt);
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(12);
			cell.setCellValue(tAgentStat1014Fmt);
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(13);
			cell.setCellValue(tAgentStat1015Fmt);
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(14);
			cell.setCellValue(nCallback);
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(15);
			cell.setCellValue(nReservation);
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(16);
			cell.setCellValue(nSms);
			cell.setCellStyle(C_N_R_T_style);
			
			rownum = rownum + 1;
			row = sheet.createRow(rownum);
			j = j + 1;
			
			//평균 계산을 위한 변수
			int size = agentStatList.size();
			int avg_nInbound = nInbound / size;
			int avg_tInbound = tInbound / size;
			int avg_nOutbound = nOutbound / size;
			int avg_tOutbound = tOutbound / size;
			int avg_nExtension = nExtension / size;
			int avg_tExtension = tExtension / size;
			int avg_nCallback = nCallback / size;
			int avg_nReservation = nReservation / size;
			int avg_nSms = nSms / size;
			int avg_tAgentStat1011 = tAgentStat1011 / size;
			int avg_tAgentStat1012 = tAgentStat1012 / size;
			int avg_tAgentStat1013 = tAgentStat1013 / size;
			int avg_tAgentStat1014 = tAgentStat1014 / size;
			int avg_tAgentStat1015 = tAgentStat1015 / size;
			
			String avg_tInboundFmt = time(avg_tInbound);
			String avg_tOutboundFmt = time(avg_tOutbound);
			String avg_tExtensionFmt = time(avg_tExtension);
			String avg_tAgentStat1011Fmt = time(avg_tAgentStat1011);
			String avg_tAgentStat1012Fmt = time(avg_tAgentStat1012);
			String avg_tAgentStat1013Fmt = time(avg_tAgentStat1013);
			String avg_tAgentStat1014Fmt = time(avg_tAgentStat1014);
			String avg_tAgentStat1015Fmt = time(avg_tAgentStat1015);
			
			for (int c = 0; c <= 2; c++) {
				cell = row.createCell(c);
				cell.setCellStyle(Ti_T_C_T_style);
				cell.setCellValue("평균");
			}
			sheet.addMergedRegion(new Region((short) rownum, (short) 0, (short) rownum, (short) 2));
			
			cell = row.createCell(3);
			cell.setCellValue(avg_nInbound);
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(4);
			cell.setCellValue(avg_tInboundFmt);
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(5);
			cell.setCellValue(avg_nOutbound);
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(6);
			cell.setCellValue(avg_tOutboundFmt);
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(7);
			cell.setCellValue(avg_nExtension);
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(8);
			cell.setCellValue(avg_tExtensionFmt);
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(9);
			cell.setCellValue(avg_tAgentStat1011Fmt);
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(10);
			cell.setCellValue(avg_tAgentStat1012Fmt);
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(11);
			cell.setCellValue(avg_tAgentStat1013Fmt);
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(12);
			cell.setCellValue(avg_tAgentStat1014Fmt);
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(13);
			cell.setCellValue(avg_tAgentStat1015Fmt);
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(14);
			cell.setCellValue(avg_nCallback);
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(15);
			cell.setCellValue(avg_nReservation);
			cell.setCellStyle(C_N_R_T_style);
			
			cell = row.createCell(16);
			cell.setCellValue(avg_nSms);
			cell.setCellStyle(C_N_R_T_style);
			
			/**
			 * 파일 다운로드 시작.
			 **/
			
			logger.debug("상담원 통계 현황 다운로드 완료.");
			
			String fileName = EitDateUtil.getToday()
					+ EitDateUtil.getTotime() + "_상담원통계현황리스트.xls";
			response.setContentType("application/x-download");
			response.setHeader("Content-Disposition", "attachment; filename="
					+URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20"));
					//+ new String(fileName.getBytes(), "euc-kr"));
			
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public String time(int param){
		int hours = param / 3600;//시 공식
        int minute = param % 3600 / 60;//분을 구하기위해서 입력되고 남은값에서 또 60을 나눈다.
        int second = param % 3600 % 60;
        
        String hours2, minute2, second2;
        
        if(hours < 10){
        	hours2 = "0" + hours;
        }else{
        	hours2 = String.valueOf(hours);
        }
        
        if(minute < 10){
        	minute2 = "0" + minute;
        }else{
        	minute2 = String.valueOf(minute);
        }
        
        if(second < 10){
        	second2 = "0" + second;
        }else{
        	second2 = String.valueOf(second);
        }
        
        String result = hours2+":"+minute2+":"+second2;
        return result;
	}
}
