import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

// Mock BLoC setup similar to user's code
class UserFormState {
  final String firstName;
  final String lastName;
  final String email;
  final bool isActive;
  final String? role;
  final List<String> tags;
  final bool isLoading;

  UserFormState({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.isActive = false,
    this.role,
    this.tags = const [],
    this.isLoading = false,
  });

  UserFormState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    bool? isActive,
    String? role,
    List<String>? tags,
    bool? isLoading,
  }) =>
      UserFormState(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        isActive: isActive ?? this.isActive,
        role: role ?? this.role,
        tags: tags ?? this.tags,
        isLoading: isLoading ?? this.isLoading,
      );
}

class UserFormCubit extends Cubit<UserFormState> {
  UserFormCubit() : super(UserFormState());

  Future<void> fetchUserDetails() async {
    emit(state.copyWith(isLoading: true));

    // Simulate async data fetch
    await Future<void>.delayed(const Duration(milliseconds: 100));

    emit(
      state.copyWith(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        isActive: true,
        role: 'Admin',
        tags: ['Tag1', 'Tag2'],
        isLoading: false,
      ),
    );
  }

  void updateFirstName(String? value) {
    emit(state.copyWith(firstName: value ?? ''));
  }

  void updateLastName(String? value) {
    emit(state.copyWith(lastName: value ?? ''));
  }

  void updateEmail(String? value) {
    emit(state.copyWith(email: value ?? ''));
  }

  void updateIsActive(bool? value) {
    emit(state.copyWith(isActive: value ?? false));
  }

  void updateRole(String? value) {
    emit(state.copyWith(role: value));
  }

  void updateTags(List<String>? value) {
    emit(state.copyWith(tags: value ?? []));
  }
}

