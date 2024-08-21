import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:opulencia/features/auth/controller/auth_controller.dart';
import 'package:opulencia/utils/widgets/my_appbar.dart';
import 'package:opulencia/utils/widgets/my_custom_button.dart';
import 'package:opulencia/utils/widgets/my_textfield.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var authData = ref.read(authControllerProvider);
    authData.enterData();
  }

  @override
  Widget build(BuildContext context) {
    var authData = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: myAppBar(context: context, title: "Edit Profile"),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    MyTextField(
                      controller: authData.firstNameController,
                      hintText: "Enter First Name",
                      hasTitle: true,
                      title: "First Name",
                      isRequired: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                    ),
                    const Gap(5),
                    MyTextField(
                      controller: authData.lastNameController,
                      hintText: "Enter Last Name",
                      hasTitle: true,
                      title: "Last Name",
                      isRequired: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                    ),
                    const Gap(5),
                    MyTextField(
                      enabled: false,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller:
                          TextEditingController(text: authData.userData!.phone),
                      hintText: "Enter Mobile Number",
                      hasTitle: true,
                      title: "Mobile Number",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your mobile number';
                        }
                        return null;
                      },
                    ),
                    const Gap(5),
                    MyTextField(
                      isRequired: true,
                      controller: authData.emailController,
                      hintText: "Enter Email Address",
                      hasTitle: true,
                      title: "Email Address",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email address';
                        }
                        // Add email validation logic here if needed
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: MyCustomButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await authData.updateProfile(context: context);
                    }
                  },
                  label: "Save",
                ),
              ),
              const Gap(30)
            ],
          ),
        ),
      ),
    );
  }
}
