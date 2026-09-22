/**
 * Gruhu Atelier - Architectural Search & Autocomplete
 */

document.addEventListener('DOMContentLoaded', () => {
    const searchModal = document.getElementById('searchModal');
    const openSearchBtns = document.querySelectorAll('[data-open-search]');
    const closeSearchBtns = document.querySelectorAll('[data-close-search]');
    const searchInput = document.getElementById('headerSearchInput');

    function openSearch() {
        if (searchModal) {
            searchModal.classList.add('active');
            document.body.style.overflow = 'hidden';
            if (searchInput) {
                setTimeout(() => searchInput.focus(), 150);
            }
        }
    }

    function closeSearch() {
        if (searchModal) {
            searchModal.classList.remove('active');
            document.body.style.overflow = '';
        }
    }

    openSearchBtns.forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.preventDefault();
            openSearch();
        });
    });

    closeSearchBtns.forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.preventDefault();
            closeSearch();
        });
    });

    // Keyboard Shortcuts: '/' or 'Ctrl+K' to open search, 'Escape' to close
    document.addEventListener('keydown', (e) => {
        if ((e.key === '/' && document.activeElement.tagName !== 'INPUT' && document.activeElement.tagName !== 'TEXTAREA') ||
            (e.key === 'k' && (e.ctrlKey || e.metaKey))) {
            e.preventDefault();
            openSearch();
        } else if (e.key === 'Escape') {
            closeSearch();
        }
    });

    // Close when clicking backdrop
    if (searchModal) {
        searchModal.addEventListener('click', (e) => {
            if (e.target === searchModal) {
                closeSearch();
            }
        });
    }
});
