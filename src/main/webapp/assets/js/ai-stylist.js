/**
 * GRUHU ATELIER — AI SPATIAL STYLIST CLIENT CONTROLLER
 * Handles drawer interactions, photo upload & downscaling,
 * communication with /api/ai-stylist, dynamic rendering, and batch adding to bag.
 */

(function () {
    'use strict';

    // Cache DOM Elements
    const triggerBtn = document.getElementById('aiStylistTriggerBtn');
    const drawer = document.getElementById('aiStylistDrawer');
    const overlay = document.getElementById('aiStylistOverlay');
    const closeBtn = document.getElementById('aiDrawerCloseBtn');
    const streamContainer = document.getElementById('aiStreamContainer');
    const typingIndicator = document.getElementById('aiTypingIndicator');
    const inputForm = document.getElementById('aiInputForm');
    const textInput = document.getElementById('aiTextInput');
    const roomSelect = document.getElementById('aiRoomSelect');
    const budgetSelect = document.getElementById('aiBudgetSelect');
    const fileInput = document.getElementById('aiFileInput');
    const quickUploadBtn = document.getElementById('aiQuickUploadBtn');
    const dropzoneBox = document.getElementById('aiDropzoneBox');
    const dropzoneSection = document.getElementById('aiPhotoDropzoneSection');
    const scanPreviewBox = document.getElementById('aiScanPreviewBox');
    const previewImage = document.getElementById('aiPreviewImage');
    const promptChips = document.querySelectorAll('.ai-chip');
    const modeTabs = document.querySelectorAll('.ai-mode-tab');
    const toast = document.getElementById('aiToast');

    if (!triggerBtn || !drawer) {
        return; // Page doesn't have AI stylist elements
    }

    // Determine Context Path
    const contextPath = window.APP_CONTEXT_PATH || (function () {
        const link = document.querySelector('link[rel="stylesheet"]');
        if (link && link.href.includes('/assets/')) {
            const idx = link.href.indexOf('/assets/');
            const path = new URL(link.href).pathname;
            return path.substring(0, path.indexOf('/assets/'));
        }
        return '';
    })();

    let currentImageData = null;
    let isProcessing = false;

    // --- Drawer Visibility ---
    function openDrawer() {
        drawer.classList.add('active');
        if (overlay) overlay.classList.add('active');
        document.body.style.overflow = 'hidden';
        setTimeout(() => textInput && textInput.focus(), 350);
    }

    function closeDrawer() {
        drawer.classList.remove('active');
        if (overlay) overlay.classList.remove('active');
        document.body.style.overflow = '';
    }

    triggerBtn.addEventListener('click', openDrawer);
    if (closeBtn) closeBtn.addEventListener('click', closeDrawer);
    if (overlay) overlay.addEventListener('click', closeDrawer);

    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && drawer.classList.contains('active')) {
            closeDrawer();
        }
    });

    // --- Mode Tab Switching ---
    modeTabs.forEach(tab => {
        tab.addEventListener('click', () => {
            modeTabs.forEach(t => t.classList.remove('active'));
            tab.classList.add('active');
            const mode = tab.dataset.mode;
            if (mode === 'photo') {
                dropzoneSection.classList.add('active');
            } else {
                dropzoneSection.classList.remove('active');
            }
        });
    });

    // --- Prompt Suggestion Chips ---
    promptChips.forEach(chip => {
        chip.addEventListener('click', () => {
            const prompt = chip.dataset.prompt || chip.textContent.trim();
            if (textInput) {
                textInput.value = prompt;
                submitStylistQuery(prompt);
            }
        });
    });

    // --- Quick Upload Button ---
    if (quickUploadBtn && fileInput) {
        quickUploadBtn.addEventListener('click', () => fileInput.click());
    }

    if (dropzoneBox && fileInput) {
        dropzoneBox.addEventListener('click', () => fileInput.click());

        // Drag & Drop
        ['dragenter', 'dragover'].forEach(evt => {
            dropzoneBox.addEventListener(evt, (e) => {
                e.preventDefault();
                e.stopPropagation();
                dropzoneBox.classList.add('dragover');
            });
        });

        ['dragleave', 'drop'].forEach(evt => {
            dropzoneBox.addEventListener(evt, (e) => {
                e.preventDefault();
                e.stopPropagation();
                dropzoneBox.classList.remove('dragover');
            });
        });

        dropzoneBox.addEventListener('drop', (e) => {
            const dt = e.dataTransfer;
            const files = dt.files;
            if (files && files.length > 0) {
                handleSelectedImage(files[0]);
            }
        });
    }

    if (fileInput) {
        fileInput.addEventListener('change', (e) => {
            if (e.target.files && e.target.files.length > 0) {
                handleSelectedImage(e.target.files[0]);
            }
        });
    }

    // --- Image Processing & Canvas Resizing ---
    function handleSelectedImage(file) {
        if (!file.type.match('image.*')) {
            showToast('Please upload a valid interior room image (JPG, PNG, WebP).');
            return;
        }

        const reader = new FileReader();
        reader.onload = function (e) {
            const img = new Image();
            img.onload = function () {
                // Downscale image via canvas to max 1024x1024
                const maxDim = 1024;
                let w = img.width;
                let h = img.height;
                if (w > maxDim || h > maxDim) {
                    if (w > h) {
                        h = Math.round((h * maxDim) / w);
                        w = maxDim;
                    } else {
                        w = Math.round((w * maxDim) / h);
                        h = maxDim;
                    }
                }

                const canvas = document.createElement('canvas');
                canvas.width = w;
                canvas.height = h;
                const ctx = canvas.getContext('2d');
                ctx.drawImage(img, 0, 0, w, h);

                currentImageData = canvas.toDataURL('image/jpeg', 0.85);

                // Show preview with animated laser scan
                if (previewImage) previewImage.src = currentImageData;
                if (scanPreviewBox) scanPreviewBox.classList.add('active');

                // Switch to active consultation
                appendUserPhotoMessage(currentImageData);
                submitStylistQuery("Analyze this room photo and curate harmonious Scandinavian pieces to complete the space.");
            };
            img.src = e.target.result;
        };
        reader.readAsDataURL(file);
    }

    // --- Message Submission ---
    if (inputForm) {
        inputForm.addEventListener('submit', (e) => {
            e.preventDefault();
            const query = textInput.value.trim();
            if (!query && !currentImageData) return;
            textInput.value = '';
            submitStylistQuery(query);
        });
    }

    function submitStylistQuery(queryText) {
        if (isProcessing) return;
        isProcessing = true;

        if (queryText && !currentImageData) {
            appendUserTextMessage(queryText);
        }

        showTyping(true);

        const roomType = roomSelect ? roomSelect.value : 'living_room';
        const budget = budgetSelect ? budgetSelect.value : '0';

        const payload = {
            query: queryText,
            roomType: roomType,
            budget: budget,
            image: currentImageData || '',
            mimeType: 'image/jpeg'
        };

        const formData = new URLSearchParams();
        formData.append('query', payload.query || '');
        formData.append('roomType', payload.roomType || '');
        formData.append('budget', payload.budget || '0');
        if (payload.image) {
            formData.append('image', payload.image);
            formData.append('mimeType', 'image/jpeg');
        }

        fetch(contextPath + '/api/ai-stylist', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            },
            body: formData.toString()
        })
        .then(res => res.json())
        .then(data => {
            showTyping(false);
            isProcessing = false;
            currentImageData = null; // reset image
            if (scanPreviewBox) scanPreviewBox.classList.remove('active');

            if (data && data.success) {
                renderStylistResponse(data);
            } else {
                appendStylistTextMessage("Our studio architect is currently consulting on private commissions. Please try another query or explore our featured catalog.");
            }
        })
        .catch(err => {
            console.error('AI Stylist error:', err);
            showTyping(false);
            isProcessing = false;
            currentImageData = null;
            if (scanPreviewBox) scanPreviewBox.classList.remove('active');
            appendStylistTextMessage("We encountered a momentary connection interruption with the atelier engine. Please re-send your query.");
        });
    }

    // --- Render Messages ---
    function appendUserTextMessage(text) {
        const msg = document.createElement('div');
        msg.className = 'ai-msg ai-msg-user';
        msg.innerHTML = `
            <div class="ai-avatar ai-avatar-user"><i class="fa-solid fa-user"></i></div>
            <div class="ai-msg-bubble">${escapeHtml(text)}</div>
        `;
        streamContainer.appendChild(msg);
        scrollToBottom();
    }

    function appendUserPhotoMessage(dataUrl) {
        const msg = document.createElement('div');
        msg.className = 'ai-msg ai-msg-user';
        msg.innerHTML = `
            <div class="ai-avatar ai-avatar-user"><i class="fa-solid fa-camera"></i></div>
            <div class="ai-msg-bubble" style="padding: 6px; max-width: 220px;">
                <img src="${dataUrl}" alt="Space Scan" style="width: 100%; border-radius: 6px; display: block;">
                <span style="font-size: 0.72rem; opacity: 0.85; display: block; margin-top: 4px; text-align: center;">Spatial Scan Uploaded</span>
            </div>
        `;
        streamContainer.appendChild(msg);
        scrollToBottom();
    }

    function appendStylistTextMessage(text) {
        const msg = document.createElement('div');
        msg.className = 'ai-msg ai-msg-stylist';
        msg.innerHTML = `
            <div class="ai-avatar ai-avatar-stylist"><i class="fa-solid fa-wand-magic-sparkles"></i></div>
            <div class="ai-msg-bubble">${escapeHtml(text)}</div>
        `;
        streamContainer.appendChild(msg);
        scrollToBottom();
    }

    function renderStylistResponse(data) {
        const msg = document.createElement('div');
        msg.className = 'ai-msg ai-msg-stylist';

        let paletteHtml = '';
        if (data.palette && data.palette.length > 0) {
            paletteHtml = `
                <div class="ai-palette-section">
                    <div class="ai-palette-heading"><i class="fa-solid fa-palette"></i> Harmonious Color Palette</div>
                    <div class="ai-palette-swatches">
                        ${data.palette.map(c => `
                            <div class="ai-swatch-item" title="${escapeHtml(c.name)} (${escapeHtml(c.hex)})">
                                <div class="ai-swatch-circle" style="background-color: ${escapeHtml(c.hex)};"></div>
                                <span class="ai-swatch-name">${escapeHtml(c.name)}</span>
                            </div>
                        `).join('')}
                    </div>
                </div>
            `;
        }

        let productsHtml = '';
        const productIds = [];
        if (data.products && data.products.length > 0) {
            productsHtml = `
                <div class="ai-ensemble-heading">
                    <span>Curated Atelier Ensemble</span>
                    <span style="font-size: 0.75rem; color: #8c734b; font-family: 'Plus Jakarta Sans', sans-serif;">${data.products.length} Pieces</span>
                </div>
                <div class="ai-ensemble-list">
                    ${data.products.map(p => {
                        productIds.push(p.productId);
                        const origPrice = p.price > p.discountedPrice ? `<span class="ai-product-price-orig">₹${formatInr(p.price)}</span>` : '';
                        return `
                            <div class="ai-product-card" data-product-id="${p.productId}">
                                <div class="ai-product-thumb">
                                    <img src="${escapeHtml(p.imageUrl)}" alt="${escapeHtml(p.productName)}" loading="lazy">
                                </div>
                                <div class="ai-product-details">
                                    <div>
                                        <div class="ai-product-meta">
                                            <span>${escapeHtml(p.categoryName)}</span> &bull; <span>${escapeHtml(p.material)}</span>
                                        </div>
                                        <a href="${contextPath}/product?id=${p.productId}" target="_blank" class="ai-product-name">
                                            ${escapeHtml(p.productName)}
                                        </a>
                                        <p class="ai-product-rationale">“${escapeHtml(p.stylingRationale)}”</p>
                                    </div>
                                    <div class="ai-product-footer">
                                        <div class="ai-product-price">
                                            ₹${formatInr(p.discountedPrice)} ${origPrice}
                                        </div>
                                        <button type="button" class="ai-add-item-btn" onclick="window.gruhuAiStylist.addSingleProduct(${p.productId}, this)">
                                            <i class="fa-solid fa-plus"></i> Add to Bag
                                        </button>
                                    </div>
                                </div>
                            </div>
                        `;
                    }).join('')}
                </div>
            `;
        }

        let bundleHtml = '';
        if (data.products && data.products.length > 0) {
            bundleHtml = `
                <div class="ai-bundle-summary-card">
                    <div class="ai-bundle-badge">
                        <i class="fa-solid fa-crown"></i> Complete Ensemble Privilege
                    </div>
                    <h4 class="ai-bundle-title">${escapeHtml(data.suggestedStyle || 'Nordic Spatial Ensemble')}</h4>
                    <div class="ai-bundle-pricing-row">
                        <div>
                            <span class="ai-bundle-price-val">₹${formatInr(data.bundlePrice)}</span>
                            <span class="ai-bundle-orig-val">₹${formatInr(data.totalPrice)}</span>
                        </div>
                        <span class="ai-bundle-saving-tag">Save 10% Bundle Privilege</span>
                    </div>
                    <button type="button" class="ai-bundle-add-all-btn" onclick="window.gruhuAiStylist.addEntireEnsemble([${productIds.join(',')}], this)">
                        <i class="fa-solid fa-bag-shopping"></i> Add Complete Ensemble to Bag
                    </button>
                </div>
            `;
        }

        let tipsHtml = '';
        if (data.stylingTips && data.stylingTips.length > 0) {
            tipsHtml = `
                <div class="ai-tips-section">
                    <div class="ai-tips-heading"><i class="fa-solid fa-compass-drafting"></i> Architectural Placement Rules</div>
                    <ul class="ai-tips-list">
                        ${data.stylingTips.map(t => `<li>${escapeHtml(t)}</li>`).join('')}
                    </ul>
                </div>
            `;
        }

        msg.innerHTML = `
            <div class="ai-avatar ai-avatar-stylist"><i class="fa-solid fa-wand-magic-sparkles"></i></div>
            <div class="ai-msg-bubble" style="width: 100%;">
                <div class="ai-diagnosis-card">
                    <div class="ai-diagnosis-title">
                        <span>${escapeHtml(data.suggestedStyle || 'Spatial Analysis')}</span>
                        <span class="ai-engine-pill">${escapeHtml(data.engine || 'Atelier AI')}</span>
                    </div>
                    <p class="ai-diagnosis-text">${escapeHtml(data.diagnosis)}</p>
                    ${paletteHtml}
                </div>
                ${productsHtml}
                ${bundleHtml}
                ${tipsHtml}
            </div>
        `;

        streamContainer.appendChild(msg);
        scrollToBottom();
    }

    function showTyping(show) {
        if (!typingIndicator) return;
        if (show) {
            typingIndicator.classList.add('active');
            scrollToBottom();
        } else {
            typingIndicator.classList.remove('active');
        }
    }

    function scrollToBottom() {
        setTimeout(() => {
            if (streamContainer) {
                streamContainer.scrollTop = streamContainer.scrollHeight;
            }
        }, 50);
    }

    function showToast(message) {
        if (!toast) return;
        toast.innerHTML = `<i class="fa-solid fa-check-circle" style="color: #d4af37;"></i> <span>${escapeHtml(message)}</span>`;
        toast.classList.add('show');
        setTimeout(() => toast.classList.remove('show'), 3500);
    }

    function updateNavCartBadge(newCount) {
        const badge = document.getElementById('cartCountBadge');
        if (badge && typeof newCount !== 'undefined') {
            badge.textContent = newCount;
            badge.style.transform = 'scale(1.35)';
            setTimeout(() => { badge.style.transform = ''; }, 300);
        }
    }

    function formatInr(val) {
        if (!val) return '0';
        const num = parseFloat(val);
        return num.toLocaleString('en-IN', { maximumFractionDigits: 0 });
    }

    function escapeHtml(str) {
        if (!str) return '';
        return String(str)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&#39;');
    }

    // --- Global Methods for In-Card Actions ---
    window.gruhuAiStylist = {
        addSingleProduct: function (productId, btnElem) {
            if (!productId) return;
            const originalText = btnElem.innerHTML;
            btnElem.innerHTML = `<i class="fa-solid fa-circle-notch fa-spin"></i> Adding...`;
            btnElem.disabled = true;

            fetch(contextPath + '/cart?action=add&productId=' + productId + '&quantity=1&ajax=true', {
                method: 'POST'
            })
            .then(res => res.json())
            .then(data => {
                btnElem.innerHTML = `<i class="fa-solid fa-check"></i> Added`;
                btnElem.style.background = '#10b981';
                btnElem.style.color = '#ffffff';
                btnElem.style.borderColor = '#10b981';

                if (data && typeof data.cartCount !== 'undefined') {
                    updateNavCartBadge(data.cartCount);
                }
                showToast("Sculptural piece added to your Atelier Bag.");
            })
            .catch(err => {
                console.error(err);
                btnElem.innerHTML = originalText;
                btnElem.disabled = false;
                showToast("Unable to add piece. Please try again.");
            });
        },

        addEntireEnsemble: function (productIds, btnElem) {
            if (!productIds || productIds.length === 0) return;

            const originalText = btnElem.innerHTML;
            btnElem.innerHTML = `<i class="fa-solid fa-circle-notch fa-spin"></i> Adding Ensemble to Bag...`;
            btnElem.disabled = true;

            // Sequential async add to avoid race conditions on guest cart
            let chain = Promise.resolve();
            let finalCount = 0;

            productIds.forEach(id => {
                chain = chain.then(() => {
                    return fetch(contextPath + '/cart?action=add&productId=' + id + '&quantity=1&ajax=true', {
                        method: 'POST'
                    })
                    .then(r => r.json())
                    .then(d => {
                        if (d && typeof d.cartCount !== 'undefined') {
                            finalCount = d.cartCount;
                        }
                    });
                });
            });

            chain.then(() => {
                btnElem.innerHTML = `<i class="fa-solid fa-check"></i> Entire Ensemble in Bag`;
                btnElem.classList.add('added');
                updateNavCartBadge(finalCount);
                showToast(`Harmonious ${productIds.length}-piece ensemble added to your Atelier Bag!`);
            })
            .catch(err => {
                console.error(err);
                btnElem.innerHTML = originalText;
                btnElem.disabled = false;
                showToast("Unable to add ensemble. Please try again.");
            });
        }
    };

})();
