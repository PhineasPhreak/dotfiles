#!/bin/env python3

from glob import glob
import codecs

categories = ["Audio",
              "AudioVideo",
              "Development",
              "Education",
              "Email",
              "FileManager",
              "Game",
              "Graphics",
              "IDE",
              "Math",
              "Music",
              "Network",
              "News",
              "Office",
              "Settings",
              "System",
              "Utility",
              "Video",
              "Viewer",
              "WebBrowser",
              "WordProcessor"]

apps = []

for fn in glob("/usr/share/applications/*.desktop"):

    app = {"terminal": False,
           "category": "Other",
           "icon": "",
           "tooltip": ""}

    for line in codecs.open(fn, "r", "utf-8").readlines():
        if "=" in line:
            items = line.strip().split("=")
            label, data = items[0], items[1]
            data = data.split(";")
            if label == "Exec":
                app["exec"] = data[0].split(" ")[0]
                app["fullexec"] = " ".join([
                    elem for elem in data[0].split(" ")
                    if "%" not in elem])
            elif label == "Icon":
                app["icon"] = data[0]
            elif label == "Categories":
                app["category"] = data
            elif label == "Name":
                app["label"] = data[0]
            elif label == "Terminal":
                app["terminal"] = True
            elif label == "Comment":
                app["tooltip"] = ";".join(data)

    try:
        x = app["exec"]
        x = app["label"]
        apps.append(app)
    except KeyError:
        pass

def format_app(app):
    tmpl = """<Program label="%(label)s" tooltip="%(tooltip)s" icon="%(icon)s">%(exec)s</Program>"""
    if app["terminal"]:
        return tmpl % {"label": app["label"],
                       "tooltip": app["tooltip"],
                       "icon": app["icon"],
                       "exec": app["fullexec"]}
    else:
        return tmpl % app

print("<JWM>")

app_cats = []

for a in apps:
    if a["category"] != "Other":
        app_cats = app_cats + a["category"]
    else:
        app_cats.append("Other")

cats_with_apps = [cat for cat in categories
                  if cat in app_cats]

for cat in cats_with_apps:
    print("""<Menu label="%s" icon="folder.ico">""" % cat)
    print("\n".join(map(format_app,
                        sorted([a for a in apps if cat in a["category"]],
                               key=lambda a: a["label"]))))
    print("</Menu>")

print("</JWM>")
