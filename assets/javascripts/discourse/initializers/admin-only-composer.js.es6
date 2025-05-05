import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "admin-only-composer",

  initialize() {
    withPluginApi("0.8.7", (api) => {
      api.modifyClass("component:composer", {
        pluginId: "discourse-admin-only",

        didInsertElement() {
          this._super(...arguments);
          if (!this.currentUser.admin) return;

          const model = this.model;
          model.customFields = model.customFields || {};
          if (model.customFields.admin_only === undefined) {
            model.customFields.admin_only = false;
          }

          this.addComposerField({
            name: "Admin Only",
            key: "admin_only",
            type: "checkbox",
            default: false,
            value: () => model.customFields.admin_only,
            onChange: (v) => { model.customFields.admin_only = v; }
          });
        }
      });
    });
  }
};
