<div align="center">

# 🌐🤖 Moltworker Cloudflare
### *Run Your Personal AI Agent on Cloudflare with Multiple Affordable Providers*

[![Deploy to Cloudflare](https://deploy.workers.cloudflare.com/button)](https://deploy.workers.cloudflare.com/?url=https://github.com/yksanjo/moltworker-cloudflare)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Cloudflare Workers](https://img.shields.io/badge/Runs%20on-Cloudflare%20Sandbox-f48120)](https://developers.cloudflare.com/sandbox/)
[![TypeScript](https://img.shields.io/badge/Built%20with-TypeScript-3178c6)](https://www.typescriptlang.org/)

**🚀 Deploy your AI assistant in minutes. Choose from 5+ affordable AI providers. No servers to manage.**

[📖 Quick Start](#-quick-start) • [💰 Cost Comparison](#-cost-comparison) • [🔧 Providers](#-ai-providers) • [🚀 Deploy](#-deployment)

</div>

---

## ✨ What is Moltworker Cloudflare?

**Moltworker Cloudflare** is a **serverless AI agent platform** that runs on [Cloudflare's edge infrastructure](https://developers.cloudflare.com/sandbox/) with support for multiple affordable AI providers.

Think of it as your personal AI assistant that:
- 🧠 **Runs on affordable AI providers** - DeepSeek, Kimi, Claude Haiku, and more
- 💬 **Connects everywhere** - Telegram, Discord, Slack, WhatsApp, Web UI
- 🔒 **Secure by design** - Device pairing, Cloudflare Access, encrypted storage
- 🌍 **Runs at the edge** - 300+ locations worldwide, low latency
- 💰 **Costs pennies** - From $0.14/million tokens + $5/month Workers plan

> ☁️ **Zero servers. Zero maintenance. Just intelligence at affordable prices.**

---

## 💰 Cost Comparison

| Provider | Cost/million tokens | Quality | Best For | Savings vs Opus |
|----------|-------------------|---------|----------|-----------------|
| **DeepSeek** | $0.14 | ⭐⭐⭐⭐ | Coding, reasoning | **99% cheaper** |
| **Claude Haiku** | $0.25 | ⭐⭐⭐ | Fast responses | **98% cheaper** |
| **Kimi (Moonshot)** | $0.60 | ⭐⭐⭐⭐ | Chinese/English | **96% cheaper** |
| **GPT-3.5 Turbo** | $0.50 | ⭐⭐⭐ | General purpose | **97% cheaper** |
| **Claude Sonnet** | $3.00 | ⭐⭐⭐⭐ | Complex reasoning | **80% cheaper** |
| **Claude Opus** | $15.00 | ⭐⭐⭐⭐⭐ | Most complex tasks | Baseline |

**Monthly Cost Example:**
- **With Opus**: ~$150 for 10M tokens
- **With DeepSeek**: ~$1.40 for 10M tokens
- **Savings**: **$148.60/month** (99% reduction)

---

## 🚀 Quick Start

### Prerequisites
- [Cloudflare Workers Paid Plan](https://www.cloudflare.com/plans/developer-platform/) ($5/month)
- AI API Key (choose one from below)

### Step 1: Get Your API Key

Choose your preferred provider:

| Provider | Get API Key | Cost |
|----------|-------------|------|
| **DeepSeek** (Recommended) | [platform.deepseek.com](https://platform.deepseek.com) | $0.14/million |
| **Kimi/Moonshot** | [platform.moonshot.cn](https://platform.moonshot.cn) | $0.60/million |
| **Anthropic Claude** | [console.anthropic.com](https://console.anthropic.com) | $0.25-$15/million |
| **OpenAI** | [platform.openai.com](https://platform.openai.com) | $0.50/million |

### Step 2: Deploy with One Command

```bash
# Clone the repository
git clone https://github.com/yksanjo/moltworker-cloudflare.git
cd moltworker-cloudflare

# Choose your deployment script:
./scripts/deploy-deepseek.sh     # For DeepSeek (recommended)
./scripts/deploy-kimi.sh         # For Kimi/Moonshot AI
./scripts/deploy-anthropic.sh    # For Anthropic Claude
./scripts/deploy-openai.sh       # For OpenAI
```

### Step 3: Access Your Agent

After deployment, you'll get a URL like:
```
https://your-worker.workers.dev/?token=YOUR_GATEWAY_TOKEN
```

🎉 **You're in!** Start chatting with your affordable AI agent.

---

## 🔧 AI Providers

### DeepSeek (Recommended)
```bash
# Deploy with DeepSeek
./scripts/deploy-deepseek.sh

# Or manually:
export DEEPSEEK_API_KEY="sk-your-key-here"
./scripts/deploy.sh --provider deepseek
```

### Kimi/Moonshot AI
```bash
# Deploy with Kimi
./scripts/deploy-kimi.sh

# Features:
# - 128K context window
# - Excellent Chinese/English support
# - OpenAI-compatible API
```

### Anthropic Claude
```bash
# Deploy with Claude Haiku (cheapest)
./scripts/deploy-anthropic.sh --model haiku

# Or with Sonnet:
./scripts/deploy-anthropic.sh --model sonnet

# Or with Opus (expensive!):
./scripts/deploy-anthropic.sh --model opus
```

### OpenAI
```bash
# Deploy with GPT-3.5 Turbo or GPT-4
./scripts/deploy-openai.sh --model gpt-3.5-turbo
```

### Multiple Providers with AI Gateway
```bash
# Set up AI Gateway in Cloudflare dashboard first
./scripts/deploy-ai-gateway.sh

# Benefits:
# - Automatic fallback between providers
# - Caching reduces costs
# - Centralized analytics
```

---

## 🛠️ Features

### 🤖 AI Models
- ✅ **DeepSeek** - Most affordable, excellent for coding
- ✅ **Kimi (Moonshot)** - Best Chinese/English bilingual
- ✅ **Claude Haiku** - Fastest Anthropic model
- ✅ **Claude Sonnet** - Balanced capability/cost
- ✅ **GPT-3.5/4** - Reliable OpenAI models
- ✅ **Any OpenAI-compatible API** - Maximum flexibility

### 💬 Chat Channels
| Platform | Status | Setup Time |
|----------|--------|------------|
| 🌐 **Web UI** | ✅ Built-in | 0 min |
| 📱 **Telegram** | ✅ Full support | 2 min |
| 💜 **Discord** | ✅ Full support | 2 min |
| 💼 **Slack** | ✅ Full support | 3 min |
| 💬 **WhatsApp** | ✅ Full support | 5 min |

### 🔧 Built-in Capabilities
- 🌐 **Browser Automation** - Screenshot, scrape, automate with Puppeteer
- 💾 **Persistent Memory** - R2 storage for conversations & configs
- 🔐 **Device Pairing** - Approve devices before they can access
- 📊 **Admin Dashboard** - Web UI for managing everything
- 🔄 **Auto-backup** - Data syncs every 5 minutes
- 🛡️ **Cloudflare Access** - Enterprise-grade authentication

---

## 📊 Cost Optimization Guide

### 1. Choose the Right Provider
```bash
# For maximum savings:
./scripts/deploy-deepseek.sh      # $0.14/million tokens

# For Chinese/English tasks:
./scripts/deploy-kimi.sh          # $0.60/million tokens

# For simple chat:
./scripts/deploy-anthropic.sh --model haiku  # $0.25/million tokens
```

### 2. Enable AI Gateway Caching
```bash
# Set up AI Gateway for automatic caching
./scripts/setup-ai-gateway.sh

# Caching can reduce costs by 20-40% for repetitive queries
```

### 3. Configure Model Fallbacks
```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "deepseek/deepseek-chat",      // Cheap primary
        "fallbacks": [
          "anthropic/claude-3-haiku",            // Fallback 1
          "openai/gpt-3.5-turbo"                 // Fallback 2
        ]
      }
    }
  }
}
```

### 4. Monitor Usage
```bash
# Check token usage
./scripts/check-usage.sh

# View cost breakdown
./scripts/cost-report.sh
```

---

## 🚀 Deployment

### One-Click Deploy
[![Deploy to Cloudflare](https://deploy.workers.cloudflare.com/button)](https://deploy.workers.cloudflare.com/?url=https://github.com/yksanjo/moltworker-cloudflare)

### Manual Deployment

```bash
# 1. Clone and install
git clone https://github.com/yksanjo/moltworker-cloudflare.git
cd moltworker-cloudflare
npm install

# 2. Authenticate with Cloudflare
npx wrangler login

# 3. Choose your provider script
./scripts/deploy-deepseek.sh     # Recommended for cost savings

# 4. Access your agent
# URL will be shown after deployment
```

### Environment Variables

Create `.env` file:
```bash
# Choose ONE provider:
DEEPSEEK_API_KEY=sk-your-deepseek-key      # Recommended
# OR
KIMI_API_KEY=your-kimi-key
# OR
ANTHROPIC_API_KEY=sk-ant-your-key
# OR
OPENAI_API_KEY=sk-your-openai-key

# Required:
MOLTBOT_GATEWAY_TOKEN=$(openssl rand -hex 32)

# Optional:
DEV_MODE=true                    # Skip auth in development
DEBUG_ROUTES=true                # Enable debug endpoints
```

---

## 🔧 Configuration

### Provider Configuration Files

Each provider has its own configuration template:

- `configs/deepseek.json` - DeepSeek configuration
- `configs/kimi.json` - Kimi/Moonshot configuration  
- `configs/anthropic.json` - Anthropic Claude configuration
- `configs/openai.json` - OpenAI configuration

### Custom Configuration

```bash
# Edit provider configuration
cp configs/deepseek.json configs/custom.json
# Edit custom.json with your preferences

# Deploy with custom config
./scripts/deploy.sh --config configs/custom.json
```

### Model Selection

```bash
# Deploy with specific model
./scripts/deploy-anthropic.sh --model haiku     # Claude Haiku ($0.25/million)
./scripts/deploy-anthropic.sh --model sonnet    # Claude Sonnet ($3/million)
./scripts/deploy-anthropic.sh --model opus      # Claude Opus ($15/million)

./scripts/deploy-openai.sh --model gpt-3.5-turbo  # GPT-3.5 ($0.50/million)
./scripts/deploy-openai.sh --model gpt-4          # GPT-4 ($30/million)
```

---

## 📈 Cost Monitoring

### Check Current Costs
```bash
# View token usage and costs
./scripts/check-costs.sh

# Output example:
# ┌─────────────────┬─────────────┬──────────────┐
# │ Provider        │ Tokens Used │ Estimated Cost │
# ├─────────────────┼─────────────┼──────────────┤
# │ DeepSeek        │ 1,250,000   │ $0.18        │
# │ Claude Haiku    │ 250,000     │ $0.06        │
# │ Total           │ 1,500,000   │ $0.24        │
# └─────────────────┴─────────────┴──────────────┘
```

### Set Budget Alerts
```bash
# Set monthly budget
./scripts/set-budget.sh --monthly 10  # $10/month

# Get alerts when approaching budget
./scripts/monitor-budget.sh
```

### Cost Optimization Tips
1. **Use DeepSeek for coding tasks** - Best value for programming
2. **Use Claude Haiku for simple Q&A** - Fast and cheap
3. **Enable AI Gateway caching** - Reduces duplicate API calls
4. **Set token limits** - Prevent runaway costs
5. **Monitor with scripts** - Regular cost checks

---

## 🛡️ Security

### Multiple Security Layers
1. **🔐 Gateway Token** - Required to access the Control UI
2. **👤 Cloudflare Access** - SSO/authentication for admin routes
3. **📱 Device Pairing** - Each device must be explicitly approved
4. **🗄️ Encrypted Storage** - R2 data encrypted at rest
5. **🔒 HTTPS Only** - All traffic encrypted in transit

### Secure Deployment
```bash
# Generate secure tokens
./scripts/generate-secrets.sh

# Enable Cloudflare Access
./scripts/setup-access.sh

# Set up device pairing
./scripts/enable-pairing.sh
```

---

## 🔄 Migration Guide

### Switching Providers
```bash
# From Opus to DeepSeek (99% cost reduction)
./scripts/migrate-provider.sh --from anthropic --to deepseek

# From GPT-4 to Kimi (80% cost reduction)
./scripts/migrate-provider.sh --from openai --to kimi

# Preserves all your data and configurations
```

### Cost Migration Example
```bash
# Check current Opus costs
./scripts/check-costs.sh
# Output: $45.00 (3M tokens @ $15/million)

# Migrate to DeepSeek
./scripts/migrate-provider.sh --from anthropic --to deepseek

# Check new costs
./scripts/check-costs.sh
# Output: $0.42 (3M tokens @ $0.14/million)

# Savings: $44.58 (99% reduction)
```

---

## 🐛 Troubleshooting

| Issue | Solution |
|-------|----------|
| **"Unauthorized" error** | Enable Cloudflare Containers in dashboard |
| **Gateway won't start** | Check `npx wrangler tail` for logs |
| **Slow first request** | Cold start takes 1-2 min. Container stays warm after |
| **High API costs** | Switch to DeepSeek: `./scripts/deploy-deepseek.sh` |
| **R2 not working** | Verify all 3 R2 secrets are set + redeploy |
| **Provider not responding** | Check API key validity and rate limits |

### Common Issues & Fixes

**High Cost Alert:**
```bash
# If spending too much on Opus:
./scripts/switch-to-deepseek.sh  # Immediate 99% cost reduction

# Or switch to Haiku:
./scripts/deploy-anthropic.sh --model haiku
```

**Provider Downtime:**
```bash
# Set up automatic fallback
./scripts/setup-fallback.sh

# Or manually switch providers
./scripts/switch-provider.sh deepseek
```

---

## 📚 Documentation

- [📖 Full Deployment Guide](docs/DEPLOYMENT.md)
- [💰 Cost Optimization Guide](docs/COST_OPTIMIZATION.md)
- [🔧 Provider Configuration](docs/PROVIDERS.md)
- [🛡️ Security Setup](docs/SECURITY.md)
- [📊 Monitoring & Analytics](docs/MONITORING.md)

---

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup
```bash
git clone https://github.com/yksanjo/moltworker-cloudflare.git
cd moltworker-cloudflare
npm install

# Test locally
npm run dev

# Run tests
npm test
```

---

## 📜 License

MIT License - see [LICENSE](LICENSE) file.

---

## 🔗 Links

- 🌐 [Cloudflare Sandbox Docs](https://developers.cloudflare.com/sandbox/)
- 💰 [DeepSeek API](https://platform.deepseek.com)
- 🌙 [Kimi/Moonshot AI](https://platform.moonshot.cn)
- 🤖 [Anthropic Claude](https://console.anthropic.com)
- 🎯 [OpenAI API](https://platform.openai.com)
- 🐦 [Twitter/X](https://twitter.com/yksanjo)

---

<div align="center">

**⭐ Star this repo if you find it helpful! ⭐**

Made with ❤️ by [@yksanjo](https://github.com/yksanjo)

</div>