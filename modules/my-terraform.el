;;; my-terraform.el --- Terraform support -*- lexical-binding: t; -*-

;;; Code:

(use-package terraform-mode
  :hook (terraform-mode . lsp))

(provide 'my-terraform)
;;; my-terraform.el ends here
