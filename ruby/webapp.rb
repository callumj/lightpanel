require 'rubygems'
require 'sinatra'
require 'json'

require File.dirname(__FILE__) + '/Panel.rb'
require File.dirname(__FILE__) + '/image_tools.rb'

$LIGHTPANEL_INSTANCE = Panel.new
puts "Loading image cache"
$IMAGECACHE_INSTANCE = process_image_directory(:directory_path => "/Users/callumj/Development/lightpanel/Letters", :invert => true, :percentage => true)

get "/c/:command" do
  $LIGHTPANEL_INSTANCE.send(params[:command])
  
  ''
end

get "/s/:cachename" do  
  $LIGHTPANEL_INSTANCE.renderArray(:matrix => $IMAGECACHE_INSTANCE[params[:cachename]]) if $IMAGECACHE_INSTANCE[params[:cachename]] != nil
  ''
end

get %r{/s/([\w\.]+)/(.+)} do
  method_name = params[:captures][0]
  method_args = build_symbols(params)
    
  if ($IMAGECACHE_INSTANCE[params[:cachename]] != nil && method_args == nil)
    $LIGHTPANEL_INSTANCE.renderArray(:matrix => $IMAGECACHE_INSTANCE[params[:cachename]])
  else
    method_args[:matrix] = $IMAGECACHE_INSTANCE[method_name]
    $LIGHTPANEL_INSTANCE.renderArray(method_args)
  end
  
  ''
end

get %r{/c/([\w]+)/(.+)} do
  method_name = params[:captures][0]
  method_args = build_symbols(params)
    
  if (method_args == nil)
    $LIGHTPANEL_INSTANCE.send(method_name)
  else
    $LIGHTPANEL_INSTANCE.send(method_name, method_args)
  end
  
  ''
end

get "/i/image_cache" do
  hash_return = {:data => $IMAGECACHE_INSTANCE.keys.sort}
  hash_return.to_json
end

def build_symbols(params)
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
  
  method_args
end