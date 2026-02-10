import 'package:flutter/material.dart';
import '../../config/app_constants.dart';

// Local Data Model for User
// Local Data Model matching API Contract Response
class _User {
  final String uid;
  final String name;
  final String email;
  final String role; 
  final String? imageUrl;
  final bool isOnline; 

  _User({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    this.imageUrl,
    this.isOnline = false,
  });

  factory _User.fromMap(Map<String, dynamic> map) {
    return _User(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'Customer',
      imageUrl: map['image_url'],
      isOnline: map['is_online'] ?? false,
    );
  }
}

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All', 'Admin', 'Courier', 'Warehouse', 'Customer'];

  // MOCK RAW RESPONSE from AdminProvider.getAllUsers()
  final List<Map<String, dynamic>> _mockApiResponse = [
    {
      'uid': 'u1',
      'name': 'Sarah Jenkins',
      'email': 'sarah.j@logitrack.com',
      'role': 'Admin',
      'image_url': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBB2NFd-UOkhpxP6H7k5n9NdE5_KWwpEx8PH5SQRhrbqf8cV4UtY8u2yTEqNEfrUosinFifhDEMRjgHnP2BXDTd8_7A0xv6rJvYaT3GvxIIvJx6X5msYkIZ3WlxgNigxmoyj9Bv2pSyDltieZfCIYklWf7bRwmn6o5sdNYPDwUX6MwlqLQkBlYuipFJTSlRcmjDulDt0TLtSQ1uMtdwaCs_O4LtPJgyUDt-2Ge3AFg2WyYkkh5rCvF6Y1XQcIOT5qyWGQFQn5uCFbM',
      'is_online': true
    },
    {
      'uid': 'u2',
      'name': 'Mike Ross',
      'email': 'mike.ross@delivery.com',
      'role': 'Courier',
      'image_url': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDwPjIkIlxPyXqCxs7NI0RTPErpI8oY15RTECjML9wjPTe7QlXOoj3TkvZJ1SbbEe5yr6DFegy8jEELdHsPqZ0e6jO2z11yZLb88j52-adcfMbJxUrIoq_fu9SjL2Fy668C1iLsP5j5AmPcjTyzc8tRv_gPtazl0OiMt76GF1bj-FFzVBPNwx2X9RWor6vqE1CxlYnVMOyPFpm2IdUQoMOy8Ugxm-XLOTgoJpqQPE8QOeIY7t9Y66DM97MEIF-hcxxU4bWgZA9bKKI',
      'is_online': false
    },
    {
      'uid': 'u3',
      'name': 'Central Depot',
      'email': 'dispatch@depot01.com',
      'role': 'Warehouse',
      'is_online': true
    },
    {
      'uid': 'u4',
      'name': 'John Doe',
      'email': 'john.d@gmail.com',
      'role': 'Customer',
      'image_url': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCrMImsBtiszvyt9fYF-JB1rKEIJKBH7-Pvzp5mGxmVL_khQM-9dXpklsS2pg2Xvge34MKzeBGAIQku4no2pb1GKVHiPOi23bYyh1iY45QavJ-tqT4VxQGqgSbyQqzfs9-nGnp10fjaNHEe3eLt9LrtU9sScUJluWl8JI-K33bmPEEMESjp0BDL0q4rf_k_H2PRsY_lTmctGpttmPBD5t0mWluv-HTl1OdzXzCwuX0MOBoLuk0JhxsET-4gqs-Jaw6e8LBr0kC5GY0',
      'is_online': false
    },
    {
      'uid': 'u5',
      'name': 'David Kim',
      'email': 'd.kim_express@logitrack.com',
      'role': 'Courier',
      'image_url': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCzbYziEapLgZdNzTG6YbbMljtk02rlIF0_IsMQ8osIMzZbtuF_5o2jdV64zneEeysgR9d6ccZogMWb3ZDPx2tOI9ylfjXfpDzv4wd4ua_RFpc4QHxhy4qIuMswt73g97pfBLVwPBTdELlv-DxblsjCy_WSevSZDYE-g15sFqjeD76-MMpt-h3mF_YrX5qXfexNX6pUNtZper2wSq0jNu5AeDHgBl87uV3dgZt6-Zl-1SyiqGsCTm4zbQ9kXe9rLMyYwqnwP5jZjTc',
      'is_online': true
    },
    {
      'uid': 'u6',
      'name': 'Emily White',
      'email': 'emily.w@outlook.com',
      'role': 'Customer',
      'is_online': false
    },
     {
      'uid': 'u7',
      'name': 'Robert Fox',
      'email': 'r.fox@logitrack.com',
      'role': 'Warehouse',
      'image_url': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCkhU_lcXldtAt71R76MHlRtku5zBwc7F3aK-2ycPbJ5oB02vG1Y_YpnpdMm7qzL2BS2ygrVthwa2ilqfr8F7LU8bsmAapDDjlhQlESxg0nUgSOJhYQHWOy1xnDT6djkJvICeqjwP03I6a7VID0DdMgulJMhwnaazLaUrTnjYCuYu1bnKf85Ffw9jWtC6MqJsMULIitRBgffnvlpYUP_WoknZnKIOBkMYrW6ihgfTKLIlhoBJKK0QaWg2DhKMR73uiyxuzX_0H4gpM',
      'is_online': true
    },
  ];

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    // Colors
    final backgroundColor = isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight;
    final surfaceColor = isDarkMode ? const Color(0xFF172a2d) : Colors.white; // Custom surface from mockup
    final textColor = isDarkMode ? AppColors.textLight : AppColors.textDark;
    final subTextColor = isDarkMode ? AppColors.textGrayDark : AppColors.textGray;
    final borderColor = isDarkMode ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05);

    // 0. Convert RAW JSON to Model (Simulate Provider)
    final allUsers = _mockApiResponse.map((json) => _User.fromMap(json)).toList();

    // Filter Users
    final filteredUsers = allUsers.where((user) {
      if (_selectedFilterIndex != 0 && user.role != _filters[_selectedFilterIndex]) {
        return false;
      }
      // Implementasi pencarian lokal
      final query = _searchController.text.toLowerCase();
      return user.name.toLowerCase().contains(query) || user.email.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Row(
                     children: [
                       Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            width: 40, height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                            ),
                            child: Icon(Icons.arrow_back, color: textColor),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('Manage Users', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
                     ],
                   ),
                   Container(
                     width: 40, height: 40,
                     decoration: BoxDecoration(
                       color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                       shape: BoxShape.circle,
                     ),
                     child: Icon(Icons.add, color: textColor),
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
                  border: Border.all(color: isDarkMode ? Colors.grey.withOpacity(0.2) : Colors.grey[200]!),
                ),
                child: TextField(
                  controller: _searchController,
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
                    onSelected: (val) => setState(() => _selectedFilterIndex = index),
                    backgroundColor: isDarkMode ? surfaceColor : Colors.grey[200],
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : (isDarkMode ? Colors.grey[300] : Colors.black87),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  );
                },
              ),
            ),
             const SizedBox(height: 8),
             Divider(height: 1, color: borderColor),

            // 4. User List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: filteredUsers.length,
                separatorBuilder: (c, i) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  return _buildUserItem(user, surfaceColor, textColor, subTextColor, isDarkMode);
                },
              ),
            ),
          ],
        ),
      ),
      // FAB for mobile
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.person_add, color: Colors.black),
      ),
    );
  }

  Widget _buildUserItem(_User user, Color surfaceColor, Color textColor, Color subTextColor, bool isDarkMode) {
    return InkWell(
      onTap: (){},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          // hover effect handled by InkWell, but base color can be transparent or surface
        ),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                 if (user.imageUrl != null)
                   Container(
                     width: 48, height: 48,
                     decoration: BoxDecoration(
                       shape: BoxShape.circle,
                       image: DecorationImage(image: NetworkImage(user.imageUrl!), fit: BoxFit.cover),
                     ),
                   )
                 else
                     Container(
                       width: 48, height: 48,
                       decoration: BoxDecoration(
                         color: Colors.grey[300],
                         shape: BoxShape.circle,
                       ),
                       alignment: Alignment.center,
                       child: Text(
                         user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                         style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                       ),
                     ),
                 
                 if (user.isOnline || user.role == 'Courier') // Show status dot for demo
                   Positioned(
                     bottom: 0, right: 0,
                     child: Container(
                       width: 12, height: 12,
                       decoration: BoxDecoration(
                         color: user.isOnline ? Colors.green : Colors.amber,
                         shape: BoxShape.circle,
                         border: Border.all(color: isDarkMode ? AppColors.backgroundDark : Colors.white, width: 2),
                       ),
                     ),
                   )
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                     children: [
                        Text(user.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const Spacer(),
                        _buildRoleBadge(user.role),
                     ],
                   ),
                   const SizedBox(height: 2),
                   Text(user.email, style: TextStyle(fontSize: 14, color: subTextColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.more_vert, color: subTextColor),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRoleBadge(String role) {
    Color bg;
    Color text;
    switch (role) {
      case 'Admin':
        bg = AppColors.primary.withOpacity(0.2);
        text = AppColors.primary;
        break;
      case 'Courier':
        bg = Colors.orange.withOpacity(0.2);
        text = Colors.orange;
        break;
      case 'Warehouse':
        bg = Colors.indigo.withOpacity(0.2);
        text = Colors.indigo;
        break;
      case 'Customer':
        bg = Colors.green.withOpacity(0.2);
        text = Colors.green;
        break;
      default:
        bg = Colors.grey.withOpacity(0.2);
        text = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Text(role.toUpperCase(), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: text)),
    );
  }
}
