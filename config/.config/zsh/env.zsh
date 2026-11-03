export PATH="$HOME/.local/bin:$PATH"

export EDITOR="nvim"
export VISUAL="$EDITOR"


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/mit/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/mit/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/home/mit/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/home/mit/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba shell init' !!
export MAMBA_EXE='/home/mit/miniforge3/bin/mamba';
export MAMBA_ROOT_PREFIX='/home/mit/miniforge3';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<
export PATH="/opt/cuda/bin:$PATH"

export SURYA_INFERENCE_PARALLEL=1
export SURYA_INFERENCE_CTX_PER_SLOT=8192
