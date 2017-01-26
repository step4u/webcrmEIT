/**
 * 전화기능 -- ING
 */

var stompClient = null;

// 현재 콜정보 보관용 ; getRequestCallInfo 용
var currentCallInfo = {
		//coretree
		cmd: 0,
		call_idx: 0,
		direct: 10,
		extension: '',
		cust_idx: 0,
		caller: '',
		callername: '',
		callee: '',
		calleename: '',
		unconditional: '',
		status: UC_CALL_STATE_IDLE
		//eit
		//id: 0,
		//message: ''
}

//이전 콜정보 보관용 ; UC_EIT_CALL_IDLE 체크용
var previousCallInfo = {
		//coretree
		cmd: 0,
		call_idx: 0,
		direct: 10,
		extension: '',
		cust_idx: 0,
		caller: '',
		callername: '',
		callee: '',
		calleename: '',
		unconditional: '',
		status: UC_CALL_STATE_IDLE
		//eit
		//id: 0,
		//message: ''
}

// 콜제어 보관용 ; getRequestCallInfo 용
var requestCallReservedInfo = {
		cmd: 0,
		direct: 0,
		extension: '',
		caller: '',
		callee: ''
}

/***
 * Soft Phone (IPCC) 의 현재 행동을 나타낸다. 걸기, 끊기, 돌려주기, 당겨받기 등의 시도 여부.
 * 현재는 전화걸기에만 적용
***/
var spBHV = {
		NONE: 0,
		TRIED: 1,
		DONE: 2
}
var spBehavior = spBHV.NONE;

/* 아래 2개는 AP 에서 정의해서 사용하세요. 

function receiveCoreTreeEvent(event)
function receiveCoreTreeEventError(event)

extension : 로그인한 usserID 에 등록된 extension 
caller    : 거는 사람 ; 이때는 extension 과 동일 
callee    : 받는 사람 ; 이때는 extension 과 동일 

*/

function stompConnect() {
    var socket = new SockJS('/webCTI');
	stompClient = Stomp.over(socket);

	//----- 디버그 없음 
	//stompClient.debug = null;

	stompClient.debug = function(str) {
		Logger.trace("[STOMP]"+ str + "\n\n");
	};

	stompClient.connect({}, function(frame) {

		try {
			Logger.info("stompConnect: connecting.....");
			
			stompClient.subscribe('/topic/ext.state.*', function(receviedMessage){
				//Logger.info("###------->" + receviedMessage.headers.destination)
				
				var destination = receviedMessage.headers.destination;
				destination = destination.replace("/topic/ext.state.", "");
				coreTreeExtensionHandler(destination, JSON.parse(receviedMessage.body));
			});
			
			stompClient.subscribe('/user/queue/groupware', function(receviedMessage){
				coreTreeFunctionHandler("groupware", JSON.parse(receviedMessage.body));
			});
			
			stompClient.subscribe('/topic/orgstates', function(receviedMessage){
				// 상담원 상태 정보 (각 내선의 상태정보가 업데이트 될 때 마다 들어옵니다.)
				// coreTreeFunctionHandler(JSON.parse(receviedMessage.body));
				Logger.debug("CoreTreeUsersStateEvent: ******UsersState******:"+ receviedMessage.body);

				receiveCoreTreeUsersStateEvent(JSON.parse(receviedMessage.body));
			});
			
			stompClient.subscribe('/user/queue/errors', function(receviedError){
				webStompErrorHandler(receviedError);
			});

			Logger.info("stompConnect: connected!");
			requestQueryExtensionState("");
			// requestQueryBusyExtensions();
			// ctiLogon();
			ctiAfterWork();
		}
		catch (err) {
			Logger.error("stompConnect: error: " + err);
		}
	});
}

function stompDisconnect() {
    if (stompClient != null) {
        stompClient.disconnect();
    }
    Logger.info("stompDisconnect: ...ed");
}

//2016-11-23
function stompSend(callreq) {
	if (!stompClient) {
		//TODO 팝업창
		alert("please call method stompConnect() !!!");
	}
	else {
		Logger.info("stompSend: [coretree_request]==> " + getCoreTreeCmdInfo(callreq));
		var message = JSON.stringify(callreq)
		//alert(message);
		stompClient.send("/app/call", {}, message);
	}
}

//2016-11-23
function getCoreTreeCmdInfo(req) {
	
	if (!req.cmd) return "";
	
	var info =
		  "cmd=" + getEventCmd(req) ;
	
	if (req.direct) {
		info += ", direct=" + getEventDirect(req) ;
	}
	if (req.call_idx) {
		info += ", call_idx=" + req.call_idx ;
	}
	if (req.extension) {
		info += ", extension=" + req.extension ;
	}	
	if (req.caller) {
		info += ", caller=" + req.caller ;
	}	
	if (req.callername) {
		info += ", callername=" + req.callername ;
	}	
	if (req.callee) {
		info += ", callee=" + req.callee ;
	}	
	if (req.calleename) {
		info += ", calleename=" + req.calleename ;
	}	
	if (req.unconditional) {
		info += ", unconditional=" + req.unconditional ;
	}	
	if (req.status) {
		info += ", status=" + getEventStatus(req) ;
	}	
	if (req.responseCode) {
		info += ", responseCode=" + req.responseCode ;
	}
	
	return info;
}

function JSONTrim(object) {
	for(var key in object)
		   if(!object[key]) delete object[key];
	return object;
}

function JSONtoString(object) {
	return JSON.stringify(JSONTrim(event));
}

//2016-08-24
function isInteger(value) {
    return /^\d+$/.test(value);
}

//2016-08-24
function getRequestCallInfo(extension, callFunctionName)
{
	var callee = "";
	var caller = "";
	
	// 콜제어 보관용 
	var requestCallInfo = {
			caller: '',
			callee: ''
	}
	
	//받은 상태 기준임
	if(currentCallInfo.direct == UC_DIRECT_INCOMING){
		
		callee = extension;
		caller = currentCallInfo.caller;

		Logger.log("getRequestCallInfo: Event기준: "+ callFunctionName + " direct:UC_DIRECT_INCOMING , extension:"+ extension +",  caller:" + caller + ", callee:" + callee);
	}
	//거는 상태 기준임
	else if (currentCallInfo.direct == UC_DIRECT_OUTGOING) {
		
		callee = currentCallInfo.callee;
		caller = extension;
		
		Logger.log("getRequestCallInfo: Event기준: "+ callFunctionName + " direct:UC_DIRECT_OUTGOING , extension:"+ extension +",  caller:" + caller + ", callee:" + callee);
	}
	//? 이벤트가 안오면 Request 로 판단 ?
	else {
		
		if (requestCallReservedInfo.cmd == UC_ANWSER_CALL_REQ) {

			callee = extension;
			caller = requestCallReservedInfo.caller;
			
			Logger.log("getRequestCallInfo: Request기준: "+ callFunctionName + " direct:UC_DIRECT_INCOMING , extension:"+ extension +",  caller:" + caller + ", callee:" + callee);

			// 초기화
			requestCallReservedInfo.cmd = 0;
			requestCallReservedInfo.extension = '';
			requestCallReservedInfo.caller = '';
			requestCallReservedInfo.callee = '';
		}
		else if  (requestCallReservedInfo.cmd == UC_MAKE_CALL_REQ ) {
			
			callee = requestCallReservedInfo.callee;
			caller = extension;
			
			Logger.log("getRequestCallInfo: Request기준: "+  callFunctionName + " direct:UC_DIRECT_OUTGOING , extension:"+ extension +",  caller:" + caller + ", callee:" + callee);
			
			// 초기화
			requestCallReservedInfo.cmd = 0;
			requestCallReservedInfo.extension = '';
			requestCallReservedInfo.caller = '';
			requestCallReservedInfo.callee = '';
		}
		else {
			
			// 이 경우는 그냥 이벤트에서 받아옴 ; 로그는 에러지만, 이벤트값을 디폴트로 처리해서 전달
			callee = currentCallInfo.callee;
			caller = currentCallInfo.caller;

			Logger.error("getRequestCallInfo: error: "+ callFunctionName+ " direct:" + currentCallInfo.direct + " , extension:"+ extension +",  caller:" + caller + ", callee:" + callee);
		}
		
	}
	
	requestCallInfo.callee = callee;
	requestCallInfo.caller = caller;
	
	return requestCallInfo;
}

//2016-11-17
function getCoreTreeEventInfo(event) {
	
	var info =
		  "cmd=" + getEventCmd(event) + 
		", direct=" + getEventDirect(event) + 
		
		", extension=" + event.extension + 
		", caller=" + event.caller + 
		", callername=" + event.callername + 
		", callee=" + event.callee + 
		", calleename=" + event.calleename + 

		", cust_no=" + event.cust_no + 

		", callid=" + event.callid + 
		", call_idx=" + event.call_idx + 
		
		", responseCode=" + event.responseCode + 
		", unconditional=" + event.unconditional + 

		", status=" + getEventStatus(event) +
		", statusmsg=" + getEventExtensionStatusMsg(event) + "(" + eventExtensionStateMsg(event.statusmsg) + ")";
	
	return info;
}

//2016-11-17
function getEitEventInfo(event) {

	var info = 
			  "target=" + event.target +
			", id=" + getEventId(event.id) + 
			", message=" + event.message;
	
	return info;
}

