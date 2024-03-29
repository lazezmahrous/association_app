import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hessen_app/Association%20application/home%20and%20employe%20dashboard/cubits/farmer_cubit/farmer_cubit.dart';

class ShowFarmers extends StatefulWidget {
  const ShowFarmers({super.key});

  @override
  State<ShowFarmers> createState() => _ShowFarmersState();
}

class _ShowFarmersState extends State<ShowFarmers> {
  @override
  void initState() {
    final farmerCubit = BlocProvider.of<FarmerCubit>(context);
    farmerCubit.getFarmers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمه الفلاحين '),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          BlocBuilder<FarmerCubit, FarmerState>(
            builder: (context, state) {
              if (state is GetFarmersSuccess) {
                if (state.farmers.isNotEmpty) {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    reverse: true,
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(' الإسم : ${state.farmers[index].name}'),
                                  Text(
                                      ' رقم الهاتف : ${state.farmers[index].phoneNumber}'),
                                  Text(
                                      '  الكميه: ${state.farmers[index].amount} طن'),
                                  Text(
                                      '  إسم الصنف: ${state.farmers[index].amountCategory}'),
                                  Text(
                                      ' المبلغ المدفوع: ${state.farmers[index].amountPaid.toString()} جنيه'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: state.farmers.length,
                  );
                } else {
                  return const Center(
                      child: Text(
                    'لم يتم تسجيل اي بيانات',
                    style: TextStyle(fontSize: 20),
                  ));
                }
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}
