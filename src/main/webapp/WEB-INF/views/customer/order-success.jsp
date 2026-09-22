<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.gruhu.model.Order" %>
<%@ page import="com.gruhu.model.OrderItem" %>
<%@ page import="com.gruhu.model.Address" %>

<%
    Order order = (Order) request.getAttribute("order");
    Address address = (order != null) ? order.getAddress() : null;
    request.setAttribute("extraCss", "cart.css");
%>

<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<main class="cart-page">
    <div class="order-success-card">
        <div class="success-icon-wrap">
            <i class="fa-solid fa-check"></i>
        </div>

        <span class="auth-tag">Acquisition Confirmed</span>
        <h1 style="font-family: var(--font-serif); font-size: 2.8rem; color: var(--dark-espresso); margin: 6px 0 14px;">
            Thank You for Your Patronage.
        </h1>
        <p style="font-size: 1.05rem; color: var(--text-secondary); max-width: 540px; margin: 0 auto 30px; line-height: 1.6;">
            Your order <strong>#<%= order.getOrderId() %></strong> has been registered at our atelier. Our craftsmen are preparing your pieces for white-glove transport.
        </p>

        <!-- Delivery Timeline -->
        <div class="order-timeline">
            <div class="timeline-step completed">
                <div class="timeline-step-icon"><i class="fa-solid fa-check"></i></div>
                <span class="timeline-step-label">Placed</span>
            </div>
            <div class="timeline-step active">
                <div class="timeline-step-icon"><i class="fa-solid fa-box-archive"></i></div>
                <span class="timeline-step-label">Atelier Prep</span>
            </div>
            <div class="timeline-step">
                <div class="timeline-step-icon"><i class="fa-solid fa-truck"></i></div>
                <span class="timeline-step-label">In Transit</span>
            </div>
            <div class="timeline-step">
                <div class="timeline-step-icon"><i class="fa-solid fa-house-chimney"></i></div>
                <span class="timeline-step-label">White Glove Setup</span>
            </div>
        </div>

        <!-- Order Summary Box inside Success -->
        <div style="text-align: left; background: var(--bg-sand-light); border: 1px solid var(--border-subtle); border-radius: var(--radius-sm); padding: 28px; margin: 36px 0;">
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-bottom: 24px; padding-bottom: 20px; border-bottom: 1px solid var(--border-subtle);">
                <div>
                    <span style="font-size: 0.78rem; text-transform: uppercase; letter-spacing: 0.1em; color: var(--text-muted); font-weight: 700; display: block; margin-bottom: 4px;">Delivery Destination</span>
                    <% if (address != null) { %>
                        <strong style="color: var(--dark-espresso);"><%= address.getReceiverName() %></strong><br>
                        <span style="font-size: 0.88rem; color: var(--text-secondary);"><%= address.getFormattedAddress() %></span><br>
                        <small style="color: var(--text-muted);">Ph: +91 <%= address.getPhone() %></small>
                    <% } %>
                </div>
                <div>
                    <span style="font-size: 0.78rem; text-transform: uppercase; letter-spacing: 0.1em; color: var(--text-muted); font-weight: 700; display: block; margin-bottom: 4px;">Payment Summary</span>
                    <strong style="color: var(--dark-espresso);"><%= order.getPaymentMethod() %></strong> &bull; <span class="badge badge-featured"><%= order.getPaymentStatus() %></span><br>
                    <span style="font-size: 1.1rem; font-weight: 700; color: var(--dark-espresso); display: inline-block; margin-top: 6px;">
                        Grand Total: &#8377;<%= String.format("%,.0f", order.getGrandTotal()) %>
                    </span>
                </div>
            </div>

            <h4 style="font-family: var(--font-serif); font-size: 1.15rem; margin-bottom: 14px;">Pieces in this shipment</h4>
            <% if (order.getItems() != null) {
                for (OrderItem item : order.getItems()) { %>
                    <div style="display: flex; justify-content: space-between; font-size: 0.92rem; margin-bottom: 8px;">
                        <span><%= item.getProductName() %> &times; <%= item.getQuantity() %></span>
                        <strong>&#8377;<%= String.format("%,.0f", item.getSubtotal()) %></strong>
                    </div>
            <%  }
               } %>
        </div>

        <div style="display: flex; gap: 16px; justify-content: center;">
            <a href="${pageContext.request.contextPath}/my-orders" class="btn btn-primary">
                <i class="fa-solid fa-box-archive"></i>
                <span>Track in My Orders</span>
            </a>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-outline">
                <span>Continue Shopping</span>
            </a>
        </div>
    </div>