//2016-11-17
function getEventInfo(event) {

	var info = getCoreTreeEventInfo(event) + " || " + getEitEventInfo(event);
	
	return info;
}

//2016-11-17 ; 초간단 로그
var Logger = (function(){
    var timestamp = function(){};
    timestamp.toString = function(){
        return (new Date).toLocaleTimeString();    
    };
        
    return {
        info: console.info.bind(console,	'[INFO ][%s]', timestamp),
        log: console.log.bind(console,		'[DEBUG][%s]', timestamp),
        debug: console.log.bind(console,	'[DEBUG][%s]', timestamp),	// 호환용 편의 
        trace: console.trace.bind(console,	'[TRACE][%s]', timestamp),	// STOMP 구분용 
        warn: console.warn.bind(console,	'[WARN ][%s]', timestamp),
        error: console.error.bind(console,	'[ERROR][%s]', timestamp)	// 이하는 잘 안쓰므로 생략...
    }
})();


//------- 이벤트 정의

function EventCoreTree(target, event, message) {
  //coretree ; UcMessage 참조
  this.cmd = event.cmd;
  this.direct = event.direct;
  this.callid = event.callid;
  this.call_idx = event.call_idx;
  this.extension = event.extension;
  this.cust_no = event.cust_no;		//modified
  this.caller = event.caller;
  this.callername = event.callername;
  this.callee = event.callee;
  this.calleename = event.calleename;
  this.responseCode = event.responseCode;
  this.unconditional = event.unconditional;
  this.status = (isInteger(event.status))? Number(event.status): event.status;
  this.statusmsg = event.statusmsg;	//added
  //eit
  this.id = event.cmd;
  this.message = message;
  this.target = target; //added 
}
EventCoreTree.prototype.fireEvent = function(callback, event) {
	if (callback && typeof(callback) === "function") {
		callback(this, event);
	}
}
EventCoreTree.prototype.toJson = function() {
	return JSON.stringify(this);
}
EventCoreTree.prototype.getInfo = function() {
	if (!this.message) {
		return this.id;
	}
	else {
		return this.id + ":" + this.message;
	}
}
EventCoreTree.prototype.getEventInfo = function() {
	return getEventInfo(this);
}


function EventCoreTreeError (target, event, message) {
  //coretree ; UcMessage 참조
  this.cmd = event.cmd;
  this.direct = event.direct;
  this.callid = event.callid;
  this.call_idx = event.call_idx;
  this.extension = event.extension;
  this.cust_no = event.cust_no;		//modified
  this.caller = event.caller;
  this.callername = event.callername;
  this.callee = event.callee;
  this.calleename = event.calleename;
  this.responseCode = event.responseCode;
  this.unconditional = event.unconditional;
  this.status = (isInteger(event.status))? Number(event.status): event.status;
  this.statusmsg = event.statusmsg;	//added
  //eit
  this.id = event.cmd;
  this.message = message;
  this.target = target; //added 
}
EventCoreTreeError.prototype.fireEvent = function(callback, event) {
	if (callback && typeof(callback) === "function") {
		callback(this, event);
	}
}
EventCoreTreeError.prototype.toJson = function() {
	return JSON.stringify(this);
}
EventCoreTreeError.prototype.getInfo = function() {
	if (!this.message) {
		return this.id;
	}
	else {
		return this.id + ":" + this.message;
	}
}
EventCoreTree.prototype.getEventInfo = function() {
	return getEventInfo(this);
}


function returnEventEIT(target, event, messsage, eitEventDefinedId) {
	if (event.status != UC_STATUS_FAIL) {
		returnEvent(target, event, messsage + "_SUCCESS", eitEventDefinedId);
	}
	else {
		returnEventError(target, event, messsage + "_FAIL", eitEventDefinedId);
	}
}

function returnEvent(target, event, messsage, eitEventDefinedId) {
	var evt = new EventCoreTree(target, event, messsage);
	if (eitEventDefinedId) evt.id = eitEventDefinedId;
	evt.fireEvent(receiveCoreTreeEvent, evt);
}

function returnEventError(target, event, messsage, eitEventDefinedId) {
	var evt = new EventCoreTreeError(target, event, messsage);
	if (eitEventDefinedId) evt.id = eitEventDefinedId;
	evt.fireEvent(receiveCoreTreeEventError, evt);
}

function getEventCmd(event) {
	var message = "";
	switch (event.cmd){
		case UC_REGISTER_REQ:
			message = event.cmd+ ":"+ "UC_REGISTER_REQ";
			break;
		case UC_REGISTER_RES:
			message = event.cmd+ ":"+ "UC_REGISTER_RES";
			break;
		case UC_UNREGISTER_REQ:
			message = event.cmd+ ":"+ "UC_UNREGISTER_REQ";
			break;
		case UC_UNREGISTER_RES:
			message = event.cmd+ ":"+ "UC_UNREGISTER_RES";
			break;
		case UC_BUSY_EXT_REQ:
			message = event.cmd+ ":"+ "UC_BUSY_EXT_REQ";
			break;
		case UC_BUSY_EXT_RES:
			message = event.cmd+ ":"+ "UC_BUSY_EXT_RES";
			break;
		case UC_INFO_SRV_REQ:
			message = event.cmd+ ":"+ "UC_INFO_SRV_REQ";
			break;
		case UC_INFO_SRV_RES:
			message = event.cmd+ ":"+ "UC_INFO_SRV_RES";
			break;
		case UC_SET_SRV_REQ:
			message = event.cmd+ ":"+ "UC_SET_SRV_REQ";
			break;
		case UC_SET_SRV_RES:
			message = event.cmd+ ":"+ "UC_SET_SRV_RES";
			break;
		case UC_CLEAR_SRV_REQ:
			message = event.cmd+ ":"+ "UC_CLEAR_SRV_REQ";
			break;
		case UC_CLEAR_SRV_RES:
			message = event.cmd+ ":"+ "UC_CLEAR_SRV_RES";
			break;
		case UC_CALL_STATE_REQ:
			message = event.cmd+ ":"+ "UC_CALL_STATE_REQ";
			break;
		case UC_CALL_STATE_RES:
			message = event.cmd+ ":"+ "UC_CALL_STATE_RES";
			break;
		case UC_MAKE_CALL_REQ:
			message = event.cmd+ ":"+ "UC_MAKE_CALL_REQ";
			break;
		case UC_MAKE_CALL_RES:
			message = event.cmd+ ":"+ "UC_MAKE_CALL_RES";
			break;
		case UC_DROP_CALL_REQ:
			message = event.cmd+ ":"+ "UC_DROP_CALL_REQ";
			break;
		case UC_DROP_CALL_RES:
			message = event.cmd+ ":"+ "UC_DROP_CALL_RES";
			break;
		case UC_ANWSER_CALL_REQ:
			message = event.cmd+ ":"+ "UC_ANWSER_CALL_REQ";
			break;
		case UC_ANWSER_CALL_RES:
			message = event.cmd+ ":"+ "UC_ANWSER_CALL_RES";
			break;
		case UC_PICKUP_CALL_REQ:
			message = event.cmd+ ":"+ "UC_PICKUP_CALL_REQ";
			break;
		case UC_PICKUP_CALL_RES:
			message = event.cmd+ ":"+ "UC_PICKUP_CALL_RES";
			break;
		case UC_HOLD_CALL_REQ:
			message = event.cmd+ ":"+ "UC_HOLD_CALL_REQ";
			break;
		case UC_HOLD_CALL_RES:
			message = event.cmd+ ":"+ "UC_HOLD_CALL_RES";
			break;
		case UC_ACTIVE_CALL_REQ:
			message = event.cmd+ ":"+ "UC_ACTIVE_CALL_REQ";
			break;
		case UC_ACTIVE_CALL_RES:
			message = event.cmd+ ":"+ "UC_ACTIVE_CALL_RES";
			break;
		case UC_TRANSFER_CALL_REQ:
			message = event.cmd+ ":"+ "UC_TRANSFER_CALL_REQ";
			break;
		case UC_TRANSFER_CALL_RES:
			message = event.cmd+ ":"+ "UC_TRANSFER_CALL_RES";
			break;
		case UC_PICKUP_TRANSFER_REQ:
			message = event.cmd+ ":"+ "UC_PICKUP_TRANSFER_REQ";
			break;
		case UC_PICKUP_TRANSFER_RES:
			message = event.cmd+ ":"+ "UC_PICKUP_TRANSFER_RES";
			break;
		case UC_CLEAR_EXT_STATE_REQ:
			message = event.cmd+ ":"+ "UC_CLEAR_EXT_STATE_REQ";
			break;
		case UC_CLEAR_EXT_STATE_RES:
			message = event.cmd+ ":"+ "UC_CLEAR_EXT_STATE_RES";
			break;
		case UC_REPORT_EXT_STATE:
			message = event.cmd+ ":"+ "UC_REPORT_EXT_STATE";
			break;
		case UC_REPORT_SRV_STATE:
			message = event.cmd+ ":"+ "UC_REPORT_SRV_STATE";
			break;
		case UC_REPORT_WAITING_COUNT:
			message = event.cmd+ ":"+ "UC_REPORT_WAITING_COUNT";
			break;
			
		//etc
		case WS_REQ_EXTENSION_STATE:
			message = event.cmd+ ":"+ "WS_REQ_EXTENSION_STATE";
			break;
		case WS_RES_EXTENSION_STATE:
			message = event.cmd+ ":"+ "WS_RES_EXTENSION_STATE";
			break;
		case WS_REQ_SET_EXTENSION_STATE:
			message = event.cmd+ ":"+ "WS_REQ_SET_EXTENSION_STATE";
			break;
		case WS_RES_SET_EXTENSION_STATE:
			message = event.cmd+ ":"+ "WS_RES_SET_EXTENSION_STATE";
			break;
		case WS_REQ_RELOAD_USER:
			message = event.cmd+ ":"+ "WS_REQ_RELOAD_USER";
			break;
		case WS_RES_RELOAD_USER:
			message = event.cmd+ ":"+ "WS_RES_RELOAD_USER";
			break;

		//---------2016-09-20 추가 	
		case WS_REQ_CHANGE_EXTENSION_STATE:
			message = event.cmd+ ":"+ "WS_REQ_CHANGE_EXTENSION_STATE";
			break;
		case WS_RES_CHANGE_EXTENSION_STATE:
			message = event.cmd+ ":"+ "WS_RES_CHANGE_EXTENSION_STATE";
			break;			
			
		//etc state ; 2016-08-18 고이사님 설계 반영
//		case WS_VALUE_EXTENSION_STATE_READY:
//			message = event.cmd+ ":"+ "WS_VALUE_EXTENSION_STATE_READY";
//			break;
//		case WS_VALUE_EXTENSION_STATE_AFTER:
//			message = event.cmd+ ":"+ "WS_VALUE_EXTENSION_STATE_AFTER";
//			break;
//		case WS_VALUE_EXTENSION_STATE_LEFT:
//			message = event.cmd+ ":"+ "WS_VALUE_EXTENSION_STATE_LEFT";
//			break;
//		case WS_VALUE_EXTENSION_STATE_REST:
//			message = event.cmd+ ":"+ "WS_VALUE_EXTENSION_STATE_REST";
//			break;
//		case WS_VALUE_EXTENSION_STATE_EDU:
//			message = event.cmd+ ":"+ "WS_VALUE_EXTENSION_STATE_EDU";
//			break;
			
//		case WS_VALUE_EXTENSION_STATE_DND:
//			message = event.cmd+ ":"+ "WS_VALUE_EXTENSION_STATE_DND";
//			break;
//		case WS_VALUE_EXTENSION_STATE_REDIRECTED:
//			message = event.cmd+ ":"+ "WS_VALUE_EXTENSION_STATE_REDIRECTED";
//			ctiMsg = "착신전환";
//			break;
			
		default:
			message = event.cmd+ ":"+ "UC_UNDEFINED!!!"
			break;
	}
	return message;
}

