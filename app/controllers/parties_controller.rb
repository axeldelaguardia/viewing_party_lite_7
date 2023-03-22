class PartiesController < ApplicationController
  def index
    @parties = Party.all
  end

  def show
    @party = Party.find(params[:id])
  end

  private

  def party_params
    params.require(:party).permit(:name, :description, :location, :date, :time)
  end
end


