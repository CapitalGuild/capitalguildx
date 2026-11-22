"use strict";
const inquiry = document.querySelector("#sponsor-form");
if (inquiry) inquiry.addEventListener("submit", event => {
  event.preventDefault();
  const fields = new FormData(inquiry);
  const body = ["Company: " + fields.get("company"), "Reply email: " + fields.get("email"),
    "Interest: " + fields.get("interest"), "", fields.get("message")].join("\n");
  window.location.href = "mailto:capitalguildx@gmail.com?subject=FuturesEdge%20Mini%20partnership&body=" + encodeURIComponent(body);
});

const contracts = { MNQ: [25n, 2n], NQ: [25n, 20n], MES: [25n, 5n], ES: [25n, 50n], MGC: [10n, 10n] };
function hundredths(value) {
  const match = /^(\d{1,9})(?:\.(\d{1,2}))?$/.exec(value.trim());
  if (!match) throw new Error("Enter a number with up to nine whole digits and two decimal places.");
  return BigInt(match[1]) * 100n + BigInt((match[2] || "").padEnd(2, "0"));
}
function dollars(cents) {
  return "$" + (cents / 100n).toLocaleString("en-US") + "." + String(cents % 100n).padStart(2, "0");
}
const calculator = document.querySelector("#calculator");
if (calculator) {
  const output = calculator.querySelector("output");
  const calculate = () => {
    try {
      const [tick, pointValue] = contracts[calculator.elements.symbol.value];
      const budget = hundredths(calculator.elements.budget.value);
      const stop = hundredths(calculator.elements.stop.value);
      if (stop === 0n || stop % tick !== 0n) throw new Error("Enter a positive stop distance in multiples of " + Number(tick) / 100 + " points.");
      const unit = stop * pointValue;
      const quantity = budget / unit;
      const number = document.createElement("strong");
      number.textContent = quantity.toLocaleString("en-US") + (quantity === 1n ? " contract" : " contracts");
      output.replaceChildren(number, " · " + dollars(unit * quantity) + " total risk · " + dollars(unit) + " per contract");
    } catch (error) {
      output.textContent = error.message;
    }
  };
  calculator.addEventListener("submit", event => { event.preventDefault(); calculate(); });
  calculate();
}

// Keep only allow-listed campaign values in optional, browser-local aggregate counts.
const supported = ["youtube", "producthunt", "community", "educator", "directory", "search"];
const query = new URLSearchParams(location.search).get("utm_source");
const source = supported.includes(query) ? query : "direct";
const attribution = document.querySelector("#local-attribution");
if (attribution) {
  const storageKey = "futuresedge-download-counts";
  const consentKey = "futuresedge-attribution-enabled";
  try {
    attribution.checked = localStorage.getItem(consentKey) === "yes";
    attribution.addEventListener("change", () => {
      if (attribution.checked) localStorage.setItem(consentKey, "yes");
      else {
        localStorage.removeItem(consentKey);
        localStorage.removeItem(storageKey);
      }
    });
    document.querySelectorAll("[data-download]").forEach(link => link.addEventListener("click", () => {
      if (!attribution.checked) return;
      try {
        const counts = JSON.parse(localStorage.getItem(storageKey) || "{}");
        counts[source] = (Number(counts[source]) || 0) + 1;
        localStorage.setItem(storageKey, JSON.stringify(counts));
      } catch {}
    }));
  } catch { attribution.closest("details").hidden = true; }
}