</main>

<!-- Celebratory Crackers & Fireworks Blast Animation -->
<canvas id="crackersCanvas" style="position: fixed; inset: 0; width: 100vw; height: 100vh; pointer-events: none; z-index: 999999;"></canvas>

<script>
(function() {
    const canvas = document.getElementById('crackersCanvas');
    if (!canvas) return;
    const ctx = canvas.getContext('2d');
    let width = canvas.width = window.innerWidth;
    let height = canvas.height = window.innerHeight;

    window.addEventListener('resize', function() {
        width = canvas.width = window.innerWidth;
        height = canvas.height = window.innerHeight;
    });

    const particles = [];
    const colors = [
        '#d97706', '#b87333', '#f59e0b', '#fbbf24', '#fef08a', // Gold & Amber
        '#10b981', '#059669', '#34d399', '#6ee7b7',             // Emerald & Sage
        '#6366f1', '#8b5cf6', '#a855f7',                         // Atelier Violet
        '#ec4899', '#f43f5e', '#ef4444',                         // Festive Crimson
        '#ffffff', '#38bdf8'                                     // Diamond Sparkles
    ];

    class Particle {
        constructor(x, y, color, isSparkle = false, isConfetti = false) {
            this.x = x;
            this.y = y;
            this.color = color;
            this.isSparkle = isSparkle;
            this.isConfetti = isConfetti;
            const angle = Math.random() * Math.PI * 2;
            const speed = isSparkle ? (Math.random() * 8 + 3) : (Math.random() * 12 + 4);
            this.vx = Math.cos(angle) * speed;
            this.vy = Math.sin(angle) * speed - (isSparkle ? 2 : 4);
            this.gravity = isConfetti ? 0.12 : (isSparkle ? 0.18 : 0.25);
            this.friction = isConfetti ? 0.98 : 0.94;
            this.alpha = 1;
            this.decay = Math.random() * 0.015 + 0.008;
            this.size = isConfetti ? (Math.random() * 6 + 4) : (Math.random() * 3.5 + 2);
            this.rotation = Math.random() * Math.PI * 2;
            this.rotSpeed = (Math.random() - 0.5) * 0.2;
            this.flutter = Math.random() * Math.PI;
            this.flicker = Math.random() * 10;
        }

        update() {
            this.vx *= this.friction;
            this.vy *= this.friction;
            this.vy += this.gravity;
            this.x += this.vx;
            this.y += this.vy;
            this.alpha -= this.decay;
            this.rotation += this.rotSpeed;
            this.flutter += 0.1;
            this.flicker += 1;
        }

        draw(ctx) {
            if (this.alpha <= 0) return;
            ctx.save();
            ctx.globalAlpha = Math.max(0, Math.min(1, this.alpha));
            ctx.translate(this.x, this.y);

            if (this.isConfetti) {
                ctx.rotate(this.rotation);
                ctx.scale(Math.cos(this.flutter), 1);
                ctx.fillStyle = this.color;
                ctx.fillRect(-this.size / 2, -this.size / 2, this.size, this.size * 1.6);
            } else if (this.isSparkle) {
                // Twinkling cracker spark
                const glow = (Math.sin(this.flicker) + 1) * 0.5 * this.size;
                ctx.beginPath();
                ctx.arc(0, 0, this.size + glow, 0, Math.PI * 2);
                ctx.fillStyle = this.color;
                ctx.shadowColor = this.color;
                ctx.shadowBlur = 12;
                ctx.fill();
            } else {
                // Rocket burst dot
                ctx.beginPath();
                ctx.arc(0, 0, this.size, 0, Math.PI * 2);
                ctx.fillStyle = this.color;
                ctx.shadowColor = this.color;
                ctx.shadowBlur = 8;
                ctx.fill();
            }
            ctx.restore();
        }
    }

    // Play subtle synthetic cracker audio pops (Web Audio API, optional/no external assets)
    function playCrackerSound() {
        try {
            const AudioContext = window.AudioContext || window.webkitAudioContext;
            if (!AudioContext) return;
            const audioCtx = new AudioContext();
            for (let i = 0; i < 4; i++) {
                setTimeout(() => {
                    const osc = audioCtx.createOscillator();
                    const gain = audioCtx.createGain();
                    osc.type = 'triangle';
                    osc.frequency.setValueAtTime(140 + Math.random() * 80, audioCtx.currentTime);
                    osc.frequency.exponentialRampToValueAtTime(30, audioCtx.currentTime + 0.12);
                    gain.gain.setValueAtTime(0.15, audioCtx.currentTime);
                    gain.gain.exponentialRampToValueAtTime(0.001, audioCtx.currentTime + 0.12);
                    osc.connect(gain);
                    gain.connect(audioCtx.destination);
                    osc.start();
                    osc.stop(audioCtx.currentTime + 0.13);
                }, i * 70);
            }
        } catch (e) {
            // Audio autoplay blocked or not supported - silently ignore
        }
    }

    // Firework shell blast
    function triggerBlast(x, y, count = 90) {
        playCrackerSound();
        for (let i = 0; i < count; i++) {
            const col = colors[Math.floor(Math.random() * colors.length)];
            const isConfetti = i % 3 === 0;
            const isSparkle = i % 4 === 0;
            particles.push(new Particle(x, y, col, isSparkle, isConfetti));
        }
    }

    // Sequential multi-stage cracker explosions
    function launchCelebration() {
        // Stage 1: Initial center burst
        triggerBlast(width * 0.5, height * 0.35, 120);

        // Stage 2: Left & right synchronized bursts
        setTimeout(() => triggerBlast(width * 0.25, height * 0.3, 100), 400);
        setTimeout(() => triggerBlast(width * 0.75, height * 0.32, 100), 700);

        // Stage 3: High center grand finale crackers
        setTimeout(() => {
            triggerBlast(width * 0.45, height * 0.22, 110);
            triggerBlast(width * 0.55, height * 0.25, 110);
        }, 1300);

        // Stage 4: Cascading confetti shower
        setTimeout(() => {
            for (let i = 0; i < 70; i++) {
                const rx = Math.random() * width;
                const ry = Math.random() * (height * 0.3);
                const col = colors[Math.floor(Math.random() * colors.length)];
                particles.push(new Particle(rx, ry, col, false, true));
            }
        }, 1800);
    }

    let animationId = null;
    function animate() {
        ctx.clearRect(0, 0, width, height);

        for (let i = particles.length - 1; i >= 0; i--) {
            const p = particles[i];
            p.update();
            p.draw(ctx);
            if (p.alpha <= 0) {
                particles.splice(i, 1);
            }
        }

        if (particles.length > 0) {
            animationId = requestAnimationFrame(animate);
        } else {
            ctx.clearRect(0, 0, width, height);
        }
    }

    // Auto-trigger on page arrival
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', () => {
            launchCelebration();
            requestAnimationFrame(animate);
        });
    } else {
        launchCelebration();
        requestAnimationFrame(animate);
    }
})();
</script>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
