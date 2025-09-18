import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/invoice_provider.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/invoice_card.dart';
import '../widgets/stats_card.dart';
import '../widgets/quick_actions.dart';
import 'invoice_list_screen.dart';
import 'create_invoice_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InvoiceProvider>().loadInvoices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read<InvoiceProvider>().loadInvoices();
          },
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Invoice Manager',
                    style: AppTheme.heading5.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: -50,
                          right: -50,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -30,
                          left: -30,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.05),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.settings),
                  ),
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, child) {
                      return IconButton(
                        onPressed: () => themeProvider.toggleTheme(),
                        icon: Icon(
                          themeProvider.isDarkMode
                              ? Icons.light_mode
                              : Icons.dark_mode,
                        ),
                      );
                    },
                  ),
                ],
              ),
              
              // Content
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Quick Stats
                    Consumer<InvoiceProvider>(
                      builder: (context, invoiceProvider, child) {
                        final stats = invoiceProvider.getInvoiceStats();
                        final totalRevenue = invoiceProvider.getTotalRevenue();
                        final totalInvoices = invoiceProvider.getTotalInvoices();
                        
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Overview',
                              style: AppTheme.heading4.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 400.ms)
                                .slideX(begin: -0.2, end: 0),
                            
                            const SizedBox(height: 16),
                            
                            Row(
                              children: [
                                Expanded(
                                  child: StatsCard(
                                    title: 'Total Invoices',
                                    value: totalInvoices.toString(),
                                    icon: Icons.receipt_long,
                                    color: AppTheme.primaryColor,
                                  ),
                                )
                                    .animate()
                                    .fadeIn(delay: 100.ms, duration: 400.ms)
                                    .scale(begin: const Offset(0.8, 0.8)),
                                
                                const SizedBox(width: 12),
                                
                                Expanded(
                                  child: StatsCard(
                                    title: 'Total Revenue',
                                    value: '\$${totalRevenue.toStringAsFixed(0)}',
                                    icon: Icons.attach_money,
                                    color: AppTheme.successColor,
                                  ),
                                )
                                    .animate()
                                    .fadeIn(delay: 200.ms, duration: 400.ms)
                                    .scale(begin: const Offset(0.8, 0.8)),
                              ],
                            ),
                            
                            const SizedBox(height: 12),
                            
                            Row(
                              children: [
                                Expanded(
                                  child: StatsCard(
                                    title: 'Draft',
                                    value: stats['draft']?.toString() ?? '0',
                                    icon: Icons.edit,
                                    color: AppTheme.warningColor,
                                  ),
                                )
                                    .animate()
                                    .fadeIn(delay: 300.ms, duration: 400.ms)
                                    .scale(begin: const Offset(0.8, 0.8)),
                                
                                const SizedBox(width: 12),
                                
                                Expanded(
                                  child: StatsCard(
                                    title: 'Paid',
                                    value: stats['paid']?.toString() ?? '0',
                                    icon: Icons.check_circle,
                                    color: AppTheme.successColor,
                                  ),
                                )
                                    .animate()
                                    .fadeIn(delay: 400.ms, duration: 400.ms)
                                    .scale(begin: const Offset(0.8, 0.8)),
                              ],
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Quick Actions
                            Text(
                              'Quick Actions',
                              style: AppTheme.heading4.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            )
                                .animate()
                                .fadeIn(delay: 500.ms, duration: 400.ms)
                                .slideX(begin: -0.2, end: 0),
                            
                            const SizedBox(height: 16),
                            
                            const QuickActions()
                                .animate()
                                .fadeIn(delay: 600.ms, duration: 400.ms)
                                .slideY(begin: 0.2, end: 0),
                            
                            const SizedBox(height: 24),
                            
                            // Recent Invoices
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recent Invoices',
                                  style: AppTheme.heading4.copyWith(
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                )
                                    .animate()
                                    .fadeIn(delay: 700.ms, duration: 400.ms)
                                    .slideX(begin: -0.2, end: 0),
                                
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const InvoiceListScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text('View All'),
                                )
                                    .animate()
                                    .fadeIn(delay: 800.ms, duration: 400.ms)
                                    .slideX(begin: 0.2, end: 0),
                              ],
                            )
                                .animate()
                                .fadeIn(delay: 700.ms, duration: 400.ms),
                            
                            const SizedBox(height: 16),
                          ],
                        );
                      },
                    ),
                  ]),
                ),
              ),
              
              // Recent Invoices List
              Consumer<InvoiceProvider>(
                builder: (context, invoiceProvider, child) {
                  final recentInvoices = invoiceProvider.getRecentInvoices(limit: 5);
                  
                  if (recentInvoices.isEmpty) {
                    return SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 64,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No invoices yet',
                                style: AppTheme.heading5.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Create your first invoice to get started',
                                style: AppTheme.bodyMedium.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const CreateInvoiceScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Create Invoice'),
                              ),
                            ],
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 900.ms, duration: 400.ms)
                            .scale(begin: const Offset(0.9, 0.9)),
                      ),
                    );
                  }
                  
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final invoice = recentInvoices[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: InvoiceCard(
                              invoice: invoice,
                              onTap: () {
                                // Navigate to invoice details
                              },
                            )
                                .animate()
                                .fadeIn(
                                  delay: Duration(milliseconds: 900 + (index * 100)),
                                  duration: 400.ms,
                                )
                                .slideX(
                                  begin: 0.2,
                                  end: 0,
                                  duration: 400.ms,
                                ),
                          );
                        },
                        childCount: recentInvoices.length,
                      ),
                    ),
                  );
                },
              ),
              
              const SliverToBoxAdapter(
                child: SizedBox(height: 100), // Bottom padding for FAB
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateInvoiceScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Invoice'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      )
          .animate()
          .fadeIn(delay: 1000.ms, duration: 400.ms)
          .scale(begin: const Offset(0.8, 0.8)),
    );
  }
}


