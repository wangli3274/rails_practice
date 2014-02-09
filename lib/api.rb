require "sinatra/base"
#require "sinatra/session_auth"
# API模块基于Sinatra/Base类，通过register方式将各种不同的业务controller文件组织起来
module Api

    # module RequireUser
    #     def self.registered(app)
    #         app.before do
    #             # Rails.logger.info "Sinatra path - #{request.path_info} : #{params.inspect}"
    #             unless request.path_info.match(not_require_routes_reg)
    #                 require_user
    #             end
    #         end

    #         app.helpers Helpers
    #     end

    #     module Helpers
    #     end
    # end

    module V1
        class Server < Sinatra::Base
            register UserController
        end
    end
end