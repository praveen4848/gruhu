// Gruhu - Scandinavian Interior & Home Atelier Main JS

document.addEventListener('DOMContentLoaded', () => {
    // Mobile navigation menu toggle
    const toggleBtn = document.getElementById('mobileToggleBtn');
    const navMenu = document.getElementById('navMenu');

    if (toggleBtn && navMenu) {
        toggleBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            navMenu.classList.toggle('active');
            const icon = toggleBtn.querySelector('i');
            if (icon) {
                if (navMenu.classList.contains('active')) {
                    icon.classList.remove('fa-bars');
                    icon.classList.add('fa-xmark');
                } else {
                    icon.classList.remove('fa-xmark');
                    icon.classList.add('fa-bars');
                }
            }
        });

        // Close when clicking outside
        document.addEventListener('click', (e) => {
            if (!navMenu.contains(e.target) && !toggleBtn.contains(e.target)) {
                navMenu.classList.remove('active');
                const icon = toggleBtn.querySelector('i');
                if (icon) {
                    icon.classList.remove('fa-xmark');
                    icon.classList.add('fa-bars');
                }
            }
        });
    }

    // User Dropdown toggle (Profile & Client Menu)
    const userDropdown = document.querySelector('.user-dropdown');
    const userBtn = document.querySelector('#userMenuBtn, .skanvi-user-btn, .user-btn');

    if (userDropdown && userBtn) {
        userBtn.addEventListener('click', (e) => {
            e.preventDefault();
            e.stopPropagation();
            userDropdown.classList.toggle('open');
        });

        document.addEventListener('click', (e) => {
            if (!userDropdown.contains(e.target)) {
                userDropdown.classList.remove('open');
            }
        });
    }

    // Auto-dismiss alert boxes after 5 seconds
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
            alert.style.opacity = '0';
            alert.style.transform = 'translateY(-10px)';
            setTimeout(() => alert.remove(), 500);
        }, 5000);
    });

    // =========================================================================
    // Skanvi Mega-Menu & Rooms Dropdown Interactions
    // =========================================================================
    const btnMegaToggle = document.getElementById('btnMegaToggle');
    const skanviMegaMenu = document.getElementById('skanviMegaMenu');
    const btnCloseMega = document.getElementById('btnCloseMega');

    const btnRoomsToggle = document.getElementById('btnRoomsToggle');
    const roomsDropdownMenu = document.getElementById('roomsDropdownMenu');
    const roomsNavItem = document.getElementById('roomsNavItem');

    if (btnMegaToggle && skanviMegaMenu) {
        btnMegaToggle.addEventListener('click', (e) => {
            e.stopPropagation();
            if (roomsDropdownMenu) roomsDropdownMenu.style.display = 'none';
            if (btnRoomsToggle) btnRoomsToggle.classList.remove('active');

            const isOpen = skanviMegaMenu.classList.toggle('open');
            btnMegaToggle.classList.toggle('active', isOpen);
            btnMegaToggle.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
        });

        if (btnCloseMega) {
            btnCloseMega.addEventListener('click', (e) => {
                e.stopPropagation();
                skanviMegaMenu.classList.remove('open');
                btnMegaToggle.classList.remove('active');
                btnMegaToggle.setAttribute('aria-expanded', 'false');
            });
        }

        // Dynamic Subcategories & Models on Hovering Column 1 & Column 2
        const megaCatItems = skanviMegaMenu.querySelectorAll('.mega-col-products .mega-nav-list li');
        const subcatHeading = document.getElementById('megaSubcatHeading');
        const subcatList = document.getElementById('megaSubcatList');
        const modelsHeading = document.getElementById('megaModelsHeading');
        const modelsList = document.getElementById('megaModelsList');

        const contextPath = (window.location.pathname.startsWith('/gruhu')) ? '/gruhu/' : '/';

        const catalogTaxonomy = {
            furniture: {
                heading: 'FURNITURE',
                subcategories: [
                    {
                        key: 'sofas',
                        name: 'Sofas',
                        icon: 'fa-solid fa-couch',
                        url: 'products?category=1&subcategory=1',
                        modelsTitle: 'SOFAS & SEATING',
                        models: [
                            { name: 'Two-Seater Sofa (3 items)', icon: 'fa-solid fa-couch', url: 'products?category=1&subcategory=1' },
                            { name: 'Three-Seater Sofa (2 items)', icon: 'fa-solid fa-couch', url: 'products?category=1&subcategory=1' },
                            { name: '4-Seater Sectional Sofa (3 items)', icon: 'fa-solid fa-couch', url: 'products?category=1&subcategory=1' }
                        ]
                    },
                    {
                        key: 'chairs',
                        name: 'Chairs',
                        icon: 'fa-solid fa-chair',
                        url: 'products?category=1&subcategory=2',
                        modelsTitle: 'CHAIRS & SEATING',
                        models: [
                            { name: 'Armchairs & Lounge (4 items)', icon: 'fa-solid fa-chair', url: 'products?category=1&subcategory=2' },
                            { name: 'Bar Stools & Counters (2 items)', icon: 'fa-solid fa-chair', url: 'products?category=1&subcategory=2' },
                            { name: 'Office Chairs Ergonomic (4 items)', icon: 'fa-solid fa-chair', url: 'products?category=1&subcategory=2' },
                            { name: 'Dining Chairs Sculpted (5 items)', icon: 'fa-solid fa-chair', url: 'products?category=1&subcategory=2' },
                            { name: 'Folding Guest Chairs (2 items)', icon: 'fa-solid fa-chair', url: 'products?category=1&subcategory=2' }
                        ]
                    },
                    {
                        key: 'beds',
                        name: 'Beds',
                        icon: 'fa-solid fa-bed',
                        url: 'products?category=1&subcategory=3',
                        modelsTitle: 'BEDS & PLATFORMS',
                        models: [
                            { name: 'Malmo Solid White Oak Platform Bed', icon: 'fa-solid fa-bed', url: 'products?category=1&subcategory=3' },
                            { name: 'Kobenhavn Minimalist Upholstered Bed', icon: 'fa-solid fa-bed', url: 'products?category=1&subcategory=3' },
                            { name: 'Stellana Natural Woven Cane Bedstead', icon: 'fa-solid fa-bed', url: 'products?category=1&subcategory=3' },
                            { name: 'Freja Integrated Storage Timber Bed', icon: 'fa-solid fa-bed', url: 'products?category=1&subcategory=3' }
                        ]
                    },
                    {
                        key: 'tables',
                        name: 'Tables',
                        icon: 'fa-solid fa-table',
                        url: 'products?category=1&subcategory=4',
                        modelsTitle: 'TABLES & DESKS',
                        models: [
                            { name: 'Coffee Tables (3 items)', icon: 'fa-solid fa-table', url: 'products?category=1&subcategory=4' },
                            { name: 'Dining Tables (2 items)', icon: 'fa-solid fa-table', url: 'products?category=1&subcategory=4' },
                            { name: 'Side Tables (4 items)', icon: 'fa-solid fa-table', url: 'products?category=1&subcategory=4' },
                            { name: 'Office Desks & Tables (4 items)', icon: 'fa-solid fa-table', url: 'products?category=1&subcategory=4' }
                        ]
                    },
                    {
                        key: 'storage',
                        name: 'Storage',
                        icon: 'fa-solid fa-box-archive',
                        url: 'products?category=1&subcategory=5',
                        modelsTitle: 'STORAGE & CABINETRY',
                        models: [
                            { name: 'Sideboards & Credenzas (2 items)', icon: 'fa-solid fa-box-archive', url: 'products?category=1&subcategory=5' },
                            { name: 'Drawers & Dressers (3 items)', icon: 'fa-solid fa-box-archive', url: 'products?category=1&subcategory=5' },
                            { name: 'Chests & Cabinets (4 items)', icon: 'fa-solid fa-box-archive', url: 'products?category=1&subcategory=5' }
                        ]
                    }
                ]
            },
            lights: {
                heading: 'LIGHTS',
                subcategories: [
                    {
                        key: 'floor_lamps',
                        name: 'Floor Lamps',
                        icon: 'fa-solid fa-lightbulb',
                        url: 'products?category=2&subcategory=6',
                        modelsTitle: 'FLOOR LAMPS',
                        models: [
                            { name: 'Pillar Architectural Brass Floor Lamp', icon: 'fa-solid fa-lightbulb', url: 'products?category=2&subcategory=6' },
                            { name: 'Arne Telescopic Oak Arc Floor Lamp', icon: 'fa-solid fa-lightbulb', url: 'products?category=2&subcategory=6' },
                            { name: 'Solstice Linear Diffused Studio Floor Lamp', icon: 'fa-solid fa-lightbulb', url: 'products?category=2&subcategory=6' },
                            { name: 'Klint Pleated Fabric Tripod Floor Lamp', icon: 'fa-solid fa-lightbulb', url: 'products?category=2&subcategory=6' }
                        ]
                    },
                    {
                        key: 'table_lamps',
                        name: 'Table Lamps',
                        icon: 'fa-solid fa-lamp',
                        url: 'products?category=2&subcategory=7',
                        modelsTitle: 'TABLE LAMPS',
                        models: [
                            { name: 'Eos Fluted Travertine Ceramic Table Lamp', icon: 'fa-solid fa-lamp', url: 'products?category=2&subcategory=7' },
                            { name: 'Forma Sculptural Dome Accent Lamp', icon: 'fa-solid fa-lamp', url: 'products?category=2&subcategory=7' },
                            { name: 'Astrid Smoked Glass Bedside Table Lamp', icon: 'fa-solid fa-lamp', url: 'products?category=2&subcategory=7' },
                            { name: 'Koto Solid Alabaster Glow Table Lamp', icon: 'fa-solid fa-lamp', url: 'products?category=2&subcategory=7' },
                            { name: 'Freja Cordless Rechargeable Table Lamp', icon: 'fa-solid fa-lamp', url: 'products?category=2&subcategory=7' }
                        ]
                    },
                    {
                        key: 'wall_lamps',
                        name: 'Wall Lamps',
                        icon: 'fa-solid fa-sun',
                        url: 'products?category=2&subcategory=8',
                        modelsTitle: 'WALL LAMPS & SCONCES',
                        models: [
                            { name: 'Aura Opal Glass Sculptural Wall Sconce', icon: 'fa-solid fa-sun', url: 'products?category=2&subcategory=8' },
                            { name: 'Nordic Articulated Swing Arm Wall Lamp', icon: 'fa-solid fa-sun', url: 'products?category=2&subcategory=8' },
                            { name: 'Lund Halo Backlit Wall Disc Luminaire', icon: 'fa-solid fa-sun', url: 'products?category=2&subcategory=8' }
                        ]
                    },
                    {
                        key: 'ceiling_lamps',
                        name: 'Ceiling Lamps',
                        icon: 'fa-solid fa-wand-magic-sparkles',
                        url: 'products?category=2&subcategory=9',
                        modelsTitle: 'PENDANTS & CHANDELIERS',
                        models: [
                            { name: 'Solstice Washi Lantern Pendant Ceiling Lamp', icon: 'fa-solid fa-wand-magic-sparkles', url: 'products?category=2&subcategory=9' },
                            { name: 'Halo 6-Light Architectural Chandelier', icon: 'fa-solid fa-wand-magic-sparkles', url: 'products?category=2&subcategory=9' }
                        ]
                    }
                ]
            },
            mirrors: {
                heading: 'MIRRORS',
                subcategories: [
                    {
                        key: 'round_mirrors',
                        name: 'Round Mirrors',
                        icon: 'fa-solid fa-circle-notch',
                        url: 'products?category=3&subcategory=10',
                        modelsTitle: 'ROUND MIRRORS',
                        models: [
                            { name: 'Astrid Solid Oak Beveled Round Mirror (80cm)', icon: 'fa-solid fa-circle-notch', url: 'products?category=3&subcategory=10' },
                            { name: 'Linnea Brushed Brass Minimalist Round Mirror (90cm)', icon: 'fa-solid fa-circle-notch', url: 'products?category=3&subcategory=10' }
                        ]
                    },
                    {
                        key: 'rectangle_mirrors',
                        name: 'Rectangle Mirrors',
                        icon: 'fa-regular fa-square',
                        url: 'products?category=3&subcategory=11',
                        modelsTitle: 'RECTANGLE MIRRORS',
                        models: [
                            { name: 'Haven Nordic Mitered Oak Rectangle Mirror', icon: 'fa-regular fa-square', url: 'products?category=3&subcategory=11' },
                            { name: 'Soren Antique Bronze Vanity Rectangle Mirror', icon: 'fa-regular fa-square', url: 'products?category=3&subcategory=11' },
                            { name: 'Freja Beveled Walnut Floating Rectangle Mirror', icon: 'fa-regular fa-square', url: 'products?category=3&subcategory=11' },
                            { name: 'Oslo Slimline Matte Black Wall Mirror', icon: 'fa-regular fa-square', url: 'products?category=3&subcategory=11' }
                        ]
                    },
                    {
                        key: 'full_length_mirrors',
                        name: 'Full Length Mirrors',
                        icon: 'fa-regular fa-gem',
                        url: 'products?category=3&subcategory=12',
                        modelsTitle: 'FULL LENGTH MIRRORS',
                        models: [
                            { name: 'Haven Arched Solid Oak Full-Length Mirror', icon: 'fa-regular fa-gem', url: 'products?category=3&subcategory=12' },
                            { name: 'Freja Free-Standing Dressing Timber Mirror', icon: 'fa-regular fa-gem', url: 'products?category=3&subcategory=12' },
                            { name: 'Koto Pill-Shaped Brass Full-Length Mirror', icon: 'fa-regular fa-gem', url: 'products?category=3&subcategory=12' },
                            { name: 'Astrid Organic Asymmetric Full-Length Mirror', icon: 'fa-regular fa-gem', url: 'products?category=3&subcategory=12' },
                            { name: 'Malmo Floor Leaning Wide Oak Mirror', icon: 'fa-regular fa-gem', url: 'products?category=3&subcategory=12' }
                        ]
                    }
                ]
            },
            accessories: {
                heading: 'ACCESSORIES',
                subcategories: [
                    {
                        key: 'wall_clocks',
                        name: 'Wall Clocks',
                        icon: 'fa-regular fa-clock',
                        url: 'products?category=4&subcategory=13',
                        modelsTitle: 'WALL CLOCKS',
                        models: [
                            { name: 'Koto Minimalist Solid Oak Dial Wall Clock', icon: 'fa-regular fa-clock', url: 'products?category=4&subcategory=13' },
                            { name: 'Stockholm Brushed Brass Rimless Wall Clock', icon: 'fa-regular fa-clock', url: 'products?category=4&subcategory=13' },
                            { name: 'Astrid Slate Monolithic Floating Wall Clock', icon: 'fa-regular fa-clock', url: 'products?category=4&subcategory=13' },
                            { name: 'Nordic Silent Sweep Terrazzo Wall Clock', icon: 'fa-regular fa-clock', url: 'products?category=4&subcategory=13' }
                        ]
                    },
                    {
                        key: 'wall_paintings',
                        name: 'Wall Paintings',
                        icon: 'fa-regular fa-image',
                        url: 'products?category=4&subcategory=14',
                        modelsTitle: 'WALL PAINTINGS & CANVAS ART',
                        models: [
                            { name: 'Atelier Earth & Stone Abstract Canvas', icon: 'fa-regular fa-image', url: 'products?category=4&subcategory=14' },
                            { name: 'Nordic Horizon Minimalist Textured Canvas', icon: 'fa-regular fa-image', url: 'products?category=4&subcategory=14' },
                            { name: 'Tactile Gesso Relief Architectural Canvas', icon: 'fa-regular fa-image', url: 'products?category=4&subcategory=14' }
                        ]
                    },
                    {
                        key: 'vases',
                        name: 'Vases',
                        icon: 'fa-solid fa-flask',
                        url: 'products?category=4&subcategory=15',
                        modelsTitle: 'CERAMIC & GLASS VASES',
                        models: [
                            { name: 'Forma Sculptural Ceramic Amphora Vase', icon: 'fa-solid fa-flask', url: 'products?category=4&subcategory=15' },
                            { name: 'Torus Hand-Blown Fluted Glass Silhouette Vase', icon: 'fa-solid fa-flask', url: 'products?category=4&subcategory=15' },
                            { name: 'Klint Matte Stoneware Ribbed Ikebana Vase', icon: 'fa-solid fa-flask', url: 'products?category=4&subcategory=15' }
                        ]
                    },
                    {
                        key: 'candle_stands',
                        name: 'Candle Stands',
                        icon: 'fa-solid fa-fire-flame-curved',
                        url: 'products?category=4&subcategory=16',
                        modelsTitle: 'CANDLE STANDS & HOLDERS',
                        models: [
                            { name: 'Freja Solid Cast Brass Sculptural Candelabra', icon: 'fa-solid fa-fire-flame-curved', url: 'products?category=4&subcategory=16' },
                            { name: 'Soren Turned Smoked Oak Pillar Candle Stand Set', icon: 'fa-solid fa-fire-flame-curved', url: 'products?category=4&subcategory=16' }
                        ]
                    }
                ]
            }
        };

        function renderModels(subcat) {
            if (!subcat) return;
            if (modelsHeading) {
                modelsHeading.textContent = subcat.modelsTitle || subcat.name.toUpperCase();
            }
            if (modelsList) {
                modelsList.innerHTML = (subcat.models || []).map(mod => `
                    <li>
                        <a href="${contextPath}${mod.url}">
                            <span class="mega-item-left"><i class="${mod.icon}"></i> ${mod.name}</span>
                        </a>
                    </li>
                `).join('');
            }
        }

        function renderSubcategories(catKey) {
            const catData = catalogTaxonomy[catKey];
            if (!catData) return;

            if (subcatHeading) {
                subcatHeading.textContent = catData.heading;
            }

            if (subcatList) {
                subcatList.innerHTML = catData.subcategories.map((sub, idx) => `
                    <li class="${idx === 0 ? 'active' : ''}" data-sub-idx="${idx}">
                        <a href="${contextPath}${sub.url}">
                            <span class="mega-item-left"><i class="${sub.icon}"></i> ${sub.name}</span>
                            <span class="mega-item-plus">+</span>
                        </a>
                    </li>
                `).join('');

                // Bind hover events to Column 2 subcategory items
                const subcatListItems = subcatList.querySelectorAll('li');
                subcatListItems.forEach((li, idx) => {
                    li.addEventListener('mouseenter', () => {
                        subcatListItems.forEach(i => i.classList.remove('active'));
                        li.classList.add('active');
                        renderModels(catData.subcategories[idx]);
                    });
                });
            }

            // Initially render Column 3 with models of first subcategory
            if (catData.subcategories && catData.subcategories.length > 0) {
                renderModels(catData.subcategories[0]);
            }
        }

        // Bind hover events to Column 1 category items
        megaCatItems.forEach(item => {
            item.addEventListener('mouseenter', () => {
                const cat = item.getAttribute('data-cat');
                if (!cat || !catalogTaxonomy[cat]) return;

                megaCatItems.forEach(i => i.classList.remove('active'));
                item.classList.add('active');
                renderSubcategories(cat);
            });
        });

        // Initialize Column 2 hover events on page load for default Furniture
        const defaultSubcatItems = subcatList ? subcatList.querySelectorAll('li') : [];
        defaultSubcatItems.forEach((li, idx) => {
            li.addEventListener('mouseenter', () => {
                defaultSubcatItems.forEach(i => i.classList.remove('active'));
                li.classList.add('active');
                const catData = catalogTaxonomy['furniture'];
                if (catData && catData.subcategories[idx]) {
                    renderModels(catData.subcategories[idx]);
                }
            });
        });
    }

    // Rooms Dropdown toggle
    if (btnRoomsToggle && roomsDropdownMenu) {
        btnRoomsToggle.addEventListener('click', (e) => {
            e.stopPropagation();
            if (skanviMegaMenu) skanviMegaMenu.classList.remove('open');
            if (btnMegaToggle) btnMegaToggle.classList.remove('active');

            const isShown = roomsDropdownMenu.style.display === 'block';
            roomsDropdownMenu.style.display = isShown ? 'none' : 'block';
            btnRoomsToggle.classList.toggle('active', !isShown);
            btnRoomsToggle.setAttribute('aria-expanded', !isShown ? 'true' : 'false');
        });
    }

    // Close menus when clicking outside or pressing Escape
    document.addEventListener('click', (e) => {
        if (skanviMegaMenu && !skanviMegaMenu.contains(e.target) && btnMegaToggle && !btnMegaToggle.contains(e.target)) {
            skanviMegaMenu.classList.remove('open');
            btnMegaToggle.classList.remove('active');
            btnMegaToggle.setAttribute('aria-expanded', 'false');
        }
        if (roomsDropdownMenu && !roomsDropdownMenu.contains(e.target) && btnRoomsToggle && !btnRoomsToggle.contains(e.target)) {
            roomsDropdownMenu.style.display = 'none';
            if (btnRoomsToggle) {
                btnRoomsToggle.classList.remove('active');
                btnRoomsToggle.setAttribute('aria-expanded', 'false');
            }
        }
    });

    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
            if (skanviMegaMenu) {
                skanviMegaMenu.classList.remove('open');
                if (btnMegaToggle) {
                    btnMegaToggle.classList.remove('active');
                    btnMegaToggle.setAttribute('aria-expanded', 'false');
                }
            }
            if (roomsDropdownMenu) {
                roomsDropdownMenu.style.display = 'none';
                if (btnRoomsToggle) {
                    btnRoomsToggle.classList.remove('active');
                    btnRoomsToggle.setAttribute('aria-expanded', 'false');
                }
            }
        }
    });

    // =========================================================================
    // "What are you looking for?" Infinite Horizontal Category Carousel
    // =========================================================================
    const carouselPrevBtn = document.getElementById('carouselPrevBtn');
    const carouselNextBtn = document.getElementById('carouselNextBtn');
    const lookingForTrack = document.getElementById('lookingForTrack');
    const sliderProgressThumb = document.getElementById('sliderProgressThumb');

    if (lookingForTrack && carouselPrevBtn && carouselNextBtn) {
        // Clone initial cards to enable endless wrapping
        const originalCards = Array.from(lookingForTrack.children);
        originalCards.forEach(card => {
            const clone = card.cloneNode(true);
            clone.setAttribute('aria-hidden', 'true');
            lookingForTrack.appendChild(clone);
        });

        function getSingleSetWidth() {
            if (originalCards.length < 2) return lookingForTrack.scrollWidth / 2;
            const first = originalCards[0];
            const clonedFirst = lookingForTrack.children[originalCards.length];
            if (clonedFirst && first) {
                const diff = clonedFirst.offsetLeft - first.offsetLeft;
                if (diff > 0) return diff;
            }
            return lookingForTrack.scrollWidth / 2;
        }

        let isPaused = false;
        let isManualScrolling = false;
        let manualScrollTimeout = null;
        let currentScrollPos = lookingForTrack.scrollLeft;
        let lastTimestamp = null;
        const speedPixelsPerSecond = 88; // Energetic smooth continuous motion (~88px/sec)

        function step(timestamp) {
            if (!lastTimestamp) lastTimestamp = timestamp;
            const delta = Math.min((timestamp - lastTimestamp) / 1000, 0.1);
            lastTimestamp = timestamp;

            const singleSetWidth = getSingleSetWidth();

            if (!isPaused && !isManualScrolling && singleSetWidth > 0) {
                currentScrollPos += speedPixelsPerSecond * delta;
                if (currentScrollPos >= singleSetWidth) {
                    currentScrollPos -= singleSetWidth;
                }
                lookingForTrack.scrollLeft = currentScrollPos;
            } else {
                currentScrollPos = lookingForTrack.scrollLeft;
            }

            // Sync visual progress thumb
            if (sliderProgressThumb && singleSetWidth > 0) {
                const scrollPort = Math.max(1, singleSetWidth);
                const pct = (lookingForTrack.scrollLeft % singleSetWidth) / scrollPort;
                const maxMove = 260 * (1 - 0.35);
                sliderProgressThumb.style.transform = 'translateX(' + Math.min(maxMove, Math.max(0, pct * maxMove)) + 'px)';
            }

            requestAnimationFrame(step);
        }
        requestAnimationFrame(step);

        // Pause on Hover & Touch
        lookingForTrack.addEventListener('mouseenter', () => { isPaused = true; });
        lookingForTrack.addEventListener('mouseleave', () => { 
            isPaused = false; 
            currentScrollPos = lookingForTrack.scrollLeft; 
            lastTimestamp = null; 
        });

        lookingForTrack.addEventListener('touchstart', () => { isPaused = true; }, { passive: true });
        lookingForTrack.addEventListener('touchend', () => { 
            isPaused = false; 
            currentScrollPos = lookingForTrack.scrollLeft; 
            lastTimestamp = null; 
        }, { passive: true });

        // Manual Navigation Buttons
        function triggerManualScroll(direction) {
            isManualScrolling = true;
            isPaused = true;
            clearTimeout(manualScrollTimeout);

            const singleSetWidth = getSingleSetWidth();
            const stepAmount = 294; // Exact single card width (270px) + gap (24px)

            if (direction === 'prev' && lookingForTrack.scrollLeft <= 20 && singleSetWidth > 0) {
                lookingForTrack.scrollLeft += singleSetWidth;
                currentScrollPos = lookingForTrack.scrollLeft;
            }

            lookingForTrack.scrollBy({ left: direction === 'next' ? stepAmount : -stepAmount, behavior: 'smooth' });

            manualScrollTimeout = setTimeout(() => {
                currentScrollPos = lookingForTrack.scrollLeft;
                isManualScrolling = false;
                isPaused = false;
                lastTimestamp = null;
            }, 450);
        }

        carouselNextBtn.addEventListener('click', () => triggerManualScroll('next'));
        carouselPrevBtn.addEventListener('click', () => triggerManualScroll('prev'));

        carouselNextBtn.addEventListener('mouseenter', () => { isPaused = true; });
        carouselNextBtn.addEventListener('mouseleave', () => { isPaused = false; lastTimestamp = null; });
        carouselPrevBtn.addEventListener('mouseenter', () => { isPaused = true; });
        carouselPrevBtn.addEventListener('mouseleave', () => { isPaused = false; lastTimestamp = null; });

        // Natural user swipe/drag handling
        lookingForTrack.addEventListener('scroll', () => {
            const singleSetWidth = getSingleSetWidth();
            if (singleSetWidth > 0) {
                if (lookingForTrack.scrollLeft >= singleSetWidth * 1.95) {
                    lookingForTrack.scrollLeft -= singleSetWidth;
                    currentScrollPos = lookingForTrack.scrollLeft;
                } else if (lookingForTrack.scrollLeft <= 5 && isManualScrolling) {
                    lookingForTrack.scrollLeft += singleSetWidth;
                    currentScrollPos = lookingForTrack.scrollLeft;
                }
            }
        }, { passive: true });

        window.addEventListener('load', () => {
            currentScrollPos = lookingForTrack.scrollLeft;
        });
        window.addEventListener('resize', () => {
            currentScrollPos = lookingForTrack.scrollLeft;
        });
    }

    // =========================================================================
    // Full-Width Hero Background Video Ambient Controls
    // =========================================================================
    const heroBgVideo = document.getElementById('heroBgVideo');
    const heroVideoCtrlBtn = document.getElementById('heroVideoCtrlBtn');
    if (heroBgVideo && heroVideoCtrlBtn) {
        heroVideoCtrlBtn.addEventListener('click', () => {
            if (heroBgVideo.paused) {
                heroBgVideo.play();
                heroVideoCtrlBtn.innerHTML = '<i class="fa-solid fa-pause"></i> <span class="video-ctrl-text">Motion</span>';
            } else {
                heroBgVideo.pause();
                heroVideoCtrlBtn.innerHTML = '<i class="fa-solid fa-play"></i> <span class="video-ctrl-text">Paused</span>';
            }
        });
    }

    // =========================================================================
    // Active Products Showcase Filter Tabs (Category & Room filtering)
    // =========================================================================
    const showcaseTabs = document.querySelectorAll('#showcaseTabs .showcase-tab');
    const productCards = document.querySelectorAll('#homeProductGrid .product-card');

    if (showcaseTabs.length > 0 && productCards.length > 0) {
        showcaseTabs.forEach(tab => {
            tab.addEventListener('click', () => {
                showcaseTabs.forEach(t => t.classList.remove('active'));
                tab.classList.add('active');

                const filter = tab.getAttribute('data-filter');
                const roomFilter = tab.getAttribute('data-room');

                productCards.forEach(card => {
                    const cardCat = card.getAttribute('data-cat');
                    const cardRooms = (card.getAttribute('data-room') || '').toLowerCase();

                    let match = true;
                    if (filter && filter !== 'all') {
                        match = match && (cardCat === filter);
                    }
                    if (roomFilter && roomFilter !== 'all') {
                        match = match && (cardRooms.indexOf(roomFilter.toLowerCase()) !== -1);
                    }

                    card.style.display = match ? 'flex' : 'none';
                });
            });
        });
    }

    // Catalog Filter Dropdown Box in Left Corner
    const btnToggleFilters = document.getElementById('btnToggleFilters');
    const filterDropdownMenu = document.getElementById('filterDropdownMenu');
    const btnCloseFilterDropdown = document.getElementById('btnCloseFilterDropdown');

    if (btnToggleFilters && filterDropdownMenu) {
        btnToggleFilters.addEventListener('click', (e) => {
            e.stopPropagation();
            const isOpen = filterDropdownMenu.style.display === 'block';
            filterDropdownMenu.style.display = isOpen ? 'none' : 'block';
            btnToggleFilters.classList.toggle('open', !isOpen);
        });

        if (btnCloseFilterDropdown) {
            btnCloseFilterDropdown.addEventListener('click', (e) => {
                e.stopPropagation();
                filterDropdownMenu.style.display = 'none';
                btnToggleFilters.classList.remove('open');
            });
        }

        // Close when clicking outside
        document.addEventListener('click', (e) => {
            if (!filterDropdownMenu.contains(e.target) && !btnToggleFilters.contains(e.target)) {
                filterDropdownMenu.style.display = 'none';
                btnToggleFilters.classList.remove('open');
            }
        });
    }

    // =========================================================================
    // Seamless AJAX Add-to-Bag & Wishlist Interactions
    // =========================================================================
    document.addEventListener('submit', async function (e) {
        const form = e.target;
        if (!form || !form.action) return;

        const actionUrl = form.action;
        const isCartAdd = actionUrl.includes('/cart') && (
            form.classList.contains('card-v2-add-form') ||
            form.classList.contains('purchase-form') ||
            form.classList.contains('quick-add-form') ||
            (form.querySelector('input[name="action"]') && form.querySelector('input[name="action"]').value === 'add')
        );

        const isWishlistToggle = actionUrl.includes('/wishlist') && (
            form.classList.contains('card-v2-wishlist-form') ||
            (form.querySelector('input[name="action"]') && ['toggle', 'add', 'remove'].includes(form.querySelector('input[name="action"]').value))
        );

        if (!isCartAdd && !isWishlistToggle) {
            return;
        }

        e.preventDefault();

        const submitBtn = form.querySelector('button[type="submit"]') || form.querySelector('button');
        const originalBtnHtml = submitBtn ? submitBtn.innerHTML : null;
        if (submitBtn) {
            submitBtn.disabled = true;
        }

        try {
            const formData = new FormData(form);
            formData.append('ajax', 'true');

            const response = await fetch(actionUrl, {
                method: 'POST',
                body: new URLSearchParams(formData),
                headers: {
                    'X-Requested-With': 'XMLHttpRequest',
                    'Accept': 'application/json'
                }
            });

            if (response.ok) {
                const data = await response.json();

                if (isCartAdd) {
                    const cartBadge = document.getElementById('cartCountBadge');
                    if (cartBadge && typeof data.cartCount !== 'undefined') {
                        cartBadge.textContent = data.cartCount;
                    }
                    showToast(data.message || 'Added to your Atelier Bag.', 'success');

                    if (submitBtn) {
                        submitBtn.innerHTML = '<i class="fa-solid fa-check"></i> <span>Added</span>';
                        setTimeout(() => {
                            if (originalBtnHtml) submitBtn.innerHTML = originalBtnHtml;
                            submitBtn.disabled = false;
                        }, 1800);
                        return;
                    }
                } else if (isWishlistToggle) {
                    const wishlistBadge = document.getElementById('wishlistCountBadge');
                    if (wishlistBadge && typeof data.wishlistCount !== 'undefined') {
                        wishlistBadge.textContent = data.wishlistCount;
                    }
                    showToast(data.message || 'Wishlist updated.', 'success');

                    if (submitBtn) {
                        const heartIcon = submitBtn.querySelector('i');
                        if (heartIcon) {
                            if (data.inWishlist) {
                                heartIcon.classList.remove('fa-regular');
                                heartIcon.classList.add('fa-solid');
                                submitBtn.classList.add('active');
                            } else {
                                heartIcon.classList.remove('fa-solid');
                                heartIcon.classList.add('fa-regular');
                                submitBtn.classList.remove('active');
                            }
                        }
                    }

                    if (!data.inWishlist && window.location.pathname.includes('/wishlist')) {
                        const wishCard = form.closest('.wishlist-item') || form.closest('.product-card');
                        if (wishCard) {
                            wishCard.style.opacity = '0';
                            wishCard.style.transform = 'scale(0.95)';
                            wishCard.style.transition = 'all 0.3s ease';
                            setTimeout(() => wishCard.remove(), 300);
                        }
                    }
                }
            } else {
                showToast('Unable to complete request. Please try again.', 'error');
            }
        } catch (err) {
            console.error('AJAX cart/wishlist error:', err);
            form.submit();
            return;
        } finally {
            if (submitBtn && isWishlistToggle) {
                submitBtn.disabled = false;
            }
        }
    });
});

// Toast notification function
function showToast(message, type = 'success') {
    let container = document.getElementById('toast-container');
    if (!container) {
        container = document.createElement('div');
        container.id = 'toast-container';
        container.className = 'toast-container';
        document.body.appendChild(container);
    }

    const toast = document.createElement('div');
    toast.className = `toast-item toast-${type}`;
    const icon = type === 'success' ? 'fa-check' : 'fa-circle-exclamation';
    toast.innerHTML = `<i class="fa-solid ${icon}"></i> <span>${message}</span>`;

    container.appendChild(toast);

    setTimeout(() => {
        toast.classList.add('hide');
        setTimeout(() => toast.remove(), 400);
    }, 3500);
}
