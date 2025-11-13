import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  final CollectionReference dataCollection = FirebaseFirestore.instance
      .collection('attendance');

  // function Edit Data - Diperbarui untuk menangani deskripsi sebagai teks bebas
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
    // Menggunakan TextField untuk Deskripsi/Izin
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
                  decoration: const InputDecoration(labelText: "Description / Permission Reason"), // Label diperbarui
                  maxLines: 3, // Multi-line input
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
                    'description': descriptionController.text, // Menggunakan teks bebas dari TextField
                    'datetime': datetimeController.text,
                  });
                  Navigator.pop(context);
                  setState(() {}); // Update screen after edit
                },
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.blueAccent),
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
                  await dataCollection.doc(docId).delete();
                  Navigator.pop(context);
                  setState(() {}); // Perbarui tampilan setelah delete
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
    // shared theme colors
    const Color primary1 = Color(0xFF667EEA);
    const Color primary2 = Color(0xFF764BA2);

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
                        final name = (doc['name'] ?? '-') as String;
                        final address = (doc['address'] ?? '-') as String;
                        final fullDescription = (doc['description'] ?? '-') as String;
                        final datetime = (doc['datetime'] ?? '-') as String;

                        // Pengecekan dan pemisahan Kategori dan Deskripsi
                        String category = fullDescription;
                        String detail = 'No details.';

                        // Format yang diharapkan dari absent_screen adalah "Kategori | Details: Deskripsi"
                        if (fullDescription.contains(' | Details: ')) {
                          final parts = fullDescription.split(' | Details: ');
                          category = parts[0].trim();
                          // Pastikan ada bagian detail, jika tidak, gunakan string kosong.
                          detail = parts.length > 1 ? parts[1].trim() : 'No details.'; 
                        } else if (fullDescription == 'Attend' || fullDescription == 'Late' || fullDescription == 'Leave') {
                           // Biarkan sebagai status biasa jika bukan izin
                        }
                        
                        // random pastel color for avatar
                        final Color avatarColor = Colors.primaries[Random().nextInt(Colors.primaries.length)].shade400;

                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundColor: avatarColor,
                                  child: Text(
                                    name.isNotEmpty ? name[0].toUpperCase() : '-',
                                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 6),

                                      // --- Menampilkan Kategori Izin (jika ada) ---
                                      if (fullDescription.contains(' | Details: ')) 
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
                                      if (fullDescription.contains(' | Details: ')) ...[
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
                                                text: detail,
                                                style: const TextStyle(color: Colors.black87, fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ] else 
                                      // Jika bukan izin (mungkin status Attend/Late), tampilkan seperti biasa
                                      Text(fullDescription, style: const TextStyle(fontSize: 14, color: Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis),
                                      
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                                          const SizedBox(width: 6),
                                          Expanded(child: Text(address, style: const TextStyle(fontSize: 13, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(datetime, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Color(0xFF667EEA)),
                                      onPressed: () => _editData(docId, name, address, fullDescription, datetime),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                                      onPressed: () => _deleteData(docId),
                                    ),
                                  ],
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