import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SidebarItem {
  final Widget icon;
  final Widget iconInactive;
  final int index;
  final String route; // ✅ 新增路由字段
  String title;

  SidebarItem({
    required this.icon,
    required this.iconInactive,
    required this.index,
    required this.route, // ✅ 新增
    this.title = "",
  });
}

class SidebarItemWidget extends StatelessWidget {
  const SidebarItemWidget({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final SidebarItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Tooltip(
          message: item.title,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: isSelected ? Colors.grey[200] : Colors.white,
            ),
            width: 30,
            height: 30,
            child: isSelected ? item.icon : item.iconInactive,
          ),
        ),
      ),
    );
  }
}

class SimpleLayout extends StatelessWidget {
  const SimpleLayout({
    super.key,
    required this.items,
    required this.child,
    required this.selectedIndex,
    required this.onIndexChanged,
    this.decoration,
    this.elevation = 10,
    this.padding = 10,
    this.backgroundColor = Colors.white,
  });

  final List<SidebarItem> items;
  final Widget child;
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;

  final Decoration? decoration;
  final double elevation;
  final double padding;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
            child: Material(
              elevation: elevation,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children:
                      items.map((item) {
                        final isSelected = item.index == selectedIndex;
                        return SidebarItemWidget(
                          item: item,
                          isSelected: isSelected,
                          onTap: () => onIndexChanged(item.index),
                        );
                      }).toList(),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: elevation,
                child: Container(decoration: decoration, child: child),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SimpleLayoutShell extends StatelessWidget {
  final Widget child;
  const SimpleLayoutShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location =
        GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();

    final items = [
      SidebarItem(
        icon: const Icon(Icons.dataset, color: Colors.blueAccent),
        iconInactive: const Icon(Icons.dataset),
        index: 0,
        title: "知识库",
        route: "/",
      ),
      SidebarItem(
        icon: const Icon(Icons.square_outlined, color: Colors.blueAccent),
        iconInactive: const Icon(Icons.square_outlined),
        index: 1,
        title: "问答",
        route: "/chat",
      ),
    ]..sort((a, b) => a.index.compareTo(b.index));

    final currentIndex = items.indexWhere((item) => item.route == location);

    return SimpleLayout(
      items: items,
      selectedIndex: currentIndex < 0 ? 0 : currentIndex,
      onIndexChanged: (index) {
        final route = items[index].route;
        if (location != route) {
          context.go(route);
        }
      },
      child: child,
    );
  }
}
