require "rack/request"
require "rack/response"

class MyApp
  def call(env)
    req = Rack::Request.new(env)
    res = Rack::Response.new

    res['Content-Type'] = 'text/html'

    tld = '.dev'
    if req.host =~ /^.*?(\d+\.\d+\.\d+\.\d+\.xip\.io)$/
      tld = ".#{$1}"
    end

    res.write %q{
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <style type="text/css">
            body { line-height: 1.5em; }
            a {  display: block; text-decoration: none; font-weight: bold; font-family: Helvetica; }
          </style>
        </head>
        <body>
    }

    Dir.glob(File.join(ENV['HOME'], '.pow', '*')).map{|p| File.basename(p)}.sort.reject{|k| k == 'default'}.each do |name|
      url = [req.scheme, '://', name, tld].join
      res.write "<a href='#{url}'>#{name.upcase}</a>"
    end

    res.write %q{
        </body>
      </html>
    }

    res.finish
  end
end

run MyApp.new
