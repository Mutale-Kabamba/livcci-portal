<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LivCCI — New Website Coming Soon</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --navy:  #1D2A68;
            --blue:  #1876C3;
            --gold:  #F4B223;
            --white: #ffffff;
        }

        html, body {
            height: 100%;
        }

        body {
            font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            color: var(--white);
            overflow-x: hidden;
            position: relative;
        }

        /* ── Background ── */
        .bg-layer {
            position: fixed;
            inset: 0;
            background-image: url('/images/bg/2.png');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            z-index: 0;
        }
        /* Dark overlay: navy gradient + opacity so photo is faint */
        .bg-layer::after {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(
                160deg,
                rgba(13, 20, 52, 0.93) 0%,
                rgba(13, 20, 52, 0.88) 40%,
                rgba(13, 30, 65, 0.82) 100%
            );
        }

        /* ── Layout ── */
        .page {
            position: relative;
            z-index: 1;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        /* ── Header ── */
        header {
            padding: clamp(32px, 5vh, 56px) clamp(24px, 5vw, 64px) 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 14px;
        }

        header img {
            height: clamp(72px, 10vw, 108px);
            width: auto;
            filter: drop-shadow(0 2px 16px rgba(0,0,0,0.5));
        }

        header .org-name {
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
        }

        header .org-name strong {
            font-size: clamp(13px, 1.8vw, 17px);
            font-weight: 700;
            letter-spacing: 0.18em;
            text-transform: uppercase;
            color: var(--white);
            line-height: 1.4;
        }

        header .org-name span {
            font-size: clamp(10px, 1.1vw, 12px);
            font-weight: 400;
            color: rgba(255,255,255,0.4);
            letter-spacing: 0.06em;
            margin-top: 3px;
        }

        /* ── Main ── */
        main {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: clamp(32px, 5vh, 64px) clamp(20px, 5vw, 64px);
        }

        .content {
            text-align: center;
            max-width: 780px;
            width: 100%;
        }

        /* Pill badge */
        .badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(244, 178, 35, 0.12);
            border: 1px solid rgba(244, 178, 35, 0.35);
            color: var(--gold);
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.18em;
            text-transform: uppercase;
            padding: 7px 18px;
            border-radius: 999px;
            margin-bottom: 32px;
        }

        .badge::before {
            content: '';
            display: inline-block;
            width: 6px;
            height: 6px;
            background: var(--gold);
            border-radius: 50%;
            animation: pulse 2s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; transform: scale(1); }
            50%       { opacity: 0.4; transform: scale(0.7); }
        }

        h1 {
            font-size: clamp(2.2rem, 5.5vw, 4rem);
            font-weight: 900;
            line-height: 1.12;
            letter-spacing: -0.02em;
            color: var(--white);
            margin-bottom: 20px;
        }

        h1 em {
            font-style: normal;
            background: linear-gradient(90deg, #60a5fa, var(--gold));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .subtitle {
            font-size: clamp(0.9rem, 2vw, 1.05rem);
            font-weight: 400;
            color: rgba(255,255,255,0.55);
            line-height: 1.75;
            max-width: 540px;
            margin: 0 auto 56px;
        }

        /* ── Countdown ── */
        .countdown-wrap {
            margin-bottom: 20px;
        }

        .countdown {
            display: inline-flex;
            align-items: center;
            gap: clamp(8px, 2vw, 20px);
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.10);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border-radius: 24px;
            padding: clamp(20px, 3vw, 32px) clamp(24px, 4vw, 48px);
            box-shadow:
                0 8px 32px rgba(0,0,0,0.35),
                inset 0 1px 0 rgba(255,255,255,0.08);
        }

        .unit {
            display: flex;
            flex-direction: column;
            align-items: center;
            min-width: clamp(52px, 10vw, 90px);
        }

        .unit-value {
            font-size: clamp(2.2rem, 5vw, 3.8rem);
            font-weight: 800;
            line-height: 1;
            color: var(--white);
            font-variant-numeric: tabular-nums;
            letter-spacing: -0.03em;
        }

        .unit-label {
            font-size: 10px;
            font-weight: 600;
            letter-spacing: 0.14em;
            text-transform: uppercase;
            color: rgba(255,255,255,0.35);
            margin-top: 8px;
        }

        .sep {
            font-size: clamp(1.8rem, 4vw, 3rem);
            font-weight: 300;
            color: rgba(255,255,255,0.2);
            line-height: 1;
            padding-bottom: 18px;
            user-select: none;
        }

        .launch-label {
            font-size: 12px;
            color: rgba(255,255,255,0.3);
            letter-spacing: 0.08em;
            margin-top: 18px;
        }

        /* ── Accent line ── */
        .accent-bar {
            width: 60px;
            height: 3px;
            border-radius: 999px;
            background: linear-gradient(90deg, var(--blue), var(--gold));
            margin: 48px auto 0;
        }

        /* ── Footer ── */
        footer {
            position: relative;
            z-index: 1;
            padding: clamp(16px, 3vh, 28px) clamp(24px, 5vw, 64px);
            border-top: 1px solid rgba(255,255,255,0.06);
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 10px;
        }

        footer .copy {
            font-size: 12px;
            color: rgba(255,255,255,0.28);
            letter-spacing: 0.03em;
        }

        footer .dev {
            font-size: 12px;
            color: rgba(255,255,255,0.28);
            letter-spacing: 0.03em;
        }

        footer .dev strong {
            color: rgba(255,255,255,0.5);
            font-weight: 600;
        }
    </style>
