import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

// Simulate the user's actual User model
class User {
  final String firstName;
  final String lastName;
  final String email;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  User copyWith({
    String? firstName,
    String? lastName,
    String? email,
  }) =>
      User(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
      );
}

// Simulate the user's Cubit state
abstract class UserFormState {}

class UserFormInitial extends UserFormState {}

class UserFormLoading extends UserFormState {}

class UserFormLoaded extends UserFormState {
  final User user;
  UserFormLoaded(this.user);
}

class UserFormSuccess extends UserFormState {}

// Simulate the user's Cubit
class UserFormCubit extends Cubit<UserFormState> {
  UserFormCubit() : super(UserFormInitial());

  void loadUser() {
    emit(UserFormLoading());
    // Simulate loading a user
    emit(
      UserFormLoaded(
        User(
          firstName: 'John',
          lastName: 'Doe',
          email: 'john@example.com',
        ),
      ),
    );
  }

  void updateUser(User user) {
    emit(UserFormLoaded(user));
  }

  void submitForm() {
    emit(UserFormSuccess());
  }
}

// Recreate the user's actual UserFormPage structure
class UserFormPage extends StatelessWidget {
  const UserFormPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => UserFormCubit()..loadUser(),
        child: const UserFormView(),
      );
}

class UserFormView extends StatefulWidget {
  const UserFormView({super.key});

  @override
  State<UserFormView> createState() => _UserFormViewState();
}

