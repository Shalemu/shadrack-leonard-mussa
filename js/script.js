

// Hero Dynamic Background
const hero = document.querySelector('.hero-section');
const images = [
  "images/banner3.jpg",
  "images/banner4.jpg",
  // "images/banner-4.jpg"
];
let currentIndex = 0;

function changeBackground() {
  if (hero) {
    hero.style.transition = "background-image 1.5s ease-in-out";
    hero.style.backgroundImage = `url(${images[currentIndex]})`;
    currentIndex = (currentIndex + 1) % images.length;
  }
}
changeBackground();
setInterval(changeBackground, 10000);


// Tagline Typing Effect
const tagline = document.getElementById("tagline");
if (tagline) {
  const text = tagline.textContent;
  tagline.textContent = "";
  let i = 0;
  function typeEffect() {
    if (i < text.length) {
      tagline.textContent += text.charAt(i);
      i++;
      setTimeout(typeEffect, 100);
    } else {
      tagline.classList.add('blink-cursor');
    }
  }
  typeEffect();
}


// Section Display & Menu
const menuLinks = document.querySelectorAll('.nav-link');
const allSections = document.querySelectorAll('section');

const sectionGroups = {
  home: ['home-section'],
  about: ['about-section'],
  product: ['product-category'], 
  'store-locator': ['store-locator-section'],
  partner: ['partner-section'],
  contact: ['contact-section'],
  news: ['news-section'],
  testimonial: ['testimonial-section']
};

function showSection(sectionClass) {
  allSections.forEach(sec => {
    if (!sec.classList.contains('footer-section')) {
      sec.style.display = 'none';
      sec.style.opacity = 0;
      sec.classList.remove("active");
    }
  });

  const sectionsToShow = document.querySelectorAll(`.${sectionClass}`);
  sectionsToShow.forEach(sec => {
    sec.style.display = 'block';
    sec.style.opacity = 0;
    sec.style.transform = "translateY(40px)";
    sec.style.transition = "opacity 1s ease, transform 1s ease";
    setTimeout(() => {
      sec.style.opacity = 1;
      sec.style.transform = "translateY(0)";
      sec.classList.add("active");
    }, 100);
  });

 
  if (sectionClass === 'home-section') {
    document.getElementById('cart-section').style.display = 'none';
    document.getElementById('products-section').style.display = 'none';
    document.getElementById('products-grid').innerHTML = '';
  }

  const header = document.querySelector("header");
  const headerOffset = header ? header.offsetHeight : 80;
  const firstSection = sectionsToShow[0];
  if (firstSection) {
    const elementPosition = firstSection.getBoundingClientRect().top + window.scrollY;
    const offsetPosition = elementPosition - headerOffset - 20;
    window.scrollTo({ top: offsetPosition, behavior: 'smooth' });
  }
}


menuLinks.forEach(link => {
  link.addEventListener('click', e => {
    e.preventDefault();
    const targetId = link.getAttribute('href').substring(1);

    if (sectionGroups[targetId]) {
      sectionGroups[targetId].forEach(secClass => {
        showSection(secClass);
      });
    }

    menuLinks.forEach(l => l.classList.remove('active-link'));
    link.classList.add('active-link');
  });
});

window.addEventListener('scroll', () => {
  const scrollPos = window.scrollY + (document.querySelector("header")?.offsetHeight || 80) + 50;

  Object.keys(sectionGroups).forEach(key => {
    const secClass = sectionGroups[key][0];
    const section = document.querySelector(`.${secClass}`);
    if (section) {
      const top = section.offsetTop;
      const height = section.offsetHeight;

      if (scrollPos >= top && scrollPos < top + height) {
        menuLinks.forEach(l => l.classList.remove('active-link'));
        const activeLink = document.querySelector(`.nav-link[href="#${key}"]`);
        if (activeLink) activeLink.classList.add('active-link');
      }
    }
  });
});

// =============================
// NAVBAR JS
// =============================

// Toggle dropdown on click (works for laptop + mobile)
document.querySelectorAll('.nav-item.dropdown > .nav-link').forEach(link => {
  link.addEventListener('click', e => {
    e.preventDefault(); // prevent jump
    const parent = link.parentElement;

    // Close all dropdowns except this one
    document.querySelectorAll('.nav-item.dropdown').forEach(drop => {
      if (drop !== parent) drop.classList.remove('open');
    });

    // Toggle clicked dropdown
    parent.classList.toggle('open');
  });
});

// Close dropdown if clicked outside
document.addEventListener('click', e => {
  if (!e.target.closest('.nav-item.dropdown')) {
    document.querySelectorAll('.nav-item.dropdown').forEach(drop => {
      drop.classList.remove('open');
    });
  }
});

// =============================
// MOBILE MENU JS
// =============================

const menuOpenBtn = document.getElementById("menu-open-button");
const menuCloseBtn = document.getElementById("menu-close-button");
const navMenu = document.querySelector(".nav-menu");

// Open menu
if (menuOpenBtn) {
  menuOpenBtn.addEventListener("click", () => {
    navMenu.classList.add("active");
    menuOpenBtn.style.display = "none";
    menuCloseBtn.style.display = "block";
  });
}

// Close menu
if (menuCloseBtn) {
  menuCloseBtn.addEventListener("click", () => {
    navMenu.classList.remove("active");
    menuCloseBtn.style.display = "none";
    menuOpenBtn.style.display = "block";
  });
}


window.addEventListener('DOMContentLoaded', () => {
  sectionGroups.home.forEach(secClass => {
    showSection(secClass);
  });
  const defaultLink = document.querySelector('.nav-link[href="#home"]');
  if (defaultLink) defaultLink.classList.add('active-link');
});

