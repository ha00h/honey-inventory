import 'package:flutter/material.dart';

import '../../domain/entities/inventory_models.dart';

class IconOption {
  const IconOption({
    required this.key,
    required this.label,
    required this.icon,
  });

  final String key;
  final String label;
  final IconData icon;
}

class IconColorOption {
  const IconColorOption({required this.hex, required this.label});

  final String hex;
  final String label;
}

const iconColorOptions = <IconColorOption>[
  IconColorOption(hex: '#3D2E1F', label: '갈색'),
  IconColorOption(hex: '#F5C842', label: '꿀색'),
  IconColorOption(hex: '#E8A838', label: '호박'),
  IconColorOption(hex: '#FF8C69', label: '산호'),
  IconColorOption(hex: '#E57373', label: '빨강'),
  IconColorOption(hex: '#F48FB1', label: '분홍'),
  IconColorOption(hex: '#CE93D8', label: '보라'),
  IconColorOption(hex: '#64B5F6', label: '파랑'),
  IconColorOption(hex: '#4DB6AC', label: '민트'),
  IconColorOption(hex: '#81C784', label: '초록'),
  IconColorOption(hex: '#FFD54F', label: '노랑'),
  IconColorOption(hex: '#FFB74D', label: '주황'),
  IconColorOption(hex: '#A1887F', label: '베이지'),
  IconColorOption(hex: '#90A4AE', label: '회색'),
  IconColorOption(hex: '#FFFFFF', label: '흰색'),
  IconColorOption(hex: '#5D4037', label: '진갈'),
];

