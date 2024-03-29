import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hessen_app/Association%20application/home%20and%20employe%20dashboard/cubits/mony_cubit/mony_cubit.dart';
import 'package:hessen_app/constanc.dart';
import 'package:hessen_app/global%20widgets/elevated_button_widget.dart';
import 'package:hessen_app/global%20widgets/get_mony_widget.dart';
import 'package:hessen_app/global%20widgets/helpers/show_snack_bar.dart';
import 'package:hessen_app/global%20widgets/text_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CollectTheAmount extends StatefulWidget {
  CollectTheAmount(
      {super.key,
      required this.employeName,
      required this.employeCenterName,
      required this.employeAssociation});
  String? employeAssociation = '';
  String? employeCenterName = '';
  String? employeName = '';

  @override
  State<CollectTheAmount> createState() => _CollectTheAmountState();
}

class _CollectTheAmountState extends State<CollectTheAmount> {
  final TextEditingController reason = TextEditingController();
  final TextEditingController _monyDecrease = TextEditingController();
  final GlobalKey<FormState> _formkay = GlobalKey();

  bool? isLoading = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<MonyCubit, MonyState>(
      listener: (context, state) {
        if (state is GetMonyeLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is DecreaseMonyeSuccess) {
          showSnackBarSuccess(context: context, message: 'تم سحب المبلغ');
        } else if (state is DecreaseMonyeFailure) {
          showSnackBarEror(context, 'خطا ${state.errMessage}', 0);
        } else {
          setState(() {
            isLoading = false;
          });
        }
      },
      child: ModalProgressHUD(
        inAsyncCall: isLoading!,
        progressIndicator: SpinKitPulse(
          color: Constanc.kColorGreen,
          size: 100.0,
        ),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('سحب مبلغ'),
          ),
          body: Form(
            key: _formkay,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              children: [
                GetMonyWidget(
                  employeCenterName: widget.employeCenterName,
                  employeAssociation: widget.employeAssociation,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFieldWidget(
                  lableName: 'سبب السحب',
                  password: false,
                  textinput: TextInputType.name,
                  controller: reason,
                  maxLength: 60,
                  ispassword: false,
                  onTap: (data) {
                    reason.text = data!;
                    return null;
                  },
                  validator: (data) {
                    if (data!.isEmpty) {
                      return 'لازم تكتب السبب';
                    } else {}
                    return null;
                  },
                ),
                TextFieldWidget(
                  lableName: 'المبلغ المسحوب',
                  password: false,
                  textinput: TextInputType.number,
                  controller: _monyDecrease,
                  maxLength: 11,
                  ispassword: false,
                  onTap: (data) {
                    _monyDecrease.text = data!;
                    return null;
                  },
                  validator: (data) {
                    if (data!.isEmpty) {
                      return 'لازم تكتب السبب';
                    } else {}
                    return null;
                  },
                ),
                ElevatedButtonWidget(
                  onPressed: () async {
                    if (_formkay.currentState!.validate()) {
                      await BlocProvider.of<MonyCubit>(context).decreasePrice(
                        employeName: widget.employeName!,
                        employeCenterName: widget.employeCenterName!,
                        decreaseMony: int.parse(_monyDecrease.value.text),
                        employeAssociation: widget.employeAssociation!,
                        reason: reason.value.text,
                      );
                    }
                  },
                  text: 'سحب المبلغ',
                )
                // Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
