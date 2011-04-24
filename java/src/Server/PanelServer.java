package com.lightpanel.server;

import com.lightpanel.base.Panel;
import com.lightpanel.base.Matrix;

import java.net.InetSocketAddress;
import java.util.concurrent.Executors;

import org.jboss.netty.bootstrap.ServerBootstrap;
import org.jboss.netty.channel.ChannelPipeline;
import org.jboss.netty.channel.ChannelPipelineFactory;
import org.jboss.netty.channel.Channels;
import org.jboss.netty.channel.socket.nio.NioServerSocketChannelFactory;

public class PanelServer
{
	public static void main(String[] args) throws Exception
	{
		final Panel device1 = new Panel(40885);
		final Panel device2 = new Panel(40862);
		final Panel device3 = new Panel(41297);
		
		Panel[][] panelArray = {{device1, device2, device3}};
		
		final Matrix screen = new Matrix(panelArray);
		
		ServerBootstrap bootstrap = new ServerBootstrap(new NioServerSocketChannelFactory(Executors.newCachedThreadPool(),Executors.newCachedThreadPool()));
		
		bootstrap.setPipelineFactory(new ChannelPipelineFactory()
			{
				public ChannelPipeline getPipeline() throws Exception
				{
					return Channels.pipeline(new PanelServerHandler(screen));
				}
			});
			
			bootstrap.bind(new InetSocketAddress(8080));
	}
	
}