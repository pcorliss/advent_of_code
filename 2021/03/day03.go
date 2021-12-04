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
	count := mostCommonBits(num_arr)
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

func mostCommonBits(num_arr [][]int) []int {
	count := []int{}
	length := len(num_arr[0])
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
	return count
}

func filter(num_arr [][]int, bit int, on bool, test func([]int, int, bool) bool) (ret [][]int) {
	for _, nums := range num_arr {
		if test(nums, bit, on) {
			ret = append(ret, nums)
		}
	}
	return ret
}
func NumArrToInt(nums []int) int {
	length := len(nums)
	out := 0
	for i, n := range nums {
		if n == 1 {
			out += int(math.Pow(2, float64(length-1-i)))
		}
	}
	return out
}

func CommonBit(num_arr [][]int, common bool) int {
	length := len(num_arr[0])
	// input_length := len(num_arr)
	filter_by_bit := func(num []int, bit int, on bool) bool {
		return (num[bit] == 1) == on
	}
	// fmt.Println("Start: ", num_arr)
	for i := 0; i < length; i++ {
		count := mostCommonBits(num_arr)
		majority := len(num_arr) / 2
		if len(num_arr)%2 == 1 {
			majority++
		}
		on := count[i] >= majority
		if !common {
			on = !on
		}
		// fmt.Println("Bit:", i, "On:", on, "Len:", len(num_arr)/2, "Count:", count)
		num_arr = filter(num_arr, i, on, filter_by_bit)
		if len(num_arr) <= 1 {
			break
		}
		// fmt.Println("Filtered: ", num_arr)
	}
	return NumArrToInt(num_arr[0])
}

func Part2(input string) [3]int {
	num_arr := StringToArr(input)
	// fmt.Println("Final Filtered: ", num_arr)

	out := [3]int{0, 0, 0}
	out[0] = CommonBit(num_arr, true)
	out[1] = CommonBit(num_arr, false)
	out[2] = out[0] * out[1]

	return out
}
