require 'rails_helper'

# == Schema Information
#
# Table name: reviews
#
#  id                 :uuid             not null, primary key
#  base_commit_sha    :string
#  commented_at       :datetime
#  commit_sha         :string           not null
#  error_message      :text
#  issues_found_count :integer          default(0), not null
#  latency_ms         :integer
#  review_content     :text
#  reviewed_at        :datetime
#  status             :string           default("processing"), not null
#  summary            :text
#  tokens_used        :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  ai_model_id        :uuid             not null
#  github_comment_id  :bigint
#  pull_request_id    :uuid             not null
#
# Indexes
#
#  idx_on_pull_request_id_commit_sha_ai_model_id_b6a69c7c0b  (pull_request_id,commit_sha,ai_model_id) UNIQUE
#  index_reviews_on_ai_model_id                              (ai_model_id)
#  index_reviews_on_pull_request_id                          (pull_request_id)
#
# Foreign Keys
#
#  fk_rails_...  (ai_model_id => ai_models.id)
#  fk_rails_...  (pull_request_id => pull_requests.id)
#
# RSpec.describe Review, type: :model do
#   pending "add some examples to (or delete) #{__FILE__}"
# end
RSpec.describe Review, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:pull_request) }
    it { is_expected.to belong_to(:ai_model) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:commit_sha) }
    it { is_expected.to validate_presence_of(:status) }
  end
end
