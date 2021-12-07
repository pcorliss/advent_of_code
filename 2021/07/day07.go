package main

import (
	"fmt"
	"os"
	"sort"
	"strconv"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("07/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 07")
	fmt.Println("Part 01")
	fmt.Println("Result: ", Part1(string(inputStr)))

	fmt.Println("Part 02")
	fmt.Println("Result: ", Part2(string(inputStr)))
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

// https://guilherme-ferreira.me/internet-and-inovation/go-lang/calculating-mean-and-median-using-go/
func CalcMedian(nums []int) int {
	sort.Ints(nums) // sort the numbers

	mNumber := len(nums) / 2

	if mNumber%2 == 1 {
		return nums[mNumber]
	}

	return (nums[mNumber-1] + nums[mNumber]) / 2
}

func Part1(input string) []int {
	nums := StringToNums(input)
	med := CalcMedian(nums)

	fuel := 0
	for _, n := range nums {
		diff := n - med
		if diff < 0 {
			diff *= -1
		}
		fuel += diff
	}

	return []int{med, fuel}
}

func Part2(input string) int {
	return 0
}
