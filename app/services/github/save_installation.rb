module Github
  class SaveInstallation
    def self.call(user, installation)
      record = find_or_initialize_record(user, installation)

      assign_attributes(record, installation)

      record.save!

      record
    end

    def self.find_or_initialize_record(user, installation)
      user.github_installations.find_or_initialize_by(installation_id: installation.id)
    end

    def self.assign_attributes(record, installation)
      record.account_login = installation.account.login
      record.account_id = installation.account.id
      record.account_type = installation.account.type
      record.repository_selection = installation.repository_selection
    end

    private_class_method :find_or_initialize_record
    private_class_method :assign_attributes
  end
end
