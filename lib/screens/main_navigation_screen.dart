import 'package:flutter/material.dart';

import 'order_form_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int currentIndex = 0;

  final List<String> titles = [
    'Katalog',
    'Riwayat Transaksi',
    'Informasi Toko',
  ];

  // ==========================================================
  // DATA RIWAYAT TRANSAKSI
  // ==========================================================

  final List<Map<String, dynamic>> transactions = [
    {
      'id': 'TRX-001',
      'customer': 'Andi',
      'product': 'Laptop Pro 14',
      'total': 10625000,
      'status': 'Sukses',
    },
    {
      'id': 'TRX-002',
      'customer': 'Budi',
      'product': 'Mouse Wireless',
      'total': 261250,
      'status': 'Sukses',
    },
    {
      'id': 'TRX-003',
      'customer': 'Citra',
      'product': 'Monitor 24 Inch',
      'total': 1680000,
      'status': 'Sukses',
    },
    {
      'id': 'TRX-004',
      'customer': 'Dimas',
      'product': 'Printer Laser',
      'total': 2816000,
      'status': 'Sukses',
    },
  ];

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  // ==========================================================
  // FORMAT RUPIAH
  // ==========================================================

  String formatRupiah(int value) {
    final text = value.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i > 0 && (text.length - i) % 3 == 0) {
        buffer.write('.');
      }

      buffer.write(text[i]);
    }

    return 'Rp ${buffer.toString()}';
  }

  // ==========================================================
  // PROSES HASIL TRANSAKSI
  // ==========================================================

  Future<void> openOrderForm(
    BuildContext context,
    Map<String, dynamic> product,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderFormScreen(product: product),
      ),
    );

    if (!mounted) return;

    if (result != null && result is Map && result['success'] == true) {
      final newTransaction = {
        'id': 'TRX-${(transactions.length + 1).toString().padLeft(3, '0')}',
        'customer': 'Pelanggan',
        'product': result['product'],
        'total': result['total'],
        'status': 'Sukses',
      };

      setState(() {
        transactions.insert(0, newTransaction);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Transaksi ${result['product']} berhasil diproses.'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'RIWAYAT',
            onPressed: () {
              setState(() {
                currentIndex = 1;
              });
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[currentIndex],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      // ========================================================
      // DRAWER
      // ========================================================
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: const SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 34,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 40),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Admin Kasir',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'SmartRetail POS',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.inventory_2_outlined),
                title: const Text('Katalog'),
                selected: currentIndex == 0,
                onTap: () {
                  changePage(0);
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.receipt_long_outlined),
                title: const Text('Riwayat Transaksi'),
                selected: currentIndex == 1,
                onTap: () {
                  changePage(1);
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.store_outlined),
                title: const Text('Informasi Toko'),
                selected: currentIndex == 2,
                onTap: () {
                  changePage(2);
                  Navigator.pop(context);
                },
              ),

              const Spacer(),

              const Divider(),

              const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Versi Aplikasi'),
                subtitle: Text('SmartRetail POS v1.0.0'),
              ),
            ],
          ),
        ),
      ),

      // ========================================================
      // CONTENT
      // ========================================================
      body: IndexedStack(
        index: currentIndex,
        children: [
          CatalogPage(onOrderPressed: openOrderForm),
          HistoryPage(transactions: transactions, formatRupiah: formatRupiah),
          const StoreInfoPage(),
        ],
      ),

      // ========================================================
      // BOTTOM NAVIGATION BAR
      // ========================================================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: changePage,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Katalog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store_outlined),
            activeIcon: Icon(Icons.store),
            label: 'Toko',
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// CATALOG PAGE
// ==================================================================

class CatalogPage extends StatelessWidget {
  final Future<void> Function(BuildContext, Map<String, dynamic>)
  onOrderPressed;

  const CatalogPage({super.key, required this.onOrderPressed});

  static final List<Map<String, dynamic>> products = [
    {
      'name': 'Laptop Pro 14',
      'category': 'Elektronik',
      'price': 12500000,
      'stock': 8,
      'discount': 15,
      'icon': Icons.laptop_mac,
    },
    {
      'name': 'Wireless Keyboard',
      'category': 'Aksesoris',
      'price': 450000,
      'stock': 15,
      'discount': 10,
      'icon': Icons.keyboard,
    },
    {
      'name': 'Mouse Wireless',
      'category': 'Aksesoris',
      'price': 275000,
      'stock': 24,
      'discount': 5,
      'icon': Icons.mouse,
    },
    {
      'name': 'Monitor 24 Inch',
      'category': 'Elektronik',
      'price': 2100000,
      'stock': 6,
      'discount': 20,
      'icon': Icons.monitor,
    },
    {
      'name': 'Printer Laser',
      'category': 'Perlengkapan Kantor',
      'price': 3200000,
      'stock': 4,
      'discount': 12,
      'icon': Icons.print,
    },
    {
      'name': 'Flashdisk 64GB',
      'category': 'Penyimpanan',
      'price': 95000,
      'stock': 30,
      'discount': 0,
      'icon': Icons.usb,
    },
  ];

