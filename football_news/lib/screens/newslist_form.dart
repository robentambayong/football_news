import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:football_news/screens/menu.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class NewsFormPage extends StatefulWidget {
  const NewsFormPage({super.key});

  @override
  State<NewsFormPage> createState() => _NewsFormPageState();
}

class _NewsFormPageState extends State<NewsFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _content = "";
  String _category = "";
  String _thumbnail = "";
  bool _isFeatured = false;

  @override
  Widget build(BuildContext context) {
    // Get the request object from the provider
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New News'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'News Title',
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _title = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Title cannot be empty!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'News Content',
                  labelText: 'Content',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                ),
                maxLines: 5,
                onChanged: (String? value) {
                  setState(() {
                    _content = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Content cannot be empty!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'e.g., match, transfer, update',
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _category = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Category cannot be empty!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Image URL',
                  labelText: 'Thumbnail URL',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _thumbnail = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Thumbnail URL cannot be empty!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              CheckboxListTile(
                title: const Text('Is Featured?'),
                value: _isFeatured,
                onChanged: (bool? value) {
                  setState(() {
                    _isFeatured = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Send data to Django backend
                    final response = await request.postJson(
                      "http://localhost:8000/create-flutter/",
                      jsonEncode({
                        "title": _title,
                        "content": _content,
                        "thumbnail": _thumbnail,
                        "category": _category,
                        "is_featured": _isFeatured,
                      }),
                    );
                    if (context.mounted) {
                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("News successfully saved!"),
                        ));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Something went wrong, please try again."),
                        ));
                      }
                    }
                  }
                },
                child: const Text(
                  'Save News',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}