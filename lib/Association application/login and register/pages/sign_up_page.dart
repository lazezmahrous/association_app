import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hessen_app/constanc.dart';
import 'package:hessen_app/Association%20application/home%20and%20employe%20dashboard/models/farmer_model.dart';
import 'package:hessen_app/Association%20application/home%20and%20employe%20dashboard/screens/home_page.dart';
import 'package:hessen_app/Association%20application/login%20and%20register/cubits/login_cubit/login_cubit.dart';
import 'package:hessen_app/Association%20application/login%20and%20register/cubits/signup_cubit/signup_cubit.dart';
import 'package:hessen_app/Association%20application/login%20and%20register/models/employe_signup_model.dart';
import 'package:hessen_app/Association%20application/login%20and%20register/pages/login_page.dart';
import 'package:hessen_app/global%20widgets/elevated_button_widget.dart';
import 'package:hessen_app/global%20widgets/helpers/create_popup_menu.dart';
import 'package:hessen_app/global%20widgets/text_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _employeName = TextEditingController();
  final TextEditingController _employePhoneNumber = TextEditingController();
  final TextEditingController _employeEmail = TextEditingController();
  final TextEditingController _employePssword = TextEditingController();
  final TextEditingController _associations = TextEditingController();
  final TextEditingController _centersName = TextEditingController();
  final GlobalKey<FormState> _formkayLogin = GlobalKey();
  bool isLoading = false;

