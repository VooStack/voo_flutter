import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voo_forms/voo_forms.dart';

// Simulating exact user scenario
class UserState {
  final Map<String, dynamic> userDetails;
  final Map<String, dynamic> userForm;
  final bool isEditMode;
  final bool isLoading;

  UserState({
    this.userDetails = const {},
    this.userForm = const {},
    this.isEditMode = false,
    this.isLoading = false,
  });
}

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserState());

  Future<void> fetchUserDetails(String? userId) async {
    if (userId == null) return;
    
    emit(UserState(isLoading: true));
    
    // Simulate async fetch
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Emit loaded data
    emit(UserState(
      isLoading: false,
      userDetails: {
        'firstName': 'John',
        'lastName': 'Doe',
        'email': 'john.doe@example.com',
        'phoneNumber': '555-1234',
        'isActive': true,
      },
      userForm: {
        'firstName': 'John',
        'lastName': 'Doe',
        'email': 'john.doe@example.com',
        'phoneNumber': '555-1234',
        'isActive': true,
      },
    ));
  }
}

void main() {
  group('User Exact Scenario', () {
    testWidgets('Controller outside BlocBuilder with async data loads initial values', (tester) async {
      // This is EXACTLY how the user structures their code
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              // Controller created OUTSIDE BlocBuilder - this is correct
              final formController = VooFormController();
              
              return BlocProvider(
                create: (context) => UserCubit()..fetchUserDetails('123'),
                child: BlocBuilder<UserCubit, UserState>(
                  builder: (context, state) {
                    return Scaffold(
                      body: VooFormPageBuilder(
                        controller: formController,
                        isSubmitting: false,
                        header: Text(
                          state.isEditMode ? 'Edit User' : 'View User',
                        ),
                        onSubmit: (_) {},
                        form: VooForm(
                          controller: formController,
                          key: const Key('user_form'),
                          isLoading: state.isLoading,
                          isReadOnly: !state.isEditMode, // View mode by default
                          fields: [
                            VooTextField(
                              name: 'first_name',
                              label: 'First Name',
                              initialValue: state.isEditMode 
                                ? state.userForm['firstName'] as String?
                                : state.userDetails['firstName'] as String?,
                            ),
                            VooTextField(
                              name: 'last_name',
                              label: 'Last Name',
                              initialValue: state.isEditMode
                                ? state.userForm['lastName'] as String?
                                : state.userDetails['lastName'] as String?,
                            ),
                            VooTextField(
                              name: 'email',
                              label: 'Email',
                              initialValue: state.isEditMode
                                ? state.userForm['email'] as String?
                                : state.userDetails['email'] as String?,
                            ),
                            VooPhoneField(
                              name: 'phone_number',
                              label: 'Phone Number',
                              initialValue: state.isEditMode
                                ? state.userForm['phoneNumber'] as String?
                                : state.userDetails['phoneNumber'] as String?,
                            ),
                            VooCheckboxField(
                              name: 'is_active',
                              label: 'Active',
                              initialValue: state.isEditMode
                                ? state.userForm['isActive'] as bool?
                                : state.userDetails['isActive'] as bool?,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      );

      // Initially loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // Wait for async data
      await tester.pump(const Duration(milliseconds: 150));
      
      // THE CRITICAL TEST: Values must display WITHOUT toggling readonly
      // User reports these don't show unless toggling to readonly
      
      // In readonly mode (view mode), values are displayed in VooReadOnlyField
      // We should see the values
      expect(find.text('John'), findsOneWidget,
        reason: 'First name should display in view mode');
      expect(find.text('Doe'), findsOneWidget,
        reason: 'Last name should display in view mode');
      expect(find.text('john.doe@example.com'), findsOneWidget,
        reason: 'Email should display in view mode');
      expect(find.text('555-1234'), findsOneWidget,
        reason: 'Phone should display in view mode');
      
      // Checkbox in readonly shows as disabled but checked
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, true,
        reason: 'Checkbox should show as checked in view mode');
    });

    testWidgets('Values display immediately when form starts in edit mode', (tester) async {
      final formController = VooFormController();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              controller: formController,
              isReadOnly: false, // Edit mode
              fields: [
                VooTextField(
                  name: 'first_name',
                  label: 'First Name',
                  initialValue: 'Jane',
                ),
                VooTextField(
                  name: 'email',
                  label: 'Email',
                  initialValue: 'jane@example.com',
                ),
                VooCheckboxField(
                  name: 'active',
                  label: 'Active',
                  initialValue: true,
                ),
              ],
            ),
          ),
        ),
      );

      // Values should display immediately in edit mode
      expect(find.text('Jane'), findsOneWidget);
      expect(find.text('jane@example.com'), findsOneWidget);
      
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
      expect(checkbox.value, true);
    });

    testWidgets('Form handles null initial values gracefully', (tester) async {
      final formController = VooFormController();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VooForm(
              controller: formController,
              fields: [
                VooTextField(
                  name: 'field1',
                  label: 'Field 1',
                  initialValue: null, // Explicitly null
                ),
                VooTextField(
                  name: 'field2',
                  label: 'Field 2',
                  // No initialValue provided
                ),
              ],
            ),
          ),
        ),
      );

      // Form should render without errors
      expect(find.byType(VooForm), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
    });
  });
}