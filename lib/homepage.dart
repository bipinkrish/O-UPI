import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ussd_advanced/ussd_advanced.dart';
import 'constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _MyAppState();
}

class _MyAppState extends State<HomePage> {
  String? myDetails;
  bool showDetails = false;

  Future<void> checkPermission() async {
    var status = await Permission.phone.serviceStatus;

    if (status.isEnabled) {
      return;
    } else if (status.isDisabled) {
      await Permission.phone.request();
    } else if (await Permission.phone.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<String?> makeUssdRequest(String code, {bool advanced = false}) async {
    if (advanced) {
      try {
        return await UssdAdvanced.sendAdvancedUssd(code: code);
      } catch (e) {
        debugPrint("Error! ${e.toString()}");
        await Future.delayed(const Duration(seconds: 1), () {});
        return await makeUssdRequest(code, advanced: advanced);
      }
    } else {
      await UssdAdvanced.sendUssd(code: code);
      return null;
    }
  }

  Future<void> getMyDetails() async {
    if (myDetails != null && myDetails != "Not Available") {
      return;
    }
    myDetails = (await makeUssdRequest(Code.getDetail, advanced: true)) ??
        "Not Available";
    refresh();
  }

  Future<void> checkMyBalance() async {
    await makeUssdRequest(Code.getBalance);
  }

  Future<void> reqMoney() async {
    await makeUssdRequest(Code.reqMoney);
  }

  Future<void> getTransaction() async {
    int i = 1;
    while (true) {
      String? temp = await makeUssdRequest(Code.getTrans(i), advanced: true);
      i++;
      if (temp == ":(" || temp == "Invalid Txn selected, please try again") {
        break;
      }

      print(temp);
    }
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          Stack(
            children: [
              if (showDetails)
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: myDetails != null
                          ? SelectableText(myDetails!)
                          : const Padding(
                              padding: EdgeInsets.all(25),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'O UPI',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDetails = !showDetails;
                        getMyDetails();
                        refresh();
                      },
                      icon: Icon(
                        Icons.info,
                        color: showDetails ? Colors.white : Colors.teal,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getCard(
                "Balance",
                Icons.account_balance,
                screenWidth / 3,
                checkMyBalance,
              ),
              const SizedBox(
                width: 40,
              ),
              getCard(
                "Req Money",
                Icons.request_page,
                screenWidth / 3,
                reqMoney,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getCard(
                "Transactions",
                Icons.money,
                screenWidth / 3,
                getTransaction,
              ),
            ],
          ),
        ],
      ),
    );
  }

  InkWell getCard(String task, IconData icd, double width, Function call) {
    return InkWell(
      onTap: () {
        call();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(4),
        width: width,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icd),
            Text(task),
          ],
        ),
      ),
    );
  }

  void refresh() {
    if (mounted) {
      setState(() {});
    }
  }
}
