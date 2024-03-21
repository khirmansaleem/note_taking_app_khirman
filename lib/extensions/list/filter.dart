

 extension Filter<T> on Stream<List<T>>{
  // return stream<list<T>> -->
   //filter items and add them to map if they pass the condition
   // in callback 'condition()'
  Stream<List<T>> filter(bool Function(T) condition)=>
      map((items) => items.where(condition).toList());


}