Sequel.migration do
  change do
    create_table(:ips, :ignore_index_errors=>true) do
      primary_key :id
      String :address, :null=>false
      DateTime :created_at, :null=>false
      DateTime :deleted_at
      
      index [:address], :unique=>true
      index [:deleted_at]
      index [:id]
    end
    
    create_table(:schema_info) do
      Integer :version, :default=>0, :null=>false
    end
    
    create_table(:ping_responses, :ignore_index_errors=>true) do
      primary_key :id
      foreign_key :ip_id, :ips, :null=>false, :key=>[:id]
      TrueClass :success, :null=>false
      Float :duration, :null=>false
      DateTime :created_at, :null=>false
      
      index [:duration]
      index [:id]
    end
  end
end
