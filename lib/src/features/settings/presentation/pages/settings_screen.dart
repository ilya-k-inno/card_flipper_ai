import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/localization/app_localizations.dart';
import '../cubit/settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        elevation: 0,
        scrolledUnderElevation: 2.0,
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoaded) {
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildThemeSection(context, state, theme),
                const Divider(height: 32.0),
                _buildLanguageSection(context, state),
                const Divider(height: 32.0),
                _buildAboutSection(context, theme),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildThemeSection(
    BuildContext context,
    SettingsLoaded state,
    ThemeData theme,
  ) {
    final l10n = context.l10n;
    final colorScheme = theme.colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.theme,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 12.0),
        Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            children: [
              _buildThemeOption(
                context,
                title: l10n.systemTheme,
                subtitle: l10n.systemThemeDescription,
                icon: Icons.brightness_auto,
                isSelected: state.themeMode == ThemeMode.system,
                onTap: () => context.read<SettingsCubit>().setThemeMode(ThemeMode.system),
              ),
              const Divider(height: 1, indent: 16.0, endIndent: 16.0),
              _buildThemeOption(
                context,
                title: l10n.lightTheme,
                subtitle: l10n.lightThemeDescription,
                icon: Icons.light_mode_outlined,
                isSelected: state.themeMode == ThemeMode.light,
                onTap: () => context.read<SettingsCubit>().setThemeMode(ThemeMode.light),
              ),
              const Divider(height: 1, indent: 16.0, endIndent: 16.0),
              _buildThemeOption(
                context,
                title: l10n.darkTheme,
                subtitle: l10n.darkThemeDescription,
                icon: Icons.dark_mode_outlined,
                isSelected: state.themeMode == ThemeMode.dark,
                onTap: () => context.read<SettingsCubit>().setThemeMode(ThemeMode.dark),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: isSelected 
                    ? colorScheme.primary.withOpacity(0.1)
                    : colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(
                icon,
                color: isSelected 
                    ? colorScheme.primary 
                    : colorScheme.onSurfaceVariant,
                size: 20.0,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isSelected 
                          ? colorScheme.primary 
                          : colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: colorScheme.primary,
                size: 20.0,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSection(
    BuildContext context,
    SettingsLoaded state,
  ) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.language,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 12.0),
        Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            children: [
              _buildLanguageOption(
                context,
                title: 'English',
                subtitle: 'English',
                languageCode: 'en',
                flag: '🇬🇧',
                isSelected: state.locale.languageCode == 'en',
                onTap: () => context.read<SettingsCubit>().setLocale(const Locale('en')),
              ),
              const Divider(height: 1, indent: 16.0, endIndent: 16.0),
              _buildLanguageOption(
                context,
                title: '日本語',
                subtitle: 'Japanese',
                languageCode: 'ja',
                flag: '🇯🇵',
                isSelected: state.locale.languageCode == 'ja',
                onTap: () => context.read<SettingsCubit>().setLocale(const Locale('ja')),
              ),
              const Divider(height: 1, indent: 16.0, endIndent: 16.0),
              _buildLanguageOption(
                context,
                title: 'Русский',
                subtitle: 'Russian',
                languageCode: 'ru',
                flag: '🇷🇺',
                isSelected: state.locale.languageCode == 'ru',
                onTap: () => context.read<SettingsCubit>().setLocale(const Locale('ru')),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildLanguageOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String languageCode,
    required String flag,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.5),
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Text(
                flag,
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isSelected 
                          ? colorScheme.primary 
                          : colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: colorScheme.primary,
                size: 20.0,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(
    BuildContext context,
    ThemeData theme,
  ) {
    final l10n = context.l10n;
    final colorScheme = theme.colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.about,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 12.0),
        Card(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.info_outline, color: colorScheme.primary),
                title: Text(l10n.version),
                subtitle: Text(AppConfig.appVersion),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Icon(Icons.privacy_tip_outlined, color: colorScheme.primary),
                title: Text(l10n.privacyPolicy),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Implement privacy policy navigation
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: Icon(Icons.description_outlined, color: colorScheme.primary),
                title: Text(l10n.termsOfService),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Implement terms of service navigation
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
