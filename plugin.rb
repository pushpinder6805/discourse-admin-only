# name: discourse-admin-only
# about: Add “Admin Only” flag to topics and expose it to Algolia
# version: 0.1
# authors: Pushpender Singh
enabled_site_setting :admin_only_enabled

after_initialize do
  # 1. Save the custom field on create/edit
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

  # 2. Expose the field in your Algolia indexer
  register_post_event_trigger(:topic_created, :post_created)

  # Extend the TopicIndexer’s to_object
  require_dependency File.expand_path("../lib/admin_only/patch_topic_indexer.rb", __FILE__)
end
