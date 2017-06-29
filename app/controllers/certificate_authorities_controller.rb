class CertificateAuthoritiesController < ApplicationController
  def index
    @cas = CertificateAuthority.all
  end

  def show
    @ca = CertificateAuthority.find_by! name: params[:ca_name]
    if params[:format] == 'pem'
      render plain: @ca.certificate
    end
  end

  def new
    @ca = CertificateAuthority.new
  end

  def create
    permitted_create_params = params.require(:certificate_authority).permit(:name, :certificate, :private_key, :pass_phrase)

    @ca = CertificateAuthority.new permitted_create_params
    if @ca.save
      redirect_to certificate_authority_path(@ca.name)
    else
      render :new
    end
  end
end
