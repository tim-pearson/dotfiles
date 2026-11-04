local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

local function filename()
  return vim.fn.expand("%:t")
end

return {
  -- Shebangs and script setup
  s("shebang", {
    t({ "#!/usr/bin/env bash", "" }),
  }),

  s("shebangz", {
    t({ "#!/usr/bin/env zsh", "" }),
  }),

  s("strict", {
    t({
      "set -Eeuo pipefail",
      "",
      "trap '",
    }),
    i(1, "echo \"Error on line $LINENO\" >&2"),
    t("' ERR"),
    t({ "", "" }),
    i(0),
  }),

  s("source", {
    t('source "'),
    i(1, "~/.config/somefile"),
    t('"'),
  }),

  s("export", {
    t("export "),
    i(1, "VARIABLE"),
    t("="),
    i(2, '"value"'),
  }),

  s("env", {
    t("env "),
    i(1, "VARIABLE=value"),
    t(" "),
    i(0, "command"),
  }),

  -- Variables and expansion
  s("var", {
    t("local "),
    i(1, "name"),
    t("="),
    i(2, '"value"'),
  }),

  s("read", {
    t("read -r -p "),
    i(1, '"Enter value: "'),
    t(" "),
    i(2, "value"),
  }),

  s("readonly", {
    t("readonly "),
    i(1, "NAME"),
    t("="),
    i(2, '"value"'),
  }),

  s("default", {
    t("${"),
    i(1, "VARIABLE"),
    t(":-"),
    i(2, "default"),
    t("}"),
  }),

  s("assigndefault", {
    t("${"),
    i(1, "VARIABLE"),
    t(":="),
    i(2, "default"),
    t("}"),
  }),

  s("param", {
    t("${"),
    i(1, "VARIABLE"),
    t("}"),
  }),

  s("cmdsub", {
    t("$("),
    i(0, "command"),
    t(")"),
  }),

  s("arith", {
    t("$(("),
    i(1, "a"),
    t(" + "),
    i(2, "b"),
    t("))"),
  }),

  -- Conditionals
  s("if", {
    t("if "),
    i(1, "[[ condition ]]"),
    t({ "; then", "    " }),
    i(0),
    t({ "", "fi" }),
  }),

  s("ife", {
    t("if "),
    i(1, "[[ condition ]]"),
    t({ "; then", "    " }),
    i(2),
    t({ "", "else", "    " }),
    i(0),
    t({ "", "fi" }),
  }),

  s("elif", {
    t("elif "),
    i(1, "[[ condition ]]"),
    t({ "; then", "    " }),
    i(0),
  }),

  s("case", {
    t("case "),
    i(1, '"$variable"'),
    t({ " in", "    " }),
    i(2, "pattern"),
    t({ ")", "        " }),
    i(3, "commands"),
    t({ "", "        ;;", "    *)", "        " }),
    i(4, "echo \"Unknown option\" >&2"),
    t({ "", "        exit 1", "        ;;", "esac" }),
  }),

  -- Loops
  s("for", {
    t("for "),
    i(1, "item"),
    t(" in "),
    i(2, '"$@"'),
    t({ "; do", "    " }),
    i(0),
    t({ "", "done" }),
  }),

  s("fori", {
    t("for (( i = "),
    i(1, "0"),
    t("; i < "),
    i(2, "10"),
    t({ "; i++ )); do", "    " }),
    i(0),
    t({ "", "done" }),
  }),

  s("forf", {
    t('for file in '),
    i(1, '"*.txt"'),
    t({ "; do", '    [[ -e "$file" ]] || continue', "    " }),
    i(0),
    t({ "", "done" }),
  }),

  s("while", {
    t("while "),
    i(1, "[[ condition ]]"),
    t({ "; do", "    " }),
    i(0),
    t({ "", "done" }),
  }),

  s("until", {
    t("until "),
    i(1, "[[ condition ]]"),
    t({ "; do", "    " }),
    i(0),
    t({ "", "done" }),
  }),

  -- Functions
  s("fn", {
    t("function "),
    i(1, "name"),
    t({ "() {", "    " }),
    i(0),
    t({ "", "}" }),
  }),

  s("fnargs", {
    t("function "),
    i(1, "name"),
    t({ "() {", '    local arg1="${1:?Missing argument 1}"', "    " }),
    i(0),
    t({ "", "}" }),
  }),

  s("usage", {
    t({ "usage() {", '    echo "Usage: ${0##*/} ' }),
    i(1, "[options]"),
    t({ '" >&2', "}", "" }),
  }),

  -- Exit status and error handling
  s("check", {
    t("if "),
    i(1, "command"),
    t({ "; then", "    " }),
    i(2, "echo \"Success\""),
    t({ "", "else", "    " }),
    i(0, 'echo "Failed" >&2'),
    t({ "", "    exit 1", "fi" }),
  }),

  s("die", {
    t('printf "%s\\n" '),
    i(1, '"Error message"'),
    t(" >&2"),
    t({ "", "exit " }),
    i(0, "1"),
  }),

  s("trap", {
    t("trap '"),
    i(1, "cleanup"),
    t("' "),
    i(2, "EXIT"),
  }),

  s("cleanup", {
    t({ "cleanup() {", "    " }),
    i(0, "# Cleanup temporary files or resources"),
    t({ "", "}", "" }),
  }),

  s("debug", {
    t('printf "%s\\n" '),
    i(1, '"variable=$variable"'),
    t(" >&2"),
  }),

  s("status", {
    t("if (($? != 0)); then"),
    t({ "", "    " }),
    i(0, 'echo "Command failed" >&2'),
    t({ "", "fi" }),
  }),

  -- Files and directories
  s("mkcd", {
    t("mkdir -p -- "),
    i(1, '"directory"'),
    t(" && cd -- "),
    rep(1),
  }),

  s("cdprev", {
    t("cd -"),
  }),

  s("findf", {
    t("find "),
    i(1, "."),
    t(" -type f -name "),
    i(2, '"*.txt"'),
    t(" "),
    i(0),
  }),

  s("findd", {
    t("find "),
    i(1, "."),
    t(" -type d -name "),
    i(2, '"name"'),
  }),

  s("grep", {
    t("grep -RIn --exclude-dir=.git "),
    i(1, '"pattern"'),
    t(" "),
    i(0, "."),
  }),

  s("copy", {
    t("cp -av -- "),
    i(1, "source"),
    t(" "),
    i(0, "destination"),
  }),

  s("move", {
    t("mv -iv -- "),
    i(1, "source"),
    t(" "),
    i(0, "destination"),
  }),

  s("remove", {
    t("rm -Iv -- "),
    i(0, "path"),
  }),

  s("symlink", {
    t("ln -sfn -- "),
    i(1, "target"),
    t(" "),
    i(0, "link"),
  }),

  s("archive", {
    t("tar -czf "),
    i(1, "archive.tar.gz"),
    t(" "),
    i(0, "directory"),
  }),

  s("extract", {
    t("tar -xzf "),
    i(0, "archive.tar.gz"),
  }),

  -- Processes and system administration
  s("psgrep", {
    t("ps aux | grep -i -- "),
    i(0, '"process"'),
  }),

  s("killport", {
    t("sudo fuser -k "),
    i(1, "8080"),
    t("/tcp"),
  }),

  s("port", {
    t("ss -ltnp | grep -E "),
    i(0, '" :8080|:3000"'),
  }),

  s("disk", {
    t("df -h"),
  }),

  s("du", {
    t("du -sh "),
    i(0, "directory"),
  }),

  s("mem", {
    t("free -h"),
  }),

  s("journal", {
    t("journalctl -b -u "),
    i(0, "service"),
  }),

  s("systemctl", {
    t("systemctl status "),
    i(0, "service"),
  }),

  -- Git
  s("gs", {
    t("git status --short --branch"),
  }),

  s("gd", {
    t("git diff"),
  }),

  s("gds", {
    t("git diff --staged"),
  }),

  s("glog", {
    t("git log --oneline --decorate --graph -"),
    i(0, "20"),
  }),

  s("gac", {
    t("git add -A && git commit -m "),
    i(0, '"message"'),
  }),

  s("gpush", {
    t("git push -u origin "),
    i(0, "HEAD"),
  }),

  -- Docker
  s("dps", {
    t("docker ps --format "),
    i(0, '"table {{.Names}}\\t{{.Status}}\\t{{.Ports}}"'),
  }),

  s("dlogs", {
    t("docker logs --tail 100 -f "),
    i(0, "container"),
  }),

  s("dexec", {
    t("docker exec -it "),
    i(1, "container"),
    t(" "),
    i(0, "bash"),
  }),

  s("dcompose", {
    t("docker compose "),
    i(0, "up -d"),
  }),

  -- Networking
  s("curl", {
    t("curl -fsSL "),
    i(0, "https://example.com"),
  }),

  s("wget", {
    t("wget -O "),
    i(1, "output"),
    t(" "),
    i(0, "https://example.com"),
  }),

  s("ssh", {
    t("ssh "),
    i(1, "user@host"),
    t(" "),
    i(0),
  }),

  s("rsync", {
    t("rsync -avh --progress "),
    i(1, "source"),
    t(" "),
    i(0, "destination"),
  }),

  -- Zsh-specific conveniences
  s("zpath", {
    t('path+=("'),
    i(0, "$HOME/bin"),
    t('")'),
  }),

  s("zalias", {
    t("alias "),
    i(1, "name"),
    t("="),
    i(0, "'command'"),
  }),

  s("zbind", {
    t("bindkey "),
    i(1, '"^X^E"'),
    t(" "),
    i(0, "edit-command-line"),
  }),

  s("zautoload", {
    t("autoload -Uz "),
    i(0, "edit-command-line"),
  }),

  s("zfunc", {
    t("function "),
    i(1, "name"),
    t({ "() {", "    " }),
    i(0),
    t({ "", "}" }),
  }),

  s("zsource", {
    t('[[ -f "'),
    i(1, "$HOME/.config/zsh/"),
    t('" ]] && source "'),
    rep(1),
    t('"'),
  }),
  -- Find: execute commands on matching files
  s("fexec", {
    t("find "),
    i(1, "."),
    t(" -type f -name "),
    i(2, '"*.cpp"'),
    t({ " -exec " }),
    i(3, "command"),
    t({ " {} +" }),
  }),

  s("fexec1", {
    t("find "),
    i(1, "."),
    t(" -type f -name "),
    i(2, '"*.cpp"'),
    t(" -exec "),
    i(3, "command"),
    t(" {} \\;"),
  }),

  s("fdelete", {
    t("find "),
    i(1, "."),
    t(" -type f -name "),
    i(2, '"*.tmp"'),
    t(" -delete"),
  }),

  s("fprint", {
    t("find "),
    i(1, "."),
    t(" -type f -name "),
    i(2, '"*.cpp"'),
    t(" -print"),
  }),

  s("fsize", {
    t("find "),
    i(1, "."),
    t(" -type f -size +"),
    i(2, "100M"),
    t(" -exec ls -lh {} +"),
  }),

  s("fnew", {
    t("find "),
    i(1, "."),
    t(" -type f -mmin -"),
    i(2, "60"),
    t(" -print"),
  }),

  s("fdepth", {
    t("find "),
    i(1, "."),
    t(" -mindepth "),
    i(2, "1"),
    t(" -maxdepth "),
    i(3, "2"),
    t(" -type f -print"),
  }),

  -- Process files from a directory
  s("eachf", {
    t("find "),
    i(1, "."),
    t(" -maxdepth 1 -type f -name "),
    i(2, '"*.cpp"'),
    t({ " -exec sh -c '", "for file do", "    " }),
    i(3, "command"),
    t({ ' "$file"', "done" }),
    t("' sh {} +"),
  }),

  s("eachr", {
    t("find "),
    i(1, "."),
    t(" -type f -name "),
    i(2, '"*.cpp"'),
    t(" -exec "),
    i(3, "command"),
    t(" {} +"),
  }),

  -- Process files selected through a pipeline
  s("xargs", {
    t("xargs -r -I {} "),
    i(1, "command"),
    t(" {}"),
  }),

  s("xargs0", {
    t("xargs -0 -r -I {} "),
    i(1, "command"),
    t(" {}"),
  }),

  s("pipefiles", {
    t("find "),
    i(1, "."),
    t(" -maxdepth 1 -type f -name "),
    i(2, '"*.cpp"'),
    t({ " -print0 | xargs -0 -r -I {} ", "" }),
    i(0, "command {}"),
  }),

  s("whilefiles", {
    t({ "while IFS= read -r -d '' file; do", "    " }),
    i(1, "command \"$file\""),
    t({ "", "done < <(find " }),
    i(2, "."),
    t(" -type f -name "),
    i(3, '"*.cpp"'),
    t(" -print0)"),
  }),

  -- Filter command output, then process matching paths
  s("grepx", {
    t("grep -E "),
    i(1, '"\\.cpp$"'),
    t(" | "),
    i(0, "xargs -r -I {} command {}"),
  }),

  s("awkx", {
    t("awk "),
    i(1, "'/\\.cpp$/ { print $0 }'"),
    t(" | "),
    i(0, "xargs -r -I {} command {}"),
  }),

  -- List and filter files safely
  s("lsgrep", {
    t("ls -1 | grep -E "),
    i(0, '"\\.cpp$"'),
  }),

  s("findgrep", {
    t("find "),
    i(1, "."),
    t(" -type f | grep -E "),
    i(0, '"\\.cpp$"'),
  }),

  s("findnot", {
    t("find "),
    i(1, "."),
    t(" -type f ! -name "),
    i(0, '"*.o"'),
  }),

  s("findor", {
    t("find "),
    i(1, "."),
    t(" -type f \\( -name "),
    i(2, '"*.cpp"'),
    t(" -o -name "),
    i(3, '"*.hpp"'),
    t(" \\)"),
  }),

  s("findperm", {
    t("find "),
    i(1, "."),
    t(" -type f -perm /"),
    i(0, "111"),
  }),

  s("findempty", {
    t("find "),
    i(1, "."),
    t(" -type f -empty"),
  }),

  s("findexecdir", {
    t("find "),
    i(1, "."),
    t(" -type f -name "),
    i(2, '"*.cpp"'),
    t(" -execdir "),
    i(3, "command"),
    t(" {} +"),
  }),
}
