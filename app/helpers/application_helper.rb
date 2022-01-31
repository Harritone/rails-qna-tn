module ApplicationHelper
  def bootstrap_class_for flash_type
    {
      success: "alert-success",
      error: "alert-danger",
      alert: "alert-warning",
      notice: "alert-info"
    }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages(_opts = {})
    # return if flash[0][0] == :form_error
    flash.each do |msg_type, message|
      next if msg_type == :form_error
      concat(content_tag(:div, message.html_safe, {
        class: "alert #{bootstrap_class_for(msg_type)} alert-dismissible fade show text-center"}) do
        concat content_tag(:button, '', class: "btn-close", data: {
          "bs-dismiss": 'alert'
          })
        concat message.html_safe
      end)
    end
    nil
  end

  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end
end
