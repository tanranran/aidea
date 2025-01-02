import 'package:askaide/helper/ability.dart';
import 'package:askaide/lang/lang.dart';
import 'package:askaide/page/component/credit.dart';
import 'package:askaide/page/component/enhanced_button.dart';
import 'package:askaide/page/component/theme/custom_size.dart';
import 'package:askaide/page/component/theme/custom_theme.dart';
import 'package:askaide/repo/api/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountQuotaCard extends StatelessWidget {
  final UserInfo? userInfo;
  final VoidCallback? onPaymentReturn;
  final bool noBorder;
  const AccountQuotaCard(
      {super.key, this.userInfo, this.onPaymentReturn, this.noBorder = false});

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Container(
      margin: noBorder
          ? null
          : const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      height: 120,
      child: Container(
        padding: noBorder
            ? const EdgeInsets.only(
                top: 5,
                left: 20,
                right: 20,
                bottom: 0,
              )
            : const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 30,
              ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppLocale.usage.getString(context),
                        style: TextStyle(
                          fontSize: 18,
                          color: customColors.backgroundInvertedColor,
                        ),
                      ),
                      const SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          launchUrl(
                            Uri.parse('https://ai.aicode.cc/zhihuiguo.html'),
                          );
                        },
                        child: Icon(
                          Icons.help,
                          size: 14,
                          color: customColors.weakTextColor?.withAlpha(150),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (userInfo != null)
                        InkWell(
                          onTap: () {
                            context.push('/quota-usage-statistics');
                          },
                          borderRadius: CustomSize.borderRadiusAll,
                          child: Credit(
                            count: userInfo!.quota.quotaRemain(),
                            color: customColors.backgroundInvertedColor,
                          ),
                        )
                      else
                        const Text('-'),
                      const SizedBox(width: 5),
                    ],
                  ),
                ],
              ),
            ),
            if (Ability().enablePayment)
              EnhancedButton(
                onPressed: () {
                  context.push('/payment').whenComplete(() {
                    if (onPaymentReturn != null) {
                      onPaymentReturn!();
                    }
                  });
                },
                title: AppLocale.buy.getString(context),
                backgroundColor: customColors.linkColor,
                width: 70,
                height: 35,
                fontSize: 14,
              ),
          ],
        ),
      ),
    );
  }
}
