require 'sinatra'
require 'pony'
require 'json'

set :protection, :origin_whitelist => ["http://localhost:4567", "http://www.per-angusta.com", "https://www.per-angusta.com", "http://per-angusta.com", "https://per-angusta.com"]

Pony.options = {
  :via => :smtp,
  :via_options => {
    :address => 'smtp.sendgrid.net',
    :port => '587',
    :domain => 'heroku.com',
    :user_name => ENV['SENDGRID_USERNAME'],
    :password => ENV['SENDGRID_PASSWORD'],
    :authentication => :plain,
    :enable_starttls_auto => true
  }
}

get '/' do
end

post '/' do
  email = ""
  
  body  = params[:message]
  body += "\n\nTel: #{params[:phone]}"

  
  content_type :json
  begin
    Pony.mail :to => ENV['email_recipients'],
              :from => "\"#{params[:name]}\" <#{params[:email]}>",
              :subject => "[Per Angusta] New contact from website",
              :body => body
    
    { "success" => 1 }.to_json
  rescue
    { "success" => 0, "errors" => {"sending" => "An error occurred while sending your message! Please try again later."} }.to_json
  end
end
