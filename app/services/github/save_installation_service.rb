module Github
  class SaveInstallationService < ApplicationService
    def initialize(user, installation)
      @user = user
      @installation = installation
    end

    def call
      record = find_or_initialize_record

      assign_attributes(record)

      record.save!
      record
    end

    private

    attr_reader :user, :installation

    def find_or_initialize_record
      user.github_installations.find_or_initialize_by(
        installation_id: installation.id
      )
    end

    def assign_attributes(record)
      record.assign_attributes(
        account_login: installation.account.login,
        account_id: installation.account.id,
        account_type: installation.account.type,
        repository_selection: installation.repository_selection
      )
    end
  end
end
