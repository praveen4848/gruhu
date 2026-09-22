<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <script>
        // Dismiss alert message banners automatically after 4 seconds
        setTimeout(() => {
            const alerts = document.querySelectorAll('.admin-alert');
            alerts.forEach(a => {
                a.style.transition = 'opacity 0.5s ease';
                a.style.opacity = '0';
                setTimeout(() => a.remove(), 500);
            });
        }, 4000);
    </script>
</body>
</html>
