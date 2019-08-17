package auth;

import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import java.nio.charset.Charset;
import java.util.Properties;
import java.util.Random;

public class Mailer {

	private static JavaMailSender getJavaMailSender() {
		JavaMailSenderImpl mailSender = new JavaMailSenderImpl();
		mailSender.setHost("smtp.gmail.com");
		mailSender.setPort(587);

		// Register for mail service using gmail account and then use it below.
		mailSender.setUsername("username@gmail.com");
		mailSender.setPassword("password");

		Properties props = mailSender.getJavaMailProperties();
		props.put("mail.transport.protocol", "smtp");
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.debug", "true");

		return mailSender;
	}

	static void send(String to, String subject, String text) throws MessagingException {
		JavaMailSender emailSender = Mailer.getJavaMailSender();
		MimeMessage message        = emailSender.createMimeMessage();
		MimeMessageHelper helper   = new MimeMessageHelper(message, false, "utf-8");

		message.setContent(text, "text/html");

		helper.setTo(to);
		helper.setSubject(subject);
		emailSender.send(message);
	}

	public static String getRandomText(){
		int n = 32;
		byte[] array = new byte[256];
		new Random().nextBytes(array);

		String rs	    = new String(array, Charset.forName("UTF-8"));
		StringBuilder r = new StringBuilder();

		for(int k = 0; k < rs.length(); ++k){
			char ch = rs.charAt(k);

			if(((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || (ch >= '0' && ch <= '9')) && (n > 0)){
				r.append(ch);
				--n;
			}
		}

		return r.toString();
	}
}