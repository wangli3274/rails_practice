module Api::V1::UserController

    def self.registered(app)
      
          app.helpers Helpers
        
          app.post '/users/create' do
            print params[:user]
            @user = User.new(params[:user])
            if @user.save
              print "Save OK\n"
            else
              print "Save ERROR\n"
            end
            render_json(:id => @user[:id])
          end

        
    end  # END def self.registered(app)
    
    module Helpers

        def render_json(json={})
            JSON.generate({:status => 0, :msg => "success."}.merge(json))
        end
    end
end