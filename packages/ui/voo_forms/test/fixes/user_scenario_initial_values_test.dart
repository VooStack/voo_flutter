import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

// Simulating the exact user scenario with UserFormState and UserFormCubit
class UserDetails {
  final String firstName;
  final String lastName;
  final String middleInitial;
  final String email;
  final String userName;
  final String phoneNumber;
  final String? permissionLevel;
  final List<String> roles;
  final bool isAnalystOrResearcher;
  final bool isActive;

  UserDetails({
    this.firstName = '',
    this.lastName = '',
    this.middleInitial = '',
    this.email = '',
    this.userName = '',
    this.phoneNumber = '',
    this.permissionLevel,
    this.roles = const [],
    this.isAnalystOrResearcher = false,
    this.isActive = false,
  });

  factory UserDetails.empty() => UserDetails();

  factory UserDetails.loaded() => UserDetails(
        firstName: 'John',
        lastName: 'Doe',
        middleInitial: 'A',
        email: 'john.doe@example.com',
        userName: 'johndoe',
        phoneNumber: '555-1234',
        permissionLevel: 'Admin',
        roles: ['Manager', 'Reviewer'],
        isAnalystOrResearcher: true,
        isActive: true,
      );
}

enum UserFormStatus { initial, loading, success, submitting, submitted }

class UserFormState {
  final UserDetails userDetails;
  final UserDetails userForm;
  final UserFormStatus status;
  final bool isEditMode;

  UserFormState({
    required this.userDetails,
    required this.userForm,
    required this.status,
    this.isEditMode = false,
  });

  factory UserFormState.initial() => UserFormState(
        userDetails: UserDetails.empty(),
        userForm: UserDetails.empty(),
        status: UserFormStatus.initial,
      );

  UserFormState copyWith({
    UserDetails? userDetails,
    UserDetails? userForm,
    UserFormStatus? status,
    bool? isEditMode,
  }) =>
      UserFormState(
        userDetails: userDetails ?? this.userDetails,
        userForm: userForm ?? this.userForm,
        status: status ?? this.status,
        isEditMode: isEditMode ?? this.isEditMode,
      );
}

class UserFormCubit extends Cubit<UserFormState> {
  UserFormCubit() : super(UserFormState.initial());

  Future<void> fetchUserDetails(String? userId) async {
    if (userId == null || userId.isEmpty || userId == 'new') {
      emit(
        state.copyWith(
          userForm: UserDetails.empty(),
          isEditMode: true,
        ),
      );
      return;
    }

    emit(state.copyWith(status: UserFormStatus.loading));

    // Simulate async fetch
    await Future<void>.delayed(const Duration(milliseconds: 100));

    final userDetails = UserDetails.loaded();
    emit(
      state.copyWith(
        status: UserFormStatus.success,
        userDetails: userDetails,
        userForm: userDetails,
        isEditMode: false,
      ),
    );
  }

  void toggleEditMode() {
    emit(state.copyWith(isEditMode: !state.isEditMode));
  }

  void updateFirstName(String? value) {
    // In real app, would update userForm
  }

  void updateLastName(String? value) {
    // In real app, would update userForm
  }

  void updateEmail(String? value) {
    // In real app, would update userForm
  }
}

// This is the exact pattern from the user's code
class UserFormPage extends StatelessWidget {
  final String? userId;

