#!/bin/bash

# Moltworker Cloudflare - Kimi/Moonshot AI Deployment
# Excellent for Chinese/English: $0.60/million tokens

set -e

echo "🚀 Moltworker Cloudflare - Kimi/Moonshot AI Deployment"
echo "======================================================"
echo "💰 Cost: $0.60 per million tokens (96% cheaper than Claude Opus!)"
echo "🌙 Features: 128K context window, excellent Chinese/English support"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if we're in the right directory
if [ ! -f "../package.json" ]; then
    echo -e "${RED}❌ Error: Please run this script from the scripts/ directory${NC}"
    exit 1
fi

cd ..

# Check dependencies
echo -e "${BLUE}🔍 Checking dependencies...${NC}"
if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm not found. Please install Node.js and npm.${NC}"
    exit 1
fi

# Check Cloudflare login
echo -e "${BLUE}🔐 Checking Cloudflare authentication...${NC}"
if ! npx wrangler whoami &> /dev/null; then
    echo -e "${YELLOW}⚠️  Not logged in to Cloudflare. Please log in:${NC}"
    npx wrangler login
fi

# Get Kimi API key
echo -e "${BLUE}🔑 Kimi/Moonshot API Key Setup${NC}"
echo -e "${YELLOW}📝 Get your Kimi API key from: https://platform.moonshot.cn${NC}"
echo -e "${YELLOW}🌐 Note: Kimi is a Chinese AI provider with excellent bilingual support${NC}"
read -p "Enter your Kimi API key: " KIMI_KEY

if [[ -z "$KIMI_KEY" ]]; then
    echo -e "${RED}❌ No API key provided. Exiting.${NC}"
    exit 1
fi

# Generate gateway token
echo -e "${BLUE}🔐 Generating secure gateway token...${NC}"
MOLTBOT_GATEWAY_TOKEN=$(openssl rand -base64 32 | tr -d '=+/' | head -c 32)
echo -e "${GREEN}✅ Gateway token generated${NC}"
echo -e "${YELLOW}📝 SAVE THIS TOKEN: $MOLTBOT_GATEWAY_TOKEN${NC}"
echo -e "${YELLOW}⚠️  You'll need this token to access your Moltbot!${NC}"

# Build the project
echo -e "${BLUE}🔨 Building project...${NC}"
npm run build
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Build failed${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Build successful${NC}"

# Set secrets
echo -e "${BLUE}🔑 Setting Cloudflare secrets...${NC}"
echo "$KIMI_KEY" | npx wrangler secret put KIMI_API_KEY
echo "$MOLTBOT_GATEWAY_TOKEN" | npx wrangler secret put MOLTBOT_GATEWAY_TOKEN
echo "true" | npx wrangler secret put DEV_MODE
echo "true" | npx wrangler secret put DEBUG_ROUTES

echo -e "${GREEN}✅ Secrets set successfully${NC}"

# Deploy
echo -e "${BLUE}☁️  Deploying to Cloudflare Workers...${NC}"
npx wrangler deploy --name moltworker-kimi

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Deployment successful!${NC}"
else
    echo -e "${RED}❌ Deployment failed${NC}"
    exit 1
fi

# Summary
echo ""
echo -e "${GREEN}🎉 DEPLOYMENT COMPLETE!${NC}"
echo "================================="
echo ""
echo -e "${BLUE}📋 Your Moltbot Details:${NC}"
echo -e "  🤖 Provider: ${GREEN}Kimi/Moonshot AI${NC}"
echo -e "  💰 Cost: ${GREEN}$0.60 per million tokens${NC}"
echo -e "  🌐 Context: ${GREEN}128K tokens${NC}"
echo -e "  🈷️  Language: ${GREEN}Excellent Chinese/English support${NC}"
echo -e "  🔗 URL: ${YELLOW}https://moltworker-kimi.yksanjo.workers.dev/?token=$MOLTBOT_GATEWAY_TOKEN${NC}"
echo -e "  🔐 Token: ${YELLOW}$MOLTBOT_GATEWAY_TOKEN${NC}"
echo ""
echo -e "${BLUE}📊 Cost Comparison:${NC}"
echo -e "  • Claude Opus: \$15.00/million tokens"
echo -e "  • Kimi:        \$0.60/million tokens"
echo -e "  • Savings:     ${GREEN}96% cheaper!${NC}"
echo ""
echo -e "${BLUE}🌟 Kimi Features:${NC}"
echo "  • 128K context window (long conversations)"
echo "  • Excellent Chinese/English bilingual support"
echo "  • OpenAI-compatible API"
echo "  • Good for coding, writing, and analysis"
echo ""
echo -e "${BLUE}⏳ Next Steps:${NC}"
echo "  1. Wait 1-2 minutes for container to start"
echo "  2. Access the URL above"
echo "  3. Try both English and Chinese conversations!"
echo ""
echo -e "${BLUE}🔧 Optional Setup:${NC}"
echo "  • Run ./scripts/setup-telegram.sh for Telegram integration"
echo "  • Run ./scripts/setup-access.sh for Cloudflare Access protection"
echo ""
echo -e "${YELLOW}💡 Tip: Kimi is perfect for bilingual tasks and long conversations!${NC}"