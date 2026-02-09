#!/bin/bash

# Moltworker Cloudflare - Anthropic Claude Deployment
# Choose between Haiku ($0.25), Sonnet ($3), or Opus ($15)

set -e

# Default model
MODEL="haiku"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --model)
            MODEL="$2"
            shift 2
            ;;
        --help)
            echo "Usage: $0 [--model haiku|sonnet|opus]"
            echo ""
            echo "Models:"
            echo "  haiku  - \$0.25/million tokens (fastest, cheapest)"
            echo "  sonnet - \$3.00/million tokens (balanced)"
            echo "  opus   - \$15.00/million tokens (most powerful, expensive)"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Set model details
case $MODEL in
    haiku)
        COST="0.25"
        MODEL_NAME="Claude 3 Haiku"
        DESCRIPTION="Fastest and most affordable Claude model"
        SAVINGS="98%"
        ;;
    sonnet)
        COST="3.00"
        MODEL_NAME="Claude 3.5 Sonnet"
        DESCRIPTION="Balanced capability and cost"
        SAVINGS="80%"
        ;;
    opus)
        COST="15.00"
        MODEL_NAME="Claude 3 Opus"
        DESCRIPTION="Most powerful Claude model (expensive!)"
        SAVINGS="0%"
        ;;
    *)
        echo "Invalid model: $MODEL"
        echo "Valid models: haiku, sonnet, opus"
        exit 1
        ;;
esac

echo "🚀 Moltworker Cloudflare - Anthropic Claude Deployment"
echo "======================================================"
echo "🤖 Model: $MODEL_NAME"
echo "💰 Cost: \$$COST per million tokens"
if [ "$MODEL" != "opus" ]; then
    echo "💸 Savings: $SAVINGS cheaper than Claude Opus!"
fi
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

# Get Anthropic API key
echo -e "${BLUE}🔑 Anthropic API Key Setup${NC}"
echo -e "${YELLOW}📝 Get your Anthropic API key from: https://console.anthropic.com${NC}"
echo -e "${YELLOW}🔑 Anthropic keys start with 'sk-ant-'${NC}"
read -p "Enter your Anthropic API key: " ANTHROPIC_KEY

if [[ -z "$ANTHROPIC_KEY" ]]; then
    echo -e "${RED}❌ No API key provided. Exiting.${NC}"
    exit 1
fi

# Validate key format
if [[ ! "$ANTHROPIC_KEY" =~ ^sk-ant- ]]; then
    echo -e "${YELLOW}⚠️  Key format may be incorrect. Expected to start with 'sk-ant-'${NC}"
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
echo "$ANTHROPIC_KEY" | npx wrangler secret put ANTHROPIC_API_KEY
echo "$MOLTBOT_GATEWAY_TOKEN" | npx wrangler secret put MOLTBOT_GATEWAY_TOKEN
echo "true" | npx wrangler secret put DEV_MODE
echo "true" | npx wrangler secret put DEBUG_ROUTES

echo -e "${GREEN}✅ Secrets set successfully${NC}"

# Deploy
WORKER_NAME="moltworker-claude-$MODEL"
echo -e "${BLUE}☁️  Deploying to Cloudflare Workers as '$WORKER_NAME'...${NC}"
npx wrangler deploy --name "$WORKER_NAME"

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
echo -e "  🤖 Provider: ${GREEN}Anthropic Claude${NC}"
echo -e "  🎯 Model: ${GREEN}$MODEL_NAME${NC}"
echo -e "  💰 Cost: ${GREEN}\$$COST per million tokens${NC}"
echo -e "  📝 Description: ${GREEN}$DESCRIPTION${NC}"
echo -e "  🔗 URL: ${YELLOW}https://$WORKER_NAME.yksanjo.workers.dev/?token=$MOLTBOT_GATEWAY_TOKEN${NC}"
echo -e "  🔐 Token: ${YELLOW}$MOLTBOT_GATEWAY_TOKEN${NC}"
echo ""
echo -e "${BLUE}📊 Cost Comparison:${NC}"
if [ "$MODEL" = "haiku" ]; then
    echo -e "  • Claude Opus: \$15.00/million tokens"
    echo -e "  • Claude Haiku: \$0.25/million tokens"
    echo -e "  • Savings:     ${GREEN}98% cheaper!${NC}"
elif [ "$MODEL" = "sonnet" ]; then
    echo -e "  • Claude Opus: \$15.00/million tokens"
    echo -e "  • Claude Sonnet: \$3.00/million tokens"
    echo -e "  • Savings:     ${GREEN}80% cheaper!${NC}"
else
    echo -e "  ⚠️  Claude Opus is the most expensive option at \$15/million tokens"
    echo -e "  💡 Consider using Haiku (\$0.25) or Sonnet (\$3.00) for cost savings"
fi
echo ""
echo -e "${BLUE}⏳ Next Steps:${NC}"
echo "  1. Wait 1-2 minutes for container to start"
echo "  2. Access the URL above"
echo "  3. Configure model in container (if needed)"
echo ""
if [ "$MODEL" = "opus" ]; then
    echo -e "${YELLOW}⚠️  WARNING: Claude Opus is very expensive!${NC}"
    echo -e "${YELLOW}💡 Consider switching to Haiku or Sonnet for regular use:${NC}"
    echo -e "${YELLOW}   ./scripts/switch-to-haiku.sh${NC}"
    echo -e "${YELLOW}   ./scripts/switch-to-sonnet.sh${NC}"
    echo ""
fi
echo -e "${BLUE}🔧 Optional Setup:${NC}"
echo "  • Run ./scripts/setup-telegram.sh for Telegram integration"
echo "  • Run ./scripts/setup-access.sh for Cloudflare Access protection"
echo "  • Run ./scripts/monitor-costs.sh to track spending (especially for Opus!)"
echo ""
echo -e "${YELLOW}💡 Tip: Use Haiku for simple tasks, Sonnet for complex reasoning!${NC}"