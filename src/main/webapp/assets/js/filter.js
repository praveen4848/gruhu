/**
 * Gruhu Atelier - Catalog Filtering & Facet Controls
 */

document.addEventListener('DOMContentLoaded', () => {
    const filterForm = document.getElementById('catalogFilterForm');
    if (!filterForm) return;

    // Price Range Synchronizer
    const priceRange = document.getElementById('priceRange');
    const priceDisplay = document.getElementById('priceDisplay');

    if (priceRange && priceDisplay) {
        priceRange.addEventListener('input', (e) => {
            const val = Number(e.target.value).toLocaleString('en-IN');
            priceDisplay.textContent = `₹${val}`;
        });

        priceRange.addEventListener('change', () => {
            filterForm.submit();
        });
    }

    // Sort Dropdown Auto-submit
    const sortSelect = document.getElementById('sortSelect');
    if (sortSelect) {
        sortSelect.addEventListener('change', () => {
            filterForm.submit();
        });
    }

    // Category / Material / Color radio and checkboxes
    const filterInputs = filterForm.querySelectorAll('input[type="radio"], input[type="checkbox"]');
    filterInputs.forEach(input => {
        input.addEventListener('change', () => {
            filterForm.submit();
        });
    });
});
