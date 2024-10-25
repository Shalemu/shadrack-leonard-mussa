import 'package:mauzoApp/models/account.dart';
import 'package:mauzoApp/models/account_category';
import 'package:mauzoApp/models/audit.dart';
import 'package:mauzoApp/models/bank.dart';
import 'package:mauzoApp/models/brand.dart';
import 'package:mauzoApp/models/bundle.dart';
import 'package:mauzoApp/models/business_category.dart';
import 'package:mauzoApp/models/business_type.dart';
import 'package:mauzoApp/models/department.dart';
import 'package:mauzoApp/models/designation.dart';
import 'package:mauzoApp/models/employee_assigned_shop.dart';
import 'package:mauzoApp/models/event.dart';
import 'package:mauzoApp/models/event_template.dart';
import 'package:mauzoApp/models/expenses.dart';
import 'package:mauzoApp/models/expenses_category';
import 'package:mauzoApp/models/failed_job.dart';
import 'package:mauzoApp/models/general_setting.dart';
import 'package:mauzoApp/models/invoice.dart';
import 'package:mauzoApp/models/item.dart';
import 'package:mauzoApp/models/item_category.dart';
import 'package:mauzoApp/models/item_image.dart';
import 'package:mauzoApp/models/item_sub_category.dart';
import 'package:mauzoApp/models/item_transfer.dart';
import 'package:mauzoApp/models/item_variants.dart';
import 'package:mauzoApp/models/job.dart';
import 'package:mauzoApp/models/job_batch.dart';
import 'package:mauzoApp/models/migration.dart';
import 'package:mauzoApp/models/product.dart';
import 'package:mauzoApp/models/purchase_order.dart';
import 'package:mauzoApp/models/quotation.dart';
import 'package:mauzoApp/models/quotationitem.dart';
import 'package:mauzoApp/models/role.dart';
import 'package:mauzoApp/models/session.dart';
import 'package:mauzoApp/models/shop.dart';
import 'package:mauzoApp/models/tax_type.dart';
import 'package:mauzoApp/models/transaction.dart';
import 'package:mauzoApp/models/transaction_on_hold.dart';
import 'package:mauzoApp/models/unit.dart';
import 'package:mauzoApp/models/user.dart';
import 'package:mauzoApp/models/warranties.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mauzoApp/models/cart_model.dart';
import 'package:mauzoApp/models/user_detail.dart';

// Import the Item model
// Import the ItemCategory model
class DatabaseHelper {
  static const int _version = 5; // Increment this for schema changes
  static const String _dbName = "Cart.db";

