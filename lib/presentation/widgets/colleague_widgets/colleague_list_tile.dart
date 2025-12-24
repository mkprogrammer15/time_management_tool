import 'package:audavis_time_management/domain/entities/colleague_entity.dart';
import 'package:audavis_time_management/presentation/widgets/colleague_widgets/colleague_leaves_widget.dart';
import 'package:audavis_time_management/presentation/widgets/avatar_widgets/custom_avatar.dart';
import 'package:audavis_time_management/presentation/widgets/avatar_widgets/upload_avatar_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Widget representing a colleague in a list tile.
class ColleagueListTile extends StatelessWidget {
  final ColleagueEntity colleague;
  final bool selected;
  final VoidCallback onTap;

  final String myId;
  final String myRole;

  const ColleagueListTile({
    super.key,
    required this.colleague,
    required this.selected,
    required this.onTap,
    required this.myId,
    required this.myRole,
  });

  @override
  Widget build(BuildContext context) {
    final bool iAmAdmin = myRole == 'admin';
    final bool isMe = colleague.id == myId;

    final bool canSeeVacationInfo = iAmAdmin || isMe;

    final hoverAvatar = ValueNotifier<bool>(false);

    return InkWell(
      onTap: onTap,
      child: Container(
        color: isMe ? Colors.grey.shade200 : null,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            MouseRegion(
              onEnter: (_) => hoverAvatar.value = true,
              onExit: (_) => hoverAvatar.value = false,
              cursor: isMe
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.basic,
              child: ValueListenableBuilder<bool>(
                valueListenable: hoverAvatar,
                builder: (context, isHover, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomAvatar(
                        imageUrl: colleague.avatarUrl,
                        name: colleague.name,
                        onTap: isMe
                            ? () async {
                                await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return UploadAvatarDialog(
                                      colleagueId: myId,
                                    );
                                  },
                                );
                              }
                            : null,
                      ),
                      if (isHover && isMe)
                        Positioned.fill(
                          child: IgnorePointer(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(120),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.photo_camera_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          colleague.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),

                      if (canSeeVacationInfo)
                        Text(
                          ' Gesamt: ${colleague.totalVacations} / Verbleiben: ${colleague.restVacations}',
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        colleague.team,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (isMe)
                        InkWell(
                          onTap: () async => await showDialog(
                            context: context,
                            builder: (ctx) => Dialog.fullscreen(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 20,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          onPressed: () => context.pop(),
                                          icon: Icon(Icons.arrow_back),
                                        ),
                                      ],
                                    ),
                                    ColleagueLeavesWidget(
                                      colleagueId: colleague.id,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          child: Icon(Icons.arrow_circle_right_outlined),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
