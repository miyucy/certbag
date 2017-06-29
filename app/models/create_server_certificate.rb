# http://qiita.com/k-masaki/items/12b5e8a1874214308912#%E3%82%B5%E3%83%BC%E3%83%90%E8%A8%BC%E6%98%8E%E6%9B%B8%E3%82%92%E4%BD%9C%E3%82%8B
# http://users.nccs.gov/~fwang2/ruby/ruby_ssl.html
class CreateServerCertificate
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
        extension_factory.create_extension('keyUsage', %w[nonRepudiation digitalSignature keyEncipherment dataEncipherment].join(','), true),
        extension_factory.create_extension('extendedKeyUsage', %w[serverAuth].join(','), false),
        extension_factory.create_extension('nsCertType', 'server'),
        extension_factory.create_extension('subjectKeyIdentifier', 'hash'),
        extension_factory.create_extension('authorityKeyIdentifier', 'keyid:always,issuer:always'),
      ]
      cert.sign @ca.pkey, OpenSSL::Digest::SHA1.new

      @ca.increment! :serial_number
      @ca.server_certificates.create!(
        name: @params[:name],
        certificate: cert.to_pem,
        private_key: pkey.export
      )
    end
  end

  def make_subject
    subject = OpenSSL::X509::Name.new
    subject.add_entry 'CN', @params[:common_name]
    subject
  end
end
