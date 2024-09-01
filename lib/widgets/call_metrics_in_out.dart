import 'package:flutter/material.dart';

class Metric {
  final IconData icon;
  final String label;
  final String value;

  Metric({required this.icon, required this.label, required this.value});
}

Widget _buildSection(String title, List<Metric> metrics) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4.0,
          spreadRadius: 1.0,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        ...metrics.map((metric) {
          return Column(
            children: [
              _buildMetricRow(metric.icon, metric.label, metric.value),
              const Divider(
                color: Colors.grey,
                height: 1,
              ),
            ],
          );
        }).toList(),
      ],
    ),
  );
}

Widget _buildMetricRow(IconData iconData, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Icon(iconData), // Icon widget
        const SizedBox(width: 8), // Spacing between icon and text
        Text(label),
        Expanded(
            child: Container()), // Expands to fill space between text and value
        Text(value),
      ],
    ),
  );
}

Widget _buildOutboundSection() {
  List<Metric> outboundMetrics = [
    Metric(icon: Icons.access_time, label: 'Average talk time', value: '0m 0s'),
    Metric(icon: Icons.access_time, label: 'Total talk time', value: '0m 0s'),
    Metric(icon: Icons.access_time, label: 'Break time', value: '0m 0s'),
    Metric(icon: Icons.access_time, label: 'Idle time', value: '0m 0s'),
    Metric(icon: Icons.access_time, label: 'Wrap up time', value: '0m 0s'),
    Metric(
        icon: Icons.access_time, label: 'Average login time', value: '0m 0s'),
  ];

  return _buildSection('Outbound Metrics', outboundMetrics);
}

Widget _buildInboundSection() {
  List<Metric> inboundMetrics = [
    Metric(
        icon: Icons.access_time, label: 'Average handle time', value: '0m 0s'),
    Metric(icon: Icons.access_time, label: 'Total handle time', value: '0m 0s'),
    Metric(icon: Icons.access_time, label: 'Hold time', value: '0m 0s'),
    Metric(icon: Icons.access_time, label: 'Queue time', value: '0m 0s'),
    Metric(icon: Icons.access_time, label: 'Abandon rate', value: '0%'),
    Metric(icon: Icons.access_time, label: 'Service level', value: '0%'),
  ];

  return _buildSection('Inbound Metrics', inboundMetrics);
}
