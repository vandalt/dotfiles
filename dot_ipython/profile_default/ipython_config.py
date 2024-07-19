import warnings

c.TerminalInteractiveShell.editing_mode = 'vi'

c.TerminalIPythonApp.log_level = "ERROR"
try:
    c.TerminalInteractiveShell.emacs_bindings_in_vi_insert_mode = False
    c.TerminalInteractiveShell.timeoutlen = 0.25
except:
    pass