  // Open or create the database
  static Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      version: _version,
      onCreate: (db, version) async {
        await db.transaction((txn) async {
          // Create cart_items table
          await txn.execute('''
            CREATE TABLE cart_items (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              transaction_id INTEGER NOT NULL,
              item_id INTEGER NOT NULL,
              item_name TEXT NOT NULL,
              sale_price REAL NOT NULL,
              quantity INTEGER NOT NULL,
              total REAL,
              discount_value REAL DEFAULT 0.00,
              price REAL,
              img TEXT,
              deleted_at TEXT,
              created_at TEXT,
              updated_at TEXT,
              sync_status INTEGER DEFAULT 0
            );
          ''');

          // Create expenses table
          await txn.execute('''
            CREATE TABLE expenses (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              date DATE NOT NULL,
              amount REAL NOT NULL, 
              description TEXT DEFAULT NULL,
              shop INTEGER NOT NULL,
              expense_category INTEGER NOT NULL,
              admin_id INTEGER NOT NULL,
              deleted_at TIMESTAMP DEFAULT NULL,
              created_at TIMESTAMP DEFAULT NULL,
              updated_at TIMESTAMP DEFAULT NULL,
              sync_status INTEGER DEFAULT 0
            );
          ''');

          // Create items table
          await txn.execute('''
            CREATE TABLE items (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              stock_id INTEGER,
              barcode TEXT,
              invoice TEXT,
              type INTEGER NOT NULL,
              name TEXT NOT NULL,
              img TEXT NOT NULL DEFAULT 'default.jpg',
              stock INTEGER NOT NULL,
              purchase_price REAL NOT NULL,
              sale_price REAL NOT NULL,
              sale_robo_price TEXT,
              sale_nusu_price TEXT,
              sale_nusurobo_price TEXT,
              min_stock INTEGER NOT NULL,
              unit TEXT NOT NULL,
              status INTEGER NOT NULL,
              expr_date TEXT,
              app_updated_at TEXT,
              created_at TEXT,
              updated_at TEXT,
              app_id INTEGER NOT NULL,
              shop_id INTEGER NOT NULL,
              admin_id INTEGER NOT NULL,
              user_id INTEGER,
              origin_stock INTEGER NOT NULL,
              sync_status TEXT DEFAULT 'unsynced'
            );
          ''');

          // Create users table
          await txn.execute('''
            CREATE TABLE IF NOT EXISTS users (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              username TEXT NOT NULL,
              phone TEXT NOT NULL,
              email TEXT NOT NULL,
              password TEXT NOT NULL,
              code TEXT NOT NULL,
              expires_at TEXT NOT NULL,
              verified INTEGER NOT NULL DEFAULT 0,
              super_user INTEGER NOT NULL DEFAULT 1,
              password_reset INTEGER NOT NULL DEFAULT 0,
              login_trials INTEGER NOT NULL DEFAULT 0,
              admin_id TEXT DEFAULT NULL,
              profile_image TEXT DEFAULT NULL,
              deleted_at TEXT,
              verified_at TEXT DEFAULT NULL,
              role_id INTEGER NOT NULL,
              user_type TEXT NOT NULL DEFAULT 'Retailer',
              created_at TEXT DEFAULT NULL,
              updated_at TEXT DEFAULT NULL,
              sync_status INTEGER DEFAULT 0
            );
          ''');

          // Create user_details table
          await txn.execute('''
            CREATE TABLE IF NOT EXISTS user_details (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              last_login TEXT,
              active INTEGER NOT NULL DEFAULT 1,
              first_time INTEGER NOT NULL DEFAULT 1,
              expiring_date TEXT,
              postal_address TEXT,
              physical_address TEXT,
              photo TEXT,
              payment_status INTEGER NOT NULL DEFAULT 0,
              lang INTEGER NOT NULL DEFAULT 0,
              owner_id INTEGER NOT NULL DEFAULT 0,
              email_sub INTEGER NOT NULL DEFAULT 1,
              bundle_id INTEGER NOT NULL DEFAULT 0,
              bundle_qty INTEGER NOT NULL DEFAULT 0,
              last_pay TEXT,
              shop_limit INTEGER NOT NULL DEFAULT 1,
              deleted_at TEXT,
              user_id INTEGER NOT NULL,
              created_at TEXT,
              updated_at TEXT,
              sync_status INTEGER DEFAULT 0
            );
          ''');

          // Create new_customer_supplier_accounts table
          await txn.execute('''
            CREATE TABLE IF NOT EXISTS new_customer_supplier_accounts (
              id INTEGER PRIMARY KEY,
              name TEXT,
              phone TEXT,
              is_customer INTEGER,
              email TEXT,
              profile_image TEXT,
              admin_id INTEGER,
              shop_id INTEGER,
              dealer TEXT,
              address TEXT,
              location TEXT,
              user_id INTEGER,
              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
              updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
              sync_status INTEGER DEFAULT 0
            );
          ''');
        });
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Implement upgrade logic
        if (oldVersion < 5) {
          // Example: await db.execute('ALTER TABLE ...');
        }

        await db.execute('''
          CREATE TABLE  IF NOT EXISTS item_categories(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            admin_id INTEGER,
            deleted_at TEXT,
            created_at TEXT,
            updated_at TEXT,
            sync_status INTEGER DEFAULT 0
          );
          ''');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS warranties(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            discription TEXT,
            duration TEXT NOT NULL,
            status INTEGER NOT NULL DEFAULT 0,
            period TEXT NOT NULL,
            admin_id INTEGER NOT NULL,
            deleted_at TEXT,
            created_at TEXT,
            updated_at TEXT,
            sync_status INTEGER DEFAULT 0
          );
          ''');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS units(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            symbol TEXT DEFAULT NULL,
            admin_id INTEGER DEFAULT NULL,
            deleted_at TEXT DEFAULT NULL,
            created_at TEXT DEFAULT NULL,
            updated_at TEXT DEFAULT NULL,
            sync_status INTEGER DEFAULT 0
          );
          ''');
        await db.execute('''
          INSERT INTO units (id, name, symbol) VALUES 
          (1, 'Piece', 'pc'),
          (2, 'Kilogram', 'kg'),
          (3, 'Gram', 'g'),
          (4, 'Liter', 'L'),
          (5, 'Milliliter', 'mL'),
          (6, 'Pack', 'pk'),
          (7, 'Box', 'bx'),
          (8, 'Dozen', 'dz'),
          (9, 'Meter', 'm'),
          (10, 'Centimeter', 'cm'),
          (11, 'Inch', 'in'),
          (12, 'Foot', 'ft'),
          (13, 'Yard', 'yd'),
          (14, 'Gallon', 'gal'),
          (15, 'Quart', 'qt'),
          (16, 'Pint', 'pt'),
          (17, 'Ounce', 'oz'),
          (18, 'Pound', 'lb'),
          (19, 'Millimeter', 'mm'),
          (20, 'Square Meter', 'm²'),
          (21, 'Cubic Meter', 'm³');
          ''');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS transaction_on_holds(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            transaction_id INTEGER NOT NULL,
            payment_hold_reference TEXT DEFAULT NULL,
            status INTEGER NOT NULL DEFAULT 0,
            deleted_at TEXT DEFAULT NULL,
            created_at TEXT DEFAULT NULL,
            updated_at TEXT DEFAULT NULL,
            sync_status INTEGER DEFAULT 0
          );
          ''');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS transactions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            total_bill DECIMAL(18, 2) NOT NULL,
            payment_mode TEXT NOT NULL,
            phone TEXT,
            delivery_mode TEXT,
            description TEXT,
            discount_value DECIMAL(8, 2),
            discount DECIMAL(18, 2),
            tax_percentage TEXT,
            gst_tax DECIMAL(18, 2),
            shipping_value DECIMAL(8, 2),
            shipping DECIMAL(18, 2),
            due DECIMAL(18, 2),
            amount_change DECIMAL(10, 2),
            total_payable DECIMAL(18, 2),
            sub_total DECIMAL(18, 2),
            transaction_id TEXT NOT NULL,
            status TEXT DEFAULT 'pending',
            sold_by INTEGER,
            supplied_by INTEGER,
            sold_to INTEGER,
            deleted_at TEXT,
            created_at TEXT,
            updated_at TEXT,
            sync_status INTEGER DEFAULT 0
          );
        ''');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS tax_types (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            admin_id INTEGER,
            deleted_at TEXT,
            created_at TEXT,
            updated_at TEXT,
            sync_status INTEGER DEFAULT 0
          );
        ''');

        // Insert default tax types data
        await db.execute('''
          INSERT INTO tax_types (id, name, admin_id, deleted_at, created_at, updated_at) VALUES
          (1, 'Income tax', NULL, NULL, NULL, NULL),
          (2, 'Property tax', NULL, NULL, NULL, NULL),
          (3, 'Sales tax', NULL, NULL, NULL, NULL),
          (4, 'Ad Valorem And Specific tax', NULL, NULL, NULL, NULL),
          (5, 'Donation tax', NULL, NULL, NULL, NULL),
          (6, 'Indirect tax', NULL, NULL, NULL, NULL),
          (7, 'Proportional tax', NULL, NULL, NULL, NULL),
          (8, 'Other tax', NULL, NULL, NULL, NULL);
        ''');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS shops (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            type INTEGER NOT NULL DEFAULT 1,
            business_category INTEGER,
            address TEXT,
            status INTEGER NOT NULL DEFAULT 1,
            admin_id INTEGER,
            deleted_at TEXT,
            created_at TEXT,
            updated_at TEXT,
            sync_status INTEGER DEFAULT 0
          );
        ''');

        // Insert sample data into the shops table
        await db.execute('''
          INSERT INTO shops (id, name, type, business_category, address, status, admin_id, deleted_at, created_at, updated_at) VALUES
          (1, 'test1', 1, 2, 'Dar es salaam', 1, 1, NULL, '2024-09-01 22:38:45', '2024-09-01 22:38:45'),
          (2, 'test2', 1, 1, 'Dar es salaam', 1, 1, NULL, '2024-09-01 22:39:02', '2024-09-01 22:39:02'),
          (3, 'test 3', 1, 1, 'Dar', 1, 1, NULL, '2024-09-01 22:39:12', '2024-09-01 22:39:12'),
          (4, 'test 4', 1, 1, 'Mbeya', 1, 1, NULL, '2024-09-01 22:39:27', '2024-09-01 22:39:27');
        ''');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS sessions (
            id TEXT PRIMARY KEY,
            user_id INTEGER,
            ip_address TEXT,
            user_agent TEXT,
            payload TEXT NOT NULL,
            last_activity INTEGER NOT NULL,
            sync_status INTEGER DEFAULT 0
          );
        ''');

        // Insert sample data into the sessions table
        await db.execute('''
          CREATE TABLE IF NOT EXISTS role_has_permissions (
            permission_id INTEGER UNSIGNED NOT NULL,
            role_id INTEGER UNSIGNED NOT NULL,
            sync_status INTEGER DEFAULT 0
          );
        ''');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS roles (
            id INTEGER UNSIGNED PRIMARY KEY,
            name TEXT NOT NULL,
            shop_id INTEGER,
            type INTEGER NOT NULL DEFAULT 1,
            admin_id INTEGER,
            guard_name TEXT NOT NULL,
            deleted_at TIMESTAMP,
            created_at TIMESTAMP,
            updated_at TIMESTAMP,
            sync_status INTEGER DEFAULT 0
          );
        ''');
        await db.execute('''
          CREATE TABLE quotation_items (
            id INTEGER UNSIGNED PRIMARY KEY,
            quotation_id INTEGER,
            item_id INTEGER,
            quantity INTEGER NOT NULL,
            purchase_price DECIMAL(10,2) NOT NULL,
            discount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
            tax_rate DECIMAL(10,2) NOT NULL DEFAULT 0.00,
            tax_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
            total_cost DECIMAL(10,2) NOT NULL,
            created_at TIMESTAMP,
            updated_at TIMESTAMP,
            deleted_at TIMESTAMP,
            sync_status INTEGER DEFAULT 0
          );
        ''');
        await db.execute('''
              CREATE TABLE quotations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            supplier_id INTEGER,
            retailer_id INTEGER,
            issue_date DATE NOT NULL,
            quotation_number TEXT NOT NULL,
            order_tax DECIMAL(10,2) NOT NULL DEFAULT 0.00,
            discount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
            shipping DECIMAL(10,2) NOT NULL DEFAULT 0.00,
            total_amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
            status TEXT NOT NULL DEFAULT 'Pending',
            description TEXT,
            created_at TIMESTAMP,
            updated_at TIMESTAMP,
            deleted_at TIMESTAMP,
            sync_status INTEGER DEFAULT 0
          );

        ''');
        await db.execute('''
          CREATE TABLE  purchase_orders (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      quotation_id INTEGER,
      total_amount DECIMAL(18,2) NOT NULL,
      status TEXT NOT NULL DEFAULT 'Pending',
      created_at TIMESTAMP,
      updated_at TIMESTAMP,
      deleted_at TIMESTAMP,
      sync_status INTEGER DEFAULT 0
    );

        ''');
        await db.execute('''
          CREATE TABLE  products (
            id INTEGER UNSIGNED PRIMARY KEY,
            name TEXT NOT NULL,
            item_code TEXT,
            barcode_symbology TEXT,
            description TEXT,
            discount_type TEXT,
            discount_value TEXT,
            product_type INTEGER NOT NULL,
            brand_id INTEGER NOT NULL,
            category_id INTEGER,
            subcategory_id INTEGER,
            min_stock INTEGER NOT NULL DEFAULT 1,
            store_id INTEGER,
            shop_id INTEGER UNSIGNED,
            admin_id INTEGER NOT NULL,
            tax_type INTEGER,
            quantity INTEGER,
            quantity_alert INTEGER,
            selling_type TEXT,
            deleted_at TIMESTAMP,
            created_at TIMESTAMP,
            updated_at TIMESTAMP,
            sync_status INTEGER DEFAULT 0
          );
        ''');

        await db.execute('''
          CREATE TABLE  password_reset_tokens (
            email TEXT NOT NULL,
            token TEXT NOT NULL,
            created_at TIMESTAMP,
            sync_status INTEGER DEFAULT 0
          );
        ''');
        await db.execute('''
          CREATE TABLE  accounts (
            id INTEGER UNSIGNED PRIMARY KEY,
            account_provider TEXT NOT NULL,
            account_number TEXT NOT NULL,
            account_name TEXT,
            account_type TEXT,
            account_status TEXT NOT NULL DEFAULT '1',
            admin_id INTEGER,
            account_category INTEGER NOT NULL,
            deleted_at TIMESTAMP,
            created_at TIMESTAMP,
            updated_at TIMESTAMP,
            sync_status INTEGER DEFAULT 0
          );
        ''');
        await db.execute('''
          CREATE TABLE  account_categories (
            id INTEGER UNSIGNED PRIMARY KEY,
            name TEXT NOT NULL,
            status TINYINT(1) NOT NULL DEFAULT 1,
            admin_id INTEGER,
            deleted_at TIMESTAMP,
            created_at TIMESTAMP,
            updated_at TIMESTAMP,
            sync_status INTEGER DEFAULT 0
          );
        ''');
        await db.execute('''
          CREATE TABLE  audits (
            id INTEGER UNSIGNED PRIMARY KEY,
            user_type TEXT,
            user_id INTEGER UNSIGNED,
            event TEXT NOT NULL,
            auditable_type TEXT NOT NULL,
            auditable_id INTEGER UNSIGNED NOT NULL,
            old_values TEXT,
            new_values TEXT,
            url TEXT,
            ip_address TEXT,
            user_agent TEXT,
            tags TEXT,
            created_at TIMESTAMP,
            updated_at TIMESTAMP,
            sync_status INTEGER DEFAULT 0
          );
        ''');
        await db.execute('''
          CREATE TABLE  banks (
            id INTEGER UNSIGNED PRIMARY KEY,
            name VARCHAR(100) NOT NULL,
            deleted_at TIMESTAMP,
            created_at TIMESTAMP,
            updated_at TIMESTAMP,
            sync_status INTEGER DEFAULT 0
          );
        ''');
        await db.execute('''
          CREATE TABLE  brands (
            id INTEGER UNSIGNED PRIMARY KEY,
            name VARCHAR(255) NOT NULL,
            logo VARCHAR(255),
            admin_id INTEGER,
            deleted_at TIMESTAMP,
            created_at TIMESTAMP,
            updated_at TIMESTAMP,
            sync_status INTEGER DEFAULT 0
          );
        ''');
        await db.execute('''
          CREATE TABLE bundles (
            id INTEGER UNSIGNED PRIMARY KEY,
            name VARCHAR(100) NOT NULL,
            price VARCHAR(110) NOT NULL,
            shops INTEGER NOT NULL,
            subscribers INTEGER,
            duration VARCHAR(110) NOT NULL,
            deleted_at TIMESTAMP,
            created_at TIMESTAMP,
            updated_at TIMESTAMP,
            sync_status INTEGER DEFAULT 0
          );
        ''');
        await db.execute('''
          CREATE TABLE business_categories (
            id INTEGER UNSIGNED PRIMARY KEY,
            name VARCHAR(255) NOT NULL,
            status INTEGER NOT NULL,
            deleted_at TIMESTAMP,
            created_at TIMESTAMP,
            updated_at TIMESTAMP,
            sync_status INTEGER DEFAULT 0
          );
        ''');
        await db.execute('''
          CREATE TABLE business_types (
            id INTEGER UNSIGNED PRIMARY KEY,
            name VARCHAR(255) NOT NULL,
            status INTEGER NOT NULL,
            created_at TIMESTAMP,
            updated_at TIMESTAMP,
            deleted_at TIMESTAMP,
            sync_status INTEGER DEFAULT 0
          );
        ''');
        await db.execute('''
DROP TABLE IF EXISTS cache;

CREATE TABLE cache (
    key TEXT NOT NULL,
    value TEXT NOT NULL,
    expiration INTEGER NOT NULL,
    PRIMARY KEY (key),
    sync_status INTEGER DEFAULT 0  -- This column is defined here
);



        ''');
        await db.execute('''
        DROP TABLE IF EXISTS cache_locks;

CREATE TABLE cache_locks (
    key TEXT NOT NULL,
    owner TEXT NOT NULL,
    expiration INTEGER NOT NULL,
    PRIMARY KEY (key),
    sync_status INTEGER DEFAULT 0
);

        ''');

        await db.execute('''
        CREATE TABLE  departments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    hod TEXT DEFAULT NULL,
    status TEXT NOT NULL DEFAULT '1',
    admin_id INTEGER NOT NULL,
    deleted_at TIMESTAMP DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    sync_status INTEGER DEFAULT 0
  );

        ''');
        await db.execute('''
        CREATE TABLE designations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT '1',
    admin_id INTEGER NOT NULL,
    deleted_at TIMESTAMP DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    sync_status INTEGER DEFAULT 0
  );

        ''');

        await db.execute('''
          CREATE TABLE employee_assigned_shops (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      shop INTEGER NOT NULL,
      employee INTEGER NOT NULL,
      admin_id INTEGER NOT NULL,
      deleted_at TIMESTAMP DEFAULT NULL,
      created_at TIMESTAMP DEFAULT NULL,
      updated_at TIMESTAMP DEFAULT NULL,
      sync_status INTEGER DEFAULT 0
    );

        ''');
        await db.execute('''
      CREATE TABLE  events (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL, 
    number_of_people INTEGER NOT NULL,
    is_group INTEGER NOT NULL DEFAULT 0,
    status INTEGER NOT NULL DEFAULT 1,
    phone_number TEXT NOT NULL,
    event_date TEXT NOT NULL,
    otp INTEGER DEFAULT NULL,
    admin_id INTEGER DEFAULT NULL,
    deleted_at TIMESTAMP DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    sync_status INTEGER DEFAULT 0
  );

        ''');
        await db.execute('''
    CREATE TABLE event_templates (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    card_image TEXT NOT NULL,
    status INTEGER NOT NULL DEFAULT 0,
    number_of_like TEXT DEFAULT NULL,
    number_of_dislike TEXT DEFAULT NULL,
    admin_id INTEGER DEFAULT NULL,
    deleted_at TIMESTAMP DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    sync_status INTEGER DEFAULT 0
  );

        ''');

        await db.execute('''
DROP TABLE IF EXISTS expense_categories;

CREATE TABLE expense_categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT DEFAULT NULL,
    admin_id INTEGER NOT NULL,
    deleted_at TIMESTAMP DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    sync_status INTEGER DEFAULT 0
);


        ''');
        await db.execute('''
      CREATE TABLE  failed_jobs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  uuid TEXT NOT NULL,
  connection TEXT NOT NULL,
  queue TEXT NOT NULL,
  payload TEXT NOT NULL,
  exception TEXT NOT NULL,
  failed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  sync_status INTEGER DEFAULT 0
);

        ''');
        await db.execute('''
        CREATE TABLE  general_settings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  business_name TEXT NOT NULL,
  business_type TEXT NOT NULL,
  business_category TEXT NOT NULL,
  number_of_shops INTEGER NOT NULL,
  business_address TEXT DEFAULT NULL,
  business_phone TEXT DEFAULT NULL,
  business_website TEXT DEFAULT NULL,
  admin_id INTEGER DEFAULT NULL,
  created_at TIMESTAMP DEFAULT NULL,
  updated_at TIMESTAMP DEFAULT NULL,
  deleted_at TIMESTAMP DEFAULT NULL,
  sync_status INTEGER DEFAULT 0
);
        ''');
        await db.execute('''
    CREATE TABLE  invoices (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  purchase_order_id INTEGER DEFAULT NULL,
  total_amount REAL NOT NULL,
  status TEXT NOT NULL DEFAULT 'Paid',
  created_at TIMESTAMP DEFAULT NULL,
  updated_at TIMESTAMP DEFAULT NULL,
  deleted_at TIMESTAMP DEFAULT NULL,
  sync_status INTEGER DEFAULT 0
);

        ''');
        await db.execute('''
     CREATE TABLE  item_images (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    item_id INTEGER NOT NULL,
    files TEXT NOT NULL,
    deleted_at TIMESTAMP DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    sync_status INTEGER DEFAULT 0
);

        ''');
        await db.execute('''
      CREATE TABLE  item_sub_categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    admin_id INTEGER DEFAULT NULL,
    item_category_id INTEGER NOT NULL,
    deleted_at TIMESTAMP DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    sync_status INTEGER DEFAULT 0
);

        ''');
        await db.execute('''
     CREATE TABLE  item_transfers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    total_number_product INTEGER NOT NULL,
    quantity_transfered INTEGER NOT NULL,
    stock_after_transfer INTEGER NOT NULL,
    ref_number TEXT NOT NULL,
    date_transfer TEXT DEFAULT NULL,
    description TEXT DEFAULT NULL,
    item INTEGER NOT NULL,
    admin_id INTEGER DEFAULT NULL,
    deleted_at TIMESTAMP DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    sync_status INTEGER DEFAULT 0
);

        ''');
        await db.execute('''
       CREATE TABLE item_variants (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    value TEXT NOT NULL,
    product_id INTEGER DEFAULT NULL,
    admin_id INTEGER NOT NULL,
    deleted_at TIMESTAMP DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    sync_status INTEGER DEFAULT 0
);

        ''');
        await db.execute('''
      CREATE TABLE  jobs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    queue TEXT NOT NULL,
    payload TEXT NOT NULL,
    attempts INTEGER NOT NULL,
    reserved_at INTEGER DEFAULT NULL,
    available_at INTEGER NOT NULL,
    created_at INTEGER NOT NULL,
    sync_status INTEGER DEFAULT 0
);

        ''');
        await db.execute('''
    DROP TABLE IF EXISTS job_batches;

CREATE TABLE job_batches (
    id TEXT NOT NULL,
    name TEXT NOT NULL,
    total_jobs INTEGER NOT NULL,
    pending_jobs INTEGER NOT NULL,
    failed_jobs INTEGER NOT NULL,
    failed_job_ids TEXT NOT NULL,
    options TEXT DEFAULT NULL,
    cancelled_at INTEGER DEFAULT NULL,
    created_at INTEGER NOT NULL,
    finished_at INTEGER DEFAULT NULL,
    PRIMARY KEY (id),
    sync_status INTEGER DEFAULT 0
);

        ''');
        await db.execute('''
       CREATE TABLE IF NOT EXISTS migrations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    migration TEXT NOT NULL,
    batch INTEGER NOT NULL,
    sync_status INTEGER DEFAULT 0
);

        ''');
        await db.execute('''
       CREATE TABLE  mobile_payments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    created_at TEXT NULL DEFAULT NULL,
    updated_at TEXT NULL DEFAULT NULL,
    deleted_at TEXT NULL DEFAULT NULL,
    sync_status INTEGER DEFAULT 0
);

        ''');
        await db.execute('''
DROP TABLE IF EXISTS model_has_permissions;

CREATE TABLE model_has_permissions (
    permission_id INTEGER NOT NULL,
    model_type TEXT NOT NULL,
    model_id INTEGER NOT NULL,
    sync_status INTEGER DEFAULT 0,
    PRIMARY KEY (permission_id, model_type, model_id)
);


        ''');
        await db.execute('''
   DROP TABLE IF EXISTS model_has_roles;

CREATE TABLE model_has_roles (
    role_id INTEGER NOT NULL,
    model_type TEXT NOT NULL,
    model_id INTEGER NOT NULL,
    sync_status INTEGER DEFAULT 0,
    PRIMARY KEY (role_id, model_type, model_id)
);


        ''');
        await db.execute('''
DROP TABLE IF EXISTS notification_centers;

CREATE TABLE notification_centers (
    id INTEGER NOT NULL,
    status INTEGER NOT NULL DEFAULT 1,
    admin_id INTEGER DEFAULT NULL,
    deleted_at TEXT DEFAULT NULL,
    created_at TEXT DEFAULT NULL,
    updated_at TEXT DEFAULT NULL,
    sync_status INTEGER DEFAULT 0,
    PRIMARY KEY (id)
);


        ''');
        await db.execute('''
  DROP TABLE IF EXISTS paper_sizes;

CREATE TABLE paper_sizes (
    id INTEGER NOT NULL,
    name TEXT NOT NULL,
    deleted_at TEXT DEFAULT NULL,
    created_at TEXT DEFAULT NULL,
    updated_at TEXT DEFAULT NULL,
    sync_status INTEGER DEFAULT 0,
    PRIMARY KEY (id)
);


        ''');
      },
    );
  }

  // CRUD operations for paper_sizes table

  // Insert or update a paper size
  static Future<void> insertOrUpdatePaperSize(
    int id,
    String name, {
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int syncStatus = 0, // Default value is 0 (not synchronized)
  }) async {
    final db = await _getDB();
    await db.insert(
      'paper_sizes',
      {
        'id': id,
        'name': name,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'deleted_at': deletedAt?.toIso8601String(),
        'sync_status': syncStatus,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve a paper size by ID
  static Future<Map<String, dynamic>?> getPaperSize(int id) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'paper_sizes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  // Retrieve paper sizes by sync status
  static Future<List<Map<String, dynamic>>> getPaperSizesBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    return await db.query(
      'paper_sizes',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  // Update sync status to 1 (synchronized) for specific IDs
  static Future<void> markPaperSizesAsSynchronized(List<int> ids) async {
    final db = await _getDB();
    await db.update(
      'paper_sizes',
      {'sync_status': 1},
      where: 'id IN (${ids.join(',')})',
    );
  }

  // Delete a paper size by ID
  static Future<void> deletePaperSize(int id) async {
    final db = await _getDB();
    await db.delete(
      'paper_sizes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Clear all paper sizes
  static Future<void> clearPaperSizes() async {
    final db = await _getDB();
    await db.delete('paper_sizes');
  }

  // Clear paper sizes with a specific sync status
  static Future<void> clearPaperSizesWithStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'paper_sizes',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  // CRUD operations for notification_centers table

  // Insert or update a notification center

  // Insert or update a notification center
  static Future<void> insertOrUpdateNotificationCenter(
    int id,
    int status, {
    int? adminId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int syncStatus = 0, // Default value is 0 (not synchronized)
  }) async {
    final db = await _getDB();
    await db.insert(
      'notification_centers',
      {
        'id': id,
        'status': status,
        'admin_id': adminId,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'deleted_at': deletedAt?.toIso8601String(),
        'sync_status': syncStatus,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve a notification center by ID
  static Future<Map<String, dynamic>?> getNotificationCenter(int id) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'notification_centers',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  // Retrieve notification centers by sync status
  static Future<List<Map<String, dynamic>>> getNotificationCentersBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    return await db.query(
      'notification_centers',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  // Update sync status to 1 (synchronized) for specific IDs
  static Future<void> markNotificationCentersAsSynchronized(
      List<int> ids) async {
    final db = await _getDB();
    await db.update(
      'notification_centers',
      {'sync_status': 1},
      where: 'id IN (${ids.join(',')})',
    );
  }

  // Delete a notification center by ID
  static Future<void> deleteNotificationCenter(int id) async {
    final db = await _getDB();
    await db.delete(
      'notification_centers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Clear all notification centers
  static Future<void> clearNotificationCenters() async {
    final db = await _getDB();
    await db.delete('notification_centers');
  }

  // Clear notification centers with a specific sync status
  static Future<void> clearNotificationCentersWithStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'notification_centers',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  // Insert or update a model role
  static Future<void> insertOrUpdateModelRole(
      int roleId, String modelType, int modelId,
      {int syncStatus = 0}) async {
    final db = await _getDB();
    await db.insert(
      'model_has_roles',
      {
        'role_id': roleId,
        'model_type': modelType,
        'model_id': modelId,
        'sync_status': syncStatus,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Retrieve a model role by role_id, model_type, model_id, and sync_status
  static Future<Map<String, dynamic>?> getModelRole(
      int roleId, String modelType, int modelId) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'model_has_roles',
      where: 'role_id = ? AND model_type = ? AND model_id = ?',
      whereArgs: [roleId, modelType, modelId],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

// Retrieve model roles by sync_status
  static Future<List<Map<String, dynamic>>> getModelRolesBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    return await db.query(
      'model_has_roles',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

// Update sync status to 1 (synchronized) for specific roles
  static Future<void> markModelRolesAsSynchronized(List<int> ids) async {
    final db = await _getDB();
    await db.update(
      'model_has_roles',
      {'sync_status': 1},
      where: 'role_id IN (${ids.join(',')})',
    );
  }

// Delete a model role by role_id, model_type, and model_id
  static Future<void> deleteModelRole(
      int roleId, String modelType, int modelId) async {
    final db = await _getDB();
    await db.delete(
      'model_has_roles',
      where: 'role_id = ? AND model_type = ? AND model_id = ?',
      whereArgs: [roleId, modelType, modelId],
    );
  }

// Clear all model roles
  static Future<void> clearModelRoles() async {
    final db = await _getDB();
    await db.delete('model_has_roles');
  }

// Clear model roles with a specific sync status
  static Future<void> clearModelRolesWithStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'model_has_roles',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  // Insert or update a mobile payment
  static Future<void> insertOrUpdateMobilePayment(int id, String name,
      {DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? deletedAt,
      int syncStatus = 0}) async {
    final db = await _getDB();
    await db.insert(
      'mobile_payments',
      {
        'id': id,
        'name': name,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'deleted_at': deletedAt?.toIso8601String(),
        'sync_status': syncStatus,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Retrieve a mobile payment by ID
  static Future<Map<String, dynamic>?> getMobilePayment(int id) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'mobile_payments',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

// Retrieve mobile payments by sync_status
  static Future<List<Map<String, dynamic>>> getMobilePaymentsBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    return await db.query(
      'mobile_payments',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

// Update sync status to 1 (synchronized) for specific mobile payments
  static Future<void> markMobilePaymentsAsSynchronized(List<int> ids) async {
    final db = await _getDB();
    await db.update(
      'mobile_payments',
      {'sync_status': 1},
      where: 'id IN (${ids.join(',')})',
    );
  }

// Delete a mobile payment by ID
  static Future<void> deleteMobilePayment(int id) async {
    final db = await _getDB();
    await db.delete(
      'mobile_payments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// Clear all mobile payments
  static Future<void> clearMobilePayments() async {
    final db = await _getDB();
    await db.delete('mobile_payments');
  }

// Clear mobile payments with a specific sync status
  static Future<void> clearMobilePaymentsWithStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'mobile_payments',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  // CRUD operations for migrations table

  // Insert or update a migration
  static Future<void> insertOrUpdateMigration(Migration migration,
      {int syncStatus = 0}) async {
    final db = await _getDB();
    await db.insert(
      'migrations',
      {
        ...migration.toMap(),
        'sync_status': syncStatus,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Retrieve a migration by ID
  static Future<Migration?> getMigrationById(int id) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'migrations',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Migration.fromMap(maps.first);
    }
    return null;
  }

// Retrieve all migrations
  static Future<List<Migration>> getAllMigrations() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('migrations');

    return List.generate(maps.length, (i) {
      return Migration.fromMap(maps[i]);
    });
  }

// Retrieve migrations by sync_status
  static Future<List<Migration>> getMigrationsBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'migrations',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );

    return List.generate(maps.length, (i) {
      return Migration.fromMap(maps[i]);
    });
  }

// Update sync status to 1 (synchronized) for specific migrations
  static Future<void> markMigrationsAsSynchronized(List<int> ids) async {
    final db = await _getDB();
    await db.update(
      'migrations',
      {'sync_status': 1},
      where: 'id IN (${ids.join(',')})',
    );
  }

// Delete a migration by ID
  static Future<void> deleteMigration(int id) async {
    final db = await _getDB();
    await db.delete(
      'migrations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// Clear all migrations
  static Future<void> clearMigrations() async {
    final db = await _getDB();
    await db.delete('migrations');
  }

// Clear migrations with a specific sync status
  static Future<void> clearMigrationsWithStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'migrations',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  //CRUD operations for job_batches table

  // Insert or update a job batch
  static Future<void> insertOrUpdateJobBatch(JobBatch jobBatch,
      {int syncStatus = 0}) async {
    final db = await _getDB();
    await db.insert(
      'job_batches',
      {
        ...jobBatch.toMap(),
        'sync_status': syncStatus,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Retrieve a job batch by ID
  static Future<JobBatch?> getJobBatchById(String id) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'job_batches',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return JobBatch.fromMap(maps.first);
    }
    return null;
  }

// Retrieve all job batches
  static Future<List<JobBatch>> getAllJobBatches() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('job_batches');

    return List.generate(maps.length, (i) {
      return JobBatch.fromMap(maps[i]);
    });
  }

// Retrieve job batches by sync_status
  static Future<List<JobBatch>> getJobBatchesBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'job_batches',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );

    return List.generate(maps.length, (i) {
      return JobBatch.fromMap(maps[i]);
    });
  }

// Update sync status to 1 (synchronized) for specific job batches
  static Future<void> markJobBatchesAsSynchronized(List<String> ids) async {
    final db = await _getDB();
    await db.update(
      'job_batches',
      {'sync_status': 1},
      where: 'id IN (${ids.map((_) => '?').join(',')})',
      whereArgs: ids,
    );
  }

// Delete a job batch by ID
  static Future<void> deleteJobBatch(String id) async {
    final db = await _getDB();
    await db.delete(
      'job_batches',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// Clear all job batches
  static Future<void> clearJobBatches() async {
    final db = await _getDB();
    await db.delete('job_batches');
  }

// Clear job batches with a specific sync status
  static Future<void> clearJobBatchesWithStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'job_batches',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  // CRUD operations for jobs table

  // Insert or update a job
  static Future<void> insertOrUpdateJob(Job job, {int syncStatus = 0}) async {
    final db = await _getDB();
    await db.insert(
      'jobs',
      {
        ...job.toMap(),
        'sync_status': syncStatus,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Retrieve a job by ID
  static Future<Job?> getJobById(int id) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'jobs',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Job.fromMap(maps.first);
    }
    return null;
  }

// Retrieve all jobs
  static Future<List<Job>> getAllJobs() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('jobs');

    return List.generate(maps.length, (i) {
      return Job.fromMap(maps[i]);
    });
  }

// Retrieve jobs by sync_status
  static Future<List<Job>> getJobsBySyncStatus(int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'jobs',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );

    return List.generate(maps.length, (i) {
      return Job.fromMap(maps[i]);
    });
  }

// Update sync status to 1 (synchronized) for specific jobs
  static Future<void> markJobsAsSynchronized(List<int> ids) async {
    final db = await _getDB();
    await db.update(
      'jobs',
      {'sync_status': 1},
      where: 'id IN (${ids.map((_) => '?').join(',')})',
      whereArgs: ids,
    );
  }

// Delete a job by ID
  static Future<void> deleteJob(int id) async {
    final db = await _getDB();
    await db.delete(
      'jobs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// Clear all jobs
  static Future<void> clearJobs() async {
    final db = await _getDB();
    await db.delete('jobs');
  }

// Clear jobs with a specific sync status
  static Future<void> clearJobsWithStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'jobs',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  // CRUD operations for item_variants table

  // Insert or update an item variant
  // Insert or update an item variant
  static Future<void> insertOrUpdateItemVariant(ItemVariant itemVariant,
      {int syncStatus = 0}) async {
    final db = await _getDB();
    await db.insert(
      'item_variants',
      {
        ...itemVariant.toMap(),
        'sync_status': syncStatus,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Retrieve an item variant by ID
  static Future<ItemVariant?> getItemVariantById(int id) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'item_variants',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ItemVariant.fromMap(maps.first);
    }
    return null;
  }

// Retrieve all item variants
  static Future<List<ItemVariant>> getAllItemVariants() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('item_variants');

    return List.generate(maps.length, (i) {
      return ItemVariant.fromMap(maps[i]);
    });
  }

// Retrieve item variants by sync_status
  static Future<List<ItemVariant>> getItemVariantsBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'item_variants',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );

    return List.generate(maps.length, (i) {
      return ItemVariant.fromMap(maps[i]);
    });
  }

// Update sync status to 1 (synchronized) for specific item variants
  static Future<void> markItemVariantsAsSynchronized(List<int> ids) async {
    final db = await _getDB();
    await db.update(
      'item_variants',
      {'sync_status': 1},
      where: 'id IN (${ids.map((_) => '?').join(',')})',
      whereArgs: ids,
    );
  }

// Delete an item variant by ID
  static Future<void> deleteItemVariant(int id) async {
    final db = await _getDB();
    await db.delete(
      'item_variants',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// Clear all item variants
  static Future<void> clearItemVariants() async {
    final db = await _getDB();
    await db.delete('item_variants');
  }

// Clear item variants with a specific sync status
  static Future<void> clearItemVariantsWithStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'item_variants',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  // CRUD operations for item_transfers table

  // Insert or update an item transfer
  static Future<void> insertOrUpdateItemTransfer(ItemTransfer itemTransfer,
      {int syncStatus = 0}) async {
    final db = await _getDB();
    await db.insert(
      'item_transfers',
      {
        ...itemTransfer.toMap(),
        'sync_status': syncStatus,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Retrieve an item transfer by ID
  static Future<ItemTransfer?> getItemTransferById(int id) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'item_transfers',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ItemTransfer.fromMap(maps.first);
    }
    return null;
  }

// Retrieve all item transfers
  static Future<List<ItemTransfer>> getAllItemTransfers() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('item_transfers');

    return List.generate(maps.length, (i) {
      return ItemTransfer.fromMap(maps[i]);
    });
  }

// Retrieve item transfers by sync_status
  static Future<List<ItemTransfer>> getItemTransfersBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'item_transfers',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );

    return List.generate(maps.length, (i) {
      return ItemTransfer.fromMap(maps[i]);
    });
  }

// Update sync status to 1 (synchronized) for specific item transfers
  static Future<void> markItemTransfersAsSynchronized(List<int> ids) async {
    final db = await _getDB();
    await db.update(
      'item_transfers',
      {'sync_status': 1},
      where: 'id IN (${ids.map((_) => '?').join(',')})',
      whereArgs: ids,
    );
  }

// Delete an item transfer by ID
  static Future<void> deleteItemTransfer(int id) async {
    final db = await _getDB();
    await db.delete(
      'item_transfers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// Clear all item transfers
  static Future<void> clearItemTransfers() async {
    final db = await _getDB();
    await db.delete('item_transfers');
  }

// Clear item transfers with a specific sync status
  static Future<void> clearItemTransfersWithStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'item_transfers',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  // CRUD operations for item_sub_categories table

  // Insert or update an item sub-category
  // Insert or update an item sub-category
  static Future<void> insertOrUpdateItemSubCategory(
      ItemSubCategory itemSubCategory,
      {int syncStatus = 0}) async {
    final db = await _getDB();
    await db.insert(
      'item_sub_categories',
      {
        ...itemSubCategory.toMap(),
        'sync_status': syncStatus,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Retrieve an item sub-category by ID
  static Future<ItemSubCategory?> getItemSubCategoryById(int id) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'item_sub_categories',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ItemSubCategory.fromMap(maps.first);
    }
    return null;
  }

// Retrieve all item sub-categories
  static Future<List<ItemSubCategory>> getAllItemSubCategories() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps =
        await db.query('item_sub_categories');

    return List.generate(maps.length, (i) {
      return ItemSubCategory.fromMap(maps[i]);
    });
  }

// Retrieve item sub-categories by sync_status
  static Future<List<ItemSubCategory>> getItemSubCategoriesBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'item_sub_categories',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );

    return List.generate(maps.length, (i) {
      return ItemSubCategory.fromMap(maps[i]);
    });
  }

// Update sync status to 1 (synchronized) for specific item sub-categories
  static Future<void> markItemSubCategoriesAsSynchronized(List<int> ids) async {
    final db = await _getDB();
    await db.update(
      'item_sub_categories',
      {'sync_status': 1},
      where: 'id IN (${ids.map((_) => '?').join(',')})',
      whereArgs: ids,
    );
  }

// Delete an item sub-category by ID
  static Future<void> deleteItemSubCategory(int id) async {
    final db = await _getDB();
    await db.delete(
      'item_sub_categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// Clear all item sub-categories
  static Future<void> clearItemSubCategories() async {
    final db = await _getDB();
    await db.delete('item_sub_categories');
  }

// Clear item sub-categories with a specific sync status
  static Future<void> clearItemSubCategoriesWithStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'item_sub_categories',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

// CRUD operations for item_images table

  // Insert or update an item image
  // Insert or update an item image
  static Future<void> insertOrUpdateItemImage(ItemImage itemImage,
      {int syncStatus = 0}) async {
    final db = await _getDB();
    await db.insert(
      'item_images',
      {
        ...itemImage.toMap(),
        'sync_status': syncStatus,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Retrieve an item image by ID
  static Future<ItemImage?> getItemImageById(int id) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'item_images',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ItemImage.fromMap(maps.first);
    }
    return null;
  }

// Retrieve all item images
  static Future<List<ItemImage>> getAllItemImages() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('item_images');

    return List.generate(maps.length, (i) {
      return ItemImage.fromMap(maps[i]);
    });
  }

// Retrieve item images by sync_status
  static Future<List<ItemImage>> getItemImagesBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'item_images',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );

    return List.generate(maps.length, (i) {
      return ItemImage.fromMap(maps[i]);
    });
  }

// Update sync status to 1 (synchronized) for specific item images
  static Future<void> markItemImagesAsSynchronized(List<int> ids) async {
    final db = await _getDB();
    await db.update(
      'item_images',
      {'sync_status': 1},
      where: 'id IN (${ids.map((_) => '?').join(',')})',
      whereArgs: ids,
    );
  }

// Delete an item image by ID
  static Future<void> deleteItemImage(int id) async {
    final db = await _getDB();
    await db.delete(
      'item_images',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// Clear all item images
  static Future<void> clearItemImages() async {
    final db = await _getDB();
    await db.delete('item_images');
  }

// Clear item images with a specific sync status
  static Future<void> clearItemImagesWithStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'item_images',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  // CRUD operations for invoices table

  // Insert or update an invoice
  // Insert or update an invoice
  static Future<void> insertOrUpdateInvoice(Invoice invoice,
      {int syncStatus = 0}) async {
    final db = await _getDB();
    await db.insert(
      'invoices',
      {
        ...invoice.toMap(),
        'sync_status': syncStatus,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Retrieve an invoice by ID
  static Future<Invoice?> getInvoiceById(int id) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'invoices',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Invoice.fromMap(maps.first);
    }
    return null;
  }

// Retrieve all invoices
  static Future<List<Invoice>> getAllInvoices() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('invoices');

    return List.generate(maps.length, (i) {
      return Invoice.fromMap(maps[i]);
    });
  }

// Retrieve invoices by sync_status
  static Future<List<Invoice>> getInvoicesBySyncStatus(int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'invoices',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );

    return List.generate(maps.length, (i) {
      return Invoice.fromMap(maps[i]);
    });
  }

// Update sync status to 1 (synchronized) for specific invoices
  static Future<void> markInvoicesAsSynchronized(List<int> ids) async {
    final db = await _getDB();
    await db.update(
      'invoices',
      {'sync_status': 1},
      where: 'id IN (${ids.map((_) => '?').join(',')})',
      whereArgs: ids,
    );
  }

// Delete an invoice by ID
  static Future<void> deleteInvoice(int id) async {
    final db = await _getDB();
    await db.delete(
      'invoices',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// Clear all invoices
  static Future<void> clearInvoices() async {
    final db = await _getDB();
    await db.delete('invoices');
  }

// Clear invoices with a specific sync_status
  static Future<void> clearInvoicesWithStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'invoices',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  // CRUD operations for general_settings table

  // Insert or update general settings
  // Insert or update general settings
  static Future<void> insertOrUpdateGeneralSettings(GeneralSettings settings,
      {int syncStatus = 0}) async {
    final db = await _getDB();
    await db.insert(
      'general_settings',
      {
        ...settings.toMap(),
        'sync_status': syncStatus,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Retrieve general settings by ID
  static Future<GeneralSettings?> getGeneralSettingsById(int id) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'general_settings',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return GeneralSettings.fromMap(maps.first);
    }
    return null;
  }

// Retrieve all general settings
  static Future<List<GeneralSettings>> getAllGeneralSettings() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('general_settings');

    return List.generate(maps.length, (i) {
      return GeneralSettings.fromMap(maps[i]);
    });
  }

// Retrieve general settings by sync_status
  static Future<List<GeneralSettings>> getGeneralSettingsBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'general_settings',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );

    return List.generate(maps.length, (i) {
      return GeneralSettings.fromMap(maps[i]);
    });
  }

// Update sync status to 1 (synchronized) for specific settings
  static Future<void> markGeneralSettingsAsSynchronized(List<int> ids) async {
    final db = await _getDB();
    await db.update(
      'general_settings',
      {'sync_status': 1},
      where: 'id IN (${ids.map((_) => '?').join(',')})',
      whereArgs: ids,
    );
  }

// Delete general settings by ID
  static Future<void> deleteGeneralSettings(int id) async {
    final db = await _getDB();
    await db.delete(
      'general_settings',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// Clear all general settings
  static Future<void> clearGeneralSettings() async {
    final db = await _getDB();
    await db.delete('general_settings');
  }

// Clear general settings with a specific sync_status
  static Future<void> clearGeneralSettingsWithStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'general_settings',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  // CRUD operations for failed_jobs table

  // Insert a new failed job
  // Insert or update a failed job
  static Future<void> insertOrUpdateFailedJob(FailedJob job,
      {int syncStatus = 0}) async {
    final db = await _getDB();
    await db.insert(
      'failed_jobs',
      {
        ...job.toMap(),
        'sync_status': syncStatus,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Retrieve a failed job by ID
  static Future<FailedJob?> getFailedJobById(int id) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'failed_jobs',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return FailedJob.fromMap(maps.first);
    }
    return null;
  }

// Retrieve all failed jobs
  static Future<List<FailedJob>> getFailedJobs() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('failed_jobs');

    return List.generate(maps.length, (i) {
      return FailedJob.fromMap(maps[i]);
    });
  }

// Retrieve failed jobs by sync_status
  static Future<List<FailedJob>> getFailedJobsBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'failed_jobs',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );

    return List.generate(maps.length, (i) {
      return FailedJob.fromMap(maps[i]);
    });
  }

// Update sync status to 1 (synchronized) for specific failed jobs
  static Future<void> markFailedJobsAsSynchronized(List<int> ids) async {
    final db = await _getDB();
    await db.update(
      'failed_jobs',
      {'sync_status': 1},
      where: 'id IN (${ids.map((_) => '?').join(',')})',
      whereArgs: ids,
    );
  }

// Delete a failed job by ID
  static Future<void> deleteFailedJob(int id) async {
    final db = await _getDB();
    await db.delete(
      'failed_jobs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// Clear all failed jobs
  static Future<void> clearFailedJobs() async {
    final db = await _getDB();
    await db.delete('failed_jobs');
  }

// Clear failed jobs with a specific sync_status
  static Future<void> clearFailedJobsWithStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'failed_jobs',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  // CRUD operations for expense_categories table

  // Insert a new expense category
  // Insert or update an expense category
  static Future<void> insertOrUpdateExpenseCategory(ExpenseCategory category,
      {int syncStatus = 0}) async {
    final db = await _getDB();
    await db.insert(
      'expense_categories',
      {
        ...category.toMap(),
        'sync_status': syncStatus,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Retrieve all expense categories
  static Future<List<ExpenseCategory>> getExpenseCategories() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps =
        await db.query('expense_categories');

    return List.generate(maps.length, (i) {
      return ExpenseCategory.fromMap(maps[i]);
    });
  }

// Retrieve an expense category by ID
  static Future<ExpenseCategory?> getExpenseCategoryById(int id) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'expense_categories',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return ExpenseCategory.fromMap(maps.first);
    }
    return null;
  }

// Retrieve expense categories by sync_status
  static Future<List<ExpenseCategory>> getExpenseCategoriesBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'expense_categories',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );

    return List.generate(maps.length, (i) {
      return ExpenseCategory.fromMap(maps[i]);
    });
  }

// Update an expense category
  static Future<void> updateExpenseCategory(ExpenseCategory category,
      {int syncStatus = 0}) async {
    final db = await _getDB();
    await db.update(
      'expense_categories',
      {
        ...category.toMap(),
        'sync_status': syncStatus,
      },
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

// Delete an expense category
  static Future<void> deleteExpenseCategory(int id) async {
    final db = await _getDB();
    await db.delete(
      'expense_categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// Clear all expense categories
  static Future<void> clearExpenseCategories() async {
    final db = await _getDB();
    await db.delete('expense_categories');
  }

// Clear expense categories by sync_status
  static Future<void> clearExpenseCategoriesWithStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'expense_categories',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  // CRUD operations for expenses table

  // Insert a new expense
// Insert or update an expense
  static Future<void> insertExpense(Expense expense,
      {int syncStatus = 0}) async {
    final db = await _getDB();
    await db.insert(
      'expenses',
      {
        ...expense.toMap(),
        'sync_status': syncStatus,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Retrieve all expenses
  static Future<List<Expense>> getExpenses() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('expenses');

    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

// Retrieve an expense by ID
  static Future<Expense?> getExpenseById(int id) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Expense.fromMap(maps.first);
    }
    return null;
  }

// Retrieve expenses by sync_status
  static Future<List<Expense>> getExpensesBySyncStatus(int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );

    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

// Update an expense
  static Future<void> updateExpense(Expense expense,
      {int syncStatus = 0}) async {
    final db = await _getDB();
    await db.update(
      'expenses',
      {
        ...expense.toMap(),
        'sync_status': syncStatus,
      },
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

// Delete an expense
  static Future<void> deleteExpense(int id) async {
    final db = await _getDB();
    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// Clear all expenses
  static Future<void> clearExpenses() async {
    final db = await _getDB();
    await db.delete('expenses');
  }

// Clear expenses with a specific sync_status
  static Future<void> clearExpensesWithStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'expenses',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  // CRUD operations for event_templates table

  // Insert a new event template
  // Insert or update an event template
  static Future<void> insertOrUpdateEventTemplate(EventTemplate eventTemplate,
      {int syncStatus = 0}) async {
    final db = await _getDB();
    await db.insert(
      'event_templates',
      {
        ...eventTemplate.toMap(),
        'sync_status': syncStatus,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Retrieve all event templates
  static Future<List<EventTemplate>> getEventTemplates() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('event_templates');

    return List.generate(maps.length, (i) {
      return EventTemplate.fromMap(maps[i]);
    });
  }

// Retrieve an event template by ID
  static Future<EventTemplate?> getEventTemplateById(int id) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'event_templates',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return EventTemplate.fromMap(maps.first);
    }
    return null;
  }

// Retrieve event templates by sync_status
  static Future<List<EventTemplate>> getEventTemplatesBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'event_templates',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );

    return List.generate(maps.length, (i) {
      return EventTemplate.fromMap(maps[i]);
    });
  }

// Update an event template
  static Future<void> updateEventTemplate(EventTemplate eventTemplate,
      {int syncStatus = 0}) async {
    final db = await _getDB();
    await db.update(
      'event_templates',
      {
        ...eventTemplate.toMap(),
        'sync_status': syncStatus,
      },
      where: 'id = ?',
      whereArgs: [eventTemplate.id],
    );
  }

// Delete an event template
  static Future<void> deleteEventTemplate(int id) async {
    final db = await _getDB();
    await db.delete(
      'event_templates',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// Clear all event templates
  static Future<void> clearEventTemplates() async {
    final db = await _getDB();
    await db.delete('event_templates');
  }

// Clear event templates with a specific sync_status
  static Future<void> clearEventTemplatesWithStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'event_templates',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  // CRUD operations for events table

  // Insert or update an event
  static Future<void> insertOrUpdateEvent(Event event,
      {int syncStatus = 0}) async {
    final db = await _getDB();
    await db.insert(
      'events',
      {
        ...event.toMap(),
        'sync_status': syncStatus,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Retrieve all events
  static Future<List<Event>> getEvents() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('events');

    return List.generate(maps.length, (i) {
      return Event.fromMap(maps[i]);
    });
  }

// Retrieve an event by ID
  static Future<Event?> getEventById(int id) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Event.fromMap(maps.first);
    }
    return null;
  }

// Retrieve events by sync_status
  static Future<List<Event>> getEventsBySyncStatus(int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'events',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );

    return List.generate(maps.length, (i) {
      return Event.fromMap(maps[i]);
    });
  }

// Update an event
  static Future<void> updateEvent(Event event, {int syncStatus = 0}) async {
    final db = await _getDB();
    await db.update(
      'events',
      {
        ...event.toMap(),
        'sync_status': syncStatus,
      },
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

// Delete an event
  static Future<void> deleteEvent(int id) async {
    final db = await _getDB();
    await db.delete(
      'events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// Clear all events
  static Future<void> clearEvents() async {
    final db = await _getDB();
    await db.delete('events');
  }

// Clear events with a specific sync_status
  static Future<void> clearEventsWithStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'events',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  // CRUD operations for employee_assigned_shops table

  // Insert or update an employee assigned shop
  static Future<void> insertOrUpdateEmployeeAssignedShop(
      EmployeeAssignedShop shop,
      {int syncStatus = 0}) async {
    final db = await _getDB();
    await db.insert(
      'employee_assigned_shops',
      {
        ...shop.toMap(),
        'sync_status': syncStatus,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Retrieve all employee assigned shops
  static Future<List<EmployeeAssignedShop>> getEmployeeAssignedShops() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps =
        await db.query('employee_assigned_shops');

    return List.generate(maps.length, (i) {
      return EmployeeAssignedShop.fromMap(maps[i]);
    });
  }

// Retrieve an employee assigned shop by ID
  static Future<EmployeeAssignedShop?> getEmployeeAssignedShopById(
      int id) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'employee_assigned_shops',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return EmployeeAssignedShop.fromMap(maps.first);
    }
    return null;
  }

// Retrieve employee assigned shops by sync_status
  static Future<List<EmployeeAssignedShop>>
      getEmployeeAssignedShopsBySyncStatus(int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'employee_assigned_shops',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );

    return List.generate(maps.length, (i) {
      return EmployeeAssignedShop.fromMap(maps[i]);
    });
  }

// Update an employee assigned shop
  static Future<void> updateEmployeeAssignedShop(EmployeeAssignedShop shop,
      {int syncStatus = 0}) async {
    final db = await _getDB();
    await db.update(
      'employee_assigned_shops',
      {
        ...shop.toMap(),
        'sync_status': syncStatus,
      },
      where: 'id = ?',
      whereArgs: [shop.id],
    );
  }

// Delete an employee assigned shop
  static Future<void> deleteEmployeeAssignedShop(int id) async {
    final db = await _getDB();
    await db.delete(
      'employee_assigned_shops',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// Clear all employee assigned shops
  static Future<void> clearEmployeeAssignedShops() async {
    final db = await _getDB();
    await db.delete('employee_assigned_shops');
  }

// Clear employee assigned shops with a specific sync_status
  static Future<void> clearEmployeeAssignedShopsWithStatus(
      int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'employee_assigned_shops',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  // CRUD operations for designations table

  // Insert a new designation
  // Insert or update a designation
  static Future<void> insertOrUpdateDesignation(Designation designation,
      {int syncStatus = 0}) async {
    final db = await _getDB();
    await db.insert(
      'designations',
      {
        ...designation.toMap(),
        'sync_status': syncStatus,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Retrieve all designations
  static Future<List<Designation>> getDesignations() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('designations');

    return List.generate(maps.length, (i) {
      return Designation.fromMap(maps[i]);
    });
  }

// Retrieve a designation by ID
  static Future<Designation?> getDesignationById(int id) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'designations',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Designation.fromMap(maps.first);
    }
    return null;
  }

// Retrieve designations by sync_status
  static Future<List<Designation>> getDesignationsBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'designations',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );

    return List.generate(maps.length, (i) {
      return Designation.fromMap(maps[i]);
    });
  }

// Update a designation
  static Future<void> updateDesignation(Designation designation,
      {int syncStatus = 0}) async {
    final db = await _getDB();
    await db.update(
      'designations',
      {
        ...designation.toMap(),
        'sync_status': syncStatus,
      },
      where: 'id = ?',
      whereArgs: [designation.id],
    );
  }

// Delete a designation
  static Future<void> deleteDesignation(int id) async {
    final db = await _getDB();
    await db.delete(
      'designations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// Clear all designations
  static Future<void> clearDesignations() async {
    final db = await _getDB();
    await db.delete('designations');
  }

// Clear designations with a specific sync_status
  static Future<void> clearDesignationsWithStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'designations',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  // CRUD operations for departments table

  // Insert a new department
  // Insert or update a department
  static Future<void> insertOrUpdateDepartment(Department department,
      {int syncStatus = 0}) async {
    final db = await _getDB();
    await db.insert(
      'departments',
      {
        ...department.toMap(),
        'sync_status': syncStatus,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Retrieve all departments
  static Future<List<Department>> getDepartments() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('departments');

    return List.generate(maps.length, (i) {
      return Department.fromMap(maps[i]);
    });
  }

// Retrieve a department by ID
  static Future<Department?> getDepartmentById(int id) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'departments',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Department.fromMap(maps.first);
    }
    return null;
  }

// Retrieve departments by sync_status
  static Future<List<Department>> getDepartmentsBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'departments',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );

    return List.generate(maps.length, (i) {
      return Department.fromMap(maps[i]);
    });
  }

// Update a department
  static Future<void> updateDepartment(Department department,
      {int syncStatus = 0}) async {
    final db = await _getDB();
    await db.update(
      'departments',
      {
        ...department.toMap(),
        'sync_status': syncStatus,
      },
      where: 'id = ?',
      whereArgs: [department.id],
    );
  }

// Delete a department
  static Future<void> deleteDepartment(int id) async {
    final db = await _getDB();
    await db.delete(
      'departments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

// Clear all departments
  static Future<void> clearDepartments() async {
    final db = await _getDB();
    await db.delete('departments');
  }

// Clear departments with a specific sync_status
  static Future<void> clearDepartmentsWithStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'departments',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  // CRUD operations for customer_supplier_accounts table

  // Insert a new customer or supplier
  Future<void> insertCustomerSupplierAccount(Map<String, dynamic> map) async {
    final db = await _getDB();
    map['sync_status'] =
        map['sync_status'] ?? 0; // Default sync status to 0 if not provided
    map['is_customer'] =
        map['is_customer'] ?? 1; // Default to customer if not provided

    try {
      await db.insert(
        'new_customer_supplier_accounts',
        map,
        conflictAlgorithm: ConflictAlgorithm.replace, // Handle conflicts
      );
      print(
          'Saved customer/supplier: ${map['name']} to local database.'); // Log for confirmation
    } catch (e) {
      print('Error inserting customer/supplier: $e'); // Log the error
    }
  }

  // Retrieve accounts by type (customer/supplier)
  Future<List<Map<String, dynamic>>> getAccountsByType(bool isCustomer) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'new_customer_supplier_accounts',
      where: 'is_customer = ?',
      whereArgs: [isCustomer ? 1 : 0],
    );

    return maps; // Return the list of accounts
  }

  // Update an existing customer or supplier
  Future<void> updateCustomerSupplierAccount(
      int id, Map<String, dynamic> map) async {
    final db = await _getDB();
    try {
      await db.update(
        'new_customer_supplier_accounts',
        map,
        where: 'id = ?',
        whereArgs: [id],
      );
      print('Updated account with id: $id'); // Log for confirmation
    } catch (e) {
      print('Error updating account: $e'); // Log the error
    }
  }

  // Delete an existing customer or supplier
  Future<void> deleteCustomerSupplierAccount(int id) async {
    final db = await _getDB();
    try {
      await db.delete(
        'new_customer_supplier_accounts',
        where: 'id = ?',
        whereArgs: [id],
      );
      print('Deleted account with id: $id'); // Log for confirmation
    } catch (e) {
      print('Error deleting account: $e'); // Log the error
    }
  }

  // Print the number of customers or suppliers
  Future<void> printCustomerCount(bool isCustomer) async {
    final accounts = await getAccountsByType(isCustomer);

    // Print the number of accounts retrieved
    print(
        'Number of ${isCustomer ? "customers" : "suppliers"}: ${accounts.length}');

    // Optional: Print details of the retrieved accounts
    for (var account in accounts) {
      print('Account: ${account['name']}, Phone: ${account['phone']}');
    }
  }

  // CRUD operations for cache_locks table

  // Insert or update a cache lock
  static Future<void> insertOrUpdateCacheLock({
    required String key,
    required String owner,
    required int expiration,
    int syncStatus = 0, // Added syncStatus parameter
  }) async {
    final db = await _getDB();
    await db.insert(
      'cache_locks',
      {
        'key': key,
        'owner': owner,
        'expiration': expiration,
        'sync_status': syncStatus, // Added syncStatus field
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Retrieve a cache lock by key
  static Future<Map<String, dynamic>?> getCacheLock(String key) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'cache_locks',
      where: 'key = ?',
      whereArgs: [key],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

// Retrieve cache locks by sync_status
  static Future<List<Map<String, dynamic>>> getCacheLocksBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'cache_locks',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );

    return maps;
  }

// Delete a cache lock by key
  static Future<void> deleteCacheLock(String key) async {
    final db = await _getDB();
    await db.delete(
      'cache_locks',
      where: 'key = ?',
      whereArgs: [key],
    );
  }

// Clear all cache locks
  static Future<void> clearCacheLocks() async {
    final db = await _getDB();
    await db.delete('cache_locks');
  }

// Clear cache locks by sync_status
  static Future<void> clearCacheLocksByStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'cache_locks',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  // CRUD operations for cache table

  // Insert or update a cache entry
  // Insert or update a cache entry
  static Future<void> insertOrUpdateCache({
    required String key,
    required String value,
    required int expiration,
    int syncStatus = 0, // Added syncStatus parameter
  }) async {
    final db = await _getDB();
    await db.insert(
      'cache',
      {
        'key': key,
        'value': value,
        'expiration': expiration,
        'sync_status': syncStatus, // Added syncStatus field
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Retrieve a cache entry by key
  static Future<Map<String, dynamic>?> getCache(String key) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'cache',
      where: 'key = ?',
      whereArgs: [key],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

// Retrieve a cache entry value by key
  static Future<String?> getCacheValue(String key) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'cache',
      where: 'key = ?',
      whereArgs: [key],
    );

    if (maps.isNotEmpty) {
      final Map<String, dynamic> map = maps.first;
      return map['value'] as String?;
    }
    return null;
  }

// Retrieve cache entries by sync_status
  static Future<List<Map<String, dynamic>>> getCacheBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'cache',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );

    return maps;
  }

// Delete a cache entry by key
  static Future<void> deleteCache(String key) async {
    final db = await _getDB();
    await db.delete(
      'cache',
      where: 'key = ?',
      whereArgs: [key],
    );
  }

// Clear all cache entries
  static Future<void> clearCache() async {
    final db = await _getDB();
    await db.delete('cache');
  }

// Clear cache entries by sync_status
  static Future<void> clearCacheByStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'cache',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  // CRUD operations for business_types table

  // Insert a new business type
  // Add or update a business type
  static Future<int> addBusinessType({
    required BusinessType type,
    int syncStatus = 0, // Added syncStatus parameter
  }) async {
    final db = await _getDB();
    return await db.insert(
      'business_types',
      {
        ...type.toJson(),
        'sync_status': syncStatus, // Added syncStatus field
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Get all business types
  static Future<List<BusinessType>> getAllBusinessTypes() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('business_types');

    return List.generate(maps.length, (i) {
      return BusinessType.fromJson(maps[i]);
    });
  }

// Get business types by sync_status
  static Future<List<BusinessType>> getBusinessTypesBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'business_types',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );

    return List.generate(maps.length, (i) {
      return BusinessType.fromJson(maps[i]);
    });
  }

// Update a business type
  static Future<int> updateBusinessType({
    required BusinessType type,
    int syncStatus = 0, // Added syncStatus parameter
  }) async {
    final db = await _getDB();
    return await db.update(
      'business_types',
      {
        ...type.toJson(),
        'sync_status': syncStatus, // Added syncStatus field
      },
      where: "id = ?",
      whereArgs: [type.id],
    );
  }

// Delete a business type
  static Future<int> deleteBusinessType(int id) async {
    final db = await _getDB();
    return await db.delete(
      'business_types',
      where: "id = ?",
      whereArgs: [id],
    );
  }

// Clear all business types
  static Future<void> clearBusinessTypes() async {
    final db = await _getDB();
    await db.delete('business_types');
  }

// Clear business types by sync_status
  static Future<void> clearBusinessTypesByStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'business_types',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  // CRUD operations for business_categories table

  // Insert a new business category
  // Add or update a business category
  static Future<int> addBusinessCategory({
    required BusinessCategory category,
    int syncStatus = 0, // Added syncStatus parameter
  }) async {
    final db = await _getDB();
    return await db.insert(
      'business_categories',
      {
        ...category.toJson(),
        'sync_status': syncStatus, // Added syncStatus field
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Get all business categories
  static Future<List<BusinessCategory>> getAllBusinessCategories() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps =
        await db.query('business_categories');

    return List.generate(maps.length, (i) {
      return BusinessCategory.fromJson(maps[i]);
    });
  }

// Get business categories by sync_status
  static Future<List<BusinessCategory>> getBusinessCategoriesBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'business_categories',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );

    return List.generate(maps.length, (i) {
      return BusinessCategory.fromJson(maps[i]);
    });
  }

// Update a business category
  static Future<int> updateBusinessCategory({
    required BusinessCategory category,
    int syncStatus = 0, // Added syncStatus parameter
  }) async {
    final db = await _getDB();
    return await db.update(
      'business_categories',
      {
        ...category.toJson(),
        'sync_status': syncStatus, // Added syncStatus field
      },
      where: "id = ?",
      whereArgs: [category.id],
    );
  }

// Delete a business category
  static Future<int> deleteBusinessCategory(int id) async {
    final db = await _getDB();
    return await db.delete(
      'business_categories',
      where: "id = ?",
      whereArgs: [id],
    );
  }

// Clear all business categories
  static Future<void> clearBusinessCategories() async {
    final db = await _getDB();
    await db.delete('business_categories');
  }

// Clear business categories by sync_status
  static Future<void> clearBusinessCategoriesByStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'business_categories',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  // CRUD operations for bundles table

  // Insert a new bundle
  // Add or update a bundle
  static Future<int> addBundle({
    required Bundle bundle,
    int syncStatus = 0, // Added syncStatus parameter
  }) async {
    final db = await _getDB();
    return await db.insert(
      'bundles',
      {
        ...bundle.toJson(),
        'sync_status': syncStatus, // Added syncStatus field
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Get all bundles
  static Future<List<Bundle>> getAllBundles() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('bundles');

    return List.generate(maps.length, (i) {
      return Bundle.fromJson(maps[i]);
    });
  }

// Get bundles by sync_status
  static Future<List<Bundle>> getBundlesBySyncStatus(int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'bundles',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );

    return List.generate(maps.length, (i) {
      return Bundle.fromJson(maps[i]);
    });
  }

// Update a bundle
  static Future<int> updateBundle({
    required Bundle bundle,
    int syncStatus = 0, // Added syncStatus parameter
  }) async {
    final db = await _getDB();
    return await db.update(
      'bundles',
      {
        ...bundle.toJson(),
        'sync_status': syncStatus, // Added syncStatus field
      },
      where: "id = ?",
      whereArgs: [bundle.id],
    );
  }

// Delete a bundle
  static Future<int> deleteBundle(int id) async {
    final db = await _getDB();
    return await db.delete(
      'bundles',
      where: "id = ?",
      whereArgs: [id],
    );
  }

// Clear all bundles
  static Future<void> clearBundles() async {
    final db = await _getDB();
    await db.delete('bundles');
  }

// Clear bundles by sync_status
  static Future<void> clearBundlesByStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'bundles',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  // CRUD operations for brands table

  // Insert a new brand
  // Add or update a brand
  static Future<int> addBrand({
    required Brand brand,
    int syncStatus = 0, // Added syncStatus parameter
  }) async {
    final db = await _getDB();
    return await db.insert(
      'brands',
      {
        ...brand.toJson(),
        'sync_status': syncStatus, // Added syncStatus field
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Get all brands
  static Future<List<Brand>> getAllBrands() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('brands');

    return List.generate(maps.length, (i) {
      return Brand.fromJson(maps[i]);
    });
  }

// Get brands by sync_status
  static Future<List<Brand>> getBrandsBySyncStatus(int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'brands',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );

    return List.generate(maps.length, (i) {
      return Brand.fromJson(maps[i]);
    });
  }

// Update a brand
  static Future<int> updateBrand({
    required Brand brand,
    int syncStatus = 0, // Added syncStatus parameter
  }) async {
    final db = await _getDB();
    return await db.update(
      'brands',
      {
        ...brand.toJson(),
        'sync_status': syncStatus, // Added syncStatus field
      },
      where: "id = ?",
      whereArgs: [brand.id],
    );
  }

// Delete a brand
  static Future<int> deleteBrand(int id) async {
    final db = await _getDB();
    return await db.delete(
      'brands',
      where: "id = ?",
      whereArgs: [id],
    );
  }

// Clear all brands
  static Future<void> clearBrands() async {
    final db = await _getDB();
    await db.delete('brands');
  }

// Clear brands by sync_status
  static Future<void> clearBrandsByStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'brands',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  // CRUD operations for banks table

  // Insert a new bank
  // Add or update a bank
  static Future<int> addBank({
    required Bank bank,
    int syncStatus = 0, // Added syncStatus parameter
  }) async {
    final db = await _getDB();
    return await db.insert(
      'banks',
      {
        ...bank.toJson(),
        'sync_status': syncStatus, // Added syncStatus field
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Get all banks
  static Future<List<Bank>> getAllBanks() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('banks');

    return List.generate(maps.length, (i) {
      return Bank.fromJson(maps[i]);
    });
  }

// Get banks by sync_status
  static Future<List<Bank>> getBanksBySyncStatus(int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'banks',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );

    return List.generate(maps.length, (i) {
      return Bank.fromJson(maps[i]);
    });
  }

// Update a bank
  static Future<int> updateBank({
    required Bank bank,
    int syncStatus = 0, // Added syncStatus parameter
  }) async {
    final db = await _getDB();
    return await db.update(
      'banks',
      {
        ...bank.toJson(),
        'sync_status': syncStatus, // Added syncStatus field
      },
      where: "id = ?",
      whereArgs: [bank.id],
    );
  }

// Delete a bank
  static Future<int> deleteBank(int id) async {
    final db = await _getDB();
    return await db.delete(
      'banks',
      where: "id = ?",
      whereArgs: [id],
    );
  }

// Clear all banks
  static Future<void> clearBanks() async {
    final db = await _getDB();
    await db.delete('banks');
  }

// Clear banks by sync_status
  static Future<void> clearBanksByStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'banks',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  // CRUD operations for audits table

  // Insert a new audit
  // Add or update an audit
  static Future<int> addAudit({
    required Audit audit,
    int syncStatus = 0, // Added syncStatus parameter
  }) async {
    final db = await _getDB();
    return await db.insert(
      'audits',
      {
        ...audit.toJson(),
        'sync_status': syncStatus, // Added syncStatus field
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Get all audits
  static Future<List<Audit>> getAllAudits() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('audits');

    return List.generate(maps.length, (i) {
      return Audit.fromJson(maps[i]);
    });
  }

// Get audits by sync_status
  static Future<List<Audit>> getAuditsBySyncStatus(int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'audits',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );

    return List.generate(maps.length, (i) {
      return Audit.fromJson(maps[i]);
    });
  }

// Update an audit
  static Future<int> updateAudit({
    required Audit audit,
    int syncStatus = 0, // Added syncStatus parameter
  }) async {
    final db = await _getDB();
    return await db.update(
      'audits',
      {
        ...audit.toJson(),
        'sync_status': syncStatus, // Added syncStatus field
      },
      where: "id = ?",
      whereArgs: [audit.id],
    );
  }

// Delete an audit
  static Future<int> deleteAudit(int id) async {
    final db = await _getDB();
    return await db.delete(
      'audits',
      where: "id = ?",
      whereArgs: [id],
    );
  }

// Clear all audits
  static Future<void> clearAudits() async {
    final db = await _getDB();
    await db.delete('audits');
  }

// Clear audits by sync_status
  static Future<void> clearAuditsByStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'audits',
      where: 'sync_status = ?',
      whereArgs: [syncStatus],
    );
  }

  // Insert a new account category
  // Add or update an account category with sync_status
  static Future<int> addAccountCategory({
    required AccountCategory category,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    try {
      return await db.insert(
        'account_categories',
        {
          ...category.toJson(),
          'sync_status':
              syncStatus, // Include sync_status in the insert operation
        },
        conflictAlgorithm: ConflictAlgorithm
            .replace, // Replace existing record if conflict occurs
      );
    } catch (e) {
      print('Error adding or updating account category: $e');
      rethrow; // Rethrow the exception to handle it elsewhere if necessary
    }
  }

// Get all account categories
  static Future<List<AccountCategory>> getAllAccountCategories() async {
    final db = await _getDB();
    try {
      final List<Map<String, dynamic>> maps =
          await db.query('account_categories');
      return List.generate(maps.length, (i) {
        return AccountCategory.fromJson(
            maps[i]); // Convert each map to an AccountCategory object
      });
    } catch (e) {
      print('Error retrieving all account categories: $e');
      rethrow; // Rethrow the exception to handle it elsewhere if necessary
    }
  }

// Get account categories by sync_status
  static Future<List<AccountCategory>> getAccountCategoriesBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'account_categories',
        where: 'sync_status = ?', // Filter by sync_status
        whereArgs: [syncStatus], // Use syncStatus for filtering
      );
      return List.generate(maps.length, (i) {
        return AccountCategory.fromJson(
            maps[i]); // Convert each map to an AccountCategory object
      });
    } catch (e) {
      print('Error retrieving account categories by sync status: $e');
      rethrow; // Rethrow the exception to handle it elsewhere if necessary
    }
  }

// Update an account category with sync_status
  static Future<int> updateAccountCategory({
    required AccountCategory category,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    try {
      return await db.update(
        'account_categories',
        {
          ...category.toJson(),
          'sync_status':
              syncStatus, // Include sync_status in the update operation
        },
        where: "id = ?", // Update where the ID matches
        whereArgs: [
          category.id
        ], // Use the category ID to identify the record to update
      );
    } catch (e) {
      print('Error updating account category: $e');
      rethrow; // Rethrow the exception to handle it elsewhere if necessary
    }
  }

// Delete an account category by ID
  static Future<int> deleteAccountCategory(int id) async {
    final db = await _getDB();
    try {
      return await db.delete(
        'account_categories',
        where: "id = ?", // Delete where the ID matches
        whereArgs: [id], // Use the ID to identify the record to delete
      );
    } catch (e) {
      print('Error deleting account category: $e');
      rethrow; // Rethrow the exception to handle it elsewhere if necessary
    }
  }

// Clear all account categories
  static Future<void> clearAccountCategories() async {
    final db = await _getDB();
    try {
      await db.delete('account_categories');
    } catch (e) {
      print('Error clearing account categories: $e');
      rethrow; // Rethrow the exception to handle it elsewhere if necessary
    }
  }

// Clear account categories by sync_status
  static Future<void> clearAccountCategoriesByStatus(int syncStatus) async {
    final db = await _getDB();
    try {
      await db.delete(
        'account_categories',
        where: 'sync_status = ?', // Delete where sync_status matches
        whereArgs: [syncStatus], // Use syncStatus for filtering
      );
    } catch (e) {
      print('Error clearing account categories by sync status: $e');
      rethrow; // Rethrow the exception to handle it elsewhere if necessary
    }
  }

  // CRUD operations for accounts table

  // Insert a new account
  // Add or update an account with sync_status
  static Future<int> addAccount({
    required Account account,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    try {
      return await db.insert(
        'accounts',
        {
          ...account.toJson(),
          'sync_status':
              syncStatus, // Include sync_status in the insert operation
        },
        conflictAlgorithm: ConflictAlgorithm
            .replace, // Replace existing record if conflict occurs
      );
    } catch (e) {
      print('Error adding or updating account: $e');
      rethrow; // Rethrow the exception to handle it elsewhere if necessary
    }
  }

// Get all accounts
  static Future<List<Account>> getAllAccounts() async {
    final db = await _getDB();
    try {
      final List<Map<String, dynamic>> maps = await db.query('accounts');
      return List.generate(maps.length, (i) {
        return Account.fromJson(
            maps[i]); // Convert each map to an Account object
      });
    } catch (e) {
      print('Error retrieving all accounts: $e');
      rethrow; // Rethrow the exception to handle it elsewhere if necessary
    }
  }

// Get accounts by sync_status
  static Future<List<Account>> getAccountsBySyncStatus(int syncStatus) async {
    final db = await _getDB();
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'accounts',
        where: 'sync_status = ?', // Filter by sync_status
        whereArgs: [syncStatus], // Use syncStatus for filtering
      );
      return List.generate(maps.length, (i) {
        return Account.fromJson(
            maps[i]); // Convert each map to an Account object
      });
    } catch (e) {
      print('Error retrieving accounts by sync status: $e');
      rethrow; // Rethrow the exception to handle it elsewhere if necessary
    }
  }

// Update an account with sync_status
  static Future<int> updateAccount({
    required Account account,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    try {
      return await db.update(
        'accounts',
        {
          ...account.toJson(),
          'sync_status':
              syncStatus, // Include sync_status in the update operation
        },
        where: "id = ?", // Update where the ID matches
        whereArgs: [
          account.id
        ], // Use the account ID to identify the record to update
      );
    } catch (e) {
      print('Error updating account: $e');
      rethrow; // Rethrow the exception to handle it elsewhere if necessary
    }
  }

// Delete an account
  static Future<int> deleteAccount(int id) async {
    final db = await _getDB();
    try {
      return await db.delete(
        'accounts',
        where: "id = ?", // Delete where the ID matches
        whereArgs: [id], // Use the ID to identify the record to delete
      );
    } catch (e) {
      print('Error deleting account: $e');
      rethrow; // Rethrow the exception to handle it elsewhere if necessary
    }
  }

// Clear all accounts
  static Future<void> clearAccounts() async {
    final db = await _getDB();
    try {
      await db.delete('accounts');
    } catch (e) {
      print('Error clearing accounts: $e');
      rethrow; // Rethrow the exception to handle it elsewhere if necessary
    }
  }

// Clear accounts by sync_status
  static Future<void> clearAccountsByStatus(int syncStatus) async {
    final db = await _getDB();
    try {
      await db.delete(
        'accounts',
        where: 'sync_status = ?', // Delete where sync_status matches
        whereArgs: [syncStatus], // Use syncStatus for filtering
      );
    } catch (e) {
      print('Error clearing accounts by sync status: $e');
      rethrow; // Rethrow the exception to handle it elsewhere if necessary
    }
  }

  // CRUD operations for password_reset_tokens table

  // Insert a new token
  // Add or update a password reset token with sync_status
  static Future<void> addPasswordResetToken({
    required String email,
    required String token,
    DateTime? createdAt,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    await db.insert(
      'password_reset_tokens',
      {
        'email': email,
        'token': token,
        'created_at': createdAt?.toIso8601String(),
        'sync_status':
            syncStatus, // Include sync_status in the insert operation
      },
      conflictAlgorithm: ConflictAlgorithm
          .replace, // Replace existing tokens for the same email
    );
  }

// Get a token by email
  static Future<Map<String, dynamic>?> getTokenByEmail(String email) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'password_reset_tokens',
      where: "email = ?",
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }

// Get tokens by sync_status
  static Future<List<Map<String, dynamic>>> getTokensBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'password_reset_tokens',
      where: 'sync_status = ?', // Filter by sync_status
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );

    return maps;
  }

// Update a token with sync_status
  static Future<void> updatePasswordResetToken({
    required String email,
    required String token,
    DateTime? createdAt,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    await db.update(
      'password_reset_tokens',
      {
        'email': email,
        'token': token,
        'created_at': createdAt?.toIso8601String(),
        'sync_status':
            syncStatus, // Include sync_status in the update operation
      },
      where: "token = ?", // Update where the token matches
      whereArgs: [token], // Use the token to identify the record to update
    );
  }

// Delete a token
  static Future<void> deleteToken(String token) async {
    final db = await _getDB();
    await db.delete(
      'password_reset_tokens',
      where: "token = ?", // Delete where the token matches
      whereArgs: [token], // Use the token to identify the record to delete
    );
  }

// Clear all password reset tokens
  static Future<void> clearPasswordResetTokens() async {
    final db = await _getDB();
    await db.delete('password_reset_tokens');
  }

// Clear password reset tokens by sync_status
  static Future<void> clearPasswordResetTokensByStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'password_reset_tokens',
      where: 'sync_status = ?', // Delete where sync_status matches
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );
  }

  // CRUD operations for products table

  // Insert a new product
  // Add or update a product with sync_status
  static Future<int> addProduct({
    required Product product,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.insert(
      'products',
      {
        ...product.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the insert operation
      },
      conflictAlgorithm: ConflictAlgorithm
          .replace, // Replace existing products with the same ID
    );
  }

// Get all products
  static Future<List<Product>> getAllProducts() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('products');

    return List.generate(maps.length, (i) {
      return Product.fromJson(maps[i]);
    });
  }

// Get products by sync_status
  static Future<List<Product>> getProductsBySyncStatus(int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'sync_status = ?', // Filter by sync_status
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );

    return List.generate(maps.length, (i) {
      return Product.fromJson(maps[i]);
    });
  }

// Update a product with sync_status
  static Future<int> updateProduct({
    required Product product,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.update(
      'products',
      {
        ...product.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the update operation
      },
      where: "id = ?", // Update where the product ID matches
      whereArgs: [
        product.id
      ], // Use the product ID to identify the record to update
    );
  }

// Delete a product
  static Future<int> deleteProduct(int id) async {
    final db = await _getDB();
    return await db.delete(
      'products',
      where: "id = ?", // Delete where the product ID matches
      whereArgs: [id], // Use the product ID to identify the record to delete
    );
  }

// Clear all products
  static Future<void> clearProducts() async {
    final db = await _getDB();
    await db.delete('products');
  }

// Clear products by sync_status
  static Future<void> clearProductsByStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'products',
      where: 'sync_status = ?', // Delete where sync_status matches
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );
  }

  // CRUD operations for purchase_orders table

  // Insert a new purchase order
  // Add or update a purchase order with sync_status
  static Future<int> addPurchaseOrder({
    required PurchaseOrder purchaseOrder,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.insert(
      'purchase_orders',
      {
        ...purchaseOrder.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the insert operation
      },
      conflictAlgorithm: ConflictAlgorithm
          .replace, // Replace existing purchase orders with the same ID
    );
  }

// Get all purchase orders
  static Future<List<PurchaseOrder>> getAllPurchaseOrders() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('purchase_orders');

    return List.generate(maps.length, (i) {
      return PurchaseOrder.fromJson(maps[i]);
    });
  }

// Get purchase orders by sync_status
  static Future<List<PurchaseOrder>> getPurchaseOrdersBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'purchase_orders',
      where: 'sync_status = ?', // Filter by sync_status
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );

    return List.generate(maps.length, (i) {
      return PurchaseOrder.fromJson(maps[i]);
    });
  }

// Update a purchase order with sync_status
  static Future<int> updatePurchaseOrder({
    required PurchaseOrder purchaseOrder,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.update(
      'purchase_orders',
      {
        ...purchaseOrder.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the update operation
      },
      where: "id = ?", // Update where the purchase order ID matches
      whereArgs: [
        purchaseOrder.id
      ], // Use the purchase order ID to identify the record to update
    );
  }

// Delete a purchase order
  static Future<int> deletePurchaseOrder(int id) async {
    final db = await _getDB();
    return await db.delete(
      'purchase_orders',
      where: "id = ?", // Delete where the purchase order ID matches
      whereArgs: [
        id
      ], // Use the purchase order ID to identify the record to delete
    );
  }

// Clear all purchase orders
  static Future<void> clearPurchaseOrders() async {
    final db = await _getDB();
    await db.delete('purchase_orders');
  }

// Clear purchase orders by sync_status
  static Future<void> clearPurchaseOrdersByStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'purchase_orders',
      where: 'sync_status = ?', // Delete where sync_status matches
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );
  }

  // CRUD operations for quotations table

  // Insert a new quotation
  // Add or update a quotation with sync_status
  static Future<int> addQuotation({
    required Quotation quotation,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.insert(
      'quotations',
      {
        ...quotation.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the insert operation
      },
      conflictAlgorithm: ConflictAlgorithm
          .replace, // Replace existing quotations with the same ID
    );
  }

// Get all quotations
  static Future<List<Quotation>> getAllQuotations() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('quotations');

    return List.generate(maps.length, (i) {
      return Quotation.fromJson(maps[i]);
    });
  }

// Get quotations by sync_status
  static Future<List<Quotation>> getQuotationsBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'quotations',
      where: 'sync_status = ?', // Filter by sync_status
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );

    return List.generate(maps.length, (i) {
      return Quotation.fromJson(maps[i]);
    });
  }

// Update a quotation with sync_status
  static Future<int> updateQuotation({
    required Quotation quotation,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.update(
      'quotations',
      {
        ...quotation.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the update operation
      },
      where: "id = ?", // Update where the quotation ID matches
      whereArgs: [
        quotation.id
      ], // Use the quotation ID to identify the record to update
    );
  }

// Delete a quotation
  static Future<int> deleteQuotation(int id) async {
    final db = await _getDB();
    return await db.delete(
      'quotations',
      where: "id = ?", // Delete where the quotation ID matches
      whereArgs: [id], // Use the quotation ID to identify the record to delete
    );
  }

// Clear all quotations
  static Future<void> clearQuotations() async {
    final db = await _getDB();
    await db.delete('quotations');
  }

// Clear quotations by sync_status
  static Future<void> clearQuotationsByStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'quotations',
      where: 'sync_status = ?', // Delete where sync_status matches
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );
  }

  // CRUD operations for quotation_items table

  // Insert a new quotation item
  // Add or update a quotation item with sync_status
  static Future<int> addQuotationItem({
    required QuotationItem item,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.insert(
      'quotation_items',
      {
        ...item.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the insert operation
      },
      conflictAlgorithm:
          ConflictAlgorithm.replace, // Replace existing items with the same ID
    );
  }

// Get all quotation items
  static Future<List<QuotationItem>> getAllQuotationItems() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('quotation_items');

    return List.generate(maps.length, (i) {
      return QuotationItem.fromJson(maps[i]);
    });
  }

// Get quotation items by sync_status
  static Future<List<QuotationItem>> getQuotationItemsBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'quotation_items',
      where: 'sync_status = ?', // Filter by sync_status
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );

    return List.generate(maps.length, (i) {
      return QuotationItem.fromJson(maps[i]);
    });
  }

// Update a quotation item with sync_status
  static Future<int> updateQuotationItem({
    required QuotationItem item,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.update(
      'quotation_items',
      {
        ...item.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the update operation
      },
      where: "id = ?", // Update where the item ID matches
      whereArgs: [item.id], // Use the item ID to identify the record to update
    );
  }

// Delete a quotation item
  static Future<int> deleteQuotationItem(int id) async {
    final db = await _getDB();
    return await db.delete(
      'quotation_items',
      where: "id = ?", // Delete where the item ID matches
      whereArgs: [id], // Use the item ID to identify the record to delete
    );
  }

// Clear all quotation items
  static Future<void> clearQuotationItems() async {
    final db = await _getDB();
    await db.delete('quotation_items');
  }

// Clear quotation items by sync_status
  static Future<void> clearQuotationItemsByStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'quotation_items',
      where: 'sync_status = ?', // Delete where sync_status matches
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );
  }

  // CRUD operations for roles table

  // Insert a new role
  // Add or update a role with sync_status
  static Future<int> addRole({
    required Role role,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.insert(
      'roles',
      {
        ...role.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the insert operation
      },
      conflictAlgorithm:
          ConflictAlgorithm.replace, // Replace existing roles with the same ID
    );
  }

// Get all roles
  static Future<List<Role>> getAllRoles() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('roles');

    return List.generate(maps.length, (i) {
      return Role.fromJson(maps[i]);
    });
  }

// Get roles by sync_status
  static Future<List<Role>> getRolesBySyncStatus(int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'roles',
      where: 'sync_status = ?', // Filter by sync_status
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );

    return List.generate(maps.length, (i) {
      return Role.fromJson(maps[i]);
    });
  }

// Update a role with sync_status
  static Future<int> updateRole({
    required Role role,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.update(
      'roles',
      {
        ...role.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the update operation
      },
      where: "id = ?", // Update where the role ID matches
      whereArgs: [role.id], // Use the role ID to identify the record to update
    );
  }

// Delete a role
  static Future<int> deleteRole(int id) async {
    final db = await _getDB();
    return await db.delete(
      'roles',
      where: "id = ?", // Delete where the role ID matches
      whereArgs: [id], // Use the role ID to identify the record to delete
    );
  }

// Clear all roles
  static Future<void> clearRoles() async {
    final db = await _getDB();
    await db.delete('roles');
  }

// Clear roles by sync_status
  static Future<void> clearRolesByStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'roles',
      where: 'sync_status = ?', // Delete where sync_status matches
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );
  }

  // CRUD operations for role_has_permissions table

  // Insert a new role_has_permission
  static Future<int> addRoleHasPermission(int permissionId, int roleId) async {
    final db = await _getDB();
    return await db.insert(
      'role_has_permissions',
      {
        'permission_id': permissionId,
        'role_id': roleId,
      },
    );
  }

  // Get all role_has_permissions
  static Future<List<Map<String, dynamic>>> getAllRoleHasPermissions() async {
    final db = await _getDB();
    return await db.query('role_has_permissions');
  }

  // Delete a role_has_permission
  static Future<int> deleteRoleHasPermission(
      int permissionId, int roleId) async {
    final db = await _getDB();
    return await db.delete(
      'role_has_permissions',
      where: 'permission_id = ? AND role_id = ?',
      whereArgs: [permissionId, roleId],
    );
  }

  // CRUD operations for sessions table

  // Get all sessions
  // Get all sessions
  static Future<List<Session>> getAllSessions() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('sessions');

    return List.generate(maps.length, (i) {
      return Session.fromJson(maps[i]);
    });
  }

// Insert a new session with sync_status
  static Future<int> addSession({
    required Session session,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.insert(
      'sessions',
      {
        ...session.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the insert operation
      },
      conflictAlgorithm:
          ConflictAlgorithm.replace, // Replace existing records if any
    );
  }

// Update a session with sync_status
  static Future<int> updateSession({
    required Session session,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.update(
      'sessions',
      {
        ...session.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the update operation
      },
      where: "id = ?",
      whereArgs: [session.id],
    );
  }

// Delete a session
  static Future<int> deleteSession(String id) async {
    final db = await _getDB();
    return await db.delete(
      'sessions',
      where: "id = ?",
      whereArgs: [id],
    );
  }

// Get sessions by sync_status
  static Future<List<Session>> getSessionsBySyncStatus(int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'sessions',
      where: 'sync_status = ?', // Filter by sync_status
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );

    return List.generate(maps.length, (i) {
      return Session.fromJson(maps[i]);
    });
  }

// Clear all sessions
  static Future<void> clearSessions() async {
    final db = await _getDB();
    await db.delete('sessions');
  }

// Clear sessions by sync_status
  static Future<void> clearSessionsByStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'sessions',
      where: 'sync_status = ?', // Delete where sync_status matches
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );
  }

  // CRUD operations for shops table

  // Get all shops
  // Get all shops
  static Future<List<Shop>> getAllShops() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('shops');

    return List.generate(maps.length, (i) {
      return Shop.fromJson(maps[i]);
    });
  }

// Insert a new shop with sync_status
  static Future<int> addShop({
    required Shop shop,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.insert(
      'shops',
      {
        ...shop.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the insert operation
      },
      conflictAlgorithm:
          ConflictAlgorithm.replace, // Replace existing records if any
    );
  }

// Update a shop with sync_status
  static Future<int> updateShop({
    required Shop shop,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.update(
      'shops',
      {
        ...shop.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the update operation
      },
      where: "id = ?",
      whereArgs: [shop.id],
    );
  }

// Delete a shop
  static Future<int> deleteShop(int id) async {
    final db = await _getDB();
    return await db.delete(
      'shops',
      where: "id = ?",
      whereArgs: [id],
    );
  }

// Get shops by sync_status
  static Future<List<Shop>> getShopsBySyncStatus(int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'shops',
      where: 'sync_status = ?', // Filter by sync_status
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );

    return List.generate(maps.length, (i) {
      return Shop.fromJson(maps[i]);
    });
  }

// Clear all shops
  static Future<void> clearShops() async {
    final db = await _getDB();
    await db.delete('shops');
  }

// Clear shops by sync_status
  static Future<void> clearShopsByStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'shops',
      where: 'sync_status = ?', // Delete where sync_status matches
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );
  }

  // CRUD operations for tax_types table

  // Get all tax types
  // Get all tax types
  static Future<List<TaxType>> getAllTaxTypes() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('tax_types');

    return List.generate(maps.length, (i) {
      return TaxType.fromJson(maps[i]);
    });
  }

// Insert a new tax type with sync_status
  static Future<int> addTaxType({
    required TaxType taxType,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.insert(
      'tax_types',
      {
        ...taxType.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the insert operation
      },
      conflictAlgorithm:
          ConflictAlgorithm.replace, // Replace existing records if any
    );
  }

// Update a tax type with sync_status
  static Future<int> updateTaxType({
    required TaxType taxType,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.update(
      'tax_types',
      {
        ...taxType.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the update operation
      },
      where: "id = ?",
      whereArgs: [taxType.id],
    );
  }

// Delete a tax type
  static Future<int> deleteTaxType(int id) async {
    final db = await _getDB();
    return await db.delete(
      'tax_types',
      where: "id = ?",
      whereArgs: [id],
    );
  }

// Retrieve tax types by sync_status
  static Future<List<TaxType>> getTaxTypesBySyncStatus(int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'tax_types',
      where: 'sync_status = ?', // Filter by sync_status
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );

    return List.generate(maps.length, (i) {
      return TaxType.fromJson(maps[i]);
    });
  }

// Clear all tax types
  static Future<void> clearTaxTypes() async {
    final db = await _getDB();
    await db.delete('tax_types');
  }

// Clear tax types by sync_status
  static Future<void> clearTaxTypesByStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'tax_types',
      where: 'sync_status = ?', // Delete where sync_status matches
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );
  }

  // Insert a new transaction on hold with sync_status
  static Future<int> addTransactionOnHold({
    required TransactionOnHold transactionOnHold,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.insert(
      'transaction_on_holds',
      {
        ...transactionOnHold.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the insert operation
      },
      conflictAlgorithm:
          ConflictAlgorithm.replace, // Replace existing records if any
    );
  }

// Update a transaction on hold with sync_status
  static Future<int> updateTransactionOnHold({
    required TransactionOnHold transactionOnHold,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.update(
      'transaction_on_holds',
      {
        ...transactionOnHold.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the update operation
      },
      where: "id = ?",
      whereArgs: [transactionOnHold.id],
    );
  }

// Delete a transaction on hold
  static Future<int> deleteTransactionOnHold(int id) async {
    final db = await _getDB();
    return await db.delete(
      'transaction_on_holds',
      where: "id = ?",
      whereArgs: [id],
    );
  }

// Retrieve transactions on hold by sync_status
  static Future<List<TransactionOnHold>> getTransactionsOnHoldBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'transaction_on_holds',
      where: 'sync_status = ?', // Filter by sync_status
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );

    return List.generate(maps.length, (i) {
      return TransactionOnHold.fromJson(maps[i]);
    });
  }

// Clear all transactions on hold
  static Future<void> clearTransactionsOnHold() async {
    final db = await _getDB();
    await db.delete('transaction_on_holds');
  }

// Clear transactions on hold by sync_status
  static Future<void> clearTransactionsOnHoldByStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'transaction_on_holds',
      where: 'sync_status = ?', // Delete where sync_status matches
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );
  }

  // Add a new cart item
  // Insert a new cart item with sync_status
  static Future<int> addCart({
    required Cart cart,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    // Ensure total is calculated before saving to the database
    return await db.insert(
      'cart_items',
      {
        ...cart.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the insert operation
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update an existing cart item with sync_status
  static Future<int> updateCart({
    required Cart cart,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.update(
      'cart_items',
      {
        ...cart.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the update operation
      },
      where: "id = ?",
      whereArgs: [cart.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Delete a cart item
  static Future<int> deleteCart(int id) async {
    final db = await _getDB();
    return await db.delete(
      'cart_items',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // Retrieve all cart items
  static Future<List<Cart>> getAllCart() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('cart_items');

    return List.generate(maps.length, (index) {
      return Cart.fromJson(maps[index]);
    });
  }

  // Retrieve all cart items by sync_status
  static Future<List<Cart>> getCartBySyncStatus(int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'cart_items',
      where: 'sync_status = ?', // Filter by sync_status
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );

    return List.generate(maps.length, (index) {
      return Cart.fromJson(maps[index]);
    });
  }

  // Clear all cart items
  // Clear all cart items from the database
  static Future<void> clearCart() async {
    final db = await _getDB();
    await db.delete('cart_items'); // Clear all items in the 'cart_items' table
  }

  // Print all cart items (for debugging)
  static Future<void> printAllCartItems() async {
    List<Cart> cartItems = await getAllCart();

    if (cartItems.isNotEmpty) {
      for (var item in cartItems) {
        print(
            'ID: ${item.id}, ItemName: ${item.itemName}, Quantity: ${item.quantity}, SalePrice: ${item.salePrice}, Total: ${item.total}, Discount: ${item.discountValue}');
      }
    } else {
      print('No items found in the cart.');
    }
  }

  // Clear cart items by sync_status
  static Future<void> clearCartByStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'cart_items',
      where: 'sync_status = ?', // Delete where sync_status matches
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );
  }

  // Insert a new item into the database
  static Future<bool> addItem(Item item, String userId) async {
    print('addItem called for: ${item.name}'); // Debug print
    print('Trying to add item with ID: ${item.id} and name: ${item.name}');

    final db = await _getDB();
    final itemData = item.toJson();
    itemData['user_id'] = userId; // Associate the item with the specific user

    // Check if the item already exists for this user based on name and id
    final List<Map<String, dynamic>> existingItems = await db.query(
      'items',
      where:
          'name = ? AND user_id = ?', // Check for duplicates based on name and user
      whereArgs: [item.name, userId],
    );

    if (existingItems.isNotEmpty) {
      print('Skipped duplicate item: ${item.name} with ID: ${item.id}');
      return false; // Item already exists, skip insertion
    }

    try {
      await db.insert(
        'items',
        itemData,
        conflictAlgorithm: ConflictAlgorithm.ignore, // Ignore duplicates
      );
      print('Successfully added item: ${item.name}');
      return true; // Item added successfully
    } catch (e) {
      print('Failed to add item: ${item.name}. Error: $e');
      return false; // Error adding item
    }
  }

  // Retrieve all items for a specific user
  static Future<List<Item>> getAllItems(String userId) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'items',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return Item.fromJson(maps[i]);
    });
  }

  // Retrieve items by sync status for a specific user
  static Future<List<Item>> getItemsBySyncStatus(
      String syncStatus, String userId) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'items',
      where: 'sync_status = ? AND user_id = ?',
      whereArgs: [syncStatus, userId],
    );

    return maps.map((json) => Item.fromJson(json)).toList();
  }

  // Clear all items for a specific user
  static Future<void> clearItems(String userId) async {
    final db = await _getDB();
    await db.delete(
      'items',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    print('All items cleared for user: $userId.');
  }

  // Clear items by sync status for a specific user
  static Future<void> clearItemsByStatus(
      String syncStatus, String userId) async {
    final db = await _getDB();
    await db.delete(
      'items',
      where: 'sync_status = ? AND user_id = ?',
      whereArgs: [syncStatus, userId],
    );
  }

  // Check if an item exists by name for a specific user
  static Future<bool> itemExists(String itemName, String userId) async {
    final db = await _getDB();

    final result = await db.query(
      'items',
      where: 'name = ? AND user_id = ?',
      whereArgs: [itemName, userId],
    );

    return result.isNotEmpty; // Return true if the item exists
  }

  static Future<int> updateItemStock(String itemName, int newStock) async {
    final db = await _getDB(); // Get the database instance

    // Update the min_stock field in the items table
    return await db.update(
      'items', // Table name
      {'min_stock': newStock}, // New stock value
      where: 'name = ?', // Filter by item name
      whereArgs: [itemName], // Provide item name as argument
    );
  }

  //CRUDE FOR USER
  // Insert a new user with sync_status
  static Future<int> addUser({
    required User user,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.insert(
      'users',
      {
        ...user.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the insert operation
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update an existing user with sync_status
  static Future<int> updateUser({
    required User user,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.update(
      'users',
      {
        ...user.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the update operation
      },
      where: "id = ?",
      whereArgs: [user.id],
    );
  }

  // Delete a user
  static Future<int> deleteUser(int id) async {
    final db = await _getDB();
    return await db.delete(
      'users',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // Retrieve all users
  static Future<List<User>> getAllUsers() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (i) {
      return User.fromJson(maps[i]);
    });
  }

  // Retrieve users by sync_status
  static Future<List<User>> getUsersBySyncStatus(int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'sync_status = ?', // Filter by sync_status
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );

    return List.generate(maps.length, (i) {
      return User.fromJson(maps[i]);
    });
  }

  // Clear all users
  static Future<void> clearUsers() async {
    final db = await _getDB();
    await db.delete('users');
  }

  // Clear users by sync_status
  static Future<void> clearUsersByStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'users',
      where: 'sync_status = ?', // Delete where sync_status matches
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );
  }

  // Add a new user detail
  // Insert a new user detail
  // Insert a new user detail with sync_status
  static Future<int> addUserDetail({
    required UserDetail userDetail,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.insert(
      'user_details',
      {
        ...userDetail.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the insert operation
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update an existing user detail with sync_status
  static Future<int> updateUserDetail({
    required UserDetail userDetail,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.update(
      'user_details',
      {
        ...userDetail.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the update operation
      },
      where: "id = ?",
      whereArgs: [userDetail.id],
    );
  }

  // Delete a user detail
  static Future<int> deleteUserDetail(int id) async {
    final db = await _getDB();
    return await db.delete(
      'user_details',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // Retrieve all user details
  static Future<List<UserDetail>> getAllUserDetails() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('user_details');

    return List.generate(maps.length, (index) {
      return UserDetail.fromJson(maps[index]);
    });
  }

  // Retrieve user details by sync_status
  static Future<List<UserDetail>> getUserDetailsBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'user_details',
      where: 'sync_status = ?', // Filter by sync_status
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );

    return List.generate(maps.length, (index) {
      return UserDetail.fromJson(maps[index]);
    });
  }

  // Clear all user details
  static Future<void> clearUserDetails() async {
    final db = await _getDB();
    await db.delete('user_details');
  }

  // Clear user details by sync_status
  static Future<void> clearUserDetailsByStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'user_details',
      where: 'sync_status = ?', // Delete where sync_status matches
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );
  }

  // Print all user details (for debugging)
  static Future<void> printAllUserDetails() async {
    List<UserDetail> userDetails = await getAllUserDetails();

    if (userDetails.isNotEmpty) {
      for (var detail in userDetails) {
        print(
            'ID: ${detail.id}, LastLogin: ${detail.lastLogin}, Active: ${detail.active}, FirstTime: ${detail.firstTime}, SyncStatus: ${detail.syncStatus}');
      }
    } else {
      print('No user details found.');
    }
  }

  // Add a new item category
  // Insert a new item category
  // Insert a new item category with sync_status
  static Future<int> addItemCategory({
    required ItemCategory category,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.insert(
      'item_categories',
      {
        ...category.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the insert operation
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update an existing item category with sync_status
  static Future<int> updateItemCategory({
    required ItemCategory category,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.update(
      'item_categories',
      {
        ...category.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the update operation
      },
      where: "id = ?",
      whereArgs: [category.id],
    );
  }

  // Delete an item category
  static Future<int> deleteItemCategory(int id) async {
    final db = await _getDB();
    return await db.delete(
      'item_categories',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // Retrieve all item categories
  static Future<List<ItemCategory>> getAllItemCategories() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('item_categories');

    return List.generate(maps.length, (index) {
      return ItemCategory.fromJson(maps[index]);
    });
  }

  // Retrieve item categories by sync_status
  static Future<List<ItemCategory>> getItemCategoriesBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'item_categories',
      where: 'sync_status = ?', // Filter by sync_status
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );

    return List.generate(maps.length, (index) {
      return ItemCategory.fromJson(maps[index]);
    });
  }

  // Clear all item categories
  static Future<void> clearItemCategories() async {
    final db = await _getDB();
    await db.delete('item_categories');
  }

  // Clear item categories by sync_status
  static Future<void> clearItemCategoriesByStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'item_categories',
      where: 'sync_status = ?', // Delete where sync_status matches
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );
  }

  // Print all item categories (for debugging)
  static Future<void> printAllItemCategories() async {
    List<ItemCategory> categories = await getAllItemCategories();

    if (categories.isNotEmpty) {
      for (var category in categories) {
        print(
            'ID: ${category.id}, Name: ${category.name}, SyncStatus: ${category.syncStatus}');
      }
    } else {
      print('No item categories found in the database.');
    }
  }

  // Insert a new warranty with sync_status
  static Future<int> addWarranty({
    required Warranty warranty,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.insert(
      'warranties',
      {
        ...warranty.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the insert operation
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update an existing warranty with sync_status
  static Future<int> updateWarranty({
    required Warranty warranty,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.update(
      'warranties',
      {
        ...warranty.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the update operation
      },
      where: "id = ?",
      whereArgs: [warranty.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Delete a warranty
  static Future<int> deleteWarranty(int id) async {
    final db = await _getDB();
    return await db.delete(
      'warranties',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // Retrieve all warranties
  static Future<List<Warranty>> getAllWarranties() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('warranties');

    return List.generate(maps.length, (index) {
      return Warranty.fromJson(maps[index]);
    });
  }

  // Retrieve warranties by sync_status
  static Future<List<Warranty>> getWarrantiesBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'warranties',
      where: 'sync_status = ?', // Filter by sync_status
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );

    return List.generate(maps.length, (index) {
      return Warranty.fromJson(maps[index]);
    });
  }

  // Clear all warranties
  static Future<void> clearWarranties() async {
    final db = await _getDB();
    await db.delete('warranties');
  }

  // Clear warranties by sync_status
  static Future<void> clearWarrantiesByStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'warranties',
      where: 'sync_status = ?', // Delete where sync_status matches
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );
  }

  // Print all warranties (for debugging)
  static Future<void> printAllWarranties() async {
    List<Warranty> warranties = await getAllWarranties();

    if (warranties.isNotEmpty) {
      for (var warranty in warranties) {
        print(
            'ID: ${warranty.id}, Name: ${warranty.name}, Duration: ${warranty.duration}, Status: ${warranty.status}, SyncStatus: ${warranty.syncStatus}');
      }
    } else {
      print('No warranties found.');
    }
  }

  // Insert a new unit with sync_status
  static Future<int> addUnit({
    required Unit unit,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();

    // Check if the unit already exists
    final existingUnits = await db.query(
      'units',
      where: 'id = ?',
      whereArgs: [unit.id],
    );

    if (existingUnits.isNotEmpty) {
      // If it exists, you can choose to return a specific value or handle it accordingly
      return 0; // Or throw an exception or log a message
    } else {
      return await db.insert(
        'units',
        {
          ...unit.toJson(),
          'sync_status':
              syncStatus, // Include sync_status in the insert operation
        },
        conflictAlgorithm:
            ConflictAlgorithm.abort, // If you still want to catch errors
      );
    }
  }

  // Update an existing unit with sync_status
  static Future<int> updateUnit({
    required Unit unit,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.update(
      'units',
      {
        ...unit.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the update operation
      },
      where: "id = ?",
      whereArgs: [unit.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Delete a unit
  static Future<int> deleteUnit(int id) async {
    final db = await _getDB();
    return await db.delete(
      'units',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // Retrieve all units
  static Future<List<Unit>> getAllUnits() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('units');

    return List.generate(maps.length, (index) {
      return Unit.fromJson(maps[index]);
    });
  }

  // Retrieve units by sync_status
  static Future<List<Unit>> getUnitsBySyncStatus(int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'units',
      where: 'sync_status = ?', // Filter by sync_status
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );

    return List.generate(maps.length, (index) {
      return Unit.fromJson(maps[index]);
    });
  }

  // Clear all units
  static Future<void> clearUnits() async {
    final db = await _getDB();
    await db.delete('units');
  }

  // Clear units by sync_status
  static Future<void> clearUnitsByStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'units',
      where: 'sync_status = ?', // Delete where sync_status matches
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );
  }

  // Print all units (for debugging)
  static Future<void> printAllUnits() async {
    List<Unit> units = await getAllUnits();

    if (units.isNotEmpty) {
      for (var unit in units) {
        print(
            'ID: ${unit.id}, Name: ${unit.name}, SyncStatus: ${unit.syncStatus}');
      }
    } else {
      print('No units found.');
    }
  }
  // CRUD operations for transactions table

  // Insert a new transaction
  // Insert a new transaction with sync_status
  static Future<int> addTransaction({
    required Transactions transaction,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.insert(
      'transactions',
      {
        ...transaction.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the insert operation
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Update an existing transaction with sync_status
  static Future<int> updateTransaction({
    required Transactions transaction,
    int syncStatus = 0, // Default value for syncStatus
  }) async {
    final db = await _getDB();
    return await db.update(
      'transactions',
      {
        ...transaction.toJson(),
        'sync_status':
            syncStatus, // Include sync_status in the update operation
      },
      where: "id = ?",
      whereArgs: [transaction.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Delete a transaction
  static Future<int> deleteTransaction(int id) async {
    final db = await _getDB();
    return await db.delete(
      'transactions',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // Retrieve all transactions
  static Future<List<Transactions>> getAllTransactions() async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query('transactions');

    return List.generate(maps.length, (index) {
      return Transactions.fromJson(maps[index]);
    });
  }

  // Retrieve transactions by sync_status
  static Future<List<Transactions>> getTransactionsBySyncStatus(
      int syncStatus) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'sync_status = ?', // Filter by sync_status
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );

    return List.generate(maps.length, (index) {
      return Transactions.fromJson(maps[index]);
    });
  }

  // Clear all transactions
  static Future<void> clearTransactions() async {
    final db = await _getDB();
    await db.delete('transactions');
  }

  // Clear transactions by sync_status
  static Future<void> clearTransactionsByStatus(int syncStatus) async {
    final db = await _getDB();
    await db.delete(
      'transactions',
      where: 'sync_status = ?', // Delete where sync_status matches
      whereArgs: [syncStatus], // Use syncStatus for filtering
    );
  }

  // Print all transactions (for debugging)
  static Future<void> printAllTransactions() async {
    List<Transactions> transactions = await getAllTransactions();

    if (transactions.isNotEmpty) {
      for (var transaction in transactions) {
        print(
            'ID: ${transaction.id}, Amount: ${transaction.amount}, Date: ${transaction.date}, SyncStatus: ${transaction.syncStatus}');
      }
    } else {
      print('No transactions found.');
    }
  }
}
