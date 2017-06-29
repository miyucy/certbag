class CreateCertificateAuthorities < ActiveRecord::Migration[5.1]
  def change
    create_table :certificate_authorities do |t|
      t.string :name
      t.text :certificate
      t.text :private_key
      t.string :pass_phrase
      t.bigint :serial_number, default: 1

      t.timestamps
    end
    add_index :certificate_authorities, :name, unique: true
  end
end
