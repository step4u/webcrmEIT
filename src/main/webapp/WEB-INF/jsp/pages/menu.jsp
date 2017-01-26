<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
<!-- <link rel="stylesheet" href="../resources/jui-master/dist/ui.css">
	<link rel="stylesheet" href="../resources/jui-master/dist/ui.min.css">
	<link rel="stylesheet" href="../resources/jui-master/dist/ui-jennifer.css">
	<link rel="stylesheet" href="../resources/jui-master/dist/ui-jennifer.min.css"> -->

<%-- <%@ include file="../common/jui_common.jsp"%> --%>

<!-- <style type="text/css">
#targetElement {
	height: 200px;
	margin: 50px;
	background: #9cf;
}

.positionDiv {
	position: absolute;
	width: 75px;
	height: 75px;
	background: #080;
}
</style> -->

<!-- <script type="text/javascript">
jui.ready([ "ui.window" ], function(win) {
	win_1 = win("#win_1", {
		width : 1117,
		height : 558,
		left : "5%",
		top : 200,
		resize : false,
		move : true
	});
});
</script> -->

<script type="text/javascript">
<%-- 	
	세션관리 방식
function viewRoleChk(){
		if('<%= session.getAttribute("role")%>' == 'ROLE_ADMIN'){
			win_11.show(); fn_index('win_11');
		}else{
			msgboxActive('내선관리', '권한이 없습니다.');
		}
	} 
--%>
	
	function viewRoleChk(url, pages, message){

		$.ajax({
			url : "/popup/" + url,
			type : "get",
			data : "",
			contentType : 'application/json; charset=utf-8',
			success : function(result) {
				if(pages =="win_1"){
					win_1.show(); fn_index('win_1');	
				}else if(pages =="win_2"){
					win_2.show(); fn_index('win_2');	
				}else if(pages =="win_3"){
					win_3.show(); fn_index('win_3');	
				}else if(pages =="win_4"){
					win_4.show(); fn_index('win_4');	
				}else if(pages =="win_5"){
					win_5.show(); fn_index('win_5');	
				}else if(pages =="win_6"){
					win_6.show(); fn_index('win_6');	
				}else if(pages =="win_12_1"){
					win_12_1.show(); fn_index('win_12_1');	
				}else if(pages =="win_9"){
					win_9.show(); fn_index('win_9');	
				}else if(pages =="win_10"){
					win_10.show(); fn_index('win_10');	
				}else if(pages =="win_11"){
					win_11.show(); fn_index('win_11');	
				}else if(pages =="win_18"){
					win_18.show(); fn_index('win_18');	
				}
				else if(pages =="noticeRegRegist"){ //공지사항 등록
					document.getElementById("noticeSingUp").click();
				}
				else if(pages =="noticeRegModify"){ //공지사항 수정
					document.getElementById("bt_noticeModifyPopup").click();
				}
				else if(pages == "noticeDelete") { //공지사항 삭제
					document.getElementById("bt_noticeDelete").click();
				}
				else if(pages == "noticeComment") { //공지사항 댓글 저장
					document.getElementById("bt_replyInsert").click();
				}
				else if(pages == "tab02customer") { //고객리스트 조회(tab02)
					document.getElementById("bt_customer").click();   
				}
				else if(pages == "tab02Del") { //고객리스트 삭제(tab02)
					document.getElementById("bt_customerdel").click();   
				}
				else if(pages == "tab02smsGrpSend") { //고객리스트 SMS단체전송(tab02)
					document.getElementById("bt_smsGrpSend").click();   
				}
				else if(pages == "tab02Excel") { //고객리스트 엑셀저장(tab02)
					document.getElementById("bt_customerExcel").click();   
				}
				else if(pages == "tab01Save") { //고객상세 저장(tab01)
					document.getElementById("bt_custSave").click();   
				}
				else if(pages == "tab01Del") { //고객상세 삭제(tab01)
					document.getElementById("bt_custDelete").click();   
				}
				else if(pages == "tab01counSave") { //상담이력 등록(tab01)
					document.getElementById("bt_counSave").click();   
				}
				else if(pages == "tab05counSearch") { //상담이력 조회(tab05)
					document.getElementById("counSearch").click();   
				}
				else if(pages == "tab03callback") { //콜백 조회(tab03)
					document.getElementById("bt_callback").click();   
				}
				else if(pages == "tab03callbackSave") { //콜백 저장(tab03)
					document.getElementById("bt_callbackSave").click();   
				}
				else if(pages == "tab01resSave") { //상담예약 등록(tab01)
					document.getElementById("bt_resSave").click();   
				}
				else if(pages == "tab04reservation") { //상담예약 조회(tab04)
					document.getElementById("bt_reservation").click();   
				}
				else if(pages == "tab04reservationSave") { //상담예약 저장(tab04)
					document.getElementById("bt_reservationSave").click();   
				}
				else if(pages == "tab06smsSearch") { //SMS발송/이력 조회(tab06)
					document.getElementById("smsSearch").click();   
				}
				else if(pages == "tab06smsSend") { //SMS발송/이력 SMS 전송(tab06)
					win_14.show();  
				}
			},
			error : function(request,status,error){
				if(request.status == "403"){
					msgboxActive(message, '요청하신 페이지에 접근 권한이 없습니다.');	
				}
			}
		});

	}
