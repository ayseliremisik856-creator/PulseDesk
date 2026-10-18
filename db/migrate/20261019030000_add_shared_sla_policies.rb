class AddSharedSlaPolicies < ActiveRecord::Migration[8.1]
  def change
    create_table :sla_policies do |t|
      t.string :name, null: false
      t.integer :first_response_minutes, null: false, default: 60
      t.timestamps
    end
    add_check_constraint :sla_policies, "first_response_minutes BETWEEN 1 AND 1440", name: "sla_policy_target_range"
    add_reference :brands, :sla_policy, foreign_key: true
    # Additive and backward compatible: existing live tickets retain 60 minutes.
    add_column :tickets, :sla_target_minutes, :integer, null: false, default: 60
    add_check_constraint :tickets, "sla_target_minutes BETWEEN 1 AND 1440", name: "ticket_sla_target_range"
  end
end
