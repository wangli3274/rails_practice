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
        
    end  # END def self.registered(app)
    
    module Helpers

        def render_json(json={})
            JSON.generate({:status => 0, :msg => "success."}.merge(json))
        end
    end
end