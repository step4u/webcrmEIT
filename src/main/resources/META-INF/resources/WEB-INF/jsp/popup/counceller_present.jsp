<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<script>
var paramCouncellerPresent = {
		leadStartDate : "",
		leadEndDate : "",
		empNm : ""
};
jui.ready([ "grid.xtable"], function(xtable) {
	tab_councellerPresent = xtable("#tab_councellerPresent", {
		resize : true,
		scrollHeight: 400,
		width : 1105,
        scrollWidth: 1100,
        buffer: "s-page",
        bufferCount: 50,
		csv:["startDate","empNm","totIbAgTransCount","totIbAgTransTime","totOutCount","totOutTime","totExtCount","totExtTime","agtStat1001Time","agtStat1002Time","agtStat1003Time","agtStat1004Time","agtStat1005Time"],
		csvNames:["일자","상담원","인바운드 건수","인바운드 시간","아웃바운드 건수","아웃바운드 시간","내선통화 건수","내선통화 시간","상담원상태(대기)","상담원상태(후처리)","상담원상태(이석)","상담원상태(휴식)","상담원상태(교육)"],
	});
	
	$("#bt_councellerPresentPopup").click(function() {
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
		
		tab_councellerPresent.update();
		
	});
	
	$("#bt_councellerPresentSelect").click(function() {
		paramCouncellerPresent.leadStartDate  = $("#txt_leadStartDate").val().replace(/-/gi, ""); 
		paramCouncellerPresent.leadEndDate  = $("#txt_leadEndDate").val().replace(/-/gi, ""); 
		paramCouncellerPresent.empNm = $("#select_councellerPresentEmpNm option:selected").val();
		
		$.ajax({
			url : "/popup/councellerPresentList",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(paramCouncellerPresent),
			success : function(result) {
				if(result != ""){
					page=1;
					tab_councellerPresent.update(result);
					tab_councellerPresent.resize(); 
				}else{
					tab_councellerPresent.resize(); 
				}
			$("#bt_councellerPresentCSV").attr("href", tab_councellerPresent.getCsvBase64());
			}
		});
	
	});
	
	paging_councellerPresent = function(no) {
        page += no;
        page = (page < 1) ? 1 : page;
        tab_councellerPresent.page(page);
	}
 	$("#bt_councellerPresentCSV").attr("href", tab_councellerPresent.getCsvBase64());
 	
 	
 	$('input[name=radio_counceller]').change(function() {   
	    if(this.value == "1"){
			paramCouncellerPresent.leadStartDate  = $("#txt_leadStartDate").val().replace(/-/gi, ""); 
			paramCouncellerPresent.leadEndDate  = $("#txt_leadEndDate").val().replace(/-/gi, ""); 
			paramCouncellerPresent.empNm = $("#select_councellerPresentEmpNm option:selected").val();
			
			$.ajax({
				url : "/popup/councellerPresentList",
				type : "post",
				contentType : 'application/json; charset=utf-8',
				data : JSON.stringify(paramCouncellerPresent),
				success : function(result) {
					if(result != ""){
						page=1;
						tab_councellerPresent.update(result);
						tab_councellerPresent.resize(); 
					}else{
						tab_councellerPresent.resize(); 
					}
				$("#bt_councellerPresentCSV").attr("href", tab_councellerPresent.getCsvBase64());
				}
			});
	    }else if(this.value == "2"){
	    	paramCouncellerPresent.leadStartDate  = $("#txt_leadStartDate").val().replace(/-/gi, ""); 
			paramCouncellerPresent.leadEndDate  = $("#txt_leadEndDate").val().replace(/-/gi, ""); 
			paramCouncellerPresent.empNm = $("#select_councellerPresentEmpNm option:selected").val();
			
			$.ajax({
				url : "/popup/councellerPresentList",
				type : "post",
				contentType : 'application/json; charset=utf-8',
				data : JSON.stringify(paramCouncellerPresent),
				success : function(result) {
					if(result != ""){
						page=1;
						tab_councellerPresent.update(result);
						tab_councellerPresent.resize(); 
					}else{
						tab_councellerPresent.resize(); 
					}
				$("#bt_councellerPresentCSV").attr("href", tab_councellerPresent.getCsvBase64());
				}
			});
	    }else if(this.value == "3"){
	    	var startDate =  $("#txt_leadStartDate").val().replace(/-/gi, ""); 
			var endDate = $("#txt_leadEndDate").val().replace(/-/gi, ""); 
			paramCouncellerPresent.leadStartDate  = startDate.substr(0,6);
			paramCouncellerPresent.leadEndDate  = startDate.substr(0,6);
			paramCouncellerPresent.empNm = $("#select_councellerPresentEmpNm option:selected").val();
			
			$.ajax({
				url : "/popup/councellerPresentListMonth",
				type : "post",
				contentType : 'application/json; charset=utf-8',
				data : JSON.stringify(paramCouncellerPresent),
				success : function(result) {
					if(result != ""){
						page=1;
						tab_councellerPresent.update(result);
						tab_councellerPresent.resize(); 
					}else{
						tab_councellerPresent.resize(); 
					}
				$("#bt_councellerPresentCSV").attr("href", tab_councellerPresent.getCsvBase64());
				}
			});
	    }else if(this.value == "4"){
	    	var startDate =  $("#txt_leadStartDate").val().replace(/-/gi, ""); 
			var endDate = $("#txt_leadEndDate").val().replace(/-/gi, ""); 
			paramCouncellerPresent.leadStartDate  = startDate.substr(0,4);
			paramCouncellerPresent.leadEndDate  = startDate.substr(0,4);
			paramCouncellerPresent.empNm = $("#select_councellerPresentEmpNm option:selected").val();
			
			$.ajax({
				url : "/popup/councellerPresentListYear",
				type : "post",
				contentType : 'application/json; charset=utf-8',
				data : JSON.stringify(paramCouncellerPresent),
				success : function(result) {
					if(result != ""){
						page=1;
						tab_councellerPresent.update(result);
						tab_councellerPresent.resize(); 
					}else{
						tab_councellerPresent.resize(); 
					}
				$("#bt_councellerPresentCSV").attr("href", tab_councellerPresent.getCsvBase64());
				}
			});
	    }
	});  
});	
</script>
<script data-jui="#tab_councellerPresent" data-tpl="row" type="text/template">
	<tr class="tr03">
		<td align ="center"><!= startDate !></td>
		<td><!= empNm !></td>
		<td><!= totIbAgTransCount !></td>
		<td><!= totIbAgTransTime !></td>
		<td><!= totOutCount !></td>
		<td><!= totOutTime !></td>
		<td><!= totExtCount !></td>
		<td><!= totExtTime !></td>
		<td><!= agtStat1001Time !></td>
		<td><!= agtStat1002Time !></td>
		<td><!= agtStat1003Time !></td>
		<td><!= agtStat1004Time !></td>
		<td><!= agtStat1005Time !></td>
	</tr>
