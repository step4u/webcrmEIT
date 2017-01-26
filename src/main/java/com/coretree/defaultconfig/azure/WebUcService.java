package com.coretree.defaultconfig.azure;

import java.nio.ByteOrder;
import java.security.Principal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.MessageHeaders;
import org.springframework.messaging.core.MessageSendingOperations;
import org.springframework.messaging.handler.annotation.MessageExceptionHandler;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.annotation.SendToUser;
import org.springframework.messaging.simp.broker.BrokerAvailabilityEvent;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.socket.messaging.SessionConnectEvent;
import org.springframework.web.socket.messaging.SessionConnectedEvent;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;
import org.springframework.web.socket.messaging.SessionSubscribeEvent;
import org.springframework.web.socket.messaging.SessionUnsubscribeEvent;

import com.coretree.defaultconfig.Listener.ApplicationListener;
import com.coretree.defaultconfig.main.mapper.CallbackMapper;
import com.coretree.defaultconfig.main.mapper.OrganizationMapper;
import com.coretree.defaultconfig.main.mapper.SmsMapper;
import com.coretree.defaultconfig.main.mapper.UserLogMapper;
import com.coretree.defaultconfig.main.model.Callback;
import com.coretree.defaultconfig.main.model.OrgStatatistics;
import com.coretree.defaultconfig.main.model.Sms;
// import com.coretree.defaultconfig.mapper.Customer2;
// import com.coretree.defaultconfig.mapper.Customer2Mapper;
import com.coretree.defaultconfig.statis.mapper.CallStatMapper;
import com.coretree.defaultconfig.statis.model.CallStat;
import com.coretree.event.HaveGotUcMessageEventArgs;
import com.coretree.event.IEventHandler;
// import com.coretree.event.IEventHandler2;
// import com.coretree.event.LogedoutEventArgs;
import com.coretree.models.GroupWareData;
import com.coretree.models.Organization;
import com.coretree.models.SmsData;
import com.coretree.models.UcMessage;
import com.coretree.socket.RTPRecordServer;
import com.coretree.socket.UcServer;
import com.coretree.util.Const4pbx;

