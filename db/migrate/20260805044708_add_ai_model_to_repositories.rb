class AddAiModelToRepositories < ActiveRecord::Migration[8.1]
  def change
    add_reference :repositories, :ai_model, type: :uuid, foreign_key: true
  end
end
