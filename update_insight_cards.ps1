$path = 'C:\Users\US\Downloads\index_pricing_bundles_added.html'
$text = Get-Content -Raw -LiteralPath $path

$cssAnchor = @"
        .glass-card:hover {
            border-color: rgba(212,175,55,0.3);
            box-shadow: 0 0 30px rgba(212,175,55,0.1), 0 20px 60px rgba(0,0,0,0.5);
            transform: translateY(-8px);
        }
"@

$cssExtra = @"
        .insight-card-enhanced { cursor: pointer; display: flex; flex-direction: column; min-height: 100%; }
        .insight-card-body { flex: 1; }
        .insight-card-cta { margin-top: 1rem; display: inline-flex; align-items: center; gap: 0.35rem; font-size: 0.75rem; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; color: rgba(212,175,55,0.88); transition: transform 0.3s ease, color 0.3s ease; }
        .insight-card-enhanced:hover .insight-card-cta, .rotating-border:hover .insight-card-cta { color: #FFC107; transform: translateX(4px); }
        .insight-card-enhanced:focus-visible { outline: 2px solid rgba(255,193,7,0.9); outline-offset: 4px; }
        .insight-modal { position: fixed; inset: 0; z-index: 120; display: flex; align-items: center; justify-content: center; padding: 1.5rem; background: rgba(1,2,10,0.82); backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px); opacity: 0; pointer-events: none; transition: opacity 0.35s ease; }
        .insight-modal.is-open { opacity: 1; pointer-events: auto; }
        .insight-modal__panel { width: min(760px, 100%); max-height: min(85vh, 900px); overflow-y: auto; padding: 2rem; border-radius: 1.5rem; border: 1px solid rgba(212,175,55,0.22); background: linear-gradient(180deg, rgba(14,14,34,0.98) 0%, rgba(8,8,26,0.98) 100%); box-shadow: 0 24px 80px rgba(0,0,0,0.55), 0 0 0 1px rgba(255,193,7,0.05) inset; }
        .insight-modal__close { display: inline-flex; align-items: center; justify-content: center; width: 2.5rem; height: 2.5rem; border-radius: 999px; border: 1px solid rgba(212,175,55,0.2); background: rgba(212,175,55,0.08); color: #fff; cursor: pointer; }
        .insight-modal__eyebrow { display: inline-block; font-size: 0.72rem; font-weight: 700; letter-spacing: 0.3em; text-transform: uppercase; color: rgba(212,175,55,0.72); margin-bottom: 1rem; }
        .insight-modal__title { font-size: clamp(1.9rem, 3vw, 2.6rem); line-height: 1.05; font-weight: 900; color: #fff; margin-bottom: 0.9rem; }
        .insight-modal__lead { color: rgba(255,255,255,0.78); line-height: 1.8; font-size: 1rem; margin-bottom: 1.5rem; }
        .insight-modal__section-title { font-size: 0.82rem; font-weight: 800; letter-spacing: 0.22em; text-transform: uppercase; color: #FFC107; margin: 1.4rem 0 0.75rem; }
        .insight-modal__list { display: grid; gap: 0.8rem; color: rgba(255,255,255,0.82); line-height: 1.7; padding-left: 1rem; }
        .insight-modal__footer { margin-top: 1.75rem; padding-top: 1rem; border-top: 1px solid rgba(212,175,55,0.12); color: rgba(212,175,55,0.82); font-size: 0.92rem; }
        body.modal-open { overflow: hidden; }
"@

$text = $text.Replace($cssAnchor, $cssAnchor + $cssExtra)

$modalAnchor = "</footer>`n`n<script>"
$modalMarkup = @"
</footer>

<div aria-hidden="true" aria-labelledby="insight-modal-title" class="insight-modal" id="insight-modal" role="dialog">
<div class="insight-modal__panel">
<div class="flex items-start justify-between gap-4 mb-6">
<div>
<span class="insight-modal__eyebrow" id="insight-modal-eyebrow">Insight</span>
<h3 class="insight-modal__title" id="insight-modal-title"></h3>
</div>
<button aria-label="Close insight" class="insight-modal__close" id="insight-modal-close" type="button">&times;</button>
</div>
<p class="insight-modal__lead" id="insight-modal-lead"></p>
<div>
<p class="insight-modal__section-title">What You Learn</p>
<ul class="insight-modal__list" id="insight-modal-points"></ul>
</div>
<p class="insight-modal__footer" id="insight-modal-footer"></p>
</div>
</div>

<script>
"@
$text = $text.Replace($modalAnchor, $modalMarkup)

$scriptAnchor = "        // Floating Particles`n"
$scriptExtra = @"
        const insightContent = {
            'Fixed Risk Per Trade': { eyebrow: 'Capital Protection', lead: 'Har trade ka loss pehle define hota hai, profit baad me. Isse ek galat decision pura account momentum kharab nahi karta.', points: ['Position size ko stop-loss distance ke hisaab se calculate karna.', 'Ek single setup ko account damage event banne se rokna.', 'Consistency ke liye same risk model ko repeat karna.'], footer: 'Best use: setup strong lage tab bhi risk rule change nahi hota.' },
            'No Over-Leverage': { eyebrow: 'Execution Discipline', lead: 'High leverage excitement create karta hai, edge nahi. Sustainable execution tab banta hai jab account pressure manageable ho.', points: ['Leverage sirf tab use karna jab invalidation clear ho.', 'Margin pressure ki wajah se emotional exits avoid karna.', 'Long-term survival ko fast gains se upar rakhna.'], footer: 'Goal: account ko survive karwana, taaki edge ko time mil sake.' },
            'Structured Execution': { eyebrow: 'Process First', lead: 'Entry, stop, target aur trade management ek repeatable checklist se decide hote hain. Impulse ko process replace karta hai.', points: ['Pre-trade checklist se confirmation lena.', 'Entry ke baad management rules pehle se define rakhna.', 'Har trade ko review karke same framework improve karna.'], footer: 'Acha trader random fast nahi hota, process-driven precise hota hai.' },
            'Consistency Over Hype': { eyebrow: 'Mindset Edge', lead: 'Market me flashy wins dikhte hain, lekin account quietly disciplined routines se grow hota hai.', points: ['Repeatable setups par focus karna, drama par nahi.', 'Emotional revenge ya FOMO entries ko cut karna.', 'Monthly outcome se zyada process quality track karna.'], footer: 'Clarity aur repetition, long-term compounding ka real base hai.' },
            'Market Structure': { eyebrow: 'Curriculum Insight', lead: 'HH-HL aur LL-LH samajhne ke baad chart random nahi lagta. Trend continuation aur reversal dono readable ho jaate hain.', points: ['Trend identify karna before taking entries.', 'Pullback aur breakout ko same context me dekhna.', 'Structure break ko bias change ke signal ki tarah read karna.'], footer: 'Yahi foundation baaki sare concepts ko connect karta hai.' },
            'Liquidity Advance': { eyebrow: 'Smart Money Lens', lead: 'Price obvious highs-lows ke around liquidity collect karta hai. Is behavior ko samajhkar trap aur real move me farq dekh sakte hain.', points: ['Stop hunt aur liquidity sweep locations mark karna.', 'Liquidity grab ke baad displacement ka wait karna.', 'Crowd positioning ke opposite side ka idea develop karna.'], footer: 'Sirf breakout dekhna enough nahi, uske peeche liquidity context dekhna hota hai.' },
            'Buyer vs Seller Activity': { eyebrow: 'Order Flow Insight', lead: 'Real-time aggression se samajh aata hai ki kis side se actual participation aa raha hai. Isse confirmations sharper ho jaati hain.', points: ['Delta aur footprint data se active pressure read karna.', 'Absorption aur imbalance spots identify karna.', 'Structure ke saath order flow ko combine karke entry quality improve karna.'], footer: 'Yahan se context se confirmation ka bridge banta hai.' },
            'Why Price Moves': { eyebrow: 'Cause Behind Move', lead: 'Sirf candle dekhne se zyada zaroori hai samajhna ki move demand-supply shift, news reaction, ya institutional participation ki wajah se aaya.', points: ['Price movement ke genuine drivers classify karna.', 'Zone reaction aur narrative alignment dekhna.', 'Noise aur meaningful expansion me difference samajhna.'], footer: 'Jab reason clear ho, confidence aur patience dono improve hote hain.' },
            'Timeframe Alignment': { eyebrow: 'Multi-Timeframe View', lead: 'Higher timeframe bias aur lower timeframe execution align karne se random entries kaafi kam ho jaati hain.', points: ['Higher timeframe se directional bias lena.', 'Mid timeframe par key zones aur liquidity mark karna.', 'Lower timeframe par precise trigger ka wait karna.'], footer: 'Alignment ka matlab har timeframe same nahi, balki ek dusre ko support karna hai.' },
            'What Every Candle Tells': { eyebrow: 'Price Action Reading', lead: 'Open, high, low aur close ke andar hi buyer-seller battle chhupi hoti hai. Candle ko story ki tarah padhna execution ko smarter banata hai.', points: ['Rejection, continuation aur indecision candles spot karna.', 'Wick aur body placement se intent read karna.', 'Single candle ko structure context ke saath interpret karna.'], footer: 'Strong reading tab aati hai jab candle ko isolated nahi, surrounding context ke saath dekha jaye.' }
        };
        const modal = document.getElementById('insight-modal');
        const titleEl = document.getElementById('insight-modal-title');
        const eyebrowEl = document.getElementById('insight-modal-eyebrow');
        const leadEl = document.getElementById('insight-modal-lead');
        const pointsEl = document.getElementById('insight-modal-points');
        const footerEl = document.getElementById('insight-modal-footer');
        const closeEl = document.getElementById('insight-modal-close');
        function openInsightByTitle(title) {
            const item = insightContent[title];
            if (!item || !modal) return;
            eyebrowEl.textContent = item.eyebrow;
            titleEl.textContent = title;
            leadEl.textContent = item.lead;
            pointsEl.innerHTML = item.points.map(point => `<li>${point}</li>`).join('');
            footerEl.textContent = item.footer;
            modal.classList.add('is-open');
            modal.setAttribute('aria-hidden', 'false');
            document.body.classList.add('modal-open');
        }
        function closeInsightModal() {
            if (!modal) return;
            modal.classList.remove('is-open');
            modal.setAttribute('aria-hidden', 'true');
            document.body.classList.remove('modal-open');
        }
        function enhanceInsightCard(card, title) {
            if (!card || card.dataset.insightEnhanced === 'true') return;
            card.dataset.insightEnhanced = 'true';
            card.classList.add('insight-card-enhanced');
            card.setAttribute('role', 'button');
            card.setAttribute('tabindex', '0');
            const body = document.createElement('div');
            body.className = 'insight-card-body';
            while (card.firstChild) body.appendChild(card.firstChild);
            card.appendChild(body);
            const cta = document.createElement('span');
            cta.className = 'insight-card-cta';
            cta.innerHTML = 'View Insight <span aria-hidden="true">&rarr;</span>';
            card.appendChild(cta);
            const handler = () => openInsightByTitle(title);
            card.addEventListener('click', handler);
            card.addEventListener('keydown', event => { if (event.key === 'Enter' || event.key === ' ') { event.preventDefault(); handler(); } });
        }
        [['Fixed Risk Per Trade', '#process .grid > div:nth-child(1)'], ['No Over-Leverage', '#process .grid > div:nth-child(2)'], ['Structured Execution', '#process .grid > div:nth-child(3)'], ['Consistency Over Hype', '#process .grid > div:nth-child(4)'], ['Market Structure', '#learn .grid > div:nth-child(1)'], ['Liquidity Advance', '#learn .grid > div:nth-child(2)'], ['Buyer vs Seller Activity', '#learn .grid > div:nth-child(3) .relative'], ['Why Price Moves', '#learn .grid > div:nth-child(4)'], ['Timeframe Alignment', '#learn .grid > div:nth-child(5)'], ['What Every Candle Tells', '#learn .grid > div:nth-child(6)']].forEach(([title, selector]) => enhanceInsightCard(document.querySelector(selector), title));
        if (closeEl) closeEl.addEventListener('click', closeInsightModal);
        if (modal) modal.addEventListener('click', event => { if (event.target === modal) closeInsightModal(); });
        document.addEventListener('keydown', event => { if (event.key === 'Escape' && modal && modal.classList.contains('is-open')) closeInsightModal(); });

        // Floating Particles
"@
$text = $text.Replace($scriptAnchor, $scriptExtra)

Set-Content -LiteralPath $path -Value $text -Encoding utf8
Write-Output "Updated $path"
