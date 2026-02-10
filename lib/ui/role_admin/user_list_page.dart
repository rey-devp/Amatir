import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../providers/admin_provider.dart';
import '../../models/user_model.dart';
import '../../utils/ui_utils.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex = 0;
  final List<String> _filters = [
    'All',
    'Admin',
    'Courier',
    'Warehouse',
    'Customer',
  ];

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    final backgroundColor = isDarkMode
        ? AppColors.backgroundDark
        : AppColors.backgroundLight;
    final surfaceColor = isDarkMode ? const Color(0xFF172a2d) : Colors.white;
    final textColor = isDarkMode ? AppColors.textLight : AppColors.textDark;
    final subTextColor = isDarkMode
        ? AppColors.textGrayDark
        : AppColors.textGray;
    final borderColor = isDarkMode
        ? Colors.white.withOpacity(0.05)
        : Colors.black.withOpacity(0.05);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.arrow_back, color: textColor),
                    style: IconButton.styleFrom(
                      backgroundColor: isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.05),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Manage Users',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.add, color: textColor),
                    style: IconButton.styleFrom(
                      backgroundColor: isDarkMode
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.05),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDarkMode
                        ? Colors.grey.withOpacity(0.2)
                        : Colors.grey[200]!,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: subTextColor),
                    hintText: 'Search by name or email...',
                    hintStyle: TextStyle(color: subTextColor),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            // 3. Filter Chips
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filters.length,
                separatorBuilder: (c, i) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final isSelected = _selectedFilterIndex == index;
                  return FilterChip(
                    label: Text(_filters[index]),
                    selected: isSelected,
                    onSelected: (val) =>
                        setState(() => _selectedFilterIndex = index),
                    backgroundColor: isDarkMode
                        ? surfaceColor
                        : Colors.grey[200],
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.black
                          : (isDarkMode ? Colors.grey[300] : Colors.black87),
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    showCheckmark: false,
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Divider(height: 1, color: borderColor),

            // 4. User List
            Expanded(
              child: StreamBuilder<List<UserModel>>(
                stream: adminProvider.getUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'No users found',
                        style: TextStyle(color: subTextColor),
                      ),
                    );
                  }

                  final query = _searchController.text.toLowerCase();
                  final filteredUsers = snapshot.data!.where((user) {
                    final filterMatch =
                        _selectedFilterIndex == 0 ||
                        user.role.toLowerCase() ==
                            _filters[_selectedFilterIndex].toLowerCase();
                    final searchMatch =
                        user.name.toLowerCase().contains(query) ||
                        user.email.toLowerCase().contains(query);
                    return filterMatch && searchMatch;
                  }).toList();

                  return ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredUsers.length,
                    separatorBuilder: (c, i) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      return _buildUserItem(
                        filteredUsers[index],
                        textColor,
                        subTextColor,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserItem(UserModel user, Color textColor, Color subTextColor) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withOpacity(0.1),
        child: Text(
          user.name[0].toUpperCase(),
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        user.name,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        user.email,
        style: TextStyle(color: subTextColor, fontSize: 12),
      ),
      trailing: _buildRoleBadge(user.role),
      onTap: () {},
    );
  }

  Widget _buildRoleBadge(String role) {
    final color = UiUtils.getRoleColor(role);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        role.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
