class ClientCertificatesController < ApplicationController
  def index
    @ca = load_ca
    @certs = @ca.client_certificates
  end

  def show
    @ca = load_ca
    @cert = @ca.client_certificates.find params[:id]
    case params[:format]
    when 'p12'
      render plain: @cert.p12.to_der
    when 'pem'
      render plain: @cert.p12.certificate.to_pem
    when 'key'
      render plain: @cert.p12.key.to_pem
    end
  end

  def new
    @ca = load_ca
    @cert = ClientCertificateForm.new ca: @ca
  end

  def create
    @ca = load_ca
    @creator = CreateClientCertificate.new @ca, permitted_create_params
    @cert = @creator.perform
    redirect_to client_certificate_path(@ca.name, @cert)
  end

  private

  def load_ca(name = params[:ca_name])
    CertificateAuthority.find_by! name: name
  end

  def permitted_create_params
    params.require(:client_certificate_form).permit(:name, :common_name, :pass_phrase)
  end
end
