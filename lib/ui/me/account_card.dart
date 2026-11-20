import 'package:flutter/material.dart';

import '../../sync/sync_service.dart';

/// "Continue with Google" when signed out; account + sync status when signed in.
class AccountCard extends StatelessWidget {
  const AccountCard({super.key});

  @override
  Widget build(BuildContext context) {
    final sync = SyncScope.maybeOf(context);
    final scheme = Theme.of(context).colorScheme;

    if (sync == null) {
      return Card(
        child: ListTile(
          leading: const Icon(Icons.cloud_off_outlined),
          title: const Text('Cloud sync unavailable'),
          subtitle: Text('This build isn\'t connected to Firebase. Your progress is saved on this device.',
              style: TextStyle(color: scheme.onSurfaceVariant)),
        ),
      );
    }

    final user = sync.user;
    if (user == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              Icon(Icons.cloud_sync_outlined, color: scheme.primary, size: 28),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Sync your progress',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
              ),
            ]),
            const SizedBox(height: 8),
            Text(
              'Sign in to back up your lessons, quiz stats, bookmarks and streak, '
              'and pick up where you left off on any iPhone or Android phone. Optional — '
              'FlutterLab works fully offline without an account.',
              style: TextStyle(color: scheme.onSurfaceVariant, height: 1.4),
            ),
            const SizedBox(height: 14),
            _GoogleButton(
              busy: sync.busy,
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final error = await sync.signInWithGoogle();
                if (error != null) {
                  messenger.showSnackBar(SnackBar(content: Text(error), duration: const Duration(seconds: 5)));
                }
              },
            ),
          ]),
        ),
      );
    }

    final photo = user.photoURL;
    final name = user.displayName ?? user.email ?? 'Signed in';
    final (IconData icon, Color color, String status) = sync.error != null
        ? (Icons.error_outline, scheme.error, sync.error!)
        : sync.busy
            ? (Icons.sync, scheme.primary, 'Merging your progress…')
            : sync.hasPendingWrites || sync.lastSynced == null
                ? (Icons.cloud_upload_outlined, const Color(0xFFE08A00), 'Waiting to upload (offline?)')
                : (Icons.cloud_done, const Color(0xFF2E9E5B), 'Synced ${_ago(sync.lastSynced!)}');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: photo != null ? NetworkImage(photo) : null,
              child: photo == null ? Text(name.characters.first.toUpperCase()) : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                if (user.email != null && user.email != name)
                  Text(user.email!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: scheme.onSurfaceVariant)),
              ]),
            ),
          ]),
          const SizedBox(height: 12),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Expanded(child: Text(status, style: TextStyle(color: color))),
          ]),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Sign out?'),
                    content: const Text(
                        'Your progress stays on this device and in your account. Changes made while signed out won\'t sync until you sign in again.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                      FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sign out')),
                    ],
                  ),
                );
                if (ok == true) await sync.signOut();
              },
              icon: const Icon(Icons.logout, size: 18),
              label: const Text('Sign out'),
            ),
          ),
        ]),
      ),
    );
  }

  static String _ago(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inSeconds < 60) return 'just now';
    if (d.inMinutes < 60) return '${d.inMinutes} min ago';
    if (d.inHours < 24) return '${d.inHours} h ago';
    return '${d.inDays} d ago';
  }
}

class _GoogleButton extends StatelessWidget {
  const _GoogleButton({required this.busy, required this.onPressed});
  final bool busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return OutlinedButton(
      onPressed: busy ? null : onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        backgroundColor: dark ? const Color(0xFF131314) : Colors.white,
        foregroundColor: dark ? const Color(0xFFE3E3E3) : const Color(0xFF1F1F1F),
        side: BorderSide(color: dark ? const Color(0xFF8E918F) : const Color(0xFF747775)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      child: busy
          ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
          : const Row(mainAxisSize: MainAxisSize.min, children: [
              _GoogleG(),
              SizedBox(width: 10),
              Flexible(child: Text('Continue with Google', style: TextStyle(fontWeight: FontWeight.w600))),
            ]),
    );
  }
}

/// The multicolour Google "G", drawn with a CustomPainter (no image asset needed).
class _GoogleG extends StatelessWidget {
  const _GoogleG();
  @override
  Widget build(BuildContext context) => const SizedBox(width: 20, height: 20, child: CustomPaint(painter: _GPainter()));
}

class _GPainter extends CustomPainter {
  const _GPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final stroke = s * 0.2;
    final rect = Rect.fromCircle(center: Offset(s / 2, s / 2), radius: s / 2 - stroke / 2);
    Paint p(Color c) => Paint()
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    const deg = 3.14159265 / 180;
    canvas.drawArc(rect, -40 * deg, -100 * deg, false, p(const Color(0xFFEA4335))); // red (top)
    canvas.drawArc(rect, -140 * deg, -90 * deg, false, p(const Color(0xFFFBBC05))); // yellow (left)
    canvas.drawArc(rect, 130 * deg, -100 * deg, false, p(const Color(0xFF34A853))); // green (bottom)
    canvas.drawArc(rect, 30 * deg, -40 * deg, false, p(const Color(0xFF4285F4))); // blue (right)
    canvas.drawLine(Offset(s / 2, s / 2), Offset(s - stroke / 2, s / 2),
        p(const Color(0xFF4285F4))..strokeCap = StrokeCap.square);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
