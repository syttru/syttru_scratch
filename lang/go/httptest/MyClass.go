package main

import "fmt"

type MyClass struct {
  Num1 int;
  Num2 int;
}

func (me *MyClass) Tasu() int {
  return me.Num1 + me.Num2
}

func main(){
  var obj MyClass;
  obj.Num1 = 1;
  obj.Num2 = 2;

  var obj2 MyClass;
  obj2.Num1 = 3;
  obj2.Num2 = 4;

  fmt.Printf("%d + %d = %d\n", obj.Num1, obj.Num2, obj.Tasu());
  fmt.Printf("%d + %d = %d\n", obj2.Num1, obj2.Num2, obj2.Tasu());
}

