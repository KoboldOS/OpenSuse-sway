;;; opensuse-theme.el --- openSUSE brand colors for Emacs -*- lexical-binding: t; -*-

;;; Commentary:
;; Dark theme matching the openSUSE sway/waybar/foot setup.
;; Palette: green #73ba25, cyan #35b9ab, blue #21a4df on pine/deep blue.

;;; Code:

(deftheme opensuse "openSUSE brand colors on a deep blue background.")

(let ((deep   "#0d2530")
      (bg-alt "#112f3c")
      (pine   "#173f4f")
      (pine+  "#1f5468")
      (slate  "#4a7383")
      (muted  "#9cb7bf")
      (fg     "#e8f1f2")
      (green  "#73ba25")
      (lime   "#8fd14f")
      (cyan   "#35b9ab")
      (blue   "#21a4df")
      (red    "#e05a5a")
      (yellow "#f0c24b")
      (purple "#b07cd8"))
  (custom-theme-set-faces
   'opensuse
   ;; Basics
   `(default ((t (:background ,deep :foreground ,fg))))
   `(cursor ((t (:background ,green))))
   `(fringe ((t (:background ,deep :foreground ,slate))))
   `(region ((t (:background ,pine+ :extend t))))
   `(secondary-selection ((t (:background ,pine :extend t))))
   `(highlight ((t (:background ,pine))))
   `(hl-line ((t (:background ,bg-alt :extend t))))
   `(shadow ((t (:foreground ,slate))))
   `(vertical-border ((t (:foreground ,pine))))
   `(window-divider ((t (:foreground ,pine))))
   `(minibuffer-prompt ((t (:foreground ,green :weight bold))))
   `(link ((t (:foreground ,blue :underline t))))
   `(link-visited ((t (:foreground ,purple :underline t))))
   `(error ((t (:foreground ,red :weight bold))))
   `(warning ((t (:foreground ,yellow :weight bold))))
   `(success ((t (:foreground ,green :weight bold))))
   `(trailing-whitespace ((t (:background ,red))))
   `(escape-glyph ((t (:foreground ,cyan))))
   `(header-line ((t (:background ,pine :foreground ,fg))))

   ;; Mode line
   `(mode-line ((t (:background ,pine :foreground ,fg
                   :box (:line-width 4 :color ,pine)))))
   `(mode-line-inactive ((t (:background ,bg-alt :foreground ,muted
                            :box (:line-width 4 :color ,bg-alt)))))
   `(mode-line-buffer-id ((t (:foreground ,green :weight bold))))
   `(mode-line-emphasis ((t (:foreground ,cyan :weight bold))))
   `(mode-line-highlight ((t (:foreground ,lime :box nil))))

   ;; Line numbers
   `(line-number ((t (:foreground ,slate :background ,deep))))
   `(line-number-current-line ((t (:foreground ,green :background ,bg-alt :weight bold))))

   ;; Search / parens
   `(isearch ((t (:background ,green :foreground ,deep :weight bold))))
   `(isearch-fail ((t (:background ,red :foreground ,fg))))
   `(lazy-highlight ((t (:background ,pine+ :foreground ,fg))))
   `(match ((t (:background ,pine+ :foreground ,lime))))
   `(show-paren-match ((t (:background ,pine+ :foreground ,lime :weight bold))))
   `(show-paren-mismatch ((t (:background ,red :foreground ,fg))))

   ;; Syntax
   `(font-lock-builtin-face ((t (:foreground ,cyan))))
   `(font-lock-comment-face ((t (:foreground ,slate :slant italic))))
   `(font-lock-comment-delimiter-face ((t (:foreground ,slate :slant italic))))
   `(font-lock-doc-face ((t (:foreground ,muted :slant italic))))
   `(font-lock-constant-face ((t (:foreground ,purple))))
   `(font-lock-function-name-face ((t (:foreground ,blue))))
   `(font-lock-keyword-face ((t (:foreground ,green :weight bold))))
   `(font-lock-string-face ((t (:foreground ,lime))))
   `(font-lock-type-face ((t (:foreground ,cyan))))
   `(font-lock-variable-name-face ((t (:foreground ,fg))))
   `(font-lock-number-face ((t (:foreground ,yellow))))
   `(font-lock-preprocessor-face ((t (:foreground ,purple))))
   `(font-lock-negation-char-face ((t (:foreground ,red))))
   `(font-lock-warning-face ((t (:foreground ,yellow :weight bold))))
   `(font-lock-regexp-grouping-backslash ((t (:foreground ,yellow))))
   `(font-lock-regexp-grouping-construct ((t (:foreground ,purple))))

   ;; Completion (built-in + common packages)
   `(completions-common-part ((t (:foreground ,cyan))))
   `(completions-first-difference ((t (:foreground ,green :weight bold))))
   `(icomplete-first-match ((t (:foreground ,green :weight bold))))
   `(vertico-current ((t (:background ,pine :extend t))))
   `(orderless-match-face-0 ((t (:foreground ,green :weight bold))))
   `(orderless-match-face-1 ((t (:foreground ,cyan :weight bold))))
   `(orderless-match-face-2 ((t (:foreground ,blue :weight bold))))
   `(orderless-match-face-3 ((t (:foreground ,yellow :weight bold))))

   ;; Diff
   `(diff-added ((t (:foreground ,lime :background "#1b3a24" :extend t))))
   `(diff-removed ((t (:foreground ,red :background "#3a1f26" :extend t))))
   `(diff-changed ((t (:foreground ,yellow :extend t))))
   `(diff-header ((t (:background ,pine :foreground ,fg))))
   `(diff-file-header ((t (:background ,pine+ :foreground ,green :weight bold))))
   `(diff-hunk-header ((t (:background ,bg-alt :foreground ,cyan))))

   ;; Org
   `(org-level-1 ((t (:foreground ,green :weight bold :height 1.25))))
   `(org-level-2 ((t (:foreground ,cyan :weight bold :height 1.15))))
   `(org-level-3 ((t (:foreground ,blue :weight bold :height 1.05))))
   `(org-level-4 ((t (:foreground ,lime :weight bold))))
   `(org-level-5 ((t (:foreground ,purple))))
   `(org-level-6 ((t (:foreground ,yellow))))
   `(org-todo ((t (:foreground ,red :weight bold))))
   `(org-done ((t (:foreground ,green :weight bold))))
   `(org-date ((t (:foreground ,cyan :underline t))))
   `(org-code ((t (:foreground ,lime))))
   `(org-verbatim ((t (:foreground ,cyan))))
   `(org-block ((t (:background ,bg-alt :extend t))))
   `(org-block-begin-line ((t (:foreground ,slate :background ,bg-alt :extend t))))
   `(org-block-end-line ((t (:foreground ,slate :background ,bg-alt :extend t))))
   `(org-link ((t (:foreground ,blue :underline t))))
   `(org-table ((t (:foreground ,muted))))

   ;; Terminal colors (term, vterm, eshell, compilation)
   `(ansi-color-black ((t (:foreground ,pine :background ,pine))))
   `(ansi-color-red ((t (:foreground ,red :background ,red))))
   `(ansi-color-green ((t (:foreground ,green :background ,green))))
   `(ansi-color-yellow ((t (:foreground ,yellow :background ,yellow))))
   `(ansi-color-blue ((t (:foreground ,blue :background ,blue))))
   `(ansi-color-magenta ((t (:foreground ,purple :background ,purple))))
   `(ansi-color-cyan ((t (:foreground ,cyan :background ,cyan))))
   `(ansi-color-white ((t (:foreground ,fg :background ,fg))))
   `(ansi-color-bright-black ((t (:foreground ,slate :background ,slate))))

   ;; Misc
   `(tab-bar ((t (:background ,deep :foreground ,muted))))
   `(tab-bar-tab ((t (:background ,pine :foreground ,green :weight bold))))
   `(tab-bar-tab-inactive ((t (:background ,deep :foreground ,muted))))
   `(whitespace-space ((t (:foreground ,pine))))
   `(whitespace-tab ((t (:foreground ,pine))))
   `(eldoc-highlight-function-argument ((t (:foreground ,green :weight bold))))
   `(flymake-error ((t (:underline (:style wave :color ,red)))))
   `(flymake-warning ((t (:underline (:style wave :color ,yellow)))))
   `(flymake-note ((t (:underline (:style wave :color ,cyan)))))))

;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'opensuse)
;;; opensuse-theme.el ends here
