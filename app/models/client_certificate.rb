class ClientCertificate < ApplicationRecord
  belongs_to :certificate_authority

  validates :name, presence: true, uniqueness: { scope: :certificate_authority_id }
  validates :certificate, presence: true
  validates :pass_phrase, presence: true

  def p12
    @p12 ||= OpenSSL::PKCS12.new Base64.strict_decode64(certificate), pass_phrase
  end
end
