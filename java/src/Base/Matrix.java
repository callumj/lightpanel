package com.lightpanel.base;

import com.phidgets.*;
import com.phidgets.event.*;

import java.util.HashMap;

public class Matrix {
	
	public final static int LED_PER_ROW = 7;
	public final static int ROW_PER_DEVICE = 9;
	
	class LED {
		public Panel device;
		public int index;
	}
	
	LED[][] ledMatrix;
	Panel[][] deviceMatrix;
	
	public Matrix(Panel[][] array) {
		deviceMatrix = array;
		
		System.out.println("Matrix will have " + array.length * ROW_PER_DEVICE + " rows and " + LED_PER_ROW * array[0].length + " cols");
		ledMatrix = new LED[array.length * ROW_PER_DEVICE][LED_PER_ROW * array[0].length];
		for (int screenRow = 0; screenRow < array.length; screenRow++) {
			for (int screenCol = 0; screenCol < array[screenRow].length; screenCol++) {
				Panel targetDevice = array[screenRow][screenCol];
				
				for (int deviceIndex = 0; deviceIndex < targetDevice.MAX_LED; deviceIndex++)
				{
					int row = deviceIndex / LED_PER_ROW;
					int col = deviceIndex - (row * LED_PER_ROW);
					
					int actualCol = col + (LED_PER_ROW * screenCol);
					int actualRow = row + (ROW_PER_DEVICE * screenRow);
					LED ledMap = new LED();
					ledMap.device = targetDevice;
					ledMap.index = deviceIndex;
					ledMatrix[actualRow][actualCol] = ledMap;
				}
			}
		}
	}
	
	
	public void setLED(int row, int col, int brightness) {
		if (ledMatrix.length > row && ledMatrix[row].length > col) {
			LED mapping = ledMatrix[row][col];
			mapping.device.setLED(mapping.index, brightness);
		}
	}
	
	public void setLEDInPercentage(double row, double col, int brightness) {
		double rowConversion = row / 100.0;
		double colConversion = col / 100.0;
		
		int actualRow = (int)rowConversion * ledMatrix.length;
		int actualCol = (int)colConversion * ledMatrix[0].length;
		
		setLED(actualRow, actualCol, brightness);
	}
	
	public void setLED(int index, int brightness) {
		int targetRow = index / (LED_PER_ROW * deviceMatrix[0].length);
		int targetCol = index - ((LED_PER_ROW * deviceMatrix[0].length) * targetRow);
		
		setLED(targetRow, targetCol, brightness);
	}
	
	public void setLEDInPercentage(double index, int brightness) {
 		double indexConversion = index / 100.0;
		int actualIndex = (int)(indexConversion * (ledMatrix.length * ledMatrix[0].length));		
		setLED(actualIndex, brightness);
	}
}