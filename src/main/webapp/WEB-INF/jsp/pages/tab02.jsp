<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
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
	var tab2_param = {
			telNo : "",
			custNm : "",
			custNo : "",
		};
	
	jui.ready([ "grid.xtable"], function(xtable) {

		var data;
		var data_size;
		var page = 1;
		var result_data;
		
		tab_customerList = xtable("#tab_customerList", {
			 //scroll : true,  
			resize : true,
			scrollHeight: 400,
	        buffer: "s-page",
	        bufferCount: 20,
			csv:["custCdNm","custNo","custNm","tel1No","tel2No","tel3No","emailId","faxNo","addr","custNote"],
			csvNames:["유형","고객번호","고객명","연락처1","연락처2","연락처3","eMail","FAX","주소","비고"],
	        event: {
	        	colresize: function(column, e) {
	                $("#bt_csv").attr("href", this.getCsvBase64());
	            }
	        }
		});
		
		$("#bt_customer").click(function() {
			tab2_param.telNo = $("input[name=tab2_telNo]").val();
			tab2_param.custNm = $("input[name=tab2_custNm]").val();
			tab2_param.custNo = $("input[name=tab2_custNo]").val();

			$.ajax({
				url : "/main/customerList",
				type : "post", 
				contentType : 'application/json; charset=utf-8',
				data : JSON.stringify(tab2_param),
				success : function(result) {
					if(result!=""){
						page=1;
						tab_customerList.update(result);
						tab_customerList.resize();
					}else{
						tab_customerList.resize();
					}
				}
			});
		});

		paging_1 = function(no) {
	        page += no;
	        page = (page < 1) ? 1 : page;
	        tab_customerList.page(page);
	    }
		 $("#bt_csv").attr("href", tab_customerList.getCsvBase64());
		 $("#bt_customer").click();
	});

	$(document).ready(function() {
		$("#bt_customerdel").click(function() {
			var chkLength = 0;
			var result = "";
			chkLength = tab_customerList.size();
			for(var i = 0; i< chkLength; i++){
				if($("#"+i+" input[name=tab2_chk]:checked").is(":checked")){
					if(result == ""){
						result = $("#"+i+" input[name=tab2_chk]").val();
					}else{
						result += ","+$("#"+i+" input[name=tab2_chk]").val()
					}
				}
			}
			tab2_param.custNo = result;
			 $.ajax({
				url : "/main/deleteCustomer",
				type : "post", 
				contentType : 'application/json; charset=utf-8',
				data : JSON.stringify(tab2_param),
				success : function(result) {
					if(result>1){
						alert("삭제되었습니다.");
						$("#bt_customer").click();
					}else{
						alert("실패했습니다.");
					}
				}
			}); 
		});
	});
	
	function customer_one(custNo){
		tab2_param.custNo = custNo;
		$.ajax({
			url : "/main/customerOne",
			type : "post",
			contentType : 'application/json; charset=utf-8',
			data : JSON.stringify(tab2_param),
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
				$("#counSearch").click();
				counReset();
				reservReset();
				$("#click_tab1").click();
			}
		});		
	}
</script>

<script data-jui="#tab_customerList" data-tpl="row" type="text/template">
	<tr id="<!= row.index !>" ondblclick="javascript:customer_one(<!= custNo !>);">
		<td align ="center"><input type="checkbox" name="tab2_chk" value="<!= custNo !>"/></td>
		<td align ="center"><!= row.index !></td>
		<td align ="center"><!= custCdNm !></td>
		<td align ="center"><!= custNo !></td>
		<td><!= custNm !></td>
		<td><!= tel1No !></td>
		<td><!= tel2No !></td>
		<td><!= tel3No !></td>
		<td><!= emailId !></td>
		<td><!= faxNo !></td>
		<td><!= addr !></td>
		<td><!= custNote !></td>
	</tr>
</script>

</head>
<body class="jui">
	<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" style="margin-bottom: 7px; height: 100%">
		<tr>
			<td>
				<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
					<tr>
						<td>
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr>
									<td class="td01">전화번호</td>
									<td class="td02">
										<input type="text" name="tab2_telNo" class="input mini" style="width: 100px" />
									</td>
									<td class="td01"><span class="td01">고객명</span></td>
									<td class="td02">
										<input type="text" name="tab2_custNm" class="input mini" style="width: 70px" />
									</td>
									<td class="td01"><span class="td01">고객번호</span></td>
									<td class="td02">
										<input type="text" name="tab2_custNo" class="input mini" style="width: 82px" />
									</td>
									<td width="150" class="td02">&nbsp;</td>
									<td width="200" align="right" class="td01">
										<a class="btn small focus" id="bt_customer">조 회</a>
										<a class="btn small focus" id="bt_customerdel">삭제</a>
										<a class="btn small focus" id="bt_csv" download="고객리스트.csv" >엑셀저장</a>
									</td>
								</tr>
							</table>
						<table border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td height="3"></td>
							</tr>
						</table>
						<table class="table classic hover" id="tab_customerList" width="100%">
							<thead>
								<tr>
									<th width="2%"></th>
									<th width="5%">SEQ</th>
									<th width="5%">유형</th>
									<th width="6%">고객번호</th>
									<th width="5%">고객명</th>
									<th width="10%">연락처1</th>
									<th width="10%">연락처2</th>
									<th width="10%">연락처3</th>
									<th width="15%">eMail</th>
									<th width="10%">FAX</th>
									<th width="15%">주소</th>
									<th width="10%">비고</th>
								</tr>
							</thead>
							 <tbody>
							</tbody> 
						</table>
						<br>
						<div class="row" align="right" style="text-align: right; margin-top: 3px;">
						    <div class="group">
						        <button onclick="paging_1(-1);" class="btn mini">Prev</button>
						        <button onclick="paging_1(1);" class="btn mini">Next</button>
						    </div>
						</div>
					</td>
				</tr>
			</table>
	</table>
</body>
</html>