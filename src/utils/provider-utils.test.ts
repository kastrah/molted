import { describe, expect, it } from "vitest";
import { isReasoningTagProvider, shouldHintReasoningTags } from "./provider-utils.js";

describe("provider-utils", () => {
  it("shouldHintReasoningTags includes strict tag providers", () => {
    expect(isReasoningTagProvider("minimax")).toBe(true);
    expect(shouldHintReasoningTags("minimax")).toBe(true);
  });

  it("shouldHintReasoningTags includes kimi-coding and moonshot providers", () => {
    expect(isReasoningTagProvider("kimi-coding")).toBe(false);
    expect(shouldHintReasoningTags("kimi-coding")).toBe(true);
    expect(shouldHintReasoningTags("moonshot")).toBe(true);
  });

  it("shouldHintReasoningTags does not match unrelated providers", () => {
    expect(shouldHintReasoningTags("openrouter")).toBe(false);
    expect(shouldHintReasoningTags("openai")).toBe(false);
  });
});