</script>
<script data-jui="#tab_councellerPresent" data-tpl="none" type="text/template">
    <tr height ="390">
        <td colspan="13" class="none" align="center">Data does not exist.</td>
    </tr>
</script>
<script>
$(document).ready(function() {
	$("#txt_leadStartDate").datepicker({
		showMonthAfterYear : true,
		changeMonth : true,
		changeYear : true,
		dateFormat : "yy-mm-dd"
	});

	$("#txt_leadEndDate").datepicker({
		showMonthAfterYear : true,
		changeMonth : true,
		changeYear : true,
		dateFormat : "yy-mm-dd"
	});
	
});
</script>
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
<div class="body">
	<table width="100%" border="0" align="center" cellpadding="0"
		cellspacing="0" style="margin-bottom: 2px;">
		<tr>
			<td width="60" class="td01">인입일자</td>
			<td align="left" class="td02">
				<input type="text" class="input mini" id="txt_leadStartDate"  style="width: 82px" />
				<input type="text" class="input mini" id="txt_leadEndDate"  style="width: 82px" /> 
			</td>
			<td width="60" class="td01">상담원</td>
			<td align="left" class="td02">
				<select id="select_councellerPresentEmpNm"></select>
			</td>
			<td width="290">
				<input type="radio" name="radio_counceller" value="1" checked> 시간대별 
				<input type="radio" name="radio_counceller" value="2" > 일별 
				<input type="radio" name="radio_counceller" value="3"> 월별
				<input type="radio" name="radio_counceller" value="4"> 연도별
			</td>
		    <td width="200" align="right" class="td01">
			   	<a class="btn small focus" id="bt_councellerPresentSelect">조 회</a> 
		      	<a class="btn small focus" id="bt_councellerPresentCSV" download="상담원통계.csv">엑셀 다운로드</a>
		    </td>
		</tr>
	</table>
	<table class="table special hover" id="tab_councellerPresent" width="100%">
		<thead>
			<tr>
				<th width="70" rowspan="2">일자</th>
				<th width="70" rowspan="2">상담원</th>
				<th colspan="2">인바운드</th>
				<th colspan="2">아웃바운드</th>
				<th colspan="2">내선통화</th>
				<th colspan="5">상담원상태</th>
			</tr>
			<tr>
				<th>건수</th>
				<th>시간</th>
				<th>건수</th>
				<th>시간</th>
				<th>건수</th>
				<th>시간</th>
				<th>대기</th>
				<th>후처리</th>
				<th>이석</th>
				<th>휴식</th>
				<th>교육</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table> 
	<div class="row" align="right" style="text-align: right; margin-top: 3px;">
	    <div class="group">
	        <button onclick="paging_councellerPresent(-1);" class="btn mini">Prev</button>
	        <button onclick="paging_councellerPresent(1);" class="btn mini">Next</button>
	    </div>
	</div>
</div>