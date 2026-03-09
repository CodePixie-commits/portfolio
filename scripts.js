// Initialize Lucide icons
lucide.createIcons();

// Smooth scrolling for navigation links
document.querySelectorAll('.nav-link-custom, .brutalist-button, .brutalist-button-outline').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        const href = this.getAttribute('href');

        // Only handle internal hash links
        if (href && href.startsWith('#')) {
            e.preventDefault();
            const targetId = href.substring(1);
            const targetElement = document.getElementById(targetId);

            if (targetElement) {
                // Smooth scroll to target
                targetElement.scrollIntoView({
                    behavior: 'smooth'
                });

                // Update active state manually on click
                document.querySelectorAll('.nav-link-custom').forEach(link => {
                    link.classList.remove('active');
                });
                const navLink = document.getElementById('nav-' + targetId);
                if (navLink) navLink.classList.add('active');

                // Close mobile menu if open
                const navbarCollapse = document.getElementById('navbarContent');
                if (navbarCollapse && navbarCollapse.classList.contains('show')) {
                    bootstrap.Collapse.getInstance(navbarCollapse).hide();
                }
            }
        }
    });
});

// Section Spacing and Animation on Scroll
const sections = document.querySelectorAll('.section');
const navLinks = document.querySelectorAll('.nav-link-custom');

window.addEventListener('scroll', () => {
    let current = '';

    sections.forEach(section => {
        const sectionTop = section.offsetTop;
        const sectionHeight = section.clientHeight;
        if (pageYOffset >= sectionTop - 200) {
            current = section.getAttribute('id');
        }
    });

    navLinks.forEach(link => {
        link.classList.remove('active');
        if (link.getAttribute('href') === `#${current}`) {
            link.classList.add('active');
        }
    });
});

// Add hover effect specifically for the project "VIEW PROJECT" buttons
document.querySelectorAll('.hover-pink').forEach(button => {
    button.addEventListener('mouseenter', () => {
        button.style.color = '#ec4899';
    });
    button.addEventListener('mouseleave', () => {
        button.style.color = '#1e1b4b';
    });
});
