/*작성자 : 송은미*/
package com.coretree.defaultconfig.controller;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.coretree.defaultconfig.main.model.Customer;



@RestController
public class ExcelController {
	/**
	 * 엑셀로 고객정보 저장 - 엑셀 선택 버튼(팝업)
	 * @param workbook
	 * @param fileName
	 * @return
	 */
	@RequestMapping(path = "/popup/read_xlsx", method = RequestMethod.POST)
	public List<Customer> readXlsx(@RequestBody String excelroot) {
		
		String rootlength = excelroot;
		System.out.println("==================================================" + excelroot);
		String root = rootlength.substring(1, rootlength.length()-1);
		
		List<Customer> cutomer = null;

		// 워크북 생성
		Workbook workbook = null;
		FileInputStream fis = null;
		try {
			fis = new FileInputStream(root);
			workbook = new XSSFWorkbook(fis);
			
			cutomer = readExcelFile(workbook);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				if (fis != null) fis.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		return cutomer;
	}
	
	/**
	 * 엑셀에 저장된 데이터를 읽어온다.
	 * @param workbook
	 * @param fileName
	 * @return
	 */
	public List<Customer> readExcelFile(Workbook workbook) {
		
		List<Customer> customer = new ArrayList<Customer>();
		
		// 워크시트
		Sheet curSheet;
		// 행
		Row curRow;
		// 셀
		Cell curCell;
		
		int numberOfSheets = workbook.getNumberOfSheets();
		System.out.println("numberOfSheets = " + numberOfSheets);
		
		for (int sheetIndex = 0; sheetIndex < numberOfSheets; sheetIndex++) {
			curSheet = workbook.getSheetAt(sheetIndex);
			
			int physicalNumberOfRows = curSheet.getPhysicalNumberOfRows();
			System.out.println("physicalNumberOfRows = " + physicalNumberOfRows);
			for (int rowIndex = 1; rowIndex < physicalNumberOfRows; rowIndex++) {
				curRow = curSheet.getRow(rowIndex);
				Customer cus = new Customer();
				String value;
				
				if (!"".equals(curRow.getCell(0).getStringCellValue())) {
					int physicalNumberOfCells = curRow.getPhysicalNumberOfCells();
					/*System.out.println("physicalNumberOfCells = " + physicalNumberOfCells);*/
					for (int cellIndex = 0; cellIndex < physicalNumberOfCells; cellIndex++) {
						curCell = curRow.getCell(cellIndex);
						
						value = "";
						switch (curCell.getCellType()) {
						case HSSFCell.CELL_TYPE_FORMULA:
							value = curCell.getCellFormula();
							break;
						case HSSFCell.CELL_TYPE_NUMERIC:
							value = ((int)curCell.getNumericCellValue())+"";
							break;
						case HSSFCell.CELL_TYPE_STRING:
							value = curCell.getStringCellValue()+"";
							break;
						case HSSFCell.CELL_TYPE_BLANK:
							value = curCell.getBooleanCellValue()+"";
							break;
						case HSSFCell.CELL_TYPE_ERROR:
							value = curCell.getErrorCellValue()+"";
							break;
						default:
							value = new String();
							break;
						}
						
						switch (cellIndex) {
						case 0:
							cus.setCustCdNm(value);
							break;
						case 1:
							cus.setCustNo(value);
							break;
						case 2:
							cus.setCustNm(value);
							break;
						case 3:
							cus.setTel1No(value);
							break;
						case 4:
							cus.setTel2No(value);
							break;
						case 5:
							cus.setTel3No(value);
							break;
						case 6:
							cus.setEmailId(value);
							break;
						case 7:
							cus.setFaxNo(value);
							break;
						case 8:
							cus.setAddr(value);
							break;
						case 9:
							cus.setCustNote(value);
							break;
							
						}
					}
					customer.add(cus);
				}
			}
		}
		
		return customer;
	}
	
}
