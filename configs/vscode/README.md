# Visual Studio Code - (vscode)
Visual Studio Code : https://code.visualstudio.com/

Visual Studio Code Manage Extention : [Marketplace](https://marketplace.visualstudio.com/VSCode)

# VScodium
[VSCodium](https://vscodium.com/#moreinfo) is a community-driven, freely-licensed binary distribution of Microsoft’s editor VS Code.

## Custom `settings.json` file from VSCode
Since VSCode 1.83.1 you can custom the **window.titleBarStyle** in settings.json file.

Example of `settings.json` :
```text
{
    // THEME
    // Specifies the color theme used in the workbench
    //"workbench.colorTheme": "GitHub Dark Dimmed",

    // ICONE
    // Specifies the file icon theme used in the workbench or 'null' to not show any file icons
    //"workbench.iconTheme": "material-icon-theme",

    // Open the Welcome page, with content to aid in getting started with VS Code and extensions.
    "workbench.startupEditor": "welcomePage", // Use "none" for empty welcomepage

    // Controls tree indentation in pixels
    "workbench.tree.indent": 15,

    // Controls whether the tree should render indent guides
    "workbench.tree.renderIndentGuides": "always",

    // Controls whether opened editors show as preview editors
    "workbench.editor.enablePreview": false,

    // Adjust the appearance of the window title bar. On Linux and Windows
    "window.titleBarStyle": "custom",

    // Adjust the zoom level of the window.
    // The original size is 0 and each increment above (e.g. 1) or below (e.g. -1)
    // represents zooming 20% larger or smaller.
    // You can also enter decimals to adjust the zoom level with a finer granularity
    "window.zoomLevel": 1,

    // Controls the font size in pixels
    "editor.fontSize": 14,

    // Controls the line height
    //"editor.lineHeight": 22,

    // Zoom the font of the editor when using mouse wheel and holding Ctrl
    "editor.mouseWheelZoom": true,

    // A multiplier to be used on the deltaX and deltaY of mouse wheel scroll events
    "editor.mouseWheelScrollSensitivity": 3,

    // No telemetry Windows Thanks... or Use VScodium
    // Controls Visual Studio Code telemetry, first-party extension telemetry and participating third-party extension telemetry.
    "telemetry.telemetryLevel": "off",
    "telemetry.enableTelemetry": false,
    "telemetry.enableCrashReporter": false,

    // Controls whether the editor should highlight semantic symbol occurrences
    "editor.occurrencesHighlight": false,

    // Controls how the editor should render whitespace characters
    "editor.renderWhitespace": "trailing",

    // Controls whether the minimap is shown
    "editor.minimap.enabled": true,

    // Enable/disable navigation breadcrumbs
    "breadcrumbs.enabled": true,

    // Controls the font family.
    "editor.fontFamily": "'JetBrains Mono', 'Fira Code', 'Operator Mono Lig', monospace",

    //Controls the font weight. Accepts "normal" and "bold" keywords or numbers between 1 and 1000.
    "editor.fontWeight": "550",

    // Enables/Disables font ligatures
    "editor.fontLigatures": false,

    // Controls how lines should wrap
    "editor.wordWrap": "on",

    // Controls whether words are overwritten when accepting completions
    "editor.suggest.insertMode": "replace",

    // Controls the cursor style
    "editor.cursorStyle": "line",

    // Controls the width of the cursor when "editor.cursorStyle" is set to "line"
    "editor.cursorWidth": 3,

    // Controls whether suggestions should be accepted on commit characters
    "editor.acceptSuggestionOnCommitCharacter": false,

    // Render vertical rulers after a certain number of monospace characters. Use multiple values for multiple rulers. No rulers are drawn if array is empty.
    "editor.rulers": [79, 120],

    // Controls the maximum number of lines the terminal keeps in its buffer
    "terminal.integrated.scrollback": 1000,

    // Controls the font size in pixels of the terminal.
    "terminal.integrated.fontSize": 15,

    // Controls the font family of the terminal. Defaults to Editor: Font Family's value.
    "terminal.integrated.fontFamily": "'JetBrains Mono', 'Fira Code', 'Hack', 'Operator Mono Lig', monospace",

    // The font weight to use within the terminal for non-bold text. Accepts "normal" and "bold" keywords or numbers between 1 and 1000.
    "terminal.integrated.fontWeight": "normal",

    // The font weight to use within the terminal for bold text. Accepts "normal" and "bold" keywords or numbers between 1 and 1000.
    "terminal.integrated.fontWeightBold": "bold",

    // Controls whether all non-basic ASCII characters are highlighted. Only characters between U+0020 and U+007E, tab, line-feed and carriage-return are considered basic ASCII
    "editor.unicodeHighlight.nonBasicASCII": false,

    // Controls whether or not Workspace Trust is enabled within VS Code.
    "security.workspace.trust.enabled": false
}
```
