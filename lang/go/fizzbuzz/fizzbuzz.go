package main
import "fmt"

func main(){
  for i:=1; i<=100; i++ {
    fmt.Printf("%s\n", num2fb(i))
  }
}

func num2fb(num int) string {
  var ret = fmt.Sprintf("%d", num);
  if num % 15 == 0 {
    ret = "FizzBuzz"
  } else if num % 3 == 0 {
    ret = "Fizz"
  } else if num % 5 == 0 {
    ret = "Buzz"
  }
  return ret
}
