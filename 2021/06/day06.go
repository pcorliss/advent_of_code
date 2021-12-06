package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("06/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 06")
	fmt.Println("Part 01")
	fmt.Println("Result: ", Part1(string(inputStr), 80))

	fmt.Println("Part 02")
	fmt.Println("Result: ", Part1(string(inputStr), 256))
}

func StringToNums(input string) []int {
	nums := []int{}
	lines := strings.Split(input, ",")
	for _, val := range lines {
		n, err := strconv.Atoi(val)
		if err != nil {
			panic(err)
		}
		nums = append(nums, n)
	}
	return nums
}

func CountByNum(nums []int) map[int]int {
	counts := make(map[int]int)
	for _, num := range nums {
		counts[num]++
	}

	return counts
}

func Part1(input string, days int) int {
	counts := CountByNum(StringToNums(input))
	for day := 1; day <= days; day++ {
		newCount := make(map[int]int)
		for age, fishCount := range counts {
			newAge := age - 1
			if newAge < 0 {
				newAge = 6
				newCount[8] += fishCount
			}
			newCount[newAge] += fishCount
		}
		counts = newCount
	}

	sum := 0
	for _, fishCount := range counts {
		sum += fishCount
	}

	return sum
}

func Part2(input string) int {
	return 0
}
