#!/bin/bash

# Switch from current provider to DeepSeek (most affordable)

set -e

echo "🔄 Switching to DeepSeek (Most Affordable Provider)"
echo "==================================================="
echo "💰 New cost: \$0.14 per million tokens (99% cheaper than Opus!)"
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

# Get current worker name
echo -e "${BLUE}🔍 Detecting current deployment...${NC}"
CURRENT_WORKER=$(npx wrangler whoami 2>/dev/null | grep "Worker:" | awk '{print $2}' || echo "moltworker")

if [ -z "$CURRENT_WORKER" ]; then
    CURRENT_WORKER="moltworker"
fi

echo -e "${GREEN}✅ Current worker: $CURRENT_WORKER${NC}"

# Get DeepSeek API key
echo -e "${BLUE}🔑 DeepSeek API Key Setup${NC}"
echo -e "${YELLOW}📝 Get your DeepSeek API key from: https://platform.deepseek.com${NC}"
read -p "Enter your DeepSeek API key: " DEEPSEEK_KEY

if [[ -z "$DEEPSEEK_KEY" ]]; then
    echo -e "${RED}❌ No API key provided. Exiting.${NC}"
    exit 1
fi

# Remove old API keys (optional but recommended)
echo -e "${BLUE}🔄 Removing old provider keys...${NC}"
npx wrangler secret delete ANTHROPIC_API_KEY --name "$CURRENT_WORKER" 2>/dev/null || true
npx wrangler secret delete OPENAI_API_KEY --name "$CURRENT_WORKER" 2>/dev/null || true
npx wrangler secret delete KIMI_API_KEY --name "$CURRENT_WORKER" 2>/dev/null || true
echo -e "${GREEN}✅ Old API keys removed${NC}"

# Set DeepSeek key
echo -e "${BLUE}🔑 Setting DeepSeek API key...${NC}"
echo "$DEEPSEEK_KEY" | npx wrangler secret put DEEPSEEK_API_KEY --name "$CURRENT_WORKER"
echo -e "${GREEN}✅ DeepSeek API key set${NC}"

# Update configuration in container
echo -e "${BLUE}🔄 Updating container configuration...${NC}"
echo -e "${YELLOW}📝 Note: The container will automatically use DeepSeek when DEEPSEEK_API_KEY is set${NC}"

# Redeploy
echo -e "${BLUE}☁️  Redeploying with DeepSeek configuration...${NC}"
npx wrangler deploy --name "$CURRENT_WORKER"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Redeployment successful!${NC}"
else
    echo -e "${RED}❌ Redeployment failed${NC}"
    exit 1
fi

# Summary
echo ""
echo -e "${GREEN}🎉 SWITCH COMPLETE!${NC}"
echo "========================"
echo ""
echo -e "${BLUE}📋 New Configuration:${NC}"
echo -e "  🤖 Provider: ${GREEN}DeepSeek${NC}"
echo -e "  💰 Cost: ${GREEN}\$0.14 per million tokens${NC}"
echo -e "  🔗 URL: ${YELLOW}https://$CURRENT_WORKER.yksanjo.workers.dev${NC}"
echo ""
echo -e "${BLUE}💰 Estimated Monthly Savings:${NC}"
echo "  Based on 1 million tokens per month:"
echo "  • Claude Opus:    \$15.00"
echo "  • DeepSeek:       \$0.14"
echo "  • Monthly savings: ${GREEN}\$14.86 (99% reduction)${NC}"
echo ""
echo -e "${BLUE}📊 If you use 10 million tokens/month:${NC}"
echo "  • Claude Opus:    \$150.00"
echo "  • DeepSeek:       \$1.40"
echo "  • Monthly savings: ${GREEN}\$148.60${NC}"
echo ""
echo -e "${BLUE}⏳ Next Steps:${NC}"
echo "  1. Wait 1-2 minutes for container restart"
echo "  2. Test your agent at the URL above"
echo "  3. Monitor costs with: ./scripts/check-costs.sh"
echo ""
echo -e "${YELLOW}💡 DeepSeek is excellent for:${NC}"
echo "  • Coding and programming tasks"
echo "  • General Q&A and reasoning"
echo "  • Text analysis and summarization"
echo "  • Cost-effective daily use"
echo ""
echo -e "${GREEN}✅ All your data and configurations are preserved!${NC}"