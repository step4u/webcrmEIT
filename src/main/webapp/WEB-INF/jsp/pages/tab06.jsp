<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>[JUI Library] - CSS/Tab</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<style type="text/css">
	body {
		margin-top: 0px;
	}
	.body.fit{
		margin-top:5px;
	}
	.tab.top{
		margin-bottom:1px;
	}
	</style>
	<script type="text/javascript">
	$(document).ready(function() {
		var tab6_param = {
				lcd : "",
			};
		
		var date = new Date();
		var month = date.getMonth() + 1;
		month = month < 10 ? '0' + month : month;
		var day = date.getDate();
		day = day < 10 ? '0' + day : day;
		
		var v = new Date(Date.parse(date) - 14*1000*60*60*24);
		var month2 = v.getMonth() + 1;
		month2 = month2 < 10 ? '0' + month2 : month2;
		var day2 = v.getDate();
		day2 = day2 < 10 ? '0' + day2 : day2;

		$("input[name=tab6_sendDate]").val(date.getFullYear() +'-'+ month2 +'-'+ day2);
		$("input[name=tab6_sendDate2]").val(date.getFullYear() +'-'+ month +'-'+ day);
		//$("input[name=tab6_sendDate]").val(date.getFullYear() +'-'+ month +'-'+ day);

		$("#tab6_sendDate").datepicker({
			showMonthAfterYear : true,
			changeMonth : true,
			changeYear : true,
			dateFormat : "yy-mm-dd"
		});
	
		$("#tab6_sendDate").datepicker({
			showMonthAfterYear : true,
			changeMonth : true,
			changeYear : true,
			dateFormat : "yy-mm-dd"
		});

		tab6_param.lcd ="1009";
		$.ajax({
			url : "/code/selecCodeList",
			type : "post",
			data : JSON.stringify(tab6_param),
			contentType : 'application/json; charset=utf-8',
			success : function(result) {
				$('#sendTypCd').append('<option value=' + '' + '></option>');
			    for ( var i = 0; i < result.length; i++) {
						$('#sendTypCd').append('<option value='+result[i].scd+'>' + result[i].scdNm + '</option>');
			    } 
			}
		});

		$.ajax({
			url : "/empList",
			type : "post",
			data : "",
			contentType : 'application/json; charset=utf-8',
			success : function(result) {
				$('#tab6_empNo').append('<option value=' + '' + '></option>');
			    for ( var i = 0; i < result.length; i++) {
						$('#tab6_empNo').append('<option value='+result[i].empNo+'>' + result[i].empNm + '</option>');
			    } 
			}
		});
		
		jui.ready([ "grid.table", "ui.paging" ], function(table, paging) {

			var data;
			var data_size;
			var page = 1;
			var result_data;
			
			tab_smsList = table("#tab_smsList", {
				scroll : true, 
				resize : true,
			});
		
		$("#smsSearch").click(function() {
			var sms = {
					sendDate : "",
					sendDate2 : "",
					sendTypCd : "",
					empNo : "",
					custNo : "",
				};

			sms.sendDate = $("input[name=tab6_sendDate]").val().replace(/-/gi, ""); 
			sms.sendDate2 = $("input[name=tab6_sendDate2]").val().replace(/-/gi, ""); 
			sms.sendTypCd = $("#sendTypCd option:selected").val();
			sms.empNo = $("#tab6_empNo option:selected").val();
			sms.custNo = $("input[name=tab6_custNo]").val(); 

			$.ajax({
				url : "/main/selectSms",
				type : "post",
				contentType : 'application/json; charset=utf-8',
				data : JSON.stringify(sms),
				success : function(result) {
					if(result != ""){
						page=1;
						result_data = result;
						data_size = result.length;
						var jsonData = JSON.stringify(result);
						data = JSON.parse(jsonData);

						tab_smsList.reset();
						paging_6.reload(data_size);
						
						var start = (page-1)*5
						var end = page*5
						for (var i = start; i < end; i++){
							tab_smsList.append(result[i]);
						}
					}else{
						tab_smsList.reset();
						paging_6.reload(0);
					}
				}
			});
		});
		
			paging_6 = paging("#paging_6", {
			        count: 5,
			        pageCount: 5,
			        event: {
			            page: function(pNo) {
			                page = pNo;
			                
			                tab_smsList.reset();
							var start = (page-1)*5
							var end = page*5
							for (var i = start; i < end; i++){
								tab_smsList.append(result_data[i]);
							}
			            }
			        }
			    });
			 //$("#smsSearch").click();
			});
		});
		
