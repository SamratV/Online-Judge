package admin;

import org.apache.commons.lang3.time.DateUtils;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Test{
	private boolean live, over, upcoming;
	private Date start, end, current;

	public Test(){
	}

	public Test(String date, String time, int duration) {
		try{
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			start   = sdf.parse(date + " " + time);
			end     = DateUtils.addMinutes(start, duration);
			current = new Date();

			live = current.compareTo(start) > 0 && current.compareTo(end) < 0;
			over = current.compareTo(end) > 0;
			upcoming = current.compareTo(start) < 0;
		}catch(Exception e){
			e.printStackTrace();
		}
	}

	public boolean isLive() {
		return live;
	}

	public boolean isOver() {
		return over;
	}

	public boolean isUpcoming() {
		return upcoming;
	}

	public long getRemaining() {
		return end.getTime() - current.getTime();
	}

	public long getStart(){
		return start.getTime();
	}

	public long getEnd(){
		return end.getTime();
	}

	public long getCurrent(){
		return current.getTime();
	}
}