class _UserFormViewState extends State<UserFormView> {
  final VooFormController controller = VooFormController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: BlocBuilder<UserFormCubit, UserFormState>(
          builder: (context, state) {
          if (state is UserFormLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserFormLoaded) {
            // This is exactly how the user's code works - VooForm inside BlocBuilder
            // with new initialValues on each state change
            return VooForm(
              controller: controller,
              fields: [
                VooTextField(
                  name: 'firstName',
                  label: 'First Name',
                  initialValue: state.user.firstName,
                  validators: [const RequiredValidation(errorMessage: 'First name is required')],
                ),
                VooTextField(
                  name: 'lastName',
                  label: 'Last Name',
                  initialValue: state.user.lastName,
                  validators: [const RequiredValidation(errorMessage: 'Last name is required')],
                ),
                VooEmailField(
                  name: 'email',
                  label: 'Email',
                  initialValue: state.user.email,
                  validators: [const RequiredValidation(errorMessage: 'Email is required')],
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
}

void main() {
  group('User Form BLoC Integration Tests', () {
    testWidgets('preserves user input when BLoC state changes with new initialValues', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: UserFormPage(),
        ),
      );

      // Wait for initial load
      await tester.pumpAndSettle();

      // Verify initial values are loaded
      expect(find.text('John'), findsOneWidget);
      expect(find.text('Doe'), findsOneWidget);
      expect(find.text('john@example.com'), findsOneWidget);

      // Clear first name to trigger validation error
      final firstNameField = find.byType(TextFormField).first;
      await tester.enterText(firstNameField, '');
      await tester.pumpAndSettle();

      // Verify error appears
      expect(find.text('First name is required'), findsOneWidget);

      // Start typing to clear the error
      await tester.enterText(firstNameField, 'J');
      await tester.pumpAndSettle();

      // Error should be cleared
      expect(find.text('First name is required'), findsNothing);

      // Continue typing more characters - this is where the user reported issues
      await tester.enterText(firstNameField, 'Jane');
      await tester.pumpAndSettle();

      // Verify the value persists
      expect(find.text('Jane'), findsOneWidget);

      // Simulate BLoC state change (like from a server update)
      final context = tester.element(find.byType(UserFormView));
      final cubit = context.read<UserFormCubit>();

      // Update with different initial values
      cubit.updateUser(
        User(
        firstName: 'Updated',
        lastName: 'User',
        email: 'updated@example.com',
      ),
    );
      await tester.pumpAndSettle();

      // Critical test: User's typed value should persist, not be replaced by new initialValue
      expect(find.text('Jane'), findsOneWidget);
      expect(find.text('Updated'), findsNothing); // Should NOT appear
      
      // Other fields that weren't edited should keep their original values too
      expect(find.text('Doe'), findsOneWidget);
      expect(find.text('john@example.com'), findsOneWidget);
    });

    testWidgets('allows continuous typing when clearing validation errors', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: UserFormPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Clear email to trigger validation
      final emailField = find.byType(TextFormField).last;
      await tester.enterText(emailField, '');
      await tester.pumpAndSettle();

      // Verify error appears
      expect(find.text('Email is required'), findsOneWidget);

      // Type multiple characters in sequence - user reported only one char works
      await tester.enterText(emailField, 'n');
      await tester.pumpAndSettle();
      
      await tester.enterText(emailField, 'ne');
      await tester.pumpAndSettle();
      
      await tester.enterText(emailField, 'new');
      await tester.pumpAndSettle();
      
      await tester.enterText(emailField, 'new@');
      await tester.pumpAndSettle();
      
      await tester.enterText(emailField, 'new@test.com');
      await tester.pumpAndSettle();

      // Verify the complete value was entered
      expect(find.text('new@test.com'), findsOneWidget);
      
      // Error should be cleared
      expect(find.text('Email is required'), findsNothing);
    });

    testWidgets('maintains focus and keyboard when validation triggers', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: UserFormPage(),
        ),
      );

      await tester.pumpAndSettle();

      final firstNameField = find.byType(TextFormField).first;
      
      // Focus the field
      await tester.tap(firstNameField);
      await tester.pumpAndSettle();

      // The field should be focused (we can verify by typing into it)
      // If it loses focus, entering text would fail
      
      // Clear to trigger error
      await tester.enterText(firstNameField, '');
      await tester.pumpAndSettle();

      // Verify error appears
      expect(find.text('First name is required'), findsOneWidget);

      // Type to clear error - this would fail if field lost focus
      await tester.enterText(firstNameField, 'J');
      await tester.pumpAndSettle();

      // Error should be cleared
      expect(find.text('First name is required'), findsNothing);
      
      // Continue typing - this verifies focus is maintained
      await tester.enterText(firstNameField, 'John');
      await tester.pumpAndSettle();
      
      expect(find.text('John'), findsOneWidget);
    });

    testWidgets('handles rapid BLoC state changes without losing user input', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: UserFormPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Start editing last name
      final lastNameField = find.byType(TextFormField).at(1);
      await tester.enterText(lastNameField, 'Smith');
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(UserFormView));
      final cubit = context.read<UserFormCubit>();

      // Simulate rapid state changes (like from real-time updates)
      for (int i = 0; i < 5; i++) {
        cubit.updateUser(
          User(
          firstName: 'Server$i',
          lastName: 'Update$i',
          email: 'server$i@example.com',
        ),
      );
        await tester.pump(const Duration(milliseconds: 100));
      }

      await tester.pumpAndSettle();

      // User's input should still be preserved
      expect(find.text('Smith'), findsOneWidget);
      
      // Server updates should not have overwritten user input
      expect(find.text('Update4'), findsNothing);
    });

    testWidgets('preserves validation state across BLoC rebuilds', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: UserFormPage(),
        ),
      );

      await tester.pumpAndSettle();

      // Create multiple validation errors
      final firstNameField = find.byType(TextFormField).first;
      final lastNameField = find.byType(TextFormField).at(1);
      
      await tester.enterText(firstNameField, '');
      await tester.enterText(lastNameField, '');
      await tester.pumpAndSettle();

      // Verify errors appear
      expect(find.text('First name is required'), findsOneWidget);
      expect(find.text('Last name is required'), findsOneWidget);

      // Trigger a BLoC state change
      final context = tester.element(find.byType(UserFormView));
      final cubit = context.read<UserFormCubit>();

      cubit.updateUser(
        User(
        firstName: 'NewFirst',
        lastName: 'NewLast',
        email: 'new@example.com',
      ),
    );
      await tester.pumpAndSettle();

      // Errors should still be visible (validation state preserved)
      expect(find.text('First name is required'), findsOneWidget);
      expect(find.text('Last name is required'), findsOneWidget);

      // Fix one error
      await tester.enterText(firstNameField, 'Fixed');
      await tester.pumpAndSettle();

      // Only the fixed field's error should be gone
      expect(find.text('First name is required'), findsNothing);
      expect(find.text('Last name is required'), findsOneWidget);
    });
  });
}