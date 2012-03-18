Sequel.migration do
  up do
    create_table(:resources) do
      primary_key :id

      String  :type, :null=>false
      String  :path, :null=>false
      Time    :created_at, :null=>false
      Time    :occurred_at, :null=>false

      String  :attributes, :text=>true
      index :occurred_at
    end
  end

  down do
    drop_table(:resources)
  end
end