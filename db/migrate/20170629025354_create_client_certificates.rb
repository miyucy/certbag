class CreateClientCertificates < ActiveRecord::Migration[5.1]
  def change
    create_table :client_certificates do |t|
      t.string :name
      t.text :certificate
      t.string :pass_phrase
      t.references :certificate_authority, foreign_key: true

      t.timestamps
    end
  end
end
