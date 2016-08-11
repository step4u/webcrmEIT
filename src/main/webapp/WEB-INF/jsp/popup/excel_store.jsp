<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<script>
var param2 = {
/* 		custNo : "", */
		custCd : "",
		custNm : "",
		tel1No : "",
		tel2No : "",
		tel3No : "",
		emailId : "",
		faxNo : "",
		addr : "",
		custNote : ""
		
};
var paramdata = {
		custCd : "",
		custNo : "",
		custNm : "",
		tel1No : "",
		tel2No : "",
		tel3No : ""
};
var param1 = {};
var arr = new Array();
var obj = new Object();

/* 엑셀 저장할 때  */
var arr2 = new Array();
var obj2 = new Object();

jui.ready([ "grid.xtable"], function(xtable) { 
 	var data;
	var data_size;
	var page = 1;
	var result_data;
	
	var tableTr = "";
	
	tab_excelList = xtable("#tab_excelList", {
		/* fields: [ "CustCdNm", "CustNo" ,"CustNm","Tel1No","Tel2No","Tel3No","EmailId","FaxNo","Addr","CustNote"], */
		resize : true,
		scrollHeight: 480,
		width : 1700,
        scrollWidth: 1325,
        buffer: "s-page",
        bufferCount: 2000,
	});
	
    
	/*
	 * 엑셀로 고객정보 저장
	 * excel_store.jsp
	 * Button Name : 엑셀선택
	 */	
	 $("#bt_selectExcel").click(function() {
		$("#bt_file").click();
		//$("#bt_selectExcel").val($("#bt_file").val());
	 });

	$("#bt_file").change(function() {
		var thumbext = $("#bt_file").val(); //파일을 추가한 input 박스의 값
		thumbext = thumbext.slice(thumbext.indexOf(".") + 1).toLowerCase(); //파일 확장자를 잘라내고, 비교를 위해 소문자로 만듭니다.
		if(thumbext != "xlsx"){ //확장자를 확인합니다.
			alert('엑셀파일(.xlsx)만 등록 가능합니다.'); 
		}else{
			$.ajax({
		        url:"/popup/read_xlsx",
		        type: "POST",
		        data: new FormData($("#upload_file_frm")[0]),
		        enctype: 'multipart/form-data',
		        processData: false,
		        contentType: false,
		        cache: false,
		        success: function () {
		            //alert("File Upload Success");
		        },
		        error: function () {
		           // alert("File Upload Error");
		        }
		    });
			
			setTimeout(function loadexcel(){
				$.ajax({
					url : "/popup/read_xlsx2",
					type : "post",
					contentType : 'application/json; charset=utf-8',
					data : JSON.stringify(param1),
					beforeSend : function(){
						document.getElementById('loadingData').innerHTML = "요청하신 데이터를 불러오는 중입니다.";
						document.getElementById("wrap-loading").classList.remove("display-none");
					},
					complete:function(){
						document.getElementById("wrap-loading").classList.add("display-none");
				    },
					success : function(result) {
						if(result != ""){
							page=1;
							tab_excelList.update(result);
							tab_excelList.resize(); 
							tableTr = tab_excelList.size();
							$("#bt_insertExcel").attr('disabled',true);
							$("#bt_file").val('');
					 	}else{
							tab_excelList.resize(); 
						} 
						
					}
				}); 
			},2000);
		}
	});
	
	
	paging_excel = function(no) {
        page += no;
        page = (page < 1) ? 1 : page;
        tab_excelList.page(page);
	}

    /* 데이터검증 */ 
	$("#bt_excelData").click(function() {
		document.getElementById('loadingData').innerHTML = "데이터를 검증 중입니다.";
		document.getElementById("wrap-loading").classList.remove("display-none");
		$("[name=insertOX]").val("");
		var dataChk = '';
		var trExcel = $('.trExcel');
		setTimeout(function(){
			for(var i = 0; i < trExcel.length; i++){
				obj = new Object();
				obj.custCd = document.querySelectorAll(".cust_cdNm")[i].innerHTML;
				obj.custNo = document.querySelectorAll(".cust_no")[i].innerHTML;
				obj.custNm = document.querySelectorAll(".cust_nm")[i].innerHTML;
				obj.tel1No = document.querySelectorAll(".tel1_no")[i].innerHTML;
				obj.tel2No = document.querySelectorAll(".tel2_no")[i].innerHTML;
				obj.tel3No = document.querySelectorAll(".tel3_no")[i].innerHTML;
				//alert(paramdata.custCd + "," + paramdata.custNo + "," + paramdata.custNm + "," + paramdata.tel1No);
	
				if(obj.custCd == "개인"){
					obj.custCd = '1001';
				}else if(obj.custCd == "사업자"){
					obj.custCd = '1002';
				}
				arr.push(obj);
			}
		
			$.ajax({
				url : "/popup/excelData",
				type : "post",
				contentType : 'application/json; charset=utf-8',
				data : JSON.stringify(arr),
				success : function(result) {
					for(var i=0; i<result.length; i++){
						dataChk = result[i];
						if(dataChk == '1000'){
							document.querySelectorAll(".insertChk")[i].innerHTML = "가능";
							document.querySelectorAll(".insertChk")[i].style.color = "black";
							document.querySelectorAll(".insertChk")[i].style.fontWeight = "normal";
							document.querySelectorAll(".cust_no")[i].innerHTML = "";
						}else if(dataChk == '1100'){
							document.querySelectorAll(".insertChk")[i].innerHTML = "선택필요(중복)";
							document.querySelectorAll(".insertChk")[i].style.color = "blue";
							document.querySelectorAll(".insertChk")[i].style.fontWeight = "bold";
							document.querySelectorAll(".cust_no")[i].innerHTML = "";
						}else if(dataChk == '2000'){
							document.querySelectorAll(".insertChk")[i].innerHTML = "가능";
							document.querySelectorAll(".insertChk")[i].style.color = "black";
							document.querySelectorAll(".insertChk")[i].style.fontWeight = "normal";
						}else if(dataChk == '2100'){
							document.querySelectorAll(".insertChk")[i].innerHTML = "불가(중복)";
							document.querySelectorAll(".insertChk")[i].style.color = "red";
							document.querySelectorAll(".insertChk")[i].style.fontWeight = "bold";
							document.querySelectorAll(".excel_chk")[i].disabled = true;
						}else if(dataChk == '1001'){
							document.querySelectorAll(".insertChk")[i].innerHTML = "가능";
							document.querySelectorAll(".insertChk")[i].style.color = "black";
							document.querySelectorAll(".insertChk")[i].style.fontWeight = "normal";
							document.querySelectorAll(".cust_no")[i].innerHTML = "";
						}else if(dataChk == '1101'){
							document.querySelectorAll(".insertChk")[i].innerHTML = "선택필요(중복)";
							document.querySelectorAll(".insertChk")[i].style.color = "blue";
							document.querySelectorAll(".insertChk")[i].style.fontWeight = "bold";
							document.querySelectorAll(".cust_no")[i].innerHTML = "";
						}else if(dataChk == '4000'){
							document.querySelectorAll(".insertChk")[i].innerHTML = "불가(사업자번호)";
							document.querySelectorAll(".excel_chk")[i].disabled = true;
							document.querySelectorAll(".insertChk")[i].style.color = "red";
							document.querySelectorAll(".insertChk")[i].style.fontWeight = "bold";
						}else if(dataChk == '4100'){
							document.querySelectorAll(".insertChk")[i].innerHTML = "불가(사업자번호오류)";
							document.querySelectorAll(".excel_chk")[i].disabled = true;
							document.querySelectorAll(".insertChk")[i].style.color = "red";
							document.querySelectorAll(".insertChk")[i].style.fontWeight = "bold";
						}
					}
					$("#bt_insertExcel").attr('disabled',false);
					arr = [];
					document.getElementById("wrap-loading").classList.add("display-none");
				}
			});	
		}, 100);
		//document.querySelectorAll(".excelData")[i].innerHTML = dataChk;
	});
	
	/*
	 * 엑셀로 고객정보 저장
	 * excel_store.jsp
	 * Button Name : 저장
	 */	

	$("#bt_insertExcel").click(function() {
		var cnt = $('input:checkbox[name="excel_chk"]:checked').length;
	    if(cnt == 0){
	         alert('저장할 데이터를 선택해주세요.');
	    }else{
	    	document.getElementById('loadingData').innerHTML = "선택한 고객정보를 저장 중입니다.";
			document.getElementById("wrap-loading").classList.remove("display-none");
		 	var chkLength = 0;
			var chktemp = "";
			chkLength = tab_excelList.size();
			for(var i = 0; i< chkLength; i++){
				 if($("#"+i+"_excel input[name=excel_chk]:checked").is(":checked")){
					if(chktemp == ""){
						chktemp = $("#"+i+"_excel input[name=excel_chk]").val();
					}else{
						chktemp += ","+$("#"+i+"_excel input[name=excel_chk]").val();
					}
				}  
			} 
			var chkNumber = chktemp;
			var chkindex = new Array();
			chkindex = chkNumber.split(',');
			
			var temp;
			$('.trExcel').each(function(index){
				for(var i=0; i < tableTr; i++){
					var num = index+1;	
					if(chkindex[i] == num){
						param2.custCd = $(this).find('#cust_cdNm').html();
						param2.custNo = $(this).find('#cust_no').html();
			 			param2.custNm = $(this).find('#cust_nm').html();
						param2.tel1No = $(this).find('#tel1_no').html();
						param2.tel2No = $(this).find('#tel2_no').html();
						param2.tel3No = $(this).find('#tel3_no').html();
						param2.emailId = $(this).find('#emailid').html();
						param2.faxNo = $(this).find('#fax_no').html();
						param2.addr = $(this).find('#addr').html();
						param2.custNote = $(this).find('#cust_note').html();
			
						if(param2.custCd == "개인"){
							param2.custCd = '1001';
							$.ajax({
								url : "/popup/insertCustomer",
								type : "post",
								contentType : 'application/json; charset=utf-8',
								data : JSON.stringify(param2),
								success : function(result) {
									temp = result;
									if(temp == 1){
										$('[name=insertOX]').eq(index).html('O');
									}else{
										$('[name=insertOX]').eq(index).html('X');
									}
								}
							});
						}else if(param2.custCd == "사업자"){
							param2.custCd = '1002';
							$.ajax({
								url : "/popup/insertCustomer2",
								type : "post",
								contentType : 'application/json; charset=utf-8',
								data : JSON.stringify(param2),
								success : function(result) {
									temp = result;
									if(temp == 1){
										$('[name=insertOX]').eq(index).html('O');
									}else{
										$('[name=insertOX]').eq(index).html('X');
									}
								}
							});
						}
					}
				}
			});
			setTimeout(function msgExcel(){
				if(temp == 1){
					document.getElementById("wrap-loading").classList.add("display-none");
					alert("저장이 완료되었습니다.");
					$("#excel_checkall").prop("checked",false);
					$("input[name=excel_chk]").prop("checked",false);
					$("#bt_insertExcel").attr('disabled',true);
				}else{ 
					document.getElementById("wrap-loading").classList.add("display-none");
					alert("실패하였습니다.");
				} 
			},1000);
	    }
		
	});
});
    
