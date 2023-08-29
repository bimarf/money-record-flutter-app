import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_record/config/app_assets.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/presentation/page/auth/login_page.dart';

import '../../../data/source/source_user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final controllerName = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();
  register() async {
    if (formKey.currentState!.validate()) {
      bool success = await SourceUser.register(
          controllerName.text, controllerEmail.text, controllerPassword.text);
      if (success) {
        DInfo.dialogSuccess('Berhasil mendaftar');
        DInfo.closeDialog(actionAfterClose: () {
          Get.off(() => const LoginPage());
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DView.nothing(),
                Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Image.asset(AppAssets.logo),
                        DView.spaceHeight(40),
                        TextFormField(
                            controller: controllerName,
                            validator: (value) =>
                                value == '' ? 'Jangan samapai kosong' : null,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              fillColor: AppColor.primary.withOpacity(0.5),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Name',
                              hintStyle: const TextStyle(color: Colors.white),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                            )),
                        DView.spaceHeight(),
                        TextFormField(
                            controller: controllerEmail,
                            validator: (value) =>
                                value == '' ? 'Jangan samapai kosong' : null,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              fillColor: AppColor.primary.withOpacity(0.5),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Email',
                              hintStyle: const TextStyle(color: Colors.white),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                            )),
                        DView.spaceHeight(),
                        TextFormField(
                            controller: controllerPassword,
                            validator: (value) =>
                                value == '' ? 'Jangan samapai kosong' : null,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            obscureText: true,
                            decoration: InputDecoration(
                              fillColor: AppColor.primary.withOpacity(0.5),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Password',
                              hintStyle: const TextStyle(color: Colors.white),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                            )),
                        DView.spaceHeight(30),
                        Material(
                          color: AppColor.primary,
                          borderRadius: BorderRadius.circular(30),
                          child: InkWell(
                            onTap: () {
                              register();
                            },
                            borderRadius: BorderRadius.circular(30),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 16),
                              child: Text(
                                'Register',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Sudah punya akun? ',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Text('Login',
                            style: TextStyle(
                                color: AppColor.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
