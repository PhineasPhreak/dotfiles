## Visual Studio Code - (vscode)

Visual Studio Code : https://code.visualstudio.com/ </br>
Visual Studio Code Manage Extention  : [Marketplace](https://marketplace.visualstudio.com/VSCode)

### Custom `settings.json` file from VSCode

Since VSCode 1.28.1 you can custom the **window.titleBarStyle** in settings.json file. <br>
Example of `settings.json` :
```json
{
    "workbench.startupEditor": "welcomePage",
    "editor.fontSize": 14,
    "editor.mouseWheelZoom": true,
    "editor.mouseWheelScrollSensitivity": 3,
    "window.zoomLevel": 1,
    "workbench.iconTheme": "vscode-icons",
    "python.pythonPath": "/usr/bin/python3.9",
    "telemetry.enableTelemetry": false,
    "telemetry.enableCrashReporter": false,
    "workbench.colorTheme": "Predawn",
    "window.titleBarStyle": "custom",
}
```
> My little config for VSCode 1.28.1 and 1.34.0

### Fix Font Rendering vscode

Holding Package on Linux : [Command Here](https://github.com/PhineasPhreak/dotfiles#holding-packages-with-dpkg-apt)
