class Movie < ApplicationRecord
  validates :name, uniqueness: true
  validates :image_url, length: { maximum: 150 }

  with_options presence: true do
    validates :year
    validates :description
    validates :image_url
    validates :name
  end

  scope :search, -> (movie_search_params) do
    return if movie_search_params.blank?
    # search_paramsが空の場合以降の処理を行わない

    # パラメータを指定して検索を実行
    filter_is_showing(movie_search_params).name_like(movie_search_params).
  end
  # nameとdescription存在する場合、nameをlike検索する
  scope :name_like, -> (movie_search_params) { where('name LIKE?', "%#{movie_search_params[:keyword]}%").or(where('description LIKE?', "%#{movie_search_params[:keyword]}%")) if movie_search_params[:keyword].present? }
  # is_showingが存在する場合、true or falseを返す
  scope :filter_is_showing, -> (movie_search_params) { where(is_showing: movie_search_params[:is_showing]) if movie_search_params[:is_showing].present? }
end

# Scopeとは、ActiveRecordのQueryメソッドに名前を付ける機能
# 戻り値はActiveRecord::Relationオブジェクトなので、ScopeからScopeを呼び出すことも可能

# 検索したときにはしるクエリ
# SELECT `movies`.* FROM `movies` WHERE (name LIKE'%ユーザー%' OR description LIKE'%ユーザー%') AND `movies`.`is_showing` = FALSE

# LIKEで指定したカラムにインデックスが設定されている場合、%(ワイルドカード)の前までしか走査されない
# よって先に公開フラグ判定のクエリを実行した方が良い