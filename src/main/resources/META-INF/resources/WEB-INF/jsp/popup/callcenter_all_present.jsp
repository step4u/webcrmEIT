<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<script>
var paramCallCenter = {
		callStatstartDate : "",
		callStatendDate : "",
		callStatstartDate2 : "",
		callStatendDate2 : ""
};
var paramCallCenterExcel = {
		callStatstartDate : "",
		callStatendDate : "",
		callStatstartDate2 : "",
		callStatendDate2 : "",
		radioValue : "",
};

var radioSelect;

jui.ready(["grid.xtable","ui.paging"], function(xtable, paging) {
	tab_callcenterList = xtable("#tab_callcenterList", {
		resize : true,
		scrollHeight: 375,
		width : 1110,
        scrollWidth: 1090,
        buffer: "s-page",
        bufferCount: 5000,
        tpl: {
            row: $("#tpl_row_callcenter").html(),
            none: $("#tpl_none_callcenter").html()
        }
	});

	paging_callCenter = paging("#paging_callCenter", {
	      pageCount: 1000,
	      event: {
	          page: function(pNo) {
	        	  tab_callcenterList.page(pNo);
	          }
	       },
	       tpl: {
	           pages: $("#tpl_pages_callcenter").html()
	       }
	});
	
	$("#bt_callcenterPopup").click(function() {
		var date = new Date();
		var month = date.getMonth() + 1;
		month = month < 10 ? '0' + month : month;
		var day = date.getDate();
		day = day < 10 ? '0' + day : day;

		$("#bt_startDate").val(setYesterday(date.getFullYear() +'-'+ month +'-'+ day));
		$("#bt_endDate").val(date.getFullYear() +'-'+ month +'-'+ day);
		
    	tab_callcenterList.update(0);
		
	});
	
	function callcenter_SumAvg(result){
		var resultLength = result.length;
		if(resultLength > 0){
			var sum_nTotIb=0; //총인입건수
			var sum_nTotIbAgTrans=0; //상담원 연결건수
			var sum_nTotCb=0; //콜백건수
			var sum_nTotIbAban=0; //포기건수
			var sum_nTotOut=0; //아웃바운드
			var sum_nTotRes=0; //상담예약건수
			var sum_nTotExt=0; //내선건수
			var sum_answer=0; //응답율
	
			var avg_nTotIb=0; //총인입건수
			var avg_nTotIbAgTrans=0; //상담원 연결건수
			var avg_nTotCb=0; //콜백건수
			var avg_nTotIbAban=0; //포기건수
			var avg_nTotOut=0; //아웃바운드
			var avg_nTotRes=0; //상담예약건수
			var avg_nTotExt=0; //내선건수
			var avg_answer=0; //응답율
			
			for(var i=0; i < resultLength; i++){
				var answerData = result[i].answer;
				var temp = answerData.split(answerData.substring(answerData.length-1,answerData.length));
				
				sum_nTotIb = result[i].nTotIb + sum_nTotIb;
				sum_nTotIbAgTrans = result[i].nTotIbAgTrans + sum_nTotIbAgTrans;
				sum_nTotCb = result[i].nTotCb + sum_nTotCb;
				sum_nTotIbAban = result[i].nTotIbAban + sum_nTotIbAban;
				sum_answer =  (parseFloat(temp) + parseFloat(sum_answer)).toFixed(2);
				sum_nTotOut = result[i].nTotOut + sum_nTotOut;
				sum_nTotRes = result[i].nTotRes + sum_nTotRes;
				sum_nTotExt = result[i].nTotExt + sum_nTotExt;
			}
			
			avg_nTotIb = parseInt(sum_nTotIb/resultLength); //총인입건수
			avg_nTotIbAgTrans = parseInt(sum_nTotIbAgTrans/resultLength); //상담원 연결건수
			avg_nTotCb = parseInt(sum_nTotCb/resultLength); //콜백건수
			avg_nTotIbAban = parseInt(sum_nTotIbAban/resultLength); //포기건수
			avg_nTotOut = parseInt(sum_nTotOut/resultLength); //아웃바운드
			avg_nTotRes = parseInt(sum_nTotRes/resultLength); //상담예약건수
			avg_nTotExt = parseInt(sum_nTotExt/resultLength); //내선건수
			avg_answer = (sum_answer/resultLength).toFixed(2); //응답율
			
			$('#tab_callcenterList > tbody:last-child').append('<tr class="tr03"><td>총계</td><td>' + sum_nTotIb + '</td><td>' + sum_nTotIbAgTrans + '</td><td>' + sum_nTotCb + '</td><td>' + sum_nTotIbAban + '</td><td>'
					+ sum_answer + '%</td><td>' + sum_nTotOut + '</td><td>' + sum_nTotRes + '</td><td>' + sum_nTotExt + '</td></tr>');
			$('#tab_callcenterList > tbody:last-child').append('<tr class="tr03"><td>평균</td><td>' + avg_nTotIb + '</td><td>' + avg_nTotIbAgTrans + '</td><td>' + avg_nTotCb + '</td><td>' + avg_nTotIbAban + '</td><td>'
					+ avg_answer + '%</td><td>' + avg_nTotOut + '</td><td>' + avg_nTotRes + '</td><td>' + avg_nTotExt + '</td></tr>');
			
		}
		else{
			
		}
	}
	
	$("#bt_callcenterList").click(function() {
		if(document.getElementById("radio_callcenterNoagg").checked == true){
			radioSelect = document.getElementById("radio_callcenterNoagg").value;
			paramCallCenter.callStatstartDate = $("#bt_startDate").val(); 
			paramCallCenter.callStatendDate = $("#bt_endDate").val(); 
			paramCallCenter.callStatstartDate2 = $("#bt_startDate").val().replace(/-/gi, ""); 
			paramCallCenter.callStatendDate2 = $("#bt_endDate").val().replace(/-/gi, ""); 
			
			$.ajax({
				url : "/popup/callStatSelect",
				type : "post",
				contentType : 'application/json; charset=utf-8',
				data : JSON.stringify(paramCallCenter),
				success : function(result) {
						page=1;
						tab_callcenterList.update(result);
						tab_callcenterList.resize(); 
						paging_callCenter.reload(tab_callcenterList.count());
						
						callcenter_SumAvg(result);
				}
			}); 
		}else if(document.getElementById("radio_callcenterDay").checked == true){
			radioSelect = document.getElementById("radio_callcenterDay").value;
			paramCallCenter.callStatstartDate = $("#bt_startDate").val(); 
			paramCallCenter.callStatendDate = $("#bt_endDate").val(); 
			paramCallCenter.callStatstartDate2 = $("#bt_startDate").val().replace(/-/gi, "");
			paramCallCenter.callStatendDate2 = $("#bt_endDate").val().replace(/-/gi, "");
			
			$.ajax({
				url : "/popup/callStatSelectDay",
				type : "post",
				contentType : 'application/json; charset=utf-8',
				data : JSON.stringify(paramCallCenter),
				success : function(result) {
						page=1;
						tab_callcenterList.update(result);
						tab_callcenterList.resize(); 
						
						callcenter_SumAvg(result);
				}
			});
		}else if(document.getElementById("radio_callcenterMonth").checked == true){
			radioSelect = document.getElementById("radio_callcenterMonth").value;
			var startDate = $("#bt_startDate").val(); 
			var endDate = $("#bt_endDate").val(); 
			paramCallCenter.callStatstartDate = startDate.substr(0,7);
			paramCallCenter.callStatendDate = endDate.substr(0,7);
			paramCallCenter.callStatstartDate2 = $("#bt_startDate").val().substr(0,7).replace(/-/gi, "");
			paramCallCenter.callStatendDate2 = $("#bt_endDate").val().substr(0,7).replace(/-/gi, "");
			
	    	$.ajax({
				url : "/popup/callStatSelectMonth",
				type : "post",
				contentType : 'application/json; charset=utf-8',
				data : JSON.stringify(paramCallCenter),
				success : function(result) {
						page=1;
						tab_callcenterList.update(result);
						tab_callcenterList.resize(); 
						
						callcenter_SumAvg(result);
				}
			});
		}else if(document.getElementById("radio_callcenterYear").checked == true){
			radioSelect = document.getElementById("radio_callcenterYear").value;
			var startDate = $("#bt_startDate").val(); 
			var endDate = $("#bt_endDate").val(); 
			paramCallCenter.callStatstartDate = startDate.substr(0,4);
			paramCallCenter.callStatendDate = endDate.substr(0,4);
			paramCallCenter.callStatstartDate2 = $("#bt_startDate").val().substr(0,4).replace(/-/gi, "");
			paramCallCenter.callStatendDate2 = $("#bt_endDate").val().substr(0,4).replace(/-/gi, "");
			
	    	$.ajax({
				url : "/popup/callStatSelectYear",
				type : "post",
				contentType : 'application/json; charset=utf-8',
				data : JSON.stringify(paramCallCenter),
				success : function(result) {
						page=1;
						tab_callcenterList.update(result);
						tab_callcenterList.resize(); 
						
						callcenter_SumAvg(result);
				}
			});
		}
		
	});
	
	/* 엑셀 다운로드 */
	$("#bt_callcenterCSV").click(function() {
		var empNm = $("input[name=empNm]").val();
		paramCallCenterExcel.radioValue = radioSelect;
		
		if(paramCallCenterExcel.radioValue == 1 || paramCallCenterExcel.radioValue == 2){
			paramCallCenterExcel.callStatstartDate = $("#bt_startDate").val(); 
			paramCallCenterExcel.callStatendDate = $("#bt_endDate").val(); 
			paramCallCenterExcel.callStatstartDate2 = $("#bt_startDate").val().replace(/-/gi, ""); 
			paramCallCenterExcel.callStatendDate2 = $("#bt_endDate").val().replace(/-/gi, ""); 
		}else if(paramCallCenterExcel.radioValue == 3){
			var startDate = $("#bt_startDate").val(); 
			var endDate = $("#bt_endDate").val(); 
			paramCallCenterExcel.callStatstartDate = startDate.substr(0,7);
			paramCallCenterExcel.callStatendDate = endDate.substr(0,7);
			paramCallCenterExcel.callStatstartDate2 = startDate.substr(0,7).replace(/-/gi, "");
			paramCallCenterExcel.callStatendDate2 = endDate.substr(0,7).replace(/-/gi, "");
		}else if(paramCallCenterExcel.radioValue == 4){
			var startDate = $("#bt_startDate").val(); 
			var endDate = $("#bt_endDate").val(); 
			paramCallCenterExcel.callStatstartDate = startDate.substr(0,4);
			paramCallCenterExcel.callStatendDate = endDate.substr(0,4);
			paramCallCenterExcel.callStatstartDate2 = startDate.substr(0,4).replace(/-/gi, "");
			paramCallCenterExcel.callStatendDate2 = endDate.substr(0,4).replace(/-/gi, "");
		}
		
		$("#ifraCallcenter").attr("src", "/popup/callcenterListExcel?callStatstartDate="+paramCallCenterExcel.callStatstartDate+"&callStatendDate="+paramCallCenterExcel.callStatendDate +
				"&callStatstartDate2="+paramCallCenterExcel.callStatstartDate2 + "&callStatendDate2=" + paramCallCenterExcel.callStatendDate2 + "&empNm="+empNm + "&radioValue=" + paramCallCenterExcel.radioValue);
	});
});
</script>
<script>
$(document).ready(function() {
	$("#bt_startDate").datepicker({
		showMonthAfterYear : true,
		changeMonth : true,
		changeYear : true,
		dateFormat : "yy-mm-dd",
		dayNamesMin : ["일","월","화","수","목","금","토"],
		monthNamesShort : ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		nextText:'다음 달',
        prevText:'이전 달'
	});

	$("#bt_endDate").datepicker({
		showMonthAfterYear : true,
		changeMonth : true,
		changeYear : true,
		dateFormat : "yy-mm-dd",
		dayNamesMin : ["일","월","화","수","목","금","토"],
		monthNamesShort : ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		nextText:'다음 달',
        prevText:'이전 달'
	});
	

});
</script>
<script id="tpl_row_callcenter" type="text/template">
	<tr class="tr03">
		<td scope="row" align ="center"><!= regDate !></td>
		<td><!= nTotIb !></td>
		<td><!= nTotIbAgTrans !></td>
		<td><!= nTotCb !></td>
		<td><!= nTotIbAban !></td>
		<td><!= answer !></td>
		<td><!= nTotOut !></td>
		<td><!= nTotRes !></td>
		<td><!= nTotExt !></td>
	</tr>
