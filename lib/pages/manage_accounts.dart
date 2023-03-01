import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageAccounts extends StatefulWidget {
  const ManageAccounts({super.key});

  @override
  State<ManageAccounts> createState() => _ManageAccountsState();
}

class _ManageAccountsState extends State<ManageAccounts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // const SizedBox(height: 20),
          Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                // alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(top: 35, left: 10),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(100)
                    //more than 50% of width makes circle
                    ),
                child: const Icon(
                  Icons.manage_accounts_rounded,
                  color: Colors.orange,
                  size: 20,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 35, left: 10),
                child: Text(
                  'Accounts',
                  style: GoogleFonts.robotoSlab(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.only(top: 35),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 10, right: 50),
              child: const Text(
                'Add another account - so you can switch between them easily.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              )),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text('Your existing account',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                      )),
                  InkWell(
                      child: const Text('Manage account',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )),
                      onTap: () {}),
                ]),
          ),
          SingleChildScrollView(
            child: Container(
                // height: MediaQuery.of(context).size.height * 0.7,
                margin: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: OutlinedButton(
                        child: Row(
                          children: <Widget>[
                            Image.asset('assets/images/person.png',
                                width: 30, height: 30),
                            const SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'John Doe',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'johndoe@gmail.com',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.check_circle,
                              color: Colors.orange,
                            ),
                          ],
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: OutlinedButton(
                        child: Row(
                          children: <Widget>[
                            Image.asset('assets/images/person.png',
                                width: 30, height: 30),
                            const SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'John Doe',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'johndoe@gmail.com',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              color: Colors.orange[100],
                              width: 20,
                              height: 20,
                              child: const Center(
                                child: Text(
                                  '8',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: OutlinedButton(
                        child: Row(
                          children: <Widget>[
                            Image.asset('assets/images/person.png',
                                width: 30, height: 30),
                            const SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'John Doe',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'johndoe@gmail.com',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              color: Colors.orange[100],
                              width: 20,
                              height: 20,
                              child: const Center(
                                child: Text(
                                  '10',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: OutlinedButton(
                        child: Row(
                          children: <Widget>[
                            Image.asset('assets/images/person.png',
                                width: 30, height: 30),
                            const SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'John Doe',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'johndoe@gmail.com',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              color: Colors.orange[100],
                              width: 20,
                              height: 20,
                              child: const Center(
                                child: Text(
                                  '2',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                )),
          ),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)
                //more than 50% of width makes circle
                ),
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              // ignore: sort_child_properties_last
              label: const Text('Add aother',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  )),
              onPressed: () {},
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
