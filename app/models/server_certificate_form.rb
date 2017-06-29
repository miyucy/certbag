class ServerCertificateForm
  include ActiveModel::Model
  attr_accessor :name, :common_name
  attr_reader :ca_name

  def ca=(ca)
    @ca_name = ca.name
  end
end
