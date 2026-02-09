# Deployment Guide

## Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/yksanjo/moltworker-cloudflare.git
cd moltworker-cloudflare
```

### 2. Install Dependencies
```bash
npm install
```

### 3. Choose Your AI Provider

| Provider | Cost | Best For | Command |
|----------|------|----------|---------|
| **DeepSeek** (Recommended) | $0.14/million | Coding, general tasks | `./scripts/deploy-deepseek.sh` |
| **Kimi/Moonshot** | $0.60/million | Chinese/English, long context | `./scripts/deploy-kimi.sh` |
| **Claude Haiku** | $0.25/million | Fast responses, simple tasks | `./scripts/deploy-anthropic.sh --model haiku` |
| **Claude Sonnet** | $3.00/million | Complex reasoning | `./scripts/deploy-anthropic.sh --model sonnet` |
| **OpenAI GPT-3.5** | $0.50/million | General purpose | `./scripts/deploy-openai.sh` |

### 4. Deploy
```bash
# Example: Deploy with DeepSeek (most affordable)
./scripts/deploy-deepseek.sh
```

### 5. Access Your Agent
After deployment, you'll get a URL like:
```
https://your-worker.workers.dev/?token=YOUR_GATEWAY_TOKEN
```

## Detailed Deployment

### Prerequisites

1. **Cloudflare Account** with Workers Paid plan ($5/month)
2. **AI Provider API Key** (choose one):
   - DeepSeek: https://platform.deepseek.com
   - Kimi: https://platform.moonshot.cn
   - Anthropic: https://console.anthropic.com
   - OpenAI: https://platform.openai.com

### Step-by-Step Deployment

#### Option A: Automated Deployment (Recommended)

```bash
# 1. Clone and enter directory
git clone https://github.com/yksanjo/moltworker-cloudflare.git
cd moltworker-cloudflare

# 2. Install dependencies
npm install

# 3. Authenticate with Cloudflare
npx wrangler login

# 4. Run deployment script for your chosen provider
./scripts/deploy-deepseek.sh     # Most affordable
# OR
./scripts/deploy-kimi.sh         # Best for Chinese/English
# OR
./scripts/deploy-anthropic.sh --model haiku  # Fast and cheap
```

#### Option B: Manual Deployment

```bash
# 1. Build the project
npm run build

# 2. Set environment secrets
# Get API key from your provider
export API_KEY="your-api-key-here"

# Generate gateway token
export MOLTBOT_GATEWAY_TOKEN=$(openssl rand -hex 32)

# Set secrets based on provider
# For DeepSeek:
echo "$API_KEY" | npx wrangler secret put DEEPSEEK_API_KEY
# For Kimi:
echo "$API_KEY" | npx wrangler secret put KIMI_API_KEY
# For Anthropic:
echo "$API_KEY" | npx wrangler secret put ANTHROPIC_API_KEY
# For OpenAI:
echo "$API_KEY" | npx wrangler secret put OPENAI_API_KEY

# Set gateway token
echo "$MOLTBOT_GATEWAY_TOKEN" | npx wrangler secret put MOLTBOT_GATEWAY_TOKEN

# 3. Deploy
npx wrangler deploy
```

### Provider-Specific Configuration

#### DeepSeek Configuration
```bash
# Default configuration (most affordable)
./scripts/deploy-deepseek.sh

# Custom configuration
cp configs/deepseek.json configs/custom.json
# Edit custom.json as needed
./scripts/deploy.sh --config configs/custom.json
```

#### Kimi/Moonshot Configuration
```bash
# Default configuration (128K context window)
./scripts/deploy-kimi.sh

# Features:
# - Excellent Chinese/English support
# - 128K context window for long conversations
# - OpenAI-compatible API
```

#### Anthropic Claude Configuration
```bash
# Choose model based on needs:
./scripts/deploy-anthropic.sh --model haiku     # $0.25/million (fastest)
./scripts/deploy-anthropic.sh --model sonnet    # $3.00/million (balanced)
./scripts/deploy-anthropic.sh --model opus      # $15.00/million (most powerful)

# Warning: Opus is very expensive!
```

### Cost Optimization Deployment

#### Start with DeepSeek (Recommended)
```bash
# DeepSeek offers the best value
./scripts/deploy-deepseek.sh