  const UserFormPage({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    // CRITICAL: Controller is created OUTSIDE the BlocBuilder
    // This is the correct pattern - controller persists across rebuilds
    final formController = VooFormController();

    return BlocProvider(
      create: (context) => UserFormCubit()..fetchUserDetails(userId),
      child: BlocBuilder<UserFormCubit, UserFormState>(
        builder: (context, state) => Scaffold(
          body: VooFormPageBuilder(
            controller: formController,
            isSubmitting: state.status == UserFormStatus.submitting,
            header: Row(
              children: [
                Expanded(
                  child: Text(
                    state.isEditMode ? 'Edit User' : 'View User',
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () => context.read<UserFormCubit>().toggleEditMode(),
                  icon: Icon(
                    state.isEditMode ? Icons.lock_open : Icons.lock,
                    color: state.isEditMode ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
            onCancel: () {},
            onSubmit: (_) {},
            form: VooForm(
              controller: formController,
              key: const Key('user_form'),
              isLoading: state.status == UserFormStatus.loading,
              isReadOnly: !state.isEditMode,
              fields: [
                VooTextField(
                  name: 'first_name',
                  label: 'First Name',
                  hint: 'Enter first name',
                  prefixIcon: const Icon(Icons.person_outline),
                  initialValue: state.isEditMode ? state.userForm.firstName : state.userDetails.firstName,
                  validators: [VooValidator.required()],
                  onChanged: (value) => context.read<UserFormCubit>().updateFirstName(value),
                ),
                VooTextField(
                  name: 'middle_initial',
                  label: 'Middle Initial',
                  hint: 'Enter middle initial',
                  prefixIcon: const Icon(Icons.text_fields),
                  initialValue: state.isEditMode ? state.userForm.middleInitial : state.userDetails.middleInitial,
                  maxLength: 1,
                ),
                VooTextField(
                  name: 'last_name',
                  label: 'Last Name',
                  hint: 'Enter last name',
                  prefixIcon: const Icon(Icons.person_outline),
                  initialValue: state.isEditMode ? state.userForm.lastName : state.userDetails.lastName,
                  validators: [VooValidator.required()],
                  onChanged: (value) => context.read<UserFormCubit>().updateLastName(value),
                ),
                VooTextField(
                  name: 'email',
                  label: 'Email',
                  hint: 'Enter email address',
                  prefixIcon: const Icon(Icons.email),
                  initialValue: state.isEditMode ? state.userForm.email : state.userDetails.email,
                  validators: [VooValidator.required(), VooValidator.email()],
                  onChanged: (value) => context.read<UserFormCubit>().updateEmail(value),
                ),
                VooTextField(
                  name: 'username',
                  label: 'Username',
                  hint: 'Enter username',
                  prefixIcon: const Icon(Icons.person),
                  initialValue: state.isEditMode ? state.userForm.userName : state.userDetails.userName,
                  validators: [VooValidator.required()],
                ),
                VooPhoneField(
                  name: 'phone_number',
                  label: 'Phone Number',
                  hint: 'Enter phone number',
                  prefixIcon: const Icon(Icons.phone),
                  initialValue: state.isEditMode ? state.userForm.phoneNumber : state.userDetails.phoneNumber,
                  validators: [VooValidator.required()],
                ),
                VooDropdownField<String>(
                  name: 'permission_level',
                  label: 'Permission Level',
                  options: const ['Admin', 'User', 'Manager'],
                  displayTextBuilder: (item) => item,
                  optionBuilder: (context, item, isSelected, displayText) => VooOption(
                    title: displayText,
                    isSelected: isSelected,
                  ),
                  initialValue: state.isEditMode ? state.userForm.permissionLevel : state.userDetails.permissionLevel,
                ),
                VooMultiSelectField<String>(
                  name: 'roles',
                  label: 'Roles',
                  options: const ['Manager', 'Reviewer', 'Editor', 'Viewer'],
                  layout: VooFieldLayout.fullWidthField,
                  initialValue: state.isEditMode ? state.userForm.roles : state.userDetails.roles,
                  displayTextBuilder: (item) => item,
                  optionBuilder: (context, item, isSelected, displayText) => VooOption(
                    title: item,
                    isSelected: isSelected,
                    showCheckbox: true,
                    showCheckmark: false,
                  ),
                ),
                VooCheckboxField(
                  name: 'is_analyst_or_researcher',
                  label: 'Is Analyst or Researcher',
                  initialValue: state.isEditMode ? state.userForm.isAnalystOrResearcher : state.userDetails.isAnalystOrResearcher,
                ),
                VooCheckboxField(
                  name: 'is_active',
                  label: 'Active',
                  initialValue: state.isEditMode ? state.userForm.isActive : state.userDetails.isActive,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  group('User Scenario - Initial Values Display Without Readonly Toggle', () {
    testWidgets('EXACT USER SCENARIO: Form displays initial values after async load WITHOUT readonly toggle', (tester) async {
      // This test reproduces the EXACT scenario reported by the user
      // Set a larger test viewport to avoid RenderFlex overflow
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;

      // Add cleanup to reset viewport
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: UserFormPage(userId: '123'),
        ),
      );

      // Initially form is loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for async data to load (fetchUserDetails completes)
      await tester.pump(const Duration(milliseconds: 150));

      // Give extra time for controller updates
      await tester.pump();
      await tester.pump(); // Extra pump for microtask processing

      // CRITICAL ASSERTIONS - These must pass without toggling to readonly
      // The user reports these DON'T show unless toggling to readonly

      // Text fields should display initial values
      expect(
        find.text('John'),
        findsOneWidget,
        reason: 'First name "John" should be displayed without readonly toggle',
      );
      expect(
        find.text('A'),
        findsOneWidget,
        reason: 'Middle initial "A" should be displayed without readonly toggle',
      );
      expect(
        find.text('Doe'),
        findsOneWidget,
        reason: 'Last name "Doe" should be displayed without readonly toggle',
      );
      expect(
        find.text('john.doe@example.com'),
        findsOneWidget,
        reason: 'Email should be displayed without readonly toggle',
      );
      expect(
        find.text('johndoe'),
        findsOneWidget,
        reason: 'Username should be displayed without readonly toggle',
      );
      expect(
        find.text('555-1234'),
        findsOneWidget,
        reason: 'Phone number should be displayed without readonly toggle',
      );

      // Dropdown should show selected value
      expect(
        find.text('Admin'),
        findsOneWidget,
        reason: 'Permission level should be displayed without readonly toggle',
      );

      // Multi-select should show selected values (in readonly mode, they're shown as comma-separated)
      expect(
        find.text('Manager, Reviewer'),
        findsOneWidget,
        reason: 'Roles should be displayed as comma-separated in readonly mode',
      );

      // Checkboxes should be checked appropriately
      final checkboxes = tester.widgetList<Checkbox>(find.byType(Checkbox));
      expect(checkboxes.length, 2, reason: 'Should have 2 checkboxes');

      // Both checkboxes should be checked (isAnalystOrResearcher and isActive are both true)
      for (final checkbox in checkboxes) {
        expect(
          checkbox.value,
          true,
          reason: 'Checkboxes should reflect initial values without readonly toggle',
        );
      }

      // Verify form is in view mode (not edit mode) initially
      expect(find.text('View User'), findsOneWidget);

      // Now toggle to edit mode to ensure values persist
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      // Should now be in edit mode
      expect(find.text('Edit User'), findsOneWidget);

      // Values should STILL be displayed
      expect(
        find.text('John'),
        findsOneWidget,
        reason: 'Values should persist when toggling to edit mode',
      );
      expect(
        find.text('Doe'),
        findsOneWidget,
        reason: 'Values should persist when toggling to edit mode',
      );
      expect(
        find.text('john.doe@example.com'),
        findsOneWidget,
        reason: 'Values should persist when toggling to edit mode',
      );
    });

    testWidgets('Form with controller outside BlocBuilder maintains values across rebuilds', (tester) async {
      // Set a larger test viewport to avoid RenderFlex overflow
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;

      // Add cleanup to reset viewport
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: UserFormPage(userId: '123'),
        ),
      );

      // Wait for data to load
      await tester.pump(const Duration(milliseconds: 150));

      // Verify initial values are displayed (in read-only mode)
      expect(find.text('John'), findsOneWidget);

      // Toggle to edit mode first
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      // Now we should have TextFormField widgets
      // Type in a field to change value
      await tester.enterText(
        find.byType(TextFormField).first,
        'Jane',
      );
      await tester.pump();

      // Toggle edit mode again (causes BlocBuilder rebuild)
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      // Toggle back to edit mode to see the value
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      // User's typed value should be preserved
      expect(find.text('Jane'), findsOneWidget);
      expect(find.text('John'), findsNothing);
    });

    testWidgets('All field types display initial values immediately without readonly', (tester) async {
      // Create a simpler test with just the form
      final formController = VooFormController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              controller: formController,
              fields: [
                const VooTextField(
                  name: 'text',
                  label: 'Text',
                  initialValue: 'Initial Text',
                ),
                const VooEmailField(
                  name: 'email',
                  label: 'Email',
                  initialValue: 'test@example.com',
                ),
                const VooPhoneField(
                  name: 'phone',
                  label: 'Phone',
                  initialValue: '555-1234',
                ),
                const VooNumberField(
                  name: 'number',
                  label: 'Number',
                  initialValue: 42.5,
                ),
                VooIntegerField(
                  name: 'integer',
                  label: 'Integer',
                  initialValue: 100,
                ),
                VooDecimalField(
                  name: 'decimal',
                  label: 'Decimal',
                  initialValue: 99.99,
                ),
                const VooCurrencyField(
                  name: 'currency',
                  label: 'Currency',
                  initialValue: 1234.56,
                ),
                VooPercentageField(
                  name: 'percentage',
                  label: 'Percentage',
                  initialValue: 75.5,
                ),
                const VooMultilineField(
                  name: 'multiline',
                  label: 'Multiline',
                  initialValue: 'Line 1\nLine 2',
                ),
                const VooDropdownField<String>(
                  name: 'dropdown',
                  label: 'Dropdown',
                  options: ['Option 1', 'Option 2', 'Option 3'],
                  initialValue: 'Option 2',
                ),
                const VooMultiSelectField<String>(
                  name: 'multiselect',
                  label: 'Multi Select',
                  options: ['A', 'B', 'C', 'D'],
                  initialValue: ['B', 'D'],
                ),
                const VooCheckboxField(
                  name: 'checkbox',
                  label: 'Checkbox',
                  initialValue: true,
                ),
                const VooBooleanField(
                  name: 'boolean',
                  label: 'Boolean',
                  initialValue: true,
                ),
              ],
            ),
          ),
        ),
      );

      // All values should be displayed immediately
      expect(find.text('Initial Text'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('555-1234'), findsOneWidget);
      expect(find.text('42.5'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
      expect(find.text('99.99'), findsOneWidget);
      expect(find.text('\$1,234.56'), findsOneWidget);
      expect(find.text('75.5'), findsOneWidget);
      expect(find.text('Line 1\nLine 2'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('D'), findsOneWidget);

      // Check boolean fields
      final checkboxes = tester.widgetList<Checkbox>(find.byType(Checkbox));
      for (final checkbox in checkboxes) {
        expect(checkbox.value, true);
      }

      final switches = tester.widgetList<Switch>(find.byType(Switch));
      for (final switchWidget in switches) {
        expect(switchWidget.value, true);
      }
    });

    testWidgets('VooFormPageBuilder with external controller displays initial values', (tester) async {
      // Set a larger test viewport to avoid RenderFlex overflow
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;

      // Add cleanup to reset viewport
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final formController = VooFormController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooFormPageBuilder(
              controller: formController,
              header: const Text('Test Form'),
              onSubmit: (_) {},
              form: VooForm(
                controller: formController,
                fields: const [
                  VooTextField(
                    name: 'field1',
                    label: 'Field 1',
                    initialValue: 'Initial Value 1',
                  ),
                  VooTextField(
                    name: 'field2',
                    label: 'Field 2',
                    initialValue: 'Initial Value 2',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Values should be displayed
      expect(find.text('Initial Value 1'), findsOneWidget);
      expect(find.text('Initial Value 2'), findsOneWidget);
    });
  });
}