function getEventId(event) {
	var message = "";
	var ctiMsg = "";
	switch (event.id){
		case UC_EIT_CALL_RINGING:
			message = event.id+ ":"+ "UC_EIT_CALL_RINGING";
//			customer_one(event.caller);
			break;
		case UC_EIT_CALL_DIALING:
			message = event.id+ ":"+ "UC_EIT_CALL_DIALING";
			break;
		case UC_EIT_CALL_IDLE:
			message = event.id+ ":"+ "UC_EIT_CALL_IDLE";
			break;
		case UC_EIT_CALL_BUSY:
			message = event.id+ ":"+ "UC_EIT_CALL_BUSY";
			break;
		case UC_EIT_CALL_STATE:
			message = event.id+ ":"+ "UC_EIT_CALL_STATE";
			break;
		case UC_EIT_WEB_ERROR:
			message = event.id+ ":"+ "UC_EIT_WEB_ERROR";
			break;
		//reserved...
		//case ..
			
		default:
			message = getEventCmd(event);
			break;
	}
	return message;
}

//call, extension
function getEventStatus(event) {
	var message = "";
	event.status = (isInteger(event.status))? Number(event.status): event.status;
	switch (event.status){
		case UC_STATUS_FAIL:
			message = event.status+ ":"+ "UC_STATUS_FAIL";
			break;
		case UC_CALL_STATE_UNREG:
			message = event.status+ ":"+ "UC_CALL_STATE_UNREG";
			break;
		case UC_CALL_STATE_IDLE:
			message = event.status+ ":"+ "UC_CALL_STATE_IDLE";
			break;
		case UC_CALL_STATE_INVITING:
			message = event.status+ ":"+ "UC_CALL_STATE_INVITING";
			break;
		case UC_CALL_STATE_RINGING:
			message = event.status+ ":"+ "UC_CALL_STATE_RINGING";
			break;
		case UC_CALL_STATE_BUSY:
			message = event.status+ ":"+ "UC_CALL_STATE_BUSY";
			break;
		case UC_CALL_STATE_NOT_FOUND:
			message = event.status+ ":"+ "UC_CALL_STATE_NOT_FOUND";
			break;
		case UC_CALL_STATE_CALLER_BUSY:
			message = event.status+ ":"+ "UC_CALL_STATE_CALLER_BUSY";
			break;
		case UC_CALL_STATE_CALLER_NOANSWER:
			message = event.status+ ":"+ "UC_CALL_STATE_CALLER_NOANSWER";
			break;
		case UC_CALL_STATE_CALLER_MOVE:
			message = event.status+ ":"+ "UC_CALL_STATE_CALLER_MOVE";
			break;
			
		// 2016년 07월 11일 메일 답변 적용
		case UC_CALL_STATE_RINGBACK:
			message = event.status+ ":"+ "UC_CALL_STATE_RINGBACK";
			break;
			
		case UC_CALL_STATE_CALLEE_BUSY:
			message = event.status+ ":"+ "UC_CALL_STATE_CALLEE_BUSY";
			break;
		case UC_CALL_STATE_CALLEE_NOANSER:
			message = event.status+ ":"+ "UC_CALL_STATE_CALLEE_NOANSER";
			break;
		case UC_CALL_STATE_CALLEE_MOVE:
			message = event.status+ ":"+ "UC_CALL_STATE_CALLEE_MOVE";
			break;
		//reserved
			
		default:
			message = getEventExtensionStatus(event); 
			break;
	}
	return message;
}

//etc state ; 2016-08-18 고이사님 설계 반영
function getEventExtensionStatus(event) {
	var message = "";
	switch (event.status){
		case WS_VALUE_EXTENSION_STATE_READY:
			message = event.status+ ":"+ "WS_VALUE_EXTENSION_STATE_READY";
			break;
		case WS_VALUE_EXTENSION_STATE_AFTER:
			message = event.status+ ":"+ "WS_VALUE_EXTENSION_STATE_AFTER";
			break;
		case WS_VALUE_EXTENSION_STATE_LEFT:
			message = event.status+ ":"+ "WS_VALUE_EXTENSION_STATE_LEFT";
			break;
		case WS_VALUE_EXTENSION_STATE_REST:
			message = event.status+ ":"+ "WS_VALUE_EXTENSION_STATE_REST";
			break;
		case WS_VALUE_EXTENSION_STATE_EDU:
			message = event.status+ ":"+ "WS_VALUE_EXTENSION_STATE_EDU";
			break;		
			
		//---------2016-09-20 추가 
		case WS_VALUE_EXTENSION_STATE_BUSY:
			message = event.status+ ":"+ "WS_VALUE_EXTENSION_STATE_BUSY";
			break;			
		case WS_VALUE_EXTENSION_STATE_LOGEDOUT:
			message = event.status+ ":"+ "WS_VALUE_EXTENSION_STATE_LOGEDOUT";
			break;			
		case WS_VALUE_EXTENSION_STATE_LOGEDON:
			message = event.status+ ":"+ "WS_VALUE_EXTENSION_STATE_LOGEDON";
			break;		
		//error	
		case WS_VALUE_EXTENSION_STATE_SAMEASNOW:
			message = event.status+ ":"+ "WS_VALUE_EXTENSION_STATE_SAMEASNOW";
			break;			
		case WS_VALUE_EXTENSION_STATE_WRONGREQ:
			message = event.status+ ":"+ "WS_VALUE_EXTENSION_STATE_WRONGREQ";
			break;			
			
//		case WS_VALUE_EXTENSION_STATE_DND:
//			message = event.status+ ":"+ "WS_VALUE_EXTENSION_STATE_DND";
//			break;
//		case WS_VALUE_EXTENSION_STATE_REDIRECTED:
//			message = event.status+ ":"+ "WS_VALUE_EXTENSION_STATE_REDIRECTED";
//			ctiMsg = "착신전환";
//			break;
			
		default:
			message = event.status+ ":"+ "UC or WS _CALL_STATE_UNDEFINED!!!"; 
			break;
	}
	return message;
}