$(document).ready(function(){
    $("#excel_checkall").click(function(){
        if($("#excel_checkall").prop("checked")){
            $("input[name=excel_chk]").not(":disabled").prop("checked",true);
        }else{
            $("input[name=excel_chk]").prop("checked",false);
        }
    }); 
    
    $("#bt_excelPopup").click(function(){
    	tab_excelList.update();
    });
    
    $("#bt_excelExport").click(function() {
    	var trExcel = $('.trExcel');
		for(var i = 0; i < trExcel.length; i++){
			obj2 = new Object();
			obj2.cust_cdNm = document.querySelectorAll(".cust_cdNm")[i].innerHTML;
			obj2.insertChk = document.querySelectorAll(".insertChk")[i].innerHTML;
			obj2.custNo = document.querySelectorAll(".cust_no")[i].innerHTML;
			obj2.custNm = document.querySelectorAll(".cust_nm")[i].innerHTML;
			obj2.tel1No = document.querySelectorAll(".tel1_no")[i].innerHTML;
			obj2.tel2No = document.querySelectorAll(".tel2_no")[i].innerHTML;
			obj2.tel3No = document.querySelectorAll(".tel3_no")[i].innerHTML;
			obj2.emailid = document.querySelectorAll(".emailid")[i].innerHTML;
			obj2.fax_no = document.querySelectorAll(".fax_no")[i].innerHTML;
			obj2.addr = document.querySelectorAll(".addr")[i].innerHTML;
			obj2.cust_note = document.querySelectorAll(".cust_note")[i].innerHTML;

			arr2.push(obj);
		}
		var jsonEncode = JSON.stringify(arr);
		$("#ifraPopup").attr("src", "/popup/excelListExport?data=" + jsonEncode);
	});
    
});
/* 취소버튼 click Event */
function cancel(){
	$("#tbodyid").empty();
	$("#list").empty();
}
/* replaceAll 메소드 */
String.prototype.replaceAll = function(org, dest) {
    return this.split(org).join(dest);
}

