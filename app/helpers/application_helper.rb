module ApplicationHelper
  DASH_MASK = '--'.freeze

  def display_text(value)
    value.presence || DASH_MASK
  end

  def sidebar_user_avatar(user)
    return unless user

    if user.avatar_url.present?
      image_tag(user.avatar_url, class: 'avatar', alt: user.full_name)
    else
      content_tag(:span, class: 'avatar') do
        user.full_name.split.filter_map(&:first).join.upcase
      end
    end
  end

  def sidebar_user_handle(user)
    "@#{user.github_username}"
  end

  def admin_menu_items
    [
      { path: admin_root_path, icon: 'chart-pie', label: 'Dashboard' },
      { path: admin_users_path, icon: 'users-round', label: 'Users' }
    ]
  end
end
