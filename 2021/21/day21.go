package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("21/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 21")
	fmt.Println("Part 01")
	fmt.Println("Result: ", Part1(string(inputStr)))

	fmt.Println("Part 02")
	fmt.Println("Result: ", Part2(string(inputStr)))
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

func Part1(input string) int {
	return 0
}

func Part2(input string) int {
	return 0
}
