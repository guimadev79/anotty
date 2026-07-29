import 'package:anotty/features/home/presentation/widgets/recent_clients.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:anotty/models/cliente.dart';
import 'package:anotty/models/movimentacao.dart';
import 'package:anotty/core/theme/app_colors.dart';
import 'package:anotty/core/theme/app_spacing.dart';
import 'package:anotty/core/widgets/app_scaffold.dart';
import 'package:anotty/core/widgets/dashboard_card.dart';
import 'package:anotty/core/widgets/empty_state.dart';
import 'package:anotty/core/services/cobranca_service.dart';
import '../../clientes/pages/clientes_page.dart';
import '../../cobrancas/pages/cobrancas_page.dart';
import '../../configuracoes/pages/configuracoes_page.dart';
import '../../relatorios/pages/relatorios_page.dart';
import '../widgets/balance_card.dart';
import '../widgets/home_header.dart';
import '../widgets/quick_actions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Cliente>('clientes');
    final movimentacoesBox = Hive.box<Movimentacao>('movimentacoes');
    final List<Widget> pages = [
      // Aba 0: Home (Dashboard)
      ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Cliente> boxClientes, _) {
          return ValueListenableBuilder(
            valueListenable: movimentacoesBox.listenable(),
            builder: (context, Box<Movimentacao> boxMovimentacoes, _) {
              final lista = boxClientes.values.toList();
              final total = lista.fold<double>(
                0,
                (soma, cliente) => soma + cliente.saldo,
              );
              final moeda = NumberFormat.currency(
                locale: 'pt_BR',
                symbol: 'R\$',
              );
              final movimentacoes = boxMovimentacoes.values.toList();

              // Cálculos inteligentes para o Dashboard corrigidos
              final vendasNaoQuitadas = movimentacoes.where(
                (m) =>
                    m.tipo == TipoMovimentacao.venda &&
                    !m.quitada &&
                    m.dataPrevistaPagamento != null,
              ).toList();

              double totalVencido = 0;
              double totalAReceber = 0;
              int qtdVencidas = 0;

              for (var venda in vendasNaoQuitadas) {
                final statusEnum = CobrancaService.obterStatus(venda);
                totalAReceber += venda.valor;
                
                // Verificação corrigida utilizando o Enum ou o nome do status em string
                if (statusEnum.name.toLowerCase().contains('vencido')) {
                  totalVencido += venda.valor;
                  qtdVencidas++;
                }
              }

              final vendas = movimentacoes
                  .where((m) => m.tipo == TipoMovimentacao.venda)
                  .fold<double>(0, (soma, m) => soma + m.valor);
              final pagamentos = movimentacoes
                  .where((m) => m.tipo == TipoMovimentacao.pagamento)
                  .fold<double>(0, (soma, m) => soma + m.valor);
              final descontos = movimentacoes
                  .where((m) => m.tipo == TipoMovimentacao.desconto)
                  .fold<double>(0, (soma, m) => soma + m.valor);

              return AppScaffold(
                backgroundColor: AppColors.background,
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HomeHeader(),
                        const SizedBox(height: 24),
                        BalanceCard(
                          total: total,
                          clientesDevendo: lista
                              .where((c) => c.saldo > 0)
                              .length,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 130,
                                child: DashboardCard(
                                  title: 'Clientes',
                                  value: lista.length.toString(),
                                  icon: Icons.people,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SizedBox(
                                height: 130,
                                child: DashboardCard(
                                  title: 'A Receber',
                                  value: moeda.format(totalAReceber),
                                  icon: Icons.account_balance_wallet,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 130,
                                child: DashboardCard(
                                  title: 'Vencidos',
                                  value: moeda.format(totalVencido),
                                  icon: Icons.warning_amber_rounded,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SizedBox(
                                height: 130,
                                child: DashboardCard(
                                  title: 'Recebimentos',
                                  value: moeda.format(pagamentos),
                                  icon: Icons.payments,
                                  color: AppColors.success,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 130,
                                child: DashboardCard(
                                  title: 'Vendas',
                                  value: moeda.format(vendas),
                                  icon: Icons.shopping_cart,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SizedBox(
                                height: 130,
                                child: DashboardCard(
                                  title: 'Descontos',
                                  value: moeda.format(descontos),
                                  icon: Icons.discount,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        const QuickActions(),
                        const SizedBox(height: 28),
                        if (lista.isEmpty)
                          const EmptyState(
                            icon: Icons.people_outline_rounded,
                            title: 'Nenhum cliente cadastrado',
                            subtitle:
                                'Cadastre seu primeiro cliente para começar.',
                          )
                        else
                          RecentClients(clientes: lista),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      // Aba 1: Clientes
      const ClientesPage(),
      // Aba 2: Cobranças
      const CobrancasPage(),
      // Aba 3: Relatórios
      const RelatoriosPage(),
      // Aba 4: Configurações
      const ConfiguracoesPage(),
    ];
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationBar(
            backgroundColor: Colors.white,
            indicatorColor: const Color(0xFFE8F5E9),
            surfaceTintColor: Colors.transparent,
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined, color: Colors.grey),
                selectedIcon: Icon(Icons.home, color: Color(0xFF4CAF50)),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.people_outline, color: Colors.grey),
                selectedIcon: Icon(Icons.people, color: Color(0xFF4CAF50)),
                label: 'Clientes',
              ),
              NavigationDestination(
                icon: Icon(Icons.receipt_long_outlined, color: Colors.grey),
                selectedIcon: Icon(
                  Icons.receipt_long,
                  color: Color(0xFF4CAF50),
                ),
                label: 'Cobrança',
              ),
              NavigationDestination(
                icon: Icon(Icons.bar_chart_outlined, color: Colors.grey),
                selectedIcon: Icon(Icons.bar_chart, color: Color(0xFF4CAF50)),
                label: 'Relatórios',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined, color: Colors.grey),
                selectedIcon: Icon(Icons.settings, color: Color(0xFF4CAF50)),
                label: 'Config.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}