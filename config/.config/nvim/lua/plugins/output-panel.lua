return {
  {
    "krissen/output-panel.nvim",

    dependencies = {
      "folke/snacks.nvim",
    },

    opts = {
      auto_open = {
        enabled = true,
      },

      auto_hide = {
        enabled = false,
      },

      follow = {
        enabled = true,
      },

      max_lines = 8000,

      profiles = {
        overseer = {
          enabled = true,

          notifications = {
            title = "Build",
          },

          window_title = "Build Output",

          auto_hide = {
            enabled = false,
          },
        },
      },

      mini = {
        height_ratio = 0.25,
        height_min = 8,
        height_max = 30,
      },

      focus = {
        height_ratio = 0.7,
      },
    },
  },
}
