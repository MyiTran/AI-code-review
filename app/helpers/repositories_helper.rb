module RepositoriesHelper
  def connect_repository_button(repository_limit_reached:)
    if repository_limit_reached
      button_tag(
        class: 'btn btn-secondary',
        disabled: true,
        title: 'Repository limit reached for your current plan.'
      ) do
        safe_join([tag.i(class: 'bi bi-plus-lg me-2'), 'Connect repository'])
      end
    else
      link_to(github_app_installation_url, class: 'btn btn-primary', data: { turbo: false }) do
        safe_join([tag.i(class: 'bi bi-plus-lg me-2'), 'Connect repository'])
      end
    end
  end
end
