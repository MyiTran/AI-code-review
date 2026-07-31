require 'rails_helper'

# == Schema Information
#
# Table name: repositories
#
#  id                     :uuid             not null, primary key
#  connected              :boolean          default(TRUE), not null
#  connected_at           :datetime         not null
#  default_branch         :string
#  description            :text
#  disconnected_at        :datetime
#  full_name              :string           not null
#  github_url             :string
#  language               :string
#  name                   :string           not null
#  visibility             :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  github_id              :bigint           not null
#  github_installation_id :uuid             not null
#
# Indexes
#
#  index_repositories_on_github_installation_id                (github_installation_id)
#  index_repositories_on_github_installation_id_and_github_id  (github_installation_id,github_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (github_installation_id => github_installations.id)
#
RSpec.describe Repository, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
