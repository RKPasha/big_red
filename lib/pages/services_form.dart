import 'package:big_red/services/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/servicesModel.dart';

class ServicesFrom extends StatefulWidget {
  final ServicesModel? service;
  const ServicesFrom({super.key, required this.service});

  @override
  State<ServicesFrom> createState() => _ServicesFromState();
}

class _ServicesFromState extends State<ServicesFrom> {
  bool isEdit = false;
  String title = '';
  String desc = '';
  String status = 'ACTIVE';

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.service?.title != null) {
      isEdit = true;
      titleController.text = widget.service!.title;
      descriptionController.text = widget.service!.description;
      status = widget.service!.status.toUpperCase();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Center(
              child: Text(isEdit ? 'Edit Service' : 'Add Service',
                  style: GoogleFonts.robotoSlab(
                      textStyle: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ))),
            ),
            backgroundColor: Colors.red,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                isEdit
                    ? Navigator.of(context).pop(widget.service)
                    : Navigator.of(context).pop(false);
              },
            )),
        body: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(height: 20),
            Container(
              height: 70,
              margin: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.title),
                  labelText: 'Title',
                  hintText: "Enter Service Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10.0),
              child: TextFormField(
                maxLines: 7,
                controller: descriptionController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.description),
                  labelText: 'Description',
                  hintText: "Enter Service Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Service Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
                height: 70,
                margin: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: [
                        Radio<String>(
                          value: "ACTIVE",
                          groupValue: status,
                          activeColor: Colors.red,
                          onChanged: (value) {
                            setState(() {
                              status = value.toString();
                            });
                          },
                        ),
                        const Text("ACTIVE"),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<String>(
                          value: "INACTIVE",
                          groupValue: status,
                          activeColor: Colors.red,
                          onChanged: (value) {
                            setState(() {
                              status = value.toString();
                            });
                          },
                        ),
                        const Text("INACTIVE"),
                      ],
                    ),
                  ],
                )),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ClipOval(
                  child: Container(
                    height: 50,
                    width: 50,
                    color: Colors.red,
                    child: IconButton(
                      icon: const Icon(
                        Icons.save_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () async {
                        if (titleController.text == '') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter title'),
                            ),
                          );
                        } else if (descriptionController.text == '') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter description'),
                            ),
                          );
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.red,
                                ));
                              });
                          if (isEdit) {
                            var params = {
                              'id': widget.service?.id,
                              'title': titleController.text.trim(),
                              'description': descriptionController.text.trim(),
                              'status': status
                            };
                            Future<int> check =
                                Service.putData(params, context);
                            check.then((value) {
                              if (value == 200) {
                                Navigator.of(context).pop();
                                widget.service?.title = titleController.text;
                                widget.service?.description =
                                    descriptionController.text;
                                widget.service?.status = status;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Service Updated'),
                                  ),
                                );
                                Navigator.of(context).pop(widget.service);
                              } else {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Service Not Updated'),
                                  ),
                                );
                              }
                            });
                          } else {
                            var params = {
                              'title': titleController.text.trim(),
                              'description': descriptionController.text.trim(),
                              'status': status
                            };
                            Future<int> check =
                                Service.postData(params, context);
                            check.then((value) {
                              if (value == 200) {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Service Added'),
                                  ),
                                );
                                Navigator.of(context).pop(true);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Service Not Added'),
                                  ),
                                );
                              }
                            });
                          }
                        }
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
                            Icons.clear,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ))),
              ],
            ),
          ]),
        ));
  }
}
