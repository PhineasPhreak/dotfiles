## Visual Studio Code - (vscode)

Visual Studio Code : https://code.visualstudio.com/ </br>
Visual Studio Code Manage Extention  : [Marketplace](https://marketplace.visualstudio.com/VSCode)

### Custom `settings.json` file from VSCode

Since VSCode 1.28.1 you can custom the **window.titleBarStyle** in settings.json file. <br>
Example of `settings.json` :
```json
{
    "editor.fontSize": 14,
    "editor.mouseWheelZoom": true,
    "editor.mouseWheelScrollSensitivity": 3,
    "window.zoomLevel": -1,
    "workbench.iconTheme": "vscode-icons",
    "python.pythonPath": "/usr/bin/python3.6",
    "telemetry.enableTelemetry": false,
    "workbench.colorTheme": "Predawn",
    "window.titleBarStyle": "custom",
}
```
> My little config for VSCode 1.28.1 and 1.34.0

### Installation

Install `libfreetype6_2.8-0.2ubuntu2.1_amd64.deb` on your system.
```shell
$ sudo dpkg -i libfreetype6_2.8-0.2ubuntu2.1_amd64.deb
```
After this installation reboot your system

### Fix Font Rendering vscode - for Kali Linux(Gnome, Mate)

GitHub Issues : https://github.com/Microsoft/vscode/issues/35675

Repositories Security Ubuntu : http://security.ubuntu.com/ubuntu/pool/main/f/freetype/

Holding Package on Linux : [Command Here](https://github.com/PhineasPhreak/dotfiles#holding-packages-with-dpkg-apt)
