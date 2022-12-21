Sequel.migration do
  change do
    add_column :ips, :deleted_at, DateTime, null: true

    add_index :ips, :deleted_at
  end
end
