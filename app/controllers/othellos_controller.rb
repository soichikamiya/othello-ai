class OthellosController < ApplicationController
  protect_from_forgery except: :reception # receptionアクションを除外
  
  def reception
    puts "パラメータは"
    puts params
    @response = 2
    render plain: @response.to_s
  end
end
