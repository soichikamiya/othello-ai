class OthellosController < ApplicationController
  protect_from_forgery except: :reception # receptionアクションを除外
  
  # 盤面
  @board = []
  # プレイヤー駒（black or whiteが入る）
  @player_coma = ""
  # エネミー駒（black or whiteが入る）
  @enemy_coma = ""
  
  def reception
    # 初期化　これがないとエラーになるので注意
    @board = []
    # オセロの盤面情報を取得
    if !params[:board].blank?
      index = 0
      8.times do |i|
        @board[i] = params[:board][index, 8]
        index += 8
      end
    end
    
    # プレイヤーとエネミーの駒をセット
    @player_coma = params[:player]
    if @player_coma == "black"
      @enemy_coma = "white"
    else
      @enemy_coma = "black"
    end
    
    # 置ける場所と評価値の組み合わせを取得
    # key=>レスポンス番号,
    # value=>{
    #   x=>横軸インデックス,
    #   y=>縦軸インデックス,
    #   evaluation_value=>評価値（どのレスポンス番号を戻すか決める際の判断値・初期値は0}
    response_candidate = {}
    if !params[:moves].blank?
      params[:moves].each{|key, value|
        response_candidate[key] = {"x"=>value["x"].to_i, "y"=>value["y"].to_i, "evaluation_value"=>0}
      }
    end
    
    # 盤面を表示
    puts "現在の盤面"
    print_board(@board)
    
    # 次の手を打った後のプレイヤー駒数を評価値として取得
    response_candidate.each{|key, value|
      value["evaluation_value"] = get_player_coma_sum(value["x"], value["y"])
    }
    
    # 次の駒は一番多く取得できる位置に置く
    res = response_candidate.max { |a, b| a[1]["evaluation_value"] <=> b[1]["evaluation_value"] }
    if !res.blank?
      next_hand = res[0]
    else
      next_hand = 0
    end
    
    render plain: next_hand.to_s
  end
  
  private
  # 引数のインデックス場所に駒設置後のプレイヤー駒数を取得
  def get_player_coma_sum(x, y)
    puts "盤面#{x},#{y}に置いた場合"
    # 予測ボード複製
    prediction_board = @board.deep_dup
    # 予測ボードにプレイヤーの駒を設置
    prediction_board[y][x] = @player_coma
    # 設定箇所を元に予測ボードを裏返す
    turn_over(prediction_board, x, y)
    # 予測ボードを出力
    print_board(prediction_board)
    
    # 予測ボード上のプレイヤー駒数を算出
    return_num = 0
    prediction_board.each do |one_row|
      return_num += one_row.count(@player_coma)
    end
    return return_num
  end
  
  # 置いた駒を基準に裏返す
  def turn_over(board, put_col, put_row)
    # 時計回りに方向を定義
    directions = [[-1,0], [-1,1], [0,1], [1,1], [1,0], [1,-1], [0,-1], [-1,-1]]
    
    # 置いた駒の周りに相手の石があるか確認
    directions.each do |direction|
      reverse_pos = []
      reverse_row = put_row + direction[0]
      reverse_col = put_col + direction[1]
      # 盤面外の場合は次の方向を確認
      if reverse_row > 7 || reverse_col > 7
        next
      end
      # 相手の石でない場合は次の方向を確認
      if board[reverse_row][reverse_col] != @enemy_coma
        next
      end
    
      reverse_flag = false
      reverse_pos << [reverse_row, reverse_col]
    
      # 見つけた方向を捜査していく
      while true
        reverse_row += direction[0]
        reverse_col += direction[1]
        # 盤面外の場合は捜査終了
        if reverse_row > 7 || reverse_col > 7
          break
        end
        if board[reverse_row][reverse_col] == @enemy_coma
          reverse_pos << [reverse_row, reverse_col]
        elsif board[reverse_row][reverse_col] == @player_coma
          reverse_flag = true
          break
        else
          break
        end
      end
    
      # 間にあった相手の石を裏返す
      if reverse_flag
        reverse_pos.each do |pos|
          board[pos[0]][pos[1]] = @player_coma
        end
      end
    end
  end
  
  # 引数のボードを出力する
  def print_board(board)
    # ● = 黒
    # ○ = 白
    # 空白=駒なし
    # × = エラー
    for one_row in board
      print "|"
      for coma in one_row
        if coma == "black"
          print "●"
        elsif coma == "white"
          print "○"
        elsif coma == "empty"
          print " "
        else
          print "×"
        end
        print "|"
      end
      puts ""
    end
    puts ""
  end
end
