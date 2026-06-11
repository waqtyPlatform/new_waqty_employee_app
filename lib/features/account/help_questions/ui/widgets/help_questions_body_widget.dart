import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/features/account/help_questions/ui/widgets/help_contact_card_widget.dart';
import 'package:new_waqty_employee_app/features/account/help_questions/ui/widgets/help_faq_section_widget.dart';
import 'package:new_waqty_employee_app/features/account/help_questions/ui/widgets/help_search_widget.dart';

class HelpQuestionsBodyWidget extends StatelessWidget {
  const HelpQuestionsBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
      child: Column(
        children: const [
          HelpSearchWidget(),
          SizedBox(height: 12),
          HelpFaqSectionWidget(
            titleKey: 'helpFaq.scheduling',
            questions: [
              HelpFaqItemData(
                questionKey: 'helpFaq.viewBookingsQuestion',
                answerKey: 'helpFaq.viewBookingsAnswer',
                isExpanded: true,
              ),
              HelpFaqItemData(questionKey: 'helpFaq.noShowQuestion'),
              HelpFaqItemData(questionKey: 'helpFaq.addServicesQuestion'),
            ],
          ),
          SizedBox(height: 12),
          HelpFaqSectionWidget(
            titleKey: 'helpFaq.earnings',
            questions: [
              HelpFaqItemData(questionKey: 'helpFaq.commissionQuestion'),
              HelpFaqItemData(questionKey: 'helpFaq.extractionQuestion'),
              HelpFaqItemData(questionKey: 'helpFaq.paidQuestion'),
              HelpFaqItemData(questionKey: 'helpFaq.payslipsQuestion'),
            ],
          ),
          SizedBox(height: 12),
          HelpFaqSectionWidget(
            titleKey: 'helpFaq.account',
            questions: [
              HelpFaqItemData(questionKey: 'helpFaq.changePinQuestion'),
              HelpFaqItemData(questionKey: 'helpFaq.biometricQuestion'),
            ],
          ),
          SizedBox(height: 12),
          HelpFaqSectionWidget(
            titleKey: 'helpFaq.attendance',
            questions: [
              HelpFaqItemData(questionKey: 'helpFaq.lateArrivalQuestion'),
              HelpFaqItemData(questionKey: 'helpFaq.deductionsQuestion'),
            ],
          ),
          SizedBox(height: 12),
          HelpContactCardWidget(),
        ],
      ),
    );
  }
}
