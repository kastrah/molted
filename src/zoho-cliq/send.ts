import { loadConfig } from "../config/config.js";
import { ZohoCliqBot } from "./bot.js";

export async function sendMessageZohoCliq(
    channelIdOrChatId: string,
    text: string,
    opts?: { accountId?: string }
) {
    const cfg = loadConfig();
    const accountId = opts?.accountId ?? "main";
    const accountCfg = cfg.zohoCliq?.accounts?.[accountId];

    if (!accountCfg) {
        throw new Error(`Zoho Cliq account ${accountId} not found in config`);
    }

    const bot = new ZohoCliqBot(accountCfg);
    return await bot.sendMessage(channelIdOrChatId, text);
}