</script>
<script data-jui="#tab_excelList" data-tpl="row" type="text/template">
	<tr id="<!= row.index !>_excel" class="trExcel">
		<td><input type="checkbox" name="excel_chk" class="excel_chk" value="<!= parseInt(row.index)+1 !>"/></td>
		<td name="excelNumber"><!= parseInt(row.index)+1 !></td>
		<td class="excelData" style="display:none;"></td>
		<td class="insertChk"></td>
		<td class="insertOX"></td>
		<td id="cust_cdNm" class="cust_cdNm" align ="center"><!= custCdNm !></td>
		<td id="cust_no" class="cust_no" align ="center" name="custNo"><!= custNo !></td>
		<td id="cust_nm" class="cust_nm"><!= custNm !></td>
		<td id="tel1_no" class="tel1_no"><!= tel1No !></td>
		<td id="tel2_no" class="tel2_no"><!= tel2No !></td>
		<td id="tel3_no" class="tel3_no"><!= tel3No !></td>
		<td id="emailid" class="emailid"><!= emailId !></td>
		<td id="fax_no" class="fax_no"><!= faxNo !></td>
		<td id="addr" class="addr"><!= addr !></td>
		<td id="cust_note" class="cust_note"><!= custNote !></td>
	</tr>
</script>
<script data-jui="#tab_excelList" data-tpl="none" type="text/template" >
    <tr height ="480">
        <td colspan="15" class="none" align="center">Data does not exist.</td>
    </tr>
