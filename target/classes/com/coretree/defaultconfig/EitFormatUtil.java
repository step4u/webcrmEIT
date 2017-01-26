package com.coretree.defaultconfig;

import java.text.MessageFormat;

public class EitFormatUtil {

    /**
     * reflection된 10자리 사업자등록번호를 '-'를 삽입하여 반환한다.
     */
    public static String toBid(String str) {
	if (str.length() != 10 || str == null)
	    return str;
	String message = "{0}-{1}-{2}";
	Object[] args = { str.substring(0, 3), str.substring(3, 5), str.substring(5, 10) };
	return MessageFormat.format(message, args);
    }

    /**
     * 6-7자리 주민등록번호 '-'를 삽입하여 반환한다.
     */
    public static String toSid(String str) {
	if (str.length() != 13)
	    return str;
	String message = "{0}-{1}";
	Object[] args = { str.substring(0, 6), str.substring(6, 13) };
	return MessageFormat.format(message, args);
    }

    /**
     * 10~11자리 전화번호를 '-'를 삽입하여 반환한다.
     */
    public static String toTel(String str) {
	if (str == null)
	    return "";
	int len = str.length();
	if (len < 9)
	    return str;

	String message = "{0}-{1}-{2}";
	Object[] args = new String[3];
	String body = null;

	if (str.startsWith("01")) { // 무선
	    args[0] = str.substring(0, 3);
	    body = str.substring(3);
	} else if (str.startsWith("02")) { // 서울
	    args[0] = str.substring(0, 2);
	    body = str.substring(2);
	} else { // 지방
	    args[0] = str.substring(0, 3);
	    body = str.substring(3);
	}

	if (body.length() == 7) {
	    args[1] = body.substring(0, 3);
	    args[2] = body.substring(3);
	} else if (body.length() == 8) {
	    args[1] = body.substring(0, 4);
	    args[2] = body.substring(4);
	} else {
	    message = "{0}-{1}";
	    args[1] = body;
	}

	return MessageFormat.format(message, args);
    }
}