// إضافه ال 100 جمعيه
// تعديل الجمعيات علي حسب المركز
  final List<String> centersNames = [
    'الفيوم',
    'سنورس',
    'طاميه',
    'إطسا',
    'يوسف الصديق',
    'أبشواي',
  ];
  final Map<String, List<String>> associations_list = {
    "الفيوم": [
      'العامرية',
      'هوارة المقطع',
      'تلات',
      'سنوفر',
      'الحادقة',
      'هوارة عدلان',
      'الناصرية',
      'الحامدية الجديدة',
      'ابجيج',
      'المندرة',
      'منشاة الفيوم',
      'اللاهون',
      'العزب',
      'العدوة',
      'الصالحية',
      'السنباط',
      'البسيونية',
      'الاعلام',
      'بني صالح',
      'منشاة العشيري',
      'دمو',
      'زاوية الكرداسة',
      'سيلا',
      'قحافة',
      'بندر الفيوم',
      'دار الرماد',
      'الشيخ فضل',
      'ابوالسعود',
      'منشاة الخطيب',
      'كفور النيل',
      'منشاة دمو',
      'منشاة عبدالله',
      'منشاة فتيح',
      'منشاة بغداد',
      'منشاة سكران',
      'نزلة بشير',
      'منشاة كمال',
      'دمشقين',
      'دسيا',
    ],
    "سنورس": [
      "سنورس أول",
      "سنورس تانى",
      "منشاه سنورس",
      "ا منشاة طنطاوى",
      "منشاة بنى عتمان",
      "اجيلة",
      "الإخصاص",
      "مطرطارس",
      "جرفس",
      "الكعابى الجديدة",
      "بيهمو",
      "ابهيت الحجر",
      "ترسا",
      "كفر فرازه",
      "نقاليفة",
      "السيلين",
      "فيديمين",
      "منشاة دكم",
      "سنرو القبلية",
      "سنهور البحرية",
      "السعيدية",
    ],
    "طاميه": [
      "دار السلام",
      "كفر عميرة",
      "عزب سرسنا",
      "سرسنا",
      "المقاتلة ناصر",
      "يونس",
      "فرقص",
      "الروبيات",
      "البرانى",
      "العزيزية",
      "هوجمين",
      "الروضة",
      "منشاة الجمال",
      "الكومي",
      "الفهمية",
      "قصر رشوان",
      "كفر محفوظ",
      "بندر طامية",
      "فانوس",
      "المظاطلي",
      "م .عفيفي",
    ],
    "اطسا": [
      "منشأة حلفا",
      "منشاة ربيع",
      "منشاة رحمى",
      "منشاة رمزى",
      "معصرة عرفة",
      "منشاة صبرى",
      "منشاة عبد المجيد",
      "نوارة",
      "بندر اطسا",
      "الصوافئة",
      "دفنو",
      "ع . الجعافرة",
      "ابودفية",
      "منشاة . فيصل",
      "معجون",
      "مطول",
      "قلمشاه",
      "قلهانة",
      "منشاة ظافر",
      "قصر الباسل",
      "عنك",
      "عزبة قلمشاه",
      "م. سيف",
      "شدموه",
      "دانيال",
      "خلف",
      "جردو",
      "تطون",
      "بحرابو المير",
      "منشاة الامير",
      "الونايسة",
      "منيه الحيط",
      "المحمودية",
      "القاسمية",
      "الغرق قبلي",
      "العوفي",
      "ابو صير دفنو",
      "اهريت",
      "الجعافره",
      "الحمدية",
      "الحجر",
      "الحسينية",
      "السعدة",
      "عتامنة المزارعة",
      "الغابة",
      "الغرق بحري",
    ],
    "أبشواي": [
      "منشأة ابشواي",
      "الخالدية",
      "أبو شنب",
      "منشأة هويدي",
      "ابو جنشو",
      "العلوية",
      "ابوكساه",
      "زيد",
      "شكشوك",
      "كفر عبود",
      "الجيلاني",
      "سنرو القبلية",
      "قصر بياض",
      "سنرو البحرية",
      "طبهار",
      "ابو دنقاش",
      "العجميين",
      "النصارية",
    ],
    "يوسف الصديق": [
      "قارون اباظة",
      "منشاة قارون",
      "قارون والي",
      "الصبيحي",
      "المشرك قبلي",
      "العقيلي",
      "ابو لطيعة",
      "الرواشدية",
      "كحك بحري",
      "كحك قبلي",
      "الصعايدة القبلية",
      "الشواشنة",
      "بطن إهريت القبليه",
      "بطن إهريت البحريه",
      "قصر الجبالي",
      "النزلة",
      "الربع",
      "المقراني",
      "الحامولي",
      "شعلان",
      "سالم عبداللة",
      "المشرك بحري",
      "الشهيد عبدالباسط",
    ],
  };

  @override
  Widget build(BuildContext context) {
    final signUpCubit = BlocProvider.of<SignUpCubit>(context);

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: SpinKitPulse(
        color: Constanc.kColorGreen,
        size: 100.0,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إنشاء حساب موظف'),
          centerTitle: true,
        ),
        body: BlocListener<SignUpCubit, SignupState>(
          listener: (context, state) {
            if (state is SignupLoading) {
              setState(() {
                isLoading = true;
              });
            } else if (state is SignupSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            } else if (state is SignupFailure) {
              setState(() {
                isLoading = false;
              });
            }
          },
          child: Form(
            key: _formkayLogin,
            child: Center(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        child: Image.asset('assets/images/logo.jpg'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'وزارة الزراعة',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFieldWidget(
                    lableName: 'إسم الموظف',
                    password: false,
                    textinput: TextInputType.name,
                    controller: _employeName,
                    maxLength: 32,
                    ispassword: false,
                    onTap: (data) {
                      _employeName.text = data!;
                      return null;
                    },
                    validator: (String? data) {
                      if (data!.isEmpty) {
                        return 'لازم تكتب إسمك';
                      } else if (data.length < 6) {
                        return 'الإسم قصير';
                      }
                      return null;
                    },
                  ),
                  TextFieldWidget(
                    lableName: 'إسم المركز',
                    password: false,
                    textinput: TextInputType.name,
                    controller: _centersName,
                    maxLength: 32,
                    ispassword: false,
                    prefixIcon: PopupMenuButton(
                      itemBuilder: (context) =>
                          createPopupMenu(list: centersNames),
                      onSelected: (value) {
                        _centersName.text = value;
                      },
                    ),
                    onTap: (data) {
                      _centersName.text = data!;
                      return null;
                    },
                    validator: (String? data) {
                      if (data!.isEmpty) {
                        return 'لازم تختار إسم المركز';
                      }
                      return null;
                    },
                  ),
                  TextFieldWidget(
                    lableName: 'إسم الجمعية',
                    password: false,
                    textinput: TextInputType.name,
                    controller: _associations,
                    maxLength: 32,
                    ispassword: false,
                    prefixIcon: PopupMenuButton(
                      itemBuilder: (context) => createPopupMenu(
                          list: associations_list[_centersName.value.text]!
                              .toList()),
                      onSelected: (value) {
                        _associations.text = value;
                      },
                    ),
                    onTap: (data) {
                      _associations.text = data!;
                      return null;
                    },
                    validator: (String? data) {
                      if (data!.isEmpty) {
                        return 'لازم تختار إسم الجمعية';
                      }
                      return null;
                    },
                  ),
                  TextFieldWidget(
                    lableName: 'رقم التلفون',
                    password: false,
                    textinput: TextInputType.name,
                    controller: _employePhoneNumber,
                    maxLength: 11,
                    ispassword: false,
                    onTap: (String? data) {
                      _employePhoneNumber.text = data!;
                      return null;
                    },
                    validator: (String? data) {
                      if (data!.isEmpty) {
                        return 'لازم تكتب رقم التلفون';
                      } else if (data.length < 6) {
                        return 'الإسم قصير';
                      }
                      return null;
                    },
                  ),
                  TextFieldWidget(
                    lableName: 'الإميل',
                    password: false,
                    textinput: TextInputType.emailAddress,
                    controller: _employeEmail,
                    maxLength: 60,
                    ispassword: false,
                    onTap: (data) {
                      _employeEmail.text = data!;
                      return null;
                    },
                    validator: (String? data) {
                      if (data!.isEmpty) {
                        return 'لازم تكتب إميلك';
                      } else if (data.length < 6) {
                        return 'الإسم قصير';
                      }
                      return null;
                    },
                  ),
                  TextFieldWidget(
                    lableName: 'كلمه السر',
                    password: true,
                    textinput: TextInputType.visiblePassword,
                    controller: _employePssword,
                    maxLength: 12,
                    ispassword: true,
                    onTap: (data) {
                      _employePssword.text = data!;
                      return null;
                    },
                    validator: (String? data) {
                      if (data!.isEmpty) {
                        return 'لازم تكتب كلمه السر';
                      } else if (data.length < 6) {
                        return 'الإسم قصير';
                      }
                      return null;
                    },
                  ),
                  ElevatedButtonWidget(
                    text: 'إنشاء حساب',
                    onPressed: () async {
                      // for (String element in associations_list) {
                      //   FirebaseFirestore.instance
                      //       .collection('agricultural_society')
                      //       .doc(element)
                      //       .set({
                      //     "يوريا": '0',
                      //     "نترات": '0',
                      //     "سوبر محبب": '0',
                      //     "سوبر ناعم": '0',
                      //     "مخصبات بوتاسيوم": '0',
                      //     "مخصبات كونفست": '0',
                      //     "مبيدات": '0',
                      //   });
                      // }
                      if (_formkayLogin.currentState!.validate()) {
                        signUpCubit.sighnUpEmploaye(
                          employe: EmployeSighnUpModel(
                            employeName: _employeName.value.text,
                            employeAssociation: _associations.value.text,
                            employeCenterName: _centersName.value.text,
                            employePhoneNumber: _employePhoneNumber.value.text,
                            employeEmail: _employeEmail.value.text,
                            employePassword: _employePssword.value.text,
                          ),
                        );
                      } else {}
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(' هل سجلت إلينا من قبل ..؟ '),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
