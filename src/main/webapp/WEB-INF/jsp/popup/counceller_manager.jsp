<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<script>
var param = {
};
var paramCounceller = {
		empNo : ""
};
var paramCouncellerInsert = {
		empNo : "",
		empNm : "",
		enterDate : "",
		extensionNo : "",
		authCd : "",
		mobilePhoneNo : "",
		emailId : "",
		note : ""
};


jui.ready([ "grid.xtable"], function(xtable) {
	/*
	 * 상담원관리
	 * counceller_manager.jsp
	 */	
	tab_counceller = xtable("#tab_counceller", {
		resize : true,
		scrollHeight: 400,
        buffer: "s-page",
        bufferCount: 50,
	    event: {
	        click: function(row, e) {
	    	this.select(row.index);
	        }
	    }
	});
	
	$("#bt_councellerSelect").click(function() {
		
		$.ajax({
			url : "/popup/counceller",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(param),
			success : function(result) {
				if(result != ""){
					page=1;
					tab_counceller.update(result);
					tab_counceller.resize(); 
				}else{
					tab_counceller.resize(); 
				}
			}
		
		});
	});
	
	/*삭제 버튼*/
	$("#bt_councellerDelete").click(function() {
		paramCounceller.empNo = $("#councellerEmpNo").val();
		
		$.ajax({
			url : "/popup/councellerDelete",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(paramCounceller),
			success : function(result) {
				if(result == 1){
					alert("삭제가 완료되었습니다");
				}else if(result == 0){
					alert("삭제가 완료되지 않았습니다. 다시 시도해주세요.");
				}
				$("#bt_councellerSelect").click();
			}
		
		});
	});
	
	/*비번초기화 버튼*/
	$("#bt_pwInitialization").click(function() {
		paramCounceller.empNo = $("#councellerEmpNo").val();
	
		$.ajax({
			url : "/popup/councellerUpdate",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(paramCounceller),
			success : function(result) {
				if(result == 1){
					alert("비밀번호가 초기화되었습니다.");
				}else if(result == 0){
					alert("비밀번호 초기화에 실패하였습니다.");
				}
				$("#bt_councellerSelect").click();
			}
		
		});
	});
	
	/*저장 버튼*/
	$("#bt_councellerInsert").click(function() {
		var date = new Date();
		   
	    var year  = date.getFullYear();
	    var month = date.getMonth() + 1; 
	    var day   = date.getDate();
	
	    if (("" + month).length == 1) { month = "0" + month; }
	    if (("" + day).length   == 1) { day   = "0" + day;   }
	    
	    var today = year + month + day
	
		paramCouncellerInsert.empNo = $("#txt_empNo").val();
		paramCouncellerInsert.empNm = $("#txt_empNm").val();
		paramCouncellerInsert.enterDate = today;
		paramCouncellerInsert.extensionNo = $("#txt_councellerExtension").val();
		paramCouncellerInsert.authCd = $("#txt_authCd").val();		
		paramCouncellerInsert.mobilePhoneNo = $("#txt_tel").val();
		paramCouncellerInsert.emailId = $("#txt_email").val();
		paramCouncellerInsert.note = $("#txt_note").val();
		
		/*alert("내선 : " + paramCouncellerInsert.extensionNo + ", 권한유형은 : " + paramCouncellerInsert.authCd);*/
		
		$.ajax({
			url : "/popup/councellerInsert",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(paramCouncellerInsert),
			success : function(result) {
				if(result == 1){
					alert("저장이 완료되었습니다");
				}else if(result == 0){
					alert("일치하는 사번이 존재합니다. 사번을 다시 입력해주세요.");
				}
				$("#txt_empNo").val("");
				$("#txt_empNm").val("");	
				$("#txt_tel").val("");
				$("#txt_email").val("");
				$("#txt_note").val("");
				$("#bt_councellerSelect").click();
					
			}
		
		});
	});
	/*
	 * 상담원관리  
	 * 내선 코드  / 권한유형
	 */	
	$("#bt_councellerPopup").click(function() {
		paramCode.lcd = "1007";
		$.ajax({
			url : "/code/selecCodeList",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(paramCode),
			success : function(result) {
				$('#select_councellerExtension').append('<option value=' + '' + '></option>');
			    for ( var i = 0; i < result.length; i++) {
						$('#select_councellerExtension').append('<option value='+result[i].scd+'>' + result[i].scdNm + '</option>');
			    } 			
			}
		});
		paramCode.lcd = "1001";
		$.ajax({
			url : "/code/selecCodeList",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(paramCode),
			success : function(result) {
				$('#select_councellerAuthCd').append('<option value=' + '' + '></option>');
			    for ( var i = 0; i < result.length; i++) {
						$('#select_councellerAuthCd').append('<option value='+result[i].scd+'>' + result[i].scdNm + '</option>');
			    } 			
			}
		});
	});
});
</script>
<script data-jui="#tab_counceller" data-tpl="row" type="text/template">
	<tr onclick = "javascript:deleteCounceller(<!= empNo !>)";>
		<td><input type="checkbox" /></td>
		<td align ="center"><!= empNo !></td>
		<td align ="center"><!= empNm !></td>
		<td><!= extensionNo !></td>
		<td><!= mobilePhoneNo !></td>
		<td><!= emailId !></td>
		<td><!= note !></td>
	</tr>
