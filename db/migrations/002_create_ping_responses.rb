Sequel.migration do
  change do
    create_table(:ping_responses) do
      primary_key :id

      foreign_key :ip_id, :ips, null: false
      TrueClass :success, null: false
      Float :duration, null: false
      DateTime :created_at, null: false

      index :id
    end
  end
end
