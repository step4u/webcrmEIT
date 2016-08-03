<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>[JUI Library] - CSS/Tab</title>
<%-- <%@ include file="../common/jui_common.jsp"%> --%>
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

	var tab3_param = {
			lcd : "",
		};

	var tab3_callback = {
			resDate : "",
			empNo : "",
			counCd : "",
		};

	jui.ready([ "grid.xtable" ], function(xtable) {

		var data;
		var data_size;
		var page = 1;
		var result_data;
		
		tab_callbackList = xtable("#tab_callbackList", {
			/* scroll : true,  */
			resize : true,
			scrollHeight: 400,
	        buffer: "s-page",
	        bufferCount: 20
		});
		
		$("#bt_callback").click(function() {
			tab3_callback.resDate = $("input[name=tab3_resDate]").val().replace(/-/gi, "");
			tab3_callback.empNo = $("#tab3_empNo option:selected").val();
			tab3_callback.counCd = $("#tab3_counResult option:selected").val();
			
			$.ajax({
				url : "/main/callbackList",
				type : "post",
				contentType : 'application/json; charset=utf-8',
				data : JSON.stringify(tab3_callback),
				success : function(result) {
					if(result!=""){
						page=1;
						tab_callbackList.update(result);
						tab_callbackList.resize();
						
						var callbackSize = tab_callbackList.size();
						tab3_param.lcd ="1011";
						
						$.ajax({
							url : "/code/selecCodeList",
							type : "post",
							data : JSON.stringify(tab3_param),
							contentType : 'application/json; charset=utf-8',
							success : function(result) {
									$(".tab3_counResult2").append('<option value=' + '' + '></option>');
								    for ( var j = 0; j < result.length; j++) {
								    	$(".tab3_counResult2").append('<option value='+result[j].scd+'>' + result[j].scdNm + '</option>');
								    }
								    for ( var i = 0; i < callbackSize; i++) {
										$("#tab3_"+i+" .tab3_counResult2").val($("#tab3_"+i+" input[name=tab3_counCd2]").val());
								    }
						    }
						}); 
					}else{
						tab_callbackList.resize();
					}

				}
			});

		});

		paging_2 = function(no) {
	        page += no;
	        page = (page < 1) ? 1 : page;
	        tab_callbackList.page(page);
	    }
		$("#bt_callback").click();
	});

	$(document).ready(function() {
		$("#tab3_resDate").datepicker({
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
		
		$("input[name=tab3_resDate]").val(date.getFullYear() +'-'+ month +'-'+ day);

		tab3_param.lcd ="1011";
		$.ajax({
			url : "/code/selecCodeList",
			type : "post",
			data : JSON.stringify(tab3_param),
			contentType : 'application/json; charset=utf-8',
			success : function(result) {
				$('#tab3_counResult').append('<option value=' + '' + '></option>');
			    for ( var i = 0; i < result.length; i++) {
						$('#tab3_counResult').append('<option value='+result[i].scd+'>' + result[i].scdNm + '</option>');
			    } 
			}
		});

		$.ajax({
			url : "/empList",
			type : "post",
			data : "",
			contentType : 'application/json; charset=utf-8',
			success : function(result) {
				$('#tab3_empNo').append('<option value=' + '' + '></option>');
			    for ( var i = 0; i < result.length; i++) {
					   <%--  if(<%=session.getAttribute("empNo") %>==result[i].empNo){
				    		$('#tab3_empNo').append('<option value='+result[i].empNo+' selected>' + result[i].empNm + '</option>');
					    }else{ }--%>
				    		$('#tab3_empNo').append('<option value='+result[i].empNo+'>' + result[i].empNm + '</option>');
			    }
			}
		});
		
});

function customer_one2(telNo){
	var customer = {
			telNo : "",
			custNm : "",
			custNo : "",
		};
	customer.telNo = telNo;
	$.ajax({
		url : "/main/customerList",
		type : "post",
		contentType : 'application/json; charset=utf-8',
		data : JSON.stringify(customer),
		success : function(result) {
			if(result != ""){
				$("input[name=custNo]").val(result[0].custNo);
				$("input[name=custNm]").val(result[0].custNm);
				$("#custCd").val(result[0].custCd);
				$("input[name=addr]").val(result[0].addr);
				$("input[name=tel1No]").val(result[0].tel1No);
				$("input[name=tel2No]").val(result[0].tel2No);
				$("input[name=tel3No]").val(result[0].tel3No);
				$("input[name=faxNo]").val(result[0].faxNo);
				$("input[name=emailId]").val(result[0].emailId);
				$("input[name=custNote]").val(result[0].custNote);
				if(result.length == 1){
					$("input[name=tab5_custNo]").val(result[0].custNo);
					//$("input[name=tab5_cStartDate]").val(date.getFullYear()-1 +'-'+ month +'-'+ day);
					//$("input[name=tab5_cEndDate]").val("");
					$("#counSearch").click();
					$("#click_tab1").click();
					//고객정보화면 팝업 
				}else if(result.length > 1){
					win_13.show();					
					//$("input[name=tab2_telNo]").val(telNo);
					//$("#click_tab2").click();
					//$("#bt_customer").click();
					//1건 존재 고객정보관리화면 popup, 상담이력 sms 이력을 display
				}
			}else{
				$("#click_tab1").click();
				$("#bt_reset").click();
				counReset();
				//고객정보화면 clear 
			}
		}
	});
}
 function setCbSeq(cbSeq,counCd){
	 $("input[name=tab3_cbSeq]").val(cbSeq);
	 $("#tab3_counResult").val(counCd);
 }
 
 function counChange(cbSeq,counCd){
	 $("input[name=tab3_cbSeq]").val(cbSeq);
	 $("input[name=tab3_counCd]").val(counCd.value);
 }
 
 function callbackSave(){
		var callback = {
				cbSeq : "",
				empNo : "",
				empNm : "",
				counCd : "",
			};
		
		callback.cbSeq = $("input[name=tab3_cbSeq]").val();
		callback.empNo = $("input[name=tab3_empNoS]").val();
		callback.empNm = $("input[name=tab3_empNmS]").val();
		callback.counCd = $("input[name=tab3_counCd]").val();
		
		$.ajax({
			url : "/main/callbackSave",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(callback),
			success : function(result) {
				if(result == 1){
					alert("저장되었습니다.");
					$("#tab3_counResult").val("");
					$("#tab3_empNo").val("");
					$("#bt_callback").click();
				}else{
					alert("실패했습니다.");
				}
			}
		});
	 
 }
</script>

<script data-jui="#tab_callbackList" data-tpl="row" type="text/template">
	<tr id="tab3_<!=row.index !>">
		<td align ="center"><!= cbSeq !></td>
		<td align ="center" ondblclick="javascript:customer_one2('<!= resTelNo !>');"><!= resTelNo !></td>
		<td align ="center"><!= resDate !> <!= resHms !></td>
		<td align ="center"><!= counDate !> <!= counHms !></td>
		<td align ="center"><input type="hidden" name="tab3_counCd2" value="<!= counCd !>"/><select class="tab3_counResult2" onchange="javascript:counChange('<!= cbSeq !>',this);"></select></td>
		<td align ="center"><!= empNm !></td>
	</tr>
</script>

<script data-jui="#tab_callbackList" data-tpl="none" type="text/template">
    <tr height ="400">
        <td colspan="6" class="none" align="center">Data does not exist.</td>
    </tr>
</script>
</head>
<body class="jui">
	<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" style="margin-bottom: 7px;">
		<tr>
			<td>
				<table width="100%" border="0" align="center"cellpadding="0" cellspacing="0" class="table01">
					<tr>
						<td>
							<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
								<tr>
									<td class="td01">요청일자</td>
									<td class="td02">
										<input type="text" id="tab3_resDate" name="tab3_resDate" class="input mini" style="width: 82px" /> 
										<input type="hidden" name="tab3_cbSeq" class="input mini" style="width: 82px" /> 
										<input type="hidden" name="tab3_counCd" class="input mini" style="width: 82px" /> 
										<input type="hidden" name="tab3_empNoS" class="input mini" value ="<%=session.getAttribute("empNo")%>" style="width: 82px" /> 
										<input type="hidden" name="tab3_empNmS" class="input mini" value ="<%=session.getAttribute("empNm")%>" style="width: 82px" /> 
									</td>
									<td class="td01">상담원</td>
									<td class="td02">
										<select id="tab3_empNo"></select>
									</td>
									<td class="td01">상담결과</td>
									<td class="td02">
										<select id="tab3_counResult"></select>
									</td>
									<td width="360">&nbsp;</td>
									<td width="140" align="right" class="td01">
										<a class="btn small focus" id="bt_callback">조 회</a> 
										<a class="btn small focus" id="bt_callbackSave" href="javascript:callbackSave()">저 장</a></td>
								</tr>
							</table>
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td height="3"></td>
								</tr>
							</table>
							<table class="table classic hover" id="tab_callbackList" width="100%">
								<thead>
									<tr>
										<th width="10%" class="th01">콜백번호</th>
										<th width="20%">예약번호</th>
										<th width="20%">예약일시</th>
										<th width="20%">처리일시</th>
										<th width="20%">처리결과</th>
										<th width="10%">상담원</th>
									</tr>
								</thead>
								<tbody>
								</tbody>
							</table>
							<br>
							<div class="row" align="right" style="text-align: right; margin-top: 3px;">
							    <div class="group">
							        <button onclick="paging_2(-1);" class="btn mini">Prev</button>
							        <button onclick="paging_2(1);" class="btn mini">Next</button>
							    </div>
							</div>
						</td>
					</tr>
				</table>
	</table>
</body>
</html>