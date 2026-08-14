require 'rails_helper'

# == Schema Information
#
# Table name: github_installations
#
#  id                   :uuid             not null, primary key
#  account_login        :string           not null
#  account_type         :string           not null
#  repository_selection :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  account_id           :bigint           not null
#  installation_id      :bigint           not null
#  user_id              :uuid             not null
#
# Indexes
#
#  index_github_installations_on_installation_id  (installation_id) UNIQUE
#  index_github_installations_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
RSpec.describe GithubInstallation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
