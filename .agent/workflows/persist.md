---
description: Run Clawdbot gateway in a persistent background session
---
// turbo-all
1. Start the gateway in the background:
```bash
./scripts/persist.sh
```

2. To see the logs or interact with the session later:
- If using tmux: `tmux attach -t clawdbot`
- If using screen: `screen -r clawdbot`
