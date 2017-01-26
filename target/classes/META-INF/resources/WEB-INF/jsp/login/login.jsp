<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Coretree - IP Contact Centre</title>
<link rel="shortcut icon" type="image/x-icon" href="../resources/jui-master/img/icon/favicon.ico" />
<%-- <jsp:include page="../common/jui_common.jsp" /> --%>
<link href='http://fonts.googleapis.com/earlyaccess/nanumgothic.css' rel='stylesheet' type='text/css'>
<link rel="stylesheet" href="../resources/jui-master/dist/ui.css">
<link rel="stylesheet" href="../resources/jui-master/dist/ui.min.css">
<link rel="stylesheet" href="../resources/jui-master/dist/ui-jennifer.css">
<link rel="stylesheet" href="../resources/jui-master/dist/grid.css" />
<link rel="stylesheet" href="../resources/jui-master/dist/grid-jennifer.css" />
<script type="text/javascript" src="../resources/js/jquery-1.10.2.js"></script>
<script type="text/javascript" src="../resources/js/jsbn.js"></script>
<script type="text/javascript" src="../resources/js/rsa.js"></script>
<script type="text/javascript" src="../resources/js/prng4.js"></script>
<script type="text/javascript" src="../resources/js/rng.js"></script>
<style>
#win_12{
	position:absolute;width:500px;height:300px;left:30%;top:30%;margin:0 !important;
}
#username, #password{
	width: 410px; height:40px !important; margin-bottom:10px; font-size:15px !important; text-align:left;
}
</style>
<% String publicKeyModulus = (String)request.getAttribute("publicKeyModulus"); %>
<% String publicKeyExponent = (String)request.getAttribute("publicKeyExponent"); %>	
<script type="text/javascript">
$(document).ready(function() {
		$("input[name=j_username]").focus();
	
	/* ENTER키 눌렀을 때 이벤트  */
	$(document).keyup(function (e) {
	    if (e.which == 13 || e.which == 32) {
	    	msgLogin_ok();
	    }
	});
	//중복로그인 시도
	if(<%= request.getAttribute("duplicateYN") == "Y"%>){
		alert($("input[name=username]").val());
		msgboxLogin2('중복로그인','기존 로그인된 정보 로그아웃 하시겠습니까?');
	}
	
	$("#duplicate_logout").click(function() {
		login();
	});
	
	$("#duplicate_cancel").click(function() {
		$('#login_duplicate').css( "display", "none" );
	});
	
}); 

var users = {
		username : "",
		empNo : "",
		password : "",
		newPwd : "", 
	};

function submitHiddenLoginForm(username, password, rsaPublicKeyModulus, rsaPpublicKeyExponent) {

   //	console.log("rsaPublicKeyModulus: "+ rsaPublicKeyModulus);
   //	console.log("rsaPpublicKeyExponent: "+ rsaPpublicKeyExponent);

	var rsa = new RSAKey();
    rsa.setPublic(rsaPublicKeyModulus, rsaPpublicKeyExponent);

    var securedUsername = rsa.encrypt(username);
    var securedPassword = rsa.encrypt(password);

   	//console.log("username: "+ username);
   	//console.log("password: "+ password);

   	//console.log("securedUsername: "+ securedUsername);
   	//console.log("securedPassword: "+ securedPassword);

    var hiddenLoginForm = document.getElementById("hiddenLoginForm");
    hiddenLoginForm.j_username.value = securedUsername;
    hiddenLoginForm.j_password.value = securedPassword;
    hiddenLoginForm.submit();
}

function login() {
		var empNo = $("input[name=username]").val();
		var password = $("input[name=password]").val();
		if(empNo == ""){
			msgboxLogin('로그인','아이디를 입력해주세요.');
		}else if(password == ""){
			msgboxLogin('로그인','비밀번호를 입력해주세요.');
		}else{
			users.username = empNo;
			users.empNo = empNo;
			users.password = password;
			/* document.frm.action = "<c:url value='/j_spring_security_check'/>";
			document.frm.submit(); */

		    var rsaPublicKeyModulus = document.getElementById("rsaPublicKeyModulus").value;
		    var rsaPublicKeyExponent = document.getElementById("rsaPublicKeyExponent").value;
			
//		   	console.log("rsaPublicKeyModulus: "+ rsaPublicKeyModulus);
//		   	console.log("rsaPpublicKeyExponent: "+ rsaPublicKeyExponent);
		   	
			var username = document.getElementById ("username").value;
			var password = document.getElementById("password").value;
			submitHiddenLoginForm(username, password, rsaPublicKeyModulus, rsaPublicKeyExponent); 
		}
	}
