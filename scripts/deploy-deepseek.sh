#!/bin/bash

# Moltworker Cloudflare - DeepSeek Deployment
# Most affordable option: $0.14/million tokens

set -e

echo "🚀 Moltworker Cloudflare - DeepSeek Deployment"
echo "=============================================="
echo "💰 Cost: $0.14 per million tokens (99% cheaper than Claude Opus!)"
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

if ! command -v npx &> /dev/null; then
    echo -e "${YELLOW}⚠️  npx not found, installing...${NC}"
    npm install -g npx
fi

# Check Cloudflare login
echo -e "${BLUE}🔐 Checking Cloudflare authentication...${NC}"
if ! npx wrangler whoami &> /dev/null; then
    echo -e "${YELLOW}⚠️  Not logged in to Cloudflare. Please log in:${NC}"
    npx wrangler login
fi

# Get DeepSeek API key
echo -e "${BLUE}🔑 DeepSeek API Key Setup${NC}"
echo -e "${YELLOW}📝 Get your DeepSeek API key from: https://platform.deepseek.com${NC}"
echo -e "${YELLOW}💡 DeepSeek keys start with 'sk-' followed by 32 characters${NC}"
read -p "Enter your DeepSeek API key: " DEEPSEEK_KEY

if [[ -z "$DEEPSEEK_KEY" ]]; then
    echo -e "${RED}❌ No API key provided. Exiting.${NC}"
    exit 1
fi

# Validate key format
if [[ ! "$DEEPSEEK_KEY" =~ ^sk-[a-zA-Z0-9]{32}$ ]]; then
    echo -e "${YELLOW}⚠️  Key format may be incorrect. Expected: sk- followed by 32 alphanumeric characters${NC}"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
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
echo "$DEEPSEEK_KEY" | npx wrangler secret put DEEPSEEK_API_KEY
echo "$MOLTBOT_GATEWAY_TOKEN" | npx wrangler secret put MOLTBOT_GATEWAY_TOKEN
echo "true" | npx wrangler secret put DEV_MODE
echo "true" | npx wrangler secret put DEBUG_ROUTES

echo -e "${GREEN}✅ Secrets set successfully${NC}"

# Deploy
echo -e "${BLUE}☁️  Deploying to Cloudflare Workers...${NC}"
npx wrangler deploy --name moltworker-deepseek

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
echo -e "  🤖 Provider: ${GREEN}DeepSeek${NC} (most affordable)"
echo -e "  💰 Cost: ${GREEN}$0.14 per million tokens${NC}"
echo -e "  🔗 URL: ${YELLOW}https://moltworker-deepseek.yksanjo.workers.dev/?token=$MOLTBOT_GATEWAY_TOKEN${NC}"
echo -e "  🔐 Token: ${YELLOW}$MOLTBOT_GATEWAY_TOKEN${NC}"
echo ""
echo -e "${BLUE}📊 Cost Comparison:${NC}"
echo -e "  • Claude Opus: \$15.00/million tokens"
echo -e "  • DeepSeek:    \$0.14/million tokens"
echo -e "  • Savings:     ${GREEN}99% cheaper!${NC}"
echo ""
echo -e "${BLUE}⏳ Next Steps:${NC}"
echo "  1. Wait 1-2 minutes for container to start"
echo "  2. Access the URL above"
echo "  3. Start chatting with your affordable AI agent!"
echo ""
echo -e "${BLUE}🔧 Optional Setup:${NC}"
echo "  • Run ./scripts/setup-telegram.sh for Telegram integration"
echo "  • Run ./scripts/setup-access.sh for Cloudflare Access protection"
echo "  • Run ./scripts/monitor-costs.sh to track spending"
echo ""
echo -e "${YELLOW}💡 Tip: DeepSeek is excellent for coding tasks and general Q&A!${NC}"