  String formatRupiah(int value) {
    final text = value.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      if (i > 0 && (text.length - i) % 3 == 0) {
        buffer.write('.');
      }

      buffer.write(text[i]);
    }

    return 'Rp ${buffer.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.shopping_bag_outlined), text: 'Produk'),
              Tab(
                icon: Icon(Icons.local_offer_outlined),
                text: 'Ketentuan Promo',
              ),
            ],
          ),

          Expanded(
            child: TabBarView(
              children: [
                // ==================================================
                // TAB PRODUK
                // ==================================================

                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 14),
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    product['icon'],
                                    size: 48,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                  ),
                                ),

                                if (product['discount'] > 0)
                                  Positioned(
                                    top: -6,
                                    right: -6,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 7,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '-${product['discount']}%',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),

                                Positioned(
                                  bottom: -6,
                                  left: 5,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: product['stock'] <= 5
                                          ? Colors.orange
                                          : Colors.green,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'Stok ${product['stock']}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(width: 18),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'],
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    product['category'],
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 13,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    formatRupiah(product['price']),
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  SizedBox(
                                    height: 38,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        onOrderPressed(context, product);
                                      },
                                      icon: const Icon(
                                        Icons.shopping_cart_outlined,
                                        size: 18,
                                      ),
                                      label: const Text('Pesan'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const PromoPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// PROMO PAGE
// ==================================================================

class PromoPage extends StatefulWidget {
  const PromoPage({super.key});

  @override
  State<PromoPage> createState() => _PromoPageState();
}

class _PromoPageState extends State<PromoPage> {
  final List<bool> expanded = [false, false, false];

  final List<Map<String, String>> promos = [
    {
      'title': 'Voucher MEMBER10',
      'content': 'Member mendapatkan diskon hingga 10% dengan minimal transaksi Rp500.000.',
    },
    {
      'title': 'Voucher ELEKTRONIK15',
      'content':
          'Diskon 15% untuk kategori elektronik tertentu selama periode promo.',
    },
    {
      'title': 'Gratis Packing',
      'content': 'Gratis biaya packing untuk pembelian dengan nilai transaksi minimal Rp1.000.000.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: ExpansionPanelList(
        expansionCallback: (index, isExpanded) {
          setState(() {
            expanded[index] = isExpanded;
          });
        },
        children: List.generate(promos.length, (index) {
          return ExpansionPanel(
            isExpanded: expanded[index],
            headerBuilder: (context, isExpanded) {
              return ListTile(
                leading: const Icon(Icons.confirmation_number_outlined),
                title: Text(
                  promos[index]['title']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
            body: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(promos[index]['content']!),
            ),
          );
        }),
      ),
    );
  }
}

// ==================================================================
// HISTORY PAGE
// ==================================================================

class HistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  final String Function(int) formatRupiah;

  const HistoryPage({
    super.key,
    required this.transactions,
    required this.formatRupiah,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Center(child: Text('Belum ada transaksi.'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(
          Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        ),
        columns: const [
          DataColumn(
            label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text(
              'Pelanggan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Produk',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text(
              'Status',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows: transactions.map((transaction) {
          return DataRow(
            cells: [
              DataCell(Text(transaction['id'])),
              DataCell(Text(transaction['customer'])),
              DataCell(Text(transaction['product'])),
              DataCell(Text(formatRupiah(transaction['total']))),
              DataCell(
                Chip(
                  label: Text(
                    transaction['status'],
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ==================================================================
// STORE INFORMATION
// ==================================================================

class StoreInfoPage extends StatelessWidget {
  const StoreInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.storefront,
                size: 55,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Center(
            child: Text(
              'SmartRetail Office Store',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 8),

          Center(
            child: Text(
              'Perlengkapan Kantor & Elektronik',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),

          const SizedBox(height: 30),

          const InfoCard(
            icon: Icons.location_on_outlined,
            title: 'Alamat',
            value: 'Jl. Contoh No. 123, Subang, Jawa Barat',
          ),

          const InfoCard(
            icon: Icons.phone_outlined,
            title: 'Telepon',
            value: '0260-123456',
          ),

          const InfoCard(
            icon: Icons.access_time_outlined,
            title: 'Jam Operasional',
            value: 'Senin - Sabtu, 08.00 - 17.00',
          ),

          const SizedBox(height: 20),

          const Text(
            'Kode Lisensi Resmi',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const SelectableText(
              'SRT-POS-2026-001-ABCD',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'Tekan dan tahan kode untuk menyalinnya.',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// INFO CARD
// ==================================================================

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(value),
        ),
      ),
    );
  }
}