function msgboxLogin(pageName, note){
	$('#msgLogin1').html(pageName);
	$('#msgLogin2').html(note);
	$('#msg_Login').css( "display", "block" );
}
function msgboxLogin2(pageName, note){
	$('#login_duplicate1').html(pageName);
	$('#login_duplicate2').html(note);
	$('#login_duplicate').css( "display", "block" );
}
function msgLogin_ok(){
	document.getElementById("msg_Login").style.display = "none";
}
</script>
</head>
<body class="jui" style="background-color: #eee">
		<div id="win_12" class="msgboxpop danger">
			<div class="head">
				<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
					<tr>
						<td class="poptitle"style="background-image: url(../resources/jui-master/img/theme/jennifer/pop.png);">로그인</td>
					</tr>
				</table>
			</div>
			<div class="body">
			<div>
					<table width="330" border="0" cellspacing="0" cellpadding="0"  align="center">
						<tr>
							<td height="4"></td>
						</tr>
						<tr>
							<td align="center">
								<p style="margin-bottom:40px;font-size:21px;"><b><font style="color:#e60000">KT ucloud biz</font>에 오신 것을 환영합니다.</b></p>
								<input type="text" name= "username" class="txtIDPW loginput mini" id="username" placeholder="아이디" /><br> 
								<input type="password" name= "password" class="loginput mini" id="password" placeholder="비밀번호"	onkeydown="javascript: if (event.keyCode == 13) {login();}"/>
								 <input type="hidden" id="rsaPublicKeyModulus" value="<%=publicKeyModulus%>" />
		        				<input type="hidden" id="rsaPublicKeyExponent" value="<%=publicKeyExponent%>" /> 
							</td>
						</tr>
						<tr>
							<td height="4"></td>
						</tr>
						<tr>
							<td align="center">
								<a class="logbtn small focus" href="javascript:login();" style="width:410px; height:40px; padding-top: 6px; font-size:15px;">로그인</a>&nbsp;
							</td>
						</tr>
					</table>
					
				</div>
			    <form id="hiddenLoginForm" name="hiddenLoginForm" action="j_spring_security_check" method="post" style="display: none;">
			        <input type="hidden" name="j_username" id="j_username" value="" />
			        <input type="hidden" name="j_password" id="j_password" value="" />
			    </form>
			</div>
		</div>
		
	<div id="msg_Login" style="position: relative; height: 150px; display: none; z-index:9999;">
		<div class="msgbox" style="left:500px; top:100%; width:300px;">
			<div class="head" id="msgHead" style="height:20px; font-size:13px; padding-left:2px; border: 0px">
					<img src="../resources/jui-master/img/theme/jennifer/popMsg.png"/>
					<span style="float:right; padding-right:115px; padding-top: 4px;">알림창</span>
		    </div>
			<div class="body" style="padding:0px;">
				<p id="msgLogin1" style="margin:0px; font-weight:bold; background-color:#525252; color:white; height: 20px; padding-left:10px; padding-top: 10px;">페이지이름</p> <br/>
				<p id="msgLogin2" style="margin:0px; padding-left: 10px;">메세지 내용</p><br/>
				<div style="text-align: center; margin-top: 20px; margin-bottom: 20px;">
					<a class="btn focus small" onclick="msgLogin_ok()" id="msgLogin_ok">확인</a>
				</div>
			</div>
		</div>
	</div>
	<div id="login_duplicate" style="position: relative; height: 150px; display: none; z-index:9999;">
		<div class="msgbox" style="left:550px; top:100%; width:300px;">
			<div class="head" id="msgHead" style="height:20px; font-size:13px; padding-left:2px; border: 0px">
					<img src="../resources/jui-master/img/theme/jennifer/popMsg.png"/>
					<span style="float:right; padding-right:115px; padding-top: 4px;">알림창</span>
		    </div>
			<div class="body" style="padding:0px;">
				<p id="login_duplicate1" style="margin:0px; font-weight:bold; background-color:#525252; color:white; height: 20px; padding-left:10px; padding-top: 10px;">페이지이름</p> <br/>
				<p id="login_duplicate2" style="margin:0px; padding-left: 10px;">메세지 내용</p><br/>
				<div style="text-align: center; margin-top: 20px; margin-bottom: 20px;">
					<a href="#" class="btn focus small" id="duplicate_logout">로그아웃</a>
					<a href="#" class="btn focus small" id="duplicate_cancel">취소</a>
				</div>
			</div>
		</div>
	</div>
</body>
</html>