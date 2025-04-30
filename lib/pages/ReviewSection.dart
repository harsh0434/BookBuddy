import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/book_model.dart';

class ReviewSection extends StatefulWidget {
  final BookModel book;
  const ReviewSection({Key? key, required this.book}) : super(key: key);

  @override
  State<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 3.0;
  late DatabaseReference _reviewRef;
  List<Map<dynamic, dynamic>> _reviews = [];
  String? _editingReviewKey;

  @override
  void initState() {
    super.initState();
    _reviewRef = FirebaseDatabase.instance
        .ref()
        .child('reviews')
        .child(widget.book.isbn ?? 'unknown');
    _fetchReviews();
  }

  void _fetchReviews() {
    _reviewRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null && data is Map) {
        setState(() {
          _reviews = (data as Map)
              .values
              .map((e) => Map<dynamic, dynamic>.from(e))
              .toList()
              .reversed
              .toList();
        });
      } else {
        setState(() {
          _reviews = [];
        });
      }
    });
  }

  void _submitReview() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      final review = {
        'userId': user.uid,
        'username': user.displayName ?? 'Anonymous',
        'rating': _rating,
        'comment': _reviewController.text.trim(),
        'timestamp': DateTime.now().toIso8601String(),
      };
      await _reviewRef.push().set(review);
      _reviewController.clear();
      setState(() {
        _rating = 3.0;
      });
    }
  }

  void _startEditReview(String key, Map review) {
    setState(() {
      _editingReviewKey = key;
      _reviewController.text = review['comment'] ?? '';
      _rating = (review['rating'] ?? 3.0).toDouble();
    });
  }

  void _cancelEdit() {
    setState(() {
      _editingReviewKey = null;
      _reviewController.clear();
      _rating = 3.0;
    });
  }

  void _updateReview() async {
    if (_formKey.currentState!.validate() && _editingReviewKey != null) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      final review = {
        'userId': user.uid,
        'username': user.displayName ?? 'Anonymous',
        'rating': _rating,
        'comment': _reviewController.text.trim(),
        'timestamp': DateTime.now().toIso8601String(),
      };
      await _reviewRef.child(_editingReviewKey!).set(review);
      _cancelEdit();
    }
  }

  void _deleteReview(String key) async {
    await _reviewRef.child(key).remove();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Reviews",
            style: GoogleFonts.ubuntu(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF3F51B5),
            ),
          ),
          const SizedBox(height: 16),
          if (_reviews.isEmpty)
            Text(
              "No reviews yet. Be the first to review!",
              style: GoogleFonts.ubuntu(fontSize: 14, color: Colors.grey[600]),
            ),
          ..._reviews.asMap().entries.map((entry) {
            final idx = entry.key;
            final review = entry.value;
            final reviewKey =
                _reviewRef.orderByKey().onValue.first.then((event) {
              final data = event.snapshot.value;
              if (data is Map) {
                return data.keys.toList()[idx];
              }
              return null;
            });
            return FutureBuilder(
              future: reviewKey,
              builder: (context, snapshot) {
                final key = snapshot.data;
                return _buildReviewTile(review, key, user);
              },
            );
          }).toList(),
          const Divider(height: 32),
          Text(
            _editingReviewKey == null ? "Add Your Review" : "Edit Your Review",
            style: GoogleFonts.ubuntu(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF3F51B5),
            ),
          ),
          const SizedBox(height: 8),
          if (user == null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'You must be logged in to submit a review.',
                style: GoogleFonts.ubuntu(color: Colors.red),
              ),
            )
          else
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Rating:", style: GoogleFonts.ubuntu(fontSize: 14)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Slider(
                          value: _rating,
                          min: 1,
                          max: 5,
                          divisions: 4,
                          label: _rating.toStringAsFixed(1),
                          onChanged: (value) {
                            setState(() {
                              _rating = value;
                            });
                          },
                        ),
                      ),
                      Text(_rating.toStringAsFixed(1)),
                    ],
                  ),
                  TextFormField(
                    controller: _reviewController,
                    decoration: const InputDecoration(
                      labelText: 'Write your review',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your review';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (_editingReviewKey != null)
                        TextButton(
                          onPressed: _cancelEdit,
                          child: const Text('Cancel'),
                        ),
                      ElevatedButton(
                        onPressed: _editingReviewKey == null
                            ? _submitReview
                            : _updateReview,
                        child: Text(
                            _editingReviewKey == null ? 'Submit' : 'Update'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReviewTile(Map review, String? key, User? user) {
    final isOwner = user != null && review['userId'] == user.uid;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, size: 20, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                review['username'] ?? 'Anonymous',
                style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Icon(Icons.star, color: Colors.amber[700], size: 18),
              Text(
                review['rating'].toString(),
                style: GoogleFonts.ubuntu(fontSize: 14),
              ),
              if (isOwner && key != null) ...[
                IconButton(
                  icon: const Icon(Icons.edit, size: 18, color: Colors.blue),
                  tooltip: 'Edit',
                  onPressed: () => _startEditReview(key, review),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                  tooltip: 'Delete',
                  onPressed: () => _deleteReview(key),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            review['comment'] ?? '',
            style: GoogleFonts.ubuntu(fontSize: 14),
          ),
          if (review['timestamp'] != null)
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                _formatTimestamp(review['timestamp']),
                style:
                    GoogleFonts.ubuntu(fontSize: 10, color: Colors.grey[600]),
              ),
            ),
        ],
      ),
    );
  }

  String _formatTimestamp(String isoString) {
    final dt = DateTime.tryParse(isoString);
    if (dt == null) return '';
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }
}
