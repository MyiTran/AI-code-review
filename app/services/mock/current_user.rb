module Mock
  class CurrentUser
    def self.call
      {
        name: 'Hazel Tran',
        github_username: 'MyiTran',
        email: 'hazel_tr@example.com',
        plan: 'Free plan',
        initials: 'HT'
      }
    end
  end
end