# Cost comparison:
# - DeepSeek: $0.14/million tokens
# - Claude Opus: $15.00/million tokens
# - Savings: 99% reduction
```

#### Set Up AI Gateway for Multiple Providers
```bash
# 1. Set up AI Gateway in Cloudflare dashboard
# 2. Configure multiple providers with fallbacks
# 3. Deploy with AI Gateway
./scripts/deploy-ai-gateway.sh

# Benefits:
# - Automatic failover between providers
# - Caching reduces costs by 20-40%
# - Centralized analytics
```

### Post-Deployment Steps

1. **Wait for Container Start** (1-2 minutes)
2. **Access Your Agent** at the provided URL
3. **Test Basic Functionality**:
   ```bash
   # Check if agent is running
   curl https://your-worker.workers.dev/health
   
   # Test with a simple question
   curl -X POST https://your-worker.workers.dev/api/chat \
     -H "Authorization: Bearer YOUR_TOKEN" \
     -d '{"message": "Hello, are you working?"}'
   ```

4. **Set Up Additional Features** (optional):
   ```bash
   # Telegram integration
   ./scripts/setup-telegram.sh
   
   # Cloudflare Access for security
   ./scripts/setup-access.sh
   
   # Cost monitoring
   ./scripts/monitor-costs.sh
   ```

### Switching Providers

If you want to switch to a different provider later:

```bash
# From Opus to DeepSeek (99% cost reduction)
./scripts/switch-to-deepseek.sh

# From any provider to Kimi
./scripts/deploy-kimi.sh

# The switch preserves all your data and configurations
```

### Troubleshooting Deployment

#### Common Issues

1. **"Unauthorized" error**:
   ```bash
   # Re-authenticate with Cloudflare
   npx wrangler login
   ```

2. **Build fails**:
   ```bash
   # Clear node_modules and reinstall
   rm -rf node_modules package-lock.json
   npm install
   ```

3. **Container won't start**:
   ```bash
   # Check logs
   npx wrangler tail
   
   # Wait longer (first start can take 2-3 minutes)
   ```

4. **API key not working**:
   ```bash
   # Verify key is valid
   # Check provider dashboard for rate limits
   # Regenerate key if needed
   ```

#### Verification Steps

After deployment, verify everything is working:

```bash
# 1. Check deployment status
npx wrangler deployments list

# 2. Check container health
npx wrangler containers list

# 3. Test web interface
curl -I https://your-worker.workers.dev/

# 4. Test API endpoint
curl https://your-worker.workers.dev/health
```

### Cost Monitoring After Deployment

```bash
# Check estimated costs
./scripts/check-costs.sh

# Monitor real-time usage
./scripts/monitor-usage.sh

# Set budget alerts
./scripts/set-budget.sh --monthly 10  # $10/month budget
```

### Advanced Deployment Options

#### Custom Domain
```bash
# 1. Add custom domain in Cloudflare dashboard
# 2. Update wrangler.jsonc
# 3. Redeploy
npx wrangler deploy --route "your-domain.com/*"
```

#### Multiple Environments
```bash
# Development environment
./scripts/deploy-deepseek.sh --env dev

# Production environment  
./scripts/deploy-deepseek.sh --env prod

# Staging environment
./scripts/deploy-deepseek.sh --env staging
```

#### High Availability Setup
```bash
# Deploy to multiple regions
./scripts/deploy-multi-region.sh

# Set up automatic failover
./scripts/setup-failover.sh
```

## Next Steps

After successful deployment:

1. **Read the [Cost Optimization Guide](COST_OPTIMIZATION.md)** to minimize expenses
2. **Set up [Security Features](SECURITY.md)** for protection
3. **Configure [Monitoring](MONITORING.md)** to track usage
4. **Explore [Advanced Features](ADVANCED.md)** for customization

## Need Help?

- Check the [Troubleshooting Guide](../README.md#-troubleshooting)
- Open an issue on [GitHub](https://github.com/yksanjo/moltworker-cloudflare/issues)
- Join discussions in the [GitHub Discussions](https://github.com/yksanjo/moltworker-cloudflare/discussions)