</script>
<script data-jui="#tab_counceller" data-tpl="none" type="text/template">
    <tr height ="390">
        <td colspan="7" class="none" align="center">Data does not exist.</td>
    </tr>
</script>
<script>
function deleteCounceller(empNo){
	document.getElementById("councellerEmpNo").value = empNo;
}
function bt_initializationCounceller(){
	document.getElementById("txt_empNo").value = "";
	document.getElementById("txt_empNm").value = "";
	document.getElementById("txt_tel").value = "";
	document.getElementById("txt_email").value = "";
	document.getElementById("txt_note").value = "";
}
</script>
<div class="head">
	<a href="#" class="close"><i class="icon-exit"></i></a>
	<table width="100%" border="0" align="center" cellpadding="0"
		cellspacing="0">
		<tr>
			<td class="poptitle"
				style="background-image: url(../resources/jui-master/img/theme/jennifer/pop.png);">
				상담원관리
			</td>
		</tr>
	</table>
</div>
<div class="body">
	<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" style="margin-bottom: 2px;">
		<tr>
			<td width="36" class="td01">사번</td>
			<td align="left" class="td02">
				<input type="text" class="input mini" id="txt_empNo" value="10000" style="width: 80px" />
			</td>
			<td width="50" class="td01">상담원</td>
			<td align="left" class="td02">
				<input type="text" class="input mini" id="txt_empNm" style="width: 80px" />
			</td>
			<td width="37" class="td01">내선</td>			
			<td width="85" align="left">
				<select id="select_councellerExtension"> </select>
			</td>
			<td width="70" class="td01">권한유형</td>
			<td width="85" align="left">
				<select id="select_councellerAuthCd"></select>
			</td>
			<td width="70" class="td01">전화번호</td>
			<td align="left" class="td02">
				<input type="text" class="input mini" id="txt_tel" maxLength="13" style="width: 100px" />
			</td>
			<td width="55" class="td01">E-Mail</td>
			<td colspan="2" align="left" class="td02" width="230">
				<input type="text" class="input mini" id="txt_email" style="width: 180px" />
			</td>
		</tr>
		<tr>
			<td class="td01">비고</td>
			<td colspan="11" align="left" class="td02">
				<input type="text" class="input mini" id="txt_note" style="width: 600px" /></td>
			<td width="360" align="right" class="td01">
				<a class="btn small focus" onclick="bt_initializationCounceller()">초기화</a> 
				<a class="btn small focus" id="bt_councellerInsert">저 장</a> 
				<input type="hidden" id="councellerEmpNo" />
				<a class="btn small focus" id="bt_councellerDelete">삭 제</a> 
				<a class="btn small focus" id="bt_pwInitialization"">비번초기화</a>
				<a class="btn small focus" id="bt_councellerSelect">조 회</a></td>
		</tr>
	</table>
	<table class="table classic hover" id="tab_counceller" width="100%">
		<thead>
			<tr>
				<th></th>
				<th>사번</th>
				<th>상담원명</th>
				<th>내선</th>
				<th>전화번호</th>
				<th>eMail</th>
				<th>비고</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
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


var txt_tel = document.getElementById('txt_tel');
txt_tel.onkeyup = function(event){
		event = event || window.event;
		var _val = this.value.trim();
		this.value = autoHypenPhone(_val) ;
} 
</script>