</script>
<style>
.wrap-loading{ /*화면 전체를 어둡게 합니다.*/
    position: fixed;
    left:0;
    right:0;
    top:0;
    bottom:0; 
    background: rgba(0,0,0,0.2);  /*not in ie */
}
.wrap-loading div{ /*로딩 이미지*/
    position: fixed;
    top:50%;
    left:40%;
    margin-left: -21px;
    margin-top: -21px; 
}
.display-none{ /*감추기*/
    display:none;
}
</style>
<div class="head">
	<a href="#" class="close"><i class="icon-exit"></i></a>
	<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr>
			<td class="poptitle"
				style="background-image: url(../resources/jui-master/img/theme/jennifer/pop.png);">
				고객정보를 엑셀로 여러 건 입력하기
			</td>
		</tr>
	</table>
</div>
<div class="body">
	 <form id="upload_file_frm">
		<table width="100%" border="0" cellpadding="0" cellspacing="0" style="margin-bottom: 2px;">
			<tr>
				<td width="100%" align="right" class="td01">
				<input type="file" id="bt_file" name="uploadFile" style="display:none;"/>
				<a class="btn small focus" id="bt_excelExport">엑셀저장</a>
				<a class="btn small focus" id="bt_selectExcel">엑셀선택</a>
				<a class="btn small focus" id="bt_excelData">데이터검증</a>
				<a class="btn small focus" id="bt_insertExcel">저장</a>
				<a class="btn small focus" onclick="cancel()">취소</a></td>
			</tr>
		</table>
	</form>
	<table class="table classic hover" id="tab_excelList">
		<thead>
			<tr>
				<th style="width:25px;"><input type="checkbox" id="excel_checkall"/></th>
				<th style="width:36px;">번호</th>
				<!-- <th style="width:54px;">검증</th>  -->
				<th style="width:108px;">저장여부</th>
				<th style="width:82px;">저장확인</th>
				<th style="width:68px;">유형</th>
				<th style="width:90px;">고객번호</th>
				<th style="width:70px;">고객명</th>
				<th style="width:100px;">핸드폰</th>
				<th style="width:100px;">직장</th>
				<th style="width:100px;">자택</th>
				<th style="width:141px;">eMail</th>
				<th style="width:110px;">FAX</th>
				<th style="width:272px;">주소</th>
				<th style="width:100px;">비고</th> 
			</tr>
		</thead>
		<tbody id="tbodyid">
		</tbody>
	</table>
	<iframe id="ifraPopup" name="ifraPopup" style="display:none;"></iframe>
<!--  	<div class="row" align="right" style="text-align: right; margin-top: 3px;">
	    <div class="group">
	        <button onclick="paging_excel(-1);" class="btn mini">Prev</button>
	        <button onclick="paging_excel(1);" class="btn mini">Next</button>
	    </div>
	</div> -->
</div>
<div class="wrap-loading display-none" id="wrap-loading">
 	<div style="background:white; border:1px solid #bd5949; border-radius: 15px; height:100px; width: 350px;">
 		<!-- <span class='icon icon-loading' style="font-size: 80px; color: #bd5949;"></span> -->
 		<img src="../resources/jui-master/img/icon/spin.gif" width="100" height="80" style="float:left; margin:10px;"/>
 		<p style="margin-top:20px" >
 		<font style="color: #bd5949; font-weight: bold;">고객정보를 엑셀에서 여러 건 입력하기<br><br></font>
 		<span id="loadingData">요청하신 데이터를 불러오는 중입니다.</span><br>
 		<b>잠시만 기다려주세요.</b>
 		</p>
 	</div>
</div>
