/* =========================================================
   AUDIO REFERENCES
========================================================= */
const theme = document.getElementById("ipl");
const hammer = document.getElementById("hammer");

/* =========================================================
   IPL THEME – PLAY ONLY ON ICON CLICK
========================================================= */
function toggleIPLTheme() {
    if (!theme) return;

    theme.pause();
    theme.currentTime = 0;
    theme.loop = false;
    theme.volume = 0.25;

    theme.play().catch(() => {});
}

/* HARD BLOCK autoplay */
if (theme) {
    theme.pause();
    theme.currentTime = 0;
    theme.loop = false;
}

/* =========================================================
   VOICE ENGINE – ENGLISH MALE / FEMALE
========================================================= */
let cachedVoice = null;

function loadEnglishVoice(type) {
    const voices = speechSynthesis.getVoices();
    if (!voices.length) return null;

    if (type === "female") {
        return voices.find(v =>
            v.lang.startsWith("en") &&
            (
                v.name.toLowerCase().includes("female") ||
                v.name.toLowerCase().includes("woman") ||
                v.name.toLowerCase().includes("zira") ||
                v.name.toLowerCase().includes("susan")
            )
        );
    }

    return voices.find(v =>
        v.lang.startsWith("en") &&
        (
            v.name.toLowerCase().includes("male") ||
            v.name.toLowerCase().includes("man") ||
            v.name.toLowerCase().includes("david") ||
            v.name.toLowerCase().includes("mark")
        )
    );
}

function updateVoiceLock() {
    const type = document.getElementById("voiceSelect")?.value || "male";
    cachedVoice = loadEnglishVoice(type);

    if (!cachedVoice) {
        cachedVoice = speechSynthesis.getVoices()
            .find(v => v.lang.startsWith("en"));
    }
}

speechSynthesis.onvoiceschanged = () => {
    updateVoiceLock();
};

/* =========================================================
   SPEAK FUNCTION
========================================================= */
function speak(text) {
    if (!cachedVoice) updateVoiceLock();

    speechSynthesis.cancel();

    const u = new SpeechSynthesisUtterance(text);
    u.voice = cachedVoice;
    u.rate = 0.9;
    u.pitch = 1;
    u.volume = 1;

    speechSynthesis.speak(u);
}

/* =========================================================
   ANNOUNCE PLAYER
========================================================= */
function announcePlayer(name, base) {
    speak(`${name}, base price ${base} crores, is now in the auction`);
    updateTicker(`${name} enters the auction`);
}

/* =========================================================
   SOLD HANDLER (DIRECT SELL)
========================================================= */
function handleSold(e, player, team, price) {
    e.preventDefault();

    if (!team || !price) {
        alert("⚠️ Select team and enter price");
        return false;
    }

    // Hammer Sound
    if (hammer) {
        hammer.currentTime = 0;
        hammer.play().catch(()=>{});
    }

    speak(`${player} sold to ${team} for ${price} crores`);
    updateTicker(`${player} SOLD to ${team} for ₹${price} Cr`);

    setTimeout(() => {
        e.target.submit();
    }, 1500);

    return false;
}

/* =========================================================
   UNSOLD HANDLER
========================================================= */
function markUnsold(player) {
    speak(`${player} remains unsold`);
    updateTicker(`${player} goes UNSOLD`);

    const podium = document.querySelector(".auction-podium");
    if (podium) {
        podium.style.opacity = "0.6";
        setTimeout(() => podium.style.opacity = "1", 1200);
    }

    return true;
}

/* =========================================================
   LIVE TICKER
========================================================= */
function updateTicker(text) {
    const ticker = document.querySelector(".live-ticker span");
    if (ticker) ticker.innerText = text;
}

/* =========================================================
   EXPORTS
========================================================= */
window.toggleIPLTheme = toggleIPLTheme;
window.announcePlayer = announcePlayer;
window.handleSold = handleSold;
window.markUnsold = markUnsold;
