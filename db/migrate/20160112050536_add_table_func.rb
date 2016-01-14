class AddTableFunc < ActiveRecord::Migration
  def change
    execute 'CREATE EXTENSION tablefunc;'
  end
end
