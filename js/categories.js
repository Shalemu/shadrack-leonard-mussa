const categoryGrid = document.getElementById('category-grid');

fetch('http://127.0.0.1:8000/api/category')
  .then(response => response.json())
  .then(data => {
    data.data.forEach(category => {
      const card = document.createElement('div'); // use div for clickable card
      card.classList.add('product-card');
      const imageSrc = category.image_url ?? 'images/default.jpg';

      card.innerHTML = `
        <div class="image-wrapper">
          <img src="${imageSrc}" alt="${category.name}">
        </div>
        <div class="card-content">
          <h3>${category.name}</h3>
          <p>${category.description}</p>
        </div>
      `;

      // Add click listener
      card.addEventListener('click', () => loadCategoryProducts(category.id, category.name));

      categoryGrid.appendChild(card);
    });
  })
  .catch(err => console.error('Error fetching categories:', err));

function loadCategoryProducts(categoryId, categoryName) {
  // Fetch products from API
  fetch(`http://127.0.0.1:8000/api/category/${categoryId}/products`)
    .then(response => response.json())
    .then(data => {
      const productsGrid = document.getElementById('products-grid');
      productsGrid.innerHTML = ""; // clear old products

      // update title
      const title = document.querySelector('#products-section .section-title');
      title.textContent = categoryName;

      // render products
      data.data.forEach(product => {
        const card = document.createElement('div');
        card.classList.add('product-item'); 
        const imageSrc = product.image_url ?? 'images/default-product.jpg';
        

        card.innerHTML = `
          <div class="image-wrapper">
            <img src="${imageSrc}" alt="${product.Product_name}">
          </div>
          <div class="card-content">
            <h3>${product.Product_name}</h3>
            <p>${product.description}</p>
            <span class="price">Price: ${product.price} Tsh</span>
             <button type="button" class="btn-add-cart">Add to Cart</button>
          </div>
        `;
        productsGrid.appendChild(card);
      });

      // hide all sections except products
      allSections.forEach(sec => {
        if (!sec.classList.contains('footer-section')) {
          sec.style.display = 'none';
        }
      });
      document.getElementById('products-section').style.display = 'block';

      // scroll to top of products
      window.scrollTo({
        top: document.getElementById('products-section').offsetTop - 80,
        behavior: 'smooth'
      });
    })
    .catch(err => console.error('Error fetching products:', err));
}
