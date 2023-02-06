# Plugins used in

### Folder structure

```txt
└── lua/
    └── modules/
        ├── plugins/
        │   ├── completion.lua
        │   ├── editor.lua
        │   ├── lang.lua
        │   ├── tool.lua
        │   └── ui.lua
        ├── configs/
        │   ├── completion/
        │   ├── editor/
        │   ├── lang/
        │   ├── tool/
        │   └── ui/
        └── utils/
            ├── icons.lua
            └── init.lua
```

### Definitions

#### Structure definition

- `plugins/{scope}.lua` contains plugins within the scope.
- `configs/{scope}/` folder contains plugin settings according to the scope.
- `utils/icons.lua` contains icons used for plugin settings.
- `utils/init.lua` contains utility functions used by plugins.

#### Scope definition

- `completion` contains plugins about code completion.
- `editor` contains plugins which improve the default ability of vinilla Neovim.
- `lang` contains plugins relates to certain programming language.
- `tool` contains plugins using external tools and change the default layout which provides new ability to Neovim.
- `ui` contains plugins render the interface without any actions after user fires Neovim.
