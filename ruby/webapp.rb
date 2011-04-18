require 'rubygems'
require 'sinatra'

require File.dirname(__FILE__) + '/Panel.rb'

$LIGHTPANEL_INSTANCE = Panel.new

get "/c/:command" do
  $LIGHTPANEL_INSTANCE.send(params[:command])
  puts ''
end

get %r{/c/([\w]+)/(.+)} do
  method_name = params[:captures][0]
  method_args = nil
    
  if (params[:captures][1] != nil && !params[:captures][1].to_s.empty?)
    method_args = {}
    
    is_param = true
    param_name = nil
    params[:captures][1].split(/\/+\s?/).each do |str|
      if (is_param)
        param_name = str
      else
        method_args[param_name.to_sym] = str
      end
      is_param = !is_param
    end
  end
  
  puts method_args
  
  if (method_args == nil)
    $LIGHTPANEL_INSTANCE.send(method_name)
  else
    $LIGHTPANEL_INSTANCE.send(method_name, method_args)
  end
  
  ''
end