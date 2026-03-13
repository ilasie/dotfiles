import shlex

config.source('gruvbox.py')
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.preferred_color_scheme = "dark"
c.colors.webpage.darkmode.policy.images = "never"

config.source('bindings.py')

config.load_autoconfig(False)

term = 'alacritty -e'

# required to create link `/bin/yazi` if it had not been there
fileChooser = shlex.split(term) + ['yazi', '--chooser-file={}']
c.fileselect.handler = "external"
c.fileselect.folder.command = fileChooser
c.fileselect.multiple_files.command = fileChooser
c.fileselect.single_file.command = fileChooser

c.url.start_pages = 'about:blank'
c.url.default_page = 'about:blank'
c.tabs.last_close = "startpage"
c.url.searchengines = {
    "DEFAULT": "https://cn.bing.com/search?q={}"
}

c.statusbar.show = "always"

c.fonts.default_size = '14pt'
c.fonts.hints = 'normal 12pt default_family'

c.tabs.show = "always"
c.tabs.position = "left"
c.tabs.padding = {"bottom":0, "left":0, "right":0, "top":0}
c.tabs.indicator.width = 0
c.tabs.width = '10%'

c.downloads.remove_finished = 3300
c.downloads.position = "bottom"
