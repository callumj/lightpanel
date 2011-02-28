package com.lightpanel.base;

import com.phidgets.*;
import com.phidgets.event.*;

public class Panel {
	public final static int MAX_LED = 63;
	
	int deviceID;
	LEDPhidget physicalDevice;
	
	public Panel(int phidgetID)
	{
		try {
			deviceID = phidgetID;
			physicalDevice = new LEDPhidget();
			physicalDevice.open(deviceID);
			physicalDevice.waitForAttachment();
			System.out.println("Device " + deviceID + " is up.");
		}
		catch (Exception phErr)
		{
			System.out.println(phErr);
		}
	}
	
	public void setLED(int ledNum, int intensity)
	{
		if (ledNum > MAX_LED)
			return;
		
		try
		{
			physicalDevice.setDiscreteLED(ledNum, intensity);
		}	
		catch (Exception phErr)
		{
			System.out.println(phErr);
		}
	}
	
}