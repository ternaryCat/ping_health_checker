Sequel.migration do
  change do
    add_index :ping_responses, :duration
  end
end
