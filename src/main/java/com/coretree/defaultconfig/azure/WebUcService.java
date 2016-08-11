package com.coretree.defaultconfig.azure;

import java.io.IOException;
import java.net.UnknownHostException;
import java.nio.ByteOrder;
import java.security.Principal;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.TimerTask;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.messaging.core.MessageSendingOperations;
import org.springframework.messaging.handler.annotation.MessageExceptionHandler;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.annotation.SendToUser;
import org.springframework.messaging.simp.broker.BrokerAvailabilityEvent;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RestController;

import com.coretree.defaultconfig.main.mapper.CallbackMapper;
import com.coretree.defaultconfig.main.model.Callback;
import com.coretree.defaultconfig.mapper.Call;
import com.coretree.defaultconfig.mapper.CallMapper;
import com.coretree.defaultconfig.mapper.Customer2;
import com.coretree.defaultconfig.mapper.Customer2Mapper;
import com.coretree.defaultconfig.mapper.Member;
import com.coretree.defaultconfig.mapper.MemberMapper;
import com.coretree.defaultconfig.mapper.SmsMapper_sample;
import com.coretree.defaultconfig.mapper.Sms_sample;
import com.coretree.event.HaveGotUcMessageEventArgs;
import com.coretree.event.IEventHandler;
import com.coretree.models.GroupWareData;
import com.coretree.models.SmsData;
import com.coretree.models.UcMessage;
import com.coretree.socket.UcServer;
import com.coretree.util.Const4pbx;

