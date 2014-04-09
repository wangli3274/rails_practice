module Api::V1::UserController

    def self.registered(app)
      
        app.helpers Helpers
        
        app.post '/users/create' do
         # print params[:user]
          Rails.logger.info(params[:user])
          @user = User.new(params[:user])
          if @user.save
            Rails.logger.info("logger Save OK")
           # print "Save OK\n"
          else
            Rails.logger.error("logger Save ERROR")
           # print "Save ERROR\n"
          end
          render_json(:id => @user[:id])
        end

        app.post('/user/posters') do
          
          # Rails.logger.info("======================/user/posters================================")
          Rails.logger.info(params[:id])
          per = (params[:limit] || 5).to_i

          if !params[:page]
        
            @total_posters = Poster.where({user_id:params[:id].to_i})
            @posters = @total_posters[0...per]
            len = @total_posters.length

            {:status => 0, :msg => "success.",:posters => @posters.to_a, :len => len}.to_json
          else
            
            @posters = Poster.where({user_id:params[:id].to_i}).page(params[:page].to_i).per(per)


            # Rails.logger.info(@posters.to_a)
            # Rails.logger.info("======================================================")
            {:status => 0, :msg => "success.",:posters => @posters.to_a}.to_json
          end

          # page = (params[:page] || 1).to_i
          # per = (params[:limit] || 5).to_i
          # @posters = Poster.where({user_id:params[:id].to_i})#.page(page).per(per)
          
          
         
          # {:status => 0, :msg => "success.",:posters => @posters.to_a}.to_json
        end
        
        
        app.get('/users/sidekiq_test') do
          User.delay.sidekiq_test()
        end
        
        app.get('/users/sidekiq/perform') do
          User.perform_async('cc', 1)
        end
        
        app.get('/users/eventmachine_test') do
          bef = ""
          aft = ""
          require 'eventmachine'
          EventMachine.run do
            bef = Time.now.to_i
            EM.add_timer(10){
                puts 'eventmachine_test'
                aft = Time.now.to_i
                EM.stop_event_loop
            }
          end
          render_json(:data => {:bef => bef, :aft => aft})
        end       
        
        app.get('/users/em_with_rainbows_test') do
          bef = ""
          aft = ""
          bef = Time.now.to_i
          # require 'sinatra/async'
          # require 'eventmachine'
          # EventMachine.run do
            EM.add_timer(1){
              aft = Time.now.to_i
              puts 'em_with_rainbows_test'
              # debugger
              # request  = Net::HTTP::Get.new(“https://www.google.com.hk”)
              http = EM::HttpRequest.new("http://www.baidu.com/").get

              http.errback {
                Rails.logger.info("http.errback")
                # debugger
                # render
                request.env['async.callback'].call(response)
              }
              http.callback {
                Rails.logger.info("http.callback")
                # debugger
                render_json(:data => {:bef => bef, :aft => aft})
                # request.env['async.callback'].call('200', {}, "Hello")
                request.env['async.callback'].call(response)
              }
              # throw :async
              # EM.stop
               # throw :async
            }
            throw :async
          # end
          # render_json(:data => {:bef => bef, :aft => aft,:a => "aaassß"})
        end  

     
        
        
        
        
    end  # END def self.registered(app)
    
    module Helpers

        def render_json(json={})
            JSON.generate({:status => 0, :msg => "success."}.merge(json))
        end
    end
end