</script>
<script id="tpl_none_callcenter" type="text/template">
    <tr height ="375">
        <td colspan="10" class="none" align="center">데이터가 존재하지 않습니다.</td>
    </tr>
</script>
<script id="tpl_pages_callcenter" type="text/template">
    <! for(var i = 0; i < pages.length; i++) { !>
    <a href="#" class="page" onclick="fn_page();"><!= pages[i] !></a>
    <! } !>
</script>
<style>
#callcenter_top_tr td {
	padding-bottom: 5px;
}
</style>
<div class="head">
	<a href="#" class="close"><i class="icon-exit"></i></a>
	<table width="100%" border="0" align="center" cellpadding="0"
		cellspacing="0">
		<tr>
			<td class="poptitle"
				style="background-image: url(../resources/jui-master/img/theme/jennifer/pop.png);">
				콜센터 전체 통계
			</td>
		</tr>
	</table>
</div>
<div class="body" style="overflow-y:hidden">
	<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" style="margin-bottom: 2px;">
		<tr id="callcenter_top_tr">
			<td width="60" class="td01" style="text-align: center; padding-left:0px !important">인입일자</td>
			<td align="left" class="td02">
				<input type="text" class="input mini" id="bt_startDate"  style="width: 82px" /> 
				<input type="text" class="input mini" id="bt_endDate"  style="width: 82px" />
			</td>
			<td width="290">
				<input type="radio" name="radio_callcenter" value = "1" id="radio_callcenterNoagg" checked> 시간대별 
				<input type="radio" name="radio_callcenter" value = "2" id="radio_callcenterDay"> 일별 
				<input type="radio" name="radio_callcenter" value = "3" id="radio_callcenterMonth"> 월별
				<input type="radio" name="radio_callcenter" value = "4" id="radio_callcenterYear"> 연도별
			</td>
         <td width="20%"></td>
        <td width="200" align="right" class="td01" style="padding-right:9px;">
        	<a class="btn small focus" id="bt_callcenterList">조 회</a> 
        	<a class="btn small focus" id="bt_callcenterCSV">엑셀 다운로드</a>
        </td>
		</tr>
	</table>
	<table class="table special hover" id="tab_callcenterList" width="100%" style="padding-left: 5px;">
		<colgroup>
			<col width="120px">
			<col width="120px">
			<col width="120px">
			<col width="120px">
			<col width="120px">
			<col width="120px">
			<col width="120px">
			<col width="120px">
			<col width="auto !important">
		</colgroup>
		<thead>
			<tr>
				<th rowspan="2" scope="col">일자</th>
				<th colspan="5" scope="colgroup">인바운드</th>
				<th colspan="3" scope="colgroup">아웃바운드</th>
			</tr>
			<tr>
				<th scope="col">총인입</th>
				<th scope="col">상담원연결</th>
				<th scope="col">콜백</th>
				<th scope="col">포기호</th>
				<th scope="col">응대율</th>
				<th scope="col">건수</th>
				<th scope="col">예약</th>
				<th scope="col">내선통화</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
	<div id="paging_callCenter" class="paging" style="margin-top: 4px; margin-right: 4px; width:1092px;">
	    <a href="#" class="prev" style="left:0" onclick="fn_page();">이전</a>
	    <div class="list"></div>
	    <a href="#" class="next" onclick="fn_page();">다음</a>
	</div>
	<iframe id="ifraCallcenter" name="ifraCallcenter" style="display:none;"></iframe>
</div>