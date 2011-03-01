package com.lightpanel.server;

import com.lightpanel.base.Matrix;

import java.util.concurrent.atomic.AtomicLong;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.nio.charset.Charset;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

import org.jboss.netty.buffer.ChannelBuffer;
import org.jboss.netty.channel.ChannelHandlerContext;
import org.jboss.netty.channel.ExceptionEvent;
import org.jboss.netty.channel.MessageEvent;
import org.jboss.netty.channel.SimpleChannelUpstreamHandler;

public class PanelServerHandler extends SimpleChannelUpstreamHandler
{
	private Matrix ledPanel;
	private Boolean lastFail;
	private String previousString;
	
	private static final Logger logger = Logger.getLogger(
              PanelServerHandler.class.getName());
  
	private final AtomicLong transferredBytes = new AtomicLong();

	public long getTransferredBytes() {
	    return transferredBytes.get();
	}
	
	public PanelServerHandler(Matrix device)
	{
		super();
		ledPanel = device;
		System.out.println("New connection!");
		previousString = "";
		lastFail = false;
	}

	@Override
	public void messageReceived(
	        ChannelHandlerContext ctx, MessageEvent e) {
	    // Send back the received message to the remote peer.
	    transferredBytes.addAndGet(((ChannelBuffer) e.getMessage()).readableBytes());
		String message = ((ChannelBuffer) e.getMessage()).toString(Charset.forName("UTF-8"));
		Pattern lineSplit = Pattern.compile("\n");
		String[] command = lineSplit.split(message);
		
		for (String line : command)
		{			
			if (lastFail)
				line = previousString + line;
			
			Pattern splitter = Pattern.compile("\\s+");
	        String[] result = splitter.split(line);
				
			try {
	        	if (result.length == 3)
				{
					String rowString = result[0];
					String colString = result[1];
					String brightnessString = result[2];
				
					if (rowString.charAt(rowString.length() - 1) == '%') {
						double row = Double.parseDouble(rowString.substring(0, rowString.length() - 2));
						double col = Double.parseDouble(colString.substring(0, colString.length() - 2));
						int brightness = Integer.parseInt(brightnessString);
						ledPanel.setLEDInPercentage(row, col, brightness);
					} else {
						int row = Integer.parseInt(rowString);
						int col = Integer.parseInt(colString);
						int brightness = Integer.parseInt(brightnessString);
						ledPanel.setLED(row, col, brightness);
					}
				} else if(result.length == 2) {
					String indexString = result[0];
					String brightnessString = result[1];
				
					if (indexString.charAt(indexString.length() - 1) == '%') {
						double index = Double.parseDouble(indexString.substring(0, indexString.length() - 1));
						int brightness = Integer.parseInt(brightnessString);
						ledPanel.setLEDInPercentage(index, brightness);
					} else {
						int index = Integer.parseInt(indexString);
						int brightness = Integer.parseInt(brightnessString);
						ledPanel.setLED(index, brightness);
					}
				}
				
				lastFail = false;
			} catch (Exception err) {
				lastFail = true;
				logger.log(Level.WARNING, "Error processing line, will attempt to recover.");
			}
			previousString = line;
		}
	}

	@Override
	public void exceptionCaught(
	        ChannelHandlerContext ctx, ExceptionEvent e) {
	    // Close the connection when an exception is raised.
	    logger.log(
	            Level.WARNING,
	            "Unexpected exception from downstream.",
	            e.getCause());
	    e.getChannel().close();
	}
}