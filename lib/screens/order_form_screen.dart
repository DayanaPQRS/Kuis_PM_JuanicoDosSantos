import 'package:flutter/material.dart';

class OrderFormScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const OrderFormScreen({super.key, required this.product});

  @override
  State<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  String selectedCourier = 'Reguler';

  final Map<String, bool> extraServices = {
    'Asuransi Pengiriman': false,
    'Bubble Wrap Ekstra': false,
    'Packing Kayu': false,
  };

  DateTime? pickupDate;
  TimeOfDay? pickupTime;

  double memberDiscount = 0;

  bool isDropship = false;
  bool giftWrapping = false;

  String formatRupiah(double value) {
    final number = value.round().toString();
    final buffer = StringBuffer();

    for (int i = 0; i < number.length; i++) {
      if (i > 0 && (number.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(number[i]);
    }

    return 'Rp ${buffer.toString()}';
  }

  int get basePrice {
    return widget.product['price'] as int;
  }

  int get productDiscount {
    final discount = widget.product['discount'] as int;

    return (basePrice * discount / 100).round();
  }

  int get priceAfterProductDiscount {
    return basePrice - productDiscount;
  }

  int get extraCost {
    int total = 0;

    if (extraServices['Asuransi Pengiriman'] == true) {
      total += 25000;
    }

    if (extraServices['Bubble Wrap Ekstra'] == true) {
      total += 15000;
    }

    if (extraServices['Packing Kayu'] == true) {
      total += 50000;
    }

    if (giftWrapping) {
      total += 20000;
    }

    return total;
  }

  int get courierCost {
    switch (selectedCourier) {
      case 'Kargo':
        return 40000;
      case 'Instan':
        return 30000;
      case 'Reguler':
      default:
        return 15000;
    }
  }

  int get memberDiscountAmount {
    return (priceAfterProductDiscount * memberDiscount / 100).round();
  }

  int get totalPrice {
    return priceAfterProductDiscount +
        courierCost +
        extraCost -
        memberDiscountAmount;
  }

  Future<void> selectDate() async {
    final now = DateTime.now();

    final selected = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );

    if (selected != null) {
      setState(() {
        pickupDate = selected;
      });
    }
  }

  Future<void> selectTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selected != null) {
      setState(() {
        pickupTime = selected;
      });
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) {
      return 'Pilih tanggal';
    }

    return '${date.day}/${date.month}/${date.year}';
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) {
      return 'Pilih jam';
    }

    return time.format(context);
  }

  void processTransaction() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ringkasan Transaksi',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                SummaryRow(label: 'Produk', value: widget.product['name']),

                SummaryRow(
                  label: 'Harga Produk',
                  value: formatRupiah(basePrice.toDouble()),
                ),

                SummaryRow(
                  label: 'Diskon Produk',
                  value: '- ${formatRupiah(productDiscount.toDouble())}',
                ),

                SummaryRow(label: 'Kurir', value: selectedCourier),

                SummaryRow(
                  label: 'Biaya Kurir',
                  value: formatRupiah(courierCost.toDouble()),
                ),

                SummaryRow(
                  label: 'Layanan Tambahan',
                  value: formatRupiah(extraCost.toDouble()),
                ),

                SummaryRow(
                  label: 'Diskon Member',
                  value: '- ${formatRupiah(memberDiscountAmount.toDouble())}',
                ),

                const Divider(),

                SummaryRow(
                  label: 'TOTAL',
                  value: formatRupiah(totalPrice.toDouble()),
                  isTotal: true,
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: confirmTransaction,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Konfirmasi Transaksi'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void confirmTransaction() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Transaksi'),
          content: Text(
            'Apakah transaksi ${widget.product['name']} '
            'dengan total ${formatRupiah(totalPrice.toDouble())} '
            'akan diproses?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final transactionResult = {
                  'success': true,
                  'product': widget.product['name'],
                  'total': totalPrice,
                };

                // Tutup AlertDialog
                Navigator.pop(dialogContext);

                // Tutup BottomSheet
                Navigator.pop(context);

                // Kembali ke CatalogPage
                Navigator.pop(context, transactionResult);
              },
              child: const Text('Ya, Proses'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Formulir Pemesanan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================
            // PRODUCT
            // ==========================

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.product['icon'],
                        size: 40,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.product['category'],
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            formatRupiah(basePrice.toDouble()),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ==========================
            // COURIER
            // ==========================
            const SectionTitle(title: 'Metode Pengiriman'),

            Card(
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Reguler'),
                    subtitle: const Text('Estimasi 2–4 hari'),
                    value: 'Reguler',
                    groupValue: selectedCourier,
                    onChanged: (value) {
                      setState(() {
                        selectedCourier = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Kargo'),
                    subtitle: const Text('Untuk barang besar'),
                    value: 'Kargo',
                    groupValue: selectedCourier,
                    onChanged: (value) {
                      setState(() {
                        selectedCourier = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Instan'),
                    subtitle: const Text('Pengiriman hari yang sama'),
                    value: 'Instan',
                    groupValue: selectedCourier,
                    onChanged: (value) {
                      setState(() {
                        selectedCourier = value!;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ==========================
            // EXTRA SERVICES
            // ==========================
            const SectionTitle(title: 'Layanan Ekstra'),

            Card(
              child: Column(
                children: extraServices.keys.map((service) {
                  return CheckboxListTile(
                    title: Text(service),
                    value: extraServices[service],
                    onChanged: (value) {
                      setState(() {
                        extraServices[service] = value ?? false;
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // ==========================
            // PICKUP SCHEDULE
            // ==========================
            const SectionTitle(title: 'Jadwal Pengambilan'),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: selectDate,
                    icon: const Icon(Icons.calendar_today_outlined),
                    label: Text(formatDate(pickupDate)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: selectTime,
                    icon: const Icon(Icons.access_time_outlined),
                    label: Text(formatTime(pickupTime)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ==========================
            // MEMBER DISCOUNT SLIDER
            // ==========================
            const SectionTitle(title: 'Diskon Member'),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Persentase Diskon'),
                        Text(
                          '${memberDiscount.round()}%',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    Slider(
                      value: memberDiscount,
                      min: 0,
                      max: 20,
                      divisions: 20,
                      label: '${memberDiscount.round()}%',
                      onChanged: (value) {
                        setState(() {
                          memberDiscount = value;
                        });
                      },
                    ),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('0%'), Text('20%')],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==========================
            // SWITCHES
            // ==========================
            const SectionTitle(title: 'Penyesuaian Tambahan'),

            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Dropship'),
                    subtitle: const Text('Kirim atas nama pihak lain'),
                    value: isDropship,
                    onChanged: (value) {
                      setState(() {
                        isDropship = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Bungkus Kado'),
                    subtitle: const Text('Tambahkan kemasan khusus'),
                    value: giftWrapping,
                    onChanged: (value) {
                      setState(() {
                        giftWrapping = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ==========================
            // PROCESS BUTTON
            // ==========================
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: processTransaction,
                icon: const Icon(Icons.point_of_sale),
                label: const Text(
                  'Proses Transaksi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// SUMMARY ROW
// ============================================================

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          const SizedBox(width: 20),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                fontSize: isTotal ? 18 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SECTION TITLE
// ============================================================

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
    );
  }
}
