class VentureLab
  require 'nokogiri'
  require 'mechanize'
  
  @@base_uri = 'http://venture-lab.org'
  @@limit_user = 37041
  @@myself = 13964
  @@team = [29228,29667,26585]
  @@cookie_path = "#{Rails.root}/tmp/cookies/venture_lab_login.yaml"  
  
  attr_accessor :page, :username, :password
  
  def initialize(username,password)
    @agent = Mechanize.new
    @page = @agent.get 'http://venture-lab.org/'
    @username,@password = username,password
  end
  
  def login(username = @username, password = @password, force = false)
    begin
      
      form = @page.forms.select do |f|
        f.action == '/users/sign_in'
      end
      
      form = form.first
      
      form['user[email]'] = username
      form['user[password]'] = password
      form['user[remember_me]'] = '1'
      
      @agent.submit form
      
      File.delete @@cookie_path if(File.exists?(@@cookie_path) && force == true)
      @agent.cookie_jar.save_as @@cookie_path 
      
      puts "Login process finish"
    rescue Exception => e
      puts "Exception in login #{e}"
      report = e.backtrace.join("\r\n")
      puts "#{report}"
    end      
  end
  
  def teams
    
  end
  
  def view_profile ids=[@@myself]
    ids.each do |id|
      begin
        get "/view_profile/#{id}"
        
        view
        
      rescue Exception => e
        puts "Exception in view_profile #{e}"
        report = e.backtrace.join("\r\n")
        puts "#{report}"
      end
    end
  end
  
  def send_message ids=@@team, delay=20
    ids.each do |id|
      begin
        get "/notifications/new/#{id}"
        form = @page.forms.first
        
        form['notification[message]'] = %Q"
          I am a fellow classmate on the Venture Lab and would to ask you for a few minutes to take our preliminary survey.
  
          Your Attitud is Important for us: http://www.surveymonkey.com/s/NVJJBFB
        "
        
        @agent.submit form
        
        puts "Send message to user #{id} success."
        sleep(delay)
      rescue Exception => e
        puts "Exception in send_message #{e}"
        report = e.backtrace.join("\r\n")
        puts "#{report}"
      end
    end
  end
  
  def view
    pp @page
  end
  
  private
  
  def validate_login
    form = @page.forms.select do |f|
        f.action == '/users/sign_in'
    end
    (form.count > 0)
  end
  
  def get uri
    uri = "#{@@base_uri}#{uri}"
    
    if File.exists? @@cookie_path
      cookie_jar = Mechanize::CookieJar.new
      cookie_jar.load @@cookie_path
      @agent.cookie_jar = cookie_jar
    end 
    
    @page = @agent.get uri
    
    if validate_login
      login @username,@password
      @page = @agent.get uri
    end
  end

  def self.random_users(n,factor = 1000)
    n.times.map do 
      r = factor + Random.rand(@@limit_user-factor)
      (r == @@myself)? factor + Random.rand(@@limit_user) : r 
    end
  end
  
end