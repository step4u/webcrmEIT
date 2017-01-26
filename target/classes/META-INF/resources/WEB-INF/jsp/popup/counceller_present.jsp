<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<script>
var paramCouncellerPresent = {
		leadStartDate : "",
		leadEndDate : "",
		empNm : ""
};

var paramCouncellerPresentExcel = {
		leadStartDate : "",
		leadEndDate : "",
		empNm : "",
		radioValue : ""
};

var radioSelect;
jui.ready(["grid.xtable","ui.paging"], function(xtable, paging) {
	tab_councellerPresent = xtable("#tab_councellerPresent", {
		resize : true,
		scrollHeight: 375,
		/* width : 1100,
        scrollWidth: 1095, */
        width : 1400,
        scrollWidth: 1095, 
        buffer: "s-page",
        bufferCount: 1000,
        tpl: {
            row: $("#tpl_row_counceller").html(),
            none: $("#tpl_none_counceller").html()
        }
	});
	
	paging_councellerPresent = paging("#paging_councellerPresent", {
	      pageCount: 1000,
	      event: {
	          page: function(pNo) {
	        	  tab_councellerPresent.page(pNo);
	          }
	       },
	       tpl: {
	           pages: $("#tpl_pages_counceller").html()
	       }
	});
	
	$("#bt_councellerPresentPopup").click(function() {
		document.getElementById("radio_councellerNoagg").checked = true;
		
		$.ajax({
			url : "/code/selectEmpNm",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(param),
			success : function(result) {
				$('#select_councellerPresentEmpNm').empty();
				$('#select_councellerPresentEmpNm').append('<option value=' + '' + '></li>');
			    for ( var i = 0; i < result.length; i++) {
						$('#select_councellerPresentEmpNm').append('<option value='+result[i].empNm+'>' + result[i].empNm + '</option>');
			    } 			
			}
		});
		
		var date = new Date();
		var month = date.getMonth() + 1;
		month = month < 10 ? '0' + month : month;
		var day = date.getDate();
		day = day < 10 ? '0' + day : day;

		$("#txt_leadStartDate").val(setYesterday(date.getFullYear() +'-'+ month +'-'+ day));
		$("#txt_leadEndDate").val(date.getFullYear() +'-'+ month +'-'+ day);
		
		tab_councellerPresent.update(0);
		
	});
	
	function counceller_SumAvg(result){
		var resultLength = result.length;
		if(resultLength > 0){
			var sum_nInbound = 0;
			var sum_tInbound = 0;
			var sum_tInboundFmt = 0;
			var sum_nOutbound = 0; //아웃바운드_건수
			var sum_tOutbound = 0; //아웃바운드 통화시간(초)
			var sum_tOutboundFmt = 0;
			var sum_nExtension = 0; //내선통화_건수
			var sum_tExtension = 0; //내선통화_시간(초)
			var sum_tExtensionFmt = 0;
			var sum_tAgentStat1011 = 0; //상담원상태_대기
			var sum_tAgentStat1011Fmt = 0;
			var sum_tAgentStat1012 = 0; //상담원상태_후처리
			var sum_tAgentStat1012Fmt = 0;
			var sum_tAgentStat1013 = 0; //상담원상태_이석
			var sum_tAgentStat1013Fmt = 0;
			var sum_tAgentStat1014 = 0; //상담원상태_휴식
			var sum_tAgentStat1014Fmt = 0;
			var sum_tAgentStat1015 = 0; //상담원상태_교육
			var sum_tAgentStat1015Fmt = 0;
			var sum_nCallback = 0; //콜백처리_건수
			var sum_nReservation = 0; //상담예약처리_건수
			var sum_nSms = 0; //SMS전송_건수
			
			var avg_nInbound = 0;
			var avg_tInbound = 0;
			var avg_tInboundFmt = 0;
			var avg_nOutbound = 0; //아웃바운드_건수
			var avg_tOutbound = 0; //아웃바운드 통화시간(초)
			var avg_tOutboundFmt = 0;
			var avg_nExtension = 0; //내선통화_건수
			var avg_tExtension = 0; //내선통화_시간(초)
			var avg_tExtensionFmt = 0;
			var avg_tAgentStat1011 = 0; //상담원상태_대기
			var avg_tAgentStat1011Fmt = 0;
			var avg_tAgentStat1012 = 0; //상담원상태_후처리
			var avg_tAgentStat1012Fmt = 0;
			var avg_tAgentStat1013 = 0; //상담원상태_이석
			var avg_tAgentStat1013Fmt = 0;
			var avg_tAgentStat1014 = 0; //상담원상태_휴식
			var avg_tAgentStat1014Fmt = 0;
			var avg_tAgentStat1015 = 0; //상담원상태_교육
			var avg_tAgentStat1015Fmt = 0;
			var avg_nCallback = 0; //콜백처리_건수
			var avg_nReservation = 0; //상담예약처리_건수
			var avg_nSms = 0; //SMS전송_건수
			
			for(var i=0; i < resultLength; i++){
				sum_nInbound = result[i].nInbound + sum_nInbound;
				sum_tInbound = result[i].tInbound + sum_tInbound;
				sum_nOutbound = result[i].nOutbound + sum_nOutbound;
				sum_tOutbound = result[i].tOutbound + sum_tOutbound;
				sum_nExtension = result[i].nExtension + sum_nExtension;
				sum_tExtension = result[i].tExtension + sum_tExtension;
				sum_tAgentStat1011 = result[i].tAgentStat1011 + sum_tAgentStat1011;
				sum_tAgentStat1012 = result[i].tAgentStat1012 + sum_tAgentStat1012;
				sum_tAgentStat1013 = result[i].tAgentStat1013 + sum_tAgentStat1013;
				sum_tAgentStat1014 = result[i].tAgentStat1014 + sum_tAgentStat1014;
				sum_tAgentStat1015 = result[i].tAgentStat1015 + sum_tAgentStat1015;
				sum_nCallback = result[i].nCallback + sum_nCallback;
				sum_nReservation = result[i].nReservation + sum_nReservation;
				sum_nSms = result[i].nSms + sum_nSms;
			}
			
			sum_tInboundFmt = humanReadable(sum_tInbound);
			sum_tOutboundFmt = humanReadable(sum_tOutbound);
			sum_tExtensionFmt = humanReadable(sum_tExtension);
			sum_tAgentStat1011Fmt = humanReadable(sum_tAgentStat1011);
			sum_tAgentStat1012Fmt = humanReadable(sum_tAgentStat1012);
			sum_tAgentStat1013Fmt = humanReadable(sum_tAgentStat1013);
			sum_tAgentStat1014Fmt = humanReadable(sum_tAgentStat1014);
			sum_tAgentStat1015Fmt = humanReadable(sum_tAgentStat1015);
			
			avg_nInbound = parseInt(sum_nInbound / resultLength);
			avg_tInbound = parseInt(sum_tInbound / resultLength);
			avg_nOutbound = parseInt(sum_nOutbound / resultLength); //아웃바운드_건수
			avg_tOutbound = parseInt(sum_tOutbound / resultLength); //아웃바운드 통화시간(초)
			avg_nExtension = parseInt(sum_nExtension / resultLength); //내선통화_건수
			avg_tExtension = parseInt(sum_tExtension / resultLength); //내선통화_시간(초)
			avg_tAgentStat1011 = parseInt(sum_tAgentStat1011 / resultLength); //상담원상태_대기
			avg_tAgentStat1012 = parseInt(sum_tAgentStat1012 / resultLength); //상담원상태_후처리
			avg_tAgentStat1013 = parseInt(sum_tAgentStat1013 / resultLength); //상담원상태_이석
			avg_tAgentStat1014 = parseInt(sum_tAgentStat1014 / resultLength); //상담원상태_휴식
			avg_tAgentStat1015 = parseInt(sum_tAgentStat1015 / resultLength); //상담원상태_교육
			avg_nCallback = parseInt(sum_nCallback / resultLength); //콜백처리_건수
			avg_nReservation = parseInt(sum_nReservation / resultLength); //상담예약처리_건수
			avg_nSms = parseInt(sum_nSms / resultLength); //SMS전송_건수
			
			avg_tInboundFmt = humanReadable(avg_tInbound);
			avg_tOutboundFmt = humanReadable(avg_tOutbound);
			avg_tExtensionFmt = humanReadable(avg_tExtension);
			avg_tAgentStat1011Fmt = humanReadable(avg_tAgentStat1011);
			avg_tAgentStat1012Fmt = humanReadable(avg_tAgentStat1012);
			avg_tAgentStat1013Fmt = humanReadable(avg_tAgentStat1013);
			avg_tAgentStat1014Fmt = humanReadable(avg_tAgentStat1014);
			avg_tAgentStat1015Fmt = humanReadable(avg_tAgentStat1015);
			
			$('#tab_councellerPresent > tbody:last-child').append('<tr class="tr03"><td colspan="2">총계</td><td>' + sum_nInbound + '</td><td>' + sum_tInboundFmt + '</td><td>' + sum_nOutbound + '</td><td>' + sum_tOutboundFmt + '</td><td>'
					+ sum_nExtension + '</td><td>' + sum_tExtensionFmt + '</td><td>' + sum_tAgentStat1011Fmt + '</td><td>' + sum_tAgentStat1012Fmt + '</td><td>' + sum_tAgentStat1013Fmt + '</td><td>' + sum_tAgentStat1014Fmt + '</td><td>' + sum_tAgentStat1015Fmt + '</td><td>' 
					+ sum_nCallback + '</td><td>' + sum_nReservation + '</td><td>' + sum_nSms + '</td></tr>');
			$('#tab_councellerPresent > tbody:last-child').append('<tr class="tr03"><td colspan="2">평균</td><td>' + avg_nInbound + '</td><td>' + avg_tInboundFmt + '</td><td>' + avg_nOutbound + '</td><td>' + avg_tOutboundFmt + '</td><td>'
					+ avg_nExtension + '</td><td>' + avg_tExtensionFmt + '</td><td>' + avg_tAgentStat1011Fmt + '</td><td>' + avg_tAgentStat1012Fmt + '</td><td>' + avg_tAgentStat1013Fmt + '</td><td>' + avg_tAgentStat1014Fmt + '</td><td>' + avg_tAgentStat1015Fmt + '</td><td>' 
					+ avg_nCallback + '</td><td>' + avg_nReservation + '</td><td>' + avg_nSms + '</td></tr>');
			}else{
				
			}
		}
	
	/* DB 쿼리로 총계, 평균 계산해서 가져오는 함수 */
	/* function counceller_SumAvg2(type, param){
		if(type == 'noagg'){
			$.ajax({
				url : "/popup/councellerPresentList2",
				type : "post",
				contentType : 'application/json; charset=utf-8',
				data : JSON.stringify(param),
				success : function(result) {
					if(result != "" || result != null){
						for(var i=0; i<result.length; i++){
							$('#tab_councellerPresent > tbody:last-child').append('<tr class="tr03"><td colspan="2">총계</td><td>' + result[i].sum_nInbound + '</td><td>' + result[i].sum_tInboundFmt + '</td><td>' + result[i].sum_nOutbound + '</td><td>' + result[i].sum_tOutboundFmt + '</td><td>'
								+ result[i].sum_nExtension + '</td><td>' + result[i].sum_tExtensionFmt + '</td><td>' + result[i].sum_tAgentStat1011Fmt + '</td><td>' + result[i].sum_tAgentStat1012Fmt + '</td><td>' + result[i].sum_tAgentStat1013Fmt + '</td><td>' + result[i].sum_tAgentStat1014Fmt + '</td><td>' + result[i].sum_tAgentStat1015Fmt + '</td><td>' 
								+ result[i].sum_nCallback + '</td><td>' + result[i].sum_nReservation + '</td><td>' + result[i].sum_nSms + '</td></tr>');
							$('#tab_councellerPresent > tbody:last-child').append('<tr class="tr03"><td colspan="2">평균</td><td>' + result[i].avg_nInbound + '</td><td>' + result[i].avg_tInboundFmt + '</td><td>' + result[i].avg_nOutbound + '</td><td>' + result[i].avg_tOutboundFmt + '</td><td>'
									+ result[i].avg_nExtension + '</td><td>' + result[i].avg_tExtensionFmt + '</td><td>' + result[i].avg_tAgentStat1011Fmt + '</td><td>' + result[i].avg_tAgentStat1012Fmt + '</td><td>' + result[i].avg_tAgentStat1013Fmt + '</td><td>' + result[i].avg_tAgentStat1014Fmt + '</td><td>' + result[i].avg_tAgentStat1015Fmt + '</td><td>' 
									+ result[i].avg_nCallback + '</td><td>' + result[i].avg_nReservation + '</td><td>' + result[i].avg_nSms + '</td></tr>');
						} 
					}else{
						console.log('[상담원 통계 현황] : 총계, 평균 Error');
					}
				}
			});
		}
	} */
	
	$("#bt_councellerPresentSelect").click(function() { 
		if(document.getElementById("radio_councellerNoagg").checked == true){
			radioSelect = document.getElementById("radio_councellerNoagg").value;
			paramCouncellerPresent.leadStartDate  = $("#txt_leadStartDate").val().replace(/-/gi, ""); 
			paramCouncellerPresent.leadEndDate  = $("#txt_leadEndDate").val().replace(/-/gi, ""); 
			paramCouncellerPresent.empNm = $("#select_councellerPresentEmpNm option:selected").val();
			
			$.ajax({
				url : "/popup/councellerPresentList",
				type : "post",
				contentType : 'application/json; charset=utf-8',
				data : JSON.stringify(paramCouncellerPresent),
				success : function(result) {
						page=1;
						tab_councellerPresent.update(result);
						tab_councellerPresent.resize(); 
						
						paging_councellerPresent.reload(tab_councellerPresent.count());
						counceller_SumAvg(result);
				}
			});
		}else if(document.getElementById("radio_councellerDay").checked == true){
			radioSelect = document.getElementById("radio_councellerDay").value;
			paramCouncellerPresent.leadStartDate  = $("#txt_leadStartDate").val().replace(/-/gi, ""); 
			paramCouncellerPresent.leadEndDate  = $("#txt_leadEndDate").val().replace(/-/gi, ""); 
			paramCouncellerPresent.empNm = $("#select_councellerPresentEmpNm option:selected").val();
			$.ajax({
				url : "/popup/councellerPresentListDay",
				type : "post",
				contentType : 'application/json; charset=utf-8',
				data : JSON.stringify(paramCouncellerPresent),
				success : function(result) {
						page=1;
						tab_councellerPresent.update(result);
						tab_councellerPresent.resize(); 

						paging_councellerPresent.reload(tab_councellerPresent.count());
						counceller_SumAvg(result);
				}
			});
		}else if(document.getElementById("radio_councellerMonth").checked == true){
			radioSelect = document.getElementById("radio_councellerMonth").value;
			var startDate =  $("#txt_leadStartDate").val().replace(/-/gi, ""); 
			var endDate = $("#txt_leadEndDate").val().replace(/-/gi, ""); 
			paramCouncellerPresent.leadStartDate  = startDate.substr(0,6);
			paramCouncellerPresent.leadEndDate  = endDate.substr(0,6);
			paramCouncellerPresent.empNm = $("#select_councellerPresentEmpNm option:selected").val();
			
			$.ajax({
				url : "/popup/councellerPresentListMonth",
				type : "post",
				contentType : 'application/json; charset=utf-8',
				data : JSON.stringify(paramCouncellerPresent),
				success : function(result) {
						page=1;
						tab_councellerPresent.update(result);
						tab_councellerPresent.resize(); 
						
						paging_councellerPresent.reload(tab_councellerPresent.count());
						counceller_SumAvg(result);
				}
			});
		}else if(document.getElementById("radio_councellerYear").checked == true){
			radioSelect = document.getElementById("radio_councellerYear").value;
			var startDate =  $("#txt_leadStartDate").val().replace(/-/gi, ""); 
			var endDate = $("#txt_leadEndDate").val().replace(/-/gi, ""); 
			paramCouncellerPresent.leadStartDate  = startDate.substr(0,4);
			paramCouncellerPresent.leadEndDate  = endDate.substr(0,4);
			paramCouncellerPresent.empNm = $("#select_councellerPresentEmpNm option:selected").val();
			
			$.ajax({
				url : "/popup/councellerPresentListYear",
				type : "post",
				contentType : 'application/json; charset=utf-8',
				data : JSON.stringify(paramCouncellerPresent),
				success : function(result) {
						page=1;
						tab_councellerPresent.update(result);
						tab_councellerPresent.resize(); 
						
						paging_councellerPresent.reload(tab_councellerPresent.count());
						counceller_SumAvg(result);
				}
			});
		}
		
	});
 	
 	/* 엑셀다운로드 */ 
 	$("#bt_councellerPresentCSV").click(function() {
 		var empNm2 = $("input[name=empNm]").val();
 		paramCouncellerPresentExcel.radioValue = radioSelect;
 		
 		if(paramCouncellerPresentExcel.radioValue == 1 || paramCouncellerPresentExcel.radioValue == 2){
 			paramCouncellerPresentExcel.leadStartDate  = $("#txt_leadStartDate").val().replace(/-/gi, ""); 
 	 		paramCouncellerPresentExcel.leadEndDate  = $("#txt_leadEndDate").val().replace(/-/gi, ""); 
 	 		paramCouncellerPresentExcel.empNm = $("#select_councellerPresentEmpNm option:selected").val();
 		}else if(paramCouncellerPresentExcel.radioValue == 3){
 			var startDate =  $("#txt_leadStartDate").val().replace(/-/gi, ""); 
			var endDate = $("#txt_leadEndDate").val().replace(/-/gi, ""); 
			paramCouncellerPresent.leadStartDate  = startDate.substr(0,6);
			paramCouncellerPresent.leadEndDate  = startDate.substr(0,6);
			paramCouncellerPresent.empNm = $("#select_councellerPresentEmpNm option:selected").val();
 		}else if(paramCouncellerPresentExcel.radioValue == 4){
 			var startDate =  $("#txt_leadStartDate").val().replace(/-/gi, ""); 
			var endDate = $("#txt_leadEndDate").val().replace(/-/gi, ""); 
			paramCouncellerPresent.leadStartDate  = startDate.substr(0,4);
			paramCouncellerPresent.leadEndDate  = startDate.substr(0,4);
			paramCouncellerPresent.empNm = $("#select_councellerPresentEmpNm option:selected").val();
 		}
		
		$("#ifraCounceller").attr("src", "/popup/agentStatListExcel?startDate="+paramCouncellerPresentExcel.leadStartDate+"&endDate="+paramCouncellerPresentExcel.leadEndDate + "&empNm=" + paramCouncellerPresentExcel.empNm + "&empNm2="+empNm2 + "&radioValue=" + paramCouncellerPresentExcel.radioValue); 	 	
 	});
 	
});	
</script>
<script id="tpl_row_counceller" type="text/template">
	<tr class="tr03">
		<td align ="center"><!= regDate !></td>
		<td><!= empNm !></td>
		<td><!= nInbound !></td>
		<td><!= tInboundFmt !></td>
		<td><!= nOutbound !></td>
		<td><!= tOutboundFmt !></td>
		<td><!= nExtension !></td>
		<td><!= tExtensionFmt !></td>
		<td><!= tAgentStat1011Fmt !></td>
		<td><!= tAgentStat1012Fmt !></td>
		<td><!= tAgentStat1013Fmt !></td>
		<td><!= tAgentStat1014Fmt !></td>
		<td><!= tAgentStat1015Fmt !></td>
		<td><!= nCallback !></td>
		<td><!= nReservation !></td>
		<td><!= nSms !></td>
	</tr>
