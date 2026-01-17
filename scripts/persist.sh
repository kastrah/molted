#!/bin/bash
# scripts/persist.sh - Keep Clawdbot gateway running in the background

SESSION_NAME="clawdbot"
CMD="npm run dev -- gateway --force"

# 1. Check for tmux (preferred) or screen
if command -v tmux >/dev/null 2>&1; then
    echo "Using tmux to start persistent session..."
    tmux has-session -t $SESSION_NAME 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "Session '$SESSION_NAME' already exists. Killing it first..."
        tmux kill-session -t $SESSION_NAME
    fi
    tmux new-session -d -s $SESSION_NAME "$CMD"
    echo "Clawdbot started in tmux session '$SESSION_NAME'."
    echo "To view: tmux attach -t $SESSION_NAME"
    echo "To detach: Ctrl+B then D"
elif command -v screen >/dev/null 2>&1; then
    echo "Using screen to start persistent session..."
    screen -S $SESSION_NAME -X quit >/dev/null 2>&1
    screen -dmS $SESSION_NAME bash -c "$CMD"
    echo "Clawdbot started in screen session '$SESSION_NAME'."
    echo "To view: screen -r $SESSION_NAME"
    echo "To detach: Ctrl+A then D"
else
    echo "Neither tmux nor screen found. Please install one (e.g., brew install tmux)."
    exit 1
fi
