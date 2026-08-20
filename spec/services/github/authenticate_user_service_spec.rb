require 'rails_helper'

RSpec.describe Github::AuthenticateUserService do
  let!(:auth) do
    OmniAuth::AuthHash.new(
      provider: 'github',
      uid: '123',
      info: {
        email: 'khoa@example.com',
        name: 'Khoa Nguyen',
        nickname: 'khoa-dev',
        image: 'https://example.com/avatar.png'
      },
      credentials: {
        token: 'github-token'
      }
    )
  end

  it 'creates a new user' do
    expect { described_class.call(auth) }.to change(User, :count).by(1)
  end

  it 'saves github attributes' do
    user = described_class.call(auth)

    expect(user.provider).to eq('github')
    expect(user.uid).to eq('123')
    expect(user.github_username).to eq('khoa-dev')
    expect(user.github_access_token).to eq('github-token')
  end

  it 'does not create duplicate user' do
    described_class.call(auth)

    expect { described_class.call(auth) }.not_to change(User, :count)
  end

  it 'generates noreply email when github email is blank' do
    auth.info.email = nil

    user = described_class.call(auth)

    expect(user.email).to eq('khoa-dev@users.noreply.github.com')
  end
end