void main() {
  group('Async Initial Value Loading Tests', () {
    testWidgets('Fields display initial values after async BLoC state update - User Scenario', (tester) async {
      // This test simulates the exact user scenario
      final formController = VooFormController();

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (context) => UserFormCubit()..fetchUserDetails(),
            child: BlocBuilder<UserFormCubit, UserFormState>(
              builder: (context, state) => Scaffold(
                body: VooFormPageBuilder(
                  controller: formController,
                  isSubmitting: false,
                  header: Text('User Form - Loading: ${state.isLoading}'),
                  onSubmit: (_) {},
                  form: VooForm(
                    controller: formController,
                    key: const Key('user_form'),
                    isLoading: state.isLoading,
                    fields: [
                      VooTextField(
                        name: 'first_name',
                        label: 'First Name',
                        initialValue: state.firstName,
                        onChanged: (value) => context.read<UserFormCubit>().updateFirstName(value),
                      ),
                      VooTextField(
                        name: 'last_name',
                        label: 'Last Name',
                        initialValue: state.lastName,
                        onChanged: (value) => context.read<UserFormCubit>().updateLastName(value),
                      ),
                      VooTextField(
                        name: 'email',
                        label: 'Email',
                        initialValue: state.email,
                        onChanged: (value) => context.read<UserFormCubit>().updateEmail(value),
                      ),
                      VooCheckboxField(
                        name: 'is_active',
                        label: 'Active',
                        initialValue: state.isActive,
                        onChanged: (value) => context.read<UserFormCubit>().updateIsActive(value),
                      ),
                      VooDropdownField<String>(
                        name: 'role',
                        label: 'Role',
                        options: const ['Admin', 'User', 'Manager'],
                        initialValue: state.role,
                        onChanged: (value) => context.read<UserFormCubit>().updateRole(value),
                      ),
                      VooMultiSelectField<String>(
                        name: 'tags',
                        label: 'Tags',
                        options: const ['Tag1', 'Tag2', 'Tag3'],
                        initialValue: state.tags,
                        onChanged: (value) => context.read<UserFormCubit>().updateTags(value),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Initially, form is loading
      expect(find.text('User Form - Loading: true'), findsOneWidget);

      // Wait for async data to load
      await tester.pump(const Duration(milliseconds: 150));

      // Form should no longer be loading
      expect(find.text('User Form - Loading: false'), findsOneWidget);

      // CRITICAL: Initial values should be displayed WITHOUT toggling to readonly
      // This is what users are reporting doesn't work
      expect(find.text('John'), findsOneWidget, reason: 'First name should be displayed');
      expect(find.text('Doe'), findsOneWidget, reason: 'Last name should be displayed');
      expect(find.text('john.doe@example.com'), findsOneWidget, reason: 'Email should be displayed');

      // Check dropdown displays value
      expect(find.text('Admin'), findsOneWidget, reason: 'Dropdown should show selected role');

      // Check multi-select displays values
      expect(find.text('Tag1'), findsOneWidget, reason: 'First tag should be displayed');
      expect(find.text('Tag2'), findsOneWidget, reason: 'Second tag should be displayed');

      // Check checkbox is checked
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox).first);
      expect(checkbox.value, true, reason: 'Checkbox should be checked');
    });

    testWidgets('Fields update when BLoC state changes multiple times', (tester) async {
      final formController = VooFormController();
      late UserFormCubit cubit;

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (context) {
              cubit = UserFormCubit();
              return cubit;
            },
            child: BlocBuilder<UserFormCubit, UserFormState>(
              builder: (context, state) => Scaffold(
                body: VooForm(
                  controller: formController,
                  fields: [
                    VooTextField(
                      name: 'first_name',
                      label: 'First Name',
                      initialValue: state.firstName,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      // Initially empty
      expect(find.text('John'), findsNothing);

      // Update state
      cubit.emit(UserFormState(firstName: 'John'));
      await tester.pump();

      // Should show John
      expect(find.text('John'), findsOneWidget);

      // Update state again
      cubit.emit(UserFormState(firstName: 'Jane'));
      await tester.pump();

      // Should show Jane (if user hasn't typed anything)
      // But if user has typed, their input should be preserved
      expect(find.text('Jane'), findsOneWidget);
    });

    testWidgets('VooForm without PageBuilder shows initial values', (tester) async {
      final formController = VooFormController();

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (context) => UserFormCubit()..fetchUserDetails(),
            child: BlocBuilder<UserFormCubit, UserFormState>(
              builder: (context, state) => Scaffold(
                body: VooForm(
                  controller: formController,
                  isLoading: state.isLoading,
                  fields: [
                    VooTextField(
                      name: 'first_name',
                      label: 'First Name',
                      initialValue: state.firstName,
                    ),
                    VooTextField(
                      name: 'email',
                      label: 'Email',
                      initialValue: state.email,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      // Wait for async data
      await tester.pump(const Duration(milliseconds: 150));

      // Values should be displayed
      expect(find.text('John'), findsOneWidget);
      expect(find.text('john.doe@example.com'), findsOneWidget);
    });

    testWidgets('Controller created inside BlocBuilder works correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (context) => UserFormCubit()..fetchUserDetails(),
            child: BlocBuilder<UserFormCubit, UserFormState>(
              builder: (context, state) {
                // Controller created inside builder - gets recreated on each build
                final formController = VooFormController();

                return Scaffold(
                  body: VooForm(
                    controller: formController,
                    isLoading: state.isLoading,
                    fields: [
                      VooTextField(
                        name: 'first_name',
                        label: 'First Name',
                        initialValue: state.firstName,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Wait for async data
      await tester.pump(const Duration(milliseconds: 150));

      // Value should still be displayed
      expect(find.text('John'), findsOneWidget);
    });

    testWidgets('Fields preserve user input when BLoC state changes', (tester) async {
      final formController = VooFormController();
      late UserFormCubit cubit;

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (context) {
              cubit = UserFormCubit();
              return cubit;
            },
            child: BlocBuilder<UserFormCubit, UserFormState>(
              builder: (context, state) => Scaffold(
                body: VooForm(
                  controller: formController,
                  fields: [
                    VooTextField(
                      name: 'first_name',
                      label: 'First Name',
                      initialValue: state.firstName,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      // Set initial state
      cubit.emit(UserFormState(firstName: 'John'));
      await tester.pump();

      // User types something
      await tester.enterText(find.byType(TextFormField), 'UserTyped');
      await tester.pump();

      // BLoC state changes (e.g., another field updates)
      cubit.emit(UserFormState(firstName: 'Jane', lastName: 'Doe'));
      await tester.pump();

      // User's typed value should be preserved
      expect(find.text('UserTyped'), findsOneWidget);
      expect(find.text('Jane'), findsNothing);
    });

    testWidgets('Readonly mode toggle preserves values', (tester) async {
      final formController = VooFormController();
      bool isReadOnly = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) => Scaffold(
              body: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => setState(() => isReadOnly = !isReadOnly),
                    child: const Text('Toggle ReadOnly'),
                  ),
                  Expanded(
                    child: VooForm(
                      controller: formController,
                      isReadOnly: isReadOnly,
                      fields: const [
                        VooTextField(
                          name: 'first_name',
                          label: 'First Name',
                          initialValue: 'John',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Value should be displayed initially
      expect(find.text('John'), findsOneWidget);

      // Toggle to readonly
      await tester.tap(find.text('Toggle ReadOnly'));
      await tester.pump();

      // Value should still be displayed
      expect(find.text('John'), findsOneWidget);

      // Toggle back to editable
      await tester.tap(find.text('Toggle ReadOnly'));
      await tester.pump();

      // Value should still be displayed
      expect(find.text('John'), findsOneWidget);
    });
  });
}
