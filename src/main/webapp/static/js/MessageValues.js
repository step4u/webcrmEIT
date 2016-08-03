// 명령어 정의 for UC //
const UC_REGISTER_REQ = 60;
const UC_REGISTER_RES = 61;
const UC_UNREGISTER_REQ = 62;
const UC_UNREGISTER_RES = 63;
const UC_BUSY_EXT_REQ = 64;
const UC_BUSY_EXT_RES = 65;
const UC_INFO_SRV_REQ = 66;
const UC_INFO_SRV_RES = 67;
const UC_SET_SRV_REQ = 68;
const UC_SET_SRV_RES = 69;
const UC_CLEAR_SRV_REQ = 70;
const UC_CLEAR_SRV_RES = 71;
const UC_CALL_STATE_REQ = 72;
const UC_CALL_STATE_RES = 73;
const UC_MAKE_CALL_REQ = 74;
const UC_MAKE_CALL_RES = 75;
const UC_DROP_CALL_REQ = 76;
const UC_DROP_CALL_RES = 77;
const UC_ANWSER_CALL_REQ = 78;
const UC_ANWSER_CALL_RES = 79;
const UC_PICKUP_CALL_REQ = 80;
const UC_PICKUP_CALL_RES = 81;
const UC_HOLD_CALL_REQ = 82;
const UC_HOLD_CALL_RES = 83;
const UC_ACTIVE_CALL_REQ = 84;
const UC_ACTIVE_CALL_RES = 85;
const UC_TRANSFER_CALL_REQ = 86;
const UC_TRANSFER_CALL_RES = 87;
const UC_PICKUP_TRANSFER_REQ = 88;
const UC_PICKUP_TRANSFER_RES = 89;

const UC_CLEAR_EXT_STATE_REQ = 100;
const UC_CLEAR_EXT_STATE_RES = 101;
const UC_REPORT_EXT_STATE = 102;
const UC_REPORT_SRV_STATE = 103;
const UC_REPORT_WAITING_COUNT = 104;

const UC_SMS_SEND_REQ = 120;
const UC_SMS_SEND_RES = 121;
const UC_SMS_INFO_REQ = 122;
const UC_SMS_INFO_RES = 123;
const UC_SMS_RECV_REQ = 124;
const UC_SMS_RECV_RES = 125;
const UC_SMS_RESERV_SEND_REQ = 126;
const UC_SMS_RESERV_SEND_RES = 127;
const UC_SMS_RESERV_CANCEL_REQ = -128;
const UC_SMS_RESERV_CANCEL_RES = -127;
const UC_SMS_TRANSFER_REQ = -126;
const UC_SMS_TRANSFER_RES = -125;
const UC_SMS_TRANSFER_CANCEL_REQ = -124;
const UC_SMS_TRANSFER_CANCEL_RES = -123;

const UC_APP_AUTH_REQ = -58;
const UC_APP_AUTH_RES = -57;

// DIRECT
const UC_DIRECT_NONE = 10;
const UC_DIRECT_OUTGOING = 11;
const UC_DIRECT_INCOMING = 12;

// TYPE
const UC_TYPE_COUPLEPHONE = 11;
const UC_TYPE_GROUPWARE = 12;
const UC_TYPE_IPPHONE = 13;

// STATUS
const UC_STATUS_SUCCESS = 100;
const UC_STATUS_FAIL = 101;
const UC_CALL_STATE_UNREG = 110;
const UC_CALL_STATE_IDLE = 111;
const UC_CALL_STATE_INVITING = 112;
const UC_CALL_STATE_RINGING = 113;
const UC_CALL_STATE_BUSY = 114;
const UC_CALL_STATE_NOT_FOUND = 115;
const UC_CALL_STATE_CALLER_BUSY = 116;
const UC_CALL_STATE_CALLER_NOANSWER = 117;
const UC_CALL_STATE_CALLER_MOVE = 118;

// 2016년 07월 11일 메일 답변 적용
const UC_CALL_STATE_RINGBACK = 119;

const UC_CALL_STATE_CALLEE_BUSY = 120;
const UC_CALL_STATE_CALLEE_NOANSER = 121;
const UC_CALL_STATE_CALLEE_MOVE = 122;

// ResponseCode
const UC_SRV_UNCONDITIONAL = 1;
const UC_SRV_NOANSWER = 2;
const UC_SRV_BUSY = 3;
const UC_SRV_DND = 4;

// DND
const UC_DND_SET = 1;
const UC_DND_CLEAR = 0;

// etc command
const WS_REQ_EXTENSION_STATE = 10001;
const WS_RES_EXTENSION_STATE = 10002;
const WS_REQ_SET_EXTENSION_STATE = 10003;
const WS_RES_SET_EXTENSION_STATE = 10004;
const WS_REQ_RELOAD_USER = 10005;
const WS_RES_RELOAD_USER = 10006;

// etc state
const WS_VALUE_EXTENSION_STATE_ONLINE = 20001;
const WS_VALUE_EXTENSION_STATE_LEFT = 20002;
const WS_VALUE_EXTENSION_STATE_DND = 20003;
const WS_VALUE_EXTENSION_STATE_REDIRECTED = 20004;

// uc websocket message
const WS_STATUS_ING_NOTFOUND = 210001;
const WS_STATUS_ING_UNSUPPORTED = 210002;





//-----------EIT DEFINED 

//-----------EVENT------
//
//UC_REPORT_EXT_STATE		102 - 전화를 걸거나 받을때의 콜상태
const UC_EIT_CALL_RINGING = 990001;
const UC_EIT_CALL_DIALING = 990002;
const UC_EIT_CALL_IDLE = 990003;
const UC_EIT_CALL_BUSY = 990004;
//dial 



//UC_CLEAR_SRV_RES			71	  - 07.07 추가 ; etc 상태 (20001 일때?)
//UC_REPORT_SRV_STATE		103   - 07.06 추가 ; etc 상태
//WS_RES_EXTENSION_STATE	10002 - 모든 콜상태요청시 콜상태, etc 상태
const UC_EIT_CALL_STATE = 990015;


//-----------ERROR------
//cmd
const UC_EIT_WEB_ERROR = -990001;

