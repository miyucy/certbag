class ClientCertificateForm
  include ActiveModel::Model
  attr_accessor :name, :common_name, :pass_phrase
  attr_reader :ca_name

  def ca=(ca)
    @ca_name = ca.name
  end
end
