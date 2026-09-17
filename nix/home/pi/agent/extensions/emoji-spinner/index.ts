import { ExtensionAPI } from "@earendil-works/pi-coding-agent";

function pickRandom(arr) {
  return arr[Math.floor(Math.random() * arr.length)];
}


const PACKS = [
   {
     name: "hands",
     frames: ["👌 ", "👍️ ", "👎️ ", "👋 ", "🤚 ", "🖐️ ", "✋️ ", "🖖 ", "🫱 ", "🫲 ", "🤌 ", "🤏 ", "✌️  ", "🤞 ", "🫰 ", "🤟 ", "🤘 ", "🤙 ", "👈️ ", "👉️ ", "👆️ ", "🖕 ", "👇️", "☝️  ", "🫵 ", "✊️ ", "👊 "],
     workingMessage: "Handling...",
   },
   {
     name: "hands2",
     frames: ["👏 ", "🙌 ", "🫶 ", "👐 ", "🤲 ", "🤝 ", "🙏 ", "✍️  "],
     workingMessage: "Hand-wringing...",
   },
   {
     name: "flowers",
     frames: ["🌸 ", "💮 ", "🪷 ", "🏵️ ", "🌺 ", "🌻 ", "🌼 ", "🌷 ", "🪻 ", "🌹 ", "🥀 "],
     workingMessage: "Blooming...",
   },
   {
     name: "plants",
     frames: ["🌱 ", "☘️ ", "🪴 ", "🌿 ", "🌳 ", "🍃", "🍁 ", "🍂 "],
     workingMessage: "Leafing...",
   },
   {
     name: "squares",
     frames: ["⬛️ ", "⬜️ ", "🔳 ", "🔲 ", "◼️ ", "◻️ ", "◾️ ", "◽️ ", "▪️ ", "▫️ "],
     workingMessage: "Squaring...",
   },
   {
     name: "arrows",
     frames: ["⬆️ ", "↗️ ", "➡️ ", "↘️ ", "⬇️ ", "↙️ ", "⬅️ ", "↖️ "],
     workingMessage: "Spinning...",
   },
   {
     name: "clock",
     frames: ["🕛️ ", "🕧️ ", "🕐️ ", "🕜️ ", "🕑️ ", "🕝️ ", "🕒️ ", "🕞️ ", "🕓️ ", "🕟️ ", "🕔️ ", "🕠️ ", "🕕️ ", "🕡️ ", "🕖️ ", "🕢️ ", "🕗️ ", "🕣️ ", "🕘️ ", "🕤️ ", "🕙️ ", "🕥️ ", "🕚️ ", "🕦️ "],
     workingMessage: "Ticking...",
   },
   {
     name: "moon",
     frames: ["🌑 ", "🌒 ", "🌓 ", "🌔 ", "🌕️ ", "🌖 ", "🌗 ", "🌘 "],
     workingMessage: "Phasing...",
   },
   {
     name: "earth",
     frames: ["🌍️ ", "🌎️ ", "🌏️ "],
     workingMessage: "Revolving...",
   },
   {
     name: "clouds",
     frames: ["☁️ ", "🌤️ ", "⛅️ ", "🌥️ ", "🌦️ ", "🌧️ ", "⛈️ ", "🌩️ ", "🌨️ "],
     workingMessage: "Weathering...",
   },
   {
     name: "stars",
     frames: ["⭐️ ", "🌠 ", "🌌 ", "🪐 ", "🌟 ", "🌀 "],
     workingMessage: "Exploring...",
   },
   {
     name: "sunmoon",
     frames: ["🌚 ", "🌝 "],
     intervalMs: 1000,
     workingMessage: "Daybreaking...",
   },
];

let PACK = null;

export default function (pi: ExtensionAPI) {
  pi.on("before_agent_start", async (_args, ctx) => {
    const { frames, workingMessage, intervalMs = 200 } = PACK || pickRandom(PACKS);
    ctx.ui.setWorkingIndicator({
      frames,
      intervalMs,
    });
    ctx.ui.setWorkingMessage(workingMessage);
  });

  pi.registerCommand("indicator-pack", {
    description: "Simulate an async operation with a custom spinner",
    handler: async (args, ctx) => {
      const name = args.trim();
      const found = PACKS.find((pack) => pack.name === name);

      if (found) {
        // statefully set the pack
        PACK = found;
        ctx.ui.notify(`Set indicator pack to: ${args}`, "success");
      } else {
        ctx.ui.notify(`No indicator pack found: ${args}`, "error");
      }
    }
  });
}
