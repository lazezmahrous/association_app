import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hessen_app/Association%20application/home%20and%20employe%20dashboard/cubits/agricultural_society_cubit/agricultural_society_cubit.dart';
import 'package:hessen_app/Association%20application/home%20and%20employe%20dashboard/screens/collect_the_amount.dart';
import 'package:hessen_app/Association%20application/home%20and%20employe%20dashboard/widgets/show_Items_widget.dart';
import 'package:hessen_app/Association%20application/login%20and%20register/models/employe_signup_model.dart';
import 'package:hessen_app/constanc.dart';
import 'package:hessen_app/global%20widgets/get_mony_widget.dart';

class GetItemsWidget extends StatelessWidget {
  const GetItemsWidget({
    super.key,
    required this.employe,
  });
  final EmployeSighnUpModel employe;

  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => AgriculturalSocietyCubit()
        ..getData(
          employeCenterName: employe.employeCenterName,
          employeAssociation: employe.employeAssociation,
        ),
      child: BlocBuilder<AgriculturalSocietyCubit, AgriculturalSocietyState>(
        builder: (context, state) {
          if (state is GetDataLoading) {
            return const CircularProgressIndicator();
          } else if (state is GetDataSuccess) {
            return SizedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: screenWidth - 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            child: Text(
                              ' مرحبا 👋  \n  يا ${employe.employeName}',
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              BlocProvider.of<AgriculturalSocietyCubit>(context)
                                  .getData(
                                employeCenterName: employe.employeCenterName,
                                employeAssociation: employe.employeAssociation,
                              );
                            },
                            child: const Text(
                              'تحديث',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: screenWidth - 60,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: state.data.docs.length,
                          itemBuilder: (context, index) {
                            return ShowItemsWidget(
                              itemName: state.data.docs[index]['name'],
                              itemamount: state.data.docs[index]['amount'],
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: GetMonyWidget(
                        employeCenterName: employe.employeCenterName,
                        employeAssociation: employe.employeAssociation,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CollectTheAmount(
                              employeName: employe.employeName,
                              employeCenterName: employe.employeCenterName,
                              employeAssociation: employe.employeAssociation,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'سحب مبلغ',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is GetDataFailure) {
            return Text('حدث خطأ ${state.errMessage}');
          }
          return const SizedBox();
        },
      ),
    );
  }
}
