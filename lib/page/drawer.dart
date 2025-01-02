import 'package:askaide/bloc/account_bloc.dart';
import 'package:askaide/bloc/chat_chat_bloc.dart';
import 'package:askaide/helper/platform.dart';
import 'package:askaide/lang/lang.dart';
import 'package:askaide/page/component/account_quota_card.dart';
import 'package:askaide/page/component/theme/custom_theme.dart';
import 'package:askaide/repo/api/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LeftDrawer extends StatefulWidget {
  const LeftDrawer({super.key});

  @override
  State<LeftDrawer> createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  @override
  void initState() {
    super.initState();

    context.read<AccountBloc>().add(AccountLoadEvent(cache: false));
    context.read<ChatChatBloc>().add(ChatChatLoadRecentHistories());
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      backgroundColor: customColors.backgroundColor,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 160,
                      child: DrawerHeader(
                        padding: PlatformTool.isMacOS()
                            ? const EdgeInsets.only(top: kToolbarHeight)
                            : const EdgeInsets.only(top: 20),
                        margin: const EdgeInsets.all(0),
                        // decoration: BoxDecoration(
                        //   color: Colors.white,
                        //   image: DecorationImage(
                        //     image: CachedNetworkImageProviderEnhanced(
                        //       "https://ssl.aicode.cc/ai-server/assets/quota-card-bg.webp-thumb1000",
                        //     ),
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),
                        child: BlocBuilder<AccountBloc, AccountState>(
                          builder: (_, state) {
                            UserInfo? userInfo;
                            if (state is AccountLoaded) {
                              userInfo = state.user;
                            }

                            return AccountQuotaCard(
                              userInfo: userInfo,
                              noBorder: true,
                              onPaymentReturn: () {
                                if (userInfo != null) {
                                  context.read<AccountBloc>().add(AccountLoadEvent(cache: false));
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    BlocBuilder<ChatChatBloc, ChatChatState>(
                      buildWhen: (previous, current) => current is ChatChatRecentHistoriesLoaded,
                      builder: (_, state) {
                        if (state is ChatChatRecentHistoriesLoaded) {
                          return ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(0),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.histories.length,
                            itemBuilder: (context, index) {
                              final item = state.histories[index];
                              return ListTile(
                                leading: const Icon(Icons.question_answer_outlined),
                                title: Text(
                                  item.title ?? 'Unknown',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () {
                                  context.push(
                                      '/chat-anywhere?chat_id=${item.id}&model=${item.model}&title=${item.title}');
                                },
                              );
                            },
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(AppLocale.moreHistories.getString(context)),
                      onTap: () {
                        context.push('/chat-chat/history').whenComplete(() {
                          context.read<ChatChatBloc>().add(ChatChatLoadRecentHistories());
                        });
                      },
                    ),
                    Divider(
                      color: customColors.weakTextColor?.withAlpha(50),
                      height: 10,
                      indent: 10,
                      endIndent: 10,
                    ),
                    ListTile(
                      leading: const Icon(Icons.group_outlined),
                      title: Text(AppLocale.homeTitle.getString(context)),
                      onTap: () {
                        context.push('/characters');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.auto_awesome_outlined),
                      title: Text(AppLocale.discover.getString(context)),
                      onTap: () {
                        context.push('/creative-gallery');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.palette_outlined),
                      title: Text(AppLocale.creativeIsland.getString(context)),
                      onTap: () {
                        context.push('/creative-draw');
                      },
                    ),
                    Divider(
                      color: customColors.weakTextColor?.withAlpha(50),
                      height: 10,
                      indent: 10,
                      endIndent: 10,
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings_outlined),
                      title: Text(AppLocale.settings.getString(context)),
                      onTap: () {
                        context.push('/setting');
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 90,
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "${AppLocale.socialMedia.getString(context)} ",
                        style: TextStyle(
                          color: customColors.weakTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Transform.rotate(
                        angle: 90 * 3.1415926535897932 / 180,
                        child: Icon(
                          Icons.turn_right,
                          color: customColors.weakTextColor,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          launchUrlString(
                            'https://ai.aicode.cc/social/home',
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        child: Image.asset('assets/app-256-transparent.png', width: 25),
                      ),
                      GestureDetector(
                        onTap: () {
                          launchUrlString(
                            'https://weibo.com/code404',
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        child: Image.asset('assets/weibo.png', width: 25),
                      ),
                      GestureDetector(
                        onTap: () {
                          launchUrlString(
                            'https://ai.aicode.cc/social/github',
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        child: Image.asset('assets/github.png', width: 25),
                      ),
                      GestureDetector(
                        onTap: () {
                          launchUrlString(
                            'https://ai.aicode.cc/social/wechat-platform',
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        child: Image.asset('assets/wechat.png', width: 25),
                      ),
                      GestureDetector(
                        onTap: () {
                          launchUrlString(
                            'https://ai.aicode.cc/social/x',
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        child: Image.asset('assets/x.png', width: 25),
                      ),
                      GestureDetector(
                        onTap: () {
                          launchUrlString(
                            'https://ai.aicode.cc/social/xiaohongshu',
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        child: Image.asset('assets/xiaohongshu.png', width: 25),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
