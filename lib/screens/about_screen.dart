import 'package:flutter/material.dart';
import '../../common/components/settings_tile.dart';
import '../../common/components/app_navbar.dart';
import '../../theme/app_theme.dart';
import '../../utils/app_utils.dart';

/// 关于灵羲界面
///
/// 包含：用户协议、隐私政策、使用条款等
class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkSurface,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 顶部导航栏
              const AppNavbar(title: '关于灵羲', showNotification: false),
              const SizedBox(height: 32),
              // Logo 和名称
              _buildLogoSection(),
              const SizedBox(height: 24),
              // 设置卡片
              _buildSettingsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Column(
      children: [
        // 占位 Logo
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryBlue.withAlpha(100),
                AppTheme.primaryBlue.withAlpha(50),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(
            Icons.rocket_rounded,
            color: AppTheme.primaryBlue,
            size: 60,
          ),
        ),
        const SizedBox(height: 20),
        // 应用名称
        const Text(
          '灵羲',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 8),
        // 副标题
        Text(
          'LynShae · Smart Robot Companion',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white30,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        // 版本号
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'v1.0.0',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white54,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard() {
    return SettingsCard(
      children: [
        SettingsTile(
          icon: Icons.description_outlined,
          title: '用户协议',
          onTap: _showUserAgreement,
        ),
        SettingsTile(
          icon: Icons.privacy_tip_outlined,
          title: '隐私政策',
          onTap: _showPrivacyPolicy,
        ),
        SettingsTile(
          icon: Icons.gavel_outlined,
          title: '使用条款',
          onTap: _showTermsOfService,
          showDivider: false,
        ),
      ],
    );
  }

  void _showUserAgreement() {
    AppUtils.vibrate();
    _showDetailPage(
      title: '用户协议',
      content: _buildUserAgreementContent(),
    );
  }

  void _showPrivacyPolicy() {
    AppUtils.vibrate();
    _showDetailPage(
      title: '隐私政策',
      content: _buildPrivacyPolicyContent(),
    );
  }

  void _showTermsOfService() {
    AppUtils.vibrate();
    _showDetailPage(
      title: '使用条款',
      content: _buildTermsOfServiceContent(),
    );
  }

  void _showDetailPage({required String title, required Widget content}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: AppTheme.darkSurface,
          body: SafeArea(
            child: Column(
              children: [
                // 顶部导航栏
                AppNavbar(title: title, showNotification: false),
                // 内容区域
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: content,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserAgreementContent() {
    return _buildTextContent([
      '欢迎使用灵羲智能机器狗伴侣应用。在使用我们的服务前，请您仔细阅读并理解本用户协议的全部内容。',
      '一、服务说明',
      '1.1 灵羲应用提供智能机器狗设备控制、实时互动、情感陪伴等服务。',
      '1.2 您需要拥有 compatible 的灵羲品牌设备才能使用本应用的核心功能。',
      '1.3 我们保留随时修改、暂停或终止部分或全部服务的权利。',
      '二、用户行为规范',
      '2.1 您承诺使用本应用时遵守相关法律法规。',
      '2.2 您不得利用本应用从事任何违法、违规或侵犯他人权益的行为。',
      '2.3 您不得对本应用进行反向工程、反编译或试图提取源代码。',
      '三、隐私保护',
      '3.1 我们重视您的隐私保护，具体政策请参见《隐私政策》。',
      '3.2 我们会采取合理的安全措施保护您的个人信息。',
      '四、知识产权',
      '4.1 本应用及其内容归灵羲公司所有，受知识产权法律保护。',
      '4.2 未经书面许可，您不得使用本应用的任何商标、标识或内容。',
      '五、免责声明',
      '5.1 本应用按"现状"提供，不保证服务完全无中断或无错误。',
      '5.2 因不可抗力导致的服务中断，我们不承担责任。',
      '六、协议变更',
      '6.1 我们有权随时修改本协议条款。',
      '6.2 修改后的协议一经公布即生效，恕不另行通知。',
      '七、联系方式',
      '如有任何问题，请联系：support@lingxi.com',
    ]);
  }

  Widget _buildPrivacyPolicyContent() {
    return _buildTextContent([
      '灵羲应用重视您的隐私保护。本隐私政策说明我们如何收集、使用和保护您的个人信息。',
      '一、信息收集',
      '1.1 账号信息：注册时提供的手机号、邮箱等。',
      '1.2 设备信息：设备型号、系统版本、唯一设备标识符。',
      '1.3 使用数据：功能使用频率、操作记录、偏好设置。',
      '1.4 位置信息：经您授权后收集的地理位置数据。',
      '二、信息使用',
      '2.1 提供、维护和改进我们的服务。',
      '2.2 开发新功能，提升用户体验。',
      '2.3 向您发送服务通知、更新提醒。',
      '2.4 在获得您同意的情况下用于营销推广。',
      '三、信息共享',
      '3.1 我们不会向第三方出售、出租或交易您的个人信息。',
      '3.2 以下情况可能会共享信息：',
      '  - 获得您的明确同意',
      '  - 履行法律义务',
      '  - 与服务提供商合作（如云存储）',
      '四、信息安全',
      '4.1 我们采用加密技术保护您的数据传输和存储安全。',
      '4.2 仅限授权人员可访问您的个人信息。',
      '4.3 发生数据泄露时我们会及时通知您。',
      '五、您的权利',
      '5.1 访问权：您可以查看我们持有的您的个人信息。',
      '5.2 更正权：您可以要求更正不准确的个人信息。',
      '5.3 删除权：在特定情况下您可以要求删除个人信息。',
      '5.4 撤回同意：您可以随时撤回之前给予的同意。',
      '六、政策更新',
      '6.1 本政策可能不定期更新。',
      '6.2 重大变更时我们会通过应用内通知告知您。',
      '七、联系我们',
      '隐私相关问题请联系：privacy@lingxi.com',
    ]);
  }

  Widget _buildTermsOfServiceContent() {
    return _buildTextContent([
      '欢迎使用灵羲智能机器狗伴侣应用。请使用本应用前仔细阅读并同意本使用条款。',
      '一、账号注册与使用',
      '1.1 您需要注册账号才能使用本应用的部分功能。',
      '1.2 您应保证注册信息的真实性和准确性。',
      '1.3 您应妥善保管账号密码，不得将账号出借或转让给他人使用。',
      '二、用户行为规范',
      '2.1 您应遵守相关法律法规，不得利用本应用从事任何违法违规活动。',
      '2.2 您不得利用本应用制作、复制、发布含有违法内容的信息。',
      '2.3 您不得对本应用进行反向工程、破解或开发衍生产品。',
      '三、设备使用安全',
      '3.1 请按照产品说明书正确使用灵羲设备。',
      '3.2 请勿将设备用于危险环境或可能造成人身伤害的场景。',
      '3.3 儿童使用设备时应有成年人监护。',
      '四、知识产权',
      '4.1 本应用及其内容归灵羲公司所有，受知识产权法律保护。',
      '4.2 未经书面许可，您不得使用本应用的任何商标、标识或内容。',
      '五、免责声明',
      '5.1 本应用按"现状"提供，不保证服务完全无中断或无错误。',
      '5.2 因不可抗力、网络攻击等原因导致的服务中断，我们不承担责任。',
      '5.3 因用户操作不当或设备故障造成的损失，我们不承担责任。',
      '六、服务变更与终止',
      '6.1 我们保留随时修改、暂停或终止部分或全部服务的权利。',
      '6.2 服务终止后，我们会尽可能提前通知您。',
      '七、条款变更',
      '7.1 我们有权随时修改本使用条款。',
      '7.2 修改后的条款一经公布即生效，恕不另行通知。',
      '八、联系我们',
      '如有任何问题，请联系：support@lingxi.com',
    ]);
  }

  Widget _buildTextContent(List<String> paragraphs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragraphs.map((text) {
        final isSection = text.startsWith('一、') ||
            text.startsWith('二、') ||
            text.startsWith('三、') ||
            text.startsWith('四、') ||
            text.startsWith('五、') ||
            text.startsWith('六、') ||
            text.startsWith('七、');

        return Padding(
          padding: EdgeInsets.only(
            bottom: isSection ? 12 : 8,
            top: isSection ? 16 : 0,
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: isSection ? 16 : 14,
              fontWeight: isSection ? FontWeight.w600 : FontWeight.normal,
              color: isSection ? Colors.white : Colors.white70,
              height: 1.8,
            ),
          ),
        );
      }).toList(),
    );
  }
}
