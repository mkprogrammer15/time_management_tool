import 'package:audavis_time_management/domain/entities/colleague_entity.dart';
import 'package:audavis_time_management/presentation/widgets/custom_avatar.dart';
import 'package:audavis_time_management/presentation/widgets/upload_avatar_dialog.dart';
import 'package:flutter/material.dart';

class ColleagueListTile extends StatelessWidget {
  final ColleagueEntity colleague;
  final bool selected;
  final VoidCallback onTap;
  final String myId;

  const ColleagueListTile({
    super.key,
    required this.colleague,
    required this.selected,
    required this.onTap,
    required this.myId,
  });

  @override
  Widget build(BuildContext context) {
    final isMeOrAdmin = colleague.id == myId || colleague.role == 'admin';
    final isMe = colleague.id == myId;
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
              child: ValueListenableBuilder(
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

                      // Hover overlay
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
                      Text(
                        colleague.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      if (isMeOrAdmin)
                        Text(
                          ' Gesamt: ${colleague.totalVacations} / Verbleiben: ${colleague.restVacations}',
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    colleague.team,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
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
