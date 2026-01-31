#!/bin/bash
set -e

# Deployment configuration
SERVICE_NAME="moltbot" # Adjust if your service is named 'openclaw' or 'clawdbot'
REPO_DIR="$(pwd)"

echo "🚀 Starting VPS OpenClaw Update..."

# 1. Stash any local changes on VPS (just in case)
echo "📦 Stashing local changes..."
git stash push -m "Pre-update stash $(date)"

# 2. Pull latest changes
echo "⬇️ Pulling from origin..."
git pull origin main

# 3. Clean install dependencies
echo "🧶 Installing dependencies..."
pnpm install

# 4. Build the project
echo "🛠️ Building project..."
pnpm build

# 5. Verify the build
echo "✅ Verifying build..."
if [ ! -f "dist/index.js" ]; then
    echo "❌ Build failed: dist/index.js not found!"
    exit 1
fi

# 6. Service Management
echo "🔄 Managing system service..."

if systemctl list-units --full -all | grep -Fq "$SERVICE_NAME.service"; then
    echo "   Found service: $SERVICE_NAME.service"
    
    # Check if we need to update ExecStart (simple check)
    SERVICE_FILE=$(systemctl show -p FragmentPath "$SERVICE_NAME.service" | cut -d= -f2)
    
    if [ -f "$SERVICE_FILE" ]; then
        if grep -q "bin/moltbot" "$SERVICE_FILE"; then
            echo "⚠️  WARNING: Service is pointing to legacy bin/moltbot."
            echo "   Please update $SERVICE_FILE to point to 'dist/index.js' or 'openclaw.mjs'."
            echo "   Example: ExecStart=/usr/bin/node $REPO_DIR/dist/index.js gateway"
        else
            echo "   Service configuration looks compatible."
        fi
    fi

    echo "   Restarting $SERVICE_NAME..."
    sudo systemctl restart "$SERVICE_NAME"
    echo "   ✅ Service restarted."
else
    echo "⚠️  Service '$SERVICE_NAME' not found in systemd."
    echo "   If you use a different name, please restart it manually:"
    echo "   sudo systemctl restart <your-service-name>"
fi

echo "🎉 Update complete! OpenClaw is running."
echo "ℹ️  Config files in '~/.moltbot' (or legacy paths) are automatically detected."
