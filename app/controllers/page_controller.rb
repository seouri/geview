class PageController < ApplicationController
  def home
    @level = params[:level].blank? ? 6 : params[:level].to_i
    @level = 6 if @level > 6
    @level = 1 if @level < 1
    @chromosome = 'chr' + (params[:chromosome] || '1').upcase
    @center = params[:center]
    @center = nil if @level == 6
  end

  def about
  end

end
