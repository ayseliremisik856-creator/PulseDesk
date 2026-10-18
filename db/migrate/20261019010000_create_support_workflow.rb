class CreateSupportWorkflow < ActiveRecord::Migration[8.1]
  def change
    create_table :brands do |t|
      t.string :name, null: false
      t.timestamps
    end
    create_table :agents do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.timestamps
    end
    add_index :agents, :email, unique: true
    create_table :tickets do |t|
      t.string :subject, null: false
      t.text :description, null: false
      t.string :customer_name, null: false
      t.string :customer_email, null: false
      t.string :priority, null: false, default: "normal"
      t.string :status, null: false, default: "new"
      t.references :brand, null: false, foreign_key: true
      t.references :agent, foreign_key: true
      t.datetime :first_response_at
      t.timestamps
    end
    add_index :tickets, [ :status, :created_at ]
    add_check_constraint :tickets, "status IN ('new', 'open', 'solved')", name: "ticket_status"
    add_check_constraint :tickets, "priority IN ('low', 'normal', 'high', 'urgent')", name: "ticket_priority"
    create_table :ticket_responses do |t|
      t.references :ticket, null: false, foreign_key: true
      t.text :body, null: false
      t.string :author_type, null: false
      t.timestamps
    end
    add_check_constraint :ticket_responses, "author_type IN ('staff', 'customer')", name: "response_author"
  end
end
