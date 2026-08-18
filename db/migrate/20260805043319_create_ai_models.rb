class CreateAiModels < ActiveRecord::Migration[8.1]
  def change
    create_table :ai_models, id: :uuid do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :provider, null: false
      t.boolean :is_default, null: false, default: false
      t.boolean :is_premium, null: false, default: false
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :ai_models, :slug, unique: true
  end
end
