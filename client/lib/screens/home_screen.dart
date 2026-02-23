import 'package:flutter/material.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_state.dart';

/// Demo Home Screen showcasing all reusable widgets
/// Works on iOS, Android, and Web
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedDemo = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomHeader(
        title: 'ApnaKaarikar - UI Demo',
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_selectedDemo) {
      case 0:
        return _buildCardsDemo();
      case 1:
        return _buildButtonsDemo();
      case 2:
        return const LoadingIndicator(message: 'Loading data...');
      case 3:
        return EmptyState(
          message: 'No products available yet',
          icon: Icons.shopping_bag_outlined,
          onAction: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Action button pressed!')),
            );
          },
          actionText: 'Add Product',
        );
      case 4:
        return ErrorState(
          message: 'Failed to load products. Please try again.',
          onRetry: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Retrying...')),
            );
          },
        );
      default:
        return _buildCardsDemo();
    }
  }

  Widget _buildCardsDemo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Custom Cards Demo',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16.0),
          
          // Basic Card
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Basic Card',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8.0),
                Text(
                  'This is a basic custom card with default styling.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          
          // Tappable Card
          CustomCard(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Card tapped!')),
              );
            },
            child: Row(
              children: [
                const Icon(Icons.touch_app, size: 40.0),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tappable Card',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Tap this card to see the action',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16.0),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          
          // Colored Card
          CustomCard(
            backgroundColor: Colors.purple[50],
            elevation: 4.0,
            child: Row(
              children: [
                Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Icon(
                    Icons.palette,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Colored Card',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Custom background color and elevation',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32.0),
          
          // Navigation Buttons
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildButtonsDemo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Custom Buttons Demo',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16.0),
          
          // Primary Button
          CustomButton(
            text: 'Primary Button',
            onPressed: () {
              _showSnackBar('Primary button pressed');
            },
          ),
          const SizedBox(height: 16.0),
          
          // Button with Icon
          CustomButton(
            text: 'Button with Icon',
            icon: Icons.shopping_cart,
            onPressed: () {
              _showSnackBar('Icon button pressed');
            },
          ),
          const SizedBox(height: 16.0),
          
          // Success Button
          CustomButton(
            text: 'Success Button',
            backgroundColor: Colors.green,
            onPressed: () {
              _showSnackBar('Success button pressed');
            },
          ),
          const SizedBox(height: 16.0),
          
          // Warning Button
          CustomButton(
            text: 'Warning Button',
            backgroundColor: Colors.orange,
            onPressed: () {
              _showSnackBar('Warning button pressed');
            },
          ),
          const SizedBox(height: 16.0),
          
          // Error Button
          CustomButton(
            text: 'Error Button',
            backgroundColor: Colors.red,
            icon: Icons.error_outline,
            onPressed: () {
              _showSnackBar('Error button pressed');
            },
          ),
          const SizedBox(height: 16.0),
          
          // Loading Button
          const CustomButton(
            text: 'Loading Button',
            isLoading: true,
          ),
          const SizedBox(height: 16.0),
          
          // Disabled Button
          const CustomButton(
            text: 'Disabled Button',
            onPressed: null,
          ),
          const SizedBox(height: 32.0),
          
          // Navigation Buttons
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Switch Demo',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12.0),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            _buildDemoChip('Cards', 0),
            _buildDemoChip('Buttons', 1),
            _buildDemoChip('Loading', 2),
            _buildDemoChip('Empty', 3),
            _buildDemoChip('Error', 4),
          ],
        ),
      ],
    );
  }

  Widget _buildDemoChip(String label, int index) {
    final isSelected = _selectedDemo == index;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedDemo = index;
        });
      },
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ApnaKaarikar'),
        content: const Text(
          'This is a demo of reusable UI components.\n\n'
          'Features:\n'
          '✓ Custom Cards\n'
          '✓ Custom Buttons\n'
          '✓ Custom Header\n'
          '✓ Loading States\n'
          '✓ Empty States\n'
          '✓ Error States\n\n'
          'Works on iOS, Android, and Web!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
