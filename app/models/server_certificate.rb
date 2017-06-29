class ServerCertificate < ApplicationRecord
  belongs_to :certificate_authority

  validates :name, presence: true, uniqueness: { scope: :certificate_authority_id }
  validates :certificate, presence: true
  validates :private_key, presence: true

  def cert
    @cert ||= OpenSSL::X509::Certificate.new certificate
  end
end
