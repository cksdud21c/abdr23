// clothing_item.dart
class ClothingItem {
  String imageUrl;
  ClothingItem({
    required this.imageUrl, //required : 필수적으로 제공되어야 함을 나타냄.만약 클래스 생성시 저기에 아무 값이 들어가 있지 않으면 오류메세지가 발생되어 오류찾기에 수월.
  });
}