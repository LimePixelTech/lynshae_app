/// 用户模型
class UserModel {
  final String id;
  final String? uuid;
  final String username;
  final String email;
  final String? avatar;
  final String? nickname;
  final String? phone;
  final String? role;
  final int? roleId;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;

  const UserModel({
    required this.id,
    this.uuid,
    required this.username,
    required this.email,
    this.avatar,
    this.nickname,
    this.phone,
    this.role,
    this.roleId,
    this.createdAt,
    this.lastLoginAt,
  });

  /// 从 JSON 创建用户模型（适配后端 API）
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? '').toString(),
      uuid: json['uuid'] as String?,
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatar: json['avatar'] as String?,
      nickname: json['nickname'] as String?,
      phone: json['phone'] as String?,
      role: json['role'] as String?,
      roleId: json['roleId'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'] as String)
          : null,
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'username': username,
      'email': email,
      'avatar': avatar,
      'nickname': nickname,
      'phone': phone,
      'role': role,
      'created_at': createdAt?.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
    };
  }

  /// 复制并修改
  UserModel copyWith({
    String? id,
    String? uuid,
    String? username,
    String? email,
    String? avatar,
    String? nickname,
    String? phone,
    String? role,
    int? roleId,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      username: username ?? this.username,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      nickname: nickname ?? this.nickname,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      roleId: roleId ?? this.roleId,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}
