class StatsController < ApplicationController
  def single
    @stats = User.all.order(single_win: :desc).page(params[:page])
    # @stats = Kaminari.paginate_array(User.find_by_sql("SELECT id, name, single_win, single_lose, RANK() OVER(ORDER BY (single_win / single_lose)) AS rank_num FROM users"), limit: 5, offset: 0, total_count: 100)
  end

  def double
    @stats = User.all.order(double_win: :desc).page(params[:page])
  end

  def logs
    @logs = Single.all.merge(Double.all).order(created_at: :desc).page(params[:page])
  end
end
