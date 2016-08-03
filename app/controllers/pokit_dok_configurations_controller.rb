class PokitDokConfigurationsController < ApplicationController
  before_action :set_pokitdok_configuration, only: [:show, :edit, :update, :destroy]

  def show
  end

  def edit
  end

  def update
    if @pokitdok_configuration.update(pokit_dok_configuration_params)
      redirect_to @pokitdok_configuration, notice: 'Bjond registration was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @pokitdok_configuration.destroy
    redirect_to bjond_registrations_url, notice: 'Pokitdok Configuration was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pokitdok_configuration
      @pokitdok_configuration = PokitDokConfiguration.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def pokit_dok_configuration_params
      params.require(:pokit_dok_configuration).permit(:client_id, :secret, :sample_person_id)
    end

end
