import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/features/account/help_questions/logic/help_questions_cubit.dart';
import 'package:new_waqty_employee_app/features/account/help_questions/ui/widgets/help_questions_body_widget.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_header_widget.dart';

class HelpQuestionsScreen extends StatefulWidget {
  const HelpQuestionsScreen({super.key});

  @override
  State<HelpQuestionsScreen> createState() => _HelpQuestionsScreenState();
}

class _HelpQuestionsScreenState extends State<HelpQuestionsScreen> {
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      _isLoaded = true;
      HelpQuestionsCubit.get(context).getFaqs(context.locale.languageCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            AccountSupportHeaderWidget(titleKey: 'helpFaq.title'),
            Expanded(child: HelpQuestionsBodyWidget()),
          ],
        ),
      ),
    );
  }
}
