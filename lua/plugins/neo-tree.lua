local function context_dir(state)
  -- return the directory of the current neo-tree node
  local node = state.tree:get_node()
  if node.type == "directory" then
    return node.path
  end
  return node.path:gsub("/[^/]*$", "") -- go up one level
end

return {
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
      require("window-picker").setup()
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        source_selector = {
          sources = { -- table
            {
              source = "filesystem", -- string
              display_name = " 󰉓 Files ", -- string | nil
            },
            {
              source = "git_status", -- string
              display_name = " 󰊢 Git ", -- string | nil
            },
          },
        },
        window = {
          position = "left",
          -- width = 40,
          mapping_options = {
            noremap = true,
            nowait = true,
          },
          mappings = {
            ["t"] = {
              function(state)
                local node = state.tree:get_node()
                vim.fn.jobstart({ "open", node.path }, { detach = true })
              end,
              desc = "Open the current node by system default software",
              nowait = true,
            },
            -- copy absolute path to clipboard
            ["Y"] = {
              function(state)
                local node = state.tree:get_node()
                local content = node.path
                vim.fn.setreg('"', content)
                vim.fn.setreg("1", content)
                vim.fn.setreg("+", content)
              end,
              desc = "copy absolute path",
              nowait = true,
            },
            -- ["<c-o>"] = {
            --   function(state)
            --     local node = state.tree:get_node()
            --     vim.cmd("tabnew")
            --     vim.cmd("DiffviewOpen -- " .. node.path)
            --   end,
            --   desc = "Open file in diffview",
            --   nowait = true,
            -- },
            -- open in telescope live grep
            ["<c-f>"] = {
              function(state)
                require("telescope.builtin").live_grep({ cwd = context_dir(state) })
              end,
              desc = "live grep",
              nowait = true,
            },
            ["<c-r>"] = {
              function(state)
                local node = state.tree:get_node()
                if node.type == "directory" then
                  require("spectre").open({
                    cwd = node.path,
                    is_close = true, -- close an exists instance of spectre and open new
                    is_insert_mode = false,
                    path = "",
                  })
                else
                  require("spectre").open({
                    cwd = context_dir(state),
                    is_close = true, -- close an exists instance of spectre and open new
                    is_insert_mode = false,
                    path = node.path:match("^.+/(.+)$"),
                  })
                end
                -- close neo-tree
                vim.cmd("Neotree close")
              end,
              desc = "replace here",
              nowait = true,
            },
            ["<space>"] = {
              "toggle_node",
              nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
            },
            ["o"] = "open",
            ["<esc>"] = "cancel", -- close preview or floating neo-tree window
            ["P"] = { "toggle_preview", config = { use_float = true } },
            ["l"] = "open_drop",
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            -- ["S"] = "split_with_window_picker",
            -- ["s"] = "vsplit_with_window_picker",
            -- ["t"] = "hello",
            -- ["<cr>"] = "open_drop",
            -- ["t"] = "open_tab_drop",
            ["w"] = "open_with_window_picker",
            --["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
            ["x"] = "close_node",
            -- ['C'] = 'close_all_subnodes',
            ["z"] = "close_all_nodes",
            --["Z"] = "expand_all_nodes",
            ["a"] = {
              "add",
              -- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
              -- some commands may take optional config options, see `:h neo-tree-mappings` for details
              config = {
                show_path = "none", -- "none", "relative", "absolute"
              },
            },
            -- ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
            ["D"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["d"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
            ["q"] = "close_window",
            ["R"] = "refresh",
            ["?"] = "show_help",
            ["<"] = "prev_source",
            [">"] = "next_source",
          },
        },
        filesystem = {
          filtered_items = {
            visible = false, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_by_name = {
              --"node_modules"
            },
            hide_by_pattern = { -- uses glob style patterns
              "._*", -- mac file info on exFat external disk
              --"*.meta",
              --"*/src/*/tsconfig.json",
            },
            always_show = { -- remains visible even if other settings would normally hide it
              --".gitignored",
            },
            never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
              ".DS_Store",
              --"thumbs.db"
            },
            never_show_by_pattern = { -- uses glob style patterns
              --".null-ls_*",
            },
          },
          follow_current_file = {
            enabled = false, -- This will find and focus the file in the active buffer every time
            --               -- the current file is changed while the tree is open.
            leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
          },
          group_empty_dirs = false, -- when true, empty folders will be grouped together
          hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
          -- in whatever position is specified in window.position
          -- "open_current",  -- netrw disabled, opening a directory opens within the
          -- window like netrw would, regardless of window.position
          -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
          use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
          -- instead of relying on nvim autocmd events.
          window = {
            mappings = {
              ["<bs>"] = "navigate_up",
              ["h"] = "navigate_up",
              ["."] = "set_root",
              ["H"] = "toggle_hidden",
              ["/"] = "fuzzy_finder",
              -- ["f"] = "fuzzy_finder_directory",
              ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
              -- ["D"] = "fuzzy_sorter_directory",
              -- ["ff"] = "filter_on_submit",
              ["<c-x>"] = "clear_filter",
              ["<c-g>"] = function(state)
                -- get the current node
                local node = state.tree:get_node()
                -- if the node is not a directory, walk up the tree until we find one
                while node and node.type ~= "directory" do
                  local parent_id = node:get_parent_id()
                  if parent_id == nil then
                    -- we must have reached the root node
                    -- this should not happen because the root node is always a directory
                    -- but just in case...
                    node = nil
                    break
                  end
                  node = state.tree:get_node(parent_id)
                end
                -- if we somehow didn't find a directory, just use the root node
                local path = node and node.path or state.path
                require("telescope.builtin").live_grep({
                  search_dirs = { path },
                  prompt_title = string.format("Grep in [%s]", vim.fs.basename(path)),
                })
              end,
            },
            fuzzy_finder_mappings = {
              -- define keymaps for filter popup window in fuzzy_finder_mode
              ["<down>"] = "move_cursor_down",
              ["<C-n>"] = "move_cursor_down",
              ["<up>"] = "move_cursor_up",
              ["<C-p>"] = "move_cursor_up",
            },
          },
          commands = {
            hello = function()
              print("Hello, neo-tree!")
            end,
          }, -- Add a custom command or override a global one using the same function name
        },
        buffers = {
          follow_current_file = {
            enabled = true, -- This will find and focus the file in the active buffer every time
            --              -- the current file is changed while the tree is open.
            leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
          },
          group_empty_dirs = true, -- when true, empty folders will be grouped together
          show_unloaded = true,
          window = {
            mappings = {
              ["bd"] = "buffer_delete",
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
            },
          },
        },
        git_status = {
          window = {
            position = "float",
            mappings = {
              ["A"] = "git_add_all",
              ["u"] = "git_unstage_file",
              ["a"] = "git_add_file",
              ["r"] = "git_revert_file",
              ["c"] = "git_commit",
              ["gp"] = "git_push",
              ["gg"] = "git_commit_and_push",
            },
          },
        },
      })
    end,
  },
}
