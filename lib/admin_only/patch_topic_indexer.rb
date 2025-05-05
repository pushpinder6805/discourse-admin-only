# frozen_string_literal: true
# this patch adds admin_only to the Algolia record

after_initialize do
  module ::DiscourseAlgolia
    class TopicIndexer
      def to_object(post)
        obj = super(post)
        # pull the topic-starter’s custom field
        admin_flag = post.topic.custom_fields['admin_only'] == 'true'
        obj[:admin_only] = admin_flag
        obj
      end
    end
  end
end
