import 'package:big_red/services/services.dart';
import 'package:big_red/models/servicesModel.dart';
import 'package:big_red/pages/services_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:validators/sanitizers.dart';

import 'car_details.dart';

class ServiceDetails extends StatefulWidget {
  final ServicesModel service;
  const ServiceDetails({super.key, required this.service});

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  ServicesModel edited = ServicesModel(
      id: '0', title: 'title', description: 'description', status: 'status');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          widget.service.title,
          style: GoogleFonts.robotoSlab(
              textStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          )),
        )),
        backgroundColor: Colors.red,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            edited.id == '0'
                ? Navigator.of(context).pop(false)
                : Navigator.of(context).pop(true);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InfoRow(title: 'Id', desc: widget.service.id),
            InfoRow(
                title: 'Title',
                desc: edited.id != '0' ? edited.title : widget.service.title),
            InfoRow(
                title: 'Description',
                desc: edited.id != '0'
                    ? edited.description
                    : widget.service.description),
            InfoRow(
                title: 'Status',
                desc: edited.id != '0' ? edited.status : widget.service.status),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ClipOval(
                    child: Container(
                      height: 50,
                      width: 50,
                      color: Colors.red,
                      child: IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () async {
                          final temp = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ServicesFrom(service: widget.service),
                            ),
                          );
                          setState(() {
                            edited = temp;
                          });
                        },
                      ),
                    ),
                  ),
                  ClipOval(
                    child: Container(
                      height: 50,
                      width: 50,
                      color: Colors.red,
                      child: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Service'),
                              content: const Text(
                                  'Are you sure you want to delete this service?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    var params = {
                                      'id': int.parse(widget.service.id),
                                    };
                                    int check = await Service.deleteData(
                                        params, context);
                                    if (mounted) Navigator.pop(context);
                                    if (check == 200 && mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Service Deleted Successfully'),
                                        ),
                                      );
                                      Navigator.of(context).pop(true);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Service Not Deleted'),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
