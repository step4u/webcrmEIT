<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<script>
var paramCallCenter = {
		startDate : "",
		endDate : ""
};
jui.ready([ "grid.xtable"], function(xtable) {
	tab_callcenterList = xtable("#tab_callcenterList", {
		resize : true,
		scrollHeight: 400,
		width : 1105,
        scrollWidth: 1100,
        buffer: "s-page",
        bufferCount: 50,
		csv:["regDate","genDirNo","totIbCount","totIbAgTransCount","totCbCount","totAbnCount","totAbnCount","totOutCount","totResCount","totExtCount"],
		csvNames:["일자","대표번호","인바운드 총인입","인바운드 상담원연결","인바운드 콜백","포기호","응대율","아웃바운드 건수","아웃바운드 예약","아웃바운드 내선통화"],
	});
	
	$("#bt_callcenterPopup").click(function() {
		var date = new Date();
		var month = date.getMonth() + 1;
		month = month < 10 ? '0' + month : month;
		var day = date.getDate();
		day = day < 10 ? '0' + day : day;

		$("#bt_startDate").val(setYesterday(date.getFullYear() +'-'+ month +'-'+ day));
		$("#bt_endDate").val(date.getFullYear() +'-'+ month +'-'+ day);
		
		tab_callcenterList.update();
	});
	
	$("#bt_callcenterList").click(function() {
		paramCallCenter.startDate = $("#bt_startDate").val().replace(/-/gi, ""); 
		paramCallCenter.endDate = $("#bt_endDate").val().replace(/-/gi, ""); 
		
		$.ajax({
			url : "/popup/callStatSelect",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(paramCallCenter),
			success : function(result) {
				if(result != ""){
					page=1;
					tab_callcenterList.update(result);
					tab_callcenterList.resize(); 
				}else{
					tab_callcenterList.resize(); 
				}
				
			 $("#bt_callcenterCSV").attr("href", tab_callcenterList.getCsvBase64());
			}
		});
	});
	
	paging_callCenter = function(no) {
        page += no;
        page = (page < 1) ? 1 : page;
        tab_callcenterList.page(page);
	}
	
	$("#bt_callcenterCSV").attr("href", tab_callcenterList.getCsvBase64());
	
	$('input[name=radio_callcenter]').change(function() {   
	    if(this.value == "1"){
			paramCallCenter.startDate = $("#bt_startDate").val().replace(/-/gi, ""); 
			paramCallCenter.endDate = $("#bt_endDate").val().replace(/-/gi, ""); 
			
	    	$.ajax({
				url : "/popup/callStatSelect",
				type : "post",
				contentType : 'application/json; charset=utf-8',
				data : JSON.stringify(paramCallCenter),
				success : function(result) {
					if(result != ""){
						page=1;
						tab_callcenterList.update(result);
						tab_callcenterList.resize(); 
					}else{
						tab_callcenterList.resize(); 
					}
				 $("#bt_callcenterCSV").attr("href", tab_callcenterList.getCsvBase64());
				}
			});
	    }else if(this.value == "2"){
	    	paramCallCenter.startDate = $("#bt_startDate").val().replace(/-/gi, ""); 
			paramCallCenter.endDate = $("#bt_endDate").val().replace(/-/gi, ""); 
			
	    	$.ajax({
				url : "/popup/callStatSelectDay",
				type : "post",
				contentType : 'application/json; charset=utf-8',
				data : JSON.stringify(paramCallCenter),
				success : function(result) {
					if(result != ""){
						page=1;
						tab_callcenterList.update(result);
						tab_callcenterList.resize(); 
					}else{
						tab_callcenterList.resize(); 
					}
				 $("#bt_callcenterCSV").attr("href", tab_callcenterList.getCsvBase64());
				}
			});
	    }else if(this.value == "3"){
	    	var startDate = $("#bt_startDate").val().replace(/-/gi, ""); 
			var endDate = $("#bt_endDate").val().replace(/-/gi, ""); 
			paramCallCenter.startDate = startDate.substr(0,6);
			paramCallCenter.endDate = startDate.substr(0,6);
			
	    	$.ajax({
				url : "/popup/callStatSelectMonth",
				type : "post",
				contentType : 'application/json; charset=utf-8',
				data : JSON.stringify(paramCallCenter),
				success : function(result) {
					if(result != ""){
						page=1;
						tab_callcenterList.update(result);
						tab_callcenterList.resize(); 
					}else{
						tab_callcenterList.resize(); 
					}
				 $("#bt_callcenterCSV").attr("href", tab_callcenterList.getCsvBase64());
				}
			});
	    }else if(this.value == "4"){
	    	var startDate = $("#bt_startDate").val().replace(/-/gi, ""); 
			var endDate = $("#bt_endDate").val().replace(/-/gi, ""); 
			paramCallCenter.startDate = startDate.substr(0,4);
			paramCallCenter.endDate = startDate.substr(0,4);
			
	    	$.ajax({
				url : "/popup/callStatSelectYear",
				type : "post",
				contentType : 'application/json; charset=utf-8',
				data : JSON.stringify(paramCallCenter),
				success : function(result) {
					if(result != ""){
						page=1;
						tab_callcenterList.update(result);
						tab_callcenterList.resize(); 
					}else{
						tab_callcenterList.resize(); 
					}
				 $("#bt_callcenterCSV").attr("href", tab_callcenterList.getCsvBase64());
				}
			});
	    }
	});  
});
</script>
<script>
$(document).ready(function() {
	$("#bt_startDate").datepicker({
		showMonthAfterYear : true,
		changeMonth : true,
		changeYear : true,
		dateFormat : "yy-mm-dd"
	});

	$("#bt_endDate").datepicker({
		showMonthAfterYear : true,
		changeMonth : true,
		changeYear : true,
		dateFormat : "yy-mm-dd"
	});
	
});
</script>
<script data-jui="#tab_callcenterList" data-tpl="row" type="text/template">
	<tr class="tr03">
		<td align ="center"><!= regDate !></td>
		<td><!= genDirNo !></td>
		<td><!= totIbCount !></td>
		<td><!= totIbAgTransCount !></td>
		<td><!= totCbCount !></td>
		<td><!= totAbnCount !></td>
		<td><!= answer !></td>
		<td><!= totOutCount !></td>
		<td><!= totResCount !></td>
		<td><!= totExtCount !></td>
	</tr>
