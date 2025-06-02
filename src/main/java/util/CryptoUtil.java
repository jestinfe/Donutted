package util;
import java.security.MessageDigest;
import java.util.Base64;

import kr.co.sist.cipher.*;

public class CryptoUtil {

    private static final String KEY = "q1w2e3r4t5y6u7i8";

    static {
        if (!(KEY.length() == 16 || KEY.length() == 24 || KEY.length() == 32)) {
            throw new IllegalArgumentException("암호화 키는 반드시 16, 24, 32자리 중 하나여야 합니다. 현재 길이: " + KEY.length());
        }
    }

    private static final DataEncryption dataEncryption = new DataEncryption(KEY);
    private static final DataDecryption dataDecryption = new DataDecryption(KEY);

    // SHA-256 해시 (단방향)
    public static String hashSHA256(String text) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(text.getBytes("UTF-8"));
        StringBuilder sb = new StringBuilder();
        for (byte b : hash) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }

    // 양방향 암호화
    public static String encrypt(String plainText) throws Exception {
        return dataEncryption.encrypt(plainText);
    }

    // 양방향 복호화
    public static String decrypt(String encryptedText) throws Exception {
        return dataDecryption.decrypt(encryptedText);
    }
    public static boolean isValidBase64(String str) {
        try {
            if (str == null || str.isBlank()) return false;
            Base64.getDecoder().decode(str.trim());
            return true;
        } catch (IllegalArgumentException e) {
            return false;
        }
    }

}
