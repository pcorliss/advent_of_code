package main

import (
	"fmt"
	"math"
	"os"
	"strconv"
	"strings"
)

func main() {
	// Load Input File
	inputStr, err := os.ReadFile("03/input.txt")
	if err != nil {
		panic(err)
	}

	fmt.Println("Day 03")
	fmt.Println("Part 01")
	fmt.Println("Result: ", Part1(string(inputStr)))

	fmt.Println("Part 02")
	fmt.Println("Result: ", Part2(string(inputStr)))
}

func StringToArr(input string) [][]int {
	nums := [][]int{}
	lines := strings.Split(input, "\n")
	for _, val := range lines {
		chars := strings.Split(val, "")
		num_arr := []int{}
		for _, char := range chars {
			n, err := strconv.Atoi(char)
			if err != nil {
				panic(err)
			}
			num_arr = append(num_arr, n)
		}
		nums = append(nums, num_arr)
	}
	return nums
}

func Part1(input string) [3]int {
	num_arr := StringToArr(input)
	length := len(num_arr[0])
	input_length := len(num_arr)
	count := []int{}
	for i := 0; i < length; i++ {
		count = append(count, 0)
	}
	for _, num := range num_arr {
		for i, n := range num {
			if n == 1 {
				count[i] += 1
			}
		}
	}
	gamma := 0
	episolon := 0

	for i, cnt := range count {
		exp := int(math.Pow(2, float64(length-1-i)))
		if cnt >= input_length/2 {
			// 1 is the most common bit
			gamma = gamma | exp
		} else {
			episolon = episolon | exp
		}
		// fmt.Println("Bit:", i, "Exp:", exp, "Count:", cnt, "Length:", input_length/2)
		// fmt.Println("Gamma:", gamma, "Episolon:", episolon)
	}

	out := [3]int{gamma, episolon, gamma * episolon}

	return out
}

func Part2(input string) int {
	return 0
}
