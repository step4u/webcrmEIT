<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE HTML>
<html>
<head>
<title>[JUI Library] - CSS/Tab</title>

<!-- <link rel="stylesheet" href="../resources/jui-master/dist/ui.css" />
	<link rel="stylesheet" href="../resources/jui-master/dist/ui-jennifer.css" />
	<link rel="stylesheet" href="../resources/jui-master/dist/ui.min.css" />
	<link rel="stylesheet" href="../resources/jui-master/dist/grid.css" />
	<link rel="stylesheet" href="../resources/jui-master/dist/grid.min.css" />
	<link rel="stylesheet" href="../resources/jui-master/dist/grid-jennifer.css" />
	<link rel="stylesheet" href="../resources/jui-master/dist/grid-jennifer.min.css" /> -->
<%-- <%@ include file="../common/jui_common.jsp"%> --%>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
body {
	margin-top: 0px;
}

.body.fit {
	margin-top: 5px;
}

.tab.top {
	margin-bottom: 1px;
}
</style>
<script type="text/javascript">
$(document).ready(function() {

	var mainCustomer = {
			custCd : "",
			custNm : "",
			tel1No : "",
			tel2No : "",
			tel3No : "",
			faxNo : "",
			addr : "",
			emailId : "",
			custNote : ""
		};

	var mainCoun = {
			counSeq : "",
			custNo : "",
			custNm : "",
			tel1No : "",
			callTypCd : "",
			counStartDate : "",
			counStartHms : "",
			counEndDate : "",
			counEndHms : "",
			counCd : "",
			empNo : "",
			empNm : "",
			counNote : ""
		};

	var mainRes = {
			custNo : "",
			custNm : "",
			resTelNo : "",
			resDate : "",
			resHms : "",
			counCd : "",
			empNo : "",
			empNm : "",
			resNote : ""
		};

	var mainCallResult = {
			lcd : "1009",
		};

	$.ajax({
		url : "/code/selecCodeList",
		type : "post",
		data : JSON.stringify(mainCallResult),
		contentType : 'application/json; charset=utf-8',
		success : function(result) {
			$('#callResult').append('<option value=' + '' + '></option>');
		    for ( var i = 0; i < result.length; i++) {
					$('#callResult').append('<option value='+result[i].scd+'>' + result[i].scdNm + '</option>');
		    } 
		}
	});
	
	jui.ready([ "ui.tab" ], function(tab) {
		tab_1 = tab("#tab_1", {
			event : {
				change : function(data) {
					$("ul.tab_up li").removeClass("checked");
					$("ul.tab_up li i").removeClass("icon-arrow1");

					var a = data.index + 1;

					$("ul.tab_up li:nth-child(" + a + ")").addClass("checked");
					$("ul.tab_up li:nth-child(" + a + ") i").addClass(
							"icon-arrow1");
				}
			},
			target : "#tab_contents_1",
			index : 0
		});

		tab_2 = tab("#tab_2", {
			event : {
				change : function(data) {
					$("ul.tab_down li").removeClass("checked");
					$("ul.tab_down li i").removeClass("icon-arrow1");

					var a = data.index + 1;

					$("ul.tab_down li:nth-child(" + a + ")")
							.addClass("checked");
					$("ul.tab_down li:nth-child(" + a + ") i").addClass(
							"icon-arrow1");
				}
			},
			target : "#tab_contents_2",
			index : 0
		});
	});

	$("#tab1_resDate").datepicker({
		showMonthAfterYear : true,
		changeMonth : true,
		changeYear : true,
		dateFormat : "yy-mm-dd"
	});

	var date = new Date();
	var month = date.getMonth() + 1;
	month = month < 10 ? '0' + month : month;
	var day = date.getDate();
	day = day < 10 ? '0' + day : day;
	var hour = date.getHours() + 1;
	hour = hour < 10 ? '0' + hour : hour;
	var min = date.getMinutes();
	min = min < 10 ? '0' + min : min;
	
	$("input[name=tab1_resDate]").val(date.getFullYear() +'-'+ month +'-'+ day);
	$("input[name=tab1_resHms]").val(hour +':'+ min);
	
	$("#bt_reset").click(function() {
		$("input[name=custCd]").val("");
		$("input[name=custNo]").val("");
		$("input[name=custNm]").val("");
		$("input[name=tel1No]").val("");
		$("input[name=tel2No]").val("");
		$("input[name=tel3No]").val("");
		$("input[name=faxNo]").val("");
		$("input[name=addr]").val("");
		$("input[name=emailId]").val("");
		$("input[name=custNote]").val("");
		$("input[name=custNote]").val("");
		$("input[name=tab1_resTelNo]").val("");
		$("input[name=tab5_custNo]").val("");
	});
	
	$("#bt_custSave").click(function() {
		mainCustomer.custNo = $("input[name=custNo]").val();
		mainCustomer.custCd = $("input[name=custCd]").val();
		mainCustomer.custNm = $("input[name=custNm]").val();
		mainCustomer.tel1No = $("input[name=tel1No]").val();
		mainCustomer.tel2No = $("input[name=tel2No]").val();
		mainCustomer.tel3No = $("input[name=tel3No]").val();
		mainCustomer.faxNo = $("input[name=faxNo]").val();
		mainCustomer.addr = $("input[name=addr]").val();
		mainCustomer.emailId = $("input[name=emailId]").val();
		mainCustomer.custNote = $("input[name=custNote]").val();

		if(mainCustomer.custCd == "1002"){
			if(mainCustomer.custNo == ""){
				alert("고객번호를 입력해주세요.");
			}else if(mainCustomer.custNm == ""){
				alert("고객명을 입력해주세요.");
			}else if(mainCustomer.tel1No == ""){
				alert("핸드폰번호를 입력해주세요.");
			}else{
				$.ajax({
					url : "/main/insertCustomer2",
					type : "post",
					contentType : 'application/json; charset=utf-8',
					data : JSON.stringify(mainCustomer),
					success : function(result) {
						if(result == 1){
							alert("등록되었습니다.");
							tab1_customer_one(mainCustomer.custNo);
						}else{
							alert("동일 고객이 존재합니다.");
						}
					}
				});
			}
		}else{
			if(mainCustomer.custNm == ""){
				alert("고객명을 입력해주세요.");
			}else if(mainCustomer.tel1No == ""){
				alert("핸드폰번호를 입력해주세요.");
			}else{
				$.ajax({
					url : "/main/insertCustomer",
					type : "post",
					contentType : 'application/json; charset=utf-8',
					data : JSON.stringify(mainCustomer),
					success : function(result) {
						if(result == "0"){
							alert("동일 고객이 존재합니다.");
						}else if(result == "2"){
							alert("정보가 수정되었습니다.");
							tab1_customer_one(mainCustomer.custNo);
						}else{
							alert("등록되었습니다.");
							tab1_customer_one(result);
						}
					}
				});
			}
		}
		
	});
	
	$("#bt_counSave").click(function() {
		mainCoun.counSeq = $("input[name=counSeq]").val();
		mainCoun.custNo = $("input[name=custNo]").val();
		mainCoun.custNm = $("input[name=custNm]").val();
		mainCoun.telNo = $("input[name=tel1No]").val();
		mainCoun.callTypCd = $("input[name=callTypCd]").val();
		mainCoun.counStartDate = $("input[name=counStartDate]").val();
		mainCoun.counStartHms = $("input[name=counStartHms]").val();
		mainCoun.counEndDate = $("input[name=counEndDate]").val();
		mainCoun.counEndHms = $("input[name=counEndHms]").val();
		mainCoun.counCd = $("#callResult").val();
		mainCoun.empNo = $("input[name=empNo]").val();
		mainCoun.empNm = $("input[name=empNm]").val();
		mainCoun.counNote = $("input[name=counNote]").val();
		if(mainCoun != null){
			if(mainCoun.counSeq == ""){
				$.ajax({
					url : "/main/insertCounsel",
					type : "post",
					contentType : 'application/json; charset=utf-8',
					data : JSON.stringify(mainCoun),
					success : function(result) {
						if(result == 1){
							alert("저장되었습니다.");
							counReset();
							$("#counSearch").click();
						}else{
							alert("실패했습니다.");
						}
					}
				});
			}else{
				$.ajax({
					url : "/main/updateCounsel",
					type : "post",
					contentType : 'application/json; charset=utf-8',
					data : JSON.stringify(mainCoun),
					success : function(result) {
						if(result == 1){
							alert("수정되었습니다.");
							counReset();
							$("#counSearch").click();
						}else{
							alert("실패했습니다.");
						}
					}
				});
			}
		}
});
	
	$("#bt_resSave").click(function() {
		mainRes.custNo = $("input[name=custNo]").val();
		mainRes.custNm = $("input[name=custNm]").val();
		mainRes.resTelNo = $("input[name=tab1_resTelNo]").val().replace(/-/gi, "");
		mainRes.resDate = $("input[name=tab1_resDate]").val().replace(/-/gi, "");
		mainRes.resHms = $("input[name=tab1_resHms]").val().replace(/:/gi, "");
		mainRes.counCd = "1001";
		mainRes.empNo = $("input[name=empNo]").val();
		mainRes.empNm = $("input[name=empNm]").val();
		mainRes.resNote = $("input[name=tab1_resNote]").val();
		if(mainRes != null){
			$.ajax({
				url : "/main/insertReservation",
				type : "post",
				contentType : 'application/json; charset=utf-8',
				data : JSON.stringify(mainRes),
				success : function(result) {
					if(result == 1){
						alert("저장되었습니다.");
						reservReset();
					}else{
						alert("실패했습니다.");
					}
				}
			});
		}
});
});
function counReset(){
	$("#callResult").val("");
	$("input[name=counNote]").val("");
	$("input[name=counSeq]").val("");
}
function reservReset(){
	var date = new Date();
	var month = date.getMonth() + 1;
	month = month < 10 ? '0' + month : month;
	var day = date.getDate();
	day = day < 10 ? '0' + day : day;
	var hour = date.getHours() + 1;
	hour = hour < 10 ? '0' + hour : hour;
	var min = date.getMinutes();
	min = min < 10 ? '0' + min : min;
	
	$("input[name=tab1_resDate]").val(date.getFullYear() +'-'+ month +'-'+ day);
	$("input[name=tab1_resHms]").val(hour +':'+ min);
	$("input[name=tab1_resNote]").val("");
}
function tab1_customer_one(custNo){

	var tab1_param = {
			custNo : ""
		};
	
	tab1_param.custNo = custNo;
	$.ajax({
		url : "/main/customerOne",
		type : "post",
		contentType : 'application/json; charset=utf-8',
		data : JSON.stringify(tab1_param),
		success : function(result) {
			if(result != ""){
				$("input[name=custNo]").val(result.custNo);
				$("input[name=tab5_custNo]").val(result.custNo);
				$("input[name=custNm]").val(result.custNm);
				$("#custCd").val(result.custCd);
				$("input[name=addr]").val(result.addr);
				$("input[name=tel1No]").val(result.tel1No);
				$("input[name=tab1_resTelNo]").val(result.tel1No);
				$("input[name=tel2No]").val(result.tel2No);
				$("input[name=tel3No]").val(result.tel3No);
				$("input[name=faxNo]").val(result.faxNo);
				$("input[name=emailId]").val(result.emailId);
				$("input[name=custNote]").val(result.custNote);
			}
		}
	});		
}
</script>
</head>
<body class="jui">
	<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
			<td>
				<table width="100%" border="0" cellpadding="0" cellspacing="0" class="table01" style="margin-bottom: 2px;">
					<tr>
						<td>
							<table width="100%" border="0" cellpadding="0"	cellspacing="0">
								<tr>
									<td width="10" rowspan="4">&nbsp;</td>
									<td width="50" class="td01">고객번호</td>
									<td class="td02">
										<input type="text" name= "custNo" class="input mini" style="width: 120px" />
									</td>
									<td width="45" class="td01">고객명</td>
									<td class="td02">
										<input type="text" name= "custNm" class="input mini" style="width: 120px" />
									</td>
									<td width="55" class="td01">고객유형</td>
									<td class="td02">
										<input type="radio" name="custCd" value="1001" checked> 일반 
										<input type="radio" name="custCd" value="1002"> 사업자 
									<td colspan="2" align="right" class="td01">
										<a class="btn small focus" id="bt_reset">초기화</a> 
										<a class="btn small focus" id="bt_custSave">저장</a>
									</td>
								</tr>
								<tr>
									<td width="50" class="td01">주소</td>
									<td colspan="7" class="td02">
										<input type="text" name= "addr" class="input mini" style="width: 910px" />
									</td>
								</tr>
								<tr>
									<td width="50" class="td01">핸드폰</td>
									<td class="td02">
										<input type="text" name= "tel1No" class="input mini" value="" style="width: 110px" />
									</td>
									<td width="45" class="td01">직장</td>
									<td class="td02">
										<input type="text" name= "tel2No" class="input mini" value="" style="width: 110px" />
									</td>
									<td width="55" class="td01">자택</td>
									<td class="td02">
										<input type="text" name= "tel3No" class="input mini" value="" style="width: 110px" />
										</td>
									<td width="40" class="td01">FAX</td>
									<td class="td02">
										<input type="text" name= "faxNo" class="input mini" value="" style="width: 110px" />
									</td>
								</tr>
								<tr>
									<td width="50" class="td01">E-Mail</td>
									<td colspan="3" class="td02">
										<input type="text" name= "emailId" class="input mini" value="" style="width: 180px" />
									</td>
									<td width="55" class="td01">비고</td>
									<td colspan="3" class="td02">
									 	<input type="text" name= "custNote" class="input mini" style="width: 450px" />
										<input type="hidden" name="empNm" class="input mini" value="<%=session.getAttribute("empNm")%>" style="width: 82px" /> 
										<input type="hidden" name="empNo" class="input mini" value="<%=session.getAttribute("empNo")%>" style="width: 82px" /> 
										<input type="hidden" name="callTypCd" class="input mini" value="1001" style="width: 82px" /> 
										<input type="hidden" name="custInsert" class="input mini" value="<%=session.getAttribute("custInsert")%>" style="width: 82px" /> 
									 </td>
								</tr>
							</table>
						</td>
					</tr>
			</table>
	</table>
	<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" style="margin-bottom: 2px;">
		<tr>
			<td>
				<div class="panel">
					<div class="head">
						<strong>상담이력 등록</strong>
					</div>
					<div class="body">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td>
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td colspan="6"></td>
										</tr>
										<tr>
											<td width="10"></td>
											<td width="50" class="td01">통화결과</td>
											<td>
												<select id="callResult"></select>
											</td>
											<td width="25" class="td01">메모</td>
											<td>
												<input type="text" name="counNote" class="input mini" value="" style="width: 795px" />
												<input type="hidden" name="counSeq" class="input mini" value="" style="width: 795px" />
											</td>
											<td width="50" align="right" class="td01">
												<a class="btn small focus" id="bt_counSave">저 장</a>
											</td>
										</tr>
									</table>
							</tr>
						</table>
					</div>
			</td>
		</tr>
	</table>
	<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
			<td>
				<div class="panel">
					<div class="head">
						<strong>상담예약 등록</strong>
					</div>
					<div class="body">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td>
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td width="10"></td>
											<td width="50" class="td01">예약일시</td>
											<td>
												<span class="td02"> 
												<input type="text"class="input mini" id="tab1_resDate" name="tab1_resDate" value="" style="width: 82px" />
												<input type="text"class="input mini" name="tab1_resHms" value="" style="width: 60px" />
												</span>
											</td>
											<td class="td01">예약전화번호</td>
											<td>
												<span class="td02"> 
												<input type="text" class="input mini" name="tab1_resTelNo" value="" style="width: 120px" />
												</span>
											</td>
											<td width="25" class="td01">메모</td>
											<td>
												<input type="text" class="input mini" name="tab1_resNote" value="" style="width: 520px" />
											</td>
											<td width="50" align="right" class="td01" id="bt_resSave"><a class="btn small focus">저 장</a></td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</div>
			</td>
		</tr>
	</table>
			<div style="height: 45%" id="test">
				<%-- <%@ include file="./pages/tab05.jsp"%> --%>
				<table width="100%" border="0" align="center" cellpadding="0"cellspacing="0">
					<tr>
						<td>
							<ul id="tab_2" class="tab top tab_down" style="margin-top: 2px;">
								<li class="checked"><a href="#tab05" style="padding-bottom: 9px;">상담이력 <i class="icon-arrow1"></i></a>
								<li><a href="#tab06" style="padding-bottom: 9px;">SMS발송/이력<i></i></a></li>
							</ul>

							<div id="tab_contents_2">
								<div id="tab05"><%@ include file="./tab05.jsp"%></div>
								<div id="tab06"><%@ include file="./tab06.jsp"%></div>
							</div>
						</td>
					</tr>
				</table>
			</div>
</body>
</html>