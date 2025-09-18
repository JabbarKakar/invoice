import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/create_invoice_screen.dart';
import '../screens/invoice_list_screen.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            title: 'Create Invoice',
            icon: Icons.add_circle_outline,
            color: AppTheme.primaryColor,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateInvoiceScreen(),
                ),
              );
            },
          ),
        ),
        
        const SizedBox(width: 12),
        
        Expanded(
          child: _ActionButton(
            title: 'View All',
            icon: Icons.list_alt,
            color: AppTheme.secondaryColor,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const InvoiceListScreen(),
                ),
              );
            },
          ),
        ),
        
        const SizedBox(width: 12),
        
        Expanded(
          child: _ActionButton(
            title: 'Templates',
            icon: Icons.description_outlined,
            color: AppTheme.warningColor,
            onTap: () {
              // TODO: Navigate to templates screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Templates feature coming soon!'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: theme.brightness == Brightness.dark 
                ? AppTheme.darkCardGradient 
                : AppTheme.cardGradient,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                title,
                style: AppTheme.labelMedium.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


