# name: discourse-admin-only
# about: A super simple plugin to demonstrate how plugins work
# version: 0.0.1
# authors: Awesome Plugin Developer
# url: https://github.com/pushpinder6805/discourse-admin-only.git

enabled_site_setting :admin_only_enabled

after_initialize do
  # Hook into topic create/edit
  on(:topic_created) do |topic, params, user|
    next unless user.admin?
    if params.dig(:topic, :custom_fields, :admin_only).present?
      topic.custom_fields['admin_only'] = params[:topic][:custom_fields][:admin_only].to_s
      topic.save_custom_fields
    end
  end

  on(:topic_edited) do |topic, params, user|
    next unless user.admin?
    if params.dig(:topic, :custom_fields, :admin_only)
      topic.custom_fields['admin_only'] = params[:topic][:custom_fields][:admin_only].to_s
      topic.save_custom_fields
    end
  end

  # Load our patch that adds the flag into the Algo­lia indexer
  require_dependency File.expand_path("../lib/admin_only/patch_topic_indexer.rb", __FILE__)
end
