import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordly/data/services/analytics_service.dart';
import 'package:wordly/utils/snackbar/showcustom_snackbar.dart';
import 'package:wordly/view_model/gameview_model.dart';
import 'package:wordly/views/feedbacks/model/feedback_model.dart';
import 'package:wordly/views/feedbacks/service/feedback_service.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final _emailController = TextEditingController();
  final _feedbackService = FeedbackService();

  FeedbackType _selectedType = FeedbackType.bug;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _messageController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final gameProvider = context.read<GameProvider>();
    final feedback = FeedbackModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: _selectedType,
      message: _messageController.text.trim(),
      userEmail: _emailController.text.trim(),
      timestamp: DateTime.now(),
      currentScore: gameProvider.score,
      currentStreak: gameProvider.streak,
    );

    final success = await _feedbackService.submitFeedback(feedback);

    setState(() => _isSubmitting = false);

    if (success && mounted) {
      CustomSnackBar.showSnackBarSafely(
        context,
        'Thank you for your feedback!',
        const Color(0xffAAD174),
      );

      _messageController.clear();
      _emailController.clear();

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) Navigator.pop(context);
      });
    } else if (mounted) {
      CustomSnackBar.showSnackBarSafely(
        context,
        'Failed to submit feedback. Please try again.',
        Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 900;
    final isMediumScreen = screenWidth > 600 && screenWidth <= 900;
    final maxWidth = isLargeScreen ? 700.0 : (isMediumScreen ? 550.0 : double.infinity);

    return Scaffold(
      backgroundColor: const Color(0xffF5FFFA),
      appBar: AppBar(
        backgroundColor: const Color(0xffE0F4E5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            AnalyticsService.trackEvent(
              eventName: 'feedback_screen_closed',
              properties: {'timestamp': DateTime.now().toIso8601String()},
            );
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Send Feedback',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffE0F4E5), Color(0xffF5FFFA)],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isLargeScreen ? 40 : 20,
                vertical: 20,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(isLargeScreen),
                    const SizedBox(height: 20),
                    _buildFeedbackTypeSection(),
                    const SizedBox(height: 20),
                    _buildEmailField(),
                    const SizedBox(height: 20),
                    _buildMessageField(),
                    const SizedBox(height: 20),
                    _buildSubmitButton(isLargeScreen),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isLargeScreen) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          if (isLargeScreen)
            Row(
              children: [
                const Icon(
                  Icons.feedback_outlined,
                  size: 50,
                  color: Color(0xffFF6B6B),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'We Value Your Feedback!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff00224D),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Help us improve Wordly by sharing your thoughts, reporting bugs, or suggesting new features.',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              children: [
                const Icon(
                  Icons.feedback_outlined,
                  size: 50,
                  color: Color(0xffFF6B6B),
                ),
                const SizedBox(height: 10),
                const Text(
                  'We Value Your Feedback!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff00224D),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Help us improve Wordly by sharing your thoughts, reporting bugs, or suggesting new features.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildFeedbackTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Feedback Type',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff00224D),
          ),
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildTypeChip(
              type: FeedbackType.bug,
              label: '🐛 Bug Report',
              color: const Color(0xffFF6B6B),
            ),
            _buildTypeChip(
              type: FeedbackType.feature,
              label: '✨ Feature Request',
              color: const Color(0xff4ECDC4),
            ),
            _buildTypeChip(
              type: FeedbackType.improvement,
              label: '🚀 Improvement',
              color: const Color(0xffF5CD47),
            ),
            _buildTypeChip(
              type: FeedbackType.other,
              label: '💬 Other',
              color: const Color(0xffA78BFA),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Email (Optional)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff00224D),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Enter your email',
            prefixIcon: const Icon(Icons.email_outlined),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Color(0xffFF6B6B),
                width: 2,
              ),
            ),
          ),
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildMessageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Message',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff00224D),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _messageController,
          maxLines: 8,
          maxLength: 500,
          decoration: InputDecoration(
            hintText: 'Tell us what\'s on your mind...',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Color(0xffFF6B6B),
                width: 2,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your feedback';
            }
            if (value.trim().length < 10) {
              return 'Please provide at least 10 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton(bool isLargeScreen) {
    return Center(
      child: SizedBox(
        width: isLargeScreen ? 300 : double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : _submitFeedback,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xffFF6B6B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            shadowColor: const Color(0xffFF6B6B).withOpacity(0.3),
          ),
          child: _isSubmitting
              ? const SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : const Text(
                  'Submit Feedback',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildTypeChip({
    required FeedbackType type,
    required String label,
    required Color color,
  }) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedType = type);
        AnalyticsService.trackEvent(
          eventName: 'feedback_type_selected',
          properties: {'type': type.name},
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}