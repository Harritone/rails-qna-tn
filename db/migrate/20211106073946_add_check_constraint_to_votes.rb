class AddCheckConstraintToVotes < ActiveRecord::Migration[6.1]
  def up
    add_check_constraint :votes, 'result IN (-1, 0, 1)', name: 'result_inclusion'
  end

  def down
    remove_check_constraint :table_name, name: 'result_inclusion'
  end
end
