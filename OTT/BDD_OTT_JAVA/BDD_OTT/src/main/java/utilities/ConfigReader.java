package utilities;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.Socket;
import java.net.URL;
import java.time.Duration;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import io.appium.java_client.android.AndroidDriver;
import io.appium.java_client.android.options.UiAutomator2Options;

import java.net.HttpURLConnection;

import org.json.JSONTokener;
import org.openqa.selenium.remote.DesiredCapabilities;

import org.json.JSONObject;

public class ConfigReader {
	/****
	 * 
	 * before start connect the device need to read the config and collect the
	 * logcat once after start appium andriod device connect
	 * 
	 * @return
	 * @throws IOException
	 * 
	 */
	private Process appiumProcess;
	private JSONObject config;
	public AndroidDriver  driver;

	public JSONObject readjsonfile() throws IOException {
		File fos = new File(System.getProperty("user.dir") + "/src/test/resources/Test_data/config.json");
		System.out.println(fos);
		System.out.println("the file which josn is present is exit" + fos.exists());
		if (fos.isFile() && fos.exists() && fos.getName().endsWith(".json")) {
			System.out.println("the json file found");
			try (FileReader fir = new FileReader(fos)) {

//			CONVERT TO TOKNER
				JSONTokener jsonobject = new JSONTokener(fir);
				 config = new JSONObject(jsonobject);
				return config;

			} catch (IOException e) {
				// TODO Auto-generated catch block
				throw new IOException("config file not found" + e);
			}

		}
		return null;

	}

	public void run_appium_background(int port) throws IOException {
		String cmd = "cmd.exe /c start /B appium -p " + port;
		appiumProcess = Runtime.getRuntime().exec(cmd);
		System.out.println("🚀 Appium server starting on port " + port);
		int attemps = 0;
		while (attemps < 20) {
			try (Socket so = new Socket("127.0.0.1", port)) {
				System.out.println("Appium is running on port " + port);
				return;
			}

			catch (IOException e) {
				// TODO: handle exception
				System.out.println("the appium restrting to connected " + port);
				try {
					Thread.sleep(3000);
				} catch (InterruptedException ignored) {
					Thread.currentThread().interrupt();
				}

			}
			attemps++;
		}
		throw new IOException("Appium failed to lanuch at the port " + port);

	}
//	
	public List<String> verfiydevicesconnected() throws IOException {
		appiumProcess=Runtime.getRuntime().exec("adb devices");
//		/which retsun the bite inputstream convert to character
		InputStreamReader  reader=new InputStreamReader(appiumProcess.getInputStream());
//		file it is normal reading like cmd  line by line
		BufferedReader  readerindevices=new BufferedReader(reader);
		   String line;
		  List<String> device_avilable_name=new LinkedList<String>(); 
		   
		 while ((line = readerindevices.readLine())!=null) {
			if(line.endsWith("device")) {
				device_avilable_name.add(line.split(" ")[0]);
			}
		}
		 return device_avilable_name;
		
	}
	
	
	public void killTheProcess() {
	    try {
	        // Kill adb processes
	        Runtime.getRuntime().exec("taskkill /F /IM adb.exe");
	        
	        // Kill node (Appium) processes
	        Runtime.getRuntime().exec("taskkill /F /IM node.exe");

	        System.out.println("Killed adb and Appium processes successfully.");
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}
//	int port=Integer.parseInt(the_port_numbereachdevice);
	
	public Map<String, String> get_device_uiud(String device) throws IOException {
		Map<String, String> deviceConfig = new HashMap<>();
		JSONObject desiredCaps = config.getJSONObject("devices")
	            .getJSONObject(device);
		int port=desiredCaps.getInt("port");
		String deviceudid=desiredCaps.getJSONObject("desired_caps").getString("udid");
		String alias=desiredCaps.getJSONObject("desired_caps").getString("alias");
		deviceConfig.put("udid", deviceudid);
	    deviceConfig.put("port", String.valueOf(port));
	    deviceConfig.put("alias", alias);
	    return deviceConfig;
		
		
	}
	
	
	public void startappium(String  devicename)  throws IOException{
		if(config==null) {
			System.out.println("json is not loaded");
			throw new IOException("json is not loaded properly");
		}
//		any process running before the test case need to kill
		
		Map<String, String> desriedcap_ports=get_device_uiud(devicename);
		
		int port=Integer.parseInt(desriedcap_ports.get("port"));
		
		
		run_appium_background(port);  // # appium stated at cmd
		
//		connect the appium
		JSONObject  commonconfig=config.getJSONObject("common_desired_caps");
		
		
		
		/***
		 * below the 7 x version we use desirecapblity but selnium upto version 4.11 after latest version appium 8+ and selenium 4+ lastes
		 * uiautomater2
		 */
		

				UiAutomator2Options options = new UiAutomator2Options()
		        .setAppActivity(commonconfig.getString("appActivity"))
		        .setAppPackage(commonconfig.getString("appPackage"))
		        .setAutomationName(commonconfig.getString("automationName"))
		        .setPlatformName(commonconfig.getString("platformName"))
		        .setDeviceName(desriedcap_ports.get("udid"))
		        .setNewCommandTimeout(Duration.ofSeconds(commonconfig.getInt("newCommandTimeout")));
		
		
		
	     URL appiumServerURL = new URL("http://127.0.0.1:" + desriedcap_ports.get("port") + "/wd/hub");
	     driver=new AndroidDriver(appiumServerURL, options);
	     System.out.println("Successfully launched on device: "  +devicename+ " (Port: " + desriedcap_ports.get("port") + ")");
		
		}
	     
	
	
	
	
	

	public static void main(String[] args) {
		ConfigReader a1 = new ConfigReader();
		try {
			JSONObject config = a1.readjsonfile();

			String capnames = config.getJSONObject("common_desired_caps").getString("appActivity");
			System.out.println("the caps name is " + capnames);
			
//			a1.killTheProcess();
		String [] exhadvicenaem= {"device_1"};
			for(String  device: exhadvicenaem) {
			a1.startappium(device);
			}
			

		} catch (IOException e) {
			// TODO Auto-generated catch block
			System.out.println(e.getMessage());
		}
	}
	

}
