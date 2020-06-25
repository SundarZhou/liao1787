module ApplicationHelper
  def full_title(page_title, base_title = '系统')
    if page_title.empty?
      base_title
    else
      "#{page_title} - #{base_title}"
    end
  end
  def notice_message
    alert_types = { notice: :success, alert: :danger }

    close_button_options = { class: "close", "data-dismiss" => "alert", "aria-hidden" => true }
    close_button = content_tag(:button, "×", close_button_options)

    alerts = flash.map do |type, message|
      alert_content = close_button + message

      alert_type = alert_types[type.to_sym] || type
      alert_class = "alert alert-#{alert_type} alert-dismissable"

      content_tag(:div, alert_content, class: alert_class)
    end

    alerts.join("\n").html_safe
  end
  def main_nav
    nav_html = %Q[
      <li class="#{'active' if controller_name == 'dashboard'}">#{link_to '控制面板', root_path}</li>
    ]

    nav_html
  end

  def side_nav
    if controller_name == 'dashboard'
      nav_html = %Q[
        <li class="#{'active' if controller_name == 'dashboard'}">#{link_to "控制面板", root_path}</li>
      ]
    end
    nav_html
  end
end
