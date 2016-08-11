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
			scrollWidth: 1095,
			width:1099,
	        buffer: "s-page",
	        bufferCount: 20,
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
						page=1;
						tab_customerList.update(result);
						tab_customerList.resize();
				}
			});
		});

		paging_main = function(no) {
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
					if(result>0){
						alert("삭제되었습니다.");
						$("#bt_customer").click();
					}else{
						alert("실패했습니다.");
					}
				}
			}); 
		});
		
		$("#bt_customerExcel").click(function() {
			var empNm = $("input[name=empNm]").val();
			tab2_param.telNo = $("input[name=tab2_telNo]").val();
			tab2_param.custNm = $("input[name=tab2_custNm]").val();
			tab2_param.custNo = $("input[name=tab2_custNo]").val();

			$("#ifra").attr("src", "/main/customerListExcel?telNo="+tab2_param.telNo+"&custNm="+tab2_param.custNm+"&custNo="+tab2_param.custNo+"&empNm="+empNm);
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
					$("input[name=tab6_custNo]").val(result.custNo);
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
				$("#smsSearch").click();
				counReset();
				reservReset();
				$("#click_tab1").click();
			}
		});		
	}
	function tab2_chkAll(){
        if($("#tab2_chkAll").prop("checked")){
            $("input[name=tab2_chk]").prop("checked",true);
        }else{
            $("input[name=tab2_chk]").prop("checked",false);
        }
	}
</script>

<script data-jui="#tab_customerList" data-tpl="row" type="text/template">
	<tr id="<!= row.index !>" ondblclick="javascript:customer_one(<!= custNo !>);">
		<td align ="center"><input type="checkbox" name="tab2_chk" value="<!= custNo !>"/></td>
		<td align ="center"><!= parseInt(row.index)+1 !></td>
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

<script data-jui="#tab_customerList" data-tpl="none" type="text/template">
    <tr height ="400">
        <td colspan="12" class="none" align="center">Data does not exist.</td>
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
										<a class="btn small focus" id="bt_customerExcel">엑셀저장</a>
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
									<th style="width: 15px;"><input type="checkbox" id="tab2_chkAll" onclick="javascript:tab2_chkAll();"/></th>
									<th style="width: 25px;">SEQ</th>
									<th style="width: 30px;">유형</th>
									<th style="width: 50px;">고객번호</th>
									<th style="width: 50px;">고객명</th>
									<th style="width: 95px;">핸드폰</th>
									<th style="width: 95px;">직장</th>
									<th style="width: 95px;">자택</th>
									<th style="width: 130px;">eMail</th>
									<th style="width: 95px;">FAX</th>
									<th style="width: 150px;">주소</th>
									<th style="width: 130px;">비고</th>
								</tr>
							</thead>
							 <tbody>
							</tbody> 
						</table>
						<br>
						<div class="row" align="right" style="text-align: right; margin-top: 3px;">
						    <div class="group">
						        <button onclick="paging_main(-1);" class="btn mini">Prev</button>
						        <button onclick="paging_main(1);" class="btn mini">Next</button>
						    </div>
						</div>
					</td>
				</tr>
			</table>
	</table>
<iframe id="ifra" name="ifra" style="display:none;"></iframe>
</body>
</html>