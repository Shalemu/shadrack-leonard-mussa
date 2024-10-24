class Cart {
  final int? id; // Primary key
  final int transactionId; // Foreign key from transactions
  final int itemId; // Item ID
  final String itemName; // Name of the item
  final double salePrice; // Sale price per item
  final int quantity; // Quantity of the item
  final double? total; // Total amount (optional)
  final double discountValue; // Discount applied to the item
  final String? deletedAt; // Soft delete timestamp (optional)
  final String? createdAt; // Creation timestamp (optional)
  final String? updatedAt; // Last update timestamp (optional)

  // Additional fields if they are part of the model
  final double price; // Price of the item
  final String img; // Item image URL

  // Constructor to initialize the Cart object
  const Cart({
    this.id,
    required this.transactionId,
    required this.itemId,
    required this.itemName,
    required this.salePrice,
    required this.quantity,
    this.total,
    this.discountValue = 0.0, // Default discount value
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    required this.price,
    required this.img,
  });

  // Factory method to create Cart from JSON
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      transactionId: json['transaction_id'],
      itemId: json['item_id'],
      itemName: json['item_name'],
      salePrice: (json['sale_price'] is int) // Handle int and double cases
          ? (json['sale_price'] as int).toDouble()
          : json['sale_price'],
      quantity: json['quantity'],
      total: json['total'],
      discountValue: json['discount_value'] ?? 0.0, // Default to 0 if null
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      price: (json['price'] is int) // Handle int and double cases
          ? (json['price'] as int).toDouble()
          : json['price'] ?? 0.0,
      img: json['img'] ?? '', // Default to empty string if null
    );
  }

  // Convert Cart instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_id': transactionId,
      'item_id': itemId,
      'item_name': itemName,
      'sale_price': salePrice,
      'quantity': quantity,
      'total': total,
      'discount_value': discountValue,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'price': price, // Include price field
      'img': img,     // Include img field
    };
  }

  // Method to calculate the total amount for the item
  double calculateTotal() {
    return salePrice * quantity - discountValue; // Adjusted to account for discount
  }
}
