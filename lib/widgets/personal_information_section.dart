import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/default_provider.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_textfield.dart';

class PersonalInforSec extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const PersonalInforSec({super.key, required this.formKey});

  @override
  State<PersonalInforSec> createState() => _PersonalInforSecState();
}

class _PersonalInforSecState extends State<PersonalInforSec> {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController kdmnameController = TextEditingController();
  final TextEditingController kdmphonenoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DefaultProvider>(context);

    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        title: const Text('Personal Information'),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: widget.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: "Name"),
                  CustomFormField(
                    inputType: TextInputType.text,
                    controller: nameController,
                    hintText: 'Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      provider.updateName(value);
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomText(text: "Email"),
                  CustomFormField(
                    inputType: TextInputType.emailAddress,
                    controller: emailController,
                    hintText: 'Email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      provider.updateEmail(value);
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomText(text: "Address"),
                  CustomFormField(
                    inputType: TextInputType.streetAddress,
                    controller: addressController,
                    hintText: 'Enter address',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an address';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      provider.updateAddress(value);
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomText(text: "Company name"),
                  CustomFormField(
                    inputType: TextInputType.text,
                    controller: companyController,
                    hintText: 'Enter company name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a company name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      provider.updateCompany(value);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // bool validate() {
  //   return _formKey.currentState?.validate() ?? false;
  // }
}
