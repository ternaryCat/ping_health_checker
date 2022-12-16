Sequel.migration do
  change do
    create_table(:ips) do
      primary_key :id

      inet :address, null: false
      DateTime :created_at, null: false

      index :id
      index :address, unique: true
    end
  end
end
