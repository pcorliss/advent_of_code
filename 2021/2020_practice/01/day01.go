package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("01/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 01")
	fmt.Println("Result: ", Doubles(string(inputStr), 2020))

	fmt.Println("Day 02")
	fmt.Println("Result: ", Triples(string(inputStr), 2020))
}

func Ident(n int) int {
	return n
}

func StringToNums(input string) []int {
	nums := []int{}
	lines := strings.Split(input, "\n")
	for _, val := range lines {
		n, err := strconv.Atoi(val)
		if err != nil {
			panic(err)
		}
		nums = append(nums, n)
	}
	return nums
}

func Doubles(input string, target int) int {
	nums := StringToNums(input)

	compliment := make(map[int]int)

	for _, a := range nums {
		if x, found := compliment[a]; found {
			return a * x
		}

		compliment[target-a] = a
	}

	return 0
}

type Pair struct {
	x int
	y int
}

func Triples(input string, target int) int {
	nums := StringToNums(input)

	compliment := make(map[int]Pair)

	for i, a := range nums {
		for j, b := range nums {
			if i == j {
				continue
			}
			if pair, found := compliment[b]; found {
				return b * pair.x * pair.y
			}
			compliment[target-a-b] = Pair{a, b}
		}
	}

	return 0
}
