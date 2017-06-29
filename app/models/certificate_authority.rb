class CertificateAuthority < ApplicationRecord
  has_many :server_certificates
  has_many :client_certificates

  validates :name, presence: true, uniqueness: true
  validates :certificate, presence: true
  validates :private_key, presence: true
  validates :pass_phrase, presence: true
  validates :serial_number, presence: true, numericality: { only_integer: true }

  def cert
    @cert ||= OpenSSL::X509::Certificate.new certificate
  end

  def pkey
    @pkey ||= OpenSSL::PKey.read private_key, pass_phrase
  end
end