</head>
<body>

    <div class="bg-layer"></div>

    <div class="page">

        <header>
            <img src="/images/logo-white.png" alt="LivCCI Logo">
            <div class="org-name">
                <strong>Livingstone Chamber of Commerce and Industry</strong>
            </div>
        </header>

        <main>
            <div class="content">

                <div class="badge">New Website Incoming</div>

                <h1>We're building something<br><em>extraordinary.</em></h1>

                <p class="subtitle">
                    Our new website is under construction. We'll be back soon with a fresh, powerful platform built for the LivCCI community.
                </p>

                <div class="countdown-wrap">
                    <div class="countdown">
                        <div class="unit">
                            <div class="unit-value" id="cd-days">00</div>
                            <div class="unit-label">Days</div>
                        </div>
                        <div class="sep">:</div>
                        <div class="unit">
                            <div class="unit-value" id="cd-hours">00</div>
                            <div class="unit-label">Hours</div>
                        </div>
                        <div class="sep">:</div>
                        <div class="unit">
                            <div class="unit-value" id="cd-minutes">00</div>
                            <div class="unit-label">Minutes</div>
                        </div>
                        <div class="sep">:</div>
                        <div class="unit">
                            <div class="unit-value" id="cd-seconds">00</div>
                            <div class="unit-label">Seconds</div>
                        </div>
                    </div>
                    <p class="launch-label">Launching August 8, 2026</p>
                </div>

                <div class="accent-bar"></div>

            </div>
        </main>

        <footer>
            <span class="copy">&copy; {{ date('Y') }} LivCCI &mdash; Livingstone, Zambia</span>
            <span class="dev">Developed by: <strong>Ori Studio Limited</strong></span>
        </footer>

    </div>

    <script>
        const target = new Date('2026-08-08T00:00:00').getTime();
        const pad    = n => String(n).padStart(2, '0');

        function tick() {
            const diff    = Math.max(0, target - Date.now());
            const days    = Math.floor(diff / 86400000);
            const hours   = Math.floor((diff % 86400000) / 3600000);
            const minutes = Math.floor((diff % 3600000)  / 60000);
            const seconds = Math.floor((diff % 60000)    / 1000);

            document.getElementById('cd-days').textContent    = pad(days);
            document.getElementById('cd-hours').textContent   = pad(hours);
            document.getElementById('cd-minutes').textContent = pad(minutes);
            document.getElementById('cd-seconds').textContent = pad(seconds);
        }

        tick();
        setInterval(tick, 1000);
    </script>
</body>
</html>
