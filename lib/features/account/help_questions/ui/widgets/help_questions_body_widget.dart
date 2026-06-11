import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/help_questions/logic/help_questions_cubit.dart';
import 'package:new_waqty_employee_app/features/account/help_questions/logic/help_questions_state.dart';
import 'package:new_waqty_employee_app/features/account/help_questions/ui/widgets/help_contact_card_widget.dart';
import 'package:new_waqty_employee_app/features/account/help_questions/ui/widgets/help_faq_section_widget.dart';
import 'package:new_waqty_employee_app/features/account/help_questions/ui/widgets/help_search_widget.dart';

class HelpQuestionsBodyWidget extends StatelessWidget {
  const HelpQuestionsBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HelpQuestionsCubit, HelpQuestionsState>(
      buildWhen: (previous, current) =>
          current is GetFaqsLoadingState ||
          current is GetFaqsSuccessState ||
          current is GetFaqsErrorState ||
          current is GetFaqsCatchErrorState ||
          current is HelpFaqSearchChangedState ||
          current is HelpFaqExpandedChangedState,
      builder: (context, state) {
        final cubit = HelpQuestionsCubit.get(context);

        if (state is GetFaqsLoadingState && cubit.faqs.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.greenColor500),
          );
        }

        return RefreshIndicator(
          color: AppColors.greenColor500,
          onRefresh: () async {
            cubit.getFaqs(context.locale.languageCode);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
            child: Column(
              children: [
                HelpSearchWidget(
                  controller: cubit.searchController,
                  onChanged: cubit.searchFaqs,
                ),
                SizedBox(height: 12.h),
                if (cubit.filteredFaqs.isEmpty)
                  SizedBox(
                    height: 180.h,
                    child: Center(
                      child: Text(
                        context.tr('helpFaq.noFaqsFound'),
                        style: TextStyles.font14greyColor900Weight500,
                      ),
                    ),
                  )
                else
                  HelpFaqSectionWidget(
                    titleKey: 'helpFaq.faqs',
                    questions: List.generate(cubit.filteredFaqs.length, (
                      index,
                    ) {
                      final faq = cubit.filteredFaqs[index];
                      return HelpFaqItemData(
                        uuid: faq.uuid,
                        question: faq.question,
                        answer: faq.answer,
                        isExpanded: cubit.expandedFaqUuid == faq.uuid,
                      );
                    }),
                    onQuestionTap: cubit.toggleFaq,
                  ),
                SizedBox(height: 12.h),
                const HelpContactCardWidget(),
              ],
            ),
          ),
        );
      },
    );
  }
}
