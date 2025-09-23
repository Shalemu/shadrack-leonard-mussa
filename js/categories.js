const categoryGrid = document.getElementById('category-grid');
const cartCountElement = document.querySelector('.cart-count');
const cartItemsContainer = document.getElementById('cart-items');
const cartTotalPrice = document.getElementById('cart-total-price');

let cart = [];

// ==============================
// Load categories
// ==============================
fetch('http://127.0.0.1:8000/api/categories')
  .then(response => response.json())
  .then(data => {
    data.data.forEach(category => {
      const card = document.createElement('div');
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

      card.addEventListener('click', () => loadCategoryProducts(category.id, category.name));
      categoryGrid.appendChild(card);
    });
  })
  .catch(err => console.error('Error fetching categories:', err));

// ==============================
// Load products in category
// ==============================
function loadCategoryProducts(categoryId, categoryName) {
  fetch(`http://127.0.0.1:8000/api/categories/${categoryId}/products`)
    .then(response => response.json())
    .then(data => {
      const productsGrid = document.getElementById('products-grid');
      productsGrid.innerHTML = "";

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

        card.querySelector('.btn-add-cart').addEventListener('click', () => addToCart(product));
        productsGrid.appendChild(card);
      });

      // hide all except products
      document.getElementById('categories-section').style.display = "none";
      document.getElementById('cart-section').style.display = "none";
      document.getElementById('products-section').style.display = "block";

      window.scrollTo({
        top: document.getElementById('products-section').offsetTop - 80,
        behavior: 'smooth'
      });
    })
    .catch(err => console.error('Error fetching products:', err));
}

// ==============================
// Add to Cart
// ==============================
function addToCart(product) {
  const existing = cart.find(item => item.id === product.id);

  if (existing) {
    existing.quantity++;
  } else {
    cart.push({
      id: product.id,
      name: product.Product_name,
      price: parseFloat(product.price),
      image: product.image_url ?? 'images/default-product.jpg',
      quantity: 1
    });
  }

  updateCartUI();
}


// Update Cart UI

function updateCartUI() {
  cartItemsContainer.innerHTML = "";
  let subtotal = 0;

  cart.forEach(item => {
    const itemTotal = item.price * item.quantity;
    subtotal += itemTotal;

    const row = document.createElement("tr");

    // Product column
    const productCol = document.createElement("td");
    productCol.innerHTML = `
      <div class="d-flex align-items-center">
        <img src="${item.image}" alt="${item.name}" 
             style="width:60px;height:60px;object-fit:cover;margin-right:10px;border-radius:6px;">
        <span>${item.name}</span>
      </div>
    `;
    row.appendChild(productCol);

    // Price column
    const priceCol = document.createElement("td");
    priceCol.textContent = `${item.price} Tsh`;
    row.appendChild(priceCol);

    // Quantity column
    const qtyCol = document.createElement("td");
    qtyCol.innerHTML = `
      <div class="quantity-controls">
        <button onclick="updateQuantity(${item.id}, -1)">-</button>
        <span>${item.quantity}</span>
        <button onclick="updateQuantity(${item.id}, 1)">+</button>
      </div>
    `;
    row.appendChild(qtyCol);

    // Subtotal column
    const subtotalCol = document.createElement("td");
    subtotalCol.textContent = `${itemTotal} Tsh`;
    row.appendChild(subtotalCol);

    // Action column
    const actionCol = document.createElement("td");
    actionCol.innerHTML = `
      <button class="btn btn-sm btn-outline-danger" onclick="removeFromCart(${item.id})">
      <i class="fas fa-trash"></i>
    </button>

    `;
    row.appendChild(actionCol);

    cartItemsContainer.appendChild(row);

    window.removeFromCart = function(productId) {
  cart = cart.filter(item => item.id !== productId);
  updateCartUI();
};


document.getElementById('update-cart-btn').addEventListener('click', () => {
  updateCartUI();
  alert('Cart updated successfully!');
});

  });

  // Update totals
  const shipping = 20;
  const total = subtotal + shipping;

  document.getElementById('cart-subtotal').textContent = subtotal.toFixed(2);
  document.getElementById('cart-total').textContent = total.toFixed(2);
  cartCountElement.textContent = cart.reduce((sum, item) => sum + item.quantity, 0);
  document.getElementById('checkout-amount').textContent = total.toFixed(2);
}



// Update Quantity

function updateQuantity(productId, change) {
  const item = cart.find(p => p.id === productId);
  if (item) {
    item.quantity += change;
    if (item.quantity <= 0) {
      cart = cart.filter(p => p.id !== productId);
    }
  }
  updateCartUI();
}


// Show Cart when clicking icon
document.querySelector(".cart-icon").addEventListener("click", () => {
  document.getElementById("products-section").style.display = "none";
  document.getElementById("categories-section").style.display = "none";
  document.getElementById("cart-section").style.display = "block";
});

document.querySelectorAll('input[name="location"]').forEach(radio => {
  radio.addEventListener('change', (e) => {
    if(e.target.value === 'outside') {
      document.getElementById('delivery-msg').style.display = 'block';
    } else {
      document.getElementById('delivery-msg').style.display = 'none';
    }
  });
});

function shareLocation() {
  if(navigator.geolocation){
    navigator.geolocation.getCurrentPosition(position => {
      alert(`Location shared: Lat: ${position.coords.latitude}, Lng: ${position.coords.longitude}`);
    }, () => {
      alert("Location access denied.");
    });
  } else {
    alert("Geolocation not supported in your browser.");
  }
}
// submit order
document.querySelector('.checkout-btn').addEventListener('click', createBooking);

async function createBooking() {
  const fullName = document.querySelector('.checkout-box input[placeholder="Full Name"]').value;
  const phone = document.querySelector('.checkout-box input[placeholder="Phone Number"]').value;
  const email = document.querySelector('.checkout-box input[placeholder="Email"]').value;

  if (!cart || cart.length === 0) {
    alert("Your cart is empty!");
    return;
  }

  const bookingData = {
    full_name: fullName,
    phone: phone,
    email: email,
    cart: cart.map(item => ({
      id: item.id,
      price: item.price,
      quantity: item.quantity
    }))
  };

  try {
    const response = await fetch("http://127.0.0.1:8000/api/orders", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(bookingData),
    });

    const data = await response.json();

      if (response.ok) {
      // Clear cart
      cart = [];
      updateCartUI();  // <-- instead of renderCart()

      // Show success message in cart section
      const successBox = document.getElementById("order-success");
      successBox.innerHTML = `
        <div class="alert alert-success text-center mt-4">
          🎉 Your order has been submitted successfully! <br>
          Order ID: <strong>${data.order_id}</strong>
        </div>
      `;
      successBox.style.display = "block";

      document.getElementById('cart-subtotal').textContent = "0.00";
      document.getElementById('cart-total').textContent = "0.00";
      document.getElementById('checkout-amount').textContent = "0.00";
      document.querySelector('#cart-count').textContent = "0";

    }

 else {
      alert("Booking failed: " + (data.message || JSON.stringify(data.errors)));
    }
  } catch (err) {
    console.error(err);
    alert("Something went wrong. Please try again.");
  }
}
