import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resize/resize.dart';
import 'package:student_manager/constant/appcolors.dart';
import 'package:student_manager/presentation/providers/notifier.dart';

class StudentListWidget extends ConsumerWidget {
  const StudentListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeProv = ref.watch(homeProvider);

    if (homeProv.loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.blue),
      );
    }

    if (homeProv.error != null) {
      return Center(
        child: Text(
          'Error: ${homeProv.error}',
          style: TextStyle(fontSize: 14.sp),
        ),
      );
    }

    if (homeProv.students.isEmpty) {
      return Center(
        child: Text('No students yet.', style: TextStyle(fontSize: 14.sp)),
      );
    }

    return RefreshIndicator(
      onRefresh: () => homeProv.refresh(),
      child: ListView.separated(
        itemCount: homeProv.students.length,
        separatorBuilder: (_, __) => SizedBox(height: 8.h),
        itemBuilder: (c, i) {
          final s = homeProv.students[i];
          return Container(
            padding: EdgeInsets.all(12.h),
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${s.email} • ${s.phone}',
                  style: TextStyle(fontSize: 12.sp),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
