<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/navbar.jsp" %>

<main class="home-main">

    <!-- About Hero -->
    <section class="hero-section" style="padding: 90px 40px 70px; text-align: center;">
        <div style="max-width: 800px; margin: 0 auto;">
            <span class="hero-eyebrow">The Atelier Chronicle</span>
            <h1 class="hero-title" style="font-size: 3.5rem;">Designing for Quiet Presence.</h1>
            <p class="hero-desc" style="margin-left: auto; margin-right: auto;">
                Gruhu was founded on a simple premise: our living environments profoundly shape our mental wellbeing. We make furniture that anchors spaces with unpretentious grace and timeless honesty.
            </p>
        </div>
    </section>

    <!-- Narrative Section -->
    <section class="home-section" style="padding: 80px 40px;">
        <div class="section-container" style="display: grid; grid-template-columns: 1fr 1fr; gap: 70px; align-items: center;">
            <div style="border-radius: var(--radius-sm); overflow: hidden; box-shadow: var(--shadow-medium);">
                <img src="https://images.unsplash.com/photo-1581539250439-c96689b516dd?auto=format&fit=crop&w=1200&q=80" 
                     alt="Gruhu Workshop Artisan Hand-Finishing Oak">
            </div>

            <div>
                <span class="section-subtitle">Our Heritage</span>
                <h2 class="section-title" style="margin-bottom: 24px;">Born in Bengaluru, Steeped in Nordic Serenity.</h2>
                <p style="font-size: 1.05rem; line-height: 1.8; color: var(--text-secondary); margin-bottom: 20px;">
                    Named after the ancient Sanskrit word for dwelling (<em>Gruha</em>), Gruhu unites the clean, functional lines of Scandinavian design with India&rsquo;s unmatched heritage of artisanal woodcraft.
                </p>
                <p style="font-size: 1.05rem; line-height: 1.8; color: var(--text-secondary); margin-bottom: 30px;">
                    We reject the cycle of fast, disposable flat-pack furniture. Instead, every chair, bedframe, and luminaire is engineered to be repairable, durable, and resilient for generations.
                </p>
                <div style="display: flex; gap: 30px;">
                    <div>
                        <strong style="font-family: var(--font-serif); font-size: 2.2rem; color: var(--dark-espresso); display: block;">100%</strong>
                        <span style="font-size: 0.85rem; color: var(--text-muted);">Sustainably Harvested Timber</span>
                    </div>
                    <div>
                        <strong style="font-family: var(--font-serif); font-size: 2.2rem; color: var(--dark-espresso); display: block;">Zero</strong>
                        <span style="font-size: 0.85rem; color: var(--text-muted);">Synthetic VOC Off-gassing</span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- 4 Tenets -->
    <section class="craft-philosophy-section">
        <div class="section-container">
            <div style="text-align: center; max-width: 700px; margin: 0 auto 50px;">
                <span class="section-subtitle">Core Philosophy</span>
                <h2 class="craft-title">The Four Tenets of Gruhu</h2>
            </div>

            <div class="craft-features-grid" style="grid-template-columns: repeat(4, 1fr);">
                <div class="craft-feature" style="background: #fff; padding: 30px; border-radius: var(--radius-sm); border: 1px solid var(--border-subtle);">
                    <div class="craft-icon"><i class="fa-solid fa-feather"></i></div>
                    <h4>1. Visual Weightlessness</h4>
                    <p>Profiles that respect natural airflow and room illumination without crowding the eye.</p>
                </div>

                <div class="craft-feature" style="background: #fff; padding: 30px; border-radius: var(--radius-sm); border: 1px solid var(--border-subtle);">
                    <div class="craft-icon"><i class="fa-solid fa-gem"></i></div>
                    <h4>2. Honest Materiality</h4>
                    <p>Real stone, genuine timber, un-dyed wool, and hand-bent metal left to age gracefully.</p>
                </div>

                <div class="craft-feature" style="background: #fff; padding: 30px; border-radius: var(--radius-sm); border: 1px solid var(--border-subtle);">
                    <div class="craft-icon"><i class="fa-solid fa-shield-heart"></i></div>
                    <h4>3. Human Ergonomics</h4>
                    <p>Angles tested extensively for deep dinner conversations and unhurried reading.</p>
                </div>

                <div class="craft-feature" style="background: #fff; padding: 30px; border-radius: var(--radius-sm); border: 1px solid var(--border-subtle);">
                    <div class="craft-icon"><i class="fa-solid fa-leaf"></i></div>
                    <h4>4. Circular Longevity</h4>
                    <p>Repairable components and zero plastic packaging on all nationwide shipments.</p>
                </div>
            </div>
        </div>
    </section>

</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
