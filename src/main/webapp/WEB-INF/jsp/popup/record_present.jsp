<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<script>
var paramCode = {
		lcd : "",
};
var paramRecord = {
		startDate : "",
		endDate: "",
		telNo : "",
		callTypCd : "",
		extensionNo : ""
};
jui.ready([ "grid.xtable"], function(xtable) {
	/*
	 * 녹취현황
	 * record_present.jsp
	 */	
	tab_record = xtable("#tab_record", {
		resize : true,
		scrollHeight: 400,
        buffer: "s-page",
        bufferCount: 20,
		width : 1105,
        scrollWidth: 1100,
	});
	
	$("#bt_recordSelect").click(function() {
		paramRecord.startDate = $("#txt_recordStartDate").val().replace(/-/gi, ""); 
		paramRecord.endDate = $("#txt_recordEndDate").val().replace(/-/gi, ""); 
		paramRecord.telNo = $("#txt_recordTel").val();
		paramRecord.callTypCd = $("#select_recordCallTyp option:selected").val();
		paramRecord.extensionNo = $("#select_recordExtension option:selected").val();
		
		
		$.ajax({
			url : "/popup/recordList",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(paramRecord),
			success : function(result) {
				if(result != ""){
					page=1;
					tab_record.update(result);
					tab_record.resize(); 
				}else{
					tab_record.resize(); 
				}
			}
		
		});
	});
	
	paging_record = function(no) {
        page += no;
        page = (page < 1) ? 1 : page;
        tab_record.page(page);
	}
	
	/*
	 * 녹취현황  
	 * 내선 코드 / 콜구분
	 */	
	$("#bt_recordPopup").click(function() {
		paramCode.lcd = "1007";
		$.ajax({
			url : "/code/selecCodeList",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(paramCode),
			success : function(result) {
				$('#select_recordExtension').empty();
				$('#select_recordExtension').append('<option value=' + '' + '></li>');
			    for ( var i = 0; i < result.length; i++) {
						$('#select_recordExtension').append('<option value='+result[i].scd+'>' + result[i].scd + '</option>');
			    } 			
			}
		});
		
		
		paramCode.lcd = "1006";
		$.ajax({
			url : "/code/selecCodeList",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(paramCode),
			success : function(result) {
				$('#select_recordCallTyp').empty();
				$('#select_recordCallTyp').append('<option value=' + '' + '></option>');
			    for ( var i = 0; i < result.length; i++) {
						$('#select_recordCallTyp').append('<option value='+result[i].scd+'>' + result[i].scdNm + '</option>');
			    } 			
			}
		});
		
		var date = new Date();
		var month = date.getMonth() + 1;
		month = month < 10 ? '0' + month : month;
		var day = date.getDate();
		day = day < 10 ? '0' + day : day;

		$("#txt_recordStartDate").val(setYesterday(date.getFullYear() +'-'+ month +'-'+ day));
		$("#txt_recordEndDate").val(date.getFullYear() +'-'+ month +'-'+ day);
		
		tab_record.update();
	});
});
</script>
<script data-jui="#tab_record" data-tpl="row" type="text/template">
	<tr class="tr03">
		<td align ="center"><!= extensionNo !></td>
		<td align ="center"><!= telNo !></td>
		<td><!= callTypCd !></td>
		<td><!= recStartDate !> <!= recStartHms !></td>
		<td><!= fileSize !></td>
		<td><!= fileName !></td>
		<td><span class="icon icon-left"></span></td>
	</tr>
</script>
<script data-jui="#tab_record" data-tpl="none" type="text/template">
    <tr height ="390">
        <td colspan="7" class="none" align="center">Data does not exist.</td>
    </tr>
</script>
<script>
$(document).ready(function() {
	$("#txt_recordStartDate").datepicker({
		showMonthAfterYear : true,
		changeMonth : true,
		changeYear : true,
		dateFormat : "yy-mm-dd"
	});

	$("#txt_recordEndDate").datepicker({
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
				녹취현황
			</td>
		</tr>
	</table>
</div>
<div class="body">
	<table width="100%" border="0" align="center" cellpadding="0"
		cellspacing="0" style="margin-bottom: 2px;">
		<tr>
			<td class="td01">통화일자</td>
			<td class="td02">
				<input type="text" class="input mini" id="txt_recordStartDate" style="width: 82px" /> 
				<input type="text" class="input mini" id="txt_recordEndDate"  style="width: 82px" />
			</td>
			<td class="td01">콜구분</td>
			<td class="td02">
				<select id="select_recordCallTyp"></select>
			</td>
			<td class="td01">내선번호</td>
			<td class="td02">
				<select id="select_recordExtension"></select>
			</td>
			<td class="td01">전화번호</td>
			<td class="td02">
				<input type="text" class="input mini" id="txt_recordTel" maxLength="14" style="width: 120px; float:left" onfocus="OnCheckPhone(this)" onKeyup="OnCheckPhone(this)"/>
			</td>
			<td width="20%">&nbsp;</td>
			<td width="60" align="right" class="td01">
				<a class="btn small focus" id="bt_recordSelect">조 회</a>
			</td>
		</tr>
	</table>
	<table class="table classic hover" id="tab_record" width="100%">
		<thead>
			<tr>
				<th style="width:146px">내선번호</th>
				<th style="width:146px">전화번호</th>
				<th style="width:146px">콜유형</th>
				<th style="width:146px">녹취일시</th>
				<th style="width:146px">파일크기</th>
				<th style="width:146px">파일명</th>
				<th style="width:146px">청취</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
	<div class="row" align="right" style="text-align: right; margin-top: 3px;">
	    <div class="group">
	        <button onclick="paging_record(-1);" class="btn mini">Prev</button>
	        <button onclick="paging_record(1);" class="btn mini">Next</button>
	    </div>
	</div>
</div>