</script>
<script id="tpl_none_counceller" type="text/template">
    <tr height ="375">
        <td colspan="16" class="none" align="center">데이터가 존재하지 않습니다.</td>
    </tr>
</script>
<script id="tpl_pages_counceller" type="text/template">
    <! for(var i = 0; i < pages.length; i++) { !>
    <a href="#" class="page" onclick="fn_page();"><!= pages[i] !></a>
    <! } !>
</script>
<script>
$(document).ready(function() {
	$("#txt_leadStartDate").datepicker({
		showMonthAfterYear : true,
		changeMonth : true,
		changeYear : true,
		dateFormat : "yy-mm-dd",
		dayNamesMin : ["일","월","화","수","목","금","토"],
		monthNamesShort : ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
		nextText:'다음 달',
        prevText:'이전 달'
	});

	$("#txt_leadEndDate").datepicker({
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
<style>
#councellerPresent_top_tr td {
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
				상담원 통계</td>
		</tr>
	</table>
</div>
<div class="body"  style="overflow-y:hidden">
	<table width="100%" border="0" align="center" cellpadding="0"
		cellspacing="0" style="margin-bottom: 2px;">
		<tr id="councellerPresent_top_tr">
			<td width="60" class="td01" style="text-align: center; padding-left:0px !important">인입일자</td>
			<td align="left" class="td02">
				<input type="text" class="input mini" id="txt_leadStartDate"  style="width: 82px" />
				<input type="text" class="input mini" id="txt_leadEndDate"  style="width: 82px" /> 
			</td>
			<td width="60" class="td01">상담원</td>
			<td align="left" class="td02">
				<select id="select_councellerPresentEmpNm"></select>
			</td>
			<td width="290">
				<input type="radio" name="radio_counceller" value="1" id="radio_councellerNoagg" checked> 시간대별 
				<input type="radio" name="radio_counceller" value="2" id="radio_councellerDay"> 일별 
				<input type="radio" name="radio_counceller" value="3" id="radio_councellerMonth"> 월별
				<input type="radio" name="radio_counceller" value="4" id="radio_councellerYear"> 연도별
			</td>
		    <td width="200" align="right" class="td01" style="padding-right:9px;">
			   	<a class="btn small focus" id="bt_councellerPresentSelect">조 회</a> 
		      	<a class="btn small focus" id="bt_councellerPresentCSV">엑셀 다운로드</a>
		    </td>
		</tr>
	</table>
	<table class="table special hover" id="tab_councellerPresent" width="100%" style="padding-left: 5px;">
		<colgroup>
			<col width="90px">
			<col width="90px">
			<col width="80px">
			<col width="80px">
			<col width="80px">
			<col width="80px">
			<col width="80px">
			<col width="80px">
			<col width="90px">
			<col width="90px">
			<col width="90px">
			<col width="90px">
			<col width="90px">
			<col width="90px">
			<col width="90px">
			<col width="auto">
		</colgroup>
		<thead>
			<tr>
				<th scope="col" rowspan="2">일자</th>
				<th scope="col" rowspan="2">상담원</th>
				<th scope="colgroup" colspan="2">인바운드</th>
				<th scope="colgroup" colspan="2">아웃바운드</th>
				<th scope="colgroup" colspan="2">내선통화</th>
				<th scope="colgroup" colspan="5">상담원상태</th>
				<th scope="col" rowspan="2">콜백</th>
				<th scope="col" rowspan="2">예약</th>
				<th scope="col" rowspan="2">SMS</th>
			</tr>
			<tr>
				<th scope="col">건수</th>
				<th scope="col">시간</th>
				<th scope="col">건수</th>
				<th scope="col">시간</th>
				<th scope="col">건수</th>
				<th scope="col">시간</th>
				<th scope="col">대기</th>
				<th scope="col">후처리</th>
				<th scope="col">이석</th>
				<th scope="col">휴식</th>
				<th scope="col">교육</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>	
	
	<div id="paging_councellerPresent" class="paging" style="margin-top: 4px; margin-right: 4px; width:1092px;">
	    <a href="#" class="prev" style="left:0" onclick="fn_page();">이전</a>
	    <div class="list"></div>
	    <a href="#" class="next" onclick="fn_page();">다음</a>
	</div>
	<iframe id="ifraCounceller" name="ifraCounceller" style="display:none;"></iframe>
</div>