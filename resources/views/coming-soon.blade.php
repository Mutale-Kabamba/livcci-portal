<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LivCCI – New Website Coming Soon</title>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #0f1630;
            color: #ffffff;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 24px;
            overflow: hidden;
            position: relative;
        }

        /* Subtle radial glow */
        body::before {
            content: '';
            position: fixed;
            inset: 0;
            background: radial-gradient(ellipse 80% 60% at 50% 10%, rgba(24, 118, 195, 0.25) 0%, transparent 70%);
            pointer-events: none;
        }

        .container {
            position: relative;
            z-index: 1;
            text-align: center;
            max-width: 720px;
            width: 100%;
        }

        .badge {
            display: inline-block;
            background: rgba(244, 178, 35, 0.15);
            border: 1px solid rgba(244, 178, 35, 0.4);
            color: #F4B223;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.15em;
            text-transform: uppercase;
            padding: 6px 16px;
            border-radius: 999px;
            margin-bottom: 28px;
        }

        .logo-text {
            font-size: 15px;
            font-weight: 800;
            letter-spacing: 0.12em;
            text-transform: uppercase;
            color: #93c5fd;
            margin-bottom: 20px;
            opacity: 0.85;
        }

        h1 {
            font-size: clamp(2rem, 6vw, 3.5rem);
            font-weight: 900;
            line-height: 1.15;
            color: #ffffff;
            margin-bottom: 18px;
        }

        h1 span {
            color: #F4B223;
        }

        p.subtitle {
            font-size: clamp(0.95rem, 2.5vw, 1.1rem);
            color: rgba(255, 255, 255, 0.6);
            line-height: 1.7;
            margin-bottom: 52px;
        }

        /* Countdown */
        .countdown {
            display: flex;
            justify-content: center;
            gap: clamp(12px, 3vw, 32px);
            margin-bottom: 52px;
        }

        .unit {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .unit-value {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 14px;
            padding: clamp(14px, 3vw, 22px) clamp(16px, 4vw, 30px);
            font-size: clamp(2rem, 5vw, 3.5rem);
            font-weight: 900;
            line-height: 1;
            color: #ffffff;
            min-width: clamp(64px, 14vw, 110px);
            font-variant-numeric: tabular-nums;
            letter-spacing: -0.02em;
        }

        .unit-label {
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: rgba(255, 255, 255, 0.4);
            margin-top: 10px;
        }

        .separator {
            font-size: clamp(2rem, 5vw, 3.5rem);
            font-weight: 900;
            color: rgba(255, 255, 255, 0.2);
            align-self: center;
            padding-bottom: 24px;
        }

        .launch-date {
            font-size: 13px;
            color: rgba(255, 255, 255, 0.35);
            margin-bottom: 48px;
            letter-spacing: 0.04em;
        }

        .divider {
            width: 48px;
            height: 3px;
            background: linear-gradient(to right, #1D2A68, #1876C3, #F4B223);
            border-radius: 2px;
            margin: 0 auto 48px;
        }

        .footer {
            font-size: 12px;
            color: rgba(255, 255, 255, 0.25);
            margin-top: 12px;
        }

        .dot {
            width: 4px;
            height: 4px;
            background: rgba(255,255,255,0.2);
            border-radius: 50%;
            display: inline-block;
            margin: 0 8px;
            vertical-align: middle;
        }

        /* Subtle animated particles */
        .particles {
            position: fixed;
            inset: 0;
            pointer-events: none;
            z-index: 0;
        }
        .particle {
            position: absolute;
            border-radius: 50%;
            background: rgba(24, 118, 195, 0.15);
            animation: float linear infinite;
        }
        @keyframes float {
            0%   { transform: translateY(100vh) scale(0); opacity: 0; }
            10%  { opacity: 1; }
            90%  { opacity: 0.4; }
            100% { transform: translateY(-20px) scale(1); opacity: 0; }
        }
    </style>
</head>
<body>

    <div class="particles" id="particles"></div>

    <div class="container">
        <div class="logo-text">Livingstone Chamber of Commerce &amp; Industry</div>

        <div class="badge">Something big is coming</div>

        <h1>A brand <span>new experience</span><br>is on its way.</h1>

        <p class="subtitle">
            We're working hard on our new website. Stay tuned — exciting things are coming for the LivCCI community.
        </p>

        <div class="countdown">
            <div class="unit">
                <div class="unit-value" id="cd-days">00</div>
                <div class="unit-label">Days</div>
            </div>
            <div class="separator">:</div>
            <div class="unit">
                <div class="unit-value" id="cd-hours">00</div>
                <div class="unit-label">Hours</div>
            </div>
            <div class="separator">:</div>
            <div class="unit">
                <div class="unit-value" id="cd-minutes">00</div>
                <div class="unit-label">Minutes</div>
            </div>
            <div class="separator">:</div>
            <div class="unit">
                <div class="unit-value" id="cd-seconds">00</div>
                <div class="unit-label">Seconds</div>
            </div>
        </div>

        <div class="launch-date">Launching on August 8, 2026</div>

        <div class="divider"></div>

        <div class="footer">
            &copy; {{ date('Y') }} LivCCI
            <span class="dot"></span>
            Livingstone, Zambia
            <span class="dot"></span>
            All rights reserved
        </div>
    </div>

    <script>
        // Countdown target: August 8, 2026 00:00:00
        const target = new Date('2026-08-08T00:00:00').getTime();

        const pad = (n) => String(n).padStart(2, '0');

        function tick() {
            const now  = Date.now();
            const diff = Math.max(0, target - now);

            const days    = Math.floor(diff / (1000 * 60 * 60 * 24));
            const hours   = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((diff % (1000 * 60)) / 1000);

            document.getElementById('cd-days').textContent    = pad(days);
            document.getElementById('cd-hours').textContent   = pad(hours);
            document.getElementById('cd-minutes').textContent = pad(minutes);
            document.getElementById('cd-seconds').textContent = pad(seconds);
        }

        tick();
        setInterval(tick, 1000);

        // Particle effect
        const container = document.getElementById('particles');
        for (let i = 0; i < 18; i++) {
            const p = document.createElement('div');
            p.className = 'particle';
            const size = Math.random() * 6 + 3;
            p.style.cssText = [
                `width:${size}px`,
                `height:${size}px`,
                `left:${Math.random() * 100}%`,
                `animation-duration:${Math.random() * 18 + 12}s`,
                `animation-delay:${Math.random() * 12}s`,
            ].join(';');
            container.appendChild(p);
        }
    </script>
</body>
</html>
