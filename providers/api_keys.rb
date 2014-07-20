# Cookbook Name:: cloudstack
# Provider:: api_keys
# Author:: Pierre-Luc Dion (<pdion@cloudops.com>)
#
# Copyright:: Copyright (c) 2014 CloudOps.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Generate api keys for specified CloudStack user.


require 'uri'
require 'net/http'
require 'json'
include Cloudstack


action :create do
  load_current_resource
  
  if cloudstack_is_running?
    if @current_resource.username == "admin"
      admin_keys = retrieve_admin_keys(@current_resource.url, @current_resource.password)
      if admin_keys[:api_key].nil?
        admin_keys = generate_admin_keys(@current_resource.url, @current_resource.password)
        Chef::Log.info "admin api keys: Generate new"
      else
        Chef::Log.info "admin api keys: use existing"
      end
      #puts admin_keys
      node.normal["cloudstack"]["admin"]["api_key"] = admin_keys[:api_key]
      node.normal["cloudstack"]["admin"]["secret_key"] = admin_keys[:secret_key]
      node.save
    end
  else
    Chef::Log.error "CloudStack not running, cannot generate API keys."
  end
end

action :reset do
  # force generate new API keys
  load_current_resource
  
  if cloudstack_is_running?
    if @current_resource.username == "admin"
      admin_keys = generate_admin_keys(@current_resource.url, @current_resource.password)
      Chef::Log.info "admin api keys: Generate new"
      node.normal["cloudstack"]["admin"]["api_key"] = admin_keys[:api_key]
      node.normal["cloudstack"]["admin"]["secret_key"] = admin_keys[:secret_key]
      node.save
    end
  else
    Chef::Log.error "CloudStack not running, cannot generate API keys."
  end
end

def load_current_resource
  @current_resource = Chef::Resource::CloudstackApiKeys.new(@new_resource.name)
  @current_resource.username(@new_resource.name)
  @current_resource.password(@new_resource.password)
  @current_resource.url(@new_resource.url)
  @current_resource.admin_apikey(@new_resource.admin_apikey)
  @current_resource.admin_apikey(@new_resource.admin_secretkey)
  
  if @current_resource.username == "admin" and  node["cloudstack"]["admin"]["api_key"] == retrieve_admin_keys(@current_resource.url, @current_resource.password)[:api_key]
    @current_resource.exists = true
  end

end


def generate_admin_keys(url, password)

  login_params = { :command => "login", :username => "admin", :password => password, :response => "json" }    
  # create sessionkey and cookie of the api session initiated with username and password
  uri = URI(url)
  uri.query = URI.encode_www_form(login_params)
  res = Net::HTTP.get_response(uri)
  get_keys_params = {
      :sessionkey => JSON.parse(res.body)['loginresponse']['sessionkey'], 
      :command => "registerUserKeys", 
      :response => "json", 
      :id => "2"
  }

  # use sessionkey + cookie to generate admin API and SECRET keys.
  uri2 = URI(url)
  uri2.query = URI.encode_www_form(get_keys_params) 

  get_key = Net::HTTP::Get.new(uri2.to_s)
  get_key['Cookie'] = res.response['set-cookie'].split('; ')[0]

  keys = Net::HTTP.start(uri2.hostname, uri2.port) {|http|
    http.request(get_key)
  }

  keys = {
    :api_key => JSON.parse(keys.body)["registeruserkeysresponse"]["userkeys"]["apikey"],
    :secret_key => JSON.parse(keys.body)["registeruserkeysresponse"]["userkeys"]["secretkey"]
  }
  return keys
end

def retrieve_admin_keys(url, password)
  login_params = { :command => "login", :username => "admin", :password => password, :response => "json" }    
  # create sessionkey and cookie of the api session initiated with username and password
  uri = URI(url)
  uri.query = URI.encode_www_form(login_params)
  res = Net::HTTP.get_response(uri)
  get_keys_params = {
      :sessionkey => JSON.parse(res.body)['loginresponse']['sessionkey'], 
      :command => "listUsers", 
      :response => "json", 
      :id => "2"
  }

  # use sessionkey + cookie to generate admin API and SECRET keys.
  uri2 = URI(url)
  uri2.query = URI.encode_www_form(get_keys_params) 

  get_key = Net::HTTP::Get.new(uri2.to_s)
  get_key['Cookie'] = res.response['set-cookie'].split('; ')[0]

  users = Net::HTTP.start(uri2.hostname, uri2.port) {|http|
    http.request(get_key)
  }

  keys = {
    :api_key => JSON.parse(users.body)["listusersresponse"]["user"].first["apikey"],
    :secret_key => JSON.parse(users.body)["listusersresponse"]["user"].first["secretkey"]
  }
  return keys
end