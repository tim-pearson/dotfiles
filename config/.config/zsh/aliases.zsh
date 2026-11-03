# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ls
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -lah'

function etok(){
  cd cosagallery_web && TOKEN=$(heroku run -a cosagallery --no-notify -- python manage.py shell -c "from ebay.models import EbayOAuthToken as T; print(T.objects.latest('id').refresh_token)" | tail -n 1 | tr -d '\r\n') && sed -i.bak '/^EBAY_REFRESH_TOKEN_DEV=/d' .env-opencode && echo "EBAY_REFRESH_TOKEN_DEV=$TOKEN" >> .env-opencode && echo "updated (${#TOKEN} chars)"
}
# Neovim
alias v='nvim'

# Git
alias gs='git status'
alias ga='git add'
alias gau='git add -u'
alias gad='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gch='git checkout'
alias gcb='git switch -c'
alias mk="make -j"
alias ev="evince"
alias ls='ls --color=auto'
alias ee="exit"
alias gtr="git log --graph --all --decorate --oneline"
alias copy='wl-copy'
alias ev="evince"

# alias carla="QT_QPA_PLATFORM=xcb carla"
alias squelchbox-mpk="squelchbox --backend alsa --midi-input \"MPK Mini Mk II:MPK Mini Mk II MIDI 1 16:0\""

alias op="omarchy plugin"
alias cat="bat"

function ma(){
  mamba activate $1
  source ~/.zshrc
}
function print_files() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        echo "Error: '$dir' is not a directory"
        return 1
    fi

    find "$dir" -type f | while read -r file; do
        echo "### File: $file ###"
        cat "$file"
        echo -e "\n--- End of $file ---\n"
    done
}
function mvd() {
  local file
  file=$(ls ~/Downloads | fzf) || return
  mv ~/Downloads/"$file" .
  echo "Moved '$file' to $(pwd)"
}
function cat() {
  if [ $# -eq 0 ]; then
    command cat
    return
  fi

  check_image=true
  check_pdf=true

  for f in "$@"; do
    mime_type=$(file --mime-type -b "$f")

    if [[ "$mime_type" == image/* ]]; then
      check_pdf=false
    elif [[ "$mime_type" == application/pdf ]]; then
      check_image=false
    else
      check_image=false
      check_pdf=false
      break
    fi
  done

  if $check_image; then
    chafa "$@"
  elif $check_pdf; then
    termpdf.py "$@" >/dev/null 2>&1 &
  else
    command cat "$@"
  fi
}
function assinate(){
  kill -9 $(pidof "$1")
}

function rsync-to-dellio() {
    rsync -avh --progress "$@"  "tidy@dellio:/home/tidy/rcv_dir/"
}

function rsync-from-dellio() {
    local src="$1"
    rsync -avh --progress "tidy@dellio:${src}" "$HOME/rcv_dir/"
}

function kwin() {
  echo "Click on the window you want to kill..."
  pid=$(xprop | awk '/_NET_WM_PID\(CARDINAL\)/ { print $NF }')
  if [ -n "$pid" ]; then
    echo "Killing process with PID $pid"
    kill -9 "$pid"
  else
    echo "Could not find PID for selected window."
  fi
}

function whod() {
git log --pretty=format:%aE | sort | uniq | while read email; do
  echo "Author: $email"
  git log --author="$email" --pretty=tformat: --numstat | awk '{add+=$1; del+=$2} END {printf "Added: %d, Deleted: %d\n\n", add, del}'
done
}


function printit() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: printit <file|directory>"
        return 1
    fi

    local target="$1"

    if [[ -f "$target" ]]; then
        lp "$target"
    elif [[ -d "$target" ]]; then
        find "$target" -maxdepth 1 -type f -print0 |
            while IFS= read -r -d '' file; do
                lp "$file"
            done
    else
        echo "Not a file or directory: $target"
        return 1
    fi
}

function ginit() {
    if [[ -z "$1" ]]; then
        echo "Usage: ginit <repo-name>"
        return 1
    fi

    local repo="$1"

    git init -b main || return 1

    [[ -f README.md ]] || printf '# %s\n' "$repo" > README.md
    [[ -f .gitignore ]] || cat > .gitignore <<'EOF'
.env
.env.*
!.env.example
__pycache__/
*.py[cod]
.venv/
venv/
node_modules/
dist/
build/
.DS_Store
EOF

    git add README.md .gitignore
    git add -A
    git commit -m "Initial commit" || return 1

    gh repo create "$repo" --source=. --remote=origin --push --public
}
function pdfpages() {
    if [[ $# -ne 4 ]]; then
        echo "Usage: pdfpages input.pdf start_label end_label suffix"
        return 1
    fi

    local input="$1"
    local start="$2"
    local end="$3"
    local suffix="$4"
    local output="${input%.pdf}-${suffix}.pdf"

    python - "$input" "$start" "$end" "$output" <<'PY'
import sys
import fitz

src, start, end, output = sys.argv[1:]
doc = fitz.open(src)

labels = [
    doc[i].get_label() or str(i + 1)
    for i in range(len(doc))
]

try:
    first = labels.index(start)
    last = labels.index(end)
except ValueError as e:
    print(f"Page label not found: {e}")
    sys.exit(1)

if first > last:
    print("Start label comes after end label.")
    sys.exit(1)

out = fitz.open()
out.insert_pdf(doc, from_page=first, to_page=last)
out.save(output)
print(f"Saved {output}: labels {start}–{end} ({last-first+1} pages)")
PY
}





# OCR one section PDF into its own output directory.
function ocrsection() {
    if [[ $# -ne 1 || ! -f "$1" ]]; then
        echo 'Usage: ocrsection section.pdf'
        return 1
    fi

    local input="$1"
    local name="${input:t:r}"
    local out="$PWD/ocr/$name"

    if [[ -f "$out/$name.md" ]]; then
        echo "Already OCR'd: $out/$name.md"
        echo "Delete '$out' to redo it."
        return 1
    fi

    mkdir -p "$out" || return 1

    echo "Running Marker on: $input"
    echo "Output: $out"

    SURYA_INFERENCE_BACKEND=llamacpp \
        marker_single "$input" --output_dir "$out"
}


alias ghost-arcade="__NV_PRIME_RENDER_OFFLOAD=1 \
__GLX_VENDOR_LIBRARY_NAME=nvidia \
__VK_LAYER_NV_optimus=NVIDIA_only \
./Ghost-Arcade-Studio-2.0.4-x86_64.AppImage --ozone-platform=x11"


function catenv() {
    sed -E 's/=.*/=xxxx/' "${1:-.env}"
}

