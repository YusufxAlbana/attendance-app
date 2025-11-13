import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:attendance_app/utils/notification_overlay.dart'; 

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  final CollectionReference dataCollection = FirebaseFirestore.instance
      .collection('attendance');

  // Map untuk menyimpan status "expanded" (terbuka penuh) per item
  final Map<String, bool> _isExpanded = {};
  
  // Fungsi untuk memotong teks
  String _truncateText(String text, {int maxLength = 30}) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }

  // function Edit Data
  void _editData(
    String docId,
    String currentName,
    String currentAddress,
    String currentDescription,
    String currentDatetime,
  ) {
    TextEditingController nameController = TextEditingController(
      text: currentName,
    );
    TextEditingController addressController = TextEditingController(
      text: currentAddress,
    );
    TextEditingController descriptionController = TextEditingController(
      text: currentDescription,
    );
    TextEditingController datetimeController = TextEditingController(
      text: currentDatetime,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Edit Data"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: "Address"),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: "Description / Permission Reason"),
                  maxLines: 3, 
                ),
                TextField(
                  controller: datetimeController,
                  decoration: const InputDecoration(labelText: "Datetime"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await dataCollection.doc(docId).update({
                    'name': nameController.text,
                    'address': addressController.text,
                    'description': descriptionController.text,
                    'datetime': datetimeController.text,
                  }).then((_) {
                    Navigator.pop(context);
                    // Panggil notifikasi Sukses setelah Edit
                    showSuccessNotification(context, 'Data berhasil diubah! ✨');
                    setState(() {}); 
                  }).catchError((e) {
                    Navigator.pop(context);
                    // Panggil notifikasi Gagal jika ada Error
                    showErrorNotification(context, 'Gagal mengubah data. Coba lagi.');
                  });
                },
                child: const Text(
                  "Save",
                  style: TextStyle(color: Color(0xFF2563EB)),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
    );
  }

  // Function Delete Data
  void _deleteData(String docId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Delete Data"),
            content: const Text("Are you sure want to delete this data?"),
            actions: [
              TextButton(
                onPressed: () async {
                  await dataCollection.doc(docId).delete().then((_) {
                    Navigator.pop(context);
                    // Panggil notifikasi Sukses setelah Delete
                    showSuccessNotification(context, 'Data berhasil dihapus! 🗑️'); 
                    setState(() {});
                  }).catchError((e) {
                    Navigator.pop(context);
                    // Panggil notifikasi Gagal jika ada Error
                    showErrorNotification(context, 'Gagal menghapus data. Coba lagi.');
                  });
                },
                child: const Text("Yes", style: TextStyle(color: Colors.red)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("No", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // shared theme colors (professional palette)
    const Color primary1 = Color(0xFF2563EB);
    const Color primary2 = Color(0xFF0EA5E9);
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    
    // Tentukan panjang maksimal pemotongan berdasarkan lebar layar
    final int maxLength = isMobile ? 30 : 60;


    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Gradient header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [primary1, primary2], begin: Alignment.topLeft, end: Alignment.bottomRight),
                boxShadow: [BoxShadow(color: primary1.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: Text(
                      'Attendance History',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: StreamBuilder<QuerySnapshot>(
                  stream: dataCollection.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                            const SizedBox(height: 10),
                            Text('Terjadi kesalahan: ${snapshot.error}'),
                          ],
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final docs = snapshot.data?.docs ?? [];
                    if (docs.isEmpty) {
                      return const Center(
                        child: Text('Ups, there is no data!', style: TextStyle(fontSize: 18)),
                      );
                    }

                    return ListView.separated(
                      itemCount: docs.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        final docId = doc.id;
                        final data = doc.data() as Map<String, dynamic>;
                        final name = (data['name'] ?? '-') as String;
                        final address = (data['address'] ?? '-') as String;
                        final storedCategory = (data['category'] ?? '') as String;
                        final storedDescription = (data['description'] ?? '-') as String;
                        final datetime = (data['datetime'] ?? '-') as String;

                        // Pastikan status expanded diinisialisasi
                        // FIX: Menggunakan Map.putIfAbsent untuk inisialisasi yang aman
                        _isExpanded.putIfAbsent(docId, () => false);


                        // Pengecekan dan pemisahan Kategori dan Deskripsi (mendukung data baru & lama)
                        String category = storedCategory.trim();
                        String detail = '';
                        bool isPermission = category.isNotEmpty || storedDescription.contains(' | Details: ');

                        if (category.isNotEmpty) {
                          detail = storedDescription.trim();
                        } else if (storedDescription.contains(' | Details: ')) {
                          final parts = storedDescription.split(' | Details: ');
                          category = parts[0].trim();
                          detail = parts.length > 1 ? parts[1].trim() : '';
                        }
                        if (detail.isEmpty || detail == '-' || detail == 'No detailed description provided.') {
                          detail = 'Tidak ada detail.';
                        }
                        
                        // Tentukan teks deskripsi yang akan ditampilkan (terpotong atau penuh)
                        final displayDetailText = _isExpanded[docId] == true ? detail : _truncateText(detail, maxLength: maxLength);

                        // random pastel color for avatar
                        final Color avatarColor = Colors.primaries[Random().nextInt(Colors.primaries.length)].shade400;

                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Kolom Kiri: Avatar
                                CircleAvatar(
                                  radius: 26,
                                  backgroundColor: avatarColor,
                                  child: Text(
                                    name.isNotEmpty ? name[0].toUpperCase() : '-',
                                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Kolom Tengah: Info Utama (Nama, Kategori, Deskripsi, Lokasi, Waktu)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 6),

                                      // --- Menampilkan Kategori Izin (jika ada) ---
                                      if (isPermission) 
                                        RichText(
                                          text: TextSpan(
                                            style: DefaultTextStyle.of(context).style,
                                            children: <TextSpan>[
                                              const TextSpan(
                                                text: 'Kategori: ',
                                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14),
                                              ),
                                              TextSpan(
                                                text: category,
                                                style: const TextStyle(color: Colors.black87, fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      
                                      // --- Menampilkan Deskripsi Detail (jika ada) ---
                                      if (isPermission) ...[
                                        const SizedBox(height: 4),
                                        RichText(
                                          text: TextSpan(
                                            style: DefaultTextStyle.of(context).style,
                                            children: <TextSpan>[
                                              const TextSpan(
                                                text: 'Deskripsi: ',
                                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14),
                                              ),
                                              TextSpan(
                                                text: displayDetailText,
                                                style: const TextStyle(color: Colors.black87, fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          maxLines: _isExpanded[docId] == true ? 100 : 1, // Batasi 1 baris jika tidak expand
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ] else 
                                      // Jika bukan izin (mungkin status Attend/Late), tampilkan seperti biasa
                                      Text(storedDescription, style: const TextStyle(fontSize: 14, color: Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis),
                                      
                                      const SizedBox(height: 6),
                                      // Lokasi
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                                          const SizedBox(width: 6),
                                          Expanded(child: Text(address, style: const TextStyle(fontSize: 13, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      // Waktu
                                      Text(datetime, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                                    ],
                                  ),
                                ),

                                // Kolom Kanan: Tombol Aksi (Mata, Edit, Delete)
                                SizedBox(
                                  width: 40, 
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // Tombol View (Mata) - Hanya muncul jika ada deskripsi detail panjang
                                      if (isPermission && detail.length > maxLength)
                                        IconButton(
                                          icon: Icon(
                                            _isExpanded[docId] == true ? Icons.visibility_off : Icons.visibility, 
                                            color: primary1,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isExpanded[docId] = !(_isExpanded[docId] ?? false);
                                            });
                                          },
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                                        ),
                                      
                                      // Spacer di antara tombol jika tombol Mata muncul
                                      if (isPermission && detail.length > maxLength)
                                        const SizedBox(height: 4),

                                      // Tombol Edit
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Color(0xFF2563EB), size: 20),
                                        onPressed: () => _editData(docId, name, address, storedDescription, datetime),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                                      ),
                                      
                                      // Tombol Delete
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                                        onPressed: () => _deleteData(docId),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}