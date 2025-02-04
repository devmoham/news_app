
class SearchBody {
  final String q;
  final String? searchIn;
  final int? pageSize;
  final int? page;
  
  SearchBody({
    required this.q,
    this.searchIn = 'title',
    this.pageSize = 15,
    this.page = 1,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'q': q,
      'searchIn': searchIn,
      'pageSize': pageSize,
      'page': page,
    };
  }

  factory SearchBody.fromMap(Map<String, dynamic> map) {
    return SearchBody(
      q: map['q'] as String,
      searchIn: map['searchIn'] != null ? map['searchIn'] as String : null,
      pageSize: map['pageSize'] != null ? map['pageSize'] as int : null,
      page: map['page'] != null ? map['page'] as int : null,
    );
  }


}
