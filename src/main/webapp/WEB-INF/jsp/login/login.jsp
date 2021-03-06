<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="shortcut icon" type="image/x-icon" href="../resources/jui-master/img/icon/favicon.ico" />
<title>Coretree - IP Contact Centre</title>

<%@ include file="../common/jui_common.jsp"%>
<script type="text/javascript">
$(document).ready(function() {
	jui.ready([ "ui.window" ], function(win) {
		win_12 = win("#win_12", {
			width : 362,
			height : 150,
			left : "8%",
			top : 50,
			resize : false,
			move : true,
			modal : true
		});

		win_12.show();
	});
});

var users = {
		username : "",
		empNo : "",
		password : "",
		newPwd : "",
	};

	function login() {
			var empNo = $("input[name=j_username]").val();
			var password = $("input[name=j_password]").val();
			if(empNo == ""){
				alert("아이디를 입력해주세요.");
			}else if(password == ""){
				alert("패스워드를 입력해주세요.");
			}else{
				users.username = empNo;
				users.empNo = empNo;
				users.password = password;
				var jsondata = JSON.stringify(users);
		
			/* 	$.ajax({
					url : "/login/actionLogin",
					type : "post",
					contentType : 'application/json; charset=utf-8',
					data : JSON.stringify(users),
					success : function(result) {
						if(result == 0){
							alert("아이디가 존재하지 않습니다.");
						}else if(result == 1){
								document.location.href = "/index";
						}else if(result == 2){
							alert("비밀번호가 일치하지 않습니다.");
						}
					}
				}); */
				//document.frm.action = "<c:url value='/login'/>";
				document.frm.action = "<c:url value='/j_spring_security_check'/>";
				document.frm.submit();
			}
		}

	function bt_updatePwd(){
		 if( $("#updatePwd").attr("style")== "display: none;"){
			 $("#updatePwd").attr("style","display: block;"); 
			 $("#win_12").css("height", "288px");
			 $(".body").css("height","235px");
		 }else{
			 $("#updatePwd").attr("style","display: none;"); 
			 $("#win_12").css("height", "150px");
			 $(".body").css("height","99px");
		 }
	}
		
	function updatePwd() {
			var empNo = $("input[name=empNo]").val();
			var nowPwd = $("input[name=nowPwd]").val();
			var newPwd = $("input[name=newPwd]").val();
			var confirmPwd = $("input[name=confirmPwd]").val();
			
			if(empNo == ""){
				alert("아이디를 입력해주세요.");
			}else if(empNo == "superadmin"){
				alert("비밀번호를 변경할 수 없습니다.");
			}else if(nowPwd == ""){
				alert("현재 비밀번호를 입력해주세요.");
			}else if(newPwd == ""){
				alert("새 비밀번호를 입력해주세요.");
			}else if(confirmPwd == ""){
				alert("새 비밀번호 확인을 입력해주세요.");
			}else if(newPwd != confirmPwd){
				alert("새 비밀번호와 새 비밀번호 확인이 맞지 않습니다.");
			}else{
				if(newPwd == confirmPwd){
					users.empNo = empNo;
					users.password = nowPwd;
					users.newPwd = newPwd;
					var jsondata = JSON.stringify(users);
			
					$.ajax({
						url : "/login/updatePwd",
						type : "post",
						contentType : 'application/json; charset=utf-8',
						data : JSON.stringify(users),
						success : function(result) {
							if(result == 0){
								alert("현재 비밀번호를 확인하세요.");
							}else if(result == 1){
								alert("변경되었습니다.");
								bt_updatePwd();
							}
						}
					});
				}
			}
		}
</script>

</head>
<body class="jui">
		<div id="win_12" class="msgboxpop danger">
			<div class="head">

				<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
					<tr>
						<td class="poptitle"style="background-image: url(../resources/jui-master/img/theme/jennifer/pop.png);">login</td>
					</tr>
				</table>
			</div>
			<div class="body">
			<div>
			<form name="frm" method="post">
				<table width="330" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td align="center">
							<input type="text" name= "j_username" class="loginput mini" placeholder="아이디" style="width: 130px" /> 
							<input type="password" name= "j_password" class="loginput mini" placeholder="비밀번호" style="width: 130px" 
							onkeydown="javascript: if (event.keyCode == 13) {login();}"/>
						</td>
					</tr>
					<tr>
						<td height="4"></td>
					</tr>
					<tr>
						<td align="center">
							<a class="logbtn small focus" href="javascript:login()">로그인</a>&nbsp;
							<a class="logbtn small focus">취소</a>
						</td>
					</tr>
					<tr>
						<td height="4"></td>
					</tr>
					<tr>
						<td align="center"><a class="log01btn small focus" onclick="javascript:bt_updatePwd();">비밀번호변경</a></td>
					</tr>
				</table>
				</form>
				</div>
				<br>

				<!-- 비밀번호 변경 -->
				<div id="updatePwd" style="display: none;">
					<table width="330" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td align="center">
								<input type="password" class="loginput mini" name="nowPwd" placeholder="현재 비밀번호" style="width: 262px" />
							</td>
						</tr>
						<tr>
							<td height="4"></td>
						</tr>
						<tr>
							<td align="center">
								<input type="password" name="newPwd" class="loginput mini"placeholder="새 비밀번호" style="width: 130px" />
								<input type="password" name="confirmPwd" class="loginput mini" placeholder="새 비밀번호 확인" style="width: 130px" />
							</td>
						</tr>
						<tr>
							<td height="4"></td>
						</tr>
						<tr>
							<td align="center">
								<a class="logbtn small focus" href="javascript:updatePwd();">확인</a>&nbsp;
								<a class="logbtn small focus" href="javascript:bt_updatePwd();">취소</a>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
</body>
</html>