#!/bin/bash

# Check AI API costs and usage

set -e

echo "💰 AI Cost Monitoring Tool"
echo "=========================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Provider cost per million tokens
declare -A COST_PER_MILLION=(
    ["deepseek"]="0.14"
    ["kimi"]="0.60"
    ["claude-haiku"]="0.25"
    ["claude-sonnet"]="3.00"
    ["claude-opus"]="15.00"
    ["gpt-3.5-turbo"]="0.50"
    ["gpt-4"]="30.00"
)

# Provider names
declare -A PROVIDER_NAMES=(
    ["deepseek"]="DeepSeek"
    ["kimi"]="Kimi/Moonshot"
    ["claude-haiku"]="Claude Haiku"
    ["claude-sonnet"]="Claude Sonnet"
    ["claude-opus"]="Claude Opus"
    ["gpt-3.5-turbo"]="GPT-3.5 Turbo"
    ["gpt-4"]="GPT-4"
)

# Detect current provider
detect_provider() {
    echo -e "${BLUE}🔍 Detecting current AI provider...${NC}"
    
    # Check which API key is set
    if npx wrangler secret get DEEPSEEK_API_KEY 2>/dev/null | grep -q "sk-"; then
        echo "deepseek"
    elif npx wrangler secret get KIMI_API_KEY 2>/dev/null | grep -q "."; then
        echo "kimi"
    elif npx wrangler secret get ANTHROPIC_API_KEY 2>/dev/null | grep -q "sk-ant-"; then
        # Need to check which Anthropic model is configured
        # For now, assume Haiku (cheapest)
        echo "claude-haiku"
    elif npx wrangler secret get OPENAI_API_KEY 2>/dev/null | grep -q "sk-"; then
        # Assume GPT-3.5 Turbo (cheapest OpenAI)
        echo "gpt-3.5-turbo"
    else
        echo "unknown"
    fi
}

# Calculate costs
calculate_costs() {
    local provider=$1
    local tokens=$2
    
    local cost_per_million=${COST_PER_MILLION[$provider]}
    local provider_name=${PROVIDER_NAMES[$provider]}
    
    if [ -z "$cost_per_million" ]; then
        echo -e "${RED}❌ Unknown provider: $provider${NC}"
        return 1
    fi
    
    # Calculate cost
    local cost=$(echo "scale=4; $tokens * $cost_per_million / 1000000" | bc)
    
    echo -e "${GREEN}✅ Current provider: $provider_name${NC}"
    echo -e "${BLUE}📊 Cost per million tokens: \$$cost_per_million${NC}"
    echo -e "${BLUE}📈 Estimated tokens this month: $tokens${NC}"
    echo -e "${BLUE}💰 Estimated monthly cost: \$${cost}${NC}"
    
    # Show comparison with other providers
    echo ""
    echo -e "${YELLOW}📋 Cost Comparison with Other Providers:${NC}"
    echo "┌──────────────────────┬──────────────────┬──────────────┐"
    echo "│ Provider             │ Cost/Million     │ Your Cost    │"
    echo "├──────────────────────┼──────────────────┼──────────────┤"
    
    for p in "${!COST_PER_MILLION[@]}"; do
        local p_name=${PROVIDER_NAMES[$p]}
        local p_cost=${COST_PER_MILLION[$p]}
        local your_cost=$(echo "scale=4; $tokens * $p_cost / 1000000" | bc)
        
        if [ "$p" = "$provider" ]; then
            echo -e "│ ${GREEN}${p_name} (current)${NC} │ \$${p_cost}           │ \$${your_cost}    │"
        else
            # Calculate savings
            local current_cost=$(echo "scale=4; $tokens * $cost_per_million / 1000000" | bc)
            local savings=$(echo "scale=4; $current_cost - $your_cost" | bc)
            
            if (( $(echo "$savings > 0" | bc -l) )); then
                echo -e "│ ${p_name}            │ \$${p_cost}           │ \$${your_cost} (save \$${savings}) │"
            else
                echo -e "│ ${p_name}            │ \$${p_cost}           │ \$${your_cost}          │"
            fi
        fi
    done
    
    echo "└──────────────────────┴──────────────────┴──────────────┘"
}

# Main script
main() {
    # Get token estimate
    echo -e "${BLUE}📈 Token Usage Estimate${NC}"
    echo -e "${YELLOW}💡 How many tokens do you estimate using per month?${NC}"
    echo "  Typical usage:"
    echo "  • Light user: 100,000 - 500,000 tokens"
    echo "  • Medium user: 1,000,000 - 5,000,000 tokens"
    echo "  • Heavy user: 10,000,000+ tokens"
    echo ""
    
    read -p "Enter estimated monthly tokens (e.g., 1000000): " TOKENS
    
    if [[ ! "$TOKENS" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}❌ Please enter a valid number${NC}"
        exit 1
    fi
    
    # Detect provider
    PROVIDER=$(detect_provider)
    
    if [ "$PROVIDER" = "unknown" ]; then
        echo -e "${YELLOW}⚠️  Could not detect provider. Please specify:${NC}"
        echo "Available providers:"
        for p in "${!PROVIDER_NAMES[@]}"; do
            echo "  • $p (${PROVIDER_NAMES[$p]})"
        done
        read -p "Enter provider: " PROVIDER
    fi
    
    # Calculate and display costs
    calculate_costs "$PROVIDER" "$TOKENS"
    
    # Recommendations
    echo ""
    echo -e "${GREEN}💡 Cost Optimization Recommendations:${NC}"
    
    case $PROVIDER in
        claude-opus|gpt-4)
            echo -e "${YELLOW}⚠️  You're using an expensive model!${NC}"
            echo "  Consider switching to:"
            echo "  • DeepSeek: ./scripts/switch-to-deepseek.sh (save 99%)"
            echo "  • Claude Haiku: ./scripts/deploy-anthropic.sh --model haiku (save 98%)"
            echo "  • Kimi: ./scripts/deploy-kimi.sh (save 96%)"
            ;;
        claude-sonnet)
            echo "  Good balance of cost and capability."
            echo "  For more savings:"
            echo "  • DeepSeek: ./scripts/switch-to-deepseek.sh (save 95%)"
            echo "  • Claude Haiku: ./scripts/deploy-anthropic.sh --model haiku (save 92%)"
            ;;
        *)
            echo "  You're already using a cost-effective provider!"
            echo "  Continue monitoring with: ./scripts/monitor-usage.sh"
            ;;
    esac
    
    echo ""
    echo -e "${BLUE}📊 Monthly Cost Breakdown:${NC}"
    echo "  • Your current provider: ${PROVIDER_NAMES[$PROVIDER]}"
    echo "  • Estimated tokens/month: $TOKENS"
    echo "  • Estimated cost/month: \$$(echo "scale=4; $TOKENS * ${COST_PER_MILLION[$PROVIDER]} / 1000000" | bc)"
    echo ""
    echo -e "${YELLOW}💡 Tip: Use ./scripts/monitor-usage.sh for real-time monitoring${NC}"
}

# Run main function
main