import 'package:flutter/material.dart';
import 'package:voo_data_grid/voo_data_grid.dart';
import 'package:voo_ui_core/voo_ui_core.dart';
import 'dart:async';
import 'dart:math';

/// Real-time data updates preview showing live data changes
@pragma('preview')
class VooDataGridRealtimePreview extends StatefulWidget {
  const VooDataGridRealtimePreview({super.key});

  @override
  State<VooDataGridRealtimePreview> createState() => _VooDataGridRealtimePreviewState();
}

class _VooDataGridRealtimePreviewState extends State<VooDataGridRealtimePreview> {
  late VooDataGridController _controller;
  late LocalDataGridSource _dataSource;
  Timer? _timer;
  Timer? _updateTimer;
  final Random _random = Random();
  bool _autoUpdate = false;
  int _updateInterval = 1000; // milliseconds
  int _updateCount = 0;
  
  // Real-time metrics
  final List<Map<String, dynamic>> _stockData = [];
  final List<Map<String, dynamic>> _serverMetrics = [];
  final List<Map<String, dynamic>> _sensorData = [];
  
  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupDataSource();
  }
  
  void _initializeData() {
    // Initialize stock data
    final stocks = ['AAPL', 'GOOGL', 'MSFT', 'AMZN', 'META', 'TSLA', 'NVDA', 'AMD', 'INTC', 'NFLX'];
    for (int i = 0; i < stocks.length; i++) {
      _stockData.add({
        'id': i + 1,
        'symbol': stocks[i],
        'price': 100 + _random.nextDouble() * 400,
        'previousPrice': 100 + _random.nextDouble() * 400,
        'change': 0.0,
        'changePercent': 0.0,
        'volume': _random.nextInt(10000000) + 1000000,
        'bid': 0.0,
        'ask': 0.0,
        'dayHigh': 0.0,
        'dayLow': 0.0,
        'marketCap': (_random.nextInt(900) + 100) * 1000000000,
        'pe': 10 + _random.nextDouble() * 30,
        'lastUpdate': DateTime.now(),
      });
      _updateStockPrices(i);
    }
    
    // Initialize server metrics
    final servers = ['Web-01', 'Web-02', 'API-01', 'API-02', 'DB-01', 'DB-02', 'Cache-01', 'Queue-01'];
    for (int i = 0; i < servers.length; i++) {
      _serverMetrics.add({
        'id': i + 1,
        'serverName': servers[i],
        'status': 'Online',
        'cpuUsage': _random.nextInt(30) + 20,
        'memoryUsage': _random.nextInt(40) + 30,
        'diskUsage': _random.nextInt(50) + 20,
        'networkIn': _random.nextInt(1000),
        'networkOut': _random.nextInt(1000),
        'requestsPerSec': _random.nextInt(5000),
        'avgResponseTime': _random.nextInt(200) + 50,
        'errorRate': _random.nextDouble() * 2,
        'uptime': '${_random.nextInt(30) + 1}d ${_random.nextInt(24)}h',
        'lastPing': DateTime.now(),
      });
    }
    
    // Initialize sensor data
    final sensors = ['SENS-A1', 'SENS-A2', 'SENS-B1', 'SENS-B2', 'SENS-C1', 'SENS-C2'];
    for (int i = 0; i < sensors.length; i++) {
      _sensorData.add({
        'id': i + 1,
        'sensorId': sensors[i],
        'temperature': 20 + _random.nextDouble() * 10,
        'humidity': 40 + _random.nextDouble() * 20,
        'pressure': 1000 + _random.nextDouble() * 50,
        'co2': 400 + _random.nextInt(200),
        'light': _random.nextInt(10000),
        'motion': _random.nextBool(),
        'battery': 70 + _random.nextInt(30),
        'signalStrength': -90 + _random.nextInt(40),
        'lastReading': DateTime.now(),
        'status': 'Active',
      });
    }
  }
  
  void _setupDataSource() {
    _dataSource = LocalDataGridSource(data: _stockData);
    
    _controller = VooDataGridController(
      dataSource: _dataSource,
      columns: _buildStockColumns(),
    );
    
    _dataSource.loadData();
  }
  
  List<VooDataColumn> _buildStockColumns() {
    return [
      const VooDataColumn(
        field: 'symbol',
        label: 'Symbol',
        width: 80,
        frozen: true,
        sortable: true,
      ),
      VooDataColumn(
        field: 'price',
        label: 'Price',
        width: 100,
        sortable: true,
        cellBuilder: (context, value, row) {
          final price = value as double;
          final change = row['change'] as double;
          final color = change > 0 ? Colors.green : change < 0 ? Colors.red : Colors.grey;
          
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                if (_autoUpdate)
                  Icon(
                    change > 0 ? Icons.arrow_upward : change < 0 ? Icons.arrow_downward : Icons.remove,
                    size: 10,
                    color: color,
                  ),
              ],
            ),
          );
        },
      ),
      VooDataColumn(
        field: 'change',
        label: 'Change',
        width: 80,
        sortable: true,
        cellBuilder: (context, value, row) {
          final change = value as double;
          final color = change > 0 ? Colors.green : change < 0 ? Colors.red : Colors.grey;
          
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.centerRight,
            child: Text(
              '${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)}',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
      ),
      VooDataColumn(
        field: 'changePercent',
        label: '% Change',
        width: 100,
        sortable: true,
        cellBuilder: (context, value, row) {
          final percent = row['changePercent'] as double;
          final color = percent > 0 ? Colors.green : percent < 0 ? Colors.red : Colors.grey;
          
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Text(
              '${percent >= 0 ? '+' : ''}${percent.toStringAsFixed(2)}%',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          );
        },
      ),
      VooDataColumn(
        field: 'volume',
        label: 'Volume',
        width: 120,
        sortable: true,
        valueFormatter: (value) {
          final vol = value as int;
          if (vol >= 1000000) {
            return '${(vol / 1000000).toStringAsFixed(1)}M';
          } else if (vol >= 1000) {
            return '${(vol / 1000).toStringAsFixed(1)}K';
          }
          return vol.toString();
        },
        textAlign: TextAlign.right,
      ),
      VooDataColumn(
        field: 'bid',
        label: 'Bid',
        width: 80,
        valueFormatter: (value) => '\$${value.toStringAsFixed(2)}',
        textAlign: TextAlign.right,
      ),
      VooDataColumn(
        field: 'ask',
        label: 'Ask',
        width: 80,
        valueFormatter: (value) => '\$${value.toStringAsFixed(2)}',
        textAlign: TextAlign.right,
      ),
      VooDataColumn(
        field: 'dayHigh',
        label: 'Day High',
        width: 90,
        valueFormatter: (value) => '\$${value.toStringAsFixed(2)}',
        textAlign: TextAlign.right,
      ),
      VooDataColumn(
        field: 'dayLow',
        label: 'Day Low',
        width: 90,
        valueFormatter: (value) => '\$${value.toStringAsFixed(2)}',
        textAlign: TextAlign.right,
      ),
      VooDataColumn(
        field: 'marketCap',
        label: 'Market Cap',
        width: 120,
        sortable: true,
        valueFormatter: (value) {
          final cap = value as int;
          if (cap >= 1000000000000) {
            return '\$${(cap / 1000000000000).toStringAsFixed(1)}T';
          } else if (cap >= 1000000000) {
            return '\$${(cap / 1000000000).toStringAsFixed(1)}B';
          }
          return '\$${(cap / 1000000).toStringAsFixed(1)}M';
        },
        textAlign: TextAlign.right,
      ),
      VooDataColumn(
        field: 'pe',
        label: 'P/E',
        width: 60,
        sortable: true,
        valueFormatter: (value) => value.toStringAsFixed(1),
        textAlign: TextAlign.right,
      ),
      VooDataColumn(
        field: 'lastUpdate',
        label: 'Last Update',
        width: 100,
        cellBuilder: (context, value, row) {
          final lastUpdate = row['lastUpdate'] as DateTime;
          final diff = DateTime.now().difference(lastUpdate).inSeconds;
          
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: diff < 2 ? Colors.green : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  diff < 60 ? '${diff}s ago' : '${(diff / 60).floor()}m ago',
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          );
        },
      ),
    ];
  }
  
  List<VooDataColumn> _buildServerColumns() {
    return [
      const VooDataColumn(
        field: 'serverName',
        label: 'Server',
        width: 100,
        frozen: true,
        sortable: true,
      ),
      VooDataColumn(
        field: 'status',
        label: 'Status',
        width: 80,
        cellBuilder: (context, value, row) {
          final status = row['status'];
          Color color;
          IconData icon;
          
          switch (status) {
            case 'Online':
              color = Colors.green;
              icon = Icons.check_circle;
              break;
            case 'Warning':
              color = Colors.orange;
              icon = Icons.warning;
              break;
            case 'Offline':
              color = Colors.red;
              icon = Icons.cancel;
              break;
            default:
              color = Colors.grey;
              icon = Icons.help;
          }
          
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(status, style: TextStyle(color: color, fontSize: 12)),
            ],
          );
        },
      ),
      VooDataColumn(
        field: 'cpuUsage',
        label: 'CPU %',
        width: 100,
        sortable: true,
        cellBuilder: (context, value, row) => _buildUsageBar(row['cpuUsage'] as int, 80),
      ),
      VooDataColumn(
        field: 'memoryUsage',
        label: 'Memory %',
        width: 100,
        sortable: true,
        cellBuilder: (context, value, row) => _buildUsageBar(row['memoryUsage'] as int, 85),
      ),
      VooDataColumn(
        field: 'diskUsage',
        label: 'Disk %',
        width: 100,
        sortable: true,
        cellBuilder: (context, value, row) => _buildUsageBar(row['diskUsage'] as int, 90),
      ),
      VooDataColumn(
        field: 'networkIn',
        label: 'Net In',
        width: 80,
        valueFormatter: (value) => '$value MB/s',
        textAlign: TextAlign.right,
      ),
      VooDataColumn(
        field: 'networkOut',
        label: 'Net Out',
        width: 80,
        valueFormatter: (value) => '$value MB/s',
        textAlign: TextAlign.right,
      ),
      VooDataColumn(
        field: 'requestsPerSec',
        label: 'Req/s',
        width: 80,
        sortable: true,
        valueFormatter: (value) => value.toString(),
        textAlign: TextAlign.right,
      ),
      VooDataColumn(
        field: 'avgResponseTime',
        label: 'Avg Response',
        width: 100,
        sortable: true,
        cellBuilder: (context, value, row) {
          final time = row['avgResponseTime'] as int;
          Color color;
          if (time < 100) {
            color = Colors.green;
          } else if (time < 200) {
            color = Colors.orange;
          } else {
            color = Colors.red;
          }
          
          return Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '${time}ms',
              style: TextStyle(color: color, fontWeight: FontWeight.w500),
            ),
          );
        },
      ),
      VooDataColumn(
        field: 'errorRate',
        label: 'Error Rate',
        width: 90,
        sortable: true,
        cellBuilder: (context, value, row) {
          final rate = row['errorRate'] as double;
          Color color;
          if (rate < 0.5) {
            color = Colors.green;
          } else if (rate < 1.0) {
            color = Colors.orange;
          } else {
            color = Colors.red;
          }
          
          return Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '${rate.toStringAsFixed(2)}%',
              style: TextStyle(color: color),
            ),
          );
        },
      ),
      const VooDataColumn(
        field: 'uptime',
        label: 'Uptime',
        width: 80,
        textAlign: TextAlign.center,
      ),
    ];
  }
  
  List<VooDataColumn> _buildSensorColumns() {
    return [
      const VooDataColumn(
        field: 'sensorId',
        label: 'Sensor ID',
        width: 100,
        frozen: true,
        sortable: true,
      ),
      VooDataColumn(
        field: 'temperature',
        label: 'Temp (°C)',
        width: 90,
        sortable: true,
        cellBuilder: (context, value, row) {
          final temp = row['temperature'] as double;
          Color color;
          if (temp < 22) {
            color = Colors.blue;
          } else if (temp < 26) {
            color = Colors.green;
          } else {
            color = Colors.orange;
          }
          
          return Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.thermostat, size: 14, color: color),
                const SizedBox(width: 4),
                Text(
                  temp.toStringAsFixed(1),
                  style: TextStyle(color: color, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        },
      ),
      VooDataColumn(
        field: 'humidity',
        label: 'Humidity %',
        width: 100,
        sortable: true,
        cellBuilder: (context, value, row) {
          final humidity = row['humidity'] as double;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LinearProgressIndicator(
                  value: humidity / 100,
                  backgroundColor: Colors.blue.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  minHeight: 4,
                ),
                const SizedBox(height: 2),
                Text(
                  '${humidity.toStringAsFixed(1)}%',
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          );
        },
      ),
      VooDataColumn(
        field: 'pressure',
        label: 'Pressure',
        width: 90,
        sortable: true,
        valueFormatter: (value) => '${value.toStringAsFixed(0)} hPa',
        textAlign: TextAlign.right,
      ),
      VooDataColumn(
        field: 'co2',
        label: 'CO₂ (ppm)',
        width: 90,
        sortable: true,
        cellBuilder: (context, value, row) {
          final co2 = row['co2'] as int;
          Color color;
          if (co2 < 450) {
            color = Colors.green;
          } else if (co2 < 550) {
            color = Colors.orange;
          } else {
            color = Colors.red;
          }
          
          return Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              co2.toString(),
              style: TextStyle(color: color),
            ),
          );
        },
      ),
      VooDataColumn(
        field: 'light',
        label: 'Light (lux)',
        width: 90,
        valueFormatter: (value) => value.toString(),
        textAlign: TextAlign.right,
      ),
      VooDataColumn(
        field: 'motion',
        label: 'Motion',
        width: 70,
        cellBuilder: (context, value, row) {
          final motion = row['motion'] as bool;
          return Center(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: motion ? Colors.red.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.sensors,
                size: 16,
                color: motion ? Colors.red : Colors.grey,
              ),
            ),
          );
        },
      ),
      VooDataColumn(
        field: 'battery',
        label: 'Battery',
        width: 80,
        sortable: true,
        cellBuilder: (context, value, row) {
          final battery = row['battery'] as int;
          IconData icon;
          Color color;
          
          if (battery > 80) {
            icon = Icons.battery_full;
            color = Colors.green;
          } else if (battery > 50) {
            icon = Icons.battery_5_bar;
            color = Colors.orange;
          } else if (battery > 20) {
            icon = Icons.battery_3_bar;
            color = Colors.orange;
          } else {
            icon = Icons.battery_alert;
            color = Colors.red;
          }
          
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text('$battery%', style: TextStyle(fontSize: 11, color: color)),
            ],
          );
        },
      ),
      VooDataColumn(
        field: 'signalStrength',
        label: 'Signal',
        width: 80,
        cellBuilder: (context, value, row) {
          final signal = row['signalStrength'] as int;
          IconData icon;
          Color color;
          
          if (signal > -60) {
            icon = Icons.signal_wifi_4_bar;
            color = Colors.green;
          } else if (signal > -70) {
            icon = Icons.network_wifi_3_bar;
            color = Colors.orange;
          } else if (signal > -80) {
            icon = Icons.network_wifi_2_bar;
            color = Colors.orange;
          } else {
            icon = Icons.signal_wifi_bad;
            color = Colors.red;
          }
          
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text('${signal}dBm', style: const TextStyle(fontSize: 10)),
            ],
          );
        },
      ),
      VooDataColumn(
        field: 'status',
        label: 'Status',
        width: 80,
        cellBuilder: (context, value, row) {
          final status = row['status'];
          return Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Text(
                status,
                style: const TextStyle(fontSize: 11, color: Colors.green),
              ),
            ),
          );
        },
      ),
    ];
  }
  
  Widget _buildUsageBar(int usage, int threshold) {
    Color color;
    if (usage < threshold * 0.7) {
      color = Colors.green;
    } else if (usage < threshold) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LinearProgressIndicator(
            value: usage / 100,
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
          const SizedBox(height: 2),
          Text(
            '$usage%',
            style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
  
  void _startAutoUpdate() {
    _timer = Timer.periodic(Duration(milliseconds: _updateInterval), (timer) {
      if (!mounted) return;
      
      setState(() {
        _updateCount++;
        
        // Update based on current data type
        if (_controller.columns == _buildStockColumns()) {
          _updateStockData();
        } else if (_controller.columns == _buildServerColumns()) {
          _updateServerData();
        } else {
          _updateSensorData();
        }
      });
    });
  }
  
  void _stopAutoUpdate() {
    _timer?.cancel();
    _updateTimer?.cancel();
  }
  
  void _updateStockData() {
    for (int i = 0; i < _stockData.length; i++) {
      _updateStockPrices(i);
    }
    _dataSource.setLocalData(_stockData);
    _dataSource.loadData();
  }
  
  void _updateStockPrices(int index) {
    final stock = _stockData[index];
    final currentPrice = stock['price'] as double;
    
    // Simulate price movement
    final changePercent = (_random.nextDouble() - 0.5) * 4; // -2% to +2%
    final newPrice = currentPrice * (1 + changePercent / 100);
    final change = newPrice - currentPrice;
    
    stock['previousPrice'] = currentPrice;
    stock['price'] = newPrice;
    stock['change'] = change;
    stock['changePercent'] = changePercent;
    stock['volume'] = stock['volume'] + _random.nextInt(100000);
    stock['bid'] = newPrice - _random.nextDouble();
    stock['ask'] = newPrice + _random.nextDouble();
    
    if (stock['dayHigh'] == 0.0 || newPrice > stock['dayHigh']) {
      stock['dayHigh'] = newPrice;
    }
    if (stock['dayLow'] == 0.0 || newPrice < stock['dayLow']) {
      stock['dayLow'] = newPrice;
    }
    
    stock['lastUpdate'] = DateTime.now();
  }
  
  void _updateServerData() {
    for (var server in _serverMetrics) {
      // Simulate metric changes
      server['cpuUsage'] = max<num>(0, min<num>(100, (server['cpuUsage'] as num) + _random.nextInt(21) - 10));
      server['memoryUsage'] = max<num>(0, min<num>(100, (server['memoryUsage'] as num) + _random.nextInt(11) - 5));
      server['diskUsage'] = max<num>(0, min<num>(100, (server['diskUsage'] as num) + _random.nextInt(5) - 2));
      server['networkIn'] = max<num>(0, (server['networkIn'] as num) + _random.nextInt(201) - 100);
      server['networkOut'] = max<num>(0, (server['networkOut'] as num) + _random.nextInt(201) - 100);
      server['requestsPerSec'] = max<num>(0, (server['requestsPerSec'] as num) + _random.nextInt(1001) - 500);
      server['avgResponseTime'] = max<num>(10, (server['avgResponseTime'] as num) + _random.nextInt(41) - 20);
      server['errorRate'] = max<num>(0, min<num>(10, (server['errorRate'] as num) + (_random.nextDouble() - 0.5)));
      
      // Update status based on metrics
      if (server['cpuUsage'] > 90 || server['memoryUsage'] > 90 || server['errorRate'] > 2) {
        server['status'] = 'Warning';
      } else if (_random.nextInt(100) < 2) {
        server['status'] = 'Offline';
      } else {
        server['status'] = 'Online';
      }
      
      server['lastPing'] = DateTime.now();
    }
    
    _dataSource.setLocalData(_serverMetrics);
    _dataSource.loadData();
  }
  
  void _updateSensorData() {
    for (var sensor in _sensorData) {
      // Simulate sensor readings
      sensor['temperature'] = 20 + _random.nextDouble() * 10;
      sensor['humidity'] = 40 + _random.nextDouble() * 20;
      sensor['pressure'] = 1000 + _random.nextDouble() * 50;
      sensor['co2'] = 400 + _random.nextInt(200);
      sensor['light'] = _random.nextInt(10000);
      sensor['motion'] = _random.nextBool();
      sensor['battery'] = max<num>(0, (sensor['battery'] as num) - (_random.nextBool() ? 1 : 0));
      sensor['signalStrength'] = -90 + _random.nextInt(40);
      sensor['lastReading'] = DateTime.now();
      
      if (sensor['battery'] < 10) {
        sensor['status'] = 'Low Battery';
      } else if (sensor['signalStrength'] < -85) {
        sensor['status'] = 'Weak Signal';
      } else {
        sensor['status'] = 'Active';
      }
    }
    
    _dataSource.setLocalData(_sensorData);
    _dataSource.loadData();
  }
  
  void _switchDataType(String type) {
    _stopAutoUpdate();
    setState(() {
      _updateCount = 0;
      _autoUpdate = false;
      
      switch (type) {
        case 'stocks':
          _dataSource.setLocalData(_stockData);
          _controller = VooDataGridController(
            dataSource: _dataSource,
            columns: _buildStockColumns(),
          );
          break;
        case 'servers':
          _dataSource.setLocalData(_serverMetrics);
          _controller = VooDataGridController(
            dataSource: _dataSource,
            columns: _buildServerColumns(),
          );
          break;
        case 'sensors':
          _dataSource.setLocalData(_sensorData);
          _controller = VooDataGridController(
            dataSource: _dataSource,
            columns: _buildSensorColumns(),
          );
          break;
      }
      
      _dataSource.loadData();
    });
  }
  
  @override
  void dispose() {
    _stopAutoUpdate();
    _controller.dispose();
    _dataSource.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return VooDesignSystem(
      data: VooDesignSystemData.defaultSystem,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Real-time Data Updates'),
            actions: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    const Text('Updates: ', style: TextStyle(fontSize: 14)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _autoUpdate ? Colors.green : Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$_updateCount',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          body: Column(
            children: [
              // Control panel
              Container(
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text('Data Type:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 16),
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(
                              value: 'stocks',
                              label: Text('Stock Market'),
                              icon: Icon(Icons.trending_up),
                            ),
                            ButtonSegment(
                              value: 'servers',
                              label: Text('Server Metrics'),
                              icon: Icon(Icons.dns),
                            ),
                            ButtonSegment(
                              value: 'sensors',
                              label: Text('IoT Sensors'),
                              icon: Icon(Icons.sensors),
                            ),
                          ],
                          selected: {
                            _controller.columns == _buildStockColumns() ? 'stocks' :
                            _controller.columns == _buildServerColumns() ? 'servers' : 'sensors'
                          },
                          onSelectionChanged: (Set<String> selection) {
                            _switchDataType(selection.first);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Auto Update:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 16),
                        Switch(
                          value: _autoUpdate,
                          onChanged: (value) {
                            setState(() {
                              _autoUpdate = value;
                              if (value) {
                                _startAutoUpdate();
                              } else {
                                _stopAutoUpdate();
                              }
                            });
                          },
                        ),
                        const SizedBox(width: 16),
                        const Text('Interval:'),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 200,
                          child: Slider(
                            value: _updateInterval.toDouble(),
                            min: 100,
                            max: 5000,
                            divisions: 49,
                            label: '${_updateInterval}ms',
                            onChanged: _autoUpdate ? null : (value) {
                              setState(() {
                                _updateInterval = value.toInt();
                              });
                            },
                          ),
                        ),
                        Text('${_updateInterval}ms'),
                        const Spacer(),
                        FilledButton.icon(
                          onPressed: () {
                            setState(() {
                              _updateCount++;
                              if (_controller.columns == _buildStockColumns()) {
                                _updateStockData();
                              } else if (_controller.columns == _buildServerColumns()) {
                                _updateServerData();
                              } else {
                                _updateSensorData();
                              }
                            });
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Manual Update'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Info banner
              Container(
                padding: const EdgeInsets.all(12),
                color: _autoUpdate ? Colors.green.shade50 : Colors.blue.shade50,
                child: Row(
                  children: [
                    Icon(
                      _autoUpdate ? Icons.play_circle : Icons.pause_circle,
                      color: _autoUpdate ? Colors.green : Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _autoUpdate 
                          ? 'Live updates running every ${_updateInterval}ms. Watch the data change in real-time!'
                          : 'Auto-update paused. Enable it to see real-time data changes or use manual update.',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Data grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    child: VooDataGrid(
                      controller: _controller,
                      showPagination: false,
                      showToolbar: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper class for local data source
class LocalDataGridSource extends VooDataGridSource {
  LocalDataGridSource({
    List<dynamic>? data,
  }) : super(mode: VooDataGridMode.local) {
    if (data != null) {
      setLocalData(data);
    }
  }

  @override
  Future<VooDataGridResponse> fetchRemoteData({
    required int page,
    required int pageSize,
    required Map<String, VooDataFilter> filters,
    required List<VooColumnSort> sorts,
  }) async {
    // Not needed for local mode
    return VooDataGridResponse(
      rows: [],
      totalRows: 0,
      page: page,
      pageSize: pageSize,
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: VooDataGridRealtimePreview(),
  ));
}