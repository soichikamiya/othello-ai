class OthellosController < ApplicationController
  protect_from_forgery except: :reception # receptionアクションを除外
  
  def reception
    if !params[:board].blank?
      # オセロの盤面情報を取得
      board = []
      index = 0
      8.times do |i|
        board[i] = params[:board][index, index+7]
        index += 8
      end
    end
    
    # 盤面を表示
    # ● = 黒
    # ○ = 白
    # 空白=駒なし
    # × = エラー
    for one_column in board
      for coma in one_column
        if one_column == "black"
          p ""
      end
      puts ""
    end
    
    @response = 2
    render plain: @response.to_s
  end
end
