{ ... }:

{
  xresources.properties = {
    # !!! XTerm resources
    "XTerm.termName" = "xterm-256color";
    # ! Enable UTF-8 support
    "XTerm.vt100.locale" = false;
    "XTerm.vt100.utf8" = true;
    # ! Send alt instead of meta
    "XTerm.vt100.metaSendsEscape" = true;
    # ! Fix stupid backspace key sending ^H instead of ^?
    "XTerm.vt100.backarrowKey" = false;
    "XTerm.ttyModes" = "erase ^?";
  };
}
