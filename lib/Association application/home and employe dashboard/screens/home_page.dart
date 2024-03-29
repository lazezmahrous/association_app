// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hessen_app/Association%20application/home%20and%20employe%20dashboard/screens/collect_the_amount.dart';
import 'package:hessen_app/Association%20application/home%20and%20employe%20dashboard/widgets/get_items_widget.dart';
import 'package:hessen_app/constanc.dart';
import 'package:hessen_app/Association%20application/home%20and%20employe%20dashboard/cubits/agricultural_society_cubit/agricultural_society_cubit.dart';
import 'package:hessen_app/Association%20application/home%20and%20employe%20dashboard/cubits/employe_cubit/employe_cubit.dart';
import 'package:hessen_app/Association%20application/home%20and%20employe%20dashboard/cubits/farmer_cubit/farmer_cubit.dart';
import 'package:hessen_app/Association%20application/home%20and%20employe%20dashboard/models/farmer_model.dart';
import 'package:hessen_app/Association%20application/home%20and%20employe%20dashboard/screens/show_farmers.dart';
import 'package:hessen_app/Association%20application/login%20and%20register/pages/sign_up_page.dart';
import 'package:hessen_app/global%20widgets/elevated_button_widget.dart';
import 'package:hessen_app/global%20widgets/get_mony_widget.dart';
import 'package:hessen_app/global%20widgets/helpers/create_popup_menu.dart';
import 'package:hessen_app/global%20widgets/helpers/show_snack_bar.dart';
import 'package:hessen_app/Association%20application/home%20and%20employe%20dashboard/widgets/show_Items_widget.dart';
import 'package:hessen_app/global%20widgets/text_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cubits/count_price_cubit/count_price_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _farmerName = TextEditingController();
  final TextEditingController _farmerPhoneNumber = TextEditingController();
  final TextEditingController _farmerAmount = TextEditingController();
  final TextEditingController _farmerAmountCategory = TextEditingController();
  final TextEditingController _farmerAmountPaid = TextEditingController();
  final TextEditingController _farmerAmountUnit = TextEditingController();
  final GlobalKey<FormState> _formkayFarmer = GlobalKey();

  bool isLoading = false;

  late String employeAssociation = '';
  late String employeCenterName = '';
  late String employeName = '';

  int amount = 0;
  final List<String> items_list = [
    'يوريا',
    'نترات',
    'سوبر محبب',
    'سوبر ناعم',
    'مخصبات بوتاسيوم',
    'مخصبات كونفست',
    'مبيدات',
  ];

  final List<String> amount_list = [
    'طن',
    'كيلو',
  ];

  Future<void> addFarmerAndCollectPrice() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    double farmerPrice = double.parse(
      _farmerAmountPaid.text,
    );

    double? oldPrice = prefs.getDouble('price');
    if (oldPrice == null) {
      prefs.setDouble('price', farmerPrice);
    } else {
      double newPrice = oldPrice + farmerPrice;
      prefs.setDouble('price', newPrice);
    }

    await BlocProvider.of<FarmerCubit>(context)
        .addFarmer(
      farmerAmountUnit: _farmerAmountUnit.value.text,
      farmer: FarmerModel(
        id: '0',
        name: _farmerName.value.text,
        phoneNumber: _farmerPhoneNumber.value.text,
        amount: _farmerAmount.value.text,
        amountCategory: _farmerAmountCategory.value.text,
        amountPaid: double.parse(_farmerAmountPaid.text),
        publisher: employeName,
        dataPublisher: DateTime.now(),
        employeAssociation: employeAssociation,
        employeCenterName: employeCenterName,
      ),
    )
        .whenComplete(
      () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final addFarmerCubit = BlocProvider.of<FarmerCubit>(context);

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: SpinKitPulse(
        color: Constanc.kColorGreen,
        size: 100.0,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('جهاز الجمعيه الزراعيه'),
          scrolledUnderElevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpPage(),
                    ),
                    (route) => false);
              },
              icon: const Icon(
                Icons.logout_rounded,
              ),
            ),
          ],
        ),
        body: BlocListener<FarmerCubit, FarmerState>(
          listener: (context, state) async {
            if (state is AddFarmerLoading) {
              setState(() {
                isLoading = true;
              });
            } else if (state is AddFarmerFailure) {
              setState(() {
                isLoading = false;
              });
            } else if (state is AddFarmerSuccess) {
              showSnackBarSuccess(
                  context: context, message: 'تم إضافه الفلاح بنجاح');
              setState(() {
                isLoading = false;

                _farmerName.clear();
                _farmerPhoneNumber.clear();
                _farmerAmountCategory.clear();
                _farmerAmount.clear();
                _farmerAmountPaid.clear();
                _farmerAmountUnit.clear();
              });
            } else if (state is ChechAmountFailure) {
              if (state.errMessage == 'تم إنتهاء الكمية') {
                showSnackBarEror(context, 'تم إنتهاء الكمية', 0);
              } else if (state.errMessage == 'خطا في إدخال الكميه') {
                showSnackBarEror(context, 'خطا في إدخال الكميه ', 0);
              } else if (state.errMessage == 'تم إنتهاء الكمية') {
                showSnackBarEror(context, 'تم إنتهاء الكمية ', 0);
              } else if (state.errMessage ==
                  'تم تسجيل الكميه بشكل خطا علي السيستم') {
                showSnackBarEror(
                    context, 'تم تسجيل الكميه بشكل خطا علي السيستم ', 0);
              } else if (state.errMessage == 'كمية غير متوفره') {
                showSnackBarEror(context, 'كمية غير متوفره', 0);
              }
            } else if (state is ChechAmountSuccess) {
              showSnackBarSuccess(context: context, message: 'كميه متوفره');

              await addFarmerAndCollectPrice();
            }
          },

          // fsl hgg hgg9uh8

          // 
          child: Form(
            key: _formkayFarmer,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<EmployeCubit, EmployeState>(
                          builder: (context, state) {
                            if (state is GetEmployeSuccess) {
                              employeAssociation =
                                  state.user.employeAssociation;
                              employeCenterName = state.user.employeCenterName;
                              employeName = state.user.employeName;
                              return GetItemsWidget(
                                employe: state.user,
                              );
                            } else if (state is GetEmployeFailure) {
                              return Text(
                                'حدث خطأ${state.errMessage}',
                              );
                            } else if (state is GetEmployeLoading) {
                              return const CircularProgressIndicator();
                            }
                            return const CircularProgressIndicator();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFieldWidget(
                  lableName: 'إسم الفلاح',
                  password: false,
                  textinput: TextInputType.name,
                  controller: _farmerName,
                  maxLength: 32,
                  ispassword: false,
                  onTap: (data) {
                    _farmerName.text = data!;
                    return null;
                  },
                  validator: (String? data) {
                    if (data!.isEmpty) {
                      return 'لازم تكتب إسم الفلاح';
                    } else if (data.length < 6) {
                      return 'الإسم قصير';
                    }
                    return null;
                  },
                ),
                TextFieldWidget(
                  lableName: 'رقم الهاتف',
                  password: false,
                  textinput: TextInputType.phone,
                  controller: _farmerPhoneNumber,
                  maxLength: 11,
                  ispassword: false,
                  onTap: (data) {
                    _farmerPhoneNumber.text = data!;
                    return null;
                  },
                  validator: (String? data) {
                    if (data!.isEmpty) {
                      return 'لازم تكتب رقم تلفونه';
                    } else if (data.length < 6) {
                      return 'الإسم قصير';
                    }
                    return null;
                  },
                ),
                TextFieldWidget(
                  lableName: 'إسم الصنف',
                  password: false,
                  textinput: TextInputType.name,
                  controller: _farmerAmountCategory,
                  maxLength: 32,
                  ispassword: false,
                  prefixIcon: PopupMenuButton(
                    itemBuilder: (context) => createPopupMenu(list: items_list),
                    onSelected: (value) {
                      _farmerAmountCategory.text = value;
                    },
                  ),
                  onTap: (data) {
                    _farmerAmountCategory.text = data!;
                    return null;
                  },
                  validator: (String? data) {
                    if (data!.isEmpty) {
                      return 'لازم تكتب إسم الصنف';
                    }
                    return null;
                  },
                ),
                TextFieldWidget(
                  lableName: 'الكمية',
                  password: false,
                  textinput: TextInputType.number,
                  controller: _farmerAmount,
                  maxLength: 32,
                  ispassword: false,
                  onTap: (data) {
                    _farmerAmount.text = data!;
                    return null;
                  },
                  validator: (String? data) {
                    if (data!.isEmpty) {
                      return 'لازم تكتب الكميه';
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFieldWidget(
                        lableName: 'وحده قياس الكميه',
                        password: false,
                        textinput: TextInputType.number,
                        controller: _farmerAmountUnit,
                        maxLength: 32,
                        ispassword: false,
                        prefixIcon: PopupMenuButton(
                          itemBuilder: (context) =>
                              createPopupMenu(list: amount_list),
                          onSelected: (value) {
                            _farmerAmountUnit.text = value;
                          },
                        ),
                        onTap: (data) {
                          _farmerAmountUnit.text = data!;
                          return null;
                        },
                        validator: (String? data) {
                          if (data!.isEmpty) {
                            return 'لازم تكتب وحده قياس الكميه';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ElevatedButtonWidget(
                        onPressed: () async {
                          await BlocProvider.of<CountPriceCubit>(context)
                              .countPrice(
                            farmerAmountUnit: _farmerAmountUnit.value.text,
                            employeCenterName: employeCenterName,
                            employeAssociation: employeAssociation,
                            farmerAmountCategory:
                                _farmerAmountCategory.value.text,
                            farmerAmountPaid: double.parse(_farmerAmount.text),
                          );
                        },
                        text: 'حساب المبلغ',
                      ),
                    ),
                  ],
                ),
                BlocListener<CountPriceCubit, CountPriceState>(
                  listener: (context, state) {
                    if (state is CountPriceSuccess) {
                      _farmerAmountPaid.text = state.price.toString();
                    } else {}
                  },
                  child: TextFieldWidget(
                    enabeld: false,
                    lableName: 'المبلغ المدفوع',
                    password: false,
                    textinput: TextInputType.number,
                    controller: _farmerAmountPaid,
                    maxLength: 32,
                    ispassword: false,
                    onTap: (data) {
                      _farmerAmountPaid.text = data!;
                      return null;
                    },
                    validator: (String? data) {
                      if (data!.isEmpty) {
                        return 'لازم تكتب المبلغ المدفوع';
                      }
                      return null;
                    },
                  ),
                ),
                ElevatedButtonWidget(
                    text: 'تأكيد عملية الشراء',
                    onPressed: () async {
                      // final Map<String, List<String>> associationsList = {
                      //   "الفيوم": [
                      //     'العامرية',
                      //     'هوارة المقطع',
                      //     'تلات',
                      //     'سنوفر',
                      //     'الحادقة',
                      //     'هوارة عدلان',
                      //     'الناصرية',
                      //     'الحامدية الجديدة',
                      //     'ابجيج',
                      //     'المندرة',
                      //     'منشاة الفيوم',
                      //     'اللاهون',
                      //     'العزب',
                      //     'العدوة',
                      //     'الصالحية',
                      //     'السنباط',
                      //     'البسيونية',
                      //     'الاعلام',
                      //     'بني صالح',
                      //     'منشاة العشيري',
                      //     'دمو',
                      //     'زاوية الكرداسة',
                      //     'سيلا',
                      //     'قحافة',
                      //     'بندر الفيوم',
                      //     'دار الرماد',
                      //     'الشيخ فضل',
                      //     'ابوالسعود',
                      //     'منشاة الخطيب',
                      //     'كفور النيل',
                      //     'منشاة دمو',
                      //     'منشاة عبدالله',
                      //     'منشاة فتيح',
                      //     'منشاة بغداد',
                      //     'منشاة سكران',
                      //     'نزلة بشير',
                      //     'منشاة كمال',
                      //     'دمشقين',
                      //     'دسيا',
                      //   ],
                      //   "سنورس": [
                      //     "سنورس أول",
                      //     "سنورس تانى",
                      //     "منشاه سنورس",
                      //     "ا منشاة طنطاوى",
                      //     "منشاة بنى عتمان",
                      //     "اجيلة",
                      //     "الإخصاص",
                      //     "مطرطارس",
                      //     "جرفس",
                      //     "الكعابى الجديدة",
                      //     "بيهمو",
                      //     "ابهيت الحجر",
                      //     "ترسا",
                      //     "كفر فرازه",
                      //     "نقاليفة",
                      //     "السيلين",
                      //     "فيديمين",
                      //     "منشاة دكم",
                      //     "سنرو القبلية",
                      //     "سنهور البحرية",
                      //     "السعيدية",
                      //   ],
                      //   "طاميه": [
                      //     "دار السلام",
                      //     "كفر عميرة",
                      //     "عزب سرسنا",
                      //     "سرسنا",
                      //     "المقاتلة ناصر",
                      //     "يونس",
                      //     "فرقص",
                      //     "الروبيات",
                      //     "البرانى",
                      //     "العزيزية",
                      //     "هوجمين",
                      //     "الروضة",
                      //     "منشاة الجمال",
                      //     "الكومي",
                      //     "الفهمية",
                      //     "قصر رشوان",
                      //     "كفر محفوظ",
                      //     "بندر طامية",
                      //     "فانوس",
                      //     "المظاطلي",
                      //     "م .عفيفي",
                      //   ],
                      //   "اطسا": [
                      //     "منشأة حلفا",
                      //     "منشاة ربيع",
                      //     "منشاة رحمى",
                      //     "منشاة رمزى",
                      //     "معصرة عرفة",
                      //     "منشاة صبرى",
                      //     "منشاة عبد المجيد",
                      //     "نوارة",
                      //     "بندر اطسا",
                      //     "الصوافئة",
                      //     "دفنو",
                      //     "ع . الجعافرة",
                      //     "ابودفية",
                      //     "منشاة . فيصل",
                      //     "معجون",
                      //     "مطول",
                      //     "قلمشاه",
                      //     "قلهانة",
                      //     "منشاة ظافر",
                      //     "قصر الباسل",
                      //     "عنك",
                      //     "عزبة قلمشاه",
                      //     "م. سيف",
                      //     "شدموه",
                      //     "دانيال",
                      //     "خلف",
                      //     "جردو",
                      //     "تطون",
                      //     "بحرابو المير",
                      //     "منشاة الامير",
                      //     "الونايسة",
                      //     "منيه الحيط",
                      //     "المحمودية",
                      //     "القاسمية",
                      //     "الغرق قبلي",
                      //     "العوفي",
                      //     "ابو صير دفنو",
                      //     "اهريت",
                      //     "الجعافره",
                      //     "الحمدية",
                      //     "الحجر",
                      //     "الحسينية",
                      //     "السعدة",
                      //     "عتامنة المزارعة",
                      //     "الغابة",
                      //     "الغرق بحري",
                      //   ],
                      //   "أبشواي": [
                      //     "منشأة ابشواي",
                      //     "الخالدية",
                      //     "أبو شنب",
                      //     "منشأة هويدي",
                      //     "ابو جنشو",
                      //     "العلوية",
                      //     "ابوكساه",
                      //     "زيد",
                      //     "شكشوك",
                      //     "كفر عبود",
                      //     "الجيلاني",
                      //     "سنرو القبلية",
                      //     "قصر بياض",
                      //     "سنرو البحرية",
                      //     "طبهار",
                      //     "ابو دنقاش",
                      //     "العجميين",
                      //     "النصارية",
                      //   ],
                      //   "يوسف الصديق": [
                      //     "قارون اباظة",
                      //     "منشاة قارون",
                      //     "قارون والي",
                      //     "الصبيحي",
                      //     "المشرك قبلي",
                      //     "العقيلي",
                      //     "ابو لطيعة",
                      //     "الرواشدية",
                      //     "كحك بحري",
                      //     "كحك قبلي",
                      //     "الصعايدة القبلية",
                      //     "الشواشنة",
                      //     "بطن إهريت القبليه",
                      //     "بطن إهريت البحريه",
                      //     "قصر الجبالي",
                      //     "النزلة",
                      //     "الربع",
                      //     "المقراني",
                      //     "الحامولي",
                      //     "شعلان",
                      //     "سالم عبداللة",
                      //     "المشرك بحري",
                      //     "الشهيد عبدالباسط",
                      //   ],
                      // };

                      // for (String element in associationsList['الفيوم']!) {
                      // for (var i = 0; i < items_list.length; i++) {
                      //   FirebaseFirestore.instance
                      //       .collection('الفيوم')
                      //       .doc(element)
                      //       .collection('items')
                      //       .doc(items_list[i])
                      //       .set({
                      //     "amount": "0 طن",
                      //     "TonUnitPrice": 0,
                      //     "keloUnitPrice": 0,
                      //     "name": items_list[i],
                      //   });
                      // }

                      if (_formkayFarmer.currentState!.validate()) {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return SizedBox(
                              height: screenHeight / 2,
                              child: Scaffold(
                                body: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 40),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const Center(
                                        child: Text(
                                          'هل انت متأكد من أن جميع البيانات صحيحه',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      ElevatedButtonWidget(
                                        onPressed: () {
                                          print(
                                              '${_farmerAmountUnit.value.text} ${_farmerAmount.value.text}');

                                          Navigator.pop(context);
                                        },
                                        text: 'مراجعه مره أخري',
                                      ),
                                      ElevatedButtonWidget(
                                        onPressed: () async {
                                          print(
                                              '${_farmerAmountUnit.value.text} ${_farmerAmount.value.text}');
                                          if (_formkayFarmer.currentState!
                                              .validate()) {
                                            await addFarmerCubit
                                                .checkItemAmount(
                                              employeAssociation:
                                                  employeAssociation,
                                              employeCenterName:
                                                  employeCenterName,
                                              category: _farmerAmountCategory
                                                  .value.text,
                                              amount:
                                                  '${_farmerAmountUnit.value.text} ${_farmerAmount.value.text}',
                                            );
                                          } else {}
                                        },
                                        text: 'تأكيد',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {}
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ShowFarmers(),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "عرض جميع الفلاحين",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
