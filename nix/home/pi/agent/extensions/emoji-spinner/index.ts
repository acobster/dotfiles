import { ExtensionAPI } from "@earendil-works/pi-coding-agent";

function pickRandom(arr) {
  return arr[Math.floor(Math.random() * arr.length)];
}


const INDICES = ["hands", "hands2", "flowers", "plants", "squares", "arrows", "clock", "moon", "earth", "clouds"];
const PACKS = [
  ["👌 ", "👍️ ", "👎️ ", "👋 ", "🤚 ", "🖐️ ", "✋️ ", "🖖 ", "🫱 ", "🫲 ", "🤌 ", "🤏 ", "✌️  ", "🤞 ", "🫰 ", "🤟 ", "🤘 ", "🤙 ", "👈️ ", "👉️ ", "👆️ ", "🖕 ", "👇️ ", "☝️  ", "🫵 ", "✊️ ", "👊 "],
  ["👏 ", "🙌 ", "🫶 ", "👐 ", "🤲 ", "🤝 ", "🙏 ", "✍️  "],
  ["🌸 ", "💮 ", "🪷 ", "🏵️ ", "🌺 ", "🌻 ", "🌼 ", "🌷 ", "🪻 ", "🌹 ", "🥀 "],
  ["🌱 ", "☘️ ", "🪴 ", "🌿 ", "🌳 ", "🍃", "🍁 ", "🍂 "],
  ["⬛️ ", "⬜️ ", "🔳 ", "🔲 ", "◼️ ", "◻️ ", "◾️ ", "◽️ ", "▪️ ", "▫️ "],
  ["⬆️ ", "↗️ ", "➡️ ", "↘️ ", "⬇️ ", "↙️ ", "⬅️ ", "↖️ "],
  ["🕛️ ", "🕧️ ", "🕐️ ", "🕜️ ", "🕑️ ", "🕝️ ", "🕒️ ", "🕞️ ", "🕓️ ", "🕟️ ", "🕔️ ", "🕠️ ", "🕕️ ", "🕡️ ", "🕖️ ", "🕢️ ", "🕗️ ", "🕣️ ", "🕘️ ", "🕤️ ", "🕙️ ", "🕥️ ", "🕚️ ", "🕦️ "],
  ["🌑 ", "🌒 ", "🌓 ", "🌔 ", "🌕️ ", "🌖 ", "🌗 ", "🌘 "],
  ["🌍️ ", "🌎️ ", "🌏️ "],
  ["☁️ ", "🌤️ ", "⛅️ ", "🌥️ ", "🌦️ ", "🌧️ ", "⛈️ ", "🌩️ ", "🌨️ "],
];

let PACK = null;

export default function (pi: ExtensionAPI) {
  pi.on("before_agent_start", async (_args, ctx) => {
    const frames = PACK || pickRandom(PACKS);
    ctx.ui.setWorkingIndicator({
      frames,
      intervalMs: 200,
    });
  });

  pi.registerCommand("indicator-pack", {
    description: "Simulate an async operation with a custom spinner",
    handler: async (args, ctx) => {
      const idx = INDICES.indexOf(args.trim());

      // statefully set the pack
      PACK = PACKS[idx];

      if (idx > -1) {
        // Set a custom spinner with emoji
        ctx.ui.setWorkingIndicator({
          frames: PACK,
          intervalMs: 200
        });

        ctx.ui.notify(`Set indicator pack to: ${args}`, "success");
      } else {
        ctx.ui.notify(`No indicator pack found: ${args}`, "error");
      }
    }
  });
}
