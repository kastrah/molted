/**
 * Utility functions for provider-specific logic and capabilities.
 */

/**
 * Returns true if the provider requires reasoning to be wrapped in tags
 * (e.g. <think> and <final>) in the text stream, rather than using native
 * API fields for reasoning/thinking.
 */
export function isReasoningTagProvider(provider: string | undefined | null): boolean {
  if (!provider) {
    return false;
  }
  const normalized = provider.trim().toLowerCase();

  // Check for exact matches or known prefixes/substrings for reasoning providers
  if (
    normalized === "ollama" ||
    normalized === "google-gemini-cli" ||
    normalized === "google-generative-ai"
  ) {
    return true;
  }

  // Handle google-antigravity and its model variations (e.g. google-antigravity/gemini-3)
  if (normalized.includes("google-antigravity")) {
    return true;
  }

  // Handle Minimax (M2.1 is chatty/reasoning-like)
  if (normalized.includes("minimax")) {
    return true;
  }

  return false;
}

/**
 * Returns true if the system prompt should include the strict <think>/<final>
 * formatting hint as a mitigation against providers that sometimes leak
 * internal reasoning into user-visible text.
 *
 * This does NOT imply that we must enforce <final>-only extraction at the
 * stream parser layer (that's handled separately by isReasoningTagProvider()).
 */
export function shouldHintReasoningTags(provider: string | undefined | null): boolean {
  if (!provider) {
    return false;
  }
  const normalized = provider.trim().toLowerCase();
  if (isReasoningTagProvider(normalized)) {
    return true;
  }
  // Kimi Coding (and some Moonshot/Kimi proxies) have been observed returning
  // chain-of-thought as plain text blocks. The hint strongly nudges it to keep
  // that content inside <think> so it can be stripped.
  if (normalized.includes("kimi-coding") || normalized.includes("moonshot")) {
    return true;
  }
  return false;
}
