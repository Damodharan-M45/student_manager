import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_manager/data/datasource/student_datasource_impl.dart';
import 'package:student_manager/data/repository_impl/student_repo_impl.dart';
import 'package:student_manager/domain/usecases/add_student_usecase.dart';
import 'package:student_manager/domain/usecases/get_student_usecase.dart';
import 'package:student_manager/presentation/providers/addstudent_provider.dart';
import 'package:student_manager/presentation/providers/home_provider.dart';
import 'package:student_manager/presentation/providers/login_provider.dart';
import 'package:student_manager/presentation/providers/register_provider.dart';
import 'package:student_manager/presentation/providers/student_providers.dart';

final loginProvider = ChangeNotifierProvider<LoginProvider>((ref) {
  return LoginProvider(ref);
});

final registerProvider = ChangeNotifierProvider<RegisterProvider>(
  (ref) => RegisterProvider(ref),
);

final homeProvider = ChangeNotifierProvider<HomeProvider>(
  (ref) => HomeProvider(ref),
);

final addStudentProvider = ChangeNotifierProvider(
  (ref) => AddStudentProvider(ref),
);

final studentLocalDataSourceProvider =
    Provider.autoDispose<StudentLocalDataSource>((ref) {
      return StudentLocalDataSourceImpl();
    });

final studentRepositoryProvider = Provider.autoDispose((ref) {
  final ds = ref.watch(studentLocalDataSourceProvider);
  return StudentRepositoryImpl(localDataSource: ds);
});

final getStudentsProviderusecase = Provider.autoDispose(
  (ref) => GetStudents(ref.watch(studentRepositoryProvider)),
);
final addStudentProviderusecase = Provider.autoDispose(
  (ref) => AddStudent(ref.watch(studentRepositoryProvider)),
);

final studentProvider = ChangeNotifierProvider.autoDispose<StudentProvider>((
  ref,
) {
  final getStudents = ref.watch(getStudentsProviderusecase);
  final addStudent = ref.watch(addStudentProviderusecase);
  final repository = ref.watch(studentRepositoryProvider);
  return StudentProvider(getStudents, addStudent, repository);
});
