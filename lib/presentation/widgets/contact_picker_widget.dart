import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:globeporter/l10n/app_localizations.dart';
import 'package:globeporter/resources/app_colors.dart';
import 'package:globeporter/resources/app_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ContactPickerScreen extends StatefulWidget {
  const ContactPickerScreen({super.key});

  @override
  State<ContactPickerScreen> createState() => _ContactPickerScreenState();
}

class _ContactPickerScreenState extends State<ContactPickerScreen> {
  final ItemScrollController _scrollController = ItemScrollController();
  final Map<String, int> _letterIndexMap = {};
  List<_ContactGroupItem> _groupedList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    if (await FlutterContacts.requestPermission()) {
      final contacts = await FlutterContacts.getContacts(withProperties: true);

      contacts.sort((a, b) => a.displayName.compareTo(b.displayName));
      final grouped = <String, List<Contact>>{};
      for (final contact in contacts) {
        final firstLetter =
            contact.displayName.isNotEmpty ? contact.displayName[0].toUpperCase() : '#';
        grouped.putIfAbsent(firstLetter, () => []).add(contact);
      }

      final flatList = <_ContactGroupItem>[];
      int index = 0;
      for (var entry in grouped.entries) {
        _letterIndexMap[entry.key] = index;
        flatList.add(_ContactGroupItem(header: entry.key));
        index++;
        for (final contact in entry.value) {
          flatList.add(_ContactGroupItem(contact: contact));
          index++;
        }
      }

      setState(() {
        _groupedList = flatList;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  void scrollToLetter(String letter) {
    final index = _letterIndexMap[letter];
    if (index != null) {
      _scrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget buildLetterScroller() {
    final letters = _letterIndexMap.keys.toList()..sort();

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: letters.map((letter) {
            return GestureDetector(
              onTap: () => scrollToLetter(letter),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  letter,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: primaryColor),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(size.width * 0.25),
        child: CustomStatusBarWidget(
          title: AppLocalizations.of(context)!.selectContactString,
          fontSize: 22,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                ScrollablePositionedList.builder(
                  itemScrollController: _scrollController,
                  itemCount: _groupedList.length,
                  padding: const EdgeInsets.only(right: 30),
                  itemBuilder: (context, index) {
                    final item = _groupedList[index];
                    if (item.header != null) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        child: Text(
                          item.header!,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      );
                    } else if (item.contact != null) {
                      final contact = item.contact!;
                      final rawPhone = contact.phones.isNotEmpty
                          ? contact.phones.first.number
                          : 'No phone number';

                      var phone = rawPhone.replaceAll(RegExp(r'\D'), '');
                      return ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(contact.displayName),
                        subtitle: Text(phone),
                        onTap: () {
                          var phoneVal = phone;
                          if (phoneVal.startsWith('91') && phoneVal.length > 10) {
                            phoneVal = phoneVal.substring(phoneVal.length - 10);
                          }
                          context.pop({
                            'name': contact.displayName,
                            'phone': phoneVal,
                          });
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
                buildLetterScroller(),
              ],
            ),
    );
  }
}

class _ContactGroupItem {
  final String? header;
  final Contact? contact;

  _ContactGroupItem({this.header, this.contact});
}
