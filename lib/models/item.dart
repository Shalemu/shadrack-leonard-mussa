class Item {
  final int id; // Matches your database ID
  final String barcode;
  final String invoice;
  final int type;
  final String name;
  final String img; // Default to 'default.jpg' if needed
  final int stock; // Renamed from 'qty_actual' for clarity
  final double purchasePrice;
  final double salePrice;
  final String? saleRoboPrice; // Made nullable
  final String? saleNusuPrice; // Made nullable
  final String? saleNusuroboPrice; // Made nullable
  final int minStock; // Added for clarity
  final String unit;
  final int status;
  final String exprDate;
  final DateTime appUpdatedAt; // Changed to DateTime for better handling
  final DateTime createdAt; // Changed to DateTime for better handling
  final DateTime updatedAt; // Changed to DateTime for better handling
  final int appId;
  final int shopId;
  final int adminId;
  final int originStock;
  final String syncStatus; // Added syncStatus field

  Item({
    required this.id,
    required this.barcode,
    required this.invoice,
    required this.type,
    required this.name,
    this.img = 'default.jpg', // Default value for missing images
    required this.stock,
    required this.purchasePrice,
    required this.salePrice,
    this.saleRoboPrice,
    this.saleNusuPrice,
    this.saleNusuroboPrice,
    required this.minStock,
    required this.unit,
    required this.status,
    required this.exprDate,
    required this.appUpdatedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.appId,
    required this.shopId,
    required this.adminId,
    required this.originStock,
    this.syncStatus = 'unsynced', // Default value for syncStatus
  });
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: int.parse(
          json['stock_id'].toString()), // Ensure this is parsed as an int
      barcode: json['barcode'] ?? '',
      invoice: json['invoice'] ?? '',
      type:
          int.parse(json['type'].toString()), // Ensure this is parsed as an int
      name: json['name'] ?? 'Unnamed Item',
      img: json['img'] ?? 'default.jpg',
      stock: int.parse(
          json['stock'].toString()), // Ensure this is parsed as an int
      purchasePrice: double.tryParse(json['purchase_price'].toString()) ??
          0.0, // Convert to double
      salePrice: double.tryParse(json['sale_price'].toString()) ??
          0.0, // Convert to double
      saleRoboPrice: json['sale_robo_price'], // Nullable
      saleNusuPrice: json['sale_nusu_price'], // Nullable
      saleNusuroboPrice: json['sale_nusurobo_price'], // Nullable
      minStock: int.parse(
          json['min_stock'].toString()), // Ensure this is parsed as an int
      unit: json['unit'] ?? 'units',
      status: int.parse(
          json['status'].toString()), // Ensure this is parsed as an int
      exprDate: json['expr_date'] ?? '1970-01-01',
      appUpdatedAt: DateTime.tryParse(
              json['app_updated_at'] ?? DateTime.now().toIso8601String()) ??
          DateTime.now(),
      createdAt: DateTime.tryParse(
              json['created_at'] ?? DateTime.now().toIso8601String()) ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(
              json['updated_at'] ?? DateTime.now().toIso8601String()) ??
          DateTime.now(),
      appId: int.parse(
          json['app_id'].toString()), // Ensure this is parsed as an int
      shopId: int.parse(
          json['shop_id'].toString()), // Ensure this is parsed as an int
      adminId: int.parse(
          json['admin_id'].toString()), // Ensure this is parsed as an int
      originStock: int.parse(
          json['origin_stock'].toString()), // Ensure this is parsed as an int
      syncStatus: json['sync_status'] ?? 'unsynced',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stock_id': id.toString(), // Ensure id is converted to String
      'barcode': barcode,
      'invoice': invoice,
      'type': type.toString(), // Convert to String
      'name': name,
      'img': img,
      'stock': stock.toString(), // Convert to String
      'purchase_price': purchasePrice
          .toStringAsFixed(2), // Convert to String with 2 decimal places
      'sale_price': salePrice
          .toStringAsFixed(2), // Convert to String with 2 decimal places
      'sale_robo_price': saleRoboPrice ?? '',
      'sale_nusu_price': saleNusuPrice ?? '',
      'sale_nusurobo_price': saleNusuroboPrice ?? '',
      'min_stock': minStock.toString(), // Convert to String
      'unit': unit,
      'status': status.toString(), // Convert to String
      'expr_date': exprDate,
      'app_updated_at': appUpdatedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'app_id': appId.toString(), // Convert to String
      'shop_id': shopId.toString(), // Convert to String
      'admin_id': adminId.toString(), // Convert to String
      'origin_stock': originStock.toString(), // Convert to String
      'sync_status': syncStatus,
    };
  }
}
