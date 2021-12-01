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
	depths := StringToNums(input)
	prev := 0
	count := 0
	for _, val := range depths {
		if val > prev && prev != 0 {
			count++
		}
		prev = val
	}
	return count
}

func Part2(input string) int {
	depths := StringToNums(input)
	prev := 0
	count := 0
	for i, _ := range depths {
		if i > len(depths)-3 {
			break
		}
		sum := depths[i] + depths[i+1] + depths[i+2]
		if sum > prev && prev != 0 {
			count++
		}
		prev = sum
	}
	return count
}
