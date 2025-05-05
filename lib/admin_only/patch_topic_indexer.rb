# frozen_string_literal: true
after_initialize do
    module ::DiscourseAlgolia
      class TopicIndexer
        # Override to_object to inject our new flag
        alias_method :orig_to_object, :to_object
  
        def to_object(post)
          obj = orig_to_object(post)
          # read the topic‐level custom field
          admin_flag = post.topic.custom_fields['admin_only'] == 'true'
          obj[:admin_only] = admin_flag
          obj
        end
      end
    end
  end
  