//---------2016-09-20 추가 
function getEventExtensionStatusMsg(event) {
	var message = "";
	switch (event.statusmsg){
		case WS_VALUE_EXTENSION_STATE_READY:
			message = event.statusmsg+ ":"+ "WS_VALUE_EXTENSION_STATE_READY";
			break;
		case WS_VALUE_EXTENSION_STATE_AFTER:
			message = event.statusmsg+ ":"+ "WS_VALUE_EXTENSION_STATE_AFTER";
			break;
		case WS_VALUE_EXTENSION_STATE_LEFT:
			message = event.statusmsg+ ":"+ "WS_VALUE_EXTENSION_STATE_LEFT";
			break;
		case WS_VALUE_EXTENSION_STATE_REST:
			message = event.statusmsg+ ":"+ "WS_VALUE_EXTENSION_STATE_REST";
			break;
		case WS_VALUE_EXTENSION_STATE_EDU:
			message = event.statusmsg+ ":"+ "WS_VALUE_EXTENSION_STATE_EDU";
			break;		
			
		case WS_VALUE_EXTENSION_STATE_BUSY:
			message = event.statusmsg+ ":"+ "WS_VALUE_EXTENSION_STATE_BUSY";
			break;			
		case WS_VALUE_EXTENSION_STATE_LOGEDOUT:
			message = event.statusmsg+ ":"+ "WS_VALUE_EXTENSION_STATE_LOGEDOUT";
			break;			
		case WS_VALUE_EXTENSION_STATE_LOGEDON:
			message = event.statusmsg+ ":"+ "WS_VALUE_EXTENSION_STATE_LOGEDON";
			break;		
		//error	
		case WS_VALUE_EXTENSION_STATE_SAMEASNOW:
			message = event.statusmsg+ ":"+ "WS_VALUE_EXTENSION_STATE_SAMEASNOW";
			break;			
		case WS_VALUE_EXTENSION_STATE_WRONGREQ:
			message = event.statusmsg+ ":"+ "WS_VALUE_EXTENSION_STATE_WRONGREQ";
			break;			
			
		default:
			message = event.statusmsg+ ":"+ "UC or WS _CALL_STATE_UNDEFINED!!!"; 
			break;
	}
	return message;
}

	function eventExtensionStateMsg(status){
		var stateMsg = "";
		switch(status){
			case WS_VALUE_EXTENSION_STATE_READY :
				stateMsg = "대기";
				break;
			case UC_CALL_STATE_BUSY :
				stateMsg = "통화중";
				break;
			case WS_VALUE_EXTENSION_STATE_READY :
				stateMsg = "온라인";
				break;
			case WS_VALUE_EXTENSION_STATE_AFTER :
				stateMsg = "후처리";
				break;
			case WS_VALUE_EXTENSION_STATE_LEFT :
				stateMsg = "이석";
				break;
			case WS_VALUE_EXTENSION_STATE_REST :
				stateMsg = "휴식";
				break;
			case WS_VALUE_EXTENSION_STATE_EDU :
				stateMsg = "교육";
				break;
			case WS_VALUE_EXTENSION_STATE_BUSY :
				stateMsg = "통화중";
				break;
			case WS_VALUE_EXTENSION_STATE_LOGEDOUT :
				stateMsg = "로그아웃";
				break;
			case UC_CALL_STATE_RINGING:
			case UC_CALL_STATE_RINGBACK:
				stateMsg = "벨울림";
				break;
			default:
				return;
		}

		return stateMsg;
	}
function getEventDirect(event) {
	var message = "";
	switch (event.direct){
		case UC_DIRECT_NONE:
			message = event.direct+ ":"+ "UC_DIRECT_NONE";
			break;
		case UC_DIRECT_OUTGOING:
			message = event.direct+ ":"+ "UC_DIRECT_OUTGOING";
			break;
		case UC_DIRECT_INCOMING:
			message = event.direct+ ":"+ "UC_DIRECT_INCOMING";
			break;
		default:
			message = event.direct+ ":"+ "UC_UNDEFINED!!!"
			break;
	}
	return message;
}


function buttonState(types){
	try{
		switch(types) {
			case "RESET":
				$("#ready").attr("disabled",false);
				$("#notReady").attr("disabled",false);
				$("#dial").attr("disabled",false);
				$("#answer").attr("disabled",false);
				$("#pickUp").attr("disabled",false);
				$("#drop").attr("disabled",false);
				$("#hold").attr("disabled",false);
				$("#unhold").attr("disabled",false);
				$("#transfer").attr("disabled",false);
			break;
			case "READY":
				$("#ready").attr("disabled",true);
				$("#notReady").attr("disabled",false);
				$("#dial").attr("disabled",true);
				$("#answer").attr("disabled",true);
				$("#pickUp").attr("disabled",true);
				$("#drop").attr("disabled",true);
				$("#hold").attr("disabled",true);
				$("#unhold").attr("disabled",true);
				$("#transfer").attr("disabled",true);
				break;
			case "NOTREADY":
				$("#ready").attr("disabled",false);
				$("#notReady").attr("disabled",true);
				$("#dial").attr("disabled",false);
				$("#answer").attr("disabled",true);
				$("#pickUp").attr("disabled",false);
				$("#drop").attr("disabled",true);
				$("#hold").attr("disabled",true);
				$("#unhold").attr("disabled",true);
				$("#transfer").attr("disabled",true);
				break;
			case "RINGING":
				$("#ready").attr("disabled",true);
				$("#notReady").attr("disabled",true);
				$("#dial").attr("disabled",true);
				$("#answer").attr("disabled",false);
				$("#pickUp").attr("disabled",true);
				$("#drop").attr("disabled",true);
				$("#hold").attr("disabled",true);
				$("#unhold").attr("disabled",true);
				$("#transfer").attr("disabled",true);
				break;
			case "ESTABLISH":
				$("#ready").attr("disabled",true);
				$("#notReady").attr("disabled",true);
				$("#dial").attr("disabled",true);
				$("#answer").attr("disabled",true);
				$("#pickUp").attr("disabled",true);
				$("#drop").attr("disabled",false);
				$("#hold").attr("disabled",false);
				$("#unhold").attr("disabled",true);
				$("#transfer").attr("disabled",false);
				break;
			case "HOLD":
				$("#ready").attr("disabled",true);
				$("#notReady").attr("disabled",true);
				$("#dial").attr("disabled",true);
				$("#answer").attr("disabled",true);
				$("#pickUp").attr("disabled",true);
				$("#drop").attr("disabled",false);
				$("#hold").attr("disabled",true);
				$("#unhold").attr("disabled",false);
				$("#transfer").attr("disabled",false);
				break;
			case "UNHOLD":
				$("#ready").attr("disabled",true);
				$("#notReady").attr("disabled",true);
				$("#dial").attr("disabled",true);
				$("#answer").attr("disabled",true);
				$("#pickUp").attr("disabled",true);
				$("#drop").attr("disabled",false);
				$("#hold").attr("disabled",false);
				$("#unhold").attr("disabled",true);
				$("#transfer").attr("disabled",false);
				break;
		}
	}catch(err){
		Logger.error("buttonState: error: "+err);
	}
}

function coreTreeFunctionHandler(destination, event) {
	Logger.debug("coreTreeFunctionHandler: [coretree_FunctionEvent]<== "+ getCoreTreeEventInfo(event));
	
	switch (event.cmd) {
		// 71
		case UC_CLEAR_SRV_RES:
			returnEventEIT(destination, event, "UC_CLEAR_SRV_RES");
			break;
				
		// 75
		case UC_MAKE_CALL_RES:
			Logger.log("coreTreeFunctionHandler: 전화걸기 응답.....");
			returnEventEIT(destination, event, "MAKE_CALL");
			break;
		
		// 77	
		case UC_DROP_CALL_RES:
			Logger.log("coreTreeFunctionHandler: 전화끊기 응답.....");
			returnEventEIT(destination, event, "DROP_CALL");
			break;
		
		//added
		// 79
		case UC_ANWSER_CALL_RES:
			Logger.log("coreTreeFunctionHandler: 전화받기 응답.....");
			returnEventEIT(destination, event, "ANWSER_CALL");
			break;
		
		//modified	
		// 81	
		case UC_PICKUP_CALL_RES:
			Logger.log("coreTreeFunctionHandler: 당겨받기 응답.....");
			returnEventEIT(destination, event, "PICKUPR_CALL");
			break;
		
		// 83	
		case UC_HOLD_CALL_RES:
			Logger.log("coreTreeFunctionHandler: 홀드 응답.....");
			returnEventEIT(destination, event, "HOLD_CALL");
			break;
		
		// 85
		case UC_ACTIVE_CALL_RES:
			Logger.log("coreTreeFunctionHandler: 언홀드 응답.....");
			returnEventEIT(destination, event, "ACTIVE_CALL");
			break;
			
		//added
		// 87
		case UC_TRANSFER_CALL_RES:
			Logger.log("coreTreeFunctionHandler: 호전환 응답.....");
			returnEventEIT(destination, event, "TRANSFER_CALL");
			break;
			
		//added
		// 89
		case UC_PICKUP_TRANSFER_RES:
			Logger.log("coreTreeFunctionHandler: 당겨받기 응답.....");
			returnEventEIT(destination, event, "PICKUP_TRANSFER");
			break;			
		
		// 123	
		case UC_SMS_INFO_RES:
			Logger.log("coreTreeFunctionHandler: UC_SMS_INFO_RES.....");
			break;
		
		// 10002 	
		case WS_RES_EXTENSION_STATE:
			Logger.log("coreTreeFunctionHandler: WS_RES_EXTENSION_STATE.....콜 상태정보 갱신");
			Logger.log("coreTreeFunctionHandler: " + JSON.stringify(event));
			returnEventEIT(destination, event, "WS_RES_EXTENSION_STATE", UC_EIT_CALL_STATE);
			break;
			
			// 1002 	
		case WS_RES_CHANGE_EXTENSION_STATE:
			Logger.log("coreTreeFunctionHandler: WS_RES_CHANGE_EXTENSION_STATE.....상담원 상태정보 갱신");
			Logger.log("coreTreeFunctionHandler: " + JSON.stringify(event));
			returnEventEIT(destination, event, "WS_RES_CHANGE_EXTENSION_STATE");
			break;
			
		default:
			//TODO: 체크
			Logger.log("coreTreeFunctionHandler: ~~Etc cmd ===>"+ event.cmd);
			break;
	}
}

