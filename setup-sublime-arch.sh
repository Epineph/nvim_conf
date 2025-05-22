#!/usr/bin/env bash
#
# setup-sublime-arch.sh — Automate Sublime Text configuration on Arch Linux
# with popular packages, autocompletion enhancements, Bash syntax support,
# and a default Colorsublime theme.
#
# Usage:
#   ./setup-sublime-arch.sh [--backup]
#
# Options:
#   --backup    Backup existing User settings before overwriting.
#   -h, --help  Show this help message.
#
set -euo pipefail

# -----------------------------------------------------------------------------
# Configuration paths
# -----------------------------------------------------------------------------
: "${XDG_CONFIG_HOME:=${HOME}/.config}"
CONFIG_USER_DIR="$XDG_CONFIG_HOME/sublime-text/Packages/User"
INSTALLED_PKGS_DIR="$XDG_CONFIG_HOME/sublime-text/Installed Packages"
LEGACY_USER_DIR="$HOME/.config/sublime-text-3/Packages/User"
LEGACY_INSTALLED_DIR="$HOME/.config/sublime-text-3/Installed Packages"
if [[ -d "$LEGACY_USER_DIR" && ! -d "$CONFIG_USER_DIR" ]]; then
  CONFIG_USER_DIR="$LEGACY_USER_DIR"
  INSTALLED_PKGS_DIR="$LEGACY_INSTALLED_DIR"
fi

# -----------------------------------------------------------------------------
# Parse arguments
# -----------------------------------------------------------------------------
BACKUP=false
TS=$(date +%Y%m%d%H%M%S)
case "${1:-}" in
  --backup) BACKUP=true ;;
  -h|--help) 
    cat << 'EOF'
setup-sublime-arch.sh — Automate Sublime Text configuration on Arch Linux

Usage:
  $0 [--backup]

Options:
  --backup    Backup existing Sublime Text User settings before overwriting.
  -h, --help  Show this help message.

This script will:
  1. Backup Preferences, keymaps, and Package Control settings (if requested).
  2. Install Package Control itself.
  3. Install a curated list of packages (LSP, linters, autocompletion, Bash support, theme plugins, etc.).
  4. Write core settings, keybindings, and package‐control configuration.
EOF
    exit 0
    ;;
esac

# -----------------------------------------------------------------------------
# Backup existing configs
# -----------------------------------------------------------------------------
if $BACKUP; then
  echo "Backing up existing User settings in: $CONFIG_USER_DIR"
  for f in "Preferences.sublime-settings" \
           "Package Control.sublime-settings" \
           "Default (Linux).sublime-keymap" \
           "Colorsublime.sublime-settings"; do
    if [[ -f "$CONFIG_USER_DIR/$f" ]]; then
      mv "$CONFIG_USER_DIR/$f" "$CONFIG_USER_DIR/${f}.bak-$TS"
      echo "  • $f → ${f}.bak-$TS"
    fi
  done
fi

# -----------------------------------------------------------------------------
# Ensure directories exist
# -----------------------------------------------------------------------------
mkdir -p "$CONFIG_USER_DIR" "$INSTALLED_PKGS_DIR"

# -----------------------------------------------------------------------------
# Bootstrap Package Control
# -----------------------------------------------------------------------------
echo "Installing Package Control..."
curl -fsSL "https://packagecontrol.io/Package%20Control.sublime-package" \
     -o "$INSTALLED_PKGS_DIR/Package Control.sublime-package"

# -----------------------------------------------------------------------------
# Package Control settings: curated packages list
# -----------------------------------------------------------------------------
cat > "$CONFIG_USER_DIR/Package Control.sublime-settings" << 'EOF'
{
  // Core package list
  "installed_packages": [
    "Package Control",
    "Emmet",
    "SidebarEnhancements",
    "GitGutter",
    "A File Icon",
    "Material Theme",
    "Dracula Color Scheme",
    "BracketHighlighter",
    "AutoFileName",
    "MarkdownPreview",
    "Terminus",
    "AlignTab",
    "All Autocomplete",
    "ColorHelper",

    // LSP and linters
    "LSP",
    "LSP-pyright",
    "LSP-typescript",
    "SublimeLinter",
    "SublimeLinter-flake8",
    "SublimeLinter-eslint",
    "GitSavvy",
    "DocBlockr",

    // Bash syntax and completions
    "Bash Completions",         // dynamic compgen-driven suggestions :contentReference[oaicite:2]{index=2}
    "ShellCheck",               // lint shell scripts
    "shfmt"                     // format shell scripts on save

    // Colorsublime plugin for easy theme switching
    "Colorsublime"              // thousands of community schemes :contentReference[oaicite:3]{index=3}
  ]
}
EOF

# -----------------------------------------------------------------------------
# Core Preferences
# -----------------------------------------------------------------------------
cat > "$CONFIG_USER_DIR/Preferences.sublime-settings" << 'EOF'
{
  // UI Theme and Color Scheme
  "theme": "Material-Theme-Darker.sublime-theme",
  "color_scheme": "Packages/Colorsublime-Themes/3024 (Night).sublime-color-scheme",

  // Font
  "font_face": "Fira Code",
  "font_size": 12,

  // Tabs & Indentation
  "translate_tabs_to_spaces": true,
  "tab_size": 2,
  "detect_indentation": true,

  // Whitespace cleanup
  "ensure_newline_at_eof_on_save": true,
  "trim_trailing_white_space_on_save": true,

  // Autocomplete
  "auto_complete": true,
  "auto_complete_delay": 50,
  "auto_complete_triggers":
    [
      // Provide completions when typing in shell scripts
      { "selector": "source.shell", "characters": "$" },
      // Always trigger on dot for object properties
      { "selector": "source",       "characters": "." }
    ],

  // Highlight current line and wrap text
  "highlight_line": true,
  "word_wrap": true,

  // Sidebar indentation
  "sidebar_tree_indent": 2,

  // Disable Vintage if unused
  "ignored_packages":
    ["Vintage"]
}
EOF

# -----------------------------------------------------------------------------
# Key Bindings (Linux)
# -----------------------------------------------------------------------------
cat > "$CONFIG_USER_DIR/Default (Linux).sublime-keymap" << 'EOF'
[
  // Save quickly
  { "keys": ["ctrl+s"],               "command": "save" },

  // Toggle sidebar
  { "keys": ["ctrl+k", "ctrl+b"],     "command": "toggle_side_bar" },

  // Open integrated terminal (Terminus)
  { "keys": ["ctrl+`"],               "command": "terminus_open" },

  // Wrap in quotes
  {
    "keys": ["ctrl+shift+'"],
    "command": "insert_snippet",
    "args": { "contents": "\"$SELECTION\"" }
  },

  // Quick access to Colorsublime theme picker
  {
    "keys": ["ctrl+alt+t"],
    "command": "colorsublime_install_theme"
  }
]
EOF

echo "✅ All done! Sublime Text User settings written to: $CONFIG_USER_DIR"
echo "➜ Restart Sublime Text and press Ctrl+Alt+T → select ‘3024 (Night)’ (or any other Colorsublime scheme)."

