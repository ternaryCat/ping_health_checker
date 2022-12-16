Sequel.migration do
  change do
    create_table(:ips, :ignore_index_errors=>true) do
      primary_key :id
      String :address, :null=>false
      DateTime :created_at, :null=>false
      
      index [:address], :unique=>true
      index [:id]
    end
    
    create_table(:schema_info) do
      Integer :version, :default=>0, :null=>false
    end
  end
end