</script>

<script data-jui="#tab_callcenterList" data-tpl="none" type="text/template">
    <tr height ="390">
        <td colspan="10" class="none" align="center">Data does not exist.</td>
    </tr>
</script>
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
<div class="body">
	<table width="100%" border="0" align="center" cellpadding="0"
		cellspacing="0" style="margin-bottom: 2px;">
		<tr>
			<td width="60" class="td01">인입일자</td>
			<td align="left" class="td02">
				<input type="text" class="input mini" id="bt_startDate"  style="width: 82px" /> 
				<input type="text" class="input mini" id="bt_endDate"  style="width: 82px" />
			</td>
			<td width="290">
				<input type="radio" name="radio_callcenter" value="1"> 시간대별 
				<input type="radio" name="radio_callcenter" value="2"> 일별 
				<input type="radio" name="radio_callcenter" value="3"> 월별
				<input type="radio" name="radio_callcenter" value="4"> 연도별
			</td>
         <td width="20%"></td>
        <td width="200" align="right" class="td01">
        	<a class="btn small focus" id="bt_callcenterList">조 회</a> 
        	<a class="btn small focus" id="bt_callcenterCSV" download="콜센터전체통계.csv">엑셀 다운로드</a>
        </td>
		</tr>
	</table>
	<table class="table special hover" id="tab_callcenterList" width="100%">
		<thead>
			<tr>
				<th width="83" rowspan="2">일자</th>
				<th width="83" rowspan="2">대표번호</th>
				<th colspan="5">인바운드</th>
				<th colspan="3">아웃바운드</th>
			</tr>
			<tr>
				<th width="58">총인입</th>
				<th width="108">상담원연결</th>
				<th width="58">콜백</th>
				<th width="58">포기호</th>
				<th width="73">응대율</th>
				<th width="138">건수</th>
				<th width="279">예약</th>
				<th width="77">내선통화</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table> 
	<div class="row" align="right" style="text-align: right; margin-top: 3px;">
	    <div class="group">
	        <button onclick="paging_callCenter(-1);" class="btn mini">Prev</button>
	        <button onclick="paging_callCenter(1);" class="btn mini">Next</button>
	    </div>
	</div>
</div>