function coreTreeExtensionHandler(destination, event) {
	Logger.debug("");
	Logger.debug("coreTreeExtensionHandler: [coretree_ExtensionEvent]<== "+ getCoreTreeEventInfo(event));

	//ING
	switch (event.cmd) {

	// 인바운드, 아웃바운드 관련 처리	
	// 102	
	case UC_REPORT_EXT_STATE:
		var myext = $("input[name=sp_extNo]").val();
		if(event.extension != "") {
			if (myext == event.extension) {
				$("#ext_" + event.extension + "_state").text(eventExtensionStateMsg(event.status));
			} else {
				$("#ext_" + event.extension + "_state").text(eventExtensionStateMsg(event.status));
				return;
			}
		}
		
		//호전환 보관용
		var msg = "";
		switch (event.direct) {
			// 인바운드
			// 12
			case UC_DIRECT_INCOMING:
				Logger.log("coreTreeFunctionHandler: <<< UC_DIRECT_INCOMING: "+ getEventStatus(event));
				switch (event.status) {
					// 111
					case UC_CALL_STATE_IDLE:
						// 이전상태 비교
						// if (previousCallInfo.status == UC_CALL_STATE_RINGING || previousCallInfo.status == UC_CALL_STATE_BUSY) {
							
							//다시 초기화
							previousCallInfo.status = 0;
							
							Logger.log("coreTreeFunctionHandler: <<< UC_DIRECT_INCOMING: UC_CALL_STATE_IDLE 온라인...");
							
							//이벤트 재정의
							returnEvent(destination, event, "UC_CALL_STATE_IDLE_SUCCESS", UC_EIT_CALL_IDLE);
						// }
						break;
					
					// 113	
					case UC_CALL_STATE_RINGING:
					// 2016년 07월 11일 이재철 차장님 메일 답변 적용
					// 119 
					// case UC_CALL_STATE_RINGBACK:

						// 로그인한 내선에 대한 현재 call 정보 보관
						var myExtension = Number($("input[name=sp_extNo]").val());
						Logger.log("coreTreeFunctionHandler: <<< UC_DIRECT_INCOMING: ***RINGING/RINGBACK : myExtension----->"+ myExtension);
						
						if (myExtension == event.extension) {
							currentCallInfo = event;
							Logger.log("coreTreeFunctionHandler: <<< UC_DIRECT_INCOMING: currentCallInfo==> extension=" + currentCallInfo.extension
									+ ", caller="+ currentCallInfo.caller
									+ ", callee="+ currentCallInfo.callee);
						}
						
						if (!event.callername) {
							Logger.log("coreTreeFunctionHandler: <<< UC_DIRECT_INCOMING: 전화가 왔습니다 : " + event.caller);
						} else {
							Logger.log("coreTreeFunctionHandler: <<< UC_DIRECT_INCOMING: 전화가 왔습니다 : " + event.caller + ", " + event.callername);
						}
						
						// 로그인한 내선에 대한 이전 call 정보 보관
						if (myExtension == event.extension) {
							previousCallInfo = event;
						}

						//이벤트 재정의 
						returnEvent(destination,event, "UC_CALL_STATE_RINGING_SUCCESS", UC_EIT_CALL_RINGING);
						break;
					
					// 114	
					case UC_CALL_STATE_BUSY:
						Logger.log("coreTreeFunctionHandler: <<< UC_DIRECT_INCOMING: UC_CALL_STATE_BUSY: 통화중: " + event.caller + " , " + event.callername + " ," +event.callid);

						// 로그인한 내선에 대한 이전 call 정보 보관
						if (myExtension == event.extension) {
							previousCallInfo = event;
						}
						
						//이벤트 재정의
						returnEvent(destination,event, "UC_CALL_STATE_BUSY_SUCCESS", UC_EIT_CALL_BUSY);
						break;
						
					default:
						//TODO: 체크
						var myExtension = Number($("input[name=sp_extNo]").val());
						if (myExtension == event.extension) {
							Logger.log("coreTreeFunctionHandler: <<< UC_DIRECT_INCOMING: ~~unkown state---->"+ event.status);
							returnEvent(destination,event, "UC_DIRECT_INCOMING_ETC_SUCCESS");
						}
						break;
				}
				break;
			
			// 아웃바운드	
			// 11	
			case UC_DIRECT_OUTGOING:
				Logger.log("coreTreeFunctionHandler: >>> UC_DIRECT_OUTGOING: "+ getEventStatus(event));
				switch (event.status) {
				// 111
				case UC_CALL_STATE_IDLE:
					// if (previousCallInfo.status == UC_CALL_STATE_INVITING || previousCallInfo.status == UC_CALL_STATE_BUSY) {
						
						//다시 초기화
						previousCallInfo.status = 0;

						Logger.log("coreTreeFunctionHandler: >>> UC_DIRECT_OUTGOING: UC_CALL_STATE_IDLE 온라인...");
						
						//이벤트 재정의 
						returnEvent(destination, event, "UC_CALL_STATE_IDLE_SUCCESS", UC_EIT_CALL_IDLE);
					// }
					break;
				
				// 112	
				case UC_CALL_STATE_INVITING:
					// 로그인한 내선에 대한 현재 call 정보 보관
					var myExtension = Number($("input[name=sp_extNo]").val());
					Logger.log("coreTreeFunctionHandler: >>> UC_DIRECT_OUTGOING: ***INVITING: myExtension----->"+ myExtension);
					
					if (myExtension == event.extension) {
						currentCallInfo = event;
						Logger.log("coreTreeFunctionHandler: >>> UC_DIRECT_OUTGOING: currentCallInfo==> extension=" + currentCallInfo.extension
								+ ", caller="+ currentCallInfo.caller
								+ ", callee="+ currentCallInfo.callee);
					}
					
					if (!event.calleename) {
						Logger.log("coreTreeFunctionHandler: >>> UC_DIRECT_OUTGOING: UC_CALL_STATE_INVITING: 전화를 거는 중: " + event.callee);
					} 
					else {
						Logger.log("coreTreeFunctionHandler: >>> UC_DIRECT_OUTGOING: UC_CALL_STATE_INVITING: 전화를 거는 중: "  + event.callee + " , " + event.calleename);
					}
					
					// 로그인한 내선에 대한 이전 call 정보 보관
					if (myExtension == event.extension) {
						previousCallInfo = event;
					}
					
					//이벤트 재정의
					returnEvent(destination, event, "UC_CALL_STATE_INVITING_SUCCESS", UC_EIT_CALL_DIALING);
					break;
				
				case UC_CALL_STATE_RINGBACK:
					if (myExtension == event.extension)
						previousCallInfo = event;
					
					returnEvent(destination, event, "UC_CALL_STATE_RINGBACK_SUCCESS", UC_CALL_STATE_RINGBACK);
					break;
					
				// 114	
				case UC_CALL_STATE_BUSY:
					Logger.log("coreTreeFunctionHandler: >>> UC_DIRECT_OUTGOING: UC_CALL_STATE_BUSY");
					
					if (!event.calleename) {
						Logger.log("coreTreeFunctionHandler: >>> UC_DIRECT_OUTGOING: 통화중: " + event.callee  + " ," +event.callid );
					} else {
						Logger.log("coreTreeFunctionHandler: >>> UC_DIRECT_OUTGOING: 통화중: " + event.callee + " , " + event.calleename + " ," +event.callid );
					}
					
					// 로그인한 내선에 대한 이전 call 정보 보관
					if (myExtension == event.extension) {
						previousCallInfo = event;
						
						Logger.log("coreTreeFunctionHandler: >>> UC_DIRECT_OUTGOING: previousCallInfo=> " + previousCallInfo);
					}
					
					//이벤트 재정의 
					returnEvent(destination, event, "UC_CALL_STATE_BUSY_SUCCESS", UC_EIT_CALL_BUSY);
					break;
					
				default:
					//TODO: 체크
					Logger.log("coreTreeFunctionHandler: >>> UC_DIRECT_OUTGOING: ~~unkown state---->"+ event.status);
					returnEvent(destination, event, "UC_DIRECT_OUTGOING_ETC_SUCCESS");
					break;
				}
				break;
			
			// 알수 없는 상태
			default:
				Logger.error("coreTreeFunctionHandler: error unkown direct =="+ event.direct);
				break;
		}
		break;
/*		
	// 102	
	case UC_REPORT_EXT_STATE:
		returnEventEIT(destination, event, "UC_REPORT_EXT_STATE", UC_EIT_CALL_STATE);
		break;*/
		
//	// 2016-07-05 이재철 차장님 메일 답변 적용	; 상담원 상태변경시
//	// 103	
//	case UC_REPORT_SRV_STATE:
//		returnEventEIT(destination, event, "UC_REPORT_SRV_STATE", UC_EIT_CALL_STATE)
//		break;
		
	case UC_REPORT_SRV_STATE:
		returnEventEIT(destination, event, "UC_REPORT_SRV_STATE")
		break;

	// 2016-07-05 이재철 차장님 메일 답변 적용	; 대기고객수
	// 104
	case UC_REPORT_WAITING_COUNT:
		returnEventEIT(destination, event, "UC_REPORT_WAITING_COUNT");
		break;
		
	default:
		Logger.error("coreTreeExtensionHandler: !!! Etc cmd===>"+ event.cmd);
		break;
	}
}

