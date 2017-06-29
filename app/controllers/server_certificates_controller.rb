class ServerCertificatesController < ApplicationController
  def index
    @ca = load_ca
    @certs = @ca.server_certificates
  end

  def show
    @ca = load_ca
    @cert = @ca.server_certificates.find params[:id]
    case params[:format]
    when 'pem'
      render plain: @cert.certificate
    when 'key'
      render plain: @cert.private_key
    end
  end

  def new
    @ca = load_ca
    @cert = ServerCertificateForm.new ca: @ca
  end

  def create
    @ca = load_ca
    @creator = CreateServerCertificate.new @ca, permitted_create_params
    @cert = @creator.perform
    redirect_to server_certificate_path(@ca.name, @cert)
  end

  private

  def load_ca(name = params[:ca_name])
    CertificateAuthority.find_by! name: name
  end

  def permitted_create_params
    params.require(:server_certificate_form).permit(:name, :common_name)
  end
end
