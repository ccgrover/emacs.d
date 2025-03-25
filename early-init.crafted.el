(setenv "LSP_USE_PLISTS" "true")
(defvar crafted-emacs-home "~/workspace/crafted-emacs"
  "The directory where CraftedEmacs was cloned")
(load (expand-file-name "modules/crafted-early-init-config" crafted-emacs-home))