function webStompErrorHandler(errorMessage) {
	//TODO
	Logger.error("webStompErrorHandler: ~~error ===> "
			+ errorMessage);
	
	call = {
			cmd: UC_EIT_WEB_ERROR,
			extension: '',
			caller: '',
			callee: '',
			unconditional: '',
			status: -1
	};
	
	var error = new EventCoreTreeError("error", call, errorMessage);
	error.fireEvent(receiveCoreTreeEventError, error);
}


//---- SPRING 
//
//UC_REGISTER_REQ	= 60	; UC 서버의 주소를 PBX에 등록하는 명령
//UC_REGISTER_RES 	= 61	; 
//UC_UNREGISTER_REQ= 62		; UC 서버의 주소를 clear함
//UC_UNREGISTER_RES= 63		;
//
//---- SPRING 


//sample
//{"cmd":64,"extension":"","caller":"","callee":"","unconditional":"","status":-1}
//
//UC_BUSY_EXT_REQ = 64			; 
//응용이 재실행되었을 때, PBX에게 현재 통화상태가 idle이 아닌 내선들의 정보를 달라고 요청하는 명령어
//PBX에서는 필요하면 아래의 명령으로 응답한다.
//UC_REPORT_EXT_STATE,
//UC_REPORT_SRV_STATE
//----???
//WS_RES_EXTENSION_STATE (현재는 이값으로 리턴?)
function requestQueryBusyExtensions() {
	callreq = {
			cmd: UC_BUSY_EXT_REQ,
			extension: '',
			caller: '',
			callee: '',
			unconditional: '',
			status: -1
	};

	stompSend(callreq);
}
//UC_BUSY_EXT_RES = 65			;


//UC_INFO_SRV_REQ = 66			; 
//응용에서 특정 내선의 착신전환 값을 알려달라고 요청하는 명령어
function requestQueryExtensionForReDirect(extension) {
	callreq = {
			cmd: UC_INFO_SRV_REQ,
			extension: extension,
			caller: '',
			callee: '',
			unconditional: '',
			status: -1
	};

	stompSend(callreq);
}
//UC_INFO_SRV_RES = 67			;


//UC_SET_SRV_REQ = 68			;
//응용에서 특정 내선의 착신전환을 설정해달라고 요청하는 명령어
//(무조건,통화중,부재중,DnD중 택일)
//
//ResponseCode
//UC_SRV_UNCONDITIONAL = 1;
//UC_SRV_NOANSWER = 2;
//UC_SRV_BUSY = 3;
//UC_SRV_DND = 4;
function requestSetExtensionForReDirect(extension, unconditional, responseCode) {
	callreq = {
          cmd: UC_SET_SRV_REQ,
          direct: 0,
          call_idx: 0,
          extension: extension,
          //cust_idx: 0,
          caller: '',
          callername: '',
          callee: '',
          calleename: '',
          responseCode: responseCode,
          unconditional: unconditional,
          status: 0
		};

	stompSend(callreq);
}
//UC_SET_SRV_RES = 69			;

/*
trade = {
      cmd: UC_SET_SRV_REQ,
      direct: UC_DIRECT_INCOMING,
      call_idx: 0,
      extension: '3001',
      cust_idx: 0,
      caller: '01045455962',
      callername: '',
      callee: '',
      calleename: '',
      responseCode: '',
      unconditional: '',
      status: 0
	};
*/

function requestSetExtensionForReDirectToUNCONDITIONAL(extension, unconditional) {
	// Requset UNCONDITIONAL
	requestSetExtensionForReDirect(extension, unconditional, UC_SRV_UNCONDITIONAL);
}
function requestSetExtensionForReDirectToNOANSWER(extension, unconditional) {
	// Requset NOANSWER
	requestSetExtensionForReDirect(extension, unconditional, UC_SRV_NOANSWER);
}
function requestSetExtensionForReDirectToBUSY(extension, unconditional) {
	// Requset BUSY
	requestSetExtensionForReDirect(extension, unconditional, UC_SRV_BUSY);
}
function requestSetExtensionForReDirectToDND(extension, unconditional) {
	// Requset DND
	requestSetExtensionForReDirect(extension, unconditional, UC_SRV_DND);
}


//UC_CLEAR_SRV_REQ = 70		;
//응용에서 특정 내선의 착신전환을 해제해달라고 요청하는 명령어
//(무조건,통화중,부재중,DnD중 택일)
function requestClearExtensionForReDirect(extension, responseCode) {
	callreq = {
          cmd: UC_CLEAR_SRV_REQ,
          direct: 0,
          call_idx: 0,
			extension: extension,
          //cust_idx: 0,
          caller: '',
          callername: '',
          callee: '',
          calleename: '',
          responseCode: responseCode,
          unconditional: '',
          status: 0
		};
  
	stompSend(callreq);
}
//sample
//{"cmd":71,"direct":0,"call_idx":0,"extension":"3010","cust_idx":0,"caller":"","callername":null,"callee":"","calleename":null,"responseCode":4,"unconditional":"","status":20001}
//
//UC_CLEAR_SRV_RES = 71		;

function requestClearExtensionForReDirectToUNCONDITIONAL(extension) {
	// UNCONDITIONAL
	requestClearExtensionForReDirect(extension, UC_SRV_UNCONDITIONAL);
}
function requestClearExtensionForReDirectToNOANSWER(extension) {
	// NOANSWER
	requestClearExtensionForReDirect(extension, UC_SRV_NOANSWER);
}
function requestClearExtensionForReDirectToBUSY(extension) {
	// BUSY
	requestClearExtensionForReDirect(extension, UC_SRV_BUSY);
}
function requestClearExtensionForReDirectToDND(extension) {
	// DND
	requestClearExtensionForReDirect(extension, UC_SRV_DND);
}



//UC_CALL_STATE_REQ = 72		;
//응용에서 특정 내선의 통화상태를 알려달라고 요청하는 명령어
function requestQueryCallState(extension) {
	callreq = {
			cmd: UC_CALL_STATE_REQ,
			extension: extension,
			caller: '',
			callee: '',
			unconditional: '',
			status: -1
	};

	stompSend(callreq);
}
//UC_CALL_STATE_RES = 73		;


//sample
//{"cmd":74,"extension":"3010","caller":"3010","callee":"3011","unconditional":"","status":-1}
//
//UC_MAKE_CALL_REQ = 74		;
//응용에서 전화를 거는 명령어
function requestCallDial(extension, caller, callee) {
	callreq = {
			cmd: UC_MAKE_CALL_REQ,
			extension: extension,
			caller: caller,
			callee: callee,
			unconditional: '',
			status: -1
	};
	
	//이벤트 문제시 예약용
	requestCallReservedInfo.cmd = callreq.cmd;
	requestCallReservedInfo.extension = extension;
	requestCallReservedInfo.caller = caller;
	requestCallReservedInfo.callee = callee;

	stompSend(callreq);
	
	spBehavior = spBHV.TRIED;	
}
//sample
//{"cmd":75,"direct":0,"call_idx":0,"extension":"3010","cust_idx":0,"caller":"3010","callername":null,"callee":"3011","calleename":null,"responseCode":0,"unconditional":null,"status":100}
//
//UC_MAKE_CALL_RES = 75		;


//sample
//{"cmd":76,"extension":"3010","caller":"3011","callee":"3010","unconditional":"","status":-1}
//
//UC_DROP_CALL_REQ = 76		;
//응용에서 전화를 종료하는 명령어
function requestCallDrop(extension, caller, callee) {
	if (!caller) caller = '';
	if (!callee) callee = '';
	callreq = {
			cmd : UC_DROP_CALL_REQ,
			extension : extension,
			caller : caller,
			callee : callee,
			unconditional : '',
			status: -1
	};

	stompSend(callreq);
}
//sample
//{"cmd":77,"direct":0,"call_idx":0,"extension":"3010","cust_idx":0,"caller":"3011","callername":null,"callee":"3010","calleename":null,"responseCode":0,"unconditional":null,"status":100}
//
//UC_DROP_CALL_RES = 77		;


//sample
//{"cmd":78,"direct":0,"call_idx":0,"extension":"3011","cust_idx":0,"caller":"","callername":"","callee":"","calleename":"","responseCode":"","unconditional":"","status":0}
//
//UC_ANWSER_CALL_REQ 78		;
//응용에서 수신된 전화를 받는 명령어
function requestCallAnswer(extension, caller, callee) {
	if (!caller) caller = '';
	if (!callee) callee = '';

	callreq = {
          cmd: UC_ANWSER_CALL_REQ,
          direct: UC_DIRECT_INCOMING,
          call_idx: 0,
          extension: extension,
          //cust_idx: 0,
          caller: caller,
          callername: '',
//           callee: '',
          callee: callee,
          calleename: '',
          responseCode: '',
          unconditional: '',
          status: 0
		};
	
	//이벤트 문제시 예약용
	requestCallReservedInfo.cmd = callreq.cmd;
	requestCallReservedInfo.extension = extension;
	requestCallReservedInfo.caller = caller;
	requestCallReservedInfo.callee = callee;
	
	stompSend(callreq);
}
//sample
//{"cmd":79,"direct":0,"call_idx":0,"extension":"3011","cust_idx":0,"caller":"","callername":null,"callee":"","calleename":null,"responseCode":0,"unconditional":null,"status":100}
//
//UC_ANWSER_CALL_RES = 79		;