@Service
@RestController
public class WebUcService implements
        ApplicationListener<BrokerAvailabilityEvent> ,
        IEventHandler<HaveGotUcMessageEventArgs>,
        ITelStatusService {

    private static final Log logger = LogFactory.getLog(WebUcService.class);

	private final MessageSendingOperations<String> messagingTemplate;
	private final SimpMessagingTemplate msgTemplate;

    //private ITelStatusService ucservice;

    private UcServer uc;

	private AtomicBoolean brokerAvailable = new AtomicBoolean();
	private ByteOrder byteorder = ByteOrder.BIG_ENDIAN;

    @Autowired
    private WebUcServiceConfig configs;

	@Autowired
	private MemberMapper memberMapper;
	@Autowired
	private Customer2Mapper custMapper;
	@Autowired
	private CallMapper callMapper;
	@Autowired
	private SmsMapper_sample smsMapper;
	@Autowired
	private CallbackMapper cbmapper;
	
	//
	//@Autowired
	//private Principal pInfo;
	
	private List<Call> curcalls = new ArrayList<Call>();
	private List<Member> userstate = new ArrayList<Member>();
	private List<Sms_sample> smsrunning = new ArrayList<Sms_sample>();
	
	private final ReentrantReadWriteLock rwl = new ReentrantReadWriteLock();
    private final Lock r = rwl.readLock();
    private final Lock w = rwl.writeLock();
    
    @Autowired
    public WebUcService(MessageSendingOperations<String> messagingTemplate, SimpMessagingTemplate msgTemplate) {
        this.messagingTemplate = messagingTemplate;
        this.msgTemplate = msgTemplate;
    }

////////////////////////////
	
	@MessageMapping("/call" )
	public void queueCallMessage(UcMessage message, Principal principal) {
		
		//logger.debug("::::::queueCallMessage------>" + principal);
		System.out.println("::::::queueCallMessage------>" + message.toString());
		logger.debug(message.cmd+ ":=================>>>" + message);
//		for (Member m : userstate) {
//			logger.debug("Member:---" + m);
//		}
		
		switch (message.cmd) {
			case Const4pbx.WS_REQ_EXTENSION_STATE:
				message.cmd = Const4pbx.WS_RES_EXTENSION_STATE;
				for (Member m : userstate) {
					message.extension = m.getExtension();
					message.status = m.getState();
					this.msgTemplate.convertAndSendToUser(principal.getName(), "/queue/groupware", message);
				}
				break;
			case Const4pbx.WS_REQ_SET_EXTENSION_STATE:
				Member mem = userstate.stream().filter(x -> x.getExtension().equals(message.extension)).findFirst().get();

				logger.debug(mem);
				//message = GetMessage(mem, message.status);
				break;
			case Const4pbx.WS_REQ_RELOAD_USER:
				break;
			case Const4pbx.WS_VALUE_EXTENSION_STATE_ONLINE:
			case Const4pbx.WS_VALUE_EXTENSION_STATE_LEFT:
			case Const4pbx.WS_VALUE_EXTENSION_STATE_DND:
			case Const4pbx.WS_VALUE_EXTENSION_STATE_REDIRECTED:
				Member member;
				r.lock();
				try {
					member = userstate.stream().filter(x -> x.getExtension().equals(message.extension)).findFirst().get();
				} catch (NoSuchElementException | NullPointerException e) {
					member = null;
				} finally {
					r.unlock();
				}

				this.RequestToPbx(message);
				member.setTempval(message.cmd);
				break;
				
			default:
				this.RequestToPbx(message);
				break;
		}
	}

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

	@MessageExceptionHandler
	@SendToUser("/queue/errors")
	public String handleException(Throwable exception) {
		logger.error("handleException : " + exception.getMessage());
		return exception.getMessage();
	}
    
////////////////////////////    
	
	
	private void initializeUserState() {
		userstate = memberMapper.getUserState();
		sendExtensionStatus();
	}
	
	private void sendExtensionStatus() {
		UcMessage msg = new UcMessage();
		msg.cmd = Const4pbx.UC_BUSY_EXT_REQ;

		try {
			this.uc.Send(msg);
		} catch (UnknownHostException e) {
			e.printStackTrace();
		}
	}
	
	
////////////////////////////	
    
	@Override
    public void RequestToPbx(UcMessage msg) {
        try {
            //logger.debug("RequestToPbx------>>>"+ msg);
            uc.Send(msg);
            logger.debug("RequestToPbx------>>>"+ msg);
        } 
        catch (UnknownHostException e) {
           logger.error("RequestToPbx",e);
        }
    }

    @Override
    public void SendSms(SmsData msg) {
        try {
            uc.Send(msg);
        } catch (UnknownHostException e) {
            logger.error("SendSms",e);
        }
    }

    @Override
    public void onApplicationEvent(BrokerAvailabilityEvent event) {
    	
        this.brokerAvailable.set(event.isBrokerAvailable());
        
        uc = new UcServer(configs.getPbxip(), 31001, 1, this.byteorder);
        uc.HaveGotUcMessageEventHandler.addEventHandler(this);
        // uc.regist();

        initializeUserState();
    }

    @Override
	public void eventReceived(Object sender, HaveGotUcMessageEventArgs e) {
		// when a message have been arrived from the groupware socket 31001, an event raise.
		// DB
		GroupWareData data = new GroupWareData(e.getItem(), byteorder);
		
		logger.debug("<<<---------" + data.toString());

		if (!this.brokerAvailable.get()) return;

		UcMessage payload;

		switch (data.getCmd()) {
			case Const4pbx.UC_REGISTER_RES:
			case Const4pbx.UC_UNREGISTER_RES:
			case Const4pbx.UC_BUSY_EXT_RES:
				break;
			case Const4pbx.UC_SMS_SEND_RES:
				this.PassReportSms(e.getItem());
				break;
			case Const4pbx.UC_REPORT_EXT_STATE:
				for (Member mem : userstate) {
					if (mem.getExtension().equals(data.getExtension())) {
						mem.setState(data.getStatus());
					}
				}
				if (data.getCallee().isEmpty()) break;
			case Const4pbx.UC_REPORT_SRV_STATE:
			case Const4pbx.UC_SET_SRV_RES:
			case Const4pbx.UC_CLEAR_SRV_RES:
			case Const4pbx.UC_REPORT_WAITING_COUNT:
				this.PassReportExtState(data);
				break;
			case Const4pbx.UC_SMS_INFO_REQ:
				this.PassReportSms2(e.getItem());
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
					//cb.setResTelNo(data.getCaller());
					cb.setResTelNo(data.getInputData());
					
					cbmapper.insTCallback(cb);
					
				} catch (IOException e1) {
					System.err.println(String.format("Has failed to send %s", e1.getStackTrace().toString()));
				} catch (Exception e2) {
					e2.printStackTrace();
				}
				break;
			default:
				if (data.getExtension() == null) return;
				if (data.getExtension().isEmpty()) return;

				Member mem = memberMapper.selectByExt(data.getExtension());

				if (mem.getUsername() == null) return;
				if (mem.getUsername().isEmpty()) return;

				payload = new UcMessage();
				payload.cmd = data.getCmd();
				payload.extension = data.getExtension();
				payload.caller = data.getCaller();
				payload.callee = data.getCallee();
				payload.status = data.getStatus();

				logger.debug("******userName==>"+ mem.getUsername());
				this.msgTemplate.convertAndSendToUser(mem.getUsername(), "/queue/groupware", payload);
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
		payload.responseCode = data.getResponseCode();

		Member counsellor = null;

		r.lock();
		try
		{
			counsellor = userstate.stream().filter(x -> x.getExtension().equals(data.getExtension())).findFirst().get();
		} catch (NoSuchElementException | NullPointerException e) {
			return;
		} finally {
			r.unlock();
		}
		
		logger.info("******PassReportExtState:"+ data.getCmd());

		switch (data.getCmd()) {
			case Const4pbx.UC_REPORT_WAITING_COUNT:
				this.messagingTemplate.convertAndSend("/topic/ext.state." + data.getExtension(), payload);
				break;
			case Const4pbx.UC_CLEAR_SRV_RES:
				if (data.getStatus() == Const4pbx.UC_STATUS_SUCCESS) {
					counsellor.setState(Const4pbx.WS_VALUE_EXTENSION_STATE_ONLINE);
					counsellor.setTempstr("");
					payload.status = counsellor.getState();
					this.messagingTemplate.convertAndSend("/topic/ext.state." + data.getExtension(), payload);
				}
				break;
			case Const4pbx.UC_SET_SRV_RES:
				if (data.getStatus() == Const4pbx.UC_STATUS_SUCCESS) {
					counsellor.setState(counsellor.getTempval());
					if (data.getResponseCode() == Const4pbx.UC_SRV_UNCONDITIONAL) {
						counsellor.setTempstr(data.getUnconditional());
					} else if (data.getResponseCode() == Const4pbx.UC_SRV_NOANSWER) {
						counsellor.setTempstr(data.getNoanswer());
					} else if (data.getResponseCode() == Const4pbx.UC_SRV_BUSY) {
						counsellor.setTempstr(data.getBusy());
					}
				}
				break;
			case Const4pbx.UC_REPORT_SRV_STATE:
				if (counsellor.getState() == Const4pbx.WS_VALUE_EXTENSION_STATE_ONLINE
						|| counsellor.getState() == Const4pbx.WS_VALUE_EXTENSION_STATE_LEFT
						|| counsellor.getState() == Const4pbx.WS_VALUE_EXTENSION_STATE_DND
						|| counsellor.getState() == Const4pbx.WS_VALUE_EXTENSION_STATE_REDIRECTED) {
					payload.status = counsellor.getState();

					this.messagingTemplate.convertAndSend("/topic/ext.state." + data.getExtension(), payload);
				}
				break;
			case Const4pbx.UC_REPORT_EXT_STATE:
				Call call = null;

				switch (data.getDirect()) {
					case Const4pbx.UC_DIRECT_INCOMING:

						r.lock();
						try {
							call = curcalls.stream().filter(x -> x.getExtension().equals(data.getCallee())
									&& x.getCust_tel().equals(data.getCaller())).findFirst().get();
						} catch (NullPointerException | NoSuchElementException e) {
							call = null;
						} finally {
							r.unlock();
						}

						switch (data.getStatus()) {
							case Const4pbx.UC_CALL_STATE_IDLE:
								if (call != null) {
									if (call.getStatus() == Const4pbx.UC_CALL_STATE_RINGING) {
										callMapper.modiEnd(call);

										w.lock();
										try {
											curcalls.removeIf(x -> x.getCust_tel().equals(data.getCaller()) && x.getExtension().equals(data.getCallee()));
										} finally {
											w.unlock();
										}
									} else if (call.getStatus() == Const4pbx.UC_CALL_STATE_BUSY) {
										call.setStatus(data.getStatus());
										call.setEnddate(new Timestamp(System.currentTimeMillis()));
										callMapper.modiStatus(call);

										w.lock();
										try {
											curcalls.removeIf(x -> x.getCust_tel().equals(data.getCaller()) && x.getExtension().equals(data.getCallee()));
										} finally {
											w.unlock();
										}
									}
									this.messagingTemplate.convertAndSend("/topic/ext.state." + data.getExtension(), payload);
									// System.err.println("IDLE curcalls.size(): " + curcalls.size());
								}
								break;
							case Const4pbx.UC_CALL_STATE_INVITING:
							case Const4pbx.UC_CALL_STATE_RINGING:
								if (call == null) {
									Member member = memberMapper.selectByExt(data.getExtension());

									call = new Call();
									call.setExtension(data.getExtension());
									call.setCust_tel(data.getCaller());
									call.setStatus(data.getStatus());
									call.setDirect(data.getDirect());
									call.setUsername(member.getUsername());

									w.lock();
									try {
										curcalls.add(call);
									} finally {
										w.unlock();
									}

									callMapper.add(call);
									this.messagingTemplate.convertAndSend("/topic/ext.state." + data.getExtension(), payload);
									//System.err.println("RINGING curcalls.size(): " + curcalls.size());
								}
								break;
							case Const4pbx.UC_CALL_STATE_BUSY:
								if (call != null) {
									call.setStartdate(new Timestamp(System.currentTimeMillis()));
									call.setStatus(data.getStatus());
									callMapper.modiStatus(call);
									this.messagingTemplate.convertAndSend("/topic/ext.state." + data.getExtension(), payload);
									// System.err.println("BUSY curcalls.size(): " + curcalls.size());
								}
								break;
						}

						if (call != null) {
							call.setStatus(data.getStatus());

							Member member = memberMapper.selectByExt(data.getExtension());
							if (member != null) {
								Customer2 cust = custMapper.findByExt(data.getCaller());

								if (cust != null) {
									payload.callername = cust.getCust_nm();
									payload.cust_no = cust.getCust_cd();
								}
								if (member != null) {
									payload.calleename = member.getUname();
								}

								payload.call_idx = call.getIdx();
								this.msgTemplate.convertAndSendToUser(member.getUsername(), "/queue/groupware", payload);
							}
						}
						// this.messagingTemplate.convertAndSend("/topic/ext.state." + data.getExtension(), payload);
						break;
					case Const4pbx.UC_DIRECT_OUTGOING:
						r.lock();
						try {
							call = curcalls.stream().filter(x -> x.getExtension().equals(data.getExtension())
									&& x.getCust_tel().equals(data.getCallee())).findFirst().get();
						} catch (NullPointerException | NoSuchElementException e) {
							call = null;
						} finally {
							r.unlock();
						}

						switch (data.getStatus()) {
							case Const4pbx.UC_CALL_STATE_IDLE:
								if (call != null) {
									if (call.getStatus() == Const4pbx.UC_CALL_STATE_RINGING) {
										callMapper.modiEnd(call);

										w.lock();
										try {
											curcalls.removeIf(x -> x.getCust_tel().equals(data.getCaller()) && x.getExtension().equals(data.getCallee()));
										} finally {
											w.unlock();
										}
									} else if (call.getStatus() == Const4pbx.UC_CALL_STATE_BUSY) {
										call.setStatus(data.getStatus());
										call.setEnddate(new Timestamp(System.currentTimeMillis()));
										callMapper.modiStatus(call);

										w.lock();
										try {
											curcalls.removeIf(x -> x.getCust_tel().equals(data.getCallee()) && x.getExtension().equals(data.getExtension()));
										} finally {
											w.unlock();
										}
									}
									this.messagingTemplate.convertAndSend("/topic/ext.state." + data.getExtension(), payload);
									System.err.println("IDLE curcalls.size(): " + curcalls.size());
								}
								break;
							case Const4pbx.UC_CALL_STATE_INVITING:
								if (call == null) {
									Member member = memberMapper.selectByExt(data.getExtension());

									call = new Call();
									call.setExtension(data.getExtension());
									call.setCust_tel(data.getCallee());
									call.setStartdate(new Timestamp(System.currentTimeMillis()));
									call.setStatus(data.getStatus());
									call.setDirect(data.getDirect());
									call.setUsername(member.getUsername());

									w.lock();
									try {
										curcalls.add(call);
									} finally {
										w.unlock();
									}

									callMapper.add(call);
									this.messagingTemplate.convertAndSend("/topic/ext.state." + data.getExtension(), payload);
								}
								break;
							case Const4pbx.UC_CALL_STATE_BUSY:
								if (call != null) {
									call.setStartdate(new Timestamp(System.currentTimeMillis()));
									call.setStatus(data.getStatus());
									callMapper.modiStatus(call);
									this.messagingTemplate.convertAndSend("/topic/ext.state." + data.getExtension(), payload);
									System.err.println("BUSY curcalls.size(): " + curcalls.size());
								}
								break;
						}

						if (call != null) {
							call.setStatus(data.getStatus());

							Member member = memberMapper.selectByExt(data.getExtension());
							if (member != null) {
								Customer2 cust = custMapper.findByExt(data.getCallee());

								if (cust != null) {
									payload.calleename = cust.getCust_nm();
									payload.cust_no = cust.getCust_no();
								}
								if (member != null) {
									payload.callername = member.getUname();
								}

								payload.call_idx = call.getIdx();
								this.msgTemplate.convertAndSendToUser(member.getUsername(), "/queue/groupware", payload);
							}
						}

						// this.messagingTemplate.convertAndSend("/topic/ext.state." + data.getExtension(), payload);
						break;
					default:
						this.messagingTemplate.convertAndSend("/topic/ext.state." + data.getExtension(), payload);
						break;
				}
				break;
		}
	}

	private void PassReportSms(byte[] bytes) {
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

		// this.msgTemplate.convertAndSendToUser(mem.getUsername(), "/queue/groupware", data);
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

		Member mem = userstate.stream().filter(x -> x.getExtension().equals(data.getFrom_ext())).findFirst().get();

		if (mem.getUsername() == null) return;
		if (mem.getUsername().isEmpty()) return;

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

		this.msgTemplate.convertAndSendToUser(mem.getUsername(), "/queue/groupware", payload);
	}

	class Timer_Elapsed extends TimerTask {
		public WebUcService parent = null;
		public Timer_Elapsed(WebUcService obj) {
			this.parent = obj;
		}

		@Override
		public void run() {

		}
	}



}
