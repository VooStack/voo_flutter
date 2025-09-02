# VooListField Migration Guide

## Old Factory Pattern (DEPRECATED)
```dart
VooField.list<Note>(
  name: 'note',
  label: 'Add Note',
  initialItems: state.isEditMode ? state.orderForm.notes : state.orderDetails.notes ?? [],
  onAddItem: (item) => context.read<OrderFormCubit>().addNote(item),
  onEditItem: (index, item) => context.read<OrderFormCubit>().updateNotesAtIndex(index, item),
  onRemoveItem: (index, item) => context.read<OrderFormCubit>().removeNoteAtIndex(index),
  itemTemplate: VooFormField(
    id: 'notes',
    label: 'Note',
    name: 'note_item',
    prefixIcon: Icons.note,
    validators: [VooValidator.required()],
    type: VooFieldType.text,
  ),
),
```

## New Direct Widget Pattern (Stateless)
```dart
VooListField<Note>(
  name: 'note',
  label: 'Add Note',
  items: state.notes,  // Your state - managed externally
  itemBuilder: (context, note, index) => VooTextField(
    name: 'note_$index',
    label: 'Note ${index + 1}',
    initialValue: note.text,
    prefixIcon: Icon(Icons.note),
    onChanged: (value) => context.read<OrderFormCubit>().updateNoteAt(index, value),
  ),
  onAddPressed: () => context.read<OrderFormCubit>().addNote(Note()),
  onRemovePressed: (index) => context.read<OrderFormCubit>().removeNoteAt(index),
  onReorder: (oldIndex, newIndex) => context.read<OrderFormCubit>().reorderNotes(oldIndex, newIndex),
)
```

## Key Differences

1. **Direct instantiation**: Use `VooListField<T>()` instead of `VooField.list<T>()`
2. **Stateless design**: VooListField doesn't manage state - you provide items and handle callbacks
3. **Item builder**: Use `itemBuilder` to create widgets for each item dynamically
4. **External state management**: You manage the list state in your StatefulWidget or state management solution
5. **Simplified callbacks**: Just `onAddPressed`, `onRemovePressed`, and `onReorder`

## Complete Example with State Management

```dart
import 'package:flutter/material.dart';
import 'package:voo_forms/voo_forms.dart';

class NotesListExample extends StatefulWidget {
  @override
  State<NotesListExample> createState() => _NotesListExampleState();
}

class _NotesListExampleState extends State<NotesListExample> {
  List<String> notes = ['First note'];
  
  void _addNote() {
    setState(() {
      notes.add('New note ${notes.length + 1}');
    });
  }
  
  void _removeNote(int index) {
    setState(() {
      notes.removeAt(index);
    });
  }
  
  void _reorderNotes(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final note = notes.removeAt(oldIndex);
      notes.insert(newIndex, note);
    });
  }
  
  void _updateNote(int index, String value) {
    setState(() {
      notes[index] = value;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return VooListField<String>(
      name: 'notes',
      label: 'Notes',
      helper: 'Add your notes here',
      items: notes,  // Pass your state
      itemBuilder: (context, note, index) => VooTextField(
        name: 'note_$index',
        initialValue: note,
        placeholder: 'Enter your note...',
        prefixIcon: const Icon(Icons.note),
        onChanged: (value) => _updateNote(index, value ?? ''),
      ),
      showItemNumbers: true,
      canReorderItems: true,
      addButtonText: 'Add Note',
      onAddPressed: _addNote,
      onRemovePressed: _removeNote,
      onReorder: _reorderNotes,
    );
  }
}
```

## Features

- **Stateless design**: No internal state management - you control everything
- **Flexible item builder**: Create any widget for each item
- **Dynamic operations**: Add, remove, and reorder items through callbacks
- **Customization**: Custom buttons, icons, decorations, and spacing
- **Item numbering**: Optional automatic item numbering
- **Empty state**: Custom widget when list is empty
- **Validation**: Integrates with form validation
- **Accessibility**: Full keyboard and screen reader support

## Important Notes

- **State Management**: VooListField is completely stateless. You must manage the list items in your own state (StatefulWidget, BLoC, Provider, etc.)
- **Item Builder**: The `itemBuilder` function receives the item and index, allowing you to create the appropriate widget
- **Callbacks**: All callbacks are optional but you need to provide them for the corresponding functionality to work
- **Performance**: Since the widget doesn't manage state, it's very efficient and rebuilds only when your state changes