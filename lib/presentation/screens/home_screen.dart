import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resize/resize.dart';
import 'package:student_manager/constant/appcolors.dart';
import 'package:student_manager/config/approutes.dart';
import 'package:student_manager/presentation/providers/notifier.dart';
import 'package:student_manager/presentation/screens/widget/studentlist_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeProvider).loadStudents();
    });
  }

  Future<bool> showLogoutDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Resize(
        builder: () => SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Students',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.logout, size: 24.sp),
                      onPressed: () async {
                        final shouldLogout = await showLogoutDialog();
                        if (shouldLogout) {
                          await ref.read(homeProvider).logout(context);
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                const Expanded(child: StudentListWidget()),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref.read(addStudentProvider).clearFields();
          Navigator.of(context).pushNamed(AppRoutes.addstudent);
        },
        backgroundColor: AppColors.orange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: Icon(Icons.add, size: 20.sp, color: AppColors.white),
        label: Text(
          'Add Student',
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
