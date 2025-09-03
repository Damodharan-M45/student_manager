import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:resize/resize.dart';
import 'package:student_manager/constant/appcolors.dart';
import 'package:student_manager/presentation/providers/notifier.dart';
import 'package:student_manager/widgets/customtextfield_widget.dart';
import 'package:student_manager/widgets/customelevatedbutton_widget.dart';

class AddStudentScreen extends ConsumerWidget {
  const AddStudentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(addStudentProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Resize(
        builder: () => SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Back arrow
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 24.sp,
                    color: AppColors.black,
                  ),
                  onPressed: () {
                    provider.clearFields();
                    Navigator.of(context).pop();
                  },
                ),
              ),
              // Title
              Center(
                child: Text(
                  'Add Student',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ),
              SizedBox(height: 32.h),

              Form(
                key: provider.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextField(
                      label: 'Name',
                      controller: provider.nameController,
                      textSize: 12.sp,
                      keyboardType: TextInputType.name,
                      inputFormatter: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r"[a-zA-Z\s'-]"),
                        ),
                      ],
                      maxLength: 50,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Enter name';
                        if (v.trim().length < 3) {
                          return 'Name must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    CustomTextField(
                      label: 'Email',
                      controller: provider.emailController,
                      textSize: 12.sp,
                      keyboardType: TextInputType.emailAddress,
                      maxLength: 50,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      inputFormatter: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        FilteringTextInputFormatter.deny(RegExp(r'[^\w@.\-]')),
                      ],
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email is required';
                        final emailRegex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );
                        if (!emailRegex.hasMatch(v.trim())) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    CustomTextField(
                      label: 'Phone',
                      controller: provider.phoneController,
                      textSize: 12.sp,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (v) => v == null || v.trim().length < 10
                          ? 'Enter valid phone number'
                          : null,
                    ),
                    SizedBox(height: 32.h),
                    CustomElevatedButton(
                      text: 'Save',
                      onPressed: provider.loading
                          ? null
                          : () => provider.saveStudent(context),
                      isLoading: provider.loading,
                      fontSize: 14.sp,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
