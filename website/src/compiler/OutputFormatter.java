package compiler;

import java.text.DecimalFormat;

public class OutputFormatter {

	private static String getStart(){
		return "<h4 class='text-center'>OUTPUT</h4><pre>";
	}

	private static String getEnd(){
		return "</pre>";
	}

	private static String getWrapperStart(){
		return "<div class='output-wrapper'>";
	}

	private static String getWrapperEnd(){
		return "</div>";
	}

	static String getTick(){
		return "<i style='color: #28a745;' class='fas fa-check'></i>";
	}

	static String getCross(){
		return "<i style='color: red;' class='fas fa-times'></i>";
	}

	static String getHeader(String text){
		return "<h6>" + text + "</h6>";
	}

	static String getSeparator(){
		return "<hr>";
	}

	static String getLineBreak(){
		return "<br>";
	}

	static String getNoOutputText(){
		return "<span class='text-muted'>~~ No output ~~</span>";
	}

	static String getOutputTooLargeText(){
		return "<span class='text-muted'>~~ Your output is too large ~~</span>";
	}

	private static String getLogs(String[] x){
		return "Message: " + x[0] + getLineBreak()
			 + "Memory : " + round(Double.parseDouble(x[1]) / (1024 * 1024)) + " MB" + getLineBreak()
			 + "Time   : " + round(Double.parseDouble(x[2]) / 1000) + " s";
	}

	static String wrapMessage(String message){
		return getWrapperStart() + message + getWrapperEnd();
	}

	static String wrapOutput(String output){
		return getStart() + output + getEnd();
	}

	public static String round(double d){
		DecimalFormat df = new DecimalFormat("#.000");
		String x = df.format(d);
		return x.startsWith(".") ? "0" + x : x;
	}

	static String getFormattedOutput(String result){
		return wrapOutput(wrapMessage(result));
	}

	static String getFormattedCTE(String exit_log, String error, String jaildir){
		String[] x    = exit_log.split(":");
		String result = getLineBreak() + getHeader("LOGS") + wrapMessage(getLogs(x));

		if(error != null && error.trim().length() > 0){
			error   = error.replace(jaildir, "");
			result += getLineBreak() + getHeader("STDERR") + wrapMessage(error);
		}

		return wrapOutput(result);
	}

	static String getFormattedInit(String[] x, String jaildir, String warning){
		String result = getLineBreak() + getHeader("LOGS") + wrapMessage(getLogs(x));

		if(warning != null && warning.trim().length() > 0){
			warning = warning.replace(jaildir, "");
			result += getLineBreak() + getHeader("WARNINGS") + wrapMessage(warning);
		}

		return result;
	}

	static String getFailedTC(int[] fail){
		StringBuilder sb = new StringBuilder();
		for(int i = 1; i < fail.length; ++i){
			if(fail[i] == 1)    sb.append(i).append(", ");
		}
		return  sb.substring(0, sb.lastIndexOf(",")) + ".";
	}
}