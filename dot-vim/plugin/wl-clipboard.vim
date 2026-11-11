vim9script
# Use wl-clipboard for the + and * registers where Vim's own Wayland
# clipboard does not work, e.g. in GNOME, which lacks the data-control
# protocol (see :help wayland-selections and :help clipboard-providers).

if !has('wayland') || !exists('v:clipproviders') || has('clipboard_working')
  finish
endif

def Available(): bool
  return !empty($WAYLAND_DISPLAY) && executable('wl-copy') && executable('wl-paste')
enddef

def Copy(reg: string, type: string, str: list<string>)
  silent system(reg == '*' ? 'wl-copy -p' : 'wl-copy', str)
enddef

def Paste(reg: string): tuple<string, list<string>>
  var args = 'wl-paste --type text/plain;charset=utf-8'
  silent return ('', systemlist(reg == '*' ? args .. ' -p' : args))
enddef

v:clipproviders['wl_clipboard'] = {
  available: Available,
  copy: {'+': Copy, '*': Copy},
  paste: {'+': Paste, '*': Paste},
}

set clipmethod=wl_clipboard