@Service
@RestController
public class WebUcService
	extends ApplicationListener
	implements
	IEventHandler<HaveGotUcMessageEventArgs>
	, ITelStatusService
	// , IEventHandler2<LogedoutEventArgs>
{

    private static final Log logger = LogFactory.getLog(WebUcService.class);

	private final MessageSendingOperations<String> messagingTemplate;
	private final SimpMessagingTemplate msgTemplate;
	private final int extensionlength = 7;

    private UcServer uc;

	private AtomicBoolean brokerAvailable = new AtomicBoolean();
	private ByteOrder byteorder = ByteOrder.BIG_ENDIAN;
//	private ByteOrder byteorder = ByteOrder.LITTLE_ENDIAN;
	
	private RTPRecordServer recoder = null;

    @Autowired
    private WebUcServiceConfig configs;

    @Autowired
	private OrganizationMapper organizationMapper;

//    @Autowired
//	private Customer2Mapper custMapper;

    @Autowired
	private CallStatMapper callstatMapper;

//    @Autowired
//	private SmsMapper_sample smsMapper;
    
    @Autowired
    private SmsMapper smsMapper;

    @Autowired
	private CallbackMapper cbmapper;

    @Autowired
	private UserLogMapper userlogmapper;

	private List<CallStat> curcalls = new ArrayList<CallStat>();
	private static List<Organization> organizations;
//	private List<Sms_sample> smsrunning = new ArrayList<Sms_sample>();
	
	private final ReentrantReadWriteLock rwl = new ReentrantReadWriteLock();
    private final Lock r = rwl.readLock();
    private final Lock w = rwl.writeLock();
    
    public ByteOrder getByteorder() {
    	ByteOrder bo = ByteOrder.BIG_ENDIAN;
    	
    	if (configs.getPbxip().equals("127.0.0.1") || configs.getPbxip().equals("localhost")) {
    		bo = ByteOrder.LITTLE_ENDIAN;
    	}
    	
    	return bo;
    }
    
    @Autowired
    public WebUcService(MessageSendingOperations<String> messagingTemplate, SimpMessagingTemplate msgTemplate) {
        this.messagingTemplate = messagingTemplate;
        this.msgTemplate = msgTemplate;
        
        organizations = new ArrayList<Organization>();
        
        smsSendTimer = new Timer();
        smsSendTimer.schedule(new SmsSendTimer_Elapsed(this), 60000, 60000);
    }
    
	@Override
	public void handleBrokerEvent(BrokerAvailabilityEvent evt) {
        this.brokerAvailable.set(evt.isBrokerAvailable());
        
        recoder = new RTPRecordServer(this.getByteorder(), "wav");
        
        uc = new UcServer(configs.getPbxip(), 31001, 1, this.byteorder);
        uc.HaveGotUcMessageEventHandler.addEventHandler(this);
        // uc.regist();

        InitializeUserState();
	}

	@Override
	public void handleSessionDisconnectEvent(SessionDisconnectEvent evt) {
		MessageHeaders headers = evt.getMessage().getHeaders();
		UsernamePasswordAuthenticationToken authtoken = (UsernamePasswordAuthenticationToken) headers.get("simpUser");
		String empNo = authtoken.getName();
		
		Organization organization = null;
		r.lock();
		try {
			organization = organizations.stream().filter(x -> x.getEmpNo().equals(empNo)).findFirst().get();
			organization.setTempval(Const4pbx.WS_VALUE_EXTENSION_STATE_LOGEDOUT);
			
			UcMessage message = new UcMessage();
			message.cmd = Const4pbx.WS_REQ_CHANGE_EXTENSION_STATE;
			message.status = Const4pbx.WS_VALUE_EXTENSION_STATE_LOGEDOUT;
			
			this.RequestToPbx(message);
			
			// System.err.println("SessionDisconnectEvent... Exception 1111");
		} catch (Exception e2) {
			System.err.println("SessionDisconnectEvent... Exception");
		} finally {
			r.unlock();
		}
		
		System.err.println("SessionDisconnectEvent... empNo : " + empNo);
	}
	
	@Override
	public void handleSessionConnectEvent(SessionConnectEvent evt) {
		System.err.println("SessionConnectEvent");
	}
	
	@Override
	public void handleSessionConnectedEvent(SessionConnectedEvent evt) {
		String empNo = evt.getUser().getName();
		System.err.println("SessionConnectedEvent... empNo : " + empNo);
	}

	@Override
	public void handleSessionSubscribeEvent(SessionSubscribeEvent evt) {
		System.err.println("SessionSubscribeEvent");
	}

	@Override
	public void handleSessionUnsubscribeEvent(SessionUnsubscribeEvent evt) {
		System.err.println("SessionUnsubscribeEvent");
	}
    
    /*
    @Override
    public void onApplicationEvent(BrokerAvailabilityEvent event) {
        this.brokerAvailable.set(event.isBrokerAvailable());
        
        uc = new UcServer(configs.getPbxip(), 31001, 1, this.byteorder);
        uc.HaveGotUcMessageEventHandler.addEventHandler(this);
        // uc.regist();

        InitializeUserState();
    }
    */

////////////////////////////
    
    private void LeaveLogs(Organization organization) {
    	if (organization.getPrevAgentStatCd().equals(organization.getAgentStatCd())) return;
    	
    	System.err.println(String.format("LeaveLogs : PrevAgentStatCd: %s, AgentStatCd: %s", organization.getPrevAgentStatCd(), organization.getAgentStatCd()));
		userlogmapper.addLog(organization);
    }

    private void UpdateOrganization(Organization organization) {
    	organization.setPrevAgentStatCd(organization.getAgentStatCd());
    	organization.setPrevStartdate(organization.getStartdate());
    	
    	organization.setAgentStatCd(String.valueOf(organization.getTempval()));
    	organization.setStartdate(LocalDateTime.now());
    }
    
	private void usersState() {
    	OrgStatatistics orgstates = new OrgStatatistics();
    	
    	orgstates.setTotal((int)(organizations.stream().filter(x -> x.getAgentStatCd().equals("110") == false).count()));
    	orgstates.setReady((int)organizations.stream().filter(x -> x.getAgentStatCd().equals("1011")).count());
    	orgstates.setAfter((int)organizations.stream().filter(x -> x.getAgentStatCd().equals("1012")).count());
    	orgstates.setBusy((int)organizations.stream().filter(x -> x.getAgentStatCd().equals("1016")).count());
    	orgstates.setLeft((int)organizations.stream().filter(x -> x.getAgentStatCd().equals("1013")).count());
    	orgstates.setRest((int)organizations.stream().filter(x -> x.getAgentStatCd().equals("1014")).count());
    	orgstates.setEdu((int)organizations.stream().filter(x -> x.getAgentStatCd().equals("1015")).count());
    	int logedin = (int)organizations.stream().filter(x -> x.getAgentStatCd().equals("1018")).count();
    	logedin += orgstates.getReady();
    	logedin += orgstates.getAfter();
    	logedin += orgstates.getLeft();
    	logedin += orgstates.getRest();
    	logedin += orgstates.getEdu();
    	logedin += orgstates.getBusy();
    	orgstates.setLogedin(logedin);
    	orgstates.setLogedout((int)organizations.stream().filter(x -> x.getAgentStatCd().equals("1017")).count());
    	
    	try {
        	this.messagingTemplate.convertAndSend("/topic/orgstates", orgstates);    		
    	} catch (Exception e) {
    		System.err.println("usersState... NullPointerException : " + e.getMessage());
    	}
    	
	}
	
	private void sendExtState2EachExt(UcMessage payload, Organization org) {
		// 내선 상태 reporting to each extension
		payload.cmd = Const4pbx.UC_REPORT_SRV_STATE;
		payload.status = Integer.valueOf(org.getAgentStatCd());
		payload.statusmsg = Const4pbx.UC_STATUS_SUCCESS;
		
		this.messagingTemplate.convertAndSend("/topic/ext.state." + org.getExtensionNo(), payload);
		this.usersState();
	}
	
	@MessageMapping("/call" )
	public void queueCallMessage(UcMessage message, Principal principal) {
		
		System.err.println("\n" + message.cmd+ ":=================>>>> " + message.toString() + "\n");
		
		Organization organization = null;
		r.lock();
		try {
			organization = organizations.stream().filter(x -> x.getExtensionNo().equals(message.extension)).findFirst().get();
		} catch (NoSuchElementException | NullPointerException e) {
			organization = null;
		} finally {
			r.unlock();
		}
		
		switch (message.cmd) {
			case Const4pbx.WS_REQ_EXTENSION_STATE:
				message.cmd = Const4pbx.WS_RES_EXTENSION_STATE;
				for (Organization organ : organizations) {
					message.extension = organ.getExtensionNo();
					message.status = Integer.valueOf(organ.getAgentStatCd());
					this.msgTemplate.convertAndSendToUser(principal.getName(), "/queue/groupware", message);
				}
				this.usersState();
				break;
//			case Const4pbx.WS_REQ_SET_EXTENSION_STATE:
//				break;
//			case Const4pbx.WS_REQ_RELOAD_USER:
//				break;
			case Const4pbx.WS_REQ_CHANGE_EXTENSION_STATE:
				switch (message.status) {
					case Const4pbx.WS_VALUE_EXTENSION_STATE_READY:
						switch (Integer.valueOf(organization.getAgentStatCd())) {
							case Const4pbx.WS_VALUE_EXTENSION_STATE_READY:
								message.cmd = Const4pbx.WS_RES_CHANGE_EXTENSION_STATE;
								message.statusmsg = Const4pbx.WS_VALUE_EXTENSION_STATE_SAMEASNOW;
								this.msgTemplate.convertAndSendToUser(principal.getName(), "/queue/groupware", message);
								
								this.sendExtState2EachExt(message, organization);
								break;
							case Const4pbx.WS_VALUE_EXTENSION_STATE_AFTER:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_LEFT:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_REST:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_EDU:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_LOGEDON:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_LOGEDOUT:
								organization.setTempval(message.status);
								this.RequestToPbx(message);
								break;
							case Const4pbx.WS_VALUE_EXTENSION_STATE_BUSY:
							default:
								message.cmd = Const4pbx.WS_RES_CHANGE_EXTENSION_STATE;
								message.status = Integer.valueOf(organization.getAgentStatCd());
								message.statusmsg = Const4pbx.WS_VALUE_EXTENSION_STATE_WRONGREQ;
								this.msgTemplate.convertAndSendToUser(principal.getName(), "/queue/groupware", message);
								break;
						}
						break;
					case Const4pbx.WS_VALUE_EXTENSION_STATE_AFTER:
						switch (Integer.valueOf(organization.getAgentStatCd())) {
							case Const4pbx.WS_VALUE_EXTENSION_STATE_AFTER:
								message.cmd = Const4pbx.WS_RES_CHANGE_EXTENSION_STATE;
								message.statusmsg = Const4pbx.WS_VALUE_EXTENSION_STATE_SAMEASNOW;
								this.msgTemplate.convertAndSendToUser(principal.getName(), "/queue/groupware", message);
								
								this.sendExtState2EachExt(message, organization);
								break;
							case Const4pbx.WS_VALUE_EXTENSION_STATE_LEFT:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_REST:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_EDU:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_LOGEDON:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_LOGEDOUT:
								organization.setTempval(message.status);
								this.UpdateOrganization(organization);
								this.LeaveLogs(organization);
								
								message.cmd = Const4pbx.UC_REPORT_SRV_STATE;
								this.messagingTemplate.convertAndSend("/topic/ext.state." + organization.getExtensionNo(), message);
								this.usersState();
								
								message.cmd = Const4pbx.WS_RES_CHANGE_EXTENSION_STATE;
								message.statusmsg = Const4pbx.UC_STATUS_SUCCESS;
								this.msgTemplate.convertAndSendToUser(principal.getName(), "/queue/groupware", message);
								break;
							case Const4pbx.WS_VALUE_EXTENSION_STATE_READY:
								organization.setTempval(message.status);
								this.RequestToPbx(message);
								break;
							case Const4pbx.WS_VALUE_EXTENSION_STATE_BUSY:
							default:
								message.cmd = Const4pbx.WS_RES_CHANGE_EXTENSION_STATE;
								message.status = Integer.valueOf(organization.getAgentStatCd());
								message.statusmsg = Const4pbx.WS_VALUE_EXTENSION_STATE_WRONGREQ;
								this.msgTemplate.convertAndSendToUser(principal.getName(), "/queue/groupware", message);
								break;
						}
						break;
					case Const4pbx.WS_VALUE_EXTENSION_STATE_LEFT:
						switch (Integer.valueOf(organization.getAgentStatCd())) {
							case Const4pbx.WS_VALUE_EXTENSION_STATE_LEFT:
								message.cmd = Const4pbx.WS_RES_CHANGE_EXTENSION_STATE;
								message.statusmsg = Const4pbx.WS_VALUE_EXTENSION_STATE_SAMEASNOW;
								this.msgTemplate.convertAndSendToUser(principal.getName(), "/queue/groupware", message);
								
								this.sendExtState2EachExt(message, organization);
								break;
							case Const4pbx.WS_VALUE_EXTENSION_STATE_AFTER:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_REST:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_EDU:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_LOGEDON:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_LOGEDOUT:
								organization.setTempval(message.status);
								this.UpdateOrganization(organization);
								this.LeaveLogs(organization);
								
								message.cmd = Const4pbx.UC_REPORT_SRV_STATE;
								this.messagingTemplate.convertAndSend("/topic/ext.state." + organization.getExtensionNo(), message);
								this.usersState();
								
								message.cmd = Const4pbx.WS_RES_CHANGE_EXTENSION_STATE;
								message.statusmsg = Const4pbx.UC_STATUS_SUCCESS;
								this.msgTemplate.convertAndSendToUser(principal.getName(), "/queue/groupware", message);
								break;
							case Const4pbx.WS_VALUE_EXTENSION_STATE_READY:
								organization.setTempval(message.status);
								this.RequestToPbx(message);
								break;
							case Const4pbx.WS_VALUE_EXTENSION_STATE_BUSY:
							default:
								message.cmd = Const4pbx.WS_RES_CHANGE_EXTENSION_STATE;
								message.status = Integer.valueOf(organization.getAgentStatCd());
								message.statusmsg = Const4pbx.WS_VALUE_EXTENSION_STATE_WRONGREQ;
								this.msgTemplate.convertAndSendToUser(principal.getName(), "/queue/groupware", message);
								break;
						}
						break;
					case Const4pbx.WS_VALUE_EXTENSION_STATE_REST:
						switch (Integer.valueOf(organization.getAgentStatCd())) {
							case Const4pbx.WS_VALUE_EXTENSION_STATE_REST:
								message.cmd = Const4pbx.WS_RES_CHANGE_EXTENSION_STATE;
								message.statusmsg = Const4pbx.WS_VALUE_EXTENSION_STATE_SAMEASNOW;
								this.msgTemplate.convertAndSendToUser(principal.getName(), "/queue/groupware", message);
								
								this.sendExtState2EachExt(message, organization);
								break;
							case Const4pbx.WS_VALUE_EXTENSION_STATE_AFTER:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_LEFT:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_EDU:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_LOGEDON:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_LOGEDOUT:
								organization.setTempval(message.status);
								this.UpdateOrganization(organization);
								this.LeaveLogs(organization);
								
								message.cmd = Const4pbx.UC_REPORT_SRV_STATE;
								this.messagingTemplate.convertAndSend("/topic/ext.state." + organization.getExtensionNo(), message);
								this.usersState();
								
								message.cmd = Const4pbx.WS_RES_CHANGE_EXTENSION_STATE;
								message.statusmsg = Const4pbx.UC_STATUS_SUCCESS;
								this.msgTemplate.convertAndSendToUser(principal.getName(), "/queue/groupware", message);
								break;
							case Const4pbx.WS_VALUE_EXTENSION_STATE_READY:
								organization.setTempval(message.status);
								this.RequestToPbx(message);
								break;
							case Const4pbx.WS_VALUE_EXTENSION_STATE_BUSY:
							default:
								message.cmd = Const4pbx.WS_RES_CHANGE_EXTENSION_STATE;
								message.status = Integer.valueOf(organization.getAgentStatCd());
								message.statusmsg = Const4pbx.WS_VALUE_EXTENSION_STATE_WRONGREQ;
								this.msgTemplate.convertAndSendToUser(principal.getName(), "/queue/groupware", message);
								break;
						}
						break;
					case Const4pbx.WS_VALUE_EXTENSION_STATE_EDU:
						switch (Integer.valueOf(organization.getAgentStatCd())) {
							case Const4pbx.WS_VALUE_EXTENSION_STATE_EDU:
								message.cmd = Const4pbx.WS_RES_CHANGE_EXTENSION_STATE;
								message.statusmsg = Const4pbx.WS_VALUE_EXTENSION_STATE_SAMEASNOW;
								this.msgTemplate.convertAndSendToUser(principal.getName(), "/queue/groupware", message);
								
								this.sendExtState2EachExt(message, organization);
								break;
							case Const4pbx.WS_VALUE_EXTENSION_STATE_AFTER:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_LEFT:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_REST:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_LOGEDON:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_LOGEDOUT:
								organization.setTempval(message.status);
								this.UpdateOrganization(organization);
								this.LeaveLogs(organization);
								
								message.cmd = Const4pbx.UC_REPORT_SRV_STATE;
								this.messagingTemplate.convertAndSend("/topic/ext.state." + organization.getExtensionNo(), message);
								this.usersState();
								
								message.cmd = Const4pbx.WS_RES_CHANGE_EXTENSION_STATE;
								message.statusmsg = Const4pbx.UC_STATUS_SUCCESS;								
								this.msgTemplate.convertAndSendToUser(principal.getName(), "/queue/groupware", message);
								break;
							case Const4pbx.WS_VALUE_EXTENSION_STATE_READY:
								organization.setTempval(message.status);
								this.RequestToPbx(message);
								break;
							case Const4pbx.WS_VALUE_EXTENSION_STATE_BUSY:
							default:
								message.cmd = Const4pbx.WS_RES_CHANGE_EXTENSION_STATE;
								message.status = Integer.valueOf(organization.getAgentStatCd());
								message.statusmsg = Const4pbx.WS_VALUE_EXTENSION_STATE_WRONGREQ;
								this.msgTemplate.convertAndSendToUser(principal.getName(), "/queue/groupware", message);
								break;
						}
						break;
					case Const4pbx.WS_VALUE_EXTENSION_STATE_LOGEDON:
						switch (Integer.valueOf(organization.getAgentStatCd())) {
							case Const4pbx.WS_VALUE_EXTENSION_STATE_LOGEDON:
								message.cmd = Const4pbx.WS_RES_CHANGE_EXTENSION_STATE;
								message.statusmsg = Const4pbx.WS_VALUE_EXTENSION_STATE_SAMEASNOW;
								this.msgTemplate.convertAndSendToUser(principal.getName(), "/queue/groupware", message);
								
								this.sendExtState2EachExt(message, organization);
								break;
							case Const4pbx.WS_VALUE_EXTENSION_STATE_READY:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_AFTER:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_LEFT:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_REST:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_EDU:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_LOGEDOUT:
								organization.setTempval(message.status);
								this.RequestToPbx(message);
								break;
							case Const4pbx.WS_VALUE_EXTENSION_STATE_BUSY:
							default:
								message.cmd = Const4pbx.WS_RES_CHANGE_EXTENSION_STATE;
								message.status = Integer.valueOf(organization.getAgentStatCd());
								message.statusmsg = Const4pbx.WS_VALUE_EXTENSION_STATE_WRONGREQ;
								this.msgTemplate.convertAndSendToUser(principal.getName(), "/queue/groupware", message);
								break;
						}
						break;
					case Const4pbx.WS_VALUE_EXTENSION_STATE_LOGEDOUT:
						switch (Integer.valueOf(organization.getAgentStatCd())) {
							case Const4pbx.WS_VALUE_EXTENSION_STATE_LOGEDOUT:
								message.cmd = Const4pbx.WS_RES_CHANGE_EXTENSION_STATE;
								message.statusmsg = Const4pbx.UC_STATUS_FAIL;
								this.msgTemplate.convertAndSendToUser(principal.getName(), "/queue/groupware", message);
								
								this.sendExtState2EachExt(message, organization);
								break;
							case Const4pbx.WS_VALUE_EXTENSION_STATE_READY:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_AFTER:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_LEFT:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_REST:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_EDU:
							case Const4pbx.WS_VALUE_EXTENSION_STATE_LOGEDON:
								organization.setTempval(message.status);
								this.RequestToPbx(message);
								break;
							case Const4pbx.WS_VALUE_EXTENSION_STATE_BUSY:
							default:
								message.cmd = Const4pbx.WS_RES_CHANGE_EXTENSION_STATE;
								message.statusmsg = Const4pbx.WS_VALUE_EXTENSION_STATE_WRONGREQ;
								this.msgTemplate.convertAndSendToUser(principal.getName(), "/queue/groupware", message);
								break;
						}
						break;
					default:
						// this.RequestToPbx(message);
						
						message.cmd = Const4pbx.WS_RES_CHANGE_EXTENSION_STATE;
						message.status = Integer.valueOf(organization.getAgentStatCd());
						message.statusmsg = Const4pbx.WS_VALUE_EXTENSION_STATE_WRONGREQ;
						this.msgTemplate.convertAndSendToUser(principal.getName(), "/queue/groupware", message);
						break;
				}
				break;
			case Const4pbx.UC_MAKE_CALL_REQ:
			case Const4pbx.UC_ANSWER_CALL_REQ:
			case Const4pbx.UC_PICKUP_CALL_REQ:
			case Const4pbx.UC_DROP_CALL_REQ:
			case Const4pbx.UC_HOLD_CALL_REQ:
			case Const4pbx.UC_ACTIVE_CALL_REQ:
			case Const4pbx.UC_TRANSFER_CALL_REQ:
				this.RequestToPbx(message);
				break;
			default:
				System.err.println("ERRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR : Wrong command. message: " + message.toString());
				
				message.cmd = Const4pbx.WS_RES_CHANGE_EXTENSION_STATE;
				message.statusmsg = Const4pbx.WS_VALUE_EXTENSION_STATE_WRONGREQ;
				this.msgTemplate.convertAndSendToUser(principal.getName(), "/queue/groupware", message);
				break;
		}
	}

	/*
	@MessageMapping("/sendmsg")
	public void queueSmsMessage(SmsData message) {
		switch (message.getCmd()) {
			case Const4pbx.UC_SMS_SEND_REQ:
				this.SendSms(message);
				break;
			default:
				break;
		}
	}
	*/

	@MessageExceptionHandler
	@SendToUser("/queue/errors")
	public String handleException(Throwable exception) {
		logger.error("handleException : " + exception.getMessage());
		return exception.getMessage();
	}
    
////////////////////////////    
	
	
	private void InitializeUserState() {
		organizations = organizationMapper.getUsers();
/*        for(Organization org : organizations) {
        	org.LogedoutEventHandler.addEventHandler(this);
        }*/
		
		sendExtensionStatus();
	}
	
	private void sendExtensionStatus() {
		UcMessage msg = new UcMessage();
		msg.cmd = Const4pbx.UC_BUSY_EXT_REQ;
		this.uc.Send(msg);
	}
	
	
////////////////////////////	
    
	@Override
    public void RequestToPbx(UcMessage msg) {
        uc.Send(msg);
    }

    @Override
    public void SendSms(SmsData msg) {
    	uc.Send(msg);
    }

    @Override
	public void eventReceived(Object sender, HaveGotUcMessageEventArgs e) {
		// when a message have been arrived from the groupware socket 31001, an event raise.
		// DB
		GroupWareData data = new GroupWareData(e.getItem(), byteorder);
		
		// logger.debug("<<<---------" + data.toString());
		// System.err.println("\nbrokerAvailable : " + this.brokerAvailable.get() + "\n");
		System.err.println("\n<<<---------" + data.toString() + "\n");

		if (!this.brokerAvailable.get()) return;

		UcMessage payload;

		switch (data.getCmd()) {
			case Const4pbx.UC_REGISTER_RES:
			case Const4pbx.UC_UNREGISTER_RES:
			case Const4pbx.UC_BUSY_EXT_RES:
				return;
			case Const4pbx.UC_SMS_SEND_RES:
				// this.PassReportSms(e.getItem());
				// this.PassReportSms3(e.getItem());
				break;
			case Const4pbx.UC_REPORT_SRV_STATE:
				return;
			case Const4pbx.UC_REPORT_EXT_STATE:
			case Const4pbx.UC_SET_SRV_RES:
			case Const4pbx.UC_CLEAR_SRV_RES:
			case Const4pbx.UC_REPORT_WAITING_COUNT:
				this.PassReportExtState(data);
				break;
			case Const4pbx.UC_SMS_INFO_REQ:
				// this.PassReportSms2(e.getItem());
				this.PassReportSms3(e.getItem());
				break;
			case Const4pbx.UC_SEND_INPUT_DATA_REQ:
				data.setCmd(Const4pbx.UC_SEND_INPUT_DATA_RES);
				data.setStatus(Const4pbx.UC_STATUS_SUCCESS);
				try {
					this.uc.Send(data);
					
					Callback cb = new Callback();
					LocalDateTime localdatetime = LocalDateTime.now();
					DateTimeFormatter df = DateTimeFormatter.ofPattern("yyyyMMdd");
					cb.setResDate(localdatetime.format(df));
					df = DateTimeFormatter.ofPattern("HHmmss");
					cb.setResHms(localdatetime.format(df));
					cb.setGenDirNo(data.getCallee());
					// cb.setResTelNo(data.getCaller());
					cb.setResTelNo(data.getInputData());
					
					cbmapper.insTCallback(cb);
				} catch (Exception e2) {
					e2.printStackTrace();
				}
				break;
			case Const4pbx.UC_HOLD_CALL_RES:
			case Const4pbx.UC_ACTIVE_CALL_RES:
			case Const4pbx.UC_ANSWER_CALL_RES:
			case Const4pbx.UC_DROP_CALL_RES:
			case Const4pbx.UC_PICKUP_CALL_RES:
			default:
				if (data.getCmd() == Const4pbx.UC_HOLD_CALL_RES) {
					if (data.getStatus() == Const4pbx.UC_STATUS_SUCCESS) {
						recoder.setIsHold(data.getExtension(), true);
					}
				}
				
				if (data.getCmd() == Const4pbx.UC_ACTIVE_CALL_RES) {
					if (data.getStatus() == Const4pbx.UC_STATUS_SUCCESS) {
						recoder.setIsHold(data.getExtension(), false);
					}
				}
				
				if (data.getExtension() == null) return;
				if (data.getExtension().isEmpty()) return;

				// Organization organization = organizationMapper.selectByExt(data.getExtension());
				Organization organization = organizations.stream().filter(x -> x.getExtensionNo().equals(data.getExtension())).findFirst().get();

				if (organization.getEmpNo() == null) return;
				if (organization.getEmpNm().isEmpty()) return;
				
				payload = new UcMessage();
				payload.cmd = data.getCmd();
				payload.extension = data.getExtension();
				payload.caller = data.getCaller();
				payload.callee = data.getCallee();
				payload.status = data.getStatus();

				/*				try {
					// payload.status = Integer.valueOf(data.getUserAgent());
				} catch (NumberFormatException e3) {
					e3.printStackTrace();
				}*/

				logger.debug("******userName==>"+ organization.getEmpNo());
				this.msgTemplate.convertAndSendToUser(organization.getEmpNo(), "/queue/groupware", payload);
				break;
		}
	}

	private void PassReportExtState(GroupWareData data) {
		UcMessage payload = new UcMessage();
		payload.cmd = data.getCmd();
		payload.direct = data.getDirect();
		payload.extension = data.getExtension();
		payload.caller = data.getCaller();
		payload.callee = data.getCallee();
		payload.unconditional = data.getUnconditional();
		payload.status = data.getStatus();
		payload.statusmsg = data.getStatus();
		payload.responseCode = data.getResponseCode();

		Organization organization = null;

		//r.lock();
		try {
			organization = organizations.stream().filter(x -> x.getExtensionNo().equals(data.getExtension())).findFirst().get();
		} catch (NoSuchElementException | NullPointerException e) {
			return;
		}/* finally {
			r.unlock();
		}*/
		
		// logger.info("******PassReportExtState:" + data.getCmd());
		
		switch (data.getCmd()) {
			case Const4pbx.UC_REPORT_WAITING_COUNT:
				this.messagingTemplate.convertAndSend("/topic/ext.state." + data.getExtension(), payload);
				break;
			case Const4pbx.UC_CLEAR_SRV_RES:
				if (data.getStatus() == Const4pbx.UC_STATUS_SUCCESS) {
					organization.setTempval(Const4pbx.WS_VALUE_EXTENSION_STATE_READY);
					organization.setTempstr("");
					this.UpdateOrganization(organization);
					this.LeaveLogs(organization);
					
					payload.cmd = Const4pbx.WS_RES_CHANGE_EXTENSION_STATE;
					payload.status = Const4pbx.WS_VALUE_EXTENSION_STATE_READY;
					payload.statusmsg = Const4pbx.UC_STATUS_SUCCESS;
					this.msgTemplate.convertAndSendToUser(organization.getEmpNo(), "/queue/groupware", payload);
					
					System.err.println("UC_CLEAR_SRV_RES1: " + payload.toString());
					
					this.sendExtState2EachExt(payload, organization);
					
//					payload.cmd = Const4pbx.UC_REPORT_SRV_STATE;
//					this.messagingTemplate.convertAndSend("/topic/ext.state." + data.getExtension(), payload);
//					
//					System.err.println("UC_CLEAR_SRV_RES2: " + payload.toString());
				} else {
					payload.cmd = Const4pbx.WS_RES_CHANGE_EXTENSION_STATE;
					payload.status = Const4pbx.WS_VALUE_EXTENSION_STATE_READY;
					payload.statusmsg = Const4pbx.UC_STATUS_FAIL;
					this.msgTemplate.convertAndSendToUser(organization.getEmpNo(), "/queue/groupware", payload);
					
					System.err.println("UC_CLEAR_SRV_RES3: " + payload.toString());
					
					this.sendExtState2EachExt(payload, organization);
					
//					payload.cmd = Const4pbx.UC_REPORT_SRV_STATE;
//					// payload.status = data.getStatus();
//					this.messagingTemplate.convertAndSend("/topic/ext.state." + data.getExtension(), payload);
//					
//					System.err.println("UC_CLEAR_SRV_RES4: " + payload.toString());
				}
				// this.usersState();
				break;
			case Const4pbx.UC_SET_SRV_RES:
				if (data.getStatus() == Const4pbx.UC_STATUS_SUCCESS) {
					this.UpdateOrganization(organization);
					this.LeaveLogs(organization);
				}
				payload.cmd = Const4pbx.WS_RES_CHANGE_EXTENSION_STATE;
				payload.status = organization.getTempval();
				payload.statusmsg = data.getStatus();
				
				if (organization.getTempval() == Const4pbx.WS_VALUE_EXTENSION_STATE_LOGEDOUT) {
					System.err.println("UC_SET_SRV_RES: already logged out.");
				} else {
					this.msgTemplate.convertAndSendToUser(organization.getEmpNo(), "/queue/groupware", payload);
					System.err.println("UC_SET_SRV_RES: " + payload.toString());
				}
				
				this.sendExtState2EachExt(payload, organization);
				break;
//			case Const4pbx.UC_REPORT_SRV_STATE:
//				payload.status = Integer.valueOf(organization.getAgentStatCd());
//				payload.statusmsg = data.getStatus();
//				
//				this.messagingTemplate.convertAndSend("/topic/ext.state." + organization.getExtensionNo(), payload);
//				this.usersState();
//				
//				System.err.println("UC_REPORT_SRV_STATE: " + payload.toString());
//				break;
			case Const4pbx.UC_REPORT_EXT_STATE:
				CallStat callstat = null;
				String callid = String.valueOf(data.getStartCallSec()) + String.valueOf(data.getStartCallUSec());
				
				switch (data.getDirect()) {
					case Const4pbx.UC_DIRECT_INCOMING:
						r.lock();
						try {
							callstat = curcalls.stream().filter(x -> x.getCallId().equals(callid)
									&& x.getExtension().equals(data.getExtension())
									&& x.getDirect() == data.getDirect()).findFirst().get();
							
							payload.caller = callstat.getTelNo().replace("-", "");
							payload.callee = callstat.getExtension().replace("-", "");
							payload.status = data.getStatus();
							payload.statusmsg = data.getStatus();
						} catch (NullPointerException | NoSuchElementException e) {
							callstat = null;
						} finally {
							r.unlock();
						}
						
						switch (data.getStatus()) {
							case Const4pbx.UC_CALL_STATE_IDLE:
								if (callstat != null) {
									if (callstat.getStatus() == Const4pbx.UC_CALL_STATE_RINGING
											|| callstat.getStatus() == Const4pbx.UC_CALL_STATE_INVITING) {
										callstat.setAgentTransYn("N");
										callstatMapper.updateCallStatEnd(callstat);
										
										w.lock();
										try {
											curcalls.removeIf(x -> x.getCallId().equals(callid) && x.getExtension().equals(data.getExtension()));
											// curcalls.removeIf(x -> x.getExtension().equals(data.getExtension()));
										} finally {
											w.unlock();
										}
										this.messagingTemplate.convertAndSend("/topic/ext.state." + payload.extension, payload);
										
										System.err.println("\n\nUC_REPORT_EXT_STATE : " + payload.toString() + "\n\n");
									} else if (callstat.getStatus() == Const4pbx.UC_CALL_STATE_BUSY) {
										callstat.setStatus(data.getStatus());
										callstat.setAgentTransYn("Y");
										callstat.setCallStatSec((int)((new Date().getTime() - callstat.getSdate().getTime()) / 1000));
										callstatMapper.updateCallStatEnd(callstat);
										
										organization.setAgentStatCd(String.valueOf(Const4pbx.WS_VALUE_EXTENSION_STATE_READY));

										w.lock();
										try {
											curcalls.removeIf(x -> x.getCallId().equals(callid) && x.getExtension().equals(data.getExtension()));
											// curcalls.removeIf(x -> x.getExtension().equals(data.getExtension()));
										} finally {
											w.unlock();
										}
										this.messagingTemplate.convertAndSend("/topic/ext.state." + data.getExtension(), payload);
										
										System.err.println("\n\nUC_REPORT_EXT_STATE : " + payload.toString() + "\n\n");
									}
								}
								break;
							case Const4pbx.UC_CALL_STATE_INVITING:
							case Const4pbx.UC_CALL_STATE_RINGING:
								if (callstat == null) {
									callstat = new CallStat();
									callstat.setCallId(callid);
									callstat.setDirect(data.getDirect());
									callstat.setExtension(data.getExtension());
									callstat.setTelNo(data.getCaller());
									callstat.setStatus(data.getStatus());
									
									if (data.getCaller().length() <= extensionlength) {
										callstat.setCallTypCd("1003");
									} else {
										callstat.setCallTypCd("1001");
									}
									
									callstat.setEmpNo(organization.getEmpNo());
									
									LocalDateTime localdatetime = LocalDateTime.now();
									DateTimeFormatter df = DateTimeFormatter.ofPattern("yyyyMMdd");
									callstat.setRegDate(localdatetime.format(df));
							
									df = DateTimeFormatter.ofPattern("HHmmss");
									callstat.setRegHms(localdatetime.format(df));
									
									w.lock();
									try {
										curcalls.add(callstat);
									} finally {
										w.unlock();
									}

									callstatMapper.insertCallStat(callstat);
									this.messagingTemplate.convertAndSend("/topic/ext.state." + payload.extension, payload);
									
									System.err.println("\n\nUC_REPORT_EXT_STATE : " + payload.toString() + "\n\n");
								} else {
									if (callstat.getStatus() == Const4pbx.UC_CALL_STATE_INVITING) {
										callstat.setStatus(data.getStatus());
										this.messagingTemplate.convertAndSend("/topic/ext.state." + payload.extension, payload);
										
										System.err.println("\n\nUC_REPORT_EXT_STATE : " + payload.toString() + "\n\n");
									}
								}
								break;
							case Const4pbx.UC_CALL_STATE_BUSY:
								if (callstat != null) {
									if (callstat.getStatus() == Const4pbx.UC_CALL_STATE_INVITING
											|| callstat.getStatus() == Const4pbx.UC_CALL_STATE_RINGING) {
										callstat.setStatus(data.getStatus());
										callstat.setSdate(new Date());
										callstat.setAgentTransYn("Y");
										
										organization.setAgentStatCd(String.valueOf(Const4pbx.WS_VALUE_EXTENSION_STATE_BUSY));
										
										this.messagingTemplate.convertAndSend("/topic/ext.state." + payload.extension, payload);
										
										System.err.println("\n\nUC_REPORT_EXT_STATE : " + payload.toString() + "\n\n");
									}
								}
								break;
						}
						break;
					case Const4pbx.UC_DIRECT_OUTGOING:
						r.lock();
						try {
							callstat = curcalls.stream().filter(x -> x.getCallId().equals(callid)
									&& x.getExtension().equals(data.getExtension())
									&& x.getDirect() == data.getDirect()).findFirst().get();
							
							payload.caller = callstat.getExtension().replace("-", "");
							payload.callee = callstat.getTelNo().replace("-", "");
							payload.status = data.getStatus();
							payload.statusmsg = data.getStatus();
						} catch (NullPointerException | NoSuchElementException e) {
							callstat = null;
						} finally {
							r.unlock();
						}
						
						switch (data.getStatus()) {
							case Const4pbx.UC_CALL_STATE_IDLE:
								if (callstat != null) {
									if (callstat.getStatus() == Const4pbx.UC_CALL_STATE_RINGING
											|| callstat.getStatus() == Const4pbx.UC_CALL_STATE_RINGBACK
											|| callstat.getStatus() == Const4pbx.UC_CALL_STATE_INVITING) {
										callstat.setAgentTransYn("N");
										callstatMapper.updateCallStatEnd(callstat);

										w.lock();
										try {
											// curcalls.removeIf(x -> x.getTelNo().equals(data.getCaller()) && x.getExtension().equals(data.getCallee()));
											curcalls.removeIf(x -> x.getCallId().equals(callid) && x.getExtension().equals(data.getExtension()));
										} finally {
											w.unlock();
										}
										
										this.messagingTemplate.convertAndSend("/topic/ext.state." + payload.extension, payload);
										
										System.err.println("\n\nUC_REPORT_EXT_STATE : " + payload.toString() + "\n\n");
									} else if (callstat.getStatus() == Const4pbx.UC_CALL_STATE_BUSY) {
										callstat.setStatus(data.getStatus());
										callstat.setAgentTransYn("Y");
										callstat.setCallStatSec((int)((new Date().getTime() - callstat.getSdate().getTime()) / 1000));
										callstatMapper.updateCallStatEnd(callstat);
										
										organization.setAgentStatCd(String.valueOf(Const4pbx.WS_VALUE_EXTENSION_STATE_READY));

										w.lock();
										try {
											curcalls.removeIf(x -> x.getCallId().equals(callid) && x.getExtension().equals(data.getExtension()));
										} finally {
											w.unlock();
										}
										
										this.messagingTemplate.convertAndSend("/topic/ext.state." + payload.extension, payload);
										
										System.err.println("\n\nUC_REPORT_EXT_STATE : " + payload.toString() + "\n\n");
									}
								}
								break;
							case Const4pbx.UC_CALL_STATE_INVITING:
								if (callstat == null) {
									if (data.getExtension().equals(data.getCallee())) {
										data.SwapCallerCallee();
										
										payload.caller = data.getCaller();
										payload.callee = data.getCallee();
									}
									
									callstat = new CallStat();
									callstat.setCallId(callid);
									callstat.setDirect(data.getDirect());
									callstat.setExtension(data.getExtension());
									callstat.setTelNo(data.getCallee());
									callstat.setStatus(data.getStatus());
									
									if (data.getCallee().length() <= extensionlength) {
										callstat.setCallTypCd("1003");
									} else {
										callstat.setCallTypCd("1002");
									}
									
									callstat.setEmpNo(organization.getEmpNo());
									
									LocalDateTime localdatetime = LocalDateTime.now();
									DateTimeFormatter df = DateTimeFormatter.ofPattern("yyyyMMdd");
									callstat.setRegDate(localdatetime.format(df));
									
									df = DateTimeFormatter.ofPattern("HHmmss");
									callstat.setRegHms(localdatetime.format(df));

									w.lock();
									try {
										curcalls.add(callstat);
									} finally {
										w.unlock();
									}

									callstatMapper.insertCallStat(callstat);
									this.messagingTemplate.convertAndSend("/topic/ext.state." + payload.extension, payload);
									
									System.err.println("\n\nUC_REPORT_EXT_STATE : " + payload.toString() + "\n\n");
								}
								break;
							case Const4pbx.UC_CALL_STATE_RINGING:
							case Const4pbx.UC_CALL_STATE_RINGBACK:
								if (callstat != null) {
									if (callstat.getStatus() == Const4pbx.UC_CALL_STATE_INVITING) {
										callstat.setStatus(data.getStatus());
										
										this.messagingTemplate.convertAndSend("/topic/ext.state." + payload.extension, payload);
										
										System.err.println("\n\nUC_REPORT_EXT_STATE : " + payload.toString() + "\n\n");
									}
								} else {
									if (data.getExtension().equals(data.getCallee())) {
										data.SwapCallerCallee();
										
										payload.caller = data.getCaller();
										payload.callee = data.getCallee();
									}
									
									callstat = new CallStat();
									callstat.setCallId(callid);
									callstat.setDirect(data.getDirect());
									callstat.setExtension(data.getExtension());
									callstat.setTelNo(data.getCallee());
									callstat.setStatus(data.getStatus());
									
									if (data.getCallee().length() <= extensionlength) {
										callstat.setCallTypCd("1003");
									} else {
										callstat.setCallTypCd("1002");
									}
									
									// callstat.setCallTypCd(String.valueOf(data.getDirect()));
									callstat.setEmpNo(organization.getEmpNo());
									
									LocalDateTime localdatetime = LocalDateTime.now();
									DateTimeFormatter df = DateTimeFormatter.ofPattern("yyyyMMdd");
									callstat.setRegDate(localdatetime.format(df));
									
									df = DateTimeFormatter.ofPattern("HHmmss");
									callstat.setRegHms(localdatetime.format(df));

									w.lock();
									try {
										curcalls.add(callstat);
									} finally {
										w.unlock();
									}

									callstatMapper.insertCallStat(callstat);
									
									this.messagingTemplate.convertAndSend("/topic/ext.state." + payload.extension, payload);
									
									System.err.println("\n\nUC_REPORT_EXT_STATE : " + payload.toString() + "\n\n");
								}
								break;
							case Const4pbx.UC_CALL_STATE_BUSY:
								if (callstat != null) {
									if (callstat.getStatus() == Const4pbx.UC_CALL_STATE_INVITING
											|| callstat.getStatus() == Const4pbx.UC_CALL_STATE_RINGBACK) {
										callstat.setSdate(new Date());
										callstat.setStatus(data.getStatus());
										
										organization.setAgentStatCd(String.valueOf(Const4pbx.WS_VALUE_EXTENSION_STATE_BUSY));
										
										this.messagingTemplate.convertAndSend("/topic/ext.state." + payload.extension, payload);
										
										System.err.println("\n\nUC_REPORT_EXT_STATE : " + payload.toString() + "\n\n");
									}
								}
								break;
						}
						break;
					default:
						// this.messagingTemplate.convertAndSend("/topic/ext.state." + data.getExtension(), payload);
						System.err.println("default......... data: " + data.toString());
						break;
				}
				
				this.usersState();
				break;
		}
	}

/*	private void PassReportSms(byte[] bytes) {
		SmsData data = new SmsData(bytes, byteorder);
		Sms_sample sms = new Sms_sample();
		sms.setExt(data.getFrom_ext());
		sms.setCusts_tel(data.getReceiverphones());
		sms.setContents(data.getMessage());
		sms.setIdx(smsMapper.add(sms));

		r.lock();
		try {
			this.smsrunning.add(sms);
		} finally {
			r.unlock();
		}
	}

	private void PassReportSms2(byte[] bytes) {
		SmsData data = new SmsData(bytes, byteorder);
		data.setCmd(Const4pbx.UC_SMS_INFO_RES);
		if (data.getStatus() == Const4pbx.UC_STATUS_FAIL) {
			data.setStatus(Const4pbx.UC_STATUS_FAIL);
		} else {
			data.setStatus(Const4pbx.UC_STATUS_SUCCESS);
		}
		this.SendSms(data);

		Organization organization = organizations.stream().filter(x -> x.getExtensionNo().equals(data.getFrom_ext())).findFirst().get();

		if (organization.getEmpNo() == null) return;
		if (organization.getEmpNo().isEmpty()) return;

		UcMessage payload = new UcMessage();
		payload.cmd = data.getCmd();
		payload.extension = data.getFrom_ext();
		payload.status = data.getStatus();

		Sms_sample runningsms = null;

		r.lock();
		try {
			runningsms = smsrunning.stream().filter(x -> x.getExt().equals(data.getFrom_ext())).findFirst().get();
			runningsms.setResult(data.getStatus());
			payload.status = data.getStatus();
			smsMapper.setresult(runningsms);
		} catch (NoSuchElementException | NullPointerException e) {
			payload.status = Const4pbx.WS_STATUS_ING_NOTFOUND;
		} catch (Exception e) {

		} finally {
			r.unlock();
		}

		w.lock();
		try {
			smsrunning.removeIf(x -> x.equals(data.getFrom_ext()));
		} catch (UnsupportedOperationException | NullPointerException e) {
			payload.status = Const4pbx.WS_STATUS_ING_UNSUPPORTED;
		} finally {
			w.unlock();
		}

		this.msgTemplate.convertAndSendToUser(organization.getEmpNo(), "/queue/groupware", payload);
	}
*/
	
	private List<Sms> smses = new ArrayList<Sms>();
	private Timer smsSendTimer;
	
	private void PassReportSms3(byte[] bytes) {
		SmsData data = new SmsData(bytes, byteorder);
		data.setCmd(Const4pbx.UC_SMS_INFO_RES);
		data.setStatus(Const4pbx.UC_STATUS_SUCCESS);
/*		
		data.setType(Const4pbx.UC_TYPE_GROUPWARE);
		if (data.getStatus() == Const4pbx.UC_STATUS_FAIL) {
			data.setStatus(Const4pbx.UC_STATUS_FAIL);
		} else {
			data.setStatus(Const4pbx.UC_STATUS_SUCCESS);
		}
*/		
		this.SendSms(data);

		try {
			final Organization org = organizations.stream().filter(x -> x.getExtensionNo().equals(data.getFrom_ext())).findFirst().get();
			Sms sms = smses.stream().filter(x -> x.getSendTelNo().equals(data.getTo_ext()) && x.getEmpNo().equals(org.getEmpNo()) && x.getSendCd().equals("1001")).findFirst().get();
			
			if (data.getStatus() == Const4pbx.UC_STATUS_SUCCESS)
				sms.setSendCd("1002");
			else
				sms.setSendCd("1003");
				
			// sms.setSendCd(String.valueOf(data.getStatus()));
			smsMapper.hadSentSms(sms);
		} catch (NoSuchElementException | NullPointerException e) {
			System.err.println("An error has broken out in PassReportSms3 method.\n--->>" + e.getMessage());
			// e.printStackTrace();
		}

		try {
			final Sms sms2 = smses.stream().filter(x -> x.getSendCd().equals("1001")).findFirst().get();
			Organization org2 = organizations.stream().filter(x -> x.getEmpNo().equals(sms2.getEmpNo())).findFirst().get();
			
			SmsData message = new SmsData();
			message.setCmd(Const4pbx.UC_SMS_SEND_REQ);
			message.setType(Const4pbx.UC_TYPE_GROUPWARE);
			message.setFrom_ext(org2.getExtensionNo());
			message.setTo_ext(sms2.getSendTelNo());
			message.setMessage(sms2.getSendComment());
			this.SendSms(message);
		} catch (NoSuchElementException | NullPointerException e) {
			smses.clear();
		}
	}
	
	class SmsSendTimer_Elapsed extends TimerTask {
		public WebUcService parent = null;
		public SmsSendTimer_Elapsed(WebUcService obj) {
			this.parent = obj;
		}
		
		@Override
		public void run() {
			w.lock();
			try {
				smses = smsMapper.selectNotSentSms();
			} finally {
				w.unlock();
			}
			
			Sms sms = null;
			//r.lock();
			try {
				sms = smses.stream().filter(x -> x.getSendCd().equals("1001")).findFirst().get();
				final String tempNo = sms.getEmpNo();
				Organization org = organizations.stream().filter(x -> x.getEmpNo().equals(tempNo)).findFirst().get();
				
				SmsData message = new SmsData();
				message.setCmd(Const4pbx.UC_SMS_SEND_REQ);
				message.setType(Const4pbx.UC_TYPE_GROUPWARE);
				message.setFrom_ext(org.getExtensionNo());
				message.setTo_ext(sms.getSendTelNo());
				message.setMessage(sms.getSendComment());
				SendSms(message);
				
			} catch (NoSuchElementException | NullPointerException e) {
				return;
			}/* finally {
				r.unlock();
			}*/
			
/*			for (Sms sms : smses) {
				SmsData message = new SmsData();
				message.setCmd(Const4pbx.UC_SMS_SEND_REQ);
				SendSms(message);
			}*/
		}
		
	}

/*	@Override
	public void EventReceived2(Object sender, LogedoutEventArgs e) {
		Organization org = (Organization)sender;
		
		UcMessage payload = new UcMessage();
		payload.cmd = Const4pbx.UC_REPORT_EXT_STATE;
		payload.extension = org.getExtensionNo();
		payload.status = Const4pbx.WS_VALUE_EXTENSION_STATE_LOGEDOUT;
		
		this.messagingTemplate.convertAndSend("/topic/ext.state." + org.getExtensionNo(), payload);
		this.usersState();
	}*/
}
