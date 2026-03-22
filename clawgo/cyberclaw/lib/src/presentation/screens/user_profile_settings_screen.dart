import 'package:cyberclaw/src/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserProfileSettingsScreen extends StatelessWidget {
  const UserProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Icon(Icons.terminal, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Text(
              'IRONCLAW CONTROL',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          if (MediaQuery.of(context).size.width > 600)
            Row(
              children: [
                _NavButton(label: 'CHAT', isSelected: false),
                _NavButton(label: 'SETTINGS', isSelected: true),
                _NavButton(label: 'SYSTEM', isSelected: false),
              ],
            ),
          const SizedBox(width: 8),
        ],
        shape: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
            width: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionHeader(title: 'Operator Profile'),
                const _OperatorProfileCard(),
                const SizedBox(height: 48),
                const _SectionHeader(title: 'AI Agent Permissions'),
                const _AiPermissionsCard(),
                const SizedBox(height: 48),
                const _AccountActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  const _NavButton({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: () {},
        child: Container(
          decoration: isSelected
              ? BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppTheme.primary, width: 2),
                  ),
                )
              : null,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary.withOpacity(0.7),
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 1,
              color: Theme.of(
                context,
              ).colorScheme.outlineVariant.withOpacity(0.2),
            ),
          ),
        ],
      ),
    );
  }
}

class _OperatorProfileCard extends StatelessWidget {
  const _OperatorProfileCard();

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BeveledEdgeClipper(cutSize: 15),
      child: Container(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.5),
                  ),
                ),
                Positioned(
                  bottom: -1,
                  right: -1,
                  child: Container(
                    width: 16,
                    height: 16,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OPERATOR_01',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    'OP_01@IRONCLAW.NETWORK',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withOpacity(0.6),
                      letterSpacing: 2,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.1),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      'LVL 4 CLEARANCE',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
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

class _AiPermissionsCard extends StatelessWidget {
  const _AiPermissionsCard();

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BeveledEdgeClipper(cutSize: 15),
      child: Container(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _PermissionTile(
              icon: Icons.folder_shared,
              title: 'Directory Access',
              subtitle: '',
              trailing: OutlinedButton(
                onPressed: () {},
                child: const Text('EDIT', style: TextStyle(fontSize: 10)),
              ),
              content: Wrap(
                spacing: 8,
                children: [
                  _Badge(text: '/root/sys_alpha'),
                  _Badge(text: '/mnt/openclaw_data'),
                ],
              ),
            ),
            const Divider(height: 48, color: Colors.white10),
            _PermissionTile(
              icon: Icons.language,
              title: 'Internet Uplink',
              subtitle: 'Cloud synchronization and external queries',
              trailing: Switch(
                value: true,
                onChanged: (_) {},
                activeColor: Theme.of(context).colorScheme.secondaryContainer,
              ),
            ),
            const Divider(height: 48, color: Colors.white10),
            _PermissionTile(
              icon: Icons.location_on,
              title: 'Geolocation Beacon',
              subtitle: 'Real-time coordinate broadcasting',
              trailing: Switch(
                value: false,
                onChanged: (_) {},
                activeColor: Theme.of(context).colorScheme.secondaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PermissionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final Widget? content;

  const _PermissionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.secondaryContainer,
          size: 24,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withOpacity(0.6),
                    fontSize: 9,
                  ),
                ),
              if (content != null) ...[const SizedBox(height: 12), content!],
            ],
          ),
        ),
        trailing,
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  const _Badge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.secondaryContainer.withOpacity(0.2),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
          fontSize: 10,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

class _AccountActions extends StatelessWidget {
  const _AccountActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: () => context.go('/sign-in'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: const Text(
              'SIGN OUT',
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 48,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
              ),
              foregroundColor: Theme.of(
                context,
              ).colorScheme.primary.withOpacity(0.7),
            ),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
                children: [
                  const TextSpan(text: 'DELETE ACCOUNT '),
                  TextSpan(
                    text: '| CRITICAL ACTION',
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BeveledEdgeClipper extends CustomClipper<Path> {
  final double cutSize;

  BeveledEdgeClipper({this.cutSize = 10.0});

  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height - cutSize)
      ..lineTo(size.width - cutSize, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
