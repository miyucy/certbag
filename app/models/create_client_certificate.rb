require 'base64'

class CreateClientCertificate
  def initialize(certificate_authority, params = {})
    @ca = certificate_authority
    @params = params
    @now = Time.now
  end

  def perform
    ApplicationRecord.transaction do
      @ca.lock!
      serial = @ca.serial_number
      pkey = OpenSSL::PKey::RSA.generate 2048
      cert = OpenSSL::X509::Certificate.new
      cert.version    = 2
      cert.not_before = @now
      cert.not_after  = @now + 10.years
      cert.public_key = pkey.public_key
      cert.serial     = serial
      cert.issuer     = @ca.cert.issuer
      cert.subject    = make_subject
      extension_factory = OpenSSL::X509::ExtensionFactory.new
      extension_factory.subject_certificate = cert
      extension_factory.issuer_certificate = @ca.cert
      cert.extensions = [
        extension_factory.create_extension('basicConstraints', 'CA:FALSE', true),
        extension_factory.create_extension('keyUsage', %w[nonRepudiation digitalSignature keyEncipherment].join(','), true),
        extension_factory.create_extension('extendedKeyUsage', %w[clientAuth codeSigning emailProtection].join(','), false),
        extension_factory.create_extension('nsCertType', 'client'),
        extension_factory.create_extension('subjectKeyIdentifier', 'hash'),
        extension_factory.create_extension('authorityKeyIdentifier', 'keyid:always,issuer:always'),
      ]
      cert.sign @ca.pkey, OpenSSL::Digest::SHA1.new
      p12 = OpenSSL::PKCS12.create @params[:pass_phrase], @params[:name], pkey, cert, [@ca.cert]

      @ca.increment! :serial_number
      @ca.client_certificates.create!(
        name: @params[:name],
        certificate: Base64.strict_encode64(p12.to_der),
        pass_phrase: @params[:pass_phrase]
      )
    end
  end

  def make_subject
    subject = OpenSSL::X509::Name.new
    subject.add_entry 'CN', @params[:common_name]
    subject
  end
end
