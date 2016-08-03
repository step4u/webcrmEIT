<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<script>
var paramIvr = {
		startDate : "",
		endDate : "",
		telNo : "",
};
jui.ready([ "grid.xtable"], function(xtable) {
	/*
	 * ivr 현황
	 * ivr_present.jsp
	 */	
	tab_ivrList = xtable("#tab_ivrList", {
		resize : true,
		scrollHeight: 400,
        buffer: "s-page",
        bufferCount: 20,
		csv:["regDate","regHms","genDirNo","telNo","extensionNo"],
		csvNames:["인일일자","인입시간","대표번호","전화번호","내선번호"],
	});
	
	$("#bt_ivrSelect").click(function() {
		paramIvr.startDate  = $("#txt_ivrStartDate").val().replace(/-/gi, ""); 
		paramIvr.endDate = $("#txt_ivrEndDate").val().replace(/-/gi, ""); 
		paramIvr.telNo = $("#txt_ivrTel").val();
		
		$.ajax({
			url : "/popup/ivrSelect",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(paramIvr),
			success : function(result) {
				if(result != ""){
					page=1;
					tab_ivrList.update(result);
					tab_ivrList.resize(); 
				}else{
					tab_ivrList.resize(); 
				}
				$("#bt_ivrCSV").attr("href", tab_ivrList.getCsvBase64());
			}
		});
	
	});
	
	paging_ivr = function(no) {
        page += no;
        page = (page < 1) ? 1 : page;
        tab_ivrList.page(page);
	}
	$("#bt_ivrCSV").attr("href", tab_ivrList.getCsvBase64());
});
</script>
<script data-jui="#tab_ivrList" data-tpl="row" type="text/template">
	<tr class="tr03">
		<td align ="center"><!= regDate !></td>
		<td><!= regHms !></td>
		<td><!= genDirNo !></td>
		<td><!= telNo !></td>
		<td><!= extensionNo !></td>
	</tr>
</script>
<script data-jui="#tab_ivrList" data-tpl="none" type="text/template">
    <tr height ="390">
        <td colspan="5" class="none" align="center">Data does not exist.</td>
    </tr>
</script>
<script>
$(document).ready(function() {
	var date = new Date();
	var month = date.getMonth() + 1;
	month = month < 10 ? '0' + month : month;
	var day = date.getDate();
	day = day < 10 ? '0' + day : day;
	
	var month2 = date.getMonth() + 1;
	month2 = month2 < 10 ? '0' + month2 : month2;
	var day2 = date.getDate() -2 ;
	day2 = day2 < 10 ? '0' + day2 : day2;
	
	$("#txt_ivrStartDate").val(date.getFullYear() +'-'+ month2 +'-'+ day2);
	$("#txt_ivrEndDate").val(date.getFullYear() +'-'+ month +'-'+ day);
	
	$("#txt_ivrStartDate").datepicker({
		showMonthAfterYear : true,
		changeMonth : true,
		changeYear : true,
		dateFormat : "yy-mm-dd"
	});

	$("#txt_ivrEndDate").datepicker({
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
				IVR 통계
			</td>
		</tr>
	</table>
</div>
<div class="body">
	<table width="100%" border="0" align="center" cellpadding="0"
		cellspacing="0" style="margin-bottom: 2px;">
		<tr>
			<td class="td01">인입일자</td>
			<td class="td02">
				<input type="text" class="input mini" id="txt_ivrStartDate"  style="width: 82px" /> 
				<input type="text" class="input mini" id="txt_ivrEndDate"  style="width: 82px" />
			</td>
			<td class="td01">인입번호</td>
			<td>
				<span class="td02"> 
					<input type="text" class="input mini" id="txt_ivrTel" maxLength="13"  style="width: 100px" />
				</span>
			</td>
			<td width="290">
				<span class="td02"> 
					<input type="radio" name="radio" id="radio" value="radio"> 시간대별 
					<label for="radio"></label> 
					<input name="radio" type="radio" id="radio2" value="radio" checked> 일별 
					<input type="radio" name="radio" id="radio3" value="radio"> 월별
				</span> 
				<span class="td02"> 
					<input type="radio" name="radio" id="radio4" value="radio"> 연도별
				</span>
			</td>
			<td width="20%"></td>
			<td width="150" align="right" class="td01">
				<a class="btn small focus" id="bt_ivrSelect">조 회</a> 
				<a class="btn small focus" id="bt_ivrCSV" download="IVR현황.csv">엑셀 다운로드</a>
			</td>
		</tr>
	</table>
	<table class="table classic hover" id="tab_ivrList" width="100%">
		<thead>
			<tr>
				<th>인입일자</th>
				<th>인입시간</th>
				<th>대표번호</th>
				<th>전화번호</th>
				<th>내선번호</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
	<div class="row" align="right" style="text-align: right; margin-top: 3px;">
	    <div class="group">
	        <button onclick="paging_ivr(-1);" class="btn mini">Prev</button>
	        <button onclick="paging_ivr(1);" class="btn mini">Next</button>
	    </div>
	</div>
</div>
<script>
function autoHypenPhone(str){
	str = str.replace(/[^0-9]/g, '');
	var tmp = '';
	if( str.length < 4){
		return str;
	}else if(str.length < 7){
		tmp += str.substr(0, 3);
		tmp += '-';
		tmp += str.substr(3);
		return tmp;
	}else if(str.length < 11){
		tmp += str.substr(0, 3);
		tmp += '-';
		tmp += str.substr(3, 3);
		tmp += '-';
		tmp += str.substr(6);
		return tmp;
	}else{				
		tmp += str.substr(0, 3);
		tmp += '-';
		tmp += str.substr(3, 4);
		tmp += '-';
		tmp += str.substr(7);
		return tmp;
	}
	return str;
}


var txt_tel = document.getElementById('txt_ivrTel');
txt_tel.onkeyup = function(event){
		event = event || window.event;
		var _val = this.value.trim();
		this.value = autoHypenPhone(_val) ;
} 
</script>