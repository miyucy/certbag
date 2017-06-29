class CreateServerCertificates < ActiveRecord::Migration[5.1]
  def change
    create_table :server_certificates do |t|
      t.string :name
      t.text :certificate
      t.text :private_key
      t.references :certificate_authority, foreign_key: true

      t.timestamps
    end
  end
end