const iconOptions = <IconOption>[
  IconOption(key: 'tissue', label: '휴지', icon: Icons.layers_rounded),
  IconOption(key: 'water', label: '생수', icon: Icons.water_drop_rounded),
  IconOption(key: 'detergent', label: '세제', icon: Icons.cleaning_services_rounded),
  IconOption(key: 'soap', label: '비누', icon: Icons.soap_rounded),
  IconOption(key: 'shampoo', label: '샴푸', icon: Icons.shower_rounded),
  IconOption(key: 'toilet', label: '변기', icon: Icons.wc_rounded),
  IconOption(key: 'toothbrush', label: '칫솔', icon: Icons.health_and_safety_rounded),
  IconOption(key: 'towel', label: '수건', icon: Icons.dry_rounded),
  IconOption(key: 'trash', label: '쓰레기', icon: Icons.delete_outline_rounded),
  IconOption(key: 'vacuum', label: '청소기', icon: Icons.electrical_services_outlined),
  IconOption(key: 'broom', label: '빗자루', icon: Icons.cleaning_services_outlined),
  IconOption(key: 'hanger', label: '옷걸이', icon: Icons.checkroom_rounded),
  IconOption(key: 'iron', label: '다리미', icon: Icons.iron_rounded),
  IconOption(key: 'laundry', label: '세탁', icon: Icons.local_laundry_service_outlined),
  IconOption(key: 'kitchen', label: '주방', icon: Icons.kitchen_rounded),
  IconOption(key: 'fridge', label: '냉장고', icon: Icons.kitchen_outlined),
  IconOption(key: 'microwave', label: '전자렌지', icon: Icons.microwave_rounded),
  IconOption(key: 'blender', label: '믹서', icon: Icons.blender_rounded),
  IconOption(key: 'pan', label: '프라이팬', icon: Icons.countertops_rounded),
  IconOption(key: 'dish', label: '그릇', icon: Icons.flatware_rounded),
  IconOption(key: 'cup', label: '컵', icon: Icons.local_cafe_rounded),
  IconOption(key: 'rice', label: '쌀', icon: Icons.rice_bowl_rounded),
  IconOption(key: 'milk', label: '우유', icon: Icons.local_drink_rounded),
  IconOption(key: 'egg', label: '달걀', icon: Icons.egg_rounded),
  IconOption(key: 'coffee', label: '커피', icon: Icons.coffee_rounded),
  IconOption(key: 'bread', label: '빵', icon: Icons.bakery_dining_rounded),
  IconOption(key: 'apple', label: '과일', icon: Icons.eco_rounded),
  IconOption(key: 'ramen', label: '라면', icon: Icons.ramen_dining_rounded),
  IconOption(key: 'grocery', label: '장보기', icon: Icons.local_grocery_store_rounded),
  IconOption(key: 'light', label: '전구', icon: Icons.lightbulb_rounded),
  IconOption(key: 'battery', label: '건전지', icon: Icons.battery_full_rounded),
  IconOption(key: 'plug', label: '콘센트', icon: Icons.electrical_services_rounded),
  IconOption(key: 'remote', label: '리모컨', icon: Icons.settings_remote_rounded),
  IconOption(key: 'tv', label: 'TV', icon: Icons.tv_rounded),
  IconOption(key: 'phone', label: '휴대폰', icon: Icons.phone_android_rounded),
  IconOption(key: 'pill', label: '약', icon: Icons.medication_rounded),
  IconOption(key: 'bandage', label: '밴드', icon: Icons.healing_rounded),
  IconOption(key: 'firstaid', label: '구급', icon: Icons.medical_services_rounded),
  IconOption(key: 'pet', label: '반려', icon: Icons.pets_rounded),
  IconOption(key: 'baby', label: '육아', icon: Icons.child_care_rounded),
  IconOption(key: 'diaper', label: '기저귀', icon: Icons.baby_changing_station_rounded),
  IconOption(key: 'scissors', label: '가위', icon: Icons.content_cut_rounded),
  IconOption(key: 'tape', label: '테이프', icon: Icons.attachment_rounded),
  IconOption(key: 'paper', label: '종이', icon: Icons.description_rounded),
  IconOption(key: 'pen', label: '펜', icon: Icons.edit_rounded),
  IconOption(key: 'umbrella', label: '우산', icon: Icons.umbrella_rounded),
  IconOption(key: 'plant', label: '화분', icon: Icons.yard_rounded),
  IconOption(key: 'candle', label: '향초', icon: Icons.spa_rounded),
  IconOption(key: 'key', label: '열쇠', icon: Icons.vpn_key_rounded),
  IconOption(key: 'sock', label: '양말', icon: Icons.dry_cleaning_rounded),
  IconOption(key: 'shirt', label: '옷', icon: Icons.checkroom_outlined),
  IconOption(key: 'bed', label: '침구', icon: Icons.bed_rounded),
  IconOption(key: 'sofa', label: '소파', icon: Icons.weekend_rounded),
  IconOption(key: 'home', label: '집', icon: Icons.home_rounded),
  IconOption(key: 'spray', label: '스프레이', icon: Icons.sanitizer_rounded),
  IconOption(key: 'sponge', label: '수세미', icon: Icons.bubble_chart_rounded),
  IconOption(key: 'basket', label: '기타', icon: Icons.inventory_2_rounded),
  IconOption(key: 'cart', label: '카트', icon: Icons.shopping_cart_rounded),
  IconOption(key: 'box', label: '상자', icon: Icons.inventory_rounded),
  IconOption(key: 'lock', label: '자물쇠', icon: Icons.lock_rounded),
  IconOption(key: 'clock', label: '시계', icon: Icons.schedule_rounded),
  IconOption(key: 'book', label: '책', icon: Icons.menu_book_rounded),
  IconOption(key: 'mail', label: '우편', icon: Icons.mail_outline_rounded),
  IconOption(key: 'tools', label: '공구', icon: Icons.handyman_rounded),
  IconOption(key: 'car', label: '차량', icon: Icons.directions_car_rounded),
  IconOption(key: 'wipes', label: '물티슈', icon: Icons.dry_outlined),
  IconOption(key: 'mask', label: '마스크', icon: Icons.masks_rounded),
  IconOption(key: 'gloves', label: '장갑', icon: Icons.front_hand_rounded),
  IconOption(key: 'lotion', label: '로션', icon: Icons.opacity_rounded),
  IconOption(key: 'cotton', label: '솜', icon: Icons.cloud_rounded),
  IconOption(key: 'snack', label: '간식', icon: Icons.cookie_rounded),
  IconOption(key: 'ice', label: '얼음', icon: Icons.ac_unit_rounded),
  IconOption(key: 'fan', label: '선풍기', icon: Icons.air_rounded),
  IconOption(key: 'aircon', label: '에어컨', icon: Icons.ac_unit_outlined),
  IconOption(key: 'bag', label: '봉투', icon: Icons.shopping_bag_rounded),
  IconOption(key: 'wrap', label: '랩', icon: Icons.wrap_text_rounded),
  IconOption(key: 'seasoning', label: '조미료', icon: Icons.restaurant_rounded),
  IconOption(key: 'waterjug', label: '정수', icon: Icons.water_rounded),
];

final _iconByKey = {for (final option in iconOptions) option.key: option};

const categoryLabels = <ProductCategory, String>{
  ProductCategory.household: '생활용품',
  ProductCategory.food: '식료품',
  ProductCategory.hygiene: '위생용품',
  ProductCategory.kitchen: '주방',
  ProductCategory.laundry: '세탁',
  ProductCategory.bathroom: '욕실',
  ProductCategory.electronics: '전자',
  ProductCategory.medicine: '의약',
  ProductCategory.pet: '반려',
  ProductCategory.baby: '육아',
  ProductCategory.other: '기타',
};

IconData iconForKey(String key) {
  return _iconByKey[key]?.icon ?? Icons.inventory_2_rounded;
}

String iconLabelForKey(String key) {
  return _iconByKey[key]?.label ?? '기타';
}

Color parseIconColor(String hex, {Color fallback = const Color(0xFF3D2E1F)}) {
  final cleaned = hex.trim().replaceFirst('#', '');
  if (cleaned.length != 6 && cleaned.length != 8) {
    return fallback;
  }
  final value = int.tryParse(cleaned, radix: 16);
  if (value == null) {
    return fallback;
  }
  if (cleaned.length == 6) {
    return Color(0xFF000000 | value);
  }
  return Color(value);
}

Color iconColorForProduct({required String iconColor}) {
  return parseIconColor(iconColor);
}

Color contrastOnColor(Color background) {
  return background.computeLuminance() > 0.65
      ? const Color(0xFF3D2E1F)
      : Colors.white;
}
