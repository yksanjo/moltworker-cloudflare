// Placeholder for Moltworker Cloudflare
// This would be replaced with actual source code from the moltworker project

export default {
  async fetch(request: Request, env: any): Promise<Response> {
    return new Response('Moltworker Cloudflare - AI Agent Platform\n\nChoose your provider:\n- DeepSeek (Recommended): $0.14/million tokens\n- Kimi: $0.60/million tokens\n- Claude Haiku: $0.25/million tokens\n\nRun deployment scripts in scripts/ directory.', {
      headers: { 'content-type': 'text/plain' },
    });
  }
};
