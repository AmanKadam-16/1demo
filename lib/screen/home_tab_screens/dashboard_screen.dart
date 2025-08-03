import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return _buildMobileDashboard();
        } else {
          return _buildDesktopDashboard();
        }
      },
    );
  }

  Widget _buildMobileDashboard() {
    return SingleChildScrollView(
      child: Container(
        color: const Color(0xFFF5F5F5),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16.0),
            _buildDashboardCard(
              title: 'Today\'s Attendance',
              value: '85%',
              subtitle: 'Present',
              icon: Icons.check_circle,
              color: Colors.green,
            ),
            const SizedBox(height: 16.0),
            _buildDashboardCard(
              title: 'Pending Approvals',
              value: '12',
              subtitle: 'Requests',
              icon: Icons.pending_actions,
              color: Colors.orange,
            ),
            const SizedBox(height: 16.0),
            _buildDashboardCard(
              title: 'Monthly Overview',
              value: '92%',
              subtitle: 'Attendance Rate',
              icon: Icons.calendar_month,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopDashboard() {
    return SingleChildScrollView(
      child: Container(
        color: const Color(0xFFF5F5F5),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildDashboardCard(
                    title: 'Today\'s Attendance',
                    value: '85%',
                    subtitle: 'Present',
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildDashboardCard(
                    title: 'Pending Approvals',
                    value: '12',
                    subtitle: 'Requests',
                    icon: Icons.pending_actions,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: _buildDashboardCard(
                    title: 'Monthly Overview',
                    value: '92%',
                    subtitle: 'Attendance Rate',
                    icon: Icons.calendar_month,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            _buildAnalyticsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Text(
      'Dashboard',
      style: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
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

  Widget _buildAnalyticsSection() {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Attendance Analytics',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            // Placeholder for chart or graph
            Container(
              height: 200.0,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Center(
                child: Text(
                  'Chart Placeholder',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