//sample
//{"cmd":80,"extension":"3010","caller":"","callee":"3012","unconditional":"","status":-1}
//
//UC_PICKUP_CALL_REQ = 80		;
//다른 내선에 벨이 울리고 있을 때 응용에서 당겨 받는 명령어   ; caller = '' ?
function requestCallPickUp(extension, callee) {
	callreq = {
			cmd : UC_PICKUP_CALL_REQ,
			extension : extension,
			caller : '',
			callee : callee,
			unconditional : '',
			status: -1
	};

	stompSend(callreq);
}
//sample
//{"cmd":81,"direct":0,"call_idx":0,"extension":"3010","cust_idx":0,"caller":"","callername":null,"callee":"3012","calleename":null,"responseCode":0,"unconditional":null,"status":100}
//
//UC_PICKUP_CALL_RES = 81		;


//sample
//{"cmd":82,"extension":"3010","caller":"3011","callee":"3010","unconditional":"","status":-1}
//
//UC_HOLD_CALL_REQ = 82		;
//현재 통화중인 콜을 잠시 보류하는 명령어
function requestCallHold(extension, caller, callee) {
	if (!caller) caller = '';
	if (!callee) callee = '';
	callreq = {
			cmd : UC_HOLD_CALL_REQ,
			extension : extension,
			caller : caller,
			callee : callee,
			unconditional : '',
			status: -1
	};

	stompSend(callreq);
}
//sample
//{"cmd":83,"direct":0,"call_idx":0,"extension":"3010","cust_idx":0,"caller":"3011","callername":null,"callee":"3010","calleename":null,"responseCode":0,"unconditional":null,"status":100}
//
//UC_HOLD_CALL_RES = 83		;


//sample
//{"cmd":84,"extension":"3010","caller":"3011","callee":"3010","unconditional":"","status":-1}
//
//UC_ACTIVE_CALL_REQ = 84		;
//현재 보류중인 통화를 재개하는 명령어
function requestCallUnhold(extension, caller, callee) {
	if (!caller) caller = '';
	if (!callee) callee = '';
	callreq = {
			cmd : UC_ACTIVE_CALL_REQ,
			extension : extension,
			caller : caller,
			callee : callee,
			unconditional : '',
			status: -1
	};

	stompSend(callreq);
}
//sample
//{"cmd":85,"direct":0,"call_idx":0,"extension":"3010","cust_idx":0,"caller":"3011","callername":null,"callee":"3010","calleename":null,"responseCode":0,"unconditional":null,"status":100}
//
//UC_ACTIVE_CALL_RES = 85		;


//sample
//{"cmd":86,"extension":"3010","caller":"3012","callee":"3010","unconditional":"3011","status":-1}
//
//UC_TRANSFER_CALL_REQ = 86	;
//현재 통화중인 통화를 다른 내선(unconditional 인자값)으로 돌려주는 명령어
function requestCallTransfer(extension, caller, callee, unconditional) {
	callreq = {
			cmd : UC_TRANSFER_CALL_REQ,
			extension : extension,
			caller : caller,
			callee : callee,
			unconditional : unconditional,
			status: -1
	};

	stompSend(callreq);
}
//sample
//{"cmd":87,"direct":0,"call_idx":0,"extension":"3010","cust_idx":0,"caller":"3012","callername":null,"callee":"3010","calleename":null,"responseCode":0,"unconditional":null,"status":100}
//
//UC_TRANSFER_CALL_RES = 87	;


//UC_PICKUP_TRANSFER_REQ = 88	;
//현재 구현하지 않은 명령어
function requestCallTransferPickUp(extension, caller, callee, unconditional) {
	callreq = {
			cmd : UC_TRANSFER_CALL_REQ,
			extension : extension,
			caller : caller,
			callee : callee,
			unconditional : unconditional,
			status: -1
	};

	stompSend(callreq);
}


//------CURRENT NOT USED
//
//UC_SEND_INPUT_DATA_REQ = 90	; IVR에서 받은 데이터를 응용으로 전달하는명령어
//UC_SEND_INPUT_DATA_RES = 91	;

//UC_INPUT_DATA_RESULT_REQ=92	; 응용에서 전달받은 데이터의 결과값을 PBX에게로 보내는 명령어
//UC_INPUT_DATA_RESULT_RES=93	; 
	
//UC_MANAGER_EXT_REQ = 94		; 응용에서 실시간 청취를 할 수 있는 관리자의 내선번호를 PBX에게 등록하는 명령어
//UC_MANAGER_EXT_RES = 95		;

//UC_CALLCENTER_GROUP_REQ = 96	; 응용에서 감청 대상이 되는 그룹 등록하는 명령어
//UC_CALLCENTER_GROUP_RES = 97	;

//UC_LISTEN_TO_CALL_REQ = 98	; 응용에서 관리자가 실시간 청취를 요청하는 명령어(추후 구현 예정)
//UC_LISTEN_TO_CALL_RES = 99	;
//
//------CURRENT NOT USED


//UC_CLEAR_EXT_STATE_REQ = 100	;
//PBX가 재부팅된 경우 응용에게 모든 내선의 통화상태를 idle로 clear하라는 명령어
function requestClearExtensionState(extension) {
	callreq = {
			cmd: UC_CLEAR_EXT_STATE_REQ,
			extension: extension,
			caller: '',
			callee: '',
			unconditional: '',
			status: -1
	};

	stompSend(callreq);
}
//UC_CLEAR_EXT_STATE_RES = 101	;


//sample
//{"cmd":102,"direct":11,"call_idx":0,"extension":"3012","cust_idx":0,"caller":"3012","callername":null,"callee":"3011","calleename":null,"responseCode":0,"unconditional":"","status":112}
//
//UC_REPORT_EXT_STATE = 102	;
//내선의 통화상태가 변화가 생기면 응용에게 알려주는 명령어(응답은 필요없음)


//sample
//{"cmd":103,"direct":10,"call_idx":0,"extension":"3010","cust_idx":0,"caller":"","callername":null,"callee":"","calleename":null,"responseCode":0,"unconditional":"3011","status":20001}
//
//UC_REPORT_SRV_STATE = 103	;
//내선의 착신전환에 변화가 생기면 응용에게 알려주는 명령어(응답은 필요없음)


//UC_REPORT_WAITING_COUNT = 104;
//콜센터 그룹이나 콜센터 내선이 통화중이어서 통화를 기다리고 있는 개수를 변화가
//있을 때마다 응용에게 알려주는 명령어 (응답은 필요없음)


//-----SMS는 현재 KT만 지원함
//UC_SMS_SEND_REQ = 120		; 응용에서 SMS를 전송해 달라고 요청하는명령어 (PBX에서 MESSAGE메시지를 SSW로 전송)
//UC_SMS_SEND_RES = 121		;

//UC_SMS_INFO_REQ = 122		; SSW로부터 MESSAGE에 대한 응답이 오면 결과를 응용으로 알려주는 명령어
//UC_SMS_INFO_RES = 123		;

//UC_SMS_RECV_REQ = 124		; SSW로부터 MESSAGE 메시지를 수신한 경우 응용에게 알려주는 명령어
//UC_SMS_RECV_RES = 125		;

//UC_SMS_RESERV_SEND_REQ = 126	; 문자 예약전송을 요청하는 명령어
//UC_SMS_RESERV_SEND_RES = 127	;

//UC_SMS_RESERV_CANCEL_REQ = -128; 예약전송을 취소하는 명령어
//UC_SMS_RESERV_CANCEL_RES = -127;

//XXXXXXXXXXXXXXXXXXX OLD
//UC_SMS_TRANSFER_REQ = 130	; 
//UC_SMS_TRANSFER_RES = 131	;

//UC_SMS_TRANSFER_CANCEL_REQ=132;
//UC_SMS_TRANSFER_CANCEL_RES=133;
//XXXXXXXXXXXXXXXXXXX OLD

//XXXXXXXXXXXXXXXXXXX NEW
//UC_SMS_TRANSFER_REQ = -126	; 문자 수신을 받은 번호를 설정하는 명령어
//UC_SMS_TRANSFER_RES = -125	;

//UC_SMS_TRANSFER_CANCEL_REQ = -124; 문자 수신 번호를 취소 하는 명령어
//UC_SMS_TRANSFER_CANCEL_RES = -123;
//XXXXXXXXXXXXXXXXXXX NEW
//
//-----SMS는 현재 KT만 지원함


//-----인증
//
//UC_APP_AUTH_REQ = -58	; 응용에서 인증을 요청하기 위해서 사용(인증값을 가진 응용만 접속을 허용하도록해야 하는데 현재는 사용하지 않음)
//UC_APP_AUTH_RES = -57	;
//
//-----인증


//sample
//{"cmd":10001,"extension":"","caller":"","callee":"","unconditional":"","status":-1}
//
//WS_REQ_EXTENSION_STATE = 10001	;
//
function requestQueryExtensionState(extension) {
	//if (!extension) extension=0;
	if (!extension) extension='';
	
	callreq = {
			cmd: WS_REQ_EXTENSION_STATE,
			extension: extension,
			caller : '',
			callee : '',
			unconditional: '',
			status: -1
	};

	stompSend(callreq);
}
//sample
//{"cmd":10002,"direct":0,"call_idx":0,"extension":"3010","cust_idx":0,"caller":"","callername":null,"callee":"","calleename":null,"responseCode":0,"unconditional":"","status":20001}
//
//WS_RES_EXTENSION_STATE = 10002	;
	

