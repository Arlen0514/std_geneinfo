package com.genesis.schedule;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Timer;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import com.genesis.util.StringTool;
import org.apache.log4j.Logger;
import com.genesis.util.DateTimeTool;

/**
 * Application Lifecycle Listener implementation class AllLisenter
 *
 */
public class AllLisenter implements ServletContextListener {
	private static Logger logger = Logger.getLogger("com/genesis/schedule/AllLisenter.class");

	private Timer timer;
	private int interval;
	private String schedule_patten;
	private String today = DateTimeTool.dateString() + " ";
	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");

	/**
	 * Default constructor.
	 */
	public AllLisenter() {
		// TODO Auto-generated constructor stub
		loggin("archives night run");
		timer = new Timer();
		interval = 300000;
	}

	/**
	 * @see ServletContextListener#contextInitialized(ServletContextEvent)
	 */
	public void contextInitialized(ServletContextEvent sce) {
		// TODO Auto-generated method stub
		try {
			loggin("Lisenter start!");
			ServletContext application = sce.getServletContext();
			interval = StringTool.validInt(application.getInitParameter("execution_interval"), interval);
			loggin("interval=" + interval);
			schedule_patten = application.getInitParameter("schedule_patten");
			if (schedule_patten.isEmpty()) {
				schedule_patten = "dela_repeat";
			}
			loggin("schedule_patten=" + schedule_patten);
			String path = application.getInitParameter("attach_path");
			loggin("path=" + path);
			Execution exec = new Execution(path);
			if (schedule_patten.equals("time_single")) {
				timer.schedule(exec, new Date(today + application.getInitParameter("schedule_patten_time")));
			} else if (schedule_patten.equals("time_repeat")) {
				Date use = new Date(today + application.getInitParameter("schedule_patten_time"));
				Date new_ = new Date();

				if (new_.after(use)) {
					Calendar yesDate = Calendar.getInstance();
					yesDate.setTime(use);
					yesDate.add(Calendar.DAY_OF_MONTH, +1);
					use = yesDate.getTime();
				}
				timer.schedule(exec, use, interval);
			} else if (schedule_patten.equals("delay_single")) {
				timer.schedule(exec, (long) StringTool.validInt(application.getInitParameter("schedule_patten_delay"), 2));
			} else {
				timer.schedule(exec, (long) StringTool.validInt(application.getInitParameter("schedule_patten_delay"), 2),
						interval);
			}
		} catch (Exception e) {
			// TODO: handle exception
			loggin(e.getMessage());
		}
	}

	/**
	 * @see ServletContextListener#contextDestroyed(ServletContextEvent)
	 */
	public void contextDestroyed(ServletContextEvent sce) {
		// TODO Auto-generated method stub
		loggin("AllLisenter contextDestroyed");
		timer.cancel();
	}

	private void loggin(String log) {
		System.out.println(log);
		logger.info(log);
	}

}