</script>

<script data-jui="#tab_smsList" data-tpl="row" type="text/template">
		<tr>
			<td align ="center"><!= custNo !></td>
			<td align ="center"><!= custNm !></td>
			<td align ="center"><!= sendTelNo !></td>
			<td align ="center"><!= sendCdNm !></td>
			<td align ="center"><!= sendResDate !> <!= sendResHms !></td>
			<td align ="center"><!= sendDate !> <!= sendHms !></td>
			<td align ="center"><!= sendTypCdNm !></td>
			<td align ="center"><!= empNm !></td>
		</tr>
	</script>

<script data-jui="#paging_6" data-tpl="pages" type="text/template">
	    <! for(var i = 0; i < pages.length; i++) { !>
	    <a href="#" class="page"><!= pages[i] !></a>
	    <! } !>
</script>

<script data-jui="#tab_smsList" data-tpl="none" type="text/template">
    <tr height ="100px">
        <td colspan="8" class="none" align="center">Data does not exist.</td>
    </tr>
</script>

</head>
<body class="jui">
	<!-- <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
	  <tr>
	    <td><ul class="tab top" style="margin-top:2px;">
			<li><a href="#" style="padding-bottom:9px;">상담이력 </a></i>
		<li class="checked"><a href="#" style="padding-bottom:9px;">SMS발송/이력<i class="icon-arrow1"></a></td>
      </tr> -->
      <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
	  <tr>
	    <td>
		  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="table01">
			  <tr>
				  <td ><table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
				    <tr>
				      <td class="td01">전송일자</td>
				      <td class="td02">
				      	<input type="text" id="tab6_sendDate" name="tab6_sendDate" class="input mini" value="" style="width:82px" />
			         	 <input type="text" id="tab6_sendDate" name="tab6_sendDate2" class="input mini" value="" style="width:82px" />
			         	 <input type="hidden" name="tab6_custNo"/>
			          </td>
				      <td class="td01">전송유형</td>
				      <td class="td02">
							<select id="sendTypCd"></select>
                      </td>
				      <td class="td01">상담원</td>
				      <td class="td02">
							<select id="tab6_empNo"></select>
                      </td>
                      <td width="200" class="td02">&nbsp;</td>
				      <td width="130" align="right" class="td01">
				      	<a class="btn small focus" id="smsSearch">조 회</a> 
				      	<a class="btn small focus" onclick="win_14.show();">SMS 전송</a>
				      </td>
			        </tr>
		        		</table>
				    <table width="100%" border="0" cellpadding="0" cellspacing="0">
				      <tr>
				        <td height="3"></td>
			          </tr>
			        </table>
				    <table class="table classic hover"  id="tab_smsList" width="100%">
				      <thead>
				        <tr>
				          <th class="th01">고객번호</th>
				          <th>고객명</th>
				          <th width="15%">전화번호</th>
				          <th>전송유형</th>
				          <th width="20%">예약일시</th>
				          <th width="20%">전송일시</th>
				          <th>전송결과</th>
				          <th>전송자</th>
			            </tr>
			          </thead>
				      <tbody></tbody>
			        </table>
							<br>
							<div id="paging_6" class="paging"
								style="width: 100%; margin-top: 3px;">
								<a href="#" class="prev">Previous</a>
								<div class="list"></div>
								<a href="#" class="next">Next</a>
							</div>
                </td>
	    	</tr>
		  </table>
      </table>
</body>
</html>