//WS_REQ_SET_EXTENSION_STATE = 10003;
//
function requestSetExtensionState(extension) {
	callreq = {
			cmd: WS_REQ_SET_EXTENSION_STATE,
			extension: extension,
			caller : '',
			callee : '',
			unconditional: '',
			status: -1
	};

	stompSend(callreq);
}
//WS_RES_SET_EXTENSION_STATE = 10004; 


//WS_REQ_RELOAD_USER = 10005		;
//
function requestReloadUser(extension) {
	callreq = {
			cmd: WS_REQ_RELOAD_USER,
			extension: extension,
			caller : '',
			callee : '',
			unconditional: '',
			status: -1
	};

	stompSend(callreq);
}
//WS_RES_RELOAD_USER = 10006		;

//---------2016-09-20 추가 
function requestCallLogOn(extension) {
	callreq = {
			cmd: WS_REQ_CHANGE_EXTENSION_STATE,
			extension: extension,
			caller : '',
			callee : '',
			unconditional: '',
			status: WS_VALUE_EXTENSION_STATE_LOGEDON,
			responseCode: 4
	};
	
	stompSend(callreq);
}

//---------2016-08-18 고이사님 설계 반영
//기존 20001 ~ 20004 를
//현재 1001  ~ 1005  로 변경


//주의: 기존 WS_VALUE_EXTENSION_STATE_ONLINE = 20001 을
//   현재 WS_VALUE_EXTENSION_STATE_READY  = 1001  로 변경
//
//WS_VALUE_EXTENSION_STATE_READY = 1001;
//
//sample
//{"cmd":1001,"extension":"3012","caller":"","callee":"","unconditional":"","status":-1,"responseCode":4}
//
//---------2016-09-20 변경 
function requestCallReady(extension) {
	callreq = {
			cmd: WS_REQ_CHANGE_EXTENSION_STATE,
			extension: extension,
			caller : '',
			callee : '',
			unconditional: '',
			status: WS_VALUE_EXTENSION_STATE_READY,
			responseCode: 4
	};

	stompSend(callreq);
}
//{"cmd":71,"direct":0,"call_idx":0,"extension":"3012","cust_no":null,"caller":"","callername":null,"callee":"","calleename":null,"responseCode":4,"unconditional":"","status":"1001"}


//TODO: 이함수는 호환용 지울 예정
//function requestCallNotReady(extension) {
//	requestAferCallWork(extension);
	//requestCallNotReady_Left(extension);
	//requestCallNotReady_Rest(extension);
	//requestCallNotReady_Edu(extension);
//}


//TODO: 기존 requestCallNotReady ==> requestAferCallWork 바꿔야함 (후처리 버튼 위치)
//
//WS_VALUE_EXTENSION_STATE_AFTER = 1002; 
//
//sample
//{"cmd":1002,"extension":"3012","caller":"","callee":"","unconditional":"","status":-1,"responseCode":4}
//
//---------2016-09-20 변경 
function requestAferCallWork(extension) {
	callreq = {
			cmd: WS_REQ_CHANGE_EXTENSION_STATE,
			extension: extension,
			caller : '',
			callee : '',
			unconditional: '',
			status: WS_VALUE_EXTENSION_STATE_AFTER,
			responseCode: 4
	};

	stompSend(callreq);
}
//{"cmd":103,"direct":10,"call_idx":0,"extension":"3012","cust_no":null,"caller":"","callername":null,"callee":"","calleename":null,"responseCode":0,"unconditional":"","status":"1002"}


//주의: 기존 20002 에서 현재 1003 으로 변경되었음
//
//WS_VALUE_EXTENSION_STATE_LEFT = 1003; 
//
//sample
//{"cmd":1003,"extension":"3012","caller":"","callee":"","unconditional":"","status":-1,"responseCode":4}
//
//---------2016-09-20 변경 
function requestCallNotReady_Left(extension) {
	callreq = {
			cmd: WS_REQ_CHANGE_EXTENSION_STATE,
			extension: extension,
			caller : '',
			callee : '',
			unconditional: '',
			status: WS_VALUE_EXTENSION_STATE_LEFT,
			responseCode: 4
	};

	stompSend(callreq);
}
//{"cmd":103,"direct":10,"call_idx":0,"extension":"3012","cust_no":null,"caller":"","callername":null,"callee":"","calleename":null,"responseCode":0,"unconditional":"","status":"1003"}


//WS_VALUE_EXTENSION_STATE_REST = 1004; 
//
//---------2016-09-20 변경 
function requestCallNotReady_Rest(extension) {
	callreq = {
			cmd: WS_REQ_CHANGE_EXTENSION_STATE,
			extension: extension,
			caller : '',
			callee : '',
			unconditional: '',
			status: WS_VALUE_EXTENSION_STATE_REST,
			responseCode: 4
	};

	stompSend(callreq);
}


//WS_VALUE_EXTENSION_STATE_EDU = 1005; 
//
//sample
//{"cmd":1005,"extension":"3012","caller":"","callee":"","unconditional":"","status":-1,"responseCode":4}
//
//---------2016-09-20 변경 
function requestCallNotReady_Edu(extension) {
	callreq = {
			cmd: WS_REQ_CHANGE_EXTENSION_STATE,
			extension: extension,
			caller : '',
			callee : '',
			unconditional: '',
			status: WS_VALUE_EXTENSION_STATE_EDU,
			responseCode: 4
	};

	stompSend(callreq);
}
//{"cmd":103,"direct":10,"call_idx":0,"extension":"3012","cust_no":null,"caller":"","callername":null,"callee":"","calleename":null,"responseCode":0,"unconditional":"","status":"1005"}

//WS_VALUE_EXTENSION_STATE_LOGEDOUT = 1007; 
//
//sample
//{"cmd":1005,"extension":"3012","caller":"","callee":"","unconditional":"","status":-1,"responseCode":4}
//
//---------2016-09-20 변경 
function requestCallLogout(extension) {
	callreq = {
			cmd: WS_REQ_CHANGE_EXTENSION_STATE,
			extension: extension,
			caller : '',
			callee : '',
			unconditional: '',
			status: WS_VALUE_EXTENSION_STATE_LOGEDOUT,
			responseCode: 4
	};
	
	stompSend(callreq);
}
//{"cmd":103,"direct":10,"call_idx":0,"extension":"3012","cust_no":null,"caller":"","callername":null,"callee":"","calleename":null,"responseCode":0,"unconditional":"","status":"1005"}



//TOCHECK: 기존 DND, REDIRECT 는 현재 사용하지않음
//
//WS_VALUE_EXTENSION_STATE_DND = 20003;
//
//function requestCallDND(extension) {
//	callreq = {
//			cmd: WS_VALUE_EXTENSION_STATE_DND,
//			extension: extension,
//			caller : '',
//			callee : '',
//			unconditional: '',
//			status: -1,
//			responseCode: 4
//	};
//
//	stompSend(callreq);
//}
//
//sample
//{"cmd":20004,"extension":"3010","caller":"3010","callee":"3011","unconditional":"3011","status":-1,"responseCode":1}
//
//WS_VALUE_EXTENSION_STATE_REDIRECTED = 20004;
//
//function requestCallRedirect(extension, unconditional, responseCode) {
//	callreq = {
//			cmd: WS_VALUE_EXTENSION_STATE_REDIRECTED,
//			extension: extension,
////			caller : extension,
////			callee : callee,
//			caller : '',
//			callee : '',
//			unconditional: unconditional,
//			status: -1,
//			responseCode: responseCode
//	};
//
//	stompSend(callreq);
//}
//
//function requestCallRedirectToUNCONDITIONAL(extension, unconditional) {
//	// UNCONDITIONAL
//	requestCallRedirect(extension, unconditional, UC_SRV_UNCONDITIONAL);
//}
//function requestCallRedirectToNOANSWER(extension, unconditional) {
//	// NOANSWER
//	requestCallRedirect(extension, unconditional, UC_SRV_NOANSWER);
//}
//function requestCallRedirectToBUSY(extension, unconditional) {
//	// BUSY
//	requestCallRedirect(extension, unconditional, UC_SRV_BUSY);
//}
//function requestCallRedirectToDND(extension, unconditional) {
//	// DND
//	requestCallRedirect(extension, unconditional, UC_SRV_DND);
//}


//------- clear 
//
//function requestClearCallRedirectToUNCONDITIONAL(extension) {
//	// UNCONDITIONAL
//	requestClearExtensionForReDirectToUNCONDITIONAL(extension, UC_SRV_UNCONDITIONAL);
//}
//function requestClearCallRedirectToNOANSWER(extension) {
//	// NOANSWER
//	requestClearExtensionForReDirectToNOANSWER(extension, UC_SRV_NOANSWER);
//}
//function requestClearCallRedirectToBUSY(extension) {
//	// BUSY
//	requestClearExtensionForReDirectToBUSY(extension, UC_SRV_BUSY);
//}
//function requestClearCallRedirectToDND(extension) {
//	// DND
//	requestClearExtensionForReDirectToDND(extension, UC_SRV_DND);
//}