</script>
</head>

<body class="jui">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td height="70" align="center">
				<img src="../resources/jui-master/img/theme/jennifer/logo.png" width="136" height="26">
			</td>
		</tr>
	</table>
	<table>
		<tr>
			<td>
				<div class="vmenu">
					<a class="active">고객정보<i class="icon-arrow1"></i></a>
					<ul class="submenu"  style="display:none">
						<li id="bt_excelPopup"><a onclick="viewRoleChk('View_excelStore_Admin.do','win_1','엑셀로 고객정보 저장');">엑셀로 고객정보 저장</a></li>
						<!-- <li id="bt_customerPopup"><a onclick="win_13.show()">고객정보선택</a></li> -->
					</ul>
					<a>통 계<i></i></a>
					<ul class="submenu"  style="display:none">
						<li id="bt_recordPopup"><a onclick="viewRoleChk('View_recordPresent_User.do','win_2','녹취 현황');">녹취 현황</a></li>
						<li id="bt_ivrPopup"><a onclick="viewRoleChk('View_ivrPresent_Admin.do','win_3','IVR 현황');">IVR 현황</a></li>
						<li id="bt_callcenterPopup"><a onclick="viewRoleChk('View_callcenterAll_Admin.do','win_4','전체 통계현황');">전체 통계현황</a></li>
						<li id="bt_councellerPresentPopup"><a onclick="viewRoleChk('View_councellerPresent_Admin.do','win_5','상담원 통계 현황');">상담원 통계 현황</a></li>
					</ul>
					<a>공지사항<i></i></a>
					<ul class="submenu"  style="display:none">
						<li id="bt_noticePopup"><a onclick="viewRoleChk('View_noticeAsk_User.do','win_6','공지사항 조회');">공지사항 조회</a></li>
					</ul>
					<a>환경설정<i></i></a>
					<ul class="submenu"  style="display:none">
						<li id="bt_updatePwdPopup"><a onclick="viewRoleChk('View_updatePassword_User.do','win_12_1','비밀번호변경');">비밀번호변경</a></li>
						<li id="bt_councellerPopup"><a onclick="viewRoleChk('View_councellerManager_Admin.do','win_9','상담원관리');">상담원관리</a></li>
						<li id="bt_smsPopup"><a onclick="viewRoleChk('View_smsTransport_Admin.do','win_10','SMS 전송유형');">SMS 전송유형</a></li>
						<li id="bt_extenstionPopup"><a onclick="viewRoleChk('View_extension_Admin.do','win_11','내선관리');">내선관리</a></li>
						<li id="bt_codePopup"><a onclick="viewRoleChk('View_codeManager_Admin.do','win_18','기타 코드관리');">기타 코드관리</a></li>
					</ul>
				</div>
			</td>
		</tr>
	</table>
</body>
</html>