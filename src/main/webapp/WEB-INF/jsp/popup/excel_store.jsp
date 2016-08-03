<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<script>
var param2 = {
/* 		custNo : "", */
		custCd : "",
		custNm : "",
		tel1No : "",
		tel2No : "",
		tel3No : "",
		emailId : "",
		faxNo : "",
		addr : "",
		custNote : ""
		
};
jui.ready([ "grid.xtable"], function(xtable) { 
 	var data;
	var data_size;
	var page = 1;
	var result_data;
	
	var tableTr = "";
	
	tab_excelList = xtable("#tab_excelList", {
		resize : true,
		scrollHeight: 400, 
        buffer: "s-page",
        bufferCount: 2000 ,
	});
	
	/*
	 * 엑셀로 고객정보 저장
	 * excel_store.jsp
	 * Button Name : 엑셀선택
	 */	
	$("#bt_selectExcel").click(function() {
		$("#bt_file").click();
		var param1 = $("#bt_file").val();
		
		$.ajax({
			url : "/popup/read_xlsx",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(param1),
			success : function(result) {
				if(result != ""){
					page=1;
					tab_excelList.update(result);
					tab_excelList.resize(); 
					tableTr = tab_excelList.size();
				}else{
					tab_excelList.resize(); 
				}
			}
		});

	});
	
     paging_excel = function(no) {
        page += no;
        page = (page < 1) ? 1 : page;
        tab_excelList.page(page);
	}
     
	/*
	 * 엑셀로 고객정보 저장
	 * excel_store.jsp
	 * Button Name : 저장
	 */	

	$("#bt_insertExcel").click(function() {
		/* var trLength = document.getElementById("tab_excelList").rows.length; 	 */
		 //var tableid = document.getElementById("tab_excelList"); 	
		// tableid.rows[i].cells[3].innerHTML
		 //alert(" 행 갯수 : " +tableTr); 
		 //alert("tr : " + $('.trExcel').length);
 		 /*   $('.trExcel').each(function (){
 			 	param2.custCd = $(this).find('#cust_cdNm').html();
	 			param2.custNo = $(this).find('#cust_no').html();
				param2.custNm = $(this).find('#cust_nm').html();
				param2.tel1No = $(this).find('#tel1_no').html();
				param2.tel2No = $(this).find('#tel2_no').html();
				param2.tel3No = $(this).find('#tel3_no').html();
				param2.emailId = $(this).find('#emailid').html();
				param2.faxNo = $(this).find('#fax_no').html();
				param2.addr = $(this).find('#addr').html();
				param2.custNote = $(this).find('#cust_note').html();    */
		var temp;
		for(var i=0; i < tableTr; i++){
			 $('.trExcel').each(function (){
			param2.custCd = $(this).find('#cust_cdNm').html();
			param2.custNo = $(this).find('#cust_no').html();
 			param2.custNm = $(this).find('#cust_nm').html();
			param2.tel1No = $(this).find('#tel1_no').html();
			param2.tel2No = $(this).find('#tel2_no').html();
			param2.tel3No = $(this).find('#tel3_no').html();
			param2.emailId = $(this).find('#emailid').html();
			param2.faxNo = $(this).find('#fax_no').html();
			param2.addr = $(this).find('#addr').html();
			param2.custNote = $(this).find('#cust_note').html();

			if(param2.custCd == "개인"){
				param2.custCd = '1001';
				$.ajax({
					url : "/popup/insertCustomer",
					type : "post",
					contentType : 'application/json; charset=utf-8',
					data : JSON.stringify(param2),
					success : function(result) {
						temp = result;
						/* if(result == 1){
							alert("저장이 완료되었습니다");
						}else if(result == 0){
							alert("동일고객이 존재합니다.");
						} */
					}
				});
			}else if(param2.custCd == "사업자"){
				param2.custCd = '1002';
				$.ajax({
					url : "/popup/insertCustomer2",
					type : "post",
					contentType : 'application/json; charset=utf-8',
					data : JSON.stringify(param2),
					success : function(result) {
						temp = result;
						/* if(result == 1){
							alert("저장이 완료되었습니다");
						}else if(result == 0){
							alert("동일고객이 존재합니다.");
						} */
					}
				});
			}else{
				//alert("유형구분을 '개인' 또는 '사업자'로 입력해주세요.");
			}
			 });
		}
		if(temp == 1){
			alert("저장이 완료되었습니다.");	
		}else{
			alert("실패하였습니다.");
		}
		
	});
});
</script>
<script data-jui="#tab_excelList" data-tpl="row" type="text/template">
	<tr class="trExcel">
		<td><!= row.index !></td>
		<td><a id="excelData"></a></td>
		<td id="cust_cdNm" align ="center"><!= custCdNm !></td>
		<td id="cust_no" align ="center"><!= custNo !></td>
		<td id="cust_nm"><!= custNm !></td>
		<td id="tel1_no"><!= tel1No !></td>
		<td id="tel2_no"><!= tel2No !></td>
		<td id="tel3_no"><!= tel3No !></td>
		<td id="emailid"><!= emailId !></td>
		<td id="fax_no"><!= faxNo !></td>
		<td id="addr"><!= addr !></td>
		<td id="cust_note"><!= custNote !></td>
	</tr>
</script>
<script data-jui="#tab_excelList" data-tpl="none" type="text/template">
    <tr height ="390">
        <td colspan="12" class="none" align="center">Data does not exist.</td>
    </tr>
</script>

<script>
/* 취소버튼 click Event */
function cancel(){
	$("#tbodyid").empty();
	$("#list").empty();
}
</script>
<div class="head">
	<a href="#" class="close"><i class="icon-exit"></i></a>
	<table width="100%" border="0" align="center" cellpadding="0"
		cellspacing="0">
		<tr>
			<td class="poptitle"
				style="background-image: url(../resources/jui-master/img/theme/jennifer/pop.png);">
				고객정보를 엑셀로 여러 건 입력하기
			</td>
		</tr>
	</table>
</div>
<div class="body">
	<table width="100%" border="0" cellpadding="0" cellspacing="0"
		style="margin-bottom: 2px;">
		<tr>
			<td width="100%" align="right" class="td01">
			<input type="file" id="bt_file" style="display:none;"/>
			<a class="btn small focus" id="bt_excelData">데이터검증</a>
			<a class="btn small focus" id="bt_selectExcel">엑셀선택</a>
			<a class="btn small focus" id="bt_insertExcel">저장</a>
			<a class="btn small focus" onclick="cancel()">취소</a></td>
		</tr>
	</table>
	<table class="table classic hover xtable" id="tab_excelList" width="100%">
		<thead>
			<tr>
				<th>번호</th>
				<th>검증</th>
				<th>유형</th>
				<th>고객번호</th>
				<th>고객명</th>
				<th>연락처1</th>
				<th>연락처2</th>
				<th>연락처3</th>
				<th>eMail</th>
				<th>FAX</th>
				<th>주소</th>
				<th>비고</th>
			</tr>
		</thead>
		<tbody id="tbodyid">
		</tbody>
	</table>
 	<div class="row" align="right" style="text-align: right; margin-top: 3px;">
	    <div class="group">
	        <button onclick="paging_excel(-1);" class="btn mini">Prev</button>
	        <button onclick="paging_excel(1);" class="btn mini">Next</button>
	    </div>
	</div>
</div>